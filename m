Return-Path: <io-uring+bounces-4893-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48BA49D4488
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:33:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CBAC283429
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8ABC1BC068;
	Wed, 20 Nov 2024 23:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FpRQYszL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39B51C8317
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145594; cv=none; b=f+MTige8hpQG6Llw1MSgA4wyYB8DQzO9OdiNWeO3oUcEY3GG5huBQeT6H5yx+ip236/ZafjTwaiCSAuzhq5VNHGZSOPVoLqSgdFe3HS9F3csq2HWXdpCcpnURoRgNjnJA57omhfNt9NRPC8WBTnlfwBnRvuqzNOfvfeoLFBxcYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145594; c=relaxed/simple;
	bh=dujS0aFvz1kY8S8u3h9P118Wqvzr24FydnRRbGhqzO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpdRR+N6GBxyALf/5NRmjUyVJJ/ViV8baABVqiOYEcqLDsH68RdcFmWFqGY1RqfP8WUYXpOWZQ7dqw4iSn57iYwR7QkfJw/XmsaL53d3z9MJHPjISvVhzbDDwXcFv13fd5vMsOJzUkZIHQNc/3U60AoXIG7yoYdtCAAq1AHhrJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FpRQYszL; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-53b13ea6b78so421983e87.2
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145591; x=1732750391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sPuIWteBXaKyE6IW5ybcaZa+VOFWSvl/ffKsXytsJvI=;
        b=FpRQYszLLTq1CYSDLrHKIhA1lqQesgGs0Fn1rd/PqZAFv+UhieLXGl9Ac0wRqEqqoK
         fBop1xpCQb5scnPxdUxpOkr3mYQmKHbJeSN3SYNTfOLKCmdkoHeVNdOm1c5m92Wr0Hnu
         BilwTYWhh6mkiAszJX7OPAbKLMOGmJvmwSqISogLfdAdf1kc/8MAud46AknvfGoh45C/
         EGtzFhuydwNNo2NS53JxXhxdUKEf09PfRfS2HkJW4kBvpZwfDepNfOsFl5b5+4wz0aYO
         YJP+MY6MDxHVCDsuQ3UmvYQgcRX74RVvKEeubayDNMpAu+MT2fP36oh+yNTMJdCqX9TW
         5gAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145591; x=1732750391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sPuIWteBXaKyE6IW5ybcaZa+VOFWSvl/ffKsXytsJvI=;
        b=LynOsmyfIRNswODdLlBX8F/7Pkr3xePV2l9egs0Qo4ro1tlN59l5cTCVhjBxmQtFVZ
         7rm5iRi7oWlDffd3E+3h878Psb5wTMnxz1rrsM/QjnRNXwWVwGnSrDsfqL4p750fztqZ
         rTdJD3A8orMmybw6/9MX/cK7OK4r3E0XJxgsuli9XwZUF+lUFNH9OT2gm89g8aZJ/m2L
         t43b1F64ONjuZXenBuFeSEvy5QPnqO0dSnPwIdFhqtfY89YuoOzReXPxmWDJuWSYcRDZ
         RMu0kmDeHZawn7OD8ctSB4Rp9ggCewIBIAF29KL4FHrbzsahwMTASqidWORAYNd5TAsf
         uHIA==
X-Gm-Message-State: AOJu0YwQGYgqcQhCyk27zOG97ZlWJAVsTiO2ghkUj6LF5m1Hk5Tq16SX
	lzxt6BlcoICxxyipCKL2vV8cE8FIEiniJTLR5g79d/bdL9fsW0CcrCl8ug==
X-Google-Smtp-Source: AGHT+IGmEUH2UNo3QdR9ZYnpzXS+DgKxoCUTT5UrXeJpfsQYbYO7ZNEpJ+aWSz2Gors6s/8AnfI8Ig==
X-Received: by 2002:a19:6b19:0:b0:53d:c3aa:e4ef with SMTP id 2adb3069b0e04-53dc3aae78emr2639633e87.31.1732145590645;
        Wed, 20 Nov 2024 15:33:10 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f415372bsm12166066b.13.2024.11.20.15.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:33:10 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 06/11] io_uring/memmap: reuse io_free_region for failure path
Date: Wed, 20 Nov 2024 23:33:29 +0000
Message-ID: <626c9711e8facbac2d80f1852763e61d9668de1b.1732144783.git.asml.silence@gmail.com>
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

Regions are going to become more complex with allocation options and
optimisations, I want to split initialisation into steps and for that it
needs a sane fail path. Reuse io_free_region(), it's smart enough to
undo only what's needed and leaves the structure in a consistent state.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index cc5f6f69ee6c..2b3cb3fd3fdf 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -220,7 +220,6 @@ void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
 int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		     struct io_uring_region_desc *reg)
 {
-	int pages_accounted = 0;
 	struct page **pages;
 	int nr_pages, ret;
 	void *vptr;
@@ -248,32 +247,27 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		ret = __io_account_mem(ctx->user, nr_pages);
 		if (ret)
 			return ret;
-		pages_accounted = nr_pages;
 	}
+	mr->nr_pages = nr_pages;
 
 	pages = io_pin_pages(reg->user_addr, reg->size, &nr_pages);
 	if (IS_ERR(pages)) {
 		ret = PTR_ERR(pages);
-		pages = NULL;
 		goto out_free;
 	}
+	mr->pages = pages;
+	mr->flags |= IO_REGION_F_USER_PINNED;
 
 	vptr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
 	if (!vptr) {
 		ret = -ENOMEM;
 		goto out_free;
 	}
-
-	mr->pages = pages;
 	mr->ptr = vptr;
-	mr->nr_pages = nr_pages;
-	mr->flags |= IO_REGION_F_VMAP | IO_REGION_F_USER_PINNED;
+	mr->flags |= IO_REGION_F_VMAP;
 	return 0;
 out_free:
-	if (pages_accounted)
-		__io_unaccount_mem(ctx->user, pages_accounted);
-	if (pages)
-		io_pages_free(&pages, nr_pages);
+	io_free_region(ctx, mr);
 	return ret;
 }
 
-- 
2.46.0


