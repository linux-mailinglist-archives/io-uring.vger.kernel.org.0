Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589CA2B099B
	for <lists+io-uring@lfdr.de>; Thu, 12 Nov 2020 17:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgKLQLg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 11:11:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728414AbgKLQLg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 11:11:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605197493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h7UdIT8ZId8iYTHJvW2BvD8NkTKm/RjlnhZH0DdqO6k=;
        b=bGDjHQWNUDq2kJySjlgSPLzzeWAiS6Dvv4x2aXMDse3H4TSF/rdVaqmQYo0rB6B7eqM7cj
        6Rbntr2CsYGbVFv0iNFHvY3zGeg+2YHo19P5bLLGHDgQG37jAXrMQX0d/BIO9fXBL/fzTc
        HUeJh8I0AM9UjUtNLbOK6UhsGcbjB6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-xGN0Qhq8PFm1LictJq_YPQ-1; Thu, 12 Nov 2020 11:11:31 -0500
X-MC-Unique: xGN0Qhq8PFm1LictJq_YPQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2124D1006CA7;
        Thu, 12 Nov 2020 16:11:30 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A5FF310013D0;
        Thu, 12 Nov 2020 16:11:26 +0000 (UTC)
Date:   Thu, 12 Nov 2020 11:11:26 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     joseph.qi@linux.alibaba.com, dm-devel@redhat.com, koct9i@gmail.com,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: dm: add support for DM_TARGET_NOWAIT for various targets
Message-ID: <20201112161125.GA29249@redhat.com>
References: <20201110065558.22694-1-jefflexu@linux.alibaba.com>
 <20201111153824.GB22834@redhat.com>
 <533a3b6b-146b-afe6-2e3e-d1bc2180a8c8@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <533a3b6b-146b-afe6-2e3e-d1bc2180a8c8@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Nov 12 2020 at  1:05am -0500,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

