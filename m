Return-Path: <io-uring+bounces-1870-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA5648C2FD7
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 08:30:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69C021F231D2
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 06:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E7C61391;
	Sat, 11 May 2024 06:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="H9bWYAPV"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6553A41
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 06:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715409051; cv=none; b=KaR0ZgwVTE1eD5M4xbI1t/NYkx1hjWtWsRJyPvpZeBU6EgFk+niviL0hmwiGjPWeLEIJzTe084vzFKaGLd4sVdW/9QdMI4jhJsFl0Gv593lNCv4g37BjLQ9LpfJogl0w8TC1zuPEPnFt9RmBE4xeAlcACE2WFmk699OW6EKAWfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715409051; c=relaxed/simple;
	bh=nwvNmN5Gee5PTeE9GxoI+Qf5rwANgehvwTJo1UQZ7Co=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=nr60QcxRbH6b6Ij9VrT3+N7GEU1fIrdxS8gniDrTsLBXW6hUeSqhb2RV+jOP4JWCBZ2DT5jcVfcFcq26G55IMja8AlrwNNu8rwl4awkLvBVxRW5o3a7M+eTZJq0dgUQYN5p0iQXt1Wt3iykxlxf3HHWjx5tuiW4GKi/BdNX1FJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=H9bWYAPV; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240511063040epoutp01e908103276350dd6c034b73bc476ef77~OW28J2q9j1876718767epoutp01T
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 06:30:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240511063040epoutp01e908103276350dd6c034b73bc476ef77~OW28J2q9j1876718767epoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715409040;
	bh=nFNDFrMBrJOO6iC/RO0A43jv+b7q7YeIenXeJG1B8ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9bWYAPVge/vIIHJ1w93HPPJPsN1ALNanp/f07Y7IP41K4QC3LAvTSMK/jvGudD60
	 R9sgi7wp4vydmf4XA+9BHuOK5pprf7Euzp6k4j+7Xkc8HBKAp4wVqHi/lda2FlAVOt
	 Gw/7dHlipX1pw3OQZgLWodEgJz+7Zpr497acM2jo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240511063040epcas5p3bf830e9688047a3bcf9f87282e010270~OW272tzww0244302443epcas5p3n;
	Sat, 11 May 2024 06:30:40 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VbwqL43WZz4x9Pv; Sat, 11 May
	2024 06:30:38 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	89.35.09665.E801F366; Sat, 11 May 2024 15:30:38 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240511055243epcas5p291fc5f72baf211a79475ec36682e170d~OWVz8WDpu2182521825epcas5p2z;
	Sat, 11 May 2024 05:52:43 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240511055243epsmtrp12f48971b06dfa58b49a06c64b11479f8~OWVz7qlWM2071620716epsmtrp1S;
	Sat, 11 May 2024 05:52:43 +0000 (GMT)
X-AuditID: b6c32a4b-829fa700000025c1-82-663f108e55d2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	35.33.08390.BA70F366; Sat, 11 May 2024 14:52:43 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240511055242epsmtip1ac7cd7a434f15bb496e157f5688b9a66~OWVzBX5Rc2084420844epsmtip1Z;
	Sat, 11 May 2024 05:52:42 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, gost.dev@samsung.com, Chenliang Li
	<cliang01.li@samsung.com>
