Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D2074FD4E
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 04:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbjGLCwH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 22:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjGLCwH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 22:52:07 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF201AE
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 19:52:04 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 5614622812f47-3942c6584f0so4612108b6e.3
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 19:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689130323; x=1691722323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mf0mkOFgMSDkPwJ5Op4385lRYb98hXbQzEVd1CE99/A=;
        b=vLaNnBzWfNrR8NHjxzoEO4LXopsmVi2AarA62UDxQz314OJChSHLz88WABCOQMq5xy
         C1NFHpKysHgA5mk8SBOCNBXjTCzieK2xYu3HMYfzYXrfGHWwCI4IuBK1PEfhkF+U1XwJ
         JWg34WxrwZvSXZ4fVU4vrW/XNh+OTUuYASc64eI7OKFieTLMtDlXrEBIyKdzMcjbu2YW
         nIoK6FaoyWEKEkhnYYixlqDMB5dILP5gObz0eynkMFYsVDDqFShqZpOsq7M+86cfJsnm
         9pbWE0aRlhpUy+G1VvmhCm0xDysvc4i/R1K8FEYktitQa0cj5uG0vWosstmARNJ0iYQb
         CbZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689130323; x=1691722323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mf0mkOFgMSDkPwJ5Op4385lRYb98hXbQzEVd1CE99/A=;
        b=F3FuDA3/dFTTkeldPSi29CWejmZVQ6T5VvIw1EFREGKWAvCjlDFZEKpyF3J5lgtwvs
         AlUZ1kUryTDy6iNLpU6WqL1uMTI3Cu6wD9pjc3Vduwb0Mf9lC0NJbWP3vspbRSj3Q3wh
         MeM4q8dO/cycOQ2kD8wXrfBKj8dcDp+7mPh27WBam1A1e7DNpt+heH65kloPLpEQv4dR
         YAjzPChoYuZ3CvOR5zDJRC+9bwPi1x6jCLUGhRSXhbNLLl7LimnraywhctU3wOmJRqLB
         ApmOyXxFq7N72clKcToZKrf8FZaBZBG8MGskZf+xYyshncIRgpZP8tIQlw4B8GegkyuR
         Hw3w==
X-Gm-Message-State: ABy/qLYcMD+MX4bNysSSS833r3bBcP9QedFHXXurwLtCgGOlY4sMvFCS
        WkdbONxSOIfe2tIMcY/aj7O/fA==
X-Google-Smtp-Source: APBJJlF8KjcSBPgGC8UPuEWcfq5C7JNC/wQ2GnMpOXNsVq76TXZrET30lycQvZndG9Qaj6SI2aoSEw==
X-Received: by 2002:a05:6808:1986:b0:3a1:d656:21c with SMTP id bj6-20020a056808198600b003a1d656021cmr20062427oib.21.1689130323252;
        Tue, 11 Jul 2023 19:52:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-246-40.pa.nsw.optusnet.com.au. [49.180.246.40])
        by smtp.gmail.com with ESMTPSA id u15-20020aa7848f000000b00663ab37ff74sm2383569pfn.72.2023.07.11.19.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 19:52:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qJPxP-0051gD-2h;
        Wed, 12 Jul 2023 12:51:59 +1000
Date:   Wed, 12 Jul 2023 12:51:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de
Subject: Re: [PATCH 1/5] iomap: complete polled writes inline
Message-ID: <ZK4VT5lLHaJsf53b@dread.disaster.area>
References: <20230711203325.208957-1-axboe@kernel.dk>
 <20230711203325.208957-2-axboe@kernel.dk>
 <ZK37j/BqFYXLjV/B@dread.disaster.area>
 <2c412c93-b197-b504-bfc5-433621a11ec5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c412c93-b197-b504-bfc5-433621a11ec5@kernel.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023 at 07:17:43PM -0600, Jens Axboe wrote:
