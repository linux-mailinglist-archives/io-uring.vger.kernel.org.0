Return-Path: <io-uring+bounces-4683-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE5819C8906
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 12:33:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20D88B3676B
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 11:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 886B71F9AAF;
	Thu, 14 Nov 2024 11:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Cp9skm5P"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C0E18BBBD
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731583085; cv=none; b=Zm0d2iBXn1Fw9KrOYiACOunuVjYP8zpLL3opdNjYdJhEpFRHBRpLpvShzlEaNBqhorsn0OOD4e3TDql7Zf02siximiCDyrK+M6d0pj/n7shuNNhhoBTOCbrwJw/lyAVC1LuaJCP+FQio+v0Ah5xSpjoC3ktIGemLiOpvirC/BlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731583085; c=relaxed/simple;
	bh=3+EpeSIcCbF/6ZjkqBAtW4O9T46NdqwVVHXXGudPBqs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=VfnTi36NtbNXbd1BtiZPF9k18xM5nnuOLEBa43fmGSNysC8e5kz+4DoAhAzy3PAkJRevxSrU0Dc2QWSweVMPFlkViAFS3bIMgN3uHPe0/CXhaZ1tslj/LjhvVcYttpn43F3h1LXxuNrLKRVD/ffQSjbQL4qtTUjLlUf3Wog2bE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Cp9skm5P; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241114111801epoutp01acb54c089df1d4e923cc1e008e28b690~H0aNzyHuI2262522625epoutp01j
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:18:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241114111801epoutp01acb54c089df1d4e923cc1e008e28b690~H0aNzyHuI2262522625epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731583081;
	bh=wQsh5MEv2xvuMdMfRC5hx+1fVZ+6hqXmEyHQLubiY3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cp9skm5Pax253NR5CfYcDYeLeXtgUcijYAsQ4cTUwDr4VYzr4yuXpkRUQOrVOPxo0
	 bb03SDf6TFKebgsST6dtCFDTLe+kZ9kDgepRVjkdME2MgCIvyMzfwKSp/IwOyb+QHi
	 N8heK0QYlVB/0QeLA/Ms2eNKrHNCNavOFqyxWe1M=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241114111800epcas5p24f2a38b47cb535e73434a76cb543107f~H0aM1lEAO1772717727epcas5p2_;
	Thu, 14 Nov 2024 11:18:00 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XpyLZ6bWsz4x9Pr; Thu, 14 Nov
	2024 11:17:58 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	49.B0.09800.66CD5376; Thu, 14 Nov 2024 20:17:58 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241114105418epcas5p1537d72b9016d10670cf97751704e2cc8~H0Fgsu3Hq2293722937epcas5p1c;
	Thu, 14 Nov 2024 10:54:18 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241114105418epsmtrp14c7709d8112021db81643c021868707b~H0FgrzgDS1676716767epsmtrp1k;
	Thu, 14 Nov 2024 10:54:18 +0000 (GMT)
X-AuditID: b6c32a4b-4a7fa70000002648-db-6735dc66072e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	14.B0.35203.AD6D5376; Thu, 14 Nov 2024 19:54:18 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241114105416epsmtip2a5420b9a1220b737b69105d53c9cce6e~H0FeLEzHm1110111101epsmtip24;
	Thu, 14 Nov 2024 10:54:16 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v9 11/11] block: add support to pass user meta buffer
