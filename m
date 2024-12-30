Return-Path: <io-uring+bounces-5631-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B0B39FE66F
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 14:29:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1F33161C41
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 13:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E8C3EAD0;
	Mon, 30 Dec 2024 13:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KdV8QtP1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB901A08B5
	for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 13:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735565388; cv=none; b=eRj2agcuzEngKEyJ+lXlfT7YwoFH0sABKaKExWKfdzmJ7SjVOIUElmh0OdrSEboZ3yCTjcQUpN+bf4w2GKS+h4n4+/3yeue2J7D9y3J/q60KmNPKMf1+/4M9hfY8m5YxNdnl+faHnK0RXiUQMztuiSIKQYnAUOsr6WL+B0GcGy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735565388; c=relaxed/simple;
	bh=+ru0m8VCABWKI7i0qu6q8mWEx0ePC29pq0nhVnZNlUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/upWAXxSJnCzHd00p5FTg64sW1SgOhBlVdul4Va+HY8bqzBxk808UpdAbNanRYTECYZWsLOlSLvRRyHAsCHIU/Nmj0fFkpolZUzdTh8HoSWkM3b1j4K2ac+CTYQWWbWPWE9Y7XCqak0bF/PTae88hytmMo0lPAp43NbDHiC2uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KdV8QtP1; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d437235769so9794302a12.2
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 05:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735565384; x=1736170184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rBhlBvWPHzIweREjAp3dpOzDzxy4v1SZqhMGYzz78iM=;
        b=KdV8QtP1CxtvGtjmVqqSk+6FIHsEQRsjMVFK5l7OQvjqM+l7dcXoEc+2CY+gzWfTWJ
         D3kGanDi79El9z175FcPndRAIrXwxOoyzGIpfEa8WlW8jySqux8n0JzhK6T9fyF7ZtM6
         qHLsqYuLSUu8uiuKAFVpui42kLjOBirY5C69sX0VcCtzU62dIiJbMj++s8DZCLLv8H9R
         4RGWDKGMnuE69agXvJigD66K8ugDjkWxgCYv/8ATbOxe0meiHyW4mgle/nTs5tTJbXB9
         e4802BYQB+JGjvn1GhpqKhtmr8ouacC3jVOaYYYCsWKAO5ThDBF+xDOyLLrc+fJwNt7w
         r8mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735565384; x=1736170184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rBhlBvWPHzIweREjAp3dpOzDzxy4v1SZqhMGYzz78iM=;
        b=lCqnt50zbAGFFAqA5Z05wfdmseLavGYR2S0PXdHH5oCN/yBnac3lLOpkD+vlBN+MkT
         qYaWi1O64aglygIwFxvQlByqiXOwApyv9YZRI74nxoTPkd5AqKXxJtZS0zd1Pb2lVkDE
         Vt146UZRcYJK/pGuJ8mRegtcUH6hlKdXi2wupbl0ACMV0S9/3QoeZXjFkTDlSGeZlNfd
         n/8DOftBY3p/4+RwBbomqAbxP4/kSTwq/VeZseWrGkWIaHqAygLd/2Q/AilmeGAqYk1p
         sWzv/eQswWF+XgrugSDh6NHxSP6xm5ZRKvno/xaq+gSmFO2uYJ5naQvBPWcm9rjSCFWy
         RU5A==
X-Gm-Message-State: AOJu0YxevBZjRGqWA7i2Tm5DtvH6bcTluk92B9sLj90ADDYVUF3jwPIh
	hETCmxkwPtWnSvT0QrjHz1ZBVQM9A/7A3zhY9omgHqKNOgJDGcKFu23+XA==
X-Gm-Gg: ASbGncs2EvtlT7ge9/1yimIZQ68vfmRvni9WaPsIVahffNEzwq1i2OIPYFB5A/qR0Kl
	CFbhntoDPwnLCDMHZmxXriWsBfcTJc2hzIHBJS6ssiPnsLDSRF2gk7cg3awrw34KtMh/GoQNK+H
	XkxxkEWb8iQuRA3Q9OhAL5dAq3DYDZUWUPDb+bGQCCzWjdyKSONQgEXATj3jhLXeaNYMGDFCPHT
	ktMMEcHBcFb7ycClJI2ZUKeNIhowNtpnFLlxxwVWdzZ6lfKA1EQI8w7xS8sYtumL8SpDA==
