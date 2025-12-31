Return-Path: <io-uring+bounces-11351-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DEC1ECEC76F
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 19:19:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 59FCC300C5E7
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 18:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F6B2FF675;
	Wed, 31 Dec 2025 18:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="MQrY2Tdg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f98.google.com (mail-ot1-f98.google.com [209.85.210.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2152DC33F
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 18:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767205152; cv=none; b=lRSFgS3rQKDbSjoRGXGeM5rZaq5q6o41plx5zwx2s0ORZan7y0D3rlW3pesHVSWWXW0qB6de2TCPtZIy3jqnEjZaErh4RDWJVRYWpeZVZz/TWK1ZQDJsAF2gelEgXjjiiiWrdLNyotnQa49ZMmlsi2bBYCvLiKKlxfo/Ip1Tpp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767205152; c=relaxed/simple;
	bh=XA9VXp/t89uYbrNpEQYMB3yWH4jA9QVWu9zC3HDuBrY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OvIIuqJV2GKnXSGXd+EkS/oG6Y5PQCxKBWhz5vi4ULLBBsIuVE9j1edC78pB6fzPHDgL2k1JqREm0vuFXfROGUW7utZpK2Q0+spzkMRkU0gEBDjM+gfwqGX+l4CjEGgXvHcDHvFGmlkE6gfBDne679tfpu3rojbX2bDVtIvBRns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=MQrY2Tdg; arc=none smtp.client-ip=209.85.210.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ot1-f98.google.com with SMTP id 46e09a7af769-7c7a32d6e7dso1307849a34.2
        for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 10:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767205150; x=1767809950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=spC8OXaVZBPTicR35S4WZ2Km38bffiKG3F7I2qMTJRs=;
        b=MQrY2Tdg8HrL7DxLfz5UtMnwOTdo6xItUgiAhcPyfMGkTq4ryJ2LWy9lkNksBm6pn4
         rAH8GUX4oYudnazboaAHFSjVSDOJ5NqLzpHPTfRTk/XtR8hpwln6rrC1beDpx0BUpfpK
         XSY7dVOy6EMkhJbThaORMH8FlYsMPyEvdp0AHC4fJsbNu/RqojJzZUZU7q32eGXaU4hd
         oQlo8WcEZhS4OUbUQE5TzVucezNQUNy2JJcKx/CUSRyYYTT+wtLxFX0FGcSRtsWb4iL8
         +erThuHdqBhSejZBPQ+PnWvuLVJ2YFb9GKviY9S3NGH++zHIzD4XMgOHzPEMUI+NKET8
         vZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767205150; x=1767809950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=spC8OXaVZBPTicR35S4WZ2Km38bffiKG3F7I2qMTJRs=;
        b=OfedeDweU3d1Nx0XxZUcvvAgljK86XlwHDTAi8gHTEvo+jcXBoE/lu/xqlnUqVOrSv
         JHMDZ5D/3I4CV2rdIIbVMaDe1BGGp+N14cqffKHBjIyx46RIeWgbbsDVhjRtLNoUmIiv
         Cj9eji4RjnsJBaavA4ruAM4Nij8Plffw5ePNox0mkzFft2tuex1SPHO0br5E28NbEqsL
         3O+EMQxGQvlNY4aYBxGanm9wcPrWetnC+Ycaeij/6Lv8OBo8ZcdiNnrtV00qaSM6mO9q
         8ipWOqNuYchdYT/0MqJwgUIc+9nt5LZYgcTRU/Tl9Yrdpmddhtg6p/XD/I7m1lbhRLLm
         pG/A==
X-Forwarded-Encrypted: i=1; AJvYcCXoZWQwSMgYSyO0zJg/YfqKi0M/zbHF8XPUtF5Z6LThr8kcKuv4RyotlDOjUUspycahs9CeavA+Dw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm903hEAhT31y5NnsiGIb9+q/ABiFVj4ajwBKeEIQdgPHeylU5
	ehNgCVSvGjVmFB8aY4j7va8vywy3ndy6fkwo6mguo6vrY56qcGkv1YvaQT/XlpVndY54JvzzlW8
	mocvWypBEytJBVsNoHbD2f3o9UsqPHVPVa6jxRviOMSfk3t3oWvG+
