Return-Path: <io-uring+bounces-1633-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BCA88B2860
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 20:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFD421C21113
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 18:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 448981514C6;
	Thu, 25 Apr 2024 18:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cRiQ9fqm"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786EC14C594
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714070828; cv=none; b=uBtEoX7ZYJBjLqfj0EPNdiIXLiQgTL1T5Edo6fQ44b3pUckiODIv//5dEIzpeQrCrTEIV7THxJd3DRQUhEMegd381IplDOK5ZmcCh7D/xICDTgV58TX/Q0zZQY/Vs/1g6Ll9EF3fbSlZRLM+sWey+5Eu4C0rsePqaBO6yPbfugY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714070828; c=relaxed/simple;
	bh=tu3vNQfF5iF/HqabzcCL7d4l4ldyHCclld5bafxBYoA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=cL5luxRoUJ//AA34D+H+rHSjFO+2JsJVGmtYuZDc8AQcOzihf1RKRILlPLen+1eaVQhCSlgcEpIerBvNM4p8Hbo4/av+EL0Hcmf/+oZz7gYvKCsXTtmQfJ1msktyHSMZ3HM1P5Cn234/+1lPhRjuXz3/blp6mAwgJisHz9fvsOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cRiQ9fqm; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240425184659epoutp01da25568ccb614e135c8449aa9c2a5bd9~JmlQctaBZ3260532605epoutp019
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:46:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240425184659epoutp01da25568ccb614e135c8449aa9c2a5bd9~JmlQctaBZ3260532605epoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714070819;
	bh=ZsVoWy3S7pVMyWodKivCv3lhvh2UtU0BIm04ZdY7CeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRiQ9fqmaXDJzx/v1DMgoMw173NrD46B3YWhMM6uj7UT7w0C+K+zS00qN87QhH5xd
	 gI5qdQ6vvOg+L5Bp53+SOktO/hFWYFsrMGX/ay0Ek6z3a68W+PIhi+vStZN9W8iBUF
	 dsgSCg5oc4JQRhhrP6mcSZgxRsTP6jQJGAip4tHw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240425184658epcas5p24e2579ceaa12477ac46bf02ece097130~JmlQBXrcS1533515335epcas5p2B;
	Thu, 25 Apr 2024 18:46:58 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VQPwK0sMWz4x9Pp; Thu, 25 Apr
	2024 18:46:57 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	15.72.08600.025AA266; Fri, 26 Apr 2024 03:46:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240425184656epcas5p42228cdef753cf20a266d12de5bc130f0~JmlNcxsdr1482414824epcas5p4e;
	Thu, 25 Apr 2024 18:46:56 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240425184656epsmtrp1f83ebcb4478fd493e8ff02931983235b~JmlNcEobB0085000850epsmtrp1U;
	Thu, 25 Apr 2024 18:46:56 +0000 (GMT)
X-AuditID: b6c32a44-6c3ff70000002198-ca-662aa5204f69
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	6D.C2.19234.F15AA266; Fri, 26 Apr 2024 03:46:55 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240425184654epsmtip16e320a8c4939754f33ddec3ede5df744~JmlLpX8mS3266832668epsmtip13;
	Thu, 25 Apr 2024 18:46:53 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	hch@lst.de, brauner@kernel.org
Cc: asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH 03/10] block: copy result back to user meta buffer correctly
 in case of split
