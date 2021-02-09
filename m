Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956D23148B2
	for <lists+io-uring@lfdr.de>; Tue,  9 Feb 2021 07:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhBIGX3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 01:23:29 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:28686 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230051AbhBIGXO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 01:23:14 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UOHYLzV_1612851742;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UOHYLzV_1612851742)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 09 Feb 2021 14:22:22 +0800
Subject: Re: [PATCH v3 09/11] dm: support IO polling for bio-based dm device
From:   JeffleXu <jefflexu@linux.alibaba.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     snitzer@redhat.com, axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        caspar@linux.alibaba.com, hch@lst.de, linux-block@vger.kernel.org,
        dm-devel@redhat.com, io-uring@vger.kernel.org
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
 <20210208085243.82367-10-jefflexu@linux.alibaba.com>
 <20210209031122.GA63798@T590>
 <a499a33f-da2e-b5aa-5266-9e7c76a34b48@linux.alibaba.com>
Message-ID: <85e0e8eb-d006-cf8b-9604-531070f35507@linux.alibaba.com>
Date:   Tue, 9 Feb 2021 14:22:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <a499a33f-da2e-b5aa-5266-9e7c76a34b48@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2/9/21 2:13 PM, JeffleXu wrote:
> 
> 
> On 2/9/21 11:11 AM, Ming Lei wrote:
>> On Mon, Feb 08, 2021 at 04:52:41PM +0800, Jeffle Xu wrote:
>>> DM will iterate and poll all polling hardware queues of all target mq
>>> devices when polling IO for dm device. To mitigate the race introduced
>>> by iterating all target hw queues, a per-hw-queue flag is maintained
>>
>> What is the per-hw-queue flag?
> 
> Sorry I forgot to update the commit message as the implementation
> changed. Actually this mechanism is implemented by patch 10 of this
> patch set.
> 
>>
>>> to indicate whether this polling hw queue currently being polled on or
>>> not. Every polling hw queue is exclusive to one polling instance, i.e.,
>>> the polling instance will skip this polling hw queue if this hw queue
>>> currently is being polled by another polling instance, and start
>>> polling on the next hw queue.
>>
>> Not see such skip in dm_poll_one_dev() in which
>> queue_for_each_poll_hw_ctx() is called directly for polling all POLL
>> hctxs of the request queue, so can you explain it a bit more about this
>> skip mechanism?
>>
> 
> It is implemented as patch 10 of this patch set. When spin_trylock()
> fails, the polling instance will return immediately, instead of busy
> waiting.
> 
> 
>> Even though such skipping is implemented, not sure if good performance
>> can be reached because hctx poll may be done in ping-pong style
>> among several CPUs. But blk-mq hctx is supposed to have its cpu affinities.
>>
> 
> Yes, the mechanism of iterating all hw queues can make the competition
> worse.
> 
> If every underlying data device has **only** one polling hw queue, then
> this ping-pong style polling still exist, even when we implement split
> bio tracking mechanism, i.e., acquiring the specific hw queue the bio
> enqueued into. Because multiple polling instance has to compete for the
> only polling hw queue.
> 
> But if multiple polling hw queues per device are reserved for multiple
> polling instances, (e.g., every underlying data device has 3 polling hw
> queues when there are 3 polling instances), just as what we practice on
> mq polling, then the current implementation of iterating all hw queues
> will indeed works in a ping-pong style, while this issue shall not exist
> when accurate split bio tracking mechanism could be implemented.
> 

If not considering process migration, I could somehow avoid iterating
all hw queues, still in the framework of the current implementation. For
example. For example, the CPU number of the IO submitting process could
be stored in the cookie, while the polling routine will only iterate hw
queues to which the stored CPU number maps. Just a temporary insight
though ....


-- 
Thanks,
Jeffle