Date: Thu, 14 Nov 2024 16:15:17 +0530
Message-Id: <20241114104517.51726-12-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241114104517.51726-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJsWRmVeSWpSXmKPExsWy7bCmhm7aHdN0g02njCw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orJtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B+UlIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fY
	KqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZxzbep+xoNuy4vrllYwNjBf0uhg5OSQE
	TCT6Z25n6mLk4hAS2M0ocfLHThYI5xOjxOEnT6Ay3xglJrZdYIRp+bVhERtEYi+jxL1H3VBV
	nxkleq+uZQGpYhNQlzjyvJURJCEisAcosfA02GBmgQlMEgumb2EGqRIWcJX41vqbvYuRg4NF
	QFVi39sokDCvgJXEkhvzmSDWyUvMvPSdHcTmBIqvaNjKDFEjKHFy5hOwZcxANc1bZzODzJcQ
	uMEh8fX+WahmF4l5jQ/ZIWxhiVfHt0DZUhIv+9ug7HSJH5efQtUXSDQf2wf1p71E66l+ZpDb
	mAU0Jdbv0ocIy0pMPbWOCWIvn0Tv7ydQrbwSO+bB2EoS7SvnQNkSEnvPNUDZHhL7Xp9lhYRW
	L6NE0+t9LBMYFWYh+WcWkn9mIaxewMi8ilEytaA4Nz212LTAOC+1HB7Pyfm5mxjBKV3Lewfj
	owcf9A4xMnEwHmKU4GBWEuE95WycLsSbklhZlVqUH19UmpNafIjRFBjeE5mlRJPzgVklryTe
	0MTSwMTMzMzE0tjMUEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGJsZZir4Ltoub5V8/l9r3
	cZl89KH3V88/Tlsh80ZJ4rKq0zsn9/TJffdjts+3tItJmnZk3WuGUN1PZ32dpx35E5Q5IdLX
	cX2D1l/n3jmL2Z9wJKZ0qQlyp0+9kdaqKn3Obvci9dpc7STH3t33z3TJ/TX4qLhnYdXPS4ZH
	Sl6ci3b+n/3+1gPDrduMdO/P7w75HOe0+NLXH5EZe3geeX89HCltr2llJ7/4/f0p9oXOSW5e
	CSElW6fdLazjzGm1fF04sVF//+anJUdNI3vT5iqxtFV6el8Ql63yWG5y/tszueaCwg7J5QJb
	fdX+pPDw7PNMu7ZmKuPsQ8zdjLXXzDrmsRZFL9frOvB6+dL2pwFnlViKMxINtZiLihMBVHd0
	BnIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWy7bCSvO6ta6bpBp8+aFl8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSyO/n/LZjHp0DVGi723tC32
	7D3JYjF/2VN2i+7rO9gslh//x2Rx/u9xVovzs+awOwh57Jx1l93j8tlSj02rOtk8Ni+p99h9
	s4HN4+PTWywefVtWMXqcWXCE3ePzJjmPTU/eMgVwRXHZpKTmZJalFunbJXBlHNt6n7Gg27Li
	+uWVjA2MF/S6GDk5JARMJH5tWMQGYgsJ7GaUmNvtCxGXkDj1chkjhC0ssfLfc3aImo+MEnuf
	CoHYbALqEkeet4LViAicYJSYP9Gti5GLg1lgBpPE7z8LWEASwgKuEt9afwM1c3CwCKhK7Hsb
	BRLmFbCSWHJjPhPEfHmJmZe+g83nBIqvaNjKDFIuJGAp8X29CES5oMTJmU/AJjIDlTdvnc08
	gVFgFpLULCSpBYxMqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgmNNS3MH4/ZVH/QO
	MTJxMB5ilOBgVhLhPeVsnC7Em5JYWZValB9fVJqTWnyIUZqDRUmcV/xFb4qQQHpiSWp2ampB
	ahFMlomDU6qBKfH/1mi+4sP35ZLmzCrkOMRZt3ND85f6vSxVH6bUpFWd+pNoqcvfwLFKPGjd
	o/sXxeeZz9Zq9Ks5vvljecbnC7NYtYJrP6Rs0d3F1h/bnN+49ZENh53Bs6BszzdGU1qDGO/L
	TvAu5L3aFnBllU74j8PT0yVeTKzk3MLSdnKOTdw1o2P9QU7vHGMvLrFLCpnKeZtj+69TKdFb
	s6frnV7w4XHwak8l3folS1czJkddWKq53NHg874Ned7TeZuPHZBnWq7ncS3yS3Tkmczs+YcE
	zu3W9Z7HcDPnbWao5FTd+1cvXE+flrLimfnUN+/vzAw5uN4kN7morbDY/nj5rHkzy2Wfzcu7
	Eaksk6jDUGhVp8RSnJFoqMVcVJwIACYv8LYkAwAA
X-CMS-MailID: 20241114105418epcas5p1537d72b9016d10670cf97751704e2cc8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241114105418epcas5p1537d72b9016d10670cf97751704e2cc8
References: <20241114104517.51726-1-anuj20.g@samsung.com>
	<CGME20241114105418epcas5p1537d72b9016d10670cf97751704e2cc8@epcas5p1.samsung.com>

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


