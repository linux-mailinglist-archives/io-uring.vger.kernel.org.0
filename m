Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C50222CAF3
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 18:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgGXQXs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 12:23:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11883 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgGXQXs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jul 2020 12:23:48 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200724162344epoutp01611b60bed853e1856f004ff63a388c28~kvNzpATQt1167511675epoutp01H
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 16:23:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200724162344epoutp01611b60bed853e1856f004ff63a388c28~kvNzpATQt1167511675epoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595607825;
        bh=9BUQg2MABIlQJWC0nt7qshMzg+pFZbAyE/T4bNQe5QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxLzTI+0UUso4K7CftSf1XMuGftujRguR+MuKKt4NxOV4bMhQtwKI96jXh1Ot7Jwe
         qZtzXQDqKNgUrwY8nGBgjoFQTCSRbUuQZ6PGrbIzNyZkcGMOPtaWaL/LISTl4NZIEu
         WwhRXHE3fo+35vxHbz7CM3i5VBr6q5/G1xdYuLZE=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200724162344epcas5p4d5cbb0a523c0df4f882569bffb230255~kvNy_-ynz1123011230epcas5p4h;
        Fri, 24 Jul 2020 16:23:44 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E9.58.09467.01B0B1F5; Sat, 25 Jul 2020 01:23:44 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200724155341epcas5p15bfc55927f2abb60f19784270fe8e377~kuzj1c3I61092810928epcas5p12;
        Fri, 24 Jul 2020 15:53:41 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200724155341epsmtrp222b7665f8f31eee093e888402a2b0f2b~kuzj0h8TD2867528675epsmtrp2W;
        Fri, 24 Jul 2020 15:53:41 +0000 (GMT)
X-AuditID: b6c32a49-a3fff700000024fb-3d-5f1b0b10bacc
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6B.02.08382.5040B1F5; Sat, 25 Jul 2020 00:53:41 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200724155338epsmtip190d9121f4f0c9f6cc016e84f579484d3~kuzhG99OH0434604346epsmtip15;
        Fri, 24 Jul 2020 15:53:38 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     willy@infradead.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Arnav Dawn <a.dawn@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: [PATCH v4 4/6] block: add zone append handling for direct I/O path
