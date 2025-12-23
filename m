Return-Path: <io-uring+bounces-11252-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 53A9DCD77E5
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:36:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AE81F300217B
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 919191FF5F9;
	Tue, 23 Dec 2025 00:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hZHpja6M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F541F5851
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450189; cv=none; b=dFeDfdjM1PrIvkZk7mebwpQjyBhAjBranOSLg2w2W7FSELwlG6chcti/rlaYlb56QSrFl+7LLYt/QuP2OxklqoC1QcjiX1AvegVcsMkVXQH3V9gdnR5plbHcbNcLsAgj7AyAmCuC5yx/45UJKwDdXpXH2ABpKAWj04rZIJmz4Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450189; c=relaxed/simple;
	bh=2bl1I2nGDFhxzgXjKcGi7d1dbtnWWYC+yqHyoAr/ZWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgKTSWVSEzMxw9TO7Qw5zWzZr60eCuhoAqnqgpl53YDVp5F0UGz+4Q2HvioOaPcNOaA6OfBxo2wYNDh2q2Pu4kTPIrPaevkG71Lp7h7QJ2tZCDdXzuZUpiHfK+vyrI6zMss6ohG/0Bx3itW3nJMeaKyLHUxLzFdidXAJUx1Cb4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hZHpja6M; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a0d5c365ceso57344885ad.3
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450187; x=1767054987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zGm2YYLVF+NHRLQ/f0+pGaC5F7muCq47qD8Hd3HU+QA=;
        b=hZHpja6MeK22CX5QLmtIrzvd6FKkP8jkLtiULBYm5zquH+EE0Njq1mZ0WWkDYTlStp
         45sulmzdX0upN9wJ6StKGCb25aOhT4J+04ExuTJ6vKLXRpk1NquvwI6CfaR/20VHzIQn
         X4XX921Dsqy9alDs412B4Ky86lEAT9gVCqLatGGKdbITVtF4N0oMuAu6wslS1PburorH
         2CPJZ6i5bV9Jfa5WDkWdZREvd1pBQsFJVzIn46XHbPwoMWXq5JE/dKYn7DGSKlvqIwOt
         X2iBrfEtwHemGZtJrBIUezBCK/a4aWnhQCISr/6VHSt6AcA5DkFbUQLs9MdwjsuI4+Vi
         rEJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450187; x=1767054987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zGm2YYLVF+NHRLQ/f0+pGaC5F7muCq47qD8Hd3HU+QA=;
        b=wacuVWyzn97IrM7GCPfzW2bajYPHJHCmB8Wg4YjIoh5PXcPkCXz3vehWxOn8P+BVcz
         NtFIsKaWt+NWjCk7mz9qmY1lrZ6uvOe6XRvz12HLjRuaArpovnu7foydIfbA2hwR3sla
         /K9lBw+b5LCWgPnaf8+X8hiGkrTnrO273u1ljVXN1ZGk4ybqgXBbUiknaY/ftQziu9Zr
         tGn61xAt3eBD4yc1bKgsY5LHNVfI/WQ3FZ01/pTJq+MQw005ABLT0A+FrLQ2/s/ne6ep
         l0RmoFYgvCFnoUX64fKSrIqZiEBOYb238dd4bxfcGEeprjNA7J0cjBxYXVspYCgbrUMc
         6jpA==
X-Forwarded-Encrypted: i=1; AJvYcCUlA7wADg25jvIhZZgqFh3rSiTffpuOn9aPVayI41db7JD8fQhl6fwyy7If6Ao0tmPdgLFVIVUZdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywaispe2/1HKdbsKfA5q2f7notfp7PilYTolMKSPwSHBHdU4YAF
	xma076iUyDtZbj5y5T+teYljrIxFM4BzGCrfsQkNrnWzshFiP2aBf15G
