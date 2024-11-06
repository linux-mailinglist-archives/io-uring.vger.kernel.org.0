Return-Path: <io-uring+bounces-4492-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C4A9BF031
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B58CC1C21BF4
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 14:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34135202636;
	Wed,  6 Nov 2024 14:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="izWXT6m/"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099A320126D
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730903334; cv=none; b=T3ijl/BkG0ucZiERZ5HnYE+/7yHhAXZZoVxFZ50NGWrxtuzICBbF018UDW440uJoyyirEx6mtpbSFPEhXL1NbuKbK5LOYm4aMQRzcnaVIFyb9CTj/eAP9rhNILF5s6HuMePmGhtbi3Ix8yv8MiiHb3aiIicmgEHeq6RRGQB8wkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730903334; c=relaxed/simple;
	bh=ZIkdyJlOm3c2bE0cQ6pelSYB5Gra8HNzZg1GmGSloUY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=lsP0M6v/sNc3u/dPkKQZ/KWPXNgmnBUm7f/LGeAduhhj6iN4P4KYbKVRGCyKX0PmNOV2KIP8i2kfTScDzhtV6jJVLqo1VR+pOQJeFUko5TqEaMCpohEaezbTk+0R0DBlL1YfonFzVYRXJoNZVT17jKrC6s066fnC1thlo4Syhig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=izWXT6m/; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241106142850epoutp033c1097f1051f4111f29ac907dd064e6f~FZ2h_hkuk2019520195epoutp03C
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:28:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241106142850epoutp033c1097f1051f4111f29ac907dd064e6f~FZ2h_hkuk2019520195epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730903330;
	bh=r23oSTZl50mKsH838ytL5lDlNxkmkMYy4oR7U1Ruz2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izWXT6m/j7bjz4bbCiKBp3/SoKkzYaK/Rwzc5mocpOrtqEEGc/oujyVbNWGnKkYzl
	 faaAjxYT3cVRIljGl20zvR5bxhWJEgdDU+uQtBvUGssqRlWxc9e+qEIPK0DGeJFCTY
	 Tf5cbR5GfTQTJhU5BuNIREdUNseyXRBE4ZrMPG28=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241106142849epcas5p1fbedcaf95bf53370a654c2aa2d912273~FZ2hKvYXv0161501615epcas5p14;
	Wed,  6 Nov 2024 14:28:49 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Xk6yR6C4Jz4x9Pw; Wed,  6 Nov
	2024 14:28:47 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	83.E2.09800.F1D7B276; Wed,  6 Nov 2024 23:28:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241106122701epcas5p379d6d2c0f7a758f959e02a363ee6871d~FYMLk5-SO1171911719epcas5p35;
	Wed,  6 Nov 2024 12:27:01 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241106122701epsmtrp1d7f3354d925114851ccbf887ce199279~FYMLjGU311944919449epsmtrp1e;
	Wed,  6 Nov 2024 12:27:01 +0000 (GMT)
X-AuditID: b6c32a4b-23fff70000002648-25-672b7d1fdee6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	56.23.08227.5906B276; Wed,  6 Nov 2024 21:27:01 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241106122659epsmtip1aa1deea918526cf1b43e53f0fdc85e6f~FYMJA3akm0722607226epsmtip1i;
	Wed,  6 Nov 2024 12:26:59 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v8 03/10] block: modify bio_integrity_map_user to accept
 iov_iter as argument
