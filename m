Return-Path: <io-uring+bounces-5123-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C64669DB6D9
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 12:47:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 02C04B21BE5
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 11:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0870919AD8D;
	Thu, 28 Nov 2024 11:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="vBSD/cGu"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9CB19CD07
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732794395; cv=none; b=gWJic12dk6kGauAxr+DTX1Jj2r8J0akmacWNxRYXY9D9mzOVv0l4lKZIkU+nwVn0uucKNAiJgUWpjXciwrwrM5MRBuv9Mdx8ELQ9c52kUlKjIBQ3DTzFDNSQ8wt7E9knWvMF4gcJ42GX1QcBr+qT5i2s47ZpPbCzkyT51j+FLso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732794395; c=relaxed/simple;
	bh=kEqfDPfi0xZPoMx7TbXTPzl3V67dpIdB/wO9T8QGsD8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=plIr5WyDlSlpPg3zVmnQUiIMCuiVktyw7hRFdXjMANyBxqO0bRl40FgOc/VMEHvn7a4hrcPPWyE0k8h/4o7PH7AtVNFHj3c3Dat30/oZnPJsZlyDhAE8jUTZ37R+jdcWc38YiDfEwmWdW0wb/MdLPjnk5v2v9nf2MO13klzNroc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=vBSD/cGu; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241128114632epoutp02e141b1ea9e2f0e0a2d84dee1d2c18025~MH1GtlVmZ1279812798epoutp02V
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241128114632epoutp02e141b1ea9e2f0e0a2d84dee1d2c18025~MH1GtlVmZ1279812798epoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732794392;
	bh=d7IuD/yxn+cNW60OVSwUUjLSGF7ezLOBWTKcR1ap47Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vBSD/cGuPXdNYoc2oCmQOSKikC7TQfg5dtAe821TM5qqv0eem9qNMsE0PERik59jr
	 JBEOAJelK41a33oW89N1Ryxo1Wo/fJsVoHpoA11mxx9bcvRPq6f8amkrCmAzKcmhFA
	 iCS9BVMrJBylzUCCgFEq6FF6NyPtHFT6lJgygYew=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241128114631epcas5p17b378bbf8f41f4d6f91d9e4032f4a1ec~MH1GTxa743041830418epcas5p1B;
	Thu, 28 Nov 2024 11:46:31 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XzZK20WNzz4x9Pq; Thu, 28 Nov
	2024 11:46:30 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	1E.6A.19956.51858476; Thu, 28 Nov 2024 20:46:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241128113120epcas5p3bd415b5a09b3d5b793cbdda0b4102a62~MHn1O4bZj2976029760epcas5p32;
	Thu, 28 Nov 2024 11:31:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241128113120epsmtrp192704f60e46ce0995d3c92d7924b2b06~MHn1M6lbu0066100661epsmtrp1K;
	Thu, 28 Nov 2024 11:31:20 +0000 (GMT)
X-AuditID: b6c32a4b-fe9f470000004df4-75-67485815dcf7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CB.0D.18729.88458476; Thu, 28 Nov 2024 20:31:20 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241128113117epsmtip2b6d67c9095883ad831492e3125ab3f15~MHnyv0CSu2086720867epsmtip2k;
	Thu, 28 Nov 2024 11:31:17 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v11 10/10] block: add support to pass user meta buffer