> On 7/11/23 7:02?PM, Dave Chinner wrote:
> > On Tue, Jul 11, 2023 at 02:33:21PM -0600, Jens Axboe wrote:
> >> Polled IO is always reaped in the context of the process itself, so it
> >> does not need to be punted to a workqueue for the completion. This is
> >> different than IRQ driven IO, where iomap_dio_bio_end_io() will be
> >> invoked from hard/soft IRQ context. For those cases we currently need
> >> to punt to a workqueue for further processing. For the polled case,
> >> since it's the task itself reaping completions, we're already in task
> >> context. That makes it identical to the sync completion case.
> >>
> >> Testing a basic QD 1..8 dio random write with polled IO with the
> >> following fio job:
> >>
> >> fio --name=polled-dio-write --filename=/data1/file --time_based=1 \
> >> --runtime=10 --bs=4096 --rw=randwrite --norandommap --buffered=0 \
> >> --cpus_allowed=4 --ioengine=io_uring --iodepth=$depth --hipri=1
> > 
> > Ok, so this is testing pure overwrite DIOs as fio pre-writes the
> > file prior to starting the random write part of the test.
> 
> Correct.

What is the differential when you use O_DSYNC writes?

> >> yields:
> >>
> >> 	Stock	Patched		Diff
> >> =======================================
> >> QD1	180K	201K		+11%
> >> QD2	356K	394K		+10%
> >> QD4	608K	650K		+7%
> >> QD8	827K	831K		+0.5%
> >>
> >> which shows a nice win, particularly for lower queue depth writes.
> >> This is expected, as higher queue depths will be busy polling
> >> completions while the offloaded workqueue completions can happen in
> >> parallel.
> >>
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >> ---
> >>  fs/iomap/direct-io.c | 9 +++++----
> >>  1 file changed, 5 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> >> index ea3b868c8355..343bde5d50d3 100644
> >> --- a/fs/iomap/direct-io.c
> >> +++ b/fs/iomap/direct-io.c
> >> @@ -161,15 +161,16 @@ void iomap_dio_bio_end_io(struct bio *bio)
> >>  			struct task_struct *waiter = dio->submit.waiter;
> >>  			WRITE_ONCE(dio->submit.waiter, NULL);
> >>  			blk_wake_io_task(waiter);
> >> -		} else if (dio->flags & IOMAP_DIO_WRITE) {
> >> +		} else if ((bio->bi_opf & REQ_POLLED) ||
> >> +			   !(dio->flags & IOMAP_DIO_WRITE)) {
> >> +			WRITE_ONCE(dio->iocb->private, NULL);
> >> +			iomap_dio_complete_work(&dio->aio.work);
> > 
> > I'm not sure this is safe for all polled writes. What if the DIO
> > write was into a hole and we have to run unwritten extent
> > completion via:
> > 
> > iomap_dio_complete_work(work)
> >   iomap_dio_complete(dio)
> >     dio->end_io(iocb)
> >       xfs_dio_write_end_io()
> >         xfs_iomap_write_unwritten()
> >           <runs transactions, takes rwsems, does IO>
> >   .....
> >   ki->ki_complete()
> >     io_complete_rw_iopoll()
> >   .....
> > 
> > I don't see anything in the iomap DIO path that prevents us from
> > doing HIPRI/REQ_POLLED IO on IOMAP_UNWRITTEN extents, hence I think
> > this change will result in bad things happening in general.
> 
> There is a check related to writing beyond the size of the inode:
> 
>         if (need_zeroout ||                                                     
>             ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
>                 dio->iocb->ki_flags &= ~IOCB_HIPRI;
> 
> but whether that is enough of what, I'm not so sure.

Ah, need-zeroout covers unwritten extents. Ok, I missed that - I
knew if covered sub-block zeroing, but I missed the fact it
explicitly turned off HIPRI for block aligned IO to unwritten
extents.

Hence HIPRI is turned off for new extents, unwritten extents and
writes that extend file size. It does not get turned off for O_DSYNC
writes, but they have exactly the same completion constraints as all
these other cases, except where we use REQ_FUA to avoid them. That
seems like an oversight to me.

IOWs, HIPRI is already turned off in *most* of the cases where
completion queuing is required. These are all the same cases that
IOMAP_F_DIRTY is used by the filesystem to tell iomap if a pure
overwrite is being done. i.e. HIPRI/REQ_POLLED is just another
pure-overwrite IO optimisation at the iomap level.


> >> +		} else {
> >>  			struct inode *inode = file_inode(dio->iocb->ki_filp);
> >>  
> >>  			WRITE_ONCE(dio->iocb->private, NULL);
> >>  			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
> >>  			queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
> >> -		} else {
> >> -			WRITE_ONCE(dio->iocb->private, NULL);
> >> -			iomap_dio_complete_work(&dio->aio.work);
> >>  		}
> >>  	}
> > 
> > Regardless of the correctness of the code, I don't think adding this
> > special case is the right thing to do here.  We should be able to
> > complete all writes that don't require blocking completions directly
> > here, not just polled writes.
> > 
> > We recently had this discussion over hacking a special case "don't
> > queue for writes" for ext4 into this code - I had to point out the
> > broken O_DSYNC completion cases it resulted in there, too. I also
> > pointed out that we already had generic mechanisms in iomap to
> > enable us to make a submission time decision as to whether
> > completion needed to be queued or not. Thread here:
> > 
> > https://lore.kernel.org/linux-xfs/20230621174114.1320834-1-bongiojp@gmail.com/
> > 
> > Essentially, we shouldn't be using IOMAP_DIO_WRITE as the
> > determining factor for queuing completions - we should be using
> > the information the iocb and the iomap provides us at submission
> > time similar to how we determine if we can use REQ_FUA for O_DSYNC
> > writes to determine if iomap IO completion queuing is required.
> > 
> > This will do the correct *and* optimal thing for all types of
> > writes, polled or not...
> 
> There's a fundamental difference between "cannot block, ever" as we have
> from any kind of irq/rcu/preemption context, and the "we should not
> block waiting for unrelated IO" which is really what the NOIO kind of
> issue that async dio or polled async dio is. This obviously goes beyond
> just this single patch and addresses the whole patchset, but it applies
> equally to the polled completions here and the task punted callbacks for
> the dio async writes. For the latter, we can certainly grab a mutex, for
> the former we cannot, ever.

