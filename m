Return-Path: <io-uring+bounces-4702-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E42069C90EA
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 18:38:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3D682814FB
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 17:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76D8017A583;
	Thu, 14 Nov 2024 17:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PM4JUOTH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9798B18C32A
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 17:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731605894; cv=none; b=b+cdlLmzZReVHLuV0w9EngDbLKASpIbIl5w8AFUycW0Ql5gcM+HZNs+qNFMlQAQdFKwpsr9SrzPnuxfp0higP1plVx2lk5PIwBYRjC3PrISQVuEoB08NhTyqinS2h8k24Gh9GeskQ3mPc4NZEawNcUfpEf5c5NuXo7qMujdTk8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731605894; c=relaxed/simple;
	bh=Hvv9oNYi9s1ueMiugtSN67O5L03GHYmR01AxOAkhpj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMDzyfbEwhedQ8PpPaisgWbqOKtDK5SS7ZbdcnSbvJRfIXIt21WlSMUO0cCDD/161qBwQi2okn6QJbdBuzk+OQDlLUPbtDuvvmVTgzpU5aOqxS17vN0VhHsHBauN6KcS3FGZbQ4hSZreiK44QDPAMI2wfYIHxNmPXgPAOltt1ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PM4JUOTH; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5cf7b79c6a6so1122178a12.0
        for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 09:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731605890; x=1732210690; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BBdhYIPS0vNHqswEqOk5yrUEAAdG6KLAA34YHKFu7Dg=;
        b=PM4JUOTH4sFleYMtA84JOS0LOFTib91SZkWqXFI6Ry3wO4UvkQvhSbf1kBZYXnaYbg
         hKd36PbN8k2+Y/8UZALJazLZd53LH0PKfnOBh5KabgbzAf68nzKcJM7B1OZ27MwKcP1d
         iesXZyqUof0B0PJTQRemgVW0Geq1w9WeOVPTmZ2Pz9bMwWxs1JmepPYBKiaBNIKTmfEL
         AnqIh4xS++TrLHskGVWGhEjsyfyWmFRO3yFQzLBx9CfJZVb7tYVQ9e1oI7TLoGDsWF76
         Hv9R6RVoEQM6q7GhoqySFOCGGqVZcwC2xHnwi9oIF0/0mRixwO2Mc6+KOhXpVVxL7b53
         iL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731605890; x=1732210690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BBdhYIPS0vNHqswEqOk5yrUEAAdG6KLAA34YHKFu7Dg=;
        b=q4YELnDCB9QSKit6dJ0zqPBuEoXoqYzKUZAO13Zve8Hfm3UPNvuvFiu2r47TXywCHQ
         OetbblF85VdjW0Fc1h9LxtPIyfigqZcwK/OIVuETTlPyPiB/AhPmqkQWuz1brd/ErlWo
         y96RdG7KoHnFBfdivJNI/Ga7wvfSM63jfrqO4mDrJi5XCX2sVbe4jpi9ueoXERh1hF6A
         gBAJoPssrNZwHRmz7imMvX0kIEIj21MM9XugBXbmzwi9vI/OwqeZwbbclV/9a92cgy0f
         hQKRWzI44lEtTrWIXPjD7LpjV/Nc1aKuUISHMKPryN2S1NP176ETZmlSaO1v8/9etCBM
         EIeQ==
X-Gm-Message-State: AOJu0YwryM5cvhYHVCvBULu3+BkdUvmcV1wALbzeNqSw7UVkK2IgiS8J
	3aiaGQXz4mwqcLc/zdyxpipgY4XOkfo/SVoYQ7oOzbPN/gKOoHVvhYwQgA==
X-Google-Smtp-Source: AGHT+IHlYpQKVwJlFOeV6I9fXUDp1PaHkJH3V73OPfYVXb//NOvKJsSY2ncAQ4A9Ra7OxXJJypH9JQ==
X-Received: by 2002:a17:906:fe4b:b0:a93:a664:a23f with SMTP id a640c23a62f3a-aa20768144dmr453771566b.5.1731605889772;
        Thu, 14 Nov 2024 09:38:09 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20df56b31sm85799966b.72.2024.11.14.09.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 09:38:09 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 5/6] io_uring: add memory region registration
Date: Thu, 14 Nov 2024 17:38:35 +0000
Message-ID: <1bd8b8abc945bebda2b465b54218be94a2f93d85.1731604990.git.asml.silence@gmail.com>
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


