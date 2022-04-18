Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6703F505C95
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 18:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346358AbiDRQqs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 12:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237766AbiDRQqs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 12:46:48 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD62D326FF
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 09:44:08 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id r17so2857347iln.9
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 09:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ARXZoX5O3WzBQ0GBSsIIabihuBAw0DIjgcVPd0iCJ5c=;
        b=cBN8HtAA96/EhN+YchRdM1QKPZ/rKMB06EzkHX4gbflAqr0rwb9hM5vbLRDb7s13Jg
         6miObSEBiHa2S7gwewaDVRYKakVX7MyVS1J9NA+OAZ5cq2cT1wYJwGPtHkoulG6oTpK/
         yUO8UtJPSxsBYzSX0Fkb8C8Dq3JGdnd1honKhxVnhLVOYEbrIS00E4MJlGjr6iHSme6q
         ZBC+OZNrkSkU2o9apQx7SYS+wi9/NUhXUkVCgn+wLS18KqGC49fy328hpKktPeMo30ow
         5PGzQOUAs6tWffRu6rQfChNS/rOqRPtfDMGigwDKNGymra6kXUtV65RFmvrNbdn6sXoE
         eRxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ARXZoX5O3WzBQ0GBSsIIabihuBAw0DIjgcVPd0iCJ5c=;
        b=yum6/tIYw+0ybMlTm1Lgs+WrumS3jfG23aS6c8eY6rB6/8S4SyQm4zAGLVrLGH2cHQ
         Kr88BaIXXoX2UDRUaRaE/m4cY1F9VmqgAKEm5hE1b2Y6oJ5cYuj/63Mg7zh66VppfBDK
         CjzXrN5JbjFfKWk29LNkAUmB3rGTDIB9jsZtFprY/UmfRb6xCyfQx2g7O2iDK3nNv7N+
         w+yIA/clUeik9RZYMSD3W+HeE7Mqh7O7SV0BSBAq+Jk/52fOUGYMLPTEZiSa45gC/eFd
         R4jaP4nyP8zm03rT1z4dKkJ7krMwYhwErqjWIcIIt9KWOy2ulsuwpCxv1/jffcWg+LQU
         4efQ==
X-Gm-Message-State: AOAM532rKHGsmcOHrQBrojSPvUMPgRyJT8Y3lyhcSvQpFuWBHSBCTcD+
        3HTKH4bIPCfGqpsI765ol556hBrgOz/AQQ==
X-Google-Smtp-Source: ABdhPJycdPvE2X7uUS876FA9LKtRRDJoojikuNMoEImsAt4XJCb7NCcwnulM439LF4xoP0gLNZbJ6A==
X-Received: by 2002:a92:cac6:0:b0:2ca:abd2:e6c1 with SMTP id m6-20020a92cac6000000b002caabd2e6c1mr4735991ilq.314.1650300247890;
        Mon, 18 Apr 2022 09:44:07 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y19-20020a056e020f5300b002cc33e5997dsm1188926ilj.63.2022.04.18.09.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 09:44:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring: add support for IORING_ASYNC_CANCEL_ALL
