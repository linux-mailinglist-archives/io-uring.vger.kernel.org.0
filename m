Return-Path: <io-uring+bounces-11181-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 562DBCCAF23
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:40:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 37F0630D6003
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E05412ECEBB;
	Thu, 18 Dec 2025 08:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GEJcM6ua"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB5E26F28F
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046878; cv=none; b=in1r2ZYZL5CjcWPNkgBcj6HujnsGj0H9jtcI3Dc8fzptemICD1vVdP6lcq5hPS1YWrsE1+y+ovLLFjSyc/+w08WqPaz5shYHgUxBLyyTGD8rhkFfcuynSG56aiDaRxdXI554uL5woWLETWJJGVcwGU5Ithfd0zcbWxK2yaGwutw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046878; c=relaxed/simple;
	bh=2bl1I2nGDFhxzgXjKcGi7d1dbtnWWYC+yqHyoAr/ZWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akgqrGuwvaGFv3cE1zqwFb+e4P2xY2HXEfVGVr8g55aB/xeGSQymopR0r06XobxSO9iDQvUFToDTyCEHq9iJAW0sUqkwl87VpEcDhskhFxFYvAUbf4fD1OlvNN690tXL6YIErPJTeXYm/P4ekCYvIyGCwUIRFbqSv6oxnj7Nl7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GEJcM6ua; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a0ac29fca1so3428685ad.2
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046875; x=1766651675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zGm2YYLVF+NHRLQ/f0+pGaC5F7muCq47qD8Hd3HU+QA=;
        b=GEJcM6ua7JcIZfyS+akR9z4NCe8NDwlxgfy3saKTTlB0z85tNZGoKquzUDIBK3CRii
         yJ01XSfXdY64Xqm/CEZ4ao3IlTgdZamqU8xGJrHfr6GfFzWbdX1TpxY8LbpJFR1crsKO
         di+P1xHECMfhaQ8X147zNDqG8EGXM151sTSEZWpf5B3pdLRkdl+yTVN4bHN6DEuwxdms
         bxPWhVBBGKeuslLnjalFOGM3f1t4NCk0tbKfRTXMbrOXA5M4mU+eW6pAPzajiYxcA/ub
         VqOrQtWMlgJC8kq3Atx73j/HzHGVkBtYt8z1R1/jQALWim3kV7CudlqH9npwr6TxT8sS
         wDZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046875; x=1766651675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zGm2YYLVF+NHRLQ/f0+pGaC5F7muCq47qD8Hd3HU+QA=;
        b=iE3FRl2esagFv0T9cIQzXQHAeyJrBIDv5QS+v7dfX8ylUYqBJqx4dbEc79BnOl1ZNl
         +5aSrQlhrSizg2QhWFVxKIT+0hZsO/s3Up9AT4Nu+IjAr0r6LB14CZmC61GHM46eWaqP
         1x8BtEYBFlYie8nTPKUg3aAmIsR2j5AY0tWGqE94Xd+w/o4fu5BYmZ/jvlTqCzWD5wpk
         XaL6wikZlS3bEur2pRlJkxqsumxQmmIunwlQ4Po0v1GDXd10xvrQaZKNoO2EZTbGcD3Q
         4P9Uy5Eme+vGp92Q+83yvSFNy04Qyvmu4zDsyUWMK6yZIQK6LGvegW2T8fBM8hkUYF7C
         O4Mw==
X-Forwarded-Encrypted: i=1; AJvYcCV93Fn4RD4ePzF8j3ohu9hjsnfBItmdfl7z8gn3dOZFFqHy1hqrS3A+yqRAAiEHXhf/bYEpbrmFGg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxziJp4Jcs5aYafB4KTP5JfbWtNti0hQLI+9tQeJVFFzXKhDBlw
	woN6mFsHKrcbuhgfGlP781gQJLWXybuEF1OkN0+P25b8yvVa/Xlqz5db
X-Gm-Gg: AY/fxX5hvEwBeGARIKz2W2zXco7KXiwAnHHUCB8PWPvRDTgnVTBLtdaTu2I5Zodd/a9
	+eK0oxOsmbvKK6kg1LOBPhCIxF4udlYFs0F2xme9Efx3e3aKZZa58Nj7cKzDH3jGZAd7AifodNg
	wR8XN7ropzKf8kGMuMD7S083NwgqmAXCGsyQ3LF7pnj/h2PPz+UrCPAE1XpJ/iJ7pOCT7/TnUK1
	7/NVXygzikEtAmDvr7+EPOlsF/60/mAtoa7196cuxO0vQk9dPQ3nJOVqczFkoXdUdsveQ7qiEWK
	C1YrTni8Qr9az2RwNYLofx6H8mG9TnMwUgUldzhOlVhKXle3RYRFXJtXTAMxiesWVawdwGPOx8u
	fEh/vv/PtCfUDjt9GWt1tqWnXx0oaA+Rl7WSIcB4T35EEu80DR1FOwOFT5VhZ1D2IR2KrXpsVg4
	jR58D5rEKFS4gxJ9YFkw==
X-Google-Smtp-Source: AGHT+IG01Zh5Sj8Wpw60Y9qnB2rGkNf0VkStAE7zfoKr8x5fg0qT0m6qdMdO4p0UwgOn+i6lxzt3pg==
X-Received: by 2002:a17:902:c94c:b0:2a0:d4e3:7181 with SMTP id d9443c01a7336-2a0d4e37ae0mr164872185ad.49.1766046875310;
        Thu, 18 Dec 2025 00:34:35 -0800 (PST)
Received: from localhost ([2a03:2880:ff:49::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d1926cecsm17272995ad.74.2025.12.18.00.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:34:35 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 01/25] io_uring/kbuf: refactor io_buf_pbuf_register() logic into generic helpers
Date: Thu, 18 Dec 2025 00:32:55 -0800
Message-ID: <20251218083319.3485503-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
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


