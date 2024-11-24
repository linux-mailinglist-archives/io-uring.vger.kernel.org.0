Return-Path: <io-uring+bounces-5016-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EB959D783D
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 636AC281E61
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C113E15B97D;
	Sun, 24 Nov 2024 21:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PICifKIE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3572913FD72
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482734; cv=none; b=ktfOw3Fk0sA+3LUKtYwz6psTqRtGsfTjExQhhbY4V4MaDT3Qsq9trix+KjAsbb7Ac7Tz+fQ5M/G4RZVs8FlZF376vUaOxc3ypUZJ4Yyzzs7XKw209RqxWiV5kHHM0FiNVkfHpuR/II3coH0bd9VNmom2uiCrxrbIs9Wy74A6AaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482734; c=relaxed/simple;
	bh=tZdEZvN/5hCLNJpMtjgBHfxWGrgUbt1UcPId78L2bOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHoQFdN+pHWfxSeYJoAGB828NGttTOCaeGvjTDSwwfDf0gY04fQOrAA9gEI9GWBrTrEOMGeeo6I2BEHmRUWD8mT+T13kiYlivFYs2d+J+6KmVIVXOf0t2IVWe1D1oF1qdWyCyhzThRquf+tg6KdyAdNKr9/BeCcO7af61T4iTjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PICifKIE; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4314fa33a35so33370585e9.1
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482731; x=1733087531; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TOubji84NJuUbvOMUGscG3na9pQtpTrNDF4xMRHuW3Y=;
        b=PICifKIEfHBYoWpHOtjNx/39/7CmsS8pv4IWucjt/zDJ/DSBolgQU3f58jYbt5xEnF
         gCliLy6SCt3tAs0/FEBEpUHKnKrpajxsFA4uhMRVsxn6hXSePHpmG0ln6hOFHtUI2oss
         mKF25Vc0y7CTaC4+Q8IHN5Kef0Ys5r8h1OJL8XKlVYDJZDSIlvGXhSs6iwMv4stRcicJ
         rxebK/WSHQZ/x0/oiY4zojkv9nbfS8SfkTLrxyIe8zPwhtSvVKEAdkglrK4LktuBSRFo
         3i1TJhYRI2SBAafBcMk2eO50qRzLBHG+TOJOGvEZzs41jwkWb19422sShwEpDAdDZ39n
         yGiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482731; x=1733087531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TOubji84NJuUbvOMUGscG3na9pQtpTrNDF4xMRHuW3Y=;
        b=IL1825RWUQNeqbiJ8+cgOSxlh0HsmcWSBFHmQKRP7ikzOzH62O9sEG0mTFvjQbbzS0
         XGnIQQp7ksyXnoX0VcPcdi4xgHZ8yP5YlhCYamUT2cY8K+ilvC5J6obWy8RUUgpEzImr
         83K4oA1JLIBNwiXh+Tp6Mh9vSewpqeGniZ+k5bgR7z0r/oqoCWZ0pw/az/9i+F8/AWLG
         w0Ik/WiZof7hBJ5NGRRYsxKRcQMVO3cC7vxfS+y9XgRvmlzxng6izEf7eeT5Z2C3bCan
         5jtz0bj3VHZauXSk6bL02V3sHY3TzR1ds64hUkJLban8Vj5vYwuXiuroHZUNsxoZGsl3
         tWEA==
X-Gm-Message-State: AOJu0Yydj6mPGpdkJqJHnClD87dwFBc2WtTErGb/Lb9Ml9tCWN60/aGE
	YPlbvrKWItbB4dC5ZE0XweLh6aX05U1r8e1OuCi1UlV88ejqjGHi4XlgyA==
X-Gm-Gg: ASbGncsGQ5VP8EFzcYuGAYAw3xMPOJIDeJ0MAMGgPb0EyZJqzRiWQaWdr75e7hYnnOG
	HqXUv02uL5FcTfHe0JYQvZIkcDDtihg0z/+iR4f/xlvIh5LLopoemHnQPnvJQ6UIcGDhzxfJ0qe
	cSsiL51kVf3e+QTx7BC5zX2VCnEpDbVAtPiAA9RVCF4coVPMRfP56/FMrdAfQmmwUDfQZoRXpRU
	A2dhIt8Dv92CjBx5xHdnVzRkkHH9+T46atj9UKzb8YFr7TqQohMHij6XWeb30c=
X-Google-Smtp-Source: AGHT+IFWp2F53oDb1JcXByDkaHiptaVWMLdUzz/9JX1ENXFMbofQJTaIEoNRRLrj7q7ApQEJHIVxcA==
X-Received: by 2002:a7b:c7da:0:b0:434:9499:9e87 with SMTP id 5b1f17b1804b1-4349499a073mr35372655e9.25.1732482731400;
        Sun, 24 Nov 2024 13:12:11 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:10 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 09/18] io_uring/memmap: add IO_REGION_F_SINGLE_REF
Date: Sun, 24 Nov 2024 21:12:26 +0000
Message-ID: <e93beab8e8cb79d069a2a9640063010ed8183873.1732481694.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1732481694.git.asml.silence@gmail.com>
References: <cover.1732481694.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kernel allocated compound pages will have just one reference for the
entire page array, add a flag telling io_free_region about that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 15fefbed77ec..cdd620bdd3ee 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -198,15 +198,22 @@ void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 enum {
 	IO_REGION_F_VMAP			= 1,
 	IO_REGION_F_USER_PINNED			= 2,
+	IO_REGION_F_SINGLE_REF			= 4,
 };
 
 void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
 {
 	if (mr->pages) {
+		long nr_pages = mr->nr_pages;
+
+		if (mr->flags & IO_REGION_F_SINGLE_REF)
+			nr_pages = 1;
+
 		if (mr->flags & IO_REGION_F_USER_PINNED)
-			unpin_user_pages(mr->pages, mr->nr_pages);
+			unpin_user_pages(mr->pages, nr_pages);
 		else
-			release_pages(mr->pages, mr->nr_pages);
+			release_pages(mr->pages, nr_pages);
+
 		kvfree(mr->pages);
 	}
 	if ((mr->flags & IO_REGION_F_VMAP) && mr->ptr)
-- 
2.46.0


