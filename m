Return-Path: <io-uring+bounces-4415-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18D679BB976
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A5231C20E4B
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 15:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B511A1C07F7;
	Mon,  4 Nov 2024 15:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JMQR6Nio"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32C41C07E4
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730735769; cv=none; b=cZY7uonx7pYlKsdrEXMKncf4vhM6GwwmE9wotNqAiMGI/GARrgvatYWaJUPpzq8D7yrHGQpsv420YvTmezsudjTIMBntaFgrWGKl5ASIxlg/mHSit5ckxogcL+QUpaFYkRJxX8jBvpXDB6WACABH4JcxEcK2H9TS/tJGQGhuQCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730735769; c=relaxed/simple;
	bh=ZIkdyJlOm3c2bE0cQ6pelSYB5Gra8HNzZg1GmGSloUY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=MUSCLVRZJiqHMon6DJEdx9FNnINH/UC+N45xDPV8gACLVQc1R/Pp6ooGSbEU02noAcmqgOqD9dY26F25C1A+TawxW16jaA93trJE+KTWr1H65it+93dC4x4+u5ly6h+d43wBAYtc/RDk0D4NC1NECo5QV3gZcinQGqNiF8utBMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JMQR6Nio; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241104155605epoutp01bdc6948aa1da32c8024d2f00053aa2ed~EzwJiBMcd2048320483epoutp01Y
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:56:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241104155605epoutp01bdc6948aa1da32c8024d2f00053aa2ed~EzwJiBMcd2048320483epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730735765;
	bh=r23oSTZl50mKsH838ytL5lDlNxkmkMYy4oR7U1Ruz2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMQR6NiojxRKjU4cHSEF43DqQbKpeqgxotRVXXYJ3NaNcFzdfLtSTM/w3ldX3TvDz
	 qkYUzI8PNI6mT+giNsvpW7YAYBS9+q+5XYOqW0oZ2qXGku0CFj8Zi66Jb//tpjcmqV
	 U0Q5ipOREB/8eiSiWHTNbHlAQEFJB7G4+K573W9g=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241104155604epcas5p4c21eaecfaa8f69190416b3fb19f1d91f~EzwIQoJap2760427604epcas5p48;
	Mon,  4 Nov 2024 15:56:04 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Xhx026HR4z4x9Pq; Mon,  4 Nov
	2024 15:56:02 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CF.00.37975.29EE8276; Tue,  5 Nov 2024 00:56:02 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241104141451epcas5p2aef1f93e905c27e34b3e16d89ff39245~EyXv5ExsS3053330533epcas5p2u;
	Mon,  4 Nov 2024 14:14:51 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241104141451epsmtrp25c9b792302190365df06d7cec0992b5f~EyXv3ptok1987019870epsmtrp21;
	Mon,  4 Nov 2024 14:14:51 +0000 (GMT)
X-AuditID: b6c32a50-085ff70000049457-b3-6728ee92a152
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	B8.DC.18937.AD6D8276; Mon,  4 Nov 2024 23:14:50 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241104141448epsmtip2dd27c5d88448694207610d66d3844aea~EyXtZsX3L3011330113epsmtip2j;
	Mon,  4 Nov 2024 14:14:48 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v7 03/10] block: modify bio_integrity_map_user to accept
 iov_iter as argument
