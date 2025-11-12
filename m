Return-Path: <io-uring+bounces-10542-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 162B0C52549
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 13:52:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A4763ABEF1
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 12:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C3CA32BF31;
	Wed, 12 Nov 2025 12:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mJTt9O8/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D47330B3A
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 12:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762951583; cv=none; b=BGVE6fOUXPDcvnbPIwec1P0t5AgbnS7vLR2sIKqAUuwsBySWfwYmx3OL2rC1XRXDJDeryfEeYZ3FSBDLjiB2BV1a5rbydC3JJ5/Fe50Iexe+P+AN1rLTKC2NOK4bA6PzuIgnXV6v7JYJ6jjKvtWwHiaFEt96iVmNSVUGTmKi77c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762951583; c=relaxed/simple;
	bh=1GjY/O/cU1i0SxhapXCY3DHO5N9kt/UosAP3IeJeslE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sj0HwyhDraZP68bLtyqRxoSPaYJIVC6mMzEaeYj0xzkcpd7ealwzSJF+IJZfhXWtDnP49t7PikHeCsxXU+BRojB52ZH3NBBjf1Jt8/gZyji50N/uOZbeG6bDzFAFYDODh4DofYj3Ypr3sXoY+aJidCALzP8vcFQxiqFPgWdxRuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mJTt9O8/; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47721743fd0so4447025e9.2
        for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 04:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762951579; x=1763556379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nyfc19tp/B3BkckABBi9ANMajlpIrgmdKZKgjEVepOU=;
        b=mJTt9O8/Hs4mf8eCS+1tTfgu7afft9fSicqCkkZwlpdkBqXbUa62YhaLuPMt7eN382
         2RGfNzvZgyUD41GprDH79Q+TVbdUHDBpE6xoWseejKNl8pikdM5WiAz9JsM34unDk0fg
         Cb1F379x/qFTIVFUozXru9lyoPwJPb0542ilEz4K74sC3rS+zj9Wts/Jzde+Zto7kjvY
         pl0j304h0nEd++z/ofSS5pQiWLVc0/p/Bcp9tx3O2doh9MZ1xS2zNUYktXglIEFRiOil
         J/AOV2ReCEm+0UnrdIgERAwBz4aRCi0OlKX7dsyvME+AICACyJq4Ri4qJWWxWH4ezSp0
         eeQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762951579; x=1763556379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nyfc19tp/B3BkckABBi9ANMajlpIrgmdKZKgjEVepOU=;
        b=Cip0Mhpp3wl5km5PRtEtfb134Hu08iZdECAf8KukEBE4CODZ1Rf9YZPi+kC1fjv0Rq
         TtcjTPLKsuFaXBwYLAuq64hRq5hRzAL5xnUIox7Bs2qvD6xvCH4/Cf8reWsWCqTyGUb6
         lLZIR5JffvUPN8pxFl4JqjVkHBpQZKAEd8mFGZyS50CDTZ5YO0sKrw2N5MCdUP/E1rsE
         GFMg8455XTB4tKOUILka5RmzWmdSyNFNexmrz3xhlaTiQIMWLxKgCKjCcLC0SASi4YoE
         RgrEE9Iav8UXrn2Wo00CwsPXdiUWItwiy3dMlnpshW2Rk/jKucWZXE8q5hXCRVkJX639
         SfvQ==
X-Gm-Message-State: AOJu0YyiH/tdPJvBQq31FsgA8JppWwhkocnAlQpZstgBkWMGmy17gvSa
	fBEeyEk4ng6xk7TrvV3+jjlz/4l92BcVrkYo113bV0gtxOHL2ND57zhrEPwuGQ==
X-Gm-Gg: ASbGncudb/BWQcA57k40tWWrEsp57t5DAde66vW6uEzmegf/UG1KL7rxJbdPAYvuuUv
	8lW/Fh7O0InAcPMzKAZfo6dFDj/OjGuUe5maxaVislXJ+dChtJv8GY9yRu62uDtmCVac7KepJzF
	X7KpjB4JrTc03KViiOfaKE4Q6l7xpi3lV/jQdTwMlNkTzvTdwAAJJptZS3qjy5BtL/AMWIspjl8
	ztYHLIR+GZGYs0I3kCDeflMvQO3oARCiiTuHlm1q4H0/seIxzHZapsYibQD2iILcn++bYiK5Vo8
	kgfDvmA0INCsAJusvjiAAp44H/mAg30t3nM0DW7P9DEISb1p28ns0KZhbGdffBnkfey/5xEPzBp
	7jM5+UQdfUCCNUNXrgu1PsI56h6uulR1ovs5KDACL/1A3xJfxqw4SuvX9owA=
