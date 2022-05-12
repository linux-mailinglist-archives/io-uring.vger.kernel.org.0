Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511DE5244DB
	for <lists+io-uring@lfdr.de>; Thu, 12 May 2022 07:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349852AbiELFZo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 May 2022 01:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238423AbiELFZn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 May 2022 01:25:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D72791E3FD
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 22:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652333139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rzUAeH0BKOzPYC738+hLYxVIwdn5S1zeJWAp6BRhKcE=;
        b=FB0b4ayw4NXDrNiHE7zMMcbVHKC6YD8C+cFXUBYYrBOOhHx0oaSKoLbgC181ZnFqCbvlXp
        ygNganM6M6keVr1K2cHWQqqW1jy4O9t4NQiOR70Y/vg5P5x2vsWnoBj1LHDsvBLZeTixPF
        LvDJFV8+Iw1s3FuMoD262rNhtUz3hZ8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-GubpK2L9MyS2j-62u3oVXw-1; Thu, 12 May 2022 01:25:36 -0400
X-MC-Unique: GubpK2L9MyS2j-62u3oVXw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23ED6803B22;
        Thu, 12 May 2022 05:25:36 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1576140CF8F4;
        Thu, 12 May 2022 05:25:29 +0000 (UTC)
Date:   Thu, 12 May 2022 13:25:24 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        mcgrof@kernel.org, shr@fb.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH v5 2/6] block: wire-up support for passthrough plugging
Message-ID: <YnyaRB+u1x6nIVp1@T590>
References: <20220511054750.20432-1-joshi.k@samsung.com>
 <CGME20220511055310epcas5p46650f5b6fe963279f686b8f50a98a286@epcas5p4.samsung.com>
 <20220511054750.20432-3-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511054750.20432-3-joshi.k@samsung.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