Date:   Mon, 18 Apr 2022 10:44:00 -0600
Message-Id: <20220418164402.75259-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220418164402.75259-1-axboe@kernel.dk>
References: <20220418164402.75259-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The current cancelation will lookup and cancel the first request it
finds based on the key passed in. Add a flag that allows to cancel any
request that matches they key. It completes with the number of requests
found and canceled, or res < 0 if an error occured.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.h                    |  1 +
 fs/io_uring.c                 | 91 +++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h |  7 +++
 3 files changed, 78 insertions(+), 21 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index dbecd27656c7..ba6eee76d028 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -155,6 +155,7 @@ struct io_wq_work_node *wq_stack_extract(struct io_wq_work_node *stack)
 struct io_wq_work {
 	struct io_wq_work_node list;
 	unsigned flags;
+	int cancel_seq;
 };
 
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index eab464e0c323..c6c00c22940a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -386,6 +386,7 @@ struct io_ring_ctx {
 		 */
 		struct io_rsrc_node	*rsrc_node;
 		int			rsrc_cached_refs;
+		atomic_t		cancel_seq;
 		struct io_file_table	file_table;
 		unsigned		nr_user_files;
 		unsigned		nr_user_bufs;
@@ -568,6 +569,7 @@ struct io_sync {
 struct io_cancel {
 	struct file			*file;
 	u64				addr;
+	u32				flags;
 };
 
 struct io_timeout {
@@ -974,6 +976,8 @@ struct io_defer_entry {
 struct io_cancel_data {
 	struct io_ring_ctx *ctx;
 	u64 data;
+	u32 flags;
+	int seq;
 };
 
 struct io_op_def {
@@ -1703,6 +1707,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 
 	req->work.list.next = NULL;
 	req->work.flags = 0;
+	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
 	if (req->flags & REQ_F_FORCE_ASYNC)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
@@ -6115,6 +6120,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	int v;
 
 	INIT_HLIST_NODE(&req->hash_node);
+	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
 	io_init_poll_iocb(poll, mask, io_poll_wake);
 	poll->file = req->file;
 
@@ -6272,6 +6278,11 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 			continue;
 		if (poll_only && req->opcode != IORING_OP_POLL_ADD)
 			continue;
+		if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
+			if (cd->seq == req->work.cancel_seq)
+				continue;
+			req->work.cancel_seq = cd->seq;
+		}
 		return req;
 	}
 	return NULL;
@@ -6457,9 +6468,15 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 	bool found = false;
 
 	list_for_each_entry(req, &ctx->timeout_list, timeout.list) {
-		found = cd->data == req->cqe.user_data;
-		if (found)
-			break;
+		if (cd->data != req->cqe.user_data)
+			continue;
+		if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
+			if (cd->seq == req->work.cancel_seq)
+				continue;
+			req->work.cancel_seq = cd->seq;
+		}
+		found = true;
+		break;
 	}
 	if (!found)
 		return ERR_PTR(-ENOENT);
@@ -6732,7 +6749,16 @@ static bool io_cancel_cb(struct io_wq_work *work, void *data)
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_cancel_data *cd = data;
 
-	return req->ctx == cd->ctx && req->cqe.user_data == cd->data;
+	if (req->ctx != cd->ctx)
+		return false;
+	if (req->cqe.user_data != cd->data)
+		return false;
+	if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
+		if (cd->seq == req->work.cancel_seq)
+			return false;
+		req->work.cancel_seq = cd->seq;
+	}
+	return true;
 }
 
 static int io_async_cancel_one(struct io_uring_task *tctx,
@@ -6744,7 +6770,8 @@ static int io_async_cancel_one(struct io_uring_task *tctx,
 	if (!tctx || !tctx->io_wq)
 		return -ENOENT;
 
-	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, cd, false);
+	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, cd,
+					cd->flags & IORING_ASYNC_CANCEL_ALL);
 	switch (cancel_ret) {
 	case IO_WQ_CANCEL_OK:
 		ret = 0;
@@ -6795,27 +6822,33 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags ||
-	    sqe->splice_fd_in)
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->cancel.addr = READ_ONCE(sqe->addr);
+	req->cancel.flags = READ_ONCE(sqe->cancel_flags);
+	if (req->cancel.flags & ~IORING_ASYNC_CANCEL_ALL)
+		return -EINVAL;
+
 	return 0;
 }
 
-static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_async_cancel(struct io_cancel_data *cd, struct io_kiocb *req,
+			     unsigned int issue_flags)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_cancel_data cd = {
-		.ctx		= ctx,
-		.data		= req->cancel.addr,
-	};
+	bool cancel_all = cd->flags & IORING_ASYNC_CANCEL_ALL;
+	struct io_ring_ctx *ctx = cd->ctx;
 	struct io_tctx_node *node;
-	int ret;
+	int ret, nr = 0;
 
-	ret = io_try_cancel(req, &cd);
-	if (ret != -ENOENT)
-		goto done;
+	do {
+		ret = io_try_cancel(req, cd);
+		if (ret == -ENOENT)
+			break;
+		if (!cancel_all)
+			return ret;
+		nr++;
+	} while (1);
 
 	/* slow path, try all io-wq's */
 	io_ring_submit_lock(ctx, issue_flags);
@@ -6823,12 +6856,28 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		struct io_uring_task *tctx = node->task->io_uring;
 
-		ret = io_async_cancel_one(tctx, &cd);
-		if (ret != -ENOENT)
-			break;
+		ret = io_async_cancel_one(tctx, cd);
+		if (ret != -ENOENT) {
+			if (!cancel_all)
+				break;
+			nr++;
+		}
 	}
 	io_ring_submit_unlock(ctx, issue_flags);
-done:
+	return cancel_all ? nr : ret;
+}
+
+static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_cancel_data cd = {
+		.ctx	= req->ctx,
+		.data	= req->cancel.addr,
+		.flags	= req->cancel.flags,
+		.seq	= atomic_inc_return(&req->ctx->cancel_seq),
+	};
+	int ret;
+
+	ret = __io_async_cancel(&cd, req, issue_flags);
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_complete_post(req, ret, 0);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1845cf7c80ba..476e58a2837f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -187,6 +187,13 @@ enum {
 #define IORING_POLL_UPDATE_EVENTS	(1U << 1)
 #define IORING_POLL_UPDATE_USER_DATA	(1U << 2)
 
+/*
+ * ASYNC_CANCEL flags.
+ *
+ * IORING_ASYNC_CANCEL_ALL	Cancel all requests that match the given key
+ */
+#define IORING_ASYNC_CANCEL_ALL	(1U << 0)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.35.1

