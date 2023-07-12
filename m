Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8475274FC77
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 03:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjGLBCO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 21:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjGLBCN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 21:02:13 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6158DE49
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 18:02:12 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-66872d4a141so4427348b3a.1
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 18:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689123732; x=1691715732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hHkc/DA4BYpGjTDImf1pogehmN0w8HNaxDq1n9ljRv8=;
        b=rB/JYAL+uhzPRRiuAcUP3gsekKcVlG/mrjiqHz0yLQXa6EQMjmoVTWxqMjntc48J90
         sFX8o+wRH6AcQwZ7O22eLWnGny0TllOvUPQf+wEjBUEEHlr5ddapMbTvyPVLeZE4xOlb
         63RtVe/Imj2v6JcEopZJHQj+kH690vGNdG+wJZIdZmnjM+k8OZ57OYq1gGZE1iS87zuh
         IkEGsFWwf4TQ3rIFN10yCRNZYQBTcsVmFJcPo8XwFdWXk8s8oHxRfMf8c+s7OgyjU4JQ
         rbKk8d6XhO+Jts6KGk0KbeTUe4FXq0FW7sTA2EDf7jHWuUPs7LB2nn8/mBv3bL/qqG/n
         h4Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689123732; x=1691715732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hHkc/DA4BYpGjTDImf1pogehmN0w8HNaxDq1n9ljRv8=;
        b=c14bq3dNPmYeP+1m0kipyHgfNiO8tQcFq6Ssd+ok6S84AV14KOkbpd3g6h9EuRLcm9
         xjAQNwSjYAgyfQHoC6Q4LYfZ/jW4lh1uiT81sE85Dl1vlhOVrcIzczDA3dPoAU/66uKQ
         oxxDNCbl8bsjxrttj7sO/bZmPWYEOBnYMpkmF3UuZwMt+LW+b4aFFCGOdIGlzS2FukZe
         nb7mq3hb3UP/rnjLF8I84tv7KBFsmiq5JgBiq0xf8t0KKZKK7WVeqTh237f/Y/UbWb/O
         C35pEVqsiXjvOZOTX949NBQ2z1k9EEeZG1IoGjD5l9xLcZCzR/Pe52jeCrKPixli/ZAg
         VGYA==
X-Gm-Message-State: ABy/qLa8fiRbihP8rKKFZAOBYjkPUIy1+5TQZtH+QYS40mBTXwWS9qcH
        hQpt3IeEqdwA43zI+o1uY1HpSA==
X-Google-Smtp-Source: APBJJlE8R8Ot/39VX3MNniTH+6O9WNgiH4rKjZildmzoeBUE8Kq+kfIJT4bZdRtXmSon1L/Xjk7KrQ==
X-Received: by 2002:a05:6a21:328a:b0:12c:efd8:de4c with SMTP id yt10-20020a056a21328a00b0012cefd8de4cmr16046256pzb.18.1689123731760;
        Tue, 11 Jul 2023 18:02:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-246-40.pa.nsw.optusnet.com.au. [49.180.246.40])
        by smtp.gmail.com with ESMTPSA id q15-20020a62ae0f000000b0067526282193sm2311778pff.157.2023.07.11.18.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 18:02:11 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qJOF6-004zwW-01;
        Wed, 12 Jul 2023 11:02:08 +1000
Date:   Wed, 12 Jul 2023 11:02:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de
Subject: Re: [PATCH 1/5] iomap: complete polled writes inline
Message-ID: <ZK37j/BqFYXLjV/B@dread.disaster.area>
References: <20230711203325.208957-1-axboe@kernel.dk>
 <20230711203325.208957-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711203325.208957-2-axboe@kernel.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023 at 02:33:21PM -0600, Jens Axboe wrote:
> Polled IO is always reaped in the context of the process itself, so it
> does not need to be punted to a workqueue for the completion. This is
> different than IRQ driven IO, where iomap_dio_bio_end_io() will be
> invoked from hard/soft IRQ context. For those cases we currently need
> to punt to a workqueue for further processing. For the polled case,
> since it's the task itself reaping completions, we're already in task
> context. That makes it identical to the sync completion case.
> 
> Testing a basic QD 1..8 dio random write with polled IO with the
> following fio job:
> 
> fio --name=polled-dio-write --filename=/data1/file --time_based=1 \
> --runtime=10 --bs=4096 --rw=randwrite --norandommap --buffered=0 \
> --cpus_allowed=4 --ioengine=io_uring --iodepth=$depth --hipri=1

Ok, so this is testing pure overwrite DIOs as fio pre-writes the
file prior to starting the random write part of the test.

> yields:
> 
> 	Stock	Patched		Diff
> =======================================
> QD1	180K	201K		+11%
> QD2	356K	394K		+10%
> QD4	608K	650K		+7%
> QD8	827K	831K		+0.5%
> 
> which shows a nice win, particularly for lower queue depth writes.
> This is expected, as higher queue depths will be busy polling
> completions while the offloaded workqueue completions can happen in
> parallel.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/iomap/direct-io.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index ea3b868c8355..343bde5d50d3 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -161,15 +161,16 @@ void iomap_dio_bio_end_io(struct bio *bio)
>  			struct task_struct *waiter = dio->submit.waiter;
>  			WRITE_ONCE(dio->submit.waiter, NULL);
>  			blk_wake_io_task(waiter);
> -		} else if (dio->flags & IOMAP_DIO_WRITE) {
> +		} else if ((bio->bi_opf & REQ_POLLED) ||
> +			   !(dio->flags & IOMAP_DIO_WRITE)) {
> +			WRITE_ONCE(dio->iocb->private, NULL);
> +			iomap_dio_complete_work(&dio->aio.work);

I'm not sure this is safe for all polled writes. What if the DIO
write was into a hole and we have to run unwritten extent
completion via:

iomap_dio_complete_work(work)
  iomap_dio_complete(dio)
    dio->end_io(iocb)
      xfs_dio_write_end_io()
        xfs_iomap_write_unwritten()
          <runs transactions, takes rwsems, does IO>
  .....
  ki->ki_complete()
    io_complete_rw_iopoll()
  .....

I don't see anything in the iomap DIO path that prevents us from
doing HIPRI/REQ_POLLED IO on IOMAP_UNWRITTEN extents, hence I think
this change will result in bad things happening in general.

> +		} else {
>  			struct inode *inode = file_inode(dio->iocb->ki_filp);
>  
>  			WRITE_ONCE(dio->iocb->private, NULL);
>  			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
>  			queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
> -		} else {
> -			WRITE_ONCE(dio->iocb->private, NULL);
> -			iomap_dio_complete_work(&dio->aio.work);
>  		}
>  	}

Regardless of the correctness of the code, I don't think adding this
special case is the right thing to do here.  We should be able to
complete all writes that don't require blocking completions directly
here, not just polled writes.

We recently had this discussion over hacking a special case "don't
queue for writes" for ext4 into this code - I had to point out the
broken O_DSYNC completion cases it resulted in there, too. I also
pointed out that we already had generic mechanisms in iomap to
enable us to make a submission time decision as to whether
completion needed to be queued or not. Thread here:

https://lore.kernel.org/linux-xfs/20230621174114.1320834-1-bongiojp@gmail.com/

Essentially, we shouldn't be using IOMAP_DIO_WRITE as the
determining factor for queuing completions - we should be using
the information the iocb and the iomap provides us at submission
time similar to how we determine if we can use REQ_FUA for O_DSYNC
writes to determine if iomap IO completion queuing is required.

This will do the correct *and* optimal thing for all types of
writes, polled or not...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
