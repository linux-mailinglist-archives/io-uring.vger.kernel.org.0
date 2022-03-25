Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3DAD4E7275
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 12:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245475AbiCYLzC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 07:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357465AbiCYLy7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 07:54:59 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911BDBC21
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 04:53:25 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id lr4so6425077ejb.11
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 04:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KuH+Sz/xqqHE/RuYxUfZMen10ADA3ceRhqcVMOI/0lM=;
        b=S1TZ8cniP8YTu64vCraYybr754xo0aTiIcxmIaXINfxjNPQ8cjx2cSshnJT26rnice
         +3QKAfJLoo4s5I8Os93HvbWdxYDPC+BFIu2A+uVcHJMh23mSyOPHxyzF+JH9TshvfiY6
         Exti5rznUjZc9Sg9yYInV1YY4sk0SmdOy2awxbhQYCRVXtZMSkVeziBm1Wc7uTNI7Y8S
         BZ6nLNsDw9AhA5V0+3xDMZVCgSB4MMcppJD6F9WgaCz7xk379dEow23+DzM0BzO7kLKQ
         FvT+HgFBTawvEhw8ad+88VRVhrL5lqM8ZKEnM4aigmpMDyoN11SFPJfejmlLZCYQLfM3
         iTSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KuH+Sz/xqqHE/RuYxUfZMen10ADA3ceRhqcVMOI/0lM=;
        b=3lQEtXMQUrsveORTVCw4CNxXBQjXTHIsmo27pPm0quOWW8VVAh5Oy2yqAHGlMvOmEd
         NHabwEE0mwsIUTwJT4fPDpq1BrSxDR+jDVWOK5rgnHddIZj/RQ4tIUsi/VdYLx6l0cyj
         akGlIKCKKkRCi4jewKt+cYxbjLD64QbqUp3XPQOc723dtcqqpiVhjlHYr8l8t+px2heS
         hJ6HOLtJe1bS5fhs2Fvok7Uhkm6tGHkilxLuFwu4Y0A165sC3iUQfWg/lBCjlbq33nIF
         mgVV6zAGmtY5wBQAC3Ryq8F2NpsOHgSOKD4bLGNUqGNeWknW2uK6n+rcOymy8x8nQvQ1
         p20w==
X-Gm-Message-State: AOAM530fgnOnpgb8YlZY2CZCH+f0Rs1Tr10vTrl9gFaJ5dw+TqYIEVRa
        Qkgmwbfft10sLiaI5xcASg476sjFqaZvQQ==
X-Google-Smtp-Source: ABdhPJxOnkuP6FqXimoiJUpW2/WyhfdYMxYOB0UjuUyHZLYB3s96kyvPTik2PRLDkXRnLwSAFOmFfw==
X-Received: by 2002:a17:906:7307:b0:6da:92db:c78f with SMTP id di7-20020a170906730700b006da92dbc78fmr11125797ejc.35.1648209203646;
        Fri, 25 Mar 2022 04:53:23 -0700 (PDT)
Received: from 127.0.0.1localhost ([78.179.227.119])
        by smtp.gmail.com with ESMTPSA id u4-20020aa7db84000000b004136c2c357csm2706777edt.70.2022.03.25.04.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 04:53:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/5] io_uring: cleanup conditional submit locking
Date:   Fri, 25 Mar 2022 11:52:14 +0000
Message-Id: <e55c2c06767676a801252e8094c9ab09912487a4.1648209006.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648209006.git.asml.silence@gmail.com>
References: <cover.1648209006.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Refactor io_ring_submit_[un]lock(), make it accept issue_flags and
remove manual IO_URING_F_UNLOCKED checks. It also allows us to place
lockdep annotations inside instead of sprinkling them in a bunch of
places. There is only one user that doesn't fit now, so hand code
locking in __io_rsrc_put_work().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 95 ++++++++++++++++++++++-----------------------------
 1 file changed, 41 insertions(+), 54 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bb40c80fd9ca..3e6f334ba520 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1213,6 +1213,26 @@ struct sock *io_uring_get_socket(struct file *file)
 }
 EXPORT_SYMBOL(io_uring_get_socket);
 
