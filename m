Return-Path: <io-uring+bounces-1630-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B4E8B285A
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 20:47:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08CD61F22522
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 18:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E0D14F10D;
	Thu, 25 Apr 2024 18:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hrfIkLM5"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF56A14C594
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714070825; cv=none; b=k3+GroSorDePOocXSV+Whx9qwV16GIr06FECgdbfe+ukb7RI498Qnm9u6Pmly2WQU0GCNWafjCDkse98IHtBX5yUqewUcGoNeryzwHuq3WOoI68C/jOFxisPs9lPonpNf/iPDZ2HKlmJ4mSBBTK7skDs2viMbkdESG2cozrtnTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714070825; c=relaxed/simple;
	bh=LJSHEEALYuYlUhgwGg0LriiebY8Ob71WhJkAcd/6hao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=HJcpUKOgHmYO+8XBc2ZGVHNn21bmiJUowv33dEwrFOHS5EPzzXtamDxpX1rp1S8YVHCugb1p5OivsrY6ZvmNwKSzmRYogfukSwfU2rC/yUCN6fUjD/50KQ5Ca7pAqczdL71dfv85NxFvGfxSI4mM7xdbZ+O0hAj3fCewvEUu5xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hrfIkLM5; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240425184701epoutp0186cb184e8347b033979413f923a23ddd~JmlS1a69T0155801558epoutp01n
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:47:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240425184701epoutp0186cb184e8347b033979413f923a23ddd~JmlS1a69T0155801558epoutp01n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714070821;
	bh=y7q5DBA+dQSHzSzTE+I2A8FpCK4wGEC6e38FcbiE8dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrfIkLM5Ko722p/A170VQ9L01uKGMvw2rTG02DnA1u9x0WamMgT/HalDHS0rMvP56
	 hI8AZCeoWvEkZLf3AJGf9zM7W4tLPz16PCRObAHPO0tGSwLc8qQ5Tvxb2KBPP4o3io
	 Wdzj6M9q3efpD7K1wwlw75uPoZ7RUNe9HPosSrbE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240425184700epcas5p16182b7694f4eb5278108585ab6122d47~JmlRs8YMB1431014310epcas5p1D;
	Thu, 25 Apr 2024 18:47:00 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VQPwL5sKzz4x9Pt; Thu, 25 Apr
	2024 18:46:58 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F5.72.08600.225AA266; Fri, 26 Apr 2024 03:46:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240425184658epcas5p2adb6bf01a5c56ffaac3a55ab57afaf8e~JmlPT_CW42219922199epcas5p2t;
	Thu, 25 Apr 2024 18:46:58 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240425184658epsmtrp28f3c47bbf444e46e51d01a1353aca379~JmlPTSy700239002390epsmtrp2Z;
	Thu, 25 Apr 2024 18:46:58 +0000 (GMT)
X-AuditID: b6c32a44-921fa70000002198-cd-662aa522290c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	8E.C2.19234.125AA266; Fri, 26 Apr 2024 03:46:57 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240425184656epsmtip15159a669c0532a2ebf6c4175721ddf12~JmlNibyJU3082730827epsmtip1Z;
	Thu, 25 Apr 2024 18:46:55 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	hch@lst.de, brauner@kernel.org
Cc: asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH 04/10] block: avoid unpinning/freeing the bio_vec incase of
 cloned bio
