Return-Path: <io-uring+bounces-1885-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 834768C3D2A
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 10:29:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A572D1C21323
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 08:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE4731474B9;
	Mon, 13 May 2024 08:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bkxRbHnD"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E998F1474A2
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 08:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715588985; cv=none; b=bdHzhRiJAdJvkNVGTVWf2Ts2ZYsYW7m/0XX2EGWZWVrhtXfKysW8aJg+2ofPa6gLToJz2SYKHbVa412kArXKS0EmPM3ivCzZsZC692lWer7kDFSLIfVKRFLto9koE+BUSsgFLXPH8/+gxD/mRy3h8ACCl8VwzcNK6P+ADcA9aGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715588985; c=relaxed/simple;
	bh=v98Mo+MpYBU0qzaAkf44WS1u6iYjnUbvkJq6cTR5f6I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ZW59epwUDjT3Mx7Isk+g7zcEIq7xSBMooDTxQ2O5Cw4S1LUs2tS5BK13nkLXuVkisb9tBf6QTs1QGhRYgstdUCvaSWQFdCHN5Nvs/Ms/YSZs/DHxvp/JJWMrQFejMD1306es9T6QAIMSNem9ju4UQNdXOudEF5FtMx+u8BR/KQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bkxRbHnD; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240513082940epoutp022f8d198c3784496126d9950fe94c00b8~O-xaBftbp1135311353epoutp022
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 08:29:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240513082940epoutp022f8d198c3784496126d9950fe94c00b8~O-xaBftbp1135311353epoutp022
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715588980;
	bh=9J3qY+gr/EQFxqtdizhx5LUqyyO9iMd1OdFM5PunXLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkxRbHnDFPbn/Womho2vSf396FPYF7pJ+NBeOE6AhMRxylprhf1JC+Giun0l6Utoy
	 DW6PfQCaDFyyvBoj3ORwE/02g8cXSKchm1XJfBlNkUwPshpHOcoWcqcvnlj6QjqwEJ
	 IuPikktpGGcScEpoV44UgDAYh8y9liY/+mlt+Fvw=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240513082939epcas5p215274d484d2a8367f537b04e9cb9c7d9~O-xZqNy2J2025720257epcas5p2B;
	Mon, 13 May 2024 08:29:39 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4VdCMk0VZ7z4x9Q0; Mon, 13 May
	2024 08:29:38 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	12.0D.19431.17FC1466; Mon, 13 May 2024 17:29:37 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240513082310epcas5p27576a80eae3ee09e40102b179ce46fa9~O-ruo0HN-3055430554epcas5p2V;
	Mon, 13 May 2024 08:23:10 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240513082310epsmtrp28b0a33d949586dbfc88762977aa1037a~O-ruoAuP_1439014390epsmtrp2J;
	Mon, 13 May 2024 08:23:10 +0000 (GMT)
X-AuditID: b6c32a50-58472a8000004be7-cf-6641cf7195c0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9C.6C.08390.DEDC1466; Mon, 13 May 2024 17:23:09 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240513082308epsmtip2e368ab2b59d386810dd727a912e9737a~O-rtonvxn0931209312epsmtip2T;
	Mon, 13 May 2024 08:23:08 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, gost.dev@samsung.com, Chenliang Li
	<cliang01.li@samsung.com>
