Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A538851C254
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 16:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380563AbiEEOZc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 10:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380581AbiEEOZa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 10:25:30 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9EAA5A5B9
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 07:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651760505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PV6wBZmVtTcLzLdqX7LnKeJ6D+LpJnxwl2ACNXXhtMk=;
        b=LGgYF3MLA4m4ebIpj/zJxO5NAwTcnUgjOCfUNF32U8wEJSTax4KPE3q57O7pDvCppw13UR
        yXwcZRqrqr+pxsOiB9REgfMQ+l8zrldbwC7aLCPYS2o98Yn5J/wvW1vfzw1jYy6Gg9i4TV
        IXmANyRwR2FIZL6qL0yYLb4yxlG8YR0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-uFpv01qhPQeVUzK0NZtdMg-1; Thu, 05 May 2022 10:21:43 -0400
X-MC-Unique: uFpv01qhPQeVUzK0NZtdMg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA684395AFE1;
        Thu,  5 May 2022 14:21:30 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B9DCF416157;
        Thu,  5 May 2022 14:21:21 +0000 (UTC)
Date:   Thu, 5 May 2022 22:21:15 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        mcgrof@kernel.org, shr@fb.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH v4 2/5] block: wire-up support for passthrough plugging
Message-ID: <YnPdW7T8JVRsNeno@T590>
References: <20220505060616.803816-1-joshi.k@samsung.com>
 <CGME20220505061146epcas5p3919c48d58d353a62a5858ee10ad162a0@epcas5p3.samsung.com>
 <20220505060616.803816-3-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505060616.803816-3-joshi.k@samsung.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 05, 2022 at 11:36:13AM +0530, Kanchan Joshi wrote:
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

This way looks a bit fragile.

blk_mq_request_bypass_insert() is called for dispatching io request too,
such as blk_insert_cloned_request(), then the request may be inserted to
scheduler finally from blk_mq_flush_plug_list().

Another issue in blk_execute_rq(), the request may stay in plug list
before polling, then hang forever.

Just wondering why not adding the pt request to plug in blk_execute_rq_nowait()
explicitly?


Thanks, 
Ming

