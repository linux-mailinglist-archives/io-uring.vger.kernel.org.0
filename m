Return-Path: <io-uring+bounces-1200-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87D3F88737E
	for <lists+io-uring@lfdr.de>; Fri, 22 Mar 2024 19:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AADC91C20DE6
	for <lists+io-uring@lfdr.de>; Fri, 22 Mar 2024 18:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A20076C66;
	Fri, 22 Mar 2024 18:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Qbm6XYEM"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7057576913
	for <io-uring@vger.kernel.org>; Fri, 22 Mar 2024 18:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711133865; cv=none; b=sDsMF2TNZ8s9TFfkxhswwkUYA16ZymGu2fl/j0SMarZWQjxGLP2TH+lc6xwbmQmNOQG4zOjZqw2kVe8c5U/PB6Hz1VbZ5R5WR3dIj/cG+e2xnuiboYGOtS4Gwu1m7xR0neos5oTh3gKhiLyVCto9J87fc1pfsNzLtUhfQg1p5oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711133865; c=relaxed/simple;
	bh=JL3MeFU+adshHszYv2h17eowSxBs6lNLRFzE98JHChY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=crm9XAYwcZkGZm65djuM03qB9MVwtXfuFynYqZ6wq+nMx73XsMdSYUj5rvnlO62Die8rtKlCw2xnA3rt0Nruv9YPVffYNyXXv7MJyEIYNresN1GHKz9u16z4SAQUAa0SI7xwSqzFhstzCz+Ba/8FEEw3vlsIBekK+5dFU0wIwqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Qbm6XYEM; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240322185741epoutp029839b89c094ff2345850b4b4c069e69c~-Ky5g7zkU0890208902epoutp02S
	for <io-uring@vger.kernel.org>; Fri, 22 Mar 2024 18:57:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240322185741epoutp029839b89c094ff2345850b4b4c069e69c~-Ky5g7zkU0890208902epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1711133861;
	bh=wHvTeaDpfgYiveEbszV3ymTJuM8INq7WUKPuWJ7ZLwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qbm6XYEMsBWRcGaFxrlL1agt/tcjmvo/bI+EKQayIYwaFumZ9+5sVxSqC+zZamLbs
	 L+6ryO+yVh5SjF/2YAuom0USUeulvqkrPbPhqEJ7BM3r0ATXjNHEjewkYl2ou5FY3T
	 d416RERpgdpWY0bOCYXgyWLN207o+f8JoPLiH1x8=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240322185740epcas5p49c00b147191d2a8b43b191974276efe5~-Ky42eVVJ2613626136epcas5p45;
	Fri, 22 Mar 2024 18:57:40 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4V1WmM1fkpz4x9Pp; Fri, 22 Mar
	2024 18:57:39 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	19.F6.19431.3A4DDF56; Sat, 23 Mar 2024 03:57:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240322185738epcas5p20e5bd448ce83350eb9e79c929c4a9b2b~-Ky2zk4od0284402844epcas5p2I;
	Fri, 22 Mar 2024 18:57:38 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240322185738epsmtrp28b4f072d32029456cca4c811de06c728~-Ky2yuB8G0597405974epsmtrp28;
	Fri, 22 Mar 2024 18:57:38 +0000 (GMT)
