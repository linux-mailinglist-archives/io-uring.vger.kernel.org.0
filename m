Return-Path: <io-uring+bounces-4238-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 944769B6BDC
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 19:11:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22F351F2243D
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:11:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C67F3213141;
	Wed, 30 Oct 2024 18:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QWE0WHPt"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF16213136
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730311831; cv=none; b=ZmNsofrzqVbefbN6+8YTc2YcBjTlmUxAzuQnkKlBkLT8vcG6RgkUdTrNFiyc909d++hJcHafxzfBEWS3Txc37ST6JbrFeF/4xqLckP2s7nvTLOuWi6iqpg7SLHhcj+sEUXSIKuUvJuRcPSb1cop1Oz7RVxYytpFz+NgtW8RlZGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730311831; c=relaxed/simple;
	bh=BPC9QfnCUK7/s4TcRVufyO+i0XBKDsn5DH/1T4BMbuw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=KUz2vf6foLx9FQIQuBzyfHwEhxoFA3VNxxQQxM3ZzzXSn2ViH68NpA1yy3/g8IQbsv1Sfz1m5O6B9iPyW926Ww8Tuw+d/kLMG86bNtTtGeSvMuc0RgQqc2uu06SbM1P6uxf21P5v/cuCUJOMpopwXotkKXPtG50790DwgvZzxUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QWE0WHPt; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241030181027epoutp01b1011f62e558cc1bfa1cdb47598897ed~DTXCDOTIv2480424804epoutp01i
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241030181027epoutp01b1011f62e558cc1bfa1cdb47598897ed~DTXCDOTIv2480424804epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730311827;
	bh=6pisa7CqgV+3Ji79lmJB+2Ri7+98WW38tiiGMkWrIyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWE0WHPtMNUKYj/ojP3rJ/uMkWM83TafJvgZd+vnSQEbQtR8WgZp86Icefz/oQ04p
	 Wx3GZGkTZxwfGJp8Ov87cegAGzRCEoSIDEJpWoxKJ52IQw2T7OnFvy/pWtDhMfVOp7
	 0GtfJiVGRa1qSrJWYkjIumw+7BKqPCTc4TEUYGU4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241030181026epcas5p370b50f7a4e3c989922db0c76ace9f85a~DTXBXS8IJ3148631486epcas5p3K;
	Wed, 30 Oct 2024 18:10:26 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XdwCP04xQz4x9Pp; Wed, 30 Oct
	2024 18:10:25 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	FB.10.09420.09672276; Thu, 31 Oct 2024 03:10:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241030181024epcas5p3964697a08159f8593a6f94764f77a7f3~DTW-St93v1475114751epcas5p39;
	Wed, 30 Oct 2024 18:10:24 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241030181024epsmtrp1a10cae8d245639d8d65820f82c49722b~DTW-R3qtN0151201512epsmtrp1A;
	Wed, 30 Oct 2024 18:10:24 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-01-67227690d601
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9F.78.08229.09672276; Thu, 31 Oct 2024 03:10:24 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241030181021epsmtip24b0ee33856d7ce1e54ed3e737bc522d5~DTW8xCjos0487504875epsmtip2-;
	Wed, 30 Oct 2024 18:10:21 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
	anuj1072538@gmail.com, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v6 10/10] block: add support to pass user meta buffer