Date: Thu, 28 Nov 2024 16:52:40 +0530
Message-Id: <20241128112240.8867-11-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241128112240.8867-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJsWRmVeSWpSXmKPExsWy7bCmuq5ohEe6wYJdVhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUdk2GamJKalFCql5yfkpmXnptkrewfHO
	8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA/KSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0ts
	lVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyM/p27mQt6Las+No7k7mB8YJeFyMnh4SA
	icS6J58Zuxi5OIQEdjNKbP2ylR3C+cQo8fPeQjYI5xujRMvluywwLW2X1kC17GWUONx7CKrq
	M6PEuZ42ZpAqNgF1iSPPW8GqRAT2MEr0LjzNAuIwC0xgklgwfQtYlbCAm8Tniz/YQGwWAVWJ
	rsuTgGwODl4BS4mex9oQ6+QlZl76zg5icwKFZ1/7xgpi8woISpyc+QTsJGagmuats5lB5ksI
	3OCQ2PjmICtEs4tE25k3ULawxKvjW9ghbCmJl/1tUHa6xI/LT5kg7AKJ5mP7GCFse4nWU/3M
	IPcwC2hKrN+lDxGWlZh6ah0TxF4+id7fT6BaeSV2zIOxlSTaV86BsiUk9p5rgLI9JPbuesMC
	Ca0eRolrm78wTWBUmIXkn1lI/pmFsHoBI/MqRsnUguLc9NRi0wLjvNRyeDwn5+duYgSndC3v
	HYyPHnzQO8TIxMF4iFGCg1lJhLeA2z1diDclsbIqtSg/vqg0J7X4EKMpMLwnMkuJJucDs0pe
	SbyhiaWBiZmZmYmlsZmhkjjv69a5KUIC6YklqdmpqQWpRTB9TBycUg1M3rOFX0T+uaa8yPbh
	MouewsCASa9XTjjbJjXVNPjIFd2lHlf1Xkicu/dG8t6hrhrWBsbCBh/Hqq5LE7Tjllpcq/Lf
	Z5tpxND+ylp2RkK2aSTD7oeO8cEX9k/7VNbi5CLYmfOzPV/9F8e9RaWJeepzkztznrTvrs7J
	4vjsrXNWOOnMbsUpj3JnGORmXG6Y3WnmriR+RjPP+cIKF8b9qw8vlst4cmSt1er38iU2Ite9
	l+w6vyE3+Y1G+FOj4wbCobYmi2qfmi+dvKLQ9YrAzeBznW8nvX+328fk3+YAw4ObLkyqndjN
	ZlHWwvxzn1+fDU906PHukzMXl68IauWK3bWw1kFi5xyZP3MWPZnUb/BaiaU4I9FQi7moOBEA
	hjYAvHIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWy7bCSvG5HiEe6QcsNZouPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8XR/2/ZLCYdusZosfeWtsWe
	vSdZLOYve8pu0X19B5vF8uP/mCzO/z3OanF+1hx2ByGPnbPusntcPlvqsWlVJ5vH5iX1Hrtv
	NrB5fHx6i8Wjb8sqRo8zC46we3zeJOex6clbpgCuKC6blNSczLLUIn27BK6Mvp07WQu6LSu+
	9s5kbmC8oNfFyMkhIWAi0XZpDSOILSSwm1Hi7c4kiLiExKmXyxghbGGJlf+es0PUfASqeRYK
	YrMJqEsced4KViMicIJRYv5Ety5GLg5mgRlMEr//LGABSQgLuEl8vviDDcRmEVCV6Lo8Ccjm
	4OAVsJToeawNMV9eYual72DzOYHCs699Y4XYZSFx+fF1MJtXQFDi5MwnYCOZgeqbt85mnsAo
	MAtJahaS1AJGplWMkqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMHRpqW5g3H7qg96hxiZ
	OBgPMUpwMCuJ8BZwu6cL8aYkVlalFuXHF5XmpBYfYpTmYFES5xV/0ZsiJJCeWJKanZpakFoE
	k2Xi4JRqYNos3R7G8Gpvu21Gc93KarO6HZKrlwTY/p0zvfeOjeCxD1/+1tcaCgjU1B4XOe8V
	80Vnfu6f1cZ3ctS+PQzf7Tpr8rL9769HS1bI/3y/hrP28It6qeL9T9S727ZYzo7v1djFukrR
	dYew+bUqt5Nvw7LtpaOdZq7VvV1z8+o0XbVzv1LWX34m1rRB8uq0dXYaEtNC+TpN+nZwrNrt
	UZb211jSIOxJ9r/VNxpY5jhIn7qXMjFespjT8VHdyfqHcZorP99Q3XN+n6DfnT/bZzd1X9a4
	7WBTb7b4l6z4TenurffflVRVG6UpyUvcq1+cV/9ec8WytRVJHOfubDPRflAiOmvVdxeHX+X3
	J26/0LCgZocSS3FGoqEWc1FxIgC+HvS6JQMAAA==
X-CMS-MailID: 20241128113120epcas5p3bd415b5a09b3d5b793cbdda0b4102a62
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241128113120epcas5p3bd415b5a09b3d5b793cbdda0b4102a62
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113120epcas5p3bd415b5a09b3d5b793cbdda0b4102a62@epcas5p3.samsung.com>

From: Kanchan Joshi <joshi.k@samsung.com>

If an iocb contains metadata, extract that and prepare the bip.
Based on flags specified by the user, set corresponding guard/app/ref
tags to be checked in bip.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c         | 50 +++++++++++++++++++++++++++++++++++
 block/fops.c                  | 45 ++++++++++++++++++++++++-------
 include/linux/bio-integrity.h |  7 +++++
 3 files changed, 92 insertions(+), 10 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 3bee43b87001..5d81ad9a3d20 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -364,6 +364,55 @@ int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 	return ret;
 }
 
