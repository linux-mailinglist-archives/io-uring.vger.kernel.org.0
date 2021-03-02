Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E28932B550
	for <lists+io-uring@lfdr.de>; Wed,  3 Mar 2021 07:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345338AbhCCGn4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 01:43:56 -0500
Received: from smtp02.tmcz.cz ([93.153.104.113]:47295 "EHLO smtp02.tmcz.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1581890AbhCBT2p (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 2 Mar 2021 14:28:45 -0500
Received: from leontynka.twibright.com (109-183-129-149.customers.tmcz.cz [109.183.129.149])
        by smtp02.tmcz.cz (Postfix) with ESMTPS id 01629405E0;
        Tue,  2 Mar 2021 20:05:54 +0100 (CET)
Received: from debian-a64.vm ([192.168.208.2])
        by leontynka.twibright.com with smtp (Exim 4.92)
        (envelope-from <mpatocka@redhat.com>)
        id 1lHALA-0003k7-OQ; Tue, 02 Mar 2021 20:05:53 +0100
Received: by debian-a64.vm (sSMTP sendmail emulation); Tue, 02 Mar 2021 20:05:51 +0100
Message-Id: <20210302190551.473015400@debian-a64.vm>
User-Agent: quilt/0.65
Date:   Tue, 02 Mar 2021 20:05:14 +0100
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     JeffleXu <jefflexu@linux.alibaba.com>,
        Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
        caspar@linux.alibaba.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, hch@lst.de
Cc:     Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/4] block: introduce a function submit_bio_noacct_mq_direct
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=block-submit-bio-mq-direct.patch
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce a function that submits bio to a request-based device driver.
The function doesn't offload requests to current->bio_list. It is expected
to be called from device mapper, where current->bio_list is already set
up.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-core.c       |   16 ++++++++++++++++
 include/linux/blkdev.h |    1 +
 2 files changed, 17 insertions(+)

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2021-03-01 19:47:27.000000000 +0100
+++ linux-2.6/block/blk-core.c	2021-03-02 10:43:28.000000000 +0100
@@ -992,6 +992,22 @@ static blk_qc_t __submit_bio_noacct(stru
 	return ret;
 }
 
+blk_qc_t submit_bio_noacct_mq_direct(struct bio *bio)
+{
+	struct gendisk *disk = bio->bi_bdev->bd_disk;
+
+	if (unlikely(bio_queue_enter(bio) != 0))
+		return BLK_QC_T_NONE;
+	
+	if (!blk_crypto_bio_prep(&bio)) {
+		blk_queue_exit(disk->queue);
+		return BLK_QC_T_NONE;
+	}
+
+	return blk_mq_submit_bio(bio);
+}
+EXPORT_SYMBOL(submit_bio_noacct_mq_direct);
+
 static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
 {
 	struct bio_list bio_list[2] = { };
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2021-03-01 19:47:29.000000000 +0100
+++ linux-2.6/include/linux/blkdev.h	2021-03-02 10:44:04.000000000 +0100
@@ -912,6 +912,7 @@ static inline void rq_flush_dcache_pages
 
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
+blk_qc_t submit_bio_noacct_mq_direct(struct bio *bio);
 blk_qc_t submit_bio_noacct(struct bio *bio);
 extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_put_request(struct request *);

