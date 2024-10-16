Return-Path: <io-uring+bounces-3730-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 180CD9A09FE
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 14:37:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1CD2AB28CA3
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 12:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EEF820966E;
	Wed, 16 Oct 2024 12:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Soy1mG2v"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BA3209683
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729082226; cv=none; b=NjiayFj411AuumDteXpdaVDJpXO7NN3pG4zSfC4ezMUpQsHgHcGtUzoXSf+ViVcT4BrWNm2gsIB7Uyrc7QKb7mPwbgL5pvJuwe2RdijtQC0XqEeMPpKWp59rN0Hqnsqnuf2MaTvMnCTrp7gywklj7jG7zGcAmlP+zCTzsRZLfbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729082226; c=relaxed/simple;
	bh=rWG+L8TKua66elGsLM0q6AdqhuoGedubwJQEvqG+Myg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=OTzaR3ScQ6DZbs5ZToSbq2jW9sihkk0JvvC9DY0/X1gXT9AJlQFz0W3c6MuqhVknQC/5QOgeQoIMNtn9Xr6iyOLdHaTlJKW5tjdU5dy1Tcvd4rduUfHauBUVuWiT8XP+95Wr41h/wVOt9DNstAbI7uEEbOrlUBKu2asrcV2MYY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Soy1mG2v; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241016123702epoutp045e7e05d161e4f54da56663101ca1828c~_7x7VUYE-2079920799epoutp04C
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:37:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241016123702epoutp045e7e05d161e4f54da56663101ca1828c~_7x7VUYE-2079920799epoutp04C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729082222;
	bh=l5NLGAVozNPeGXm3NN3/NT8GrqW9QoQFU3FPIXkqZQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Soy1mG2vU372NaHyxIzXL+s3WVLZGEGHTSqcQIuF9EbCzauH9iymSyUJyqm0AGtgr
	 josQjeZVwzGKOp2YaO3t6PTHgI9Zoef6VpwHSY+ubxwEl3nNRmZlHZLDIvk9IK2V8y
	 jWOthQOvCADGZD/BOOBsiMidQQwxMTOoX10KZJUw=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241016123702epcas5p299d4ccd67892ddb47ec8a965a601e475~_7x63VnXv1543915439epcas5p2Y;
	Wed, 16 Oct 2024 12:37:02 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XT9T833sZz4x9Pv; Wed, 16 Oct
	2024 12:37:00 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	97.18.09420.C63BF076; Wed, 16 Oct 2024 21:37:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241016113752epcas5p4c365819fce1e5d498fd781ae2b309341~_6_RMXIKo1424214242epcas5p4n;
	Wed, 16 Oct 2024 11:37:52 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241016113752epsmtrp22c9d3afdc4237a16a85531587f299460~_6_RLg81s1555115551epsmtrp2i;
	Wed, 16 Oct 2024 11:37:52 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-04-670fb36cf13d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4F.68.08227.095AF076; Wed, 16 Oct 2024 20:37:52 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241016113750epsmtip15073a22c64ea221d14f0ec92e0320c7c~_6_PFnQMF2787227872epsmtip16;
	Wed, 16 Oct 2024 11:37:50 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v4 09/11] block: add support to pass user meta buffer