X-Gm-Gg: AY/fxX7FqwtTDRWHB5WuR4FdxmUxTMMjTfZQlhpZhzQiuXcf+1P81ncOwFnzq5FAG0j
	Z1XwS7jJY+U4zvT7bbSSi71F6jEYVZ1x0SMf3mdNq7f1vJGgJfpq3BEa51fwbX7eNoOB922V0Qz
	V4YzaVn8wx6jrF/Zp9N1h5WBZTg2QpvtsRqB6hbalXGl7tmyYaYb5qtnSuJqReBca6IbOQW0GI1
	VFoMwaRsS75CzAYS013Fk0hrcac3J8yWM2dAcHfMFnLr/tznexjBe4NM6c5AsHdcYMjDg6v2wwZ
	02kLNuWofiBHNRDS2DvOEoiv78s/d4vA0N0maV4zCZcQ/FTVIMXj29bVHJChC3jCjhxHzg4oSTp
	Gx5q/L7TVVVBCOYUmiqfyfyuImjH/P6I4GjVEqPeSPdxVfn0coFI2V9TnAd0eGHlWHd34iY58gO
	Tqadl91uixIKLhWiXZow==
X-Google-Smtp-Source: AGHT+IECC2pnYFWgfKAgX+K1LWLxO7LDnvtb/j/+LBASPVEhDUx5y+ctz9gVsNa++IS5VAV9dGQ+rg==
X-Received: by 2002:a17:903:8d0:b0:269:8d1b:40c3 with SMTP id d9443c01a7336-2a2f21fb43amr126991335ad.12.1766450187208;
        Mon, 22 Dec 2025 16:36:27 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4b::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d5dea1sm106022615ad.81.2025.12.22.16.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:26 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 01/25] io_uring/kbuf: refactor io_buf_pbuf_register() logic into generic helpers
Date: Mon, 22 Dec 2025 16:34:58 -0800
Message-ID: <20251223003522.3055912-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003522.3055912-1-joannelkoong@gmail.com>
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the logic in io_register_pbuf_ring() into generic helpers:
- io_validate_buf_reg(): Validate user input and buffer registration
  parameters
- io_alloc_new_buffer_list(): Allocate and initialize a new buffer
  list for the given buffer group ID
- io_setup_pbuf_ring(): Sets up the physical buffer ring region and
  handles memory mapping for provided buffer rings

This is a preparatory change for upcoming kernel-managed buffer ring
support which will need to reuse some of these helpers.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/kbuf.c | 123 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 82 insertions(+), 41 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 796d131107dd..100367bb510b 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -596,55 +596,71 @@ int io_manage_buffers_legacy(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_COMPLETE;
 }
 
-int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
+static int io_validate_buf_reg(struct io_uring_buf_reg *reg,
+			       unsigned int permitted_flags)
 {
-	struct io_uring_buf_reg reg;
-	struct io_buffer_list *bl;
-	struct io_uring_region_desc rd;
-	struct io_uring_buf_ring *br;
-	unsigned long mmap_offset;
-	unsigned long ring_size;
-	int ret;
-
-	lockdep_assert_held(&ctx->uring_lock);
-
-	if (copy_from_user(&reg, arg, sizeof(reg)))
-		return -EFAULT;
-	if (!mem_is_zero(reg.resv, sizeof(reg.resv)))
+	if (!mem_is_zero(reg->resv, sizeof(reg->resv)))
 		return -EINVAL;
-	if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
+	if (reg->flags & ~permitted_flags)
 		return -EINVAL;
-	if (!is_power_of_2(reg.ring_entries))
+	if (!is_power_of_2(reg->ring_entries))
 		return -EINVAL;
 	/* cannot disambiguate full vs empty due to head/tail size */
-	if (reg.ring_entries >= 65536)
+	if (reg->ring_entries >= 65536)
 		return -EINVAL;
+	return 0;
+}
 