Date:   Fri, 24 Jul 2020 21:19:20 +0530
Message-Id: <1595605762-17010-5-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSe0wTWRTG985MpwNuN2NBvYtSY4MvVlBRk5uoK0Y0o0aDGhODUWxgliqU
        QgcUMRhASUsRxVIsEHyhRqhBTUVULK4LASLIo2J8gCBQiWSFaqBWllJYx9H43+9+57vfOefm
        Uri0XORHHYxPYjXxijg56U1U1S1eGERPmx25zFVPIbfJKEIl5iqAbnSfIZF+spJAWVoXhprz
        SjHkyGolkP3NqBjVTw2TyHguE6A7X3Qkqun8A1lrnhCoo7qERFXuizh6bizF0YexJyRq8zSK
        kHushAz1YR4Ud4uZO2WBTEdLMmMZMYiZ05VmwIxaZIz2cQ7GWN4NY+FUhPeaaDbu4GFWs/TP
        A97Ky5+H8YT24BRzRiuZDp7P1wOKgvRKeCNbrAdelJR+CGDmoELgEQBPNoYK7AKw3xrNM2/v
        O2HE9MD7q14DYM/1SVI4jAJospwCfChJL4bt+ck8+tJr4IOrAbwFp5tw+KiuDvBBPvRW+LFV
        R/BM0PNhuacc41lCb4D/5BiA0EwGX7dm4zx70WGw3dYN+CBIWyn4X+FrsbBAGHR0hAh+H/hv
        Y6VYYD846qghBebg+Jt6XLirA/BlehEhFNZBm9WD8Tn415lvVS8VZH9Y0HTz2zw4/RvMdb/D
        BF0C71/4wfNgj2FAJPAs2Fd49Tsz0J557fsDmQCc6s0S5wFZ8c8WlwAwg9/ZBE4Vw3KrEpbH
        s0eCOYWKS46PCY5Sqyzg228K3HwfdPd+Cq4FGAVqAaRwua+kzOUXKZVEK46mshp1pCY5juVq
        wWyKkM+SyMee7pfSMYokNpZlE1jNjypGefmlY7rzf+8M+5wibXMnblSbjp+1da3c/f7QtjnF
        aQt63vpP+hoNoUXNm/MNTi1HLrOplkxfHVWhDdidNzDVFpv/pS9oLRdE27QNKc8ioh6n5q6Y
        ML1qmVjVP56qnzv4QWWf2e9q6mwJUZ026RrIXM+uweaZM7o2Va67XejM2Z70kfHshWk9m2TD
        vftsW6qdDolXx6/WnWWy9coXO1bnHbtSakpMDGnsXBu0ZWT8WNe8o+om7IraYciV3z1hv2sP
        pwtmDP3iHGiJ7Yu5/MwVzh3PrvAvWPRXUWS5dK5ye1RG3Z45aZZDE9MDlLqMBs2RBvP7Jc2G
        rArJNderW0Mqp2jo3qUIOcEpFcsDcQ2n+B/JY1N1vAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSnC4ri3S8wf0PPBa/tz1isfg9fQqr
        xZxV2xgtVt/tZ7Po+reFxaK1/RuTxekJi5gs3rWeY7F4fOczu8XR/2/ZLKZMa2K02Py9g81i
        7y1tiz17T7JYXN41h81i2+/5zBZXpixitnj94ySbxfm/x1ktfv+Yw+Yg4rFz1l12j80rtDwu
        ny312PRpErtH35ZVjB6fN8l5tB/oZvLY9OQtUwBHFJdNSmpOZllqkb5dAlfGwq9vmQsu6FWs
        ajzH1sB4RbWLkZNDQsBE4mHzFCYQW0hgN6PEgj1yEHFxieZrP9ghbGGJlf+es0PUfGSUmLJI
        qYuRg4NNQFPiwuRSkLCIgINE1/HHQGO4OJgFbjFLPFrbwwaSEBbwlnh/roMFxGYRUJVY+Xcl
        2C5eAWeJg92TGCHmy0ncPNfJDGJzCrhIXLh4lxFkvhBQzcUf5RMY+RYwMqxilEwtKM5Nzy02
        LDDMSy3XK07MLS7NS9dLzs/dxAiOBS3NHYzbV33QO8TIxMF4iFGCg1lJhHfFN6l4Id6UxMqq
        1KL8+KLSnNTiQ4zSHCxK4rw3ChfGCQmkJ5akZqemFqQWwWSZODilGpimCDh4WIV7HryzPeu9
        xs5bJU/N5xXk37qed+jHBY+9rIulFR1XPhTKezH99FFplcmaWw8uvBqRLXDY5lT/YW7RI5er
        w86v32+TerP8ZKnhn3upuvdZvzF8urMp99urGoWkbsHyQ+xCHEKvxPP6WBgFnTMTzFOXhVdL
        xrqf777V5mXU1Mki+uRO65xLrhy+fRft9tu9m7cucWsti+BBbWWt3tU+2it2yu9ezr1nsoV7
        UcGFO66LnJKl5TIldZyln2xfx6Ke9+/LIudN200rxEwj+6c9nPhI0/Q/H8OWrbEvNlgE99V/
        E7Sd9Iz9xdv3AVtuFr1wcDtQpvJ8YajN3w01Ri9fzP9Q9e7bei+1ieeVWIozEg21mIuKEwFX
        wT7b9AIAAA==
X-CMS-MailID: 20200724155341epcas5p15bfc55927f2abb60f19784270fe8e377
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20200724155341epcas5p15bfc55927f2abb60f19784270fe8e377
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
        <CGME20200724155341epcas5p15bfc55927f2abb60f19784270fe8e377@epcas5p1.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For zoned block device, opt in for zone-append by setting
