Return-Path: <io-uring+bounces-4700-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4B2B9C90E8
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 18:38:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70989282171
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 17:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB5E418BC21;
	Thu, 14 Nov 2024 17:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KBLVJBtR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF73C18BC28
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 17:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731605891; cv=none; b=QWMvSDs9N83FeWX5lkYI+aeulvvXTKBd4i5Vp6/k7G93gFmYXWUZKcTQPN1NOj0Muv3VwaQ1SGStOQ1Cw/bJY3MaBxazuTm4YDEQX8JbVZY/aJkdSabEdnz32UUGgRLuUkGVJviYLA8HeVnq8I7yB8Rd+MIXBobZyqlukCIe230=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731605891; c=relaxed/simple;
	bh=v2IbOLpYo3a22Mop7BMSABJ+5BM1F7i4KaPCY4tFSYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQYVfWoNxljbLflqCREVHXBYmsLAAd0GjJ2LyHZJgAYf3qFlVQl08LjX9xn59qx/ccgDjMLJSKXeSYuqDEX6hWgeFmMhpcPe3GCCqDF2XEV5eq66BHxA2oy0Gj2Zsp+O+M2qImltXQKD2k7Vk+b3R7vauLaCW2+ATzfIT1UU5p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KBLVJBtR; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9ec267b879so165057266b.2
        for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 09:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731605886; x=1732210686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9nJxolNITZkKjcgVgsRnwP3J3cPf7OR1t7KjI8tbabc=;
        b=KBLVJBtRRc2VQrJvhs8TUkl8dSS93Ad/qkMvu643sd+xMpH9VD/eZf1VEEvGwvcmdY
         mTN8R49+vhJEdJPQKTcRpoLMWmzkWgEzM+JJX+OnrcstC+1KnGg+wl79RkWmmGlzrWIW
         WGpFDAMT0qNjKwj/EPXVzxXY5QlizAVFe3LX8A8qiBuzJXpX0KDg9OnRoKtjRMSNNhkw
         9/g9ztS2MjsEGWA/PuS4U755KlCk1YCfSDPT4weHHkP5XJ1h07fzirNAHIOZX2+gdWep
         F00dLDnq+eH8GIZcjgPKxQPw2Hjz4V7fa73PwCEYWbM8S+EXa9R65UD6DPFVkWCO0FvO
         +AqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731605886; x=1732210686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9nJxolNITZkKjcgVgsRnwP3J3cPf7OR1t7KjI8tbabc=;
        b=jwxOGRnbZKSxFKccJrLl0ZO4JXXDcgC0oD/NnqRNjxYDMW0mbRR8WhF7QVO68E71ao
         LMOH2pYuecAxuqlkXCnueLBhft5/vMWYxt5Ajs+JKlz6vsFapcYKrs4xdxTZHZIvenww
         RFwQgW3GxYvHRT7cuckOnZ8egOk/UgpGhnhikrxCvkhJlg41H+RTEW4mD16dXIdHmt8a
         +X2iv7azF26B3ws7dtnFegRehzQXQJy6hkV/JjLMzvuYmhFNBuS1c0ZalXAZueoEty/E
         Vot6XIKW3us72oyw8oOymw//+FjhcaNcfHsxFWKPpZwthcJCWAE1vD7gA0d03WhiPqfr
         tKnQ==
X-Gm-Message-State: AOJu0Yx/alyRkpwsbgHjTRfEgsFEe9YpYjEUpt7edYX5wgYFc6FAPdev
	BAXGvXMCs5NNukp5FSuetSNqL1URT7yvQtV2+bEwJOalG3rHb/pIZRwCtg==
X-Google-Smtp-Source: AGHT+IERY+QzSbcpM5GmaOyZFHNWlr8ws+IoI1CSVY0/DbwVuZkdlCRn7iUdXe1k0HMWpgRXugbdBQ==
X-Received: by 2002:a17:906:4783:b0:a9a:533b:56e3 with SMTP id a640c23a62f3a-aa1f8076dacmr757675666b.26.1731605886358;
        Thu, 14 Nov 2024 09:38:06 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20df56b31sm85799966b.72.2024.11.14.09.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 09:38:05 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 3/6] io_uring: temporarily disable registered waits
Date: Thu, 14 Nov 2024 17:38:33 +0000
Message-ID: <70b1d1d218c41ba77a76d1789c8641dab0b0563e.1731604990.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731604990.git.asml.silence@gmail.com>
References: <cover.1731604990.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Disable wait argument registration as it'll be replaced with a more
generic feature. We'll still need IORING_ENTER_EXT_ARG_REG parsing
in a few commits so leave it be.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 10 -----
 include/uapi/linux/io_uring.h  |  3 --
 io_uring/io_uring.c            | 10 -----
 io_uring/register.c            | 82 ----------------------------------
 io_uring/register.h            |  1 -
 5 files changed, 106 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 072e65e93105..52a5da99a205 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -330,14 +330,6 @@ struct io_ring_ctx {
 		atomic_t		cq_wait_nr;
 		atomic_t		cq_timeouts;
 		struct wait_queue_head	cq_wait;
-
-		/*
-		 * If registered with IORING_REGISTER_CQWAIT_REG, a single
-		 * page holds N entries, mapped in cq_wait_arg. cq_wait_index
-		 * is the maximum allowable index.
-		 */
-		struct io_uring_reg_wait	*cq_wait_arg;
-		unsigned char			cq_wait_index;
 	} ____cacheline_aligned_in_smp;
 
 	/* timeouts */
