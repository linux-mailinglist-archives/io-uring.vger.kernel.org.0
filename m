Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5961547769D
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbhLPQFm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbhLPQFm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 11:05:42 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0F9C061574
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:05:42 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id y16so35830477ioc.8
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/pPKkXtT6Xrl9aqdgr4UGNl+ZJEtLSBkw/CIGk0Ps8Y=;
        b=hrAibA8VCiRbTVdDg+0x+InGlOJ+7hx7X3m+HVrRE6NeGaojnjD2KfBEJAt57Bx4kM
         ACupiwLU2vUmauKIDN301FUJJ6n1BgnD02odN8w3JnW7LCGe5nmxQDPO273GM4btJjUX
         V1FopdaIX6h0oB3RIpJX+b7FoyBH4NuoiYCF5pdu9KIJKIsQAk4iCep/Q66gGjd76o2a
         UIihO0OWoyCB2n2zPJ1YKWbBZhvMd420Jj3btrYZtg9ZwebXjibml4Gj9S3+5e4tpSBT
         wpX/Q6ij0l9dTKlSmI1nrvWocgsVnUXDiKwRHT32LoOmXssog1YLnFfkefG6El7MMS0Q
         RzXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/pPKkXtT6Xrl9aqdgr4UGNl+ZJEtLSBkw/CIGk0Ps8Y=;
        b=GbDvuwmLxANZhmIHveDHkF5ddQ8yGt00DIx4/sZEBN2L96PP/fGJcpZnrsKCdzvj1U
         2BP62B5z5/y8HlSPRthAbh/zUYzUmhgN5VNxXRpcPEPPAHGPZv32xed98ZWmtTYwxw8p
         aRxTa8o4fIWQb9Jl9hpkI6BJalLVnmYY8bMnkLsenV7AKZYNR5/yzOpjSop6/FaOBfM7
         jYKu+2q/txXMsDTMjhSr8zkt7UVX0B2ztnA2idjBqazSBoUcjoz5As8eItXWzKxTZUnl
         9qcOQywfUaOdBpVUb2w5eGxjb60wCvEvlpZ01yQQuRCXiKe9AJaEOQa/RXdvOyTBxL4Y
         JWlQ==
X-Gm-Message-State: AOAM532prw6B0UiHy4vB/7CAC4hHqgKlL/PNQNAfKIJRVUB58xlZw5LU
        X7jbwUYNxzVJgJ1qyr4yu5yr53+DHlKt0A==
X-Google-Smtp-Source: ABdhPJyZvGZ7Csc3Ozp6Tn4H9lRpoYb6zejMLBe6rUw9wqFXCf+CxyyNi5MRqbS6MX2EEwjVvOZdiQ==
X-Received: by 2002:a05:6638:2055:: with SMTP id t21mr10015876jaj.90.1639670741326;
        Thu, 16 Dec 2021 08:05:41 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s9sm3237155ild.14.2021.12.16.08.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 08:05:40 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] block: add mq_ops->queue_rqs hook
Date:   Thu, 16 Dec 2021 09:05:34 -0700
Message-Id: <20211216160537.73236-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211216160537.73236-1-axboe@kernel.dk>
References: <20211216160537.73236-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we have a list of requests in our plug list, send it to the driver in
one go, if possible. The driver must set mq_ops->queue_rqs() to support
this, if not the usual one-by-one path is used.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq.c         | 26 +++++++++++++++++++++++---
 include/linux/blk-mq.h |  8 ++++++++
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 75154cc788db..51991232824a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2553,6 +2553,7 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 {
 	struct blk_mq_hw_ctx *this_hctx;
 	struct blk_mq_ctx *this_ctx;
+	struct request *rq;
 	unsigned int depth;
 	LIST_HEAD(list);
 
@@ -2561,7 +2562,28 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
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
@@ -2573,8 +2595,6 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 	this_ctx = NULL;
 	depth = 0;
 	do {
-		struct request *rq;
-
 		rq = rq_list_pop(&plug->mq_list);
 
 		if (!this_hctx) {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 772f8f921526..550996cf419c 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -492,6 +492,14 @@ struct blk_mq_ops {
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

