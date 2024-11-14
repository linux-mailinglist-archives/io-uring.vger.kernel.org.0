Return-Path: <io-uring+bounces-4682-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE8B69C88A9
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 12:18:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 538621F225C8
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 11:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 727941F9430;
	Thu, 14 Nov 2024 11:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hsBKorR6"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5821F890A
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731583075; cv=none; b=mi8AL+sV2WKn1YdKxYDFTxd2MLi04d+xBGw58rr0HczPKRKGz4rhE9fafzd6k3CTo8mIMQcSQ20vtZugNactmuqx5PC2Zl1q0ZPLDOTwNbGd6W3Com+2m9UiarTBcT66B4RAerYO27zUAOfU+qX396ueasrqBq0GuvRE8XENEnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731583075; c=relaxed/simple;
	bh=zLKmPBKgE330gUiBEDdBE5IP6I7cKVfh+yfAPfTxqIA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=KH9VYT+ED6HgZfLFAwnErvhnZl19NPxQD1fhFCii9pQ50hMsHUpv7QGyHb6h0Lc+oCa3DoixoTBizuSkvedcdCc5YD6eeX6eh3B41ZuLtc6khFBxrplCHDLiFsnUb7qfV4rCgdknHFlimusLaDu4l7xVYVm/eGV74MsW+ZIglnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hsBKorR6; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241114111751epoutp01e6c88f0d1b335e2224069ab272590a4b~H0aEg_32o2304223042epoutp01J
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:17:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241114111751epoutp01e6c88f0d1b335e2224069ab272590a4b~H0aEg_32o2304223042epoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731583071;
	bh=TJPyl3aTvIkg4YnLvrh/pR51inkyCmkLsiviu+/e0sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsBKorR6jyfdErYB0lW8JWzOiZx1mm8zDewkdyQYAJQVGpDAtu3O9bHtaW/ukMRvI
	 7F9EGufPvrYPXkItzGv8n4TpoR4K8rtPH3EX9c0Z6warSI+Shc8ijBjP1fz5N6UM5M
	 5aHVThDlGxnlWry1ScKl25Zpg89GBlqlq6bA6diw=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241114111751epcas5p11e7c22b6048020ddb2eaacbf0efd7d2c~H0aED2WZv2611726117epcas5p1o;
	Thu, 14 Nov 2024 11:17:51 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XpyLP3mlyz4x9Pr; Thu, 14 Nov
	2024 11:17:49 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E9.10.08574.D5CD5376; Thu, 14 Nov 2024 20:17:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241114105410epcas5p1c6a4e6141b073ccfd6277288f7d5e28b~H0FZJykea0117201172epcas5p1O;
	Thu, 14 Nov 2024 10:54:10 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241114105410epsmtrp1acbac2af6818b8a83ac2243422cde220~H0FZI1YMj1676716767epsmtrp1W;
	Thu, 14 Nov 2024 10:54:10 +0000 (GMT)
X-AuditID: b6c32a44-93ffa7000000217e-7d-6735dc5d4c1b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	38.6A.07371.2D6D5376; Thu, 14 Nov 2024 19:54:10 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241114105408epsmtip2ae6cc286ea2163093baedf6328059fe2~H0FWvO-JM1327613276epsmtip24;
	Thu, 14 Nov 2024 10:54:08 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v9 08/11] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG
 bip_flags
