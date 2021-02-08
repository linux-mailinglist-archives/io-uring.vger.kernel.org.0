Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9BD312C85
	for <lists+io-uring@lfdr.de>; Mon,  8 Feb 2021 09:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhBHIzs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Feb 2021 03:55:48 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:37738 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230148AbhBHIxb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Feb 2021 03:53:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UOAH3J-_1612774368;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UOAH3J-_1612774368)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Feb 2021 16:52:48 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, axboe@kernel.dk
Cc:     joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com, hch@lst.de,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: [PATCH v3 04/11] block: add poll_capable method to support bio-based IO polling
Date:   Mon,  8 Feb 2021 16:52:36 +0800
Message-Id: <20210208085243.82367-5-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This method can be used to check if bio-based device supports IO polling
or not. For mq devices, checking for hw queue in polling mode is
adequate, while the sanity check shall be implementation specific for
bio-based devices. For example, dm device needs to check if all
underlying devices are capable of IO polling.

Though bio-based device may have done the sanity check during the
device initialization phase, cacheing the result of this sanity check
(such as by cacheing in the queue_flags) may not work. Because for dm
devices, users could change the state of the underlying devices through
'/sys/block/<dev>/io_poll', bypassing the dm device above. In this case,
the cached result of the very beginning sanity check could be
out-of-date. Thus the sanity check needs to be done every time 'io_poll'
is to be modified.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-sysfs.c      | 14 +++++++++++---
 include/linux/blkdev.h |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index b513f1683af0..f11fedefc37d 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -420,9 +420,17 @@ static ssize_t queue_poll_store(struct request_queue *q, const char *page,
 	unsigned long poll_on;
 	ssize_t ret;
 
-	if (!q->tag_set || q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
-	    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
-		return -EINVAL;
+	if (queue_is_mq(q)) {
+		if (!q->tag_set || q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
+		    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
+			return -EINVAL;
+	} else {
+		struct gendisk *disk = queue_to_disk(q);
+
+		if (!disk->fops->poll_capable ||
+		    !disk->fops->poll_capable(disk))
+			return -EINVAL;
+	}
 
 	ret = queue_var_store(&poll_on, page, count);
 	if (ret < 0)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ebe16f55cba4..8a84088642ce 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1854,6 +1854,7 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
 struct block_device_operations {
 	blk_qc_t (*submit_bio) (struct bio *bio);
 	int (*poll)(struct request_queue *q, blk_qc_t cookie);
+	bool (*poll_capable)(struct gendisk *disk);
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
 	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
-- 
2.27.0

