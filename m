Return-Path: <io-uring+bounces-2614-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B5F494219F
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 22:29:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D47628646A
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 20:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A933A18E025;
	Tue, 30 Jul 2024 20:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bwO2s8VF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9579918DF7D
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 20:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722371368; cv=none; b=RVtCVnvYCUIz/YilUNgb6FK2isHvB6NOaY991+S8SovigXfP9zzEKicLpsy03oXiDCvx4ujUn3f8k5YGP+XwAuPm5ixC1X2POTNLHsnING9Ptn/BQ4kXrF2RDVPJH3s2y6IeNIHhY660y2lLEJR+gDWakzvCiw3bwlIrBzPBLrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722371368; c=relaxed/simple;
	bh=zovKaqxO0iZW2msDKkeqZYOYPS1G0opJSaZ5TvPDHgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixq+Ew0jGOShHABHJ6KZAV1gZVN4VRq89selXC9UH+TDXlhAOquUwQYzgfenTs6VbPItkhhtgAqLVmxY2A/Cp/CGw0kXZxSSQaI3ZKSHxyZTiWRVWdBxLOYBssKpY7AJxOZz7FW8jeGk1GmzQ1E5QKR2KAMKQ+jq/is4aiE29wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bwO2s8VF; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-427b1d4da32so1410845e9.0
        for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 13:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722371364; x=1722976164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WsQgCMWM9FHgRe4Z+rQk9mNDKnWifQacOoNk8pNYn8U=;
        b=bwO2s8VFbBAGGjWJ1w1Cg80v/HFVzzEwp+aWEzHPoQaMnQvfKjONSV1twT5jSu3yIJ
         ulMTDH67/XkZE+0kzmhrj274yj0fYZRZv4bf0IIC+BMn7flLdTiYIGkXj4hv8uFD9vqz
         DzNUjYKYXyxO2qip1kVNrgSaXMtbuPb82GhIUQAFVtawVaxIWSMFrI+fXHLSvT72LL8Y
         70hKEws9iiH5TzVqe6Bg3y3D+rtKtsz67mO75HqsKzRNdVRJFLyRc+LitdsErnETz2R4
         2dClx+42WBN7jD+FBH0e72zmkXv8lhBIZLLVqqrVwMV7sfodWFt3C9m+L+yXgXfRuCsp
         RZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722371364; x=1722976164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WsQgCMWM9FHgRe4Z+rQk9mNDKnWifQacOoNk8pNYn8U=;
        b=hNhs1jLTM/he6BaWEJlliIcr4x5dqTwH9q3JkGc3kGRp7mnEWAepaImuhntQZavjqb
         GrzPaVGMutie45x4GvrqpdInfAIijgFroD5VN75zHVJxeYFMgI4SaCfWdsfHJ8l2x9Rw
         L8X+ZdPP6dbkjJgwQInenX3/kcnyIe5djtinevITyrCO9BRPM77+D9uPi4zo2qJMhydb
         e4rIzsNZkqgalAxzjDlMlugk2Qb5J/KyLmz8LLmExn+e4sQ4yfOvCM1wrJrNl5tFW9Hp
         WEJyAF1vfyz3z5ddB8xEpJPuXxZ0Oqr2A80lxSjfSm2dSssobhhLk62I9PMbpvYX+KWV
         Ej5A==
X-Gm-Message-State: AOJu0Yy9v0gapgxbHsQoZLAUZChkT/MiP49mU3/4r3wQx955p/Ioehl4
	UySYjSpHks16lg9ntkvn4HSemAhdKxS/By+HcY4GPa08YYu3QQSlgfs+7A==
X-Google-Smtp-Source: AGHT+IF2PcvlXs4+keKHEMyx0npqCgE8zPdZ3xZdTFhoDxRvctH4z2Yso3CvCX6JwA28OWMnxBb2Lw==
X-Received: by 2002:a05:600c:a41:b0:428:9c0:2ad with SMTP id 5b1f17b1804b1-4282445d0c0mr19886095e9.18.1722371364248;
        Tue, 30 Jul 2024 13:29:24 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42808457c7fsm214488065e9.32.2024.07.30.13.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 13:29:23 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Lewis Baker <lewissbaker@gmail.com>
