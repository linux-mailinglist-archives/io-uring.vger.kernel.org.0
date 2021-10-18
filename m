Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F376B431C27
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 15:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhJRNjO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 09:39:14 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:1163 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232799AbhJRNgt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 09:36:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UsfImXd_1634564071;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UsfImXd_1634564071)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 18 Oct 2021 21:34:37 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2] io_uring: split logic of force_nonblock
Date:   Mon, 18 Oct 2021 21:34:31 +0800
Message-Id: <20211018133431.103298-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently force_nonblock stands for three meanings:
 - nowait or not
 - in an io-worker or not(hold uring_lock or not)

Let's split the logic to two flags, IO_URING_F_NONBLOCK and
IO_URING_F_UNLOCKED for convenience of the next patch.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

v1-->v2
 - remove the incorrect io_worker logic in io_read and io_write (Pavel)
 - add the forgotten case in io_iopoll_req_issued() (Pavel)
 - unify need_lock to needs_lock

 fs/io_uring.c | 48 ++++++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b6da03c26122..b3546eef0289 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -199,6 +199,7 @@ struct io_rings {
 
 enum io_uring_cmd_flags {
 	IO_URING_F_COMPLETE_DEFER	= 1,
+	IO_URING_F_UNLOCKED		= 2,
 	/* int's last bit, sign checks are usually faster than a bit test */
 	IO_URING_F_NONBLOCK		= INT_MIN,
 };
@@ -2703,10 +2704,10 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	const bool need_lock = !(issue_flags & IO_URING_F_NONBLOCK);
+	const bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 
 	/* workqueue context doesn't hold uring_lock, grab it now */
-	if (unlikely(need_lock))
+	if (unlikely(needs_lock))
 		mutex_lock(&ctx->uring_lock);
 
 	/*
@@ -2742,7 +2743,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		wq_list_add_tail(&req->comp_list, &ctx->iopoll_list);
 
-	if (unlikely(need_lock)) {
+	if (unlikely(needs_lock)) {
 		/*
 		 * If IORING_SETUP_SQPOLL is enabled, sqes are either handle
 		 * in sq thread task context or in io worker task context. If
@@ -2926,7 +2927,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 			struct io_ring_ctx *ctx = req->ctx;
 
 			req_set_fail(req);
-			if (!(issue_flags & IO_URING_F_NONBLOCK)) {
+			if (issue_flags & IO_URING_F_UNLOCKED) {
 				mutex_lock(&ctx->uring_lock);
 				__io_req_complete(req, issue_flags, ret, cflags);
 				mutex_unlock(&ctx->uring_lock);
@@ -3036,7 +3037,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 {
 	struct io_buffer *kbuf = req->kbuf;
 	struct io_buffer *head;
-	bool needs_lock = !(issue_flags & IO_URING_F_NONBLOCK);
+	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		return kbuf;
@@ -3341,7 +3342,7 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 	int ret;
 
 	/* submission path, ->uring_lock should already be taken */
-	ret = io_import_iovec(rw, req, &iov, &iorw->s, IO_URING_F_NONBLOCK);
+	ret = io_import_iovec(rw, req, &iov, &iorw->s, 0);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -4314,9 +4315,9 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer *head;
 	int ret = 0;
-	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 
-	io_ring_submit_lock(ctx, !force_nonblock);
+	io_ring_submit_lock(ctx, needs_lock);
 
 	lockdep_assert_held(&ctx->uring_lock);
 
@@ -4329,7 +4330,7 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	/* complete before unlock, IOPOLL may need the lock */
 	__io_req_complete(req, issue_flags, ret, 0);
-	io_ring_submit_unlock(ctx, !force_nonblock);
+	io_ring_submit_unlock(ctx, needs_lock);
 	return 0;
 }
 
@@ -4401,9 +4402,9 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer *head, *list;
 	int ret = 0;
-	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 
-	io_ring_submit_lock(ctx, !force_nonblock);
+	io_ring_submit_lock(ctx, needs_lock);
 
 	lockdep_assert_held(&ctx->uring_lock);
 
@@ -4419,7 +4420,7 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	/* complete before unlock, IOPOLL may need the lock */
 	__io_req_complete(req, issue_flags, ret, 0);
-	io_ring_submit_unlock(ctx, !force_nonblock);
+	io_ring_submit_unlock(ctx, needs_lock);
 	return 0;
 }
 
@@ -6279,6 +6280,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	u64 sqe_addr = req->cancel.addr;
+	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 	struct io_tctx_node *node;
 	int ret;
 
@@ -6287,7 +6289,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 		goto done;
 
 	/* slow path, try all io-wq's */
-	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+	io_ring_submit_lock(ctx, needs_lock);
 	ret = -ENOENT;
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		struct io_uring_task *tctx = node->task->io_uring;
@@ -6296,7 +6298,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret != -ENOENT)
 			break;
 	}
-	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+	io_ring_submit_unlock(ctx, needs_lock);
 done:
 	if (ret < 0)
 		req_set_fail(req);
@@ -6323,6 +6325,7 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
 static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 	struct io_uring_rsrc_update2 up;
 	int ret;
 
@@ -6332,10 +6335,10 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	up.tags = 0;
 	up.resv = 0;
 
-	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+	io_ring_submit_lock(ctx, needs_lock);
 	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
 					&up, req->rsrc_update.nr_args);
-	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+	io_ring_submit_unlock(ctx, needs_lock);
 
 	if (ret < 0)
 		req_set_fail(req);
@@ -6745,7 +6748,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 
 	if (!ret) {
 		do {
-			ret = io_issue_sqe(req, 0);
+			ret = io_issue_sqe(req, IO_URING_F_UNLOCKED);
 			/*
 			 * We can get EAGAIN for polled IO even though we're
 			 * forcing a sync submission from here, since we can't
@@ -8333,12 +8336,12 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 				 unsigned int issue_flags, u32 slot_index)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 	bool needs_switch = false;
 	struct io_fixed_file *file_slot;
 	int ret = -EBADF;
 
-	io_ring_submit_lock(ctx, !force_nonblock);
+	io_ring_submit_lock(ctx, needs_lock);
 	if (file->f_op == &io_uring_fops)
 		goto err;
 	ret = -ENXIO;
@@ -8379,7 +8382,7 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 err:
 	if (needs_switch)
 		io_rsrc_node_switch(ctx, ctx->file_data);
-	io_ring_submit_unlock(ctx, !force_nonblock);
+	io_ring_submit_unlock(ctx, needs_lock);
 	if (ret)
 		fput(file);
 	return ret;
@@ -8389,11 +8392,12 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 {
 	unsigned int offset = req->close.file_slot - 1;
 	struct io_ring_ctx *ctx = req->ctx;
+	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 	struct io_fixed_file *file_slot;
 	struct file *file;
 	int ret, i;
 
-	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+	io_ring_submit_lock(ctx, needs_lock);
 	ret = -ENXIO;
 	if (unlikely(!ctx->file_data))
 		goto out;
@@ -8419,7 +8423,7 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	io_rsrc_node_switch(ctx, ctx->file_data);
 	ret = 0;
 out:
-	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+	io_ring_submit_unlock(ctx, needs_lock);
 	return ret;
 }
 
-- 
2.24.4

