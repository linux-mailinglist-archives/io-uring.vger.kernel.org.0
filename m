Return-Path: <io-uring+bounces-2517-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CD35932064
	for <lists+io-uring@lfdr.de>; Tue, 16 Jul 2024 08:19:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06ACE1F22276
	for <lists+io-uring@lfdr.de>; Tue, 16 Jul 2024 06:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 606461862C;
	Tue, 16 Jul 2024 06:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TA0v/z9n"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD212200C7
	for <io-uring@vger.kernel.org>; Tue, 16 Jul 2024 06:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721110779; cv=none; b=VPB2nHpSJPx0rnPExfb2dDZpa+MYbxw0ez1vtpsscyJAP2pD0xLash7kJlzE2WI3/0dr7y1bqKmtx64dIt+LyfOi4GTI/Rep4mA6NxnjD21bc2CrJuxYe3/GC1iOV/faameCt4kJxJd6Qhml6MF/1VFj1YYU0K4wDSbunf6GYBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721110779; c=relaxed/simple;
	bh=isk6Xphu7apU7I5W/dqwpKBlxbGhc14gmtvZjJp8L60=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Pzv4yYTVivSoyrt3MzKla58DzJq+I1JwEbMD6gcomKeyQQU/aCmJnNuAj38js4vYNBjjFgd2codU6yWKYn5cp/nQubA7OkRf96rZ3gnSVeCAVAJZYuBvRtN3ZHxRewj8+/b398JF9ukGbKTW/8aaZOLeAFBoaft1dr+gmqBK9n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=TA0v/z9n; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240716061934epoutp037a32d682ff3b49d18e4796d8ec158bf2~inSFgf3oF0960509605epoutp03P
	for <io-uring@vger.kernel.org>; Tue, 16 Jul 2024 06:19:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240716061934epoutp037a32d682ff3b49d18e4796d8ec158bf2~inSFgf3oF0960509605epoutp03P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1721110774;
	bh=vvDmPE9fHChoq3JiMipwa+hpODyfu2IxOaDRAQSotjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TA0v/z9n+C3DfJKBFzxcKB7JuWkVONKAVnW3OFkwqQktrsMBR8exVuPggcEgKwn+4
	 6BgtiQ4Bv1Vaxg3rXjK5LJ55XiTckdDnmktULhak/G2AU8bYO15aKUlJt+QU1Em/de
	 nHBhJGh/20pvsn3pjSAEJ+VZhIIXsIzZHrV1kHRg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240716061933epcas5p1f0451f9bad9417b92aedb2485342c3cd~inSFGGCyx3214732147epcas5p1s;
	Tue, 16 Jul 2024 06:19:33 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WNTS45Zszz4x9Q8; Tue, 16 Jul
	2024 06:19:32 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	98.9E.06857.4F016966; Tue, 16 Jul 2024 15:19:32 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240716060816epcas5p229d9f7083165acaf45256fff28536e40~inIOrkHEJ2236822368epcas5p2C;
	Tue, 16 Jul 2024 06:08:16 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240716060816epsmtrp1c6ea181adf0fe9eb97663e8e6d6e6dfb~inIOqsG3_1559415594epsmtrp11;
	Tue, 16 Jul 2024 06:08:16 +0000 (GMT)
X-AuditID: b6c32a4b-ae9fa70000021ac9-e7-669610f407ea
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	57.BC.19057.05E06966; Tue, 16 Jul 2024 15:08:16 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240716060815epsmtip10c146c6e88981d6b63f34e0a0c3d14a9~inINNP4F82388923889epsmtip1R;
	Tue, 16 Jul 2024 06:08:15 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH v6 1/2] io_uring/rsrc: store folio shift and mask into imu
