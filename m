Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F38C35F42A
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 14:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhDNMnW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 08:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbhDNMnU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 08:43:20 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6538C06175F
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 05:42:56 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j5so18772596wrn.4
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 05:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=oscbcssEEKnxt7QXNK9v0Xg30qtm5zAwyV5HW8WuKBg=;
        b=Mtvyi6xIc9lao49kzdhmeH52OXql4NZ8AO0reZ1lUcLdT8UHhvX3oVipQa7yjqhi5p
         pZzMc4HqyRWb4YYrX9UUtklgMJshjcjlhPcw0DthrH0fkRS+Bx0yDsLlRBDujkEc5KPQ
         L7zh/sgCoUtXn7bURXwVdWQZ8bGbgg9IQ2QXdYrEihliZPqqTk2dlp6CMNu6hbXsXn89
         74fxoFBJbhHAPsiOOcjN8CRQjSxaerEoGJRfAovJqYIoyFpwjiHmvi7l0VTli9Ykjnvi
         jKLMOlF0U5LjdhQaM0AuxvQuQ9LKBoUoH+vma4LkDhPns2x0Pw+SkztXS12/3aE6b6Jh
         BIMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oscbcssEEKnxt7QXNK9v0Xg30qtm5zAwyV5HW8WuKBg=;
        b=kSnaQT/duqPJXM3Q/xjmvEznV59eWcMfa/r5krUdDj+hwz5ysHDFrCCRgqa0l6y9QI
         1KnoiGrwY0IhgAbk/gntybA0L5N5olGh2OZl9FXGQ+sZhN29ccuf3GfKTih+2Ysy4Cg3
         LlB3olKWEKl1eXmUnp1s9r61Y+iMnG9TkvL+GwWbJcig+xI4TC40zvWcgUVl1PsbgJNt
         JqIg9ix4HJOaXyE8ygW2XfQTtNbQiv4sNc8glFVbGBWtWgXS1G8Wa2EGHCXCu1NxsAof
         3dKSk2drVcD0TNJchXPLgFto+oiIxNF8tMJhx0UeBNcoKtfBXYyUpyfAYKicKFyz3dlN
         b77A==
X-Gm-Message-State: AOAM532Wfz8WG+UA9Lr0B46jtMm70r6OXKIMcVhiNGavx/jej26daEnv
        Uf2Ome7s8EaVFxu3m/6HCwA=
X-Google-Smtp-Source: ABdhPJw1uOiosBe2BSriF9Njid8X/7OyNwhYGKm41TKUNHN2J3D2vw62zK+g/kzXsmutkgBEuxPjQQ==
X-Received: by 2002:a5d:6881:: with SMTP id h1mr34671331wru.121.1618404175646;
        Wed, 14 Apr 2021 05:42:55 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.37])
        by smtp.gmail.com with ESMTPSA id f2sm5179912wmp.20.2021.04.14.05.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 05:42:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 3/5] io_uring: fix POLL_REMOVE removing apoll
Date:   Wed, 14 Apr 2021 13:38:35 +0100
Message-Id: <50808409506c69dcaaa8aefdc49689e6b25c1522.1618403742.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618403742.git.asml.silence@gmail.com>
References: <cover.1618403742.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't allow REQ_OP_POLL_REMOVE to kill apoll requests, users should not
know about it. Also, remove weird -EACCESS in io_poll_update(), it
shouldn't know anything about apoll, and have to work even if happened
to have a poll and an async poll'ed request with same user_data.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6a70bf455c49..ce75a859a376 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5258,7 +5258,8 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	return posted != 0;
 }
 
-static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr)
+static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr,
+				     bool poll_only)
 	__must_hold(&ctx->completion_lock)
 {
 	struct hlist_head *list;
@@ -5268,18 +5269,20 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr)
 	hlist_for_each_entry(req, list, hash_node) {
 		if (sqe_addr != req->user_data)
 			continue;
+		if (poll_only && req->opcode != IORING_OP_POLL_ADD)
+			continue;
 		return req;
 	}
-
 	return NULL;
 }
 
-static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
+static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr,
+			  bool poll_only)
 	__must_hold(&ctx->completion_lock)
 {
 	struct io_kiocb *req;
 
-	req = io_poll_find(ctx, sqe_addr);
+	req = io_poll_find(ctx, sqe_addr, poll_only);
 	if (!req)
 		return -ENOENT;
 	if (io_poll_remove_one(req))
@@ -5311,7 +5314,7 @@ static int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 
 	spin_lock_irq(&ctx->completion_lock);
-	ret = io_poll_cancel(ctx, req->poll_remove.addr);
+	ret = io_poll_cancel(ctx, req->poll_remove.addr, true);
 	spin_unlock_irq(&ctx->completion_lock);
 
 	if (ret < 0)
@@ -5412,14 +5415,10 @@ static int io_poll_update(struct io_kiocb *req)
 	int ret;
 
 	spin_lock_irq(&ctx->completion_lock);
-	preq = io_poll_find(ctx, req->poll_update.old_user_data);
+	preq = io_poll_find(ctx, req->poll_update.old_user_data, true);
 	if (!preq) {
 		ret = -ENOENT;
 		goto err;
-	} else if (preq->opcode != IORING_OP_POLL_ADD) {
-		/* don't allow internal poll updates */
-		ret = -EACCES;
-		goto err;
 	}
 
 	/*
@@ -5748,7 +5747,7 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	ret = io_timeout_cancel(ctx, sqe_addr);
 	if (ret != -ENOENT)
 		goto done;
-	ret = io_poll_cancel(ctx, sqe_addr);
+	ret = io_poll_cancel(ctx, sqe_addr, false);
 done:
 	if (!ret)
 		ret = success_ret;
@@ -5790,7 +5789,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	ret = io_timeout_cancel(ctx, sqe_addr);
 	if (ret != -ENOENT)
 		goto done;
-	ret = io_poll_cancel(ctx, sqe_addr);
+	ret = io_poll_cancel(ctx, sqe_addr, false);
 	if (ret != -ENOENT)
 		goto done;
 	spin_unlock_irq(&ctx->completion_lock);
-- 
2.24.0

