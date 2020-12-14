Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C23A2D91EF
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 03:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438261AbgLNC55 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Dec 2020 21:57:57 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:39266 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726867AbgLNC5t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Dec 2020 21:57:49 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id D1C99765A3A;
        Mon, 14 Dec 2020 13:56:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1koe2h-003jSe-U5; Mon, 14 Dec 2020 13:56:55 +1100
Date:   Mon, 14 Dec 2020 13:56:55 +1100
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
Message-ID: <20201214025655.GH3913616@dread.disaster.area>
References: <1607075096-94235-1-git-send-email-haoxu@linux.alibaba.com>
 <20201207022130.GC4170059@dread.disaster.area>
 <9bbfafcf-688c-bad9-c288-6478a88c6097@linux.alibaba.com>
 <20201209212358.GE4170059@dread.disaster.area>
 <adf32418-dede-0b58-13da-40093e1e4e2d@linux.alibaba.com>
 <20201210051808.GF4170059@dread.disaster.area>
 <fdb6e01a-a662-90fa-3844-410b2107e850@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdb6e01a-a662-90fa-3844-410b2107e850@linux.alibaba.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=SRrdq9N9AAAA:8 a=6R7veym_AAAA:8
        a=7-415B0cAAAA:8 a=Xe0Sj6dyDsrYYO_VHT8A:9 a=CjuIK1q_8ugA:10
        a=ILCOIF4F_8SzUMnO7jNM:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Dec 11, 2020 at 10:50:44AM +0800, JeffleXu wrote:
