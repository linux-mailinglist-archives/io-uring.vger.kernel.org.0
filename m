Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708E7214EAA
	for <lists+io-uring@lfdr.de>; Sun,  5 Jul 2020 20:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgGESw0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Jul 2020 14:52:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31503 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728124AbgGESwV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Jul 2020 14:52:21 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200705185219epoutp0425ed11a9fc66378e5bf17e77629b1ecd~e7-GaWR4m1071310713epoutp04e
        for <io-uring@vger.kernel.org>; Sun,  5 Jul 2020 18:52:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200705185219epoutp0425ed11a9fc66378e5bf17e77629b1ecd~e7-GaWR4m1071310713epoutp04e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593975139;
        bh=o9X0/DRGhOiQAeeouZvDE/Hf3lYVHbd1pPCwPfh4oTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nsNCWCzK63+qWyYDE4QkfeOCXbGb0RczV8vpBz6Zi03PF77nJ/j69qW//6qeux39j
         i67CsoW7PvZoUZleslD7kADS0my2x8W6bZCk2xtIrYS9VwWf/eqn7uDM92Kd2Le88t
         v9biNQGLKX6FKMBKjLVeTYqyVqkxoD9sdfqg/eL0=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200705185218epcas5p13f0f63e2276c1542beebf9c323633bce~e7-FrCPVo2311023110epcas5p16;
        Sun,  5 Jul 2020 18:52:18 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        82.C7.09703.261220F5; Mon,  6 Jul 2020 03:52:18 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200705185217epcas5p1cc12d4b892f057a1fe06d73a00869daa~e7-Eg1lv30734507345epcas5p1d;
        Sun,  5 Jul 2020 18:52:17 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200705185217epsmtrp2b1eda7d6b157d43bd4a3e1756bf6c6ce~e7-Ef8QyP1855618556epsmtrp20;
        Sun,  5 Jul 2020 18:52:17 +0000 (GMT)
X-AuditID: b6c32a4a-4b5ff700000025e7-42-5f022162852b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6B.37.08303.061220F5; Mon,  6 Jul 2020 03:52:16 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200705185214epsmtip2d532bc57741d334bd3d8583d01ff37ee~e7-B8VoeE3260032600epsmtip2z;
        Sun,  5 Jul 2020 18:52:14 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     hch@infradead.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Arnav Dawn <a.dawn@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: [PATCH v3 2/4] block: add zone append handling for direct I/O path
