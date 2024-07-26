Return-Path: <io-uring+bounces-2588-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A5A093D50C
	for <lists+io-uring@lfdr.de>; Fri, 26 Jul 2024 16:24:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E782284054
	for <lists+io-uring@lfdr.de>; Fri, 26 Jul 2024 14:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD3B6D51A;
	Fri, 26 Jul 2024 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VmLkVrc3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F5F10953
	for <io-uring@vger.kernel.org>; Fri, 26 Jul 2024 14:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722003849; cv=none; b=XUuXjigZmM15XfjvHCbQ/v7VBGlmZ3v7iTkRKnn4WM1ZfeMbpKi5ObRK1gfS91UQPeQ3R7W4H2jEfLkV4ZOXxDYxISwFAFFmNOUEqTD7cCHTC2ytVBaWrf0NpGgbWO4txa5awdcC0a7djib7kKsznWTh3AGkfQ3cCiaWlUPTktI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722003849; c=relaxed/simple;
	bh=UzOSJ79VOyc2/Ktpbev9Taeffiq8vzLkHQY2bMqE904=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ar7kB5ih7HKnCsmIxatF+VSd+/GJYr62d3oSpOB+sVWe16BpMpgu7rDtIbNmKZ3u3mkerCi/neCcN18Iy75LWIL9saP/i2He8drPzjq5t9s4V6QJ5XH74Ad6njfYjiinIPtIiONHKbL6aXkZgFqnh9Uq9j9qOwjE70RpP9iCyHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VmLkVrc3; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-36858357bb7so1242477f8f.2
        for <io-uring@vger.kernel.org>; Fri, 26 Jul 2024 07:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722003846; x=1722608646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWFxYZVUdU5VgKQ1O9wvjoyKLvqGVeHzOmx2JdNh+Yk=;
        b=VmLkVrc3ksXADyO5wE+QCoYdMDZp6g0o122OL5DBcMX4fA0gIsMG81p3+ruQQcuCek
         kPS1R0WoChTwPlMjqGxnmDmbFy4N/rmIuT/llt0T7VIclTYX5mmyGW7p1tUn7egFJoom
         kZJhK4zzTZkFFOqyplF/xlWMdAr2fCE4k5LAnOEGjxYWcDEqcZsq16/NcASlPfGhpJem
         kwktBuoe1xu6HKCpJlS4dEIox2BrpvZygUAfEogzfXLZXjN5BeTvVB6mSy9p2GZFo350
         25SW7qsuh7FQe4DqU2tY7l4Zszt22T6lhg2L+LAaNeM+Q6XTCVdgqOhfLXdEkoxoCPYA
         2kCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722003846; x=1722608646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XWFxYZVUdU5VgKQ1O9wvjoyKLvqGVeHzOmx2JdNh+Yk=;
        b=ksfc2XxHJOcTaTYwOcxtBRzFlFk6mbZpOHMQ+VynV7PAEnxBal+uA0dQyrMXJfP3ro
         NfDWNhFmIV4NaawULTtwzrD2l8alrylJO5Wtc/5opw9/mPnZFHf6t3XLQu/9VRryTh5s
         jMkuFY7cC9KgJ5r2bV6ZQ+NgvD6ZTO3Tlmcqe+k8L+F/iYoHpj9t2s04G3Hcz8WN8fO5
         /28yMThkdxE1a0CEL7u5xK2ciuYcVoqHAR/D1o9GpV+MqYch4X6fxOPo/x/B6g7K2Uq1
         gZqjG61A/kqzflOjPuXo7MrUGbbJuxohrISYsdTn4OrFJyyxGtZ8zHGt+sm5TWdXZd+0
         cisw==
X-Gm-Message-State: AOJu0YzEo2tPiIfBFeU+xuUxCn5ajXPotW+xzwA5m9YjGVzC/SjkMEwQ
	mxMJ+PPobx8OEYGtpx1zzzYIlHgqNMLjsC6zHDEhMMMpdMsl5vtn2t6OgA==
