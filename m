Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D70575DF3A
	for <lists+io-uring@lfdr.de>; Sun, 23 Jul 2023 01:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjGVXFZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Jul 2023 19:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjGVXFY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Jul 2023 19:05:24 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F18E0
        for <io-uring@vger.kernel.org>; Sat, 22 Jul 2023 16:05:23 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-666ecb21f86so2923594b3a.3
        for <io-uring@vger.kernel.org>; Sat, 22 Jul 2023 16:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690067123; x=1690671923;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BYcKh3CigA2XfZupwu14HyozmnMVJFZ6G2nMtPKtxjw=;
        b=djEAUymjYKHpEKgrOXZcC+jbQ7pyoe1ePPxcY1MjOggXdsn8QIIRONV39+Pl5fr64y
         HDZvnRSyJxknmGY0Iu5H4RihgydDbFCN+Rf0beKgVt4xqbo73O3+gYa3rdJesNZvdXZg
         mqWHeyOE4xEPZZCR2bWjH/D1aanLxLYoTKqMjJbPq5uGcr6k8CN9mg7JlRlpg8t3GRPu
         1+8Ka2fkv0Qa5FZzbCddoyhXASYKr+1v4ngOfLphfw1iB8cFowkOy4xdJ0an/hwnHeWu
         q4GpHN8WYsaO8ikhMDGbGO1IZ1xJOdT67Huo+2FZiRhRi2t57az9putaFbyhI7ikKCEc
         ZDjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690067123; x=1690671923;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BYcKh3CigA2XfZupwu14HyozmnMVJFZ6G2nMtPKtxjw=;
        b=eJpZPfuP1Af/QWWW7vNHuxBR3dWe2sB1CpKgl6hi93hE3cl/x1xCPaBk/JxbreAvUn
         w//GD3HvdqCFbArk5kTanjSyJ3uMRT08ywXdfbfpyHKuOb4uSEaOwtGGqSu6bqPxMWrO
         1IXWUTXwQGFJ9WcVLOfBpeDvoHdenLLUYQaBqJ6UilRmlIWNGow7N+RyAbYVKTqJGV2V
         BPSL43dN/OxkeTPpBe0pNDDZnjxQDDrTGNfin/AVpApCNx9dTpFT0NRw7vdpaE1xk64D
         kP0gFIfmdZxodfiHP+fUGHufhQhvB3Gb2shleaTda6PKiXooWNKIKahpAangm0MkeT2o
         +n8w==
X-Gm-Message-State: ABy/qLZBPJn4xx7gLgw4/uuO3ds9Vt4DR4uRiI3cJBMRqrYmr1AWEv8I
        UDvmAnP3LdgQIhz6jOPvyvAiV6FCy2mGawZ8mDk=
X-Google-Smtp-Source: APBJJlEsh+0pA9YO+xx3v86k6qSY5+YHQKqY3elqdQGTvg7SEo+jtLOxETYyaiAVCXsdH5W6arMp+g==
X-Received: by 2002:a17:903:22c4:b0:1b6:797d:33fb with SMTP id y4-20020a17090322c400b001b6797d33fbmr7774537plg.64.1690067122646;
        Sat, 22 Jul 2023 16:05:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id t14-20020a170902b20e00b001b9da7b6bc3sm5860800plr.184.2023.07.22.16.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jul 2023 16:05:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qNLf4-009KlO-2j;
        Sun, 23 Jul 2023 09:05:18 +1000
Date:   Sun, 23 Jul 2023 09:05:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de
Subject: Re: [PATCH 4/8] iomap: completed polled IO inline
Message-ID: <ZLxgrnvsVPJYBJ1L@dread.disaster.area>
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-5-axboe@kernel.dk>
 <ZLr8D60gYqDrHl21@dread.disaster.area>
 <fe2754d6-04d0-ce69-d7b2-6e6af7cfb140@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe2754d6-04d0-ce69-d7b2-6e6af7cfb140@kernel.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 21, 2023 at 09:10:57PM -0600, Jens Axboe wrote:
