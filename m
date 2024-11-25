Return-Path: <io-uring+bounces-5028-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5446B9D7C69
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 09:07:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9BC1160F09
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 08:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F38FB189528;
	Mon, 25 Nov 2024 08:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KPQQ4qq0"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2004E188CCA
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732522066; cv=none; b=UecB1uq3IRk9UGD+R+swrwdAHdP5tWNT9uuPpSUDulRBkMvvuGMTwr7jBDut9f8SjhwUm6L7fFjYBMRSovzIhyRwVAzPwZ6NEhO1dZdGJYv+scLdLppPm55aNA19vnqBRHEQlIz2kk1/G78M+J9N/rtuCaDhRMCWaQyIHNaiqEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732522066; c=relaxed/simple;
	bh=z3oZCEUpNWP6ssVVNnvaEMGwTgZ5HxAO2xsIC7OVOu8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=TzFyN9Uc/A13lREDdm1oZf2FLUsDZp0vD5sGxMJm5A/s1qAK5XXhii5q/RH4mU9FmuotRnZXDXpAxB1N5WszO5bSGPhyJKNE39HuFMG2nEFTa5IpoCQPMoL1SzGHZXmEP+VGfgxFAr0rG/CdvaNs0yzI3v+xNa+v/3YZ1hvcdfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KPQQ4qq0; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241125080738epoutp04a8afaeb03516b515368f698408797eff~LJ6H9pO8a1317113171epoutp04_
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:07:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241125080738epoutp04a8afaeb03516b515368f698408797eff~LJ6H9pO8a1317113171epoutp04_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732522058;
	bh=n6LNHR2UxOEOGCqUSfrJ4D/dcAXYHqklNM5hsVN/lLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPQQ4qq0F2GQmM9lj3VtsGROUJmsMBBrfw5KnvdHSnq5fQBk9090qrAG1J9Q2rRkD
	 5qRfS9FAv1CyoCjykZ4xkDESzBfxIWD62r6up42zjORtCoTVfh4pewZQsswXfCNzfA
	 qroBlYPPfS0+IVyo9g6yjw6AbvixlWAZYoYw0CDY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241125080737epcas5p110d91d6478e4741866935487bbcfe3c4~LJ6HdKTCM0753607536epcas5p1Y;
	Mon, 25 Nov 2024 08:07:37 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Xxdbq2q8yz4x9QC; Mon, 25 Nov
	2024 08:07:35 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	90.86.19710.74034476; Mon, 25 Nov 2024 17:07:35 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241125071449epcas5p1f1d44ee61d1af7c847920680767637e7~LJMATL_Db0075500755epcas5p1a;
	Mon, 25 Nov 2024 07:14:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241125071448epsmtrp25d2c9e189a97be238e69b4a4f56dac3d~LJMAQ7JPR0291702917epsmtrp2K;
	Mon, 25 Nov 2024 07:14:48 +0000 (GMT)
X-AuditID: b6c32a44-36bdd70000004cfe-75-67443047379a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5B.F7.35203.8E324476; Mon, 25 Nov 2024 16:14:48 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241125071446epsmtip187adfcb57fadac6d0e10bd8a9f220b58~LJL97JGsg0181001810epsmtip1c;
	Mon, 25 Nov 2024 07:14:46 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v10 01/10] block: define set of integrity flags to be
 inherited by cloned bip
