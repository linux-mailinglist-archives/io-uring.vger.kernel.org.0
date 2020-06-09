Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09B31F3610
	for <lists+io-uring@lfdr.de>; Tue,  9 Jun 2020 10:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgFIIZh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Jun 2020 04:25:37 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:40204 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728020AbgFIIZh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Jun 2020 04:25:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0U.3iYrQ_1591691124;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U.3iYrQ_1591691124)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 09 Jun 2020 16:25:34 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH v6 1/2] io_uring: avoid whole io_wq_work copy for requests completed inline
Date:   Tue,  9 Jun 2020 16:25:11 +0800
Message-Id: <20200609082512.19053-1-xiaoguang.wang@linux.alibaba.com>
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
V4:
  add io_req_init_async() helper

V5:
  refactor io_req_init_async() to io_init_req_work() and io_init_req_work_func
  in case we need to change io_wq_work.func separately.

V6:
  Drop the refactor work in V5, and rebase to io_uring-5.8.
---
 fs/io-wq.h    |  5 ----
 fs/io_uring.c | 63 +++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 51 insertions(+), 17 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 2db24d31fbc5..8e138fa88b9f 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -93,11 +93,6 @@ struct io_wq_work {
 	pid_t task_pid;
 };
 
-#define INIT_IO_WORK(work)					\
-	do {							\
-		*(work) = (struct io_wq_work){};		\
-	} while (0)						\
-
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
 {
 	if (!work->list.next)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3ffe03194c1e..bde8b17a7275 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -542,6 +542,7 @@ enum {
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
 	REQ_F_QUEUE_TIMEOUT_BIT,
+	REQ_F_WORK_INITIALIZED_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -599,6 +600,8 @@ enum {
 	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
 	/* needs to queue linked timeout */
 	REQ_F_QUEUE_TIMEOUT	= BIT(REQ_F_QUEUE_TIMEOUT_BIT),
+	/* io_wq_work is initialized */
+	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
 };
 
 struct async_poll {
@@ -645,6 +648,7 @@ struct io_kiocb {
 	unsigned int		flags;
 	refcount_t		refs;
 	struct task_struct	*task;
+	const struct cred	*creds;
 	unsigned long		fsize;
 	u64			user_data;
 	u32			result;
@@ -911,6 +915,15 @@ EXPORT_SYMBOL(io_uring_get_socket);
 
 static void io_file_put_work(struct work_struct *work);
 
+static inline void io_req_init_async(struct io_kiocb *req)
+{
+	if (req->flags & REQ_F_WORK_INITIALIZED)
+		return;
+
+	memset(&req->work, 0, sizeof(req->work));
+	req->flags |= REQ_F_WORK_INITIALIZED;
+}
+
 static inline bool io_async_submit(struct io_ring_ctx *ctx)
 {
 	return ctx->flags & IORING_SETUP_SQPOLL;
@@ -1019,8 +1032,14 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 		mmgrab(current->mm);
 		req->work.mm = current->mm;
 	}
-	if (!req->work.creds)
-		req->work.creds = get_current_cred();
+	if (!req->work.creds) {
+		if (!req->creds) {
+			req->work.creds = get_current_cred();
+		} else {
+			req->work.creds = req->creds;
+			req->creds = NULL;
+		}
+	}
 	if (!req->work.fs && def->needs_fs) {
 		spin_lock(&current->fs->lock);
 		if (!current->fs->in_exec) {
@@ -1037,6 +1056,9 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 
 static inline void io_req_work_drop_env(struct io_kiocb *req)
 {
+	if (!(req->flags & REQ_F_WORK_INITIALIZED))
+		return;
+
 	if (req->work.mm) {
 		mmdrop(req->work.mm);
 		req->work.mm = NULL;
@@ -2781,8 +2803,14 @@ static int __io_splice_prep(struct io_kiocb *req,
 		return ret;
 	req->flags |= REQ_F_NEED_CLEANUP;
 
-	if (!S_ISREG(file_inode(sp->file_in)->i_mode))
+	if (!S_ISREG(file_inode(sp->file_in)->i_mode)) {
+		/*
+		 * Splice operation will be punted aync, and here need to
+		 * modify io_wq_work.flags, so initialize io_wq_work firstly.
+		 */
+		io_req_init_async(req);
 		req->work.flags |= IO_WQ_WORK_UNBOUND;
+	}
 
 	return 0;
 }
@@ -3368,8 +3396,10 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	/*
 	 * If we queue this for async, it must not be cancellable. That would
-	 * leave the 'file' in an undeterminate state.
+	 * leave the 'file' in an undeterminate state, and here need to modify
+	 * io_wq_work.flags, so initialize io_wq_work firstly.
 	 */
+	io_req_init_async(req);
 	req->work.flags |= IO_WQ_WORK_NO_CANCEL;
 
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
@@ -4847,6 +4877,8 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	if (!sqe)
 		return 0;
 
+	io_req_init_async(req);
+
 	if (io_op_defs[req->opcode].file_table) {
 		ret = io_grab_files(req);
 		if (unlikely(ret))
@@ -5495,19 +5527,23 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -5524,6 +5560,8 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			goto exit;
 		}
 punt:
+		io_req_init_async(req);
+
 		if (io_op_defs[req->opcode].file_table) {
 			ret = io_grab_files(req);
 			if (ret)
@@ -5776,7 +5814,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	refcount_set(&req->refs, 2);
 	req->task = NULL;
 	req->result = 0;
-	INIT_IO_WORK(&req->work);
 
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
@@ -5798,10 +5835,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	id = READ_ONCE(sqe->personality);
 	if (id) {
-		req->work.creds = idr_find(&ctx->personality_idr, id);
-		if (unlikely(!req->work.creds))
+		req->creds = idr_find(&ctx->personality_idr, id);
+		if (unlikely(!req->creds))
 			return -EINVAL;
-		get_cred(req->work.creds);
+		get_cred(req->creds);
+	} else {
+		req->creds = NULL;
 	}
 
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
-- 
2.17.2

