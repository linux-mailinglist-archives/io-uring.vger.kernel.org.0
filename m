Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4ADB1E9CD3
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2020 06:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgFAE4i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Jun 2020 00:56:38 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:54004 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725290AbgFAE4i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Jun 2020 00:56:38 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0U-9qG-p_1590987389;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U-9qG-p_1590987389)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Jun 2020 12:56:34 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH v5 1/2] io_uring: avoid whole io_wq_work copy for requests completed inline
Date:   Mon,  1 Jun 2020 12:56:25 +0800
Message-Id: <20200601045626.9291-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <a2184644-34b6-88a2-b022-e8f5e7def071@gmail.com>
References: <a2184644-34b6-88a2-b022-e8f5e7def071@gmail.com>
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
---
 fs/io-wq.h    |  5 ----
 fs/io_uring.c | 83 +++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 67 insertions(+), 21 deletions(-)

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
index 95df63b0b2ce..8e022d0f0c86 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -538,6 +538,7 @@ enum {
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
+	REQ_F_WORK_INITIALIZED_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -593,6 +594,8 @@ enum {
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
 	/* doesn't need file table for this request */
 	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
+	/* io_wq_work is initialized */
+	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
 };
 
 struct async_poll {
@@ -638,6 +641,7 @@ struct io_kiocb {
 	unsigned int		flags;
 	refcount_t		refs;
 	struct task_struct	*task;
+	const struct cred	*creds;
 	unsigned long		fsize;
 	u64			user_data;
 	u32			result;
@@ -900,6 +904,21 @@ EXPORT_SYMBOL(io_uring_get_socket);
 
 static void io_file_put_work(struct work_struct *work);
 
+static inline void io_init_req_work(struct io_kiocb *req)
+{
+	if (req->flags & REQ_F_WORK_INITIALIZED)
+		return;
+
+	memset(&req->work, 0, sizeof(req->work));
+	req->flags |= REQ_F_WORK_INITIALIZED;
+}
+
+static inline void io_init_req_work_func(struct io_kiocb *req,
+			void (*func)(struct io_wq_work **))
+{
+	req->work.func = func;
+}
+
 static inline bool io_async_submit(struct io_ring_ctx *ctx)
 {
 	return ctx->flags & IORING_SETUP_SQPOLL;
@@ -1025,8 +1044,15 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
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
@@ -1043,6 +1069,9 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 
 static inline void io_req_work_drop_env(struct io_kiocb *req)
 {
+	if (!(req->flags & REQ_F_WORK_INITIALIZED))
+		return;
+
 	if (req->work.mm) {
 		mmdrop(req->work.mm);
 		req->work.mm = NULL;
@@ -2895,6 +2924,8 @@ static int __io_splice_prep(struct io_kiocb *req,
 		return ret;
 	req->flags |= REQ_F_NEED_CLEANUP;
 
+	/* Splice will be punted aync, so initialize io_wq_work firstly. */
+	io_init_req_work(req);
 	if (!S_ISREG(file_inode(sp->file_in)->i_mode))
 		req->work.flags |= IO_WQ_WORK_UNBOUND;
 
@@ -3045,7 +3076,8 @@ static int io_fsync(struct io_kiocb *req, bool force_nonblock)
 {
 	/* fsync always requires a blocking context */
 	if (force_nonblock) {
-		req->work.func = io_fsync_finish;
+		io_init_req_work(req);
+		io_init_req_work_func(req, io_fsync_finish);
 		return -EAGAIN;
 	}
 	__io_fsync(req);
@@ -3093,7 +3125,8 @@ static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
 {
 	/* fallocate always requiring blocking context */
 	if (force_nonblock) {
-		req->work.func = io_fallocate_finish;
+		io_init_req_work(req);
+		io_init_req_work_func(req, io_fallocate_finish);
 		return -EAGAIN;
 	}
 
@@ -3567,6 +3600,9 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
 
 static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	 /* Close may be punted aync, so initialize io_wq_work firstly */
+	io_init_req_work(req);
+
 	/*
 	 * If we queue this for async, it must not be cancellable. That would
 	 * leave the 'file' in an undeterminate state.
@@ -3618,7 +3654,8 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 	if (req->close.put_file->f_op->flush && force_nonblock) {
 		/* avoid grabbing files - we don't need the files */
 		req->flags |= REQ_F_NO_FILE_TABLE | REQ_F_MUST_PUNT;
-		req->work.func = io_close_finish;
+		io_init_req_work(req);
+		io_init_req_work_func(req, io_close_finish);
 		return -EAGAIN;
 	}
 
@@ -3675,7 +3712,8 @@ static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
 {
 	/* sync_file_range always requires a blocking context */
 	if (force_nonblock) {
-		req->work.func = io_sync_file_range_finish;
+		io_init_req_work(req);
+		io_init_req_work_func(req, io_sync_file_range_finish);
 		return -EAGAIN;
 	}
 
@@ -4144,7 +4182,8 @@ static int io_accept(struct io_kiocb *req, bool force_nonblock)
 
 	ret = __io_accept(req, force_nonblock);
 	if (ret == -EAGAIN && force_nonblock) {
-		req->work.func = io_accept_finish;
+		io_init_req_work(req);
+		io_init_req_work_func(req, io_accept_finish);
 		return -EAGAIN;
 	}
 	return 0;
@@ -5144,6 +5183,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	if (!sqe)
 		return 0;
 
+	io_init_req_work(req);
+	io_init_req_work_func(req, io_wq_submit_work);
+
 	if (io_op_defs[req->opcode].file_table) {
 		ret = io_grab_files(req);
 		if (unlikely(ret))
@@ -5779,19 +5821,24 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -5808,6 +5855,10 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			goto exit;
 		}
 punt:
+		io_init_req_work(req);
+		if (!req->work.func)
+			io_init_req_work_func(req, io_wq_submit_work);
+
 		if (io_op_defs[req->opcode].file_table) {
 			ret = io_grab_files(req);
 			if (ret)
@@ -6060,7 +6111,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	refcount_set(&req->refs, 2);
 	req->task = NULL;
 	req->result = 0;
-	INIT_IO_WORK(&req->work, io_wq_submit_work);
 
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
@@ -6082,11 +6132,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
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

