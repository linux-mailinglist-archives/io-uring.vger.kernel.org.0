Return-Path: <io-uring+bounces-2389-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2426C91CB7D
	for <lists+io-uring@lfdr.de>; Sat, 29 Jun 2024 09:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BE5E2838DB
	for <lists+io-uring@lfdr.de>; Sat, 29 Jun 2024 07:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B615B2BCF7;
	Sat, 29 Jun 2024 07:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="o94HnSxG"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E4D14A85
	for <io-uring@vger.kernel.org>; Sat, 29 Jun 2024 07:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719645988; cv=none; b=pG3KtZhhcC1plcb3HGXkb0AmPq2rBS6d7Addq8FMyon2oPDGNQJLKLH7hBnN+A3WPw//xgNlVLcbY/bhXr+aMpqb/IVA9X2oHKIZHPTOayQEenxQk4dtX2t1lSGp+LYtnw/knS+ItgzMpRYvG1T2xHOqpra3p7YchmEs87YYQHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719645988; c=relaxed/simple;
	bh=0ckTLWkCqkNEr+z4jilUV3nA6GJHPHIrOJVJOMuANPY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=HWK0v5HQ/XemkQaD1bib4YWGUirCGTz760nR+y7+9WDicKd2WJCX0+frcb93Or+mmcwrJrZLjez+fox7by/kMXwa5kuhMkMQSChzN0Il4T7DNzojoFBAXlsm3apqik9SRYjryht2kVHiAA2WikQ2YjLAgWct1TIWcsdEiAAECk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=o94HnSxG; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240629072624epoutp041ced77381fba8c7a9f94e35fd15b7bbb~daOlSoU2l0908809088epoutp04H
	for <io-uring@vger.kernel.org>; Sat, 29 Jun 2024 07:26:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240629072624epoutp041ced77381fba8c7a9f94e35fd15b7bbb~daOlSoU2l0908809088epoutp04H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719645984;
	bh=oOYRZfHDM6ImX8DPxmphYo3scgdYkl/adrdNjXjCqB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o94HnSxGJLifudEF+fitfV1P1br25jyjI9vXrWiRplJpAnzTNDO2AKOWDOo3qK56x
	 hSeq6YTFjRi5wVOBgYClQRz3t6L163eF3I0r5xjduGkWx2kxK01u/Q0IY0+esZct2Q
	 26nStdhuFlB29Od5+N5J0KZTizGr+RHbxT7AHI64=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240629072623epcas5p44911431171797b09da3862ca34f212a8~daOk6JhTE0540905409epcas5p4G;
	Sat, 29 Jun 2024 07:26:23 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4WB3l22pSrz4x9Pr; Sat, 29 Jun
	2024 07:26:22 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E6.26.11095.E17BF766; Sat, 29 Jun 2024 16:26:22 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240628084422epcas5p3b5d4c93e5fa30069c703bcead1fa0033~dHpX8nE2t2959029590epcas5p3s;
	Fri, 28 Jun 2024 08:44:22 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240628084422epsmtrp2309cefad43065bc8ff113ec24b9a4321~dHpX76ukC0935009350epsmtrp2j;
	Fri, 28 Jun 2024 08:44:22 +0000 (GMT)
X-AuditID: b6c32a49-3c3ff70000012b57-92-667fb71ed5fd
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	3E.3C.07412.6E77E766; Fri, 28 Jun 2024 17:44:22 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240628084420epsmtip19dd98dd4d415d5da6ef86f2d544e362e~dHpWtb3Y20069900699epsmtip1x;
	Fri, 28 Jun 2024 08:44:20 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH v5 2/3] io_uring/rsrc: store folio shift and mask into imu
