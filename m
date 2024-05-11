Return-Path: <io-uring+bounces-1872-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E94C8C2FD9
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 08:31:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54936283F37
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 06:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86062ECF;
	Sat, 11 May 2024 06:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="O9GbEOA/"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7D8380
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 06:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715409060; cv=none; b=tJDhoIYBPJiIVcwaYqR3IsZJRVm09bl+0S7KECXfa+UcqD8sCN88xZG9bN/lvWQt2Hcloahq0aViBd6owRVO48aITnpWbGqLHcagC7fhsOxe4LVZellJnLvdwkJbOp/TLf+86ydVRkb8RBycxXLOqXqLkSDLvGaP8rm/FycLPe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715409060; c=relaxed/simple;
	bh=RKNM6mcKJHQrN1gXAWf9OWz2eNKa20RONK4dATr/IHA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=mIbKQ8kV++jxIiGAfTPhf0v6GF68kdG+E5fPL2LnnqA+B9Ze1Et90myi1VjcmONH5PKsuKl1YksxSwkkNwcrurp1+4dYFQ6p9HyCWOagjAuWGVWUsb7IWmWE8Rs6vlAgDMQokKKqjcueRwMwE9GUc4RnAWW3w6ZR5SHt8hU8KkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=O9GbEOA/; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240511063050epoutp04ca91251544d7c9735d9ef2680ed6ba7c~OW3FJK3JT1078310783epoutp04z
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 06:30:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240511063050epoutp04ca91251544d7c9735d9ef2680ed6ba7c~OW3FJK3JT1078310783epoutp04z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715409050;
	bh=1gUqNGiqVvQbEYPG08LCY1EgsRDR8KnwG+EpwqPYvBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O9GbEOA/bpO8uNT7vyqxscsQPN7gOzV53RYcbLUYzM2bI/TpUa4XdZq5fDZbMCcN5
	 yj5DMF6+cvAlrJFIlT0SrDxhp6ucspftV0XBKCjX0daKje3kQDvCRjQoXyawkljIrL
	 WfXmkN5mX3BKqdvr+Ri9/7aFztrLFVuGcuQHpd6k=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240511063049epcas5p2598bb35194851823a5c227a1225c6541~OW3ExPuIE3223532235epcas5p2P;
	Sat, 11 May 2024 06:30:49 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4VbwqX0PSxz4x9Pw; Sat, 11 May
	2024 06:30:48 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	FF.F5.09666.7901F366; Sat, 11 May 2024 15:30:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240511055248epcas5p287b7dfdab3162033744badc71fd084e1~OWV4dsZC73263732637epcas5p2z;
	Sat, 11 May 2024 05:52:48 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240511055248epsmtrp1c6501a09b228020dc84989394e2f0a69~OWV4c-VeE2071620716epsmtrp1U;
	Sat, 11 May 2024 05:52:48 +0000 (GMT)
X-AuditID: b6c32a49-cefff700000025c2-0a-663f10976a5f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	8A.C2.19234.0B70F366; Sat, 11 May 2024 14:52:48 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240511055247epsmtip125b36d14c4052d72974b983be33ad514~OWV3iXHCO0364503645epsmtip1d;
	Sat, 11 May 2024 05:52:47 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, gost.dev@samsung.com, Chenliang Li
	<cliang01.li@samsung.com>
Subject: [PATCH v2 4/4] io_uring/rsrc: enable multi-hugepage buffer
 coalescing
