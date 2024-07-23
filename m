Return-Path: <io-uring+bounces-2545-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA92E9399B4
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 08:28:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48675282848
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 06:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803C913D245;
	Tue, 23 Jul 2024 06:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RYwDvYOM"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3187C13D8B3
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 06:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721716117; cv=none; b=eTI7K/VYUq0Jm1Vj0Mjfg7HFDdaexYVo2/+5fVd/jm7JGfml5jeh3zbUa1EDWf8IqLY4Xz4WGklE76x3b7QbgozxwnneirFQdcsvLgycLOYnBNMkIgyYe6Rm4rJxMkym4TDoppcgecfQdcCutHLNhHquRwYjmA6ezjk5lbrmmqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721716117; c=relaxed/simple;
	bh=isk6Xphu7apU7I5W/dqwpKBlxbGhc14gmtvZjJp8L60=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=NF5uHDEdVlcNtG4McQ2CJnXE76Bn/PpTv/ztHeMLrzhB6K69GdhhjHw0uC3kGrLwuEhqKkv8v8UZA2eqEn1MOucZe2CajWZFReV7hefhhPyMREvHV43fcHYZfWwMKAlvCOa5FcFE/VPYlC6gaK0UN0yY6SjVRSLpBVoiSRKMcw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RYwDvYOM; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240723062827epoutp0277013092548a239d9e9c76877702ec84~kw61uoMPJ2267922679epoutp02k
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 06:28:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240723062827epoutp0277013092548a239d9e9c76877702ec84~kw61uoMPJ2267922679epoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1721716107;
	bh=vvDmPE9fHChoq3JiMipwa+hpODyfu2IxOaDRAQSotjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYwDvYOM5nnkL6l/YUq6km06iOlwqcP40GnOEK7jvLUk1R9xgZ3LbZNd7GIeMOpYi
	 NCh1x/x2UoWoVTgqePqwrwmtr5L8xjXxiMNrjBaFAx7M4X1zpL4xaSmM+0+OI3YRWA
	 WuNZwv5zhtV3PVaunsBH9wJ2chd/F9lfmJyUSsf4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240723062826epcas5p18c6bdd38342267ba16b1a023531e26a7~kw61ZbPvZ1238012380epcas5p1D;
	Tue, 23 Jul 2024 06:28:26 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WSnK41p8rz4x9Pp; Tue, 23 Jul
	2024 06:28:24 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	3B.30.19863.88D4F966; Tue, 23 Jul 2024 15:28:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240723055625epcas5p105f302ac966b9bef5925b1e718acd453~kwe35po7Z2316223162epcas5p1w;
	Tue, 23 Jul 2024 05:56:25 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240723055625epsmtrp17ea97a623aad47242adc6d4b29dfdab3~kwe34_1wG1884918849epsmtrp1Y;
	Tue, 23 Jul 2024 05:56:25 +0000 (GMT)
X-AuditID: b6c32a50-c73ff70000004d97-10-669f4d8838eb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F5.B3.07567.9064F966; Tue, 23 Jul 2024 14:56:25 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240723055623epsmtip2bb15e081f7b1027c6dad1a8ee347bc88~kwe2jVPKl1406214062epsmtip2t;
	Tue, 23 Jul 2024 05:56:23 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [Patch v7 1/2] io_uring/rsrc: store folio shift and mask into imu
