Return-Path: <io-uring+bounces-1886-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F88E8C3D30
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 10:30:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B771E1F22194
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 08:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1FA71474AF;
	Mon, 13 May 2024 08:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YlhD9tyI"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C371474A2
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 08:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715588993; cv=none; b=rpENufXIrc9/B0FEG8JpR3QIsMCf2352YpKRCHtjICfaJBqNNQ7H9tcv0y2efUy4Gq6zu9ZLzRpLcI+0ib/6548icfXhR2TzRYaVv6RiuwoAP53DRXg3XGtgGm+A5q0TvoNcjHI1WhVYmpuf6KM3Zxh9R79My/83oV6DEe3iypA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715588993; c=relaxed/simple;
	bh=L04S/T0HduAOk5jic8D4zPDYPUsOlWlq6z5J2Sfh0tI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=afbtVaY9d1YKMXlPMK+7seBN0sc0cUuu2LRsssoDaeTMMqqMKNHaL6kfvqAbRKBd9HyxyesxonT9igU2kz621RNlTPdl5sLSObq0GzqwE8qKILimNW+W/A+nmvEJxTUkewudc/CXirAbvt3yzY8njFlSV3S1FVdGFKlktTrLv0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YlhD9tyI; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240513082942epoutp013a8d7e74c6fb8085be81e0050922360f~O-xcQxuEe1953319533epoutp01U
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 08:29:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240513082942epoutp013a8d7e74c6fb8085be81e0050922360f~O-xcQxuEe1953319533epoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715588982;
	bh=oXAeKS3l9SfB9JAX17XgdEuqjbyD8WlhE++s0l1R6lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlhD9tyIFIYfRbpDGyBQk1iPGlInbU3AnmVVly5KsS4tRZB/M449uVSByWACAries
	 +uUUBhEsK8zMCB1bTrMR5/Ty+93sIMrudmIAM/0Yiuk40ow1O8VQjiWnGEd9bNsS09
	 RufEvra6SgbavzMn4659u2afj9Gy8OKSLkSYfNzg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240513082942epcas5p29c83675a161e291e8b4a5aa0f40cf4ee~O-xb3ojjq2028620286epcas5p2D;
	Mon, 13 May 2024 08:29:42 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4VdCMm3Bpxz4x9Py; Mon, 13 May
	2024 08:29:40 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	23.E5.09688.47FC1466; Mon, 13 May 2024 17:29:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240513082311epcas5p3556d301a1f1faca0c6b613555324861e~O-rwIj0Ga2725827258epcas5p3O;
	Mon, 13 May 2024 08:23:11 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240513082311epsmtrp15dd4da51428071c821337d214cdc0a09~O-rwHvkYh1297912979epsmtrp1I;
	Mon, 13 May 2024 08:23:11 +0000 (GMT)
X-AuditID: b6c32a4a-5dbff700000025d8-bb-6641cf745a24
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7E.6C.08390.FEDC1466; Mon, 13 May 2024 17:23:11 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240513082310epsmtip23953c50dfd194e42ffa8b22fd018ed8a~O-rvCjmCr0931209312epsmtip2V;
	Mon, 13 May 2024 08:23:10 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, gost.dev@samsung.com, Chenliang Li
	<cliang01.li@samsung.com>
Subject: [PATCH v3 3/5] io_uring/rsrc: add init and account functions for
 coalesced imus
