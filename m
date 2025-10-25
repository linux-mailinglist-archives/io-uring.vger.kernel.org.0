Return-Path: <io-uring+bounces-10211-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75104C09F16
	for <lists+io-uring@lfdr.de>; Sat, 25 Oct 2025 21:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F5E33AE8F4
	for <lists+io-uring@lfdr.de>; Sat, 25 Oct 2025 19:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B23E2306B1B;
	Sat, 25 Oct 2025 19:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="oUCWRME1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2D5288517
	for <io-uring@vger.kernel.org>; Sat, 25 Oct 2025 19:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761419716; cv=none; b=dy1eavHEgqwvw+YrZl/pdoz8FY278SInr9O3ORLCTnIg4GjWdfZZeR8hLqQTfl0sEhaxftNEv+yc+mkXrhK5YGW+kCUK5RL7zEu3pu90mznqlWNXCZMtD9XX9nbTegWSUjd+z1AVk/XLfLt0pFpLDQYRrIvLJOM8xg/Zm8BoZ/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761419716; c=relaxed/simple;
	bh=ij1x4613J3AHEeswr7FdcyCt9AbrnTY1NxiRhfgijWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o23ELDkzCjjMm3+hnLWX/xkSfHLKkDPc0ZLD06YHhJ4tKELt5+hTimdcj77dYudBkiHiblFcPOKgpTYuFlsR03RyBEkxaMIrzl4k/Ckl31YmmP2hNtxfComYTAAM2YBFbtZO+40OjcxLwRKyhfav15Y3Ke99hRwaQpY9NK241yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=oUCWRME1; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7c532e3a165so399753a34.0
        for <io-uring@vger.kernel.org>; Sat, 25 Oct 2025 12:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761419714; x=1762024514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5rekNj8CurFm9QMgGrJk7ZXx54jLEwnnaQhK4O7KQfc=;
        b=oUCWRME1CgO5y683JCAG8rtGkirCS5hle1hTEgUWq7irgKOUQ/Jcg4pxs8NRuULdAp
         waKUkV67sgq8GZgyi1rMTM4SNCk/ZOrqMIMLH7m3EPP2gSBuCp7ybLQ1OSDGLwzBw389
         7tYtptAQWvRhZ4VlbcAPt/eu+jCF+Q69MZlHOnGTDddkJshWpGG7cEAQo5EvkTmS2dWm
         aTG+LnmMBUxryJAhPDaGMy596cO3iu5fyXWB4nt+qBLtP7OE95yLd+o7CbAFmxAYurGM
         7tIWBWdMaTURB5/C0/6zFc/dsSZG2GjBte7wWyWKauYhekxodY0jt9rIrWIYs4xnj5l3
         lpQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761419714; x=1762024514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5rekNj8CurFm9QMgGrJk7ZXx54jLEwnnaQhK4O7KQfc=;
        b=Ot0wU4/ju5lCR4tnXNgt81cNpEdw3p0yKRL968CcFVWrKGn/8hX8naJoAC664v7yRG
         sFqUGfSpBRCJBzjxC/UgFK9+qSNBCHEG/0aH4aAvgOrUw/4Kl/wu30fmvD6meTmEkjXm
         Eo1FM3sWygP6EnfXeAzsvl3cM0t3+kBSLTgkgQ7A9TRJ4d7KX9VffJ8CGwsAX6D7EX+F
         PnT4nh8TC4p62BQndiNVTydqCGWxl9M9EFLJeaH2PgN3kqhybUxJ0+291+ndwocdmhZ7
         634wGZ4/LdB4smtHq+mL1a2JdId3NRD+iXNWTyrHuaEg1KBFp5LSUAuKVJUykbZl+8jR
         UJqQ==
X-Gm-Message-State: AOJu0Yw24Ok+cgoFkzXCDVvoaVC3fiUsIISWG05pFvwKFHj7SCfTDUhN
	djZsVEcuMEOjamqgG8ODooKaSQVgJAmdBLfFLGbLgsomSWBh5gFthDygH3myUcLaX5EQtc6f7z4
	aCkyX
X-Gm-Gg: ASbGncudGC2JOlJB16Gpoinp9SFwuX4vLaner56w3gS7wAmhLCCfpoNq3tm8bk04+9U
	LXjQPd37Dt2b5xq6AUs4hHykzg0jzEwnnAGzE3FPLJM+JJ7vEX03vf0IW8uvb2RartlIcl42cy/
	WBBNJJJr/Q6IB7HbVhVsCZVO91f83NE49isZ3Njte/NKFW1BZjRjqjlynlzbzoLdYYwbOck8iyY
	/Z6CC58/Fz09hHNbBo5YEoUthFL+5ndBeVf94PBF77x6eKijZmoUTKLFskkaDPfAh2Oe/c5ZFoq
	hQGsez9Fe3gl0+hXrKg7Ekn9z2DaenatWX+uQWUYu9kiDJHXAOwME1ib0wrd7r4PtiCx1UC5JMg
	F1E5UPVwN7j0i+sV+XZiY+tHACfRQAXCW41QkJ5hFlpUp1IXu5V5O8WTK/xzu5/CAWXg+PGOI8L
	py4SlfXhAF6DuX6BM4zCcfl5KdO301
