Return-Path: <io-uring+bounces-4892-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E40529D4487
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:33:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4D68283362
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E761C8773;
	Wed, 20 Nov 2024 23:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X/LfyBht"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DAD1C8306
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145593; cv=none; b=lOSb13rA20dz/85iU0tavh/dukzjSMudlGpdmj26fTPjaW0tlGdynRtF5FdH+ycnYPKOYoI+ng1R2mDUtzIszNkD7xvqRuIQSS/Z8DEo9Cx2C11FWvouLuxbHKT33Di+73tc3D2IngJX8FSE9suN3pOOhm1YErQywuJ0q83uVnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145593; c=relaxed/simple;
	bh=A/BG30k4dPSYeGyQ9WWlDhGgvjjruOFJ2EsBN5g0230=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClwketkB/jP0xAWNGJF7GpmH6NdXbqEsbZdqSNu8B3b9HkDbs4tTZPK4fAyXjzO0DvZGwuKQnlmoR9hxeElAIPpIqt///P48POV6M9zFNg5Dhc+TfFijvkdr+oOao4c144cejx7i+f9yhXQ7ylQYD8ig3YczjspfFWyndtfolXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X/LfyBht; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9eb3794a04so31272266b.3
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145590; x=1732750390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cQnp+lrUnHITWCsKfUZMU+VFdBNN5rUz4oDhu1P1PU=;
        b=X/LfyBhtExzLE4fS1ZP1Y+l0mvEbIcTXl0NK+FtPGBFpIaleNwLxJw4qV0/ie3BXst
         kHAPlW/fCt0LHz8ACRjrHsOzakH4w9BHakFbWuTbV82Z8gEA1RaUbXyBWIDNSXHIKer0
         Vlt59v5RxGBNx1O5HnJpb5VceNjEpxapcAMjQRDzH34Lf++xoSn4uiWlFUev4bXNZLWr
         Th+IK15HCCcq0ptBGKWXpzMQIqJgyO0PuhR5VPejo7LDjATE7xb4Afggo2kXQSAWjIa9
         bU9jp/0YFSl/dyqTWO8Z5y0aL0e9Qq7kLUMgzMDOYl/aFRj109uF5TKiB3sFNpdc3bsA
         yf7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145590; x=1732750390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5cQnp+lrUnHITWCsKfUZMU+VFdBNN5rUz4oDhu1P1PU=;
        b=pdkFTYhNvz8v9xAtyiosl+/zJpkjm9CIYu04YQmONOw04wpiedb2A3wWyHJa6wP7N/
         Km/fv7Cf1Lo78bJplI8PoDgnZBVhpG81kgN2TuIeMsUM8OVusJolQFsp8NnqhRp6uJ2F
         Ws7QFq3hxtmx8jfGdol8nyLkFScILKd24f94v81Nkr61Dc1VQMfdt7u3t3EXrr7cqh0e
         22sfhPl2Iqtty0q4pgEC7SZ1Wnw57w2z/sm9qxRNhwSZOwOzKap6ZlpuFy2D+tYJaIwy
         xaA5VHqgsrMs+JfqN+YkxutjXWn2wxL/LHZeTl73INHrliLI8hsHXWXMKtRNC/TYha8v
         D1Dw==
X-Gm-Message-State: AOJu0YzfvnJ8IVsaqfcnwnx+UmfchOUrzyohkHZcC0fit1/a3o+6rwzu
	Q54MRHB083/mX3KtnC51L8w7f/A+ueIXaenNMIXGo3NFe0CNxiZZ2z6jTw==
X-Google-Smtp-Source: AGHT+IHkPqIIRFu+8WyF3Vi5l/fSSbPN75nthpEilp1VBi0CJiLpfWRWgdYbYNxS1cgcLhWjfNJ4rg==
X-Received: by 2002:a17:907:9493:b0:a99:5234:c56c with SMTP id a640c23a62f3a-aa4dd59f50bmr463269566b.33.1732145589768;
        Wed, 20 Nov 2024 15:33:09 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f415372bsm12166066b.13.2024.11.20.15.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:33:09 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 05/11] io_uring/memmap: account memory before pinning
Date: Wed, 20 Nov 2024 23:33:28 +0000
Message-ID: <ba7a2fa8c75ac048a06fee6a316f914f97549761.1732144783.git.asml.silence@gmail.com>
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

Move memory accounting before page pinning. It shouldn't even try to pin
pages if it's not allowed, and accounting is also relatively
inexpensive. It also give a better code structure as we do generic
accounting and then can branch for different mapping types.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index f76bee5a861a..cc5f6f69ee6c 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -243,17 +243,21 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	if (check_add_overflow(reg->user_addr, reg->size, &end))
 		return -EOVERFLOW;
 
-	pages = io_pin_pages(reg->user_addr, reg->size, &nr_pages);
-	if (IS_ERR(pages))
-		return PTR_ERR(pages);
-
+	nr_pages = reg->size >> PAGE_SHIFT;
 	if (ctx->user) {
 		ret = __io_account_mem(ctx->user, nr_pages);
 		if (ret)
-			goto out_free;
+			return ret;
 		pages_accounted = nr_pages;
 	}
 
+	pages = io_pin_pages(reg->user_addr, reg->size, &nr_pages);
+	if (IS_ERR(pages)) {
+		ret = PTR_ERR(pages);
+		pages = NULL;
+		goto out_free;
+	}
+
 	vptr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
 	if (!vptr) {
 		ret = -ENOMEM;
@@ -268,7 +272,8 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 out_free:
 	if (pages_accounted)
 		__io_unaccount_mem(ctx->user, pages_accounted);
-	io_pages_free(&pages, nr_pages);
+	if (pages)
+		io_pages_free(&pages, nr_pages);
 	return ret;
 }
 
-- 
2.46.0


