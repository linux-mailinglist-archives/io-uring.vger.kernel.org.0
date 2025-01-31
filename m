Return-Path: <io-uring+bounces-6205-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A6DFA241E0
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 18:26:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FAB71887F71
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 17:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A1601EC00C;
	Fri, 31 Jan 2025 17:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZSKqD2w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76C6136351
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 17:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738344414; cv=none; b=Gj21O8etAtgWcU2OO4vtNIySoqq4eOhspAV6dZYf3YaVY/p+kFfdhTW4yATAuDyvdsnL8GE3eBS+TkA6B6YRA5IPnqBEn1UieZrl5R2h8HL9htXLk0bUA+5e4xUnO7oZKBmOEddfcqCkC9lwUXWCUDVdJbM8X6mwIXlmllYXDNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738344414; c=relaxed/simple;
	bh=ynI0+2fKuM5FuDwtcmZyl6SB9Y5QvbLzsTnD6WSMyXU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uEx787/84Qc6szU4O1+icN1o6ZYkg6/JwaWi6s1j7ZXnSDvSZTJ+hqmYzenH6RRAZWElLjD9xiVvoGJjx6AB6MTABdCSaBmZlTXcjIx5ZYktRBhezZCGetuS1Ck5E1yV6jWFgtmuAAshbUkHn9VSq3G+b53XTjbxOkMpxTexo6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dZSKqD2w; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4361f796586so26870895e9.3
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 09:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738344410; x=1738949210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PH3D0o8pFa3Scn32FuoBbUyFDazvYmH3CqKwUPsnYZA=;
        b=dZSKqD2w5phBvGw/Dk+LXs7a1h6OAM80Y61/+R4rKihs088x7VqXs3BrxGWYKrTwqr
         h05GqN2QXdGE+22KZSSZH8XaLrsfDqxE4KYh4W+99fOa2cJxONFIbrT5MYjYv5hdpq9n
         Dtu85ojKNcB95mIEW898fn+bYQE6BLQOD9uYmRd4pf7wNZsxSBti3dhZ54m7SVgM76PN
         756MUlew36mwgL/JvWftASQchkmWmvSM0o1+ABCaCT514bSjktITWPnWiqyek3831D3l
         Ca+2cdE5hlsPIQdG5s3CYdExU2/Fd3nHiwbt+DcgYrLM0D7w3hkGn6+itZFrPuxqX/yw
         oGhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738344410; x=1738949210;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PH3D0o8pFa3Scn32FuoBbUyFDazvYmH3CqKwUPsnYZA=;
        b=qb5PrcJng30QLS3dPlmhqRA8mdhpGna4ober7cJw+yJIN8dP2jmLVEO5spKfiuT2/z
         RfenC0CY79bVdPkCyJDfaUtD5x7mYMH84kA1IF2pE4mKeL2cnvdkFkNhaAwZ9YZRkMiR
         qnnopzr9BJRswAmKZzEr6tnPXsoz0w9aYLmR0OKoV2B7vvS1xB8cslZPoY2ZoCGAPuJi
         qhS0HZ2HwH9Z4SqfBCt40zdjSc6iZEqCMf0Bioe0CSLcs7Jsi46tnrX/t9CHJIqW4q3y
         ys6xJI+4AX5EyDIIvlEJGOzPSa7lZ8T0udT5D/TJKw5phqFbjeY2mT6Z42J76NdjN2X8
         d6ow==
X-Gm-Message-State: AOJu0YwxVVi+G2Ml2JL3DPCzn116hn+E+1Z7LusnkmO7tAnPdMOeiRUI
	M7saYVeTUNfFG4Ru7NpR88ud0bXv0XEfFxfFUEwITDpJQOJaLFb+3rkMaA==
X-Gm-Gg: ASbGncvqVPSciG4Gc/H1p0MS6yu8WeDzUv/7jUB/755parZgTHrri8otWB5tVymHH3n
	Oyy4x+sZpOKKppl3RJLd+Vf4SMeCTantkfjt9bxOcFMo3/qN36qGM21/SkJZSgH+bGwfigSCD5A
	6/8RDdHxJv1CFUTU7OMBva1aChQE4RPYlLqPGXCJ4Y8i7AX1UiEkAt2Bc5BlKuTDseygPAr+Baa
	J2YgPpc51yR7satO33OmGLG5wND1zcfKHCu504trLb/5m93PONRh2dcbrlICI8qvYgtDCA/3Dw=
X-Google-Smtp-Source: AGHT+IGFZpbClAIw2vWjtN6iVRhN6ZJuYUQFRMcXyDZeNWfCcAEaqAjZwj84BMp1pGAMZOt8CPqtIw==
X-Received: by 2002:a05:6000:1842:b0:38c:5fbf:10ca with SMTP id ffacd0b85a97d-38c5fbf1211mr6930198f8f.39.1738344410477;
        Fri, 31 Jan 2025 09:26:50 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7071])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e47a7b1asm327203966b.31.2025.01.31.09.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 09:26:49 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: deduplicate caches deallocation
Date: Fri, 31 Jan 2025 17:27:02 +0000
Message-ID: <b6b0125677c58bdff99eda91ab320137406e8562.1738342562.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a function that frees all ring caches since we already have two
spots repeating the same thing and it's easy to miss it and change only
one of them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4d6d2c494046c..ca5aa46e83c30 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -282,6 +282,16 @@ static int io_alloc_hash_table(struct io_hash_table *table, unsigned bits)
 	return 0;
 }
 
+static void io_free_alloc_caches(struct io_ring_ctx *ctx)
+{
+	io_alloc_cache_free(&ctx->apoll_cache, kfree);
+	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
+	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
+	io_alloc_cache_free(&ctx->uring_cache, kfree);
+	io_alloc_cache_free(&ctx->msg_cache, kfree);
+	io_futex_cache_free(ctx);
+}
+
 static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
 	struct io_ring_ctx *ctx;
@@ -360,12 +370,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 free_ref:
 	percpu_ref_exit(&ctx->refs);
 err:
-	io_alloc_cache_free(&ctx->apoll_cache, kfree);
-	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
-	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
-	io_alloc_cache_free(&ctx->uring_cache, kfree);
-	io_alloc_cache_free(&ctx->msg_cache, kfree);
-	io_futex_cache_free(ctx);
+	io_free_alloc_caches(ctx);
 	kvfree(ctx->cancel_table.hbs);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
@@ -2702,12 +2707,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_sqe_files_unregister(ctx);
 	io_cqring_overflow_kill(ctx);
 	io_eventfd_unregister(ctx);
-	io_alloc_cache_free(&ctx->apoll_cache, kfree);
-	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
-	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
-	io_alloc_cache_free(&ctx->uring_cache, kfree);
-	io_alloc_cache_free(&ctx->msg_cache, kfree);
-	io_futex_cache_free(ctx);
+	io_free_alloc_caches(ctx);
 	io_destroy_buffers(ctx);
 	io_free_region(ctx, &ctx->param_region);
 	mutex_unlock(&ctx->uring_lock);
-- 
2.47.1