X-Google-Smtp-Source: AGHT+IGP0I11k0kOEM9zXlvDGd3L4+LUnK6PEeMB2sM5rXSoWYBRNwrXmPkzfkT59GgbxMn1bCGvWw==
X-Received: by 2002:a05:6808:c183:b0:44d:add1:d5a8 with SMTP id 5614622812f47-44dadd1d969mr524697b6e.62.1761419714091;
        Sat, 25 Oct 2025 12:15:14 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:2::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c5302203d2sm801972a34.32.2025.10.25.12.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 12:15:13 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 3/5] io_uring/zcrx: share an ifq between rings
Date: Sat, 25 Oct 2025 12:15:02 -0700
Message-ID: <20251025191504.3024224-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251025191504.3024224-1-dw@davidwei.uk>
References: <20251025191504.3024224-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a way to share an ifq from a src ring that is real i.e. bound to a
HW RX queue with other rings. This is done by passing a new flag
IORING_ZCRX_IFQ_REG_PROXY in the registration struct
io_uring_zcrx_ifq_reg, alongside the fd of the src ring and the ifq id
to be proxied.

It is not permitted to proxy another proxy ifq; it must be a real ifq.

The proxy ifq has most fields zero initialised. The exception is
ifq->if_rxq, which is set to the same value as the src ifq. This is
because if_rxq will be used by the cleanup code to denote an ifq that
has been cleaned up but not yet freed.

To prevent the src ring or ifq from being cleaned up or freed while the
proxy exists, take the appropriate refs on the src ring (ctx->refs) and
src ifq (ifq->refs). The subsequent patch that adds cleaning up proxy
ifqs will discuss lifetimes in more detail.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h |  4 ++
 io_uring/zcrx.c               | 72 ++++++++++++++++++++++++++++++++++-
 io_uring/zcrx.h               |  1 +
 3 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 263bed13473e..10f6347b1725 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1055,6 +1055,10 @@ struct io_uring_zcrx_area_reg {
 	__u64	__resv2[2];
 };
 
+enum io_uring_zcrx_ifq_reg_flags {
+	IORING_ZCRX_IFQ_REG_PROXY	= 1,
+};
+
 /*
  * Argument for IORING_REGISTER_ZCRX_IFQ
  */
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 22d759307c16..6b9066333fcf 100644
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
 
@@ -541,6 +541,74 @@ struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 	return ifq ? &ifq->region : NULL;
 }
 
+static int io_proxy_zcrx_ifq(struct io_ring_ctx *ctx,
+			     struct io_uring_zcrx_ifq_reg __user *arg,
+			     struct io_uring_zcrx_ifq_reg *reg)
+{
+	struct io_zcrx_ifq *ifq, *src_ifq;
+	struct io_ring_ctx *src_ctx;
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
+	io_lock_two_rings(ctx, src_ctx);
+
+	ret = -EINVAL;
+	src_ifq = xa_load(&src_ctx->zcrx_ctxs, src_id);
+	if (!src_ifq || src_ifq->proxy)
+		goto err_unlock;
+
+	percpu_ref_get(&src_ctx->refs);
+	refcount_inc(&src_ifq->refs);
+
+	ifq = kzalloc(sizeof(*ifq), GFP_KERNEL);
+	ifq->proxy = src_ifq;
+	ifq->ctx = ctx;
+	ifq->if_rxq = src_ifq->if_rxq;
+
+	scoped_guard(mutex, &ctx->mmap_lock) {
+		ret = xa_alloc(&ctx->zcrx_ctxs, &id, NULL, xa_limit_31b, GFP_KERNEL);
+		if (ret)
+			goto err_free;
+
+		ret = -ENOMEM;
+		if (xa_store(&ctx->zcrx_ctxs, id, ifq, GFP_KERNEL)) {
+			xa_erase(&ctx->zcrx_ctxs, id);
+			goto err_free;
+		}
+	}
+
+	reg->zcrx_id = id;
+	if (copy_to_user(arg, reg, sizeof(*reg))) {
+		ret = -EFAULT;
+		goto err;
+	}
+	mutex_unlock(&src_ctx->uring_lock);
+	fput(file);
+	return 0;
+err:
+	scoped_guard(mutex, &ctx->mmap_lock)
+		xa_erase(&ctx->zcrx_ctxs, id);
+err_free:
+	kfree(ifq);
+err_unlock:
+	mutex_unlock(&src_ctx->uring_lock);
+	fput(file);
+	return ret;
+}
+
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zcrx_ifq_reg __user *arg)
 {
@@ -566,6 +634,8 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EINVAL;
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
+	if (reg.flags & IORING_ZCRX_IFQ_REG_PROXY)
+		return io_proxy_zcrx_ifq(ctx, arg, &reg);
 	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
 		return -EFAULT;
 	if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) ||
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 566d519cbaf6..0df956cb9592 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -62,6 +62,7 @@ struct io_zcrx_ifq {
 	struct io_mapped_region		region;
 
 	refcount_t			refs;
+	struct io_zcrx_ifq		*proxy;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.47.3


