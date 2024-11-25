Return-Path: <io-uring+bounces-5030-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44E639D7C74
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 09:08:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05DDC28236E
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 08:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58FE189528;
	Mon, 25 Nov 2024 08:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AuPjSbr+"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2170155747
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732522077; cv=none; b=DMPH1i9l+RrQkPDuP4Qe9V9LnEVTN7G3ZZuvAtqOmhtMzCJdPa+qQ3OBHfPTsHVD2/p22OjM/Mtu/gDvtbLwfvHHau96ElpjJfIMRU1IMbFqozmSpu1OMERaCXUvB8NCUr0JUlPBrchMdz8Dmzcdtf50f3Do3+tR8UWCEYxxf0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732522077; c=relaxed/simple;
	bh=ZIkdyJlOm3c2bE0cQ6pelSYB5Gra8HNzZg1GmGSloUY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=DmnnhDz3b35BKiAY45HdUqiNgT9dqQmYESTnpRGPLs3kXfcddgGRPAoENxvJlorVSosgsAwS+ezjtVto2ZCMaZhCX2Y212+rcBk5vP0gHFULKBS/Xu5vtedTV78SBbVuf0zzxBVOca4ZYpyJbayzatD/UhNQmr0/HQneyEI0Z1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=AuPjSbr+; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241125080753epoutp03fdfbdd58903f82efde89bb17f98f12ce~LJ6V8d0LV0666806668epoutp03Q
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:07:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241125080753epoutp03fdfbdd58903f82efde89bb17f98f12ce~LJ6V8d0LV0666806668epoutp03Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732522073;
	bh=r23oSTZl50mKsH838ytL5lDlNxkmkMYy4oR7U1Ruz2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuPjSbr+wwrj35VTO1a0GWubB8L9zZIQo92dC+7Bx8cLn4jaqMeN9HGhL34OF944s
	 DgZLid3RhclwFSl5VmpEaYfyts+BXOMiBWSIIhrrkI4P9xWzjDZ8FdPVf/xWWHuRzH
	 nMrHSTAItpL0DARdjI55gr49mmgoW6B734KYWa7Q=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241125080752epcas5p4faeaf8c214c343ab0d6e74bdafb82e59~LJ6VZUXaz1615316153epcas5p40;
	Mon, 25 Nov 2024 08:07:52 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Xxdc64ygzz4x9QB; Mon, 25 Nov
	2024 08:07:50 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	97.9F.20052.65034476; Mon, 25 Nov 2024 17:07:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241125071454epcas5p449a4b9a80f6bfe2ffa1181e3af6c2ac6~LJMFPjhPU1933019330epcas5p4H;
	Mon, 25 Nov 2024 07:14:54 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241125071454epsmtrp2a685c9fea5b8dd07aca582f547795d7a~LJMFNgE_x0286002860epsmtrp2Z;
	Mon, 25 Nov 2024 07:14:54 +0000 (GMT)
X-AuditID: b6c32a49-3fffd70000004e54-94-67443056a5ba
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	FE.7E.18937.EE324476; Mon, 25 Nov 2024 16:14:54 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241125071451epsmtip13040f1ba58cb8551b4a7e4a8acfc959c~LJMCy34Cw0361403614epsmtip1b;
	Mon, 25 Nov 2024 07:14:51 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v10 03/10] block: modify bio_integrity_map_user to accept
 iov_iter as argument