+static void io_ring_submit_unlock(struct io_ring_ctx *ctx, unsigned issue_flags)
+{
+	lockdep_assert_held(&ctx->uring_lock);
+	if (issue_flags & IO_URING_F_UNLOCKED)
+		mutex_unlock(&ctx->uring_lock);
+}
+
+static void io_ring_submit_lock(struct io_ring_ctx *ctx, unsigned issue_flags)
+{
+	/*
+	 * "Normal" inline submissions always hold the uring_lock, since we
+	 * grab it from the system call. Same is true for the SQPOLL offload.
+	 * The only exception is when we've detached the request and issue it
+	 * from an async worker thread, grab the lock for that case.
+	 */
+	if (issue_flags & IO_URING_F_UNLOCKED)
+		mutex_lock(&ctx->uring_lock);
+	lockdep_assert_held(&ctx->uring_lock);
+}
+
 static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
 {
 	if (!*locked) {
@@ -1399,10 +1419,7 @@ static void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	if (req->flags & REQ_F_PARTIAL_IO)
 		return;
 
-	if (issue_flags & IO_URING_F_UNLOCKED)
-		mutex_lock(&ctx->uring_lock);
-
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_submit_lock(ctx, issue_flags);
 
 	buf = req->kbuf;
 	bl = io_buffer_get_list(ctx, buf->bgid);
@@ -1410,8 +1427,7 @@ static void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
 	req->kbuf = NULL;
 
-	if (issue_flags & IO_URING_F_UNLOCKED)
-		mutex_unlock(&ctx->uring_lock);
+	io_ring_submit_unlock(ctx, issue_flags);
 }
 
 static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
@@ -3371,24 +3387,6 @@ static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 	return __io_import_fixed(req, rw, iter, imu);
 }
 
-static void io_ring_submit_unlock(struct io_ring_ctx *ctx, bool needs_lock)
-{
-	if (needs_lock)
-		mutex_unlock(&ctx->uring_lock);
-}
-
-static void io_ring_submit_lock(struct io_ring_ctx *ctx, bool needs_lock)
-{
-	/*
-	 * "Normal" inline submissions always hold the uring_lock, since we
-	 * grab it from the system call. Same is true for the SQPOLL offload.
-	 * The only exception is when we've detached the request and issue it
-	 * from an async worker thread, grab the lock for that case.
-	 */
-	if (needs_lock)
-		mutex_lock(&ctx->uring_lock);
-}
-
 static void io_buffer_add_list(struct io_ring_ctx *ctx,
 			       struct io_buffer_list *bl, unsigned int bgid)
 {
@@ -3404,16 +3402,13 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 					  int bgid, unsigned int issue_flags)
 {
 	struct io_buffer *kbuf = req->kbuf;
-	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		return kbuf;
 
-	io_ring_submit_lock(ctx, needs_lock);
-
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_submit_lock(req->ctx, issue_flags);
 
 	bl = io_buffer_get_list(ctx, bgid);
 	if (bl && !list_empty(&bl->buf_list)) {
@@ -3427,7 +3422,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 		kbuf = ERR_PTR(-ENOBUFS);
 	}
 
-	io_ring_submit_unlock(req->ctx, needs_lock);
+	io_ring_submit_unlock(req->ctx, issue_flags);
 	return kbuf;
 }
 
@@ -4746,11 +4741,8 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 	int ret = 0;
-	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 
-	io_ring_submit_lock(ctx, needs_lock);
-
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_submit_lock(ctx, issue_flags);
 
 	ret = -ENOENT;
 	bl = io_buffer_get_list(ctx, p->bgid);
@@ -4761,7 +4753,7 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	/* complete before unlock, IOPOLL may need the lock */
 	__io_req_complete(req, issue_flags, ret, 0);
-	io_ring_submit_unlock(ctx, needs_lock);
+	io_ring_submit_unlock(ctx, issue_flags);
 	return 0;
 }
 
