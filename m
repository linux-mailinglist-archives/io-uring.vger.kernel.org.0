Return-Path: <io-uring+bounces-10896-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 307C4C9D667
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:36:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 91EAB34A1DC
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D54520B7E1;
	Wed,  3 Dec 2025 00:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a8X+A2+Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DB61FA178
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722192; cv=none; b=nShqVCrjrDK2+nePlWGEspbeSulxxM1+Yk1n9wFC/TYrd00m8Pmb9yvitMX9UPjDtLLEN6Beel2YlxZAs4J5pNosGFoxR0ETp57yJanSsbWP83a4HyWCmcHG9vbYOTfA3g2w0YJmgDSvi8vDOwAS+BOJttJ2c3I1e3L2bIP23yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722192; c=relaxed/simple;
	bh=vtrab+E7lWgP1nIQYZh7pQ/dfUw271W1DSEqEjHCJBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2XPhmLhJkO2eujOZ99hLQOM0+Vtt9tRmTYVO8seYz12njHMJbyA9sxTLsg/yW2nc+/q8qt7RH+RmmS3WMuFA6+SMI17LSt8W0AeDZEyKepnr5AZyK7tLxlEeZmdX0KcBxNeHZT3mvZMTQolMAZ+eJAUth7zMSZyYtJK6tAITVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a8X+A2+Z; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7baf61be569so7234821b3a.3
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722190; x=1765326990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ofCCx79H7TXzLYeCPUc03xeqntUzcR8hDP2dvJGHdr4=;
        b=a8X+A2+ZDWXxCOYnzfT2zRUPqwyRE5XjI6Wn5nc2+OT3dDkTLM+7BwX9kyPNopXIPI
         KRXcmMJO3Jnfp16dljxGpmWFbcElragIe3r1zMbVwuGI+W2BqeDjrqkluRsPG4FgUbdB
         kEKVgX9mC7/d1AqINa5o2Rv4lUAGVhdW9Sgm9rv35nJpWAjEUuUCme2b3Qyl1h6RtK4a
         EjdcotoNAGqigE4HShbHuw38rDBpOJS2BC6gE5LR498h6xO2niXXoPEqH+/sGsE6fMHv
         odNxXdjWxgWJ/p3JDB5REOzD/AylBiTK2LXWoD33MBW0DWehyv+Y578Xs/vM8pLpNxcm
         tpGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722190; x=1765326990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ofCCx79H7TXzLYeCPUc03xeqntUzcR8hDP2dvJGHdr4=;
        b=HlVC3xpQfMgA1Ox068gs7fUlKdTk/4ek8C8X7RSP5ntsRlP0eNPlDi2sJPG9myjQci
         ZhW36g3Qj7YTvKm5v4M4Mb9BaXYaskYqPHPusZkBEa6L/HLF0VSML4AVyReU3WTsvj1Z
         433HC7DsiBPCAaAhx1r/4sH8EyejphiVAx+Wwi0N3YWWkWWchQ5gv3rnoWejqSOPYFd8
         bwqzd/O6JmpS9bUNBINSNZGSjo/253TTvjF/Tqkru1oZxyTIA/kdWuYstGjFfpna5cdV
         AzHy1nAdVcXj/CxgiSL/DYJGJ/pnNfpphmL7gAwmLpDJiMTk1TU/8W3AWPvd2TKvxIMv
         IH7g==
X-Forwarded-Encrypted: i=1; AJvYcCVkfu8Xxq816nXnUA4IVc7V8g+sYaFTX7+Q7cDCnUFEQwM6BWd62US8b6kqDzIXpRskNfegOhpfpw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwDjBM6DI2yfqxE5J1U3nHBDa+wr4ngMDQSMUWEjw4szyycGZ1u
	Ktx6MOjkEQM920J3Fljyiis38SHojJRiZEuzW9Z5FpMiMZGqaB03oaeq
X-Gm-Gg: ASbGnctnD+yw1c3WAJIXLvEkw5kkbCK5UJs7mAaDtTGJDJZqfTNXUx7IlKvbGMudyV6
	N8MIXMeoa2FCu3J12NX6WESlYdPaFFDmm/fUYTpq6sTOdPmLCigZ+NF/yAwbZfQQxU13rX2JfFE
	E4RQMpDWV1f0pXKv2dLg4pSa+AJfG6+KcPBsoI9MZBJdZagzAjFUdaLi+PFy4cAkU7zagxuiVpr
	GlE90hoMrZAOH0NdzedUhZBNxzt2Cf2EK6fa7N7WJX+7N6nXfSvRTVbt6MBEF95D2pe4ZOj1z2l
	qYB9Ut9PnSItadp4rwGxtaOJzyXdnf1ebgGIMHZ2G2toC2Yosli87aRaas6LyswH2l//Ry4AP84
	1DLs9oSjcm8WIf/WD0ugQrG2uyfY6WfCy3NZ7nRMr6KUFSulrbqGU8gTs2x+XGquTmbUvmrs3Qe
	P2kgojGyL1hIXCNWIDXtTRT+agMU3p
X-Google-Smtp-Source: AGHT+IHjVbyrLkZa5rfO3j9HxqzFrFGFhLBMFDh/VIStguvvowTd0jY9IXVLrV0PB5gdFynX5woesA==
X-Received: by 2002:a05:6a00:3e24:b0:7b8:8d43:fcd2 with SMTP id d2e1a72fcca58-7e00bcf71ecmr506980b3a.14.1764722189875;
        Tue, 02 Dec 2025 16:36:29 -0800 (PST)
Received: from localhost ([2a03:2880:ff:59::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e9c3dfcsm18128372b3a.40.2025.12.02.16.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:29 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 01/30] io_uring/kbuf: refactor io_buf_pbuf_register() logic into generic helpers
Date: Tue,  2 Dec 2025 16:34:56 -0800
Message-ID: <20251203003526.2889477-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
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
index 8a329556f8df..c656cb433099 100644
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


