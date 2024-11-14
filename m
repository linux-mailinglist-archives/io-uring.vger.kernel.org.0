Return-Path: <io-uring+bounces-4675-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ADEF59C81D3
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 05:14:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F8D01F21E23
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 04:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DB8B1DF72E;
	Thu, 14 Nov 2024 04:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fBkRajoV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE211E8827
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 04:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731557649; cv=none; b=gfl9TbttUFK8yEEm0H/N9WfmAvNGuEIv5RY1LkMtalmO2seo3HRbBOlwln2qmWGPOaC9arKv6IeYNwpXabcG3ezE62vDR2uMAMz4RoS3/zgXwdVnvkHwwESXVBE+eTh3TC07UvwHxVoBq7THyI4uexejNJHsa5pNdU+7WUuozgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731557649; c=relaxed/simple;
	bh=/obiZqY5u6S9sB6CawVtRypVIKFQ0tCsRKXtcq4bR9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgaLpNyEhT3rPi+i95LN6FrIPjCZfLKWr3tg3CWBg/LfKMUwqAfe2KrEcCTn+scWncGHBRdobm6+oKK8ffno5XUHK901wsi+yMtkmc8er35iswTYss+6qp16aWdoRabbJCOpaQHUKm+X4UQONzsCHedg5qUhD7jdq/kGHr/tCi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fBkRajoV; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-37d6ff1cbe1so141693f8f.3
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 20:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731557645; x=1732162445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HzJUtYhk70OYS1BXABOZzA3PP2mUGfbEHdHP14EV0Uc=;
        b=fBkRajoVo2gogtxZZhXdDqXvy0A9xxkjJdDia9KWvbC3SZzmjeF40DUyv2aF8d75Xl
         Xp1X5V8lON62QtoIMbsvkxg5g6fM/EK4/XVO0QiSLtFoS60eradiOSGmEx+Z/L2Ipr1A
         22EKtlllG53Heb+NXYR3intFxQPewuSKAYsv0uSFsgKA7w+uOJe/BaATYN6YI2nsdXWh
         bfTcXouToz2l25UWVK5Y+H7U60DVIW5DdrLyWdRMf18YaK3edRPhvoNpS2vAOdt/XIqX
         UECuGXIKfevSx2dYekDx2W4qSVKnbJJviQ3r7hFIyKjgKLLZzYXYJcqaPBTXP2zs2mjd
         fQ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731557645; x=1732162445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HzJUtYhk70OYS1BXABOZzA3PP2mUGfbEHdHP14EV0Uc=;
        b=QhNJofnguaigsw4fxLa6YxqJ3d71hfr8NoHrWjBmvKDoBS9rV8s+RLKKL3+t1fthfu
         1ztRZfpjQyISvT9+/daHddeEDj3++mLs+BsL2oqZ3vqTczg/2Xej+x0oWLEJnej1sTGs
         FDM8wnECS2oU89fBljsHzP2ryZzpHSkDNl6XMx0H44otqiA7zkR3rHNvonzsHZiEdd55
         ijhWpWTBKRR9NKLA7JYOm/ZqbfBEGJjhDvwkiba5yErNfTVlOFbZAg01LVQJlPjWqPil
         HLflmUPbbnhJY/OIyFiPsmxVNI+qitK1Vibp4OslxBlKLaU5APcl+nGjkS9j2uOp1RY9
         ERRg==
X-Gm-Message-State: AOJu0YxqvMngvhWdThVsSaUCXsFH1PdUlTDgO+B1A4/tn7M1RocpcvSE
	+7QeOW6U0KvjX5YB3XtsY9mk4uQOHgCNBRMNT2knD16+ycNfYcuSUAmQow==
X-Google-Smtp-Source: AGHT+IHOVG0IjOQKRQ3aUSzPxndxQTkGVqICejHcKJSt+p8sMETbhyWbOL7jjM3zJfIMulk0zP+WeA==
X-Received: by 2002:a5d:6d8c:0:b0:382:d8c:2dc3 with SMTP id ffacd0b85a97d-3820df71a43mr4218824f8f.14.1731557644890;
        Wed, 13 Nov 2024 20:14:04 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ae311fbsm251936f8f.95.2024.11.13.20.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 20:14:04 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 5/6] io_uring: add parameter region registration
Date: Thu, 14 Nov 2024 04:14:24 +0000
Message-ID: <481f7a4973b86038f6b03f0d1e9ce4e127ced315.1731556844.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731556844.git.asml.silence@gmail.com>
References: <cover.1731556844.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow the user to pre-register a region for passing various paramteres.

To use it for passing wait loop arguments, which is wired in the
following commit, the region has to be registered with the
IORING_PARAM_REGION_WAIT_ARG flag set. The flag also requires the
context to be currently disabled, i.e. IORING_SETUP_R_DISABLED, to avoid
races with otherwise potentially running waiters.

