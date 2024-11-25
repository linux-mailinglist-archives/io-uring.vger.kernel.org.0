Return-Path: <io-uring+bounces-5029-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10FAE9D7C6E
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 09:08:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C66462820B1
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 08:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3958618A959;
	Mon, 25 Nov 2024 08:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pHoaV3Pg"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3930C189BAC
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732522069; cv=none; b=BUD4Y0bTWTVluZNmt0h3fVfCcy16LZMGhlfvMXAj2fNBlNa3dMxmHQdWRDTLpsHTR/sdMYjXYlSv7wTIpd6bPzAsD7sMSSqz5JLYYzH7sfchVNz+PxoacBUdUa/rwD1apU3BRawkxT8L+iYxkF+39XOgKGaL1wHIrL/k4pKA8JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732522069; c=relaxed/simple;
	bh=g2fp64Elfp9R80cl3zu6i89Ehrxw1OCNHe/eXuK93qM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=dL1MYF9PhUeB9AdD3Z1tc4r1RZE+YEYhVyQE677qDbWUyPNsdESScOJi8wnlUDVXeyli0I9aY9EcajbEIvfPqqIpesvSR2T9CppTvws3Nc8Mm7jpxtLeXCBymsFF7vgYTrAsPoOmm/BvZBBY9QDm6um4vOXJX1J1kE2RAVOKqTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pHoaV3Pg; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241125080745epoutp01992e7d7a6a715d97535429eae3e1e520~LJ6OYMUzb0921709217epoutp01Y
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:07:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241125080745epoutp01992e7d7a6a715d97535429eae3e1e520~LJ6OYMUzb0921709217epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732522065;
	bh=FQM1oME+yjLcszh/NNdlGeevLgEVh+e4WfItNIpaOVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pHoaV3PgaywxXbtOMUqSSZ0pGIdYAoyWZI4/eN5w3TJq6NRoPtljYrV6zoPpIzuAS
	 V/h+/8ecPfFYYfvcDJQI7aBY9+sE3KEUD2UmP2m/lK0dhvMgb0zWgj55rPAp4kUSDb
	 pZ9AjZLb10sn9E2SWiOBptwrRWGZXNDqXYiycMOw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241125080744epcas5p1e5c279f254c7b11203f99bd831ef6e13~LJ6NyW-R60753007530epcas5p1c;
	Mon, 25 Nov 2024 08:07:44 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Xxdby6n4qz4x9QD; Mon, 25 Nov
	2024 08:07:42 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	31.9F.20052.C4034476; Mon, 25 Nov 2024 17:07:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241125071451epcas5p2e50329d88842569e5a2a07b918406d28~LJMCttwXl1898818988epcas5p2y;
	Mon, 25 Nov 2024 07:14:51 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241125071451epsmtrp1aba047449d1481e7d1338a2e2d227525~LJMCsyB3q0302403024epsmtrp1m;
	Mon, 25 Nov 2024 07:14:51 +0000 (GMT)
X-AuditID: b6c32a49-3d20270000004e54-7d-6744304c1831
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4D.F7.35203.BE324476; Mon, 25 Nov 2024 16:14:51 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241125071449epsmtip16e62cc014438b6259563f1686ec18e7c~LJMAXyNEe0365203652epsmtip1N;
	Mon, 25 Nov 2024 07:14:48 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v10 02/10] block: copy back bounce buffer to user-space
 correctly in case of split
