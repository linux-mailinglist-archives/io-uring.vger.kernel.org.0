Return-Path: <io-uring+bounces-1637-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E7CB8B286A
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 20:47:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5289D1C20E87
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 18:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F00214F123;
	Thu, 25 Apr 2024 18:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="M5YNw6cC"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A1C14EC6D
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714070835; cv=none; b=rtl0oLWuZmF8E6+nwI9qBB3h4aGhdpGNXqWzOyWZX5b/1w3bbDQiGZu2RfxACRChrqX7ppIEezwkZHPhSxKfqO4fue1lbn+ECBUsEIX3jALywz6RHzKHvhMSMxJd7PQqBEDEgzc/e67CNj5Icj0SRU4S4eZfEyFFGfruUzDAXRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714070835; c=relaxed/simple;
	bh=/DPGeX9I0ObwE3EP0v0TbLOEIokjWnkXRqaku++fBDE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=jDAF6zPy2oSFZ+Vr2b4qq6wHdxAjPOAe6+FT8eCsR8o0JZs+MYRLGfZ9WcoTmtu+fT3QKt6RoF3Zgy/76nIevmi8/YpeXteRFGAB5/KOfcxsnYr2L525ZspBE0zshquoNHCJ4WkfYOjb+sCp4sq5gP6b26ka+vk4xxH06IGCj5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=M5YNw6cC; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240425184711epoutp03cb94672b6793c07234a6eb381f122263~Jmlb1vPQc2307023070epoutp03I
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:47:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240425184711epoutp03cb94672b6793c07234a6eb381f122263~Jmlb1vPQc2307023070epoutp03I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714070831;
	bh=ZpVI+2oz3hOIVHmIDa5Dfh1pTAGcWIpPyXMJ0UEsJ9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5YNw6cCtaRVoeV0CGnet7Pxi0N1Dazvg9sBsItugLbRgucyUrLhQA4Hcy5is/lrP
	 D6h6Zkv/fghX4tsv5e2Kf+mhCbCKFkxuwwgV3qGU5SJEsJCKUVWlZj9xWZwlpZ74TP
	 Y7CDJFFGVOq+FzvMjnjxVzAMIaAFOJifXqlsYulo=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240425184710epcas5p38c919ee7548dbf6d85e36427a50cb697~JmlbSzWtt0687706877epcas5p34;
	Thu, 25 Apr 2024 18:47:10 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4VQPwY12gVz4x9Pq; Thu, 25 Apr
	2024 18:47:09 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9E.20.09665.C25AA266; Fri, 26 Apr 2024 03:47:09 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240425184708epcas5p4f1d95cd8d285614f712868d205a23115~JmlZGm_No1482414824epcas5p4t;
	Thu, 25 Apr 2024 18:47:08 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240425184708epsmtrp12435c2216b41129151b5da961d30625b~JmlZF1L8o0085000850epsmtrp1i;
	Thu, 25 Apr 2024 18:47:08 +0000 (GMT)
X-AuditID: b6c32a4b-829fa700000025c1-27-662aa52cd31b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2C.F0.07541.C25AA266; Fri, 26 Apr 2024 03:47:08 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240425184706epsmtip103cfb1eb0a27f8948c2292d55253d0a5~JmlXL-eNj0041100411epsmtip1r;
	Thu, 25 Apr 2024 18:47:06 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	hch@lst.de, brauner@kernel.org