X-Google-Smtp-Source: AGHT+IEZqhYyCupEM+ETM6VoEVrb+xXV6XZBKTDcGEnZcAdQWW/fBDXqvFioaKVaVRTjhtqikKpicw==
X-Received: by 2002:a05:6000:2ca:b0:368:38ab:65f4 with SMTP id ffacd0b85a97d-36b31a3e70dmr5554564f8f.38.1722003846259;
        Fri, 26 Jul 2024 07:24:06 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.204])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b367d9859sm5263706f8f.28.2024.07.26.07.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 07:24:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring/napi: pass ktime to io_napi_adjust_timeout
Date: Fri, 26 Jul 2024 15:24:31 +0100
Message-ID: <4f5b8e8eed4f53a1879e031a6712b25381adc23d.1722003776.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1722003776.git.asml.silence@gmail.com>
References: <cover.1722003776.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pass the waiting time for __io_napi_adjust_timeout as ktime and get rid
of all timespec64 conversions. It's especially simpler since the caller
already have a ktime.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  6 ++++--
 io_uring/napi.c     | 14 +++-----------
 io_uring/napi.h     |  8 ++++----
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2626424f5d73..3942db160f18 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2416,12 +2416,14 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 	if (uts) {
 		struct timespec64 ts;
+		ktime_t dt;
 
 		if (get_timespec64(&ts, uts))
 			return -EFAULT;
 
-		iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
-		io_napi_adjust_timeout(ctx, &iowq, &ts);
+		dt = timespec64_to_ktime(ts);
+		iowq.timeout = ktime_add(dt, ktime_get());
+		io_napi_adjust_timeout(ctx, &iowq, dt);
 	}
 
 	if (sig) {
diff --git a/io_uring/napi.c b/io_uring/napi.c
index 6bdb267e9c33..4fd6bb331e1e 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -282,20 +282,12 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
  * the NAPI timeout accordingly.
  */
 void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
-			      struct timespec64 *ts)
+			      ktime_t to_wait)
 {
 	ktime_t poll_dt = READ_ONCE(ctx->napi_busy_poll_dt);
 
-	if (ts) {
-		struct timespec64 poll_to_ts;
-
-		poll_to_ts = ns_to_timespec64(ktime_to_ns(poll_dt));
-		if (timespec64_compare(ts, &poll_to_ts) < 0) {
-			s64 poll_to_ns = timespec64_to_ns(ts);
-			if (poll_to_ns > 0)
-				poll_dt = ns_to_ktime(poll_to_ns);
-		}
-	}
+	if (to_wait)
+		poll_dt = min(poll_dt, to_wait);
 
 	iowq->napi_busy_poll_dt = poll_dt;
 }
diff --git a/io_uring/napi.h b/io_uring/napi.h
index babbee36cd3e..88f1c21d5548 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -18,7 +18,7 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg);
 void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock);
 
 void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
-		struct io_wait_queue *iowq, struct timespec64 *ts);
+		struct io_wait_queue *iowq, ktime_t to_wait);
 void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq);
 int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx);
 
@@ -29,11 +29,11 @@ static inline bool io_napi(struct io_ring_ctx *ctx)
 
 static inline void io_napi_adjust_timeout(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
-					  struct timespec64 *ts)
+					  ktime_t to_wait)
 {
 	if (!io_napi(ctx))
 		return;
-	__io_napi_adjust_timeout(ctx, iowq, ts);
+	__io_napi_adjust_timeout(ctx, iowq, to_wait);
 }
 
 static inline void io_napi_busy_loop(struct io_ring_ctx *ctx,
@@ -88,7 +88,7 @@ static inline void io_napi_add(struct io_kiocb *req)
 }
 static inline void io_napi_adjust_timeout(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
-					  struct timespec64 *ts)
+					  ktime_t to_wait)
 {
 }
 static inline void io_napi_busy_loop(struct io_ring_ctx *ctx,
-- 
2.45.2


