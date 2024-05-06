Return-Path: <io-uring+bounces-1770-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AE848BCA45
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 11:09:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2CC2CB224F7
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 09:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3B7A1411CE;
	Mon,  6 May 2024 09:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cU4p2A9l"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D15984FB3
	for <io-uring@vger.kernel.org>; Mon,  6 May 2024 09:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714986550; cv=none; b=mDl2S4iz/k8srCph4nQa9QzcA3Tw/eqKcTbdUO/DBPYhd868/XSJekV+MlaTe6o0IQcEA8tPpuBgaLhfs2Rse5ik69hR6/rbl4eSll1X5Qa+bHCl2dJnAfXzuZhItHtX3QKLfplXeAfVP93n9ZBQNp6Rx+vuxQKCYHvI4bVPvRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714986550; c=relaxed/simple;
	bh=DIj3uOSTe54dSogyMn44tGSmCTlpJl//cqjBO+aBtyA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=PGfZbLxGx9TweD/LK83bGpGarRnreu1UKwakZ/SD05JD42qbv6VajxyzJmQJlbINSN3NvR8eQz8NRV/3HxOJXx9j465Vi9COSTQ7AiFHuAvLAhL9QFDBwOmT1n44EySKmj8D/tJoI5OESlYE+1Fs6hsPpwL4f7boFtigB4tA1Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cU4p2A9l; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240506090108epoutp02c7a8573838818ba1e703a8b157561f3a~M2r4Sataj1942119421epoutp02J
	for <io-uring@vger.kernel.org>; Mon,  6 May 2024 09:01:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240506090108epoutp02c7a8573838818ba1e703a8b157561f3a~M2r4Sataj1942119421epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714986068;
	bh=MkDRtuXUGYKnezppJCmDRci2myXg937PtzpJQb7sPuM=;
	h=From:To:Cc:Subject:Date:References:From;
	b=cU4p2A9lArx1AiWsXshlfCU+sD5EIh7KhCqEtSDZDF41mpAriCL3UBm1Oq8bLN1Dz
	 XyFqiPi/Q16f3opMG+JY/f6RB9W8/UG/Oda43B6bve9z5XZoZd4l6CYDcYLScvNK1n
	 51GEEG8fUHGaNL+yk2Xw2zO8UESx9LsI+2uccC1U=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240506090107epcas5p236245498c4bbe36fa69ac3d862eed75f~M2r36MkD31172211722epcas5p2Z;
	Mon,  6 May 2024 09:01:07 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4VXwPG3JnWz4x9Pv; Mon,  6 May
	2024 09:01:06 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	73.4C.08600.15C98366; Mon,  6 May 2024 18:01:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240506075314epcas5p25333b80c8d6a3217d5352a5a7ed89278~M1wmydLbp0400404004epcas5p2d;
	Mon,  6 May 2024 07:53:14 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240506075314epsmtrp15e121021c338f74f4005caf73bb3e6b1~M1wmxru-v1874718747epsmtrp1s;
	Mon,  6 May 2024 07:53:14 +0000 (GMT)
X-AuditID: b6c32a44-921fa70000002198-7d-66389c51c60f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7A.80.09238.A6C88366; Mon,  6 May 2024 16:53:14 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240506075313epsmtip1be1b6f0884a91e44c09b7d3989f39c6b~M1wllq7kt3072130721epsmtip1Y;
	Mon,  6 May 2024 07:53:13 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	peiwei.li@samsung.com, joshi.k@samsung.com, kundan.kumar@samsung.com,
	gost.dev@samsung.com, Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH] io_uring/rsrc: Add support for multi-folio buffer
 coalescing
