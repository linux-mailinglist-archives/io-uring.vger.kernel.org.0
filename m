Return-Path: <io-uring+bounces-8014-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBA68ABA480
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 22:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45EA1A2613E
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 20:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FC0922B8AA;
	Fri, 16 May 2025 20:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UoXT4NWK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADEC22CBC7
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 20:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747426220; cv=none; b=l0jy2VYjTB8Z/vEHfxwlTgVireoCdMyU1HL7yTSHoBL+tv/nmgHSOyFbt58vMZ432xC74QfyM2N+PT1DmrkqlaeV6SXa7Z+3Os0+q0aH31yFlQGwq3OR8wV2jxXFyOiwwpCTWGH55HPMiyK9llpWRZWXXBaptF8YP6/ps3qqcuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747426220; c=relaxed/simple;
	bh=vENkS8ISAkUs5e5OKFysrC3uwCh1R7s0wnQKPJv7e8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKgqDyWfl4AIThNs0UAzWXtLVY0m/YAvRhPZu0/J96bOVEuKdKapXzZNbdUtc0P78iVytoO5axB3gHQCk3BVY2TK/6X6OrKXKWWwibcV8OrjfHBcJEyUaAok/rZCSqvOKfaBP0CjXU12Zel8yCmAfQboRoTEwg+lo/aFMThd7Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UoXT4NWK; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-85db3475637so120636939f.1
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 13:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747426216; x=1748031016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EXDesRyJ2WzD85C5aKaly5GX/a+tJk0Ov0yfZ33P7iE=;
        b=UoXT4NWK9phptKJgWjx/Xy9rs5un26LGroX2JrtZ+9tof31sUlQzydIOA9JwR9MBnD
         K7Ns4V/7tFAgjYIdWbq5xHCVfhcWxwQVY4pFbjtsb3iEy7lxVJgBNfqB4enrmKwZzdTp
         BgbXlDGDej0o5L9Jrfpg0PQ78G4Dnvc2c58DbJWY5CfrhKjoQI/O6g1/7VdozHB6IstP
         61Wi5zKEQ8gCfTzKra0UOSCJUj8/sgBRDh02YyNhbwGFSse3tLMsrvDBiMWRp0mFGZNd
         G749ISzbonontg2gunCozrkHKDN1DuuBF0cePlBJCyaZXGCz97pv6mKIsQBg/hldnhyg
         5mkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747426216; x=1748031016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EXDesRyJ2WzD85C5aKaly5GX/a+tJk0Ov0yfZ33P7iE=;
        b=EE+ID3xxhSKBt6IOOZtzVmW1Zq7m7bZc4LlMzpA/p/AI59ZFcFdtmj8kE2QcDEb0sR
         gRk1ZM3wkwJ/IBIY3h8MbbMG1ZLdnEOu93Jjr4PHN81CLbDmDG00hej36DtfHvI+Eqpc
         VgtMc/UpR5nvOtcB7UPJmWyBbz/qMnLG4pNtOQ6qjPaSisXvxLzWg0Avja6ywpamSgD1
         MOt8i1tYJeUT4rxm9DQLEE1+NDI1NcNcgWkFGRy4aZmdBZnuM/RmprROes4NCdkw9RCJ
         qg6AkHsRZQXWPc3l9iqmedYaLoUAxWj5hHmJvs6Y76/C2FdMCsDnJFt+TJSyfxjFgtdQ
         gN3A==
X-Gm-Message-State: AOJu0Yz5FWdRsQesruP74Vq4wLWtLTugrXot2p4gooOA+g4/FELGxW8G
	PFsJOqMMFuUTIi0cDmPFj4GcaGpFCeOThbDL+iW6hotWHkvD1zeu9kZsfgvYLVNoHvp/FdXUgD9
	DxHWE
X-Gm-Gg: ASbGncuSvBHIXf7DjXl+xFtGulJOAJCJk9gPfzcQCjO6ekugI7dzaq+/twy4IZ1YP1I
	Cj+23eDCkyOYkzNk884Yu2cb5kGaGRvMO6K3Jp4wdr/VlVS0rwXxyRLDzVOW6l98TsRHorageui
	e//0VsHyfLCcyKSqdZjg7X2yTK7CxwfP9BOCeNM2Q8Dk1+DKNLCg/lS3zTdMRM5/b2ycNY0xm7h
	XN9th5SzfT3BvcJzt820LheEDn8Xy9kCAxo5fbOQzDkf1vGDUVguMuauVPkvnc66G1ZvhD5h45N
	AqPpFMdSTLD4Yv6CoYR5ya48vB+Zr+72zLrCxNCAFPQfc0JDRmvT4yvF
X-Google-Smtp-Source: AGHT+IHdOAITS+Bb81GioiAh3xfaXmqifvTwItJk8sMvDlrBxHoeoB7AomARPr0PzfuBW7jDPgbW7A==
X-Received: by 2002:a05:6e02:1a6e:b0:3d4:346e:8d49 with SMTP id e9e14a558f8ab-3db778fd61amr118980845ab.9.1747426215921;
        Fri, 16 May 2025 13:10:15 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4ea4b5sm541805173.136.2025.05.16.13.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 13:10:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring: make io_alloc_ocqe() take a struct io_cqe pointer
Date: Fri, 16 May 2025 14:05:08 -0600
Message-ID: <20250516201007.482667-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250516201007.482667-1-axboe@kernel.dk>
References: <20250516201007.482667-1-axboe@kernel.dk>
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
index b564a1bdc068..b50c2d434e74 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -724,8 +724,8 @@ static bool io_cqring_add_overflow(struct io_ring_ctx *ctx,
 }
 
 static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
-					     u64 user_data, s32 res, u32 cflags,
-					     u64 extra1, u64 extra2, gfp_t gfp)
+					     struct io_cqe *cqe, u64 extra1,
+					     u64 extra2, gfp_t gfp)
 {
 	struct io_overflow_cqe *ocqe;
 	size_t ocq_size = sizeof(struct io_overflow_cqe);
@@ -735,11 +735,11 @@ static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
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
@@ -806,6 +806,9 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	return false;
 }
 
+#define io_init_cqe(user_data, res, cflags)	\
+	(struct io_cqe) { .user_data = user_data, .res = res, .flags = cflags }
+
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
 	bool filled;
@@ -814,8 +817,9 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
 	if (unlikely(!filled)) {
 		struct io_overflow_cqe *ocqe;
+		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, user_data, res, cflags, 0, 0, GFP_ATOMIC);
+		ocqe = io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_ATOMIC);
 		filled = io_cqring_add_overflow(ctx, ocqe);
 	}
 	io_cq_unlock_post(ctx);
@@ -833,8 +837,9 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 
 	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
 		struct io_overflow_cqe *ocqe;
+		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, user_data, res, cflags, 0, 0, GFP_KERNEL);
+		ocqe = io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_KERNEL);
 		spin_lock(&ctx->completion_lock);
 		io_cqring_add_overflow(ctx, ocqe);
 		spin_unlock(&ctx->completion_lock);
@@ -1444,8 +1449,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
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


