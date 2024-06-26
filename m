Return-Path: <io-uring+bounces-2347-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D696917FF7
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 13:42:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70A5E1C23699
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 11:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C514A17FAAE;
	Wed, 26 Jun 2024 11:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hRXcryWv"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C6117F4EB
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719402148; cv=none; b=A/xcB0yHeg8f9WupsADJdF2XCbutQnfXYuJzBol8Yu0g9Q5nUfNCcwrdQEgvKF9fmQuXgYPxbQtPrALc52ClDj28TgXVk097ao1QJD8n/7Sc7QnOluTTflvnAy2QTj5stDEle4g/sbTxovL4FMcZ/GxVlNAMKd/0HPfVrH0XleA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719402148; c=relaxed/simple;
	bh=8hu2gELgAaPO9ThdtDrVOBEQrck8AWf/89L08gXHjvo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ltyuaBbeXGesZxu1gXiDTXu5kfanPvYdMNtO/0Qjacdv3Ech039CScqKA9/iwQl/zLMc6QLD4FZWBeP0/m4i/iNXYyCpHuo70/ihfqHbQlynvd6URj6IzVP3F8/mUKp8pSFkepMQ6VZOxjAX5CSl/c/4Y8eG3EqeY7Rwxoq2E+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hRXcryWv; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240626114225epoutp0362acfbb932333fe9bf8fe7d590db7868~ciyQg2rHB0792607926epoutp03Q
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:42:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240626114225epoutp0362acfbb932333fe9bf8fe7d590db7868~ciyQg2rHB0792607926epoutp03Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719402145;
	bh=nXGPzER1JF01Eq/Va1G8I1f4os1fOKXD7EF9v6r4iM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRXcryWvbC7asq2VcYxnTBbOYtFDaTYfkNgjxiJlp2tLW/cX4zDKGCyauZFQU2R5G
	 5ruNTFaba0MTGGQamO/0P5TJG87NOReVLPFMUonV1fU4Pvy1DJsihVaeWYjIc+PyzS
	 sGXSo0/GHkpizyFleaeRvRsQD2vaTgET+K2aQd64=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240626114224epcas5p47a3e3da5c0bc0c406bfb9ed989ec64e6~ciyP1O5oC0207802078epcas5p4I;
	Wed, 26 Jun 2024 11:42:24 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4W8KYp3v2nz4x9Pp; Wed, 26 Jun
	2024 11:42:22 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EC.75.19174.E9EFB766; Wed, 26 Jun 2024 20:42:22 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240626101519epcas5p163b0735c1604a228196f0e8c14773005~chmOOAph61565315653epcas5p1H;
	Wed, 26 Jun 2024 10:15:19 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240626101519epsmtrp1fd3887d9cd4992b3258841181ca9ce27~chmONJVY91023810238epsmtrp1k;
	Wed, 26 Jun 2024 10:15:19 +0000 (GMT)
X-AuditID: b6c32a50-87fff70000004ae6-ed-667bfe9ebdf3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D9.6A.19057.73AEB766; Wed, 26 Jun 2024 19:15:19 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240626101518epsmtip1c3b688bf7716f6795f14ab17527fc687~chmMm6_kR0370603706epsmtip1C;
	Wed, 26 Jun 2024 10:15:18 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v2 05/10] block: introduce BIP_CLONED flag
