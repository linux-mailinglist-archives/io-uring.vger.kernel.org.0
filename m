Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE913198C7
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 04:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhBLD3J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 22:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhBLD3J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 22:29:09 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D97C06178A
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 19:27:52 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id n10so6038504wmq.0
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 19:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aLJZarOSOAa1EZN8Jhw26TfuTtDkcaSoD4t5CdjOac8=;
        b=MtV0Ii4yOe8E/og4dW43VvrYlhlMTZPTQ5/xmIUgrggz8c1BaIfAru7vXGYmJoQVOb
         gnBzCkrbMFQusdD36MPx2lDDVzUqz6AcLVuRY3/6I9EiCJ30wsxAbDlgNshtd9PZv7AH
         cyDrxsTvep1oWWGJAcYxc6b6u2tCfAD+1RMchCmKbat8SOBuABPEYq5M7dIRy4bQbW7V
         HRh2oBVn135HzKfhopVcZ/UazX9KRL/DmTI3R/meEpOWziptwYFbQBcpdOWpI8CQFfY/
         y+kVahAIa3ni2IQLwyWp5NKdLTh+8rB/bo/aPRouCn0ANrR2MfaP2ZJtMzMYiUE9Mzi9
         Ue1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aLJZarOSOAa1EZN8Jhw26TfuTtDkcaSoD4t5CdjOac8=;
        b=UY6ETTUTlgTKr40RG6Kp99qT3rB45z0b7y/3CfE0WFcR5OndAHyUUWk5+LS6GtG6cm
         K8cIRa7UtiLDtUnfBZFkE9jjpYsvDA2X42oUi7Zy9UnvlJ9eMW3vI79ID9zMocsCzrqs
         cIMKC/rjpRjEt0jl8W7IsvEa94Nlc41AgbHLP9W6CbSpyczf3eZvL/9QCg4sTgcJdFnk
         Rzx/DnZz6dQ0YFaOI4bEJABCUhJrEKuZH91oftDHsdQVWb8s95m0gnqGJbL3Fr/ZU6Hj
         qfsZcMTNixV4/qh640q4+cvLYqk6kyziUqvf16lN150KplxMjuitDqzS/cR4e2eKapVP
         w81g==
X-Gm-Message-State: AOAM530r43vjthLXA//MSHzUPQvT07Sw4ynAMb9PGH0pjLHyKm6U2+nO
        rjCtsqW7vvZLMjyh/OWhPjA=
X-Google-Smtp-Source: ABdhPJwopTIUyZML/X++18PcD21vVSXLKU3mIvRF7pl6oKElc6mkx9l+W/2KDrPRFN5KUIoEpUirHg==
X-Received: by 2002:a1c:20c7:: with SMTP id g190mr747992wmg.156.1613100471054;
        Thu, 11 Feb 2021 19:27:51 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id c62sm12973479wmd.43.2021.02.11.19.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 19:27:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/5] io_uring: save ctx put/get for task_work submit
Date:   Fri, 12 Feb 2021 03:23:54 +0000
Message-Id: <92d90394cda7c5dd3248bae0284a854d7e5700f5.1613099986.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613099986.git.asml.silence@gmail.com>
References: <cover.1613099986.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Do a little trick in io_ring_ctx_free() briefly taking uring_lock, that
will wait for everyone currently holding it, so we can skip pinning ctx
with ctx->refs for __io_req_task_submit(), which is executed and loses
its refs/reqs while holding the lock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5c0b1a7dba80..87f2f8e660e8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2336,6 +2336,7 @@ static void __io_req_task_submit(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
+	/* ctx stays valid until unlock, even if we drop all ours ctx->refs */
 	mutex_lock(&ctx->uring_lock);
 	if (!ctx->sqo_dead && !io_sq_thread_acquire_mm_files(ctx, req))
 		__io_queue_sqe(req);
@@ -2347,10 +2348,8 @@ static void __io_req_task_submit(struct io_kiocb *req)
 static void io_req_task_submit(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
-	struct io_ring_ctx *ctx = req->ctx;
 
 	__io_req_task_submit(req);
-	percpu_ref_put(&ctx->refs);
 }
 
 static void io_req_task_queue(struct io_kiocb *req)
@@ -2358,11 +2357,11 @@ static void io_req_task_queue(struct io_kiocb *req)
 	int ret;
 
 	req->task_work.func = io_req_task_submit;
-	percpu_ref_get(&req->ctx->refs);
-
 	ret = io_req_task_work_add(req);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		percpu_ref_get(&req->ctx->refs);
 		io_req_task_work_add_fallback(req, io_req_task_cancel);
+	}
 }
 
 static inline void io_queue_next(struct io_kiocb *req)
@@ -8707,6 +8706,14 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *submit_state = &ctx->submit_state;
 
+	/*
+	 * Some may use context even when all refs and requests have been put,
+	 * and they are free to do so while still holding uring_lock, see
+	 * __io_req_task_submit(). Wait for them to finish.
+	 */
+	mutex_lock(&ctx->uring_lock);
+	mutex_unlock(&ctx->uring_lock);
+
 	io_finish_async(ctx);
 	io_sqe_buffers_unregister(ctx);
 
-- 
2.24.0