-	bl = io_buffer_get_list(ctx, reg.bgid);
-	if (bl) {
+static int io_alloc_new_buffer_list(struct io_ring_ctx *ctx,
+				    struct io_uring_buf_reg *reg,
+				    struct io_buffer_list **bl)
+{
+	struct io_buffer_list *list;
+
+	list = io_buffer_get_list(ctx, reg->bgid);
+	if (list) {
 		/* if mapped buffer ring OR classic exists, don't allow */
-		if (bl->flags & IOBL_BUF_RING || !list_empty(&bl->buf_list))
+		if (list->flags & IOBL_BUF_RING || !list_empty(&list->buf_list))
 			return -EEXIST;
-		io_destroy_bl(ctx, bl);
+		io_destroy_bl(ctx, list);
 	}
 
-	bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
-	if (!bl)
+	list = kzalloc(sizeof(*list), GFP_KERNEL_ACCOUNT);
+	if (!list)
 		return -ENOMEM;
 
-	mmap_offset = (unsigned long)reg.bgid << IORING_OFF_PBUF_SHIFT;
-	ring_size = flex_array_size(br, bufs, reg.ring_entries);
+	list->nr_entries = reg->ring_entries;
+	list->mask = reg->ring_entries - 1;
+	list->flags = IOBL_BUF_RING;
+
+	*bl = list;
+
+	return 0;
+}
+
+static int io_setup_pbuf_ring(struct io_ring_ctx *ctx,
+			      struct io_uring_buf_reg *reg,
+			      struct io_buffer_list *bl)
+{
+	struct io_uring_region_desc rd;
+	unsigned long mmap_offset;
+	unsigned long ring_size;
+	int ret;
+
+	mmap_offset = (unsigned long)reg->bgid << IORING_OFF_PBUF_SHIFT;
+	ring_size = flex_array_size(bl->buf_ring, bufs, reg->ring_entries);
 
 	memset(&rd, 0, sizeof(rd));
 	rd.size = PAGE_ALIGN(ring_size);
-	if (!(reg.flags & IOU_PBUF_RING_MMAP)) {
-		rd.user_addr = reg.ring_addr;
+	if (!(reg->flags & IOU_PBUF_RING_MMAP)) {
+		rd.user_addr = reg->ring_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
 	}
+
 	ret = io_create_region(ctx, &bl->region, &rd, mmap_offset);
 	if (ret)
-		goto fail;
-	br = io_region_get_ptr(&bl->region);
+		return ret;
+	bl->buf_ring = io_region_get_ptr(&bl->region);
 
 #ifdef SHM_COLOUR
 	/*
@@ -656,25 +672,50 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	 * should use IOU_PBUF_RING_MMAP instead, and liburing will handle
 	 * this transparently.
 	 */
-	if (!(reg.flags & IOU_PBUF_RING_MMAP) &&
-	    ((reg.ring_addr | (unsigned long)br) & (SHM_COLOUR - 1))) {
-		ret = -EINVAL;
-		goto fail;
+	if (!(reg->flags & IOU_PBUF_RING_MMAP) &&
+	    ((reg->ring_addr | (unsigned long)bl->buf_ring) &
+	     (SHM_COLOUR - 1))) {
+		io_free_region(ctx->user, &bl->region);
+		return -EINVAL;
 	}
 #endif
 
-	bl->nr_entries = reg.ring_entries;
-	bl->mask = reg.ring_entries - 1;
-	bl->flags |= IOBL_BUF_RING;
-	bl->buf_ring = br;
+	return 0;
+}
+
+int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
+{
+	unsigned int permitted_flags;
+	struct io_uring_buf_reg reg;
+	struct io_buffer_list *bl;
+	int ret;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	if (copy_from_user(&reg, arg, sizeof(reg)))
+		return -EFAULT;
+
+	permitted_flags = IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC;
+	ret = io_validate_buf_reg(&reg, permitted_flags);
+	if (ret)
+		return ret;
+
+	ret = io_alloc_new_buffer_list(ctx, &reg, &bl);
+	if (ret)
+		return ret;
+
+	ret = io_setup_pbuf_ring(ctx, &reg, bl);
+	if (ret) {
+		kfree(bl);
+		return ret;
+	}
+
 	if (reg.flags & IOU_PBUF_RING_INC)
 		bl->flags |= IOBL_INC;
+
 	io_buffer_add_list(ctx, bl, reg.bgid);
+
 	return 0;
-fail:
-	io_free_region(ctx->user, &bl->region);
-	kfree(bl);
-	return ret;
 }
 
 int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
-- 
2.47.3