Date: Fri, 28 Jun 2024 16:44:10 +0800
Message-Id: <20240628084411.2371-3-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240628084411.2371-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsWy7bCmpq7c9vo0g9+fRSyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7IyWLU9ZCppFK6ZOX8XSwDhXoIuRk0NCwETi97UOti5GLg4hgd2M
	ElN7HjJCOJ8YJSZe/cUC4XxjlHi0uIERpmVFyzwwW0hgL6PE6hX5EEVNTBLTzn5jAUmwCehI
	/F7xC8wWEdCWeP14KpjNLLCLUWLhOSkQW1jAS2J7w0k2EJtFQFXi6o92JhCbV8Ba4ueja2wQ
	y+Ql9h88ywxicwrYSFyaPosdokZQ4uTMJ1Az5SWat85mBjlCQuAvu8Sl2++ZIJpdJE6+mcEK
	YQtLvDq+hR3ClpL4/G4v0AIOILtYYtk6OYjeFkaJ9+/mQH1pLfHvyh4WkBpmAU2J9bv0IcKy
	ElNPrWOC2Msn0fv7CdQqXokd82BsVYkLB7dBrZKWWDthKzOE7SHx49dVaFj3M0r0rX7MNoFR
	YRaSf2Yh+WcWwuoFjMyrGCVTC4pz01OLTQsM81LL4bGcnJ+7iRGcTrU8dzDeffBB7xAjEwfj
	IUYJDmYlEV7+zLo0Id6UxMqq1KL8+KLSnNTiQ4ymwACfyCwlmpwPTOh5JfGGJpYGJmZmZiaW
	xmaGSuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUwZSVPnbVgyXmf2HudVxd9sXmrl7EwdWnz
	u5ZWL/t+t+8WYd3cfCYCU3wv/f+8bFWjzs7TShnxcW5Z81unSZssOPUuRfpyd9n3zkeyS75p
	eGSeKNqusn3R1Wr2d38ja/eX3y4Qcl55Y5eg/Wm7IJbqyHuHt25Mzol+m7Ml8K7M4eTdf9gO
	mDlLJTdvSHJI9xffN3fHga1HN83tevz3Fu8819ANSZ+7ODw/CO7UupmrfH1F8sJDgu+enBf6
	xb5SI6Lb/hcj1/Rit7zs0JP5zw5sLUyoVjDcMSOr65l8yLmlz5uWnH3vzPj+lKxCzYf3b7XW
	tAc+3mVjNKU76aI6Q2X73Zkmc7fsvbJv/hMbgQMffZRYijMSDbWYi4oTAYHiGrEwBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWy7bCSnO6z8ro0g8blXBZNE/4yW8xZtY3R
	YvXdfjaL038fs1jcPLCTyeJd6zkWi6P/37JZ/Oq+y2ix9ctXVotnezktzk74wOrA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEro2XLU5aCZtGKqdNXsTQwzhXoYuTkkBAw
	kVjRMo+xi5GLQ0hgN6PEsxvr2SAS0hIdh1rZIWxhiZX/nrNDFDUwSbS+m8AIkmAT0JH4veIX
	SxcjB4eIgK5E410FkBpmgUOMEs0bmsFqhAW8JLY3nAQbyiKgKnH1RzsTiM0rYC3x89E1qGXy
	EvsPnmUGsTkFbCQuTZ/FDjJTCKjmw91IiHJBiZMzn7CA2MxA5c1bZzNPYBSYhSQ1C0lqASPT
	KkbJ1ILi3PTcZMMCw7zUcr3ixNzi0rx0veT83E2M4HDX0tjBeG/+P71DjEwcjEA3czArifDy
	Z9alCfGmJFZWpRblxxeV5qQWH2KU5mBREuc1nDE7RUggPbEkNTs1tSC1CCbLxMEp1cDk9O/Z
	/u+7l127ebfCXvGKcqvR3xNeT6am7ljhHOXLITbDVSm1beOebzkydbLV96skDyvJmuok9S4W
	l0rpvtaxus574/ccI4cvL4+fN3+gqsTyREl3pnuv2IrKd8qzH/FsY/00c61JwEKJwvz1ue7f
	6zfO3JPh/uboLmljrQ1as3Za77j8TP/p1XMrX+tU5M16Xjih9u/s/uKzl3oDH736nB2zuZLX
	b5rsunMbO9LkO1Q715kvUlGT+9+u82baDE6j/ELHxQunWbk+cj0/62yVYKq89Sme/228l60f
	Lbe8+HG3oIDTueyu7JW/NpuGJ73hnVbVycayLi/3/qkAjUPM+xUPPOz9YtzV1Lpmwc12JZbi
	jERDLeai4kQADDFmQ+YCAAA=
X-CMS-MailID: 20240628084422epcas5p3b5d4c93e5fa30069c703bcead1fa0033
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240628084422epcas5p3b5d4c93e5fa30069c703bcead1fa0033
References: <20240628084411.2371-1-cliang01.li@samsung.com>
	<CGME20240628084422epcas5p3b5d4c93e5fa30069c703bcead1fa0033@epcas5p3.samsung.com>

Store the folio shift and folio mask into imu struct and use it in
iov_iter adjust, as we will have non PAGE_SIZE'd chunks if a
multi-hugepage buffer get coalesced.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
---
 io_uring/rsrc.c | 15 ++++++---------
 io_uring/rsrc.h |  2 ++
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index c88ce8c38515..3198cf854db1 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1002,6 +1002,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	imu->ubuf = (unsigned long) iov->iov_base;
 	imu->ubuf_end = imu->ubuf + iov->iov_len;
 	imu->nr_bvecs = nr_pages;
+	imu->folio_shift = PAGE_SHIFT;
+	imu->folio_mask = PAGE_MASK;
 	*pimu = imu;
 	ret = 0;
 
@@ -1118,23 +1120,18 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
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
@@ -1144,12 +1141,12 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 
 			/* skip first vec */
 			offset -= bvec->bv_len;
-			seg_skip = 1 + (offset >> PAGE_SHIFT);
+			seg_skip = 1 + (offset >> imu->folio_shift);
 
 			iter->bvec = bvec + seg_skip;
 			iter->nr_segs -= seg_skip;
 			iter->count -= bvec->bv_len + offset;
-			iter->iov_offset = offset & ~PAGE_MASK;
+			iter->iov_offset = offset & ~imu->folio_mask;
 		}
 	}
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index cc66323535f6..b02fc0ef59fe 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -46,7 +46,9 @@ struct io_mapped_ubuf {
 	u64		ubuf;
 	u64		ubuf_end;
 	unsigned int	nr_bvecs;
+	unsigned int	folio_shift;
 	unsigned long	acct_pages;
+	unsigned long	folio_mask;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
 
-- 
2.34.1


