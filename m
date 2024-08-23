Return-Path: <io-uring+bounces-2913-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D806E95CADF
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 12:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09A901C222C4
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 10:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8237A187342;
	Fri, 23 Aug 2024 10:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hw/QDHs8"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A3B13D521
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724410128; cv=none; b=Om467GepJXzgYxo/WJGv6snW7cBR93FnReB6cJszm8b/aIk+NiI3O+zSXluJgNt53ooZKGfijpVyx/252qYUUGQCVv7vigD9B4m+TlOwy9KgT2x7U5e1di2F+xnERDb35Z9OJutjul5eUTi/+4jy3YWnL4ysqB4Wzi5s1Z4auQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724410128; c=relaxed/simple;
	bh=ZFRQD9h8z7hSXpmmJj4mQnOOQRJC2IiHlwUXp6iT0Tk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=KlVlh7uPiE4ggudgN2Dhn26+SszB15on7/Toy7cRw7/8bJLEa1R5vdW9/D+cd7r8r92MdemFkCJQDf0AXfwPIpCF9oV8O5wsGwDkPNjJoEurpDJCWZUh2G016lgeWa2wxEkVm4+YCtAFZ/slTZs62mhT3jTlm3aHo+vhLp4GGFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hw/QDHs8; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240823104844epoutp034f2d53fc012c563609c67d56ea07bd1f~uVd9Tquxr0963909639epoutp03D
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:48:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240823104844epoutp034f2d53fc012c563609c67d56ea07bd1f~uVd9Tquxr0963909639epoutp03D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724410125;
	bh=xx/xKoOUcbojb9soBs/yl0B6zu+0BvFN6VqSS3y8yOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hw/QDHs8Re082khBLEc8/iC6F9jo5/uHixtlDFIRoub/7gLN4Z+VD7eLkqgd1GEvF
	 c/fhJeLLnIm/Dn654/QxhJ4DbvOaysAlM2GmBbv0o81kHNB4hxay46TbPxVcILD1fU
	 8SZcbrAbkfGTs2GEFGXQALxhH+uOPLGNGomOHA4Q=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240823104844epcas5p321b62e0822626f1b28485f8e22f10cd4~uVd8payEw1524515245epcas5p3z;
	Fri, 23 Aug 2024 10:48:44 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Wqxd63xs1z4x9Q0; Fri, 23 Aug
	2024 10:48:42 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D8.30.08855.A0968C66; Fri, 23 Aug 2024 19:48:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240823104634epcas5p4ef1af26cc7146b4e8b7a4a1844ffe476~uVcDkn7Qc3268132681epcas5p4j;
	Fri, 23 Aug 2024 10:46:34 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240823104634epsmtrp14411ac4782d6495c00ecee9d728005d2~uVcDj2E7d0262002620epsmtrp1B;
	Fri, 23 Aug 2024 10:46:34 +0000 (GMT)
X-AuditID: b6c32a44-107ff70000002297-c7-66c8690a6ada
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	86.6F.07567.A8868C66; Fri, 23 Aug 2024 19:46:34 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240823104632epsmtip2938765aea09c7de01353c72ad9e196c4~uVcBcYfOP1453814538epsmtip2C;
	Fri, 23 Aug 2024 10:46:31 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v3 08/10] block: add support to pass user meta buffer
