Return-Path: <io-uring+bounces-8706-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A02CBB07F3A
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 23:03:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7D664E631B
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 21:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 303BC12C544;
	Wed, 16 Jul 2025 21:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lyVBndnF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7604A11
	for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 21:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752699779; cv=none; b=bKxdJ6/LT+eIxmgwEVXagc7/WXSxwRNYCRXmHFkeAVUBmzz03udWP6QjlBz8iy8XL+fM6kFkMMH5pZKvZIRe+f/axdv4AjyuCW21MqzcUOgWfxfJ0QXumQ/CEGjnNzOpg1LYomdVTydhD7CZBeoeug1eAjilT/6LN6ycLNFgwa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752699779; c=relaxed/simple;
	bh=Y815Pn2IgZL+56roLq0GrX6dSpoDmU8DEQ8lcBS6ADg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQ6c7GcAUjo5hJZlmSWYZvrH0cjAGQJsne4qQkcZI2B5CGmvKvQZQydolWn6ZKGWUIpUCY2iFyRekiBFY1G2RmOyNTgEG610hGiY17EEwUN9YRZaMGFh5BuONusFqHXz0R4r7jkd7CaEvw9frJxtM2zj4igfvewtGVN6xiEcczQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lyVBndnF; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-60c01f70092so371309a12.3
        for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 14:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752699775; x=1753304575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iGGw0ubA493OPwTyV6lB/y6jMn1D5eZ+Xp432zHqcuU=;
        b=lyVBndnFtpUfFEq82i0i3LpY+ZT1rKg3s++FbUEV+zckJlIQc3iVZkgE9NyyTbKwa4
         9nbfGSLOk7UgguLBiQRWINICoi+lsZsVrU8Ef0lQvRoG2xe3iF51fzUsBs1iWFZSuMf8
         IfOq/4km2Hseri9zkBXYZMDPMHaeFa5tmEEdEsq3RZId5Mgwa5UWIDQIp/axg964+7Ek
         uJ7xJ5VbUK/oW5y6UpT4CtAc53wr87LoQmCyKled87fjP7k1iHRiWGAphVpE6pYLAJyP
         JTsDpG+dAvTlEULyIfos+k68sKXxDOc5S4CyVmAgCKrjUMXrvdsR1jAoOi8DzUHmAm1i
         CVAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752699775; x=1753304575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iGGw0ubA493OPwTyV6lB/y6jMn1D5eZ+Xp432zHqcuU=;
        b=Y9mH5WKnMAa5nE007Y+ePTdDJWzL08+a23GZ6AXKvaquP4YCuYc2NWJaGwQSjt4Z7J
         n0iiYMlgsjm041KnRl0AR0mwdMleCUJKgHF6Nr5yw/3vkLiUJ/09baLtgNROjNJexGBa
         dTl9UMKgVCNlw/17mXbYyNn9lJqfBVXvlnXqTRbvZipVftAuD6pn1TfF+7FBf4TL0UH2
         1CaxMtmFNHlWNojH3bzJjnqdzqfU8LLA5/IA7DBufzOD4ph/Zd41ykuaZTnI7TYWG8O/
         mNfLhRDlWbUzuRLNMzH691lixTFGJJFG77PG8R9r4pXujd/YEips3PAniGwP4pNbIvnF
         ZW0w==
X-Gm-Message-State: AOJu0YyQED4stE8NnA/bg7TRdL5R81NKdU1AwZHz1lqy7as8Hnxd7/rf
	kC/djrc4Z/rZNJkvDVPl8IB0gci0VfXwxVNPCY1oj25rj0iPD18BGTxtxCRr7w==
