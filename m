Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7011832C5B9
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382166AbhCDAYJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 19:24:09 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:48176 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1442110AbhCCL6d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 06:58:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UQFn1IH_1614772667;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQFn1IH_1614772667)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Mar 2021 19:57:48 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     msnitzer@redhat.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, mpatocka@redhat.com,
        caspar@linux.alibaba.com, joseph.qi@linux.alibaba.com
Subject: [PATCH v5 07/12] blk-mq: add one helper function getting hw queue
Date:   Wed,  3 Mar 2021 19:57:35 +0800
Message-Id: <20210303115740.127001-8-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
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
index 6ef9f0b038c2..72390f208c82 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3902,6 +3902,16 @@ unsigned int blk_mq_rq_cpu(struct request *rq)
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
index d22269b3dbe9..149f6a9d9aa7 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -638,5 +638,7 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio);
 int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, bool spin);
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
 		struct lock_class_key *key);
+struct blk_mq_hw_ctx *blk_mq_get_hctx(struct request_queue *q, int cpu,
+		unsigned int flags);
 
 #endif
-- 
2.27.0