Date: Wed, 30 Oct 2024 23:31:12 +0530
Message-Id: <20241030180112.4635-11-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241030180112.4635-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUxTVxjGc+4tbcEUL9WFM0y0XpUFtmKrpR4WYSwgXIYjKDOZksDu6E1h
	0N6mt0WcGOoQwteQ4YwrsOkMRSxbMYgMB0wsEkYyYcNtfCwM3IpDGAtK5HOy9cvN/5487+89
	73nOhxAX3+UHCbO0BkavpXNIvh+vrSckVFqVS6pllh4FevRkjYc+qHqKozprG0BN42f5aLbn
	MUCj3TcxdLWpF0N/FQ3wUO2FQgz1/jPHR9X2nwHqGnsZdXb189DFhikBKh9u56MrfesYGnza
	54MGa+oE0WLqZs24gLp310i1WEv51PX6Aqpj1MSnHk2N8ajKViugvrt0R0AttGylWhxzWLLf
	sez9mQytYvQSRpvBqrK06kgyMSU9Jj1cKZNL5RFoHynR0homkow9mCyNy8pxZiIluXSO0Wkl
	0xxH7o7ar2eNBkaSyXKGSJLRqXJ0Cl0YR2s4o1YdpmUMr8plsj3hTvCd7MzqxdOYrmJfXtGF
	FWACJdIy4CuEhAJeXpsBZcBPKCY6ADx/7TRwFcTEYwAtsz6ewiKAEzcqBc86GlYbMQ/UBWBF
	mdwDLQC41vQlXgaEQj4RAr8/Z3QxmwkLgFeHU10MTlzBYPdEB89V2EQcgI7VCfeiPGIXNH9e
	6NYiAkG7tRl4hm2D5qElt+/r9OfbR3keJgD2mx1ujTuZwhu1uGsAJEaE8LPaCp6nORZ+a7/m
	3fUmONPX6tVB8OHZYq/OhpO/TXr5fNh+vdLHo1+Dpr9HfFxhcGeY5q93e2b5ww/XHJjLhoQI
	lhSLPfR2+Gv1lLczEN7/pN6rKTgzUepeRUyUA9h9rApsq3kuQM1zAWr+n3UJ4FbwIqPjNGqG
	C9fJtczx/241g9W0APe7Dk1oB+OT82F2gAmBHUAhTm4WRRzerhaLVPSJ9xk9m6435jCcHYQ7
	T/gjPOiFDNb5MbSGdLkiQqZQKpWKiL1KORkomi36VCUm1LSByWYYHaN/1ocJfYNM2JHit4Id
	D1YFHfY7BZ3H316e6J0voErX0Zm58qSXqldZ83TEjltcxxRrPsxKpvH+sT25vRfV33SfEjke
	HNgZd1T5w5blpJi8QzsWj6I3gqN/qVPc+iJAFBuVeIbQjd8bHopXJUrXwjaMpww+Wd6awG48
	9EqeLp+2VdqyTr5ehYl+OtfDTC/JLMrh+xt6Gx42Jr27EtX1FQzJSjvSKXgzdUC01JCxMy1m
	74m0wJH6jcHF/rdTUN1gMrbSprK1niw4TzcP9L1XWXy71JI6q/xYNHTKUPtHyeX1isg/42Ts
	j3AKT6/2k8yMNCWMxdu2xBj8+Y0aQUK+yfp7wIJtDF+Pjid5XCYtD8X1HP0vdG5pgmAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSvO6EMqV0g3efRC0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orhsUlJzMstSi/TtErgyJn1rZCroMa9o
	nf6TsYGxQ7eLkZNDQsBEYtmvFUxdjFwcQgK7GSWOfN/LDpEQl2i+9gPKFpZY+e85mC0k8JFR
	Yu8zlS5GDg42AU2JC5NLQXpFBNYzSpzdO4EFxGEW2MgkcXbPDzaQBmEBV4knv+6DNbMIqErM
	XNgMZvMKWEgcWrWeEWKBvMTMS9/B4pxA8Q87brJALDOXuL7wDFS9oMTJmU/A4sxA9c1bZzNP
	YBSYhSQ1C0lqASPTKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4IjT0tzBuH3VB71D
	jEwcjIcYJTiYlUR4LYMU04V4UxIrq1KL8uOLSnNSiw8xSnOwKInzir/oTRESSE8sSc1OTS1I
	LYLJMnFwSjUwrYs5cK6PoeXk8WqVsmNrX3aHvZA6lJjRwrXEY+2BS85ftizR0AhuupY5xSd4
	txTXyrjSRyyTHUz6NNjN/O3LzJf4b5wSOD3h/da/HGkvNr7QYpA5K8/31rPQLoUjoH1n6JS0
	HtX4WP7pzpaLjyb1c93LvBq5lEOm/UntkherGTq6ppZNP3NswpfKs1s37zvJPO+rsVUA05NJ
	W9tfHk6x1Z3wLvBIxsXPjF8nrX66T36H5suqfsYlbh8apct1i80/me68nqaacc5y/fVDzWrv
	60XYumTsuW22vPj7e/lVL/k7H/JuFi9fIt2/tTp0+96Hv9by7VRd+E2vr6a5MrqmPPhN+oaz
	p9IM1Rt/FT+xUWIpzkg01GIuKk4EAPmYgdwnAwAA
X-CMS-MailID: 20241030181024epcas5p3964697a08159f8593a6f94764f77a7f3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241030181024epcas5p3964697a08159f8593a6f94764f77a7f3
References: <20241030180112.4635-1-joshi.k@samsung.com>
	<CGME20241030181024epcas5p3964697a08159f8593a6f94764f77a7f3@epcas5p3.samsung.com>

If an iocb contains metadata, extract that and prepare the bip.
Based on flags specified by the user, set corresponding guard/app/ref
tags to be checked in bip.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
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
index 0046c744ea53..a42b7fe0eee9 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -23,6 +23,7 @@ struct bio_integrity_payload {
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
 	unsigned short		bip_max_vcnt;	/* integrity bio_vec slots */
 	unsigned short		bip_flags;	/* control flags */
+	u16			app_tag;	/* application tag value */
 
 	struct bvec_iter	bio_iter;	/* for rewinding parent bio */
 
@@ -79,6 +80,7 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio, gfp_t gfp,
 int bio_integrity_add_page(struct bio *bio, struct page *page, unsigned int len,
 		unsigned int offset);
 int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter);
+int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta);
 void bio_integrity_unmap_user(struct bio *bio);
 bool bio_integrity_prep(struct bio *bio);
 void bio_integrity_advance(struct bio *bio, unsigned int bytes_done);
@@ -109,6 +111,11 @@ static int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
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


