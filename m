Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F7B1E5B9A
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2020 11:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgE1JQM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 05:16:12 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:52375 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728129AbgE1JQL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 05:16:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Tzt718k_1590657361;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Tzt718k_1590657361)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 May 2020 17:16:08 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH v3 1/2] io_uring: avoid whole io_wq_work copy for requests completed inline
Date:   Thu, 28 May 2020 17:15:49 +0800
Message-Id: <20200528091550.3169-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If requests can be submitted and completed inline, we don't need to
initialize whole io_wq_work in io_init_req(), which is an expensive
operation, add a new 'REQ_F_WORK_INITIALIZED' to control whether
io_wq_work is initialized.

I use /dev/nullb0 to evaluate performance improvement in my physical
machine:
  modprobe null_blk nr_devices=1 completion_nsec=0
  sudo taskset -c 60 fio  -name=fiotest -filename=/dev/nullb0 -iodepth=128
  -thread -rw=read -ioengine=io_uring -direct=1 -bs=4k -size=100G -numjobs=1
  -time_based -runtime=120

before this patch:
Run status group 0 (all jobs):
   READ: bw=724MiB/s (759MB/s), 724MiB/s-724MiB/s (759MB/s-759MB/s),
   io=84.8GiB (91.1GB), run=120001-120001msec

With this patch:
Run status group 0 (all jobs):
   READ: bw=761MiB/s (798MB/s), 761MiB/s-761MiB/s (798MB/s-798MB/s),
   io=89.2GiB (95.8GB), run=120001-120001msec

About 5% improvement.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io-wq.h    |  5 ----
 fs/io_uring.c | 78 ++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 62 insertions(+), 21 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 5ba12de7572f..3d85d365d764 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -94,11 +94,6 @@ struct io_wq_work {
 	pid_t task_pid;
 };
 
