Return-Path: <io-uring+bounces-7999-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A68BFABA164
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:59:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 473C350369A
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 16:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63ED6215F50;
	Fri, 16 May 2025 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uOQO70YO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11276214A6F
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747414531; cv=none; b=KxQciajK7AGxxnKfDrc0ZjQfabSCPpBlcDkkGgJHmndx07lw/iiMOJA9PXlHXZo0nWdyFV8wgnu63x9ZKeJWj+nwE0fnWc4CczgpFTUA58FRUswfncAbONF5iMLavzV8sTpPO6wMAz2sE4o3k8JDXNpoKHMY+S2Lv2BTP9WdDW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747414531; c=relaxed/simple;
	bh=zxxWX95VOwuFr8kuds4tHklzid5FNPXISR/zEU8FxtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjVGB1Rgj/St/Weg2ZDRlsVB2a8Gwv9qSaFiLpgxm1Q1I1MWnhZDtqmiwx5IFdc5nmYn7wZfTNACWeqMwo5stIFhLOouknKOsEApXUVMiwCAejsVRkbJ0EkYcDJHIQFxehfK3NJRtZEv7NVESN/I2/RCEAY0MEx5ctsV2EucwQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uOQO70YO; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-867347b8de9so115127239f.0
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 09:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747414527; x=1748019327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q8OUqs2V1+70r0bu6Lo+RyvwqbXVKbiLyBMbcdRRYK4=;
        b=uOQO70YOtoCerbzxRjUvVwueHQDAykbu1uBH9jLvmCTkLO3kGj2/fB51+MmjpZPLbA
         5MndwYV02OQpmjuHzl7fdNIELasY9phKQLxVqs7Z4w9o1Pm06gEHDogwAYbZvEcrS0Ag
         cQPCSiEmW2t4qI/mlVJP8UfF/IaVyu9owLECD/fFMVKS55nwuvXEoQYOwuvt8sAmURf3
         gHDgs82Pcb4jwATdhlu8upqrF4GhaiVuwcsPJ6b11O0aKQjStqlAlVhcrEpKaJSRnHsM
         /kOyCDAcfoYz+64kiKZYxr2+x8UsztfNLBNUGg+qbG2HhHrWjuvOc8fyl3iCnYp5qfl4
         b5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747414527; x=1748019327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q8OUqs2V1+70r0bu6Lo+RyvwqbXVKbiLyBMbcdRRYK4=;
        b=jihHMUUHSZZL8WsfwtgaCT/hYCnvImDtTwHnYY250X/Z1+TKYJvLbvzb/Syoe2ysHv
         KGowZgNMRfhRrHs9l/FlQQIVP3ayR9Do+EFJBI0yA7Y0l/1C6kIiSTnLpShHKe5a4igN
         MsGLuHUwLV5oKeRerGZ8lAkIEvu+xqeoWIh2kCqVzlv5Hner9XwSKgHpTrfOnVbppxnO
         EligubrgIId8h3zR+mJW5wIP+I2FG3YuruL4kCx+gA95VgEFRiiLhHuM7DBsLhL5P17Q
         fHz3lNQRRghnVRnVSN4T0uqVcUZ5o6rjQEYDSiPzHRQeuJgqEmAehI9nRQd4gFErpba/
         xYNw==
X-Gm-Message-State: AOJu0YwgfMVFRAasmUdHu5ZHo7BcPKOLs/ji5RoDgDNoAVIO+P+yxIw7
	MvVcCq/AwxxEgtSiqZ4qDBiI3i3XoyMCD+4MOw0N/hvL4zvl0abNi2M/XutuMD5PX8M2FemZP73
	QNJxo
X-Gm-Gg: ASbGncsSp9kLvgUqaCbj7bUtUn986efaKlQ5OX0+U7n69ymOHo9VJFRd/hLalc7paoh
	fRpx5MO6DU6E4tWxu21g3gbUdYKuz/qpBHT2OTR+wTJVLAuoigZrQGnvym7gLlAFtmDkS3Uq28L
	UDQBuQn45R2EDBWBLoCpPfBbOtBgrFZwxflko1Q3K8iKCEOWeUrWb9e11g9vu2dgQe2SEVEIjof
	6B1KYyYAc/hAmYMFpbW3q2riS1+g6yaqT2Jrr1taa0H98hcaWI8L2okw9seiqIUIFRigDYEV+yQ
	hK8RN9jiW+lZDSWEy013khvACbvumijpcXICrUWbAHIgwXXNhrAkgWA=
