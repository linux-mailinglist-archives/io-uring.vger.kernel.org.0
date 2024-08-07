Return-Path: <io-uring+bounces-2663-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A00994A9E1
	for <lists+io-uring@lfdr.de>; Wed,  7 Aug 2024 16:18:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 835951C20E4A
	for <lists+io-uring@lfdr.de>; Wed,  7 Aug 2024 14:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 305A36D1C1;
	Wed,  7 Aug 2024 14:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qv21fLbv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739725820E
	for <io-uring@vger.kernel.org>; Wed,  7 Aug 2024 14:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040263; cv=none; b=ogeEcDeOoZeY0iR9Gh7fCpppvOhrgVyxbJSCWZIbFXUuoFQ3sJMNqscpSnMAWH7i0Jc0wDJoXVgu8k1Gyz1b01ZQe0GFc230BT4CXv7J2JMsRNW4H90ghd6h627JPUx7RQHvPwYPvUafvoOV45vT64XtQBw4PwFUFYYu2dpcWHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040263; c=relaxed/simple;
	bh=yMnMp6sYGz4/6Z7wV25uL/n2ygpp95FpW6CIeQqXrF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtksAQrvohDIRNZZg+mLSi9OBjUmS0eSPHtkDAUYMR/vl/xBPoWKVX37FeUsTc7e+e8pdQktu0NBbIhmlb8fBP0MhGS+Yw1d3V9fYdVq3WOgwf0K79I1fWk7chYQGTBFSval5fLmNqfG/6bv0O5PnhtrItXTlHZ6cba7e6LgIhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qv21fLbv; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5a108354819so2445513a12.0
        for <io-uring@vger.kernel.org>; Wed, 07 Aug 2024 07:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723040260; x=1723645060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aCDFSYLRz664AJ+uUNg7sg3G8Ma7AxzpoUVwna2Z1b0=;
        b=Qv21fLbvVonDg8pOkNtluTdcz1xxnFJl8DAKXjyEX9dIbu9TR0Jp56PdFDEKxmZ26I
         UTqel6ETRANTH1Kuj6zDy4MJNm29GsX6LkpjD4J79PTqdXXulRgl2rQxKAjhAT9xgoRM
         Tr0NXfk9eZv1qljG5Uzax/1IaEIEFXAkUtLgnvl2/ApiOIImyViYSUQzDAmJsItHQPYU
         C4xEG9jCsAs8mEMRsgGKlsdmQGksv6aNjmPH10Do9A2fDmye4OhnerMsLYNWsfuzX4IT
         A1Hc7qhxBHHB5EFkWnE1g9T9L94kVeHvub1jYKcR4Lbpy2bLrdXmvLncrsbAOW/6hbqW
         eteg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723040260; x=1723645060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aCDFSYLRz664AJ+uUNg7sg3G8Ma7AxzpoUVwna2Z1b0=;
        b=kIaQsxsiqjd/WReUOR8vueo6nG9PazTeBRT3IkeQbrycfaZuXI1ok+5wEpM5vwa687
         ngy7/++Un+GmdLe8hEaeGGz5inele4QRP+15kxVln867hsnXIuCOSfYr7DyCRhMCUJ+q
         iaF/y0PbB6sa+mM9dBkPzrdG2x8rbONBQjOIC1lYSbUpO6WsBuih67Fu8BsKjdBf76H8
         tGVCgjx2tmrof2P3ERuGWiyDyZOD32BCqXGWPvXZ3CYHJUuaO49qbm6uJeUdMoimrBQU
         cLkcBgM9R88+5Zeylj2vbe2/xFHnU7GUAvybOiXuV1AruvEqtoGsz1K1vshbrjuaatPV
         5zNg==
X-Gm-Message-State: AOJu0YyfjWx/fMF3QUpRyxeoWmiCO8ps/mUBQ6WxwHueeHu34dl3rEQz
	2YuFfrB/TLqDoztOfAznxohGKcMrRzcKiKk1sSvuxka1nvcC3ZoVyXStEw==
X-Google-Smtp-Source: AGHT+IEaSrWL+TV0mKJWa1lWd1/aGzHypK8qXU6b1bHsupGG92k1WyW+r1xpxjS8roqUjPWdnhUFwQ==
X-Received: by 2002:a05:6402:1a42:b0:5a2:2ecc:2f0 with SMTP id 4fb4d7f45d1cf-5b7f36f5964mr13223321a12.1.1723040259134;
        Wed, 07 Aug 2024 07:17:39 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5b83bf3a37bsm7176928a12.88.2024.08.07.07.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 07:17:38 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Lewis Baker <lewissbaker@gmail.com>
Subject: [PATCH v2 1/4] io_uring/napi: refactor __io_napi_busy_loop()
Date: Wed,  7 Aug 2024 15:18:11 +0100
Message-ID: <2ad7ede8cc7905328fc62e8c3805fdb11635ae0b.1723039801.git.asml.silence@gmail.com>
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

we don't need to set ->napi_prefer_busy_poll if we're not going to poll,
do the checks first and all polling preparation after.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/napi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 4fd6bb331e1e..a670f49e30ef 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -301,10 +301,11 @@ void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iow
  */
 void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
 {
-	iowq->napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
+	if ((ctx->flags & IORING_SETUP_SQPOLL) || !ctx->napi_enabled)
+		return;
 
-	if (!(ctx->flags & IORING_SETUP_SQPOLL) && ctx->napi_enabled)
-		io_napi_blocking_busy_loop(ctx, iowq);
+	iowq->napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
+	io_napi_blocking_busy_loop(ctx, iowq);
 }
 
 /*
-- 
2.45.2