-#define INIT_IO_WORK(work, _func)				\
-	do {							\
-		*(work) = (struct io_wq_work){ .func = _func };	\
-	} while (0)						\
-
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
 {
 	if (!work->list.next)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2af87f73848e..7ba8590a45a6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -535,6 +535,7 @@ enum {
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
+	REQ_F_WORK_INITIALIZED_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -590,6 +591,8 @@ enum {
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
 	/* doesn't need file table for this request */
 	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
+	/* io_wq_work is initialized */
+	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
 };
 
 struct async_poll {
@@ -635,6 +638,7 @@ struct io_kiocb {
 	unsigned int		flags;
 	refcount_t		refs;
 	struct task_struct	*task;
+	const struct cred	*creds;
 	unsigned long		fsize;
 	u64			user_data;
 	u32			result;
@@ -882,6 +886,12 @@ static struct kmem_cache *req_cachep;
 
 static const struct file_operations io_uring_fops;
 
+static inline void init_io_work(struct io_kiocb *req,
+			void (*func)(struct io_wq_work **))
+{
+	req->work = (struct io_wq_work){ .func = func };
+	req->flags |= REQ_F_WORK_INITIALIZED;
+}
 struct sock *io_uring_get_socket(struct file *file)
 {
 #if defined(CONFIG_UNIX)
@@ -1035,8 +1045,15 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 		mmgrab(current->mm);
 		req->work.mm = current->mm;
 	}
-	if (!req->work.creds)
-		req->work.creds = get_current_cred();
+
+	if (!req->work.creds) {
+		if (!req->creds)
+			req->work.creds = get_current_cred();
+		else {
+			req->work.creds = req->creds;
+			req->creds = NULL;
+		}
+	}
 	if (!req->work.fs && def->needs_fs) {
 		spin_lock(&current->fs->lock);
 		if (!current->fs->in_exec) {
@@ -1053,6 +1070,9 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 
 static inline void io_req_work_drop_env(struct io_kiocb *req)
 {
+	if (!(req->flags & REQ_F_WORK_INITIALIZED))
+		return;
+
 	if (req->work.mm) {
 		mmdrop(req->work.mm);
 		req->work.mm = NULL;
@@ -2923,7 +2943,10 @@ static int io_fsync(struct io_kiocb *req, bool force_nonblock)
 {
 	/* fsync always requires a blocking context */
 	if (force_nonblock) {
-		req->work.func = io_fsync_finish;
+		if (!(req->flags & REQ_F_WORK_INITIALIZED))
+			init_io_work(req, io_fsync_finish);
+		else
+			req->work.func = io_fsync_finish;
 		return -EAGAIN;
 	}
 	__io_fsync(req);
@@ -2971,7 +2994,10 @@ static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
 {
 	/* fallocate always requiring blocking context */
 	if (force_nonblock) {
-		req->work.func = io_fallocate_finish;
+		if (!(req->flags & REQ_F_WORK_INITIALIZED))
+			init_io_work(req, io_fallocate_finish);
+		else
+			req->work.func = io_fallocate_finish;
 		return -EAGAIN;
 	}
 
@@ -3500,7 +3526,10 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 		/* submission ref will be dropped, take it for async */
 		refcount_inc(&req->refs);
 
-		req->work.func = io_close_finish;
+		if (!(req->flags & REQ_F_WORK_INITIALIZED))
+			init_io_work(req, io_close_finish);
+		else
+			req->work.func = io_close_finish;
 		/*
 		 * Do manual async queue here to avoid grabbing files - we don't
 		 * need the files, and it'll cause io_close_finish() to close
@@ -3563,7 +3592,10 @@ static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
 {
 	/* sync_file_range always requires a blocking context */
 	if (force_nonblock) {
-		req->work.func = io_sync_file_range_finish;
+		if (!(req->flags & REQ_F_WORK_INITIALIZED))
+			init_io_work(req, io_sync_file_range_finish);
+		else
+			req->work.func = io_sync_file_range_finish;
 		return -EAGAIN;
 	}
 
@@ -4032,7 +4064,10 @@ static int io_accept(struct io_kiocb *req, bool force_nonblock)
 
 	ret = __io_accept(req, force_nonblock);
 	if (ret == -EAGAIN && force_nonblock) {
-		req->work.func = io_accept_finish;
+		if (!(req->flags & REQ_F_WORK_INITIALIZED))
+			init_io_work(req, io_accept_finish);
+		else
+			req->work.func = io_accept_finish;
 		return -EAGAIN;
 	}
 	return 0;
@@ -5032,6 +5067,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	if (!sqe)
 		return 0;
 
+	if (!(req->flags & REQ_F_WORK_INITIALIZED))
+		init_io_work(req, io_wq_submit_work);
+
 	if (io_op_defs[req->opcode].file_table) {
 		ret = io_grab_files(req);
 		if (unlikely(ret))
@@ -5667,19 +5705,24 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_kiocb *linked_timeout;
 	struct io_kiocb *nxt;
-	const struct cred *old_creds = NULL;
+	const struct cred *creds, *old_creds = NULL;
 	int ret;
 
 again:
 	linked_timeout = io_prep_linked_timeout(req);
 
-	if (req->work.creds && req->work.creds != current_cred()) {
+	if (req->flags & REQ_F_WORK_INITIALIZED)
+		creds = req->work.creds;
+	else
+		creds = req->creds;
+
+	if (creds && creds != current_cred()) {
 		if (old_creds)
 			revert_creds(old_creds);
-		if (old_creds == req->work.creds)
+		if (old_creds == creds)
 			old_creds = NULL; /* restored original creds */
 		else
-			old_creds = override_creds(req->work.creds);
+			old_creds = override_creds(creds);
 	}
 
 	ret = io_issue_sqe(req, sqe, true);
@@ -5696,6 +5739,9 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			goto exit;
 		}
 punt:
+		if (!(req->flags & REQ_F_WORK_INITIALIZED))
+			init_io_work(req, io_wq_submit_work);
+
 		if (io_op_defs[req->opcode].file_table) {
 			ret = io_grab_files(req);
 			if (ret)
@@ -5948,7 +5994,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	refcount_set(&req->refs, 2);
 	req->task = NULL;
 	req->result = 0;
-	INIT_IO_WORK(&req->work, io_wq_submit_work);
 
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
@@ -5970,11 +6015,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	id = READ_ONCE(sqe->personality);
 	if (id) {
-		req->work.creds = idr_find(&ctx->personality_idr, id);
-		if (unlikely(!req->work.creds))
+		req->creds = idr_find(&ctx->personality_idr, id);
+		if (unlikely(!req->creds))
 			return -EINVAL;
-		get_cred(req->work.creds);
-	}
+		get_cred(req->creds);
+	} else
+		req->creds = NULL;
 
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags |= sqe_flags;
-- 
2.17.2

