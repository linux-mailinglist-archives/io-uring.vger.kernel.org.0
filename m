Return-Path: <io-uring+bounces-4232-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E37849B6BC3
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 19:10:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A301D281209
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F3B1CF5F5;
	Wed, 30 Oct 2024 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="k8iA0A3L"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173FE1CDFDA
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730311817; cv=none; b=OPDryAM/O1zNt0GQ13eX+lwRfG3Xsr6oWrUWVfW/lLXb7vYujDYFFL/vZw3d4YOo11JxL1bgYl+EYltCjqI1EWcLHM8sG+O+soMnE/0Da2Li3Yig+M9KiyWTmokpvP+mSPNjZbGRFf3ynSd2M4cBVmiVxq7MrbjyuyQAW+ZfXJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730311817; c=relaxed/simple;
	bh=oVxnfy+l2Dk2dYUOGC+cFgPvC9iJ1gjhIdA6qvU+rm4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=N+TboXr2VeFxGpu8B8i9d+0Tj3TvMCZMtgoJ4d8u1vATMrYZ6Wx74miJX60ikPeZMgefnuJn7yQggKzV0ulvFVp/rhXNqmKoD4M05klPInNzUK1ut3ZSyOIQNcdaWzhcEh0yMm9PBeH93HxkF33Omphuoes4mTDdaclhpwhqa8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=k8iA0A3L; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241030181008epoutp047d1c406260a07f748972368de8576351~DTWwUsX1v0272402724epoutp04Q
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241030181008epoutp047d1c406260a07f748972368de8576351~DTWwUsX1v0272402724epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730311808;
	bh=4844NLpBgRyqsjekSJDaeGrgKQYqhURgJQKrPEO2Wk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8iA0A3LwWW/buMJLn9M9lIPNFdQKlSQe3QwP2u5NuyQqrvI9lFcwFoHLV/Y3Ku6n
	 6Sc0jWhPhmlS0S5f/IxtExUzY18a6ixyNimHgRBZvcm4ve2JSoW6mw/8TFWCusHFEc
	 9vkkntn0tiDD3HJievlD3Ar2ENptuUrmZIBfudvw=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241030181007epcas5p1b05f34e88b7a2a5d8b7afd7faa795f9d~DTWvz7_E21837718377epcas5p19;
	Wed, 30 Oct 2024 18:10:07 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XdwC21K62z4x9Pr; Wed, 30 Oct
	2024 18:10:06 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	08.10.09420.E7672276; Thu, 31 Oct 2024 03:10:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241030181005epcas5p43b40adb5af1029c9ffaecde317bf1c5d~DTWt1c6zh0638906389epcas5p4z;
	Wed, 30 Oct 2024 18:10:05 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241030181005epsmtrp257d2df1a049654f1f5b7a212d65968ba~DTWt0gxw_1079210792epsmtrp2D;
	Wed, 30 Oct 2024 18:10:05 +0000 (GMT)
X-AuditID: b6c32a49-33dfa700000024cc-e8-6722767e8a1c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AF.B6.08227.D7672276; Thu, 31 Oct 2024 03:10:05 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241030181003epsmtip2551cf31ab80c506859e5f51aa38f5c1e~DTWrT_WMg0487504875epsmtip26;
	Wed, 30 Oct 2024 18:10:02 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
	anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v6 03/10] block: modify bio_integrity_map_user to accept
 iov_iter as argument
