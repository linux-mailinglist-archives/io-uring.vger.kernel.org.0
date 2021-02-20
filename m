Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2019E32050D
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 12:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhBTLHi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 06:07:38 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:55520 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229796AbhBTLH0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 06:07:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UP1N.EP_1613819202;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UP1N.EP_1613819202)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Feb 2021 19:06:43 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, axboe@kernel.dk
Cc:     hch@lst.de, ming.lei@redhat.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com
Subject: [PATCH v4 05/12] blk-mq: extract one helper function polling hw queue
Date:   Sat, 20 Feb 2021 19:06:30 +0800
Message-Id: <20210220110637.50305-6-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
References: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Extract the logic of polling one hw queue and related statistics
handling out as the helper function.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-mq.c         |  5 +----
 include/linux/blk-mq.h | 13 +++++++++++++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c18bc23834a0..b4de2b37b826 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3850,11 +3850,8 @@ int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	do {
 		int ret;
 
-		hctx->poll_invoked++;
-
-		ret = q->mq_ops->poll(hctx);
+		ret = blk_mq_poll_hctx(q, hctx);
 		if (ret > 0) {
-			hctx->poll_success++;
 			__set_current_state(TASK_RUNNING);
 			return ret;
 		}
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index adc789d5888e..cf1910c6d5ae 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -606,6 +606,19 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
 		rq->rq_disk = bio->bi_disk;
 }
 
+static inline int blk_mq_poll_hctx(struct request_queue *q,
+				   struct blk_mq_hw_ctx *hctx)
+{
+	int ret;
+
+	hctx->poll_invoked++;
+	ret = q->mq_ops->poll(hctx);
+	if (ret > 0)
+		hctx->poll_success++;
+
+	return ret;
+}
+
 blk_qc_t blk_mq_submit_bio(struct bio *bio);
 int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, bool spin);
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
-- 
2.27.0