Date: Mon,  4 Nov 2024 19:35:54 +0530
Message-Id: <20241104140601.12239-4-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241104140601.12239-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJsWRmVeSWpSXmKPExsWy7bCmuu6kdxrpBrMO6Vh8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSyO/n/LZjHp0DVGi723tC32
	7D3JYjF/2VN2i+7rO9gslh//x2Rx/u9xVovzs+awOwh57Jx1l93j8tlSj02rOtk8Ni+p99h9
	s4HN4+PTWywefVtWMXqcWXCE3ePzJjmPTU/eMgVwRWXbZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gD9pKRQlphTChQKSCwuVtK3synKLy1JVcjILy6x
	VUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIznj64jNTwR65it2XPRoYt0l2MXJySAiY
	SPxY3sHexcjFISSwh1Gi+dZWFgjnE6PEvtbDTHDOiX2TGWFaNty+wQRiCwnsZJSYdy4Gougz
	o0TvvcUsIAk2AXWJI89bGUESIiBzexeeBpvLLDCBSaJ94hx2kCphgXiJtiVTwcayCKhKXPnd
	BmRzcPAKWEp8PBMCsU1eYual72DlnAJWEnP+3gVbwCsgKHFy5hMwmxmopnnrbGaQ+RICVzgk
	fq76zgbR7CKxufc6E4QtLPHq+BZ2CFtK4vO7vVA16RI/Lj+FqimQaD62D+pNe4nWU/3MIPcw
	C2hKrN+lDxGWlZh6ah0TxF4+id7fT6BaeSV2zIOxlSTaV86BsiUk9p5rgLI9JCZOWcMGCa1e
	RolTt+6yTmBUmIXkn1lI/pmFsHoBI/MqRqnUguLc9NRk0wJD3bzUcng0J+fnbmIEJ3StgB2M
	qzf81TvEyMTBeIhRgoNZSYR3Xqp6uhBvSmJlVWpRfnxRaU5q8SFGU2CAT2SWEk3OB+aUvJJ4
	QxNLAxMzMzMTS2MzQyVx3tetc1OEBNITS1KzU1MLUotg+pg4OKUamGQ1OX9YXepxvX2PRWeT
	c+q/NiceLpeXK3X35B06/nPblaMvqs87bT76c9+hOTeuR5T8Ymza6X/h6N3sGp5EWa3SCSFm
	bx/m5j+6WxdYMmHe37eRbx6/UzcVc2zMPbkm6hRn2buoP9pcYiWRKl/a5Bm555fMiVDYp3n4
	Z/W24OvSFZJdsU9vFL5SDPKx+rA12OjZz8Umpj4Slc+OsAcfeJsZG72+tcUkbsXstzcVy2s2
	Mr2e2/O/5uaOkM4r9xQcEuZyGkY98pGTPLKwdwfDlhV+1Z1y/O4/UosKG2bUTl6x45XTcq2w
	1qt3d5e1KOiELun/wqJXY9388GHGw/Kpil2111iNWNKrjXb1xqj2KrEUZyQaajEXFScCAHbM
	ySlxBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LZdlhJXvfWNY10g8t3rSw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orhsUlJzMstSi/TtErgynr74zFSwR65i
	92WPBsZtkl2MnBwSAiYSG27fYOpi5OIQEtjOKHHv+gsWiISExKmXyxghbGGJlf+es0MUfWSU
	WLL7BFiCTUBd4sjzVjBbROAEo8T8iW4gRcwCM5gken6tYANJCAvESlz5+hOsiEVAVeLK7zYg
	m4ODV8BS4uOZEIgF8hIzL31nB7E5Bawk5vy9C3aEEFDJpqZLYDavgKDEyZlPwGxmoPrmrbOZ
	JzAKzEKSmoUktYCRaRWjaGpBcW56bnKBoV5xYm5xaV66XnJ+7iZGcJxpBe1gXLb+r94hRiYO
	xkOMEhzMSiK881LV04V4UxIrq1KL8uOLSnNSiw8xSnOwKInzKud0pggJpCeWpGanphakFsFk
	mTg4pRqYKj9sufAl1nF2pvSMbRPOCMnm9rn+VEz0fXuweqWf1/tH4j8DVqfM2SHarDrt+G2t
	tokmPH6PVTea7N7780bdvuZNDTKmQTOmKuyZ8cRe9aqYYeI7Fq4PWRGtXcZcIdzbTNQXrH2a
	/573wt1zX+/YbxVfus7IqfCfRNzEb9GpG5ynOZkenad3OvzzOaOGnGjmm/qyO2+4zktf75Rz
	sDzMfdfj+A8VN+z1rniWVjCeFLj3IqY015XJQFL/neT1/VwmCv/KyuXXvtnoc+yzwWavyJXt
	n59KKTzmbJnINfHGVlGOw/XzgpQ3TEie+GHWJ7XL/XXKYTfllwtxHZy5dhKvzYvdvxzl09+d
	+J3s8uH8TSWW4oxEQy3mouJEABdlUiQiAwAA
