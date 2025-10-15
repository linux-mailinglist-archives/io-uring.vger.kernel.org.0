Return-Path: <io-uring+bounces-10021-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F15C7BDFD6C
	for <lists+io-uring@lfdr.de>; Wed, 15 Oct 2025 19:26:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7604319C5E8F
	for <lists+io-uring@lfdr.de>; Wed, 15 Oct 2025 17:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6537B338F2F;
	Wed, 15 Oct 2025 17:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="PIR457Mw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vs1-f97.google.com (mail-vs1-f97.google.com [209.85.217.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CF62D3755
	for <io-uring@vger.kernel.org>; Wed, 15 Oct 2025 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760549162; cv=none; b=i7Az2pxoaavSwViv04uEeaPIPwhgYmA8hM3priN97hDevUl4WRdHMFA58zyk3F8c2iJiV9GZnFbYtpBw5GKn2RCFeaolAUXmrtRoEnlvctrnsIUlvXefhXEy5V1ZokwFaYcDN/DJUd0FLUwpZ8sG60gowgbG4I5WW7MpPYixZGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760549162; c=relaxed/simple;
	bh=JB5oFzqmNqnAnPByzKv3TD4SI4/gUXMe6Yt/XtVTZxo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iG+txAkTDF/7eea9KEuLdNZiapFY+7lZSPEDGJplfUxBY1PlaL5O0xburj+TuuZ8cqEZlwEUfGZ/IPFTW42aRdBS/gxinytO0NoVPLe8pqkNAlZDmpJSqj9N2Rxrsz1AlwkQd0vSa/OOh2iGdp/XOdUmZpJGCeLLBI9MK9ow74E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=PIR457Mw; arc=none smtp.client-ip=209.85.217.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-vs1-f97.google.com with SMTP id ada2fe7eead31-57f496e96d6so451288137.0
        for <io-uring@vger.kernel.org>; Wed, 15 Oct 2025 10:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1760549159; x=1761153959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8a0FBTWbRkzlovsTrElybeARL/kMTLRwEd+6K2uwZkE=;
        b=PIR457MwBUzF9YGnn9XoWgp1FewRVHpdJFvQpOPbAOXOWIS5J8cyBezuLCfUc05kUN
         0+BLS1xVgnkOrQAOqHRgZqjDW+5HzYNBcnk8aIkXrbcPesw/YBFp8vn0oat8DZiQuM8C
         6knu0QmINxALoyiB5tCgQVCR4Zh+OLNdVM8vIsTo05sd0ZpJQOiVlE/arGsY0nCTHE7c
         lg14OmuKDSQDEl0unTWOvMDLWhJgKuoJedejpLTQKD9AskcEiKGSTfjBi8cyf6dveRem
         K3/oS0CgqKAE4X/BzozaDh4duoafrTcV5Rhuo49w5X4TgxkwtWYbIz73FKu4PFkDJbwT
         sMKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760549159; x=1761153959;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8a0FBTWbRkzlovsTrElybeARL/kMTLRwEd+6K2uwZkE=;
        b=VcGSutJbWNgMfn6+spQIxut+I6xQZ8MbiMlZRNzrUklkuLXwk4jxGM/6Jm7m2Um6hE
         CR03iNd033uAwkz1SBN4UmbTEN8t8dwDdGVlnfGvU9PXoBidlGIYy4RFWC5fn6JZTK+W
         4DAcYluenmrjNH7uQRUAgn2XXF2+DSYq6Lz9XFKgicqrzeGe5GVXfcnUkFp59u3KGfZZ
         BP6PUcGdAzzjYrwvbfnZ0aG3biM/pMJYOBndGzfhO3VFYqlL9AYrxNuR7Rs8CtBS9sd5
         TtoVvOxbzU45p7BzerWAsvgVypYLf53n72Z8abJwFpByZhBxGNQ90gDpqOn7LZFAWLyT
         V0PQ==
