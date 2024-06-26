Return-Path: <io-uring+bounces-2352-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2549918006
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 13:43:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01BD41C239A7
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 11:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5786517FAB4;
	Wed, 26 Jun 2024 11:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TWQdpJWS"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0C817FAA9
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719402185; cv=none; b=hf4T5uLhPU8F0nLWMe7eCDADRguR3FORAoDD9YSVNlValGYWwYAyzFcdAfAg7y/ZWt7eIFjWbStj7d29PwN+jlurj41OHj/r1L9TQGZcnZo6o3h9wEo283L3v/AV1ivMIkj6DCRs3V+QU7FLOtCvoF8iJloWVP9Bj4N8rShbzU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719402185; c=relaxed/simple;
	bh=5jIjcP8xRXDjWvr2WGjD3BoRgUVdc77PFesx1qBBvyI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=XkilnDKjwmtXSE3290o3JqH4vSqoKNfw1TxoeFNU22LdgMQunUUGxG9cANQnQz2cOcggV7I0X9/oMvJmp0RYNb4ux12BUeT1NNzorTnnPdGFXX3MgLA5RgOfX1TySOQsR6NsZ6dlbpWwXGJtoPifgQgKsjwzEg/G/lNESQHk2hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=TWQdpJWS; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240626114300epoutp0258629d0601d98268de61ee7e83b2ec8f~ciyxal1ot0308303083epoutp02D
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:43:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240626114300epoutp0258629d0601d98268de61ee7e83b2ec8f~ciyxal1ot0308303083epoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719402180;
	bh=Ms96jkmQ0kuaCcPQfmnfod94T8OohipgnI02PQvTjo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWQdpJWSVXt6fwQA668mibYDtcPydd+2U1afNb6JaAAtiQ6PAgYRl7GzYoOEq7EVN
	 jy6Q8RFKI4aDUCDClVHhnYMlXFzDtLMW2jjyLNcEDvIIRsIgD3w+ecY1W0oJ4OCpnP
	 fGR6rcqssCgZIvHfRWfzsLnQcNpRtQe96NAVWWLU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240626114259epcas5p1b6818f7576e9665da59304f5e9b015e4~ciyw6V50m1003510035epcas5p1q;
	Wed, 26 Jun 2024 11:42:59 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4W8KZV1NqTz4x9Pq; Wed, 26 Jun
	2024 11:42:58 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	36.48.09989.2CEFB766; Wed, 26 Jun 2024 20:42:58 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240626101527epcas5p23e10a6701f552d16bd6a999418009ba0~chmVION0E2207822078epcas5p2-;
	Wed, 26 Jun 2024 10:15:27 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240626101527epsmtrp19e14a3ce1656ea45bee13c5af862a824~chmVGgijU1052710527epsmtrp1H;
	Wed, 26 Jun 2024 10:15:27 +0000 (GMT)
X-AuditID: b6c32a4a-e57f970000002705-a4-667bfec2bc8f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5B.6A.19057.F3AEB766; Wed, 26 Jun 2024 19:15:27 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240626101525epsmtip1585e16aa5c4eb50dd6c82ce8c3bc9c15~chmTc1YNM0324303243epsmtip16;
	Wed, 26 Jun 2024 10:15:25 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v2 09/10] block: add support to pass user meta buffer