This will also be useful in the future for various request / SQE
arguments like iovec, the meta read/write API, and also for BPF.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  6 ++++
 include/uapi/linux/io_uring.h  | 13 ++++++++
 io_uring/io_uring.c            |  1 +
 io_uring/register.c            | 59 ++++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 1d3a37234ace..aa5f5ea98076 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -324,6 +324,9 @@ struct io_ring_ctx {
 		unsigned		cq_entries;
 		struct io_ev_fd	__rcu	*io_ev_fd;
 		unsigned		cq_extra;
+
+		void			*cq_wait_arg;
+		size_t			cq_wait_size;
 	} ____cacheline_aligned_in_smp;
 
 	/*
@@ -429,6 +432,9 @@ struct io_ring_ctx {
 	unsigned short			n_sqe_pages;
 	struct page			**ring_pages;
 	struct page			**sqe_pages;
+
+	/* used for optimised request parameter and wait argument passing  */
+	struct io_mapped_region		param_region;
 };
 
 struct io_tw_state {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7ceeccbbf4cb..49b94029c137 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -627,6 +627,8 @@ enum io_uring_register_op {
 	/* resize CQ ring */
 	IORING_REGISTER_RESIZE_RINGS		= 33,
 
+	IORING_REGISTER_PARAM_REGION		= 34,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -660,6 +662,17 @@ struct io_uring_region_desc {
 	__u64 __resv[4];
 };
 
+enum {
+	/* expose the region as registered wait arguments */
+	IORING_PARAM_REGION_WAIT_ARG			= 1,
+};
+
+struct io_uring_param_region_reg {
+	__u64 region_uptr; /* struct io_uring_region_desc * */
+	__u64 flags;
+	__u64 __resv[2];
+};
+
 /*
  * Register a fully sparse file space, rather than pass in an array of all
  * -1 file descriptors.
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 286b7bb73978..c640b8a4ceee 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2709,6 +2709,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->msg_cache, io_msg_cache_free);
 	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
+	io_free_region(ctx, &ctx->param_region);
 	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
diff --git a/io_uring/register.c b/io_uring/register.c
index 3c5a3cfb186b..d1ba14da37ea 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -570,6 +570,59 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	return ret;
 }
 
+/*
+ * Register a page holding N entries of struct io_uring_reg_wait, which can
+ * be used via io_uring_enter(2) if IORING_GETEVENTS_EXT_ARG_REG is set.
+ * If that is set with IORING_GETEVENTS_EXT_ARG, then instead of passing
+ * in a pointer for a struct io_uring_getevents_arg, an index into this
+ * registered array is passed, avoiding two (arg + timeout) copies per
+ * invocation.
+ */
+static int io_register_mapped_heap(struct io_ring_ctx *ctx, void __user *uarg)
+{
+	struct io_uring_param_region_reg __user *reg_uptr = uarg;
+	struct io_uring_param_region_reg reg;
+	struct io_uring_region_desc __user *rd_uptr;
+	struct io_uring_region_desc rd;
+	int ret;
+
+	if (io_region_is_set(&ctx->param_region))
+		return -EBUSY;
+	if (copy_from_user(&reg, reg_uptr, sizeof(reg)))
+		return -EFAULT;
+	rd_uptr = u64_to_user_ptr(reg.region_uptr);
+	if (copy_from_user(&rd, rd_uptr, sizeof(rd)))
+		return -EFAULT;
+
+	if (memchr_inv(&reg.__resv, 0, sizeof(reg.__resv)))
+		return -EINVAL;
+	if (reg.flags != IORING_PARAM_REGION_WAIT_ARG)
+		return -EINVAL;
+
+	/*
+	 * This ensures there are no waiters. Waiters are unlocked and it's
+	 * hard to synchronise with them, especially if we need to initialise
+	 * the region.
+	 */
+	if ((reg.flags & IORING_PARAM_REGION_WAIT_ARG) &&
+	    !(ctx->flags & IORING_SETUP_R_DISABLED))
+		return -EINVAL;
+
+	ret = io_create_region(ctx, &ctx->param_region, &rd);
+	if (ret)
+		return ret;
+	if (copy_to_user(rd_uptr, &rd, sizeof(rd))) {
+		io_free_region(ctx, &ctx->param_region);
+		return -EFAULT;
+	}
+
+	if (reg.flags & IORING_PARAM_REGION_WAIT_ARG) {
+		ctx->cq_wait_arg = io_region_get_ptr(&ctx->param_region);
+		ctx->cq_wait_size = rd.size;
+	}
+	return 0;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -764,6 +817,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_resize_rings(ctx, arg);
 		break;
+	case IORING_REGISTER_PARAM_REGION:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_mapped_heap(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.46.0


