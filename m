Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423C22E1BDD
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 12:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgLWL1J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 06:27:09 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:39417 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728435AbgLWL1I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 06:27:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UJWwKPG_1608722785;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UJWwKPG_1608722785)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 23 Dec 2020 19:26:25 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: [PATCH RFC 2/7] block: add helper function fetching gendisk from queue
Date:   Wed, 23 Dec 2020 19:26:19 +0800
Message-Id: <20201223112624.78955-3-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sometimes we need to get the corresponding gendisk from request_queue.

One such use case is that, the block device driver had ever stored the
same private data both in queue->queuedata and gendisk->private_data,
while nowadays gendisk->private_data is more preferable in such case,
e.g. commit c4a59c4e5db3 ("dm: stop using ->queuedata"). So if only
request_queue given, we need to get the corresponding gendisk from
queue, to get the private data stored in gendisk.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 include/linux/blkdev.h       | 2 ++
 include/trace/events/kyber.h | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 070de09425ad..2303d06a5a82 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -691,6 +691,8 @@ static inline bool blk_account_rq(struct request *rq)
 	dma_map_page_attrs(dev, (bv)->bv_page, (bv)->bv_offset, (bv)->bv_len, \
 	(dir), (attrs))
 
+#define queue_to_disk(q)	(dev_to_disk(kobj_to_dev((q)->kobj.parent)))
+
 static inline bool queue_is_mq(struct request_queue *q)
 {
 	return q->mq_ops;
diff --git a/include/trace/events/kyber.h b/include/trace/events/kyber.h
index c0e7d24ca256..f9802562edf6 100644
--- a/include/trace/events/kyber.h
+++ b/include/trace/events/kyber.h
@@ -30,7 +30,7 @@ TRACE_EVENT(kyber_latency,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= disk_devt(dev_to_disk(kobj_to_dev(q->kobj.parent)));
+		__entry->dev		= disk_devt(queue_to_disk(q));
 		strlcpy(__entry->domain, domain, sizeof(__entry->domain));
 		strlcpy(__entry->type, type, sizeof(__entry->type));
 		__entry->percentile	= percentile;
@@ -59,7 +59,7 @@ TRACE_EVENT(kyber_adjust,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= disk_devt(dev_to_disk(kobj_to_dev(q->kobj.parent)));
+		__entry->dev		= disk_devt(queue_to_disk(q));
 		strlcpy(__entry->domain, domain, sizeof(__entry->domain));
 		__entry->depth		= depth;
 	),
@@ -81,7 +81,7 @@ TRACE_EVENT(kyber_throttled,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= disk_devt(dev_to_disk(kobj_to_dev(q->kobj.parent)));
+		__entry->dev		= disk_devt(queue_to_disk(q));
 		strlcpy(__entry->domain, domain, sizeof(__entry->domain));
 	),
 
-- 
2.27.0