Date: Wed, 26 Jun 2024 15:36:59 +0530
Message-Id: <20240626100700.3629-10-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240626100700.3629-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMJsWRmVeSWpSXmKPExsWy7bCmpu6hf9VpBoc/sVg0TfjLbDFn1TZG
	i9V3+9ksVq4+ymTxrvUci8XR/2/ZLCYdusZosfeWtsX8ZU/ZLZYf/8dkMbHjKpMDt8fOWXfZ
	PS6fLfXYtKqTzWPzknqP3Tcb2Dw+Pr3F4vF+31U2j74tqxg9Pm+SC+CMyrbJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpVSaEsMacUKBSQWFyspG9n
	U5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdsfFNSEGHRcW2N3uY
	Ghi36HYxcnJICJhILL25h7mLkYtDSGA3o8SbOZ+YQBJCAp8YJW7+04JIfGOUmNv7nQWm4+m7
	1SwQib2MElvfzWOCcD4zSnx+fJ8NpIpNQF3iyPNWRhBbRKBWYmXrdHaQImaBpYwSB3atB0sI
	C7hKLLm6iB3EZhFQlXg3/yXQIRwcvAKWEnPuOUBsk5eYeek7WAknUPjO5u1grbwCghInZz4B
	u4gZqKZ562ywHyQE5nJIzFt4hwVkjoSAi8TNUwEQc4QlXh3fwg5hS0m87G+DstMlflx+ygRh
	F0g0H9vHCGHbS7Se6gc7h1lAU2L9Ln2IsKzE1FPrmCDW8kn0/n4C1corsWMejK0k0b5yDpQt
	IbH3XAOU7SGxc+YpVkhY9TBK7OxdyTqBUWEWkndmIXlnFsLqBYzMqxglUwuKc9NTi00LjPJS
	y+FxnJyfu4kRnHq1vHYwPnzwQe8QIxMH4yFGCQ5mJRHe0JKqNCHelMTKqtSi/Pii0pzU4kOM
	psDgnsgsJZqcD0z+eSXxhiaWBiZmZmYmlsZmhkrivK9b56YICaQnlqRmp6YWpBbB9DFxcEo1
	MHk29GfXT59gG7df0KAxYW92ObOA7radX2651iaeqdK5fOdAzldh+eYvleXbj99o974a9ffy
	qn8R0s9XX4rLXiK9odDeK2PiFokJF252+y7iW9D1L8laP9N39Qoz+VvXPQ70iBlOaDPhs5S6
	ut3z3r+cn0nl4asXZdxYLLySN6456+Peu/8qQjinRRQvn6armF7/c9fzetUdzxYwXz30Qrd5
	xrxHdRmuq9e0toW9W+fdf/+UwrnO1o3snU/0W9yE5/83WX6jxUbpUSPP/TMNYa0GH+fteZhS
	HMaqO6/2vOPds7Xf+mW19KRVGbh2PrKdNH3mxulNuyWkooIa4hXUdVzNXA+wX+sSv+t34FTq
	HSWW4oxEQy3mouJEADwhZYNGBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWy7bCSnK79q+o0g97jnBZNE/4yW8xZtY3R
	YvXdfjaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2i+XH/zFZTOy4yuTA7bFz1l12
	j8tnSz02repk89i8pN5j980GNo+PT2+xeLzfd5XNo2/LKkaPz5vkAjijuGxSUnMyy1KL9O0S
	uDI2vgkp6LCo2PZmD1MD4xbdLkZODgkBE4mn71azgNhCArsZJU7PMoWIS0icermMEcIWllj5
	7zk7RM1HRomDv2tAbDYBdYkjz1uBarg4RARaGSUOTG0Bc5gFVgI5HefBOoQFXCWWXF0EZrMI
	qEq8m/+SuYuRg4NXwFJizj0HiAXyEjMvfQcr4QQK39m8nRFimYXEg+fNrCA2r4CgxMmZT8AO
	ZQaqb946m3kCo8AsJKlZSFILGJlWMUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIER4eW
	1g7GPas+6B1iZOJgPMQowcGsJMIbWlKVJsSbklhZlVqUH19UmpNafIhRmoNFSZz32+veFCGB
	9MSS1OzU1ILUIpgsEwenVAPTlPyVX7+fPbac321yaWjX/Rtvzs+KvPN5dpvHd1EWWdlvs8pD
	RD1yXE6p2v58oB7g5jPzxQpV9/ccU8pmNyzY27bR4qnZvqIXa7sWPNc0W8M624Nh8o9tal+3
	yZycJMVyYZFXohNfDdvHHwyXt4mc2D2vui1YRf5Lc/PPN5sctjX+XbVMQ6GNaekhteMbvlr1
	2B36Fhmm7540+cML153rZ8ncyGdKMXFqMGE9s/qffcXpjV9ZlFqduaUj/llc9wrLa7w9Y4fv
	t+zr0gccXzBn5U999VJpsuocjpOn8948d18qr/Mq7WLvquMHLmzfe0bgYnfbavf/X1sWJXSZ
	XL/ziWvjpIb9NsYpEV/nHvPZLaXEUpyRaKjFXFScCACHBxPA/QIAAA==
