Return-Path: <io-uring+bounces-10371-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F21AC334A0
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 23:45:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAE6F3B2A4E
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 22:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFCB33F8B7;
	Tue,  4 Nov 2025 22:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Atr0gMwP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102A6328B6F
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 22:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762296304; cv=none; b=gVj+EnKItCsivXVCc5tcWg7rp6YCQWmM0dAGHvOE99lyHj9dOSQmqFq99NThGtLGmAKvsmySQs21fnPnUCfXiO0Wt1SJUs3wOEEvzeY+G4UaWRbreCWymnyyVSjjs3QFsh/gCPxPnlloAYEPvbQidAZH9fzTZy7Awks+RH5DUpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762296304; c=relaxed/simple;
	bh=/6TeMQIZFGOGBftkQFVAyJCfXQVP0Dd9lxnoQSG7qIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOx67DHGz9oKAMwzJvN2cckp5qku/Pd/NHHGX2gaMbm0wG86YABKNp8l1OZAPqp0YkR2LasN/PZiRs7cBklXe0awmh/LbO8gVDSOx9nzc7Jqnzm3lNgR1DMP22wrRS51LWTH1xcN7IOxU4qZf+5alXTarEY2YSt6ZdSwOcdVuXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Atr0gMwP; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7c2948b774cso4109931a34.0
        for <io-uring@vger.kernel.org>; Tue, 04 Nov 2025 14:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762296302; x=1762901102; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hz8W4FYKKdml45Vr6A3xpwDAjARBCNSHsrnQa69SYYY=;
        b=Atr0gMwPoYmngqHgZLpB95LuzJIObX8//grJt4MAlRhE7y/RyJTmbtEDB1oYloSQ7K
         LryeqRT/sf0k4NiB0Y9SxvvXwBsYWYdkrLoul615Zyiw5I00bi4ZpMCy7OV2WTmCI+TA
         R9c8Ijatyl1fve/w2n5qGEF9Dn+Lb6LlHYP3RN0kJ4ZdfVR82dWMs3Ejr+Yo/hO3LtzO
         l9ExNaS4z3rjgi27hS2beCj8uUKna0vxdYEQsY6SNF+ScllAMKU1ijyhRHD5bUZZGwG/
         vmTrOOB3FSjtwvUB/DkRVXudTRZQGA7nWzsqYoYuLSN3Z9d69kzKbzEMZi67Nyi8XiUu
         CT0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762296302; x=1762901102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hz8W4FYKKdml45Vr6A3xpwDAjARBCNSHsrnQa69SYYY=;
        b=GrlracbknxOU595l4PCBOSAM9iP/H+eMMygHlo6aKW44gKprc+P3Eblrw/5sTt7q3e
         IZU/AOmDUZR94Liona98sa5BKu00YmjxZoixUe4leo18LCXHvmOPoOFTF5fxF6dpQIbm
         yrWZCE5Kt2N7GmSqWIUF4eJt0DOgs+aoaa6Xh66IIPT8p5TtJk+PEM8/jhpg73RLGBeQ
         eMj1p+D9zf06ro/busWagdFHNR9PA4u+oel4y1qxce1FAVpZdfMJX5isbGtIETVByCll
         xYhBf1mjb82zjN0MhjbULacuLtT0Ur/JcS6yLD2Gv5Yh6xrJyyIWJgkaWlQqzqzVdRZ2
         yMKA==
X-Gm-Message-State: AOJu0Yz6/2Mb0rRBR5cKTO8g45vZtV2uoaQ41mgWVtXJXQoNXNhyxnra
	BlN4JhC9HGrJcKqHFia4kXDE9RGfQsxOvmJ0DDvN/GKQF00tkQrETulEeCutRp/btnYlWtw2vIn
	vlqpH
X-Gm-Gg: ASbGncs4q0yVUvzH1dceom+Y4bYIFiUUlzEEkNg8+cxvRE6seyNBDx4BE88Tc7Sdu6S
	/0+6xzK0InEyaOV4PqEFLkOmhXiZl9ViQVEmM9s8r0McoIkceKJ+whJ19mjUn+a0OYm4EL2ZipU
	rU2BaXbSYXlFaUKpZNt6+EUkAOJWSlvCFd5W9il0LMvs+2+t1T/MgfRTUXZvrDh+a0KbSWNq0Ay
	5L7Sy6+hcEXU1vUv3/DJgn3XUxpR1RgXfQshMJG9NNjM6Cngf5qdnlRYud7q6/YpbqySVFXKcqV
	MaTesGcy1QzmpFENEJ4BBNMHjYlleiCQhcYgwp18Qj1Rqvac2gep0FZ8+pJKzVlOc8u4J9dZhxQ
	ynNmoAQRwGFi+YijLFZkVXc9Sh6d8/XURtxE621ivyCFy3pKoi62hlnYdmo2xjSbxR3kH1JR0wU
	MbQ3BfN7JXpNiv0b7U/Ww=
