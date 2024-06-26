Return-Path: <io-uring+bounces-2349-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9929E917FF9
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 13:42:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26CEA1F24BC6
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 11:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A357E17F4FA;
	Wed, 26 Jun 2024 11:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YMbcZapM"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952ED17F4F0
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719402157; cv=none; b=NoUINYB+9AaeHJvhfnFqmI3fPn9gcX5ogGh/NzdgRVcEQCIRm6sBgl0KP04Lr/ctngkuvNEbndm3Agka2KIcJc5QbsDyyJJtx2uvAIMv3qExrh0kvS0jNVbt8aSRTWhcVcEivXWUBxVARG/6dsBygsGt3wKfPJX0F/PXs3w9Fuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719402157; c=relaxed/simple;
	bh=pAcrVqvzIHK6gcFDcS2qtFzmbz2pTTMoSzKWX8SsNnw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=AynZ4/PQj7ejOcGQpNPUBeKKDn4eca65XtMLX4gTFa+O4OknJL4cMpk8aqK0e/NHhIU1+DfSXh+7pH8YGj9TW4medTK0dmfThkZqtJfjdnNSRMtQRL8HGiNGYNByMQbcg02PWxN5vAVUcjSb8/LLWYjkYWYMhAN8b/NQxkkDQZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YMbcZapM; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240626114227epoutp0400633892686d2b5b46cce3543c6b6225~ciyS-xfSd2386023860epoutp04Q
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:42:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240626114227epoutp0400633892686d2b5b46cce3543c6b6225~ciyS-xfSd2386023860epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719402147;
	bh=pO3eGbVZcPQlxKtRYSdD+0t2tpPWLie9HfulaNqkz/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMbcZapM4i/SKlRvfcqV4Z9tnRv7p5llGvLx+FKpvarxM8OQYlBqWOQ0U75y1zu2z
	 C9sa3K84bSRgvF+B6DO3zIY6JxD7DK3DQz9M9tEL3cdJufOdIDeMRzZ496RMpBMF1i
	 Ok5RM5J7kMhX9i0XTlnEf4PSicHzmBYUl+/zVvvI=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240626114227epcas5p4f56c41f4aaffacff454027f720ff5870~ciySkmlkC0207802078epcas5p4Q;
	Wed, 26 Jun 2024 11:42:27 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4W8KYs3yNlz4x9Pv; Wed, 26 Jun
	2024 11:42:25 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C4.18.09989.1AEFB766; Wed, 26 Jun 2024 20:42:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240626101521epcas5p42b0c1c0e123996b199e058bae9a69123~chmP_YtvB2295722957epcas5p4V;
	Wed, 26 Jun 2024 10:15:21 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240626101521epsmtrp1590517e3aa77fb307b919163c4b00bcd~chmP9oZzM1024010240epsmtrp1i;
	Wed, 26 Jun 2024 10:15:21 +0000 (GMT)
X-AuditID: b6c32a4a-bffff70000002705-63-667bfea1aa2e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	50.7B.29940.93AEB766; Wed, 26 Jun 2024 19:15:21 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240626101519epsmtip125c4bbfe3a765009cf04a8051d5a62d3~chmOQxHOo0370603706epsmtip1D;
	Wed, 26 Jun 2024 10:15:19 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v2 06/10] block: modify bio_integrity_map_user to accept
 iov_iter as argument