X-CMS-MailID: 20240626101527epcas5p23e10a6701f552d16bd6a999418009ba0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240626101527epcas5p23e10a6701f552d16bd6a999418009ba0
References: <20240626100700.3629-1-anuj20.g@samsung.com>
	<CGME20240626101527epcas5p23e10a6701f552d16bd6a999418009ba0@epcas5p2.samsung.com>

From: Kanchan Joshi <joshi.k@samsung.com>

If iocb contains the meta, extract that and prepare the bip.
Extend bip so that can it can carry three new integrity-check flags
and application tag.

Make sure that ->prepare_fn and ->complete_fn are skipped for
user-owned meta buffer.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c | 44 +++++++++++++++++++++++++++++++++++++++++++
 block/fops.c          | 28 ++++++++++++++++++++++++++-
 block/t10-pi.c        |  6 ++++++
 include/linux/bio.h   | 10 ++++++++++
 4 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 38418be07139..599f39999174 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -12,6 +12,7 @@
 #include <linux/bio.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
+#include <uapi/linux/io_uring.h>
 #include "blk.h"
 
 static struct kmem_cache *bip_slab;
@@ -337,6 +338,49 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
 	return nr_bvecs;
 }
 
+static void bio_uio_meta_to_bip(struct bio *bio, struct uio_meta *meta)
+{
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+	u16 bip_flags = 0;
+
+	if (meta->flags & INTEGRITY_CHK_GUARD)
+		bip_flags |= BIP_USER_CHK_GUARD;
+	if (meta->flags & INTEGRITY_CHK_APPTAG)
+		bip_flags |= BIP_USER_CHK_APPTAG;
+	if (meta->flags & INTEGRITY_CHK_REFTAG)
+		bip_flags |= BIP_USER_CHK_REFTAG;
+
+	bip->bip_flags |= bip_flags;
+	bip->apptag = meta->apptag;
+}
+
+int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta)
+{
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
+	unsigned int integrity_bytes;
+	int ret;
+	struct iov_iter it;
+
+	if (!bi)
+		return -EINVAL;
+	/*
+	 * original meta iterator can be bigger.
+	 * process integrity info corresponding to current data buffer only.
+	 */
+	it = meta->iter;
+	integrity_bytes = bio_integrity_bytes(bi, bio_sectors(bio));
+	if (it.count < integrity_bytes)
+		return -EINVAL;
+
+	it.count = integrity_bytes;
+	ret = bio_integrity_map_user(bio, &it, 0);
+	if (!ret) {
+		bio_uio_meta_to_bip(bio, meta);
+		iov_iter_advance(&meta->iter, integrity_bytes);
+	}
+	return ret;
+}
+
 int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter,
 			   u32 seed)
 {
diff --git a/block/fops.c b/block/fops.c
index be36c9fbd500..6477424b4ebc 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -126,12 +126,13 @@ static void blkdev_bio_end_io(struct bio *bio)
 {
 	struct blkdev_dio *dio = bio->bi_private;
 	bool should_dirty = dio->flags & DIO_SHOULD_DIRTY;
+	bool is_async = !(dio->flags & DIO_IS_SYNC);
 
 	if (bio->bi_status && !dio->bio.bi_status)
 		dio->bio.bi_status = bio->bi_status;
 
 	if (atomic_dec_and_test(&dio->ref)) {
-		if (!(dio->flags & DIO_IS_SYNC)) {
+		if (is_async) {
 			struct kiocb *iocb = dio->iocb;
 			ssize_t ret;
 
@@ -154,6 +155,9 @@ static void blkdev_bio_end_io(struct bio *bio)
 		}
 	}
 
+	if (is_async && (dio->iocb->ki_flags & IOCB_HAS_META))
+		bio_integrity_unmap_free_user(bio);
+
 	if (should_dirty) {
 		bio_check_pages_dirty(bio);
 	} else {
@@ -231,6 +235,16 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 			}
 			bio->bi_opf |= REQ_NOWAIT;
 		}
+		if (!is_sync && unlikely(iocb->ki_flags & IOCB_HAS_META)) {
+			ret = bio_integrity_map_iter(bio, iocb->private);
+			if (unlikely(ret)) {
+				bio_release_pages(bio, false);
+				bio_clear_flag(bio, BIO_REFFED);
+				bio_put(bio);
+				blk_finish_plug(&plug);
+				return ret;
+			}
+		}
 
 		if (is_read) {
 			if (dio->flags & DIO_SHOULD_DIRTY)
@@ -288,6 +302,9 @@ static void blkdev_bio_end_io_async(struct bio *bio)
 		ret = blk_status_to_errno(bio->bi_status);
 	}
 
+	if (unlikely(iocb->ki_flags & IOCB_HAS_META))
+		bio_integrity_unmap_free_user(bio);
+
 	iocb->ki_complete(iocb, ret);
 
 	if (dio->flags & DIO_SHOULD_DIRTY) {
@@ -348,6 +365,15 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		task_io_account_write(bio->bi_iter.bi_size);
 	}
 
+	if (unlikely(iocb->ki_flags & IOCB_HAS_META)) {
+		ret = bio_integrity_map_iter(bio, iocb->private);
+		WRITE_ONCE(iocb->private, NULL);
+		if (unlikely(ret)) {
+			bio_put(bio);
+			return ret;
+		}
+	}
+
 	if (iocb->ki_flags & IOCB_ATOMIC)
 		bio->bi_opf |= REQ_ATOMIC;
 
diff --git a/block/t10-pi.c b/block/t10-pi.c
index cd7fa60d63ff..38c3da245b11 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -131,6 +131,8 @@ static void t10_pi_type1_prepare(struct request *rq)
 		/* Already remapped? */
 		if (bip->bip_flags & BIP_MAPPED_INTEGRITY)
 			break;
+		if (bip->bip_flags & BIP_INTEGRITY_USER)
+			break;
 
 		bip_for_each_vec(iv, bip, iter) {
 			unsigned int j;
@@ -180,6 +182,8 @@ static void t10_pi_type1_complete(struct request *rq, unsigned int nr_bytes)
 		struct bio_vec iv;
 		struct bvec_iter iter;
 
+		if (bip->bip_flags & BIP_INTEGRITY_USER)
+			break;
 		bip_for_each_vec(iv, bip, iter) {
 			unsigned int j;
 			void *p;
@@ -305,6 +309,8 @@ static void ext_pi_type1_prepare(struct request *rq)
 		/* Already remapped? */
 		if (bip->bip_flags & BIP_MAPPED_INTEGRITY)
 			break;
+		if (bip->bip_flags & BIP_INTEGRITY_USER)
+			break;
 
 		bip_for_each_vec(iv, bip, iter) {
 			unsigned int j;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 966e22a04996..ff22b627906d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -330,6 +330,9 @@ enum bip_flags {
 	BIP_INTEGRITY_USER	= 1 << 5, /* Integrity payload is user address */
 	BIP_COPY_USER		= 1 << 6, /* Kernel bounce buffer in use */
 	BIP_CLONED		= 1 << 7, /* Indicates that bip is cloned */
+	BIP_USER_CHK_GUARD	= 1 << 8,
+	BIP_USER_CHK_APPTAG	= 1 << 9,
+	BIP_USER_CHK_REFTAG	= 1 << 10,
 };
 
 struct uio_meta {
@@ -349,6 +352,7 @@ struct bio_integrity_payload {
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
 	unsigned short		bip_max_vcnt;	/* integrity bio_vec slots */
 	unsigned short		bip_flags;	/* control flags */
+	u16			apptag;		/* apptag */
 
 	struct bvec_iter	bio_iter;	/* for rewinding parent bio */
 
@@ -738,6 +742,7 @@ static inline bool bioset_initialized(struct bio_set *bs)
 		bip_for_each_vec(_bvl, _bio->bi_integrity, _iter)
 
 int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter, u32 seed);
+int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta);
 void bio_integrity_unmap_free_user(struct bio *bio);
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
@@ -817,6 +822,11 @@ static inline int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter,
 	return -EINVAL;
 }
 
+static inline int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta)
+{
+	return -EINVAL;
+}
+
 static inline void bio_integrity_unmap_free_user(struct bio *bio)
 {
 }
-- 
2.25.1