Date:   Mon,  6 Jul 2020 00:17:48 +0530
Message-Id: <1593974870-18919-3-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsWy7bCmum6SIlO8wcf5vBa/tz1isfg9fQqr
        xZxV2xgtVt/tZ7Po+reFxaK1/RuTxekJi5gs3rWeY7F4fOczu8XR/2/ZLKZMa2K02HtL22LP
        3pMsFpd3zWGzWLH9CIvFtt/zmS2uTFnEbPH6x0k2i/N/j7M6CHvsnHWX3WPzCi2Py2dLPTZ9
        msTu0X31B6NH35ZVjB6fN8l5tB/oZvLY9OQtUwBnFJdNSmpOZllqkb5dAldGx+xVrAXftCoa
        n/9kbGA8p9TFyMkhIWAicfH4TuYuRi4OIYHdjBIXJ71jhHA+MUqc/XyaBcL5zCjRMucRE0zL
        lCMfwWwhgV2MEv/nC8IVtS29ytbFyMHBJqApcWFyKYgpImAjsXOJCkgJs8AKZolzF98zgvQK
        C3hLzH9znw3EZhFQlVg5fwUziM0r4Cwx/eUUdohdchI3z3WCxTkFXCTadp8GO1VCYAeHxP62
        d2wQRS4Sh6Y1MkLYwhKvjm+BapaS+PxuL1RNscSvO0ehmjsYJa43zGSBSNhLXNzzlwnkUmag
        o9fv0gcJMwvwSfT+fgIWlhDglehoE4KoVpS4N+kpK4QtLvFwxhIo20Piyu5/rJBwmM4osezZ
        bvYJjLKzEKYuYGRcxSiZWlCcm55abFpglJdarlecmFtcmpeul5yfu4kRnJK0vHYwPnzwQe8Q
        IxMH4yFGCQ5mJRHeXm3GeCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8Sj/OxAkJpCeWpGanphak
        FsFkmTg4pRqY1Gu6JFp2TEqee/bDrXm3C6LUdlyqKzSaem+WavSyz/POKB0Pkp/UdEHR5pC6
        fcxTm2mLWBZW1RmXSFTqu9Zf2STqdur+nXyT77kxqgFfzyi/8GBfHTb3SO0LjWr9vYUFBqId
        a+QFnKcHBfc8ylyXe86j8Y6F9bS8s8XHrlUZyf7+M2P2kVWLN0itrGT4F3rMrf5N/tk/77W0
        9kWzMgjPuyYbx97fZf7y/dzaiu3X294pfNXU72lZonjl+xFNZ58vU46UOEYHPshev/ZSzuye
        mjObGFpdIyeG73m9yFH5Som4xklNoRtvWy79LGpgfVeiN1vv6GwBxSLxbcJOmWt59y5dbXKq
        1qrwXZdBgp+3EktxRqKhFnNRcSIAqs0TpbgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWy7bCSvG6CIlO8wYU1Fha/tz1isfg9fQqr
        xZxV2xgtVt/tZ7Po+reFxaK1/RuTxekJi5gs3rWeY7F4fOczu8XR/2/ZLKZMa2K02HtL22LP
        3pMsFpd3zWGzWLH9CIvFtt/zmS2uTFnEbPH6x0k2i/N/j7M6CHvsnHWX3WPzCi2Py2dLPTZ9
        msTu0X31B6NH35ZVjB6fN8l5tB/oZvLY9OQtUwBnFJdNSmpOZllqkb5dAldGx+xVrAXftCoa
        n/9kbGA8p9TFyMkhIWAiMeXIRyYQW0hgB6PEg98qEHFxieZrP9ghbGGJlf+eA9lcQDUfGSXu
        PjgN1MDBwSagKXFhcilIjYiAg0TX8cdMIDXMAjuYJV5dWckMkhAW8JaY/+Y+G4jNIqAqsXL+
        CrA4r4CzxPSXU6AWyEncPNcJFucUcJFo232aGWS+EFDN1EuKExj5FjAyrGKUTC0ozk3PLTYs
        MMpLLdcrTswtLs1L10vOz93ECI4GLa0djHtWfdA7xMjEwXiIUYKDWUmEt1ebMV6INyWxsiq1
        KD++qDQntfgQozQHi5I479dZC+OEBNITS1KzU1MLUotgskwcnFINTCtyknhWv33+wsf2Ztyc
        GKkGPhUh9Y7rR5gYpnrt2pQTtpfpV6if2eZP+fcn7zh97ZKY95MDt3/OaxJjulG95fDzj/L+
        S/VtBCMONexomzlH/Ofu4FOcrekZOu+mfNjbV6rh2fmw/emLvHm6k6YdSH2v0FQeWXckhG/B
        xK3XpcvPpH5cevbiU5a551+9y6lcK9Ptxq2x0Kv2Q/JpxmtRSSb8kXPz8m3nB6/wrbx87V/T
        6VM7u76dV9svLbapssKx762htEmYXL7MkVvNOSWRnpue6T7NCTjQfkNY97Sf8o93vQKmnz7N
        NS/ZGM5gN/9X1S8lP4cUSZOTEaoMkfdZdMIiFRo/db+wPJgql9Otp8RSnJFoqMVcVJwIAOO9
        /971AgAA
X-CMS-MailID: 20200705185217epcas5p1cc12d4b892f057a1fe06d73a00869daa
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200705185217epcas5p1cc12d4b892f057a1fe06d73a00869daa
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
        <CGME20200705185217epcas5p1cc12d4b892f057a1fe06d73a00869daa@epcas5p1.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Selvakumar S <selvakuma.s1@samsung.com>

For zoned block device, subscribe to zone-append by setting
FMODE_ZONE_APPEND during open. Make direct IO submission path use
IOCB_ZONE_APPEND to send bio with append op. Make direct IO completion
return zone-relative offset, in sector unit, to upper layer using
kiocb->ki_complete interface.
Return failure if write is larger than max_append_limit and therefore
requires formation of multiple bios.

Signed-off-by: Selvakumar S <selvakuma.s1@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Arnav Dawn <a.dawn@samsung.com>
Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
---
 fs/block_dev.c | 49 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 9 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 47860e5..941fb22 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -178,10 +178,19 @@ static struct inode *bdev_file_inode(struct file *file)
 	return file->f_mapping->host;
 }
 
