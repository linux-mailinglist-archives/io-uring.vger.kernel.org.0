Return-Path: <io-uring+bounces-5014-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0255D9D783A
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 080B9162C8B
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9768D163;
	Sun, 24 Nov 2024 21:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TeocTknT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68E9156960
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482732; cv=none; b=jR2b1S7/Q+oFTQLOW7pylDtR09RKty/w7BI4HVb0Ng8sZXwgyrmeqqBp243iMMTeG0pa4dI7W0VVbLo4r3WCoOg3iyJP8bGIXGv8QZ1tHd9CGk36muAogq6LxGH+4ANcMqilM5tt5vNEYfFIdbbArE5e786AL5+pxoyWhhpQE3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482732; c=relaxed/simple;
	bh=55xt3/pYTVPzdu81FVZJ0x8k5BIhUfm79mNIEsz93uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LA6aazYOUJ1eiQMknHTZRG29KyIacQRyuZUHFGSZPbLgTdRFYNmO0Iw/9GBnCVvO9Zhk5GP4Uwse9n1o52dffs1tKC6Gt+AH986WtFze8kDSkgwxSHWGsogyMGzn4aazrah4pal+WS072OZcSSqNFM+zJ+pdBBjyO+qCYzoU6pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TeocTknT; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4315f24a6bbso32131865e9.1
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482729; x=1733087529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K+skNG/NMNLar+6yG7jRI9A/owfpoygJmWoUnCIcEc0=;
        b=TeocTknTO7tlEbMDvKYf6x+Mfr0n+4MQEpisG0Y4J/qxl3qOgSxf0zXofKKEbwW/Mz
         7Wf472Xg0Mq2fG5lRC1gIWqx2azCPnlpQu6zQx6XiPKRtyi6eRHzWsyK2kygNNE04xSC
         eFMwTrmMiRDC83eSWUJ6geD4d80zBjbmhcCR1k7D8cFz4HyoYHsD/eTxfWGEse/oYEhS
         6saocPvMa63XRY37Dy4VvxHDxo8VKUxnACgIA2G7P557j2RtaKnMte+hM6vGozQNPZX6
         rIq7n6ObZsHE2PuwbAdso+nRLImkyopB/2hkkpoqljUAbK9niEuxoTxddVGa3IeJfhTQ
         PFJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482729; x=1733087529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K+skNG/NMNLar+6yG7jRI9A/owfpoygJmWoUnCIcEc0=;
        b=ccroWT8zZR6NBZYcy4TusaoIJRV2zLa75n85KABARp+FUMxOdbQQKfiKs3P3ZnyAEJ
         t6BkDjRjk1eTHccE1sAnOyLFRkE26wjHWiZhq+o7e9Kolr2neSuBEhunO21Q7kuKnJwi
         Fb0Qzjcly41r7upV2bQefYq/WW7GNhDcQYAybrWRmjBAcghZjxDFl2bOPUBK9yxDCzkI
         +HbuFxgmuCMTfA0c8x96qYCeIxPEVNXsAK+9QZXVXJ/Qpl0q/sk/XXxjCCD13OfTfCL1
         1RTdpeAoaxmOIL1POoiLFmBYbBcAxmh6Z5C3JDNEOkoLW+HHo2pBerT5zrYqfK5AMyoA
         bKuQ==
X-Gm-Message-State: AOJu0YxfqDZvTHzh+4PVC+wfKgkvkaMUVGjRv+GfFKXQ/yPMN+d5zRnr
	4ArXRDHmhYEL68oBUkE6+Dvsw7l0+UlkaXXH8bvK4YncsT0wUDN5IYJrGQ==
X-Gm-Gg: ASbGnctesA/HsCfYK7ES1rH1tEF2j4g1Wwk2g/MdyFefvNkTwBLJXJuKeT5dFMRdScc
	wWTeyFM6Jg4smKtgNJVY/Cz4tHD7fiRxJvSQOfD8W/Cso18/pkTTVPW6ODWZXXcp0PqelbKa+l7
	5ElNNuBxeQLI9DiioP2wpt/cerAnY9OzT9/W3zoBcHlmWsJTfT5r3mRJ15ZmERttC7CKSxAoPnI
	5cYe94mgqb3Wzx853lZtKSutVjdWH1kTZuThUfb1PrbUEBzW3x9nwrEaGsEhi8=
X-Google-Smtp-Source: AGHT+IEqbXpV1lmNv5WfvqmcWc7iyx+9ha6sC30QFtb3kghFEjd9q0w0j1CPQMLKMoXO8dsJwfOHQg==
X-Received: by 2002:a05:600c:1c09:b0:42f:4f6:f8f3 with SMTP id 5b1f17b1804b1-433ce420b21mr87039705e9.7.1732482728954;
        Sun, 24 Nov 2024 13:12:08 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:08 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 07/18] io_uring/memmap: optimise single folio regions
Date: Sun, 24 Nov 2024 21:12:24 +0000
Message-ID: <398023f58961f57ae2c4974ef6327f5572bf8e73.1732481694.git.asml.silence@gmail.com>
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