On Wed, May 11, 2022 at 11:17:46AM +0530, Kanchan Joshi wrote:
> From: Jens Axboe <axboe@kernel.dk>
> 
> Add support for plugging in passthrough path. When plugging is enabled, the
> requests are added to a plug instead of getting dispatched to the driver.
> And when the plug is finished, the whole batch gets dispatched via
> ->queue_rqs which turns out to be more efficient. Otherwise dispatching
> used to happen via ->queue_rq, one request at a time.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq.c | 73 +++++++++++++++++++++++++++-----------------------
>  1 file changed, 39 insertions(+), 34 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 84d749511f55..2cf011b57cf9 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2340,6 +2340,40 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
>  	blk_mq_hctx_mark_pending(hctx, ctx);
>  }
>  
> +/*
> + * Allow 2x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
> + * queues. This is important for md arrays to benefit from merging
> + * requests.
> + */
> +static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
> +{
> +	if (plug->multiple_queues)
> +		return BLK_MAX_REQUEST_COUNT * 2;
> +	return BLK_MAX_REQUEST_COUNT;
> +}
> +
> +static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
> +{
> +	struct request *last = rq_list_peek(&plug->mq_list);
> +
> +	if (!plug->rq_count) {
> +		trace_block_plug(rq->q);
> +	} else if (plug->rq_count >= blk_plug_max_rq_count(plug) ||
> +		   (!blk_queue_nomerges(rq->q) &&
> +		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
> +		blk_mq_flush_plug_list(plug, false);
> +		trace_block_plug(rq->q);
> +	}
> +
> +	if (!plug->multiple_queues && last && last->q != rq->q)
> +		plug->multiple_queues = true;
> +	if (!plug->has_elevator && (rq->rq_flags & RQF_ELV))
> +		plug->has_elevator = true;
> +	rq->rq_next = NULL;
> +	rq_list_add(&plug->mq_list, rq);
> +	plug->rq_count++;
> +}
> +
>  /**
>   * blk_mq_request_bypass_insert - Insert a request at dispatch list.
>   * @rq: Pointer to request to be inserted.
> @@ -2353,7 +2387,12 @@ void blk_mq_request_bypass_insert(struct request *rq, bool at_head,
>  				  bool run_queue)
>  {
>  	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
> +	struct blk_plug *plug = current->plug;
>  
> +	if (plug) {
> +		blk_add_rq_to_plug(plug, rq);
> +		return;
> +	}

This way may cause nested plugging, and breaks xfstests generic/131.
Also may cause io hang since request can't be polled before flushing
plug in blk_execute_rq().

I'd suggest to apply the plug in blk_execute_rq_nowait(), such as:


diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2cf011b57cf9..60c29c0229d5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1169,6 +1169,62 @@ static void blk_end_sync_rq(struct request *rq, blk_status_t error)
 	complete(waiting);
 }
 
+/*
+ * Allow 2x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
+ * queues. This is important for md arrays to benefit from merging
+ * requests.
+ */
+static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
+{
+	if (plug->multiple_queues)
+		return BLK_MAX_REQUEST_COUNT * 2;
+	return BLK_MAX_REQUEST_COUNT;
+}
+
+static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
+{
+	struct request *last = rq_list_peek(&plug->mq_list);
+
+	if (!plug->rq_count) {
+		trace_block_plug(rq->q);
+	} else if (plug->rq_count >= blk_plug_max_rq_count(plug) ||
+		   (!blk_queue_nomerges(rq->q) &&
+		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
+		blk_mq_flush_plug_list(plug, false);
+		trace_block_plug(rq->q);
+	}
+
+	if (!plug->multiple_queues && last && last->q != rq->q)
+		plug->multiple_queues = true;
+	if (!plug->has_elevator && (rq->rq_flags & RQF_ELV))
+		plug->has_elevator = true;
+	rq->rq_next = NULL;
+	rq_list_add(&plug->mq_list, rq);
+	plug->rq_count++;
+}
+
+static void __blk_execute_rq_nowait(struct request *rq, bool at_head,
+		rq_end_io_fn *done, bool use_plug)
+{
+	WARN_ON(irqs_disabled());
+	WARN_ON(!blk_rq_is_passthrough(rq));
+
+	rq->end_io = done;
+
+	blk_account_io_start(rq);
+
+	if (use_plug && current->plug) {
+		blk_add_rq_to_plug(current->plug, rq);
+		return;
+	}
+	/*
+	 * don't check dying flag for MQ because the request won't
+	 * be reused after dying flag is set
+	 */
+	blk_mq_sched_insert_request(rq, at_head, true, false);
+}
+
+
 /**
  * blk_execute_rq_nowait - insert a request to I/O scheduler for execution
  * @rq:		request to insert
@@ -1184,18 +1240,8 @@ static void blk_end_sync_rq(struct request *rq, blk_status_t error)
  */
 void blk_execute_rq_nowait(struct request *rq, bool at_head, rq_end_io_fn *done)
 {
-	WARN_ON(irqs_disabled());
-	WARN_ON(!blk_rq_is_passthrough(rq));
-
-	rq->end_io = done;
-
-	blk_account_io_start(rq);
+	__blk_execute_rq_nowait(rq, at_head, done, true);
 
-	/*
-	 * don't check dying flag for MQ because the request won't
-	 * be reused after dying flag is set
-	 */
-	blk_mq_sched_insert_request(rq, at_head, true, false);
 }
 EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
 
@@ -1234,7 +1280,7 @@ blk_status_t blk_execute_rq(struct request *rq, bool at_head)
 	unsigned long hang_check;
 
 	rq->end_io_data = &wait;
-	blk_execute_rq_nowait(rq, at_head, blk_end_sync_rq);
+	__blk_execute_rq_nowait(rq, at_head, blk_end_sync_rq, false);
 
 	/* Prevent hang_check timer from firing at us during very long I/O */
 	hang_check = sysctl_hung_task_timeout_secs;
@@ -2340,40 +2386,6 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	blk_mq_hctx_mark_pending(hctx, ctx);
 }
 
-/*
- * Allow 2x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
- * queues. This is important for md arrays to benefit from merging
- * requests.
- */
-static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
-{
-	if (plug->multiple_queues)
-		return BLK_MAX_REQUEST_COUNT * 2;
-	return BLK_MAX_REQUEST_COUNT;
-}
-
-static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
-{
-	struct request *last = rq_list_peek(&plug->mq_list);
-
-	if (!plug->rq_count) {
-		trace_block_plug(rq->q);
-	} else if (plug->rq_count >= blk_plug_max_rq_count(plug) ||
-		   (!blk_queue_nomerges(rq->q) &&
-		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
-		blk_mq_flush_plug_list(plug, false);
-		trace_block_plug(rq->q);
-	}
-
-	if (!plug->multiple_queues && last && last->q != rq->q)
-		plug->multiple_queues = true;
-	if (!plug->has_elevator && (rq->rq_flags & RQF_ELV))
-		plug->has_elevator = true;
-	rq->rq_next = NULL;
-	rq_list_add(&plug->mq_list, rq);
-	plug->rq_count++;
-}
-
 /**
  * blk_mq_request_bypass_insert - Insert a request at dispatch list.
  * @rq: Pointer to request to be inserted.
@@ -2387,12 +2399,7 @@ void blk_mq_request_bypass_insert(struct request *rq, bool at_head,
 				  bool run_queue)
 {
 	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
-	struct blk_plug *plug = current->plug;
 
-	if (plug) {
-		blk_add_rq_to_plug(plug, rq);
-		return;
-	}
 	spin_lock(&hctx->lock);
 	if (at_head)
 		list_add(&rq->queuelist, &hctx->dispatch);


Thanks,
Ming

