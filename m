Return-Path: <io-uring+bounces-1888-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89DAD8C3D54
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 10:34:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0263C1F21E5D
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 08:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A7161474CB;
	Mon, 13 May 2024 08:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="vh6Nn3wf"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6CA1482FE
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 08:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715589202; cv=none; b=G1/A/z/hX8eHn6sswOtJW3u1pvbJH7DpJjH4aZjrc953atpKpnV15xm2JseNOvXYCALd45RNFlCdPNMxMs/dmpQzRN6s1+p4M16y5WW2Kbnfty4EMqg7GwyznqhlipuCcMEa7cSgZRbYsx5d+a5b70Te9puFNlUIQ6YjU6vjgzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715589202; c=relaxed/simple;
	bh=x1lM9kZ9BGnwdm1+MInf5Pe+/XsY67EMndVqggG8gr0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=rTCHqOtp/EWZ0LogE4xFTSJ+1QtkvEOqMHjBTid15XA9v1xf9K5+4Vh7GlSxgsdKFJA02rbKQ/X3PMqHdN8xYd3uCfi8Hh/vDmbr+KClrN0Z1DecoRcdObbFuE4viD0g8BKC+hjNqsWHOk+RTni0ydFCqLe0X093IPGdnZrznQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=vh6Nn3wf; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240513083315epoutp04e351f265cc1d1b99d55c9fdcb9c867d4~O-0iHRfq11434114341epoutp042
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 08:33:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240513083315epoutp04e351f265cc1d1b99d55c9fdcb9c867d4~O-0iHRfq11434114341epoutp042
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715589195;
	bh=v+WaDfn/RpYboI5Yj9LJJNwQgkVytlZFrMVuD73n/0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vh6Nn3wfWu+IKelfJLV3TqsniNwSUKoO8duvyCRcvSwenKqhWUt/Ze2mSSnABuf6Y
	 9v2OPBy3JOF3cYFuJ6/7UvTCY9aIBYjB5PuplmMpnR3mxEd0Qlii70smE16VBFRIyS
	 I3DFpoK/EorU7SKUhutTh9yttDy9Ja87dguzfwvc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240513083314epcas5p27a08524ef77f627f7da46e75c61461d1~O-0hmoRud2904529045epcas5p2_;
	Mon, 13 May 2024 08:33:14 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4VdCRr5KFnz4x9QJ; Mon, 13 May
	2024 08:33:12 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2B.02.09665.840D1466; Mon, 13 May 2024 17:33:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240513082313epcas5p2a781d3393e4bf92d13d04ac62bb28fb7~O-rxpcuJ22123521235epcas5p2Q;
	Mon, 13 May 2024 08:23:13 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240513082313epsmtrp1a9380dc713c4cfd1b446392d7b647a0b~O-rxnxfX61295312953epsmtrp1g;
	Mon, 13 May 2024 08:23:13 +0000 (GMT)
X-AuditID: b6c32a4b-829fa700000025c1-b8-6641d048970b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	B9.AB.19234.1FDC1466; Mon, 13 May 2024 17:23:13 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240513082312epsmtip2add8b99aa1bf7445aaaa0113f8a58d50~O-rwmIjEU1126111261epsmtip2z;
	Mon, 13 May 2024 08:23:12 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, gost.dev@samsung.com, Chenliang Li
	<cliang01.li@samsung.com>
Subject: [PATCH v3 4/5] io_uring/rsrc: enable multi-hugepage buffer
 coalescing