> Hi Jens and guys in block/io_uring mailing list, this mail contains
> some discussion abount
> 
> RWF_NOWAIT, please see the following contents.
> 
> 
> 
> On 11/11/20 11:38 PM, Mike Snitzer wrote:
> >On Tue, Nov 10 2020 at  1:55am -0500,
> >Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> >
> >>This is one prep patch for supporting iopoll for dm device.
> >>
> >>The direct IO routine will set REQ_NOWAIT flag for REQ_HIPRI IO (that
> >>is, IO will do iopoll) in bio_set_polled(). Then in the IO submission
> >>routine, the ability of handling REQ_NOWAIT of the block device will
> >>be checked for REQ_HIPRI IO in submit_bio_checks(). -EOPNOTSUPP will
> >>be returned if the block device doesn't support REQ_NOWAIT.
> >submit_bio_checks() verifies the request_queue has QUEUE_FLAG_NOWAIT set
> >if the bio has REQ_NOWAIT.
> Yes that's the case.
> >
> >>DM lacks support for REQ_NOWAIT until commit 6abc49468eea ("dm: add
> >>support for REQ_NOWAIT and enable it for linear target"). Since then,
> >>dm targets that support REQ_NOWAIT should advertise DM_TARGET_NOWAIT
> >>feature.
> >I'm not seeing why DM_TARGET_NOWAIT is needed (since you didn't add any
> >code that consumes the flag).
> 
> As I said, it's needed if we support iopoll for dm device.  Only if
> a block device is capable of
> 
> handling NOWAIT, then it can support iopoll.
> 
> 
> IO submitted for iopoll (marked with IOCB_HIPRI) is usually also
> marked with REQ_NOWAIT.
> 
> There are two scenario when it could happen.
> 
> 
> 1. io_uring will set REQ_NOWAIT
> 
> The IO submission of io_uring can be divided into two phase. First,
> IO will be submitted
> 
> synchronously in user process context (when sqthread feature
> disabled), or sqthread
> 
> context (when sqthread feature enabled).
> 
> 
> ```sh
> - current process context when sqthread disabled, or sqthread when
> it's enabled
>     io_uring_enter
>         io_submit_sqes
>             io_submit_sqe
>                 io_queue_sqe
>                     __io_queue_sqe
>                         io_issue_sqe // with @force_nonblock is true
>                             io_read/io_write
> ```
> 
> In this case, IO should be handled in a NOWAIT way, since the user
> process or sqthread
> 
> can not be blocked for performance.
> 
> ```
> 
> io_read/io_write
> 
>     /* Ensure we clear previously set non-block flag */
>     if (!force_nonblock)
>         kiocb->ki_flags &= ~IOCB_NOWAIT;
>     else
>         kiocb->ki_flags |= IOCB_NOWAIT;
> 
> ```
> 
> 
> 2. The direct IO routine will set REQ_NOWAIT for polling IO
> 
> Both fs/block_dev.c: __blkdev_direct_IO and fs/iomap/direct-io.c:
> iomap_dio_submit_bio will
> 
> call bio_set_polled(), in which will set REQ_NOWAIT for polling IO.
> 
> 
> ```sh
> __blkdev_direct_IO / iomap_dio_submit_bio:
>     if (dio->iocb->ki_flags & IOCB_HIPRI)
>         bio_set_polled
>           bio->bi_opf |= REQ_NOWAIT
> ```
> 
> 
> Thus to support iopoll for dm device, the dm target should be
> capable of handling NOWAIT,
> 
> or submit_bio_checks() will fail with -EOPNOTSUPP when submitting
> bio to dm device.
> 
> 
> >
> >dm-table.c:dm_table_set_restrictions() has:
> >
> >         if (dm_table_supports_nowait(t))
> >                 blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
> >         else
> >                 blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, q);
> >
> >>This patch adds support for DM_TARGET_NOWAIT for those dm targets, the
> >>.map() algorithm of which just involves sector recalculation.
> >So you're looking to constrain which targets will properly support
> >REQ_NOWAIT, based on whether they do a simple remapping?
> 
> To be honest, I'm a little confused about the semantics of
> REQ_NOWAIT. Jens may had ever
> 
> explained it in block or io_uring mailing list, but I can't find the
> specific mail.
> 
> 
> The man page explains FMODE_NOWAIT as 'File is capable of returning
> -EAGAIN if I/O will
> 
> block'.
> 
> 
> And RWF_NOWAIT as
> 
> ```
> 
>               RWF_NOWAIT (since Linux 4.14)
>                      Don't wait if the I/O will block for operations
> such as
>                      file block allocations, dirty page flush, mutex locks,
>                      or a congested block device inside the kernel.  If any
>                      of these conditions are met, the control block is re‐
>                      turned immediately with a return value of -EAGAIN in
>                      the res field of the io_event structure (see
>                      io_getevents(2)).
> 
> ```
> 
> 
> commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable it
> for linear
> 
> target") handles NOWAIT for DM core as
> 
> 
> ```
> 
> @@ -1802,7 +1802,9 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
>         if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
> +               if (bio->bi_opf & REQ_NOWAIT)
> +                       bio_wouldblock_error(bio);
> 
> +               else if (!(bio->bi_opf & REQ_RAHEAD))
>                         queue_io(md, bio);
> 
> ```
> 
> 
> Theoretically the block device could advertise QUEUE_FLAG_NOWAIT as
> long as it could
> 
> 'return -EAGAIN if I/O will block' as the man page said. However,
> considering when the
> 
> dm device detected as suspending, the submitted bios are deferred to
> workqueue in
> 
> drivers/dm/dm.c: dm_submit_bio. In this case, IO gets **deferred**
> while the user process
> 
> will not be **blocked**. Can we say IO gets **blocked** in this case?
> 
> 
> Actually several dm targets handle submitted bio in this deferred
> way, such as dm-crypt/
> 
> dm-delay/dm-era/dm-ebs. Can we say these targets are not capable of
> handling NOWAIT?
> 
> 
> Also when system is short of memory, bio allocation in
> bio_alloc_bioset() may trigger memory
> 
> direct reclaim, as the gfp_mask is usually GFP_NOIO. While in memory
> direct reclaim, the
> 
> process may be scheduled out, but I have never seen the proper
> handling for NOWAIT in this
> 
> situation. Maybe the block or io_uring guys have more insights?
> 
> 
> So there's just too many possibilities that may get blocked, not to
> say mutex locks.
> 
> 
> >
> >
> >>Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> >>---
> >>Hi Mike,
> >>
> >>I could split these boilerplate code that each dm target have one
> >>seperate patch if you think that would be better.
> >One patch for all these is fine.  But it should include the code that I
> >assume you'll be adding to dm_table_supports_nowait() to further verify
> >that the targets in the table are all DM_TARGET_NOWAIT.
> >
> >And why isn't dm-linear setting DM_TARGET_NOWAIT?
> These are all done in commit 6abc49468eea ("dm: add support for
> REQ_NOWAIT and enable it for
> linear target").

Ha, oops.  You'd think I'd have remembered adding DM_TARGET_NOWAIT to
dm-linear and dm_target_supports_nowait, etc.

Thanks for clarifying.  So your patch was just about extending
the capability to other targets where you think it applicable.

We'll be able to make that clearer by tweaking the header a bit.

Mike