@@ -431,8 +423,6 @@ struct io_ring_ctx {
 	unsigned short			n_sqe_pages;
 	struct page			**ring_pages;
 	struct page			**sqe_pages;
-
-	struct page			**cq_wait_page;
 };
 
 struct io_tw_state {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 5d08435b95a8..132f5db3d4e8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -627,9 +627,6 @@ enum io_uring_register_op {
 	/* resize CQ ring */
 	IORING_REGISTER_RESIZE_RINGS		= 33,
 
-	/* register fixed io_uring_reg_wait arguments */
-	IORING_REGISTER_CQWAIT_REG		= 34,
-
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 464a70bde7e6..286b7bb73978 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2709,7 +2709,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->msg_cache, io_msg_cache_free);
 	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
-	io_unregister_cqwait_reg(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
@@ -3195,15 +3194,6 @@ void __io_uring_cancel(bool cancel_all)
 static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
 			const struct io_uring_getevents_arg __user *uarg)
 {
-	struct io_uring_reg_wait *arg = READ_ONCE(ctx->cq_wait_arg);
-
-	if (arg) {
-		unsigned int index = (unsigned int) (uintptr_t) uarg;
-
-		if (index <= ctx->cq_wait_index)
-			return arg + index;
-	}
-
 	return ERR_PTR(-EFAULT);
 }
 
diff --git a/io_uring/register.c b/io_uring/register.c
index 45edfc57963a..3c5a3cfb186b 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -570,82 +570,6 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	return ret;
 }
 
-void io_unregister_cqwait_reg(struct io_ring_ctx *ctx)
-{
-	unsigned short npages = 1;
-
-	if (!ctx->cq_wait_page)
-		return;
-
-	io_pages_unmap(ctx->cq_wait_arg, &ctx->cq_wait_page, &npages, true);
-	ctx->cq_wait_arg = NULL;
-	if (ctx->user)
-		__io_unaccount_mem(ctx->user, 1);
-}
-
-/*
- * Register a page holding N entries of struct io_uring_reg_wait, which can
- * be used via io_uring_enter(2) if IORING_GETEVENTS_EXT_ARG_REG is set.
- * If that is set with IORING_GETEVENTS_EXT_ARG, then instead of passing
- * in a pointer for a struct io_uring_getevents_arg, an index into this
- * registered array is passed, avoiding two (arg + timeout) copies per
- * invocation.
- */
-static int io_register_cqwait_reg(struct io_ring_ctx *ctx, void __user *uarg)
-{
-	struct io_uring_cqwait_reg_arg arg;
-	struct io_uring_reg_wait *reg;
-	struct page **pages;
-	unsigned long len;
-	int nr_pages, poff;
-	int ret;
-
-	if (ctx->cq_wait_page || ctx->cq_wait_arg)
-		return -EBUSY;
-	if (copy_from_user(&arg, uarg, sizeof(arg)))
-		return -EFAULT;
-	if (!arg.nr_entries || arg.flags)
-		return -EINVAL;
-	if (arg.struct_size != sizeof(*reg))
-		return -EINVAL;
-	if (check_mul_overflow(arg.struct_size, arg.nr_entries, &len))
-		return -EOVERFLOW;
-	if (len > PAGE_SIZE)
-		return -EINVAL;
-	/* offset + len must fit within a page, and must be reg_wait aligned */
-	poff = arg.user_addr & ~PAGE_MASK;
-	if (len + poff > PAGE_SIZE)
-		return -EINVAL;
-	if (poff % arg.struct_size)
-		return -EINVAL;
-
-	pages = io_pin_pages(arg.user_addr, len, &nr_pages);
-	if (IS_ERR(pages))
-		return PTR_ERR(pages);
-	ret = -EINVAL;
-	if (nr_pages != 1)
-		goto out_free;
-	if (ctx->user) {
-		ret = __io_account_mem(ctx->user, 1);
-		if (ret)
-			goto out_free;
-	}
-
-	reg = vmap(pages, 1, VM_MAP, PAGE_KERNEL);
-	if (reg) {
-		ctx->cq_wait_index = arg.nr_entries - 1;
-		WRITE_ONCE(ctx->cq_wait_page, pages);
-		WRITE_ONCE(ctx->cq_wait_arg, (void *) reg + poff);
-		return 0;
-	}
-	ret = -ENOMEM;
-	if (ctx->user)
-		__io_unaccount_mem(ctx->user, 1);
-out_free:
-	io_pages_free(&pages, nr_pages);
-	return ret;
-}
-
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -840,12 +764,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_resize_rings(ctx, arg);
 		break;
-	case IORING_REGISTER_CQWAIT_REG:
-		ret = -EINVAL;
-		if (!arg || nr_args != 1)
-			break;
-		ret = io_register_cqwait_reg(ctx, arg);
-		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/io_uring/register.h b/io_uring/register.h
index 3e935e8fa4b2..a5f39d5ef9e0 100644
--- a/io_uring/register.h
+++ b/io_uring/register.h
@@ -5,6 +5,5 @@
 int io_eventfd_unregister(struct io_ring_ctx *ctx);
 int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id);
 struct file *io_uring_register_get_file(unsigned int fd, bool registered);
-void io_unregister_cqwait_reg(struct io_ring_ctx *ctx);
 
 #endif
-- 
2.46.0


