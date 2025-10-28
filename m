Return-Path: <io-uring+bounces-10274-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C28D9C16490
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 18:49:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 107CF1890C39
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 17:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 224B234EF03;
	Tue, 28 Oct 2025 17:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ejjqG8so"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E39D34E763
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 17:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673612; cv=none; b=Sp5qFoS+mG6q4gZM8kwL92rVDEp95v1nocc+9ybvbkyLHo+Ty0ZqpdPvCi25WnZXq4NN3nUEYwJMow5W5OCGG9/BEfYnlv0idaAxxeqw2r76SLC8UvS0BQR3GjneqWW/HTVHSggCzgYeDVSh0HZOe2+983hk2hQHz9LWvX6RcrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673612; c=relaxed/simple;
	bh=TcybaV/arDyPRZ9sIjbNCWGw0A42uwYy7ztzzlt6cTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YW9Riw4eczuvcK/hck2whNghpK+P1HdvkmrAhfB1tf/Gk73BGgCHpTc2YFoW390a55AEIdT2+JjBe/JNHaVoupxqVCR7ONqsqwFhe6GApAoyeydivJhUQ9xTTNYgw2Puu0YdTpeyI+8UND/5AFvT9gqv0W3kUJut5tBGiNICWJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ejjqG8so; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7c532d70cfaso2531341a34.1
        for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 10:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761673609; x=1762278409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HZNIb2h6luQOgMaEgUx8xsYqsfsV9Ws4/qiwDX545Pk=;
        b=ejjqG8sokqf1xXOcj/22p11xhs2pGDBhj2r7TQ/Bh+asvqFXBgKw9J4WvVJt8QHOmk
         IEWqcDtn3eld6+poEf0S3z2DYG26K7JC95EoD/JkEU+vTn9fEtYJIX1Z8pjPkxIBvSvI
         O2TMzVZ8HM39cUzUnMaX6ropiJLYMwgbgwPtn3ore36dA9+5lVyqtatuk5iWSkB3MCPZ
         PFxTHIqYiNQD6arm81a4hcXMYswwDHp13saXn8XuXfP0rD6j0K57zhYe/L1wKtY69a55
         esHlVh8owMi8BvlRIozx8jdFpuX55UbzxxAlMNaNvcVC6SUDbOueqZpkP2M2wCcpMa7O
         Pxug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761673609; x=1762278409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HZNIb2h6luQOgMaEgUx8xsYqsfsV9Ws4/qiwDX545Pk=;
        b=L+UAY1amho+Qw3ZtynBAsUhYK1tudGET3SVTn83dM8zCHnSTU+VoNhHW6x/qO+VB73
         Qit9lzPG7L2myDnf2wvUzcBi6shYpupw5+0K74+7y1fQ37iDSlXDNKVDDBYm6sqMSjUe
         TWHz7Ew13o8wJTuJgU+vDQ5VqsdSnUKaPLFJPLQiJXHWNUgmyQZKx295hPkyFtHpc/bb
         XaRwOxNaqYRSBvMuYfQjX7Y68QYjkG6wB25ekhwrdSJANfnscqQLd6z9aQGvy9cBT6Se
         +luz2nU6Z8XZiVWE6lZAG/KBx3j6dCQ9J1REGrS7SNHa0FepoCISiioWgrZHduuoJzL2
         EwgA==
X-Gm-Message-State: AOJu0YyA61mb88jr7qgxs9lgRf9EYRsXPNI/9gkxIs2+v4ai5INo6e27
	1kr5n6nH8G5Ncvt/F8/NJrPNTbCbIyWbTEcpos6V7haaq4VevTW4yySc4pknSxt8UiRdgOOW+iw
	242bc
X-Gm-Gg: ASbGnctP9nM7tEe3kj7BZqzrXm8YgW6XEb/3m3/jOXESh0s1pruQ4B1PTkWTXpPB5Vv
	Rl1AhUYm2XJJJ0n2Jj0Swk4Mt9ersBZh/x21zgEF1Y1D3PijSR+NJxkcRK0GBabEKsITU/KXq3a
	evj0fIdO1R2BZQu7j9v2ayX6ZYXPpaiBKaBAHjkaJFWT1yH0bUp0ZHziCtgmFxM1hlz6o65QAf/
	1uOA5Bz7AEIWlr09dQazZz6sTLU63E4cYKBnKoXZcWzhY4MVNhE5pYnGRGT+NJSs79zm/Dzm+Ql
	quEVITJTbt5FpI04U6V6JEsAJ0KAHlSgZMDNFFu338CgrGtj3HfgiYRotsbWvl9DOhJmixZPCjC
	6/9AuKm7ioRsvpzk4acHhi2F1A1HKbY6I5axyZUVSDJfC0vPBOVuiIp9iH62p73rdNZGmo43PUi
	OGtkuBjQWMINPfNWs6B733VAe8yyVx7Q==
