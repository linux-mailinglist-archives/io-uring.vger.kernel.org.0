Return-Path: <io-uring+bounces-4145-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB3A9B50CD
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 18:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38D79283965
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 17:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E0A2071EC;
	Tue, 29 Oct 2024 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tXdogbB3"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883C81FF7C2
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 17:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222759; cv=none; b=urd+I8wdsiucY9dhLz8WAl1K56sqBJMgMrNS/kfKrtWLS9bFpYjnKfbi8f+rXSRUZhM+mS3VjnUzN1GnNKhY+30jWhAhCvmJNiubDtcDNubz5NanZ5qtHYgmWjyhnsz9mqbhybziXErXeUoW5uv5aWM6vo+R+e3/QsWiz/aT7EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222759; c=relaxed/simple;
	bh=L7o3ib0+EsbTdZxLS11SB4JXmC4qf7Dn9qpf4MMoYGI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=gh3EHaxq6zWCD/CygE/hHXSvNpkGs86PjrQdwKM+dW6E3HoVddhakBF+qJqjXT6/SJ+GC09V7r4SRV2Iw75D9wiUMPQ9QZn0QKuN3b5ncDH2PMyyi5krSgIdIdZvk4u7qD0WFXDzrxVtsu8VE5/8qTKR0EWX5FDDjAUi1wcdtAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=tXdogbB3; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241029172554epoutp01e8b7582607c015f40be034fc75b34214~C-G2YtdSl3157231572epoutp01I
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 17:25:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241029172554epoutp01e8b7582607c015f40be034fc75b34214~C-G2YtdSl3157231572epoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730222754;
	bh=2foZeewvSQYZTb+J5+1KUDb+ESQXlAssFb4T+K85poc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXdogbB3ZMMdjpH+E9ZGb5NdI34Jk+c6X+R+Uc5r9zHQXYrSh+rUFJbo6ao2OGT3x
	 CAncO8uG2NM934W9vhgt6+uHsqFnfdPMZRAz3eepRGa6iyRl2zK+b/rFImzddc+RLN
	 AAXa6C4UiYq8qM8fahO5aO/XRmkpGonjFQ6fa4RQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241029172553epcas5p4be7f2012462fdcf2c5a921c761e36c88~C-G1S8JvQ1348313483epcas5p4d;
	Tue, 29 Oct 2024 17:25:53 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XdHGR4Nnnz4x9Pp; Tue, 29 Oct
	2024 17:25:51 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	97.7F.09800.F9A11276; Wed, 30 Oct 2024 02:25:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241029163235epcas5p340ce6d131cc7bf220db978a2d4dc24c2~C_YTZ8EHL1013110131epcas5p3j;
	Tue, 29 Oct 2024 16:32:35 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241029163235epsmtrp22684874ace9623df1e50818911f04cd8~C_YTY_V5G1621316213epsmtrp2K;
	Tue, 29 Oct 2024 16:32:35 +0000 (GMT)
X-AuditID: b6c32a4b-4a7fa70000002648-a9-67211a9f88a6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	D0.19.18937.32E01276; Wed, 30 Oct 2024 01:32:35 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241029163233epsmtip23d279260c8fc2654bbb56d837ab74132~C_YQ_LO9c0998409984epsmtip2d;
	Tue, 29 Oct 2024 16:32:33 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v5 10/10] block: add support to pass user meta buffer