X-Forwarded-Encrypted: i=1; AJvYcCVk4Gqw+jSQ+7HO4g51WXHSKXbxhw8HaZpd5odzxcocccSEaGU9yACKi/HApJFZQr7XBzHjCSairw==@vger.kernel.org
X-Gm-Message-State: AOJu0YylO3/paL3n3BmKjKnszYAQuj9g9JCYSn+N8qMwp4PHTZ+i+pN4
	cCsArZj6Fl7lwy+L4ku8w307P50njy7hBbLxcGgbfENIelFzRiKlQGk46hqABVzbpnyp1vh2BKZ
	ePSId4iHtObLqF5Bwtt0MTDiMRnKo2P4Es946
X-Gm-Gg: ASbGnctj1mnmZR0TZrNt2+Jlq9Pmrdy97wlbXecwgtXGy9z6df2jQf2xb0gs1lXkfQl
	fAB89ZUj9lkCDLorJ0PQ3EUSlM9E1IE8DlDNcyTJPEbKG/LiwU7iRiMNyl/jX13VzjguWT8NImj
	EEOl55DTVixLBlnOCuwol7jCKIy/QYj4/kDepv2XMR3dyni2udQjioeFoiFaduZ96otB50Dl9hq
	b8fbUPaC0sLBLuolef3oaVH2120olFzH2opVYtmjPR583yraB4cI47H9GvabXQuronaSQkdzCHD
	FOx8Wc0Sd/sCSjfwclNvoFsvpaEYgMLUlnFVq2Z2x/qIKEUOus2vV26R+MLrPKEohevoSKpK
X-Google-Smtp-Source: AGHT+IEyCGl9AhptKS4IDg6E1CU4cRmqkZiT6EIc5uRSVlidSgZPLElf0iGy34FDQOT0X6ZobQurYjmqAj3u
X-Received: by 2002:a05:6102:3581:b0:55d:b35e:7a67 with SMTP id ada2fe7eead31-5d5e21f14famr5081188137.2.1760549158620;
        Wed, 15 Oct 2025 10:25:58 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-5d5fc4d87cfsm2010256137.0.2025.10.15.10.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 10:25:58 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id E7560340576;
	Wed, 15 Oct 2025 11:25:57 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id E03A3E41EAD; Wed, 15 Oct 2025 11:25:57 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/memmap: return bool from io_mem_alloc_compound()
Date: Wed, 15 Oct 2025 11:25:54 -0600
Message-ID: <20251015172555.2797238-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_mem_alloc_compound() returns either ERR_PTR(-ENOMEM) or a virtual
address for the allocated memory, but its caller just checks whether the
result is an error. Return a bool success value instead.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/memmap.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 2e99dffddfc5..b53733a54074 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -13,30 +13,30 @@
 #include "memmap.h"
 #include "kbuf.h"
 #include "rsrc.h"
 #include "zcrx.h"
 
-static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
-				   size_t size, gfp_t gfp)
+static bool io_mem_alloc_compound(struct page **pages, int nr_pages,
+				  size_t size, gfp_t gfp)
 {
 	struct page *page;
 	int i, order;
 
 	order = get_order(size);
 	if (order > MAX_PAGE_ORDER)
-		return ERR_PTR(-ENOMEM);
+		return false;
 	else if (order)
 		gfp |= __GFP_COMP;
 
 	page = alloc_pages(gfp, order);
 	if (!page)
-		return ERR_PTR(-ENOMEM);
+		return false;
 
 	for (i = 0; i < nr_pages; i++)
 		pages[i] = page + i;
 
-	return page_address(page);
+	return true;
 }
 
 struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
 {
 	unsigned long start, end, nr_pages;
@@ -157,18 +157,16 @@ static int io_region_allocate_pages(struct io_ring_ctx *ctx,
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
 	size_t size = (size_t) mr->nr_pages << PAGE_SHIFT;
 	unsigned long nr_allocated;
 	struct page **pages;
-	void *p;
 
 	pages = kvmalloc_array(mr->nr_pages, sizeof(*pages), gfp);
 	if (!pages)
 		return -ENOMEM;
 
-	p = io_mem_alloc_compound(pages, mr->nr_pages, size, gfp);
-	if (!IS_ERR(p)) {
+	if (io_mem_alloc_compound(pages, mr->nr_pages, size, gfp)) {
 		mr->flags |= IO_REGION_F_SINGLE_REF;
 		goto done;
 	}
 
 	nr_allocated = alloc_pages_bulk_node(gfp, NUMA_NO_NODE,
-- 
2.45.2


