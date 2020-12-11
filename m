Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3014C2D6E3D
	for <lists+io-uring@lfdr.de>; Fri, 11 Dec 2020 03:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389813AbgLKCvu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Dec 2020 21:51:50 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:48377 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389750AbgLKCv3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Dec 2020 21:51:29 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UICEwW5_1607655044;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UICEwW5_1607655044)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 11 Dec 2020 10:50:44 +0800
Subject: Re: [PATCH v3 RESEND] iomap: set REQ_NOWAIT according to IOCB_NOWAIT
 in Direct IO
To:     Dave Chinner <david@fromorbit.com>
Cc:     Hao Xu <haoxu@linux.alibaba.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1607075096-94235-1-git-send-email-haoxu@linux.alibaba.com>
 <20201207022130.GC4170059@dread.disaster.area>
 <9bbfafcf-688c-bad9-c288-6478a88c6097@linux.alibaba.com>
 <20201209212358.GE4170059@dread.disaster.area>
 <adf32418-dede-0b58-13da-40093e1e4e2d@linux.alibaba.com>
 <20201210051808.GF4170059@dread.disaster.area>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <fdb6e01a-a662-90fa-3844-410b2107e850@linux.alibaba.com>
Date:   Fri, 11 Dec 2020 10:50:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201210051808.GF4170059@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Excellent explanation! Thanks a lot.

Still some questions below.

