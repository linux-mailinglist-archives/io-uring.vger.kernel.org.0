Return-Path: <io-uring+bounces-4730-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3539CF230
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 17:55:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B6D3283E05
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 16:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C698F1D5ABF;
	Fri, 15 Nov 2024 16:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z5ESlnpa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B9D1D5AB7
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 16:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731689652; cv=none; b=MTl6Mn9+dd+yHv9zADi3Q/mpb6dvzjYZ2t1RydhWgQVfK5m21W5bGhD+oAH/DaUpkXF65LZL5ix/caAygldFCW0gc4LliWkxa7fv95KyjL7+6fGHGikknUjDdYXfBKO1ABhrp4GsX+JC/B9yXG5jZZBsP0yiM2mbrTulWERk/Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731689652; c=relaxed/simple;
	bh=EIbAFT0q3kOELpCDsKQQyLXO15L65KHz1yWcNvLLmhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjrgSIvt3poEV8yEc4K2u3b86orkRjLmuzHqVCQo6TQHHIzQQK5hapr6k4MGY4nlyvIueq+X59rv0j2v+rokmpIQ2ZvZWF25P8bxHwYZCG+rkFdQSIUyvn5ZlblhXriZHEN7lO0MgfMELzbAWsIM1DZec46/XVLIxKCXH1QSlwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z5ESlnpa; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3822ba3cdbcso346058f8f.0
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 08:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731689647; x=1732294447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=stTh6Z/X5iv3BRtWLpIQnccw9vPRWvFo0Vx0AyhXGUk=;
        b=Z5ESlnpahVRVGnL/2i+d6IL445r6RAtI5purAVPmBZe8sA2JYHPtaPSuBnBRW1XL3+
         IIOMxbCnBLnsmOVuf3+uuliwthM9Ve99FyP0zEPOdaD9x1bltVKJ4fsP8KNZSLfbIwqQ
         DCU+13BDagJ3F+gT87VBPmCC1oSUaXDdrG0DBZpFEfWDs8ydFIw4Z9wAxEmL+28qzTxL
         608vDiPp0nADPM0BcZejdhDLdPb9tVicTkB6wQVEaR5Tj6XNnY2gHtJr6q4Jb9tn0u1V
         bDv20epEQQkqMkEtuFFBIW60FXYXwmEArl4eW8sF52fKryPR7rL7xnQE1i6UGVQDdPcd
         bFUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731689647; x=1732294447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=stTh6Z/X5iv3BRtWLpIQnccw9vPRWvFo0Vx0AyhXGUk=;
        b=eboqOjjnGmdj8zvl7W/5f0IFHSS6IlW7eY3C1Opm4uqWmcyydCnzXphrkNpe42HQSN
         xEv9whWsuoRJCoOfrVmgl1h5KPUrTJpysgVxlWQTG0309KyzApExHJX8mMiY80Tyfl6E
         hDjMVRojo7mPGTV83GAbeqRqXfnnHJaXOse1JiEuTS2ENFG1ptLDqlMoNhOl4dSafnI8
         kRx6c54aDESOvYeUAQT878CpXl9JtsOsNYTHDhzh5Nal0J7HDEZ1deSqSyejyY3M7mp9
         WnXjLLvw3wBnjgjUcujQTpE+9SRa/Qoog3Z8cluhiSOgKpm75NIdTYIGzzwPme7/fak9
         39jg==
X-Gm-Message-State: AOJu0YxD4k/AzXJvoP8eQtzj97VJzwO6wapIkXC6AuyVmlLD32ox3AIx
	e88VypaQFkEEADfFJpjS+b6Pk7rDhy7UIRw4rKiw82J85ZmifQha3lJRvQ==
X-Google-Smtp-Source: AGHT+IHiqAyl/4K6MoZxsKhNsBln47g8pRtzc2h/QAre3wrl0HzEstBRbXgb378X4Ag5glOGiBUsXA==
X-Received: by 2002:a05:6000:991:b0:381:f443:21b9 with SMTP id ffacd0b85a97d-38225901b81mr2461172f8f.3.1731689647419;
        Fri, 15 Nov 2024 08:54:07 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ae2f651sm5011895f8f.87.2024.11.15.08.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 08:54:05 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 6/6] io_uring: restore back registered wait arguments
