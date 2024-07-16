Return-Path: <io-uring+bounces-2516-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C92F932057
	for <lists+io-uring@lfdr.de>; Tue, 16 Jul 2024 08:15:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75C4C1C21559
	for <lists+io-uring@lfdr.de>; Tue, 16 Jul 2024 06:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAA2617C8B;
	Tue, 16 Jul 2024 06:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="l5PUzlFR"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DF72599
	for <io-uring@vger.kernel.org>; Tue, 16 Jul 2024 06:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721110548; cv=none; b=KLFgYtcospb76N7+vPnQliMz6Pxum9mxPmiDru+CcmXtPoeY7NealLKwMqfoRQWiquI2c0jXb+BtBax6nCPwYeXbrZh9vQL+UlnGCScp/cDFqtJTq835EK3wJELiQTFx1AdJ5xiS1FztL3fqn9QpvYoRzf070nQLB1oLXJBlBX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721110548; c=relaxed/simple;
	bh=zP+O3TXxQ+JoS5IQSj9xGH/Tya1CuEZw6GoENmbSxv0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Lsix/ApKYMs5hFBrQKPBAUWU/ctbGjzD73BEN8FyRSrIzu3z3UJPJec6EItbBK3zpdxveRH+M7ECuUeTM9KW9y0Yc9I/HfPc1MAGzP3NYgqu76shDHQl5IE5E5+7GTd4bMsQadRoS8ZQd+eetOiz/WheOqv9p2+QeTds2dqUFG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=l5PUzlFR; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240716061537epoutp014a63e3c4b4bd9f01ad21b300fed3b867~inOpVrDv71127211272epoutp01L
	for <io-uring@vger.kernel.org>; Tue, 16 Jul 2024 06:15:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240716061537epoutp014a63e3c4b4bd9f01ad21b300fed3b867~inOpVrDv71127211272epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1721110537;
	bh=3Tx2J5vgajnGedwka7nzgsHiLd0Joih4HPmSwPRwk2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5PUzlFR8sN7k+fTGImDhXyhwYtB2ass8XAEK+M+oAM7XS6cr9j52YQzdpUpnVX0J
	 yo+MoNw1PNq3Ib2KL6Iw0sDWub5tu/spG/gLd7Ji8pi9d9MW90MLmQc3F13aU59+ZH
	 GCJYBUKU+bA51zLbY6nBCYwy+TLeztVLoerjSilA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240716061537epcas5p4f6068e8f5914e812a7da6779f96547ab~inOo1lhTO2733027330epcas5p4l;
	Tue, 16 Jul 2024 06:15:37 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4WNTMW4Hk1z4x9Q7; Tue, 16 Jul
	2024 06:15:35 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5B.BD.06857.70016966; Tue, 16 Jul 2024 15:15:35 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240716060819epcas5p3387922a068b65eca1b3ab65effcf586e~inIRGOslf2206022060epcas5p3k;
	Tue, 16 Jul 2024 06:08:19 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240716060819epsmtrp186e2f00fbf03c94de273ccb516a1d1ac~inIRFVEzK1559415594epsmtrp16;
	Tue, 16 Jul 2024 06:08:19 +0000 (GMT)
X-AuditID: b6c32a4b-88bff70000021ac9-36-669610073018
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A2.1E.29940.35E06966; Tue, 16 Jul 2024 15:08:19 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240716060817epsmtip1db1389dd8b16052f77d5a0a5d35ba891~inIPiJAA12547325473epsmtip1f;
	Tue, 16 Jul 2024 06:08:17 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH v6 2/2] io_uring/rsrc: enable multi-hugepage buffer
 coalescing
