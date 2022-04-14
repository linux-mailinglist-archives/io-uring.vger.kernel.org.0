Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EFE501C9C
	for <lists+io-uring@lfdr.de>; Thu, 14 Apr 2022 22:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346281AbiDNU0z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Apr 2022 16:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346285AbiDNU0y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Apr 2022 16:26:54 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8805FB6
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 13:24:27 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id h23-20020a17090a051700b001c9c1dd3acbso6742601pjh.3
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 13:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QPBvtRCvamAB8BSsgKOEH2wzayNXttUPbFGH4r4CQRA=;
        b=Qv+UMM/GTf4fhLFcy7uiep9zh4nQykRKKpfGpgR1dHvESOtdHva5K4vLSKGad5ykzF
         2/0S4eYCP0UvVdchuoIDMd2iQEcsb+E72fj6xtawXugcztjG86txUpmwyPtdfi3RW2hZ
         HE8e4sC+P2/TTg7T6ynrQGfQvKjNAAkbFbvm83Fj9lq9ipTdGAHNs1JhIYpwlkHg0uDc
         +ciZhMJEEXvblZ65AMaQ9tGXYvCAfJJUo2w2weKtEaR/JCwA1TUtKTz8GsDjzcbk9Xto
         ea7DU0byta5evSwo6m/ObRMEE4XGu4KFk4zQnmDIwcB0hXC1b2luxly0IOBo7N8nkd0z
         FRBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QPBvtRCvamAB8BSsgKOEH2wzayNXttUPbFGH4r4CQRA=;
        b=TWyU7po6G7DTASZePeVBggGCxlAaIh04DUDOYsnM8tKR0/heqv7RDEvIQRfVq4QJ7R
         NL3xwII9pGGAxbPd61tePez1X7NByqa7Yf+++syk1gzgUqiBuye7WvcTBIABXUjfJEgZ
         7Q/Kj49jp8Zakok/M1KyAoUaR2HM5yqxKEIpCb4lRP2UEDXCj7z7uCUyOauwk+L5VJbD
         ccJ1gTWg4gAyMHKaXUlg4ftQ62HDaJIsOu7hkAl8wz0uoQl/k3YzqS2a+m5bOVi0SfT+
         +mHqrNmV0Nf+OhZqm8E5FH4OffJKpb1brKDKmnQaURSuFMae70uWs3jOE3jrwpXNitUf
         hxvw==
X-Gm-Message-State: AOAM533KQbjMUHhqx5heaMddm6tXagEvHnS82n7VTJtk9XgVwkFEXEst
        DRMwWW5EzbCb3xcGclIcu9hrkrX3VM1xMA==
X-Google-Smtp-Source: ABdhPJyKJRei/p41UdRTsIa9DpHdJgYghFcFhzcWljDuouJTsxkYe4WXZhF11eydUixy9Xg6n2BywQ==
X-Received: by 2002:a17:902:748c:b0:158:3461:ac75 with SMTP id h12-20020a170902748c00b001583461ac75mr28093795pll.114.1649967866078;
        Thu, 14 Apr 2022 13:24:26 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id v16-20020a62a510000000b0050759c9a891sm689365pfm.6.2022.04.14.13.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 13:24:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: allow IORING_OP_ASYNC_CANCEL with 'fd' key