X-AuditID: b6c32a50-f57ff70000004be7-15-65fdd4a36e93
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	59.B3.19234.2A4DDF56; Sat, 23 Mar 2024 03:57:38 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240322185736epsmtip139deaba879c59af89b84af8413656577~-Ky0-Feiv1992619926epsmtip1g;
	Fri, 22 Mar 2024 18:57:36 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: martin.petersen@oracle.com, axboe@kernel.dk, kbusch@kernel.org,
	hch@lst.de
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	anuj1072538@gmail.com, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [RFC PATCH 4/4] block: add support to pass the meta buffer
Date: Sat, 23 Mar 2024 00:20:23 +0530
Message-Id: <20240322185023.131697-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240322185023.131697-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGJsWRmVeSWpSXmKPExsWy7bCmlu7iK39TDd694rT4+PU3i0XThL/M
	Fqvv9rNZrFx9lMniXes5Fouj/9+yWUw6dI3RYu8tbYvlx/8xOXB67Jx1l93j8tlSj02rOtk8
	dt9sYPP4+PQWi0ffllWMHp83yQWwR2XbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
	mCsp5CXmptoqufgE6Lpl5gAdpqRQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkpMCnQ
	K07MLS7NS9fLSy2xMjQwMDIFKkzIztgwr5mlYIFsxaMjF5gaGN+JdzFyckgImEgcfTqXtYuR
	i0NIYA+jxOH5x9ghnE+MEgsfPGaEc06tPMYM09KzdQcLRGIno8TDmyehqj4zSvxb8oSti5GD
	g01AU+LC5FKQBhGBAImnv8+xgdQwC8xhlNi5rZcdpEZYwFli6st6kBoWAVWJJU0vWEFsXgFL
	iV1dy5kglslLzLz0nR3E5hSwkrh+9ScLRI2gxMmZT8BsZqCa5q2zmUHmSwj8ZZeYfugiG0Sz
	i0RLy0soW1ji1fEt7BC2lMTnd3uh4skSl2aeg1pWIvF4z0Eo216i9VQ/M8idzEC/rN+lD7GL
	T6L39xMmkLCEAK9ER5sQRLWixL1JT1khbHGJhzOWQNkeEqdWN7FBgqeXUWLSwpnMExjlZyF5
	YRaSF2YhbFvAyLyKUSq1oDg3PTXZtMBQNy+1HB6zyfm5mxjBCVQrYAfj6g1/9Q4xMnEwHmKU
	4GBWEuHd8f9PqhBvSmJlVWpRfnxRaU5q8SFGU2AgT2SWEk3OB6bwvJJ4QxNLAxMzMzMTS2Mz
	QyVx3tetc1OEBNITS1KzU1MLUotg+pg4OKUamNa+Cvi3s+Zn5yPJ+Id/Dtpe+dgr0RbLF/gm
	/9Dx1E19XJm7e60/P7H74D/PjfmFqO/UBRNDe35w7prru8d9Y/LTrWzPsztXHXQz27/jwxVL
	q2kRuRfv2bro7+tyk7s0v/C92Kxnd3Q07xu2tl7f9KK5dBXLFanT1c/LrXcF3Ym+YJE4yUfv
	/WyF2VP9LRfk7Zvcubj8vlZ5uJ1k9cf7nqcWMG7NK68Rm9xu81c/Wecjx2KvVyvVXPo57Tq3
	9mjLXd9snP7yQZ3Q4f3c3/Zu/S+xruPVjBVm/F5rc5ZECE7clH7eetGsh1w/4g/NNWZ+NW/X
	G6ap2bOEn/6Yv22THke64D42gZ4ka7WvP9pS531VYinOSDTUYi4qTgQAXsmCEykEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWy7bCSnO6iK39TDc6vVLP4+PU3i0XThL/M
	Fqvv9rNZrFx9lMniXes5Fouj/9+yWUw6dI3RYu8tbYvlx/8xOXB67Jx1l93j8tlSj02rOtk8
	dt9sYPP4+PQWi0ffllWMHp83yQWwR3HZpKTmZJalFunbJXBlbJjXzFKwQLbi0ZELTA2M78S7
	GDk5JARMJHq27mDpYuTiEBLYzijxenkjC0RCXKL52g92CFtYYuW/5+wQRR8ZJZZN/M7UxcjB
	wSagKXFhcilIjYhAiMSy1gnMIDazwAJGiYUnrEFKhAWcJaa+rAcJswioSixpesEKYvMKWErs
	6lrOBDFeXmLmpe9gqzgFrCSuX/0JdoIQUM3056uh6gUlTs58wgIxXl6ieets5gmMArOQpGYh
	SS1gZFrFKJpaUJybnptcYKhXnJhbXJqXrpecn7uJERzuWkE7GJet/6t3iJGJg/EQowQHs5II
	747/f1KFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8yrndKYICaQnlqRmp6YWpBbBZJk4OKUamLoD
	3Kx2NfOXt+9webM2a+7Fm+u/FW8+GZh2uuHfb9O1U1Onn5LYddEpuJvBvuYl13p1Kx+Jkudz
	+579cdBIV5KeuHFVZGBVzvYFB9usWvN5D/ZKM4q23G4Iz3lW8G+TnmBBjpemQ/r8T9n5vxif
	ft66U5xT6+6Lj3c/7CuPLYqa9OWqTHW+3JXQ5eWRX1l8eOL03xV1SLWsUuFqM57T96Gpwon5
	tdzEV3z3hA+cXf7aWTIjQaHjyvYyoQ38PqZlcbKX/3Iq3zRLM1p3aHXciuASdj6zvBXbeoNe
	9CpJRcXLqz2ceXeBVI7lXqV/Fmc4jC24uGzndDXtji5KEz+fM+XZBz4WH8bW458f2x5WYinO
	SDTUYi4qTgQAthAiUeYCAAA=
