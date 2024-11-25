Return-Path: <io-uring+bounces-5037-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DD4249D7C8E
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 09:09:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F8AEB228E6
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 08:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA12188A0C;
	Mon, 25 Nov 2024 08:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IiOBRd3V"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0F118A924
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732522149; cv=none; b=t8fDF90KQDDzlVZc7vFCHOQ5p3FqydpmjP3+2EaR4qjjM1goKHoIetK0UfElxOzUqu0Iie81mmAnqxhdhkrupY502BiwWL8lG87KCnmvD+kZnyv5UO06Z4s5Q6mAGJ4jGO5VofeVOR6+oXJpYJ0cjYtM8lVEMBbIHTqU++Z5wZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732522149; c=relaxed/simple;
	bh=3+EpeSIcCbF/6ZjkqBAtW4O9T46NdqwVVHXXGudPBqs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=uaum63dKhybEPSsmr6EizRVMjo4sUm3V2YKhHX2l4fADkMOPGJMfK6RzHkBHDBm4jrm2SgIYPfj533BrkMb2LppBonOR7DCIBwarXVIneM7PTQoPtUuUOgMOoXWuB/HjSxvSHF2geQLtUfWqg8Kz+adxR+DSj44GM/NQV1PAhTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IiOBRd3V; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241125080905epoutp0235ff947d59f715405be5aabef5c0d0b4~LJ7ZEUrfv2011320113epoutp02R
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:09:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241125080905epoutp0235ff947d59f715405be5aabef5c0d0b4~LJ7ZEUrfv2011320113epoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732522145;
	bh=wQsh5MEv2xvuMdMfRC5hx+1fVZ+6hqXmEyHQLubiY3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IiOBRd3VdE0CFYnDxLYf7yWZhycFvdyYIgUBc7YGjpAeHUvhAJiZZ3FDdCgoireTf
	 rrNHcWUEPiX9jaq9FJEEAsqokfuLtm8OAVI5FwI7Qf8iWCfxOJUtH+DRE36hzuuaJp
	 UXwPKrk7xgydaNeSDXNy0ENK1A4WktaDAErjX+5g=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241125080904epcas5p2a2b062f3df3661b7c9fe3be95daea41d~LJ7YhXdLs2571325713epcas5p2K;
	Mon, 25 Nov 2024 08:09:04 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XxddW1Qxdz4x9QG; Mon, 25 Nov
	2024 08:09:03 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D5.DF.20052.F9034476; Mon, 25 Nov 2024 17:09:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241125071513epcas5p28b1c27bc43262eb575d576e32f8e3d7b~LJMW5CQMt0301003010epcas5p2U;
	Mon, 25 Nov 2024 07:15:13 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241125071513epsmtrp2809e4950879250e1150cd3cc9f0925d8~LJMW4MfQc0299802998epsmtrp2d;
	Mon, 25 Nov 2024 07:15:13 +0000 (GMT)
X-AuditID: b6c32a49-3d20270000004e54-49-6744309fc76d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	32.AE.18937.10424476; Mon, 25 Nov 2024 16:15:13 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241125071510epsmtip1805f7c732c008101b63f5dc352fc2828~LJMUcCQnb0361903619epsmtip1w;
	Mon, 25 Nov 2024 07:15:10 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v10 10/10] block: add support to pass user meta buffer
