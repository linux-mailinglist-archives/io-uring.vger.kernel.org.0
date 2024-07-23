Return-Path: <io-uring+bounces-2544-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D459399B3
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 08:28:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE205282895
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 06:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EAE513D896;
	Tue, 23 Jul 2024 06:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="O3XyFIqJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719C013D8B3
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 06:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721716114; cv=none; b=u8LtR6/EmIciPSvLY2VOYeZOzWyjytAbAnD6xRxUUDxzaA4Jjhoc6WECcgPoGe5F4Sp5A593DSNcKlkVPqPqT1/0wHZ+w7U0Jzf9W73m6pA1qcZra42GJLdHelJmXChL+RvoHgL6nVEHPhFnON9NnjXWP/wXfsO4rzbkIRhhGg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721716114; c=relaxed/simple;
	bh=rwSlEH5POIeRfeBUzdsicMXJRZ+TjVooAEvRCUzEhkQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=NLGFBnoaWV37TfvJf5GnN5fcqubiUwp19i7NXWSUYuvGLL9Qz5f87LGk7UawR3VQnvFQDjzRm5rVHC/UB24VE+LgF8LNRKKETUL4eijSvD/PY9t+0vn6KjrEKna2y1y+GJY6EmwS7GW5oXT8E5bwWZsxAvZLAGmnsaGWypE+8fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=O3XyFIqJ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240723062829epoutp04ac2efb16be0c2e638c224525a4d5cf99~kw630iHYN0182301823epoutp04D
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 06:28:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240723062829epoutp04ac2efb16be0c2e638c224525a4d5cf99~kw630iHYN0182301823epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1721716109;
	bh=dRZHvZ8LVGP9ldTit2RBbw55OLuz4Nu4t6v9O5KqMsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3XyFIqJIPEIzGYzubCPCuxuQW1qW2JF2BBZ4TK5qSlLqugeiPeWQZjtgPtIdYRD5
	 8F9kK0BddJj28nverc7/4Qe8G/rtkOWvpn5eVQvLspMWWB6Gd7didPEwetEXpoQ0Ia
	 JDp7CymgamzO4Qjb64ZceCvcJUqxCFKZRdW7lWO4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240723062828epcas5p2b74e2e7d5fc661c910a356ecb6ab37a7~kw63LXoDF1918419184epcas5p2j;
	Tue, 23 Jul 2024 06:28:28 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WSnK65w5Kz4x9Q7; Tue, 23 Jul
	2024 06:28:26 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AD.E5.08855.A8D4F966; Tue, 23 Jul 2024 15:28:26 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240723055627epcas5p4e61911110cd5aa41d80f1570d7796bd0~kwe6DJOjs1800918009epcas5p4k;
	Tue, 23 Jul 2024 05:56:27 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240723055627epsmtrp2503a76cc451a072ba2e220bdf453c70c~kwe6Brb7E2364623646epsmtrp2W;
	Tue, 23 Jul 2024 05:56:27 +0000 (GMT)
X-AuditID: b6c32a44-107ff70000002297-c5-669f4d8a0099
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B8.72.08964.B064F966; Tue, 23 Jul 2024 14:56:27 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240723055626epsmtip2f02b9168a5caa0145bda4e2bf840c27d~kwe4g3Zdu1451714517epsmtip2G;
	Tue, 23 Jul 2024 05:56:25 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [Patch v7 2/2] io_uring/rsrc: enable multi-hugepage buffer
 coalescing