+static void bio_uio_meta_to_bip(struct bio *bio, struct uio_meta *meta)
+{
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+
+	if (meta->flags & IO_INTEGRITY_CHK_GUARD)
+		bip->bip_flags |= BIP_CHECK_GUARD;
+	if (meta->flags & IO_INTEGRITY_CHK_APPTAG)
+		bip->bip_flags |= BIP_CHECK_APPTAG;
+	if (meta->flags & IO_INTEGRITY_CHK_REFTAG)
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
+	/* should fit into two bytes */
+	BUILD_BUG_ON(IO_INTEGRITY_VALID_FLAGS >= (1 << 16));
+
+	if (meta->flags && (meta->flags & ~IO_INTEGRITY_VALID_FLAGS))
+		return -EINVAL;
+
+	it.count = integrity_bytes;
+	ret = bio_integrity_map_user(bio, &it);
+	if (!ret) {
+		bio_uio_meta_to_bip(bio, meta);
+		bip_set_seed(bio_integrity(bio), meta->seed);
+		iov_iter_advance(&meta->iter, integrity_bytes);
+		meta->seed += bio_integrity_intervals(bi, bio_sectors(bio));
+	}
+	return ret;
+}
+
 /**
  * bio_integrity_prep - Prepare bio for integrity I/O
  * @bio:	bio to prepare
@@ -564,6 +613,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 	bip->bip_vec = bip_src->bip_vec;
 	bip->bip_iter = bip_src->bip_iter;
 	bip->bip_flags = bip_src->bip_flags & BIP_CLONE_FLAGS;
+	bip->app_tag = bip_src->app_tag;
 
 	return 0;
 }
diff --git a/block/fops.c b/block/fops.c
index 13a67940d040..6d5c4fc5a216 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -54,6 +54,7 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	struct bio bio;
 	ssize_t ret;
 
+	WARN_ON_ONCE(iocb->ki_flags & IOCB_HAS_METADATA);
 	if (nr_pages <= DIO_INLINE_BIO_VECS)
 		vecs = inline_vecs;
 	else {
@@ -124,12 +125,16 @@ static void blkdev_bio_end_io(struct bio *bio)
 {
 	struct blkdev_dio *dio = bio->bi_private;
 	bool should_dirty = dio->flags & DIO_SHOULD_DIRTY;
+	bool is_sync = dio->flags & DIO_IS_SYNC;
 
 	if (bio->bi_status && !dio->bio.bi_status)
 		dio->bio.bi_status = bio->bi_status;
 
+	if (!is_sync && (dio->iocb->ki_flags & IOCB_HAS_METADATA))
+		bio_integrity_unmap_user(bio);
+
 	if (atomic_dec_and_test(&dio->ref)) {
-		if (!(dio->flags & DIO_IS_SYNC)) {
+		if (!is_sync) {
 			struct kiocb *iocb = dio->iocb;
 			ssize_t ret;
 
@@ -221,14 +226,16 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
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
@@ -269,6 +276,12 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 
 	bio_put(&dio->bio);
 	return ret;
+fail:
+	bio_release_pages(bio, false);
+	bio_clear_flag(bio, BIO_REFFED);
+	bio_put(bio);
+	blk_finish_plug(&plug);
+	return ret;
 }
 
 static void blkdev_bio_end_io_async(struct bio *bio)
@@ -286,6 +299,9 @@ static void blkdev_bio_end_io_async(struct bio *bio)
 		ret = blk_status_to_errno(bio->bi_status);
 	}
 
+	if (iocb->ki_flags & IOCB_HAS_METADATA)
+		bio_integrity_unmap_user(bio);
+
 	iocb->ki_complete(iocb, ret);
 
 	if (dio->flags & DIO_SHOULD_DIRTY) {
@@ -330,10 +346,8 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
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
 
@@ -346,6 +360,13 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
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
 
@@ -360,6 +381,10 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
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
index 2195bc06dcde..de0a6c9de4d1 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -23,6 +23,7 @@ struct bio_integrity_payload {
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
 	unsigned short		bip_max_vcnt;	/* integrity bio_vec slots */
 	unsigned short		bip_flags;	/* control flags */
+	u16			app_tag;	/* application tag value */
 
 	struct bvec_iter	bio_iter;	/* for rewinding parent bio */
 
@@ -78,6 +79,7 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio, gfp_t gfp,
 int bio_integrity_add_page(struct bio *bio, struct page *page, unsigned int len,
 		unsigned int offset);
 int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter);
+int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta);
 void bio_integrity_unmap_user(struct bio *bio);
 bool bio_integrity_prep(struct bio *bio);
 void bio_integrity_advance(struct bio *bio, unsigned int bytes_done);
@@ -108,6 +110,11 @@ static int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
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