Yes, but I don't think that matters....

> I do hear your point that gating this on writes is somewhat odd, but
> that's mostly because the read completions don't really need to do
> anything.

That was just a simplification we did because nobody was concerned
with micro-optimisation of the iomap IO path. It was much faster
than what we had before to begin with without lots of special case
micro-optimisation - the thing that made the old direct IO code
completely unmaintainable was all the crazy micro-optimisations that
had occurred over time....

> Would you like it more if we made that explicit with another
> IOMAP flag? Only concern here for the polled part is that REQ_POLLED may
> be set for submission on the iomap side, but then later cleared through
> the block stack if we cannot do polled IO for this bio. This means it
> really has to be checked on the completion side, you cannot rely on any
> iocb or iomap flags set at submission time.

I think REQ_POLLED is completely irrelevant here because it is only
used on iomaps that are pure overwrites. Hence at the iomap level it
should be perfectly OK to do direct completion for a pure overwrite
regardless of whether REQ_POLLED is set at completion time or not.

As such, I think completion queuing can be keyed off a specific
dio->flag set at submission time, rather than keying off
IOMAP_DIO_WRITE or some complex logic based on current IO
contexts...

> For the write checking, that's already there... And while I'm all for
> making that code cleaner, I don't necessarily think cleaning that up
> first is a fair ask. At least not without more details on what you want,
> specifically?

I think it's very fair to ask you to fix the problem the right way.
It's pretty clear what needs to be done, it's solvable in a generic
manner, it is not complex to do and we've even got pure overwrite
detection already in the dio write path that we can formalise for
this purpose.

Fix it once, fix it for everyone.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
