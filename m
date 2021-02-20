Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B6D320507
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 12:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhBTLHo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 06:07:44 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:58447 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229803AbhBTLH1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 06:07:27 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UP1AWdu_1613819204;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UP1AWdu_1613819204)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Feb 2021 19:06:45 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, axboe@kernel.dk
Cc:     hch@lst.de, ming.lei@redhat.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com
Subject: [PATCH v4 07/12] blk-mq: add one helper function getting hw queue
Date:   Sat, 20 Feb 2021 19:06:32 +0800
Message-Id: <20210220110637.50305-8-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
References: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add one helper function getting hw queue mapping to specific CPU, and of
specific type.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-mq.c         | 10 ++++++++++
 include/linux/blk-mq.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b4de2b37b826..734aa1338b69 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3876,6 +3876,16 @@ unsigned int blk_mq_rq_cpu(struct request *rq)
 }
 EXPORT_SYMBOL(blk_mq_rq_cpu);
 
+
+struct blk_mq_hw_ctx *blk_mq_get_hctx(struct request_queue *q, int cpu,
+				      unsigned int flags)
+{
+	struct blk_mq_ctx *ctx = __blk_mq_get_ctx(q, cpu);
+
+	return blk_mq_map_queue(q, flags, ctx);
+}
+EXPORT_SYMBOL(blk_mq_get_hctx);
+
 static int __init blk_mq_init(void)
 {
 	int i;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 0c511555ec16..9b6a5c1fcb2d 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -630,5 +630,7 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio);
 int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, bool spin);
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
 		struct lock_class_key *key);
+struct blk_mq_hw_ctx *blk_mq_get_hctx(struct request_queue *q, int cpu,
+		unsigned int flags);
 
 #endif
-- 
2.27.0

