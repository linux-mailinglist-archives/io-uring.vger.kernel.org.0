Return-Path: <io-uring+bounces-1902-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3BB88C4D5D
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 09:55:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C74251C21711
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 07:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 335B717577;
	Tue, 14 May 2024 07:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="imRHklgL"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9B314A8F
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 07:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715673343; cv=none; b=PeKCdub4YGNq3hU+o8dz/ECpg/OzCx0US8bLZ9FxwuCB+yfj6Q4vOed8N5pY/dYNd1jtR+NFfYeeEMXEQcyT3/NtsEmMHih25cAlfPhqFxgZKs+NpPXZgkP+yF6jMEP+dreN8x5Nazz3xizaeZCUrvj2+RuJtWnlTvyLx9JwMgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715673343; c=relaxed/simple;
	bh=/pquvSSb5hWMFri5I9lPidd/KPmZagrm0CwHv1irRLU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=tG6W4B8ja4x2TKa2+g7DjikcY03k6UIQOHZFDWBcZppHxO+OAGOmZFIUSPSx6e4apE5S5PP577M7IIoXGLqS7tZbLG6qYnZT3hIU93u8d3FqMYUqkBzZxOxJHLzfe1zGsl23UfPjvZbwqNX0wFdDhiFtbtx0wS2rzs7yo/RRL8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=imRHklgL; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240514075532epoutp0307e40085a83805a8130a844e0dba8030~PS85PoSeY1861718617epoutp03B
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 07:55:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240514075532epoutp0307e40085a83805a8130a844e0dba8030~PS85PoSeY1861718617epoutp03B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715673332;
	bh=qprTvAGOCcQg9gi5Hb8YrQlfhdJvrh5dgetkxuBjKRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imRHklgL9wqav+9xhhTsV+5w2OHBwbMtk0x7GVPMmmN+C3kdmP2GJxApxaYL/3BjO
	 weGqnkobxGjNIaN8HQsbnScAnktlGcF3kucSt/AQY6LZP1kschbiRTdzEpfOaUBBj2
	 i6XA3E//qelpJQ9v5VNNhsZF20GYo0Rj3jFDjL5M=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240514075531epcas5p10a4b7b3c752d14ba6f6a48a366c6d028~PS84lIaTr3203932039epcas5p1H;
	Tue, 14 May 2024 07:55:31 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4VdpYs272mz4x9QF; Tue, 14 May
	2024 07:55:29 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E4.E4.19431.1F813466; Tue, 14 May 2024 16:55:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240514075502epcas5p10be6bef71d284a110277575d6008563d~PS8dWW0gd3182031820epcas5p1f;
	Tue, 14 May 2024 07:55:02 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240514075502epsmtrp1ca786515251d91188ae854a15651b675~PS8dVb15A0538105381epsmtrp1w;
	Tue, 14 May 2024 07:55:02 +0000 (GMT)
X-AuditID: b6c32a50-ccbff70000004be7-4c-664318f1572c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	8F.21.19234.6D813466; Tue, 14 May 2024 16:55:02 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240514075501epsmtip2625cd05c8015d1fdac432ea955422ac3~PS8cQ21lN0438604386epsmtip2F;
	Tue, 14 May 2024 07:55:01 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH v4 4/4] io_uring/rsrc: enable multi-hugepage buffer
 coalescing
