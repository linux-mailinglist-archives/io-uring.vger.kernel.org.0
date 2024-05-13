Return-Path: <io-uring+bounces-1884-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 173588C3D29
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 10:29:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34A631C21400
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 08:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01DDC1474AA;
	Mon, 13 May 2024 08:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="b+kzygwh"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C078146A91
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 08:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715588983; cv=none; b=f/+vYgb+0QJvrT1IBNp8f+3iSIjqWjdYNbUYMBdxYMb6LIvWI/CbG/hLT7am1D2GTJ06h6amhOhKJq/2IhLnp3k2XSmCXinPcSReAHukGrPgQo2ySqbaKbCDrKVbUkhmZUDeqX96JKZrq97yswMfZaoK40Ey79gxNfeD2lhX0Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715588983; c=relaxed/simple;
	bh=GgB79gShNLQoKk+gewD6WVXUhfoRMFUqTI993fcouUM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=pLLp/Mh3DsvkPS/f/pbsksUXLZJsMCpNci5xknHwIQEIRdufnwL1cGFrXCGt4CssvzjnnEnfvWfzFooqRz9cRZQNjZwf7nqyX4e4YhF5a2go/1O/vDib95hMEb/WmK+IS00tSwBa34IWzGCH6ijVObN7feFA4OD5pV0ycYLSOLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=b+kzygwh; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240513082937epoutp02577a157fe7b0fe8ae3e22730b9c71122~O-xXwjyZ31177211772epoutp020
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 08:29:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240513082937epoutp02577a157fe7b0fe8ae3e22730b9c71122~O-xXwjyZ31177211772epoutp020
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715588977;
	bh=luky4jv5sJLLkurx2YzjEwBLcK+91Q/SXM6pUFX2CzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+kzygwhYtWbv9s6gSfRLjEWjInOYWc0w0LIVZEvtHO8He8cOxAfQLpbvMK1w1mAI
	 Vjop1dCpu3eoL1btBwdnkhr18u4or8Iu4n7xGzWms9LqDpodBoF9JvPqCktIGf/eic
	 kV4kd63iUcTpyBv6K+aXNR1uIsk7qLXCCsniSgYw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240513082937epcas5p1dae1544e187c9b4240615cb47de2f062~O-xXHAykX0073900739epcas5p1o;
	Mon, 13 May 2024 08:29:37 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VdCMg2cPTz4x9Q3; Mon, 13 May
	2024 08:29:35 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	70.0D.19431.F6FC1466; Mon, 13 May 2024 17:29:35 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240513082308epcas5p3c38ce4d44fa1613988bbae84eaec41b9~O-rtG6zkc2476724767epcas5p3j;
	Mon, 13 May 2024 08:23:08 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240513082308epsmtrp2401a2d08f6cb8aecad9ecda9907a7843~O-rtGCodg1459414594epsmtrp2p;
	Mon, 13 May 2024 08:23:08 +0000 (GMT)
X-AuditID: b6c32a50-ccbff70000004be7-c4-6641cf6fa0ab
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BA.23.09238.CEDC1466; Mon, 13 May 2024 17:23:08 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240513082307epsmtip241d24af930fcbb5745ddf0c1252668c2~O-rsLhlen1150211502epsmtip2Y;
	Mon, 13 May 2024 08:23:07 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, gost.dev@samsung.com, Chenliang Li
	<cliang01.li@samsung.com>