Date: Mon, 25 Nov 2024 12:36:33 +0530
Message-Id: <20241125070633.8042-11-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241125070633.8042-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJsWRmVeSWpSXmKPExsWy7bCmlu58A5d0g8VnWC0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orJtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B+UlIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fY
	KqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZxzbep+xoNuy4vrllYwNjBf0uhg5OSQE
	TCT+tZ1l6mLk4hAS2M0osXT3QmYI5xOjxJH+3ywgVWBO311nmI7tBy+xQsR3Mkp82FAI0fCZ
	UeLLgfPsIAk2AXWJI89bGUESIgJ7GCV6F55mAXGYBSYwSSyYvoUZpEpYwE1ib+9XsA4WAVWJ
	znUzwNbxClhKHLx6hBFinbzEzEvfwWo4geJv2w5A1QhKnJz5BMxmBqpp3job7G4JgQscEjum
	zGOBaHaRuNu0nBXCFpZ4dXwLO4QtJfH53V42CDtd4sflp0wQdoFE87F9UIvtJVpP9QMN5QBa
	oCmxfpc+RFhWYuqpdUwQe/kken8/gWrlldgxD8ZWkmhfOQfKlpDYe66BCWSMhICHxKNmNkho
	9TBKXNlzm2UCo8IsJO/MQvLOLITNCxiZVzFKphYU56anFpsWGOallsNjOTk/dxMjOJ1ree5g
	vPvgg94hRiYOxkOMEhzMSiK8fOLO6UK8KYmVValF+fFFpTmpxYcYTYHhPZFZSjQ5H5hR8kri
	DU0sDUzMzMxMLI3NDJXEeV+3zk0REkhPLEnNTk0tSC2C6WPi4JRqYNoYUbxdTXCW7SpvJq6e
	vc/CLSU75v7m3C3k9LipLPbQfs8F+ztnGIbnnRa1EWzKuprRNYmntfPSLaammBmJT14trfi7
	buMWWx11Lb05XpZTHbbt/C8qkz9PummCJtdMsfJ7XeoHYl0u+Op9eXB/z1Sd0j9pxT1L1M6c
	ZPDVeHjo0EzeTULt+asWS2xWr3o5Wag+tOTrZfXQKaqLJR+xXf4SULV8T/WeNdxTQ1b2ZlSv
	m3WXXzgwSFpx8qE64aRVr9c5b1u+s2jt8f23imfnuL1I3XX3YdKfXbZ5G3J7dVd9rEn46bnY
	64qle9LNbxkdRzPZI6qt9uTtVH+tfSP9yI0lz/5sv3TdxnaT7LGHhh1KLMUZiYZazEXFiQCp
	S6FmcAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWy7bCSnC6jiku6Qf9THouPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8XR/2/ZLCYdusZosfeWtsWe
	vSdZLOYve8pu0X19B5vF8uP/mCzO/z3OanF+1hx2ByGPnbPusntcPlvqsWlVJ5vH5iX1Hrtv
	NrB5fHx6i8Wjb8sqRo8zC46we3zeJOex6clbpgCuKC6blNSczLLUIn27BK6MY1vvMxZ0W1Zc
	v7ySsYHxgl4XIyeHhICJxPaDl1i7GLk4hAS2M0p8XXyLESIhIXHq5TIoW1hi5b/n7BBFHxkl
	1q/vAkuwCahLHHneCmaLCJxglJg/0Q2kiFlgBpPE7z8LWEASwgJuEnt7v7KD2CwCqhKd62aA
	xXkFLCUOXj0CtUFeYual72A1nEDxt20HwGqEBCwkZnWuZIWoF5Q4OfMJWJwZqL5562zmCYwC
	s5CkZiFJLWBkWsUomlpQnJuem1xgqFecmFtcmpeul5yfu4kRHGtaQTsYl63/q3eIkYmD8RCj
	BAezkggvn7hzuhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFe5ZzOFCGB9MSS1OzU1ILUIpgsEwen
	VAOTQd1Ei7M/V8/buv6vYvySJkGdnMe7bk5pW/Fy+af430nn+R7dZ7vuzdXw08h38Zngjxr3
	5zbHXt7RJdS+Ztecmvsu0qff7woOrNp5bekBFQ2+L38PbTSRm+27aeNxvz2z/jas8Usym7i6
	dh5H+qxv5739D2ZMTeyW3q7s4sqz7sZZxVsMb5PXvGhd0auSa2g277v1ITvJBr2Mt+qbTWtk
	Yk5nHd+vE8PAV5H8UKJ+e2zZ1O9tzoUmC1SPrI5YFSRSascwaY3mtwv8r5IcGS690Lxy5NYZ
	L/kjBz+rXlf45mHWf3vKnmQ154lL9/rMk/zGwfr6jtj6iIgi999Raj+vnWXXXldjkWwbHSpt
	taDipxJLcUaioRZzUXEiAAgRP4okAwAA
X-CMS-MailID: 20241125071513epcas5p28b1c27bc43262eb575d576e32f8e3d7b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241125071513epcas5p28b1c27bc43262eb575d576e32f8e3d7b
References: <20241125070633.8042-1-anuj20.g@samsung.com>
	<CGME20241125071513epcas5p28b1c27bc43262eb575d576e32f8e3d7b@epcas5p2.samsung.com>

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
index 2d01c9007681..412ae74032ad 100644
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