Date: Tue, 16 Jul 2024 14:08:07 +0800
Message-Id: <20240716060807.2707-3-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240716060807.2707-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmpi67wLQ0g12/pSyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7IxFR0oKNphVvH17g62BsVe7i5GDQ0LAROLeQ/cuRi4OIYHdjBJ7
	j7xhgXA+MUrs/r6MHcL5xijxtnMxYxcjJ1jHrr/dTBCJvYwSGy7/ZoVwmpgkThzawwxSxSag
	I/F7xS8WEFtEQFvi9eOpYDazwC5GiYXnpEBsYYEAiTWT/oNNZRFQlVi09wMriM0rYC0xc+9m
	Joht8hL7D54Fm8kpYCPR+/UqO0SNoMTJmU+gZspLNG+dzQxyhITAX3aJzh9tLBDNLhLrX/Ww
	QtjCEq+Ob2GHsKUkXva3sUMCoFhi2To5iN4WRon37+ZAvWkt8e/KHhaQGmYBTYn1u/QhwrIS
	U0+tY4LYyyfR+/sJ1J28EjvmwdiqEhcOboNaJS2xdsJWZgjbQ2LFymVsILaQQD+jxMvV8hMY
	FWYheWcWkndmIWxewMi8ilEytaA4Nz212LTAOC+1HB7Hyfm5mxjBqVTLewfjowcf9A4xMnEw
	HmKU4GBWEuGdwDgtTYg3JbGyKrUoP76oNCe1+BCjKTC8JzJLiSbnA5N5Xkm8oYmlgYmZmZmJ
	pbGZoZI47+vWuSlCAumJJanZqakFqUUwfUwcnFINTJz6u7d//fFh4z9TAYWq2eLm63P0Ppr3
	p2kVPZ90tKD9l3lRhsbk3BY/s+R/yaZvTkhKlLCp/d9R6+jw4/HW79KXBNYmvFnu/nL7pqjV
	abpJ8YtvXfNu59x8WFrsjtK+xGtn+Hfezfj6TJnn2aX5Hb+ilNMjpuqcv/522xT5+lnBW7el
	8fpNEPip8j7Mi/F5f0Xr7Tvxr06c0NrWKHHuqu7D8l4p1asMO//z3cxt/P4gqyukcJHa7rjn
	a+etKOZdPM2jYIeSN/+BGYLVYefby4w0ftqtXpX4ozHCz8pIw1ux6MYx1mtPza5Pe21gFrbC
	0uLm7VurojmPxJq8CJvf32Lx9P5+F9kLqTnBLfPbw5VYijMSDbWYi4oTAYe/i3guBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSnG4w37Q0g4PTJSyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxqIjJQUbzCrevr3B1sDYq93FyMkhIWAi
	setvN1MXIxeHkMBuRomWWW+YIRLSEh2HWtkhbGGJlf+es0MUNTBJbNrzFyzBJqAj8XvFL5Yu
	Rg4OEQFdica7CiA1zAKHGCWaNzQzgsSFBfwkJn6rBilnEVCVWLT3AyuIzStgLTFz72YmiPny
	EvsPngXbyylgI9H79SrYeCGgmhezpjJB1AtKnJz5hAXEZgaqb946m3kCo8AsJKlZSFILGJlW
	MUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIEB7uW5g7G7as+6B1iZOJgBLqZg1lJhHcC
	47Q0Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rziL3pThATSE0tSs1NTC1KLYLJMHJxSDUx7LrPs
	vX719Y1vLkrROipni7Qc/pWVfHmRcMm6gy9XmPVTt8yx60X8k99MENXnPCOWMWnpRfYdZVcO
	P077wWIem/fyY0r7Kn4VPjmtT5/mW/J/3/L6wpEirwg/v/2fN0y51XZkjkjIY8VXmXO+pj78
	pOnx/iCD9toj99rKI5fN3bhVPqAsTE/iZEftqUU+kw4o6cz+xeTT/U7K4vijyM0/hQ75/5Su
	ObtU8s/vmbUnd1Yty3py8WyCsHwrz5sq4bBltp2nt7zYx9s71Xd9mWfevBWpnw/HBfV7KarP
	6N2/KvHDUivjeb6Bi5Znr3q45ljS5GbPJXeVU3RneN699NFi/tOvidvNJ779F81w+dIzViWW
	4oxEQy3mouJEAGcRDPLlAgAA
X-CMS-MailID: 20240716060819epcas5p3387922a068b65eca1b3ab65effcf586e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240716060819epcas5p3387922a068b65eca1b3ab65effcf586e
References: <20240716060807.2707-1-cliang01.li@samsung.com>
	<CGME20240716060819epcas5p3387922a068b65eca1b3ab65effcf586e@epcas5p3.samsung.com>

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
 io_uring/rsrc.c | 139 +++++++++++++++++++++++++++++++++++++-----------
 io_uring/rsrc.h |   8 +++
 2 files changed, 115 insertions(+), 32 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 0d6cda92ba46..bba7d2913aa9 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -849,6 +849,103 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
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
+			if (folio_page_idx(folio, page_array[i-1])
+				!= data->nr_pages_mid - 1)
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
+	if (nr_folios == 1) {
+		if (folio_page_idx(folio, page_array[i-1])
+			!= data->nr_pages_mid - 1)
+			return false;
+
+		data->nr_pages_head = count;
+	}
+
+	return io_do_coalesce_buffer(pages, nr_pages, data, nr_folios);
+}
+
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				  struct io_mapped_ubuf **pimu,
 				  struct page **last_hpage)
@@ -858,7 +955,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	unsigned long off;
 	size_t size;
 	int ret, nr_pages, i;
-	struct folio *folio = NULL;
+	struct io_imu_folio_data data;
+	bool coalesced;
 
 	*pimu = (struct io_mapped_ubuf *)&dummy_ubuf;
 	if (!iov->iov_base)
@@ -873,31 +971,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
@@ -909,7 +984,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		goto done;
 	}
 
-	off = (unsigned long) iov->iov_base & ~PAGE_MASK;
 	size = iov->iov_len;
 	/* store original address for later verification */
 	imu->ubuf = (unsigned long) iov->iov_base;
@@ -917,17 +991,18 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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