Date: Mon,  6 May 2024 15:53:02 +0800
Message-Id: <20240506075303.25630-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmlm7gHIs0gyf/xC3mrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vF5V1z2Cye7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAlqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWl
	eel6eaklVoYGBkamQIUJ2RlPf3UxFzx2qPh4dS1rA+MOoy5GDg4JAROJDw/5uxi5OIQEdjNK
	TD3yiRXC+cQo8WbVWijnG6PE861dbF2MnGAdC2btZoZI7GWUWH91HzuE84tRYua9drAqNgEd
	id8rfrGA2CIC2hKvH09lASliFjjEKHG/fSIjyHJhAX+JZ/vB6lkEVCXWz9vDCmLzCthItG7Z
	zgSxTV5i/8GzzBBxQYmTM5+AzWQGijdvnQ12hYTAS3aJaQdWQzW4SLTe6GCEsIUlXh3fwg5h
	S0m87G9jh3i6WGLZOjmI3hZGiffv5kDVW0v8u7KHBaSGWUBTYv0ufYiwrMTUU+uYIPbySfT+
	fgK1ildixzwYW1XiwsFtUKukJdZO2MoMYXtI/N12GewvIYFYif4/N1kmMMrPQvLOLCTvzELY
	vICReRWjZGpBcW56arJpgWFeajk8YpPzczcxgpOmlssOxhvz/+kdYmTiYAQGLQezkgjv0Xbz
	NCHelMTKqtSi/Pii0pzU4kOMpsAwnsgsJZqcD0zbeSXxhiaWBiZmZmYmlsZmhkrivK9b56YI
	CaQnlqRmp6YWpBbB9DFxcEo1MKmEpbEWb5bzX1eeyH0/d8k0iWdtNz1e+wrrpFzldVu27Piv
	a5qLXgYJCq3vOZVbcPHPwiXTUq3myVlMfaDQq/olniFlg5n5VV3HMM8yTrXFSju2SnlNFK1Z
	s6n5tHRlINsfVfP1s0OCcyZ3Sl18/kLdZoNvr9jfaqErv8NjnvzUruK6trvli7zwMm3d5ANM
	ef9z5pzJCQrK2R9ScWyv7M+/DUUS5/u0+n8KaajOvuam5jR3w1ebs5pJ5t7Pb/g2N9/anaXA
	z+Mb2zJnyZRZxdEth45vjY8sM9u3JChGJkxN7VNZrtK+dfzZav+fOT/fAszANd+e7360ZZmM
	7hyXF0/k595bU/1mu1Z4SvsKJZbijERDLeai4kQACxBxiSMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsWy7bCSnG5Wj0WawZmjKhZzVm1jtFh9t5/N
	4vTfxywWNw/sZLJ413qOxeLo/7dsFr+67zJabP3yldXi8q45bBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxtNfXcwFjx0qPl5dy9rAuMOoi5GTQ0LA
	RGLBrN3MXYxcHEICuxklXi9/zQyRkJboONTKDmELS6z895wdougHo8S6rzvAitgEdCR+r/jF
	0sXIwSEioCvReFcBpIZZ4BSjxNs1O8CahQV8JRqX/WYEsVkEVCXWz9vDCmLzCthItG7ZzgSx
	QF5i/8GzzBBxQYmTM5+wgNjMQPHmrbOZJzDyzUKSmoUktYCRaRWjZGpBcW56brJhgWFearle
	cWJucWleul5yfu4mRnAAa2nsYLw3/5/eIUYmDsZDjBIczEoivEfbzdOEeFMSK6tSi/Lji0pz
	UosPMUpzsCiJ8xrOmJ0iJJCeWJKanZpakFoEk2Xi4JRqYOL99iQx20Lk2PlMrVCdtxO4OTf4
	9H+RNJyi+dpwN9/UXxx/T6acWT853HuVzoWpwnEubQeMJpZnfU37cU7D+4LYtC5F44ZqkYCr
	WysXRuqGfHcpWGR6TcbknembQkvnNbc8v71e5uURxrc58vOeloPyHy+o+OcZKe8zisrdEsnn
	IfHzSGP88z1cKi9fGQjFzYzuW/X+1rnOwNfP2qwMk19wqG+x/nT0UJaSwtn0oOW3G0qWCDwp
	4Qg3nHZ99dwdF7ftuv/h1yfe/4UWH388+v7lnGxlxYfCbad2aUW+7G7Ji+1ynVDZqiygVfze
	IzLmR3LlzmUJ2zc1fOC68C+guWWyVPeLJaHbLG7tNDbcy6zEUpyRaKjFXFScCACxhWhHzwIA
	AA==
