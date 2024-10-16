Return-Path: <io-uring+bounces-3725-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 247F59A09E9
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 14:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9A211F25482
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 12:36:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83DF9207A09;
	Wed, 16 Oct 2024 12:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="i2H0uxzT"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11231DFF5
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729082188; cv=none; b=m3u20fnWx5l6s0JgSOaUg1o/NkWMi+aGnTYkNCl1M7IQ3zItOJsTW5Vewjz5RkodM63E6Z3/ENgzAshsW20AwdxChc9br9ash5wePY8/8uMTkwO6+zPaE0U92iFoUrE+W2GT1o8r76xC09QGeZZstmOeRngGONprW72jriSq3do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729082188; c=relaxed/simple;
	bh=he/RKtwB0BA6gZ5+5gIwr4rdDI2BtLEw7XicuZ0Kc5A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ntZDzM3jmkiVYTbG4I1UkXiB2+1cMnbO+6qdTjhjYNY/dUzC/9oK4suEE86/pQ7kFXQA8PxefAiGmSeQh+8PJalp/ignMaZbmkePwFW7W2WBHTbiST0Ks+waN/x8jgG2+UnEA6gYdxGK2eC23GzVRulXlSr3/hDiFZEixaWwRCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=i2H0uxzT; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241016123625epoutp04611d9d03b1a505b21d1ae2d4ed1d3420~_7xYRg48Z1871018710epoutp04Z
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:36:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241016123625epoutp04611d9d03b1a505b21d1ae2d4ed1d3420~_7xYRg48Z1871018710epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729082185;
	bh=UVsxMR53W9XtECcTqAPzjCe5MFT++ZFTK0IoQGFyX50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2H0uxzTjQrTysPpdFAZ3k9U1AWyqYia/NdpqN5CW4mstpfp/b3OLSRDDnjQbgqEp
	 5qYkgTzu+nykMAzUBxll68UCVhlXFm0nS2jaGaMpCSP0ku8PGI6mE2z2qOYlpvyHGY
	 HD0y+1hb6ZQPjL2o0IKdGsKtbPwgz++9pu9M59qc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241016123624epcas5p2f0d8b35c2ea1b60bc616d926c088e95a~_7xXYp64r3112131121epcas5p2S;
	Wed, 16 Oct 2024 12:36:24 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XT9SQ3t5cz4x9Pr; Wed, 16 Oct
	2024 12:36:22 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7E.43.18935.643BF076; Wed, 16 Oct 2024 21:36:22 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241016113738epcas5p2d217b8d6efbf855f61c133f64deaa486~_6_EOP5tl3038230382epcas5p26;
	Wed, 16 Oct 2024 11:37:38 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241016113738epsmtrp16c8c84804246c27c5bbbec8778145815~_6_ENcN6u0254402544epsmtrp1o;
	Wed, 16 Oct 2024 11:37:38 +0000 (GMT)
X-AuditID: b6c32a50-cb1f8700000049f7-14-670fb346808a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2D.9A.07371.285AF076; Wed, 16 Oct 2024 20:37:38 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241016113736epsmtip1c8a477b3eda0933f06fe491b78581761~_6_CJyia12875928759epsmtip1E;
	Wed, 16 Oct 2024 11:37:36 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v4 03/11] block: modify bio_integrity_map_user to accept
 iov_iter as argument