Date: Tue, 23 Jul 2024 13:56:15 +0800
Message-Id: <20240723055616.2362-2-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240723055616.2362-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmlm6H7/w0g41/OSyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7IyX8w+yFTSKVtxbvoO9gXG2QBcjJ4eEgInEzQPH2UFsIYE9jBIn
	b3tB2J8YJa7t4YewvzFK7DqbBFM/+eFsxi5GLqD4XkaJGZ8mMkM4TUwSq56cYQKpYhPQkfi9
	4hcLiC0ioC3x+vFUMJtZYBejxMJzUiC2sICXxKxfWxlBbBYBVYlpf++AXcErYC0xf88hVoht
	8hL7D55lBrE5BWwkHp+bxAhRIyhxcuYTqJnyEs1bZ4MdISHwl12ibd9tNohmF4mn7UcYIWxh
	iVfHt7BD2FISL/vbgGwOILtYYtk6OYjeFkaJ9+/mQNVbS/y7socFpIZZQFNi/S59iLCsxNRT
	65gg9vJJ9P5+wgQR55XYMQ/GVpW4cHAb1CppibUTtjJD2B4Suz79ZYUEVj8wpC9OYZnAqDAL
	yT+zkPwzC2H1AkbmVYxSqQXFuempyaYFhrp5qeXwSE7Oz93ECE6mWgE7GFdv+Kt3iJGJg/EQ
	owQHs5II75NXc9OEeFMSK6tSi/Lji0pzUosPMZoCQ3wis5Rocj4wneeVxBuaWBqYmJmZmVga
	mxkqifO+bp2bIiSQnliSmp2aWpBaBNPHxMEp1cA0u2BmyUWHxVY9qWFOV01WBQY+7OCqFJhq
	p6/xd4am8NyGlMgM0SniSmm9yX+mPL18g7Nm0TzX9WXK+69c+LrQ9v2OGbJ/C2tunOaMvnei
	6LCashCb32LrF/Mnqj5undqt7hKc1VPq27NxxucPS/S6pTY+ONqvzL72ywU/zdwZq8WnXt+e
	N7//cBjPpI8a835az/Vcsf7RyTU3vZIMgreUz33Uz+Ew+8KsRRGzOWSYOjlK/8r9vno+6fz2
	80+eKno0T8kUehkoqvOLLSIzSsP4oDKDk+G1G/d5ne7mPBU/8fz5x80Hr2dmf43Zp6r27b9Y
	sfiDO6nPeNe/uCg6iV2448E9jfc/CvgE5Q+VNLWLKLEUZyQaajEXFScCAEWt3vAvBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWy7bCSvC6n2/w0gxNzRC2aJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxsv5B9kKGkUr7i3fwd7AOFugi5GTQ0LA
	RGLyw9mMXYxcHEICuxkl3l9ewwqRkJboONTKDmELS6z895wdoqiBSeLupC4WkASbgI7E7xW/
	gGwODhEBXYnGuwogNcwChxglmjc0M4LUCAt4Scz6tRXMZhFQlZj29w7YUF4Ba4n5ew5BLZOX
	2H/wLDOIzSlgI/H43CSweiGgmsmb1jBC1AtKnJz5BGwvM1B989bZzBMYBWYhSc1CklrAyLSK
	UTK1oDg3PTfZsMAwL7Vcrzgxt7g0L10vOT93EyM44LU0djDem/9P7xAjEwcj0NEczEoivE9e
	zU0T4k1JrKxKLcqPLyrNSS0+xCjNwaIkzms4Y3aKkEB6YklqdmpqQWoRTJaJg1OqgWm2+Y5z
	mlsfB4dOjT37nf/IZMVkpx28mSfYr7XrHYnxY7jkWBXgcq4u40jpL/ktYbF7Fzn5RVnrrFYo
	Twva94iZjffnDbOoDU2Zu/oK/lS/OPGCU+wR+zP+E6ksVb9NZCcHPhKKWHM9YVGt5LnfTD++
	LHWy9Ora1ZJ+RPzX6aN2LFavguvuTTb45eP2ZNXSSvabNbeSz2x9e3/Zl4xyhgtrAirS+Gvf
	7PNQNjHO9xBZfSxn9f+JX6fYTLZYbqT4YbvBg2Mzn+z1zkhsOHPZXLL74Z76lx6BOacyajM0
	lHy1XjOJbr4rcKew8SWLyr8fsofEfK52C9xmu1lxvjC703ujr6LdLSP9+k2F+ey7PyqxFGck
	GmoxFxUnAgBdnCLA5wIAAA==
X-CMS-MailID: 20240723055625epcas5p105f302ac966b9bef5925b1e718acd453
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240723055625epcas5p105f302ac966b9bef5925b1e718acd453
References: <20240723055616.2362-1-cliang01.li@samsung.com>
	<CGME20240723055625epcas5p105f302ac966b9bef5925b1e718acd453@epcas5p1.samsung.com>

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


