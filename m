Return-Path: <io-uring+bounces-1634-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11FCD8B2862
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 20:47:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93E141F22256
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 18:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529A31514D9;
	Thu, 25 Apr 2024 18:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ieemyNF+"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E62014E2CC
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714070829; cv=none; b=nYjHZECpFg4H+zHZuy8u3cOGiiNx5W+iDGTrnRk2QSFAfLljQipub8zHaluGWBzxT63ycHcIjRlie5BFRoArr1uAYX2sK6GzTfll1UTl+JFgHZtPdt6RWbadOkmss1YGuleiG8E4fPGeEY1HL14b+0Fv8oRWnRCGhuxI+BO1WVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714070829; c=relaxed/simple;
	bh=EELVs2/K7r6/yt7yfKYJWd3E3c40DRgqJAJx6QNgmF8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=GIIv7pLLynoZgtvsKbsDFdxWrIKOJcp9rEvLsi7JTQgKnN1IQR2vI/dDllSlxXNPsB+CdyPCfMwVN8K0iuThGe8JYZ3i4+oH7dIOEVvRhhO+CVFMpq5jZ4lqnLlsV9QWDHcg8UV3cEx80TC0kCa9J/U4//4Dae1d0ds16djgagU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ieemyNF+; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240425184705epoutp01fc5b46cd68f70edff511d77240f4b5c3~JmlV4kUUo0155801558epoutp01p
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:47:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240425184705epoutp01fc5b46cd68f70edff511d77240f4b5c3~JmlV4kUUo0155801558epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714070825;
	bh=OxaxYUv6kXArTeVw0WCBnIgHVnHyAM8bZTyh57XJclA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ieemyNF+qwNgiF5ZKTEJtJSDMhMEsCir90HlzFn8b6N/jX5iUBpUNWLFHS3TYQ6hI
	 qVdmxSi2lYAWc2QgfWxT2xgeyaWtgViHtbSkTfO8hu4AIkTKP1vZLf5h4CU3GvTF2/
	 JBfcIw+hmTHteIVisvsB4/9tsdSrJNAXUqJQHKcE=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240425184704epcas5p449c454a93cee3cd90db570bdcd3525e4~JmlVUZQq11507515075epcas5p4f;
	Thu, 25 Apr 2024 18:47:04 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4VQPwQ5N6Fz4x9Pp; Thu, 25 Apr
	2024 18:47:02 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6B.E6.19431.625AA266; Fri, 26 Apr 2024 03:47:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240425184702epcas5p1ccb0df41b07845bc252d69007558e3fa~JmlTM_5Ai1330613306epcas5p1M;
	Thu, 25 Apr 2024 18:47:02 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240425184702epsmtrp18037949dd8671c2b47ec3374d07e8cf3~JmlTMODXx0085000850epsmtrp1f;
	Thu, 25 Apr 2024 18:47:02 +0000 (GMT)
X-AuditID: b6c32a50-f57ff70000004be7-cd-662aa526028b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2B.F0.07541.625AA266; Fri, 26 Apr 2024 03:47:02 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240425184700epsmtip12c9a5239317da24686f8384443bb40e6~JmlRXCNYr0041000410epsmtip1N;
	Thu, 25 Apr 2024 18:47:00 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	hch@lst.de, brauner@kernel.org