X-CMS-MailID: 20241104141451epcas5p2aef1f93e905c27e34b3e16d89ff39245
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241104141451epcas5p2aef1f93e905c27e34b3e16d89ff39245
References: <20241104140601.12239-1-anuj20.g@samsung.com>
	<CGME20241104141451epcas5p2aef1f93e905c27e34b3e16d89ff39245@epcas5p2.samsung.com>

This patch refactors bio_integrity_map_user to accept iov_iter as
argument. This is a prep patch.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c         | 12 +++++-------
 block/blk-integrity.c         | 10 +++++++++-
 include/linux/bio-integrity.h |  5 ++---
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 4341b0d4efa1..f56d01cec689 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -302,16 +302,15 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
 	return nr_bvecs;
 }
 
-int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes)
+int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	unsigned int align = blk_lim_dma_alignment_and_pad(&q->limits);
 	struct page *stack_pages[UIO_FASTIOV], **pages = stack_pages;
 	struct bio_vec stack_vec[UIO_FASTIOV], *bvec = stack_vec;
+	size_t offset, bytes = iter->count;
 	unsigned int direction, nr_bvecs;
-	struct iov_iter iter;
 	int ret, nr_vecs;
-	size_t offset;
 	bool copy;
 
 	if (bio_integrity(bio))
@@ -324,8 +323,7 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes)
 	else
 		direction = ITER_SOURCE;
 
-	iov_iter_ubuf(&iter, direction, ubuf, bytes);
-	nr_vecs = iov_iter_npages(&iter, BIO_MAX_VECS + 1);
+	nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS + 1);
 	if (nr_vecs > BIO_MAX_VECS)
 		return -E2BIG;
 	if (nr_vecs > UIO_FASTIOV) {
@@ -335,8 +333,8 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes)
 		pages = NULL;
 	}
 
-	copy = !iov_iter_is_aligned(&iter, align, align);
-	ret = iov_iter_extract_pages(&iter, &pages, bytes, nr_vecs, 0, &offset);
+	copy = !iov_iter_is_aligned(iter, align, align);
+	ret = iov_iter_extract_pages(iter, &pages, bytes, nr_vecs, 0, &offset);
 	if (unlikely(ret < 0))
 		goto free_bvec;
 
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index b180cac61a9d..4a29754f1bc2 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -115,8 +115,16 @@ EXPORT_SYMBOL(blk_rq_map_integrity_sg);
 int blk_rq_integrity_map_user(struct request *rq, void __user *ubuf,
 			      ssize_t bytes)
 {
-	int ret = bio_integrity_map_user(rq->bio, ubuf, bytes);
+	int ret;
+	struct iov_iter iter;
+	unsigned int direction;
 
+	if (op_is_write(req_op(rq)))
+		direction = ITER_DEST;
+	else
+		direction = ITER_SOURCE;
+	iov_iter_ubuf(&iter, direction, ubuf, bytes);
+	ret = bio_integrity_map_user(rq->bio, &iter);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index 0f0cf10222e8..58ff9988433a 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -75,7 +75,7 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio, gfp_t gfp,
 		unsigned int nr);
 int bio_integrity_add_page(struct bio *bio, struct page *page, unsigned int len,
 		unsigned int offset);
-int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t len);
+int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter);
 void bio_integrity_unmap_user(struct bio *bio);
 bool bio_integrity_prep(struct bio *bio);
 void bio_integrity_advance(struct bio *bio, unsigned int bytes_done);
@@ -101,8 +101,7 @@ static inline void bioset_integrity_free(struct bio_set *bs)
 {
 }
 
-static inline int bio_integrity_map_user(struct bio *bio, void __user *ubuf,
-					 ssize_t len)
+static int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 {
 	return -EINVAL;
 }
-- 
2.25.1


