Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B963204F3
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 12:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhBTLHg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 06:07:36 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:53046 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhBTLH0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 06:07:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UP1XFxd_1613819200;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UP1XFxd_1613819200)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Feb 2021 19:06:41 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, axboe@kernel.dk
Cc:     hch@lst.de, ming.lei@redhat.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com
Subject: [PATCH v4 03/12] block: add poll method to support bio-based IO polling
Date:   Sat, 20 Feb 2021 19:06:28 +0800
Message-Id: <20210220110637.50305-4-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
References: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->poll_fn was introduced in commit ea435e1b9392 ("block: add a poll_fn
callback to struct request_queue") to support bio-based queues such as
nvme multipath, but was later removed in commit 529262d56dbe ("block:
remove ->poll_fn").

Given commit c62b37d96b6e ("block: move ->make_request_fn to struct
block_device_operations") restore the possibility of bio-based IO
polling support by adding an ->poll method to gendisk->fops.

Make blk_mq_poll() specific to blk-mq, while blk_bio_poll() is
originally a copy from blk_mq_poll(), and is specific to bio-based
polling. Currently hybrid polling is not supported by bio-based polling.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-core.c       | 58 ++++++++++++++++++++++++++++++++++++++++++
 block/blk-mq.c         | 22 +---------------
 include/linux/blk-mq.h |  1 +
 include/linux/blkdev.h |  1 +
 4 files changed, 61 insertions(+), 21 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7663a9b94b80..37aa513da5f2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1132,6 +1132,64 @@ blk_qc_t submit_bio(struct bio *bio)
 }
 EXPORT_SYMBOL(submit_bio);
 
+
+static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
+{
+	long state;
+	struct gendisk *disk = queue_to_disk(q);
+
+	state = current->state;
+	do {
+		int ret;
+
+		ret = disk->fops->poll(q, cookie);
+		if (ret > 0) {
+			__set_current_state(TASK_RUNNING);
+			return ret;
+		}
+
+		if (signal_pending_state(state, current))
+			__set_current_state(TASK_RUNNING);
+
+		if (current->state == TASK_RUNNING)
+			return 1;
+		if (ret < 0 || !spin)
+			break;
+		cpu_relax();
+	} while (!need_resched());
+
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}
+
+/**
+ * blk_poll - poll for IO completions
+ * @q:  the queue
+ * @cookie: cookie passed back at IO submission time
+ * @spin: whether to spin for completions
+ *
+ * Description:
+ *    Poll for completions on the passed in queue. Returns number of
+ *    completed entries found. If @spin is true, then blk_poll will continue
+ *    looping until at least one completion is found, unless the task is
+ *    otherwise marked running (or we need to reschedule).
+ */
+int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
+{
+	if (!blk_qc_t_valid(cookie) ||
+	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+		return 0;
+
+	if (current->plug)
+		blk_flush_plug_list(current->plug, false);
+
+	if (queue_is_mq(q))
+		return blk_mq_poll(q, cookie, spin);
+	else
+		return blk_bio_poll(q, cookie, spin);
+}
+EXPORT_SYMBOL_GPL(blk_poll);
+
 /**
  * blk_cloned_rq_check_limits - Helper function to check a cloned request
  *                              for the new queue limits
diff --git a/block/blk-mq.c b/block/blk-mq.c
index f285a9123a8b..c18bc23834a0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3826,30 +3826,11 @@ static bool blk_mq_poll_hybrid(struct request_queue *q,
 	return blk_mq_poll_hybrid_sleep(q, rq);
 }
 
-/**
- * blk_poll - poll for IO completions
- * @q:  the queue
- * @cookie: cookie passed back at IO submission time
- * @spin: whether to spin for completions
- *
- * Description:
- *    Poll for completions on the passed in queue. Returns number of
- *    completed entries found. If @spin is true, then blk_poll will continue
- *    looping until at least one completion is found, unless the task is
- *    otherwise marked running (or we need to reschedule).
- */
-int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
+int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 {
 	struct blk_mq_hw_ctx *hctx;
 	long state;
 
-	if (!blk_qc_t_valid(cookie) ||
-	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
-		return 0;
-
-	if (current->plug)
-		blk_flush_plug_list(current->plug, false);
-
 	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
 
 	/*
@@ -3891,7 +3872,6 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	__set_current_state(TASK_RUNNING);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(blk_poll);
 
 unsigned int blk_mq_rq_cpu(struct request *rq)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index d705b174d346..adc789d5888e 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -607,6 +607,7 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
 }
 
 blk_qc_t blk_mq_submit_bio(struct bio *bio);
+int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, bool spin);
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
 		struct lock_class_key *key);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2a802e011a95..ebe16f55cba4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1853,6 +1853,7 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
 
 struct block_device_operations {
 	blk_qc_t (*submit_bio) (struct bio *bio);
+	int (*poll)(struct request_queue *q, blk_qc_t cookie);
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
 	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
-- 
2.27.0

