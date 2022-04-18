Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A26505C96
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 18:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346362AbiDRQqu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 12:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346360AbiDRQqt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 12:46:49 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F1232987
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 09:44:09 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id r17so2857384iln.9
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 09:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=72qqfoeUnn7bx4nXRMz+lGIKuQcntyP/cU4vs+RzVYQ=;
        b=lCruSLUKdy2uuvpqzEilSdkuJDBpL2okrbdzHVCGEEO8xF4aG5veEQhgdseDIfqu2r
         vXcQLm2kmJRwYXyebMnmlOU5E2nooNayR0qTY7u98ACRZwHhxhKJxa4olPx7RJmudzhV
         W6uClDrSvKNnlafqxuin2eT8Uqva4Du0WzQDikaNWOOMdqzecQKqikAzDVL2EDMm2ZdL
         eC7SQGNqxfK0f34q+ILJpewN9tuiBkpKUtyD/43Y7S7PNNkahE2gpp5dm8arRO/XmIKA
         ozAVXLOKLw0mFRjJbEcndixUCayxET7y9Z0KiueU2mNB7tL99aWLrYfCDPWIbodQ4n41
         0giw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=72qqfoeUnn7bx4nXRMz+lGIKuQcntyP/cU4vs+RzVYQ=;
        b=tvYzlmgonI3TtzbIAiEgJetDr3dIdPF6Vt6wZ0hyHUNW93AcE818dV19U0tTyA6ARg
         MplZPyp3b9Jl/2CDPw0m0Eh2F0IGcgrXfpkYsaPEYAxRzieBPjA4hNcoTXg7Qa39X0+u
         AcQ9NzPVwKgJBAlMvHuOf7mPJiPXU5ZutnWXDo6wu8J5Psqtv4dffphqC4IDfCvo6CYF
         Gbt08XP/oV29+WjIo/skm4dwNxBRTbcy82ONjLiGWpgRBFXOD8eHVbbbtjmq17LFI936
         f6ObsSa+3OWQMs3bJETwDqE/JQ4/SB67TmZ6moZ+k7ISPKY2J3KcukRNsVZdoyU87YxL
         78fQ==
X-Gm-Message-State: AOAM532wW77iaC+N3F4mO9JJbV2Vm9YDDrsi74y9H5rSxmys8wEpYb6r
        3sA6RYl5DZaqElC9/BuA0nTA77v/JsKGcQ==
X-Google-Smtp-Source: ABdhPJyxbKNT6t25puEwyXdcOTNzKcGS8u9rwd3v7h7oaD0T6BnsM/1BINatesr2o5rsLHrptaDsEA==
X-Received: by 2002:a05:6e02:188c:b0:2cb:febf:48f8 with SMTP id o12-20020a056e02188c00b002cbfebf48f8mr5067495ilu.223.1650300249083;
        Mon, 18 Apr 2022 09:44:09 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y19-20020a056e020f5300b002cc33e5997dsm1188926ilj.63.2022.04.18.09.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 09:44:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: allow IORING_OP_ASYNC_CANCEL with 'fd' key
Date:   Mon, 18 Apr 2022 10:44:01 -0600
Message-Id: <20220418164402.75259-5-axboe@kernel.dk>
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

