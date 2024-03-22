Return-Path: <io-uring+bounces-1199-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4865188737B
	for <lists+io-uring@lfdr.de>; Fri, 22 Mar 2024 19:58:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6A311F217B0
	for <lists+io-uring@lfdr.de>; Fri, 22 Mar 2024 18:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B753F76914;
	Fri, 22 Mar 2024 18:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pliPrxC9"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E1C7603E
	for <io-uring@vger.kernel.org>; Fri, 22 Mar 2024 18:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711133863; cv=none; b=F4TDvjaPlEKQRa4QsP0LoBZzB15BvleBFaf16ZWhLL8isc/nDHcgAIsmQvQ+3btodsjomXn37nA+pR+Q/R26MiaoFPhUXMd5f6ygg10O0rE0qmCL0/G+F+Tz70/HrrGOrOUqTnFHrDUw5mSJkhCOb4kONf1U/q+14Chj/mDlXXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711133863; c=relaxed/simple;
	bh=syu/InlwIWqqihQMOD2qdHzhCd/aLGFAsPn8K8olr94=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=sIBV4/n+OwT05dOt+uRkdWWpXS7Pou+WyJhJ0m1k5k+fVZEarmx5P+cpEX+xv9wWB349m5Dgj9eF1Pk8PurwqitYi27nvMhUDnKW4U4QOm4ehNEU+1Vu2CGJdlAgysC43DSR7V6Ww3dLEayiRtN4ZmHChkc4DYlFsCUwJLUvEtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pliPrxC9; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240322185739epoutp026491bdd585ae54aaed30994c5e659f4f~-Ky3fhC9M0890208902epoutp02R
	for <io-uring@vger.kernel.org>; Fri, 22 Mar 2024 18:57:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240322185739epoutp026491bdd585ae54aaed30994c5e659f4f~-Ky3fhC9M0890208902epoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1711133859;
	bh=u9x1Pfw1Q0EhKD2Isnc1MhcBzy/Nfy+GN5tL8AhSIzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pliPrxC9QEQLttDWOShCy1+5Szg76rBdX0HBQqCTQoT8VxzAUbW+bqSqz/7xy/MmZ
	 TMuDJ9DiFOawZmgJ8okc2gQ2gnJf1PLvDnoEzQbaIEqYEDeDCYjylwcvPhhh05KRJh
	 MFZA3ML+0moqKbu2hVJMxXJdeu3Qs3UZOdrZXqEI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240322185738epcas5p2ae10171c40bf8046d39d1e6731fa35da~-Ky23G1TY0149101491epcas5p2n;
	Fri, 22 Mar 2024 18:57:38 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4V1WmK0Mrmz4x9Pt; Fri, 22 Mar
	2024 18:57:37 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AC.70.09688.0A4DDF56; Sat, 23 Mar 2024 03:57:36 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240322185736epcas5p3d0093948e9904e775994bcbe735ea0c5~-Ky03RhUL3147731477epcas5p3s;
	Fri, 22 Mar 2024 18:57:36 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240322185736epsmtrp2594f807cda2318093b4a32970e017d89~-Ky02nfzM0597405974epsmtrp27;
	Fri, 22 Mar 2024 18:57:36 +0000 (GMT)
X-AuditID: b6c32a4a-837fa700000025d8-37-65fdd4a01eec
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	33.23.08390.0A4DDF56; Sat, 23 Mar 2024 03:57:36 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240322185734epsmtip1d4df9abc3cf12a412156b2431b22dc79~-KyyxbKpl1491214912epsmtip1b;
	Fri, 22 Mar 2024 18:57:34 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: martin.petersen@oracle.com, axboe@kernel.dk, kbusch@kernel.org,
	hch@lst.de
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [RFC PATCH 3/4] block: modify bio_integrity_map_user to accept
 iov_iter as argument