Date: Sat, 11 May 2024 13:52:29 +0800
Message-Id: <20240511055229.352481-5-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240511055229.352481-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmlu50Afs0g0sfrCzmrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBKVbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDdI6SQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1
	xMrQwMDIFKgwITvjzMEmloLHkhX777WyNTAeFe5i5OSQEDCR2DhnPnsXIxeHkMBuRolv274z
	QjifGCX+fznMBue8eLiVFaZlzoXnrBCJnYwSC9cuhKr6xSjx+3QTI0gVm4COxO8Vv1hAbBEB
	bYnXj6eygBQxCyxhlNjVuRysSFggQOLgwg9A3RwcLAKqEoeeWoOEeQVsJW6u3cgGsU1eYv/B
	s8wgNqeAncThl+1sEDWCEidnPgGbzwxU07x1NjPIfAmBt+wSU349YoRodpHoaLjPAmELS7w6
	voUdwpaSeNnfxg6yV0KgWGLZOjmI3hZGiffv5kD1Wkv8u7KHBaSGWUBTYv0ufYiwrMTUU+uY
	IPbySfT+fsIEEeeV2DEPxlaVuHBwG9QqaYm1E7YyQ9geEt/ubYIG9kRGiSOnGpgmMCrMQvLP
	LCT/zEJYvYCReRWjZGpBcW56arFpgWFeajk8mpPzczcxgtOolucOxrsPPugdYmTiYDzEKMHB
	rCTCW1VjnSbEm5JYWZValB9fVJqTWnyI0RQY3hOZpUST84GJPK8k3tDE0sDEzMzMxNLYzFBJ
	nPd169wUIYH0xJLU7NTUgtQimD4mDk6pBqaQC4575qZk1X8qvO8fvi3inVwf43Tfug+1Kco8
	K3qWrZnllF54XebEz4XLd+/asG6J21eXuxlVpzfElJ9+avP03ZyryZdcQm7nx6xwV0tvby6/
	eMHeMfOjy27lk29Xzj7951ST2ye2GWXPBRkts/Lv5R174t/+uW2h37Q/5WpG+yQndK9N4TW+
	Ond1Fefx2DlMK9/GXeVe3m7+/Bdj+Y0CrikOVyvVje6fP7v5we+dXabcKXeOq80+KyCqMD/p
	jPr2LytrzrJ2NN/N/GT4YcvfFc2f4k50i8+RSJZ3np/scXLZaQ7nl9szS10edf9VPdnUmdcV
	ym1ldkfcKKiCKfz2exXR6petan5pbUYBW+cpsRRnJBpqMRcVJwIA6WiGniwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWy7bCSnO4Gdvs0g3/XdC3mrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlXHmYBNLwWPJiv33WtkaGI8KdzFyckgImEjMufCc
	tYuRi0NIYDujxMMjG1khEtISHYda2SFsYYmV/54D2RxART8YJS4ogITZBHQkfq/4xQISFhHQ
	lWi8qwAyhllgFaPE1fftYGOEBfwk2h8fYwapYRFQlTj01BokzCtgK3Fz7UY2iOnyEvsPnmUG
	sTkF7CQOv2wHiwsB1ZyaeoYZol5Q4uTMJywgNjNQffPW2cwTGAVmIUnNQpJawMi0ilE0taA4
	Nz03ucBQrzgxt7g0L10vOT93EyM4sLWCdjAuW/9X7xAjEwfjIUYJDmYlEd6qGus0Id6UxMqq
	1KL8+KLSnNTiQ4zSHCxK4rzKOZ0pQgLpiSWp2ampBalFMFkmDk6pBiZfj57wPUHPXeZZaj/w
	8pwQ135ufsTlz+FbHeTe9Ew/ZhJ8VLm6XKi3cvE/xWdzim/6vvM6rbLq06wKD60nbmoru4W5
	jhfX3rxx9ubRDVv589qcHuw5uFP4dkvWsTvme0JSF4btnnyfuSmrpaPsTMaPuPefnxzo+j4/
	KYqP88W101JSMwW1s6U9T0Tm9h2xXrv+gpd+85wnoQ+m7PknaVcdHZW7vlq4R/hPh1dVh8Ze
	s5OamWuXTsrtNno7n2G2rseGFQG8hekpsnUpT68/WKFh1t/0fupxd649IteD5xXlpvBs3imm
	yRb1zj1d9VCkO+eWaoa6vliFuUtUxU8dKZDlyRMxfnw3Ve7O7DZRRyWW4oxEQy3mouJEAEOI
	YK/bAgAA
X-CMS-MailID: 20240511055248epcas5p287b7dfdab3162033744badc71fd084e1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240511055248epcas5p287b7dfdab3162033744badc71fd084e1
References: <20240511055229.352481-1-cliang01.li@samsung.com>
	<CGME20240511055248epcas5p287b7dfdab3162033744badc71fd084e1@epcas5p2.samsung.com>

This patch depends on patch 1, 2, 3. It modifies the original buffer
registration path to expand the one-hugepage coalescing feature to
work with multi-hugepage buffers. Separated from previous patches to
make it more easily reviewed.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 io_uring/rsrc.c | 44 ++++++++------------------------------------
 1 file changed, 8 insertions(+), 36 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 7f95eba72f1c..70acc76ff27c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1044,7 +1044,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	unsigned long off;
 	size_t size;
 	int ret, nr_pages, i;
-	struct folio *folio = NULL;
+	struct io_imu_folio_data data;
 
 	*pimu = (struct io_mapped_ubuf *)&dummy_ubuf;
 	if (!iov->iov_base)
@@ -1059,30 +1059,11 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
+	/* If it's huge page(s), try to coalesce them into fewer bvec entries */
+	if (io_sqe_buffer_try_coalesce(pages, nr_pages, &data)) {
+		ret = io_coalesced_imu_alloc(ctx, iov, pimu, last_hpage,
+						pages, &data);
+		goto done;
 	}
 
 	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
@@ -1106,10 +1087,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	*pimu = imu;
 	ret = 0;
 
-	if (folio) {
-		bvec_set_page(&imu->bvec[0], pages[0], size, off);
-		goto done;
-	}
 	for (i = 0; i < nr_pages; i++) {
 		size_t vec_len;
 
@@ -1215,23 +1192,18 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 		 * we know that:
 		 *
 		 * 1) it's a BVEC iter, we set it up
-		 * 2) all bvecs are PAGE_SIZE in size, except potentially the
+		 * 2) all bvecs are the same in size, except potentially the
 		 *    first and last bvec
 		 *
 		 * So just find our index, and adjust the iterator afterwards.
 		 * If the offset is within the first bvec (or the whole first
 		 * bvec, just use iov_iter_advance(). This makes it easier
 		 * since we can just skip the first segment, which may not
-		 * be PAGE_SIZE aligned.
+		 * be folio_size aligned.
 		 */
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
-- 
2.34.1


