Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01721A6B51
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 19:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732760AbgDMRWF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 13:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732579AbgDMRWE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 13:22:04 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352D1C0A3BDC
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 10:22:04 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id z9so4057487pjd.2
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 10:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RhGy1hMMDk3tX7yhvvqKxq1xy/LmOYB9w2PC+8Gt0UI=;
        b=d8T2+Mr9sTZhVEDsqD3PuKCo62F/lI8SAzh5X01+89vFhctYh4lR6KwMVpeDeTAhzX
         PS0szCqUM6jDfU1lb0Ap8al4u0Tt7viawjHiMtH6ujp1/GI+9g+ymWedBHRGsOKi45Bv
         SuV/bAShEtuIivQW3+e1AOcNQ9TnP1IAJrPCuvz8PQSGXVgBd/+wHTNOCPrZe7za/NE+
         C3948hzTxFAho3NV1d6SuiTnM4dD5A0+ZyOwR+m0/51Za/gHf7+omx+voHmjgD5nlwEq
         IFciuJ+kUPjyUqQJryH+6PU0Kti8xjowQlphUuk81aHxF0j/uNlkkcDhvQkhRqqszhO/
         sM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RhGy1hMMDk3tX7yhvvqKxq1xy/LmOYB9w2PC+8Gt0UI=;
        b=tx1DBIRHX5VJ/HhB1ZcPpMy6N3pRRZEvqnzoS1n6aRHGPAtCiVVjymnkmu3DdBNx8/
         JHUfF3qhbPSwUeIFwFqc4uJWGeU5XCiaJZ7HMrTfiESKOiq7rQJfRyGbsDtltTx2bvK8
         lxkjCK9Lj3PFpHDIcPe+/vKUpQ79UOeL2ACZz2V+zx1GV8Q000ToU4eOi+Rp9lwCzV8A
         0F/zhpNYVBaKjRbclxSX45P5BFzfoxQa6BR3luzDc788Mr9LfPBA8l/OX5OTO1narsia
         hTD3+JVQC3obeZyUNVQSeWkytZyVW7GkpmTE5H089IlvWgRFv4EaELLW/+mIyc8O/FkX
         jQdA==
X-Gm-Message-State: AGi0PuaOyemAONndewkHsD34XO/k23x1uVegmjN/h05uNU7VUMfzeLYJ
        CQLHy4i13XWWX1yqGP9j4vCfnVKmVjBjJg==
X-Google-Smtp-Source: APiQypLqO18dxPJ1nCtdZNvleMLfzfueSOasJnxDQs5dWsIN4ZpPppkf1T6W47IlBHYvO3GyaS6nhA==
X-Received: by 2002:a17:902:a98a:: with SMTP id bh10mr17704187plb.340.1586798523402;
        Mon, 13 Apr 2020 10:22:03 -0700 (PDT)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id v25sm8615686pgl.55.2020.04.13.10.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 10:22:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: check for need to re-wait in polled async handling
Date:   Mon, 13 Apr 2020 11:21:57 -0600
Message-Id: <20200413172158.8126-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200413172158.8126-1-axboe@kernel.dk>
References: <20200413172158.8126-1-axboe@kernel.dk>
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

