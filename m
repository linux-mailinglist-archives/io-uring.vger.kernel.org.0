Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1E62957E3
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 07:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502787AbgJVF2H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 01:28:07 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:59887 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502763AbgJVF2H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 01:28:07 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UCoWYuG_1603344481;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UCoWYuG_1603344481)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 22 Oct 2020 13:28:02 +0800
Subject: Re: [RFC 0/3] Add support of iopoll for dm device
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
        joseph.qi@linux.alibaba.com, xiaoguang.wang@linux.alibaba.com,
        haoxu@linux.alibaba.com, io-uring@vger.kernel.org
References: <20201020065420.124885-1-jefflexu@linux.alibaba.com>
 <20201021203906.GA10896@redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
Date:   Thu, 22 Oct 2020 13:28:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201021203906.GA10896@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 10/22/20 4:39 AM, Mike Snitzer wrote:

> What you've _done_ could serve as a stop-gap but I'd really rather we
> get it properly designed from the start.

Indeed I totally agree with you that the design should be done nicely at 
the very beginning. And this

is indeed the purpose of this RFC patch.


>> This patch set adds support of iopoll for dm device.
>>
>> This is only an RFC patch. I'm really looking forward getting your
>> feedbacks on if you're interested in supporting iopoll for dm device,
>> or if there's a better design to implement that.
>>
>> Thanks.
>>
>>
>> [Purpose]
>> IO polling is an important mode of io_uring. Currently only mq devices
>> support iopoll. As for dm devices, only dm-multipath is request-base,
>> while others are all bio-based and have no support for iopoll.
>> Supporting iopoll for dm devices can be of great meaning when the
>> device seen by application is dm device such as dm-linear/dm-stripe,
>> in which case iopoll is not usable for io_uring.
> I appreciate you taking the initiative on this; polling support is on my
> TODO so your work serves as a nice reminder to pursue this more
> urgently.

It's a good news that iopoll for DM is meaningful.


> but we cannot avoid properly mapping a cookie to each
> split bio.  Otherwise you resort to inefficiently polling everything.

Yes. At the very beginning  I tried to build the mapping a cookie to 
each bio, but I failed with several

blocking design issues. By the way maybe we could clarify these design 
issues here, if you'd like.


>
> Seems your attempt to have the cookie point to a dm_io object was likely
> too coarse-grained (when bios are split they get their own dm_io on
> recursive re-entry to DM core from ->submit_bio); but isn't having a
> list of cookies still too imprecise for polling purposes?  You could
> easily have a list that translates to many blk-mq queues.  Possibly
> better than your current approach of polling everything -- but not
> much.

To make the discussion more specific, assume that dm0 is mapped to 
dm1/2/3, while dm1 mapped to

nvme1, dm2 mapped to dm2, etc..

                     dm0

dm1             dm2            dm3

nvme1        nvme2        nvme3


Then the returned cookie of dm0 could be pointer pointing to dm_io 
object of dm0.

struct dm_io {  // the returned cookie points to dm_io object
	...
+	struct list_head cookies;
};

struct dm_target_io {
	...
	/*
	 * The corresponding polling hw queue if submitted to mq device (such as nvme1/2/3),
	 * NULL if submitted to dm device (such as dm1/2/3)
	 */
+	struct blk_mq_hw_ctx *hctx;
+	struct list_head      node;  // add to @cookies list
};

The @cookies list of dm_io object could maintain all dm_target_io objects
of all **none-dm** devices, that is, all hw queues that we should poll on.


returned  ->  @cookies list	
cookie	      of dm_io object of dm0
		   |
		   +--> dm_target_io	 ->  dm_target_io     ->  dm_target_io
			object of nvme1      object of nvme2	  object of nvme3

When polling returned cookie of dm0, actually we're polling @cookies 
list. Once one of the dm_target_io

completed (e.g. nvme2), it should be removed from the @cookies list., 
and thus we should only focus on

hw queues that have not completed.



>> [Design Notes]
>>
>> cookie
>> ------
>> Let's start from cookie. Cookie is one important concept in iopoll. It
>> is used to identify one specific request in one specific hardware queue.
>> The concept of cookie is initially designed as a per-bio concept, and
>> thus it doesn't work well when bio-split involved. When bio is split,
>> the returned cookie is indeed the cookie of one of the split bio, and
>> the following polling on this returned cookie can only guarantee the
>> completion of this specific split bio, while the other split bios may
>> be still uncompleted. Bio-split is also resolved for dm device, though
>> in another form, in which case the original bio submitted to the dm
>> device may be split into multiple bios submitted to the underlying
>> devices.
>>
>> In previous discussion, Lei Ming has suggested that iopoll should be
>> disabled for bio-split. This works for the normal bio-split (done in
>> blk_mq_submit_bio->__blk_queue_split), while iopoll will never be
>> usable for dm devices if this also applies for dm device.
>>
>> So come back to the design of the cookie for dm devices. At the very
>> beginning I want to refactor the design of cookie, from 'unsigned int'
>> type to the pointer type for dm device, so that cookie can point to
>> something, e.g. a list containing all cookies of one original bio,
>> something like this:
>>
>> struct dm_io { // the returned cookie points to dm_io
>> 	...
>> 	struct list_head cookies;
>> };
>>
>> In this design, we can fetch all cookies of one original bio, but the
>> implementation can be difficult and buggy. For example, the
>> 'struct dm_io' structure may be already freed when the returned cookie
>> is used in blk_poll(). Then what if maintain a refcount in struct dm_io
>> so that 'struct dm_io' structure can not be freed until blk_poll()
>> called? Then the 'struct dm_io' structure will never be freed if the
>> IO polling is not used at all.
> I'd have to look closer at the race in the code you wrote (though you
> didn't share it);

I worried that dm_target_io/dm_io objects could have been freed 
before/when we are polling on them,

and thus could cause use-after-free when accessing @cookies list in 
dm_target_io. It could happen

when there are multiple polling instance. io_uring has implemented 
per-instance polling thread. If

there are two bios submitted to dm0, please consider the following race 
sequence:


1. race 1: dm_target_io/dm_io objects could have been freed ****when**** 
we are polling on them

```*
*

*thread1 polling on bio1                    thread2 polling on bio2*

     fetch dm_io object by the cookie

reaps completions in nvme 1/2/3,

completes bio1 and frees dm_io object of bio1 by the way

     use-after-free when accessing dm_io object

```

Maybe we should get a refcount of dm_io of bio1 when start polling, but 
I'm not sure if the design is

elegant or not.



2. race 2: dm_target_io/dm_io objects could have been freed 
****before**** we are polling on them

```

*thread1 polling on bio1                    thread2 polling on bio2*

reaps completions in nvme 1/2/3,

clone_endio

     dec_pending

         free_io(md, io);  // free dm_io object

     __blkdev_direct_IO

         READ_ONCE(dio->waiter)  // dio->waiter is still none-NULL

         bio_endio(io->orig_bio) //call bi_end_io() of original bio, 
that is blkdev_bio_end_io

             WRITE_ONCE(dio->waiter, NULL);

         blk_poll

             fetch dm_io object by the cookie  // use-after-free!

```


Thanks.

Jeffle.

