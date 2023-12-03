Return-Path: <io-uring+bounces-211-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E31A9802531
	for <lists+io-uring@lfdr.de>; Sun,  3 Dec 2023 16:39:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AF2A1F20F4B
	for <lists+io-uring@lfdr.de>; Sun,  3 Dec 2023 15:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A076154AC;
	Sun,  3 Dec 2023 15:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7k93WH1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79126EB
	for <io-uring@vger.kernel.org>; Sun,  3 Dec 2023 07:39:32 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-33331e98711so2066001f8f.1
        for <io-uring@vger.kernel.org>; Sun, 03 Dec 2023 07:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701617971; x=1702222771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5H13ZNw0VyOVQKzz9/JvTcJvrlTNhJPNYmDU8i2TAcc=;
        b=D7k93WH1z2HPOuWenysNnxq2z1LZiS1GeutOOYnUto8aRRLfMMUNVWT+Hok1n3Vxj7
         d+oL3Psdq56XwQxBgTeGnTUVKp14tH6OTedK3MTi99+H0KrNgKxKNRKaHRuHNhQEErKC
         b2JsRhUsQEDj3+0i34o1rUjSs9FzJfJiY3m1Y4hIzMLHBRKjbkO3YOp+yc3Srg6gcoR5
         2ekGVX0nNGwvJSEAGAof56SjvvtsJsjKgWzhz1XbBntNXDz/n/axJfoV9rtYQPvuHT/i
         7h2Iuf3lQbOCP4BIF1crZwv1P1PN5j7FSUqO0luF53MozD1T5wdCDUMNVYRG/sT8i83y
         yGMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701617971; x=1702222771;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5H13ZNw0VyOVQKzz9/JvTcJvrlTNhJPNYmDU8i2TAcc=;
        b=OEyTouhmoGOTUnEZbveioyNmHPZANExEMN57fT2sQFVhumIcL7imvQkweTyepxWl3o
         i9TABdelLYZ+jZPf0ykLJ8f/bqC5d6Qd1Rt43cG011d+lyW0YPLDw4uNuecAUPw9bc2e
         /H2irAcF3IWCAz9ZzClAFpVXGj+edfaw7LwGkpMpPMfsMEEcbzTFelKbGdI++/HFPhW1
         KgvdLUAzoW3JpA1bNnM44ZQjI3V68gGOMNBodNtak79RNT9wfYd4D9LoPDGq6LmldWU9
         faMcYKnVraZoZl6bOVsnGu4t8oTJ1CVQe1EwJjeLe6zaxDomu80qynHCjzInBsb9/dkE
         lddQ==
X-Gm-Message-State: AOJu0YyiWdYwjAh22AWzTcxY9R1iJRapP7bJU20IHpxEHnQyYTLHLyFY
	NRmwcPEiEauK09njHXmzfJ9tdXcmqNI=
X-Google-Smtp-Source: AGHT+IHfUK/i50CWyterOYSM+8v/8htvvb7VC08ZmA3Tz0GPmfWKvG+0PILR/6BsONURWY09RX41HQ==
X-Received: by 2002:a05:600c:1f83:b0:40b:4c60:7405 with SMTP id je3-20020a05600c1f8300b0040b4c607405mr1612700wmb.28.1701617970414;
        Sun, 03 Dec 2023 07:39:30 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.73])
        by smtp.gmail.com with ESMTPSA id fl8-20020a05600c0b8800b0040b37f1079dsm15928075wmb.29.2023.12.03.07.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Dec 2023 07:39:30 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	jannh@google.com
Subject: [PATCH 1/1] io_uring: fix mutex_unlock with unreferenced ctx
Date: Sun,  3 Dec 2023 15:37:53 +0000
Message-ID: <929d30ff7f0a27793e8b36f398ae12788cf04899.1701617803.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Callers of mutex_unlock() have to make sure that the mutex stays alive
for the whole duration of the function call. For io_uring that means
that the following pattern is not valid unless we ensure that the
context outlives the mutex_unlock() call.

mutex_lock(&ctx->uring_lock);
req_put(req); // typically via io_req_task_submit()
mutex_unlock(&ctx->uring_lock);

Most contexts are fine: io-wq pins requests, syscalls hold the file,
task works are taking ctx references and so on. However, the task work
fallback path doesn't follow the rule.

Cc: stable@vger.kernel.org
Fixes: 04fc6c802d ("io_uring: save ctx put/get for task_work submit")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6212f81ed887..c45951f95946 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -272,6 +272,7 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 	struct io_kiocb *req, *tmp;
 	struct io_tw_state ts = { .locked = true, };
 
+	percpu_ref_get(&ctx->refs);
 	mutex_lock(&ctx->uring_lock);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
 		req->io_task_work.func(req, &ts);
@@ -279,6 +280,7 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 		return;
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
+	percpu_ref_put(&ctx->refs);
 }
 
 static int io_alloc_hash_table(struct io_hash_table *table, unsigned bits)
@@ -3145,12 +3147,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	init_completion(&exit.completion);
 	init_task_work(&exit.task_work, io_tctx_exit_cb);
 	exit.ctx = ctx;
-	/*
-	 * Some may use context even when all refs and requests have been put,
-	 * and they are free to do so while still holding uring_lock or
-	 * completion_lock, see io_req_task_submit(). Apart from other work,
-	 * this lock/unlock section also waits them to finish.
-	 */
+
 	mutex_lock(&ctx->uring_lock);
 	while (!list_empty(&ctx->tctx_list)) {
 		WARN_ON_ONCE(time_after(jiffies, timeout));
-- 
2.43.0


