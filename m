Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FFA75D6B7
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 23:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjGUVnu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 17:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjGUVnt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 17:43:49 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD8E2D7E
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 14:43:48 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-66872d4a141so1635218b3a.1
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 14:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689975828; x=1690580628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J0JhVqzVbq0nTl0YRA33W/tnP6+MiSZVg5v0O0qkG8U=;
        b=lQQ0RVZCHpv2AGVQXOVTO08oKgkBZBJXAqHQOgrbHSU3az4rdgwa4tlfjkb+sbe6i+
         +Hq74RIcDKHqiO99SAadELf9V3MobKm6l1Q7HHCWh42xcNVbpbY79pjllJqUSlrpWjiE
         Bnyv1kU6ZiilQ7h5h7kODwnwlCKgt6+EjDUyK+wZ1LbPfEvhVJ/5Kn5yCnlBVIQDcHNn
         vH20v7bQRi89s7fJG8zmDxFZGrr/2zN7n/DsV61Tt8eR7kGYXy+A1588PTRJWcolk9nY
         Hzu5ZYCuTDBipfDTuEmZWcCRU8ODRQ1Svbg9prCC3/zdbxDgcfGYN3exHKr8nipruHjB
         TmSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689975828; x=1690580628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J0JhVqzVbq0nTl0YRA33W/tnP6+MiSZVg5v0O0qkG8U=;
        b=Ha8guZbUDI8roatJrzOgxn+c6RPYJy+At7HZcYqk0NJjgcZHHdtJ8Co+dLLf8KHvx7
         isH2MDfUxqK6JhAUFMaBu0I2CEhi+ZL8pbjj23HY9/cKTFF/+pIz+OBMIvZeTW3AkyQ8
         9hRpE/v0EpgQ6d0HaChs7cmpe0g7G2/sZl9VanRs2x6V2kQLnMdlSnFhgFXLPa+JVKGl
         6jdd8lfJE9fghKS4Og8WL6B0xXp7O3tl8syD99eWR14nQATUj1BGivYaZzR9ooLW6L2j
         ugW2tQ0pxdZ78y7v/YJka66OoLukZ/yYkbQwHX/WXWzibQR48Ywyq3vEYkIkHakYU+bP
         IC9Q==
X-Gm-Message-State: ABy/qLaIxqiIb8ew3jABAKxbGzvVSc7xuutqrh4jO8xaueDzSA/CFWlg
        bn6gZbtg20JvIXW1aLIjTnbqLw==
X-Google-Smtp-Source: APBJJlGTlCMacuZh+LdRlHAJWUBL4EYX0nxTHw/62SwlKOiEK4rhWSsZpCmje58HeCY0380SRXNfuw==
X-Received: by 2002:a05:6a00:3917:b0:668:6eed:7c0f with SMTP id fh23-20020a056a00391700b006686eed7c0fmr1334982pfb.12.1689975827481;
        Fri, 21 Jul 2023 14:43:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id y10-20020aa7804a000000b006862af32fbesm3551001pfm.14.2023.07.21.14.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 14:43:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qMxuZ-008uln-2Q;
        Sat, 22 Jul 2023 07:43:43 +1000
Date:   Sat, 22 Jul 2023 07:43:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de
Subject: Re: [PATCH 4/8] iomap: completed polled IO inline
Message-ID: <ZLr8D60gYqDrHl21@dread.disaster.area>
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720181310.71589-5-axboe@kernel.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 20, 2023 at 12:13:06PM -0600, Jens Axboe wrote:
> Polled IO is only allowed for conditions where task completion is safe
> anyway, so we can always complete it inline. This cannot easily be
> checked with a submission side flag, as the block layer may clear the
> polled flag and turn it into a regular IO instead. Hence we need to
> check this at completion time. If REQ_POLLED is still set, then we know
> that this IO was successfully polled, and is completing in task context.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/iomap/direct-io.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 9f97d0d03724..c3ea1839628f 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -173,9 +173,19 @@ void iomap_dio_bio_end_io(struct bio *bio)
>  	}
>  
>  	/*
> -	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline
> +	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline.
> +	 * Ditto for polled requests - if the flag is still at completion
> +	 * time, then we know the request was actually polled and completion
> +	 * is called from the task itself. This is why we need to check it
> +	 * here rather than flag it at issue time.
>  	 */
> -	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
> +	if ((dio->flags & IOMAP_DIO_INLINE_COMP) || (bio->bi_opf & REQ_POLLED)) {

This still smells wrong to me. Let me see if I can work out why...

<spelunk!>

When we set up the IO in iomap_dio_bio_iter(), we do this:

        /*
         * We can only poll for single bio I/Os.
         */
        if (need_zeroout ||
            ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
                dio->iocb->ki_flags &= ~IOCB_HIPRI;

The "need_zeroout" covers writes into unwritten regions that require
conversion at IO completion, and the latter check is for writes
extending EOF. i.e. this covers the cases where we have dirty
metadata for this specific write and so may need transactions or
journal/metadata IO during IO completion.

The only case it doesn't cover is clearing IOCB_HIPRI for O_DSYNC IO
that may require a call to generic_write_sync() in completion. That
is, if we aren't using FUA, will not have IOMAP_DIO_INLINE_COMP set,
but still do polled IO.

I think this is a bug. We don't want to be issuing more IO in
REQ_POLLED task context during IO completion, and O_DSYNC IO
completion for non-FUA IO requires a journal flush and that can
issue lots of journal IO and wait on it in completion process.

Hence I think we should only be setting REQ_POLLED in the cases
where IOCB_HIPRI and IOMAP_DIO_INLINE_COMP are both set.  If
IOMAP_DIO_INLINE_COMP is set on the dio, then it doesn't matter what
context we are in at completion time or whether REQ_POLLED was set
or cleared during the IO....

That means the above check should be:

        /*
         * We can only poll for single bio I/Os that can run inline
	 * completion.
         */
        if (need_zeroout ||
	    (iocb_is_dsync(dio->iocb) && !use_fua) ||
            ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
                dio->iocb->ki_flags &= ~IOCB_HIPRI;

or if we change the logic such that calculate IOMAP_DIO_INLINE_COMP
first:

	if (!(dio->flags & IOMAP_DIO_INLINE_COMP))
		dio->iocb->ki_flags &= ~IOCB_HIPRI;

Then we don't need to care about polled IO on the completion side at
all at the iomap layer because it doesn't change the completion
requirements at all...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
