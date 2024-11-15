Return-Path: <io-uring+bounces-4729-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 035B39CF22F
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 17:54:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86C0F1F2B2DE
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 16:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77B7D1D47A8;
	Fri, 15 Nov 2024 16:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dGaHAEjq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A7C1D63FB
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 16:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731689650; cv=none; b=Jb09Nt1OTEhZ3cYRIXf3rUinusE6iDXQlAnUpHYrPbFWVzEx5qi8zU3kfFNghF3i/KaXICrZC6WP4ajRRGBR8alFPdRIlDsSae37pCGgsq3kCnHaP0tzwNLsO2SjjjjRo2pEoQvGioIx1KSnRRAn6ITc2/5e/HeHXdXnntVnd20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731689650; c=relaxed/simple;
	bh=Hvv9oNYi9s1ueMiugtSN67O5L03GHYmR01AxOAkhpj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0HWoyQCvsW7Stqew9WcaAlIcUWXWrqbehFUH6yp9cFmJin1vkXlNWXl9Y8GSxAgjuqC1ZVdZwbbS935ObqCBq3HMmif6mCs8uInin0YYYT8vRUDPvJwYX3hit1ox9CxMi8lLcEPoijucqTIvV+xLpYfEJSeh2GzGJt37OwenQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dGaHAEjq; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-38207c86695so1444622f8f.2
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 08:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731689645; x=1732294445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BBdhYIPS0vNHqswEqOk5yrUEAAdG6KLAA34YHKFu7Dg=;
        b=dGaHAEjqIbsUBrQmfccE+dUufFiMb3DsBHqx3x9cyVW8B+Zj+CQOCWP9OPWQt8r2eD
         lc4VZfnhzr5mWU0ImelSWfeCZkmcMl3rHnAmVBpwOAxcKo6xfCjhYXMyV9jzekpj+/U3
         Sj0wzm3MLN28bsVh5mSGRpiH+LQjYn5PWO3m/wC7YMZksG5NHdBoZKywd5DaFs6dEC+z
         hPAwVOr2c0SiPuE7wBLrB0lr4/EJRv9r0/cJ7bwruLIlozXpCMiEZcwwJi4GfJZCTWGN
         NakCM1y0iys+50CC+H7xhyqKFVacjFIToUC6QWkJeJnDS0MEZBUzSVJuB+FawhO+uZY7
         Z5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731689645; x=1732294445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BBdhYIPS0vNHqswEqOk5yrUEAAdG6KLAA34YHKFu7Dg=;
        b=Pn4RP0FOtYcTUTP8Q5sZZ6bk82FuELNJ+OFYtfBVWxR91Wy1S9s2Ke+x7VwwBvwdzU
         qPQAF1V7x/0BNVYIwE9pd0knh4iC1tSJhAPMJL7oNnkSBPBQ/Rf1UHXlabQq/S/EcHIP
         OEly8FeV7Uw8IpHVDn2qnkS80KYMoPhfwOJ3DEXZ9ihlprQYrSaD4wzcgcKv7xNuiTAi
         5Sgw4LMrV3tK1p3FPMzgNGJeTs/4AscvPHkSUy7ehcoB80G558iN9bC1inPBZdgL26R5
         NHxwJF9hC2BJtHk3eJahXz7RZYay/usrw+n7JDoJrlecdG6ZznNVxklmDwJRc4c55pj1
         o9wA==
X-Gm-Message-State: AOJu0YwGp845+VIyEE4QXR9CRMnXBABKzFwYI+9gkgL6rd92QqJuBK8L
	80PEVJ967+NfubQ8/md6+PAqQCRwW43ooOn5J8UXn6WjlHtcKsAk9jRXQw==
X-Google-Smtp-Source: AGHT+IH0NVr6PYH1ZFuCERS3jlM3NzaeEUn12ufD9zkPU7T66hAyc1AZEH00+TvvD/SbO9oWvGylfQ==
X-Received: by 2002:a5d:5847:0:b0:382:1504:f064 with SMTP id ffacd0b85a97d-38225a88a05mr2708795f8f.42.1731689645215;
        Fri, 15 Nov 2024 08:54:05 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ae2f651sm5011895f8f.87.2024.11.15.08.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 08:54:04 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 5/6] io_uring: add memory region registration
Date: Fri, 15 Nov 2024 16:54:42 +0000
Message-ID: <0798cf3a14fad19cfc96fc9feca5f3e11481691d.1731689588.git.asml.silence@gmail.com>
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

Regions will serve multiple purposes. First, with it we can decouple
ring/etc. object creation from registration / mapping of the memory they
will be placed in. We already have hacks that allow to put both SQ and
CQ into the same huge page, in the future we should be able to:

region = create_region(io_ring);
create_pbuf_ring(io_uring, region, offset=0);
create_pbuf_ring(io_uring, region, offset=N);

The second use case is efficiently passing parameters. The following
patch enables back on top of regions IORING_ENTER_EXT_ARG_REG, which
optimises wait arguments. It'll also be useful for request arguments
replacing iovecs, msghdr, etc. pointers. Eventually it would also be
handy for BPF as well if it comes to fruition.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  3 +++
 include/uapi/linux/io_uring.h  |  8 ++++++++
 io_uring/io_uring.c            |  1 +
 io_uring/register.c            | 37 ++++++++++++++++++++++++++++++++++
 4 files changed, 49 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 1d3a37234ace..e1d69123e164 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -429,6 +429,9 @@ struct io_ring_ctx {
 	unsigned short			n_sqe_pages;
 	struct page			**ring_pages;
 	struct page			**sqe_pages;
+
+	/* used for optimised request parameter and wait argument passing  */
+	struct io_mapped_region		param_region;
 };
 
 struct io_tw_state {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 5cbfd330c688..1ee35890125b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -627,6 +627,8 @@ enum io_uring_register_op {
 	/* resize CQ ring */
 	IORING_REGISTER_RESIZE_RINGS		= 33,
 
+	IORING_REGISTER_MEM_REGION		= 34,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -661,6 +663,12 @@ struct io_uring_region_desc {
 	__u64 __resv[4];
 };
 
+struct io_uring_mem_region_reg {
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
index 3c5a3cfb186b..2cbac3d9b288 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -570,6 +570,37 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	return ret;
 }
 
+static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
+{
+	struct io_uring_mem_region_reg __user *reg_uptr = uarg;
+	struct io_uring_mem_region_reg reg;
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
+	if (reg.flags)
+		return -EINVAL;
+
+	ret = io_create_region(ctx, &ctx->param_region, &rd);
+	if (ret)
+		return ret;
+	if (copy_to_user(rd_uptr, &rd, sizeof(rd))) {
+		io_free_region(ctx, &ctx->param_region);
+		return -EFAULT;
+	}
+	return 0;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -764,6 +795,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_resize_rings(ctx, arg);
 		break;
+	case IORING_REGISTER_MEM_REGION:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_mem_region(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.46.0