Date: Sat, 23 Mar 2024 00:20:22 +0530
Message-Id: <20240322185023.131697-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240322185023.131697-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKJsWRmVeSWpSXmKPExsWy7bCmlu6CK39TDQ48Mrf4+PU3i0XThL/M
	Fqvv9rNZrFx9lMniXes5Fouj/9+yWUw6dI3RYu8tbYvlx/8xOXB67Jx1l93j8tlSj02rOtk8
	dt9sYPP4+PQWi0ffllWMHp83yQWwR2XbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
	mCsp5CXmptoqufgE6Lpl5gAdpqRQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkpMCnQ
	K07MLS7NS9fLSy2xMjQwMDIFKkzIzpjzoJmpYL98xe5/C9kaGD9IdjFyckgImEj0nvvJCmIL
	CexmlNh+Ia2LkQvI/sQoMfv3bVYI5xujxJUDfawwHU8/P2OCSOxllDg6YzqU85lRomfeZyCH
	g4NNQFPiwuRSkAYRgQCJp7/PsYHUMAvMYZRYPq+fCSQhLBAn8fr2DRYQm0VAVWLOixZmEJtX
	wFLi+p99TBDb5CVmXvrODmJzClhJXL/6kwWiRlDi5MwnYDYzUE3z1tnMIAskBFo5JHb96mSH
	aHaR+LPvNwuELSzx6vgWqLiUxOd3e9kg7GSJSzPPQS0rkXi85yCUbS/ReqqfGeQZZqBn1u/S
	h9jFJ9H7+wnYjxICvBIdbUIQ1YoS9yY9hQaQuMTDGUugbA+JJZ1P2SDh08soMXHfW9YJjPKz
	kLwwC8kLsxC2LWBkXsUomVpQnJueWmxaYJSXWg6P2OT83E2M4PSp5bWD8eGDD3qHGJk4GA8x
	SnAwK4nw7vj/J1WINyWxsiq1KD++qDQntfgQoykwjCcyS4km5wMTeF5JvKGJpYGJmZmZiaWx
	maGSOO/r1rkpQgLpiSWp2ampBalFMH1MHJxSDUwR86durwicenC91j/B5JuXd1XfCqkx/7fh
	DMs2nSu5Lpxh8+/f2623WejlgeVPUk3mS7zdov/+3dbyqesLlnCdSX96Ruqx3kmlvfONf5vX
	eFQUnZpckRHX3bUsSLbslNxchl0eAs/bhYSWfJ5oGG9S33fE7crDncJGpxdHPxOfqzDv7TTd
	Wg7zxLY9s6/u3LUv+5PEZdkyn03nX20W8c3bUWBywlrZ7rfZlSdyUfIfWOr2TrYoig1f9Fha
	MGrSt8z97t3XmYv5/om1a72fL+K8788+rhim4veTJ3TIRLJ+l9Sbfjn6tLa6pNpCEYZaTfGl
	+Xudz2+a6WTedOPuCoUrh7ZdaZta99xMmFHviOQtJZbijERDLeai4kQA1fs10CgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSnO6CK39TDRZ9VbT4+PU3i0XThL/M
	Fqvv9rNZrFx9lMniXes5Fouj/9+yWUw6dI3RYu8tbYvlx/8xOXB67Jx1l93j8tlSj02rOtk8
	dt9sYPP4+PQWi0ffllWMHp83yQWwR3HZpKTmZJalFunbJXBlzHnQzFSwX75i97+FbA2MHyS7
	GDk5JARMJJ5+fsYEYgsJ7GaU2PaSFSIuLtF87Qc7hC0ssfLfc3aImo+MEsvvynQxcnCwCWhK
	XJhcChIWEQiRWNY6gbmLkYuDWWABo0TTq242kISwQIzEojX7mUFsFgFViTkvWsBsXgFLiet/
	9jFBzJeXmHnpO9h8TgErietXf7JA7LKUmP58NStEvaDEyZlPwOLMQPXNW2czT2AUmIUkNQtJ
	agEj0ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOCw19Lawbhn1Qe9Q4xMHIyHGCU4
	mJVEeHf8/5MqxJuSWFmVWpQfX1Sak1p8iFGag0VJnPfb694UIYH0xJLU7NTUgtQimCwTB6dU
	A1PGUhZVhYS2Sd5LRI5zHXyxYPb3SX5W4U+ePbRhmJyxP+rEw4gzKxUSiwy2WC7N1CvgX6wQ
	wb619fz3z2rh59iKnfwcm1csa01p/eb/rsiYdVHppb83v0wKVi2VV2HmT70/8Vkr51KBnESJ
	c5sY3/19Lz0jrXThL8cn+asf7v9Ue1piv1niYeXvG6otJ+zyqvK7cLdC12HfHMbfu81nOt6a
	rDutuoRJXWL23vd1bKyL3i9PVSlK++TucWj369cJv5RvSLfeDzC7Eyx9Ompn1qGe1H9ZIgXb
	Zi3ayDtZ+236j6kdzKt+qulNUnsyQe2HrJPFLeGHDE3WP/vvT5rgv7Tl8xuew92Nps4nFRQb
	hCWVWIozEg21mIuKEwGUv7H76gIAAA==
