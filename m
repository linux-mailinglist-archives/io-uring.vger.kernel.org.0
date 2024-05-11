Return-Path: <io-uring+bounces-1869-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5F448C2FD6
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 08:30:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B291283F35
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 06:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94881A55;
	Sat, 11 May 2024 06:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fM8DoD9D"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BE91C01
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 06:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715409049; cv=none; b=Nydk05A9ZhcMaNWoRjy27mAZ3G1anucHMdWkt7Qn3FD5vqDBgW+n2LnS/33x+qENi43PpwAz3UzG2ESW1av0BASpKaq/w97ZzOyA1LQXAAbku5JZyV8tDxnvW+bLxgIkHSZddOIj7Me3v4uSuMPnq2temmLT7wrB58WGAODcFLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715409049; c=relaxed/simple;
	bh=v98Mo+MpYBU0qzaAkf44WS1u6iYjnUbvkJq6cTR5f6I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=IxkVV/AkltsaPCL5EikWKUHvFQS0bcbqNc4qCzfaDguo48pZGIvZUe/ecLlzJCWcMGNX0YIRE1NZ9dKU/SbdKV0yZjl8gkPopb6sE/vz5QL0noTpUz4ur8Uux1IAwKQ/VLXhcdriqP2qXRzS0q+fFANKpts2FECB3pPvHM6d/X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fM8DoD9D; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240511063044epoutp022fdad395a280e8ec40c2fddbf6b5f53a~OW2-jOdW11125511255epoutp02a
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 06:30:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240511063044epoutp022fdad395a280e8ec40c2fddbf6b5f53a~OW2-jOdW11125511255epoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715409044;
	bh=9J3qY+gr/EQFxqtdizhx5LUqyyO9iMd1OdFM5PunXLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fM8DoD9Du8yVIjmVrqaMqlBlTyzTANe0FlueWK+TplUjKmpcl0l5Fbn57JwcqvaBB
	 79ftzGfBBJWJafE3UpORI9Jb0NI/ZPyLKV2OwF4LGYcBOOpUyu4HPOzlZyjv9XqoRY
	 ZY8hDuIJrtA/7fhxXRgwxsmWv0c2Jkp0hkgOStVI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240511063043epcas5p2a6667af7b215d1b1e659daabbc522795~OW2-F_76_3223632236epcas5p2B;
	Sat, 11 May 2024 06:30:43 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VbwqP6ntnz4x9Pr; Sat, 11 May
	2024 06:30:41 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	62.82.08600.1901F366; Sat, 11 May 2024 15:30:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240511055245epcas5p407cdbc005fb5f0fe2d9bbb8da423ff28~OWV1c4NLN3151631516epcas5p4I;
	Sat, 11 May 2024 05:52:45 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240511055245epsmtrp19da6b7953e41a8a34bf71b6600bcc92a~OWV1cM7FX2071620716epsmtrp1T;
	Sat, 11 May 2024 05:52:45 +0000 (GMT)
X-AuditID: b6c32a44-921fa70000002198-b7-663f1091369d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	99.C2.19234.DA70F366; Sat, 11 May 2024 14:52:45 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240511055244epsmtip110a6ec42fc837cc2ac8a55e2b14d6a56~OWV0gUinR0560305603epsmtip1a;
	Sat, 11 May 2024 05:52:44 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, gost.dev@samsung.com, Chenliang Li
	<cliang01.li@samsung.com>
