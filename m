Return-Path: <io-uring+bounces-4422-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 91E4E9BB995
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:57:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20F171F22970
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 15:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAD661C2443;
	Mon,  4 Nov 2024 15:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uPGG2+CM"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14031C7B99
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730735794; cv=none; b=XRbVMWWuRHGghCGPIdwjlEe1+hNmIkjWL8JdQ8jL8ctTPJZfH1ViRTIt0aA8cA+cn1uRSJb0mdiY/mK9Onuyp4wTDGy5W29bBjuoYNDg9upXPZvI0OwGu/XW9WKX355JYEgm3oPtwKcDuBbHRhhp3+lRNiJdLCkfcml/VUZw26k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730735794; c=relaxed/simple;
	bh=WHvZy6Y5oID0mO4AofIk2VjNJ7NxK6UpWbYIbVVX3wY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=W4ux4PkJp5vC8kLBbqFN+r26tGSCmtJ+woZrHszp40WagYn/mb2kkmlYRCWPihPH4o88q9HGXWoUDGlKKejSRSNZ5FpujU+KK6KVLkVMkQarjRYfbvWJyApA8c3o6ReAKRk7cSJ0JD5uCi8Fa7IqzLz7gdGJAaOhTrs5EqUojkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=uPGG2+CM; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241104155631epoutp01144f5da90c3e20bf80f3a7303f5848e4~Ezwg9gtfC2197221972epoutp01N
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:56:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241104155631epoutp01144f5da90c3e20bf80f3a7303f5848e4~Ezwg9gtfC2197221972epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730735791;
	bh=lzO5Gr/GJg/Q14qdgiZppE3+0qzFmF96RxNwH21zcLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPGG2+CMoAwP8J5jk53nW5Fr2Bo2xk7EfwJPTpBdJkpJL894PaZmwwniXUYyD2zSP
	 ycf1WwIJ/uU3vBYQIuLP2tcU/NLFCFqQAUqD5aJSoxa3rTfiZVr1RnDRGy7zHJ7Cn+
	 ZDsUSTl3gMEdyQoDygIimGRVadNgRqXkwHv3ozzQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241104155629epcas5p317f76a2999cf2e5ac26083e0783d255e~EzwfohX8t2593425934epcas5p3w;
	Mon,  4 Nov 2024 15:56:29 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Xhx0W6nywz4x9Pq; Mon,  4 Nov
	2024 15:56:27 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	43.DA.09800.BAEE8276; Tue,  5 Nov 2024 00:56:27 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241104141509epcas5p4ed0c68c42ccad27f9a38dc0c0ef7628d~EyYBZ6W0B3055030550epcas5p4t;
	Mon,  4 Nov 2024 14:15:09 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241104141509epsmtrp2a117a3377c18571a105712e5fe9b9b65~EyYBY3dlZ1987019870epsmtrp2W;
	Mon,  4 Nov 2024 14:15:09 +0000 (GMT)
X-AuditID: b6c32a4b-23fff70000002648-4c-6728eeabda1b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	16.C9.08227.DE6D8276; Mon,  4 Nov 2024 23:15:09 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241104141507epsmtip22fcbe2494b12d261f60cf1d1a84d975a~EyX_6_yCt3097330973epsmtip2j;
	Mon,  4 Nov 2024 14:15:07 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v7 10/10] block: add support to pass user meta buffer
