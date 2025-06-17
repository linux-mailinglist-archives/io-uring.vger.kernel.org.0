Return-Path: <io-uring+bounces-8397-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78AA6ADD06D
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 16:50:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01E15167D68
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B67E22B585;
	Tue, 17 Jun 2025 14:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fMB7s1eZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E132E06D9
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 14:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750171650; cv=none; b=SMmx/qHvnScOXBZ395GS1tBBXM/4TPoz6FHtq4fODYITp4NlRbF8hzqnarquj9KDcWn2ZjfhbdM1wPI/K3FG+c0qO5ZtrBSGTCgFjSFH0L+qztzUHaGsJ5GpjnAErLLReYbNxsqhrk2w8eYs15wA6vU1ouwH4UBPVorucixYri8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750171650; c=relaxed/simple;
	bh=RCjxvuMGhHoSadmBj6nItM76NNrL9L6ZnfPiqlJJOA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpPNT0bnRfAjsTv2RuNLtlpus9RxgSwlOQCeRmAxaAjpURssiOpt6TvDYMBJFnBYXCzq+RjzqsvWWeijJJKxrzp+J+mB33KjweIMDrQX7LxmV6/8i+tT9a7JDyRFUbX9reIUBOKsMx7FYpWNp7g9xJv3FoowI96xT3j/wr39AqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fMB7s1eZ; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-607ec30df2bso10702176a12.1
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 07:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750171647; x=1750776447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/+DR2xdQvP57rbA36ZPLGctpXU8FxHEKhWhfu04ivI=;
        b=fMB7s1eZpgj9kE2jCBoA/rxwHshOVqqFMCXztS+w+hsSJqic+2/4NGH5ELmSizcO0Z
         FsFl9nBuYozhYHQQeZpgRbBrAk5v1In3yNptQ0fwDrlbAiGD7XE24NmLtNLLY2aTstNy
         MO+nmdEFvF63p8cA2YLOIliwI/bsqEkYiV/VLM4cPZHi8xmRo9A9/pn/rO0mjN6p6nCC
         yqnhkD1dUDOyrOvvTKvfL7XXqeRUrY2+aMPBHGUREznJrhjWD3C2jMOWHJb9Yxbi7L04
         dGj+NU98FdzkSynCAKLNbzqL+nUPEQ9DifSyycfwqdZs5sJ08KsWZNkipkXvJr+XxPHR
         itDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750171647; x=1750776447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D/+DR2xdQvP57rbA36ZPLGctpXU8FxHEKhWhfu04ivI=;
        b=gYM9WMOTBCJ6RzS4MtR3t5RT8UB0ef6Vs72LEfGnx1zBgvPDRo7xVVMPKo2nWVdkzD
         pcvcEk5XX8IRPsFIyChAjOTGD02sW4RkjMZ6PJNvswmXf3iSIuu1I0RFGetC713O5VNo
         WnciGcihys0vSNYjq8rFi1x2klHe0AE5JQD7mUJ7Li9vrtfx7pbY+msO8kNsreYyKJyu
         zsDwhJ+Q+I75s12DPZdYouNOBP2ChOIYOTBe4U/tssISVzCPWTJs8jACCzE6XcH1+7XW
         xEzRYNvDPGG5HvgNFiNUZZszGTy65JYpP1P5mgW6lgaNyAfhUb2arQ+OU9chlcMCTcaw
         TYow==
X-Gm-Message-State: AOJu0YyQoK+RHXybPWmkHugJmFejTs+bnwBvOVlMpFGux7DgxXJOYB21
	MLlD5byXtoTlLPIQZTN6L2j4uyOq+Q3qL1vmnjpRT9E2rhcOOH9oRWviILTvJQ==
X-Gm-Gg: ASbGnctO6bMF1iHv5TikkLqOXa5MmPh7CX5eljPQ08SVNZoSLfmMr2jYyLLUkpDZ1t2
	N5KzLOtcIbSEvEeaU7/RzkE2cqaSu/Grj+/soKNHG2XMaBn9nglFm14ho1X7F1j8mJWcu+TdGgK
	zF8ZTcrip/mYAmyjeyCJtTRhUqoER2ncWXuGYoPL2SdgiNxOympDJOaG0DvhrlreF7kh7XezbOb
	ZzTigjAG0eIy2x40OLG30yCY5CwoxyrJGOCBS7VCF2VabnzhLHnWSaDcvfl/9+jl2zl29yg2Z2u
	hmDiQURagJl5sVv3tqUfSHzLeLEbFY1Kojxr8lK9gPrkIg==
X-Google-Smtp-Source: AGHT+IH+uIOOdeaRNmNplLw8Sdi2pUryMqAvf5FfXXHVgcA6S3BznSuKUuu+WArXynrm7VBQIFB6gg==
X-Received: by 2002:a05:6402:2113:b0:5fb:f4a5:7871 with SMTP id 4fb4d7f45d1cf-608d09615ecmr13008880a12.16.1750171646533;
        Tue, 17 Jun 2025 07:47:26 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b491])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-608b4a9288csm7951040a12.57.2025.06.17.07.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 07:47:25 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 6/8] io_uring/zcrx: add infra for large pages
Date: Tue, 17 Jun 2025 15:48:24 +0100
Message-ID: <34e8280b870599c1cfa0e084b8b64578dec34de2.1750171297.git.asml.silence@gmail.com>
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

Currently, zcrx assumes PAGE_SIZE pages, add infrastructure to support
uniformly sized higher order pages. sg_table hides most of the details
and the only place that need index recalculation is the copy fallback.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 13 ++++++++-----
 io_uring/zcrx.h |  1 +
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a83b80c16491..44b5f8084279 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -44,13 +44,14 @@ static inline struct folio *io_niov_folio(const struct net_iov *niov,
 					  unsigned long *off)
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
-	struct page *page;
+	unsigned long niov_off, folio_idx;
 
 	lockdep_assert(!area->mem.is_dmabuf);
 
-	page = area->mem.pages[net_iov_idx(niov)];
-	*off = (page - compound_head(page)) << PAGE_SHIFT;
-	return page_folio(page);
+	niov_off = net_iov_idx(niov) << PAGE_SHIFT;
+	folio_idx = niov_off >> area->mem.folio_shift;
+	*off = niov_off - (folio_idx << area->mem.folio_shift);
+	return page_folio(area->mem.pages[folio_idx]);
 }
 
 static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
@@ -164,6 +165,7 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 			  struct io_zcrx_mem *mem,
 			  struct io_uring_zcrx_area_reg *area_reg)
 {
+	unsigned folio_shift = PAGE_SHIFT;
 	struct scatterlist *sgl;
 	struct page **pages;
 	int nr_pages, ret;
@@ -182,11 +184,12 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	if (ret)
 		return ret;
 	for_each_sg(mem->page_sg_table.sgl, sgl, nr_pages, i)
-		sg_set_page(sgl, pages[i], PAGE_SIZE, 0);
+		sg_set_page(sgl, pages[i], 1U << folio_shift, 0);
 
 	mem->pages = pages;
 	mem->nr_folios = nr_pages;
 	mem->size = area_reg->len;
+	mem->folio_shift = folio_shift;
 	return 0;
 }
 
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 89015b923911..4f718b3088d9 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -14,6 +14,7 @@ struct io_zcrx_mem {
 
 	struct page			**pages;
 	unsigned long			nr_folios;
+	unsigned			folio_shift;
 	struct sg_table			page_sg_table;
 
 	struct dma_buf_attachment	*attach;
-- 
2.49.0


