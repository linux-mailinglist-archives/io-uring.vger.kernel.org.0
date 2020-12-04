Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B772CEB46
	for <lists+io-uring@lfdr.de>; Fri,  4 Dec 2020 10:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387556AbgLDJpu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Dec 2020 04:45:50 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:32983 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387553AbgLDJpu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Dec 2020 04:45:50 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UHV5WIO_1607075096;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UHV5WIO_1607075096)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Dec 2020 17:45:06 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 RESEND] iomap: set REQ_NOWAIT according to IOCB_NOWAIT in Direct IO
Date:   Fri,  4 Dec 2020 17:44:56 +0800
Message-Id: <1607075096-94235-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently, IOCB_NOWAIT is ignored in Direct IO, REQ_NOWAIT is only set
when IOCB_HIPRI is set. But REQ_NOWAIT should be set as well when
IOCB_NOWAIT is set.

Suggested-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

Hi all,
I tested fio io_uring direct read for a file on ext4 filesystem on a
nvme ssd. I found that IOCB_NOWAIT is ignored in iomap layer, which
means REQ_NOWAIT is not set in bio->bi_opf. This makes nowait IO a
normal IO. Since I'm new to iomap and block layer, I sincerely ask
yours opinions in case I misunderstand the code which is very likely
to happen.:)
The example I use: io_uring direct randread, the first try is with
IOCB_NOWAIT but not IOCB_HIPRI, the IOCB_NOWAIT is ignored in block
layer which I think is not the designed behaviour.

I found that Konstantin found this issue before in May
2020 (https://www.spinics.net/lists/linux-block/msg53275.html), here add
his signature, add Jeffle's as well since he gave me some help.

v1->v2:
* add same logic in __blkdev_direct_IO_simple()
v2->v3:
* add same logic in do_blockdev_direct_IO()

 fs/block_dev.c       | 7 +++++++
 fs/direct-io.c       | 6 ++++--
 fs/iomap/direct-io.c | 3 +++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9e84b1928b94..ca6f365c2f14 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -263,6 +263,10 @@ static void blkdev_bio_end_io_simple(struct bio *bio)
 		bio.bi_opf = dio_bio_write_op(iocb);
 		task_io_account_write(ret);
 	}
+
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		bio.bi_opf |= REQ_NOWAIT;
+
 	if (iocb->ki_flags & IOCB_HIPRI)
 		bio_set_polled(&bio, iocb);
 
@@ -417,6 +421,9 @@ static void blkdev_bio_end_io(struct bio *bio)
 			task_io_account_write(bio->bi_iter.bi_size);
 		}
 
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			bio->bi_opf |= REQ_NOWAIT;
+
 		dio->size += bio->bi_iter.bi_size;
 		pos += bio->bi_iter.bi_size;
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index d53fa92a1ab6..b221ed351c1c 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1206,11 +1206,13 @@ static inline int drop_refcount(struct dio *dio)
 	if (iov_iter_rw(iter) == WRITE) {
 		dio->op = REQ_OP_WRITE;
 		dio->op_flags = REQ_SYNC | REQ_IDLE;
-		if (iocb->ki_flags & IOCB_NOWAIT)
-			dio->op_flags |= REQ_NOWAIT;
 	} else {
 		dio->op = REQ_OP_READ;
 	}
+
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		dio->op_flags |= REQ_NOWAIT;
+
 	if (iocb->ki_flags & IOCB_HIPRI)
 		dio->op_flags |= REQ_HIPRI;
 
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 933f234d5bec..2e897688ed6d 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -64,6 +64,9 @@ static void iomap_dio_submit_bio(struct iomap_dio *dio, struct iomap *iomap,
 {
 	atomic_inc(&dio->ref);
 
+	if (dio->iocb->ki_flags & IOCB_NOWAIT)
+		bio->bi_opf |= REQ_NOWAIT;
+
 	if (dio->iocb->ki_flags & IOCB_HIPRI)
 		bio_set_polled(bio, dio->iocb);
 
-- 
1.8.3.1

