Return-Path: <io-uring+bounces-2908-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D408495CAD0
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 12:48:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E1AC1F27965
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 10:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E3738389;
	Fri, 23 Aug 2024 10:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GsyhN/HM"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93A2187563
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724410106; cv=none; b=WZ0cJfjmDaCOWxhvKUMmnqvoXuS/NCE9GczXxl6/Lz6zbU3+mJGvNtmw/vhMUO/RJjRXBCXTBGKsPimorSJsKW2cCsvhmSQ5i4jsMf5DDyxOIdmjtHi9Sn6zz49156I83A/w57DUpKnsxCFsywpICbSg1tIwRdhtZ7QpT2YdqDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724410106; c=relaxed/simple;
	bh=sZkPdHu9h1cr9eLtTsn2Hs6X8Mcx1oFFuOWH/X/o+Tg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=sJx9RPll8JTttul5lWTnFBegnbHK2L7DCPjmCor7bntSMEXZqgjyW3QiigFVZvTMCReG5CrcWq51TBUDA3CzPs/CCutqSLMFzAGUxUpZaLA4D4vJbOpOwsi8K+98XTnhox9Bs0ko2Wzy7HbH/ruu2jCM7EN6RZp4sIyJCfqaAbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=GsyhN/HM; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240823104823epoutp0254c6cae296d59b9d6f8c4aa4f796162b~uVdo9Lspg0969809698epoutp02a
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:48:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240823104823epoutp0254c6cae296d59b9d6f8c4aa4f796162b~uVdo9Lspg0969809698epoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724410103;
	bh=90CNtiP/2tt+h1YZtONu5flbGM3VvoqfTKHbF+jJYgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GsyhN/HM1//gxXmRqb23bC+dYSqQoLO85lk6DFbBuhEYGiuZNAtKjhKMuMETelPiF
	 sHf6pHzbzLZc6N4xXpjIXsuAAdaZcoTwu4gF6qS6dRGglhMBhv1p3RpDPpwD3JKk5L
	 5EJfm2Gjw6HfWA6CKGWHVWM4k7gB8abCF0ecn9iU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240823104822epcas5p1262f2e00ced25e2a84c26e18f1596f68~uVdodsH0s2850128501epcas5p1a;
	Fri, 23 Aug 2024 10:48:22 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Wqxch6lndz4x9Q0; Fri, 23 Aug
	2024 10:48:20 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9A.8F.09743.4F868C66; Fri, 23 Aug 2024 19:48:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240823104622epcas5p2e3b29f793eff9857c5712b3d6d327ed5~uVb44JoMx1288512885epcas5p2n;
	Fri, 23 Aug 2024 10:46:22 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240823104622epsmtrp2e09c20224f926e6655aeccf9907e12da~uVb42v-es0122301223epsmtrp2E;
	Fri, 23 Aug 2024 10:46:22 +0000 (GMT)
X-AuditID: b6c32a4a-14fff7000000260f-7d-66c868f4185f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	26.50.19367.E7868C66; Fri, 23 Aug 2024 19:46:22 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240823104620epsmtip288908594f49a4e4a562d9e488ce2b8d2~uVb213WlK1442714427epsmtip2a;
	Fri, 23 Aug 2024 10:46:20 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v3 04/10] block: modify bio_integrity_map_user to accept
 iov_iter as argument