Subject: [PATCH v2 1/4] io_uring/rsrc: add hugepage buffer coalesce helpers
Date: Sat, 11 May 2024 13:52:26 +0800
Message-Id: <20240511055229.352481-2-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240511055229.352481-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmpm6fgH2awZy58hZzVm1jtFh9t5/N
	4vTfxywWNw/sZLJ413qOxeLo/7dsFr+67zJabP3yldXi2V5Oi7MTPrA6cHnsnHWX3ePy2VKP
	vi2rGD0+b5ILYInKtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLx
	CdB1y8wBOkdJoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5da
	YmVoYGBkClSYkJ0x81kra8FFuYqV0+YzNzBekOhi5OSQEDCR2HfrEVsXIxeHkMBuRonbT24y
	giSEBD4xSqxrL4FIfGOUOHNyKTtMx8LeU+wQib2MEsvunYdyfjFKfG77CNbOJqAj8XvFLxYQ
	W0RAW+L146ksIEXMAksYJXZ1LgcrEhbwljh/4R4TiM0ioCpx7M96MJtXwFZi1/yNTBDr5CX2
	HzzLDGJzCthJHH7ZzgZRIyhxcuYTsAXMQDXNW2czgyyQEPjJLnFnxx82iGYXiTunJ7JC2MIS
	r45vgfpBSuJlfxuQzQFkF0ssWycH0dvCKPH+3RxGiBpriX9X9rCA1DALaEqs36UPEZaVmHpq
	HRPEXj6J3t9PoO7kldgxD8ZWlbhwcBvUKmmJtRO2MkPYHhKLf+5igoTvREaJni1pExgVZiF5
	ZxaSd2YhbF7AyLyKUTK1oDg3PbXYtMA4L7UcHsvJ+bmbGMFJVMt7B+OjBx/0DjEycTAeYpTg
	YFYS4a2qsU4T4k1JrKxKLcqPLyrNSS0+xGgKDO+JzFKiyfnANJ5XEm9oYmlgYmZmZmJpbGao
	JM77unVuipBAemJJanZqakFqEUwfEwenVAPToganGhWBX6l/dZYXvVv0uT2lO2UBF++yrA36
	YT9DHVeUvquyCuB5vkf4ui2f/82XO1LYxSvMul+cvu+UVVRql8206+57Zv8Mv5N7GSLWbWoR
	MbE1Ouz07WvjLb/aoF37pP36xXtZZQ8sn5PvdlCnV1b8hv3BL/y6dx15O1aurN+8hyn3reK6
	tHQuizWS7F0Cz/fv/PzmU96+bS+ecxcrT1pwaceJQ8wn4jYp/xFz3fZKdgZP0NfHj5csvni2
	QjXAySPNplro6qu9+aUzOvQmT/kxjZU/0INz0qrDHouOh1uI3TUwcGw+yrW5epur29XwDVpr
	Ch5Z8W9U6P12USdY+rlzX1bxvHa9xNM2t2OUWIozEg21mIuKEwFJisv5KwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWy7bCSnO5qdvs0g9uTzSzmrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlTHzWStrwUW5ipXT5jM3MF6Q6GLk5JAQMJFY2HuK
	HcQWEtjNKHH+cCZEXFqi41ArO4QtLLHy33Mgmwuo5gejxP2Na8ASbAI6Er9X/GLpYuTgEBHQ
	lWi8qwBSwyywilHi6vt2VpAaYQFvifMX7jGB2CwCqhLH/qwHs3kFbCV2zd/IBLFAXmL/wbPM
	IDangJ3E4ZftbBAH2UqcmnqGGaJeUOLkzCcsIDYzUH3z1tnMExgFZiFJzUKSWsDItIpRMrWg
	ODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzjItbR2MO5Z9UHvECMTB+MhRgkOZiUR3qoa6zQh
	3pTEyqrUovz4otKc1OJDjNIcLErivN9e96YICaQnlqRmp6YWpBbBZJk4OKUamK7UPi5ate4X
	/x/Db0XsapL/awTTtXmNZE9mZ7xrPN33+ENpo66Tiol0hfOmR+c22HA47q7b6/ZRpfLR3XvJ
	v0+LH7h5IEk6l0lYqm//1Fu1jI5rz79K+1UZt/LmxTP7xf48OfFNaUlzjqN55+3PF1bmznzi
	ejB75U63rvf3OfZPPbR1Rq/hKYXSPF3/9X1GPx5NEcg5IpkcpLw5J0r/9ZbdDYfuP1pk6LBz
	wwF+bYGZz5Wex1zisXpuvmiBa6T1TauVB3kYvjS/2Kx/9dzrebe8WnwSxH97eH5hX7/g71+z
	JF6r6nwjK8F14TKWRb4Vn6dHuUc/eFB1PtPxRvz7FYuOaZzj/DbRyfTD75JZh/4qsRRnJBpq
	MRcVJwIAvDMb9OECAAA=
