Return-Path: <io-uring+bounces-2345-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1416917FF2
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 13:42:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F33751C22C7E
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 11:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ECBE17F4F0;
	Wed, 26 Jun 2024 11:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gnq1+7sh"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7974B17F4E8
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719402125; cv=none; b=UqONRAvDgFhOzXMJ5QRVhcc1S3JiPu2R477Y+zQTUwsM1zLg7RYG8bOkeuE8CDc2reaK8fFsMawmYj8fvmZVhkBKV+Hlxr/xt1nzfpINmwi/mJzLSfkUTE7Sd+cjNC0FoAmnopb2i5FNVgFwpmMjsjiCUdmZxpgoCzOEd1wHaaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719402125; c=relaxed/simple;
	bh=bDM2mzF+qYf4eY9qLWRjxBr8gqKFq4pksnmaibWnQtw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=HwnqjPZS132udkGB0yFlkNwYsfML4qVGRk+ASLzD4u+v4Olk6u86j7Tn0XP6zymkpBbHhhN0E9i9P1oBOHPA2dzBNrteRJgTPxkCWEZgN6uDIT/Sq9b/dokqqeQuORdTpAHbua4HXj8OTRrOk8EJLFziMjOGnqdWNfp5XwQhb3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gnq1+7sh; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240626114200epoutp02d2c8d6c2504afdb0f250ae170d90ac23~cix54obkT0090100901epoutp02l
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:42:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240626114200epoutp02d2c8d6c2504afdb0f250ae170d90ac23~cix54obkT0090100901epoutp02l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719402120;
	bh=CddwOBmVKHfCIekEQ0xwuipaf4radU9oHxoG3DHT28I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnq1+7shfd+oITixvUjmZ4W3xtAcCtdITQSIMn2cv/PzwOBGxQI7IchYE1ObDxj+/
	 CmPQpsw9QMlv1GBnnkxn32tr45JZNf7ZPMmqxLA7nz+OE2pTyzOVcfvCz5HH//g+lA
	 0qYVtJO+is6uV8cTHY9MfB0JBTcTiW48Cgdc1KKw=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240626114200epcas5p3d0f26fedd94965b2a16a9a978e7d1d34~cix5anObS2803828038epcas5p3D;
	Wed, 26 Jun 2024 11:42:00 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4W8KYK6Zjkz4x9Pp; Wed, 26 Jun
	2024 11:41:57 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	29.08.09989.58EFB766; Wed, 26 Jun 2024 20:41:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240626101513epcas5p10b3f8470148abb10ce3edfb90814cd94~chmIrqYUZ0829808298epcas5p1f;
	Wed, 26 Jun 2024 10:15:13 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240626101513epsmtrp2eeaa7a869685d6ca50a408eaa6d5ffab~chmIq6IEq1237112371epsmtrp2N;
	Wed, 26 Jun 2024 10:15:13 +0000 (GMT)
X-AuditID: b6c32a4a-bffff70000002705-25-667bfe853d33
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7E.6B.29940.13AEB766; Wed, 26 Jun 2024 19:15:13 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240626101512epsmtip15b7099c4bf924e901811582bd44caed0~chmG6euMQ0147101471epsmtip1P;
	Wed, 26 Jun 2024 10:15:11 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v2 02/10] block: set bip_vcnt correctly