Date: Wed, 16 Oct 2024 16:59:10 +0530
Message-Id: <20241016112912.63542-10-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241016112912.63542-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJsWRmVeSWpSXmKPExsWy7bCmlm7OZv50g7cnBCw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7O4eWAnk8XK1UeZLN61nmOxOPr/LZvFpEPXGC22n1nKbLH3lrbF/GVP2S26
	r+9gs1h+/B+TxflZc9gd+D12zrrL7nH5bKnHplWdbB6bl9R77L7ZwObx8ektFo++LasYPTaf
	rvb4vEkugDMq2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DX
	LTMH6HwlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWh
	gYGRKVBhQnbGrN3nWArWWVR8W72HvYGxVa+LkZNDQsBE4tSlu6xdjFwcQgK7GSU2d11mg3A+
	MUr8alzFDOF8Y5S4e3wWM0zLg60XoBJ7GSWmPjjMDuF8ZpQ4uqKZFaSKTUBd4sjzVkYQW0Rg
	EqPE88uhIEXMAu8ZJZY9mwWWEBZwlfj6fREbiM0ioCrx6+A/sDivgJXE6RlzoNbJS8y89J0d
	xOYEip86d5AdokZQ4uTMJywgNjNQTfPW2VD1ezgk3v4pgrBdJOY2zGWFsIUlXh3fwg5hS0l8
	freXDcJOl/hx+SkThF0g0XxsHyOEbS/ReqofaCYH0HxNifW79CHCshJTT61jgljLJ9H7+wlU
	K6/EjnkwtpJE+8o5ULaExN5zDVC2h8SnhnfQwOpllJi5ax3TBEaFWUjemYXknVkIqxcwMq9i
	lEwtKM5NTy02LTDMSy2HR3Nyfu4mRnCa1vLcwXj3wQe9Q4xMHIyHGCU4mJVEeCd18aYL8aYk
	VlalFuXHF5XmpBYfYjQFhvdEZinR5HxgpsgriTc0sTQwMTMzM7E0NjNUEud93To3RUggPbEk
	NTs1tSC1CKaPiYNTqoEpQ670c/kl1clL//uI7nTY+6Zxx9PVtp9/qMzQEF7Dy8N+2eLU4pXz
	NVfofY89khvcm3oj3PPK3HPCzqwSBxLCO24VxD8+P6/WRWt96vwE+RPb+B8XFaoE/PsnWMIl
	abfoTOXs844SlTNqdfsTV/vbsjTd+2OppnB/fXAz093aZqF1tlz/M9ZrnSoql3DI6g+fOWm1
	Y0zzL9EjrBzLunfJdR597bVZx/Lr9NpXrz9xJa/Ue18v963/qeiPCz0Pn5ve1ZAzEboRNG+6
	Tqhe8h4nWesb3d03H0zfnpkau/l4+Ps9HHu22Ry+sc8jtfeTTLRDzwyG7fkJXc6S0+QFzxia
	h5Z8YWFiE6vIZTjhlazEUpyRaKjFXFScCABNoRPVXAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42LZdlhJTnfCUv50g/51qhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1ncPLCTyWLl6qNMFu9az7FYHP3/ls1i0qFrjBbbzyxltth7S9ti/rKn7Bbd
	13ewWSw//o/J4vysOewO/B47Z91l97h8ttRj06pONo/NS+o9dt9sYPP4+PQWi0ffllWMHptP
	V3t83iQXwBnFZZOSmpNZllqkb5fAlTFr9zmWgnUWFd9W72FvYGzV62Lk5JAQMJF4sPUCcxcj
	F4eQwG5GiZmrN7JBJCQkTr1cxghhC0us/PecHaLoI6NE15TfLCAJNgF1iSPPWxlBEiICsxgl
	Ds+azwSSYBb4zijxr9sZxBYWcJX4+n0R2FQWAVWJXwf/gU3lFbCSOD1jDjPEBnmJmZe+s4PY
	nEDxU+cOgtlCApYS/yZ/gKoXlDg58wkLxHx5ieats5knMAJtRUjNQpJawMi0ilEytaA4Nz23
	2LDAKC+1XK84Mbe4NC9dLzk/dxMjOJK0tHYw7ln1Qe8QIxMH4yFGCQ5mJRHeSV286UK8KYmV
	ValF+fFFpTmpxYcYpTlYlMR5v73uTRESSE8sSc1OTS1ILYLJMnFwSjUwpZbw9ErMeH3U2S2y
	yN1M4/eR68EcaVt8k3YZzOhNjHpWtPTJkp8xvQ8PVR2VD9f7+/ZDTLP8p3IWdc30oLjQb0e2
	X+GKlppic92Tq7b4+5m0LPbdb3dMrDEU6/lRv7+r9OxxmzLeF4ru95lyLgSfmVczXfRnotH3
	Xz633h96ybPWsk1o1yOLdT6eAlWhoazu8yIDT75lMDl+pbPx3T6RN7t2iEfHBxakqfitX6g6
	Y9NlrZKwHxazZxVVTtQNV0u5LWAw4XaCz0EFK84FVw9dXxy1RDeq1yUud16Pmt+j16V17Ktq
	2abdmXFZmmtXkCq3Ogfv9QM5S352zVrIUsdybsGEwrWMtRPuxCXPnvxSiaU4I9FQi7moOBEA
	9ROoixMDAAA=
