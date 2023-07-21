Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56EA275CCF7
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbjGUQBS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbjGUQBJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:01:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3D82D77;
        Fri, 21 Jul 2023 09:01:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08A0B61D24;
        Fri, 21 Jul 2023 16:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6475DC433C8;
        Fri, 21 Jul 2023 16:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689955266;
        bh=DWgArUco9o0uQ0BaLyzqx/PxvU7DMrvrlHy0J3P/+tQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uhlZk5iO/n3R/HDO4BqmqzTUOG6oH1OyhjK1aKxge99nyNgkGyjYM2zSQT29eVf7C
         V+y3aDGTP6L0av4mqUYdAPIyGJoe8S4OaEqvJhTSI3JqP7MdUL9mP972eWiTFcrSMc
         ikHMq45lZOCj6ndEehBE34ytSdzty1RPj7FG2jCMYk84cs9irU3wcL57sMMI7lpx0l
         ux63i8qSEd93zLdn3r/1ksdmjn5BJ2iSbe88S8wQU9GN9Jw+BZoNg0N4KeBFNT97w6
         YIYFplQrrXTqtHi/qq+WHVzpvPLe/JMaY/tgeko4V4myMmuoAfDax6MleCUEg4sEOf
         TwIimWRHRCTHg==
Date:   Fri, 21 Jul 2023 09:01:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 8/8] iomap: support IOCB_DIO_DEFER
Message-ID: <20230721160105.GR11352@frogsfrogsfrogs>
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-9-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720181310.71589-9-axboe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 20, 2023 at 12:13:10PM -0600, Jens Axboe wrote:
> If IOCB_DIO_DEFER is set, utilize that to set kiocb->dio_complete handler
> and data for that callback. Rather than punt the completion to a
> workqueue, we pass back the handler and data to the issuer and will get a
> callback from a safe task context.
> 
> Using the following fio job to randomly dio write 4k blocks at
> queue depths of 1..16:
> 
> fio --name=dio-write --filename=/data1/file --time_based=1 \
> --runtime=10 --bs=4096 --rw=randwrite --norandommap --buffered=0 \
> --cpus_allowed=4 --ioengine=io_uring --iodepth=$depth
> 
> shows the following results before and after this patch:
> 
> 	Stock	Patched		Diff
> =======================================
> QD1	155K	162K		+ 4.5%
> QD2	290K	313K		+ 7.9%
> QD4	533K	597K		+12.0%
> QD8	604K	827K		+36.9%
> QD16	615K	845K		+37.4%

Nice!

> which shows nice wins all around. If we factored in per-IOP efficiency,
> the wins look even nicer. This becomes apparent as queue depth rises,
> as the offloaded workqueue completions runs out of steam.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/iomap/direct-io.c | 54 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 53 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index cce9af019705..de86680968a4 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -20,6 +20,7 @@
>   * Private flags for iomap_dio, must not overlap with the public ones in
>   * iomap.h:
>   */
> +#define IOMAP_DIO_DEFER_COMP	(1 << 26)

IOMAP_DIO_CALLER_COMP, to go with IOCB_CALLER_COMP?

>  #define IOMAP_DIO_INLINE_COMP	(1 << 27)
>  #define IOMAP_DIO_STABLE_WRITE	(1 << 28)
>  #define IOMAP_DIO_NEED_SYNC	(1 << 29)
> @@ -132,6 +133,11 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
>  }
>  EXPORT_SYMBOL_GPL(iomap_dio_complete);
>  
> +static ssize_t iomap_dio_deferred_complete(void *data)
> +{
> +	return iomap_dio_complete(data);
> +}
> +
>  static void iomap_dio_complete_work(struct work_struct *work)
>  {
>  	struct iomap_dio *dio = container_of(work, struct iomap_dio, aio.work);
> @@ -192,6 +198,31 @@ void iomap_dio_bio_end_io(struct bio *bio)
>  		goto release_bio;
>  	}
>  
> +	/*
> +	 * If this dio is flagged with IOMAP_DIO_DEFER_COMP, then schedule
> +	 * our completion that way to avoid an async punt to a workqueue.
> +	 */
> +	if (dio->flags & IOMAP_DIO_DEFER_COMP) {
> +		/* only polled IO cares about private cleared */
> +		iocb->private = dio;
> +		iocb->dio_complete = iomap_dio_deferred_complete;
> +
> +		/*
> +		 * Invoke ->ki_complete() directly. We've assigned out

"We've assigned our..."

> +		 * dio_complete callback handler, and since the issuer set
> +		 * IOCB_DIO_DEFER, we know their ki_complete handler will
> +		 * notice ->dio_complete being set and will defer calling that
> +		 * handler until it can be done from a safe task context.
> +		 *
> +		 * Note that the 'res' being passed in here is not important
> +		 * for this case. The actual completion value of the request
> +		 * will be gotten from dio_complete when that is run by the
> +		 * issuer.
> +		 */
> +		iocb->ki_complete(iocb, 0);
> +		goto release_bio;
> +	}
> +
>  	/*
>  	 * Async DIO completion that requires filesystem level completion work
>  	 * gets punted to a work queue to complete as the operation may require
> @@ -288,12 +319,17 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  		 * after IO completion such as unwritten extent conversion) and
>  		 * the underlying device either supports FUA or doesn't have
>  		 * a volatile write cache. This allows us to avoid cache flushes
> -		 * on IO completion.
> +		 * on IO completion. If we can't use stable writes and need to

"If we can't use writethrough and need to sync..."

> +		 * sync, disable in-task completions as dio completion will
> +		 * need to call generic_write_sync() which will do a blocking
> +		 * fsync / cache flush call.
>  		 */
>  		if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
>  		    (dio->flags & IOMAP_DIO_STABLE_WRITE) &&
>  		    (bdev_fua(iomap->bdev) || !bdev_write_cache(iomap->bdev)))
>  			use_fua = true;
> +		else if (dio->flags & IOMAP_DIO_NEED_SYNC)
> +			dio->flags &= ~IOMAP_DIO_DEFER_COMP;
>  	}
>  
>  	/*
> @@ -319,6 +355,13 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  		pad = pos & (fs_block_size - 1);
>  		if (pad)
>  			iomap_dio_zero(iter, dio, pos - pad, pad);
> +
> +		/*
> +		 * If need_zeroout is set, then this is a new or unwritten
> +		 * extent. These need extra handling at completion time, so

"...then this is a new or unwritten extent, or dirty file metadata have
not been persisted to disk."

> +		 * disable in-task deferred completion for those.
> +		 */
> +		dio->flags &= ~IOMAP_DIO_DEFER_COMP;
>  	}
>  
>  	/*
> @@ -557,6 +600,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		iomi.flags |= IOMAP_WRITE;
>  		dio->flags |= IOMAP_DIO_WRITE;
>  
> +		/*
> +		 * Flag as supporting deferred completions, if the issuer
> +		 * groks it. This can avoid a workqueue punt for writes.
> +		 * We may later clear this flag if we need to do other IO
> +		 * as part of this IO completion.
> +		 */
> +		if (iocb->ki_flags & IOCB_DIO_DEFER)
> +			dio->flags |= IOMAP_DIO_DEFER_COMP;
> +

With those comment clarifications added,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  		if (dio_flags & IOMAP_DIO_OVERWRITE_ONLY) {
>  			ret = -EAGAIN;
>  			if (iomi.pos >= dio->i_size ||
> -- 
> 2.40.1
> 
