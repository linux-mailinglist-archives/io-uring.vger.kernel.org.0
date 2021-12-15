Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3C1475D53
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 17:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244559AbhLOQYZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 11:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244769AbhLOQYZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 11:24:25 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43D0C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 08:24:24 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id 14so30942904ioe.2
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 08:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1SBA0bhDbSks9/dge4Z1VfI7VEjTmMQutlQnA9v9Dz8=;
        b=KcE1I3I84+u1z1UaTcDjbPgiHeZZ49EnH/BJxurLAuXFhmmId2tMc5oNxowuep5rVF
         964O1i4qbiO4mxZi3567hCfxFGs5q4k1qaInNcGbid91PIB154svBJq+nDMQgaz5ZHma
         uytYifB64BhE8xTKdND/UitbkEyzN5bjx1nCVLgYPrz9DB3dMKSvbuH9PxOWolGiVN/y
         hB+LBaaqTn/KXlF6gv7rvsL5Ob4Dpq5oz3ufmMKV3pMFaHd1/ioTibLewpjUHA1ZBxCO
         ywAR2eueZjtKR7eqhGyO40PSOvqDzkNA80liuHG+48e/5TnLwPcl5CLjjY+yOwTIzfur
         O31g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1SBA0bhDbSks9/dge4Z1VfI7VEjTmMQutlQnA9v9Dz8=;
        b=PlNflhIenGz27QOYr9moGksqQqC7x0i3s6VGj8Yk+LVYnrZaUaGgNVyTVsQ7q5hDcB
         tz7gS3SF5faE9ZtbBX6PG4slFPIx6p987qDpeIIX4Dx2C6ZSottLNgaPuPwveBrSacNg
         uSvXraWrX/RIrWlmrf+nmAKPO3J6IT6VLCBHfUIb6AqMbcczPEPamKfzxQyMdhjQz9K6
         toa7bPd6sIe20oibO7b/p0BGRDduGd0rm+7Xfou2seNGkSlCFhFA2tivLAxnWE6ov8cM
         hfBqwjC1ZsoRYqWz2ZoNCW6Q2plhC66zaQjyCT0KUqW7fO76H7XldP2bDk1MsplHZEhx
         rSPA==
X-Gm-Message-State: AOAM530aowtXZLWtP8ZZp1xLQnnHenqfWhwJ9p0JYLM5Aw1RgBusnc9p
        TzOrc/O4eEXg5fDZPJ+gf9QrbLTGVM0Tgg==
X-Google-Smtp-Source: ABdhPJx1Y7YEULBa/TFG/Z2C6+4RHrgZkmPXXhE0CVwjSmOwGWsnCpEcezCGgTn66cPMcEhn7viteA==
X-Received: by 2002:a05:6638:11cb:: with SMTP id g11mr6078664jas.139.1639585463729;
        Wed, 15 Dec 2021 08:24:23 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g1sm1153170ild.52.2021.12.15.08.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 08:24:23 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] block: add mq_ops->queue_rqs hook
Date:   Wed, 15 Dec 2021 09:24:18 -0700
Message-Id: <20211215162421.14896-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215162421.14896-1-axboe@kernel.dk>
References: <20211215162421.14896-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we have a list of requests in our plug list, send it to the driver in
one go, if possible. The driver must set mq_ops->queue_rqs() to support
this, if not the usual one-by-one path is used.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq.c         | 26 +++++++++++++++++++++++---
 include/linux/blk-mq.h |  8 ++++++++
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e02e7017db03..f24394cb2004 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2512,6 +2512,7 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 {
 	struct blk_mq_hw_ctx *this_hctx;
 	struct blk_mq_ctx *this_ctx;
+	struct request *rq;
 	unsigned int depth;
 	LIST_HEAD(list);
 
@@ -2520,7 +2521,28 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 	plug->rq_count = 0;
 
 	if (!plug->multiple_queues && !plug->has_elevator && !from_schedule) {
-		struct request_queue *q = rq_list_peek(&plug->mq_list)->q;
+		struct request_queue *q;
+
+		rq = rq_list_peek(&plug->mq_list);
+		q = rq->q;
+
+		/*
+		 * Peek first request and see if we have a ->queue_rqs() hook.
+		 * If we do, we can dispatch the whole plug list in one go. We
+		 * already know at this point that all requests belong to the
+		 * same queue, caller must ensure that's the case.
+		 *
+		 * Since we pass off the full list to the driver at this point,
+		 * we do not increment the active request count for the queue.
+		 * Bypass shared tags for now because of that.
+		 */
+		if (q->mq_ops->queue_rqs &&
+		    !(rq->mq_hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)) {
+			blk_mq_run_dispatch_ops(q,
+				q->mq_ops->queue_rqs(&plug->mq_list));
+			if (rq_list_empty(plug->mq_list))
+				return;
+		}
 
 		blk_mq_run_dispatch_ops(q,
 				blk_mq_plug_issue_direct(plug, false));
@@ -2532,8 +2554,6 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 	this_ctx = NULL;
 	depth = 0;
 	do {
-		struct request *rq;
-
 		rq = rq_list_pop(&plug->mq_list);
 
 		if (!this_hctx) {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 6f858e05781e..1e1cd9cfbbea 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -493,6 +493,14 @@ struct blk_mq_ops {
 	 */
 	void (*commit_rqs)(struct blk_mq_hw_ctx *);
 
+	/**
+	 * @queue_rqs: Queue a list of new requests. Driver is guaranteed
+	 * that each request belongs to the same queue. If the driver doesn't
+	 * empty the @rqlist completely, then the rest will be queued
+	 * individually by the block layer upon return.
+	 */
+	void (*queue_rqs)(struct request **rqlist);
+
 	/**
 	 * @get_budget: Reserve budget before queue request, once .queue_rq is
 	 * run, it is driver's responsibility to release the
-- 
2.34.1