X-CMS-MailID: 20240322185738epcas5p20e5bd448ce83350eb9e79c929c4a9b2b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240322185738epcas5p20e5bd448ce83350eb9e79c929c4a9b2b
References: <20240322185023.131697-1-joshi.k@samsung.com>
	<CGME20240322185738epcas5p20e5bd448ce83350eb9e79c929c4a9b2b@epcas5p2.samsung.com>

If IOCB_USE_META flag is set, iocb->private points to iov_iter
corresponding to the meta-buffer.
Use it to prepare the bip and attach that to the bio that we send down.

Make sure that block-integrity checks are skipped for this user-owned
meta buffer.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c | 13 +++++++++++++
 block/fops.c          |  9 +++++++++
 block/t10-pi.c        |  6 ++++++
 include/linux/bio.h   |  6 ++++++
 4 files changed, 34 insertions(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index e340b5a03cdf..c46b70aff840 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -308,6 +308,19 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
 	return nr_bvecs;
 }
 
+int bio_integrity_map_iter(struct bio *bio, struct iov_iter *iter)
+{
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
+
+	if (!bi)
+		return -EINVAL;
+
+	if (iter->count < bio_integrity_bytes(bi, bio_sectors(bio)))
+		return -EINVAL;
+
+	return bio_integrity_map_user(bio, iter, 0);
+}
+
 int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter,
 			  u32 seed)
 {
diff --git a/block/fops.c b/block/fops.c
index 679d9b752fe8..e488fa66dd60 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -353,6 +353,15 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		task_io_account_write(bio->bi_iter.bi_size);
 	}
 
+	if (unlikely(iocb->ki_flags & IOCB_USE_META)) {
+		ret = bio_integrity_map_iter(bio, iocb->private);
+		WRITE_ONCE(iocb->private, NULL);
+		if (unlikely(ret)) {
+			bio_put(bio);
+			return ret;
+		}
+	}
+
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		bio->bi_opf |= REQ_NOWAIT;
 
diff --git a/block/t10-pi.c b/block/t10-pi.c
index d90892fd6f2a..72d1522417a1 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -156,6 +156,8 @@ static void t10_pi_type1_prepare(struct request *rq)
 		/* Already remapped? */
 		if (bip->bip_flags & BIP_MAPPED_INTEGRITY)
 			break;
+		if (bip->bip_flags & BIP_INTEGRITY_USER)
+			break;
 
 		bip_for_each_vec(iv, bip, iter) {
 			unsigned int j;
@@ -205,6 +207,8 @@ static void t10_pi_type1_complete(struct request *rq, unsigned int nr_bytes)
 		struct bio_vec iv;
 		struct bvec_iter iter;
 
+		if (bip->bip_flags & BIP_INTEGRITY_USER)
+			break;
 		bip_for_each_vec(iv, bip, iter) {
 			unsigned int j;
 			void *p;
@@ -408,6 +412,8 @@ static void ext_pi_type1_prepare(struct request *rq)
 		/* Already remapped? */
 		if (bip->bip_flags & BIP_MAPPED_INTEGRITY)
 			break;
+		if (bip->bip_flags & BIP_INTEGRITY_USER)
+			break;
 
 		bip_for_each_vec(iv, bip, iter) {
 			unsigned int j;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 20cf47fc851f..34ea387dfc59 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -723,6 +723,7 @@ static inline bool bioset_initialized(struct bio_set *bs)
 	for_each_bio(_bio)						\
 		bip_for_each_vec(_bvl, _bio->bi_integrity, _iter)
 
+int bio_integrity_map_iter(struct bio *bio, struct iov_iter *iter);
 int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter, u32 seed);
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
@@ -802,6 +803,11 @@ static inline int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter,
 	return -EINVAL;
 }
 
+static inline int bio_integrity_map_iter(struct bio *bio, struct iov_iter *iter)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
 /*
-- 
2.25.1