Cc: asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH 09/10] block: add support to send meta buffer
Date: Fri, 26 Apr 2024 00:09:42 +0530
Message-Id: <20240425183943.6319-10-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240425183943.6319-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAJsWRmVeSWpSXmKPExsWy7bCmlq7uUq00g1lLmC2aJvxltpizahuj
	xeq7/WwWrw9/YrR4NWMtm8XNAzuZLFauPspk8a71HIvF0f9v2SwmHbrGaLH3lrbF/GVP2S2W
	H//H5MDrcW3GRBaPnbPusntcPlvqsWlVJ5vH5iX1HrtvNrB5fHx6i8Wjb8sqRo/Pm+QCOKOy
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOArlZSKEvM
	KQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGe8
	f3+eqeCNesWB81UNjIsVuhg5OSQETCQOH5rE2sXIxSEksJtR4uWOq0wQzidGiW1TGthAqoQE
	vjFKfLmbDNMxf/d3qKK9jBJNG0+xQDifGSV+n9zB3MXIwcEmoClxYXIpSIOIQIrEq3WvGUFq
	mAWeMkrs+XqTCaRGWMBWYuVrJ5AaFgFViUPXp7OD2LwCFhJXfn5nh1gmLzHzEoTNCRSffPE0
	VI2gxMmZT1hAbGagmuats5lB5ksIrOSQaDl2kRmi2UViRftxVghbWOLV8S1QQ6UkXva3QdnJ
	EpdmnmOCsEskHu85CGXbS7Se6gf7hRnol/W79CF28Un0/n4Cdr6EAK9ER5sQRLWixL1JT6E2
	iUs8nLEEyvaQmHr0GTskeLoZJVZcvss0gVF+FpIXZiF5YRbCtgWMzKsYJVMLinPTU4tNC4zz
	Usvh0Zqcn7uJEZx0tbx3MD568EHvECMTB+MhRgkOZiUR3psfNdKEeFMSK6tSi/Lji0pzUosP
	MZoCw3gis5Rocj4w7eeVxBuaWBqYmJmZmVgamxkqifO+bp2bIiSQnliSmp2aWpBaBNPHxMEp
	1cBkcio07/EdY9PK8nmeVWfiu+2OOup82qZn+WLnXqb+tjN9AqaqkpZ+wXVHr6m4bZCtu3uh
	8aHvr5Xm53ONZ4dt9Vq20X/pHjbrbEeN605Su24xlsvpfgupjxVO2SU6u/GvwONCtQ+Jk3Ol
	nyo++WBz4EST/pnubV0sq63amH99jtFP3Ft73u9iS2w6Z/yFkJmbLZTYuhsb7ducNzNsX26w
	ikP/u4GK6/37AYdjjqooP/YuWPRmymytGW+vWcR7dqp29CiG/V4c/6Z3h6bn+RC98t8Fi7Uc
	Kg+k7wjUjYnrt94gOvt7ramEvspsgXLO+6KLZy/+esZKY833KddUdKsqC68GvTn+ZalE4+sN
	z5RYijMSDbWYi4oTAXv9jUBDBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWy7bCSnK7OUq00g73bxCyaJvxltpizahuj
	xeq7/WwWrw9/YrR4NWMtm8XNAzuZLFauPspk8a71HIvF0f9v2SwmHbrGaLH3lrbF/GVP2S2W
	H//H5MDrcW3GRBaPnbPusntcPlvqsWlVJ5vH5iX1HrtvNrB5fHx6i8Wjb8sqRo/Pm+QCOKO4
	bFJSczLLUov07RK4Mt6/P89U8Ea94sD5qgbGxQpdjJwcEgImEvN3f2cCsYUEdjNK3HhqAhEX
	l2i+9oMdwhaWWPnvOZDNBVTzkVHiQM8s1i5GDg42AU2JC5NLQWpEBLIk9vZfAathFnjLKLFt
	6Uo2kBphAVuJla+dQGpYBFQlDl2fDjaTV8BC4srP71Dz5SVmXoKwOYHiky+eZoe4x1xi6ppF
	jBD1ghInZz5hAbGZgeqbt85mnsAoMAtJahaS1AJGplWMkqkFxbnpucmGBYZ5qeV6xYm5xaV5
	6XrJ+bmbGMHxoqWxg/He/H96hxiZOBgPMUpwMCuJ8N78qJEmxJuSWFmVWpQfX1Sak1p8iFGa
	g0VJnNdwxuwUIYH0xJLU7NTUgtQimCwTB6dUA5OPb//e2uPRDhPOq+rMN0pmKv1zka/3RVLn
	Pt/PHb+e/tvNuFJnQ++TZSLlDw4J5k3xSjTUDra/bTDp3EnXVvfV7SG6cff8ub9d2PPh64PA
	r6vMGphntZ2eZDRJ+IRiqKQa89xHyfWLkt3fnPzw8vrnRTN23/DlfxlcvvsDj9faipBzH/T/
	/vnW4p3uyVH2VozlpBrDwSeRu/62lW9+oGBwzabl2K0pF6fMUC/W25pzZWZUYsbMpkypTs8Y
	77k3piqdMoyyzGI/Weks3XxCbX7JKusVj6o2antHVpxbUxp4W07+OPe52tNsket2chk13Xp8
	xd6m7xiHq8bbv9Z75u/4zcYWJR4XO3nzmcbLCa+UWIozEg21mIuKEwFRqecdBgMAAA==
X-CMS-MailID: 20240425184708epcas5p4f1d95cd8d285614f712868d205a23115
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240425184708epcas5p4f1d95cd8d285614f712868d205a23115
References: <20240425183943.6319-1-joshi.k@samsung.com>
	<CGME20240425184708epcas5p4f1d95cd8d285614f712868d205a23115@epcas5p4.samsung.com>

If iocb contains the meta, extract that and prepare the bip.
Extend bip so that can it can carry three new integrity-check flags
and application tag.

