Return-Path: <io-uring+bounces-2346-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F293917FF3
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 13:42:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31C881C21C38
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 11:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949AF17F50F;
	Wed, 26 Jun 2024 11:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="eUZfU5Ar"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6079317DE11
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719402132; cv=none; b=YZ8sakPx7hc/V8W3H7Pg56Lx2XjvSbjyMhgGgK9HMaynA3N2Z4x6eMJfo0T5eNlkm3VZyAy5ynlRSC/c/59ZiFjva9/elDwozAX12+O0LZdzDuQHQ06JH7IQnsRoCl2t+XkNDcDeAf/wU4tkgh8YwTEsBKSrwihEziVAVhaOTl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719402132; c=relaxed/simple;
	bh=/abOTLXTWq6MnTNy0iTo95+c8un+ioDHLrWRw9LnUYo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=R/hWHSCkVyjHq6A85BvrIVB+HuEQkKHuAhr5wdQMV3XWbkl7NIOU0wz12+vgWio66x/rTBqdgR0K4H9PvL7HK41vmAZ9grmyNsc8hn4SYtbBJ2vRMmrwwDbgPOyZP6P7aaTHeFXo0jmB4vehY9gcfnCw4lShGVKPRdOawn8kNL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=eUZfU5Ar; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240626114207epoutp03bce5498727ef02e1037f32b3a00f68f4~ciyAkI0_F0548205482epoutp03I
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:42:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240626114207epoutp03bce5498727ef02e1037f32b3a00f68f4~ciyAkI0_F0548205482epoutp03I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719402127;
	bh=xg1hUcooavawNWfL5YZpGfpv2h4Dx6Xk84lE11bhOzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUZfU5ArMlR2jfRNg3OA59bzYxiu4nuc5Geuadf2xALych19fZEjRZbcdEhOoc2nf
	 f/QiqUSry3AaUP9kfWTYuFeXusAg768CmZgE8h8+/Y534tr91QxYDYdyXmrwv3LlMu
	 Njj95P1lJf5PAfIlpDNgdLh7Vxxz1WQpnYm4ut4A=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240626114207epcas5p2348478597814e6bdf5adbe9223618dac~cix-79sCc0959509595epcas5p2i;
	Wed, 26 Jun 2024 11:42:07 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4W8KYT3mPYz4x9Pp; Wed, 26 Jun
	2024 11:42:05 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BC.08.09989.D8EFB766; Wed, 26 Jun 2024 20:42:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240626101516epcas5p19fb40e8231d1832cab3d031672f0109e~chmK1jLgO0829808298epcas5p1j;
	Wed, 26 Jun 2024 10:15:16 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240626101516epsmtrp13052680d2b3b838252dd658696b5d8b2~chmK02-LG1024010240epsmtrp1c;
	Wed, 26 Jun 2024 10:15:16 +0000 (GMT)
X-AuditID: b6c32a4a-bffff70000002705-33-667bfe8d61ce
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	DE.4C.18846.43AEB766; Wed, 26 Jun 2024 19:15:16 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240626101514epsmtip132e399ece14b53def07176d7d9a70188~chmI6SqZH0147101471epsmtip1Q;
	Wed, 26 Jun 2024 10:15:13 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v2 03/10] block: copy bip_max_vcnt vecs instead of bip_vcnt
 during clone
