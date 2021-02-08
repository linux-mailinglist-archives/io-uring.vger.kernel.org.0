Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF84312C8F
	for <lists+io-uring@lfdr.de>; Mon,  8 Feb 2021 09:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhBHI4h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Feb 2021 03:56:37 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:49761 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230126AbhBHIxg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Feb 2021 03:53:36 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UOAH3JG_1612774370;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UOAH3JG_1612774370)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Feb 2021 16:52:50 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, axboe@kernel.dk
Cc:     joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com, hch@lst.de,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: [PATCH v3 06/11] block/mq: add iterator for polling hw queues
Date:   Mon,  8 Feb 2021 16:52:38 +0800
Message-Id: <20210208085243.82367-7-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add one helper function for iterating all hardware queues in polling
mode.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 include/linux/blk-mq.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index cf1910c6d5ae..0c511555ec16 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -574,6 +574,13 @@ static inline void *blk_mq_rq_to_pdu(struct request *rq)
 	for ((i) = 0; (i) < (q)->nr_hw_queues &&			\
 	     ({ hctx = (q)->queue_hw_ctx[i]; 1; }); (i)++)
 
+#define queue_for_each_poll_hw_ctx(q, hctx, i)				\
+	for ((i) = 0; ((q)->tag_set->nr_maps > HCTX_TYPE_POLL) &&	\
+	     (i) < (q)->tag_set->map[HCTX_TYPE_POLL].nr_queues &&	\
+	     ({ int __idx = (q)->tag_set->map[HCTX_TYPE_POLL].queue_offset + (i); \
+	     hctx = (q)->queue_hw_ctx[__idx]; 1; }); \
+	     (i)++)
+
 #define hctx_for_each_ctx(hctx, ctx, i)					\
 	for ((i) = 0; (i) < (hctx)->nr_ctx &&				\
 	     ({ ctx = (hctx)->ctxs[(i)]; 1; }); (i)++)
-- 
2.27.0

