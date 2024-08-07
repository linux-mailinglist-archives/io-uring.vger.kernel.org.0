Return-Path: <io-uring+bounces-2664-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BAF694A9E3
	for <lists+io-uring@lfdr.de>; Wed,  7 Aug 2024 16:18:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 171F81F2BF75
	for <lists+io-uring@lfdr.de>; Wed,  7 Aug 2024 14:18:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA265820E;
	Wed,  7 Aug 2024 14:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZOTW/Fci"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FC4339B1
	for <io-uring@vger.kernel.org>; Wed,  7 Aug 2024 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040264; cv=none; b=ugHTOxryFKml/U4TZb68o4jP+St+KwFeDqOnB7ZzXh/nLrgjhAwUGIHqvKRgcekMU9pjoDrKmdXTa2zq6wh+yMJwr580cE3E5yqs8PLjQJKWk04OD8JTfM+XF5z+wWicQnOtJ87JEu4YHXlNmaGdcU97P4qma2i0Ft1cpZk9LU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040264; c=relaxed/simple;
	bh=kbQc3ZU5Pa8Xs4JzWsnWeqlC1DUBEYEF1zOqqUrpdNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GS693buu0vTOqr9+/jEBIYCmWGlEwB2XgbDvToRB3zZe3GwAlZJfcoqI/bQymZ798bTZmiUe7goiA08LonX++n9wCYKzCd9h84aOg3AqXdgxUrRTO6Uw+sZ/da+G+fN0NNOafp1wOXwCwcxAQRLiKuYz2A49yHnINHvOoG5XfXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZOTW/Fci; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5b8c2a6135eso1136582a12.0
        for <io-uring@vger.kernel.org>; Wed, 07 Aug 2024 07:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723040260; x=1723645060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cd+9inN4Ie9i79QY0gLMmfXUkICUzIAd6tOIMvHR4GE=;
        b=ZOTW/FciOAgqmIwci+12OD+7r/e6GAx6qhXo02G5lbsRXFnhUO8ETJQJV0UXspYJc0
         wkdheG1z0OBSfws/oAFeYLbfU5ciFSfhPhhp5s3NoNOL+j4vsHkRlPwu4+oxsZuTpyEN
         JToQ1Up/DSaj0p178PYPUzkAFrquvbLUkFPI4LnscaQN0v1XPeOnx6SFkmfuI74KIdwr
         dMFBVw+87SVeK0GY2+LyBbHs1PfIlJtukXlqHesvDQwBy7IUVZBKXBhZb5OuP2VcJJXo
         bzpAQ95oISMTOj6Zr6sSL2IEpGsoDdH69DARyKhkOrPkUJ5NAdLQxt2abeNZJ0wdzIqE
         ZphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723040260; x=1723645060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cd+9inN4Ie9i79QY0gLMmfXUkICUzIAd6tOIMvHR4GE=;
        b=Oa7nt0PISpE29hxBXRN1z37holn0OjuxOo6P/iY1UUoLTYZID909ndo59FTWOE9j9M
         8TFFSTDs3S7v92PyOTjnKQ8GEZ2dEzHf78E6gqRmwYEB3iKYI9WFe/A11YnM0721+fIS
         TnnUlOGGibySpKxGEfYzeCrnu8VFThv9Z1L3dT1dQO+Qj9/KIh60uPyVAkfuGPTLNZMF
         H8XIN7c0ayA71dnSgE94xMc52WfhW1bNloJ3lOS9TlZwXyuzMMG2VkYbXa0A62l+piAA
         MubP6roK5uB1YokB90SZAQcAg1XH8ga4vuUBzThZylX1+NRh2nzGXXWZfc8Zp7TZpRL+
         iBIA==
X-Gm-Message-State: AOJu0Yxcin6qgNR6p6Ju7ENA7VuEkHvXJty3grTOndEPxx6xvK3e1t9u
	zw4qX/7LFKR8FSExQV9LSj6kKfnNFif6JyRSij+RUb4hEMscccljUiki8w==
X-Google-Smtp-Source: AGHT+IE/b7JT3Pr91hHDIQwZT5/vXLt6lNP7yWspRnsMq+L8H/awCdRIRN8/2y73g60DtAy0GXeOOw==
X-Received: by 2002:aa7:d953:0:b0:5af:b1d8:f3d5 with SMTP id 4fb4d7f45d1cf-5bba36ab44bmr1953799a12.12.1723040260082;
        Wed, 07 Aug 2024 07:17:40 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5b83bf3a37bsm7176928a12.88.2024.08.07.07.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 07:17:39 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Lewis Baker <lewissbaker@gmail.com>
Subject: [PATCH v2 2/4] io_uring/napi: postpone napi timeout adjustment
Date: Wed,  7 Aug 2024 15:18:12 +0100
Message-ID: <88e14686e245b3b42ff90a3c4d70895d48676206.1723039801.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1723039801.git.asml.silence@gmail.com>
References: <cover.1723039801.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove io_napi_adjust_timeout() and move the adjustments out of the
common path into __io_napi_busy_loop(). Now the limit it's calculated
based on struct io_wait_queue::timeout, for which we query current time
another time. The overhead shouldn't be a problem, it's a polling path,
however that can be optimised later by additionally saving the delta
time value in io_cqring_wait().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  1 -
 io_uring/napi.c     | 28 +++++++---------------------
 io_uring/napi.h     | 16 ----------------
 3 files changed, 7 insertions(+), 38 deletions(-)

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
index a670f49e30ef..d39ae20a3db8 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -271,27 +271,6 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
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
@@ -304,6 +283,13 @@ void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
 	if ((ctx->flags & IORING_SETUP_SQPOLL) || !ctx->napi_enabled)
 		return;
 
+	iowq->napi_busy_poll_dt = READ_ONCE(ctx->napi_busy_poll_dt);
+	if (iowq->timeout != KTIME_MAX) {
+		ktime_t dt = ktime_sub(iowq->timeout, ktime_get());
+
+		iowq->napi_busy_poll_dt = min_t(u64, iowq->napi_busy_poll_dt, dt);
+	}
+
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


