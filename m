Return-Path: <io-uring+bounces-1312-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 303F1890E8A
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 00:35:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 534931C22CFC
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 23:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7E6E80BE0;
	Thu, 28 Mar 2024 23:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="N6p24DWP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD581130AC8
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 23:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711668899; cv=none; b=fCDx1pc82XJJbKh0ny/JTeEika+MfZuqNAdjfZUxS+uetVieuGZ1HSCD6dIyVZXtFwEocjV5hqsu4Ik1X9YBZb4zunoWDTHqPOnk8Rscrgj6DOjUM5NBjgCVoWyd4JaEiWrUah79wioBwxHgRRwY64HuYlP9RwU5JO3cdkgpIFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711668899; c=relaxed/simple;
	bh=fHyvvebnEPUnAwmr0t/L6S4igv+2Bli8GSZaj7RK5Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qa7X/FDYjbwwxSrinCxzoxo9np9weVu1pCi6ATEHM6H93qewpLkFqQhbE5TLvqc5ZNOGrnNzf26wluFPLgUgg54DV2ebmV9bXuf8lDI6OD/On57+hRRjDM9S3yPVtY+OYj8IZhsMlCSV6JisBG6BKwbBNdT29b9eRAwLOD028uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=N6p24DWP; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1dde367a10aso2555485ad.0
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 16:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711668897; x=1712273697; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HcTGmr9xA8QipTDJRrWEwTCI9+2LyvKqUf3LPC31+e0=;
        b=N6p24DWPJIgq0Mft9AHs98znD+8FfWRAa0dpffnU9srTK1JH9yiRJ0s59K8JTMLtWj
         XX3fs9Q3yj7V9G8pi5N5mDFZz8PzeCJY/G2+43J6fsgjjwU42fpIOlVmhdrU3Wl2l7HD
         k8pa6Q4o4+LegZhfB1XR8SPgQyqhhKItqryds46Xppln5ViardhOTybnt6aN2TPAV/LL
         0Ceu8RznsWc7YqNR8RtBZsgiz6DZRDKhwemyCrO869Pq0+LEsHIKXjovatF5vOeRMlTA
         gWoV4CahMEV0NHXVzRsG8DCdgjuUJAv+R2bU4rlJ3WAxgKPsu5tQYGG/GwJIrxviJi34
         NXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711668897; x=1712273697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HcTGmr9xA8QipTDJRrWEwTCI9+2LyvKqUf3LPC31+e0=;
        b=kMHHcDqpx+OjPa/aXjQEyYx22CzPCuQDYTT6UjXqyM81gTRSTp/9QLSk6A8VOubIfg
         YWh+iX+m/3+bm7Qu6ldHJ8F8dQxDWdLC/RdMEM5Ml9DkvS+q0dxfkDWxLBpOwWON3btQ
         oiNc7ROK23WXIki6sG4lcAiT8SejRF3FVBHZNxgeUf/ONBiqu5YXPq+fk0TiHTClB1Hj
         ocUrTYwppY6718T8oKmrnSEd7TSalH8AkdTtCzXs9hjyobZRjh/sSv3oq96a0cZ3Ywmm
         pKc7vmJWYSW0E3VUQztqcuyq1sFghq/7jx/6nwyd8LkLibHgLWCXJ0IrzU4gSGJerqL0
         Iu4w==
X-Gm-Message-State: AOJu0YzcVEftKyg81YkFjfMWJbnevdbJe3cEItP/17qAQyXlc8kx+xxs
	aER0wS3b4av6JK+dd/dtjSTiie6rFj2Gx2AUixOv0QgafAS6olnvHoWZK7WE5Qxgmffzv9EKtf+
	w
X-Google-Smtp-Source: AGHT+IHGt2masg4RVkJfFYOBjIUE0I7p8uoewhWeR8iGso1p43MW/TzYE4bZ6hFskTioEx5SVy4Wjg==
X-Received: by 2002:a17:903:124d:b0:1de:ddc6:27a6 with SMTP id u13-20020a170903124d00b001deddc627a6mr959943plh.2.1711668896700;
        Thu, 28 Mar 2024 16:34:56 -0700 (PDT)
Received: from localhost.localdomain ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b001e0b3c9fe60sm2216981pla.46.2024.03.28.16.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:34:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: hannes@cmpxchg.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/11] io_uring/kbuf: get rid of lower BGID lists
Date: Thu, 28 Mar 2024 17:31:32 -0600
Message-ID: <20240328233443.797828-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240328233443.797828-1-axboe@kernel.dk>
References: <20240328233443.797828-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just rely on the xarray for any kind of bgid. This simplifies things, and
it really doesn't bring us much, if anything.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  1 -
 io_uring/io_uring.c            |  2 -
 io_uring/kbuf.c                | 70 ++++------------------------------
 3 files changed, 8 insertions(+), 65 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index b191710bec4f..8c64c303dee8 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -295,7 +295,6 @@ struct io_ring_ctx {
 
 		struct io_submit_state	submit_state;
 
-		struct io_buffer_list	*io_bl;
 		struct xarray		io_bl_xa;
 
 		struct io_hash_table	cancel_table_locked;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3aac7fbee499..17db5b2aa4b5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -353,7 +353,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	io_futex_cache_free(ctx);
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
-	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
 	return NULL;
@@ -2928,7 +2927,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_napi_free(ctx);
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
-	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
 }
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 693c26da4ee1..8bf0121f00af 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -17,8 +17,6 @@
 
 #define IO_BUFFER_LIST_BUF_PER_PAGE (PAGE_SIZE / sizeof(struct io_uring_buf))
 