X-Google-Smtp-Source: AGHT+IHKu3ZgadUyzW/TBmbeG1kEzQQlkiKcoWkKBhYzOyOtmcoDrDehkbRCnPqw+x5bqdPgNUiHOg==
X-Received: by 2002:a05:600c:3b0d:b0:477:7479:f081 with SMTP id 5b1f17b1804b1-4778707b6b9mr25751905e9.12.1762951579185;
        Wed, 12 Nov 2025 04:46:19 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:2601])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e58501sm33846795e9.10.2025.11.12.04.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 04:46:18 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 6/7] io_uring: pre-calculate scq layout
Date: Wed, 12 Nov 2025 12:45:58 +0000
Message-ID: <c4163a72841f4e6e768aebea2e55eeffa7873f16.1762947814.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762947814.git.asml.silence@gmail.com>
References: <cover.1762947814.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move ring layouts calculations into io_prepare_config(), so that more
misconfiguration checking can be done earlier before creating a ctx.
It also deduplicates some code with ring resizing. And as a bonus, now
it initialises params->sq_off.array, which is closer to all other user
offset init, and also applies it to ring resizing, which was previously
missing it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 27 ++++++++++++++-------------
 io_uring/io_uring.h |  3 +--
 io_uring/register.c |  4 ----
 3 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1dfd0a8a7270..d286118dcd9d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2757,8 +2757,8 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 	ctx->sq_sqes = NULL;
 }
 
-int rings_size(unsigned int flags, unsigned int sq_entries,
-		unsigned int cq_entries, struct io_rings_layout *rl)
+static int rings_size(unsigned int flags, unsigned int sq_entries,
+		      unsigned int cq_entries, struct io_rings_layout *rl)
 {
 	struct io_rings *rings;
 	size_t sqe_size;
@@ -3353,10 +3353,11 @@ bool io_is_uring_fops(struct file *file)
 }
 
 static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
-					 struct io_uring_params *p)
+					 struct io_ctx_config *config)
 {
+	struct io_uring_params *p = &config->p;
+	struct io_rings_layout *rl = &config->layout;
 	struct io_uring_region_desc rd;
-	struct io_rings_layout __rl, *rl = &__rl;
 	struct io_rings *rings;
 	int ret;
 
@@ -3364,10 +3365,6 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	ctx->sq_entries = p->sq_entries;
 	ctx->cq_entries = p->cq_entries;
 
-	ret = rings_size(ctx->flags, p->sq_entries, p->cq_entries, rl);
-	if (ret)
-		return ret;
-
 	memset(&rd, 0, sizeof(rd));
 	rd.size = PAGE_ALIGN(rl->rings_size);
 	if (ctx->flags & IORING_SETUP_NO_MMAP) {
@@ -3378,7 +3375,6 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	if (ret)
 		return ret;
 	ctx->rings = rings = io_region_get_ptr(&ctx->ring_region);
-
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
 		ctx->sq_array = (u32 *)((char *)rings + rl->sq_array_offset);
 
@@ -3560,6 +3556,14 @@ int io_prepare_config(struct io_ctx_config *config)
 	if (ret)
 		return ret;
 
+	ret = rings_size(p->flags, p->sq_entries, p->cq_entries,
+			 &config->layout);
+	if (ret)
+		return ret;
+
+	if (!(p->flags & IORING_SETUP_NO_SQARRAY))
+		p->sq_off.array = config->layout.sq_array_offset;
+
 	return 0;
 }
 
@@ -3632,13 +3636,10 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 	mmgrab(current->mm);
 	ctx->mm_account = current->mm;
 
-	ret = io_allocate_scq_urings(ctx, p);
+	ret = io_allocate_scq_urings(ctx, config);
 	if (ret)
 		goto err;
 
-	if (!(p->flags & IORING_SETUP_NO_SQARRAY))
-		p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
-
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 5e544c2d27c8..a790c16854d3 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -27,6 +27,7 @@ struct io_rings_layout {
 
 struct io_ctx_config {
 	struct io_uring_params p;
+	struct io_rings_layout layout;
 	struct io_uring_params __user *uptr;
 };
 
@@ -147,8 +148,6 @@ static inline bool io_should_wake(struct io_wait_queue *iowq)
 #define IORING_MAX_ENTRIES	32768
 #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
 
-int rings_size(unsigned int flags, unsigned int sq_entries,
-		unsigned int cq_entries, struct io_rings_layout *rl);
 int io_prepare_config(struct io_ctx_config *config);
 
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32);
diff --git a/io_uring/register.c b/io_uring/register.c
index 98693021edbe..110e978b872d 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -423,10 +423,6 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	if (unlikely(ret))
 		return ret;
 
-	ret = rings_size(p->flags, p->sq_entries, p->cq_entries, rl);
-	if (ret)
-		return ret;
-
 	memset(&rd, 0, sizeof(rd));
 	rd.size = PAGE_ALIGN(rl->rings_size);
 	if (p->flags & IORING_SETUP_NO_MMAP) {
-- 
2.49.0