Date: Wed, 16 Oct 2024 16:59:04 +0530
Message-Id: <20241016112912.63542-4-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241016112912.63542-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJsWRmVeSWpSXmKPExsWy7bCmhq7bZv50g3PTZC0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7O4eWAnk8XK1UeZLN61nmOxOPr/LZvFpEPXGC22n1nKbLH3lrbF/GVP2S26
	r+9gs1h+/B+TxflZc9gd+D12zrrL7nH5bKnHplWdbB6bl9R77L7ZwObx8ektFo++LasYPTaf
	rvb4vEkugDMq2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DX
	LTMH6HwlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWh
	gYGRKVBhQnbGzw/7GQveyVX0XvzL3sB4XrKLkYNDQsBEYvExqy5GTg4hgT2MEu+2KHcxcgHZ
	nxglHj+YywrhfGOU+Pr7MjNMw8PpPBDxvYwS7XeOM0E4nxklJrd+ZQMZxSagLnHkeSsjiC0i
	MIlR4vnlUJAiZoH3jBLv9y9nBUkIC8RLPJvVCFbEIqAqsfBOF1gzr4ClxLc3F1lAbAkBeYmZ
	l76zg9icAlYSp84dZIeoEZQ4OfMJWA0zUE3z1tnMIAskBI5wSDT+v8sO0ewicfnOZ0YIW1ji
	1fEtUHEpiZf9bVB2usSPy0+ZIOwCieZj+6Dq7SVaT/WDvcwsoCmxfpc+RFhWYuqpdUwQe/kk
	en8/gWrlldgxD8ZWkmhfOQfKlpDYe66BCRJyHhLPjytBAquXUeLHy6dMExgVZiF5ZxaSd2Yh
	bF7AyLyKUSq1oDg3PTXZtMBQNy+1HB7Jyfm5mxjBKVorYAfj6g1/9Q4xMnEwHmKU4GBWEuGd
	1MWbLsSbklhZlVqUH19UmpNafIjRFBjgE5mlRJPzgVkiryTe0MTSwMTMzMzE0tjMUEmc93Xr
	3BQhgfTEktTs1NSC1CKYPiYOTqkGptm/pmh3uzv2OolfmRqxc79L/fxvDYHKP1L+ecsLfZr9
	zmNeYV/lv8knpgcquSWd7vzDkvQpoEfBweeFa/J0O7uaxIt1TBH3j/jyTY2qe+D9+1aPXqiW
	gYnd4pj5rNP0poZK8Z5dsElFsFCbN2Fm0R/9Z5xuLFm1L826174xX6kUIF/E7F68WnTuG6FX
	9tE1m56zpfhuj3ohcj7UUfOM55o/5/537PLo2j5DsUZN3mztB+nQkzMCW57UPk04e21ryocp
	2zbsf7N3Ss2/2aI7vh5juStsvufD9ts+h1hqhPhfTthtxNA+5a3KPNaqqew6kQ0nrBe7p7lO
	1l4SYare6C/+48+c15Jqnh8YYx6yKbEUZyQaajEXFScCAHXHDIRaBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWy7bCSnG7TUv50g/+rdCw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7O4eWAnk8XK1UeZLN61nmOxOPr/LZvFpEPXGC22n1nKbLH3lrbF/GVP2S26
	r+9gs1h+/B+TxflZc9gd+D12zrrL7nH5bKnHplWdbB6bl9R77L7ZwObx8ektFo++LasYPTaf
	rvb4vEkugDOKyyYlNSezLLVI3y6BK+Pnh/2MBe/kKnov/mVvYDwv2cXIwSEhYCLxcDpPFyMX
	h5DAbkaJqz/62boYOYHiEhKnXi5jhLCFJVb+e84OUfSRUWLp7zlMIAk2AXWJI89bGUESIgKz
	GCUOz5rPBOIwC3xnlJi2/BoLyAphgViJCRvkQRpYBFQlFt7pAtvAK2Ap8e3NRRaIDfISMy99
	ZwexOQWsJE6dOwhmCwHV/Jv8gRGiXlDi5MwnYPXMQPXNW2czT2AE2oqQmoUktYCRaRWjZGpB
	cW56brJhgWFearlecWJucWleul5yfu4mRnAcaWnsYLw3/5/eIUYmDsZDjBIczEoivJO6eNOF
	eFMSK6tSi/Lji0pzUosPMUpzsCiJ8xrOmJ0iJJCeWJKanZpakFoEk2Xi4JRqYMrMXLbl/OQD
	R2UmvDy+ZfOarW/XvYypyL4i3bwz9805VospvNuMrj9IuH9yNtddaceLQdWL1qfsUl98qGv3
	hbWNhc+yXzxRFt697YHqgtb3TQnLhad561Q+eOW5Jt6vUc1V4vuTqmk6Z7LOv1kr9ZNrgarU
	+1u2zHvX7T0iYGNz541PichVm9INITs2W5jWzf7WrS8XrPHMc9d83jne5n7LjPymNuUdv2IQ
	HOwWarkk+fZaNXlp2yW635/tPx68hMPyk4SHonvE2xdrRCSePMncGNPcvkrW74LZqf5DE0NU
	653zT539PY9pec4V9rZNWS+X95d8f6Xaf+nZodPKIfMjNh5kuOFw5Czn8uPn/QMrlFiKMxIN
	tZiLihMBt0Z1GRIDAAA=
