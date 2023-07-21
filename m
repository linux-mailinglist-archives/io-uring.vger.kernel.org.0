Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8E675CBD7
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 17:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbjGUPfS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 11:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjGUPfR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 11:35:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A9730DD;
        Fri, 21 Jul 2023 08:35:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5844461D06;
        Fri, 21 Jul 2023 15:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1666C433C7;
        Fri, 21 Jul 2023 15:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689953715;
        bh=XK+rZDy092BG0paL9xtt7YLxixe+rSDeXeuTZ7XKhCY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a+8Pv0oof2/kxjFqbMJvgjlKz36HWezvYQMr9Ly9aNbSyN+03RX4HUaqmeevdYCnM
         OChr/cxIIPxOpZzNQ/XlavEgX98+nXTesdzueF8SEZcAwYp/r5xBBqHoZwmWUeI2s3
         D3dNCIckdLwg/jOO/fqlcsQwhi331TCRCo0wPGxonvqAqFPQP+IQYF5o5M8A84CoHZ
         L2jMeMOFMLghQWRuGua7/30Gypux6pbSs7GUIYd+4SyPTghUaMHs9ETz68/MtDYTeM
         1D2WmpzflssMEXL6gpO0dVTTBmF/wNfU+fSVFTJ306fhRs+EdxQ2ymKn/87I0VI0ne
         IJLruKbauGkOg==
Date:   Fri, 21 Jul 2023 08:35:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 5/8] iomap: only set iocb->private for polled bio
Message-ID: <20230721153515.GN11352@frogsfrogsfrogs>
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-6-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720181310.71589-6-axboe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 20, 2023 at 12:13:07PM -0600, Jens Axboe wrote:
> iocb->private is only used for polled IO, where the completer will
> find the bio to poll through that field.
> 
> Assign it when we're submitting a polled bio, and get rid of the
> dio->poll_bio indirection.

IIRC, the only time iomap actually honors HIPRI requests from the iocb
is if the entire write can be satisfied with a single bio -- no zeroing
around, no dirty file metadata, no writes past EOF, no unwritten blocks,
etc.  Right?

There was only ever going to be one assign to dio->submit.poll_bio,
which means the WRITE_ONCE isn't going to overwrite some non-NULL value.
Correct?

All this does is remove the indirection like you said.

If the answers are {yes, yes} then I understand the HIPRI mechanism
enough to say

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/iomap/direct-io.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index c3ea1839628f..cce9af019705 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -42,7 +42,6 @@ struct iomap_dio {
>  		struct {
>  			struct iov_iter		*iter;
>  			struct task_struct	*waiter;
> -			struct bio		*poll_bio;
>  		} submit;
>  
>  		/* used for aio completion: */
> @@ -64,12 +63,14 @@ static struct bio *iomap_dio_alloc_bio(const struct iomap_iter *iter,
>  static void iomap_dio_submit_bio(const struct iomap_iter *iter,
>  		struct iomap_dio *dio, struct bio *bio, loff_t pos)
>  {
> +	struct kiocb *iocb = dio->iocb;
> +
>  	atomic_inc(&dio->ref);
>  
>  	/* Sync dio can't be polled reliably */
> -	if ((dio->iocb->ki_flags & IOCB_HIPRI) && !is_sync_kiocb(dio->iocb)) {
> -		bio_set_polled(bio, dio->iocb);
> -		dio->submit.poll_bio = bio;
> +	if ((iocb->ki_flags & IOCB_HIPRI) && !is_sync_kiocb(iocb)) {
> +		bio_set_polled(bio, iocb);
> +		WRITE_ONCE(iocb->private, bio);
>  	}
>  
>  	if (dio->dops && dio->dops->submit_io)
> @@ -197,7 +198,6 @@ void iomap_dio_bio_end_io(struct bio *bio)
>  	 * more IO to be issued to finalise filesystem metadata changes or
>  	 * guarantee data integrity.
>  	 */
> -	WRITE_ONCE(iocb->private, NULL);
>  	INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
>  	queue_work(file_inode(iocb->ki_filp)->i_sb->s_dio_done_wq,
>  			&dio->aio.work);
> @@ -536,7 +536,6 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  
>  	dio->submit.iter = iter;
>  	dio->submit.waiter = current;
> -	dio->submit.poll_bio = NULL;
>  
>  	if (iocb->ki_flags & IOCB_NOWAIT)
>  		iomi.flags |= IOMAP_NOWAIT;
> @@ -648,8 +647,6 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	if (dio->flags & IOMAP_DIO_STABLE_WRITE)
>  		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
>  
> -	WRITE_ONCE(iocb->private, dio->submit.poll_bio);
> -
>  	/*
>  	 * We are about to drop our additional submission reference, which
>  	 * might be the last reference to the dio.  There are three different
> -- 
> 2.40.1
> 