X-Gm-Gg: AY/fxX4DQxq/GXmeQTPoF9PU07vTXMkA/UPouWDlpEGWwctPJ2EHkfkgpdPfH0B53Tv
	slWmoGhQ4W5UOuD6njRX5jrEB0uy/IdCbOdrICUN14fI60QyFm2P0Aqilbq41HlZ4YKYK2r/ig1
	Vewp3oalNEYz37JmEGtzybG0oEfBmN3n4tvLVvLTbmRit+tNQOP9omXBpisYtTvBj0dMpBZKUyx
	pMje0PL0rS6beUfikCtKKQmZa2bE4axXf305zRtQZDBAbuxznnsQ1hqDIB0arNHEy/IHwUMAh+D
	bPt/w79SbUjRfUZ8Ru0byEukr+LB2CnItXE5E4Zgye95AejqnrHjjr4TCk6Y9GctZQq41eMkXcn
	1znzwucVIiACF7pMS86sQGjIGQPc=
X-Google-Smtp-Source: AGHT+IEsh4Vj4HmS6tj5e84VPtTy7F4B8RMk5vvvlP0iGibByQou1oNK6h6QAvBB9cKNy9PWg6AZ/0crqpz9
X-Received: by 2002:a05:6830:310e:b0:7c9:3d82:4235 with SMTP id 46e09a7af769-7cc66a550cbmr18379200a34.3.1767205149596;
        Wed, 31 Dec 2025 10:19:09 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7cc667d6b73sm4321855a34.5.2025.12.31.10.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 10:19:09 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.49.34.222])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id C6DCE340185;
	Wed, 31 Dec 2025 11:19:08 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id BFE8BE41BE0; Wed, 31 Dec 2025 11:19:08 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/memmap: drop unused sz param in io_uring_validate_mmap_request()
Date: Wed, 31 Dec 2025 11:19:06 -0700
Message-ID: <20251231181908.4039028-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_validate_mmap_request() doesn't use its size_t sz argument, so
remove it.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/memmap.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index dc4bfc5b6fb8..cb9dfc411c3b 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -266,12 +266,11 @@ static void *io_region_validate_mmap(struct io_ring_ctx *ctx,
 		return ERR_PTR(-EINVAL);
 
 	return io_region_get_ptr(mr);
 }
 
-static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
-					    size_t sz)
+static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff)
 {
 	struct io_ring_ctx *ctx = file->private_data;
 	struct io_mapped_region *region;
 
 	region = io_mmap_get_region(ctx, pgoff);
@@ -302,11 +301,11 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	struct io_mapped_region *region;
 	void *ptr;
 
 	guard(mutex)(&ctx->mmap_lock);
 
-	ptr = io_uring_validate_mmap_request(file, vma->vm_pgoff, sz);
+	ptr = io_uring_validate_mmap_request(file, vma->vm_pgoff);
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
 
 	switch (offset & IORING_OFF_MMAP_MASK) {
 	case IORING_OFF_SQ_RING:
@@ -334,11 +333,11 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
 	if (addr)
 		return -EINVAL;
 
 	guard(mutex)(&ctx->mmap_lock);
 
-	ptr = io_uring_validate_mmap_request(filp, pgoff, len);
+	ptr = io_uring_validate_mmap_request(filp, pgoff);
 	if (IS_ERR(ptr))
 		return -ENOMEM;
 
 	/*
 	 * Some architectures have strong cache aliasing requirements.
@@ -384,11 +383,11 @@ unsigned long io_uring_get_unmapped_area(struct file *file, unsigned long addr,
 	struct io_ring_ctx *ctx = file->private_data;
 	void *ptr;
 
 	guard(mutex)(&ctx->mmap_lock);
 
-	ptr = io_uring_validate_mmap_request(file, pgoff, len);
+	ptr = io_uring_validate_mmap_request(file, pgoff);
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
 
 	return (unsigned long) ptr;
 }
-- 
2.45.2