X-CMS-MailID: 20240322185736epcas5p3d0093948e9904e775994bcbe735ea0c5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240322185736epcas5p3d0093948e9904e775994bcbe735ea0c5
References: <20240322185023.131697-1-joshi.k@samsung.com>
	<CGME20240322185736epcas5p3d0093948e9904e775994bcbe735ea0c5@epcas5p3.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

Refactor bio_integrity_map_user to accept iov_iter as
argument. This is a prep patch.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c     | 14 ++++++--------
 drivers/nvme/host/ioctl.c | 11 +++++++++--
 include/linux/bio.h       |  7 ++++---
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 2e3e8e04961e..e340b5a03cdf 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -308,17 +308,16 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
 	return nr_bvecs;
 }
 
-int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
-			   u32 seed)
+int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter,
+			  u32 seed)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	unsigned int align = q->dma_pad_mask | queue_dma_alignment(q);
 	struct page *stack_pages[UIO_FASTIOV], **pages = stack_pages;
 	struct bio_vec stack_vec[UIO_FASTIOV], *bvec = stack_vec;
+	size_t offset, bytes = iter->count;
 	unsigned int direction, nr_bvecs;
-	struct iov_iter iter;
 	int ret, nr_vecs;
-	size_t offset;
 	bool copy;
 
 	if (bio_integrity(bio))
@@ -331,8 +330,7 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
 	else
 		direction = ITER_SOURCE;
 
-	iov_iter_ubuf(&iter, direction, ubuf, bytes);
-	nr_vecs = iov_iter_npages(&iter, BIO_MAX_VECS + 1);
+	nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS + 1);
 	if (nr_vecs > BIO_MAX_VECS)
 		return -E2BIG;
 	if (nr_vecs > UIO_FASTIOV) {
@@ -342,8 +340,8 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
 		pages = NULL;
 	}
 
-	copy = !iov_iter_is_aligned(&iter, align, align);
-	ret = iov_iter_extract_pages(&iter, &pages, bytes, nr_vecs, 0, &offset);
+	copy = !iov_iter_is_aligned(iter, align, align);
+	ret = iov_iter_extract_pages(iter, &pages, bytes, nr_vecs, 0, &offset);
 	if (unlikely(ret < 0))
 		goto free_bvec;
 
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 3dfd5ae99ae0..deee13000f08 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -145,8 +145,15 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 	if (bdev) {
 		bio_set_dev(bio, bdev);
 		if (meta_buffer && meta_len) {
-			ret = bio_integrity_map_user(bio, meta_buffer, meta_len,
-						     meta_seed);
+			struct iov_iter iter;
+			unsigned int direction;
+
+			if (bio_data_dir(bio) == READ)
+				direction = ITER_DEST;
+			else
+				direction = ITER_SOURCE;
+			iov_iter_ubuf(&iter, direction, meta_buffer, meta_len);
+			ret = bio_integrity_map_user(bio, &iter, meta_seed);
 			if (ret)
 				goto out_unmap;
 			req->cmd_flags |= REQ_INTEGRITY;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 875d792bffff..20cf47fc851f 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -723,7 +723,7 @@ static inline bool bioset_initialized(struct bio_set *bs)
 	for_each_bio(_bio)						\
 		bip_for_each_vec(_bvl, _bio->bi_integrity, _iter)
 
-int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t len, u32 seed);
+int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter, u32 seed);
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
 extern bool bio_integrity_prep(struct bio *);
@@ -795,8 +795,9 @@ static inline int bio_integrity_add_page(struct bio *bio, struct page *page,
 	return 0;
 }
 
-static inline int bio_integrity_map_user(struct bio *bio, void __user *ubuf,
-					 ssize_t len, u32 seed)
+static inline int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter,
+					u32 seed)
+
 {
 	return -EINVAL;
 }
-- 
2.25.1