X-CMS-MailID: 20241016113752epcas5p4c365819fce1e5d498fd781ae2b309341
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113752epcas5p4c365819fce1e5d498fd781ae2b309341
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113752epcas5p4c365819fce1e5d498fd781ae2b309341@epcas5p4.samsung.com>

From: Kanchan Joshi <joshi.k@samsung.com>

If an iocb contains metadata, extract that and prepare the bip.
Based on flags specified by the user, set corresponding guard/app/ref
tags to be checked in bip.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c         | 51 +++++++++++++++++++++++++++++++++++
 block/fops.c                  | 44 +++++++++++++++++++++++-------
 include/linux/bio-integrity.h |  7 +++++
 3 files changed, 93 insertions(+), 9 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index d3c8b56d3fe6..24fad9b6f3ec 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -12,6 +12,7 @@
 #include <linux/bio.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
+#include <uapi/linux/blkdev.h>
 #include "blk.h"
 
 static struct kmem_cache *bip_slab;
@@ -303,6 +304,55 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
 	return nr_bvecs;
 }
 
+static void bio_uio_meta_to_bip(struct bio *bio, struct uio_meta *meta)
+{
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+
+	if (meta->flags & BLK_INTEGRITY_CHK_GUARD)
+		bip->bip_flags |= BIP_CHECK_GUARD;
+	if (meta->flags & BLK_INTEGRITY_CHK_APPTAG)
+		bip->bip_flags |= BIP_CHECK_APPTAG;
+	if (meta->flags & BLK_INTEGRITY_CHK_REFTAG)
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
+
+	/* should fit into two bytes */
+	BUILD_BUG_ON(BLK_INTEGRITY_VALID_FLAGS >= (1 << 16));
+
+	if (meta->flags && (meta->flags & ~BLK_INTEGRITY_VALID_FLAGS))
+		return -EINVAL;
+
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
+	ret = bio_integrity_map_user(bio, &it, meta->seed);
+	if (!ret) {
+		bio_uio_meta_to_bip(bio, meta);
+		iov_iter_advance(&meta->iter, integrity_bytes);
+		meta->seed += bio_integrity_intervals(bi, bio_sectors(bio));
+	}
+	return ret;
+}
+
 int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter,
 			   u32 seed)
 {
@@ -566,6 +616,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 	bip->bip_vec = bip_src->bip_vec;
 	bip->bip_iter = bip_src->bip_iter;
 	bip->bip_flags = bip_src->bip_flags & BIP_CLONE_FLAGS;
+	bip->app_tag = bip_src->app_tag;
 
 	return 0;
 }
diff --git a/block/fops.c b/block/fops.c
index e696ae53bf1e..59257b209bfb 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -57,6 +57,7 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	struct bio bio;
 	ssize_t ret;
 