Date: Fri, 26 Apr 2024 00:09:37 +0530
Message-Id: <20240425183943.6319-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240425183943.6319-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEJsWRmVeSWpSXmKPExsWy7bCmlq7SUq00g6NNuhZNE/4yW8xZtY3R
	YvXdfjaL14c/MVq8mrGWzeLmgZ1MFitXH2WyeNd6jsXi6P+3bBaTDl1jtNh7S9ti/rKn7BbL
	j/9jcuD1uDZjIovHzll32T0uny312LSqk81j85J6j903G9g8Pj69xeLRt2UVo8fnTXIBnFHZ
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVysplCXm
	lAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjMO
	fXrLUjCBu6J94QfGBsadnF2MnBwSAiYSX25cYe9i5OIQEtjNKNFz/zYThPOJUeLrpQZWOGfG
	oilMMC1TN29ghkjsZJSYtfAWVNVnRonFrzuAqjg42AQ0JS5MLgVpEBFIkXi17jUjiM0s8JRR
	4kcn2CBhgQiJ3Yuus4PYLAKqEt3zv4HFeQXMJY4dXcgIsUxeYual72A1nAIWEpMvnmaHqBGU
	ODnzCQvETHmJ5q2zwQ6SEFjLIfFr0j52iGYXiUc3f0INEpZ4dXwLVFxK4vO7vWwQdrLEpZnn
	oD4rkXi85yCUbS/ReqqfGeQXZqBf1u/Sh9jFJ9H7+wnYixICvBIdbUIQ1YoS9yY9ZYWwxSUe
	zlgCZXtI/Hw0ERq83YwS11ftZpzAKD8LyQuzkLwwC2HbAkbmVYySqQXFuempyaYFhnmp5fCI
	Tc7P3cQITrxaLjsYb8z/p3eIkYmD8RCjBAezkgjvzY8aaUK8KYmVValF+fFFpTmpxYcYTYFh
	PJFZSjQ5H5j680riDU0sDUzMzMxMLI3NDJXEeV+3zk0REkhPLEnNTk0tSC2C6WPi4JRqYBKI
	fjLvo/HUq8ed+FRdom3j1ZwkdVunvYk9s1RDKfnefM/N7kcKxMrWXZfWLuuuWPX5euCVXSVW
	4SeWK5aunNNonXqn4UWTcOBLc2NhoXjdB3e/9c1+3VKUbfNm/ZYMHvv409yWERE77rPHLzY2
	utz7/brMA78oLafZCvtlIiZ8/a5V+/dchPtpkUediqvs2zlOLXfv4P5e2ucltvWB1sXWL5du
	lt1c8e/Arnnnj1xx91/UqmjebCp62GR+1KEJxw+5KvgUP5D3P1q01W3/5ufrTmgLM/uHLjkd
	mN0/MTZq64NCQ4s8nW85RVXvH/5J6/LJnzV/k1j22hMlD3x5Sv/3btfTlJUUeP55s4b2eiWW
	4oxEQy3mouJEAOSQmbdFBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWy7bCSnK7iUq00g+nzrCyaJvxltpizahuj
	xeq7/WwWrw9/YrR4NWMtm8XNAzuZLFauPspk8a71HIvF0f9v2SwmHbrGaLH3lrbF/GVP2S2W
	H//H5MDrcW3GRBaPnbPusntcPlvqsWlVJ5vH5iX1HrtvNrB5fHx6i8Wjb8sqRo/Pm+QCOKO4
	bFJSczLLUov07RK4Mg59estSMIG7on3hB8YGxp2cXYycHBICJhJTN29g7mLk4hAS2M4ocXzH
	SmaIhLhE87Uf7BC2sMTKf8/ZIYo+MkqsO7mVsYuRg4NNQFPiwuRSkBoRgSyJvf1XwGqYBd4y
	Ssz/u4cZpEZYIEzi7Il4kBoWAVWJ7vnfmEBsXgFziWNHFzJCzJeXmHnpO9guTgELickXT4PZ
	QkA1U9csYoSoF5Q4OfMJC4jNDFTfvHU28wRGgVlIUrOQpBYwMq1iFE0tKM5Nz00uMNQrTswt
	Ls1L10vOz93ECI4VraAdjMvW/9U7xMjEwXiIUYKDWUmE9+ZHjTQh3pTEyqrUovz4otKc1OJD
	jNIcLErivMo5nSlCAumJJanZqakFqUUwWSYOTqkGpnrps0r+m4XDYqbXKeh83RDPv2LzqhUN
	GS8EM6Q/9MhNmvM/c8aH7hOVLX6TT2ypjpQ4JLjx74Qum6k/5/WKzVjzak5zz4SZnG9nf582
	b1OBT1TJZ60ThxarqH2POTUzqeVyQNPPewuVeL2C12TYFrl8MpuYonPjM6vJpzbR+SnsjIpK
	9XsXzufauain8/OZli2b2bTjvCa3rFvt9P6Alt+5P40ng1Xf1G2+sd3lldGbLVtnnX/47Y5z
	csm0O1aKm58+/HG5xmmBxJLXpvvUftnd0O6VTfoQ0nmISzru0cEe0e2bV5zTqW5+bZpwd4XU
	yb1HlvqtXG3+eFOQ26bGq59+lP9ZmSc0zcV5q8GDwskTlViKMxINtZiLihMBC75WrQQDAAA=
X-CMS-MailID: 20240425184658epcas5p2adb6bf01a5c56ffaac3a55ab57afaf8e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240425184658epcas5p2adb6bf01a5c56ffaac3a55ab57afaf8e
References: <20240425183943.6319-1-joshi.k@samsung.com>
	<CGME20240425184658epcas5p2adb6bf01a5c56ffaac3a55ab57afaf8e@epcas5p2.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

Do it only once when the parent bio completes.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index b4042414a08f..b698eb77515d 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -119,7 +119,8 @@ static void bio_integrity_uncopy_user(struct bio_integrity_payload *bip)
 	ret = copy_to_iter(bvec_virt(&src_bvec), bytes, &iter);
 	WARN_ON_ONCE(ret != bytes);
 
-	bio_integrity_unpin_bvec(copy, nr_vecs, true);
+	if (!bio_flagged((bip->bip_bio), BIO_CLONED))
+		bio_integrity_unpin_bvec(copy, nr_vecs, true);
 }
 
 static void bio_integrity_unmap_user(struct bio_integrity_payload *bip)
@@ -129,11 +130,14 @@ static void bio_integrity_unmap_user(struct bio_integrity_payload *bip)
 	if (bip->bip_flags & BIP_COPY_USER) {
 		if (dirty)
 			bio_integrity_uncopy_user(bip);
-		kfree(bvec_virt(bip->bip_vec));
+		if (!bio_flagged((bip->bip_bio), BIO_CLONED))
+			kfree(bvec_virt(bip->bip_vec));
 		return;
 	}
 
-	bio_integrity_unpin_bvec(bip->bip_vec, bip->bip_max_vcnt, dirty);
+	if (!bio_flagged((bip->bip_bio), BIO_CLONED))
+		bio_integrity_unpin_bvec(bip->bip_vec, bip->bip_max_vcnt,
+					 dirty);
 }
 
 /**
-- 
2.25.1