FMODE_ZONE_APPEND during open. Make direct IO submission path use
IOCB_ZONE_APPEND to send bio with append op. Make direct IO completion
return written-offset, in bytes, to upper layer via ret2 of
kiocb->ki_complete interface.
Write with the flag IOCB_ZONE_APPEND are ensured not be be short.
Prevent short write and instead return failure if appending write spans
beyond end of device.
Return failure if write is larger than max_append_limit and therefore
requires formation of multiple bios.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Selvakumar S <selvakuma.s1@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Arnav Dawn <a.dawn@samsung.com>
Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
---
 fs/block_dev.c | 51 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 10 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 47860e5..3b5836b 100644
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
@@ -295,6 +304,14 @@ static int blkdev_iopoll(struct kiocb *kiocb, bool wait)
 	return blk_poll(q, READ_ONCE(kiocb->ki_cookie), wait);
 }
 
+static inline long long blkdev_bio_ret2(struct kiocb *iocb, struct bio *bio)
+{
+	/* return written-offset for zone append in bytes */
+	if (op_is_write(bio_op(bio)) && iocb->ki_flags & IOCB_ZONE_APPEND)
+		return bio->bi_iter.bi_sector << SECTOR_SHIFT;
+	return 0;
+}
+
 static void blkdev_bio_end_io(struct bio *bio)
 {
 	struct blkdev_dio *dio = bio->bi_private;
@@ -307,15 +324,17 @@ static void blkdev_bio_end_io(struct bio *bio)
 		if (!dio->is_sync) {
 			struct kiocb *iocb = dio->iocb;
 			ssize_t ret;
+			long long ret2;
 
 			if (likely(!dio->bio.bi_status)) {
 				ret = dio->size;
 				iocb->ki_pos += ret;
+				ret2 = blkdev_bio_ret2(iocb, bio);
 			} else {
 				ret = blk_status_to_errno(dio->bio.bi_status);
 			}
 
-			dio->iocb->ki_complete(iocb, ret, 0);
+			dio->iocb->ki_complete(iocb, ret, ret2);
 			if (dio->multi_bio)
 				bio_put(&dio->bio);
 		} else {
@@ -382,6 +401,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		bio->bi_private = dio;
 		bio->bi_end_io = blkdev_bio_end_io;
 		bio->bi_ioprio = iocb->ki_ioprio;
+		bio->bi_opf = dio_bio_op(is_read, iocb);
 
 		ret = bio_iov_iter_get_pages(bio, iter);
 		if (unlikely(ret)) {
@@ -391,11 +411,9 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		}
 
 		if (is_read) {
-			bio->bi_opf = REQ_OP_READ;
 			if (dio->should_dirty)
 				bio_set_pages_dirty(bio);
 		} else {
-			bio->bi_opf = dio_bio_write_op(iocb);
 			task_io_account_write(bio->bi_iter.bi_size);
 		}
 
@@ -419,6 +437,12 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
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
@@ -1841,6 +1865,7 @@ EXPORT_SYMBOL(blkdev_get_by_dev);
 static int blkdev_open(struct inode * inode, struct file * filp)
 {
 	struct block_device *bdev;
+	int ret;
 
 	/*
 	 * Preserve backwards compatibility and allow large file access
@@ -1866,7 +1891,11 @@ static int blkdev_open(struct inode * inode, struct file * filp)
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
@@ -2017,7 +2046,9 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if ((iocb->ki_flags & (IOCB_NOWAIT | IOCB_DIRECT)) == IOCB_NOWAIT)
 		return -EOPNOTSUPP;
 
-	iov_iter_truncate(from, size - iocb->ki_pos);
+	if (iov_iter_truncate(from, size - iocb->ki_pos) &&
+			(iocb->ki_flags & IOCB_ZONE_APPEND))
+		return -ENOSPC;
 
 	blk_start_plug(&plug);
 	ret = __generic_file_write_iter(iocb, from);
-- 
2.7.4

