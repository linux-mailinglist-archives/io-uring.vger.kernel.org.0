Return-Path: <io-uring+bounces-4419-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26B469BB988
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:57:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4509C1C219F2
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 15:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04FF71C2301;
	Mon,  4 Nov 2024 15:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="vHJBO04X"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486241C1ABC
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730735783; cv=none; b=WiwFiH96essVL7Xj8licKOmW+ck6a9PutZQQFPDgnsuEu8A56Q2WR9codIjQz6/MeufcRjH+9CR95ythIU3uFbz/L3g5VrV6nYZ+szyeoOHuslro5zQjgCu5HacuYxirOAyxcBV+ljLpdsF+dTihe9JXzNKY9bVWAjPTnFJnLCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730735783; c=relaxed/simple;
	bh=5SWlWgE0v/ZgsGIR4YjIdGynPoaBkFM3l3dgZp1M8u0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=fI48OhVbAwH+mM28ivR0xWYGKvkIb+e9n9pDXcU4hZZiA3DUlSdDZ0xqoIeZ87iRWn+nXdVHJAbCr1o4SVwJMJ2vaQxqz759Zw80Jh1nxfp/Dut7OnhwtAlWlSXWdvhYuyPm2Xfkog3cyufKQ494rrK2T3pMvbQw7aJP26imLJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=vHJBO04X; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241104155619epoutp031245170d48bb3cb292f0ca592a9299c1~EzwWSfE6p1886518865epoutp038
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:56:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241104155619epoutp031245170d48bb3cb292f0ca592a9299c1~EzwWSfE6p1886518865epoutp038
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730735779;
	bh=/SlWjlwmF9Rr5zYWclsqVal/XEMs0tmP/ImOW56sBng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHJBO04X174IB6PiydOMnBuPtpTUeF+aevCHG62zCIKn/hUsSOnuPGBGcYCih6G33
	 aURk5r4ae4iaguVP/Mlfs7flnUB0NLUv/UzgocWsy0rIwVqT7wFerYsVGp8qYskzln
	 2HlgNZ/GHD2yXXIEzOSHPnhAMCutv8QWOcy7T9CY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241104155618epcas5p45010de634170053529509503662c01e4~EzwVb-WQ32760427604epcas5p4V;
	Mon,  4 Nov 2024 15:56:18 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Xhx0K148Qz4x9Pp; Mon,  4 Nov
	2024 15:56:17 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C3.75.08574.0AEE8276; Tue,  5 Nov 2024 00:56:17 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241104141501epcas5p38203d98ce0b2ac95cc45e02a142e84ef~EyX56xglX2420824208epcas5p3F;
	Mon,  4 Nov 2024 14:15:01 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241104141501epsmtrp12fbb65828dc52d86d498ccbefe8fda83~EyX55sgYH1340613406epsmtrp1V;
	Mon,  4 Nov 2024 14:15:01 +0000 (GMT)
X-AuditID: b6c32a44-93ffa7000000217e-e9-6728eea0fcff
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	67.8D.07371.5E6D8276; Mon,  4 Nov 2024 23:15:01 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241104141459epsmtip2fec098a032b17ccd6841ce6d71d440c0~EyX3bKxX03097430974epsmtip2n;
	Mon,  4 Nov 2024 14:14:59 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v7 07/10] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG
 bip_flags