Date: Mon, 25 Nov 2024 12:36:24 +0530
Message-Id: <20241125070633.8042-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241125070633.8042-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xbVRzHc+69a0sN5NJhOGDGyk0MGwq0DNhFeczA8C4zEbPMOIypTbkW
	0id94MY/gFBAEIojDtqCDJ0QShTtWEcd1fIagcFIYDJBmJkBVwZDnhsJj9j1Ft1/n98539/v
	e36/cw4H5f3BCuXkKnW0RimWEywuZu8/HhH1tiBdKqhYxcm1rR2M/Kx2DyUbrXZAdswZWeRS
	/zogp10OhGzvGETIFcNdjLTUlyDk5b4pQDpnXiN7nMMY2dy6wCar7nezyLahfYQc3xs6RI6b
	G9mnAimHeY5NTY7pKZv1cxZ1/VohdWu6iEWtLcxgVE2XFVCjVwfY1IYtjLLNP0EyuVmypBxa
	nE1r+LRSosrOVUqTibPnRGmi+ASBMEqYSJ4k+Eqxgk4m0t/JjMrIlXvaIfj5Yrnes5Qp1mqJ
	mJQkjUqvo/k5Kq0umaDV2XJ1nDpaK1Zo9UpptJLWvSEUCGLjPcKPZTnGmVagnnjp4m2jDRSB
	Fb9K4MeBeBxs6hhAKgGXw8NvAbjysAxjgnUA7cO7h5jgKYBlxZvgIGV1aAswG04AXVYTygQb
	AI4UV3pVLDwCDjwyeFVBeA+A1S13vIVRfBHA76zfYM9Vh3ERdPfUehnDX4V/Olu87I+TcLd1
	B2X8jkLTxDP2c/bDE+GTMpdPEwiHTfNeRj2akhsW7zEgfo8Di7cWMSY5Hdb3W3x8GD4e6mIz
	HAo3VpwshqVwe3IBYVgNS27/4ms0FRpGjJ6iHI/Bcdj5cwyzfAR+NfIDwvgGwOqdeV+qP+z+
	+oAJWN7e6GMInXeLfEzBufVq37i/AHC3rAutBXzzC/2YX+jH/L/1VYBaQQit1iqktCReLVTS
	n/530RKVwga8rzwyvRv83rwf3QcQDugDkIMSQf4BwWlSnn+2+FIBrVGJNHo5re0D8Z6Bf4mG
	vixReb6JUicSxiUK4hISEuISTyQIiWD/JUNTNg+XinW0jKbVtOYgD+H4hRYh9/Lb71SETFk6
	JSGZ7Vd49dPtutTzYR+unJmNWn7/xib7139G38yavcCuWnKUpqAxpWeCA8Z+M7U1c10F7zZY
	x7BldC3wSIU+XuEIX6gZ5dQR25R9n38644KhLstQtLnf+7jq4jOzuy72XF5d76XAwacZvW7H
	xLHl4XXZWxUtoMc19UHDiKDi75vz96u/L8eOcSO/dYW2xV67kpWUkmMxpm12ck8aSPusHVS+
	Zzqal4cb3YVBivyApsW/wsYD3GWKTdHrjwbldRGLtoX8yQatnPvwlDvphCblFdnNgsm58B9r
	SpynbXudQbF9D2o/Ol/+yfWfLtup7fnUB5LV0vDCfQLT5oiFkahGK/4XVupXRm4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LZdlhJTveFsku6wcbPZhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAK4rLJiU1J7MstUjfLoEro//WMsaCS9wVx/o3MTYw
	vuPsYuTkkBAwkfhw/CtjFyMXh5DAbkaJV+v+MEMkJCROvVzGCGELS6z895wdxBYS+Mgo0TzD
	FMRmE1CXOPK8FaxGROAEo8T8iW4gg5hBaiZ8mc0CkhAWiJXYvewwE4jNIqAqcX/vQrA4r4CF
	xJ9lv6GWyUvMvPQdbAGngKXE27YDLBDLLCRmda5khagXlDg58wlYnBmovnnrbOYJjAKzkKRm
	IUktYGRaxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHGdamjsYt6/6oHeIkYmD8RCj
	BAezkggvn7hzuhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFe8Re9KUIC6YklqdmpqQWpRTBZJg5O
	qQamQ0eSKqW73eQe7LjanFR+5WbwdPkbr3ptOrrUNnIulFnVdYJtbub9bytT4uQK2AQ3e91M
	DP219IKx+KOFK1IDtk5U7cnfGHpvguNr8aM/D4Xmeqb61um/TG2rPerdbKx8P3h74ZoH0f4l
	By3mMIuuPPygVHHavFdf+e6ImzcG+Ybdf3crXOpE1sYFWw5fYXt5Pm9aH8/DX1UJrGvfrP+i
	cESAIf5FddKD6SI3ZviyfWWR5P+09EXZ7dYbp/N9H9tt1wo/foX5WtvizZoB8Y6pR9M8Xv3v
	mHBp8gEvtf8rfFoXX7yxffNGo6ArOzwL3735t+S+jc/+4JOStdt6Tye995JxW3/66qrWVVv/
	X65ncFZiKc5INNRiLipOBACyDTlAIgMAAA==
X-CMS-MailID: 20241125071449epcas5p1f1d44ee61d1af7c847920680767637e7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241125071449epcas5p1f1d44ee61d1af7c847920680767637e7
References: <20241125070633.8042-1-anuj20.g@samsung.com>
	<CGME20241125071449epcas5p1f1d44ee61d1af7c847920680767637e7@epcas5p1.samsung.com>

Introduce BIP_CLONE_FLAGS describing integrity flags that should be
inherited in the cloned bip from the parent.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c         | 2 +-
 include/linux/bio-integrity.h | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 2a4bd6611692..a448a25d13de 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -559,7 +559,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	bip->bip_vec = bip_src->bip_vec;
 	bip->bip_iter = bip_src->bip_iter;
-	bip->bip_flags = bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
+	bip->bip_flags = bip_src->bip_flags & BIP_CLONE_FLAGS;
 
 	return 0;
 }
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index dbf0f74c1529..0f0cf10222e8 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -30,6 +30,9 @@ struct bio_integrity_payload {
 	struct bio_vec		bip_inline_vecs[];/* embedded bvec array */
 };
 
+#define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
+			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM)
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
 #define bip_for_each_vec(bvl, bip, iter)				\
-- 
2.25.1


