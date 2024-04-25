Return-Path: <io-uring+bounces-1629-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC588B2859
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 20:47:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6466C281ECA
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 18:47:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B3614EC6D;
	Thu, 25 Apr 2024 18:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bYhiEqIM"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF27149DFD
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714070825; cv=none; b=hvPD8GzfEjeEtjaOb/oCTsnMJFp99OkHnRqj/BKmkq79qPzKxOt3uOSpswEyfnRLAxnl5S5pgyHz4J35jieBDnrkxazFmKagE7xvkWvtS4zEI90GB6qTRcZlwAnRFknM5ccFxC9OgfPJSleciAkj6G6wUUkCdV6Vfk4riBaBKfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714070825; c=relaxed/simple;
	bh=0zuD9gszrxLOfK8HJKkiv8NVBsKlq8lupJk3KzBU8ok=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=RcfDC/vEoFI0nJc6O7wiZohwddcJ1zXEA+YquTRlIgCp1y/1SCzQkMkuM/B6kriih2gJOUUNzzm1Mt4AC5TPzL25zvE7jj1+q1D9uuMqBBcuBH3ntO1WLG8C41ndQZZCqeoBTopqUPy60RsWICrEvVe0Ju6wvRpe097w/V0BAqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bYhiEqIM; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240425184655epoutp01bc41d301f92aacab604621d23d08905c~JmlM4xcxq3260532605epoutp016
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:46:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240425184655epoutp01bc41d301f92aacab604621d23d08905c~JmlM4xcxq3260532605epoutp016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714070815;
	bh=aRbU1XKPvEeuwgaCiIvDBDmtfNhGzLeEHTExPWAIynM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYhiEqIMOYIsKPXeih/PLo3m+M127zA+bL3KHmuFsV5BhkIi1kNU0KCCdIWqJzp+9
	 sy6VfdnpHMh/JT/4WEFJ6Vr12xjQUAUqwUBslTNO1rZn/TG9BWxWaatTDgyxCrJMQn
	 rTUrACELQDNZo9/qN7n0tt5VidqTtQbbpFwcvCmw=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240425184654epcas5p26f282413236cf15e1c992c985ea04949~JmlLwLGk_2738327383epcas5p2j;
	Thu, 25 Apr 2024 18:46:54 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4VQPwD390Rz4x9Pp; Thu, 25 Apr
	2024 18:46:52 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C9.E6.19431.C15AA266; Fri, 26 Apr 2024 03:46:52 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240425184651epcas5p3404f2390d6cf05148eb96e1af093e7bc~JmlJoQfkR0824808248epcas5p3f;
	Thu, 25 Apr 2024 18:46:51 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240425184651epsmtrp245499ce6745e46d2ab1d88b3388c1748~JmlJnUZsw0238902389epsmtrp2b;
	Thu, 25 Apr 2024 18:46:51 +0000 (GMT)
X-AuditID: b6c32a50-ccbff70000004be7-c0-662aa51c7ff8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	8C.C2.19234.B15AA266; Fri, 26 Apr 2024 03:46:51 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240425184650epsmtip143df1e6819cfa539ae1ae7996e97cad2~JmlH25CSx3053530535epsmtip1s;
	Thu, 25 Apr 2024 18:46:49 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	hch@lst.de, brauner@kernel.org