Date: Tue, 23 Jul 2024 13:56:16 +0800
Message-Id: <20240723055616.2362-3-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240723055616.2362-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmum6X7/w0g2cv1C2aJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7IwnWxYzFhw2rbhw0bKBcZdWFyMnh4SAicSkff1sXYxcHEICuxkl
	jr5sZYRwPjFKLFtznAXC+cYo8fHObxaYlvkXbkK17AVqWfSAHSQhJNDEJLHnrzyIzSagI/F7
	xS+wBhEBbYnXj6eC2cwCuxglFp6TArGFBQIk+v5+A+rl4GARUJVoXOEMEuYVsJb4+uAlO8Qu
	eYn9B88yg9icAjYSj89NYoSoEZQ4OfMJ1Eh5ieats5lB7pEQ+MkusWjidWaIZheJJ9cuskHY
	whKvjm+BGiol8fndXjaQvRICxRLL1slB9LYwSrx/N4cRosZa4t+VPSwgNcwCmhLrd+lDhGUl
	pp5axwSxl0+i9/cTJog4r8SOeTC2qsSFg9ugVklLrJ2wFeocD4m/n1qZIeHWzyjx9Fov4wRG
	hVlI/pmF5J9ZCKsXMDKvYpRMLSjOTU9NNi0wzEsth8dxcn7uJkZwKtVy2cF4Y/4/vUOMTByM
	hxglOJiVRHifvJqbJsSbklhZlVqUH19UmpNafIjRFBjeE5mlRJPzgck8ryTe0MTSwMTMzMzE
	0tjMUEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGJmXfAPu7nq13XgvvvN5b9Mny+MnTe3P2
	8dcuvle65P8pt01ruA1UP7wI+PN+o3/C5BQfncAvdw5d6joZtSmvptB0dVbdmf3fln1mO/Lk
	w9kTX+s5JxjMDQ4JEQ5c8zdnGRfnDJPgxEi5LtM24ROXbe61hXhvfNfE2LviS8K6io6/Eq8L
	HNaF5Zs8nNbh/FGuqVRg6u/6Ncudd/XInZ3NHmjxdxLP5M1cjjmCS6Nu3NnP1vHI8vuM905B
	hYbqSv17d16/1sG69c8/8a2n55fdSNl20C53i9Ca1FmV190OrmDUOnliLXNVcR9Lxt39Hkah
	AkLs6+dOu54ttKZScUOdw/fNb8LrDhdsX/o+re+QZKcSS3FGoqEWc1FxIgB2MCzELgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSvC632/w0g8M/lS2aJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxpMtixkLDptWXLho2cC4S6uLkZNDQsBE
	Yv6Fm2wgtpDAbkaJle+VIeLSEh2HWtkhbGGJlf+eA9lcQDUNTBJXvtxlBUmwCehI/F7xi6WL
	kYNDREBXovGuAkgNs8AhRonmDc2MIDXCAn4SW/euZgOpYRFQlWhc4QwS5hWwlvj64CXUfHmJ
	/QfPMoPYnAI2Eo/PTWKEuMdaYvKmNYwQ9YISJ2c+YQGxmYHqm7fOZp7AKDALSWoWktQCRqZV
	jJKpBcW56bnFhgWGeanlesWJucWleel6yfm5mxjBoa6luYNx+6oPeocYmTgYgW7mYFYS4X3y
	am6aEG9KYmVValF+fFFpTmrxIUZpDhYlcV7xF70pQgLpiSWp2ampBalFMFkmDk6pBqatR30z
	JKftC29+qXsqa+Oka18DNrFV5a5UucI9OYdnUUnOsV+7ez6n/K982fbV/WJijGadq7K9gegN
	porwAkXhWW+mV++I0u++xlV1eqm0jMvmQIkFpq/uPvt+340h9bGkToy773kLO02LhVISB2TF
	87+/5fY04P+Zza17QcjOfN6BHzv4dl9N4QyWKlitw1U747Vz5yHz82c+7Vpm9HS6oWf11w3T
	Wmxaz2TZRwetfDDhYkJCmV11elHq8fL/zYmeApwCuxiPnlkgeNPwlOlJZeGQtNi+b+dkpokV
	9C76sexKtqp+m5h8og/Pow012bvSm2svnE6RO/u2pDzO8vqi8o9awvMqVJPcrjZmK7EUZyQa
	ajEXFScCAIHo6SjkAgAA
X-CMS-MailID: 20240723055627epcas5p4e61911110cd5aa41d80f1570d7796bd0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240723055627epcas5p4e61911110cd5aa41d80f1570d7796bd0
References: <20240723055616.2362-1-cliang01.li@samsung.com>
	<CGME20240723055627epcas5p4e61911110cd5aa41d80f1570d7796bd0@epcas5p4.samsung.com>

Add support for checking and coalescing multi-hugepage-backed fixed
buffers. The coalescing optimizes both time and space consumption caused
by mapping and storing multi-hugepage fixed buffers.

A coalescable multi-hugepage buffer should fully cover its folios
(except potentially the first and last one), and these folios should
have the same size. These requirements are for easier processing later,
also we need same size'd chunks in io_import_fixed for fast iov_iter
adjust.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 io_uring/rsrc.c | 134 ++++++++++++++++++++++++++++++++++++------------
 io_uring/rsrc.h |   8 +++
 2 files changed, 110 insertions(+), 32 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 0d6cda92ba46..794c046b9247 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -849,6 +849,98 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	return ret;
 }
 
