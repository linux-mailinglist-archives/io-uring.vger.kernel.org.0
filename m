Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59E32D50EC
	for <lists+io-uring@lfdr.de>; Thu, 10 Dec 2020 03:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgLJCfK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Dec 2020 21:35:10 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:55273 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728822AbgLJCfD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Dec 2020 21:35:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UI6QV8c_1607567639;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UI6QV8c_1607567639)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Dec 2020 10:34:00 +0800
Subject: Re: [PATCH v3 RESEND] iomap: set REQ_NOWAIT according to IOCB_NOWAIT
 in Direct IO
To:     Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Hao Xu <haoxu@linux.alibaba.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1607075096-94235-1-git-send-email-haoxu@linux.alibaba.com>
 <20201207022130.GC4170059@dread.disaster.area>
 <3b33a9e3-0f03-38cc-d484-3f355f75df73@kernel.dk>
 <20201209211558.GD4170059@dread.disaster.area>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <59e5a477-d0b1-adda-34d1-2004a06fdef5@linux.alibaba.com>
Date:   Thu, 10 Dec 2020 10:33:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201209211558.GD4170059@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 12/10/20 5:15 AM, Dave Chinner wrote:
> On Mon, Dec 07, 2020 at 04:40:38PM -0700, Jens Axboe wrote:
>> On 12/6/20 7:21 PM, Dave Chinner wrote:
>>> On Fri, Dec 04, 2020 at 05:44:56PM +0800, Hao Xu wrote:
>>>> Currently, IOCB_NOWAIT is ignored in Direct IO, REQ_NOWAIT is only set
>>>> when IOCB_HIPRI is set. But REQ_NOWAIT should be set as well when
>>>> IOCB_NOWAIT is set.
>>>>
>>>> Suggested-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>>>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>> ---
>>>>
>>>> Hi all,
>>>> I tested fio io_uring direct read for a file on ext4 filesystem on a
>>>> nvme ssd. I found that IOCB_NOWAIT is ignored in iomap layer, which
>>>> means REQ_NOWAIT is not set in bio->bi_opf.
>>>
>>> What iomap is doing is correct behaviour. IOCB_NOWAIT applies to the
>>> filesystem behaviour, not the block device.
>>>
>>> REQ_NOWAIT can result in partial IO failures because the error is
>>> only reported to the iomap layer via IO completions. Hence we can
>>> split a DIO into multiple bios and have random bios in that IO fail
>>> with EAGAIN because REQ_NOWAIT is set. This error will
>>> get reported to the submitter via completion, and it will override
>>> any of the partial IOs that actually completed.
>>>
>>> Hence, like the recently reported multi-mapping IOCB_NOWAIT bug
>>> reported by Jens and fixed in commit 883a790a8440 ("xfs: don't allow
>>> NOWAIT DIO across extent boundaries") we'll get silent partial
>>> writes occurring because the second submitted bio in an IO can
>>> trigger EAGAIN errors with partial IO completion having already
>>> occurred.
>>>
>>> Further, we don't allow partial IO completion for DIO on XFS at all.
>>> DIO must be completely submitted and completed or return an error
>>> without having issued any IO at all.  Hence using REQ_NOWAIT for
>>> DIO bios is incorrect and not desirable.
>>
>> What you say makes total sense for a user using RWF_NOWAIT, but it
>> doesn't make a lot of sense for io_uring where we really want
>> IOCB_NOWAIT to be what it suggests it is - don't wait for other IO to
>> complete, if avoidable. One of the things that really suck with
>> aio/libai is the "yeah it's probably async, but lol, might not be"
>> aspect of it.
> 
> Sure, but we have no way of telling what semantics the IO issuer
> actually requires from above. And because IOCB_NOWAIT behaviour is
> directly exposed to userspace by RWF_NOWAIT, that's the behaviour we
> have to implement.
> 
>> For io_uring, if we do get -EAGAIN, we'll retry without NOWAIT set. So
>> the concern about fractured/short writes doesn't bubble up to the
>> application. Hence we really want an IOCB_NOWAIT_REALLY on that side,
>> instead of the poor mans IOCB_MAYBE_NOWAIT semantics.
> 
> Yup, perhaps what we really want is a true IOCB_NONBLOCK flag as an
> internal kernel implementation. i.e. don't block anywhere in the
> stack, and the caller must handle retrying/completing the entire IO
> regardless of where the -EAGAIN comes from during the IO, including
> from a partial completion that the caller is waiting for...
> 
> i.e. rather than hacking around this specific instance of "it blocks
> and we don't want it to", define the semantics and behaviour of a
> fully non-blocking IO through all layers from the VFS down to the
> hardware and let's implement that. Then we can stop playing
> whack-a-mole with all the "but it blocks when I do this, doctor!"
> issues that we seem to keep having.... :)
> 

From my opinion, the semantics of NOWAIT is clear, just like Jens said,
"don't wait, if**avoidable**". Also it should be the responsibility of
the callers who set this flag to resubmit the failed IO once a -EAGAIN
returned. e.g. if the user app sets RWF_NOWAIT, then it's the
responsibility of the user app to resubmit the failed IO once -EAGAIN
returned. If io_uring layer newly set IOCB_NONBLOCK flag, then it's the
responsibility of io_uring to resubmit.

The limitation here is that once a big DIO/bio got split, then the
atomicity of whole DIO/bio can not be guaranteed. This seems a
limitation of direct IO routine and block layer, and the work of above
layers e.g. filesystem, is needed to guarantee the atomicity.

-- 
Thanks,
Jeffle