Date: Wed, 26 Jun 2024 15:36:55 +0530
Message-Id: <20240626100700.3629-6-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240626100700.3629-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAJsWRmVeSWpSXmKPExsWy7bCmpu68f9VpBvO2yFrMWbWN0WL13X42
	i5WrjzJZvGs9x2Jx9P9bNotJh64xWuy9pW0xf9lTdovlx/8xWUzsuMrkwOWxc9Zddo/LZ0s9
	Nq3qZPPYvKTeY/fNBjaPj09vsXi833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DOVFIoS8wpBQoFJBYXK+nb2RTll5ak
	KmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ+y63cxasIK3Ys/OLsYGxudc
	XYycHBICJhLnHtxi7mLk4hAS2MMosefjXFYI5xOjxPWerVDON0aJCfNXsMC0rJ0yixXEFhLY
	yyhxdF4qRNFnRomvjS2MIAk2AXWJI89bwWwRgVqJla3T2UGKmAUaGCW6J3xnB0kIC1hJXPp7
	Hmg5BweLgKrEtEtg9bwCFhLfz5xmhVgmLzHzEkQ5p4ClxJ3N26FqBCVOznwCdhAzUE3z1tlg
	P0gITOWQ2PL6KyPITAkBF4ln73wh5ghLvDq+hR3ClpJ42d8GZadL/Lj8lAnCLpBoPraPEcK2
	l2g91Q92GrOApsT6XfoQYVmJqafWMUGs5ZPo/f0EqpVXYsc8GFtJon3lHChbQmLvuQYo20Pi
	3LqJ0ADtYZR4eXk2ywRGhVlI3pmF5J1ZCKsXMDKvYpRKLSjOTU9NNi0w1M1LLYfHcnJ+7iZG
	cNLVCtjBuHrDX71DjEwcjIcYJTiYlUR4Q0uq0oR4UxIrq1KL8uOLSnNSiw8xmgLDeyKzlGhy
	PjDt55XEG5pYGpiYmZmZWBqbGSqJ875unZsiJJCeWJKanZpakFoE08fEwSnVwOR7JO78mjWq
	F25vv2F2lH2F2JP92lbP7HoyOGYtfm1VsvLsn3Idtt6u+qQFimGiO5gS5RcsbnbcbOryqiFh
	nXvzwo0dJ/5phSuHp1xg6FVWT66dcKZtz53pZk0dl1baq0t+ObPpW1GIsNqKNPeMvh2dSyPD
	+38vEv0ge/P0nUAttlM1U4yi/72vb9UEuvRbTSkv31evPe9TzjIk7f3mmm4iqJ9pPrG2/PhL
	btl/K5LcLmzK7FimYHwofWHmStH5kqye2q89D5RqfJ79Jn3qAq3fPa6NrP+WT/Y5+dH0g9wh
	i/z3E/amKyyf/iA/JP9DrrbFyfgFNarPVD6+vjfxd5mDgfWCkylGF03XZVg7KrEUZyQaajEX
	FScCAOfRShtDBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSnK75q+o0gxtrdS3mrNrGaLH6bj+b
	xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpu8Xy4/+YLCZ2XGVy4PLYOesuu8fls6Ue
	m1Z1snlsXlLvsftmA5vHx6e3WDze77vK5tG3ZRWjx+dNcgGcUVw2Kak5mWWpRfp2CVwZu243
	sxas4K3Ys7OLsYHxOVcXIyeHhICJxNops1i7GLk4hAR2M0oc2nGNGSIhIXHq5TJGCFtYYuW/
	5+wQRR8ZJd61XAErYhNQlzjyvJURJCEi0MoocWBqC5jDLNDCKDG3tYUdpEpYwEri0t/zQB0c
	HCwCqhLTLoFN5RWwkPh+5jQrxAZ5iZmXvoOVcwpYStzZvB2sRgio5sHzZlaIekGJkzOfsIDY
	zED1zVtnM09gFJiFJDULSWoBI9MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgyNDS
	2sG4Z9UHvUOMTByMhxglOJiVRHhDS6rShHhTEiurUovy44tKc1KLDzFKc7AoifN+e92bIiSQ
	nliSmp2aWpBaBJNl4uCUamAKnqtV5diQwRkfYNPmOdHZoyvWi18yL0qv+0Da5yWbqneWJRdX
	ps214tto656VPPWPVqGaopz3fJH6OM8LFU9dFP663astTP9b8a8l+wNDT1PvRN6IAxv2Wtux
	N/pz7vZftPaiRIjyA9v6o/veKk3zYt02y3XF/IIZ8fy/4+5/Z7MWKAj9mxm/+9Myj55/Rftl
	v3cYZ239e9LkeNW2H4mmDKfN/900rtoiFW+TKWfFbP6c4cqTR/IXlk06nj2vQjQ/uunms7kB
	r7dY1jN7eIZ/4GrwPHrg3eLfDjtT3n81LkrdySgw4UpaQm7CtoCZ+3KW9OqFLtmfVpH7SzXn
	1+nNy2+tK8iNWZJrteBlkRJLcUaioRZzUXEiAHW0shj7AgAA
X-CMS-MailID: 20240626101519epcas5p163b0735c1604a228196f0e8c14773005
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240626101519epcas5p163b0735c1604a228196f0e8c14773005
References: <20240626100700.3629-1-anuj20.g@samsung.com>
	<CGME20240626101519epcas5p163b0735c1604a228196f0e8c14773005@epcas5p1.samsung.com>

From: Kanchan Joshi <joshi.k@samsung.com>

Set the BIP_CLONED flag when bip is cloned.
Use that flag to ensure that integrity is freed for cloned user bip.

Note that a bio may have BIO_CLONED flag set but it may still not be
sharing the integrity vecs.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c | 5 ++++-
 include/linux/bio.h   | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 845d4038afb1..8f07c4d0fada 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -147,7 +147,8 @@ void bio_integrity_free(struct bio *bio)
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 	struct bio_set *bs = bio->bi_pool;
 
-	if (bip->bip_flags & BIP_INTEGRITY_USER)
+	if (bip->bip_flags & BIP_INTEGRITY_USER &&
+	    !(bip->bip_flags & BIP_CLONED))
 		return;
 	if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
 		kfree(bvec_virt(bip->bip_vec));
@@ -662,6 +663,8 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 	bip->bip_iter = bip_src->bip_iter;
 	bip->bip_flags = bip_src->bip_flags & ~(BIP_BLOCK_INTEGRITY |
 						BIP_COPY_USER);
+	bip->bip_flags |= BIP_CLONED;
+
 	return 0;
 }
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 818e93612947..44226fcb4d00 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -329,6 +329,7 @@ enum bip_flags {
 	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
 	BIP_INTEGRITY_USER	= 1 << 5, /* Integrity payload is user address */
 	BIP_COPY_USER		= 1 << 6, /* Kernel bounce buffer in use */
+	BIP_CLONED		= 1 << 7, /* Indicates that bip is cloned */
 };
 
 /*
-- 
2.25.1