Date: Tue, 29 Oct 2024 21:54:02 +0530
Message-Id: <20241029162402.21400-11-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241029162402.21400-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJsWRmVeSWpSXmKPExsWy7bCmlu58KcV0g1k/FS0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orJtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B+UlIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fY
	KqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZzy918JY0G1esbD5HksDY6tuFyMHh4SA
	icTSdq4uRi4OIYHdjBLtz+4zQjifGCV+vdzMCuds3feSvYuRE6xjflsfG0RiJ6NEw1sY5zOj
	xIRjP8Gq2ATUJY48bwWbJSKwh1Gid+FpFhCHWWACk8SC6VuYQaqEBVwlWpobWEBsFgFViRX7
	boDZvAJWEtta57FA7JOXmHnpO9hUTqD4saN7mCBqBCVOznwCVsMMVNO8dTYzRP0FDolznWYQ
	37lI/PxbBxEWlnh1fAvUC1ISn9/tZYOw0yV+XH7KBGEXSDQf28cIYdtLtJ7qZwYZwyygKbF+
	lz5EWFZi6ql1TBBb+SR6fz+BauWV2DEPxlaSaF85B8qWkNh7roEJ4hoPiRnfeCBh1csosfFD
	E+sERoVZSJ6ZheSZWQibFzAyr2KUTC0ozk1PLTYtMM5LLYdHcnJ+7iZGcDLX8t7B+OjBB71D
	jEwcjIcYJTiYlUR4V8fKpgvxpiRWVqUW5ccXleakFh9iNAWG9kRmKdHkfGA+ySuJNzSxNDAx
	MzMzsTQ2M1QS533dOjdFSCA9sSQ1OzW1ILUIpo+Jg1OqgWl+x7w5V2VSPrE80Onwd4z5oNXg
	XrBu9zmmbYtcJH48sLv6es7jxffDzy7dtaeyIKss3ynm9so29ZM+8lffhm5c+j+KLfLy27vn
	lSO1fk85lKQ5TeRMbrNaVPhtvr9i9gvE7FedbNFY0svo7svBsFjz69srWd0Cgr3Hj9TN84vu
	drwp3X+2Obm3LGR1vMHdvH7dh5faJr3qX7fu9Ya6/uX1U+ptXqo/5bj0tjl6+Rw587cz6w7G
	VPo8u1duEpjzx37t6p5NuwJyOm8vXjc9McboS3Kvnq28UNoRP0bT61zaS77NE75ygPP2Ep3V
	p5u+sHlFTJNgYkza1Zz66OTGnz8mlIodM3kX4GVd41F5olGJpTgj0VCLuag4EQCq6sFybwQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSvK4yn2K6wbKfOhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUVw2Kak5mWWpRfp2CVwZT++1MBZ0m1cs
	bL7H0sDYqtvFyMkhIWAiMb+tj62LkYtDSGA7o8TqtmeMEAkJiVMvl0HZwhIr/z1nhyj6yChx
	9ORBFpAEm4C6xJHnrWBFIgInGCXmT3QDKWIWmMEk8fvPArAiYQFXiZbmBjCbRUBVYsW+G2A2
	r4CVxLbWeSwQG+QlZl76zg5icwLFjx3dw9TFyAG0zVLi5CQ3iHJBiZMzn4CVMwOVN2+dzTyB
	UWAWktQsJKkFjEyrGEVTC4pz03OTCwz1ihNzi0vz0vWS83M3MYIjTStoB+Oy9X/1DjEycTAe
	YpTgYFYS4V0dK5suxJuSWFmVWpQfX1Sak1p8iFGag0VJnFc5pzNFSCA9sSQ1OzW1ILUIJsvE
	wSnVwCQ3X7xqsfW5iz2+nH+vTq/v67uyNuNIknqRQl7DEnmLOBanjHMT326a+189bK6fSH1z
	Yiv37LO3WD/pXpM+mrjE7EPrnelRggv3+Yc6NHg/6VWR2BHCzbFAclVIS5JYUOuX8IordYov
	fmQdn3fVPmzF2UrFD577ZrCX7cl4ElSkV2v57JHrosc3/e8+eN408+OTTff9+SX3Jb6Zqp92
	5MbOuB1e/nEy6wymy4gKV4XubD/sK3bgG1dJ4dPdtWwdXxaorz8tE8ltdW7R3ZzkVbNUJ8Xn
	a6Xlv8pZe//Yy4zHPfxXGP74ud38bb5dwCiEq0mvwMp8vrztvbMPhDgEL9yf66OZu7hO6M3f
	2p28DEosxRmJhlrMRcWJAGAapGAjAwAA
X-CMS-MailID: 20241029163235epcas5p340ce6d131cc7bf220db978a2d4dc24c2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241029163235epcas5p340ce6d131cc7bf220db978a2d4dc24c2
References: <20241029162402.21400-1-anuj20.g@samsung.com>
	<CGME20241029163235epcas5p340ce6d131cc7bf220db978a2d4dc24c2@epcas5p3.samsung.com>

From: Kanchan Joshi <joshi.k@samsung.com>

If an iocb contains metadata, extract that and prepare the bip.
Based on flags specified by the user, set corresponding guard/app/ref
tags to be checked in bip.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c         | 50 +++++++++++++++++++++++++++++++++++
 block/fops.c                  | 42 ++++++++++++++++++++++-------
 include/linux/bio-integrity.h |  7 +++++
 3 files changed, 90 insertions(+), 9 deletions(-)

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
index 2d01c9007681..3cf7e15eabbc 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -54,6 +54,7 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	struct bio bio;
 	ssize_t ret;
 
+	WARN_ON_ONCE(iocb->ki_flags & IOCB_HAS_METADATA);
 	if (nr_pages <= DIO_INLINE_BIO_VECS)
 		vecs = inline_vecs;
 	else {
@@ -128,6 +129,9 @@ static void blkdev_bio_end_io(struct bio *bio)
 	if (bio->bi_status && !dio->bio.bi_status)
 		dio->bio.bi_status = bio->bi_status;
 
+	if (dio->iocb->ki_flags & IOCB_HAS_METADATA)
+		bio_integrity_unmap_user(bio);
+
 	if (atomic_dec_and_test(&dio->ref)) {
 		if (!(dio->flags & DIO_IS_SYNC)) {
 			struct kiocb *iocb = dio->iocb;
@@ -221,14 +225,16 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
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
@@ -269,6 +275,12 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 
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
@@ -286,6 +298,9 @@ static void blkdev_bio_end_io_async(struct bio *bio)
 		ret = blk_status_to_errno(bio->bi_status);
 	}
 
+	if (iocb->ki_flags & IOCB_HAS_METADATA)
+		bio_integrity_unmap_user(bio);
+
 	iocb->ki_complete(iocb, ret);
 
 	if (dio->flags & DIO_SHOULD_DIRTY) {
@@ -330,10 +345,8 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
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
 
@@ -346,6 +359,13 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
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
 
@@ -360,6 +380,10 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
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
index fe2bfe122db2..96ec559c24ef 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -24,6 +24,7 @@ struct bio_integrity_payload {
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
 	unsigned short		bip_max_vcnt;	/* integrity bio_vec slots */
 	unsigned short		bip_flags;	/* control flags */
+	u16			app_tag;	/* application tag value */
 
 	struct bvec_iter	bio_iter;	/* for rewinding parent bio */
 
@@ -80,6 +81,7 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio, gfp_t gfp,
 int bio_integrity_add_page(struct bio *bio, struct page *page, unsigned int len,
 		unsigned int offset);
 int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter);
+int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta);
 void bio_integrity_unmap_user(struct bio *bio);
 bool bio_integrity_prep(struct bio *bio);
 void bio_integrity_advance(struct bio *bio, unsigned int bytes_done);
@@ -110,6 +112,11 @@ static int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
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


