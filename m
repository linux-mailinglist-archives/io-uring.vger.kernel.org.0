Return-Path: <io-uring+bounces-4416-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C91A9BB97D
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:56:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF2C42821CA
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 15:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B0171C07E5;
	Mon,  4 Nov 2024 15:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BUPSPf4v"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918B61C07F5
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730735773; cv=none; b=W8OAefVj5fy+jOW6/zRsEY8hS1tUilECPjZ+3Mqg1wj9WcsatdJEdPcA21uG27yajQRLga9vbgcPmoWUS7aOux+sBLvU/fgSEiurRueQ7CZZXegJR5MJY7/2+kimbzUjLpwwGVrmGAvbSURUa4Faz6zqLA6eqb8dzE8+Yus/eLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730735773; c=relaxed/simple;
	bh=UFY5MN9pbhnVXin5x3CaTOeVR6EWJ0aWiPTyVYFaoBM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=P6eTbw7iKBkpSSpwt7R8eZY+WhiPQGo5NYaWSqfqiNbv6HkboUbl9kKEg2KdQZoV1NjHyeHUHHxYEDAECfv8qho9n7PCoVt45r8xJd2TIieG9q8CnAssfMl12aUhN6G3g/Hz/EzHIDlwjfDonxt07JqGv2Pr53XYnE15RH6zplk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BUPSPf4v; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241104155608epoutp03e0fe779f43cbe383f01b30d62498a9bb~EzwMVOaMx1886218862epoutp03L
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:56:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241104155608epoutp03e0fe779f43cbe383f01b30d62498a9bb~EzwMVOaMx1886218862epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730735769;
	bh=xceWim7FbQmDU7VlpPk+fRyrGFM+8wFLGLVO0uYGafc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUPSPf4vQ/gjWyhBMEwprcnsiRiYhxQcfZ72kcanMxou5dCb1nYLFc9IVP74p1wKt
	 NKmQisIwflfcbQoFrpwm6NseO0jqfKPGP005zdHxUBak2G/dyfALl0zQ405C+DMoI0
	 9b7pP+qX3BrxHZf28ik/oEuLZCceBmkJbxn0BMA0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241104155608epcas5p2d0e7c7a247415b4d41800dd08e115c0a~EzwLwsJYX2426624266epcas5p2P;
	Mon,  4 Nov 2024 15:56:08 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Xhx064bjFz4x9Pv; Mon,  4 Nov
	2024 15:56:06 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	40.DA.09800.69EE8276; Tue,  5 Nov 2024 00:56:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241104141453epcas5p201e4aabfa7aa1f4af1cdf07228f8d4e7~EyXyb-HAs3052330523epcas5p2o;
	Mon,  4 Nov 2024 14:14:53 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241104141453epsmtrp2550a6ccf6797c4f03750e856f4b9404b~EyXybFHiE1987119871epsmtrp2z;
	Mon,  4 Nov 2024 14:14:53 +0000 (GMT)
X-AuditID: b6c32a4b-23fff70000002648-34-6728ee965683
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	99.68.35203.DD6D8276; Mon,  4 Nov 2024 23:14:53 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241104141451epsmtip207668ca33be3d64f9fcd6ac19ddc4f3a~EyXv8Sdo23097430974epsmtip2m;
	Mon,  4 Nov 2024 14:14:51 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v7 04/10] fs, iov_iter: define meta io descriptor