Currently sqe->addr must contain the user_data of the request being
canceled. Introduce the IORING_ASYNC_CANCEL_FD flag, which tells the
kernel that we're keying off the file fd instead for cancelation. This
allows canceling any request that a) uses a file, and b) was assigned the
file based on the value being passed in.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 72 ++++++++++++++++++++++++++++++-----
 include/uapi/linux/io_uring.h |  3 ++
 2 files changed, 66 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c6c00c22940a..70050c94560e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -570,6 +570,7 @@ struct io_cancel {
 	struct file			*file;
 	u64				addr;
 	u32				flags;
+	s32				fd;
 };
 
 struct io_timeout {
@@ -975,7 +976,10 @@ struct io_defer_entry {
 
 struct io_cancel_data {
 	struct io_ring_ctx *ctx;
-	u64 data;
+	union {
+		u64 data;
+		struct file *file;
+	};
 	u32 flags;
 	int seq;
 };
@@ -6288,6 +6292,29 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 	return NULL;
 }
 
+static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
+					  struct io_cancel_data *cd)
+	__must_hold(&ctx->completion_lock)
+{
+	struct io_kiocb *req;
+	int i;
+
+	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
+		struct hlist_head *list;
+
+		list = &ctx->cancel_hash[i];
+		hlist_for_each_entry(req, list, hash_node) {
+			if (req->file != cd->file)
+				continue;
+			if (cd->seq == req->work.cancel_seq)
+				continue;
+			req->work.cancel_seq = cd->seq;
+			return req;
+		}
+	}
+	return NULL;
+}
+
 static bool io_poll_disarm(struct io_kiocb *req)
 	__must_hold(&ctx->completion_lock)
 {
@@ -6301,8 +6328,12 @@ static bool io_poll_disarm(struct io_kiocb *req)
 static int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 	__must_hold(&ctx->completion_lock)
 {
-	struct io_kiocb *req = io_poll_find(ctx, false, cd);
+	struct io_kiocb *req;
 
+	if (cd->flags & IORING_ASYNC_CANCEL_FD)
+		req = io_poll_file_find(ctx, cd);
+	else
+		req = io_poll_find(ctx, false, cd);
 	if (!req)
 		return -ENOENT;
 	io_poll_cancel_req(req);
@@ -6751,8 +6782,13 @@ static bool io_cancel_cb(struct io_wq_work *work, void *data)
 
 	if (req->ctx != cd->ctx)
 		return false;
-	if (req->cqe.user_data != cd->data)
-		return false;
+	if (cd->flags & IORING_ASYNC_CANCEL_FD) {
+		if (req->file != cd->file)
+			return false;
+	} else {
+		if (req->cqe.user_data != cd->data)
+			return false;
+	}
 	if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
 		if (cd->seq == req->work.cancel_seq)
 			return false;
@@ -6807,9 +6843,11 @@ static int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
 	if (ret != -ENOENT)
 		goto out;
 
-	spin_lock_irq(&ctx->timeout_lock);
-	ret = io_timeout_cancel(ctx, cd);
-	spin_unlock_irq(&ctx->timeout_lock);
+	if (!(cd->flags & IORING_ASYNC_CANCEL_FD)) {
+		spin_lock_irq(&ctx->timeout_lock);
+		ret = io_timeout_cancel(ctx, cd);
+		spin_unlock_irq(&ctx->timeout_lock);
+	}
 out:
 	spin_unlock(&ctx->completion_lock);
 	return ret;
@@ -6820,15 +6858,17 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+	if (unlikely(req->flags & REQ_F_BUFFER_SELECT))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->len || sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->cancel.addr = READ_ONCE(sqe->addr);
 	req->cancel.flags = READ_ONCE(sqe->cancel_flags);
-	if (req->cancel.flags & ~IORING_ASYNC_CANCEL_ALL)
+	if (req->cancel.flags & ~(IORING_ASYNC_CANCEL_ALL|IORING_ASYNC_CANCEL_FD))
 		return -EINVAL;
+	if (req->cancel.flags & IORING_ASYNC_CANCEL_FD)
+		req->cancel.fd = READ_ONCE(sqe->fd);
 
 	return 0;
 }
@@ -6877,7 +6917,21 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	};
 	int ret;
 
+	if (cd.flags & IORING_ASYNC_CANCEL_FD) {
+		if (req->flags & REQ_F_FIXED_FILE)
+			req->file = io_file_get_fixed(req, req->cancel.fd,
+							issue_flags);
+		else
+			req->file = io_file_get_normal(req, req->cancel.fd);
+		if (!req->file) {
+			ret = -EBADF;
+			goto done;
+		}
+		cd.file = req->file;
+	}
+
 	ret = __io_async_cancel(&cd, req, issue_flags);
+done:
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_complete_post(req, ret, 0);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 476e58a2837f..cc7fe82a1798 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -191,8 +191,11 @@ enum {
  * ASYNC_CANCEL flags.
  *
  * IORING_ASYNC_CANCEL_ALL	Cancel all requests that match the given key
+ * IORING_ASYNC_CANCEL_FD	Key off 'fd' for cancelation rather than the
+ *				request 'user_data'
  */
 #define IORING_ASYNC_CANCEL_ALL	(1U << 0)
+#define IORING_ASYNC_CANCEL_FD	(1U << 1)
 
 /*
  * IO completion data structure (Completion Queue Entry)
-- 
2.35.1

