Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A53314ABE
	for <lists+io-uring@lfdr.de>; Tue,  9 Feb 2021 09:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhBIIsn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 03:48:43 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:55181 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230139AbhBIIqq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 03:46:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UOHsEzl_1612860361;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UOHsEzl_1612860361)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 09 Feb 2021 16:46:02 +0800
Subject: Re: [PATCH v3 09/11] dm: support IO polling for bio-based dm device
To:     Ming Lei <ming.lei@redhat.com>
Cc:     snitzer@redhat.com, axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        caspar@linux.alibaba.com, hch@lst.de, linux-block@vger.kernel.org,
        dm-devel@redhat.com, io-uring@vger.kernel.org
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
 <20210208085243.82367-10-jefflexu@linux.alibaba.com>
 <20210209031122.GA63798@T590>
 <a499a33f-da2e-b5aa-5266-9e7c76a34b48@linux.alibaba.com>
 <20210209080739.GB94287@T590>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <4ac63594-7764-dc13-a217-50a96cd9a93c@linux.alibaba.com>
Date:   Tue, 9 Feb 2021 16:46:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209080739.GB94287@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2/9/21 4:07 PM, Ming Lei wrote:
> On Tue, Feb 09, 2021 at 02:13:38PM +0800, JeffleXu wrote:
>>
>>
>> On 2/9/21 11:11 AM, Ming Lei wrote:
>>> On Mon, Feb 08, 2021 at 04:52:41PM +0800, Jeffle Xu wrote:
>>>> DM will iterate and poll all polling hardware queues of all target mq
>>>> devices when polling IO for dm device. To mitigate the race introduced
>>>> by iterating all target hw queues, a per-hw-queue flag is maintained
>>>
>>> What is the per-hw-queue flag?
>>
>> Sorry I forgot to update the commit message as the implementation
>> changed. Actually this mechanism is implemented by patch 10 of this
>> patch set.
> 
> It is hard to associate patch 10's spin_trylock() with per-hw-queue
> flag. 

You're right, the commit message here is totally a mistake. Actually I
had ever implemented a per-hw-queue flag, such as

```
struct blk_mq_hw_ctx {
	atomic_t busy;
	...
};
```

In this case, the skipping mechanism is implemented in block layer.


But later I refactor the code and move the implementation to the device
driver layer as described by patch 10, while forgetting to update the
commit message. The reason why I implement it in device driver layer is
that, the competition actually stems from the underlying device driver
(e.g., nvme driver), as described in the following snippet.

```
nvme_poll
	spin_lock(&nvmeq->cq_poll_lock);
	found = nvme_process_cq(nvmeq);
	spin_unlock(&nvmeq->cq_poll_lock);
```

It is @nvmeq->cq_poll_lock, i.e., the implementation of the underlying
device driver that has caused the competition. Thus maybe it is
reasonable to handle the competition issue in the device driver layer?


> Also scsi's poll implementation is in-progress, and scsi's poll may
> not be implemented in this way.

Yes. The defect of leaving the competition issue to the device driver
layer is that, every device driver supporting polling need to be somehow
optimized individually. Actually I have not taken a close look at the
other two types of nvme driver (drivers/nvme/host/tcp.c and
drivers/nvme/host/rdma.c), which also support polling.



>>
>>>
>>>> to indicate whether this polling hw queue currently being polled on or
>>>> not. Every polling hw queue is exclusive to one polling instance, i.e.,
>>>> the polling instance will skip this polling hw queue if this hw queue
>>>> currently is being polled by another polling instance, and start
>>>> polling on the next hw queue.
>>>
>>> Not see such skip in dm_poll_one_dev() in which
>>> queue_for_each_poll_hw_ctx() is called directly for polling all POLL
>>> hctxs of the request queue, so can you explain it a bit more about this
>>> skip mechanism?
>>>
>>
>> It is implemented as patch 10 of this patch set. When spin_trylock()
>> fails, the polling instance will return immediately, instead of busy
>> waiting.
>>
>>
>>> Even though such skipping is implemented, not sure if good performance
>>> can be reached because hctx poll may be done in ping-pong style
>>> among several CPUs. But blk-mq hctx is supposed to have its cpu affinities.
>>>
>>
>> Yes, the mechanism of iterating all hw queues can make the competition
>> worse.
>>
>> If every underlying data device has **only** one polling hw queue, then
>> this ping-pong style polling still exist, even when we implement split
>> bio tracking mechanism, i.e., acquiring the specific hw queue the bio
>> enqueued into. Because multiple polling instance has to compete for the
>> only polling hw queue.
>>
>> But if multiple polling hw queues per device are reserved for multiple
>> polling instances, (e.g., every underlying data device has 3 polling hw
>> queues when there are 3 polling instances), just as what we practice on
>> mq polling, then the current implementation of iterating all hw queues
>> will indeed works in a ping-pong style, while this issue shall not exist
>> when accurate split bio tracking mechanism could be implemented.
> 
> In reality it could be possible to have one hw queue for each numa node.
> 
> And you may re-use blk_mq_map_queue() for getting the proper hw queue for poll.

Thanks. But the optimization I proposed in [1] may not works well when
the IO submitting process migrates to another CPU halfway. I mean, the
process has submitted several split bios, and then it migrates to
another CPU and moves on submitting the left split bios.

[1]
https://lore.kernel.org/io-uring/20210208085243.82367-1-jefflexu@linux.alibaba.com/T/#m0d9a0e55e11874a70c6a3491f191289df72a84f8

-- 
Thanks,
Jeffle