Subject: [PATCH v3 1/5] io_uring/rsrc: add hugepage buffer coalesce helpers
Date: Mon, 13 May 2024 16:22:56 +0800
Message-Id: <20240513082300.515905-2-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240513082300.515905-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmpm7+ecc0g3m9ghZzVm1jtFh9t5/N
	4vTfxywWNw/sZLJ413qOxeLo/7dsFr+67zJabP3yldXi2V5Oi7MTPrA6cHnsnHWX3ePy2VKP
	vi2rGD0+b5ILYInKtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLx
	CdB1y8wBOkdJoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5da
	YmVoYGBkClSYkJ0xb/oO1oKjchVXV15jbWA8JtHFyMkhIWAi0XfnH1sXIxeHkMAeRonfSw4z
	QzifGCVerJ7FDuF8Y5S4MquHEaZlzaa3LBCJvYwSy6+8ZAJJCAn8YpRYsMcHxGYT0JH4veIX
	C4gtIqAt8frxVLAGZoEljBK7OpeDTRIW8JbY2v+MHcRmEVCVeHJgIdggXgFbiX2XD7FDbJOX
	2H/wLDOIzSlgJ7Fzzx9miBpBiZMzn4AtYAaqad46mxmi/iu7xIEpthC2i8SR3/NZIGxhiVfH
	t0DNlJL4/G4v0NMcQHaxxLJ1ciC3SQi0MEq8fzcH6ktriX9X9rCA1DALaEqs36UPEZaVmHpq
	HRPEWj6J3t9PmCDivBI75sHYqhIXDm6DWiUtsXbCVqjTPCT23LkMDeuJjBJ9Lb+YJjAqzELy
	ziwk78xCWL2AkXkVo1RqQXFuemqyaYGhbl5qOTyak/NzNzGC06hWwA7G1Rv+6h1iZOJgPMQo
	wcGsJMLrUGifJsSbklhZlVqUH19UmpNafIjRFBjgE5mlRJPzgYk8ryTe0MTSwMTMzMzE0tjM
	UEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGpqLWvXdXm9Sczrh5eMWpeaXqp81vHI1duvF1
	e++B5pJJ917sO+eZIfnK/hDn1qlul7VfxM8VK13+c7G2wNXnbpf2z9ygE710kZl+9UKpXVbP
	ClNtt8cVZ3PPkDgacfmEEbvknlXMDxbt+T7rVDXPMueii+s86yZaX+pufeRct/fqnfKzwmeW
	d5yqjW4z85vJNeFJykSJtK9Tvl1pOrvkecdSzZaDIoU81xK/GXZ/SxQwnsxs/+VZioOClvL0
	sG15e9+c3JnwweNlrkCl+BU36QsVPW6bj53OnqhiNe8as+S0Zu/rdcyHdxy4rHrX9XeMv/rr
	A7kb5x83k/rsOefoKgsJ19V8PnybLn9amP5IwodHiaU4I9FQi7moOBEAa3BWsSwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSvO6bs45pBmcahSzmrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlTFv+g7WgqNyFVdXXmNtYDwm0cXIySEhYCKxZtNb
	li5GLg4hgd2MEt+f97FAJKQlOg61skPYwhIr/z1nhyj6wSixZddrsCI2AR2J3yt+AdkcHCIC
	uhKNdxVAapgFVjFKXH3fzgpSIyzgLbG1/xnYIBYBVYknBxYygdi8ArYS+y4fglogL7H/4Flm
	EJtTwE5i554/YLYQUM2pw5vZIOoFJU7OfAK2lxmovnnrbOYJjAKzkKRmIUktYGRaxSiZWlCc
	m56bbFhgmJdarlecmFtcmpeul5yfu4kRHOZaGjsY783/p3eIkYmD8RCjBAezkgivQ6F9mhBv
	SmJlVWpRfnxRaU5q8SFGaQ4WJXFewxmzU4QE0hNLUrNTUwtSi2CyTBycUg1MutK9fGYpWvkJ
	bzf6tM+TTXn60KT1yAOudTMjvitrXa+y6DxsIfFXybL5Tma6bZ137SrH2Td6lf6lf7RqjvtW
	W6bf2XJWVnLnmYczlii4tB/9k38y44VB8M8Ajjz5p8VhSw9xzKk22FilWTXrsM9UqZ8sqy+y
	TuPmfHNH6voH5l3Tm7hNbkkvr4rvnv1t+YHrO+Vcu545BPBGLt3IUnVEd5VxSMFbwZP/lpVo
	HjybPDUtTKL68INGL70pr+IUpqj+4Evc8Yz11JzqybMnv9jb3fLg162Y/scv0zlibJZ+Wrtm
	yqYjFcyPNM9b5p4L620UaG5pXmGtnzotWtOcLerO4338M/MvT5V4GiJyNWqVEktxRqKhFnNR
	cSIAorbt3eICAAA=
X-CMS-MailID: 20240513082308epcas5p3c38ce4d44fa1613988bbae84eaec41b9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240513082308epcas5p3c38ce4d44fa1613988bbae84eaec41b9
References: <20240513082300.515905-1-cliang01.li@samsung.com>
	<CGME20240513082308epcas5p3c38ce4d44fa1613988bbae84eaec41b9@epcas5p3.samsung.com>

Introduce helper functions to check whether a buffer can
be coalesced or not, and gather folio data for later use.

The coalescing optimizes time and space consumption caused
by mapping and storing multi-hugepage fixed buffers.

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


