Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7670F35F1A0
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 12:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbhDNKsf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 06:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233833AbhDNKse (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 06:48:34 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7680FC061756
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 03:48:13 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j5so18433854wrn.4
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 03:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=oscbcssEEKnxt7QXNK9v0Xg30qtm5zAwyV5HW8WuKBg=;
        b=tfQFNPf7al5EXeugSbKYvohRp0sZ8gn5ra0+Xg78Qql5e0BfojYQF/H2jbf4vAZ2Xv
         UToV5cmYPxAqbgG7j9mNboi22SYQc4T1wk1sC1UGM1pZXJNaVHyZ+D0bS9DRA6oYVBxb
         nYXqftj67KiX20tAbnq5YrKvKSF0JaYs2Vtyi2h+Tem48uNPIfhnX0pJnWTfgjfEZuuS
         abMsgk9Vf0p6uRskk7488nwdf4uLlfptn9rXQQp0lpL0+DbTwsyOYqKz/KAkYevBRlX5
         XjKNHcwCv5iEMADX60W/2fK+O1mBnVdGuRFdAmGJ+Mbg8WM0LHuoGsmhDZq0trTSg+hA
         CJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oscbcssEEKnxt7QXNK9v0Xg30qtm5zAwyV5HW8WuKBg=;
        b=apUPl5Hbl0U2j3aQesk5uZAvMFj+pQupPtsdtCf4SPj1cwLj69Nzd/HUi/YMWpaPdQ
         DrhcDANyZckrbz0YfGcRm6RrJgXwsqXJzKz+r+gJ3ewl9jvkaaDqyvMqBcVw9m9gTaTX
         jBXhVM5eBT5AHq7jI151nhOV6gb7zZ3nPIc/p0xYYMH5ClrN0/z6OMshLhPUrtfgjClP
         BCJWFMUxhfAaTc+xeedmvDoraKK9MbNCvTfCBkUzFk63MsTAs0jC53isutKUTskRIsg2
         Hxu8EUvrm3UAhZvmCs8qwbtt8tSuWeMr5x6qG6+QLIFnv+oPhCEY3JgHgC3sRgOIz2og
         j05g==
X-Gm-Message-State: AOAM532oSa1XNX2uF2VQtz1rfxV8kP7gp7y4anIDTsqpsdeU3mAJqOSq
        MRr/20CSuazS2FtmC3Tl5Gs=
X-Google-Smtp-Source: ABdhPJwRtLvgo6iuT+FNB/3pT9JB5PLXSxRM/6ZLO42VH8HWmFutVy0rMhM8n4hkyANuiYY1Wdpelw==
X-Received: by 2002:a5d:6c62:: with SMTP id r2mr43858198wrz.62.1618397292324;
        Wed, 14 Apr 2021 03:48:12 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.163])
        by smtp.gmail.com with ESMTPSA id n14sm5003002wmk.5.2021.04.14.03.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 03:48:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/5] io_uring: fix POLL_REMOVE removing apoll
Date:   Wed, 14 Apr 2021 11:43:52 +0100
Message-Id: <50808409506c69dcaaa8aefdc49689e6b25c1522.1618396838.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618396838.git.asml.silence@gmail.com>
References: <cover.1618396838.git.asml.silence@gmail.com>
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