Date: Mon, 25 Nov 2024 12:36:26 +0530
Message-Id: <20241125070633.8042-4-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241125070633.8042-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxjfuff2AQvkUlk4oEK9mSzybGeBgwN1gW2XAAkJbAlsGXZw01bK
	bdeHQ/4YxFqIoAPdg0nrRLbIxGljoQwsGEQYgzFk4GYAIfxRJmpgKPKICFvpBed/v+87v0e+
	75wjxEWT/CChijUwOlaupvjeRMutPWGRH0iSFRLbw1D0eHGVQMeq13BkbWwB6PJEFR89uvUE
	oNHONgxdutyDoTnzIIEsNSYM9fw7y0dnuv4CqGMsHLV39BHo/MVpAaq828pHDb3rGLq91stD
	t2utgoMiuq12QkCP/G6k7Y0n+HTTDyW0c7SUTz+eHiPoL5obAT1Q1y2gF+zBtN01i2V45xQk
	KBl5PqMTM2yeJl/FKhKp1MzcpNyYWIk0UhqP4igxKy9kEqnktIzId1Vq90yU+IhcbXS3MuR6
	PRW9P0GnMRoYsVKjNyRSjDZfrZVpo/TyQr2RVUSxjGGfVCJ5M8ZNPFSgnJ5ZwLTtwUXOEboU
	tARWAC8hJGXw2c1VUAG8hSLSCWDXmWObxRMAv126wntRrDgHBFuSdatFwB20Abg2tIRxxQKA
	80PHwQaLT74Bu++bPV7+ZDuApy78RmwUOFmNwfLTVo/XNvIQHO+748EEuRu6uis82IdE8N61
	izwuLwSeHV729L3IeDhb1klwHD/Yd9blwbibY3JY8I0ASA4Job3+HuDEydD1h4ng8Db4sLd5
	c4gguDDXweewAq6MTGMc1kLTLzc2tQegub/KbSp0B+yBtuvRXHsn/Lr/Ksbl+sJTq65NqQ9s
	/W4LU7D8knUTQ9gxWIpt2ECShg3PA7ltnQTQ8fc6UQ3EtS+NU/vSOLX/J9cBvBEEMlp9oYLR
	x2ilLPPZi2vO0xTageehh6W0gomp+agugAlBF4BCnPL38Q1IUoh88uVHixmdJldnVDP6LhDj
	3vdpPOi1PI37p7CGXKksXiKLjY2Vxe+NlVIBPo/M5/JFpEJuYAoYRsvotnSY0CuoFCMsUmWE
	ib1Tbzpw5XD/eXFztqYhVfC8ucpaF2x8JeLI3YpEdtk+NZZTWTnxljm65MRoyuqu+UWcrKv3
	25FMblcdLt83Pva5babk46X0T0Xf65YDTHtXwiczVTsdjp8vjN28kTbjV21L6hx9Zzn77WHH
	/vKsdd7xb2ZCfnyVDIn+KCpTNVVTP/JnVpOq55z6S5nT0OR4PyVrtKjoJ99p51Evepjm7VBG
	ZKZ5h6Ic/5bXE3Z1ilX/4IJ0233bU++TiyLL1aKBstxPnpZ1hAfi2xPnxs27v2qNRM8mD5Z/
	uLxQHOcV1zv4oObXirbs606ZRQbOhIfEpRe/lwp511yDoQ/qKEKvlEvDcJ1e/h9RYhnicQQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LZdlhJTvedsku6wboPPBYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUVw2Kak5mWWpRfp2CVwZT198ZirYI1ex
	+7JHA+M2yS5GTg4JAROJf3Nms4PYQgLbGSX29OhBxCUkTr1cxghhC0us/PccqIYLqOYjo0RT
	912wBjYBdYkjz1vBikQETjBKzJ/oBlLELDCDSaLn1wo2kISwQJzEpMYOFhCbRUBV4smRLrBm
	XgELiTsbl7FCbJCXmHnpO1icU8BS4m3bARaIiywkZnWuZIWoF5Q4OfMJWJwZqL5562zmCYwC
	s5CkZiFJLWBkWsUomlpQnJuem1xgqFecmFtcmpeul5yfu4kRHGdaQTsYl63/q3eIkYmD8RCj
	BAezkggvn7hzuhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFe5ZzOFCGB9MSS1OzU1ILUIpgsEwen
	VANTb/uMW3dvdUadXLK774Ju9ZRdQqXmqk6lZc2PJk6Y/HhNpPP9cquIsgsVLIerAy4Yf/Ge
	fKht/VcniW63vLMt/PHGPXExah8Fjj36MO1RyjyHKe/mz560NNfqD5+W7wdx1cWnuUOZM3dO
	5k9f9UQsfIdAymfhuUFrmvUM80Vq/e9IP1K1vnvcwutP1OTQl5e/LUoT4+ift2X6iXj+uZaW
	JU/dtcVPSe2Qt+g9bfbzYGmkRZt07OOPQbaiS15dWD1dUiamt33zLqkNj60Pvgwo2rvibQjb
	81jODAaJb/O293Yuuv20ZreR1sT1+qXev64vEZ4rGyj4fTWnaP+p6MgZll/dL2wNKS6YLMOW
	dnKhEktxRqKhFnNRcSIAGBu+8CIDAAA=
X-CMS-MailID: 20241125071454epcas5p449a4b9a80f6bfe2ffa1181e3af6c2ac6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241125071454epcas5p449a4b9a80f6bfe2ffa1181e3af6c2ac6
References: <20241125070633.8042-1-anuj20.g@samsung.com>
	<CGME20241125071454epcas5p449a4b9a80f6bfe2ffa1181e3af6c2ac6@epcas5p4.samsung.com>

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


