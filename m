Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877577589C7
	for <lists+io-uring@lfdr.de>; Wed, 19 Jul 2023 01:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjGRX4n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jul 2023 19:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbjGRX4a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jul 2023 19:56:30 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6635253
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 16:53:40 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b89600a37fso39203455ad.2
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 16:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689724260; x=1692316260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ez9intjtxjYak8uRtr3zqkB1irxR9pxxyDUK+M4QLY=;
        b=PsZG4b3OmO9q/q7apB+Tp0HI6XN1xRghQb57aIiw7zBABxqaUczq1kESDUdIxjMos5
         kf0MV4/m0EsGtxCF6WoaOY/iDx1bihMOco4FXOtstix6zfQLQlm0OHCcSr8EWJSYLAWH
         GRWbQiOg4DdL2VtfWy4DPv4ARs3banH6B81xc5X90ZIcvSZE6h1H3ZUOGGOE6diNMquP
         Mxsne5HQgxKIySeEDytTNPWK/MWIyF4+NcmEBEb3Xq0DAULLYrWGif3EawT2uHoRrerN
         R/XGb+DffyhoRe3MrDNZQlwGqJO0U4fx9aRScT0oLSFSwINroIls+ZMhd93pOya9EWRK
         nZmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689724260; x=1692316260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Ez9intjtxjYak8uRtr3zqkB1irxR9pxxyDUK+M4QLY=;
        b=js+oojf+KoTG8yIrIsa+SI+PcW/FlROSWU6Umspk575IPTCkWqUsotC0OkCh8OTlhF
         VF7bxs24Dpt9IB9UkKi/AMr1gPPLcIxmEMJUR8PTg1iBmSlHBmZ4uTLblXKiZZm2Vzgk
         DU6TUP3HFbtv+eSfVyBTcteXzSXVctz/F8KN+8D+K4tPchCXrwlyK3BUyXC8j628V5B5
         +IMZs8MRdGXKA12bS3WbEBtrA3MT/LHqDflwluObqJvG8S5/dmAeXh6U5zH1ULOWm9O6
         3JfCY3JJkRMczyHAWFdqTkJJipJBbi7OgA7zhw/1rs2br59PGwbVO1yfEOVX6ai80UzC
         AP+w==
X-Gm-Message-State: ABy/qLbglh22haAtytIwGzFkC3xUOATzqlnv6SfVSqlTq/aAZpR6Djl8
        q2VoZS4fcubaGT/Wsl7oP15Nww==
X-Google-Smtp-Source: APBJJlECq9GlTxsV46/p2vnTpGyTFZuVAAUfVd16o5DBIb4/f4V8qy3kJrvlQNrkP65Yh9jaRNeHkA==
X-Received: by 2002:a05:6a20:430f:b0:134:3013:cdb5 with SMTP id h15-20020a056a20430f00b001343013cdb5mr760622pzk.35.1689724260282;
        Tue, 18 Jul 2023 16:51:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id c24-20020aa78818000000b00662c4ca18ebsm2038064pfo.128.2023.07.18.16.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 16:50:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qLuT3-007kcs-0p;
        Wed, 19 Jul 2023 09:50:57 +1000
Date:   Wed, 19 Jul 2023 09:50:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de
Subject: Re: [PATCH 5/5] iomap: support IOCB_DIO_DEFER
Message-ID: <ZLclYR9AtKQXcGFJ@dread.disaster.area>
References: <20230718194920.1472184-1-axboe@kernel.dk>
 <20230718194920.1472184-7-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718194920.1472184-7-axboe@kernel.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 18, 2023 at 01:49:20PM -0600, Jens Axboe wrote:
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
> --cpus_allowed=4 --ioengine=io_uring --iodepth=16
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

Nice.