Date: Tue, 16 Jul 2024 14:08:06 +0800
Message-Id: <20240716060807.2707-2-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240716060807.2707-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsWy7bCmpu4XgWlpBru/qVs0TfjLbDFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAlqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWl
	eel6eaklVoYGBkamQIUJ2Rkv5x9kK2gUrbi3fAd7A+NsgS5GTg4JAROJfxNmMnYxcnEICexm
	lOj7+pINwvnEKNG/5Q2U841R4vr/KywwLe+XnWSFSOxllFh4+zxUVROTROeR90wgVWwCOhK/
	V/wC6xAR0JZ4/XgqmM0ssAuo45wUiC0s4CXRt/YWM4jNIqAqMXtyIyuIzStgLbHt2FZWiG3y
	EvsPngWr4RSwkej9epUdokZQ4uTMJ1Az5SWat85mBjlCQuAvu8SDJX+BijiAHBeJxYfyIOYI
	S7w6voUdwpaSeNnfBlVSLLFsnRxEawujxPt3cxghaqwl/l3ZwwJSwyygKbF+lz5EWFZi6ql1
	TBBr+SR6fz9hgojzSuyYB2OrSlw4uA1qlbTE2glbmSFsD4n97a/YIWHVzyjx+/R/xgmMCrOQ
	vDMLyTuzEFYvYGRexSiZWlCcm55abFpgnJdaDo/l5PzcTYzgdKrlvYPx0YMPeocYmTgYDzFK
	cDArifBOYJyWJsSbklhZlVqUH19UmpNafIjRFBjeE5mlRJPzgQk9ryTe0MTSwMTMzMzE0tjM
	UEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGpvlrnGw+FVw4LHFmToGwfnFaSPWUUsHXDb3F
	K+M0/8Wx73Zjzrdn9zpTIubyy0B5AcuHKMM9B1/N3FR899hKNUOvOYnPzHRNbLhZkpZ5f55i
	Nm2+AOcJh6OP1GQZT6S8jb2oeK5XQb9jX2vq67XR0atNz5vWnNuYua/AtX+ZTvCN/oiVbSK1
	AefDDxf/TxGbvD/o8s+t6fFPku83n5NTijy5nI0hOek70wEB3uq58wuPmk0PnX1Y5NLMKaxi
	/G/m7WC6vr/nQVNJw+6t62wWvvqo8OXW9OlzRWUOHmY8zeVtuVji9okYD9Ppy3lfiSSvvTzH
	yn2Fk+DUzS9Xz+Tlc1Zm9m774Fax8oPdmcv8wUosxRmJhlrMRcWJAOPY2zkwBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWy7bCSnG4A37Q0gwUvjSyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxsv5B9kKGkUr7i3fwd7AOFugi5GTQ0LA
	ROL9spOsXYxcHEICuxklTl5uZ4NISEt0HGplh7CFJVb+e84OUdTAJHF541dmkASbgI7E7xW/
	WLoYOThEBHQlGu8qgNQwCxxilGje0MwIUiMs4CXRt/YWWD2LgKrE7MmNrCA2r4C1xLZjW1kh
	FshL7D94FqyGU8BGovfrVbDFQkA1L2ZNZYKoF5Q4OfMJC4jNDFTfvHU28wRGgVlIUrOQpBYw
	Mq1ilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAgOeC2tHYx7Vn3QO8TIxMEIdDQHs5II
	7wTGaWlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeb+97k0REkhPLEnNTk0tSC2CyTJxcEo1MF04
	yFUTL/RYcee8eRsS/r08WN1x8+rKOQeMU6q8v3atTl6eYTyhyLfUTFQ54DrLQqWUlB3Nqs4Z
	z305SwW7t5yyf9vecftthbZz7Z0T1QzMW/8lbMwTrt27f8+9L31Ok/2NFz35IXTMNi527b+I
	G4nlPctXSVofLecRZNzsJSGz+MmpF43HPnNUhv97L/JP6/f0f0c8zHd5sMbXbO/KCq7arl/3
	lJdtWuTCOtayg1/SNt+TlLl1edXVi79WLe1ZxCLM0Snvtyb49VTtJL9kha3zt5Xam1y+dX+G
	mJnRk5dP9Fgcix0DVrMddbSwtJ73bOUJNi25MumrRv+WHOeLjkqSjv9jEFHJPqsxiSP+sBJL
	cUaioRZzUXEiAJ+3z1nnAgAA
X-CMS-MailID: 20240716060816epcas5p229d9f7083165acaf45256fff28536e40
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240716060816epcas5p229d9f7083165acaf45256fff28536e40
References: <20240716060807.2707-1-cliang01.li@samsung.com>
	<CGME20240716060816epcas5p229d9f7083165acaf45256fff28536e40@epcas5p2.samsung.com>

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
index 60c00144471a..0d6cda92ba46 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -915,6 +915,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	imu->ubuf = (unsigned long) iov->iov_base;
 	imu->ubuf_end = imu->ubuf + iov->iov_len;
 	imu->nr_bvecs = nr_pages;
+	imu->folio_shift = PAGE_SHIFT;
+	imu->folio_mask = PAGE_MASK;
 	*pimu = imu;
 	ret = 0;
 
@@ -1031,23 +1033,18 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
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
@@ -1057,12 +1054,12 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 
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
index c032ca3436ca..8b029c53d325 100644
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