+static bool io_do_coalesce_buffer(struct page ***pages, int *nr_pages,
+				struct io_imu_folio_data *data, int nr_folios)
+{
+	struct page **page_array = *pages, **new_array = NULL;
+	int nr_pages_left = *nr_pages, i, j;
+
+	/* Store head pages only*/
+	new_array = kvmalloc_array(nr_folios, sizeof(struct page *),
+					GFP_KERNEL);
+	if (!new_array)
+		return false;
+
+	new_array[0] = compound_head(page_array[0]);
+	/*
+	 * The pages are bound to the folio, it doesn't
+	 * actually unpin them but drops all but one reference,
+	 * which is usually put down by io_buffer_unmap().
+	 * Note, needs a better helper.
+	 */
+	if (data->nr_pages_head > 1)
+		unpin_user_pages(&page_array[1], data->nr_pages_head - 1);
+
+	j = data->nr_pages_head;
+	nr_pages_left -= data->nr_pages_head;
+	for (i = 1; i < nr_folios; i++) {
+		unsigned int nr_unpin;
+
+		new_array[i] = page_array[j];
+		nr_unpin = min_t(unsigned int, nr_pages_left - 1,
+					data->nr_pages_mid - 1);
+		if (nr_unpin)
+			unpin_user_pages(&page_array[j+1], nr_unpin);
+		j += data->nr_pages_mid;
+		nr_pages_left -= data->nr_pages_mid;
+	}
+	kvfree(page_array);
+	*pages = new_array;
+	*nr_pages = nr_folios;
+	return true;
+}
+
+static bool io_try_coalesce_buffer(struct page ***pages, int *nr_pages,
+					 struct io_imu_folio_data *data)
+{
+	struct page **page_array = *pages;
+	struct folio *folio = page_folio(page_array[0]);
+	unsigned int count = 1, nr_folios = 1;
+	int i;
+
+	if (*nr_pages <= 1)
+		return false;
+
+	data->nr_pages_mid = folio_nr_pages(folio);
+	if (data->nr_pages_mid == 1)
+		return false;
+
+	data->folio_shift = folio_shift(folio);
+	/*
+	 * Check if pages are contiguous inside a folio, and all folios have
+	 * the same page count except for the head and tail.
+	 */
+	for (i = 1; i < *nr_pages; i++) {
+		if (page_folio(page_array[i]) == folio &&
+			page_array[i] == page_array[i-1] + 1) {
+			count++;
+			continue;
+		}
+
+		if (nr_folios == 1) {
+			if (folio_page_idx(folio, page_array[i-1]) !=
+				data->nr_pages_mid - 1)
+				return false;
+
+			data->nr_pages_head = count;
+		} else if (count != data->nr_pages_mid) {
+			return false;
+		}
+
+		folio = page_folio(page_array[i]);
+		if (folio_size(folio) != (1UL << data->folio_shift) ||
+			folio_page_idx(folio, page_array[i]) != 0)
+			return false;
+
+		count = 1;
+		nr_folios++;
+	}
+	if (nr_folios == 1)
+		data->nr_pages_head = count;
+
+	return io_do_coalesce_buffer(pages, nr_pages, data, nr_folios);
+}
+
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				  struct io_mapped_ubuf **pimu,
 				  struct page **last_hpage)
@@ -858,7 +950,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	unsigned long off;
 	size_t size;
 	int ret, nr_pages, i;
-	struct folio *folio = NULL;
+	struct io_imu_folio_data data;
+	bool coalesced;
 
 	*pimu = (struct io_mapped_ubuf *)&dummy_ubuf;
 	if (!iov->iov_base)
@@ -873,31 +966,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		goto done;
 	}
 
-	/* If it's a huge page, try to coalesce them into a single bvec entry */
-	if (nr_pages > 1) {
-		folio = page_folio(pages[0]);
-		for (i = 1; i < nr_pages; i++) {
-			/*
-			 * Pages must be consecutive and on the same folio for
-			 * this to work
-			 */
-			if (page_folio(pages[i]) != folio ||
-			    pages[i] != pages[i - 1] + 1) {
-				folio = NULL;
-				break;
-			}
-		}
-		if (folio) {
-			/*
-			 * The pages are bound to the folio, it doesn't
-			 * actually unpin them but drops all but one reference,
-			 * which is usually put down by io_buffer_unmap().
-			 * Note, needs a better helper.
-			 */
-			unpin_user_pages(&pages[1], nr_pages - 1);
-			nr_pages = 1;
-		}
-	}
+	/* If it's huge page(s), try to coalesce them into fewer bvec entries */
+	coalesced = io_try_coalesce_buffer(&pages, &nr_pages, &data);
 
 	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
 	if (!imu)
@@ -909,7 +979,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		goto done;
 	}
 
-	off = (unsigned long) iov->iov_base & ~PAGE_MASK;
 	size = iov->iov_len;
 	/* store original address for later verification */
 	imu->ubuf = (unsigned long) iov->iov_base;
@@ -917,17 +986,18 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	imu->nr_bvecs = nr_pages;
 	imu->folio_shift = PAGE_SHIFT;
 	imu->folio_mask = PAGE_MASK;
+	if (coalesced) {
+		imu->folio_shift = data.folio_shift;
+		imu->folio_mask = ~((1UL << data.folio_shift) - 1);
+	}
+	off = (unsigned long) iov->iov_base & ~imu->folio_mask;
 	*pimu = imu;
 	ret = 0;
 
-	if (folio) {
-		bvec_set_page(&imu->bvec[0], pages[0], size, off);
-		goto done;
-	}
 	for (i = 0; i < nr_pages; i++) {
 		size_t vec_len;
 
-		vec_len = min_t(size_t, size, PAGE_SIZE - off);
+		vec_len = min_t(size_t, size, (1UL << imu->folio_shift) - off);
 		bvec_set_page(&imu->bvec[i], pages[i], vec_len, off);
 		off = 0;
 		size -= vec_len;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 8b029c53d325..048fd6959f7a 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -52,6 +52,14 @@ struct io_mapped_ubuf {
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
 
+struct io_imu_folio_data {
+	/* Head folio can be partially included in the fixed buf */
+	unsigned int	nr_pages_head;
+	/* For non-head/tail folios, has to be fully included */
+	unsigned int	nr_pages_mid;
+	unsigned int	folio_shift;
+};
+
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
-- 
2.34.1