Date: Fri, 23 Aug 2024 16:08:04 +0530
Message-Id: <20240823103811.2421-5-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240823103811.2421-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLJsWRmVeSWpSXmKPExsWy7bCmlu6XjBNpBktn61k0TfjLbDFn1TZG
	i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaL7WeWMlvsvaVtMX/ZU3aL7us72CyW
	H//H5MDrsXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49Pb7F49G1Zxeix+XS1x+dNcgGcUdk2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBHKymUJeaU
	AoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyMzad
	esFUcEq+YsPlFywNjL1SXYycHBICJhIz+qeydzFycQgJ7GaUWLJ6CROE84lRYs27BWwgVWDO
	jauOMB0//7SzQBTtZJS4Pm8bVPtnRommjkksIFVsAuoSR563MoLYIgKVEs93/QDrYBa4yShx
	aO8zZpCEsEC8xPXuZWBFLAKqEhMvbwdr5hWwkNj6sJMNYp28xMxL39lBbE4BS4mm2Q1QNYIS
	J2c+AbOZgWqat85mBlkgIbCUQ+Jk8xxWiGYXiYW/NjNC2MISr45vYYewpSQ+v9sLtSBd4sfl
	p0wQdoFE87F9UPX2Eq2n+oGGcgAt0JRYv0sfIiwrMfXUOiaIvXwSvb+fQLXySuyYB2MrSbSv
	nANlS0jsPdfABDJGQsBD4v6yIkiI9jBKHDuQPYFRYRaSb2Yh+WYWwuIFjMyrGCVTC4pz01OL
	TQuM8lLL4ZGcnJ+7iRGcjrW8djA+fPBB7xAjEwfjIUYJDmYlEd6ke0fThHhTEiurUovy44tK
	c1KLDzGaAoN7IrOUaHI+MCPklcQbmlgamJiZmZlYGpsZKonzvm6dmyIkkJ5YkpqdmlqQWgTT
	x8TBKdXAZM7Z8UtfP6wtck+XXnf9xh2f3VOaLhjHSjRv1Fvkd7CpecL01LSutNu3Fxppzy5Y
	q3Zj5t5JW2yu/BYUiFVbF8si07SOk+OD+NS/056+kjj1U7v0cN8Hkd07BBNS9614srjdSz2U
	/7nS1n+GG1pXflj2cYXZq+wcw/2qnd2T8r///nesfXG2OLdhk5T0JgcewTWpZQW3otZt+H7e
	jklAbyN7wtxKz/Lf63av3FK7MEGhpdQhzFS5fOYtlvWl6rx+v42+VMf/kF286vPae2KeGpmO
	hzMuPvgd0Hv678zNtgKxe83r57u+iAiS+V/faxBXPGXVk46MWYfl1llcvjBx/0Wp/sUpz0O2
	iNbsLzv3V4mlOCPRUIu5qDgRAPCSqotQBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWy7bCSvG5dxok0g/mnNC2aJvxltpizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF9jNLmS323tK2mL/sKbtF9/UdbBbL
	j/9jcuD12DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvTYfLra4/MmuQDOKC6b
	lNSczLLUIn27BK6MTadeMBWckq/YcPkFSwNjr1QXIyeHhICJxM8/7SxdjFwcQgLbGSUebupg
	gUhISJx6uYwRwhaWWPnvOTtE0UdGiRud59lAEmwC6hJHnrcygiREBBoZJbY0fwHrZha4zyix
	oDsExBYWiJX40tgE1sAioCox8fJ2sBpeAQuJrQ872SA2yEvMvPSdHcTmFLCUaJrdAFYjBFSz
	bPkZRoh6QYmTM59AzZeXaN46m3kCo8AsJKlZSFILGJlWMYqmFhTnpucmFxjqFSfmFpfmpesl
	5+duYgRHi1bQDsZl6//qHWJk4mA8xCjBwawkwpt072iaEG9KYmVValF+fFFpTmrxIUZpDhYl
	cV7lnM4UIYH0xJLU7NTUgtQimCwTB6dUA9M0I/66B5oq26w79mceEJGwXFpX80HfxG1D/5LT
	Ti9XiE+ztA/v7nhw+45Sg/X8fTMkd+z7xG3j3Cqq8PXYx6tP3F88mRwU79Gu48XIniC5jNfv
	nPLjR9KVaYcnzdE/Fhv2ofSy1MN+Xc4FjhnNIZtjuxfIvFwxl7HHZVl33elM/9kN6wPOvkr6
	XGc2SeVU3X2Zc6rlC9Jzt8gueXq+2zn+/Zr+WQfXspev2sDEtPjXSvcY3pOPVdbqvmQ9c2jn
	nG13YywqDzJyfF8nPIlHj/3VNaXCrMIX7k18F51O/e7adtXb4li6sGxIXS/n/cRz7dF3PpRz
	u5vxMVXvmdO0dFnEjU3SVXW7cpjOi0s7+CmxFGckGmoxFxUnAgC0jE+0BQMAAA==
X-CMS-MailID: 20240823104622epcas5p2e3b29f793eff9857c5712b3d6d327ed5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240823104622epcas5p2e3b29f793eff9857c5712b3d6d327ed5
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104622epcas5p2e3b29f793eff9857c5712b3d6d327ed5@epcas5p2.samsung.com>

This patch refactors bio_integrity_map_user to accept iov_iter as
argument. This is a prep patch.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c         | 12 +++++-------
 drivers/nvme/host/ioctl.c     | 11 +++++++++--
 include/linux/bio-integrity.h |  6 +++---
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index d8b810a2b4bf..aaf67eb427ab 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -310,17 +310,16 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
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
@@ -333,8 +332,7 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
 	else
 		direction = ITER_SOURCE;
 
-	iov_iter_ubuf(&iter, direction, ubuf, bytes);
-	nr_vecs = iov_iter_npages(&iter, BIO_MAX_VECS + 1);
+	nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS + 1);
 	if (nr_vecs > BIO_MAX_VECS)
 		return -E2BIG;
 	if (nr_vecs > UIO_FASTIOV) {
@@ -344,8 +342,8 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
 		pages = NULL;
 	}
 
-	copy = !iov_iter_is_aligned(&iter, align, align);
-	ret = iov_iter_extract_pages(&iter, &pages, bytes, nr_vecs, 0, &offset);
+	copy = !iov_iter_is_aligned(iter, align, align);
+	ret = iov_iter_extract_pages(iter, &pages, bytes, nr_vecs, 0, &offset);
 	if (unlikely(ret < 0))
 		goto free_bvec;
 
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index f1d58e70933f..d8628e7071cb 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -146,8 +146,15 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
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
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index 485d8a43017a..5313811dc1ce 100644
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
+					u32 seed)
 {
 	return -EINVAL;
 }
-- 
2.25.1