Make sure that ->prepare_fn and ->complete_fn are skipped for
user-owned meta buffer.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c | 31 ++++++++++++++++++++++++++++++-
 block/fops.c          |  9 +++++++++
 block/t10-pi.c        |  6 ++++++
 include/linux/bio.h   | 10 ++++++++++
 4 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 1085cf45f51e..dab76fd73813 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -11,7 +11,7 @@
 #include <linux/export.h>
 #include <linux/bio.h>
 #include <linux/workqueue.h>
-#include <linux/slab.h>
+#include <uapi/linux/io_uring.h>
 #include "blk.h"
 
 static struct kmem_cache *bip_slab;
@@ -318,6 +318,35 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
 	return nr_bvecs;
 }
 
+int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta)
+{
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
+	u16 bip_flags = 0;
+	int ret;
+
+	if (!bi)
+		return -EINVAL;
+
+	if (meta->iter.count < bio_integrity_bytes(bi, bio_sectors(bio)))
+		return -EINVAL;
+
+	ret = bio_integrity_map_user(bio, &meta->iter, 0);
+	if (!ret) {
+		struct bio_integrity_payload *bip = bio_integrity(bio);
+
+		if (meta->flags & META_CHK_GUARD)
+			bip_flags |= BIP_USER_CHK_GUARD;
+		if (meta->flags & META_CHK_APPTAG)
+			bip_flags |= BIP_USER_CHK_APPTAG;
+		if (meta->flags & META_CHK_REFTAG)
+			bip_flags |= BIP_USER_CHK_REFTAG;
+
+		bip->bip_flags |= bip_flags;
+		bip->apptag = meta->apptag;
+	}
+	return ret;
+}
+
 int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter,
 			  u32 seed)
 {
diff --git a/block/fops.c b/block/fops.c
index 679d9b752fe8..e488fa66dd60 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -353,6 +353,15 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		task_io_account_write(bio->bi_iter.bi_size);
 	}
 
+	if (unlikely(iocb->ki_flags & IOCB_USE_META)) {
+		ret = bio_integrity_map_iter(bio, iocb->private);
+		WRITE_ONCE(iocb->private, NULL);
+		if (unlikely(ret)) {
+			bio_put(bio);
+			return ret;
+		}
+	}
+
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		bio->bi_opf |= REQ_NOWAIT;
 
diff --git a/block/t10-pi.c b/block/t10-pi.c
index d90892fd6f2a..72d1522417a1 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -156,6 +156,8 @@ static void t10_pi_type1_prepare(struct request *rq)
 		/* Already remapped? */
 		if (bip->bip_flags & BIP_MAPPED_INTEGRITY)
 			break;
+		if (bip->bip_flags & BIP_INTEGRITY_USER)
+			break;
 
 		bip_for_each_vec(iv, bip, iter) {
 			unsigned int j;
@@ -205,6 +207,8 @@ static void t10_pi_type1_complete(struct request *rq, unsigned int nr_bytes)
 		struct bio_vec iv;
 		struct bvec_iter iter;
 
+		if (bip->bip_flags & BIP_INTEGRITY_USER)
+			break;
 		bip_for_each_vec(iv, bip, iter) {
 			unsigned int j;
 			void *p;
@@ -408,6 +412,8 @@ static void ext_pi_type1_prepare(struct request *rq)
 		/* Already remapped? */
 		if (bip->bip_flags & BIP_MAPPED_INTEGRITY)
 			break;
+		if (bip->bip_flags & BIP_INTEGRITY_USER)
+			break;
 
 		bip_for_each_vec(iv, bip, iter) {
 			unsigned int j;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 0281b356935a..8724305bce62 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -329,6 +329,9 @@ enum bip_flags {
 	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
 	BIP_INTEGRITY_USER	= 1 << 5, /* Integrity payload is user address */
 	BIP_COPY_USER		= 1 << 6, /* Kernel bounce buffer in use */
+	BIP_USER_CHK_GUARD	= 1 << 7,
+	BIP_USER_CHK_APPTAG	= 1 << 8,
+	BIP_USER_CHK_REFTAG	= 1 << 9,
 };
 
 struct uio_meta {
@@ -348,6 +351,7 @@ struct bio_integrity_payload {
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
 	unsigned short		bip_max_vcnt;	/* integrity bio_vec slots */
 	unsigned short		bip_flags;	/* control flags */
+	u16			apptag;		/* apptag */
 
 	struct bvec_iter	bio_iter;	/* for rewinding parent bio */
 
@@ -729,6 +733,7 @@ static inline bool bioset_initialized(struct bio_set *bs)
 	for_each_bio(_bio)						\
 		bip_for_each_vec(_bvl, _bio->bi_integrity, _iter)
 
+int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta);
 int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter, u32 seed);
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
@@ -808,6 +813,11 @@ static inline int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter,
 	return -EINVAL;
 }
 
+static inline int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
 /*
-- 
2.25.1