+	WARN_ON_ONCE(iocb->ki_flags & IOCB_HAS_METADATA);
 	if (nr_pages <= DIO_INLINE_BIO_VECS)
 		vecs = inline_vecs;
 	else {
@@ -131,6 +132,9 @@ static void blkdev_bio_end_io(struct bio *bio)
 	if (bio->bi_status && !dio->bio.bi_status)
 		dio->bio.bi_status = bio->bi_status;
 
+	if (dio->iocb->ki_flags & IOCB_HAS_METADATA)
+		bio_integrity_unmap_user(bio);
+
 	if (atomic_dec_and_test(&dio->ref)) {
 		if (!(dio->flags & DIO_IS_SYNC)) {
 			struct kiocb *iocb = dio->iocb;
@@ -224,14 +228,16 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 			 * a retry of this from blocking context.
 			 */
 			if (unlikely(iov_iter_count(iter))) {
-				bio_release_pages(bio, false);
-				bio_clear_flag(bio, BIO_REFFED);
-				bio_put(bio);
-				blk_finish_plug(&plug);
-				return -EAGAIN;
+				ret = -EAGAIN;
+				goto fail;
 			}
 			bio->bi_opf |= REQ_NOWAIT;
 		}
+		if (!is_sync && (iocb->ki_flags & IOCB_HAS_METADATA)) {
+			ret = bio_integrity_map_iter(bio, iocb->private);
+			if (unlikely(ret))
+				goto fail;
+		}
 
 		if (is_read) {
 			if (dio->flags & DIO_SHOULD_DIRTY)
@@ -272,6 +278,14 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 
 	bio_put(&dio->bio);
 	return ret;
+
+fail:
+	bio_release_pages(bio, false);
+	bio_clear_flag(bio, BIO_REFFED);
+	bio_put(bio);
+	blk_finish_plug(&plug);
+	return ret;
+
 }
 
 static void blkdev_bio_end_io_async(struct bio *bio)
@@ -289,6 +303,9 @@ static void blkdev_bio_end_io_async(struct bio *bio)
 		ret = blk_status_to_errno(bio->bi_status);
 	}
 
+	if (iocb->ki_flags & IOCB_HAS_METADATA)
+		bio_integrity_unmap_user(bio);
+
 	iocb->ki_complete(iocb, ret);
 
 	if (dio->flags & DIO_SHOULD_DIRTY) {
@@ -333,10 +350,8 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		bio_iov_bvec_set(bio, iter);
 	} else {
 		ret = bio_iov_iter_get_pages(bio, iter);
-		if (unlikely(ret)) {
-			bio_put(bio);
-			return ret;
-		}
+		if (unlikely(ret))
+			goto out_bio_put;
 	}
 	dio->size = bio->bi_iter.bi_size;
 
@@ -349,6 +364,13 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		task_io_account_write(bio->bi_iter.bi_size);
 	}
 
+	if (iocb->ki_flags & IOCB_HAS_METADATA) {
+		ret = bio_integrity_map_iter(bio, iocb->private);
+		WRITE_ONCE(iocb->private, NULL);
+		if (unlikely(ret))
+			goto out_bio_put;
+	}
+
 	if (iocb->ki_flags & IOCB_ATOMIC)
 		bio->bi_opf |= REQ_ATOMIC;
 
@@ -363,6 +385,10 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		submit_bio(bio);
 	}
 	return -EIOCBQUEUED;
+
+out_bio_put:
+	bio_put(bio);
+	return ret;
 }
 
 static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index a9dd0594dfc8..ec792873f2d5 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -24,6 +24,7 @@ struct bio_integrity_payload {
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
 	unsigned short		bip_max_vcnt;	/* integrity bio_vec slots */
 	unsigned short		bip_flags;	/* control flags */
+	u16			app_tag;	/* application tag value */
 
 	struct bvec_iter	bio_iter;	/* for rewinding parent bio */
 
@@ -90,6 +91,7 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio, gfp_t gfp,
 int bio_integrity_add_page(struct bio *bio, struct page *page, unsigned int len,
 		unsigned int offset);
 int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter, u32 seed);
+int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta);
 void bio_integrity_unmap_user(struct bio *bio);
 bool bio_integrity_prep(struct bio *bio);
 void bio_integrity_advance(struct bio *bio, unsigned int bytes_done);
@@ -121,6 +123,11 @@ static inline int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter,
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


