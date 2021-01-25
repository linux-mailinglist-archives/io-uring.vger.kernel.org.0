Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B46304A34
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 21:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbhAZFK0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 00:10:26 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:58842 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727881AbhAYMPq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 07:15:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UMpeZ6T_1611576822;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UMpeZ6T_1611576822)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Jan 2021 20:13:43 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com
Cc:     joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v2 5/6] block: add QUEUE_FLAG_POLL_CAP flag
Date:   Mon, 25 Jan 2021 20:13:39 +0800
Message-Id: <20210125121340.70459-6-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce QUEUE_FLAG_POLL_CAP flag representing if the request queue
capable of polling or not.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-mq.c         | 2 +-
 block/blk-sysfs.c      | 3 +--
 include/linux/blkdev.h | 6 ++++++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d058b9cbdf76..10f06337d8dc 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3203,7 +3203,7 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	q->queue_flags |= QUEUE_FLAG_MQ_DEFAULT;
 	if (set->nr_maps > HCTX_TYPE_POLL &&
 	    set->map[HCTX_TYPE_POLL].nr_queues)
-		blk_queue_flag_set(QUEUE_FLAG_POLL, q);
+		q->queue_flags |= QUEUE_FLAG_POLL_MASK;
 
 	q->sg_reserved_size = INT_MAX;
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index b513f1683af0..65693efb7c76 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -420,8 +420,7 @@ static ssize_t queue_poll_store(struct request_queue *q, const char *page,
 	unsigned long poll_on;
 	ssize_t ret;
 
-	if (!q->tag_set || q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
-	    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
+	if (!blk_queue_poll_cap(q))
 		return -EINVAL;
 
 	ret = queue_var_store(&poll_on, page, count);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bc540df197cb..095b486de02f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -621,11 +621,16 @@ struct request_queue {
 #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
 #define QUEUE_FLAG_HCTX_ACTIVE	28	/* at least one blk-mq hctx is active */
 #define QUEUE_FLAG_NOWAIT       29	/* device supports NOWAIT */
+#define QUEUE_FLAG_POLL_CAP	30	/* capable of IO polling */
 
 #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_SAME_COMP) |		\
 				 (1 << QUEUE_FLAG_NOWAIT))
 
+#define QUEUE_FLAG_POLL_MASK	((1 << QUEUE_FLAG_POLL) |		\
+				 (1<< QUEUE_FLAG_POLL_CAP))
+
+
 void blk_queue_flag_set(unsigned int flag, struct request_queue *q);
 void blk_queue_flag_clear(unsigned int flag, struct request_queue *q);
 bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
@@ -667,6 +672,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_fua(q)	test_bit(QUEUE_FLAG_FUA, &(q)->queue_flags)
 #define blk_queue_registered(q)	test_bit(QUEUE_FLAG_REGISTERED, &(q)->queue_flags)
 #define blk_queue_nowait(q)	test_bit(QUEUE_FLAG_NOWAIT, &(q)->queue_flags)
+#define blk_queue_poll_cap(q)	test_bit(QUEUE_FLAG_POLL_CAP, &(q)->queue_flags)
 
 extern void blk_set_pm_only(struct request_queue *q);
 extern void blk_clear_pm_only(struct request_queue *q);
-- 
2.27.0