X-Google-Smtp-Source: AGHT+IH8C60f/zRPlrKMQzz5vAfNdj59yPk/6D2+JAe2cF2RPMoC32qVy2lHqIdJRghdQRQHupfrCQ==
X-Received: by 2002:a5d:9f45:0:b0:85e:dbe3:137f with SMTP id ca18e2360f4ac-86a171bcc28mr816895639f.0.1747414527461;
        Fri, 16 May 2025 09:55:27 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc38a87csm480344173.10.2025.05.16.09.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 09:55:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: make io_alloc_ocqe() take a struct io_cqe pointer
Date: Fri, 16 May 2025 10:55:12 -0600
Message-ID: <20250516165518.429979-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250516165518.429979-1-axboe@kernel.dk>
References: <20250516165518.429979-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The number of arguments to io_alloc_ocqe() is a bit unwieldy. Make it
take a struct io_cqe pointer rather than three sepearate CQE args. One
path already has that readily available, add an io_init_cqe() helper for
the remainding two.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2ee002f878ba..680374bceb52 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -745,8 +745,8 @@ static bool io_cqring_add_overflow(struct io_ring_ctx *ctx,
 }
 
 static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
-					     u64 user_data, s32 res, u32 cflags,
-					     u64 extra1, u64 extra2, gfp_t gfp)
+					     struct io_cqe *cqe, u64 extra1,
+					     u64 extra2, gfp_t gfp)
 {
 	struct io_overflow_cqe *ocqe;
 	size_t ocq_size = sizeof(struct io_overflow_cqe);
@@ -756,11 +756,11 @@ static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
 		ocq_size += sizeof(struct io_uring_cqe);
 
 	ocqe = kmalloc(ocq_size, gfp | __GFP_ACCOUNT);
-	trace_io_uring_cqe_overflow(ctx, user_data, res, cflags, ocqe);
+	trace_io_uring_cqe_overflow(ctx, cqe->user_data, cqe->res, cqe->flags, ocqe);
 	if (ocqe) {
-		ocqe->cqe.user_data = user_data;
-		ocqe->cqe.res = res;
-		ocqe->cqe.flags = cflags;
+		ocqe->cqe.user_data = cqe->user_data;
+		ocqe->cqe.res = cqe->res;
+		ocqe->cqe.flags = cqe->flags;
 		if (is_cqe32) {
 			ocqe->cqe.big_cqe[0] = extra1;
 			ocqe->cqe.big_cqe[1] = extra2;
@@ -827,6 +827,9 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	return false;
 }
 
+#define io_init_cqe(user_data, res, cflags)	\
+	(struct io_cqe) { .user_data = user_data, .res = res, .flags = cflags }
+
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
 	bool filled;
@@ -835,8 +838,9 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
 	if (unlikely(!filled)) {
 		struct io_overflow_cqe *ocqe;
+		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, user_data, res, cflags, 0, 0, GFP_ATOMIC);
+		ocqe = io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_ATOMIC);
 		filled = io_cqring_add_overflow(ctx, ocqe);
 	}
 	io_cq_unlock_post(ctx);
@@ -854,8 +858,9 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 
 	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
 		struct io_overflow_cqe *ocqe;
+		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, user_data, res, cflags, 0, 0, GFP_KERNEL);
+		ocqe = io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_KERNEL);
 		spin_lock(&ctx->completion_lock);
 		io_cqring_add_overflow(ctx, ocqe);
 		spin_unlock(&ctx->completion_lock);
@@ -1451,8 +1456,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 			gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;
 			struct io_overflow_cqe *ocqe;
 
-			ocqe = io_alloc_ocqe(ctx, req->cqe.user_data, req->cqe.res,
-					     req->cqe.flags, req->big_cqe.extra1,
+			ocqe = io_alloc_ocqe(ctx, &req->cqe, req->big_cqe.extra1,
 					     req->big_cqe.extra2, gfp);
 			if (ctx->lockless_cq) {
 				spin_lock(&ctx->completion_lock);
-- 
2.49.0


