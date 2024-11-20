Return-Path: <io-uring+bounces-4896-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAA4A9D448C
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:33:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32A59B22044
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:33:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB8B81C878E;
	Wed, 20 Nov 2024 23:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lYxOpm9z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5951C8317
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145597; cv=none; b=r8mSovHn4x1ehWZzbCM4s6BB6cPpg5NnAtwIKhChavD+B0QgbmywxZ+kjiHBjBVmjplmydZ3YhsIBi5vOGyCw9jecoJmTHyMAEv8jzQyU4GueoNAOlxACMgiLVn5w5Nju8c1j53V+/pHy/a6Ye8tYhAOnoN3GASBYJB25FDxn4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145597; c=relaxed/simple;
	bh=tZdEZvN/5hCLNJpMtjgBHfxWGrgUbt1UcPId78L2bOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ittnnJfgGbs5Zwd7E9zGBiBBJyk2pWdXSIYyNfTulAe7RGInUdmlFmWfL0ItjnfS9VjeLrPUw10P6g1WrllRICmRsDQeu08XiY+b8PcvGfLV02JYi2PF2ouxp1tlBtUSclJYYLBivaxyIgXkkRuz6HbV7vvpxBK67ydEZuyYqTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lYxOpm9z; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aa1e51ce601so59685966b.3
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145594; x=1732750394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TOubji84NJuUbvOMUGscG3na9pQtpTrNDF4xMRHuW3Y=;
        b=lYxOpm9zvIP2Bg5wu7Cp2EnzHmf9H5AtHZm54v1AgLplCSi7EaEXx0OBig2fuv2MYB
         7Iq3y2yOwuBgRyx6G+1gNRGCp1WbHUjwIzQXOOsU1DirsBqrpdYeb4CZhuVizGfqBW0i
         KUka8Wt3dx2BiEsU9pulPkIUxUNXW0SpmCsCgGoVp8GEoG5zdnLGSWJ20EyH8bvfAZZn
         7xbI1cTo4wf3j46HRW/lFJOsVOAnm1+O32waYojgFpFEFZiZ46WwD7QMH9EZuCM3wIh/
         V4HLwCb5mLvX8mPRVNE4BX5pUToUQaLrlQK9RWikaZM9Y1FWLFhS+bbnn9V8BL/YqX0g
         q8LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145594; x=1732750394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TOubji84NJuUbvOMUGscG3na9pQtpTrNDF4xMRHuW3Y=;
        b=HnM8exXtCLix1IfuYB4pAt3QVQMu9p1dbYJsD8cvk2XPu4MFoEY95ABJn0GGccMlOu
         TTqw6/uILprvv0PwgG0AsmRV+xSxZsy+SGGxqSnZrPB0n9CKMmz4xYXrOH9OOznuyRDU
         AyvC7hsQO+k746ypof4IqHQyJxgxeq7/jSOB+7uVw7jfcgDWq9becdmALSKXpvWWvza+
         6AftkfKUYQO3VMw60sBRy2T+Jam5fiU+jbiF+zX6wjCvERG1qyxB47rifGShIlVvpwpZ
         7BfE4hh6nDv+pBUek4I/6L0sYBCdLyGTLJYjAt/VCEiPYd1oLWPLG5uo2DVNEXswDs8k
         Q04A==
X-Gm-Message-State: AOJu0YwFtT3YW9rseHyAbcQsPi0Cq52jGLukOLKHnT/uVGTN4uAfM3jx
	10YL9uFkpt6Q2dl3JKZIpW0nRx7VvPXKDlwNythHJZJlEj4HyogCJaPjFg==
X-Gm-Gg: ASbGnctsxsPEIDZFTtvjmfLDkha5L8lF/kmOUE7ZPRiN1Ubng/xTSe/ISqRVywsMl9P
	/O9ALvTmtrsep+9/RlP/IRqDC1guaeRN0yQHmIwhYKGwYoM8d96l/QBCOY67F4Hd9brcfD7LB7u
	s+pb6ho10tqhYBd/BDYLGqCc2XnaIe/zHbmmYK1ISGOG5Rzk8yRUNrNtTJU5Dru8sHXmwSYB92Q
	eTz83ZyHS1uYwp4G2vOdYs51ebZE3i1BYhu006IBRviEHwizvi+vSVi4BLu/JBE
X-Google-Smtp-Source: AGHT+IGuV6comNTVE4IAoxI5lopPVb+lCI1qhsCEj78+PPDhezKWs/lHTeJ7AhWOXi7S1aKLP6jrEg==
X-Received: by 2002:a17:906:eec8:b0:a99:77f0:51f7 with SMTP id a640c23a62f3a-aa4dd799d4bmr431768466b.61.1732145594136;
        Wed, 20 Nov 2024 15:33:14 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f415372bsm12166066b.13.2024.11.20.15.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:33:13 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 09/11] io_uring/memmap: add IO_REGION_F_SINGLE_REF
Date: Wed, 20 Nov 2024 23:33:32 +0000
Message-ID: <807340ea7288500c76fb693e8a13a3372aba1709.1732144783.git.asml.silence@gmail.com>
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


