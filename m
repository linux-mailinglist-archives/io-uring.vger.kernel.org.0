Return-Path: <io-uring+bounces-8399-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E91F7ADD096
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 16:54:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6E961941F3F
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 858A7227E8A;
	Tue, 17 Jun 2025 14:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GZGfqkLU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E9920AF9A
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 14:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750171652; cv=none; b=q+Uvz/ho/KvxauA496Vz1c66zdSw4HPmDi1ObSauyh5mij+6sW/YfiMeKR+0j2MOrH/RJVBAljz47VasYg/bx9dxhKhx71BbIE3DVUHo/K/ypc1ZoHmvjKeZAOEdU2fa1lfjSLGVkSwNedWFSk8UTDZEXtqpi8ANYeuW5q0v6r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750171652; c=relaxed/simple;
	bh=Qb39sL+CjqhP9iF9kO38B0gq1r80mKgFnb/3IrPBdRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jsvv45+lJQ3j6uiSTKM6+iH2/aCyXVGki9irJIWDLyfR0lUQ7CR8MkcjwxZi/o80itPdVms+rbDhi8BYs9r2cVF0xrg/Vh0A14tQXCh9KPODdh4a6IXGUwunPrw7HbrgneWW/JPSs4REQkoyQCoP+NOwdlP92zgV8e/AOzC1J2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GZGfqkLU; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-60179d8e65fso10574792a12.0
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 07:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750171649; x=1750776449; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5UMBEHYVflrx0dGjscl4qut4cRAS+QhJ9DaeilZl6r4=;
        b=GZGfqkLUPCw+4aAqhX+UOPdUB9eSzlNGqPTuCYcHsqLULg0Jt70sJDypX054SfNHhT
         yxzQjkk2BfLdZ11xrZ7tLWh5BVXOLN6xM+n6rHwdqtUkaihVM7XBb6XNSF2KsGh3YWUf
         twoQa6FT0FOGujBBggH7GVdrcu1xKYNo1Qqzd5qbKiUbek2/DxzioKbsMzXCf+0zbbNN
         xoDFC+CADnoTsaT9cQNozT3OWFQb0BsJXRIAYR3UREIWGSnKCHMieW6ehjj3hfOX1s4u
         yyYpqOozVve3icF/xBtStznix/ppTdOGK3Q1ZuZSkf6gR86ntjdk+S0p45QLm/PTgGxA
         9jfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750171649; x=1750776449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5UMBEHYVflrx0dGjscl4qut4cRAS+QhJ9DaeilZl6r4=;
        b=ZeT4kwIjY17FJ9YgdPePBclYjIoN87Kv3GavpNUVsBEitTxEbs/m+GbxggXBqjExeP
         Zo1UtCyrnR73z0iuWGc6WLNjiYqRBTuWdtNFKGMKfgPxT+Du9ZWWL9NTkbg3+Y+RCfcE
         yoRXVnhvtQg7aYRd9qIMl6XTV2mNDTUOGAClGJDgqKnTbNjcY3KB2JceKOkTVCiDm5co
         pXQlxQN06bJAfAZEyK9ECk190Kp4S5+ffxIDYbrc4kNFKkulaiuwQiGhXX6Le4gWnsmY
         tWjxadk7yU7c+p/1tsZaYsrypV0VlfHqtRN3SbC3Em3VPeEF16aH5IORhG6+w1NzXgZ/
         2KNw==
X-Gm-Message-State: AOJu0Yzs/SEmztwU5Kvwnl+x8CDSgm/DSPNk0kb06qxoP41j96vhrIcv
	Q9LhnIAMrxQBt56xIfimpKbqcF3vwxNBuyMyHhcWrKRrQn3NX53V0mNocon7iw==
X-Gm-Gg: ASbGncv8XArDpV9cpPdW+stXwpuv2IvIQvPqTv9nxLZnjeVGIPE+Wr117g7wHXlBQWi
	0+Rsq+PdXxNF3wjeIMM8VDDkYXIAsrZBWNOIvTKg8j2UJVJIk751QCd2RyCC6YS1PuCM9ziyFQh
	uxFSnxdA9WhysjEL5tTliTegji49oC2d0jpQgrLg950lCQTzo5kldAPEq9F4DIP095+clQb5kRi
	W3yura7ZEotHoSkmT0yei3ivvTa4SQYx4RN2bEyozXYx5W5/M5tERoVSM6/WFMowX6nuOkXo2Bb
	irmPN0aKPFBqKc+KS4+xh9P4GT3CwlrG/fWEI4d21hLbzc9bGiNOdCp+
X-Google-Smtp-Source: AGHT+IGStKjeny+EKGMuOns6YHrPVWH54pvtTY/pAQVCOdsb210d4l463r5Kqd+IeJcE+03IHdi/FQ==
X-Received: by 2002:a05:6402:84a:b0:607:5af9:19b6 with SMTP id 4fb4d7f45d1cf-608d08ac088mr11366761a12.15.1750171648571;
        Tue, 17 Jun 2025 07:47:28 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b491])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-608b4a9288csm7951040a12.57.2025.06.17.07.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 07:47:28 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 8/8] io_uring/zcrx: try to coalesce area pages
Date: Tue, 17 Jun 2025 15:48:26 +0100
Message-ID: <f65839d67b1074098e476302df3b1fe96264a15d.1750171297.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750171297.git.asml.silence@gmail.com>
References: <cover.1750171297.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Try to shrink the page array into fewer larger folios if possible. This
reduces the footprint, optimises dma mappings and will be used in the
future for further huge page optimisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 44b5f8084279..9f81682ccf0c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -166,6 +166,7 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 			  struct io_uring_zcrx_area_reg *area_reg)
 {
 	unsigned folio_shift = PAGE_SHIFT;
+	struct io_imu_folio_data data;
 	struct scatterlist *sgl;
 	struct page **pages;
 	int nr_pages, ret;
@@ -180,6 +181,17 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
+	if (nr_pages > 1 && io_check_coalesce_buffer(pages, nr_pages, &data)) {
+		/*
+		 * Only coalesce folio addr-aligned pages and when we can
+		 * improve the size.
+		 */
+		if (data.nr_pages_mid != 1 &&
+		    data.nr_pages_head == data.nr_pages_mid &&
+		    io_coalesce_buffer(&pages, &nr_pages, &data))
+			folio_shift = data.folio_shift;
+	}
+
 	ret = sg_alloc_table(&mem->page_sg_table, nr_pages, GFP_KERNEL_ACCOUNT);
 	if (ret)
 		return ret;
-- 
2.49.0