Date: Mon, 13 May 2024 16:22:58 +0800
Message-Id: <20240513082300.515905-4-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240513082300.515905-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmum7Jecc0g8vfhS3mrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBKVbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDdI6SQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1
	xMrQwMDIFKgwITvj9MMFbAXPpSrWftnI3sA4R7SLkZNDQsBE4tSJhYwgtpDAbkaJZ4vjIexP
	jBKHpvN1MXIB2d8YJV7/XMwC0zDn8VUmiMReoIYD65khnF+MEnOuLwGrYhPQkfi94heYLSKg
	LfH68VQWkCJmgSWMErs6l4PtExaIkvg0cyVYEYuAqsS2pbvAbF4BW4l/66ZBrZOX2H/wLDOI
	zSlgJ7Fzzx9miBpBiZMzn4DVMAPVNG+dDXaFhMBXdol1i56zdzFyADkuEtOvMULMEZZ4dXwL
	O4QtJfGyvw2qpFhi2To5iNYWRon37+ZA1VtL/LuyhwWkhllAU2L9Ln2IsKzE1FPrmCDW8kn0
	/n7CBBHnldgxD8ZWlbhwcBvUKmmJtRO2MkPYHhITl/5ihQTWREaJUz1/GScwKsxC8s4sJO/M
	Qli9gJF5FaNkakFxbnpqsWmBUV5qOTySk/NzNzGCU6iW1w7Ghw8+6B1iZOJgPMQowcGsJMLr
	UGifJsSbklhZlVqUH19UmpNafIjRFBjeE5mlRJPzgUk8ryTe0MTSwMTMzMzE0tjMUEmc93Xr
	3BQhgfTEktTs1NSC1CKYPiYOTqkGpqVzVvkuj0lWfvfyxbmDvi/vujscPxDI7+i8b3bQTPsd
	jIneQUuWx5W66cvdlF1dbeq+e/HeCcnb+WfFP167co7ZhXfGP5YkCTf5Gx/P6FKedPmHl/iW
	+/5Je/mkOCtilSOYar8ahsfbS/2bZXvW/q5Y4EqhtK54waKwaQrHojrPKPJLnT5ruyhlN/dM
	iQWliz737w2xdPhpVvN84/JdEdNm5Uw9ybpISkTV1Cn81PK5evYnjQpEv3v/iAvbqxeyaJm9
	A/f07CM8f102aNpzvtHtfONc0x/0td79262STROX/KmdufECx8NXHwR3LitRLnLZdPXwT6/T
	Qmfl1nxcKypwLk4kdJpP//JjCjda3yixFGckGmoxFxUnAgAxCMHbKgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSvO77s45pBsceKljMWbWN0WL13X42
	i9N/H7NY3Dywk8niXes5Fouj/9+yWfzqvstosfXLV1aLZ3s5Lc5O+MDqwOWxc9Zddo/LZ0s9
	+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+P0wwVsBc+lKtZ+2cjewDhHtIuRk0NCwERizuOr
	TF2MXBxCArsZJZ49nMwMkZCW6DjUyg5hC0us/PecHaLoB6PEju0HWEASbAI6Er9X/AKyOThE
	BHQlGu8qgNQwC6xilLj6vp0VpEZYIEJi1tpFTCA2i4CqxLalu8B6eQVsJf6tm8YCsUBeYv/B
	s2CLOQXsJHbu+QNmCwHVnDq8mQ2iXlDi5MwnYPXMQPXNW2czT2AUmIUkNQtJagEj0ypGydSC
	4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOAw19Lawbhn1Qe9Q4xMHIyHGCU4mJVEeB0K7dOE
	eFMSK6tSi/Lji0pzUosPMUpzsCiJ83573ZsiJJCeWJKanZpakFoEk2Xi4JRqYIoTaAm883tH
	u2VDbPl6fxcvl4u6DIdONLCav4qsctc6eGvfbdOHB5fprrvostvo/PWA80JKydXPX2SZaN6q
	siis6N3tJZvySoehO1WiPc6tIetjYOKfH/l39u6Qe6H9f6JaT8K5vpR7OdpdUde9jGS2s8q8
	7TLnMdGd2v0/JuOensDpX7v/XI6yX7bk7ZQNc9/zBboUlaTOe9bTmf7VqFTySu7ktaKFlXnM
	UyUXurEKzjox/0WAQtS+rA/JudEb2dlP/7mSac2xk9ljT2fF8+CwRy6nGW9MP7PkVInWA565
	Jvfa3bZNlH9ZV6DaEuf9KmFjReAbXZft37bZSE676rTa/1nO58Xmy17f9lvKocRSnJFoqMVc
	VJwIAPTAEMjiAgAA
