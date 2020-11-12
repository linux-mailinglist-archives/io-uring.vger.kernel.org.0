Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7582AFF88
	for <lists+io-uring@lfdr.de>; Thu, 12 Nov 2020 07:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgKLGFr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 01:05:47 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:54317 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725966AbgKLGFq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 01:05:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UF2fvup_1605161140;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UF2fvup_1605161140)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 Nov 2020 14:05:41 +0800
Subject: Re: [dm-devel] dm: add support for DM_TARGET_NOWAIT for various
 targets
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     joseph.qi@linux.alibaba.com, dm-devel@redhat.com, koct9i@gmail.com,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20201110065558.22694-1-jefflexu@linux.alibaba.com>
 <20201111153824.GB22834@redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <533a3b6b-146b-afe6-2e3e-d1bc2180a8c8@linux.alibaba.com>
Date:   Thu, 12 Nov 2020 14:05:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201111153824.GB22834@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens and guys in block/io_uring mailing list, this mail contains some 
discussion abount

RWF_NOWAIT, please see the following contents.



On 11/11/20 11:38 PM, Mike Snitzer wrote:
> On Tue, Nov 10 2020 at  1:55am -0500,
> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
>
>> This is one prep patch for supporting iopoll for dm device.
>>
>> The direct IO routine will set REQ_NOWAIT flag for REQ_HIPRI IO (that
>> is, IO will do iopoll) in bio_set_polled(). Then in the IO submission
>> routine, the ability of handling REQ_NOWAIT of the block device will
>> be checked for REQ_HIPRI IO in submit_bio_checks(). -EOPNOTSUPP will
>> be returned if the block device doesn't support REQ_NOWAIT.
> submit_bio_checks() verifies the request_queue has QUEUE_FLAG_NOWAIT set
> if the bio has REQ_NOWAIT.
Yes that's the case.
>
>> DM lacks support for REQ_NOWAIT until commit 6abc49468eea ("dm: add
>> support for REQ_NOWAIT and enable it for linear target"). Since then,
>> dm targets that support REQ_NOWAIT should advertise DM_TARGET_NOWAIT
>> feature.
> I'm not seeing why DM_TARGET_NOWAIT is needed (since you didn't add any
> code that consumes the flag).

As I said, it's needed if we support iopoll for dm device.  Only if a 
block device is capable of

handling NOWAIT, then it can support iopoll.


IO submitted for iopoll (marked with IOCB_HIPRI) is usually also marked 
with REQ_NOWAIT.

There are two scenario when it could happen.


1. io_uring will set REQ_NOWAIT

The IO submission of io_uring can be divided into two phase. First, IO 
will be submitted

synchronously in user process context (when sqthread feature disabled), 
or sqthread

context (when sqthread feature enabled).


```sh
- current process context when sqthread disabled, or sqthread when it's 
enabled
     io_uring_enter
         io_submit_sqes
             io_submit_sqe
                 io_queue_sqe
                     __io_queue_sqe
                         io_issue_sqe // with @force_nonblock is true
                             io_read/io_write
```

In this case, IO should be handled in a NOWAIT way, since the user 
process or sqthread

can not be blocked for performance.

```

io_read/io_write

     /* Ensure we clear previously set non-block flag */
     if (!force_nonblock)
         kiocb->ki_flags &= ~IOCB_NOWAIT;
     else
         kiocb->ki_flags |= IOCB_NOWAIT;

```


2. The direct IO routine will set REQ_NOWAIT for polling IO

Both fs/block_dev.c: __blkdev_direct_IO and fs/iomap/direct-io.c: 
iomap_dio_submit_bio will

call bio_set_polled(), in which will set REQ_NOWAIT for polling IO.


```sh
__blkdev_direct_IO / iomap_dio_submit_bio:
     if (dio->iocb->ki_flags & IOCB_HIPRI)
         bio_set_polled
           bio->bi_opf |= REQ_NOWAIT
```


Thus to support iopoll for dm device, the dm target should be capable of 
handling NOWAIT,

or submit_bio_checks() will fail with -EOPNOTSUPP when submitting bio to 
dm device.


>
> dm-table.c:dm_table_set_restrictions() has:
>
>          if (dm_table_supports_nowait(t))
>                  blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
>          else
>                  blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, q);
>
>> This patch adds support for DM_TARGET_NOWAIT for those dm targets, the
>> .map() algorithm of which just involves sector recalculation.
> So you're looking to constrain which targets will properly support
> REQ_NOWAIT, based on whether they do a simple remapping?

To be honest, I'm a little confused about the semantics of REQ_NOWAIT. 
Jens may had ever

explained it in block or io_uring mailing list, but I can't find the 
specific mail.


The man page explains FMODE_NOWAIT as 'File is capable of returning 
-EAGAIN if I/O will

block'.


And RWF_NOWAIT as

```

               RWF_NOWAIT (since Linux 4.14)
                      Don't wait if the I/O will block for operations 
such as
                      file block allocations, dirty page flush, mutex locks,
                      or a congested block device inside the kernel.  If any
                      of these conditions are met, the control block is re‐
                      turned immediately with a return value of -EAGAIN in
                      the res field of the io_event structure (see
                      io_getevents(2)).

```


commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable it for 
linear

target") handles NOWAIT for DM core as


```

@@ -1802,7 +1802,9 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
         if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
+               if (bio->bi_opf & REQ_NOWAIT)
+                       bio_wouldblock_error(bio);

+               else if (!(bio->bi_opf & REQ_RAHEAD))
                         queue_io(md, bio);

```


Theoretically the block device could advertise QUEUE_FLAG_NOWAIT as long 
as it could

'return -EAGAIN if I/O will block' as the man page said. However, 
considering when the

dm device detected as suspending, the submitted bios are deferred to 
workqueue in

drivers/dm/dm.c: dm_submit_bio. In this case, IO gets **deferred** while 
the user process

will not be **blocked**. Can we say IO gets **blocked** in this case?


Actually several dm targets handle submitted bio in this deferred way, 
such as dm-crypt/

dm-delay/dm-era/dm-ebs. Can we say these targets are not capable of 
handling NOWAIT?


Also when system is short of memory, bio allocation in 
bio_alloc_bioset() may trigger memory

direct reclaim, as the gfp_mask is usually GFP_NOIO. While in memory 
direct reclaim, the

process may be scheduled out, but I have never seen the proper handling 
for NOWAIT in this

situation. Maybe the block or io_uring guys have more insights?


So there's just too many possibilities that may get blocked, not to say 
mutex locks.


>
>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>> Hi Mike,
>>
>> I could split these boilerplate code that each dm target have one
>> seperate patch if you think that would be better.
> One patch for all these is fine.  But it should include the code that I
> assume you'll be adding to dm_table_supports_nowait() to further verify
> that the targets in the table are all DM_TARGET_NOWAIT.
>
> And why isn't dm-linear setting DM_TARGET_NOWAIT?
These are all done in commit 6abc49468eea ("dm: add support for 
REQ_NOWAIT and enable it for
linear target").
>
> Also, other targets _could_ be made to support REQ_NOWAIT by
> conditionally returning bio_wouldblock_error() if appropriate
> (e.g. bio-based dm-multipath's case of queue_if_no_path).



-- 
Thanks,
Jeffle