X-Google-Smtp-Source: AGHT+IF/jZ0F/nAmcq4KPpZ6SkEYT6bWH9QLKTL/ExV0MTz58QAdwcSx+YwqbDjkQeWUnkUFTTVoqw==
X-Received: by 2002:a05:6830:4122:b0:7a6:c26e:1f7a with SMTP id 46e09a7af769-7c6d14166a6mr675549a34.13.1762296302157;
        Tue, 04 Nov 2025 14:45:02 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:74::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c6c25002eesm1375826a34.28.2025.11.04.14.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 14:45:01 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 2/7] io_uring/memmap: refactor io_free_region() to take user_struct param
Date: Tue,  4 Nov 2025 14:44:53 -0800
Message-ID: <20251104224458.1683606-3-dw@davidwei.uk>
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

Refactor io_free_region() to take user_struct directly, instead of
accessing it from the ring ctx.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/io_uring.c | 6 +++---
 io_uring/kbuf.c     | 4 ++--
 io_uring/memmap.c   | 8 ++++----
 io_uring/memmap.h   | 2 +-
 io_uring/register.c | 6 +++---
 io_uring/zcrx.c     | 2 +-
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 200b6c4bb2cc..7d42748774f8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2798,8 +2798,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 static void io_rings_free(struct io_ring_ctx *ctx)
 {
-	io_free_region(ctx, &ctx->sq_region);
-	io_free_region(ctx, &ctx->ring_region);
+	io_free_region(ctx->user, &ctx->sq_region);
+	io_free_region(ctx->user, &ctx->ring_region);
 	ctx->rings = NULL;
 	ctx->sq_sqes = NULL;
 }
@@ -2884,7 +2884,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_eventfd_unregister(ctx);
 	io_free_alloc_caches(ctx);
 	io_destroy_buffers(ctx);
-	io_free_region(ctx, &ctx->param_region);
+	io_free_region(ctx->user, &ctx->param_region);
 	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index c034c90396bc..8a329556f8df 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -428,7 +428,7 @@ static int io_remove_buffers_legacy(struct io_ring_ctx *ctx,
 static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 {
 	if (bl->flags & IOBL_BUF_RING)
-		io_free_region(ctx, &bl->region);
+		io_free_region(ctx->user, &bl->region);
 	else
 		io_remove_buffers_legacy(ctx, bl, -1U);
 
@@ -672,7 +672,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	io_buffer_add_list(ctx, bl, reg.bgid);
 	return 0;
 fail:
-	io_free_region(ctx, &bl->region);
+	io_free_region(ctx->user, &bl->region);
 	kfree(bl);
 	return ret;
 }
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index d1318079c337..b1054fe94568 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -88,7 +88,7 @@ enum {
 	IO_REGION_F_SINGLE_REF			= 4,
 };
 
-void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
+void io_free_region(struct user_struct *user, struct io_mapped_region *mr)
 {
 	if (mr->pages) {
 		long nr_refs = mr->nr_pages;
@@ -105,8 +105,8 @@ void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
 	}
 	if ((mr->flags & IO_REGION_F_VMAP) && mr->ptr)
 		vunmap(mr->ptr);
-	if (mr->nr_pages && ctx->user)
-		__io_unaccount_mem(ctx->user, mr->nr_pages);
+	if (mr->nr_pages && user)
+		__io_unaccount_mem(user, mr->nr_pages);
 
 	memset(mr, 0, sizeof(*mr));
 }
@@ -228,7 +228,7 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		goto out_free;
 	return 0;
 out_free:
-	io_free_region(ctx, mr);
+	io_free_region(ctx->user, mr);
 	return ret;
 }
 
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index 58002976e0c3..a7c476f499d5 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -16,7 +16,7 @@ unsigned long io_uring_get_unmapped_area(struct file *file, unsigned long addr,
 					 unsigned long flags);
 int io_uring_mmap(struct file *file, struct vm_area_struct *vma);
 
-void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr);
+void io_free_region(struct user_struct *user, struct io_mapped_region *mr);
 int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		     struct io_uring_region_desc *reg,
 		     unsigned long mmap_offset);
diff --git a/io_uring/register.c b/io_uring/register.c
index 1a3e05be6e7b..023f5e7a18da 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -381,8 +381,8 @@ struct io_ring_ctx_rings {
 static void io_register_free_rings(struct io_ring_ctx *ctx,
 				   struct io_ring_ctx_rings *r)
 {
-	io_free_region(ctx, &r->sq_region);
-	io_free_region(ctx, &r->ring_region);
+	io_free_region(ctx->user, &r->sq_region);
+	io_free_region(ctx->user, &r->ring_region);
 }
 
 #define swap_old(ctx, o, n, field)		\
@@ -604,7 +604,7 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 	if (ret)
 		return ret;
 	if (copy_to_user(rd_uptr, &rd, sizeof(rd))) {
-		io_free_region(ctx, &region);
+		io_free_region(ctx->user, &region);
 		return -EFAULT;
 	}
 
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a816f5902091..d15453884004 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -378,7 +378,7 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 
 static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 {
-	io_free_region(ifq->ctx, &ifq->region);
+	io_free_region(ifq->ctx->user, &ifq->region);
 	ifq->rq_ring = NULL;
 	ifq->rqes = NULL;
 }
-- 
2.47.3


