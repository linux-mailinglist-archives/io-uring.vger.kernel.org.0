Return-Path: <io-uring+bounces-1486-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 608AB89E7C9
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 03:27:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78DEB284392
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 01:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E7DA55;
	Wed, 10 Apr 2024 01:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M9u3eUcV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9378A1388
	for <io-uring@vger.kernel.org>; Wed, 10 Apr 2024 01:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712712436; cv=none; b=aeZrnyCelTcGpdksvnlklCfQggu5P9I2iDO3X8bhGwPyYbL3UtMiFPibVMPB2QPDDD5O2psZ1axe6YjEmOBKe/E032kP+RJdfvr9rFYkeX0P/4A9V+H3IYa6E5h2cMAxVOoKLA7erHb+LXjJ1kA/a1nN9Op7kp0iVsM2dY2Pzfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712712436; c=relaxed/simple;
	bh=S4NaWumQkuVUStYPiLt2TE9vK9XhYW42xTwrzgxFUBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjNRDohumBest+mfrP9iZDBg/dCh258YVNS8NDEHdhA79/hRTYf3YqthuVrGqWQLOP66K/jU57nfIlYWeVWWV8kV6kGzANqJSNT+xV5kq22l7jqJ4NOpJi07rFzeKPJ9D4/2m0kSZwZ7sZc7oBgR5SqjP5Rf/xkKyL1kO7Yhc1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M9u3eUcV; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-34665dd7610so99350f8f.3
        for <io-uring@vger.kernel.org>; Tue, 09 Apr 2024 18:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712712432; x=1713317232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HUT3VaoONdExdEm2PmzG4eWlFh4iS4s0PUvVjZnVNPk=;
        b=M9u3eUcVZKo/jAKOJEGn1z/bPZWHOhiaqWMsIJyX/xlV/gbuAetKqUip9x2JJ0B7PD
         GpL02dctVFlkVeCyTaJhEBtPT2jaE7Y4uGtPuE56Kf6YRRg8jUbtK+CpF1vC8uAWfnGn
         OPykLZdbrXpTM9CCRHyyfVF3Q9+98S52YQ62GLQNvgXk6R0qvWohsxCQ8jBO5DDifYZE
         iONzh4wTu04etQdAasJfMa81qQ5h6GJDSHheW8KRObzlyKotw4PU00/voY27Dr79RP/t
         2g2xmzC/WXv3OZWXVLvFs4w6FvHAUPonqPwzISFxFopzKRkk7GV9hVLe7SvqeyTEOdpX
         Z/Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712712432; x=1713317232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HUT3VaoONdExdEm2PmzG4eWlFh4iS4s0PUvVjZnVNPk=;
        b=PuwUlWH4y/Ibjtl7yC970SLdP6IvA0+T9HCgqMMozeVcL8Nvjm+69HyiUV0ojwyCoC
         ltyqj1PWjgAX2T24GWxaVPNNmN0reP6tNWCfm9UJe/QG6H8J+xhlJBQ420wS6LsfSlzB
         ThF7WJK8JHHZcJ3+G2q8ivhj9in+PQICykbl7Gi4Frbd+Sc6yaAjwtva4ZmwMcNoi6Ba
         h5D4kn1KroLV5LYJGmMZh3OJ+TOGl5x89mT55INfei5vLuWAlcm/gw6uLztDCFOKtwOh
         VkDBYHyaR9BfMnaowrmyCgyTqpqoFpfg3Be0e1NXsHyn5/eE2JIVARyNEZKwX4YU7YoZ
         PCbg==
X-Gm-Message-State: AOJu0YyBs/OSVlAAUElfVQPUGt7P7RvomMI7qZAPeQVdH0hwBV1Eon3D
	7SkocTYxZt4VeHv2QFAlkzPCm179THZBp0s4Am1uw17DjDpvllFZZdPTuizr
X-Google-Smtp-Source: AGHT+IG2h0/oPUulM0TF1mLS1gnMHcNfhHejxtqOTQnHl/ZDXH9LrW7dsw7bQvonrDSRf2sKJMOdsg==
X-Received: by 2002:a05:6000:1549:b0:345:c359:d34a with SMTP id 9-20020a056000154900b00345c359d34amr886618wry.59.1712712432295;
        Tue, 09 Apr 2024 18:27:12 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id r4-20020a5d6944000000b00343b09729easm12737693wrw.69.2024.04.09.18.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 18:27:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next 4/5] io_uring: always lock __io_cqring_overflow_flush
Date: Wed, 10 Apr 2024 02:26:54 +0100
Message-ID: <162947df299aa12693ac4b305dacedab32ec7976.1712708261.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712708261.git.asml.silence@gmail.com>
References: <cover.1712708261.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Conditional locking is never great, in case of
__io_cqring_overflow_flush(), which is a slow path, it's not justified.
Don't handle IOPOLL separately, always grab uring_lock for overflow
flushing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9424659c5856..d6cb7d0d5e1d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -673,6 +673,8 @@ static void io_cqring_overflow_kill(struct io_ring_ctx *ctx)
 	struct io_overflow_cqe *ocqe;
 	LIST_HEAD(list);
 
+	lockdep_assert_held(&ctx->uring_lock);
+
 	spin_lock(&ctx->completion_lock);
 	list_splice_init(&ctx->cq_overflow_list, &list);
 	clear_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
@@ -689,6 +691,8 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 {
 	size_t cqe_size = sizeof(struct io_uring_cqe);
 
+	lockdep_assert_held(&ctx->uring_lock);
+
 	if (__io_cqring_events(ctx) == ctx->cq_entries)
 		return;
 
@@ -718,12 +722,9 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 
 static void io_cqring_do_overflow_flush(struct io_ring_ctx *ctx)
 {
-	/* iopoll syncs against uring_lock, not completion_lock */
-	if (ctx->flags & IORING_SETUP_IOPOLL)
-		mutex_lock(&ctx->uring_lock);
+	mutex_lock(&ctx->uring_lock);
 	__io_cqring_overflow_flush(ctx);
-	if (ctx->flags & IORING_SETUP_IOPOLL)
-		mutex_unlock(&ctx->uring_lock);
+	mutex_unlock(&ctx->uring_lock);
 }
 
 /* can be called by any task */
@@ -1522,6 +1523,8 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 	unsigned int nr_events = 0;
 	unsigned long check_cq;
 
+	lockdep_assert_held(&ctx->uring_lock);
+
 	if (!io_allowed_run_tw(ctx))
 		return -EEXIST;
 
-- 
2.44.0


