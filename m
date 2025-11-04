Return-Path: <io-uring+bounces-10374-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF0F1C334AF
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 23:45:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CA8F3BEACD
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 22:45:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C40D346E66;
	Tue,  4 Nov 2025 22:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="NBIUIhn7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4621A328B6F
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 22:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762296309; cv=none; b=CcZ7TUuM9CuNM949/abonusHC8U2uxSVEw9n5LPM7Vn2Yq5WsZddbTqnqW2mlRvi/KM2yPSweFtd2oTLI6/0OH+SjICQ1LEFSo+9mSOb1E4dyRK6G3xbNGr/ktdi7CqOV+2HuRmtZx8V1aqQZlK/MmIUkvV1W5s+HECRqNUtyfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762296309; c=relaxed/simple;
	bh=q7BK9iktocfJYm+/WotXGKhxxS+aD37j96cH6TGbOE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dv5eb0vhiHj++7PxrC9y5SbBrT9aW3qkQX3d1IMjRFekzVyjO7knlCZBr376XbZiNLxiu2iQRx3GB7JkLW02Hebds0mmCvtvF/yEGySduquiKIcJuQ0H15LosdXvipMQ5NvkZphyoGRKcEM5TJzcVoA43ZrwJEJslsYKeFGE+Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=NBIUIhn7; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7c68bfe1719so1563820a34.3
        for <io-uring@vger.kernel.org>; Tue, 04 Nov 2025 14:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762296306; x=1762901106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aPop6mvsum5XsgmkruquoYcW5M+7CiBgtUqQPcfMIkw=;
        b=NBIUIhn7a/hiO9aaV5nt1JptYGaUqnYgDjOBtXf+gWuUIUW2wBBvYdMYPJvp5HrU4d
         CpS3/kiVF8Pwhqy+91/dwCpQhtFlTbKnJwmlfAedz3BUR/j0IB5e6D2WBtXP83uWPJes
         tHn9bfchGYDiOWz/TT1Uynx5Q7LR/5FAsapaOGKJajSQAeOoI8mJgDRp90+XGgnCvO5U
         O/UPt2DrExK00pu7Dio4FUvTyFfUN+42fLVA8GGgAPqQ8Ko+StgyZiv14iFrrEKTEPcL
         F0a77CY/udAH+1KD/cvG4+gCGeFVvzEzuB7xENCgWvzj2wJWsIsp7MRKDfhcuQXqVkax
         9tSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762296306; x=1762901106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aPop6mvsum5XsgmkruquoYcW5M+7CiBgtUqQPcfMIkw=;
        b=bX6o7zHT2UgMwp0TzOfzjlRE1dy0gJg0kj5IuWgLkhln+DFEiHdmANMc6JH+//5RT1
         MelvicZpaSZvsQNOP+Ro2Qafn/kL9UVe1LJroirSLMBA/YdGl5ElLQ3LcIC9YELYgKsr
         JiYanjaJyWPP81A22k2/r7fQ2da8MDPKv/3a9E3JNY3LKglPJHTaAGzlhsN8cQDDmuQ2
         MAHqO0cskgazDS0upe3wzQNEW4EVJcki8h0F3m/vIAilfwoggwF+/9arGqk7dW2zeFCh
         9DSbbiXDT7MQJuFMhQjWzsXaekDf0JE4t++bsRIaEVgULyLWew8fXGM0+w9otPk50+MU
         Odgw==
X-Gm-Message-State: AOJu0Yzz5SORJqkzgoz69AIXWbb5qkJE6zWcuuEXefdKgcdqM3C8B4n/
	3V1I8Hg6TDDxGLvfIvOZQimeKhrxAV1L0wz1th7JV1FDcJlv705F2+YZkcZbKxCvjxG7Ji7ZY3B
	yA6xV
X-Gm-Gg: ASbGnctJeLQvuCZ7u8gvAGyaHCC7W0X+GbVOIOtW+iQluJB/4IUZ4YDea4dQPVzrFvC
	xdjEQ+jWWgwNmOfuu+pRHoWEBc4Bl+nwZyX9p+TRVVqklifldv3qk5fjOWGgS4uue5AnOCp9lw1
	+Q9GGOn8tg9ys5e/egeBaxHyRvVaevI7HG/8J+zCcZHVDErNjVLMTMg4yZjBauEINwMl0EuPz/O
	Fjuw/DG5uac4l+5Feg5Ii+2Om1YEqv59yFgjej7D7Y8SFfABLDgFSzpzzUpfOovPrU/JOxoXvhj
	N6P+faKzPS/VTw7R0RprFztKHuYYYTe78uA4PHUbV8iBcbauYLWh/P+5MMnSoaWUq9tpXULn1eY
	wUZfnFUAP93cinKiZ5ZYhSmWEh4GkDBIzPBg/PkM/TH9lp1MT7JK4j3ZHkL1ssyijNc5cZ/3X+O
	s4Z7zWoUDM9Mm33bQ=
