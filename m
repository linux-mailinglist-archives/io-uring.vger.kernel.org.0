Return-Path: <io-uring+bounces-1182-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18988885B25
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 15:48:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AF49284E1B
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 14:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350DF84FA0;
	Thu, 21 Mar 2024 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CWa2g8g3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887D184A51
	for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 14:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711032521; cv=none; b=MQ1M/kY7MZP6ZcnMGmC4LRj/N6hfqE9xghb58yj9HXdVskDSEuWuGNDFXOvZpRFZoy5KwmIgsLfcvZVhb4FGQcd3h20WqveTTQw1jBfiXi8kx/sSmPi3HEUTY/19RsgnpPs2ZYMqWpmguov17WEBEVojtFfDynLhb/X+cjDGgxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711032521; c=relaxed/simple;
	bh=tsk/vGy57WWlSJnklOHHVGV/6Lw/R39zrN40hMWm/cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4KY2wocdfWIWukjRVl+FIHg+xHCCS/oE91gw2N14gj2YRujBVzUur9Vxsei5pijpGPgwq4UN8QDoX6jYRr8/sZ965yIwdZ7N5cSfHifMXTyOf7INOrahEY3TxbvSvt++bAwmuKpr3tkRXK9bruwcP+z711auSbTdvJ2RPosjMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CWa2g8g3; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7cc5e664d52so19312839f.0
        for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 07:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711032516; x=1711637316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k+0GTkS88F/9JgiF0E6fTaZaUJu28N1lKoEtmdHQlyU=;
        b=CWa2g8g3pIfIwOxzyPYKt0aowc+l5OnXqXo9ntEq+FsEnLz40xTt+tLIKbCeCLtuLq
         bLNcymaA/ibuDuf/zOGpZjzJL2BguYo3iLaedgEw+KQoPttw0FZBrvxkXqQodExNOyxZ
         pIrUd9qAp0IHQTJp7HE+uGCKJ5WuuEsYb6H5tOYTl4cmfFtp1WOpEm2z5cZS52JBaPcT
         URZ2giOG7r1j6xzkwaJRpvwkxl1gDTLa8pBnkKyLlV155mPk+3MpqqMZmLt9PzfpbHAb
         vwmclqLg5aSNQuUJUL9w9YWpzaId+Zfqs+QFzyz5ZQN+3NvgXLuxlVxnNWZ1KS6XhYVO
         SxOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711032516; x=1711637316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k+0GTkS88F/9JgiF0E6fTaZaUJu28N1lKoEtmdHQlyU=;
        b=Zo2hgbV2KKHdyutth/zrdSGwkTFfWlLtJpOqPMEqpeVn00AZU6jiAcWKfCKrANARl1
         LcHe+3ibWUNomm0KsF+7n5ink7QPu68khMabAdIr0S95SejepI6KAqa9o/3g5O73beYh
         ib4DGwVvElKU+pSQ748M/9SwAtxTpb+7mjHpGOde5oyEyJJzMpbPT5eYZAo5eunDrlpx
         To+EJBrMsQi44hoUwzSjsLwc74hYo/Ais4qL3pem5Fyy1FHaqtnlt1xQtXsDPXcHhtVX
         eo0TKRxcE4LV3Ia8ASzJTXBetvBYKrNEg3WqmRTeOmYjRAkiISm+XtO8p3zrNWgtDuco
         g80g==
X-Gm-Message-State: AOJu0YwjsSns6xTv4hKRei7mlt4aQnkyb8xcK0pnt8ewf+0mXOcN9oxu
	UcUWwU1OqKivXxUUbpqWY/Q/MR1yR5MTY07PDrjNj9WeEGXo9TVi/P311AFJG4i4GU2j1vsgUJA
	Q
X-Google-Smtp-Source: AGHT+IHefxedIowEfxWxxi2/Wf6L9pf+zutV30Qwve5wyDE4itn3vmkYZ9OrHl+0vhwN2ApmzBRGCQ==
X-Received: by 2002:a6b:5108:0:b0:7ce:f407:1edf with SMTP id f8-20020a6b5108000000b007cef4071edfmr8860480iob.0.1711032516263;
        Thu, 21 Mar 2024 07:48:36 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q20-20020a02c8d4000000b0047bed9ff286sm250835jao.31.2024.03.21.07.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 07:48:34 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] io_uring/kbuf: get rid of lower BGID lists
Date: Thu, 21 Mar 2024 08:44:56 -0600
Message-ID: <20240321144831.58602-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240321144831.58602-1-axboe@kernel.dk>
References: <20240321144831.58602-1-axboe@kernel.dk>
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
index ea7e5488b3be..c9a1952a383a 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -295,7 +295,6 @@ struct io_ring_ctx {
 
 		struct io_submit_state	submit_state;
 
-		struct io_buffer_list	*io_bl;
 		struct xarray		io_bl_xa;
 
 		struct io_hash_table	cancel_table_locked;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index de7f88df939c..5b80849fbb85 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -342,7 +342,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 err:
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
-	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
 	return NULL;
@@ -2849,7 +2848,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
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


