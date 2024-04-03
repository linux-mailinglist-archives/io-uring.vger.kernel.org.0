Return-Path: <io-uring+bounces-1375-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E6D78971C0
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 15:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 824031C25B1F
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 13:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B615148857;
	Wed,  3 Apr 2024 13:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YO6hvnhb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D23148844
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 13:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712152572; cv=none; b=bOt3rEs62Rf3gwwf4hxyYbn/D8MFPdS7u1sLKNNu71tSwEj/8DfO5IPWjlLt4myfpQ+Y48L6PgLNF0aBxB+7FxnEH1jwqp4NIoy3kccvhgGsbSwoY7R0D0vA1J0VQm97+lX+dKAxFtsL15hCjkpxFIo43cr+9d4930ljvpX7y7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712152572; c=relaxed/simple;
	bh=2zyZqrh0NeVxqGOPo5tUGzqQ6zCy6N2KuRJRBu9FFKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niFzg6jkzx+sYVaBdjWs5XC3a5LmRecO6ndAjVLs8fg3KocPVEVmtSwD+/JJU8pXqHqqEXiFDbOovbcVxeIGL8//k9+qWrkzpoCBHaayxAQtBtuboJ/oJc1wvIgv1jL3/En5EUMgd+q+/7LboFblHSkT5qjFKjPjpxQMjEOsrMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YO6hvnhb; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-369f8526c85so306545ab.1
        for <io-uring@vger.kernel.org>; Wed, 03 Apr 2024 06:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712152568; x=1712757368; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YpyMnkGLPfuCdpP3GgziuHRh4o2UqLyww0R8LKUm/K0=;
        b=YO6hvnhbZcyHlgMzrC0B7Y6MGGkjl+29cXx5eqei3F3YbQtwC+aPDtCGS/TNxGkIAX
         lzZiPgBMa5f9/sKKkf03mqn0ta1e0xIVY+G7MiZDIhrwAZNZDX9gVsDl+gZjEH8GzFmR
         XUjw/K6xoAhzibpxfarxyHPkBIOm7LOzxvFVD48opM5GkCyaaj6H2ktOcaU3DfBlN7G1
         I7gF/8KYfWQUeVCVlLoDcCSrv0k4x0DovzxXdvqYyl3iWBr1MO47qH6eZu5UuLL12T4R
         76ngEptSEyzoY5ZSweZxn2DHNGgDbtP0qwcOsLv2RX5+N9hRlMyR3alqdDJzeUwHJ7dV
         ndWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712152568; x=1712757368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YpyMnkGLPfuCdpP3GgziuHRh4o2UqLyww0R8LKUm/K0=;
        b=hD8MzeqAxPN1/53ADr1Yqu2oj0LCuU94Mc6tlBH5ODiphNEq8l5OOsSyveDUDydSp4
         iJIcXoy88pe2D8rAdQqfWbh2LNrEXHA/UtJpBlt3yBmviS5X38CJJlU0qnNdDLytJVrF
         HdwnW7tZtTp4hsTGTQqLHrl7+F97oihojY+aSGjCm3YVo7pql92nKgFX647i6dE/RcjR
         rxn2+Tuj9B6wIj7SrMjurZfD39uN+pmoKYqyie2XtsfsQhGT24n6rSCFXYBkz8dm0h0T
         QuTs9Qvrn8Ax0fZfILjUydhD32PxX0ZyYmprmmqS/+BZUJ2sbdt7zhuHuuT4lTYLu553
         Vr4w==
X-Gm-Message-State: AOJu0YyznECFwW1nphYNIdytGExSUhyfuGnbZsEqaEh5Du/JOBJsnlrX
	DIkV4yVliMrtOc9FOvN3nAhYra2KDK5YmJOe6x6ekS48m6ahIUzJ3uBXydn6JhT0n/QxaIr02fE
	q
X-Google-Smtp-Source: AGHT+IHyA0Uc96KgIHa3U6IJQjDMOIVhB0P5ca7DEqSCC1nFojhhMnImqj34EY72Yehdc5elZ+cgfQ==
X-Received: by 2002:a6b:5907:0:b0:7c8:d514:9555 with SMTP id n7-20020a6b5907000000b007c8d5149555mr14852479iob.1.1712152568532;
        Wed, 03 Apr 2024 06:56:08 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l14-20020a02ccee000000b0047ec296d3c1sm3839460jaq.19.2024.04.03.06.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 06:56:06 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org
Subject: [PATCH 1/4] io_uring/kbuf: get rid of lower BGID lists
Date: Wed,  3 Apr 2024 07:52:34 -0600
Message-ID: <20240403135602.1623312-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240403135602.1623312-1-axboe@kernel.dk>
References: <20240403135602.1623312-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just rely on the xarray for any kind of bgid. This simplifies things, and
it really doesn't bring us much, if anything.

Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  1 -
 io_uring/io_uring.c            |  2 -
 io_uring/kbuf.c                | 70 ++++------------------------------
 3 files changed, 8 insertions(+), 65 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e24893625085..05df0e399d7c 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -294,7 +294,6 @@ struct io_ring_ctx {
 
 		struct io_submit_state	submit_state;
 
-		struct io_buffer_list	*io_bl;
 		struct xarray		io_bl_xa;
 
 		struct io_hash_table	cancel_table_locked;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d1defb99b89e..bc730f59265f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -351,7 +351,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 err:
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