X-Google-Smtp-Source: AGHT+IGG5v+Bzx2YdnvN+edflESwvjBbj42aNUf+BHdumuV4GVGSmBg+c70fo/cCzgXp4EfZjyPJ1g==
X-Received: by 2002:a05:6808:ec5:b0:44d:badf:f41a with SMTP id 5614622812f47-44fed30a937mr374253b6e.32.1762296306159;
        Tue, 04 Nov 2025 14:45:06 -0800 (PST)
Received: from localhost ([2a03:2880:12ff::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-44fd84952c4sm1066384b6e.1.2025.11.04.14.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 14:45:05 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 5/7] io_uring/zcrx: add user_struct and mm_struct to io_zcrx_ifq
Date: Tue,  4 Nov 2025 14:44:56 -0800
Message-ID: <20251104224458.1683606-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251104224458.1683606-1-dw@davidwei.uk>
References: <20251104224458.1683606-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for removing ifq->ctx and making ifq lifetime independent
of ring ctx, add user_struct and mm_struct to io_zcrx_ifq.

In the ifq cleanup path, these are the only fields used from the main
ring ctx to do accounting. Taking a copy in the ifq allows ifq->ctx to
be removed later, including the ctx->refs held by the ifq.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 24 ++++++++++++++++++------
 io_uring/zcrx.h |  2 ++
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 5c90404283ff..774efbce8cb6 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -200,7 +200,7 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	}
 
 	mem->account_pages = io_count_account_pages(pages, nr_pages);
-	ret = io_account_mem(ifq->ctx->user, ifq->ctx->mm_account, mem->account_pages);
+	ret = io_account_mem(ifq->user, ifq->mm_account, mem->account_pages);
 	if (ret < 0)
 		mem->account_pages = 0;
 
@@ -344,7 +344,8 @@ static void io_zcrx_get_niov_uref(struct net_iov *niov)
 	atomic_inc(io_get_user_counter(niov));
 }
 
-static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
+static int io_allocate_rbuf_ring(struct io_ring_ctx *ctx,
+				 struct io_zcrx_ifq *ifq,
 				 struct io_uring_zcrx_ifq_reg *reg,
 				 struct io_uring_region_desc *rd,
 				 u32 id)
@@ -362,7 +363,7 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 	mmap_offset = IORING_MAP_OFF_ZCRX_REGION;
 	mmap_offset += id << IORING_OFF_PBUF_SHIFT;
 
-	ret = io_create_region(ifq->ctx, &ifq->region, rd, mmap_offset);
+	ret = io_create_region(ctx, &ifq->region, rd, mmap_offset);
 	if (ret < 0)
 		return ret;
 
@@ -378,7 +379,7 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 
 static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 {
-	io_free_region(ifq->ctx->user, &ifq->region);
+	io_free_region(ifq->user, &ifq->region);
 	ifq->rq_ring = NULL;
 	ifq->rqes = NULL;
 }
@@ -390,7 +391,7 @@ static void io_zcrx_free_area(struct io_zcrx_ifq *ifq,
 	io_release_area_mem(&area->mem);
 
 	if (area->mem.account_pages)
-		io_unaccount_mem(area->ifq->ctx->user, area->ifq->ctx->mm_account,
+		io_unaccount_mem(ifq->user, ifq->mm_account,
 				 area->mem.account_pages);
 
 	kvfree(area->freelist);
@@ -525,6 +526,9 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 
 	if (ifq->area)
 		io_zcrx_free_area(ifq, ifq->area);
+	free_uid(ifq->user);
+	if (ifq->mm_account)
+		mmdrop(ifq->mm_account);
 	if (ifq->dev)
 		put_device(ifq->dev);
 
@@ -588,6 +592,14 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	ifq = io_zcrx_ifq_alloc(ctx);
 	if (!ifq)
 		return -ENOMEM;
+	if (ctx->user) {
+		get_uid(ctx->user);
+		ifq->user = ctx->user;
+	}
+	if (ctx->mm_account) {
+		mmgrab(ctx->mm_account);
+		ifq->mm_account = ctx->mm_account;
+	}
 	ifq->rq_entries = reg.rq_entries;
 
 	scoped_guard(mutex, &ctx->mmap_lock) {
@@ -597,7 +609,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			goto ifq_free;
 	}
 
-	ret = io_allocate_rbuf_ring(ifq, &reg, &rd, id);
+	ret = io_allocate_rbuf_ring(ctx, ifq, &reg, &rd, id);
 	if (ret)
 		goto err;
 
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 33ef61503092..8d828dc9b0e4 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -42,6 +42,8 @@ struct io_zcrx_ifq {
 	struct io_ring_ctx		*ctx;
 	struct io_zcrx_area		*area;
 	unsigned			niov_shift;
+	struct user_struct		*user;
+	struct mm_struct		*mm_account;
 
 	spinlock_t			rq_lock ____cacheline_aligned_in_smp;
 	struct io_uring			*rq_ring;
-- 
2.47.3