Date: Fri, 23 Aug 2024 16:08:09 +0530
Message-Id: <20240823103811.2421-10-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240823103811.2421-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHJsWRmVeSWpSXmKPExsWy7bCmui5X5ok0gwPThC2aJvxltpizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF9jNLmS323tK2mL/sKbtF9/UdbBbL
	j/9jcuD12DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvTYfLra4/MmuQDOqGyb
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCjlRTKEnNK
	gUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFJgV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGW1f
	ZzIXfLau6Fy8iamB8ZBBFyMnh4SAicTqYz+Yuxi5OIQEdjNK7FncxwbhfGKUWLdhGhOE841R
	4s6rm4wwLTunv4dq2csoMXHTI0YI5zOjRO/d9SwgVWwC6hJHnreCdYgIVEo83/WDBaSIWeAm
	o0TzsX1MIAlhAVeJiz8XMoPYLAKqEk/nfGcFsXkFLCX2/zvBArFOXmLmpe/sIDYnULxpdgML
	RI2gxMmZT8BsZqCa5q2zwU6SEFjLITHxx2+gBRxAjovE2s+BEHOEJV4d38IOYUtJvOxvg7LT
	JX5cfsoEYReA3Ab1pr1E66l+ZpAxzAKaEut36UOEZSWmnlrHBLGWT6L39xOoVl6JHfNgbCWJ
	9pVzoGwJib3nGqCu8ZA4PCUNElY9jBL//hxinsCoMAvJN7OQfDMLYfMCRuZVjJKpBcW56anJ
	pgWGeanl8FhOzs/dxAhOyFouOxhvzP+nd4iRiYPxEKMEB7OSCG/SvaNpQrwpiZVVqUX58UWl
	OanFhxhNgcE9kVlKNDkfmBPySuINTSwNTMzMzEwsjc0MlcR5X7fOTRESSE8sSc1OTS1ILYLp
	Y+LglGpg0j7x9UHB2ZVdm3oN/071etzJMPOaaelC8S9Vx9Lm1RW2h8zINDz1ptji4WkHlTgW
	ba4qvTkaNm+PtJqevBvbv0d3qsqnu2rPfOVKrUJ/P+ZZ69O/OeFMRl1JYAxbm+vTnp57f8Xy
	GLnYFjLOY1bsPdzlv9QyRk4x54o5h/R/V5YHxhvXZ4VsPKg3laPorTWL1EnVVov0S1OEv54S
	K24/uLB0YZKjam/8rHadb/wN3UuLBQLcOItK3tdIvjkp8rb4gUe0S/iJ5jPPP7nUfvTZOt8i
	6cvKN//3CE4MV1d593Cq1T+GVwsC+g04E9S6PPgOifsuPSgzqfCLoNgNZant+bf/rJgSnXH6
	3To7jVNKLMUZiYZazEXFiQC+qDLSUQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWy7bCSvG5Xxok0g5cPOSyaJvxltpizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF9jNLmS323tK2mL/sKbtF9/UdbBbL
	j/9jcuD12DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvTYfLra4/MmuQDOKC6b
	lNSczLLUIn27BK6Mtq8zmQs+W1d0Lt7E1MB4yKCLkZNDQsBEYuf098xdjFwcQgK7GSWe9E5l
	g0hISJx6uYwRwhaWWPnvOTtE0UdGiZ4fl8ASbALqEkeetzKCJEQEGhkltjR/YQFxmAXuM0q8
	bd7NAlIlLOAqcfHnQmYQm0VAVeLpnO+sIDavgKXE/n8nWCBWyEvMvPSdHcTmBIo3zW4AiwsJ
	WEgsW36GEaJeUOLkzCdgcWag+uats5knMArMQpKahSS1gJFpFaNkakFxbnpusmGBYV5quV5x
	Ym5xaV66XnJ+7iZGcNxoaexgvDf/n94hRiYOxkOMEhzMSiK8SfeOpgnxpiRWVqUW5ccXleak
	Fh9ilOZgURLnNZwxO0VIID2xJDU7NbUgtQgmy8TBKdXAtKQwsWX/i6f16aYZ/K1yeVVnbgd1
	S+3QOnjGS23OihX3F/U16wvuqbylInptpeWKP6Uhgi9+nl6g9kN0XgarY3XBR0u52EbGeYyz
	3TTf8+TYX8hXTlsrOj2m8nnuq3eKRvrLs8q+ZjmECzatuaXgKRCR/tn1SOqhU99O7C1hkW6W
	2GW1K2PfB67iSDXzhUv0PzeIc6bJJktXWls1B1vzu6yYumdmgF6Q2xuDd2LrGWc8kckoOrFH
	KWXC5K7iq3v6Mq92ztooYfC8v3nJ6QvrptonFvU0JnmcWt0t023s1rxi6hJ+aYfNfJ5SPwst
	mlM6ZxtY8V7LTtnx/oUjv8p27QdtyYdUY/+pesp7nVJiKc5INNRiLipOBADkltLoCgMAAA==
X-CMS-MailID: 20240823104634epcas5p4ef1af26cc7146b4e8b7a4a1844ffe476
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240823104634epcas5p4ef1af26cc7146b4e8b7a4a1844ffe476
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104634epcas5p4ef1af26cc7146b4e8b7a4a1844ffe476@epcas5p4.samsung.com>