Cc: asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH 01/10] block: set bip_vcnt correctly
Date: Fri, 26 Apr 2024 00:09:34 +0530
Message-Id: <20240425183943.6319-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240425183943.6319-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0wTZxjH896d1ytbyVnYeNMswk6XIBvQjlKuC4hGQi7OLYDbPywGanvS
	hvZa+8PhTEaDAylkIMgQCugwOkMJ6JDxowLREgaIdJNFl7KAWRQkEN0Kg+lmYS3HNv/7PG+e
	7/Pj+z4EKr6GSwgdZ2XNnEpP4WFYz/DuuPg3LscdlXa7IuiSMwGUbnb1ALp9phqnl4aXAb3Y
	0IHTvpv9CN3WPoLQT0u9GD2y8QSnaz33AT04/TZ94Zs5AX1ldB3ZK2LuN9RgTL9zRsD8NGlj
	ulwOnLl+qZi54bPjjH9uGmOqul2AWenakSXMLUzVsioNa45hObVRo+MK0qj3D+Xtz0tWSGXx
	MiWdQsVwKgObRmUczIrP1OmDU1Mxx1V6W/ApS2WxUIl7Us1Gm5WN0Rot1jSKNWn0JrkpwaIy
	WGxcQQLHWt+TSaXvJgcT8wu1v3tLcNM9omjuXtU2O2gWVACCgKQc1tSdrABhhJgcAPCccw3h
	g2UAh8bqsQog5IPTE+IQhwS3HXPb+KR+AJ/99QXOBysAdkw+2CyLk7vhj2dtIUEkqYGLnUsg
	xCg5FxQ4kBBHBAutzrs33zHyLXih1L8pFZEp0G/X8r2iYePUn4IQC0kanr07sckicjscb3yE
	8SWj4anvmtDQCJBsI+BC1x2UF2fAJ3U/YzxHwMXRbgHPErjydBDnWQ2nGr0Iz1b4cODWFqfD
	0tvVaGgeNLjKVXci3yscfvn3I4Q3TgTLy7YseRPO1oYsCXEU/LXh0hYzMDDaB3h3KgFsu/sc
	OwOinS+t4HxpBef/3b4GqAtIWJPFUMCqk02yeI799L9vVRsNXWDzdOOy+kD7tUCCByAE8ABI
	oFSkyOePPSoWaVQnPmPNxjyzTc9aPCA56HENKnlNbQzePmfNk8mVUrlCoZArkxQyKkq0VNqi
	EZMFKitbyLIm1vyvDiGEEjviPO8LO3Ijx1aUI0n/oTn7cacQvDjxsEW4b/oAE5tfvS9Ruye/
	5M5Kyq69r1csmJub6IiOqnHD4WOGBl1x7exhx+rEufFCymOZ1x1xPLj1IinsncXp1Y+P49Hf
	e/u+fX7dlU21MmjrWEm5ryxct3Ok6cOhSUWmveqUW1lPEqbAKt5e3Pvs8R872Yx05VCeuzJQ
	qS0nq9D13Lrt7s8XsJq0Ywd3fbIxP3N5jduoS9oQtn4k7VFMGZeHoz5wn55dt+9PfeWiv7fh
	Ynanr+1V746bZb+UKlMPrFl/Q7jeNHI0MfeqOjyTxL4SzxaNRXpTByaN2Ih6MLbTfb4+vuVk
	IIfCLFqVLA41W1T/AKCVWG9DBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWy7bCSnK70Uq00gxe/jC2aJvxltpizahuj
	xeq7/WwWrw9/YrR4NWMtm8XNAzuZLFauPspk8a71HIvF0f9v2SwmHbrGaLH3lrbF/GVP2S2W
	H//H5MDrcW3GRBaPnbPusntcPlvqsWlVJ5vH5iX1HrtvNrB5fHx6i8Wjb8sqRo/Pm+QCOKO4
	bFJSczLLUov07RK4Mj6ca2IruMpR8fRqH2sD4xz2LkZODgkBE4lTnU9Zuxi5OIQEtjNK9Pf9
	ZIZIiEs0X/sBVSQssfLfc3aIoo+MEluvfALq4OBgE9CUuDC5FKRGRCBLYm//FbAaZoG3jBLz
	/+4BGyQMtOHrs12MIDaLgKrE/NaP7CC9vALmEh8bMiDmy0vMvPQdbBengIXE5IunwWwhoJKp
	axaBtfIKCEqcnPmEBcRmBqpv3jqbeQKjwCwkqVlIUgsYmVYxiqYWFOem5yYXGOoVJ+YWl+al
	6yXn525iBMeKVtAOxmXr/+odYmTiYDzEKMHBrCTCe/OjRpoQb0piZVVqUX58UWlOavEhRmkO
	FiVxXuWczhQhgfTEktTs1NSC1CKYLBMHp1QDUybXua97Nu+e6vNFx4U3k2/aiu3mN2789Zp7
	UIz75fQb94xOV20zOMLwnLdtuULRCoGy1bf3vjXKSqi78sF6Na/6lBtXkm6tiauO4xRcrubH
	P/uhhPECE9fGH0lrXVcZ/klfff3Ig/L4oB/rxMWY/daq6dTyP8ir0Ep5vXnL/5k2G//f4g6u
	FjFdO+MEs2vYnIrNuuxSy/iPRkzOKZwYLD47q+9p2vq1toxz42tnLvi/93JQ5PJZGzYpRwf9
	iLfZGH95+Snzgjp3UeOkJYpsWqwLTzMKGa+ZE/zadNPc4naHw/sLchcVf1ooaDCncYX1p+JF
	ocIN3wsPeP53yPrsfLLSeNbD49uj9momhbz49V2JpTgj0VCLuag4EQD+boJzBAMAAA==
X-CMS-MailID: 20240425184651epcas5p3404f2390d6cf05148eb96e1af093e7bc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240425184651epcas5p3404f2390d6cf05148eb96e1af093e7bc
References: <20240425183943.6319-1-joshi.k@samsung.com>
	<CGME20240425184651epcas5p3404f2390d6cf05148eb96e1af093e7bc@epcas5p3.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

Set the bip_vcnt correctly in bio_integrity_init_user and
bio_integrity_copy_user. If the bio gets split at a later point,
this value is required to set the right bip_vcnt in the cloned bio.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 2e3e8e04961e..e3390424e6b5 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -254,6 +254,7 @@ static int bio_integrity_copy_user(struct bio *bio, struct bio_vec *bvec,
 
 	bip->bip_flags |= BIP_INTEGRITY_USER | BIP_COPY_USER;
 	bip->bip_iter.bi_sector = seed;
+	bip->bip_vcnt = nr_vecs;
 	return 0;
 free_bip:
 	bio_integrity_free(bio);
@@ -275,6 +276,7 @@ static int bio_integrity_init_user(struct bio *bio, struct bio_vec *bvec,
 	bip->bip_flags |= BIP_INTEGRITY_USER;
 	bip->bip_iter.bi_sector = seed;
 	bip->bip_iter.bi_size = len;
+	bip->bip_vcnt = nr_vecs;
 	return 0;
 }
 
-- 
2.25.1


