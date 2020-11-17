Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64EBD2B5A91
	for <lists+io-uring@lfdr.de>; Tue, 17 Nov 2020 08:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgKQH43 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Nov 2020 02:56:29 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:46271 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726136AbgKQH43 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Nov 2020 02:56:29 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UFgHDzY_1605599786;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UFgHDzY_1605599786)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 17 Nov 2020 15:56:26 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     axboe@kernel.dk, hch@infradead.org, ming.lei@redhat.com
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com
Subject: [PATCH v4 2/2] block,iomap: disable iopoll when split needed
Date:   Tue, 17 Nov 2020 15:56:25 +0800
Message-Id: <20201117075625.46118-3-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117075625.46118-1-jefflexu@linux.alibaba.com>
References: <20201117075625.46118-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Both blkdev fs and iomap-based fs (ext4, xfs, etc.) currently support
sync iopoll. One single bio can contain at most BIO_MAX_PAGES, i.e. 256
bio_vec. If the input iov_iter contains more than 256 segments, then
one dio will be split into multiple bios, which may cause potential
deadlock for sync iopoll.

When it comes to sync iopoll, the bio is submitted without REQ_NOWAIT
flag set and the process may hang in blk_mq_get_tag() if the dio needs
to be split into multiple bios and thus can rapidly exhausts the queue
depth. The process has to wait for the completion of the previously
allocated requests, which should be reaped by the following sync
polling, and thus causing a potential deadlock.

In fact there's a subtle difference of handling of HIPRI IO between
blkdev fs and iomap-based fs, when dio need to be split into multiple
bios. blkdev fs will set REQ_HIPRI for only the last split bio, leaving
the previous bios queued into normal hardware queues, and not causing
the trouble described above. iomap-based fs will set REQ_HIPRI for all
split bios, and thus may cause the potential deadlock described above.

Noted that though the analysis described above, currently blkdev fs and
iomap-based fs won't trigger this potential deadlock. Because only
preadv2(2)/pwritev2(2) are capable of *sync* polling as only these two
can set RWF_NOWAIT. Currently the maximum number of iovecs of one single
preadv2(2)/pwritev2(2) call is UIO_MAXIOV, i.e. 1024, while the minimum
queue depth is BLKDEV_MIN_RQ i.e. 4. That means one
preadv2(2)/pwritev2(2) call can submit at most 4 bios, which will fill
up the queue depth *exactly* and thus there's no deadlock in this case.

However this constraint can be fragile. Disable iopoll when one dio need
to be split into multiple bios.Though blkdev fs may not suffer this issue,
still it may not make much sense to iopoll for big IO, since iopoll is
initially for small size, latency sensitive IO.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/block_dev.c       |  9 +++++++++
 fs/iomap/direct-io.c | 10 ++++++++++
 2 files changed, 19 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9e84b1928b94..ed3f46e8fa91 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -436,6 +436,15 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 			break;
 		}
 
+		/*
+		 * The current dio needs to be split into multiple bios here.
+		 * iopoll for split bio will cause subtle trouble such as
+		 * hang when doing sync polling, while iopoll is initially
+		 * for small size, latency sensitive IO. Thus disable iopoll
+		 * if split needed.
+		 */
+		iocb->ki_flags &= ~IOCB_HIPRI;
+
 		if (!dio->multi_bio) {
 			/*
 			 * AIO needs an extra reference to ensure the dio
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 933f234d5bec..396ac0f91a43 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -309,6 +309,16 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		copied += n;
 
 		nr_pages = iov_iter_npages(dio->submit.iter, BIO_MAX_PAGES);
+		/*
+		 * The current dio needs to be split into multiple bios here.
+		 * iopoll for split bio will cause subtle trouble such as
+		 * hang when doing sync polling, while iopoll is initially
+		 * for small size, latency sensitive IO. Thus disable iopoll
+		 * if split needed.
+		 */
+		if (nr_pages)
+			dio->iocb->ki_flags &= ~IOCB_HIPRI;
+
 		iomap_dio_submit_bio(dio, iomap, bio, pos);
 		pos += n;
 	} while (nr_pages);
-- 
2.27.0

