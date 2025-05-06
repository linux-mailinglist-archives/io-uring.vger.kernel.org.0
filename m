Return-Path: <io-uring+bounces-7867-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C9C0AACA74
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 18:08:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D3F9525D3F
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 16:08:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D045F28467D;
	Tue,  6 May 2025 16:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ByNk0Mg9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B417284663
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 16:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746547681; cv=none; b=iLwrQZGYhNjYORhJBxZ47cidvfKIaauTvEXf2XKewevfVmkyV6cik+jaHBqNmTQ/vyI8BIUq30yq1xtPYZlzBNb0htURbsrqujUwDlCnD3dnaXxPna5stkJuZzxzEP34PZkDBH+PW9Be4lk1BL/cQCstNA2ErofpZ0Te68LB3Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746547681; c=relaxed/simple;
	bh=roZ8zSUa4UUJ672EPkp6qUh2XigXmTp6Y5CNkr8aqrc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AzEx/FR6OKTjyCrp51O6DRl1UvHhRfuBdBzd/Go0hDHecKPR/Gsa7FZtqTsbIRRMB5ptC2cIt5kKrSi8MZ1+k4KSnGRfc9ZsJuW7mxZUP++fL1D9U014ioorV/8RY0N1AmMULnM6T2/2rx/ru+H0gleOC02nUt+O5hEoJZuaFpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ByNk0Mg9; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ac3fcf5ab0dso964702966b.3
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 09:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746547678; x=1747152478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8UrswhCm0MoF0qi8C20FNhLspSM8kBWIE7jXmeDulPM=;
        b=ByNk0Mg9jyHZ7IH0kT2jXyMNAizFQ1A2O3Kyn02jTOviaBmSboUG2Of1Tpzx4FKubh
         /HC9MnmZUF9Qbx8aA0hYnGXcpzu5Pc823cR5OlEcCMgIifviSUoZQnKpZF+JpbH2pmUf
         A8M3V3O/YHDRFr8j0wE++W5GgR+RggwPJDkZByBUI1DQWXi5BRA4k1IYkaBJcrDmlB2t
         N1KiTqz7aKHFoScrgzM1LQzyEq1GyOHi0h57+5eEOIL+9ZB1rJ50qiqxYxphbFb9XveQ
         xSGHST3tAFvyLKY+8VGwbY+ES4akkyCxg3f2mYxyV92LuTWUey8zvFLbASIhHNNKPdeU
         wMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746547678; x=1747152478;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8UrswhCm0MoF0qi8C20FNhLspSM8kBWIE7jXmeDulPM=;
        b=s4+aRzka+3EyyVAzrISgyloN+V7KMRu7/Ao5GFKvi873PG43kaGrWsiqXbtOwzcwXL
         5hrpjazV+Iw1YiylyXjmd2B7KcIOAlKxLAeNygo900ersjGFbD5qnrXqvu4gSsh9VgDR
         C2t+eoeWgzFyJO70msjqWhoTfy286NVhzPCgxtnUW4DmNCGnmIP6uzBsOmGbELd2GgaN
         8yk90zrHD9d1+wMSoed+UL/i+eBkrWULeI/CNxBH3EznIpfIStJxyZyPl+Q8p/Sg2phM
         x8zRuu0eaA+aKUlMg5BPW7II2QcwUfBYLbuUgBcDuLjr7h5H7Xx+3J56p7z/YgJF5is1
         TQZQ==
X-Gm-Message-State: AOJu0Yw49EjXY4r4jMrtuPeGyoYhZgrbqO3iNAJsV3KaSCmXIA+lqpfS
	ClPSLo9A+9Oz/eLH5r4YVV1CZjneC39IN14TMKQ5lRdkiGGpfW5BnxAaUw==
X-Gm-Gg: ASbGncsC3ZUIkZhDBqb9uRGr2wiTWQNC4SAEBzYOFYCCMxKbX2+Dv1CYNmZGAO85YUl
	aZIVxDNkhAbMDi+I3IQlo6HvPYikZ2OOHw0txY8rBvlS8uwyeYdrg8iT9EBzqxO42H771FTdD1o
	ZkUuqWk2877gU1VwQY0vtENKJeytMC1O03cKcq4iwPNKRtbpiLwkWeTMJtsaZKqODHr4ahFiaB8
	QUEbMkRNlbUBApQ2P32WrVSmrf9WgGMjAAHeu6jU2v5GyWP1+n7tmP8EqTozzUPjqX8FoRJDKBd
	Pg1x1+AQBaAv9vbrGnnvzvL8
X-Google-Smtp-Source: AGHT+IFGNO+TCgBoZW3gKqmFEDc48bJcRD7Cg6jPmVcrzajdTuOcmvNIW8KNKA4nr5cG/FMP3TJe5Q==
X-Received: by 2002:a17:906:bf47:b0:ab7:cfe7:116f with SMTP id a640c23a62f3a-ad1e8d04ee3mr1051366b.46.1746547677644;
        Tue, 06 May 2025 09:07:57 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4f70])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad1891a3f1asm735132766b.64.2025.05.06.09.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 09:07:56 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Alexey Charkov <alchark@gmail.com>
Subject: [PATCH 1/1] io_uring/zcrx: fix builds without dmabuf
Date: Tue,  6 May 2025 17:08:56 +0100
Message-ID: <6e37db97303212bbd8955f9501cf99b579f8aece.1746547722.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

armv7a-unknown-linux-gnueabihf-ld: io_uring/zcrx.o: in function
`io_release_dmabuf':
zcrx.c:(.text+0x1c): undefined reference to `dma_buf_unmap_attachment_unlocked'
armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x30): undefined
reference to `dma_buf_detach'
armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x40): undefined
reference to `dma_buf_put'
armv7a-unknown-linux-gnueabihf-ld: io_uring/zcrx.o: in function
`io_register_zcrx_ifq':
zcrx.c:(.text+0x15cc): undefined reference to `dma_buf_get'
armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x15e8): undefined
reference to `dma_buf_attach'
armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x1604): undefined
reference to `dma_buf_map_attachment_unlocked'
make[2]: *** [scripts/Makefile.vmlinux:91: vmlinux] Error 1
make[1]: *** [/home/alchark/linux/Makefile:1242: vmlinux] Error 2
make: *** [Makefile:248: __sub-make] Error 2

There are no definitions for dma-buf functions without
CONFIG_DMA_SHARED_BUFFER, make sure we don't try to link to them
if dma-bufs are not enabled.

Reported-by: Alexey Charkov <alchark@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index fac293bcba72..9a568d049204 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -49,6 +49,9 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 
 static void io_release_dmabuf(struct io_zcrx_mem *mem)
 {
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return;
+
 	if (mem->sgt)
 		dma_buf_unmap_attachment_unlocked(mem->attach, mem->sgt,
 						  DMA_FROM_DEVICE);
@@ -75,6 +78,8 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
 
 	if (WARN_ON_ONCE(!ifq->dev))
 		return -EFAULT;
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return -EINVAL;
 
 	mem->is_dmabuf = true;
 	mem->dmabuf = dma_buf_get(dmabuf_fd);
@@ -118,6 +123,9 @@ static int io_zcrx_map_area_dmabuf(struct io_zcrx_ifq *ifq, struct io_zcrx_area
 	struct scatterlist *sg;
 	unsigned i, niov_idx = 0;
 
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return -EINVAL;
+
 	for_each_sgtable_dma_sg(area->mem.sgt, sg, i) {
 		dma_addr_t dma = sg_dma_address(sg);
 		unsigned long sg_len = sg_dma_len(sg);
-- 
2.49.0


