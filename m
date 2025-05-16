Return-Path: <io-uring+bounces-7991-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E9FABA0AF
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:15:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE99B189ABA5
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 16:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EAC41BFE00;
	Fri, 16 May 2025 16:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lXhcK4Vj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F25019007D
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747412114; cv=none; b=JyoBCr43rePd7pc1sBT+LkGLuAjZh14EPNQXVAvqzwm8fUl6kunWZgNn+ZpuFUFgTPdLxC6HscVD37TaKAu1GfZWaoextG27HxOvS6JGnscltIElFO/8/jiiGFkgducpc5846/PrP2YzYw6+IdV7RObzR+tr6anMdl7OY69srRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747412114; c=relaxed/simple;
	bh=nq2yum6t4TseGqiXJQ/wFcC3ths+AJEXcoEsq8G2wek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHJJF5XsRhE6eOYeH5L7pWp2t5Cm2Y5kAlEsNUUcI9wteczr6hgXFmIlxAiSrEJtu0Z+GemBqExWfh3ZSi5X+SpsDMPiLMlfpsxtJ8ma4eCWsmici3ykeiqW8uJIB6WYQBp9duHun1LtE2pYWijIYHjMlUHsYTkPczkmtqsQqhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lXhcK4Vj; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3da73df6c4eso17903835ab.0
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 09:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747412110; x=1748016910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ax2QV0y1IxvlHLPcgkPGzd//WQJ3GAdQP1KEJotiNmM=;
        b=lXhcK4VjmGljCUfHLXAMJSkopjmNXpAbX7wwBgWcRXCmiS78V5FDaqgBTCydl+NFQU
         2nKh9PMAG3+mWqujyJusLoa2/w8IvqyIIKil0EUW4+1zKDm4pRowHNqBWpKVwNkOloR2
         /tJo7zwYATVZRTo7LCxvl21Ff397c8d/dbOxElwGj1NdPur0mRZvv3isC1081rvtZk0o
         3c9zrhSqjEkzaclQkWWcB6DTavSTgKF4dbLvKhGDAdz7zEkmGhYU0lp8tq3lVF+h5cWn
         i6/ZTTeZKwxbETdmVA5AVgq01R/3co0KohTWrTGwQEy8s69zXTcY1b3UzdmXS64vZW5L
         71oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747412110; x=1748016910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ax2QV0y1IxvlHLPcgkPGzd//WQJ3GAdQP1KEJotiNmM=;
        b=jnmX8BqjDmzhsR/WsszeDsr8tztK+36YQUDaWMLIyOJyR5xQXghju4XyIjCawYc/99
         PmqcDUZuQ35GUgUipvFp0qfPBA2tjyXa7rbMiiIr7x2d2vtOVMC+mGde4RY77UMGbmVP
         ds0wdST2ySZv6qIeh9lhd+QInC6WyUTq2g+D5ka6Fs9xA5kIt3ELl1+udbg+9KSAXPjS
         5J1C0XIKMXuWKjbGzNu2DKl43TmwsvYXY/FbO9JFpWaxZfLqm2iwFbl8fSJfWBSIvlwL
         X6x/3ZV5YvNgj4TwrfgC4DZnmI0ccIbg8JvUJdYC4cuo3w3MJs4Q1c6wHw03ipIma+2o
         jKkA==
X-Gm-Message-State: AOJu0YwhknZpuOGTzWIzrSZ9CiJDZoWB9ekeiDNmGiAZAxg92SuD6yW2
	dfV1HEzGfd3IhbE3nvnApuFrP59J2y/9gE4b5uWr5gQHf5ewkgNsI1+Bhh+UDqGk6JihKoHOCay
	vqk4N
X-Gm-Gg: ASbGncvSuOnF/8mvqE8G6txC4AKDJP7fwJwgw1hs1mU8Hss13LVCpUI5L6ci0fdMMXA
	HDwNzx27KDewSW2WGsNWTAQYAboe4PZjlziRfRXv7hoRb/KRdQbKdLt8v/8FGYvsY4jGFD5LnkX
	BubFi7nGggkjDZb8kHwKSzh6fuvhvleHIDp1Q5BpXVvt9VBj5EbBTFIiDfTrjf9bYXsLeBD5Sys
	1pt3q7Hhm/cCVxy87NA7Gg+xE7ylK78tcmJwkuPOIu+EbdjoMzbwY/t/Zk1WkSTrHdu58tkBldn
	NIQNTmcmhcUdBwdslBBrsleSc5xpjRFgdfNNBwQ+VICFIK9FJ9r0G20=
X-Google-Smtp-Source: AGHT+IFe1TnwMAvGcZVAay9vSFRf1PN2Ovdq3PJ2WG/gWF15ICrWr4Hcn3o/X62B2jmUVu+jE7qjHw==
X-Received: by 2002:a05:6e02:1fc9:b0:3d4:70ab:f96f with SMTP id e9e14a558f8ab-3db842ba7eamr52294105ab.8.1747412099274;
        Fri, 16 May 2025 09:14:59 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc48c5cdsm467439173.84.2025.05.16.09.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 09:14:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: make io_alloc_ocqe() take a struct io_cqe pointer
Date: Fri, 16 May 2025 10:08:57 -0600
Message-ID: <20250516161452.395927-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250516161452.395927-1-axboe@kernel.dk>
References: <20250516161452.395927-1-axboe@kernel.dk>
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
index 2519fab303c4..e3c8c19902e8 100644
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
@@ -774,8 +774,7 @@ static void io_req_cqe_overflow(struct io_kiocb *req, gfp_t gfp)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_overflow_cqe *ocqe;
 
-	ocqe = io_alloc_ocqe(ctx, req->cqe.user_data, req->cqe.res,
-			     req->cqe.flags, req->big_cqe.extra1,
+	ocqe = io_alloc_ocqe(ctx, &req->cqe, req->big_cqe.extra1,
 			     req->big_cqe.extra2, gfp);
 	io_cqring_add_overflow(ctx, ocqe);
 	memset(&req->big_cqe, 0, sizeof(req->big_cqe));
@@ -839,6 +838,9 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	return false;
 }
 
+#define io_init_cqe(user_data, res, cflags)	\
+	(struct io_cqe) { .user_data = user_data, .res = res, .flags = cflags }
+
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
 	bool filled;
@@ -847,8 +849,9 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
 	if (unlikely(!filled)) {
 		struct io_overflow_cqe *ocqe;
+		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, user_data, res, cflags, 0, 0, GFP_ATOMIC);
+		ocqe = io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_ATOMIC);
 		filled = io_cqring_add_overflow(ctx, ocqe);
 	}
 	io_cq_unlock_post(ctx);
@@ -866,8 +869,9 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 
 	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
 		struct io_overflow_cqe *ocqe;
+		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, user_data, res, cflags, 0, 0, GFP_KERNEL);
+		ocqe = io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_KERNEL);
 		spin_lock(&ctx->completion_lock);
 		io_cqring_add_overflow(ctx, ocqe);
 		spin_unlock(&ctx->completion_lock);
-- 
2.49.0