Date: Mon,  4 Nov 2024 19:36:01 +0530
Message-Id: <20241104140601.12239-11-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241104140601.12239-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf0wTZxjH894dbenWeRZ0r5gNchsBJGA7CxxG5rIxcomEdLiNRZPhhd5a
	Qnvteu10sGyEpjN2Iuh0SGVQdWpoRSYwUpAygyAUHSSSiRBLZMIgYyX8krnwY2t7uPnf53ne
	5/t83+f9IUKlY4IoUSFrYowsrSUEYqz1VkJCkms2Xi1bt6aQ809WMLKscg0la5ytgHT5KgTk
	zK0FQI7cbEPIelcPQs5aBzDyXJUFIXv+8QvIU133AekZTSQ7PF6MrLs8KSS/GXYLyCu96wg5
	uNYbRg7aa4RvSak2u09IDf1ippqcxwRU8w9fUTdGSgXU/OQoRp1ocQLqrqNbSC02vUo1TfgR
	pfhA0R4NQ6sYYwzDFuhVhaw6g9i3P/+d/JRUmTxJnk6mETEsrWMyiMxsZVJWoTYwExHzGa01
	B1JKmuOInW/uMerNJiZGo+dMGQRjUGkNCkMyR+s4M6tOZhnTbrlM9kZKoPBQkeaB62fM0JZ2
	5PryUlgpuJZkAyIRxBXwxwbSBsQiKX4DQN9AFeCDBQA7h2wIHywD6Gy8hNlAeEhxsmFayC94
	ALw3txzGB4sAXvBahcEqAR4Hu6esoV6ReAeA5efvYMEAxSsR6KhqQYPuEfi7cMzzQVCA4bHw
	4pIFDbIE3w2b/bYNu2hYfe+vUNPwQL5mzYfxNZuht3oixGigxvLTOTTYH+IPRdA7Nwh4cSac
	q10I4zkC/tHbIuQ5Ci7OegQ8q+HToUmEZwO03O7c0O6F1v6K0D5RPAE2tu/k06/AM/3XEN73
	JVi+MrEhlUB37TMm4NH6mg2G0DNQusEUnLb0YPxplQPY92gAqwQx9ufmsT83j/1/awdAnWAb
	Y+B0aoZLMeximcP/XXOBXtcEQg99xz43+O3RXHIXQESgC0ARSkRKapk4tVSioj8vZoz6fKNZ
	y3BdICVw4CfRqC0F+sBPYU35ckW6TJGamqpI35UqJ16WzFi/V0lxNW1iihjGwBif6RBReFQp
	sv8y7csuJqWnE2eSXmBPD2uFrZGFyweOvX/4hLg5bvW1nBy/a2Q8s/r4cN/jGoYQ1DFn8yKu
	9v+9dfF+vLf5ErrXXjn8xSdD01ndFQfrE7LTYlvFiVnmzCPSq66u0cZfmSX3+qebzq5/9/tH
	qx3colex/c4pzlEi0Tm3WpU9H68Uy3I/HN0UnZ5WTT4WxyaUaV5M/FKlrPJvbm95vSy58fyf
	NyX2VXdn+Tzmfk/3dfT49rHcvKmGb68/eNqndXB1S1eWj0svlMRNjMtUcXKuKvz2QdtDsbJd
	P50ff7ei5IkffXubY0uezxt9iLDkVJQVDB8t8xkasULt1EU2N0sT0UFgnIaW70CNHP0v9hZu
	DnEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSvO7baxrpBnc2GFh8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSyO/n/LZjHp0DVGi723tC32
	7D3JYjF/2VN2i+7rO9gslh//x2Rx/u9xVovzs+awOwh57Jx1l93j8tlSj02rOtk8Ni+p99h9
	s4HN4+PTWywefVtWMXqcWXCE3ePzJjmPTU/eMgVwRXHZpKTmZJalFunbJXBl3Fi9n6Vgp3nF
	xm9fWBsY1+l2MXJySAiYSExc+4K9i5GLQ0hgN6PEwtur2SESEhKnXi5jhLCFJVb+ew5V9JFR
	4viZZ2BFbALqEkeet4IViQicYJSYP9ENpIhZYAaTxO8/C1i6GDk4hAVcJe7tDQWpYRFQlVj8
	pZkZxOYVsJLY/LaLBWKBvMTMS9/BZnICxef8vQsWFxKwlNjUdIkFol5Q4uTMJ2A2M1B989bZ
	zBMYBWYhSc1CklrAyLSKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM44rS0djDuWfVB
	7xAjEwfjIUYJDmYlEd55qerpQrwpiZVVqUX58UWlOanFhxilOViUxHm/ve5NERJITyxJzU5N
	LUgtgskycXBKNTA1/fWvifDYcefMw5uvGpym9N+rq9p4QfL5vReM9nvv7FvyVOmJzRfjOWeE
	WtfyX9myUOHTjNe1+b7/5NzDdzKFLZv8M//FgUu//6rmfd9Sf172+6uvGdM+fF/XuXnq2QiX
	g3I1jVkiN+STlR3y6+u/nrebdb3I58zZrDdln6VvOMXkcz95PmOX+++fLO1OQqemdivEJ17Y
	MO0071MBdpHC3BbZ0mZzbUNloStrxNQLpvBmW7uU1TIwn5ssM3G2G+/i1SYN7exfFJ29Fk8L
	WSp25N75h5pxR9aJ2rPKfmaJlL02abOH7YdHt8JOltXmV3y+MrU+517ztwOLjv99kfSN8UJD
	5cZLBjH+Kcc52lfPVmIpzkg01GIuKk4EAIMmAwAnAwAA
X-CMS-MailID: 20241104141509epcas5p4ed0c68c42ccad27f9a38dc0c0ef7628d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241104141509epcas5p4ed0c68c42ccad27f9a38dc0c0ef7628d
References: <20241104140601.12239-1-anuj20.g@samsung.com>
	<CGME20241104141509epcas5p4ed0c68c42ccad27f9a38dc0c0ef7628d@epcas5p4.samsung.com>

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