Subject: [PATCH v2 2/4] io_uring/rsrc: store folio shift and mask into imu
Date: Sat, 11 May 2024 13:52:27 +0800
Message-Id: <20240511055229.352481-3-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240511055229.352481-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmuu5EAfs0g0f/TC3mrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBKVbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDdI6SQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1
	xMrQwMDIFKgwITvj1PoVzAXPeCr6rzUyNjDO5upi5OSQEDCRmNa0hb2LkYtDSGA3o8S73U1s
	EM4nRoneB5+Y4Jyuy9NYYFo+bnsAldjJKDH1dyNU/y9Gie5DF1lBqtgEdCR+r/gF1iEioC3x
	+vFUFpAiZoEljBK7OpczgiSEBbwkNm6+CDSKg4NFQFVi23pekDCvgK3E+Z4DbBDb5CX2HzzL
	DGJzCthJHH7ZzgZRIyhxcuYTsPnMQDXNW2czg8yXEPjILnH//1cmiGYXiXerIJolBIQlXh0H
	+RTElpJ42d/GDrJXQqBYYtk6OYjeFkaJ9+/mMELUWEv8u7KHBaSGWUBTYv0ufYiwrMTUU+uY
	IPbySfT+fgK1ildixzwYW1XiwsFtUKukJdZO2Ap1gofEp4MXGCGBNZFR4vLKF2wTGBVmIfln
	FpJ/ZiGsXsDIvIpRMrWgODc9Ndm0wDAvtRwezcn5uZsYwWlUy2UH4435//QOMTJxMB5ilOBg
	VhLhraqxThPiTUmsrEotyo8vKs1JLT7EaAoM74nMUqLJ+cBEnlcSb2hiaWBiZmZmYmlsZqgk
	zvu6dW6KkEB6YklqdmpqQWoRTB8TB6dUA5NuT5jqDt8Gp1cXZzC+O785ILLr6q72h5MV3zR1
	8B1MkZ1zbV7n9bJ7V47NVazIcXWZtbMg+cU3R7clj+MuW+YkZsxmXb5Qfwsjo6rBZ4moVXzn
	ueedOquufjdE+GPs8+pSvcsXU0U1nmeYz1zydc6fyQ/dNi+6bnDtS13qdrfSTIMMFXPXSfO2
	WH6WCo9LbgvX2rFuF6N/go6A9kKuU28W3F1zesud/jX1ycsmpdbGvrnnONnC7+Q3/5D4G87N
	pZotogKRD7MT677f3Xr+Jp/5G883TXcerj6ftLmjqfHtjrTMDc/ELx++/vxhW0fxkXsPc1QO
	PHy6L4onalvkcleWM29d9qd7m3x5vFPAhiNNiaU4I9FQi7moOBEAyqq9BywEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWy7bCSnO5advs0g6fvZS3mrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlXFq/Qrmgmc8Ff3XGhkbGGdzdTFyckgImEh83PaA
	qYuRi0NIYDujxJR1y1kgEtISHYda2SFsYYmV/56zQxT9YJTY0/AeLMEmoCPxe8UvoAYODhEB
	XYnGuwogNcwCqxglrr5vZwWpERbwkti4+SITSA2LgKrEtvW8IGFeAVuJ8z0H2CDmy0vsP3iW
	GcTmFLCTOPyyHSwuBFRzauoZZoh6QYmTM5+A3cYMVN+8dTbzBEaBWUhSs5CkFjAyrWIUTS0o
	zk3PTS4w1CtOzC0uzUvXS87P3cQIDm6toB2My9b/1TvEyMTBeIhRgoNZSYS3qsY6TYg3JbGy
	KrUoP76oNCe1+BCjNAeLkjivck5nipBAemJJanZqakFqEUyWiYNTqoFpYc+hz85/Fygavz4R
	dObl7rux8X+6F9dtXvtjf8ffT+bRZczK5bL2brsnrX7u5m/fYxoXMkFHa5m7UGD2hhMMmR3b
	UvSbMvi2i378NLWfYzd7h1i0U5mQkvLhunt3i77vV55aLVLTPNVJ55NUfvNWA38jE68ZmguL
	oubfne3g/2HSmpolzxtuPvhlMLlLLuhi5+/wmjK1PcEnbZY+Z73FzBoh6t+wMLOfx6BQ357t
	f5PjfsHnX9burim++XeG6VSf7fGL8sIKcj9NUNZ/4uDiYsrIvK9reop7i9TWxgmHtqdzbmW9
	d4194pP6HS6zmaQDWNNZ7zcGT83Rmf9Mw7j4oeHvp+/W5W6tnXx7zy4lluKMREMt5qLiRAC6
	OQ173QIAAA==
X-CMS-MailID: 20240511055245epcas5p407cdbc005fb5f0fe2d9bbb8da423ff28
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240511055245epcas5p407cdbc005fb5f0fe2d9bbb8da423ff28
References: <20240511055229.352481-1-cliang01.li@samsung.com>
	<CGME20240511055245epcas5p407cdbc005fb5f0fe2d9bbb8da423ff28@epcas5p4.samsung.com>

Store the folio shift and folio mask into imu struct and use it in
iov_iter adjust, as we will have non PAGE_SIZE'd chunks if a
multi-hugepage buffer get coalesced.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 io_uring/rsrc.c | 6 ++++--
 io_uring/rsrc.h | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d08224c0c5b0..578d382ca9bc 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1015,6 +1015,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	imu->ubuf = (unsigned long) iov->iov_base;
 	imu->ubuf_end = imu->ubuf + iov->iov_len;
 	imu->nr_bvecs = nr_pages;
+	imu->folio_shift = PAGE_SHIFT;
+	imu->folio_mask = PAGE_MASK;
 	*pimu = imu;
 	ret = 0;
 
@@ -1153,12 +1155,12 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 
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
index b2a9d66b76dd..93da02e652bc 100644
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