X-Gm-Gg: ASbGncuR4agCLCBvrcpchCkhf0VVEO4F+AV6cHMltL2ED7Q2Aar3Hi0boJA8tOxIiNP
	NA433PQPblsn9XC4hP0VnLdT+Cu84Jju+F52UfUTcx/xNbHaf3dfMNv4hMUK+WqGv3KRXrZOdnf
	Y0uTjfaSw6iYNN//Z1PN76yRRjGXBUn0A9iVJtb9EN6FLQm6cDmGAPPnoeQvQOKcgMqXnKhhikf
	fzdhRFGG/f395wzI9N9w2Jug194ObAcVj3GepiGvyjOhcTpO/yZTwGl+woepTh13hmJvtGTfz3t
	8UmMqZad1hTP7hHVVKqvdnaN4HtUn9CBNSi+QNNQTJQFzjoA4XJVAx0W8eD62O5wq3mvbyEZBDn
	NdGvFuHQMQR3aQWDIQyyaOG9Hle5EFocMwg==
X-Google-Smtp-Source: AGHT+IFz2v/TGJC2Q1hnnCTQfz7nrqZvIoB3t469O/oUXK33pGyIB9daYD5VHhKn00NSBofSl5qpFA==
X-Received: by 2002:a17:907:9487:b0:ae3:cac0:f47c with SMTP id a640c23a62f3a-aec4fb095a4mr43714966b.26.1752699775050;
        Wed, 16 Jul 2025 14:02:55 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.71])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e8264fd2sm1254007466b.108.2025.07.16.14.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 14:02:54 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dw@davidwei.uk
Subject: [PATCH 2/2] io_uring/zcrx: account area memory
Date: Wed, 16 Jul 2025 22:04:09 +0100
Message-ID: <4b53f0c575bd062f63d12bec6cac98037fc66aeb.1752699568.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1752699568.git.asml.silence@gmail.com>
References: <cover.1752699568.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zcrx areas can be quite large and need to be accounted and checked
against RLIMIT_MEMLOCK. In practise it shouldn't be a big issue as
the inteface already requires cap_net_admin.

Cc: stable@vger.kernel.org
Fixes: cf96310c5f9a0 ("io_uring/zcrx: add io_zcrx_area")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 27 +++++++++++++++++++++++++++
 io_uring/zcrx.h |  1 +
 2 files changed, 28 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 7d7396ce876c..dabce3ee0e8b 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -158,6 +158,23 @@ static int io_zcrx_map_area_dmabuf(struct io_zcrx_ifq *ifq, struct io_zcrx_area
 				    area->mem.dmabuf_offset);
 }
 
+static unsigned long io_count_account_pages(struct page **pages, unsigned nr_pages)
+{
+	struct folio *last_folio = NULL;
+	unsigned long res = 0;
+	int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		struct folio *folio = page_folio(pages[i]);
+
+		if (folio == last_folio)
+			continue;
+		last_folio = folio;
+		res += 1UL << folio_order(folio);
+	}
+	return res;
+}
+
 static int io_import_umem(struct io_zcrx_ifq *ifq,
 			  struct io_zcrx_mem *mem,
 			  struct io_uring_zcrx_area_reg *area_reg)
@@ -180,6 +197,13 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	if (ret)
 		return ret;
 
+	mem->account_pages = io_count_account_pages(pages, nr_pages);
+	ret = io_account_mem(ifq->ctx, mem->account_pages);
+	if (ret < 0) {
+		mem->account_pages = 0;
+		return ret;
+	}
+
 	mem->pages = pages;
 	mem->nr_folios = nr_pages;
 	mem->size = area_reg->len;
@@ -357,6 +381,9 @@ static void io_zcrx_free_area(struct io_zcrx_area *area)
 		io_zcrx_unmap_area(area->ifq, area);
 	io_release_area_mem(&area->mem);
 
+	if (area->mem.account_pages)
+		io_unaccount_mem(area->ifq->ctx, area->mem.account_pages);
+
 	kvfree(area->freelist);
 	kvfree(area->nia.niovs);
 	kvfree(area->user_refs);
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 89015b923911..109c4ca36434 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -15,6 +15,7 @@ struct io_zcrx_mem {
 	struct page			**pages;
 	unsigned long			nr_folios;
 	struct sg_table			page_sg_table;
+	unsigned long			account_pages;
 
 	struct dma_buf_attachment	*attach;
 	struct dma_buf			*dmabuf;
-- 
2.49.0