Date:   Thu, 14 Apr 2022 14:24:19 -0600
Message-Id: <20220414202419.201614-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220414202419.201614-1-axboe@kernel.dk>
References: <20220414202419.201614-1-axboe@kernel.dk>
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
 fs/io_uring.c                 | 58 +++++++++++++++++++++++++++++------
 include/uapi/linux/io_uring.h |  8 +++++
 2 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0ef8401b6552..c86a92a975b7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -567,7 +567,8 @@ struct io_sync {
 
 struct io_cancel {
 	struct file			*file;
-	u64				addr;
+	u64				data;
+	u32				flags;
 };
 
 struct io_timeout {
@@ -6306,6 +6307,25 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr,
 	return NULL;
 }
 
+static struct io_kiocb *io_poll_fd_find(struct io_ring_ctx *ctx, int fd)
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
+			if (!req->file || fd != req->cqe.fd)
+				continue;
+			return req;
+		}
+	}
+	return NULL;
+}
+
 static bool io_poll_disarm(struct io_kiocb *req)
 	__must_hold(&ctx->completion_lock)
 {
@@ -6319,13 +6339,18 @@ static bool io_poll_disarm(struct io_kiocb *req)
 struct io_cancel_data {
 	struct io_ring_ctx *ctx;
 	u64 data;
+	unsigned int flags;
 };
 
 static int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 	__must_hold(&ctx->completion_lock)
 {
-	struct io_kiocb *req = io_poll_find(ctx, cd->data, false);
+	struct io_kiocb *req;
 
+	if (cd->flags & IORING_ASYNC_CANCEL_FD)
+		req = io_poll_fd_find(ctx, cd->data);
+	else
+		req = io_poll_find(ctx, cd->data, false);
 	if (!req)
 		return -ENOENT;
 	io_poll_cancel_req(req);
@@ -6762,7 +6787,11 @@ static bool io_cancel_cb(struct io_wq_work *work, void *data)
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_cancel_data *cd = data;
 
-	return req->ctx == cd->ctx && req->cqe.user_data == cd->data;
+	if (req->ctx != cd->ctx)
+		return false;
+	if (cd->flags & IORING_ASYNC_CANCEL_FD)
+		return req->file && cd->data == req->cqe.fd;
+	return req->cqe.user_data == cd->data;
 }
 
 static int io_async_cancel_one(struct io_uring_task *tctx,
@@ -6811,9 +6840,11 @@ static int io_try_cancel_userdata(struct io_kiocb *req,
 	if (ret != -ENOENT)
 		goto out;
 
-	spin_lock_irq(&ctx->timeout_lock);
-	ret = io_timeout_cancel(ctx, cd->data);
-	spin_unlock_irq(&ctx->timeout_lock);
+	if (!(cd->flags & IORING_ASYNC_CANCEL_FD)) {
+		spin_lock_irq(&ctx->timeout_lock);
+		ret = io_timeout_cancel(ctx, cd->data);
+		spin_unlock_irq(&ctx->timeout_lock);
+	}
 out:
 	spin_unlock(&ctx->completion_lock);
 	return ret;
@@ -6826,11 +6857,17 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags ||
-	    sqe->splice_fd_in)
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->splice_fd_in)
+		return -EINVAL;
+
+	req->cancel.data = READ_ONCE(sqe->addr);
+	req->cancel.flags = READ_ONCE(sqe->cancel_flags);
+	if (req->cancel.flags & ~IORING_ASYNC_CANCEL_FD)
+		return -EINVAL;
+	else if ((req->cancel.flags & IORING_ASYNC_CANCEL_FD) &&
+		 req->cancel.data > INT_MAX)
 		return -EINVAL;
 
-	req->cancel.addr = READ_ONCE(sqe->addr);
 	return 0;
 }
 
@@ -6839,7 +6876,8 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_cancel_data cd = {
 		.ctx	= ctx,
-		.data	= req->cancel.addr,
+		.data	= req->cancel.data,
+		.flags	= req->cancel.flags,
 	};
 	struct io_tctx_node *node;
 	int ret;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1845cf7c80ba..806c473dde9f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -187,6 +187,14 @@ enum {
 #define IORING_POLL_UPDATE_EVENTS	(1U << 1)
 #define IORING_POLL_UPDATE_USER_DATA	(1U << 2)
 
+/*
+ * ASYNC_CANCEL flags.
+ *
+ * IORING_ASYNC_CANCEL_FD	Key off 'fd' for cancelation rather than the
+ *				request 'user_data'
+ */
+#define IORING_ASYNC_CANCEL_FD	(1U << 0)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.35.1