@@ -4875,11 +4867,8 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 	int ret = 0;
-	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
-
-	io_ring_submit_lock(ctx, needs_lock);
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_submit_lock(ctx, issue_flags);
 
 	bl = io_buffer_get_list(ctx, p->bgid);
 	if (unlikely(!bl)) {
@@ -4897,7 +4886,7 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	/* complete before unlock, IOPOLL may need the lock */
 	__io_req_complete(req, issue_flags, ret, 0);
-	io_ring_submit_unlock(ctx, needs_lock);
+	io_ring_submit_unlock(ctx, issue_flags);
 	return 0;
 }
 
@@ -6885,7 +6874,6 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	u64 sqe_addr = req->cancel.addr;
-	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 	struct io_tctx_node *node;
 	int ret;
 
@@ -6894,7 +6882,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 		goto done;
 
 	/* slow path, try all io-wq's */
-	io_ring_submit_lock(ctx, needs_lock);
+	io_ring_submit_lock(ctx, issue_flags);
 	ret = -ENOENT;
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		struct io_uring_task *tctx = node->task->io_uring;
@@ -6903,7 +6891,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret != -ENOENT)
 			break;
 	}
-	io_ring_submit_unlock(ctx, needs_lock);
+	io_ring_submit_unlock(ctx, issue_flags);
 done:
 	if (ret < 0)
 		req_set_fail(req);
@@ -6930,7 +6918,6 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
 static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 	struct io_uring_rsrc_update2 up;
 	int ret;
 
@@ -6940,10 +6927,10 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	up.tags = 0;
 	up.resv = 0;
 
-	io_ring_submit_lock(ctx, needs_lock);
+	io_ring_submit_lock(ctx, issue_flags);
 	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
 					&up, req->rsrc_update.nr_args);
-	io_ring_submit_unlock(ctx, needs_lock);
+	io_ring_submit_unlock(ctx, issue_flags);
 
 	if (ret < 0)
 		req_set_fail(req);
@@ -8949,15 +8936,17 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 		list_del(&prsrc->list);
 
 		if (prsrc->tag) {
-			bool lock_ring = ctx->flags & IORING_SETUP_IOPOLL;
+			if (ctx->flags & IORING_SETUP_IOPOLL)
+				mutex_lock(&ctx->uring_lock);
 
-			io_ring_submit_lock(ctx, lock_ring);
 			spin_lock(&ctx->completion_lock);
 			io_fill_cqe_aux(ctx, prsrc->tag, 0, 0);
 			io_commit_cqring(ctx);
 			spin_unlock(&ctx->completion_lock);
 			io_cqring_ev_posted(ctx);
-			io_ring_submit_unlock(ctx, lock_ring);
+
+			if (ctx->flags & IORING_SETUP_IOPOLL)
+				mutex_unlock(&ctx->uring_lock);
 		}
 
 		rsrc_data->do_put(ctx, prsrc);
@@ -9131,12 +9120,11 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 				 unsigned int issue_flags, u32 slot_index)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 	bool needs_switch = false;
 	struct io_fixed_file *file_slot;
 	int ret = -EBADF;
 
-	io_ring_submit_lock(ctx, needs_lock);
+	io_ring_submit_lock(ctx, issue_flags);
 	if (file->f_op == &io_uring_fops)
 		goto err;
 	ret = -ENXIO;
@@ -9177,7 +9165,7 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 err:
 	if (needs_switch)
 		io_rsrc_node_switch(ctx, ctx->file_data);
-	io_ring_submit_unlock(ctx, needs_lock);
+	io_ring_submit_unlock(ctx, issue_flags);
 	if (ret)
 		fput(file);
 	return ret;
@@ -9187,12 +9175,11 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 {
 	unsigned int offset = req->close.file_slot - 1;
 	struct io_ring_ctx *ctx = req->ctx;
-	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 	struct io_fixed_file *file_slot;
 	struct file *file;
 	int ret, i;
 
-	io_ring_submit_lock(ctx, needs_lock);
+	io_ring_submit_lock(ctx, issue_flags);
 	ret = -ENXIO;
 	if (unlikely(!ctx->file_data))
 		goto out;
@@ -9218,7 +9205,7 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	io_rsrc_node_switch(ctx, ctx->file_data);
 	ret = 0;
 out:
-	io_ring_submit_unlock(ctx, needs_lock);
+	io_ring_submit_unlock(ctx, issue_flags);
 	return ret;
 }
 
-- 
2.35.1

