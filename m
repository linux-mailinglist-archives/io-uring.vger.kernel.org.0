Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED44231FF87
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 20:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhBSTlr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 14:41:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229765AbhBSTlr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 14:41:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613763620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bs7S2E20DJwyOK6XIPGdAph5cz5A2jlVdAjpHfdozmU=;
        b=TPjtRjseiU5MgcgTgUKUo7ZBj/XKhu3oMbgk/6800JL4/VEYoUj9o6fHjOB1RT5uXpoldg
        S3Pro0e7p1E0sQPJP5AppRUaBnSxR2+zGMylGNJnyV9YMTc5hKgDot25fGPnUIH62t33lw
        rq225UyMI6akthK0659Y1kMEFurXsd4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-V82hEyd7PtSvzvDIKNIU7g-1; Fri, 19 Feb 2021 14:40:16 -0500
X-MC-Unique: V82hEyd7PtSvzvDIKNIU7g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 642168DB095;
        Fri, 19 Feb 2021 19:39:28 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 556CC60C79;
        Fri, 19 Feb 2021 19:38:39 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 11JJcccc006464;
        Fri, 19 Feb 2021 14:38:38 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 11JJcc89006460;
        Fri, 19 Feb 2021 14:38:38 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Fri, 19 Feb 2021 14:38:38 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
cc:     snitzer@redhat.com, axboe@kernel.dk, caspar@linux.alibaba.com,
        hch@lst.de, linux-block@vger.kernel.org,
        joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v3 11/11] dm: fastpath of bio-based polling
In-Reply-To: <20210208085243.82367-12-jefflexu@linux.alibaba.com>
Message-ID: <alpine.LRH.2.02.2102191351200.10545@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com> <20210208085243.82367-12-jefflexu@linux.alibaba.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On Mon, 8 Feb 2021, Jeffle Xu wrote:

> Offer one fastpath of bio-based polling when bio submitted to dm device
> is not split.
> 
> In this case, there will be only one bio submitted to only one polling
> hw queue of one underlying mq device, and thus we don't need to track
> all split bios or iterate through all polling hw queues. The pointer to
> the polling hw queue the bio submitted to is returned here as the
> returned cookie.

This doesn't seem safe - note that between submit_bio() and blk_poll(), no 
locks are held - so the device mapper device may be reconfigured 
arbitrarily. When you call blk_poll() with a pointer returned by 
submit_bio(), the pointer may point to a stale address.

Mikulas

> In this case, the polling routine will call
> mq_ops->poll() directly with the hw queue converted from the input
> cookie.
> 
> If the original bio submitted to dm device is split to multiple bios and
> thus submitted to multiple polling hw queues, the bio submission routine
> will return BLK_QC_T_BIO_MULTI, while the polling routine will fall
> back to iterating all hw queues (in polling mode) of all underlying mq
> devices.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  block/blk-core.c          | 33 +++++++++++++++++++++++++++++++--
>  include/linux/blk_types.h |  8 ++++++++
>  include/linux/types.h     |  2 +-
>  3 files changed, 40 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 37aa513da5f2..cb24b33a4870 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -956,11 +956,19 @@ static blk_qc_t __submit_bio(struct bio *bio)
>   * bio_list_on_stack[0] contains bios submitted by the current ->submit_bio.
>   * bio_list_on_stack[1] contains bios that were submitted before the current
>   *	->submit_bio_bio, but that haven't been processed yet.
> + *
> + * Return:
> + *   - BLK_QC_T_NONE, no need for IO polling.
> + *   - BLK_QC_T_BIO_MULTI, @bio gets split and enqueued into multi hw queues.
> + *   - Otherwise, @bio is not split, returning the pointer to the corresponding
> + *     hw queue that the bio enqueued into as the returned cookie.
>   */
>  static blk_qc_t __submit_bio_noacct(struct bio *bio)
>  {
>  	struct bio_list bio_list_on_stack[2];
>  	blk_qc_t ret = BLK_QC_T_NONE;
> +	struct request_queue *top_q = bio->bi_disk->queue;
> +	bool poll_on = test_bit(QUEUE_FLAG_POLL, &top_q->queue_flags);
>  
>  	BUG_ON(bio->bi_next);
>  
> @@ -968,6 +976,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>  	current->bio_list = bio_list_on_stack;
>  
>  	do {
> +		blk_qc_t cookie;
>  		struct request_queue *q = bio->bi_disk->queue;
>  		struct bio_list lower, same;
>  
> @@ -980,7 +989,20 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>  		bio_list_on_stack[1] = bio_list_on_stack[0];
>  		bio_list_init(&bio_list_on_stack[0]);
>  
> -		ret = __submit_bio(bio);
> +		cookie = __submit_bio(bio);
> +
> +		if (poll_on &&
> +		    blk_qc_t_bio_valid(ret) && blk_qc_t_valid(cookie)) {
> +			unsigned int queue_num = blk_qc_t_to_queue_num(cookie);
> +			struct blk_mq_hw_ctx *hctx = q->queue_hw_ctx[queue_num];
> +
> +			cookie = (blk_qc_t)hctx;
> +
> +			if (!blk_qc_t_valid(ret)) /* set initial value */
> +				ret = cookie;
> +			else if (ret != cookie)   /* bio got split */
> +				ret = BLK_QC_T_BIO_MULTI;
> +		}
>  
>  		/*
>  		 * Sort new bios into those for a lower level and those for the
> @@ -1003,6 +1025,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>  	} while ((bio = bio_list_pop(&bio_list_on_stack[0])));
>  
>  	current->bio_list = NULL;
> +
>  	return ret;
>  }
>  
> @@ -1142,7 +1165,13 @@ static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>  	do {
>  		int ret;
>  
> -		ret = disk->fops->poll(q, cookie);
> +		if (blk_qc_t_bio_valid(cookie)) {
> +			struct blk_mq_hw_ctx *hctx = (struct blk_mq_hw_ctx *)cookie;
> +			struct request_queue *target_q = hctx->queue;
> +
> +			ret = blk_mq_poll_hctx(target_q, hctx);
> +		} else
> +			ret = disk->fops->poll(q, cookie);
>  		if (ret > 0) {
>  			__set_current_state(TASK_RUNNING);
>  			return ret;
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 2e05244fc16d..4173754532c0 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -557,6 +557,14 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
>  	return (cookie & BLK_QC_T_INTERNAL) != 0;
>  }
>  
> +/* Macros for blk_qc_t used for bio-based polling */
> +#define BLK_QC_T_BIO_MULTI	-2U
> +
> +static inline bool blk_qc_t_bio_valid(blk_qc_t cookie)
> +{
> +	return cookie != BLK_QC_T_BIO_MULTI;
> +}
> +
>  struct blk_rq_stat {
>  	u64 mean;
>  	u64 min;
> diff --git a/include/linux/types.h b/include/linux/types.h
> index da5ca7e1bea9..f6301014a459 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -126,7 +126,7 @@ typedef u64 sector_t;
>  typedef u64 blkcnt_t;
>  
>  /* cookie used for IO polling */
> -typedef unsigned int blk_qc_t;
> +typedef uintptr_t blk_qc_t;
>  
>  /*
>   * The type of an index into the pagecache.
> -- 
> 2.27.0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 