Date: Wed,  6 Nov 2024 17:48:35 +0530
Message-Id: <20241106121842.5004-4-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241106121842.5004-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJsWRmVeSWpSXmKPExsWy7bCmpq58rXa6wftvehYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUdk2GamJKalFCql5yfkpmXnptkrewfHO
	8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA/KSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0ts
	lVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyM56++MxUsEeuYvdljwbGbZJdjJwcEgIm
	Eh/u/2TrYuTiEBLYzSixrmsjlPOJUaL5wkYmkCohgW+MEl9eVMJ0PLnUyApRtJdR4tP2XVDO
	Z0aJppbXjCBVbALqEkeetzKCJEQE9jBK9C48zQLiMAtMYJJonziHHaRKWCBe4s7ymcwgNouA
	qsSCa31Ayzk4eAUsJE7MMoNYJy8x89J3sHJOAUuJs5+3gS3gFRCUODnzCQuIzQxU07x1NjPI
	fAmBBxwS02a0sUM0u0i8WXSICcIWlnh1fAtUXEriZT9MTbrEj8tPoWoKJJqP7WOEsO0lWk/1
	M4PcwyygKbF+lz5EWFZi6ql1TBB7+SR6fz+BauWV2DEPxlaSaF85B8qWkNh7rgHK9pCYOn0a
	IyS0ehglnt65yzaBUWEWkn9mIflnFsLqBYzMqxglUwuKc9NTi00LjPNSy+GxnJyfu4kRnM61
	vHcwPnrwQe8QIxMH4yFGCQ5mJRFe/yjtdCHelMTKqtSi/Pii0pzU4kOMpsDwnsgsJZqcD8wo
	eSXxhiaWBiZmZmYmlsZmhkrivK9b56YICaQnlqRmp6YWpBbB9DFxcEo1MCnfPrXDOHjC8ddJ
	t04e+6w7S2Ql6yJnruMqmzd0NioIB7m8tFVOs1vOZWK71KeirO/qjbdn2LIbHy94+jTfy3HS
	/G/fn76w9VBeW/5OaXbk03O2LlkHT+5gTKzdL7tZfimDb9qcbbPdQruXpwvNyLuXumiFjf3u
	Ta4X2cuDjhhJFa7J4KzYcvrqsXhF7ol2fzZo9q+PPLF615+e0IWhH8qPH5jFKdjWpbg0cw5n
	z6G0o/U7BAuU237L3w5sivrdO/tciGnqlNXPpN1aLE0uz+ziuPrsjl3kwZKwMuE7XDMaAj1X
	Vzlf2irl+GB/W+Dv47UdbMG39N53/co8/FK6Ie6YtLx2OJ9T7baSSR1/BZVYijMSDbWYi4oT
	AfCiPu1wBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWy7bCSnO7UBO10g1t/jS0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orhsUlJzMstSi/TtErgynr74zFSwR65i
	92WPBsZtkl2MnBwSAiYSTy41snYxcnEICexmlOg/so0VIiEhcerlMkYIW1hi5b/n7CC2kMBH
	RonJF6JBbDYBdYkjz1vBakQETjBKzJ/oBjKIWWAGk0TPrxVsIAlhgViJZ3M/s4DYLAKqEguu
	9QHFOTh4BSwkTswyg5gvLzHz0new+ZwClhJnP29jhNhlIfFnQR8ziM0rIChxcuYTsDHMQPXN
	W2czT2AUmIUkNQtJagEj0ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOBo09Lawbhn
	1Qe9Q4xMHIyHGCU4mJVEeP2jtNOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ83573ZsiJJCeWJKa
	nZpakFoEk2Xi4JRqYPKYGvRl6bS7Bv+Me4UETaUqnopd2P/088kyI8Hcs0bbDomsUvqdIMb3
	/UVI+N/Phzz3vRO772GqlelfV6McL2y+TdtC/NKJ1csWl4ddWvXz38I4teb3HnptoRw2S4Om
	CTaHfiu5vGmKgfSO4pUGzp7JFx7a/drzreCg+KZ+DlnWgEkv8lzefzp/1nSec1D2/kVVSRK7
	bm28yv6TVV/usfA34y+h0xOfvGLrcXCx2fd3Ls8D8eVnu1ff534fwfJv+4/YhQZs0q1xvS7c
	15dwZt3IiWCIWvu7YaL3gYfSlSdr1Fap33yu5nJ2+m02xhr/Vq8T914oPL3lNnmm+p40a4vT
	7zSEPr1VEn6/8uuL70xKLMUZiYZazEXFiQAKivRLJQMAAA==
X-CMS-MailID: 20241106122701epcas5p379d6d2c0f7a758f959e02a363ee6871d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241106122701epcas5p379d6d2c0f7a758f959e02a363ee6871d
References: <20241106121842.5004-1-anuj20.g@samsung.com>
	<CGME20241106122701epcas5p379d6d2c0f7a758f959e02a363ee6871d@epcas5p3.samsung.com>

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