Date: Thu, 14 Nov 2024 16:15:14 +0530
Message-Id: <20241114104517.51726-9-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241114104517.51726-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJsWRmVeSWpSXmKPExsWy7bCmlm7sHdN0g3NrZSw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orJtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B+UlIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fY
	KqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZzzdPIW54Jlkxctnzg2My0W7GDk5JARM
	JGZNP83UxcjFISSwm1GiaWc3C4TziVFi2aJdbBDON0aJ/0ueMsG0dP78DGYLCexllNg0Sxmi
	6DOjxKQbu1lAEmwC6hJHnrcygiREBPYwSvQuPA02l1lgApNE+8Q57CBVwgIhEhv2XmADsVkE
	VCW2fV8IZvMKWEosWtTMCrFOXmLmpe9g9ZwCVhIrGrYyQ9QISpyc+QRsGzNQTfPW2cwgCyQE
	HnBIPFs6jxGi2UXicOc0KFtY4tXxLewQtpTEy/42KDtd4sdlmN8KJJqP7YOqt5doPdUPNJQD
	aIGmxPpd+hBhWYmpp9YxQezlk+j9/QSqlVdixzwYW0mifeUcKFtCYu+5BijbQ+L+t3eMkKDr
	ZZToPGk5gVFhFpJ3ZiF5ZxbC5gWMzKsYJVMLinPTU5NNCwzzUsvhsZycn7uJEZzOtVx2MN6Y
	/0/vECMTB+MhRgkOZiUR3lPOxulCvCmJlVWpRfnxRaU5qcWHGE2B4T2RWUo0OR+YUfJK4g1N
	LA1MzMzMTCyNzQyVxHlft85NERJITyxJzU5NLUgtgulj4uCUamDSO5MV3NXHs8NVmrc4+/zG
	V48ab5VNzO641LOZ1yVs7fK171TrT21pTG49U7F4ZvlWj6OMXKX9E9hLdOoDv81YnX5vVf/q
	jhfyvKVl209Nu8//6k7JCUnLPWYLHNKOL58xpa9Rq7sskU9NQ+J458rMja33zZO/bK178Njn
	yoU9P2R04gLq76X7rfgl4HCfZcPqWQu2vnspkv+T0V/thcDvGxN9hbSfhi+ed2/HXsuUq/4a
	4p7v1Pnupz5zM8yzWNPxz6jxX6eZ1+OX7R+5Apu65PPbq4KPWh6wuPmHJWNRGXvOzDc7L0x8
	WaD77KTPCrM0l/UVGm1GKyKM8uUZHApe2+9MnTM9MPr/DiUJ0WVKLMUZiYZazEXFiQBbGBW6
	cAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWy7bCSvO6la6bpBndua1p8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSyO/n/LZjHp0DVGi723tC32
	7D3JYjF/2VN2i+7rO9gslh//x2Rx/u9xVovzs+awOwh57Jx1l93j8tlSj02rOtk8Ni+p99h9
	s4HN4+PTWywefVtWMXqcWXCE3ePzJjmPTU/eMgVwRXHZpKTmZJalFunbJXBlPN08hbngmWTF
	y2fODYzLRbsYOTkkBEwkOn9+Zupi5OIQEtjNKPH+9jc2iISExKmXyxghbGGJlf+es4PYQgIf
	GSUevI4AsdkE1CWOPG8FqxEROMEoMX+iG8ggZoEZTBI9v1aADRIWCJLY3P8PrJlFQFVi2/eF
	YHFeAUuJRYuaWSEWyEvMvPQdrIZTwEpiRcNW5i5GDqBllhLf14tAlAtKnJz5hAXEZgYqb946
	m3kCo8AsJKlZSFILGJlWMUqmFhTnpucmGxYY5qWW6xUn5haX5qXrJefnbmIER5uWxg7Ge/P/
	6R1iZOJgPMQowcGsJMJ7ytk4XYg3JbGyKrUoP76oNCe1+BCjNAeLkjiv4YzZKUIC6Yklqdmp
	qQWpRTBZJg5OqQYmfZ7E49ys1vuSF5oa3TLbuS/vQMlkvmmdv//9KF3DtmH3dfHzoS7z1Zbv
	+6l7/fi1Yw5fEv790Ys0t+H4dDRhBsvmZ407/y3R2N0pOUkqLNQ1l/nDrWUn7rlMWdHvf5bJ
	K7j4QVinqHkG+8+dy85NObWrrE1NLijxY39VyaeZXwK27Lus5bZyjcYJuScKPGe2yS5+avHL
	zSzm0uSIF8v28z1/l7A5XUKIf/uv/Xze+1jZ/I643q1/sel25aPGDTYnGO8vjYpR0ru+N9VK
	4tum6J19h5MY/2Z3nOrzXblqz/PW76vy3uqyrl9cYXhm9QFOE8VVNaH7lRyTOvKdeI4tf2y/
	x72imdf9xTLb6W1zriqxFGckGmoxFxUnAgDVqB4dJQMAAA==
