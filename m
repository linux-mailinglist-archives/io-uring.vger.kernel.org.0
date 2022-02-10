Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431044B0E42
	for <lists+io-uring@lfdr.de>; Thu, 10 Feb 2022 14:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242065AbiBJNR7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Feb 2022 08:17:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242072AbiBJNR5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Feb 2022 08:17:57 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0FF22F;
        Thu, 10 Feb 2022 05:17:56 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 245DF47827;
        Thu, 10 Feb 2022 13:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1644498551; x=1646312952; bh=yiWgb8zfUEyXzRBjxEPMjRX13PSIX80va5z
        tpeaSm9E=; b=MRpwAx43q7O3OJv7dIuLBiVqw46iYqp4QAm5Um39Nq+BerVQRUv
        JHBulRcdgLkISBknV5qKTHqQPy6Q19dVXU/VpRpcAI+3z35ubNpEfsgYNZ6pQijn
        9y3dTSGY0aUddYW7HrX8u9RkZ/Lez/kS0fyxywJwkV2p8/EDhWUqN3Vc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6BzW_HNHStRw; Thu, 10 Feb 2022 16:09:11 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id D96CC41846;
        Thu, 10 Feb 2022 16:09:11 +0300 (MSK)
Received: from localhost.localdomain (10.178.114.63) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 10 Feb 2022 16:09:10 +0300
From:   "Alexander V. Buev" <a.buev@yadro.com>
To:     <linux-block@vger.kernel.org>
CC:     <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, <linux@yadro.com>,
        "Alexander V. Buev" <a.buev@yadro.com>
Subject: [PATCH v2 3/3] block: fops: handle IOCB_USE_PI in direct IO
Date:   Thu, 10 Feb 2022 16:08:25 +0300
Message-ID: <20220210130825.657520-4-a.buev@yadro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210130825.657520-1-a.buev@yadro.com>
References: <20220210130825.657520-1-a.buev@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.114.63]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Check that the size of integrity data correspond to device integrity
profile and data size. Split integrity data to the different bio's
in case of to big orginal bio (together with normal data).

Signed-off-by: Alexander V. Buev <a.buev@yadro.com>
---
 block/fops.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index 4f59e0f5bf30..99c670b9f7d4 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -16,6 +16,7 @@
 #include <linux/suspend.h>
 #include <linux/fs.h>
 #include <linux/module.h>
+#include <linux/blk-integrity.h>
 #include "blk.h"
 
 static inline struct inode *bdev_file_inode(struct file *file)
@@ -44,6 +45,19 @@ static unsigned int dio_bio_write_op(struct kiocb *iocb)
 
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
+	pi_iter->count = iter_count;
+	return ret;
+}
+
 static void blkdev_bio_end_io_simple(struct bio *bio)
 {
 	struct task_struct *waiter = bio->bi_private;
@@ -101,6 +115,14 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	if (iocb->ki_flags & IOCB_HIPRI)
 		bio_set_polled(&bio, iocb);
 
+	if (iocb->ki_flags & IOCB_USE_PI) {
+		ret = __bio_integrity_add_iovec(&bio, iocb->pi_iter);
+		if (ret) {
+			bio_release_pages(&bio, should_dirty);
+			goto out;
+		}
+	}
+
 	submit_bio(&bio);
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
@@ -252,6 +274,16 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		pos += bio->bi_iter.bi_size;
 
 		nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS);
+
+		if (iocb->ki_flags & IOCB_USE_PI) {
+			ret = __bio_integrity_add_iovec(bio, iocb->pi_iter);
+			if (ret) {
+				bio->bi_status = BLK_STS_IOERR;
+				bio_endio(bio);
+				break;
+			}
+		}
+
 		if (!nr_pages) {
 			submit_bio(bio);
 			break;
@@ -358,6 +390,15 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		task_io_account_write(bio->bi_iter.bi_size);
 	}
 
+	if (iocb->ki_flags & IOCB_USE_PI) {
+		ret = __bio_integrity_add_iovec(bio, iocb->pi_iter);
+		if (ret) {
+			bio->bi_status = BLK_STS_IOERR;
+			bio_endio(bio);
+			return ret;
+		}
+	}
+
 	if (iocb->ki_flags & IOCB_HIPRI) {
 		bio->bi_opf |= REQ_POLLED | REQ_NOWAIT;
 		submit_bio(bio);
@@ -377,6 +418,27 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	if (!iov_iter_count(iter))
 		return 0;
 
+	if (iocb->ki_flags & IOCB_USE_PI) {
+		struct block_device *bdev = iocb->ki_filp->private_data;
+		struct blk_integrity *bi = bdev_get_integrity(bdev);
+		unsigned int intervals;
+
+		if (unlikely(!(bi && bi->tuple_size &&
+				bi->flags & BLK_INTEGRITY_DEVICE_CAPABLE))) {
+			pr_err("Device %d:%d is not integrity capable",
+				MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
+			return -EINVAL;
+		}
+
+		intervals = bio_integrity_intervals(bi, iter->count >> 9);
+		if (unlikely(intervals * bi->tuple_size > iocb->pi_iter->count)) {
+			pr_err("Integrity & data size mismatch data=%zu integrity=%zu intervals=%u tuple=%u",
+				iter->count, iocb->pi_iter->count,
+				intervals, bi->tuple_size);
+				return -EINVAL;
+		}
+	}
+
 	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
 	if (likely(nr_pages <= BIO_MAX_VECS)) {
 		if (is_sync_kiocb(iocb))
-- 
2.34.1

