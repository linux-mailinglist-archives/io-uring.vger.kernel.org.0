Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C02075CB26
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 17:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbjGUPNw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 11:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjGUPNu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 11:13:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD5130D2;
        Fri, 21 Jul 2023 08:13:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DF65617C0;
        Fri, 21 Jul 2023 15:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE511C433C7;
        Fri, 21 Jul 2023 15:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689952420;
        bh=Udwimq2/DNtgNkAAjycBbJW8qZ4UVSkEscoLiVk8CfU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J+pebEjjX5KU9AeHbriANSzmJiTpzZzzufIh5eZa9tztXP3AYAKW1Yl9QuOmZMJ1e
         nYlL2QP/TS3F9MxtyOqphbA13o4Sd80cXfHAxEOvSOwZJ9X0dOLTo79QGPH3ilAUNL
         qEPXij6S0hpPgyBKRU+DvlAxvd2FeuFb7M+wzknbfpeuxzdJTrY8O3MaD2iSDtb7AQ
         viKGdork/o6r9+XNmikQpX/Mqe4xFsFHnQQDscr+QEcyy+oE3mYlOnTmBCfTPqnKXR
         J9qqcx68x5aiJbWxyEkIluhfLloKLivyaUp332vo0WGhtKMCO7Xk1NEZsEsOAM3VON
         BIvQpo+b1z+yw==
Date:   Fri, 21 Jul 2023 08:13:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 1/8] iomap: cleanup up iomap_dio_bio_end_io()
Message-ID: <20230721151340.GK11352@frogsfrogsfrogs>
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720181310.71589-2-axboe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 20, 2023 at 12:13:03PM -0600, Jens Axboe wrote:
> Make the logic a bit easier to follow:
> 
> 1) Add a release_bio out path, as everybody needs to touch that, and
>    have our bio ref check jump there if it's non-zero.
> 2) Add a kiocb local variable.
> 3) Add comments for each of the three conditions (sync, inline, or
>    async workqueue punt).
> 
> No functional changes in this patch.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Thanks for deindentifying this,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/direct-io.c | 46 +++++++++++++++++++++++++++++---------------
>  1 file changed, 31 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index ea3b868c8355..0ce60e80c901 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -152,27 +152,43 @@ void iomap_dio_bio_end_io(struct bio *bio)
>  {
>  	struct iomap_dio *dio = bio->bi_private;
>  	bool should_dirty = (dio->flags & IOMAP_DIO_DIRTY);
> +	struct kiocb *iocb = dio->iocb;
>  
>  	if (bio->bi_status)
>  		iomap_dio_set_error(dio, blk_status_to_errno(bio->bi_status));
> +	if (!atomic_dec_and_test(&dio->ref))
> +		goto release_bio;
>  
> -	if (atomic_dec_and_test(&dio->ref)) {
> -		if (dio->wait_for_completion) {
> -			struct task_struct *waiter = dio->submit.waiter;
> -			WRITE_ONCE(dio->submit.waiter, NULL);
> -			blk_wake_io_task(waiter);
> -		} else if (dio->flags & IOMAP_DIO_WRITE) {
> -			struct inode *inode = file_inode(dio->iocb->ki_filp);
> -
> -			WRITE_ONCE(dio->iocb->private, NULL);
> -			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
> -			queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
> -		} else {
> -			WRITE_ONCE(dio->iocb->private, NULL);
> -			iomap_dio_complete_work(&dio->aio.work);
> -		}
> +	/*
> +	 * Synchronous dio, task itself will handle any completion work
> +	 * that needs after IO. All we need to do is wake the task.
> +	 */
> +	if (dio->wait_for_completion) {
> +		struct task_struct *waiter = dio->submit.waiter;
> +
> +		WRITE_ONCE(dio->submit.waiter, NULL);
> +		blk_wake_io_task(waiter);
> +		goto release_bio;
> +	}
> +
> +	/* Read completion can always complete inline. */
> +	if (!(dio->flags & IOMAP_DIO_WRITE)) {
> +		WRITE_ONCE(iocb->private, NULL);
> +		iomap_dio_complete_work(&dio->aio.work);
> +		goto release_bio;
>  	}
>  
> +	/*
> +	 * Async DIO completion that requires filesystem level completion work
> +	 * gets punted to a work queue to complete as the operation may require
> +	 * more IO to be issued to finalise filesystem metadata changes or
> +	 * guarantee data integrity.
> +	 */
> +	WRITE_ONCE(iocb->private, NULL);
> +	INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
> +	queue_work(file_inode(iocb->ki_filp)->i_sb->s_dio_done_wq,
> +			&dio->aio.work);
> +release_bio:
>  	if (should_dirty) {
>  		bio_check_pages_dirty(bio);
>  	} else {
> -- 
> 2.40.1
> 