-#define BGID_ARRAY	64
-
 /* BIDs are addressed by a 16-bit field in a CQE */
 #define MAX_BIDS_PER_BGID (1 << 16)
 
@@ -40,13 +38,9 @@ struct io_buf_free {
 	int				inuse;
 };
 
-static struct io_buffer_list *__io_buffer_get_list(struct io_ring_ctx *ctx,
-						   struct io_buffer_list *bl,
-						   unsigned int bgid)
+static inline struct io_buffer_list *__io_buffer_get_list(struct io_ring_ctx *ctx,
+							  unsigned int bgid)
 {
-	if (bl && bgid < BGID_ARRAY)
-		return &bl[bgid];
-
 	return xa_load(&ctx->io_bl_xa, bgid);
 }
 
@@ -55,7 +49,7 @@ static inline struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
 {
 	lockdep_assert_held(&ctx->uring_lock);
 
-	return __io_buffer_get_list(ctx, ctx->io_bl, bgid);
+	return __io_buffer_get_list(ctx, bgid);
 }
 
 static int io_buffer_add_list(struct io_ring_ctx *ctx,
@@ -68,10 +62,6 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	 */
 	bl->bgid = bgid;
 	smp_store_release(&bl->is_ready, 1);
-
-	if (bgid < BGID_ARRAY)
-		return 0;
-
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
@@ -208,24 +198,6 @@ void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 	return ret;
 }
 
-static __cold int io_init_bl_list(struct io_ring_ctx *ctx)
-{
-	struct io_buffer_list *bl;
-	int i;
-
-	bl = kcalloc(BGID_ARRAY, sizeof(struct io_buffer_list), GFP_KERNEL);
-	if (!bl)
-		return -ENOMEM;
-
-	for (i = 0; i < BGID_ARRAY; i++) {
-		INIT_LIST_HEAD(&bl[i].buf_list);
-		bl[i].bgid = i;
-	}
-
-	smp_store_release(&ctx->io_bl, bl);
-	return 0;
-}
-
 /*
  * Mark the given mapped range as free for reuse
  */
@@ -300,13 +272,6 @@ void io_destroy_buffers(struct io_ring_ctx *ctx)
 	struct list_head *item, *tmp;
 	struct io_buffer *buf;
 	unsigned long index;
-	int i;
-
-	for (i = 0; i < BGID_ARRAY; i++) {
-		if (!ctx->io_bl)
-			break;
-		__io_remove_buffers(ctx, &ctx->io_bl[i], -1U);
-	}
 
 	xa_for_each(&ctx->io_bl_xa, index, bl) {
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
@@ -489,12 +454,6 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	io_ring_submit_lock(ctx, issue_flags);
 
-	if (unlikely(p->bgid < BGID_ARRAY && !ctx->io_bl)) {
-		ret = io_init_bl_list(ctx);
-		if (ret)
-			goto err;
-	}
-
 	bl = io_buffer_get_list(ctx, p->bgid);
 	if (unlikely(!bl)) {
 		bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
@@ -507,14 +466,9 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret) {
 			/*
 			 * Doesn't need rcu free as it was never visible, but
-			 * let's keep it consistent throughout. Also can't
-			 * be a lower indexed array group, as adding one
-			 * where lookup failed cannot happen.
+			 * let's keep it consistent throughout.
 			 */
-			if (p->bgid >= BGID_ARRAY)
-				kfree_rcu(bl, rcu);
-			else
-				WARN_ON_ONCE(1);
+			kfree_rcu(bl, rcu);
 			goto err;
 		}
 	}
@@ -679,12 +633,6 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (reg.ring_entries >= 65536)
 		return -EINVAL;
 
-	if (unlikely(reg.bgid < BGID_ARRAY && !ctx->io_bl)) {
-		int ret = io_init_bl_list(ctx);
-		if (ret)
-			return ret;
-	}
-
 	bl = io_buffer_get_list(ctx, reg.bgid);
 	if (bl) {
 		/* if mapped buffer ring OR classic exists, don't allow */
@@ -734,10 +682,8 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		return -EINVAL;
 
 	__io_remove_buffers(ctx, bl, -1U);
-	if (bl->bgid >= BGID_ARRAY) {
-		xa_erase(&ctx->io_bl_xa, bl->bgid);
-		kfree_rcu(bl, rcu);
-	}
+	xa_erase(&ctx->io_bl_xa, bl->bgid);
+	kfree_rcu(bl, rcu);
 	return 0;
 }
 
@@ -771,7 +717,7 @@ void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
 {
 	struct io_buffer_list *bl;
 
-	bl = __io_buffer_get_list(ctx, smp_load_acquire(&ctx->io_bl), bgid);
+	bl = __io_buffer_get_list(ctx, bgid);
 
 	if (!bl || !bl->is_mmap)
 		return NULL;
-- 
2.43.0


