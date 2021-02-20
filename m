Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5483204F9
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 12:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbhBTLHo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 06:07:44 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:44072 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229802AbhBTLH1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 06:07:27 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UP1BfWE_1613819203;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UP1BfWE_1613819203)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Feb 2021 19:06:44 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, axboe@kernel.dk
Cc:     hch@lst.de, ming.lei@redhat.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com
Subject: [PATCH v4 06/12] blk-mq: add iterator for polling hw queues
Date:   Sat, 20 Feb 2021 19:06:31 +0800
Message-Id: <20210220110637.50305-7-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
References: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
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