Date: Wed, 30 Oct 2024 23:31:05 +0530
Message-Id: <20241030180112.4635-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241030180112.4635-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJsWRmVeSWpSXmKPExsWy7bCmlm5dmVK6wZynrBYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUdk2GamJKalFCql5yfkpmXnptkrewfHO
	8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA/KSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0ts
	lVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyMy5vOMNc8Fyu4uAvmwbGW5JdjJwcEgIm
	Ev8/fWXuYuTiEBLYzSgxf+V6NpCEkMAnRonJp5MhEt8YJd5/eAZUxQHWcW13MkTNXkaJ00ci
	IWo+M0qsPL+IEaSGTUBT4sLkUpAaEYGlQPHr0SA1zALLmSTerZ/CCJIQFoiXWLjiBtgyFgFV
	ic43vSwgNq+AucSZ84+ZIa6Tl5h56Ts7iM0pYCHxYcdNqBpBiZMzn4DZzEA1zVtng30gIXCH
	Q6Lr8G1GiGYXiX87X0ANEpZ4dXwLO4QtJfH53V42CDtb4sGjBywQdo3Ejs19rBC2vUTDnxus
	IM8wAz2zfpc+xC4+id7fT5gg4cAr0dEmBFGtKHFv0lOoTnGJhzOWsEKUeEjc/GMPCZ5uRonm
	3iVsExjlZyH5YBaSD2YhLFvAyLyKUTK1oDg3PbXYtMAwL7UcHqnJ+bmbGMHJWstzB+PdBx/0
	DjEycTAeYpTgYFYS4bUMUkwX4k1JrKxKLcqPLyrNSS0+xGgKDOKJzFKiyfnAfJFXEm9oYmlg
	YmZmZmJpbGaoJM77unVuipBAemJJanZqakFqEUwfEwenVANTQcRPZnaJBoE5X5Rm6sgunN+l
	yaqWmXZ+hfwnH9dHPhfeZLFpL1wvNb/97PM+Dz551/WML6JL1itqMteGFSgYxnVYasfPX3Zk
	h/lsKcndU4SL3+3bt3H7oXi3ZcmLtlUdybFZ/fassdqyZpmgbEUeieKQzabitx4//PhJ0uDK
	nsUnKg7f63BauOO5hRrrf/eq03KOc+/o+M//sEskJ8Ta+UG/YFXianeFXL8DTuc/uVXZqkyd
	fvLuJNl759YyvvDROlvjxvhq/nnNQuNai+jNO1ZptzQmxvz+aGTtWOEw25PT1z6+S0Srp6cx
	uu9aecrN84uu/WfbqPn2wBrdJbpTy+ztU1n9fHbZb77QJK3EUpyRaKjFXFScCADfGbLIXwQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSvG5tmVK6wak2ZYuPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8XR/2/ZLCYdusZosfeWtsWe
	vSdZLOYve8pu0X19B5vF8uP/mCzO/z3OanF+1hx2ByGPnbPusntcPlvqsWlVJ5vH5iX1Hrtv
	NrB5fHx6i8Wjb8sqRo8zC46we3zeJOex6clbpgCuKC6blNSczLLUIn27BK6MyxvOMBc8l6s4
	+MumgfGWZBcjB4eEgInEtd3JXYxcHEICuxklJv0/xdjFyAkUF5dovvaDHcIWllj57zk7RNFH
	Rol5K3czgjSzCWhKXJhcChIXEVjPKHF27wQWEIdZYCOTxJSN58AmCQvESkx/18sEYrMIqEp0
	vullAbF5Bcwlzpx/zAyxQV5i5qXvYNs4BSwkPuy4CVYjBFRzfeEZdoh6QYmTM5+AxZmB6pu3
	zmaewCgwC0lqFpLUAkamVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwfGmpbWDcc+q
	D3qHGJk4GA8xSnAwK4nwWgYppgvxpiRWVqUW5ccXleakFh9ilOZgURLn/fa6N0VIID2xJDU7
	NbUgtQgmy8TBKdXANJuD6cimOMP4lxNsi2tC44p2mq3mZorUKM571pD+yIGH4dmlztL9S0+H
	nQ85seeF/Ly572d4vmNb/JtfRSct+/YBvW/LLB/Pml+4c4f2mbfyC3bqiake6XTPi9dRbD8+
	0SBAiTkmkuu7zbO80wJbnVWbIvZ8sj92fjZzzKG8vOsrZgnvV4xLjdbeeeGaQ/38HvZnvN9i
	td4cD9/y4Jm7mOnsVwcPr74lxRTCVLp3Brea/H6m2PKKcvXf7HvqGGfLXJxSnSx9O4HtfqlK
	i1DQHs+M5/1dszlnp7gJ3N3S4LRH0kKxJGvpNiOJfp7rBS/CJ2y9vMdpgcXDWZInGN8WlRd4
	meXJNXZF2fc0LFFQYinOSDTUYi4qTgQAChGJXyYDAAA=
X-CMS-MailID: 20241030181005epcas5p43b40adb5af1029c9ffaecde317bf1c5d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241030181005epcas5p43b40adb5af1029c9ffaecde317bf1c5d
References: <20241030180112.4635-1-joshi.k@samsung.com>
	<CGME20241030181005epcas5p43b40adb5af1029c9ffaecde317bf1c5d@epcas5p4.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

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


