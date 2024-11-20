Return-Path: <io-uring+bounces-4894-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 020E59D4489
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:33:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A8C61F222C3
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06D031BD009;
	Wed, 20 Nov 2024 23:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eENBWZGP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9041BBBE8
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145595; cv=none; b=Ms49Jq6PB0of3dTAknyorWRn1RrGP9hAA9Ls+hf4/wzkLMxqk/P44cL9DUU3meiVukuV8cD6qwt+8iD8jSK4C/n4M4PCSdULaqdh32gd+3Va9QorRAzngllbUQa3SFq94iXHdsjByVDLCDETZARQxmWW5YdjEijwwxqbNhbuxzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145595; c=relaxed/simple;
	bh=55xt3/pYTVPzdu81FVZJ0x8k5BIhUfm79mNIEsz93uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCELjQmhp4o7ct83i+stlXJl72s/hcLLKnrRihR5SvR7iNcifD8XvDV3sPM4mWBtqfXg2DK++B1xwHrWhxYN6ZTufXQlg2+I6NZgGRBjkErvl5sOVOqWJsOHukuSxwQTEthFU2/YxBJ1ga+vFNW7Hnn6ZSeOa0bmbTUPSYP1woQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eENBWZGP; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9a0ef5179dso53483966b.1
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145592; x=1732750392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K+skNG/NMNLar+6yG7jRI9A/owfpoygJmWoUnCIcEc0=;
        b=eENBWZGPFUt2JHickDcMVmE8SoUcmXlRat0ZQFdwT37+NMvOJWmW8p61JvrE1d9a7E
         8zySLQzHsEDD9rKPxohLLsWV4PbWFznfM+C+klIF2N9nLVqIlN5BeZnBuTUww+7KIw1N
         3Yfdd4nlfflIDQkXXkybO2c3SzrGN/Vmvvbx4bzMg+Cvp0G5tBkSKv9s2LWtZUwU4Gv1
         H0xB1oTm34f00ErY+/+f0chH/VfPIvhNHutU+qLBzrs7PX8/WWKT9VGIhhv+z8R1f+MX
         qeZDDQ2eD5dE0ln0QlM5Q7NbQrRxwJ4VKR/JlhVYq2Srz4JsiwifmG2nXPyHjlmkB4Ng
         StgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145592; x=1732750392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K+skNG/NMNLar+6yG7jRI9A/owfpoygJmWoUnCIcEc0=;
        b=XL2PjZS/BeWL/gHoq95gBeTwYdt4PunlwuNb1vIO17RyQohSCdZhg5x0DaqBEBp5pI
         VteqRGsXNRN5XpStZsLetMTXu9H4UP45bJK93XaBNUeMmYURr8xQAUHT49BlkD69EOdU
         DKCSrISuTzNqesjgcUZwfFHXykOkmptKvpwkdlqUQeoWNaXnA6cfl370vHf9DLchkKCO
         iBbnM/EFnqEeF/gyNndacKg1u0JC3IjLaknVL/J4hEVCC4rrVaMjNJfczPqyCtjY0Ulq
         E8eHCBXIEiqivcRclLLzF9LZp28PlputsmVTENUFgpxCHFc0c1SaSBzECZnBq7WAMxUS
         XGcA==
X-Gm-Message-State: AOJu0YxfpIH2WGzdgEtNmmt5rdOgCxpgLrxB5b8MM4soVFDRz3DKq9xo
	WD5hA433RbvwZGJmx+CAQyJQosoFS9fxYsugF9dTHwzoT7jDOsbFrM6Gqg==
X-Gm-Gg: ASbGnctuhRW522sLpMsoBwxaxfSCUx+n0E/zgX+xL3TU49ZbGCcejCBE88VV3+6YelR
	yZUfXBhO7yc65K4V1bng1gO0+nmfrfmYM62iVxkfs2ejMvSnn6xPsmoyOo5wBVUGmzdavJYd+0Y
	GMSriLk9YNvIw7V5M96ErMWJBEKxMtaPy4mfCKVu4h3V3QvKJdSenkwsymFItrLlNfyuQGDP/Jo
	vWmJy0P30hHcg5TLdPtK6UmvmyQqjbw/cdtBbFp6mpS5TcEzSozC8SIJCzjE1lo
X-Google-Smtp-Source: AGHT+IEVXkw7ltgXRAqLxaJ1TfbHUd2KJqajg7amLeXytBW0fyHEX60Lq94WhzDkobfZp+kUWZz6nw==
X-Received: by 2002:a17:907:9485:b0:a9a:9ab:6233 with SMTP id a640c23a62f3a-aa4dd56af99mr425929166b.34.1732145591884;
        Wed, 20 Nov 2024 15:33:11 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f415372bsm12166066b.13.2024.11.20.15.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:33:11 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 07/11] io_uring/memmap: optimise single folio regions
Date: Wed, 20 Nov 2024 23:33:30 +0000
Message-ID: <018f6d706b1d986630debc38e01973fe16f085a3.1732144783.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1732144783.git.asml.silence@gmail.com>
References: <cover.1732144783.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We don't need to vmap if memory is already physically contiguous. There
are two important cases it covers: PAGE_SIZE regions and huge pages.
Use io_check_coalesce_buffer() to get the number of contiguous folios.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 2b3cb3fd3fdf..32d2a39aff02 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -217,12 +217,31 @@ void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
 	memset(mr, 0, sizeof(*mr));
 }
 
+static int io_region_init_ptr(struct io_mapped_region *mr)
+{
+	struct io_imu_folio_data ifd;
+	void *ptr;
+
+	if (io_check_coalesce_buffer(mr->pages, mr->nr_pages, &ifd)) {
+		if (ifd.nr_folios == 1) {
+			mr->ptr = page_address(mr->pages[0]);
+			return 0;
+		}
+	}
+	ptr = vmap(mr->pages, mr->nr_pages, VM_MAP, PAGE_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	mr->ptr = ptr;
+	mr->flags |= IO_REGION_F_VMAP;
+	return 0;
+}
+
 int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		     struct io_uring_region_desc *reg)
 {
 	struct page **pages;
 	int nr_pages, ret;
-	void *vptr;
 	u64 end;
 
 	if (WARN_ON_ONCE(mr->pages || mr->ptr || mr->nr_pages))
@@ -258,13 +277,9 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	mr->pages = pages;
 	mr->flags |= IO_REGION_F_USER_PINNED;
 
-	vptr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
-	if (!vptr) {
-		ret = -ENOMEM;
+	ret = io_region_init_ptr(mr);
+	if (ret)
 		goto out_free;
-	}
-	mr->ptr = vptr;
-	mr->flags |= IO_REGION_F_VMAP;
 	return 0;
 out_free:
 	io_free_region(ctx, mr);
-- 
2.46.0


