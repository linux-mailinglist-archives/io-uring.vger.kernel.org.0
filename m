Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989802D4D23
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 22:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388349AbgLIVu4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Dec 2020 16:50:56 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:45258 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388356AbgLIVu4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Dec 2020 16:50:56 -0500
X-Greylist: delayed 2047 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2020 16:50:54 EST
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id E304A10C90F;
        Thu, 10 Dec 2020 08:15:58 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kn6oY-002Gej-CG; Thu, 10 Dec 2020 08:15:58 +1100
Date:   Thu, 10 Dec 2020 08:15:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Hao Xu <haoxu@linux.alibaba.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v3 RESEND] iomap: set REQ_NOWAIT according to IOCB_NOWAIT
 in Direct IO
Message-ID: <20201209211558.GD4170059@dread.disaster.area>
References: <1607075096-94235-1-git-send-email-haoxu@linux.alibaba.com>
 <20201207022130.GC4170059@dread.disaster.area>
 <3b33a9e3-0f03-38cc-d484-3f355f75df73@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b33a9e3-0f03-38cc-d484-3f355f75df73@kernel.dk>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=SRrdq9N9AAAA:8 a=6R7veym_AAAA:8
        a=7-415B0cAAAA:8 a=018I-g7Lv1ZZF0RgCPIA:9 a=CjuIK1q_8ugA:10
        a=ILCOIF4F_8SzUMnO7jNM:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Dec 07, 2020 at 04:40:38PM -0700, Jens Axboe wrote:
> On 12/6/20 7:21 PM, Dave Chinner wrote:
> > On Fri, Dec 04, 2020 at 05:44:56PM +0800, Hao Xu wrote:
> >> Currently, IOCB_NOWAIT is ignored in Direct IO, REQ_NOWAIT is only set
> >> when IOCB_HIPRI is set. But REQ_NOWAIT should be set as well when
> >> IOCB_NOWAIT is set.
> >>
> >> Suggested-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> >> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> >> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> >> ---
> >>
> >> Hi all,
> >> I tested fio io_uring direct read for a file on ext4 filesystem on a
> >> nvme ssd. I found that IOCB_NOWAIT is ignored in iomap layer, which
> >> means REQ_NOWAIT is not set in bio->bi_opf.
> > 
> > What iomap is doing is correct behaviour. IOCB_NOWAIT applies to the
> > filesystem behaviour, not the block device.
> > 
> > REQ_NOWAIT can result in partial IO failures because the error is
> > only reported to the iomap layer via IO completions. Hence we can
> > split a DIO into multiple bios and have random bios in that IO fail
> > with EAGAIN because REQ_NOWAIT is set. This error will
> > get reported to the submitter via completion, and it will override
> > any of the partial IOs that actually completed.
> > 
> > Hence, like the recently reported multi-mapping IOCB_NOWAIT bug
> > reported by Jens and fixed in commit 883a790a8440 ("xfs: don't allow
> > NOWAIT DIO across extent boundaries") we'll get silent partial
> > writes occurring because the second submitted bio in an IO can
> > trigger EAGAIN errors with partial IO completion having already
> > occurred.
> > 
> > Further, we don't allow partial IO completion for DIO on XFS at all.
> > DIO must be completely submitted and completed or return an error
> > without having issued any IO at all.  Hence using REQ_NOWAIT for
> > DIO bios is incorrect and not desirable.
> 
> What you say makes total sense for a user using RWF_NOWAIT, but it
> doesn't make a lot of sense for io_uring where we really want
> IOCB_NOWAIT to be what it suggests it is - don't wait for other IO to
> complete, if avoidable. One of the things that really suck with
> aio/libai is the "yeah it's probably async, but lol, might not be"
> aspect of it.

Sure, but we have no way of telling what semantics the IO issuer
actually requires from above. And because IOCB_NOWAIT behaviour is
directly exposed to userspace by RWF_NOWAIT, that's the behaviour we
have to implement.

> For io_uring, if we do get -EAGAIN, we'll retry without NOWAIT set. So
> the concern about fractured/short writes doesn't bubble up to the
> application. Hence we really want an IOCB_NOWAIT_REALLY on that side,
> instead of the poor mans IOCB_MAYBE_NOWAIT semantics.

Yup, perhaps what we really want is a true IOCB_NONBLOCK flag as an
internal kernel implementation. i.e. don't block anywhere in the
stack, and the caller must handle retrying/completing the entire IO
regardless of where the -EAGAIN comes from during the IO, including
from a partial completion that the caller is waiting for...

i.e. rather than hacking around this specific instance of "it blocks
and we don't want it to", define the semantics and behaviour of a
fully non-blocking IO through all layers from the VFS down to the
hardware and let's implement that. Then we can stop playing
whack-a-mole with all the "but it blocks when I do this, doctor!"
issues that we seem to keep having.... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