Subject: [PATCH v3 2/5] io_uring/rsrc: store folio shift and mask into imu
Date: Mon, 13 May 2024 16:22:57 +0800
Message-Id: <20240513082300.515905-3-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240513082300.515905-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmlm7hecc0g2OHrSzmrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBKVbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDdI6SQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1
	xMrQwMDIFKgwITvj1PoVzAXPeCr6rzUyNjDO5upi5OSQEDCRePJhElsXIxeHkMAeRond55Yy
	QjifGCW2n5nBAlIlJPCNUeLIRGmYjgufO1kgivYySnS2/4ZyfjFK7HqzlR2kik1AR+L3il9g
	3SIC2hKvH08FK2IWWAJU1LmcESQhLOAlsfTBJKAEBweLgKrE3t2SIGFeAVuJdT8usEJsk5fY
	f/AsM4jNKWAnsXPPH2aIGkGJkzOfgM1nBqpp3jqbGWS+hMBHdonJnxazQzS7SKy78oQRwhaW
	eHV8C1RcSuLzu71sIHslBIollq2Tg+htYZR4/24OVL21xL8re8BuYxbQlFi/Sx8iLCsx9dQ6
	Joi9fBK9v58wQcR5JXbMg7FVJS4c3Aa1Slpi7YStzBC2h8Ti+7OhYT2RUWLN1H7GCYwKs5D8
	MwvJP7MQVi9gZF7FKJVaUJybnppsWmCom5daDo/m5PzcTYzgNKoVsINx9Ya/eocYmTgYDzFK
	cDArifA6FNqnCfGmJFZWpRblxxeV5qQWH2I0BQb4RGYp0eR8YCLPK4k3NLE0MDEzMzOxNDYz
	VBLnfd06N0VIID2xJDU7NbUgtQimj4mDU6qBKdlNMD8g1skwkM3WfcHO/Njgta5qgakZ92Mn
	bGu9dOd54OyvFxusl7YYV9ybZ1i5tlFr6sOlJy0E1RVlVk13Nq3dvJlTx8vsndeCubfmsftl
	eH81s/3h/ahug8TDhqmZGl1iStFiE28v48ho+7xg+2rjhgmZL1dJCeXM3eG/82gVp2mfhsHO
	utLFPtLrVI2ifeJvG6ZMj7ynqPdU14A1b7WskugBEw8Hm6s9JZYGT1lnO4s+rfifGbUxIabp
	eOye9XNTo0633dbS8v95dV6s0YowBeY3DxkaWSq3dn07t+LJ4s4PMd8cnp3JM3S+oHR411Rz
	NZfKtVUWRTH7GpimeHiafJjlJdYZ0SnTsk+JpTgj0VCLuag4EQDuOds+LAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWy7bCSvO7bs45pBodazCzmrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlXFq/Qrmgmc8Ff3XGhkbGGdzdTFyckgImEhc+NzJ
	0sXIxSEksJtR4ur0B6wQCWmJjkOt7BC2sMTKf8/ZIYp+MEpMe/6GCSTBJqAj8XvFL6BuDg4R
	AV2JxrsKIDXMAquABr1vBxskLOAlsfTBJLAaFgFVib27JUHCvAK2Eut+XIDaJS+x/+BZZhCb
	U8BOYueeP2C2EFDNqcOb2SDqBSVOznzCAmIzA9U3b53NPIFRYBaS1CwkqQWMTKsYJVMLinPT
	c4sNC4zyUsv1ihNzi0vz0vWS83M3MYKDXEtrB+OeVR/0DjEycTAeYpTgYFYS4XUotE8T4k1J
	rKxKLcqPLyrNSS0+xCjNwaIkzvvtdW+KkEB6YklqdmpqQWoRTJaJg1OqgSnv357Tj5/kPbmp
	n31OaIFAbszVTIm0xb9fMP48wa0mfWfN6SefQqQLE++WrHxhV2Rz6cAegZM5Kao6eUtvaWRv
	OH1aPPfdA+4+JgGF4jBu76nfXT/7GrbsnrrT6k6Cf6fEy6nWVyXnzZ2g+L/ba83ar+I64fqt
	q36eMF/7/WPQ43ieA/GJintdNfaabxcwXvKxnNtk5m+OCPXtD6yrmhq3vxV3dT4klL2UZ72c
	kp0Ik8+cD8YC2ZIO//PP+b3vXp5dV747t+L9FJu3WfUF7ry3lhnybJiwhoE1OrXlrgHTo6Tj
	1/r9fjwWUC0UkJnW7pPSfaVqseFP9Rh/9WOqPSdKNW8lXZ8Xk/Hf3PmajBJLcUaioRZzUXEi
	AFWp7pzhAgAA
X-CMS-MailID: 20240513082310epcas5p27576a80eae3ee09e40102b179ce46fa9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240513082310epcas5p27576a80eae3ee09e40102b179ce46fa9
References: <20240513082300.515905-1-cliang01.li@samsung.com>
	<CGME20240513082310epcas5p27576a80eae3ee09e40102b179ce46fa9@epcas5p2.samsung.com>

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