Date: Wed, 26 Jun 2024 15:36:53 +0530
Message-Id: <20240626100700.3629-4-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240626100700.3629-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCJsWRmVeSWpSXmKPExsWy7bCmum7vv+o0g8ffxC2aJvxltpizahuj
	xeq7/WwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFsuP/2OymNhxlcmB22PnrLvs
	HpfPlnpsWtXJ5rF5Sb3H7psNbB4fn95i8Xi/7yqbR9+WVYwenzfJBXBGZdtkpCampBYppOYl
	56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAN2qpFCWmFMKFApILC5W0rez
	KcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjO+P35BVvBFo6KPbse
	sDYw/mfrYuTkkBAwkTjbu5C1i5GLQ0hgN6PEh6atLCAJIYFPjBKvHyhDJIDsL4dvMsJ0vN26
	GapjJ6PE+f+TmCCcz4wSB5ffA2tnE1CXOPK8FaxDRKBWYmXrdHaQImaBpUA7HlxnBkkIC0RJ
	rFjfyARiswioSrycsBrsKF4BC4nWz6+gDpSXmHnpOzuIzSlgKXFn83ZGiBpBiZMzn4AtYwaq
	ad46mxlkgYTATA6JeSt2ASU4gBwXia7NghBzhCVeHd/CDmFLSbzsb4Oy0yV+XH7KBGEXSDQf
	2wf1pr1E66l+ZpAxzAKaEut36UOEZSWmnlrHBLGWT6L39xOoVl6JHfNgbCWJ9pVzoGwJib3n
	GqBsD4nei5fZIcHbwyhxuV11AqPCLCTfzELyzSyEzQsYmVcxSqYWFOempxabFhjlpZbDIzk5
	P3cTIzj5anntYHz44IPeIUYmDsZDjBIczEoivKElVWlCvCmJlVWpRfnxRaU5qcWHGE2BwT2R
	WUo0OR+Y/vNK4g1NLA1MzMzMTCyNzQyVxHlft85NERJITyxJzU5NLUgtgulj4uCUamAqqLO8
	tKDyhVj8s+XchZz2i58crPvwxGPhcwb3p1tXiS7nTOaOXMTH8N/t+ZvEesePOVbTfvfqlBxr
	CRf6fd5M5kht3MN+sxRt50jHqsDti3fr+3u5+fAHOGQ1B0iu+WrWmvM4fErx25Vc96dll/Hk
	J0cxNPv/6QjlXFqZE/zqqdt7/Wzn29r7pHJz3RUP/lj54tL9j4Vih+tZTsgVlP6Y01NQPy11
	9sVu/m0J3qlWZ0y/aSfWv5lUeTtjmhOX3HL3N4yvf2j9uDQlzdv41vqfs9aWhSrf+z7rXrto
	1tK3mn82Xd27hPn9XKsLm87tsfZ+kje/5Hegp3qZ8pTwA7/uhtoHCKbbNLvNmbOer0mJpTgj
	0VCLuag4EQDUDIsyRwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWy7bCSnK7Jq+o0gxvvuC2aJvxltpizahuj
	xeq7/WwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFsuP/2OymNhxlcmB22PnrLvs
	HpfPlnpsWtXJ5rF5Sb3H7psNbB4fn95i8Xi/7yqbR9+WVYwenzfJBXBGcdmkpOZklqUW6dsl
	cGX8/vyCrWALR8WeXQ9YGxj/s3UxcnJICJhIvN26mbWLkYtDSGA7o8SH7vUsEAkJiVMvlzFC
	2MISK/89Z4co+sgoce34PHaQBJuAusSR562MIAkRgVZGiQNTW8AcZoGVjBK3F71gAqkSFoiQ
	+N24F2wfi4CqxMsJq8FsXgELidbPr6DukJeYeek72FROAUuJO5u3g60WAqp58LyZFaJeUOLk
	zCdg5zED1Tdvnc08gVFgFpLULCSpBYxMqxhFUwuKc9NzkwsM9YoTc4tL89L1kvNzNzGCo0Mr
	aAfjsvV/9Q4xMnEwHmKU4GBWEuENLalKE+JNSaysSi3Kjy8qzUktPsQozcGiJM6rnNOZIiSQ
	nliSmp2aWpBaBJNl4uCUamBy+GDx9MnWu3rNhxYt5sh5EF557Fk0w32hiRbb+x985P1WrPBQ
	0a3p3i3De/e7A6bHtd3aXLVmGkPY5AC3Dyvuh255f32DW3DGi/O1+Ud8Ta7cZeoJ/GP+Wdtk
	q0CAi9v63D8LrktkHGP6mFeXev3yTn63xN+nFh1NOOnio6dwy6jrioKq1qod/qzyK6psrrLs
	blTecPrQ/SaulO0b3nfOX26Y8+6D6BHz6vQf5fPD5CMFDybzvgrrORvvXOXgkvH7aaDt+dfX
	z8nH1nptM1WpmXMsIj/e51dHa/BOVXWJxsg7kQ+KWlYf1d0x4fvOrauF36+aa5m7fILwrD5n
	f+P7vKv9ej9fKVn++6ebeq23EktxRqKhFnNRcSIAfis1Jv0CAAA=
X-CMS-MailID: 20240626101516epcas5p19fb40e8231d1832cab3d031672f0109e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240626101516epcas5p19fb40e8231d1832cab3d031672f0109e
References: <20240626100700.3629-1-anuj20.g@samsung.com>
	<CGME20240626101516epcas5p19fb40e8231d1832cab3d031672f0109e@epcas5p1.samsung.com>

If bio_integrity_copy_user is used to process the meta buffer, bip_max_vcnt
is one greater than bip_vcnt. In this case bip_max_vcnt vecs needs to be
copied to cloned bip.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index af79d9fbf413..5e7596b74ef1 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -647,12 +647,12 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	BUG_ON(bip_src == NULL);
 
-	bip = bio_integrity_alloc(bio, gfp_mask, bip_src->bip_vcnt);
+	bip = bio_integrity_alloc(bio, gfp_mask, bip_src->bip_max_vcnt);
 	if (IS_ERR(bip))
 		return PTR_ERR(bip);
 
 	memcpy(bip->bip_vec, bip_src->bip_vec,
-	       bip_src->bip_vcnt * sizeof(struct bio_vec));
+	       bip_src->bip_max_vcnt * sizeof(struct bio_vec));
 
 	bip->bip_vcnt = bip_src->bip_vcnt;
 	bip->bip_iter = bip_src->bip_iter;
-- 
2.25.1