X-CMS-MailID: 20240506075314epcas5p25333b80c8d6a3217d5352a5a7ed89278
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240506075314epcas5p25333b80c8d6a3217d5352a5a7ed89278
References: <CGME20240506075314epcas5p25333b80c8d6a3217d5352a5a7ed89278@epcas5p2.samsung.com>

Currently fixed buffers consisting of pages in one same folio(huge page)
can be coalesced into a single bvec entry at registration.
This patch expands it to support coalescing fixed buffers
with multiple folios, by:
1. Add a helper function and a helper struct to do the coalescing work
at buffer registration;
2. Add the bvec setup procedure of the coalsced path;
3. store page_mask and page_shift into io_mapped_ubuf for
later use in io_import_fixed.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 io_uring/rsrc.c | 156 +++++++++++++++++++++++++++++++++++-------------
 io_uring/rsrc.h |   9 +++
 2 files changed, 124 insertions(+), 41 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 65417c9553b1..f9e11131c9a5 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -871,6 +871,80 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	return ret;
 }
 
+/*
+ * For coalesce to work, a buffer must be one or multiple
+ * folios, all the folios except the first and last one
+ * should be of the same size.
+ */
+static bool io_sqe_buffer_try_coalesce(struct page **pages,
+				       unsigned int nr_pages,
+				       struct io_imu_folio_stats *stats)
+{
+	struct folio	*folio = NULL, *first_folio = NULL;
+	unsigned int	page_cnt;
+	int		i, j;
+
+	if (nr_pages <= 1)
+		return false;
+
+	first_folio = page_folio(pages[0]);
+	stats->full_folio_pcnt = folio_nr_pages(first_folio);
+	if (stats->full_folio_pcnt == 1)
+		return false;
+
+	stats->folio_shift = folio_shift(first_folio);
+
+	folio = first_folio;
+	page_cnt = 1;
+	stats->nr_folios = 1;
+	/*
+	 * Check:
+	 * 1. Pages must be contiguous;
+	 * 2. All folios should have the same page count
+	 *    except the first and last one
+	 */
+	for (i = 1; i < nr_pages; i++) {
+		if (page_folio(pages[i]) != folio ||
+		   pages[i] != pages[i-1] + 1) {
+			if (folio == first_folio)
+				stats->first_folio_pcnt = page_cnt;
+			else if (page_cnt != stats->full_folio_pcnt)
+				return false;
+			folio = page_folio(pages[i]);
+			page_cnt = 1;
+			stats->nr_folios++;
+			continue;
+		}
+		page_cnt++;
+	}
+	if (folio == first_folio)
+		stats->first_folio_pcnt = page_cnt;
+
+	if (stats->first_folio_pcnt > 1)
+		/*
+		 * The pages are bound to the folio, it doesn't
+		 * actually unpin them but drops all but one reference,
+		 * which is usually put down by io_buffer_unmap().
+		 * Note, needs a better helper.
+		 */
+		unpin_user_pages(&pages[1], stats->first_folio_pcnt - 1);
+	j = stats->first_folio_pcnt;
+	nr_pages -= stats->first_folio_pcnt;
+	for (i = 1; i < stats->nr_folios; i++) {
+		unsigned int nr_unpin;
+
+		nr_unpin = min_t(unsigned int, nr_pages - 1,
+				stats->full_folio_pcnt - 1);
+		if (nr_unpin <= 1)
+			continue;
+		unpin_user_pages(&pages[j+1], nr_unpin);
+		j += stats->full_folio_pcnt;
+		nr_pages -= stats->full_folio_pcnt;
+	}
+
+	return true;
+}
+
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				  struct io_mapped_ubuf **pimu,
 				  struct page **last_hpage)
@@ -879,8 +953,9 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	struct page **pages = NULL;
 	unsigned long off;
 	size_t size;
-	int ret, nr_pages, i;
-	struct folio *folio = NULL;
+	int ret, nr_pages, nr_bvecs, i, j;
+	bool coalesced;
+	struct io_imu_folio_stats stats;
 
 	*pimu = (struct io_mapped_ubuf *)&dummy_ubuf;
 	if (!iov->iov_base)