X-CMS-MailID: 20241016113738epcas5p2d217b8d6efbf855f61c133f64deaa486
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113738epcas5p2d217b8d6efbf855f61c133f64deaa486
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113738epcas5p2d217b8d6efbf855f61c133f64deaa486@epcas5p2.samsung.com>

This patch refactors bio_integrity_map_user to accept iov_iter as
argument. This is a prep patch.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c         | 12 +++++-------
 block/blk-integrity.c         | 10 +++++++++-
 include/linux/bio-integrity.h |  6 +++---
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 8948e635432d..341a0382befd 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -303,17 +303,16 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
 	return nr_bvecs;
 }
 
-int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
+int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter,
 			   u32 seed)
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
@@ -326,8 +325,7 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
 	else
 		direction = ITER_SOURCE;
 
-	iov_iter_ubuf(&iter, direction, ubuf, bytes);
-	nr_vecs = iov_iter_npages(&iter, BIO_MAX_VECS + 1);
+	nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS + 1);
 	if (nr_vecs > BIO_MAX_VECS)
 		return -E2BIG;
 	if (nr_vecs > UIO_FASTIOV) {
@@ -337,8 +335,8 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
 		pages = NULL;
 	}
 
-	copy = !iov_iter_is_aligned(&iter, align, align);
-	ret = iov_iter_extract_pages(&iter, &pages, bytes, nr_vecs, 0, &offset);
+	copy = !iov_iter_is_aligned(iter, align, align);
+	ret = iov_iter_extract_pages(iter, &pages, bytes, nr_vecs, 0, &offset);
 	if (unlikely(ret < 0))
 		goto free_bvec;
 
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 83b696ba0cac..cb8f7260bdcf 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -115,8 +115,16 @@ EXPORT_SYMBOL(blk_rq_map_integrity_sg);
 int blk_rq_integrity_map_user(struct request *rq, void __user *ubuf,
 			      ssize_t bytes, u32 seed)
 {
-	int ret = bio_integrity_map_user(rq->bio, ubuf, bytes, seed);
+	int ret;
+	struct iov_iter iter;
+	unsigned int direction;
 
+	if (op_is_write(req_op(rq)))
+		direction = ITER_DEST;
+	else
+		direction = ITER_SOURCE;
+	iov_iter_ubuf(&iter, direction, ubuf, bytes);
+	ret = bio_integrity_map_user(rq->bio, &iter, seed);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index 485d8a43017a..90aab50a3e14 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -75,7 +75,7 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio, gfp_t gfp,
 		unsigned int nr);
 int bio_integrity_add_page(struct bio *bio, struct page *page, unsigned int len,
 		unsigned int offset);
-int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t len, u32 seed);
+int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter, u32 seed);
 void bio_integrity_unmap_user(struct bio *bio);
 bool bio_integrity_prep(struct bio *bio);
 void bio_integrity_advance(struct bio *bio, unsigned int bytes_done);
@@ -101,8 +101,8 @@ static inline void bioset_integrity_free(struct bio_set *bs)
 {
 }
 
-static inline int bio_integrity_map_user(struct bio *bio, void __user *ubuf,
-					 ssize_t len, u32 seed)
+static inline int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter,
+					 u32 seed)
 {
 	return -EINVAL;
 }
-- 
2.25.1


