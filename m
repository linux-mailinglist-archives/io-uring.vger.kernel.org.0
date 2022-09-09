Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512645B3798
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 14:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiIIMWe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 08:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiIIMWF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 08:22:05 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A9C85FF6;
        Fri,  9 Sep 2022 05:21:04 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1EAAB56D1B;
        Fri,  9 Sep 2022 12:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1662726061; x=1664540462; bh=gMxdHuGYRwTuopHTFooGl2Pgd
        /f9+WV3Q6zWRfpmhjk=; b=iPGSAm0WP68Mx/juvXY7LWmKwvVqyEoz+SVHRKTNL
        vOeyNu3Ag02gX+qO0mekYw4hd/cyjdg8JH4Td5oTFckUQi6I9i8jjgXEyRo9QzGe
        s/7FsRthC8el1ZwNf1Yu1vdBJtZvtWTbDEvQCZ1ZlpkPN2gbGx7zxthlAc5hw8eU
        cI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id shy5bBdbV5Pn; Fri,  9 Sep 2022 15:21:01 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9698956C77;
        Fri,  9 Sep 2022 15:21:01 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 9 Sep 2022 15:21:01 +0300
Received: from altair.lan (10.199.18.119) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 9 Sep 2022
 15:21:00 +0300
From:   "Alexander V. Buev" <a.buev@yadro.com>
To:     <linux-block@vger.kernel.org>
CC:     <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "Christoph Hellwig" <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, <linux@yadro.com>,
        "Alexander V. Buev" <a.buev@yadro.com>
Subject: [PATCH v4 3/3] block: fops: handle IOCB_USE_PI in direct IO
Date:   Fri, 9 Sep 2022 15:20:40 +0300
Message-ID: <20220909122040.1098696-4-a.buev@yadro.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220909122040.1098696-1-a.buev@yadro.com>
References: <20220909122040.1098696-1-a.buev@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.119]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Check that the size of PI data correspond to device integrity profile
and data size.
Add PI data to device BIO.

Signed-off-by: Alexander V. Buev <a.buev@yadro.com>
---
 block/fops.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index b90742595317..d89fa7d99635 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -16,6 +16,7 @@
 #include <linux/suspend.h>
 #include <linux/fs.h>
 #include <linux/module.h>
+#include <linux/blk-integrity.h>
 #include "blk.h"
 
 static inline struct inode *bdev_file_inode(struct file *file)
@@ -51,6 +52,19 @@ static bool blkdev_dio_unaligned(struct block_device *bdev, loff_t pos,
 
 #define DIO_INLINE_BIO_VECS 4
 
+static int __bio_integrity_add_iovec(struct bio *bio, struct iov_iter *pi_iter)
+{
+	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
+	unsigned int pi_len = bio_integrity_bytes(bi, bio->bi_iter.bi_size >> SECTOR_SHIFT);
+	size_t iter_count = pi_iter->count-pi_len;
+	int ret;
+
+	iov_iter_truncate(pi_iter, pi_len);
+	ret = bio_integrity_add_iovec(bio, pi_iter);
+	iov_iter_reexpand(pi_iter, iter_count);
+	return ret;
+}
+
 static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 		struct iov_iter *iter, unsigned int nr_pages)
 {
@@ -94,6 +108,15 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		bio.bi_opf |= REQ_NOWAIT;
 
+	if (iocb->ki_flags & IOCB_USE_PI) {
+		ret = __bio_integrity_add_iovec(&bio, (struct iov_iter *)iocb->private);
+		WRITE_ONCE(iocb->private, NULL);
+		if (ret) {
+			bio_release_pages(&bio, should_dirty);
+			goto out;
+		}
+	}
+
 	submit_bio_wait(&bio);
 
 	bio_release_pages(&bio, should_dirty);
@@ -178,6 +201,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	blk_opf_t opf = is_read ? REQ_OP_READ : dio_bio_write_op(iocb);
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
+	struct iov_iter *pi_iter = 0;
 
 	if (blkdev_dio_unaligned(bdev, pos, iter))
 		return -EINVAL;
@@ -235,6 +259,19 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		pos += bio->bi_iter.bi_size;
 
 		nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS);
+
+		if (iocb->ki_flags & IOCB_USE_PI) {
+			if (!pi_iter)
+				pi_iter = (struct iov_iter *)iocb->private;
+			ret = __bio_integrity_add_iovec(bio, pi_iter);
+			WRITE_ONCE(iocb->private, NULL);
+			if (unlikely(ret)) {
+				bio->bi_status = BLK_STS_IOERR;
+				bio_endio(bio);
+				break;
+			}
+		}
+
 		if (!nr_pages) {
 			submit_bio(bio);
 			break;
@@ -343,6 +380,16 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		task_io_account_write(bio->bi_iter.bi_size);
 	}
 
+	if (iocb->ki_flags & IOCB_USE_PI) {
+		ret = __bio_integrity_add_iovec(bio, (struct iov_iter *)iocb->private);
+		WRITE_ONCE(iocb->private, NULL);
+		if (ret) {
+			bio->bi_status = BLK_STS_IOERR;
+			bio_endio(bio);
+			return -EIOCBQUEUED;
+		}
+	}
+
 	if (iocb->ki_flags & IOCB_HIPRI) {
 		bio->bi_opf |= REQ_POLLED | REQ_NOWAIT;
 		submit_bio(bio);
@@ -355,6 +402,31 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	return -EIOCBQUEUED;
 }
 
+static inline int
+blkdev_check_pi(struct block_device *bdev, size_t data_size, size_t pi_size)
+{
+	struct blk_integrity *bi = bdev_get_integrity(bdev);
+	unsigned int intervals;
+
+	if (unlikely(!(bi && bi->tuple_size &&
+			bi->flags & BLK_INTEGRITY_DEVICE_CAPABLE))) {
+		pr_err("Device %d:%d is not integrity capable",
+			MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
+		return -EINVAL;
+	}
+
+	intervals = bio_integrity_intervals(bi, data_size >> SECTOR_SHIFT);
+	if (unlikely(intervals * bi->tuple_size > pi_size)) {
+		pr_err("Device %d:%d integrity & data size mismatch",
+			MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
+		pr_err("data=%zu integrity=%zu intervals=%u tuple=%u",
+			data_size, pi_size,
+			intervals, bi->tuple_size);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	unsigned int nr_pages;
@@ -362,6 +434,14 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	if (!iov_iter_count(iter))
 		return 0;
 
+	if (iocb->ki_flags & IOCB_USE_PI) {
+		struct block_device *bdev = iocb->ki_filp->private_data;
+		struct iov_iter *pi_iter = iocb->private;
+
+		if (blkdev_check_pi(bdev, iter->count, pi_iter->count))
+			return -EINVAL;
+	}
+
 	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
 	if (likely(nr_pages <= BIO_MAX_VECS)) {
 		if (is_sync_kiocb(iocb))
-- 
2.30.2