> which shows nice wins all around. If we factored in per-IOP efficiency,
> the wins look even nicer. This becomes apparent as queue depth rises,
> as the offloaded workqueue completions runs out of steam.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/iomap/direct-io.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 92b9b9db8b67..ed615177e1f6 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -131,6 +131,11 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
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
> @@ -167,6 +172,25 @@ void iomap_dio_bio_end_io(struct bio *bio)
>  		} else if ((dio->flags & IOMAP_DIO_INLINE_COMP) && in_task()) {
>  			WRITE_ONCE(dio->iocb->private, NULL);
>  			iomap_dio_complete_work(&dio->aio.work);
> +		} else if ((dio->flags & IOMAP_DIO_INLINE_COMP) &&
> +			   (iocb->ki_flags & IOCB_DIO_DEFER)) {
> +			/* only polled IO cares about private cleared */
> +			iocb->private = dio;
> +			iocb->dio_complete = iomap_dio_deferred_complete;
> +			/*
> +			 * Invoke ->ki_complete() directly. We've assigned
> +			 * out dio_complete callback handler, and since the
> +			 * issuer set IOCB_DIO_DEFER, we know their
> +			 * ki_complete handler will notice ->dio_complete
> +			 * being set and will defer calling that handler
> +			 * until it can be done from a safe task context.
> +			 *
> +			 * Note that the 'res' being passed in here is
> +			 * not important for this case. The actual completion
> +			 * value of the request will be gotten from dio_complete
> +			 * when that is run by the issuer.
> +			 */
> +			iocb->ki_complete(iocb, 0);
>  		} else {
>  			struct inode *inode = file_inode(iocb->ki_filp);
>  

Hmmm. No problems with the change, but all the special cases is
making the completion function a bit of a mess.

Given that all read DIOs use inline completions, we can largely
simplify the completion down to just looking at
dio->wait_for_completion and IOMAP_DIO_COMPLETE_INLINE, and not
caring about what type of IO is being completed at all.

Hence I think that at the end of this series, the completion
function should look something like this:

void iomap_dio_bio_end_io(struct bio *bio)
{
	struct iomap_dio *dio = bio->bi_private;
	struct kiocb *iocb = dio->iocb;
	bool should_dirty = (dio->flags & IOMAP_DIO_DIRTY);
	ssize_t result = 0;

	if (bio->bi_status)
		iomap_dio_set_error(dio, blk_status_to_errno(bio->bi_status));

	if (!atomic_dec_and_test(&dio->ref))
		goto release_bio;

	/* Synchronous IO completion. */
	if (dio->wait_for_completion) {
		struct task_struct *waiter = dio->submit.waiter;
		WRITE_ONCE(dio->submit.waiter, NULL);
		blk_wake_io_task(waiter);
		goto release_bio;
	}

	/*
	 * Async DIO completion that requires filesystem level
	 * completion work gets punted to a work queue to complete
	 * as the operation may require more IO to be issued to
	 * finalise filesystem metadata changes or guarantee data
	 * integrity.
	 */
	if (!(dio->flags & IOMAP_DIO_COMPLETE_INLINE)) {
		struct inode *inode = file_inode(iocb->ki_filp);

		WRITE_ONCE(iocb->private, NULL);
		INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
		queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
		goto release_bio;
	}

	/*
	 * Inline completion for async DIO.
	 *
	 * If the IO submitter is running DIO completions directly
	 * itself, set up the callback it needs. The value we pass
	 * to .ki_complete in this case does not matter, the defered
	 * completion will pull the result from the completion
	 * callback we provide.
	 *
	 * Otherwise, run the dio completion directly, then pass the
	 * result to the iocb completion function to finish the IO.
	 */
	if (iocb->ki_flags & IOCB_DEFER_DIO) {
		WRITE_ONCE(iocb->private, dio);
		iocb->dio_complete = iomap_dio_deferred_complete;
	} else {
		WRITE_ONCE(dio->iocb->private, NULL);
		result = iomap_dio_complete(dio);
	}
	iocb->ki_complete(iocb, result);

release_bio:
	if (should_dirty) {
		bio_check_pages_dirty(bio);
	} else {
		bio_release_pages(bio, false);
		bio_put(bio);
	}
}

-Dave.
-- 
Dave Chinner
david@fromorbit.com
