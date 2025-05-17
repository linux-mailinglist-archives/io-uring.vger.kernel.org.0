Return-Path: <io-uring+bounces-8027-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E95FABA9E5
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 13:49:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87B079E2560
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 11:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 667282D052;
	Sat, 17 May 2025 11:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="g8/n7XWG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231D81F5425
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 11:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747482590; cv=none; b=VsHzVuiIkATlKCDNUUMkHliHli10frqA33M4bRfH2tW1DhwXKJLh0IFnchpkYX5fuNdxLWH8FxElj/VbEnBaURyhuzqLi9GNop+B7mRiSTVc0vqHmwx0XL+7eRUQGCV1HDHpJ/zVvepAdTHVe5nxqS9brVPYfAmfDA8+XI9sNXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747482590; c=relaxed/simple;
	bh=J9Q7ct7sO/c6vXYdU/7XMSrAz3PwEFozf0g/wKY3tRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzl2NHNwX27TTpRk+FjCHiqH5XYtIrs7B3v8Ct+1Ux4JYx/2Mo847rv5yKdTrZ+UY39yciI/ngCONdS6MGhPAnoXy/Ubt5oZz/JFtJ3ug90q7eMAibav/N9BmHIemEUfRFrQJs6vhaSCYJR5/fa3nGACtC/p16MCKgjZmE/v+Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=g8/n7XWG; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3da73998419so8661735ab.0
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 04:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747482587; x=1748087387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QvpowAbTYhJhdJQ0R+p4FRsP9K7b8CyoWEEu2SAUjcs=;
        b=g8/n7XWGNdOxawJjwdsQJCpp60mKfiZ1vanm4yNmosazoBRxdVw2a5fTNp9V2S+EcG
         Th4uz4iCuYyfCRcjCOsiUVd0NmJTKJHlP9R/9Q9Ez/mfVGmDbU4s8IATlqEj5GNsvjFz
         0V9+2K9PEwe6ZGecEOlSPIpk688aWtuyRTfzNQs+3ILzWFhRKTxCgHNS/IC0ZJ9oYCoX
         kv1GkgKxMRl9OD41zW6qKrSmcJvQ7F9nyzQfYxSvAmw05cRJ8AgdX4TEq+dXe/Vlzuaf
         X68pXoKXG3KCdHug1AdI0NaNeHTOySPefXWusxJGdqyF1xoqGlRIM3+SnMrfqUDwKKcO
         cbag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747482587; x=1748087387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QvpowAbTYhJhdJQ0R+p4FRsP9K7b8CyoWEEu2SAUjcs=;
        b=Wk5bax5MxDcZOchpCoaNkZNmC4NtdtNDLKXPHOhWIBIZV8499JhFgcMtV8mXB2J+h4
         SvGIBDG+4IB4sHQkOl0IiFK+9KR5dT5QC3O0R7dUO1Kn2ZYWUUs9yDOdMikmx77W/z9j
         8/Uap8KzDV2m2cwD4zyu+91bx4Xi4spoklZ8TRroGIn/K0YgEUDffId2Kv7aNoTdH/WF
         eU6MYAIMp/vsF/tYKm0Xw2ejvEQZBv+stHDMYKxHCgoef2QvzhdPwSKJeUQVH5krrd4m
         1Y/cHvYIXQQI0clBWQFiKh5KB7IsKI98BQxnnpqJIgrO7SRBZhxccbXE4mZEATYfmKGr
         QqqA==
X-Gm-Message-State: AOJu0YwiuCdDGg6xYoJHlPn+7gjL68JbMuNywq4lzLXZ7y//skD/SRC6
	OG71j7IdhpeHdzfR6T8WQqWpmuoBOsxWL/GXJXkURYLXTM9YGqxv5VPAPc4J6jrHXuQq+wRCiMY
	cP1mm
X-Gm-Gg: ASbGncv7zt+e2f8zfhr5S1CZw7MTSnmPdD8sUaQRQbaTL64x/B8G7G/SagjU+9q05Fy
	qwXBiwOd/5064wA632vpKrp6UKS6gqLWuD58qUFWsONbdwW/nBoySN/kmyJ4EENZQLT+VIkDf7+
	YPj75rwyUZe1py7uJLZ0x7xc5ncbs36C6JqWQFhgp52uiX6xKwZgFezMQvwWdJS+K/lLE9PpQeA
	5MOZFU3Z1zXznJuhwGDUD2PGmh/nHTLcrJT+QXXZBRu25yofiNpCgLlPi5PJE/0FLGghcSwdr3H
	1X4+o7OVeFu0UaZhjA4UI69iCk+K/RxolsvxmBP5DcYH4nERNH4jozmn
X-Google-Smtp-Source: AGHT+IHMfftkUQCt60fyL4AxNZkS9y78bksSm+ce55O7I6oqyjHoM9579d31fGhgyxKzvVvn7s8CyQ==
X-Received: by 2002:a05:6e02:3a04:b0:3db:6dc8:96bc with SMTP id e9e14a558f8ab-3db84333761mr67781885ab.14.1747482586677;
        Sat, 17 May 2025 04:49:46 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b1a8bsm874354173.47.2025.05.17.04.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 04:49:45 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring: make io_alloc_ocqe() take a struct io_cqe pointer
Date: Sat, 17 May 2025 05:42:13 -0600
Message-ID: <20250517114938.533378-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250517114938.533378-1-axboe@kernel.dk>
References: <20250517114938.533378-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The number of arguments to io_alloc_ocqe() is a bit unwieldy. Make it
take a struct io_cqe pointer rather than three separate CQE args. One
path already has that readily available, add an io_init_cqe() helper for
the remaining two.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b564a1bdc068..1cf9d68b4964 100644
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
@@ -806,6 +806,11 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	return false;
 }
 
+static inline struct io_cqe io_init_cqe(u64 user_data, s32 res, u32 cflags)
+{
+	return (struct io_cqe) { .user_data = user_data, .res = res, .flags = cflags };
+}
+
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
 	bool filled;
@@ -814,8 +819,9 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
 	if (unlikely(!filled)) {
 		struct io_overflow_cqe *ocqe;
+		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, user_data, res, cflags, 0, 0, GFP_ATOMIC);
+		ocqe = io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_ATOMIC);
 		filled = io_cqring_add_overflow(ctx, ocqe);
 	}
 	io_cq_unlock_post(ctx);
@@ -833,8 +839,9 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 
 	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
 		struct io_overflow_cqe *ocqe;
+		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, user_data, res, cflags, 0, 0, GFP_KERNEL);
+		ocqe = io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_KERNEL);
 		spin_lock(&ctx->completion_lock);
 		io_cqring_add_overflow(ctx, ocqe);
 		spin_unlock(&ctx->completion_lock);
@@ -1444,8 +1451,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
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