On 12/10/20 1:18 PM, Dave Chinner wrote:
> On Thu, Dec 10, 2020 at 09:55:32AM +0800, JeffleXu wrote:
>> Sorry I'm still a little confused.
>>
>>
>> On 12/10/20 5:23 AM, Dave Chinner wrote:
>>> On Tue, Dec 08, 2020 at 01:46:47PM +0800, JeffleXu wrote:
>>>>
>>>>
>>>> On 12/7/20 10:21 AM, Dave Chinner wrote:
>>>>> On Fri, Dec 04, 2020 at 05:44:56PM +0800, Hao Xu wrote:
>>>>>> Currently, IOCB_NOWAIT is ignored in Direct IO, REQ_NOWAIT is only set
>>>>>> when IOCB_HIPRI is set. But REQ_NOWAIT should be set as well when
>>>>>> IOCB_NOWAIT is set.
>>>>>>
>>>>>> Suggested-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>>>>>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>>>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>>>> ---
>>>>>>
>>>>>> Hi all,
>>>>>> I tested fio io_uring direct read for a file on ext4 filesystem on a
>>>>>> nvme ssd. I found that IOCB_NOWAIT is ignored in iomap layer, which
>>>>>> means REQ_NOWAIT is not set in bio->bi_opf.
>>>>>
>>>>> What iomap is doing is correct behaviour. IOCB_NOWAIT applies to the
>>>>> filesystem behaviour, not the block device.
>>>>>
>>>>> REQ_NOWAIT can result in partial IO failures because the error is
>>>>> only reported to the iomap layer via IO completions. Hence we can
>>>>> split a DIO into multiple bios and have random bios in that IO fail
>>>>> with EAGAIN because REQ_NOWAIT is set. This error will
>>>>> get reported to the submitter via completion, and it will override
>>>>> any of the partial IOs that actually completed.
>>>>>
>>>>> Hence, like the recently reported multi-mapping IOCB_NOWAIT bug
>>>>> reported by Jens and fixed in commit 883a790a8440 ("xfs: don't allow
>>>>> NOWAIT DIO across extent boundaries") we'll get silent partial
>>>>> writes occurring because the second submitted bio in an IO can
>>>>> trigger EAGAIN errors with partial IO completion having already
>>>>> occurred.
>>>>>
>>
>>>>> Further, we don't allow partial IO completion for DIO on XFS at all.
>>>>> DIO must be completely submitted and completed or return an error
>>>>> without having issued any IO at all.  Hence using REQ_NOWAIT for
>>>>> DIO bios is incorrect and not desirable.
>>
>>
>> The current block layer implementation causes that, as long as one split
>> bio fails, then the whole DIO fails, in which case several split bios
>> maybe have succeeded and the content has been written to the disk. This
>> is obviously what you called "partial IO completion".
>>
>> I'm just concerned on how do you achieve that "DIO must return an error
>> without having issued any IO at all". Do you have some method of
>> reverting the content has already been written into the disk when a
>> partial error happened?
> 
> I think you've misunderstood what I was saying. I did not say
> "DIO must return an error without having issued any IO at all".
> There are two parts to my statement, and you just smashed part of
> the first statement into part of the second statement and came up
> something I didn't actually say.
> 
> The first statement is:
> 
> 	1. "DIO must be fully submitted and completed ...."
> 
> That is, if we need to break an IO up into multiple parts, the
> entire IO must be submitted and completed as a whole. We do not
> allow partial submission or completion of the IO at all because we
> cannot accurately report what parts of a multi-bio DIO that failed
> through the completion interface. IOWs, if any of the IOs after the
> first one fail submission, then we must complete all the IOs that
> have already been submitted before we can report the failure that
> occurred during the IO.
> 

1. Actually I'm quite not clear on what you called "partial submission
or completion". Even when REQ_NOWAIT is set for all split bios of one
DIO, then all these split bios are **submitted** to block layer through
submit_bio(). Even when one split bio after the first one failed
**inside** submit_bio() because of REQ_NOWAIT, submit_bio() only returns
BLK_QC_T_NONE, and the DIO layer (such as __blkdev_direct_IO()) will
still call submit_bio() for the remaining split bios. And then only when
all split bios complete, will the whole kiocb complete.

So if you define "submission" as submitting to hardware disk (such as
nvme device driver), then it is indeed **partial submission** when
REQ_NOWAIT set. But if the definition of "submission" is actually
"submitting to block layer by calling submit_bio()", then all split bios
of one DIO are indeed submitted to block layer, even when one split bio
gets BLK_STS_AGAIN because of REQ_NOWIAT.


2. One DIO could be split into multiple bios in DIO layer. Similarly one
big bio could be split into multiple bios in block layer. In the
situation when all split bios have already been submitted to block
layer, since the IO completion interface could return only one error
code, the whole DIO could fail as long as one split bio fails, while
several other split bios could have already succeeded and the
corresponding disk sectors have already been overwritten. I'm not sure
if this is what you called "silent partial writes", and if this is the
core reason for commit 883a790a8440 ("xfs: don't allow NOWAIT DIO across
extent boundaries") you mentioned in previous mail.

If this is the case, then it seems that the IO completion interface
should be blamed for this issue. Besides REQ_NOWIAT, there may be more
situations that will cause "silent partial writes".

As long as one split bios could fail (besides EAGAIN, maybe EOPNOTSUPP,
if possible), while other split bios may still succeeds, then the error
of one split bio will still override the completion status of the whole
DIO. In this case "silent partial writes" is still possible? In my
understanding, passing REQ_NOWAIT flags from IOCB_NOWAIT in DIO layer
only makes the problem more likely to happen, but it's not the only
source of this problem?



> The second statement is:
> 
> 	2. "... or return an error without having issued any IO at
> 	   all."
> 
> IO submission errors are only reported by the DIO layer through IO
> completion, in which case #1 is applied. #2 only applies to errors
> that occur before IO submission is started, and these errors are
> directly reported to the caller. IOCB_NOWAIT is a check done before
> we start submission, hence can return -EAGAIN directly to the
> caller.
> 
> IOWs, if an error is returned to the caller, we have either not
> submitted any IO at all, or we have fully submitted and completed
> the IO and there was some error reported by the IO completions.
> There is no scope for "partial IO" here - it either completed fully
> or we got an error.
> 
> This is necessary for correct AIO semantics. We aren't waiting for
> completions to be able to report submission errors to submitters.
> Hence for async IO, the only way for an error in the DIO layer to be
> reported to the submitter is if the error occurs before the first IO
> is submitted.(*)
> 
> RWF_NOWAIT was explicitly intended to enable applications using
> AIO+DIO to avoid long latencies that occur as a result of blocking
> on filesystem locks and resources. Blocking in the request queue is
> minimal latency compared to waiting for (tens of) thousands of IOs
> to complete ((tens of) seconds!) so the filesystem iomap path can run a
> transaction to allocate disk spacei for the DIO.
> 
> IOWS, IOCB_NOWAIT was pretty` much intended to only be seen at the
> filesystem layers to avoid the extremely high latencies that
> filesystem layers might cause.  Blocking for a few milliseconds or
> even tens of milliseconds in the request queue is not a problem
> IOCB_NOWAIT was ever intended to solve.

Don't know the initial intention and history of IOCB_NOWAIT. Learned a
lot. Thanks.

> 
> Really, if io_uring needs DIO to avoid blocking in the request
> queues below the filesystem, it should be providing that guidance
> directly. IOCB_NOWAIT is -part- of the semantics being asked for,
> but it does not provide them all and we can't change them to provide
> exactly what io_uring wants because IOCB_NOWAIT == RWF_NOWAIT
> semantics.
> 
> Cheers,
> 
> Dave.
> 
> (*) Yes, yes, I know that if you have a really fast storage the IO
> might complete before submission has finished, but that's just the
> final completion is done by the submitter and so #1 is actually
> being followed in this case. i.e. IO is fully submitted and
> completed.
> 

-- 
Thanks,
Jeffle
