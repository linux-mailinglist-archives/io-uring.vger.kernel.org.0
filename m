Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88326750C53
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 17:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbjGLPWJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 11:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbjGLPWH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 11:22:07 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8243C1726;
        Wed, 12 Jul 2023 08:22:05 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1135467373; Wed, 12 Jul 2023 17:22:02 +0200 (CEST)
Date:   Wed, 12 Jul 2023 17:22:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-xfs@vger.kernel.org, hch@lst.de, andres@anarazel.de
Subject: Re: [PATCH 1/5] iomap: complete polled writes inline
Message-ID: <20230712152201.GA23566@lst.de>
References: <20230711203325.208957-1-axboe@kernel.dk> <20230711203325.208957-2-axboe@kernel.dk> <ZK37j/BqFYXLjV/B@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZK37j/BqFYXLjV/B@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 12, 2023 at 11:02:07AM +1000, Dave Chinner wrote:
> I'm not sure this is safe for all polled writes. What if the DIO
> write was into a hole and we have to run unwritten extent
> completion via:
> 
> iomap_dio_complete_work(work)
>   iomap_dio_complete(dio)
>     dio->end_io(iocb)
>       xfs_dio_write_end_io()
>         xfs_iomap_write_unwritten()
>           <runs transactions, takes rwsems, does IO>
>   .....
>   ki->ki_complete()
>     io_complete_rw_iopoll()
>   .....
> 
> I don't see anything in the iomap DIO path that prevents us from
> doing HIPRI/REQ_POLLED IO on IOMAP_UNWRITTEN extents, hence I think
> this change will result in bad things happening in general.

Where the bad thing is that we're doing fairly expensive work in the
completion thread.  Which is probably horrible for performance, but
should be otherwise unproblematic.

> Regardless of the correctness of the code, I don't think adding this
> special case is the right thing to do here.  We should be able to
> complete all writes that don't require blocking completions directly
> here, not just polled writes.

Note that we have quite a few completion handlers that don't block,
but still require user context, as they take a spinlock without
irq protection.

Thinks are a bit more complicated now compared to the legacy direct
I/O, because back then non-XFS file system usually dindn't support
i_size updates from asynchronous dio.

> Essentially, we shouldn't be using IOMAP_DIO_WRITE as the
> determining factor for queuing completions - we should be using
> the information the iocb and the iomap provides us at submission
> time similar to how we determine if we can use REQ_FUA for O_DSYNC
> writes to determine if iomap IO completion queuing is required.

We also need information from the file system, e.g. zonefs always
takes a mutex at least for the zone files.

In other words the optimize non-sync or FUA pure overwrites has a fair
bit of overlap with this, but actually is a more complex issue.
