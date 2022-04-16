Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D8F50331A
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 07:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiDPA2o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 20:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiDPA2m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 20:28:42 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A52F98F51
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 17:26:08 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id s14so8202888plk.8
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 17:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ubzJYUJwW9HwINb2gSexcVZ3lerAsH0CZN+run2TTm0=;
        b=wNM7hYFLrSBn0zWABunUZt6s/8VRCgzKcND3qZ0cCRqxgIp0g3i3uXnfSatEHHa7Gs
         OYfg3u9lCk8bLQ4YbLh+aApQjrAQXXfcemeg2zIaY30exrQnhD8u4LOsRMEsJ3dUoe6J
         04uWGKu/xiP2wj/tivQ7inzVRTI7Cb1W/wu3krN/9RvhbAuuk9d/R87e+4BU/4qH3KSC
         lqeAe97RvDTFj8VOAplSQXc3soWncW6uyrxI/ysH2ZpifE8Bzh5MBs+Sp2yE1mLPETVL
         ExkuwO46hl+ZN6eMlwwkZYsqZnreDzlVKa6pnGYo9UBccXn5OXv0sjJet763oXxpaAUl
         QGEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ubzJYUJwW9HwINb2gSexcVZ3lerAsH0CZN+run2TTm0=;
        b=2N3PI3d55uKFSOrmxZFvyDa3/4y+J0zKg8A96vGKw4dPY0/Z3v8ISuV95dc7A8yNeT
         P7jiR7CYNlTyn3pTdeqzoBu3py88iyGnx2bTZigKLVti+wNXzawubDWuOfLiYpNQ/a1O
         MLHub3ytEsoTnXWq1AxyhkeBXK9WM0hJP/hIOx9SjE0qHh01mOLWk/DdtaFo2bqKKJ2Y
         IUj1xsJ8po9W+Xi62Lu8l1mfZP8kjHt4GX27EllZheECdxZNExA8yzeMzwDHvQ8lvGIa
         TTEk8GuYwRUH8Y8iYJ0HOEVVJVfVzAYgtWV9ze2InZ390KnlyA5s/l+xaoHCKH+EWRYj
         qfTg==
X-Gm-Message-State: AOAM533kAM67zFgaoBhf9Kk5wA64ikhPfScLDRY83OdjvOThTe2TAc0U
        y8BsaxKHaQmwZyrKb+DmdFgEgMXl6X0o2Q==
X-Google-Smtp-Source: ABdhPJwT2MTzdOo26y7up99bFBrA1nqlEqvyLX8LGcP7Dn4/SQKhVfWOmk7ccOz2ft1MlzCZFD/aWw==
X-Received: by 2002:a17:90b:164f:b0:1c7:8d27:91fc with SMTP id il15-20020a17090b164f00b001c78d2791fcmr6823494pjb.228.1650068767162;
        Fri, 15 Apr 2022 17:26:07 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id s20-20020aa78d54000000b004fac74c83b3sm3895375pfe.186.2022.04.15.17.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:26:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: add support for IORING_ASYNC_CANCEL_ALL
Date:   Fri, 15 Apr 2022 18:26:00 -0600
Message-Id: <20220416002601.360026-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220416002601.360026-1-axboe@kernel.dk>
References: <20220416002601.360026-1-axboe@kernel.dk>
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
index 16f8e1f7dcae..79601a333903 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -401,6 +401,7 @@ struct io_ring_ctx {
 		struct xarray		personalities;
 		u32			pers_next;
 		unsigned		sq_thread_idle;
+		atomic_t		cancel_seq;
 	} ____cacheline_aligned_in_smp;
 
 	/* IRQ completion list, under ->completion_lock */
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
@@ -1694,6 +1698,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 
 	req->work.list.next = NULL;
 	req->work.flags = 0;
+	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
 	if (req->flags & REQ_F_FORCE_ASYNC)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
@@ -6149,6 +6154,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	int v;
 
 	INIT_HLIST_NODE(&req->hash_node);
+	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
 	io_init_poll_iocb(poll, mask, io_poll_wake);
 	poll->file = req->file;
 
@@ -6306,6 +6312,11 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
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
@@ -6491,9 +6502,15 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
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
@@ -6766,7 +6783,16 @@ static bool io_cancel_cb(struct io_wq_work *work, void *data)
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
@@ -6778,7 +6804,8 @@ static int io_async_cancel_one(struct io_uring_task *tctx,
 	if (!tctx || !tctx->io_wq)
 		return -ENOENT;
 
-	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, cd, false);
+	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, cd,
+					cd->flags & IORING_ASYNC_CANCEL_ALL);
 	switch (cancel_ret) {
 	case IO_WQ_CANCEL_OK:
 		ret = 0;
@@ -6829,27 +6856,33 @@ static int io_async_cancel_prep(struct io_kiocb *req,
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
@@ -6857,12 +6890,28 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
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