X-CMS-MailID: 20240511055243epcas5p291fc5f72baf211a79475ec36682e170d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240511055243epcas5p291fc5f72baf211a79475ec36682e170d
References: <20240511055229.352481-1-cliang01.li@samsung.com>
	<CGME20240511055243epcas5p291fc5f72baf211a79475ec36682e170d@epcas5p2.samsung.com>

This patch introduces helper functions to check whether a buffer can
be coalesced or not, and gather folio data for later use.

The coalescing optimizes time and space consumption caused by mapping
and storing multi-hugepage fixed buffers.

A coalescable multi-hugepage buffer should fully cover its folios
(except potentially the first and last one), and these folios should
have the same size. These requirements are for easier later process,
also we need same size'd chunks in io_import_fixed for fast iov_iter
adjust.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 io_uring/rsrc.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++
 io_uring/rsrc.h | 10 +++++++
 2 files changed, 88 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 65417c9553b1..d08224c0c5b0 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -871,6 +871,84 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	return ret;
 }
 
+static bool __io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
+					 struct io_imu_folio_data *data)
+{
+	struct folio *folio = page_folio(pages[0]);
+	unsigned int count = 1;
+	int i;
+
+	data->nr_pages_mid = folio_nr_pages(folio);
+	if (data->nr_pages_mid == 1)
+		return false;
+
+	data->folio_shift = folio_shift(folio);
+	data->folio_size = folio_size(folio);
+	data->nr_folios = 1;
+	/*
+	 * Check if pages are contiguous inside a folio, and all folios have
+	 * the same page count except for the head and tail.
+	 */
+	for (i = 1; i < nr_pages; i++) {
+		if (page_folio(pages[i]) == folio &&
+			pages[i] == pages[i-1] + 1) {
+			count++;
+			continue;
+		}
+
+		if (data->nr_folios == 1)
+			data->nr_pages_head = count;
+		else if (count != data->nr_pages_mid)
+			return false;
+
+		folio = page_folio(pages[i]);
+		if (folio_size(folio) != data->folio_size)
+			return false;
+
+		count = 1;
+		data->nr_folios++;
+	}
+	if (data->nr_folios == 1)
+		data->nr_pages_head = count;
+
+	return true;
+}
+
+static bool io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
+				       struct io_imu_folio_data *data)
+{
+	int i, j;
+
+	if (nr_pages <= 1 ||
+		!__io_sqe_buffer_try_coalesce(pages, nr_pages, data))
+		return false;
+
+	/*
+	 * The pages are bound to the folio, it doesn't
+	 * actually unpin them but drops all but one reference,
+	 * which is usually put down by io_buffer_unmap().
+	 * Note, needs a better helper.
+	 */
+	if (data->nr_pages_head > 1)
+		unpin_user_pages(&pages[1], data->nr_pages_head - 1);
+
+	j = data->nr_pages_head;
+	nr_pages -= data->nr_pages_head;
+	for (i = 1; i < data->nr_folios; i++) {
+		unsigned int nr_unpin;
+
+		nr_unpin = min_t(unsigned int, nr_pages - 1,
+					data->nr_pages_mid - 1);
+		if (nr_unpin == 0)
+			break;
+		unpin_user_pages(&pages[j+1], nr_unpin);
+		j += data->nr_pages_mid;
+		nr_pages -= data->nr_pages_mid;
+	}
+
+	return true;
+}
+
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				  struct io_mapped_ubuf **pimu,
 				  struct page **last_hpage)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index c032ca3436ca..b2a9d66b76dd 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -50,6 +50,16 @@ struct io_mapped_ubuf {
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
 
+struct io_imu_folio_data {
+	/* Head folio can be partially included in the fixed buf */
+	unsigned int	nr_pages_head;
+	/* For non-head/tail folios, has to be fully included */
+	unsigned int	nr_pages_mid;
+	unsigned int	nr_folios;
+	unsigned int	folio_shift;
+	size_t		folio_size;
+};
+
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
-- 
2.34.1