X-Google-Smtp-Source: AGHT+IEnOyIfRKYLBJcPdvQaau/lQXF5R1BNYdBuE0oOchLVAAQkNLfABVhUAAg/Qm88ZIYndJ8lZQ==
X-Received: by 2002:a05:6808:301f:b0:438:bdb0:89a0 with SMTP id 5614622812f47-44f7a455a60mr150247b6e.24.1761673609565;
        Tue, 28 Oct 2025 10:46:49 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:72::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-44da3e205c2sm2771422b6e.2.2025.10.28.10.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 10:46:49 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 8/8] io_uring/zcrx: share an ifq between rings
Date: Tue, 28 Oct 2025 10:46:39 -0700
Message-ID: <20251028174639.1244592-9-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251028174639.1244592-1-dw@davidwei.uk>
References: <20251028174639.1244592-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a way to share an ifq from a src ring that is real (i.e. bound to a
HW RX queue) with other rings. This is done by passing a new flag
IORING_ZCRX_IFQ_REG_SHARE in the registration struct
io_uring_zcrx_ifq_reg, alongside the fd of the src ring and its ifq id
to be shared.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h |  4 +++
 io_uring/zcrx.c               | 65 ++++++++++++++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 04797a9b76bc..4da4552a4215 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1063,6 +1063,10 @@ struct io_uring_zcrx_area_reg {
 	__u64	__resv2[2];
 };
 
+enum io_uring_zcrx_ifq_reg_flags {
+	IORING_ZCRX_IFQ_REG_SHARE	= 1,
+};
+
 /*
  * Argument for IORING_REGISTER_ZCRX_IFQ
  */
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 6324dfa61ce0..094bd595d517 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -22,10 +22,10 @@
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
-#include "kbuf.h"
 #include "memmap.h"
 #include "zcrx.h"
 #include "rsrc.h"
+#include "register.h"
 
 #define IO_ZCRX_AREA_SUPPORTED_FLAGS	(IORING_ZCRX_AREA_DMABUF)
 
@@ -546,6 +546,67 @@ struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 	return ifq ? &ifq->region : NULL;
 }
 
+static int io_share_zcrx_ifq(struct io_ring_ctx *ctx,
+			     struct io_uring_zcrx_ifq_reg __user *arg,
+			     struct io_uring_zcrx_ifq_reg *reg)
+{
+	struct io_ring_ctx *src_ctx;
+	struct io_zcrx_ifq *src_ifq;
+	struct file *file;
+	int src_fd, ret;
+	u32 src_id, id;
+
+	src_fd = reg->if_idx;
+	src_id = reg->if_rxq;
+
+	file = io_uring_register_get_file(src_fd, false);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	src_ctx = file->private_data;
+	if (src_ctx == ctx)
+		return -EBADFD;
+
+	mutex_unlock(&ctx->uring_lock);
+	mutex_lock(&src_ctx->uring_lock);
+
+	src_ifq = xa_load(&src_ctx->zcrx_ctxs, src_id);
+	if (!src_ifq) {
+		mutex_unlock(&src_ctx->uring_lock);
+		fput(file);
+		mutex_lock(&ctx->uring_lock);
+		return -EINVAL;
+	}
+
+	refcount_inc(&src_ifq->refs);
+	mutex_unlock(&src_ctx->uring_lock);
+	fput(file);
+	mutex_lock(&ctx->uring_lock);
+
+	scoped_guard(mutex, &ctx->mmap_lock) {
+		ret = xa_alloc(&ctx->zcrx_ctxs, &id, NULL, xa_limit_31b, GFP_KERNEL);
+		if (ret)
+			return ret;
+	}
+
+	reg->zcrx_id = id;
+	if (copy_to_user(arg, reg, sizeof(*reg))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+	scoped_guard(mutex, &ctx->mmap_lock) {
+		ret = -ENOMEM;
+		if (xa_store(&ctx->zcrx_ctxs, id, src_ifq, GFP_KERNEL))
+			goto err;
+	}
+	return 0;
+err:
+	scoped_guard(mutex, &ctx->mmap_lock)
+		xa_erase(&ctx->zcrx_ctxs, id);
+	return ret;
+}
+
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zcrx_ifq_reg __user *arg)
 {
@@ -571,6 +632,8 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EINVAL;
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
+	if (reg.flags & IORING_ZCRX_IFQ_REG_SHARE)
+		return io_share_zcrx_ifq(ctx, arg, &reg);
 	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
 		return -EFAULT;
 	if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) ||
-- 
2.47.3