Cc: asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH 06/10] block: modify bio_integrity_map_user argument
Date: Fri, 26 Apr 2024 00:09:39 +0530
Message-Id: <20240425183943.6319-7-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240425183943.6319-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMJsWRmVeSWpSXmKPExsWy7bCmuq7aUq00g4bt6hZNE/4yW8xZtY3R
	YvXdfjaL14c/MVq8mrGWzeLmgZ1MFitXH2WyeNd6jsXi6P+3bBaTDl1jtNh7S9ti/rKn7BbL
	j/9jcuD1uDZjIovHzll32T0uny312LSqk81j85J6j903G9g8Pj69xeLRt2UVo8fnTXIBnFHZ
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVysplCXm
	lAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjN6
	dl9gKzgtX7Gp7zhLA+MvyS5GTg4JAROJ609Ws3UxcnEICexhlJgzaxo7hPOJUWLHsycsEM43
	Ron210cZYVp+vJ7ABJHYyyjR2TQbqv8zo8S2NTuB+jk42AQ0JS5MLgVpEBFIkXi17jVYM7PA
	U0aJH51MILawgIvEk21XWUFsFgFViRs//oDZvALmEh9PbGSDWCYvMfPSd3YQm1PAQmLyxdPs
	EDWCEidnglwHMlNeonnrbGaQGyQE1nJIzLt8EOpSF4kf9/5CDRKWeHV8CzuELSXxsr8Nyk6W
	uDTzHBOEXSLxeM9BKNteovVUPzPIL8xAv6zfpQ+xi0+i9/cTJpCwhACvREebEES1osS9SU9Z
	IWxxiYczlkDZHhLbL5yFhmg3o8S578eYJzDKz0LywiwkL8xC2LaAkXkVo1RqQXFuemqyaYGh
	bl5qOTxmk/NzNzGCU69WwA7G1Rv+6h1iZOJgPMQowcGsJMJ786NGmhBvSmJlVWpRfnxRaU5q
	8SFGU2AgT2SWEk3OByb/vJJ4QxNLAxMzMzMTS2MzQyVx3tetc1OEBNITS1KzU1MLUotg+pg4
	OKUamELFDjccknIKlmJlt/B5ahN4ftXR4kdpBvqsij2+7X6B3H0ZZv+YdrMWSd3lqG5SLxHz
	Zpq76Kzn7elKX5Y8O25gHqrRc0U0UHjSMqbPN9fNiLZ/I3EzSvi26sS8yV0PlI80mO2ctHJ2
	5cwvgk/Mr896ErxmnY/g7mtRwmfMJxZk5TZeY/prkerrW/frcJPGxGt/r9qX2+f/yVldf2t/
	6KEfj7cwxHzMfVPMeN/rBxvDvPmvtaeLWz/U2jBHq67557+JBybd6poT/kZ26U/33XJ/b83Z
	2n+2ItDn2Y1pCmxbvx6YwXuk8vwOhwOP3SI6dl/9p3Biy9tLTLtKd3D5TvSUux6TpnddYa+0
	DcePnktKLMUZiYZazEXFiQBoTdiSRgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWy7bCSnK7aUq00g8kfWC2aJvxltpizahuj
	xeq7/WwWrw9/YrR4NWMtm8XNAzuZLFauPspk8a71HIvF0f9v2SwmHbrGaLH3lrbF/GVP2S2W
	H//H5MDrcW3GRBaPnbPusntcPlvqsWlVJ5vH5iX1HrtvNrB5fHx6i8Wjb8sqRo/Pm+QCOKO4
	bFJSczLLUov07RK4Mnp2X2ArOC1fsanvOEsD4y/JLkZODgkBE4kfrycwdTFycQgJ7GaUuLf0
	HxtEQlyi+doPdghbWGLlv+fsEEUfGSX2/p/A0sXIwcEmoClxYXIpSI2IQJbE3v4rYDXMAm8Z
	Jeb/3cMMkhAWcJF4su0qK4jNIqAqcePHHzCbV8Bc4uOJjVDL5CVmXvoOtoxTwEJi8sXTYLYQ
	UM3UNYsYIeoFJU7OfMICYjMD1Tdvnc08gVFgFpLULCSpBYxMqxglUwuKc9Nzkw0LDPNSy/WK
	E3OLS/PS9ZLzczcxgqNGS2MH4735//QOMTJxMB5ilOBgVhLhvflRI02INyWxsiq1KD++qDQn
	tfgQozQHi5I4r+GM2SlCAumJJanZqakFqUUwWSYOTqkGJvXbJjyNbx3n7652j7afwLHnmFnt
	DqewL2e9Lr4QqGh3MrZ9HVy95mHLjxKFytJyp7BoAeZLvpv1nivllPB7qa2NPuAz9cOWpQqP
	dh7v7EhzK7A2XJN75+7G5Q28osuEn/Ze54laFOv3pPJu6vLXNZ7PFK7N+dV34tTNg4aLH0QF
	mYhNnbzFMPoIa4ZvdfPMSW+XV837GvPv99oijfk3uPmuZPKf7l6zvqbTakfN/1mf508Q0ftm
	HmaSu+bpp98tl5zSLzy0lDv58/sir/k7GJtbP7nWSqc+PnKQ9533i5thh5IdaidnSKrmJUb9
	UXQxXtKhctDH0ICfTfJj0ZNGe5Opa68IPgmertu7oNmuUYmlOCPRUIu5qDgRAHhULSgJAwAA
X-CMS-MailID: 20240425184702epcas5p1ccb0df41b07845bc252d69007558e3fa
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240425184702epcas5p1ccb0df41b07845bc252d69007558e3fa
References: <20240425183943.6319-1-joshi.k@samsung.com>
	<CGME20240425184702epcas5p1ccb0df41b07845bc252d69007558e3fa@epcas5p1.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

This patch refactors bio_integrity_map_user to accept iov_iter as
argument. This is a prep patch.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c     | 14 ++++++--------
 drivers/nvme/host/ioctl.c | 11 +++++++++--
 include/linux/bio.h       |  7 ++++---
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index b698eb77515d..1085cf45f51e 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -318,17 +318,16 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
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
@@ -341,8 +340,7 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
 	else
 		direction = ITER_SOURCE;
 
-	iov_iter_ubuf(&iter, direction, ubuf, bytes);
-	nr_vecs = iov_iter_npages(&iter, BIO_MAX_VECS + 1);
+	nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS + 1);
 	if (nr_vecs > BIO_MAX_VECS)
 		return -E2BIG;
 	if (nr_vecs > UIO_FASTIOV) {
@@ -352,8 +350,8 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
 		pages = NULL;
 	}
 
-	copy = !iov_iter_is_aligned(&iter, align, align);
-	ret = iov_iter_extract_pages(&iter, &pages, bytes, nr_vecs, 0, &offset);
+	copy = !iov_iter_is_aligned(iter, align, align);
+	ret = iov_iter_extract_pages(iter, &pages, bytes, nr_vecs, 0, &offset);
 	if (unlikely(ret < 0))
 		goto free_bvec;
 
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 499a8bb7cac7..4ed389edb3b6 100644
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