Date: Tue, 14 May 2024 15:54:44 +0800
Message-Id: <20240514075444.590910-5-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514075444.590910-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsWy7bCmuu5HCec0g/1/uC2aJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7IzpR/+wFTySqDiyby1bA+MtoS5GTg4JAROJ05MmsnQxcnEICexh
	lLh5bSY7hPOJUeLZ1VuscM6rkyeYYVo2rngDVbWTUeJn10tGCOcXo8SP7x8YQarYBHQkfq/4
	xQJiiwhoS7x+PBXMZhbYxSix8JwUiC0sECBx70YTWJxFQFVi+6oOJhCbV8BW4vGDL6wQ2+Ql
	9h88C7SZg4NTwE7i1AwXiBJBiZMzn0CNlJdo3job6riv7BJrp6VD2C4S/x9/gYoLS7w6voUd
	wpaSeNnfxg4yUkKgWGLZOjmQ8yUEWhgl3r+bwwhRYy3x78oeFpAaZgFNifW79CHCshJTT61j
	gljLJ9H7+wkTRJxXYsc8GFtV4sLBbVCrpCXWTtgKdYKHxOYuWIBOBIbbsy0sExgVZiF5ZxaS
	d2YhrF7AyLyKUSq1oDg3PTXZtMBQNy+1HB7Lyfm5mxjB6VQrYAfj6g1/9Q4xMnEwHmKU4GBW
	EuF1KLRPE+JNSaysSi3Kjy8qzUktPsRoCgzvicxSosn5wISeVxJvaGJpYGJmZmZiaWxmqCTO
	+7p1boqQQHpiSWp2ampBahFMHxMHp1QDU0+G86IZ7g0cR4vOhe3uqPm2y3rrBomuPLew5De5
	ydKPE9fPVtpZ/VWj42zT1BRJpi6RJlmfO38v1BRpu3PcKGq2ee7xzGfTgitvljpZbPI3Yvv1
	TlnF9HLizsTj7z+r9E6otdqkLb9U8U3QdqntX4oO6XrbnM5yOKIgyP3seYXzw9OJO06FrvZ9
	t3Wrbht36sTU6PPHVZUr1/2fWWDyP4jvsa7glb0dja8ObrwTpnsqpof5u2W87b1LGodV03Pj
	V1zX60l+FvSum/n0tS1XnK0bDv+qY72V2+elmPRqqbt1QeQraYPgiVybti++u/fNiiBf9n/v
	5k3OfPpYmzXs95fvn5asDD1WsumwndXGcCWW4oxEQy3mouJEAOQjrMwwBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSvO41Cec0g0md0hZNE/4yW8xZtY3R
	YvXdfjaL038fs1jcPLCTyeJd6zkWi6P/37JZ/Oq+y2ix9ctXVotnezktzk74wOrA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY/rRP2wFjyQqjuxby9bAeEuoi5GTQ0LA
	RGLjijfsXYxcHEIC2xklHm3fxQSRkJboONTKDmELS6z89xyq6AejRO+2Y8wgCTYBHYnfK36x
	dDFycIgI6Eo03lUAqWEWOMQo0byhmRGkRljAT+LX1jlg9SwCqhLbV3WALeAVsJV4/OALK8QC
	eYn9B88yg8zhFLCTODXDBSQsBFSy+c9xdohyQYmTM5+wgNjMQOXNW2czT2AUmIUkNQtJagEj
	0ypG0dSC4tz03OQCQ73ixNzi0rx0veT83E2M4DDXCtrBuGz9X71DjEwcjED3cjArifA6FNqn
	CfGmJFZWpRblxxeV5qQWH2KU5mBREudVzulMERJITyxJzU5NLUgtgskycXBKNTBFB32XMMq7
	kfAzJm1TPZdIl6TAiu3bg+o8DHOEvjjMZD+74GbiIrmWW9fXeDacO6xudZ5h+7dvX9b3Hlbq
	0z3rKK59VPBXtmPJ870MXga+N+4sWbgjpEPWaeXWjBwVnu4rSguF95+uX5jTrHtBolRjQ8zF
	TU/X7TW96zdrvrXZqSweSf74iTvX3o0T0Vt7L/HBZP/NH22fH8kPuiUtKskpzd3GcKzsfHLY
	OomFK6VDguPYkuNC/OdI1u38zRixe45TybH9/Hav5a8syr4lYFYfoSFcH5TEtSi67sV2ERut
	vXrfPy19G69ftMvGcq73ttdXg9iZy9hLtuW8vOYhlXJ1uY920cYiz+B82QImeSWW4oxEQy3m
	ouJEAEi01KfiAgAA
X-CMS-MailID: 20240514075502epcas5p10be6bef71d284a110277575d6008563d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240514075502epcas5p10be6bef71d284a110277575d6008563d
References: <20240514075444.590910-1-cliang01.li@samsung.com>
	<CGME20240514075502epcas5p10be6bef71d284a110277575d6008563d@epcas5p1.samsung.com>

Modify the original buffer registration and enable the coalescing for
buffers with more than one hugepages.

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