Date: Mon, 13 May 2024 16:22:59 +0800
Message-Id: <20240513082300.515905-5-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240513082300.515905-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmhq7HBcc0g3V3NSzmrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBKVbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDdI6SQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1
	xMrQwMDIFKgwITuj7fF1toKdkhV9c++xNDAuEe5i5OSQEDCRODN7MmMXIxeHkMBuRonmT2fY
	IZxPjBKbFtxhgXNebv7FDtOy7sVKZojETkaJ69/XQDm/GCVOHjnIClLFJqAj8XvFLxYQW0RA
	W+L146lgo5gFljBK7OpczgiSEBYIkJg5bQkbiM0ioCqx4VAD2ApeAVuJna2rWSHWyUvsP3iW
	GcTmFLCT2LnnDzNEjaDEyZlPwBYwA9U0b50NdoWEwFt2iTUX3jBBNLtINP1sZoOwhSVeHd8C
	9YOUxMv+NiCbA8gulli2Tg6it4VR4v27OYwQNdYS/67sYQGpYRbQlFi/Sx8iLCsx9dQ6Joi9
	fBK9v59AreKV2DEPxlaVuHBwG9QqaYm1E7YyQ6zykDjUng0JrImMEl9mNrFPYFSYheSdWUje
	mYWweQEj8ypGydSC4tz01GLTAuO81HJ4NCfn525iBKdRLe8djI8efNA7xMjEwXiIUYKDWUmE
	16HQPk2INyWxsiq1KD++qDQntfgQoykwvCcyS4km5wMTeV5JvKGJpYGJmZmZiaWxmaGSOO/r
	1rkpQgLpiSWp2ampBalFMH1MHJxSDUzLf/DEc3VeExcUkmx+ZjtdpVMvfOc7h/kCT4Q2hUac
	TnyquD2g/I+67f3T5+YLJmxwm7xfv/CzlElYK3/FkukHtY/ofl6s/vfe54qbQaF/97k8YX+W
	HsL5a23Q0vneZxbXN8ponmB50W/DK/1lTWTXibA2TotXWkmyRsrpvh0lFz7/FK1TcTymXHf9
	633Znw8KtR98KTp98sotJ2PHc+FPvf97z/yZeq1J6HPLU7F7jw7N7je7bRX5z2GnYruVtPJN
	ZfUPLWJ9u8Q0eY0knrb+dVF929QSxCVYLi2X5fBuwz+jT9VuS25YTEp+4FQQ9eh567ZPDZqp
	j6ccl320+nJ9x7YaQZW1K6rOCnJGeSixFGckGmoxFxUnAgCxR3IrLAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWy7bCSvO7Hs45pBlM2cVnMWbWN0WL13X42
	i9N/H7NY3Dywk8niXes5Fouj/9+yWfzqvstosfXLV1aLZ3s5Lc5O+MDqwOWxc9Zddo/LZ0s9
	+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK6Pt8XW2gp2SFX1z77E0MC4R7mLk5JAQMJFY92Il
	cxcjF4eQwHZGiQUnNjFDJKQlOg61skPYwhIr/z0Hs4UEfjBKnD4kBGKzCehI/F7xi6WLkYND
	REBXovGuAsgcZoFVjBJX37ezgtQIC/hJrH/TC2azCKhKbDjUADaHV8BWYmfralaI+fIS+w+e
	BdvLKWAnsXPPH2aIXbYSpw5vZoOoF5Q4OfMJC4jNDFTfvHU28wRGgVlIUrOQpBYwMq1iFE0t
	KM5Nz00uMNQrTswtLs1L10vOz93ECA5uraAdjMvW/9U7xMjEwXiIUYKDWUmE16HQPk2INyWx
	siq1KD++qDQntfgQozQHi5I4r3JOZ4qQQHpiSWp2ampBahFMlomDU6qBqf/1Po+Da0Sj1a2k
	8iutTyfdDNgSI9pwgd/00qRls5w16i/M4Cj2lTCa+zJeccHabXedpBX57lfvdYjmEI/VOCN/
	083l0Yb/NbkaVQfmWjkxLmldlZE0wahZ9oDr7zzrUi3N9bZ7Dp8Mi3Xhbb4kl+/gbtvtatN1
	WCM0b6Wb/hpbyz8bFiistqma6NOc25Z7nWsaz81u22LBOUsDOx38trTfmV7xRSY80Ntzf6o4
	78WTbneNw2qb7cQU/3PnJkW9PKuaxmm/6XCItrX+9wcic0wWnr94n39R9FsL392H9E0/qhpP
	fXf5dPk5m92Cmk8tNfOzNrPXyHZZuPUv8l/dXrqgIOS2tZzg160P5JRYijMSDbWYi4oTAbNo
	r+bdAgAA
X-CMS-MailID: 20240513082313epcas5p2a781d3393e4bf92d13d04ac62bb28fb7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240513082313epcas5p2a781d3393e4bf92d13d04ac62bb28fb7
References: <20240513082300.515905-1-cliang01.li@samsung.com>
	<CGME20240513082313epcas5p2a781d3393e4bf92d13d04ac62bb28fb7@epcas5p2.samsung.com>

Modify the original buffer registration path to expand the
one-hugepage coalescing feature to work with multi-hugepage
buffers. Separated from previous patches to make it more
easily reviewed.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 io_uring/rsrc.c | 44 ++++++++------------------------------------
 1 file changed, 8 insertions(+), 36 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 53fac5f27bbf..5e5c1d6f3501 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1047,7 +1047,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	unsigned long off;
 	size_t size;
 	int ret, nr_pages, i;
-	struct folio *folio = NULL;
+	struct io_imu_folio_data data;
 
 	*pimu = (struct io_mapped_ubuf *)&dummy_ubuf;
 	if (!iov->iov_base)
@@ -1062,30 +1062,11 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
@@ -1109,10 +1090,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	*pimu = imu;
 	ret = 0;
 
-	if (folio) {
-		bvec_set_page(&imu->bvec[0], pages[0], size, off);
-		goto done;
-	}
 	for (i = 0; i < nr_pages; i++) {
 		size_t vec_len;
 
@@ -1218,23 +1195,18 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
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