> Excellent explanation! Thanks a lot.
> 
> Still some questions below.
> 
> On 12/10/20 1:18 PM, Dave Chinner wrote:
> > On Thu, Dec 10, 2020 at 09:55:32AM +0800, JeffleXu wrote:
> >> Sorry I'm still a little confused.
> >>
> >>
> >> On 12/10/20 5:23 AM, Dave Chinner wrote:
> >>> On Tue, Dec 08, 2020 at 01:46:47PM +0800, JeffleXu wrote:
> >>>>
> >>>>
> >>>> On 12/7/20 10:21 AM, Dave Chinner wrote:
> >>>>> On Fri, Dec 04, 2020 at 05:44:56PM +0800, Hao Xu wrote:
> >>>>>> Currently, IOCB_NOWAIT is ignored in Direct IO, REQ_NOWAIT is only set
> >>>>>> when IOCB_HIPRI is set. But REQ_NOWAIT should be set as well when
> >>>>>> IOCB_NOWAIT is set.
> >>>>>>
> >>>>>> Suggested-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> >>>>>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> >>>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> >>>>>> ---
> >>>>>>
> >>>>>> Hi all,
> >>>>>> I tested fio io_uring direct read for a file on ext4 filesystem on a
> >>>>>> nvme ssd. I found that IOCB_NOWAIT is ignored in iomap layer, which
> >>>>>> means REQ_NOWAIT is not set in bio->bi_opf.
> >>>>>
> >>>>> What iomap is doing is correct behaviour. IOCB_NOWAIT applies to the
> >>>>> filesystem behaviour, not the block device.
> >>>>>
> >>>>> REQ_NOWAIT can result in partial IO failures because the error is
> >>>>> only reported to the iomap layer via IO completions. Hence we can
> >>>>> split a DIO into multiple bios and have random bios in that IO fail
> >>>>> with EAGAIN because REQ_NOWAIT is set. This error will
> >>>>> get reported to the submitter via completion, and it will override
> >>>>> any of the partial IOs that actually completed.
> >>>>>
> >>>>> Hence, like the recently reported multi-mapping IOCB_NOWAIT bug
> >>>>> reported by Jens and fixed in commit 883a790a8440 ("xfs: don't allow
> >>>>> NOWAIT DIO across extent boundaries") we'll get silent partial
> >>>>> writes occurring because the second submitted bio in an IO can
> >>>>> trigger EAGAIN errors with partial IO completion having already
> >>>>> occurred.
> >>>>>
> >>
> >>>>> Further, we don't allow partial IO completion for DIO on XFS at all.
> >>>>> DIO must be completely submitted and completed or return an error
> >>>>> without having issued any IO at all.  Hence using REQ_NOWAIT for
> >>>>> DIO bios is incorrect and not desirable.
> >>
> >>
> >> The current block layer implementation causes that, as long as one split
> >> bio fails, then the whole DIO fails, in which case several split bios
> >> maybe have succeeded and the content has been written to the disk. This
> >> is obviously what you called "partial IO completion".
> >>
> >> I'm just concerned on how do you achieve that "DIO must return an error
> >> without having issued any IO at all". Do you have some method of
> >> reverting the content has already been written into the disk when a
> >> partial error happened?
> > 
> > I think you've misunderstood what I was saying. I did not say
> > "DIO must return an error without having issued any IO at all".
> > There are two parts to my statement, and you just smashed part of
> > the first statement into part of the second statement and came up
> > something I didn't actually say.
> > 
> > The first statement is:
> > 
> > 	1. "DIO must be fully submitted and completed ...."
> > 
> > That is, if we need to break an IO up into multiple parts, the
> > entire IO must be submitted and completed as a whole. We do not
> > allow partial submission or completion of the IO at all because we
> > cannot accurately report what parts of a multi-bio DIO that failed
> > through the completion interface. IOWs, if any of the IOs after the
> > first one fail submission, then we must complete all the IOs that
> > have already been submitted before we can report the failure that
> > occurred during the IO.
> > 
> 
> 1. Actually I'm quite not clear on what you called "partial submission
> or completion". Even when REQ_NOWAIT is set for all split bios of one
> DIO, then all these split bios are **submitted** to block layer through
> submit_bio(). Even when one split bio after the first one failed
> **inside** submit_bio() because of REQ_NOWAIT, submit_bio() only returns
> BLK_QC_T_NONE, and the DIO layer (such as __blkdev_direct_IO()) will
> still call submit_bio() for the remaining split bios. And then only when
> all split bios complete, will the whole kiocb complete.

Yes, so what you have there is complete submission and completion.
i.e. what I described as #1.

> So if you define "submission" as submitting to hardware disk (such as
> nvme device driver), then it is indeed **partial submission** when
> REQ_NOWAIT set. But if the definition of "submission" is actually
> "submitting to block layer by calling submit_bio()", then all split bios
> of one DIO are indeed submitted to block layer, even when one split bio
> gets BLK_STS_AGAIN because of REQ_NOWIAT.

The latter is the definition we using in iomap, because at this
layer we are the ones submitting the bios and defining the bounds of
the IO. What happens in the lower layers does not concern us here.

Partial submission can occur at the iomap layer if IOCB_NOWAIT is
set - that was what 883a790a8440 fixed. i.e. we do

	loop for all mapped extents {
		loop for mapped range {
			submit_bio(subrange)
		}
	}

So if we have an extent range like so:

	start					end
	+-----------+---------+------+-----------+
	  ext 1        ext 2    ext 3    ext 4

We actually have to loop above 4 times to map the 4 extents that
span the user IO range. That means we need to submit at least 4
independent bios to run this IO.

So if we submit all the bios in a first mapped range (ext 1), then
go back to the filesystem to get the map for the next range to
submit and it returns -EAGAIN, we break out of the outer loop
without having completely submitted bios for the range spanning ext
2, 3 or 4. That's partial IO submission as the *iomap layer* defines
it.

And the "silent" part of the "partial write" it came from the fact
this propagated -EAGAIN to the user despite the fact that some IO
was actually successfully committed and completed. IOws, we may have
corrupted data on disk by telling the user nothing was done with
-EAGAIN rather than failing the partial IO with -EIO.

This is the problem commit 883a790a8440 fixed.

> 2. One DIO could be split into multiple bios in DIO layer. Similarly one
> big bio could be split into multiple bios in block layer. In the
> situation when all split bios have already been submitted to block
> layer, since the IO completion interface could return only one error
> code, the whole DIO could fail as long as one split bio fails, while
> several other split bios could have already succeeded and the
> corresponding disk sectors have already been overwritten.

Yup. That can happen. That's a data corruption for which prevention
is the responsibility of the layer doing the splitting and
recombining.  The iomap layer knows nothing of this - this situation
needs to result in the entire bio that was split being marked with
an EIO error because we do not know what parts of the bio made it to
disk or not. IOWs, the result of the IO is undefined, and so we
need to return EIO to the user.

This "data is inconsistent until all sub-devices complete their IO
successfully" situation is also known as the "RAID 5 write hole".
Crash while these IOs are in flight, and some might hit the disk and
some might not. When the system comes back up, you've got no idea
which part of that IO was completed or not, so the data in the
entire stripe is corrupt.

> I'm not sure
> if this is what you called "silent partial writes", and if this is the
> core reason for commit 883a790a8440 ("xfs: don't allow NOWAIT DIO across
> extent boundaries") you mentioned in previous mail.

No, it's not the same thing. This "split IO failed" should never
result in a silent partial write - it should always result in EIO.

> If this is the case, then it seems that the IO completion interface
> should be blamed for this issue. Besides REQ_NOWIAT, there may be more
> situations that will cause "silent partial writes".

Yes, there are many potential causes of this behaviour. They are all
considered to be a data corruption, and so in all cases they should
be returning EIO as the completion status to the submitter of the
bio.

> As long as one split bios could fail (besides EAGAIN, maybe EOPNOTSUPP,
> if possible), while other split bios may still succeeds, then the error
> of one split bio will still override the completion status of the whole
> DIO.

If you get EOPNOTSUPP from on device in bio split across many
devices, then you have a bug in the layer that is splitting the IO.
All the sub-devices need to support the operation, or the top level
device cannot safely support that operation.

And if one device didn't do the opreation, then we have inconsistent
data on disk now and so EIO is the result that should be returned to
the user.

> In this case "silent partial writes" is still possible? In my
> understanding, passing REQ_NOWAIT flags from IOCB_NOWAIT in DIO layer
> only makes the problem more likely to happen, but it's not the only
> source of this problem?

Passing REQ_NOWAIT from the iomap dio layer means that we will see
data corruptions in stable storage simply due to high IO load, rather
than the much, much rarer situations of software bugs or actual
hardware errors.  IOWs, REQ_NOWAIT essentially guarantees data
corruption in stable storage of a perfectly working storage stack
will occur and there is nothing the application can do to prevent
that occurring.

The worst part of this is that REQ_NOWAIT also requires the
application to detect and correct the corruption caused by the
kernel using REQ_NOWAIT inappropriately. And if the application
crashes before it can correct the data corruption, it's suddenly a
permanent, uncorrectable data corruption.

REQ_NOWAIT is dangerous and can easily cause harm to user data by
aborting parts of submitted IOs. IOWs, it's more like a random IO
error injection mechanism than a useful method of doing safe
non-blocking IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