X-Google-Smtp-Source: AGHT+IH3fPCCFrf72r54Wb4YNbi8rViwVPRtCJue6xj4E717AlRiqQGBD+fD/9KpG+k+qGvsiZHCDA==
X-Received: by 2002:a05:6402:348e:b0:5d3:d9f5:bf08 with SMTP id 4fb4d7f45d1cf-5d81dd5438cmr34394429a12.7.1735565384099;
        Mon, 30 Dec 2024 05:29:44 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.209])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80679f35csm14694286a12.51.2024.12.30.05.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2024 05:29:43 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 1/4] io_uring: add structure for registered arguments
Date: Mon, 30 Dec 2024 13:30:21 +0000
Message-ID: <dda0a555cee9b774ef3833273c98a288744562a8.1735301337.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1735301337.git.asml.silence@gmail.com>
References: <cover.1735301337.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A preparation patch making infra for wait arguments a bit more general
to use in in following patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  9 +++++++--
 io_uring/io_uring.c            | 23 +++--------------------
 io_uring/io_uring.h            | 16 ++++++++++++++++
 io_uring/register.c            |  4 ++--
 4 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 493a8f7fa8e4..49008f00d064 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -83,6 +83,11 @@ struct io_mapped_region {
 	unsigned		flags;
 };
 
+struct io_reg_args {
+	void			*ptr;
+	size_t			size;
+};
+
 /*
  * Arbitrary limit, can be raised if need be
  */
@@ -332,8 +337,8 @@ struct io_ring_ctx {
 		struct io_ev_fd	__rcu	*io_ev_fd;
 		unsigned		cq_extra;
 
-		void			*cq_wait_arg;
-		size_t			cq_wait_size;
+		struct io_reg_args	wait_args;
+
 	} ____cacheline_aligned_in_smp;
 
 	/*
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5535a72b0ce1..e2b6b256fc9a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3178,25 +3178,6 @@ void __io_uring_cancel(bool cancel_all)
 	io_uring_cancel_generic(cancel_all, NULL);
 }
 
-static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
-			const struct io_uring_getevents_arg __user *uarg)
-{
-	unsigned long size = sizeof(struct io_uring_reg_wait);
-	unsigned long offset = (uintptr_t)uarg;
-	unsigned long end;
-
-	if (unlikely(offset % sizeof(long)))
-		return ERR_PTR(-EFAULT);
-
-	/* also protects from NULL ->cq_wait_arg as the size would be 0 */
-	if (unlikely(check_add_overflow(offset, size, &end) ||
-		     end > ctx->cq_wait_size))
-		return ERR_PTR(-EFAULT);
-
-	offset = array_index_nospec(offset, ctx->cq_wait_size - size);
-	return ctx->cq_wait_arg + offset;
-}
-
 static int io_validate_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
 			       const void __user *argp, size_t argsz)
 {
@@ -3233,7 +3214,9 @@ static int io_get_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
 
 		if (ext_arg->argsz != sizeof(struct io_uring_reg_wait))
 			return -EINVAL;
-		w = io_get_ext_arg_reg(ctx, argp);
+
+		w = io_args_get_ptr(&ctx->wait_args, (uintptr_t)argp,
+				    sizeof(struct io_uring_reg_wait));
 		if (IS_ERR(w))
 			return PTR_ERR(w);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 032758b28d78..a18da74f18e8 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -514,4 +514,20 @@ static inline bool io_has_work(struct io_ring_ctx *ctx)
 	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
 	       io_local_work_pending(ctx);
 }
+
+static inline void *io_args_get_ptr(struct io_reg_args *args,
+				    unsigned long offset, size_t size)
+{
+	unsigned long end;
+
+	if (unlikely(offset % sizeof(long)))
+		return ERR_PTR(-EFAULT);
+
+	/* also protects from NULL as the size would be 0 */
+	if (unlikely(check_add_overflow(offset, size, &end) || end > args->size))
+		return ERR_PTR(-EFAULT);
+
+	return args->ptr + array_index_nospec(offset, args->size - size);
+}
+
 #endif
diff --git a/io_uring/register.c b/io_uring/register.c
index f1698c18c7cb..b926eb053408 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -604,8 +604,8 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 	}
 
 	if (reg.flags & IORING_MEM_REGION_REG_WAIT_ARG) {
-		ctx->cq_wait_arg = io_region_get_ptr(&ctx->param_region);
-		ctx->cq_wait_size = rd.size;
+		ctx->wait_args.ptr = io_region_get_ptr(&ctx->param_region);
+		ctx->wait_args.size = rd.size;
 	}
 	return 0;
 }
-- 
2.47.1