-static unsigned int dio_bio_write_op(struct kiocb *iocb)
+static unsigned int dio_bio_op(bool is_read, struct kiocb *iocb)
 {
-	unsigned int op = REQ_OP_WRITE | REQ_SYNC | REQ_IDLE;
+	unsigned int op;
 
+	if (is_read)
+		return REQ_OP_READ;
+
+	if (iocb->ki_flags & IOCB_ZONE_APPEND)
+		op = REQ_OP_ZONE_APPEND;
+	else
+		op = REQ_OP_WRITE;
+
+	op |= REQ_SYNC | REQ_IDLE;
 	/* avoid the need for a I/O completion work item */
 	if (iocb->ki_flags & IOCB_DSYNC)
 		op |= REQ_FUA;
@@ -207,6 +216,7 @@ __blkdev_direct_IO_simple(struct kiocb *iocb, struct iov_iter *iter,
 	struct bio_vec inline_vecs[DIO_INLINE_BIO_VECS], *vecs;
 	loff_t pos = iocb->ki_pos;
 	bool should_dirty = false;
+	bool is_read = (iov_iter_rw(iter) == READ);
 	struct bio bio;
 	ssize_t ret;
 	blk_qc_t qc;
@@ -231,18 +241,17 @@ __blkdev_direct_IO_simple(struct kiocb *iocb, struct iov_iter *iter,
 	bio.bi_private = current;
 	bio.bi_end_io = blkdev_bio_end_io_simple;
 	bio.bi_ioprio = iocb->ki_ioprio;
+	bio.bi_opf = dio_bio_op(is_read, iocb);
 
 	ret = bio_iov_iter_get_pages(&bio, iter);
 	if (unlikely(ret))
 		goto out;
 	ret = bio.bi_iter.bi_size;
 
-	if (iov_iter_rw(iter) == READ) {
-		bio.bi_opf = REQ_OP_READ;
+	if (is_read) {
 		if (iter_is_iovec(iter))
 			should_dirty = true;
 	} else {
-		bio.bi_opf = dio_bio_write_op(iocb);
 		task_io_account_write(ret);
 	}
 	if (iocb->ki_flags & IOCB_HIPRI)
@@ -295,6 +304,16 @@ static int blkdev_iopoll(struct kiocb *kiocb, bool wait)
 	return blk_poll(q, READ_ONCE(kiocb->ki_cookie), wait);
 }
 
+static inline long blkdev_bio_res2(struct kiocb *iocb, struct bio *bio)
+{
+	/* calculate zone relative offset for zone append */
+	if (op_is_write(bio_op(bio)) && iocb->ki_flags & IOCB_ZONE_APPEND) {
+		sector_t zone_sec = blk_queue_zone_sectors(bio->bi_disk->queue);
+		return bio->bi_iter.bi_sector & (zone_sec - 1);
+	}
+	return 0;
+}
+
 static void blkdev_bio_end_io(struct bio *bio)
 {
 	struct blkdev_dio *dio = bio->bi_private;
@@ -307,15 +326,17 @@ static void blkdev_bio_end_io(struct bio *bio)
 		if (!dio->is_sync) {
 			struct kiocb *iocb = dio->iocb;
 			ssize_t ret;
+			long res2;
 
 			if (likely(!dio->bio.bi_status)) {
 				ret = dio->size;
 				iocb->ki_pos += ret;
+				res2 = blkdev_bio_res2(iocb, bio);
 			} else {
 				ret = blk_status_to_errno(dio->bio.bi_status);
 			}
 
-			dio->iocb->ki_complete(iocb, ret, 0);
+			dio->iocb->ki_complete(iocb, ret, res2);
 			if (dio->multi_bio)
 				bio_put(&dio->bio);
 		} else {
@@ -382,6 +403,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		bio->bi_private = dio;
 		bio->bi_end_io = blkdev_bio_end_io;
 		bio->bi_ioprio = iocb->ki_ioprio;
+		bio->bi_opf = dio_bio_op(is_read, iocb);
 
 		ret = bio_iov_iter_get_pages(bio, iter);
 		if (unlikely(ret)) {
@@ -391,11 +413,9 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		}
 
 		if (is_read) {
-			bio->bi_opf = REQ_OP_READ;
 			if (dio->should_dirty)
 				bio_set_pages_dirty(bio);
 		} else {
-			bio->bi_opf = dio_bio_write_op(iocb);
 			task_io_account_write(bio->bi_iter.bi_size);
 		}
 
@@ -419,6 +439,12 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		}
 
 		if (!dio->multi_bio) {
+			/* zone-append cannot work with multi bio*/
+			if (!is_read && iocb->ki_flags & IOCB_ZONE_APPEND) {
+				bio->bi_status = BLK_STS_IOERR;
+				bio_endio(bio);
+				break;
+			}
 			/*
 			 * AIO needs an extra reference to ensure the dio
 			 * structure which is embedded into the first bio
@@ -1841,6 +1867,7 @@ EXPORT_SYMBOL(blkdev_get_by_dev);
 static int blkdev_open(struct inode * inode, struct file * filp)
 {
 	struct block_device *bdev;
+	int ret;
 
 	/*
 	 * Preserve backwards compatibility and allow large file access
@@ -1866,7 +1893,11 @@ static int blkdev_open(struct inode * inode, struct file * filp)
 	filp->f_mapping = bdev->bd_inode->i_mapping;
 	filp->f_wb_err = filemap_sample_wb_err(filp->f_mapping);
 
-	return blkdev_get(bdev, filp->f_mode, filp);
+	ret = blkdev_get(bdev, filp->f_mode, filp);
+	if (blk_queue_is_zoned(bdev->bd_disk->queue))
+		filp->f_mode |= FMODE_ZONE_APPEND;
+
+	return ret;
 }
 
 static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
-- 
2.7.4