Date: Wed, 26 Jun 2024 15:36:56 +0530
Message-Id: <20240626100700.3629-7-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240626100700.3629-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOJsWRmVeSWpSXmKPExsWy7bCmpu7Cf9VpBqtvy1g0TfjLbDFn1TZG
	i9V3+9ksVq4+ymTxrvUci8XR/2/ZLCYdusZosfeWtsX8ZU/ZLZYf/8dkMbHjKpMDt8fOWXfZ
	PS6fLfXYtKqTzWPzknqP3Tcb2Dw+Pr3F4vF+31U2j74tqxg9Pm+SC+CMyrbJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpVSaEsMacUKBSQWFyspG9n
	U5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdMeHnaeaCZ/IVE3+t
	ZmlgnCLVxcjJISFgItHdt4+pi5GLQ0hgN6PEncnL2CCcT4wSlxrWMEI43xglLuzfzALT0te3
	DSqxl1Hi2oqJUP2fGSVmLpzGCFLFJqAuceR5K5gtIlArsbJ1OjtIEbPAUkaJDw+uM4MkhAXi
	JfYtXgxmswioSuxZ/ZUJxOYVsJA4s3s3E8Q6eYmZl76zg9icApYSdzZvZ4SoEZQ4OfMJ2EnM
	QDXNW2czgyyQEJjLIfH+2CeoZheJQ23vmCFsYYlXx7ewQ9hSEi/726DsdIkfl59C1RdINB/b
	xwhh20u0nuoH6uUAWqApsX6XPkRYVmLqqXVMEHv5JHp/P4Fq5ZXYMQ/GVpJoXzkHypaQ2Huu
	Acr2kDgzeRU0tHoYJZ6/mMM4gVFhFpJ/ZiH5ZxbC6gWMzKsYJVMLinPTU4tNC4zyUsvh8Zyc
	n7uJEZyCtbx2MD588EHvECMTB+MhRgkOZiUR3tCSqjQh3pTEyqrUovz4otKc1OJDjKbAAJ/I
	LCWanA/MAnkl8YYmlgYmZmZmJpbGZoZK4ryvW+emCAmkJ5akZqemFqQWwfQxcXBKNTDZddw/
	b+O0b2IY7+Krh/mkOf8LRDpd2/bjQfr22TnTPJZlzyoNavySVVi1N/5JyWV1fs/PF1sehj8K
	8tueoOkRse5+U/xmBvuWB7Vfyx6Z7JCJODvF2TNx1fwz38StTY/OmGC462I7K9clRhkTBwHB
	6+xcasvZL05Z6XfygRLXHC+1z1Wre+UMjnqd8/5Tp7H99QwpJXO3s0wqs1Y4+RtIuUQa71x6
	Y/H2cyc45vlOErL4PWnGBz+rzby9Rfr/7rhNPvZiqc+S+Fu+v0J4gvJ1Qz9dn3j2e+erALMf
	t0+1+k96de5RJfvnl5c+MgraevFI3X1RVX0u6a/NgdgmIbme4+za4VOrFga+bPbsUH+vxFKc
	kWioxVxUnAgAxDgA0EoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWy7bCSnK7lq+o0g+6lGhZNE/4yW8xZtY3R
	YvXdfjaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2i+XH/zFZTOy4yuTA7bFz1l12
	j8tnSz02repk89i8pN5j980GNo+PT2+xeLzfd5XNo2/LKkaPz5vkAjijuGxSUnMyy1KL9O0S
	uDIm/DzNXPBMvmLir9UsDYxTpLoYOTkkBEwk+vq2MXYxcnEICexmlFja/p0ZIiEhcerlMkYI
	W1hi5b/n7BBFHxklfvw+wgSSYBNQlzjyvBWsW0SglVHiwNQWMIdZYCWjxO1FL8CqhAViJU7e
	WAE2ikVAVWLP6q9gcV4BC4kzu3czQayQl5h56Ts7iM0pYClxZ/N2sHohoJoHz5tZIeoFJU7O
	fMICYjMD1Tdvnc08gVFgFpLULCSpBYxMqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcx
	gqNES3MH4/ZVH/QOMTJxMB5ilOBgVhLhDS2pShPiTUmsrEotyo8vKs1JLT7EKM3BoiTOK/6i
	N0VIID2xJDU7NbUgtQgmy8TBKdXAtOLh3wOsB/p/WCn8c9q/REzJu3DHerOfV0101J8dDMyX
	OF3KwvZqx5bufhYjSZHDCzRswwKVahdPsD9VP/2cwEETW+WPsTPDNucwJAUl3Pt0zu3+33fH
	Vtb76eqdn+vf93xXyBKL1VcvlswWO1Hr8ZMl6laS5rG0+z+u7jf2Xv2HaY2IePN36Z+vej+o
	z4vgkf96f8btzUcyFyyWVX4q0C7tcUj43Op4Xq4Ve++5pYvY5GvcKdBmFs3+sfHUnoYPAlK3
	+hh+idTx66xYd/7Z3bWykzI1/F7HT72a+vyLaFt6fkzaywcGWR7XS/8VzY27d9w62/33/6QD
	6zQfRWgbugU2XV0yl6fKq8pTUKkzV4mlOCPRUIu5qDgRAE5UtRkBAwAA
X-CMS-MailID: 20240626101521epcas5p42b0c1c0e123996b199e058bae9a69123
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240626101521epcas5p42b0c1c0e123996b199e058bae9a69123
References: <20240626100700.3629-1-anuj20.g@samsung.com>
	<CGME20240626101521epcas5p42b0c1c0e123996b199e058bae9a69123@epcas5p4.samsung.com>

This patch refactors bio_integrity_map_user to accept iov_iter as
argument. This is a prep patch.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c     | 12 +++++-------
 drivers/nvme/host/ioctl.c | 11 +++++++++--
 include/linux/bio.h       |  8 +++++---
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 8f07c4d0fada..38418be07139 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -337,17 +337,16 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
 	return nr_bvecs;
 }
 
-int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
+int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter,
 			   u32 seed)
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
@@ -360,8 +359,7 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
 	else
 		direction = ITER_SOURCE;
 
-	iov_iter_ubuf(&iter, direction, ubuf, bytes);
-	nr_vecs = iov_iter_npages(&iter, BIO_MAX_VECS + 1);
+	nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS + 1);
 	if (nr_vecs > BIO_MAX_VECS)
 		return -E2BIG;
 	if (nr_vecs > UIO_FASTIOV) {
@@ -371,8 +369,8 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
 		pages = NULL;
 	}
 
-	copy = !iov_iter_is_aligned(&iter, align, align);
-	ret = iov_iter_extract_pages(&iter, &pages, bytes, nr_vecs, 0, &offset);
+	copy = !iov_iter_is_aligned(iter, align, align);
+	ret = iov_iter_extract_pages(iter, &pages, bytes, nr_vecs, 0, &offset);
 	if (unlikely(ret < 0))
 		goto free_bvec;
 
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 8b69427a4476..e77ea1e7be03 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -152,8 +152,15 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
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
index 44226fcb4d00..c90168274188 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -731,7 +731,7 @@ static inline bool bioset_initialized(struct bio_set *bs)
 	for_each_bio(_bio)						\
 		bip_for_each_vec(_bvl, _bio->bi_integrity, _iter)
 
-int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t len, u32 seed);
+int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter, u32 seed);
 void bio_integrity_unmap_free_user(struct bio *bio);
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
@@ -804,11 +804,13 @@ static inline int bio_integrity_add_page(struct bio *bio, struct page *page,
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
+
 static inline void bio_integrity_unmap_free_user(struct bio *bio)
 {
 }
-- 
2.25.1