Subject: [PATCH 2/3] io_uring/napi: delay napi timeout adjustment
Date: Tue, 30 Jul 2024 21:29:43 +0100
Message-ID: <2766891d83b5d1ff231210ee3d09387398ef29cc.1722357468.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1722357468.git.asml.silence@gmail.com>
References: <cover.1722357468.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead adjusting busy polling time in io_cqring_wait(), rely on the
deadline value and delay the check until io_napi_busy_loop_timeout()
is called inside the napi busy polling loop. There is a side effect
of comparing a cpu local clock with ktime_get(), however waiting
timeouts are usually long enough not to care and napi.c is already
careless about mixing time flavours, i.e. io_napi_blocking_busy_loop()
gets a cpu local time before disabling preemption.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  1 -
 io_uring/napi.c     | 30 ++++++------------------------
 io_uring/napi.h     | 16 ----------------
 3 files changed, 6 insertions(+), 41 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3942db160f18..9ec07f76ad19 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2423,7 +2423,6 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 		dt = timespec64_to_ktime(ts);
 		iowq.timeout = ktime_add(dt, ktime_get());
-		io_napi_adjust_timeout(ctx, &iowq, dt);
 	}
 
 	if (sig) {
diff --git a/io_uring/napi.c b/io_uring/napi.c
index a670f49e30ef..c5c1177e2fb4 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -109,12 +109,15 @@ static inline void io_napi_remove_stale(struct io_ring_ctx *ctx, bool is_stale)
 }
 
 static inline bool io_napi_busy_loop_timeout(ktime_t start_time,
-					     ktime_t bp)
+					     struct io_wait_queue *iowq)
 {
+	ktime_t bp = iowq->napi_busy_poll_dt;
+
 	if (bp) {
 		ktime_t end_time = ktime_add(start_time, bp);
 		ktime_t now = net_to_ktime(busy_loop_current_time());
 
+		end_time = min(end_time, iowq->timeout);
 		return ktime_after(now, end_time);
 	}
 
@@ -130,8 +133,7 @@ static bool io_napi_busy_loop_should_end(void *data,
 		return true;
 	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
 		return true;
-	if (io_napi_busy_loop_timeout(net_to_ktime(start_time),
-				      iowq->napi_busy_poll_dt))
+	if (io_napi_busy_loop_timeout(net_to_ktime(start_time), iowq))
 		return true;
 
 	return false;
@@ -271,27 +273,6 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 	return 0;
 }
 
-/*
- * __io_napi_adjust_timeout() - adjust busy loop timeout
- * @ctx: pointer to io-uring context structure
- * @iowq: pointer to io wait queue
- * @ts: pointer to timespec or NULL
- *
- * Adjust the busy loop timeout according to timespec and busy poll timeout.
- * If the specified NAPI timeout is bigger than the wait timeout, then adjust
- * the NAPI timeout accordingly.
- */
-void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
-			      ktime_t to_wait)
-{
-	ktime_t poll_dt = READ_ONCE(ctx->napi_busy_poll_dt);
-
-	if (to_wait)
-		poll_dt = min(poll_dt, to_wait);
-
-	iowq->napi_busy_poll_dt = poll_dt;
-}
-
 /*
  * __io_napi_busy_loop() - execute busy poll loop
  * @ctx: pointer to io-uring context structure
@@ -304,6 +285,7 @@ void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
 	if ((ctx->flags & IORING_SETUP_SQPOLL) || !ctx->napi_enabled)
 		return;
 
+	iowq->napi_busy_poll_dt = READ_ONCE(ctx->napi_busy_poll_dt);
 	iowq->napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
 	io_napi_blocking_busy_loop(ctx, iowq);
 }
diff --git a/io_uring/napi.h b/io_uring/napi.h
index 88f1c21d5548..87e30b4f8d9e 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -17,8 +17,6 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg);
 
 void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock);
 
-void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
-		struct io_wait_queue *iowq, ktime_t to_wait);
 void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq);
 int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx);
 
@@ -27,15 +25,6 @@ static inline bool io_napi(struct io_ring_ctx *ctx)
 	return !list_empty(&ctx->napi_list);
 }
 
-static inline void io_napi_adjust_timeout(struct io_ring_ctx *ctx,
-					  struct io_wait_queue *iowq,
-					  ktime_t to_wait)
-{
-	if (!io_napi(ctx))
-		return;
-	__io_napi_adjust_timeout(ctx, iowq, to_wait);
-}
-
 static inline void io_napi_busy_loop(struct io_ring_ctx *ctx,
 				     struct io_wait_queue *iowq)
 {
@@ -86,11 +75,6 @@ static inline bool io_napi(struct io_ring_ctx *ctx)
 static inline void io_napi_add(struct io_kiocb *req)
 {
 }
-static inline void io_napi_adjust_timeout(struct io_ring_ctx *ctx,
-					  struct io_wait_queue *iowq,
-					  ktime_t to_wait)
-{
-}
 static inline void io_napi_busy_loop(struct io_ring_ctx *ctx,
 				     struct io_wait_queue *iowq)
 {
-- 
2.45.2


