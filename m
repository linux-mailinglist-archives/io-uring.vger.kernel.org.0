Return-Path: <io-uring+bounces-4703-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8A549C90EB
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 18:38:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75B89281987
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 17:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E32EA18BC2A;
	Thu, 14 Nov 2024 17:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d4Kubfcp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22503262A3
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 17:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731605894; cv=none; b=cuXR25VVOW/n/4iwTq7e8hlb5cpgRXlDRlnkh0c0PxCr9awxbCAM9XNiNelyjt5v6zwJCB+XrM5K9lO12/+vH72Oe61EUGi0CSygRc2ZaG8fdB/zB804BGEMzJ7HTA+ORBVD0ym122kxkVlejOJWWKxyIkmnGJFTurKUgzSs6Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731605894; c=relaxed/simple;
	bh=LNgFjHLiBir6oEIW8ncov4hMQdVBoAL03Xq3o0BzmJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKhrvTEMkveLVanEgb+SwDgLhDf4AbInW4ddEK/FdIsIfwwY0SmycGDNfRen66CszE1h8iNZEiLYwXgDHK8IWgYlKYIkTTqe3Ooy26sBDjqeJWaPaVLmIAhfoIO3nl7CEXkQKjqbCdw0JTdWzKHEO2+h00orfo3SGqtnvTxRtTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d4Kubfcp; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5cb6ca2a776so1534963a12.0
        for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 09:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731605891; x=1732210691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rK2Es19MgdCzXZpmiUCx1KpjgTYixs0FFvqPiUOwGyE=;
        b=d4KubfcpiPd/ANUeD/ru51MxbQyAaTm61ckC9u8CzpVZ2uzB5cOIBSAPBODasqwoIF
         75BoyGL8Yd5dcZERUejnAK/r5e1iUJKRvyo2tUDNXzXn0dtB9QoYZ44/uMX/TEb6fSuC
         lD3zWucwzh+wvi1OMjp1L/xTQLgsGu9GdRU/8OxQ9RAA4JtjWeTD4UBTowZP+6m0AD+N
         nVYUIyUlJUim2pXQ/6dlR4I9lHVetdaCZD4pW+UCFryWyXbh4mEAuk0aoybb8YjtWibf
         AfKpraHseS2JPo5oMHZqa/7+Ue/fEX4Ir3EWwxKTY89ZcneWDrZmUo4b34bav+9WpW09
         E89w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731605891; x=1732210691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rK2Es19MgdCzXZpmiUCx1KpjgTYixs0FFvqPiUOwGyE=;
        b=mHjlPfrbKg/McUGfbpLLhwRgxeXOSNclzonjUG4HYgj21dVa/pKRHfF9uwqgv5yzgB
         cLs+zliwkfNFphK0ypfSApXhmRK10D8yf1JExjdKqM0TuBGjrtsi0PclXXm2vwVpCLFU
         colCWC9pvqIwj9Msb8zmGTx+fnb/AfLhEPwgv32p91eKgBkyN3Gv/xrgcZb1OB/f/g03
         Sf7qMSLjH+E8rN/0y2uD4i7npPiNBXPtC2IIY1n9FiFcHjnlbZlPe0Jq6EPx97yOfC2B
         o+loTbz0CIx50yuEk2GbIjLNXHBfcqpGlqviGW4YLOXZKwDcH/yd7QBMpxJUEQlf6yDF
         LgHQ==
X-Gm-Message-State: AOJu0Yyv10pJ3W7EdvZOEeEq4i9S59Ra6znPeLFLr4PrLdiwcTV1DCRE
	9bwSRSdwyVeRH/OtIibqHi85KT3ntAa7O7urpM1/bJgsGz6AOUHVymBBRA==
X-Google-Smtp-Source: AGHT+IGdXbqRjcDjqcCMd7GwWsdcPsPqhg28WyCNh5h6lv9ND4VBLteor9VFGPe8msOiJyzFAMzWMQ==
X-Received: by 2002:a17:907:c12:b0:a9a:76d:e86c with SMTP id a640c23a62f3a-aa1c57ef2c1mr1203170366b.49.1731605890465;
        Thu, 14 Nov 2024 09:38:10 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20df56b31sm85799966b.72.2024.11.14.09.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 09:38:10 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 6/6] io_uring: restore back registered wait arguments
Date: Thu, 14 Nov 2024 17:38:36 +0000
Message-ID: <24cce6841e4d5ebb3a33bb602a94f5ded77757c3.1731604990.git.asml.silence@gmail.com>
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

Now we've got a more generic region registration API, place
IORING_ENTER_EXT_ARG_REG and re-enable it.

First, the user has to register a region with the
IORING_MEM_REGION_REG_WAIT_ARG flag set. It can only be done for a
ring in a disabled state, aka IORING_SETUP_R_DISABLED, to avoid races
with already running waiters.

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