X-CMS-MailID: 20241114105410epcas5p1c6a4e6141b073ccfd6277288f7d5e28b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241114105410epcas5p1c6a4e6141b073ccfd6277288f7d5e28b
References: <20241114104517.51726-1-anuj20.g@samsung.com>
	<CGME20241114105410epcas5p1c6a4e6141b073ccfd6277288f7d5e28b@epcas5p1.samsung.com>

This patch introduces BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags which
indicate how the hardware should check the integrity payload.
BIP_CHECK_GUARD/REFTAG are conversion of existing semantics, while
BIP_CHECK_APPTAG is a new flag. The driver can now just rely on block
layer flags, and doesn't need to know the integrity source. Submitter
of PI decides which tags to check. This would also give us a unified
interface for user and kernel generated integrity.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c         |  5 +++++
 drivers/nvme/host/core.c      | 11 +++--------
 include/linux/bio-integrity.h |  6 +++++-
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index f56d01cec689..3bee43b87001 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -434,6 +434,11 @@ bool bio_integrity_prep(struct bio *bio)
 	if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
 		bip->bip_flags |= BIP_IP_CHECKSUM;
 
+	/* describe what tags to check in payload */
+	if (bi->csum_type)
+		bip->bip_flags |= BIP_CHECK_GUARD;
+	if (bi->flags & BLK_INTEGRITY_REF_TAG)
+		bip->bip_flags |= BIP_CHECK_REFTAG;
 	if (bio_integrity_add_page(bio, virt_to_page(buf), len,
 			offset_in_page(buf)) < len) {
 		printk(KERN_ERR "could not attach integrity payload\n");
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 1a8d32a4a5c3..bd309e98ffac 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1017,18 +1017,13 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 			control |= NVME_RW_PRINFO_PRACT;
 		}
 
-		switch (ns->head->pi_type) {
-		case NVME_NS_DPS_PI_TYPE3:
+		if (bio_integrity_flagged(req->bio, BIP_CHECK_GUARD))
 			control |= NVME_RW_PRINFO_PRCHK_GUARD;
-			break;
-		case NVME_NS_DPS_PI_TYPE1:
-		case NVME_NS_DPS_PI_TYPE2:
-			control |= NVME_RW_PRINFO_PRCHK_GUARD |
-					NVME_RW_PRINFO_PRCHK_REF;
+		if (bio_integrity_flagged(req->bio, BIP_CHECK_REFTAG)) {
+			control |= NVME_RW_PRINFO_PRCHK_REF;
 			if (op == nvme_cmd_zone_append)
 				control |= NVME_RW_APPEND_PIREMAP;
 			nvme_set_ref_tag(ns, cmnd, req);
-			break;
 		}
 	}
 
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index 58ff9988433a..fe2bfe122db2 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -11,6 +11,9 @@ enum bip_flags {
 	BIP_DISK_NOCHECK	= 1 << 3, /* disable disk integrity checking */
 	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
 	BIP_COPY_USER		= 1 << 5, /* Kernel bounce buffer in use */
+	BIP_CHECK_GUARD		= 1 << 6, /* guard check */
+	BIP_CHECK_REFTAG	= 1 << 7, /* reftag check */
+	BIP_CHECK_APPTAG	= 1 << 8, /* apptag check */
 };
 
 struct bio_integrity_payload {
@@ -31,7 +34,8 @@ struct bio_integrity_payload {
 };
 
 #define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
-			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM)
+			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM | \
+			 BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
-- 
2.25.1