From: Kanchan Joshi <joshi.k@samsung.com>

If iocb contains the meta, extract that and prepare the bip.
Based on flags specified by the user, set corresponding guard/app/ref
tags to be checked in bip. Introduce BIP_INTEGRITY_USER flag to
indicate integrity payload is user address. Make sure that
->prepare_fn and ->complete_fn are skipped for user-owned meta buffer.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c         | 45 ++++++++++++++++++++++++++++++++++-
 block/fops.c                  | 25 +++++++++++++++++++
 block/t10-pi.c                |  6 +++++
 include/linux/bio-integrity.h | 13 +++++++++-
 4 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 7fbf8c307a36..02b766c2e57d 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -12,6 +12,7 @@
 #include <linux/bio.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
+#include <uapi/linux/io_uring.h>
 #include "blk.h"
 
 static struct kmem_cache *bip_slab;
@@ -252,7 +253,7 @@ static int bio_integrity_copy_user(struct bio *bio, struct bio_vec *bvec,
 		goto free_bip;
 	}
 
-	bip->bip_flags |= BIP_COPY_USER;
+	bip->bip_flags |= BIP_INTEGRITY_USER | BIP_COPY_USER;
 	bip->bip_iter.bi_sector = seed;
 	bip->bip_vcnt = nr_vecs;
 	bip->bio_iter = bio->bi_iter;
@@ -274,6 +275,7 @@ static int bio_integrity_init_user(struct bio *bio, struct bio_vec *bvec,
 		return PTR_ERR(bip);
 
 	memcpy(bip->bip_vec, bvec, nr_vecs * sizeof(*bvec));
+	bip->bip_flags |= BIP_INTEGRITY_USER;
 	bip->bip_iter.bi_sector = seed;
 	bip->bip_iter.bi_size = len;
 	bip->bip_vcnt = nr_vecs;
@@ -310,6 +312,47 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
 	return nr_bvecs;
 }
 
+static void bio_uio_meta_to_bip(struct bio *bio, struct uio_meta *meta)
+{
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+
+	if (meta->flags & INTEGRITY_CHK_GUARD)
+		bip->bip_flags |= BIP_CHECK_GUARD;
+	if (meta->flags & INTEGRITY_CHK_APPTAG)
+		bip->bip_flags |= BIP_CHECK_APPTAG;
+	if (meta->flags & INTEGRITY_CHK_REFTAG)
+		bip->bip_flags |= BIP_CHECK_REFTAG;
+
+	bip->app_tag = meta->app_tag;
+}
+
+int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta)
+{
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
+	unsigned int integrity_bytes;
+	int ret;
+	struct iov_iter it;
+
+	if (!bi)
+		return -EINVAL;
+	/*
+	 * original meta iterator can be bigger.
+	 * process integrity info corresponding to current data buffer only.
+	 */
+	it = meta->iter;
+	integrity_bytes = bio_integrity_bytes(bi, bio_sectors(bio));
+	if (it.count < integrity_bytes)
+		return -EINVAL;
+
+	it.count = integrity_bytes;
+	ret = bio_integrity_map_user(bio, &it, 0);
+	if (!ret) {
+		bio_uio_meta_to_bip(bio, meta);
+		iov_iter_advance(&meta->iter, integrity_bytes);
+	}
+	return ret;
+}
+
 int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter,
 			   u32 seed)
 {
diff --git a/block/fops.c b/block/fops.c
index 9825c1713a49..5c18676c17ab 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -154,6 +154,9 @@ static void blkdev_bio_end_io(struct bio *bio)
 		}
 	}
 
+	if (bio_integrity(bio) && (dio->iocb->ki_flags & IOCB_HAS_META))
+		bio_integrity_unmap_user(bio);
+
 	if (should_dirty) {
 		bio_check_pages_dirty(bio);
 	} else {
@@ -231,6 +234,16 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 			}
 			bio->bi_opf |= REQ_NOWAIT;
 		}
