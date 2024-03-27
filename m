Return-Path: <io-uring+bounces-1259-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B99B888EF16
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 20:19:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC5FDB23AB0
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 19:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208891514DB;
	Wed, 27 Mar 2024 19:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JICYg6nN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6E614D280
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 19:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567188; cv=none; b=ZWk5ZLzvak1I25gN/0pIKQdTgUtKQbcvVFhI8YJEco49W95OVPEovt6Ep4rV2YedgLWk4Tl8BPneiz7PgKBuYnUxpVdCwtT+bw/3Fc8w3cnRJb3RJ+Qn9QmaFnEJKYSjuu7IuC6FCfk0KO3pzNubxPU1rpksfnNbVW85IfkDUZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567188; c=relaxed/simple;
	bh=IPj6VKN7BleBl24Q46XxZI4LhiYDh51nW7RVel9Fv6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YT0Le/y3E19NtE9UYMKODsBogPeazADtXvfLNCwMmaQuAaiAucfYN6LQ1NlOGG3oqJCmwckm7IBAar0yaIQ++Firb0dBVv8oOTZu1e7d3qihIBbl8V1nuKen7JMTbktV5OGLZWyn55BT0ZfUEmQsNi2ENIk3rCmKP8sYBOUCw90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JICYg6nN; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-58962bf3f89so25593a12.0
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 12:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711567185; x=1712171985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O9hRezk9QcZPei+uCZVczfTP+TTF/FpzdoAoLtJHj44=;
        b=JICYg6nNW9jpu7A62SczalOQFWZNSW27o+Eh4OzxDcGDn6Sg9w/qq03RyPhZkBkhDQ
         DWgmCvxJ2fY2bsQ/BJ4eRH32coz7HzqSs9XNP1CdvCrRMpjwIOpp6h/two1aumlb9Qyx
         Qxob4+E6lIl9M8bgVs+dz83r897J0MIJISBNzMnD1uUo/BJxYtOymuxT09HGZA8h9H75
         ZdBX5zcDeuWscc+22yfDtoEqzJCRIv3aAN8OM9/jXh+wbhcLDEa2RQGWNp8BqPkyrPyX
         k1bbSQ3f5vASsGoEH3Rwyid9PYJiQB6MQ/f911Ze9a7H91kAqUGVcPjwH9DGz+c8Qv09
         NN7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711567185; x=1712171985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O9hRezk9QcZPei+uCZVczfTP+TTF/FpzdoAoLtJHj44=;
        b=VFZGLTBRETYdBZDdK4bxdDeIkRh6TIKgeIiyBAU4l20a+Gi2hFDAHQ4yS0YVmuV3Up
         hnlouEmxCnluViM3Ib1g6CkJYCY1werWXzCo6rUffozkmxFFUhVU6+y1k3cFCS8ViAzc
         TtArnLUohxiHWo9yR6rMKxef4MhXg1H+xpBQpjGW+3IIpuzf7CFUOvxOG3wM5LbW9UUj
         9DT4Q5E/AeB7QazBFfAvx53APhZSmhWd75g3P0DdtZEtc9+KihebsuhVN9Qlt4nskkDw
         DdNiUukxupFBD65qVnu567aC8xvuaCkgB1UO8d7EEx2EpK5mLwIwBbFDjit1iniP7elS
         7V2g==
X-Gm-Message-State: AOJu0YyG0Ky3625xKHcbIy9NYxeL3lUcf/SxmXftKQ1YljJMZegZWpQn
	mybVN3mlEsirnYI7+gDVODnjsEk5YRQi51edAZN4B5w/7QHxkBQiXSD3FqQ8MDu+vHh9yOgLH6h
	1
X-Google-Smtp-Source: AGHT+IEP8lLbb7dN6Wq8niC5PC2/9TOdFZfU0JUwmqSB4C+a5/2AoBr9fl+ydSQX5ljqBkT70AGFNg==
X-Received: by 2002:a05:6a20:daa9:b0:1a3:b00a:7921 with SMTP id iy41-20020a056a20daa900b001a3b00a7921mr1085117pzb.5.1711567184990;
        Wed, 27 Mar 2024 12:19:44 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:bb1e])
        by smtp.gmail.com with ESMTPSA id n2-20020aa79842000000b006e6c3753786sm8278882pfq.41.2024.03.27.12.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 12:19:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/10] io_uring/kbuf: get rid of lower BGID lists
Date: Wed, 27 Mar 2024 13:13:40 -0600
Message-ID: <20240327191933.607220-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240327191933.607220-1-axboe@kernel.dk>
References: <20240327191933.607220-1-axboe@kernel.dk>
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
index e3d2e2655e95..31b686c5cb23 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -354,7 +354,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	io_futex_cache_free(ctx);
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
-	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
 	return NULL;
@@ -2932,7 +2931,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
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


