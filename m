Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC902D5314
	for <lists+io-uring@lfdr.de>; Thu, 10 Dec 2020 06:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgLJFSy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Dec 2020 00:18:54 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:40251 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726313AbgLJFSy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Dec 2020 00:18:54 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 7AB638BFC;
        Thu, 10 Dec 2020 16:18:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1knELA-002NnU-U4; Thu, 10 Dec 2020 16:18:08 +1100
Date:   Thu, 10 Dec 2020 16:18:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     Hao Xu <haoxu@linux.alibaba.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v3 RESEND] iomap: set REQ_NOWAIT according to IOCB_NOWAIT
 in Direct IO
Message-ID: <20201210051808.GF4170059@dread.disaster.area>
References: <1607075096-94235-1-git-send-email-haoxu@linux.alibaba.com>
 <20201207022130.GC4170059@dread.disaster.area>
 <9bbfafcf-688c-bad9-c288-6478a88c6097@linux.alibaba.com>
 <20201209212358.GE4170059@dread.disaster.area>
 <adf32418-dede-0b58-13da-40093e1e4e2d@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adf32418-dede-0b58-13da-40093e1e4e2d@linux.alibaba.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=SRrdq9N9AAAA:8 a=6R7veym_AAAA:8
        a=7-415B0cAAAA:8 a=xaIeskg8_AF8nRZSNhQA:9 a=CjuIK1q_8ugA:10
        a=ILCOIF4F_8SzUMnO7jNM:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 10, 2020 at 09:55:32AM +0800, JeffleXu wrote:
> Sorry I'm still a little confused.
> 
> 
> On 12/10/20 5:23 AM, Dave Chinner wrote:
> > On Tue, Dec 08, 2020 at 01:46:47PM +0800, JeffleXu wrote:
> >>
> >>
> >> On 12/7/20 10:21 AM, Dave Chinner wrote:
> >>> On Fri, Dec 04, 2020 at 05:44:56PM +0800, Hao Xu wrote:
> >>>> Currently, IOCB_NOWAIT is ignored in Direct IO, REQ_NOWAIT is only set
> >>>> when IOCB_HIPRI is set. But REQ_NOWAIT should be set as well when
> >>>> IOCB_NOWAIT is set.
> >>>>
> >>>> Suggested-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> >>>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> >>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> >>>> ---
> >>>>
> >>>> Hi all,
> >>>> I tested fio io_uring direct read for a file on ext4 filesystem on a
> >>>> nvme ssd. I found that IOCB_NOWAIT is ignored in iomap layer, which
> >>>> means REQ_NOWAIT is not set in bio->bi_opf.
> >>>
> >>> What iomap is doing is correct behaviour. IOCB_NOWAIT applies to the
> >>> filesystem behaviour, not the block device.
> >>>
> >>> REQ_NOWAIT can result in partial IO failures because the error is
> >>> only reported to the iomap layer via IO completions. Hence we can
> >>> split a DIO into multiple bios and have random bios in that IO fail
> >>> with EAGAIN because REQ_NOWAIT is set. This error will
> >>> get reported to the submitter via completion, and it will override
> >>> any of the partial IOs that actually completed.
> >>>
> >>> Hence, like the recently reported multi-mapping IOCB_NOWAIT bug
> >>> reported by Jens and fixed in commit 883a790a8440 ("xfs: don't allow
> >>> NOWAIT DIO across extent boundaries") we'll get silent partial
> >>> writes occurring because the second submitted bio in an IO can
> >>> trigger EAGAIN errors with partial IO completion having already
> >>> occurred.
> >>>
> 
> >>> Further, we don't allow partial IO completion for DIO on XFS at all.
> >>> DIO must be completely submitted and completed or return an error
> >>> without having issued any IO at all.  Hence using REQ_NOWAIT for
> >>> DIO bios is incorrect and not desirable.
> 
> 
> The current block layer implementation causes that, as long as one split
> bio fails, then the whole DIO fails, in which case several split bios
> maybe have succeeded and the content has been written to the disk. This
> is obviously what you called "partial IO completion".
> 
> I'm just concerned on how do you achieve that "DIO must return an error
> without having issued any IO at all". Do you have some method of
> reverting the content has already been written into the disk when a
> partial error happened?

I think you've misunderstood what I was saying. I did not say
"DIO must return an error without having issued any IO at all".
There are two parts to my statement, and you just smashed part of
the first statement into part of the second statement and came up
something I didn't actually say.

The first statement is:

	1. "DIO must be fully submitted and completed ...."

That is, if we need to break an IO up into multiple parts, the
entire IO must be submitted and completed as a whole. We do not
allow partial submission or completion of the IO at all because we
cannot accurately report what parts of a multi-bio DIO that failed
through the completion interface. IOWs, if any of the IOs after the
first one fail submission, then we must complete all the IOs that
have already been submitted before we can report the failure that
occurred during the IO.

The second statement is:

	2. "... or return an error without having issued any IO at
	   all."

IO submission errors are only reported by the DIO layer through IO
completion, in which case #1 is applied. #2 only applies to errors
that occur before IO submission is started, and these errors are
directly reported to the caller. IOCB_NOWAIT is a check done before
we start submission, hence can return -EAGAIN directly to the
caller.

IOWs, if an error is returned to the caller, we have either not
submitted any IO at all, or we have fully submitted and completed
the IO and there was some error reported by the IO completions.
There is no scope for "partial IO" here - it either completed fully
or we got an error.

This is necessary for correct AIO semantics. We aren't waiting for
completions to be able to report submission errors to submitters.
Hence for async IO, the only way for an error in the DIO layer to be
reported to the submitter is if the error occurs before the first IO
is submitted.(*)

RWF_NOWAIT was explicitly intended to enable applications using
AIO+DIO to avoid long latencies that occur as a result of blocking
on filesystem locks and resources. Blocking in the request queue is
minimal latency compared to waiting for (tens of) thousands of IOs
to complete ((tens of) seconds!) so the filesystem iomap path can run a
transaction to allocate disk spacei for the DIO.

IOWS, IOCB_NOWAIT was pretty` much intended to only be seen at the
filesystem layers to avoid the extremely high latencies that
filesystem layers might cause.  Blocking for a few milliseconds or
even tens of milliseconds in the request queue is not a problem
IOCB_NOWAIT was ever intended to solve.

Really, if io_uring needs DIO to avoid blocking in the request
queues below the filesystem, it should be providing that guidance
directly. IOCB_NOWAIT is -part- of the semantics being asked for,
but it does not provide them all and we can't change them to provide
exactly what io_uring wants because IOCB_NOWAIT == RWF_NOWAIT
semantics.

Cheers,

Dave.

(*) Yes, yes, I know that if you have a really fast storage the IO
might complete before submission has finished, but that's just the
final completion is done by the submitter and so #1 is actually
being followed in this case. i.e. IO is fully submitted and
completed.

-- 
Dave Chinner
david@fromorbit.com