+		if (!is_sync && unlikely(iocb->ki_flags & IOCB_HAS_META)) {
+			ret = bio_integrity_map_iter(bio, iocb->private);
+			if (unlikely(ret)) {
+				bio_release_pages(bio, false);
+				bio_clear_flag(bio, BIO_REFFED);
+				bio_put(bio);
+				blk_finish_plug(&plug);
+				return ret;
+			}
+		}
 
 		if (is_read) {
 			if (dio->flags & DIO_SHOULD_DIRTY)
@@ -288,6 +301,9 @@ static void blkdev_bio_end_io_async(struct bio *bio)
 		ret = blk_status_to_errno(bio->bi_status);
 	}
 
+	if (bio_integrity(bio) && (iocb->ki_flags & IOCB_HAS_META))
+		bio_integrity_unmap_user(bio);
+
 	iocb->ki_complete(iocb, ret);
 
 	if (dio->flags & DIO_SHOULD_DIRTY) {
@@ -348,6 +364,15 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		task_io_account_write(bio->bi_iter.bi_size);
 	}
 
+	if (unlikely(iocb->ki_flags & IOCB_HAS_META)) {
+		ret = bio_integrity_map_iter(bio, iocb->private);
+		WRITE_ONCE(iocb->private, NULL);
+		if (unlikely(ret)) {
+			bio_put(bio);
+			return ret;
+		}
+	}
+
 	if (iocb->ki_flags & IOCB_ATOMIC)
 		bio->bi_opf |= REQ_ATOMIC;
 
diff --git a/block/t10-pi.c b/block/t10-pi.c
index e7052a728966..cb7bc4a88380 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -139,6 +139,8 @@ static void t10_pi_type1_prepare(struct request *rq)
 		/* Already remapped? */
 		if (bip->bip_flags & BIP_MAPPED_INTEGRITY)
 			break;
+		if (bip->bip_flags & BIP_INTEGRITY_USER)
+			break;
 
 		bip_for_each_vec(iv, bip, iter) {
 			unsigned int j;
@@ -188,6 +190,8 @@ static void t10_pi_type1_complete(struct request *rq, unsigned int nr_bytes)
 		struct bio_vec iv;
 		struct bvec_iter iter;
 
+		if (bip->bip_flags & BIP_INTEGRITY_USER)
+			break;
 		bip_for_each_vec(iv, bip, iter) {
 			unsigned int j;
 			void *p;
@@ -313,6 +317,8 @@ static void ext_pi_type1_prepare(struct request *rq)
 		/* Already remapped? */
 		if (bip->bip_flags & BIP_MAPPED_INTEGRITY)
 			break;
+		if (bip->bip_flags & BIP_INTEGRITY_USER)
+			break;
 
 		bip_for_each_vec(iv, bip, iter) {
 			unsigned int j;
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index c7c0121689e1..22ff2ae16444 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -14,6 +14,9 @@ enum bip_flags {
 	BIP_CHECK_GUARD		= 1 << 6,
 	BIP_CHECK_REFTAG	= 1 << 7,
 	BIP_CHECK_APPTAG	= 1 << 8,
+	BIP_INTEGRITY_USER      = 1 << 9, /* Integrity payload is user
+					   * address
+					   */
 };
 
 struct bio_integrity_payload {
@@ -24,6 +27,7 @@ struct bio_integrity_payload {
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
 	unsigned short		bip_max_vcnt;	/* integrity bio_vec slots */
 	unsigned short		bip_flags;	/* control flags */
+	u16			app_tag;
 
 	struct bvec_iter	bio_iter;	/* for rewinding parent bio */
 
@@ -44,7 +48,8 @@ struct uio_meta {
 
 #define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
 			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM | \
-			 BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
+			 BIP_CHECK_GUARD | BIP_CHECK_REFTAG | \
+			 BIP_CHECK_APPTAG | BIP_INTEGRITY_USER)
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
@@ -89,6 +94,7 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio, gfp_t gfp,
 int bio_integrity_add_page(struct bio *bio, struct page *page, unsigned int len,
 		unsigned int offset);
 int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter, u32 seed);
+int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta);
 void bio_integrity_unmap_user(struct bio *bio);
 bool bio_integrity_prep(struct bio *bio);
 void bio_integrity_advance(struct bio *bio, unsigned int bytes_done);
@@ -120,6 +126,11 @@ static inline int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter,
 	return -EINVAL;
 }
 
+static inline int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta)
+{
+	return -EINVAL;
+}
+
 static inline void bio_integrity_unmap_user(struct bio *bio)
 {
 }
-- 
2.25.1