Date: Wed, 26 Jun 2024 15:36:52 +0530
Message-Id: <20240626100700.3629-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240626100700.3629-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKJsWRmVeSWpSXmKPExsWy7bCmpm7rv+o0g8nrjS2aJvxltpizahuj
	xeq7/WwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFsuP/2OymNhxlcmB22PnrLvs
	HpfPlnpsWtXJ5rF5Sb3H7psNbB4fn95i8Xi/7yqbR9+WVYwenzfJBXBGZdtkpCampBYppOYl
	56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAN2qpFCWmFMKFApILC5W0rez
	KcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjO6Fr8lr3gOkfF+qkz
	2RoYF7B3MXJySAiYSFy+eYsVxBYS2M0o8fujQhcjF5D9iVFi2cm9bBDON0aJ21vXwnX0Nxxg
	gUjsZZTYM/8IE4TzmVHi2Kx1jCBVbALqEkeet4LZIgK1Eitbp7ODFDELLGWU+PDgOjNIQljA
	XGLi1d9gY1kEVCUetXxiArF5BSwktr+/wQKxTl5i5qXvYDWcApYSdzZvZ4SoEZQ4OfMJWA0z
	UE3z1tnMIAskBOZySPx7uxZoEAeQ4yIx/xcjxBxhiVfHt0C9ICXx+R3IbyB2usSPy0+ZIOwC
	ieZj+6Dq7SVaT/Uzg4xhFtCUWL9LHyIsKzH11DomiLV8Er2/n0C18krsmAdjK0m0r5wDZUtI
	7D3XAGV7SJz99IoRElg9jED3/GCcwKgwC8k7s5C8Mwth9QJG5lWMkqkFxbnpqcWmBUZ5qeXw
	WE7Oz93ECE6/Wl47GB8++KB3iJGJg/EQowQHs5IIb2hJVZoQb0piZVVqUX58UWlOavEhRlNg
	eE9klhJNzgdmgLySeEMTSwMTMzMzE0tjM0Mlcd7XrXNThATSE0tSs1NTC1KLYPqYODilGph2
	vK6L1hZ98v7sU3Ndc1WpDROb57rFHrG/knziWZKz54pdZ+8deu74dNp+zcakxwsZDqza6GXl
	xnjlYvez21WMDG3usosUtX1Ormk/s5B3x6p35qvjJwfPYzqpYTGDzXSG8TFW071vtmTP1eg7
	um/rstluRoveb+DrqlVc4Z61VW3WlW9GZ98ujp+SNHs2a4TMjX/xzIX3DeZ1er0+HLTFZdaK
	S2wX5ZUn/lM1uaki9JzzVv+V/re/rs0LrXC+ccXsnXK8kqcfz+Et1rfe5X79+vad/VE9ht+B
	TbFLH5dJ+rM7nnRtvfHhzsl4e48PSp5nV/5fbZ0RHrP1i1X2stRL51l3aR+1vqI8ccu1vtn2
	rUosxRmJhlrMRcWJAH857pxIBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWy7bCSnK7hq+o0g2OnTSyaJvxltpizahuj
	xeq7/WwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFsuP/2OymNhxlcmB22PnrLvs
	HpfPlnpsWtXJ5rF5Sb3H7psNbB4fn95i8Xi/7yqbR9+WVYwenzfJBXBGcdmkpOZklqUW6dsl
	cGV0LX7LXnCdo2L91JlsDYwL2LsYOTkkBEwk+hsOsHQxcnEICexmlHhwdDcbREJC4tTLZYwQ
	trDEyn/P2SGKPjJKPNq7HKybTUBd4sjzVkaQhIhAK6PEgaktYA6zwEpGiduLXjCBVAkLmEtM
	vPobrINFQFXiUcsnsDivgIXE9vc3WCBWyEvMvPQdrIZTwFLizubtYKuFgGoePG9mhagXlDg5
	8wlYPTNQffPW2cwTGAVmIUnNQpJawMi0ilEytaA4Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMj
	OEq0NHcwbl/1Qe8QIxMH4yFGCQ5mJRHe0JKqNCHelMTKqtSi/Pii0pzU4kOM0hwsSuK84i96
	U4QE0hNLUrNTUwtSi2CyTBycUg1M60paLqz4qGbaPqlBUb7t4O+avsyVJWEHm1+3tEdu7bI7
	XcPWKHAyyLvYXUB5Zd77k1s3m8TX8KyK5/kToejXJ70m7UPQ2teV9z5Xc7rd99y4XjtJ9N2r
	9is52cn1zxIcbRImbXNMP8aYIHvk05yISYFPPgmJbjjyPHxlW1TskmlHJC1VT6d9/X+G34Kx
	on32VH+h5Lg1WVq24vzm4eyxAiUyu+U+Bmea9WZrruHMfya9x07A7vYeOcsFjTOsIxcY5uXd
	Dnu42ugfq9iWWy8nys+ZsE2BVfQ1/8kj2/pVTfN2eakbf9m3/Oty0zOaD9vXKz03mSfZ8b/E
	yGFnzMKrc2bUczwzkkx49H9G1hMlluKMREMt5qLiRABZ/IQIAQMAAA==
X-CMS-MailID: 20240626101513epcas5p10b3f8470148abb10ce3edfb90814cd94
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240626101513epcas5p10b3f8470148abb10ce3edfb90814cd94
References: <20240626100700.3629-1-anuj20.g@samsung.com>
	<CGME20240626101513epcas5p10b3f8470148abb10ce3edfb90814cd94@epcas5p1.samsung.com>

Set the bip_vcnt correctly in bio_integrity_init_user and
bio_integrity_copy_user. If the bio gets split at a later point,
this value is required to set the right bip_vcnt in the cloned bio.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index dab70370b2c7..af79d9fbf413 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -276,6 +276,7 @@ static int bio_integrity_copy_user(struct bio *bio, struct bio_vec *bvec,
 
 	bip->bip_flags |= BIP_INTEGRITY_USER | BIP_COPY_USER;
 	bip->bip_iter.bi_sector = seed;
+	bip->bip_vcnt = nr_vecs;
 	return 0;
 free_bip:
 	bio_integrity_free(bio);
@@ -297,6 +298,7 @@ static int bio_integrity_init_user(struct bio *bio, struct bio_vec *bvec,
 	bip->bip_flags |= BIP_INTEGRITY_USER;
 	bip->bip_iter.bi_sector = seed;
 	bip->bip_iter.bi_size = len;
+	bip->bip_vcnt = nr_vecs;
 	return 0;
 }
 
-- 
2.25.1


