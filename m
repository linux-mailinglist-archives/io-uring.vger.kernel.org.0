Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF7B2D508C
	for <lists+io-uring@lfdr.de>; Thu, 10 Dec 2020 03:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgLJB4X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Dec 2020 20:56:23 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:34418 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727168AbgLJB4R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Dec 2020 20:56:17 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UI5UZl3_1607565332;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UI5UZl3_1607565332)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Dec 2020 09:55:32 +0800
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
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <adf32418-dede-0b58-13da-40093e1e4e2d@linux.alibaba.com>
Date:   Thu, 10 Dec 2020 09:55:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201209212358.GE4170059@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sorry I'm still a little confused.


On 12/10/20 5:23 AM, Dave Chinner wrote:
> On Tue, Dec 08, 2020 at 01:46:47PM +0800, JeffleXu wrote:
>>
>>
>> On 12/7/20 10:21 AM, Dave Chinner wrote:
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


The current block layer implementation causes that, as long as one split
bio fails, then the whole DIO fails, in which case several split bios
maybe have succeeded and the content has been written to the disk. This
is obviously what you called "partial IO completion".

I'm just concerned on how do you achieve that "DIO must return an error
without having issued any IO at all". Do you have some method of
reverting the content has already been written into the disk when a
partial error happened?

> 
> If any part of a DIO fails, we fail the entire IO. When we split a
> DIO into multiple bios and one reports an error, we don't know track
> where in the IO it actually failed, we just fail the entire IO.
> 
> e.g. how do you report correct partial completion to userspace when
> a DIO gets split into 3 pieces and the middle one fails? There are
> two ranges that actually completed, but we can only report one of
> them....
> 
> And, really, we still need to report that an IO failed to userspace,
> because mission critical apps care more about the fact that an IO
> failure occurred than silently swallowing the IO error with a
> (potentially incorrect) partial IO completion notification.



-- 
Thanks,
Jeffle