Date: Mon,  4 Nov 2024 19:35:58 +0530
Message-Id: <20241104140601.12239-8-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241104140601.12239-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xbdRTH87v3cltI2lwLuB/Ebc1NFmAbrMVSb8mQBYi5iziY0+gwGd7R
	u0Iobe1tB2rmeKQQQQRMYKN0PKJ7QBVG2ZCNl4Nhx0OIEnkpksWyCch46ZxMwJYW3X+f3znf
	8z055/f78VHRL3ggP01jYPUaRk3iPlhrb0hQaN2jYJWkvxZQK38+xajc0g2UsjS0Aso6XYJT
	C72rgJr85hZC1Vv7EOqRaRijqi7kIVTf1iJOfdYzBqjOqQNUR2c/RtVcmeVRReNtOHXVvolQ
	Ixt2L2rEbOEdEdG3zNM8evQ7I21r+BinW744T7dPZuP0yuwURn96owHQQ7V3efSabQ9tcywi
	iT5J6YdTWUbJ6sWsJkWrTNOooshXTyTHJkfIJdJQqYJ6iRRrmAw2ioyLTwx9JU3tnIkUn2XU
	RmcokeE48tDLh/Vao4EVp2o5QxTJ6pRqnUwXxjEZnFGjCtOwhkipRBIe4RS+m55aVLDB0z0I
	yBr//W88G1z1LwTefEjIYGOlDSkEPnwR0Q5gzsx94D6sArg6tu7JPAZwrmgG3ynZvDfLcyc6
	Abw5b/WUrAH428Qyz6XCiSB496FpO+FHdABYXDeIuQ4oUYrAgjLLtsqXeAPem7/o9OXzMWIf
	/PzhQVdYQCjgUHcD5m63F1b+8Ne23JuIhJaNacyteQ72Vzq2GXVq8m5WoS5/SPzMh91LE14u
	T0jEQUdznNvHF87bb/DcHAjnSvI9rIJPRmcRN+tg3rddwM3R0DRQgrpsUCIENt0+5A7vhuUD
	jYi7rRAWP3V4SgWwrXqHSVhQb/EwhJ3D2R6mYUX/DOpeVjGAXS02vBSIzc+MY35mHPP/rWsB
	2gACWB2XoWJTInRSDZv53zWnaDNsYPuh749rAxM1m2E9AOGDHgD5KOknqGaDVCKBknn/A1av
	TdYb1SzXAyKc6y5DA/1TtM6fojEkS2UKiUwul8sUL8ql5C7BgumSUkSoGAObzrI6Vr9Th/C9
	A7ORvUdTGk8n/vrmgyG/3q6l3u5kUenCylstdUhP7qTv9dd114TKrYFlReFWje1Abk6FV8Kp
	zWMx8u8fJwiCT8masHZ7zPCX3RupKz9+FfQHfF7JtQ4et9mP7etwROnry0dPEhwjtb4trAsp
	6z0D17l/8sMR87Cxb8l3KCm2QzontKxXyesqTtPHRdiQ2HBnIiv+ZH64fRFLiDz/Yc5BtXCu
	+cmu4unXJLM/cRfUYQVHHPej/MUDI9YBxQtT0XtiProYmHSuMfZ2+rLZJ9owGHDp8sKJ0N2d
	n9QH697pF54Rfo03X6u+MzpWWB6f2SQ/ZzqabY33Szx7fXWczcp8jzRNrJEYl8pI96N6jvkX
	oduHTnEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSvO7TaxrpBitb9Cw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orhsUlJzMstSi/TtErgyutv/shc8k6y4
	/uYnWwPjctEuRk4OCQETiX8nnrJ3MXJxCAnsZpRY8OAhO0RCQuLUy2WMELawxMp/z8HiQgIf
	GSXadseD2GwC6hJHnreC1YgInGCUmD/RDWQQs8AMJomeXyvYQBLCAkESb3euBSri4GARUJVY
	/FwHJMwrYClxZv8qFoj58hIzL30Hm88pYCUx5+9dFohdlhKbmi6xQNQLSpyc+QTMZgaqb946
	m3kCo8AsJKlZSFILGJlWMUqmFhTnpucmGxYY5qWW6xUn5haX5qXrJefnbmIEx5uWxg7Ge/P/
	6R1iZOJgPMQowcGsJMI7L1U9XYg3JbGyKrUoP76oNCe1+BCjNAeLkjiv4YzZKUIC6Yklqdmp
	qQWpRTBZJg5OqQamOe/P1khWlb7Zp/by1+KvB9SKf/91lp2w/Udwl9b0Rxs1fszdeqTEWlxl
	meD5JDfeAu63ct8qdi42vWrG1680ITV64fRpuTrsN7vWdJ7oZ+fatzjkgwFfaoYP++vFT8rc
	8nRZ/ybfmDlT8AJTMfPK+dmKyxd/SIs4kPeo8nSi6jqD51v3J/2qZN3dv4CnWYl/ovuys15z
	j11+q9qZdtnG43rT6ZSq3/Hrq6KfT16xxIrj7hJeUWXNvuO3ThnF2d2TrDz/Zd8S5h17fp5v
	StywgP1Q11tt927utS/nTUs9UWYS8/COxQntQwctRK9Ie785sTLhwFK/JrHKPb7ZBz1PrmLS
	9akLmrDD40anev7DiUosxRmJhlrMRcWJADMW6O0mAwAA
X-CMS-MailID: 20241104141501epcas5p38203d98ce0b2ac95cc45e02a142e84ef
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241104141501epcas5p38203d98ce0b2ac95cc45e02a142e84ef
References: <20241104140601.12239-1-anuj20.g@samsung.com>
	<CGME20241104141501epcas5p38203d98ce0b2ac95cc45e02a142e84ef@epcas5p3.samsung.com>

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
index 3de7555a7de7..79bd6b22e88d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1004,18 +1004,13 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
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