Date: Mon,  4 Nov 2024 19:35:55 +0530
Message-Id: <20241104140601.12239-5-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241104140601.12239-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJsWRmVeSWpSXmKPExsWy7bCmuu60dxrpBre+K1p8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSyO/n/LZjHp0DVGi723tC32
	7D3JYjF/2VN2i+7rO9gslh//x2Rx/u9xVovzs+awOwh57Jx1l93j8tlSj02rOtk8Ni+p99h9
	s4HN4+PTWywefVtWMXqcWXCE3ePzJjmPTU/eMgVwRWXbZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gD9pKRQlphTChQKSCwuVtK3synKLy1JVcjILy6x
	VUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzti1+zRbwXLeinO7vzA1MH7m6mLk5JAQ
	MJGYvWYrUxcjF4eQwG5GiU/N+5khnE+MEt3/D7JCON8YJS5vPswM0/JwymZGiMReRomnC2+x
	QTifGSXOtMxhBKliE1CXOPK8FaxKRGAPo0TvwtMsIA6zwAQmifaJc9hBqoQFHCUOXT7ECmKz
	CKhK/GybzAZi8wpYStxs62CE2CcvMfPSd7B6TgEriTl/77JA1AhKnJz5BMxmBqpp3job6r47
	HBJ72nggbBeJw7f/s0PYwhKvjm+BsqUkPr/bywZhp0v8uPyUCcIukGg+tg9qr71E66l+oJkc
	QPM1Jdbv0ocIy0pMPbWOCWItn0Tv7ydQrbwSO+bB2EoS7SvnQNkSEnvPNUDZHhIXtzyFhnYv
	o8SmU2+ZJjAqzELyziwk78xCWL2AkXkVo2RqQXFuemqxaYFxXmo5PJ6T83M3MYJTupb3DsZH
	Dz7oHWJk4mA8xCjBwawkwjsvVT1diDclsbIqtSg/vqg0J7X4EKMpMLwnMkuJJucDs0peSbyh
	iaWBiZmZmYmlsZmhkjjv69a5KUIC6YklqdmpqQWpRTB9TBycUg1MOev9D0V9jRNv4spnEt2h
	pdO3fVr9/6eGXbwJzzT/v1frjn540VxQ2DH1Yaj9e42rxW8nbZ1ov+Siy9YPJdPiiz5Zbm+K
	evmKd5uGG2fyPdYHO/v+5t9f3egX4xvw7ZvCLza5gIqdvNWOe+Q+LdsWNvtdvHGEQrYGq9eH
	ywImRndf5K98FnWIbdpfcb/e2P64X4wvcsOseh3KlGdETliv8adaVW6u5Q6Tg0KuZ3pZ1VvT
	V9XN6Lg9jWnd7gvflp21Dj1dwJ6uX/GW56eoXKBby+vWLSV3eJ8mGHIuF+4Sdfmtx/vWq4iJ
	P9dJ7Wh130sbbos/9wT2ca7omJcjutowXsbrYU2Q7ZlHf28wvFNiKc5INNRiLipOBABZIKT/
	cgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSvO7daxrpBv9/aFh8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSyO/n/LZjHp0DVGi723tC32
	7D3JYjF/2VN2i+7rO9gslh//x2Rx/u9xVovzs+awOwh57Jx1l93j8tlSj02rOtk8Ni+p99h9
	s4HN4+PTWywefVtWMXqcWXCE3ePzJjmPTU/eMgVwRXHZpKTmZJalFunbJXBl7Np9mq1gOW/F
	ud1fmBoYP3N1MXJySAiYSDycspmxi5GLQ0hgN6PE1k39zBAJCYlTL5cxQtjCEiv/PWeHKPrI
	KLGnfSdYgk1AXeLI81YwW0TgBKPE/IluIEXMAjOYJHp+rWADSQgLOEocunyIFcRmEVCV+Nk2
	GSzOK2ApcbOtA2qDvMTMS9/ZQWxOASuJOX/vsoDYQkA1m5ousUDUC0qcnPkEzGYGqm/eOpt5
	AqPALCSpWUhSCxiZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525iBMecluYOxu2rPugd
	YmTiYDzEKMHBrCTCOy9VPV2INyWxsiq1KD++qDQntfgQozQHi5I4r/iL3hQhgfTEktTs1NSC
	1CKYLBMHp1QD05W+is0RX6VnNFv1XK2P4w21SLvKzfAl+trWnVf6DovGNCh+rehWeuBycd6c
	/LfFF6ffNWk48PzDvhuNuv9NprIz+D9VjRJfz2eXmP9ZaOWml1teeF5ZnaXn9P6ynsK2tZHH
	NWdYi3S6/rmkIKXBVBHwO2/pr36OBX1LP+flzKyIYxc+kuOasGmO/eVrb/hWz7NtThUzWbH8
	w9b//lbHmdOv/XDdG3B7j8EfyRWbatRuO7zaY/2Jbd67t+tlXTJMYj+7FO/YevlPZH1z4ss5
	q1qzP56abVQgMVe6ONP/rlj6c8ndFilXNxleOXqP13ed3cK/x3a/1HllqSspoCC3omRP19G3
	gcJGOlUR/MEH1yqxFGckGmoxFxUnAgB4/XaMKAMAAA==
X-CMS-MailID: 20241104141453epcas5p201e4aabfa7aa1f4af1cdf07228f8d4e7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241104141453epcas5p201e4aabfa7aa1f4af1cdf07228f8d4e7
References: <20241104140601.12239-1-anuj20.g@samsung.com>
	<CGME20241104141453epcas5p201e4aabfa7aa1f4af1cdf07228f8d4e7@epcas5p2.samsung.com>

Add flags to describe checks for integrity meta buffer. Also, introduce
a  new 'uio_meta' structure that upper layer can use to pass the
meta/integrity information.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 include/linux/uio.h     | 9 +++++++++
 include/uapi/linux/fs.h | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 853f9de5aa05..8ada84e85447 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -82,6 +82,15 @@ struct iov_iter {
 	};
 };
 
+typedef __u16 uio_meta_flags_t;
+
+struct uio_meta {
+	uio_meta_flags_t	flags;
+	u16			app_tag;
+	u64			seed;
+	struct iov_iter		iter;
+};
+
 static inline const struct iovec *iter_iov(const struct iov_iter *iter)
 {
 	if (iter->iter_type == ITER_UBUF)
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 753971770733..9070ef19f0a3 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -40,6 +40,15 @@
 #define BLOCK_SIZE_BITS 10
 #define BLOCK_SIZE (1<<BLOCK_SIZE_BITS)
 
+/* flags for integrity meta */
+#define IO_INTEGRITY_CHK_GUARD		(1U << 0) /* enforce guard check */
+#define IO_INTEGRITY_CHK_REFTAG		(1U << 1) /* enforce ref check */
+#define IO_INTEGRITY_CHK_APPTAG		(1U << 2) /* enforce app check */
+
+#define IO_INTEGRITY_VALID_FLAGS (IO_INTEGRITY_CHK_GUARD | \
+				  IO_INTEGRITY_CHK_REFTAG | \
+				  IO_INTEGRITY_CHK_APPTAG)
+
 #define SEEK_SET	0	/* seek relative to beginning of file */
 #define SEEK_CUR	1	/* seek relative to current file position */
 #define SEEK_END	2	/* seek relative to end of file */
-- 
2.25.1