Date: Mon, 25 Nov 2024 12:36:25 +0530
Message-Id: <20241125070633.8042-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241125070633.8042-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJJsWRmVeSWpSXmKPExsWy7bCmuq6PgUu6wfsd2hYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsbn2U1MBav5KlY1TGNrYJzE08XIySEhYCLR0NzB
	1sXIxSEksJtRYuPMaewQzidGid7WDYwgVUIC3xgldh4whenY2v0Cqmgvo8TB1nNMEM5nRolJ
	Cx8zg1SxCahLHHneygiSEBHYAzRq4WkWEIdZ4CWjxNJVi1hAqoQFUiR+7wSZxcnBIqAq8Xjt
	MVYQm1fAQuL8nF8sEPvkJWZe+g5WwylgKfG27QALRI2gxMmZT8BsZqCa5q2zmSHqz3BI/FjL
	CGG7SCzq+8kEYQtLvDq+hR3ClpJ42d8GZadL/Lj8FKqmQKL52D6oXnuJ1lP9QDM5gOZrSqzf
	pQ8RlpWYemodE8RaPone30+gWnkldsyDsZUk2lfOgbIlJPaea4CyPSTedL1mhYRWD6PEqePn
	2CcwKsxC8s4sJO/MQli9gJF5FaNkakFxbnpqsWmBYV5qOTyak/NzNzGC07iW5w7Guw8+6B1i
	ZOJgPMQowcGsJMLLJ+6cLsSbklhZlVqUH19UmpNafIjRFBjeE5mlRJPzgZkkryTe0MTSwMTM
	zMzE0tjMUEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGpr7nts0sJ28fOPT5wReVRfKxyxeV
	1bcYTL91JNTGqWlT1baszRGXn8p4F7DXnQtv5is4pCFq+krK5dOW92fCbmvH7lNcM/2r+VJO
	3ZzcC3ERJqleUTIzgrujnu+5fst33tP0tdzLFTl3FEpGazUruBxSl7roONFKZ1Y076dJtQyn
	Df69Ftb+a/WhfdX0LwufvXFYw23z4m3AmwkX+TLDVZ6faVM2+P5V+pd48VS5SRxRrWV2+5zs
	dNe//f252VljSroxc4vfgVWL69xMJbKZFJWLU6bWuKy58sv8tfjjMre2Z4oBc1i+3Re5lfgl
	z/PZSdFpO10eJM671RRw+9yp4ndmYjv7444Exjerej1dqsRSnJFoqMVcVJwIABUWbthsBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSnO5rZZd0g6ur5Cw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAVxSXTUpqTmZZapG+XQJXxufZTUwFq/kqVjVMY2tg
	nMTTxcjJISFgIrG1+wV7FyMXh5DAbkaJX9c+M0EkJCROvVzGCGELS6z89xyq6COjxPQP51hB
	EmwC6hJHnreCFYkInGCUmD/RDaSIGaRowpfZLCAJYYEkiSnbPoMVsQioSjxeewysmVfAQuL8
	nF8sEBvkJWZe+s4OYnMKWEq8bTsAFhcCqpnVuRKqXlDi5MwnYHFmoPrmrbOZJzAKzEKSmoUk
	tYCRaRWjZGpBcW56brFhgWFearlecWJucWleul5yfu4mRnCkaWnuYNy+6oPeIUYmDsZDjBIc
	zEoivHzizulCvCmJlVWpRfnxRaU5qcWHGKU5WJTEecVf9KYICaQnlqRmp6YWpBbBZJk4OKUa
	mIr8TW+WyaqEfp7GxhGzps96svU5xrMSlyb7dcWsvpN2xNlu0byfybevftkTlOMsNyM8+0uI
	8CWTlY+UzwhmnD2uHHF1Wkirw+FFT47c2Rj98fNJZUO+HVezLs3cWDPJUPPPtrWSr6bzW9dk
	z7ym2Vk6If6079XvK/9Xflxtqc7Y8kw6uFPBS3zNZSnNT82hSbyH63R11x7fM4dX6k2aeXbr
	cofUBp0tHAe9nCx3+JvmZr3rKDh0dsafBUeW8u/0kVv7tDmHnfnSq44f7SmSf0+GdP9szo86
	8z70aansLWaBH75HNzjdCXaqrs9oTXjTP/FLVqxzVGZKoUjQls2bA0S6Cvi9kxuKvsrNuV3z
	VomlOCPRUIu5qDgRAPuIJN0jAwAA
X-CMS-MailID: 20241125071451epcas5p2e50329d88842569e5a2a07b918406d28
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241125071451epcas5p2e50329d88842569e5a2a07b918406d28
References: <20241125070633.8042-1-anuj20.g@samsung.com>
	<CGME20241125071451epcas5p2e50329d88842569e5a2a07b918406d28@epcas5p2.samsung.com>

From: Christoph Hellwig <hch@lst.de>

Copy back the bounce buffer to user-space in entirety when the parent
bio completes. The existing code uses bip_iter.bi_size for sizing the
copy, which can be modified. So move away from that and fetch it from
the vector passed to the block layer. While at it, switch to using
better variable names.

Fixes: 492c5d455969f ("block: bio-integrity: directly map user buffers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index a448a25d13de..4341b0d4efa1 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -118,17 +118,18 @@ static void bio_integrity_unpin_bvec(struct bio_vec *bv, int nr_vecs,
 
 static void bio_integrity_uncopy_user(struct bio_integrity_payload *bip)
 {
-	unsigned short nr_vecs = bip->bip_max_vcnt - 1;
-	struct bio_vec *copy = &bip->bip_vec[1];
-	size_t bytes = bip->bip_iter.bi_size;
-	struct iov_iter iter;
+	unsigned short orig_nr_vecs = bip->bip_max_vcnt - 1;
+	struct bio_vec *orig_bvecs = &bip->bip_vec[1];
+	struct bio_vec *bounce_bvec = &bip->bip_vec[0];
+	size_t bytes = bounce_bvec->bv_len;
+	struct iov_iter orig_iter;
 	int ret;
 
-	iov_iter_bvec(&iter, ITER_DEST, copy, nr_vecs, bytes);
-	ret = copy_to_iter(bvec_virt(bip->bip_vec), bytes, &iter);
+	iov_iter_bvec(&orig_iter, ITER_DEST, orig_bvecs, orig_nr_vecs, bytes);
+	ret = copy_to_iter(bvec_virt(bounce_bvec), bytes, &orig_iter);
 	WARN_ON_ONCE(ret != bytes);
 
-	bio_integrity_unpin_bvec(copy, nr_vecs, true);
+	bio_integrity_unpin_bvec(orig_bvecs, orig_nr_vecs, true);
 }
 
 /**
-- 
2.25.1


