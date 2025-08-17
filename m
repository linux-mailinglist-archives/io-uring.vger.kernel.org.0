Return-Path: <io-uring+bounces-9003-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B87F8B2958F
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:43:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAA834E7C9D
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C3022A7F2;
	Sun, 17 Aug 2025 22:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j3IC2ekW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CAC1DD877
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470597; cv=none; b=cqYnCx+PL/qrgeA0vehaXMjpEUY+VTT9UTSykRkUZeFn+gWY/PaDE1LYuG+/zzc2ctwrU+QyYvUcwWMpOHuwUNdQCFa4zeNWQLkLM7kqU3OpbUytB2oTqtVJMju1cNwBRP2qcAKAb23b6sXNmvtSYYZsqoLne3WGw5OWaWJVF2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470597; c=relaxed/simple;
	bh=AddHNsszyBFiR/Fde8xfP3g8TpGmVRkTOZi+Ep8bckQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYPFaZCAtQCX1+y8iSHZVvOm9IVtuuRq7CMqlK/sdfbYH8qPiDg7YkNPDg1vmHhghAHrXqDwzOB7eAokBIbQkYQntuXkAvqi5rsdvNHa0Sdm8OSE5+ct/5pUyhJdFRZpWh3KYB/k5YFt/7hv6Cvxa+m9J6gqVz8A991NvNGrg7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j3IC2ekW; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3bb2fb3a436so1860397f8f.1
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470593; x=1756075393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6eLcFdThddA45i2wPb1fmMZEJXVOF3np+Lknwyg+kxg=;
        b=j3IC2ekWjGnyeNm4KDHPbfnfnE54GnGtgVGWTW1sT6IhHedDosvRwqtI3ocyICeQY/
         fu8L/DsOzLP0Est9rtAeBqg7erYHpQzUCdrnz9bbZoSzLd+O8xiBzarTfL2oXDJsQ/kx
         2haH98ii5zjr6F0ykjoJT2rNNITFeDwTkgFNHfhUeNrGZIBwpsTnXuPriMxl/VoNkvhW
         X/CDqv6dd5JSO3eQpHk4VO6ERKUAGN+s4avRqfZSxZH2EMS9A6VDBJUvYelCv6+G47It
         1Sja6UX1d8ZRQlqk+8UEWyi+3yM1c3pw2kt79/3BHkJF9+RwjxkaFUNhZSMXlWlUhaAf
         F/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470593; x=1756075393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6eLcFdThddA45i2wPb1fmMZEJXVOF3np+Lknwyg+kxg=;
        b=ft/1rbNPiX1T+BSFoL8aJkoEixa43O6biEWPsX3H+Vm/8VQ1IrWnzKPQ6sgtDTh3cz
         3O6vAPjtBUWxWRJDdYCgRa8l6QTM1RnF+QUV2xshIxVwn1+EXlt9qfbGxvyOT7vukvBE
         H8lTMemTyaHJGdojF3iPi1jrXIoqg0nuRsU1cevRgfF1rDZ5a6yO+/yZ2Zoi4vZM82Yc
         sggLAvfEueDHdab+ozTqYIzY76xHfruU4/5zgR+BnITnw7E5Bw68DIlpjv89CGXQciTG
         R+eam52lfdHl3bzYcmyOX7Oh4JS6XtctvSDK6jM1e7LBBwKA0h2Dn9lNTrhd3xnoQjLD
         yRBA==
X-Gm-Message-State: AOJu0YyUulJ5hzHnaYLl13o2cRX+iyISJqpqyiJ8PfM+wy92CMbcRLvB
	8iCtfBdofVFqvvXdk8ya1JavEcQ44u3XUOjno8QrkZ0rxuigiCiv3GlLPjLKIQ==
X-Gm-Gg: ASbGncsvi4DBklbpTdku1BbqtdfCT7LSFW2kjcqmj7BnwPxSSuZRnUY/LwXqQGaqYKV
	C+DUKMGAfCNQPYSNDdi/lHMpnyiqOKjisfdWQoMu3Y+VGotVTmtzJVc4wMJNJ0Q2SSJkq8i/9C0
	bd4F694M6cS0lqmwxc4cWcfUbhlZGmWzCYVQl35CFvr98OWai38ciqbufoQsbx/vVEOBAaydsbf
	mll8oXsB34o40JVlJowRBFwlRFpMh3mdVEjTtowredVAfiY3GplC9+tQCB3PblkePmCZa7rRfSL
	f9bf0KrYqB/kUZ/bm9twDbM5mc4UJZLdNMCmYsBn7iChoDPBlZ2rAeBv6hEL6h+t+jjiKLTPOkb
	ejH6TZ28iI89+fICe3qv1KIxsr4qtJ2/sVQ==
X-Google-Smtp-Source: AGHT+IFrOQfTFvZGG0AUeixi7Gnigdtc8tMN88EUH7P0yYz54kCgbzWkZrypCaNFQi+4nBk+pVAE0w==
X-Received: by 2002:a05:6000:2501:b0:3b7:8af8:b91d with SMTP id ffacd0b85a97d-3bc69cc2bd2mr5110834f8f.35.1755470593183;
        Sun, 17 Aug 2025 15:43:13 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a7fsm10554786f8f.37.2025.08.17.15.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:43:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 2/8] io_uring/zcrx: move area reg checks into io_import_area
Date: Sun, 17 Aug 2025 23:44:13 +0100
Message-ID: <913d79dca00fca67bb1e7c28e25114809542f393.1755467608.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755467608.git.asml.silence@gmail.com>
References: <cover.1755467608.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_import_area() is responsible for importing memory and parsing
io_uring_zcrx_area_reg, so move all area reg structure checks into the
function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 1c69c8c8e509..ea62e13b9500 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -26,6 +26,8 @@
 #include "zcrx.h"
 #include "rsrc.h"
 
+#define IO_ZCRX_AREA_SUPPORTED_FLAGS	(IORING_ZCRX_AREA_DMABUF)
+
 #define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
 
 static inline struct io_zcrx_ifq *io_pp_to_ifq(struct page_pool *pp)
@@ -231,6 +233,13 @@ static int io_import_area(struct io_zcrx_ifq *ifq,
 {
 	int ret;
 
+	if (area_reg->flags & ~IO_ZCRX_AREA_SUPPORTED_FLAGS)
+		return -EINVAL;
+	if (area_reg->rq_area_token)
+		return -EINVAL;
+	if (area_reg->__resv2[0] || area_reg->__resv2[1])
+		return -EINVAL;
+
 	ret = io_validate_user_buf_range(area_reg->addr, area_reg->len);
 	if (ret)
 		return ret;
@@ -376,8 +385,6 @@ static void io_zcrx_free_area(struct io_zcrx_area *area)
 	kfree(area);
 }
 
-#define IO_ZCRX_AREA_SUPPORTED_FLAGS	(IORING_ZCRX_AREA_DMABUF)
-
 static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
 				struct io_zcrx_area *area)
 {
@@ -394,13 +401,6 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	unsigned nr_iovs;
 	int i, ret;
 
-	if (area_reg->flags & ~IO_ZCRX_AREA_SUPPORTED_FLAGS)
-		return -EINVAL;
-	if (area_reg->rq_area_token)
-		return -EINVAL;
-	if (area_reg->__resv2[0] || area_reg->__resv2[1])
-		return -EINVAL;
-
 	ret = -ENOMEM;
 	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (!area)
-- 
2.49.0