> On 7/21/23 3:43?PM, Dave Chinner wrote:
> > On Thu, Jul 20, 2023 at 12:13:06PM -0600, Jens Axboe wrote:
> >> Polled IO is only allowed for conditions where task completion is safe
> >> anyway, so we can always complete it inline. This cannot easily be
> >> checked with a submission side flag, as the block layer may clear the
> >> polled flag and turn it into a regular IO instead. Hence we need to
> >> check this at completion time. If REQ_POLLED is still set, then we know
> >> that this IO was successfully polled, and is completing in task context.
> >>
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >> ---
> >>  fs/iomap/direct-io.c | 14 ++++++++++++--
> >>  1 file changed, 12 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> >> index 9f97d0d03724..c3ea1839628f 100644
> >> --- a/fs/iomap/direct-io.c
> >> +++ b/fs/iomap/direct-io.c
> >> @@ -173,9 +173,19 @@ void iomap_dio_bio_end_io(struct bio *bio)
> >>  	}
> >>  
> >>  	/*
> >> -	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline
> >> +	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline.
> >> +	 * Ditto for polled requests - if the flag is still at completion
> >> +	 * time, then we know the request was actually polled and completion
> >> +	 * is called from the task itself. This is why we need to check it
> >> +	 * here rather than flag it at issue time.
> >>  	 */
> >> -	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
> >> +	if ((dio->flags & IOMAP_DIO_INLINE_COMP) || (bio->bi_opf & REQ_POLLED)) {
> > 
> > This still smells wrong to me. Let me see if I can work out why...
> > 
> > <spelunk!>
> > 
> > When we set up the IO in iomap_dio_bio_iter(), we do this:
> > 
> >         /*
> >          * We can only poll for single bio I/Os.
> >          */
> >         if (need_zeroout ||
> >             ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
> >                 dio->iocb->ki_flags &= ~IOCB_HIPRI;
> > 
> > The "need_zeroout" covers writes into unwritten regions that require
> > conversion at IO completion, and the latter check is for writes
> > extending EOF. i.e. this covers the cases where we have dirty
> > metadata for this specific write and so may need transactions or
> > journal/metadata IO during IO completion.
> > 
> > The only case it doesn't cover is clearing IOCB_HIPRI for O_DSYNC IO
> > that may require a call to generic_write_sync() in completion. That
> > is, if we aren't using FUA, will not have IOMAP_DIO_INLINE_COMP set,
> > but still do polled IO.
> > 
> > I think this is a bug. We don't want to be issuing more IO in
> > REQ_POLLED task context during IO completion, and O_DSYNC IO
> > completion for non-FUA IO requires a journal flush and that can
> > issue lots of journal IO and wait on it in completion process.
> > 
> > Hence I think we should only be setting REQ_POLLED in the cases
> > where IOCB_HIPRI and IOMAP_DIO_INLINE_COMP are both set.  If
> > IOMAP_DIO_INLINE_COMP is set on the dio, then it doesn't matter what
> > context we are in at completion time or whether REQ_POLLED was set
> > or cleared during the IO....
> > 
> > That means the above check should be:
> > 
> >         /*
> >          * We can only poll for single bio I/Os that can run inline
> > 	 * completion.
> >          */
> >         if (need_zeroout ||
> > 	    (iocb_is_dsync(dio->iocb) && !use_fua) ||
> >             ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
> >                 dio->iocb->ki_flags &= ~IOCB_HIPRI;
> 
> Looks like you are right, it would not be a great idea to handle that
> off polled IO completion. It'd work just fine, but anything generating
> more IO should go to a helper. I'll make that change.
> 
> > or if we change the logic such that calculate IOMAP_DIO_INLINE_COMP
> > first:
> > 
> > 	if (!(dio->flags & IOMAP_DIO_INLINE_COMP))
> > 		dio->iocb->ki_flags &= ~IOCB_HIPRI;
> > 
> > Then we don't need to care about polled IO on the completion side at
> > all at the iomap layer because it doesn't change the completion
> > requirements at all...
> 
> That still isn't true, because you can still happily issue as polled IO
> and get it cleared and now have an IRQ based completion. This would work
> for most cases, but eg xfs dio end_io handler will grab:
> 
> spin_lock(&ip->i_flags_lock);
> 
> if the inode got truncated. Maybe that can't happen because we did
> inode_dio_begin() higher up?

Yes, truncate, hole punch, etc block on inode_dio_wait() with the
i_rwsem held which means it blocks new DIO submissions and waits
until all in-flight DIO before the truncate operation starts.
inode_dio_complete() does not get called until after the filesystem
->endio completion has run, so there's no possibility of
truncate-like operations actually racing with DIO completion at
all...

> Still seems saner to check for the polled
> flag at completion to me...

I disagree. If truncate (or anything that removes extents or reduces
inode size) is running whilst DIO to that range is still in
progress, we have a use-after-free situation that will cause data
and/or filesystem corruption. It's just not a safe thing to allow,
so we prevent it from occurring at a high level in the filesystem
and the result is that low level IO code just doesn't need to
care about races with layout/size changing operations...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