@@ -895,39 +970,26 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
-
-	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
+	/* If it's multiple huge pages, try to coalesce them into fewer bvec entries */
+	coalesced = io_sqe_buffer_try_coalesce(pages, nr_pages, &stats);
+	nr_bvecs = nr_pages;
+	if (coalesced)
+		nr_bvecs = stats.nr_folios;
+	imu = kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
 	if (!imu)
 		goto done;
 
 	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
 	if (ret) {
-		unpin_user_pages(pages, nr_pages);
+		if (coalesced) {
+			unpin_user_page(pages[0]);
+			j = stats.first_folio_pcnt;
+			for (i = 1; i < stats.nr_folios; i++) {
+				unpin_user_page(pages[j]);
+				j += stats.full_folio_pcnt;
+			}
+		} else
+			unpin_user_pages(pages, nr_pages);
 		goto done;
 	}
 
@@ -936,12 +998,29 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	/* store original address for later verification */
 	imu->ubuf = (unsigned long) iov->iov_base;
 	imu->ubuf_end = imu->ubuf + iov->iov_len;
-	imu->nr_bvecs = nr_pages;
+	imu->nr_bvecs = nr_bvecs;
+	imu->page_shift = PAGE_SHIFT;
+	imu->page_mask = PAGE_MASK;
+	if (coalesced) {
+		imu->page_shift = stats.folio_shift;
+		imu->page_mask = ~((1UL << stats.folio_shift) - 1);
+	}
 	*pimu = imu;
 	ret = 0;
 
-	if (folio) {
-		bvec_set_page(&imu->bvec[0], pages[0], size, off);
+	if (coalesced) {
+		size_t vec_len;
+
+		vec_len = min_t(size_t, size, PAGE_SIZE * stats.first_folio_pcnt - off);
+		bvec_set_page(&imu->bvec[0], pages[0], vec_len, off);
+		size -= vec_len;
+		j = stats.first_folio_pcnt;
+		for (i = 1; i < nr_bvecs; i++) {
+			vec_len = min_t(size_t, size, PAGE_SIZE * stats.full_folio_pcnt);
+			bvec_set_page(&imu->bvec[i], pages[j], vec_len, 0);
+			size -= vec_len;
+			j += stats.full_folio_pcnt;
+		}
 		goto done;
 	}
 	for (i = 0; i < nr_pages; i++) {
@@ -1049,7 +1128,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 		 * we know that:
 		 *
 		 * 1) it's a BVEC iter, we set it up
-		 * 2) all bvecs are PAGE_SIZE in size, except potentially the
+		 * 2) all bvecs are the same in size, except potentially the
 		 *    first and last bvec
 		 *
 		 * So just find our index, and adjust the iterator afterwards.
@@ -1061,11 +1140,6 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 		const struct bio_vec *bvec = imu->bvec;
 
 		if (offset < bvec->bv_len) {
-			/*
-			 * Note, huge pages buffers consists of one large
-			 * bvec entry and should always go this way. The other
-			 * branch doesn't expect non PAGE_SIZE'd chunks.
-			 */
 			iter->bvec = bvec;
 			iter->nr_segs = bvec->bv_len;
 			iter->count -= offset;
@@ -1075,12 +1149,12 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 
 			/* skip first vec */
 			offset -= bvec->bv_len;
-			seg_skip = 1 + (offset >> PAGE_SHIFT);
+			seg_skip = 1 + (offset >> imu->page_shift);
 
 			iter->bvec = bvec + seg_skip;
 			iter->nr_segs -= seg_skip;
 			iter->count -= bvec->bv_len + offset;
-			iter->iov_offset = offset & ~PAGE_MASK;
+			iter->iov_offset = offset & ~(imu->page_mask);
 		}
 	}
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index c032ca3436ca..4c655e446150 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -47,9 +47,18 @@ struct io_mapped_ubuf {
 	u64		ubuf_end;
 	unsigned int	nr_bvecs;
 	unsigned long	acct_pages;
+	unsigned int	page_shift;
+	unsigned long	page_mask;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
 
+struct io_imu_folio_stats {
+	unsigned int	first_folio_pcnt;
+	unsigned int	full_folio_pcnt;
+	unsigned int	nr_folios;
+	unsigned int	folio_shift;
+};
+
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
-- 
2.34.1