Date: Fri, 15 Nov 2024 16:54:43 +0000
Message-ID: <81822c1b4ffbe8ad391b4f9ad1564def0d26d990.1731689588.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731689588.git.asml.silence@gmail.com>
References: <cover.1731689588.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now we've got a more generic region registration API, place
IORING_ENTER_EXT_ARG_REG and re-enable it.

First, the user has to register a region with the
IORING_MEM_REGION_REG_WAIT_ARG flag set. It can only be done for a
ring in a disabled state, aka IORING_SETUP_R_DISABLED, to avoid races
with already running waiters. With that we should have stable constant
values for ctx->cq_wait_{size,arg} in io_get_ext_arg_reg() and hence no
READ_ONCE required.

The other API difference is that we're now passing byte offsets instead
of indexes. The user _must_ align all offsets / pointers to the native
word size, failing to do so might but not necessarily has to lead to a
failure usually returned as -EFAULT. liburing will be hiding this
details from users.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  3 +++
 include/uapi/linux/io_uring.h  |  5 +++++
 io_uring/io_uring.c            | 14 +++++++++++++-
 io_uring/register.c            | 16 +++++++++++++++-
 4 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e1d69123e164..aa5f5ea98076 100644
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
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1ee35890125b..4418d0192959 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -663,6 +663,11 @@ struct io_uring_region_desc {
 	__u64 __resv[4];
 };
 
+enum {
+	/* expose the region as registered wait arguments */
+	IORING_MEM_REGION_REG_WAIT_ARG		= 1,
+};
+
 struct io_uring_mem_region_reg {
 	__u64 region_uptr; /* struct io_uring_region_desc * */
 	__u64 flags;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c640b8a4ceee..c93a6a9cd47e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3195,7 +3195,19 @@ void __io_uring_cancel(bool cancel_all)
 static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
 			const struct io_uring_getevents_arg __user *uarg)
 {
-	return ERR_PTR(-EFAULT);
+	unsigned long size = sizeof(struct io_uring_reg_wait);
+	unsigned long offset = (uintptr_t)uarg;
+	unsigned long end;
+
+	if (unlikely(offset % sizeof(long)))
+		return ERR_PTR(-EFAULT);
+
+	/* also protects from NULL ->cq_wait_arg as the size would be 0 */
+	if (unlikely(check_add_overflow(offset, size, &end) ||
+		     end >= ctx->cq_wait_size))
+		return ERR_PTR(-EFAULT);
+
+	return ctx->cq_wait_arg + offset;
 }
 
 static int io_validate_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
diff --git a/io_uring/register.c b/io_uring/register.c
index 2cbac3d9b288..1a60f4916649 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -588,7 +588,16 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 
 	if (memchr_inv(&reg.__resv, 0, sizeof(reg.__resv)))
 		return -EINVAL;
-	if (reg.flags)
+	if (reg.flags & ~IORING_MEM_REGION_REG_WAIT_ARG)
+		return -EINVAL;
+
+	/*
+	 * This ensures there are no waiters. Waiters are unlocked and it's
+	 * hard to synchronise with them, especially if we need to initialise
+	 * the region.
+	 */
+	if ((reg.flags & IORING_MEM_REGION_REG_WAIT_ARG) &&
+	    !(ctx->flags & IORING_SETUP_R_DISABLED))
 		return -EINVAL;
 
 	ret = io_create_region(ctx, &ctx->param_region, &rd);
@@ -598,6 +607,11 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 		io_free_region(ctx, &ctx->param_region);
 		return -EFAULT;
 	}
+
+	if (reg.flags & IORING_MEM_REGION_REG_WAIT_ARG) {
+		ctx->cq_wait_arg = io_region_get_ptr(&ctx->param_region);
+		ctx->cq_wait_size = rd.size;
+	}
 	return 0;
 }
 
-- 
2.46.0