X-CMS-MailID: 20240513082311epcas5p3556d301a1f1faca0c6b613555324861e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240513082311epcas5p3556d301a1f1faca0c6b613555324861e
References: <20240513082300.515905-1-cliang01.li@samsung.com>
	<CGME20240513082311epcas5p3556d301a1f1faca0c6b613555324861e@epcas5p3.samsung.com>

Introduce two functions to separate the coalesced imu alloc and
accounting path from the original one. This helps to keep the original
code path clean.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 io_uring/rsrc.c | 89 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 578d382ca9bc..53fac5f27bbf 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -871,6 +871,45 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	return ret;
 }
 
+static int io_coalesced_buffer_account_pin(struct io_ring_ctx *ctx,
+					   struct page **pages,
+					   struct io_mapped_ubuf *imu,
+					   struct page **last_hpage,
+					   struct io_imu_folio_data *data)
+{
+	int i, j, ret;
+
+	imu->acct_pages = 0;
+	j = 0;
+	for (i = 0; i < data->nr_folios; i++) {
+		struct page *hpage = pages[j];
+
+		if (hpage == *last_hpage)
+			continue;
+		*last_hpage = hpage;
+		/*
+		 * Already checked the page array in try coalesce,
+		 * so pass in nr_pages=0 here to waive that.
+		 */
+		if (headpage_already_acct(ctx, pages, 0, hpage))
+			continue;
+		imu->acct_pages += data->nr_pages_mid;
+		if (i)
+			j += data->nr_pages_mid;
+		else
+			j = data->nr_pages_head;
+	}
+
+	if (!imu->acct_pages)
+		return 0;
+
+	ret = io_account_mem(ctx, imu->acct_pages);
+	if (!ret)
+		return 0;
+	imu->acct_pages = 0;
+	return ret;
+}
+
 static bool __io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
 					 struct io_imu_folio_data *data)
 {
@@ -949,6 +988,56 @@ static bool io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
 	return true;
 }
 
+static int io_coalesced_imu_alloc(struct io_ring_ctx *ctx, struct iovec *iov,
+				  struct io_mapped_ubuf **pimu,
+				  struct page **last_hpage, struct page **pages,
+				  struct io_imu_folio_data *data)
+{
+	struct io_mapped_ubuf *imu = NULL;
+	unsigned long off;
+	size_t size, vec_len;
+	int ret, i, j;
+
+	ret = -ENOMEM;
+	imu = kvmalloc(struct_size(imu, bvec, data->nr_folios), GFP_KERNEL);
+	if (!imu)
+		return ret;
+
+	ret = io_coalesced_buffer_account_pin(ctx, pages, imu, last_hpage,
+						data);
+	if (ret) {
+		unpin_user_page(pages[0]);
+		j = data->nr_pages_head;
+		for (i = 1; i < data->nr_folios; i++) {
+			unpin_user_page(pages[j]);
+			j += data->nr_pages_mid;
+		}
+		return ret;
+	}
+	off = (unsigned long) iov->iov_base & ~PAGE_MASK;
+	size = iov->iov_len;
+	/* store original address for later verification */
+	imu->ubuf = (unsigned long) iov->iov_base;
+	imu->ubuf_end = imu->ubuf + iov->iov_len;
+	imu->nr_bvecs = data->nr_folios;
+	imu->folio_shift = data->folio_shift;
+	imu->folio_mask = ~((1UL << data->folio_shift) - 1);
+	*pimu = imu;
+	ret = 0;
+
+	vec_len = min_t(size_t, size, PAGE_SIZE * data->nr_pages_head - off);
+	bvec_set_page(&imu->bvec[0], pages[0], vec_len, off);
+	size -= vec_len;
+	j = data->nr_pages_head;
+	for (i = 1; i < data->nr_folios; i++) {
+		vec_len = min_t(size_t, size, data->folio_size);
+		bvec_set_page(&imu->bvec[i], pages[j], vec_len, 0);
+		size -= vec_len;
+		j += data->nr_pages_mid;
+	}
+	return ret;
+}
+
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				  struct io_mapped_ubuf **pimu,
 				  struct page **last_hpage)
-- 
2.34.1