Date: Fri, 26 Apr 2024 00:09:36 +0530
Message-Id: <20240425183943.6319-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240425183943.6319-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIJsWRmVeSWpSXmKPExsWy7bCmuq7iUq00g5PdzBZNE/4yW8xZtY3R
	YvXdfjaL14c/MVq8mrGWzeLmgZ1MFitXH2WyeNd6jsXi6P+3bBaTDl1jtNh7S9ti/rKn7BbL
	j/9jcuD1uDZjIovHzll32T0uny312LSqk81j85J6j903G9g8Pj69xeLRt2UVo8fnTXIBnFHZ
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVysplCXm
	lAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjM+
	ru1nL1jCVfFx5nfGBsYbHF2MnBwSAiYSh9Y8Z+9i5OIQEtjNKHH2w0VWCOcTo8SKI6sRnNsf
	d7HCtDS33oJq2ckosebMW0YI5zOjxLuOuSxdjBwcbAKaEhcml4I0iAikSLxa95oRxGYWeMoo
	8aOTCaREWCBeonFnJEiYRUBV4suubSwgNq+AucSW5jZGiF3yEjMvfWcHsTkFLCQmXzzNDlEj
	KHFy5hMWiJHyEs1bZzODnCAhsJJDYun5I1DNLhK7Wn+zQdjCEq+Ob2GHsKUkXva3QdnJEpdm
	nmOCsEskHu85CGXbS7Se6mcGuZMZ6JX1u/QhdvFJ9P5+Ana+hACvREebEES1osS9SU+hwSMu
	8XDGEijbQ+Lhoi42SOh0M0q8/rWQeQKj/CwkL8xC8sIshG0LGJlXMUqmFhTnpqcmmxYY5qWW
	w+M1OT93EyM47Wq57GC8Mf+f3iFGJg7GQ4wSHMxKIrw3P2qkCfGmJFZWpRblxxeV5qQWH2I0
	BYbxRGYp0eR8YOLPK4k3NLE0MDEzMzOxNDYzVBLnfd06N0VIID2xJDU7NbUgtQimj4mDU6qB
	qSxx+17JVfYqKacvak+N3qhXe7uoYXur+S+ReeF15VkvHE89bxC5cXBOwowts7n+HFuUUavP
	f/LKO5tQA3UZrtbEGQGH1/280XohIDX+p7bsXgOtzUduyR28zNvO2Lohew6/2Yoj/zts/OtE
	mp+pZJw3SHi3dds8JoEntbePW7d+WPC57n/w0W3Z6gU3oiafTqjiUYkr2XPz1jTffx3mXks6
	9/NEmx8W7Go/nT4lZX/o2udnz4lxam14cpYxg3W53mtxFgWx5bZvuOzXr7u3o0d2zS1mntSZ
	ldr8/f5z5lw55XnZZiqL0f3TEvdauXr9mBje3FLbwzzr2Ytniez8C66UHe05mp16I6Wl9Pfs
	XUosxRmJhlrMRcWJAPe/hhFEBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWy7bCSnK78Uq00g+uvzC2aJvxltpizahuj
	xeq7/WwWrw9/YrR4NWMtm8XNAzuZLFauPspk8a71HIvF0f9v2SwmHbrGaLH3lrbF/GVP2S2W
	H//H5MDrcW3GRBaPnbPusntcPlvqsWlVJ5vH5iX1HrtvNrB5fHx6i8Wjb8sqRo/Pm+QCOKO4
	bFJSczLLUov07RK4Mj6u7WcvWMJV8XHmd8YGxhscXYycHBICJhLNrbfYuxi5OIQEtjNKXDp+
	mw0iIS7RfO0HO4QtLLHy33Oooo+MEl9nTmTuYuTgYBPQlLgwuRSkRkQgS2Jv/xWwGmaBt4wS
	8//uYQZJCAvESpyd38YKYrMIqEp82bWNBcTmFTCX2NLcxgixQF5i5qXvYMs4BSwkJl88DWYL
	AdVMXbOIEaJeUOLkzCdgvcxA9c1bZzNPYBSYhSQ1C0lqASPTKkbR1ILi3PTc5AJDveLE3OLS
	vHS95PzcTYzgaNEK2sG4bP1fvUOMTByMhxglOJiVRHhvftRIE+JNSaysSi3Kjy8qzUktPsQo
	zcGiJM6rnNOZIiSQnliSmp2aWpBaBJNl4uCUamDaesnwkYb5UYbCHS39+VUbp17emD11nVmJ
	yZuHbaJO9ikSaYvvN/VGtuy1j6t+c6rIIMRqmeDci1EGHrYd5Vt7Z79xiTeb5RZ5IaFxd2+5
	5EK+4PPzZTZMd9hdcW3yGysv/9eXbsbWx3HOmr987/tknVTNJ3v/ip/829szfb3gtd9nTa12
	Lfmc6XrzkUyZz8cAUZu3Hg6FM6ctuyTRs3dxktDn5bNZIg67HP198c3e7kc/31nff7TX1Wma
	/MVTxx/fyVHmVN9srjk7qTn/ZrDIosmeXdVVVqFKdqKeEmEsfgFLVFLY8h2u9Jioxv49tcuu
	12vpa8fyiypPD9VWb7241+e005eLZ1oMz+hPZTykxFKckWioxVxUnAgATUJq2wUDAAA=
X-CMS-MailID: 20240425184656epcas5p42228cdef753cf20a266d12de5bc130f0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240425184656epcas5p42228cdef753cf20a266d12de5bc130f0
References: <20240425183943.6319-1-joshi.k@samsung.com>
	<CGME20240425184656epcas5p42228cdef753cf20a266d12de5bc130f0@epcas5p4.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

In case of split, the len and offset of bvec gets updated in the iter.
Use it to fetch the right bvec, and copy it back to user meta buffer.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index c1955f01412e..b4042414a08f 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -108,11 +108,15 @@ static void bio_integrity_uncopy_user(struct bio_integrity_payload *bip)
 	unsigned short nr_vecs = bip->bip_max_vcnt - 1;
 	struct bio_vec *copy = &bip->bip_vec[1];
 	size_t bytes = bip->bip_iter.bi_size;
+	struct bio_vec copy_bvec, src_bvec;
 	struct iov_iter iter;
 	int ret;
 
-	iov_iter_bvec(&iter, ITER_DEST, copy, nr_vecs, bytes);
-	ret = copy_to_iter(bvec_virt(bip->bip_vec), bytes, &iter);
+	copy_bvec = mp_bvec_iter_bvec(copy, bip->bip_iter);
+	src_bvec = mp_bvec_iter_bvec(bip->bip_vec, bip->bip_iter);
+
+	iov_iter_bvec(&iter, ITER_DEST, &copy_bvec, nr_vecs, bytes);
+	ret = copy_to_iter(bvec_virt(&src_bvec), bytes, &iter);
 	WARN_ON_ONCE(ret != bytes);
 
 	bio_integrity_unpin_bvec(copy, nr_vecs, true);
-- 
2.25.1


