Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EB21A6B56
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 19:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732777AbgDMR0P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 13:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732579AbgDMR0O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 13:26:14 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A980C0A3BDC
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 10:26:14 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id c23so4741925pgj.3
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 10:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RhGy1hMMDk3tX7yhvvqKxq1xy/LmOYB9w2PC+8Gt0UI=;
        b=cejg/G5I/IpsG4zrqzZV3Y6HwCgPbKcYA67kXZVIUGVEbQKMub62IyS8gN8BAfokEt
         p9f2vXpYmDHjv/tZOcWqjpEvQ8Ksd7q9BtW8Ljh7tWamm+WW9Ks9itjzXsH5i3oAF4m6
         GmC575oJF2Zyw0SjtakkxfY5fKPsK4qAO5dR20JLeOjoWSqyc8tN5gUkCEV0bPDJPoQn
         9fMmV6ls1AQbPsKyBEhk04M1WjsxhArUwH7oFKKdi5G6TTKerxn+adrRWKZ/erqUJRDM
         rPr9+3+wPfxMzrj4FD5oGSdrf9vslsQatF5ClLN35hetC9vyF/vdexTsvXX9FkySuR3P
         4ntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RhGy1hMMDk3tX7yhvvqKxq1xy/LmOYB9w2PC+8Gt0UI=;
        b=FJbYWsG34qbkX6LLlkkrTQq7xbWXCLzAKUYMDSAVE2Mz8ORzxSwEc+9D2qNz+waUyi
         Lrhk4dnTJw4sdSpBzkZOu1uelb5toL/u11dQABmybzeZjc6Y0577GUcjuxsGwqWqnDY7
         VtwNNf+PhwluWNUUv0Qhbcj0LiAn1X4MqjAW1+BL+1t7M2Y7HWp2LykVN9SxiXC9bsnk
         UG9I1z75jyss9kV5SHB/cI2aqYScRRVtRGM846ErhLy2W7UTIvG81+M78N1yo7jcAfJE
         Qb09F5tQuCmFjElpsNZSkQ+EgI9/Ex8SvnBp/KViaOPtJIt9Q2F8UVvi3OtfAQs/Vfvd
         G57w==
X-Gm-Message-State: AGi0PuY+S0xMnYg2r1+k0h+GtJAq/Akrz3pqyTCcvxPn78bh/rKRy43h
        l0RD/GMSdVURYI4rh+8UYjm4ah4zcSkW1A==
X-Google-Smtp-Source: APiQypLcJx7ri7rSjtWn+5vhqFkxqT9XOXm2LxnLRwDHehdCz033K3cizOFSLk75kNNWPc0cP9nO0w==
X-Received: by 2002:aa7:9207:: with SMTP id 7mr18670421pfo.178.1586798773596;
        Mon, 13 Apr 2020 10:26:13 -0700 (PDT)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id q2sm2228834pfl.174.2020.04.13.10.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 10:26:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: check for need to re-wait in polled async handling
Date:   Mon, 13 Apr 2020 11:26:05 -0600
Message-Id: <20200413172606.8836-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200413172606.8836-1-axboe@kernel.dk>
References: <20200413172606.8836-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We added this for just the regular poll requests in commit a6ba632d2c24
("io_uring: retry poll if we got woken with non-matching mask"), we
should do the same for the poll handler used pollable async requests.
Move the re-wait check and arm into a helper, and call it from
io_async_task_func() as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0d1b5d5f1251..7b41f6231955 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4156,6 +4156,26 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	return 1;
 }
 
+static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
+	__acquires(&req->ctx->completion_lock)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!req->result && !READ_ONCE(poll->canceled)) {
+		struct poll_table_struct pt = { ._key = poll->events };
+
+		req->result = vfs_poll(req->file, &pt) & poll->events;
+	}
+
+	spin_lock_irq(&ctx->completion_lock);
+	if (!req->result && !READ_ONCE(poll->canceled)) {
+		add_wait_queue(poll->head, &poll->wait);
+		return true;
+	}
+
+	return false;
+}
+
 static void io_async_task_func(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
@@ -4164,14 +4184,16 @@ static void io_async_task_func(struct callback_head *cb)
 
 	trace_io_uring_task_run(req->ctx, req->opcode, req->user_data);
 
-	WARN_ON_ONCE(!list_empty(&req->apoll->poll.wait.entry));
-
-	if (hash_hashed(&req->hash_node)) {
-		spin_lock_irq(&ctx->completion_lock);
-		hash_del(&req->hash_node);
+	if (io_poll_rewait(req, &apoll->poll)) {
 		spin_unlock_irq(&ctx->completion_lock);
+		return;
 	}
 
+	if (hash_hashed(&req->hash_node))
+		hash_del(&req->hash_node);
+
+	spin_unlock_irq(&ctx->completion_lock);
+
 	/* restore ->work in case we need to retry again */
 	memcpy(&req->work, &apoll->work, sizeof(req->work));
 
@@ -4436,18 +4458,11 @@ static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_poll_iocb *poll = &req->poll;
 
-	if (!req->result && !READ_ONCE(poll->canceled)) {
-		struct poll_table_struct pt = { ._key = poll->events };
-
-		req->result = vfs_poll(req->file, &pt) & poll->events;
-	}
-
-	spin_lock_irq(&ctx->completion_lock);
-	if (!req->result && !READ_ONCE(poll->canceled)) {
-		add_wait_queue(poll->head, &poll->wait);
+	if (io_poll_rewait(req, poll)) {
 		spin_unlock_irq(&ctx->completion_lock);
 		return;
 	}
+
 	hash_del(&req->hash_node);
 	io_poll_complete(req, req->result, 0);
 	req->flags |= REQ_F_COMP_LOCKED;
-- 
2.26.0

