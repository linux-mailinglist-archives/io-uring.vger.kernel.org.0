Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462CC336CB7
	for <lists+io-uring@lfdr.de>; Thu, 11 Mar 2021 08:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhCKHHt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 02:07:49 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:51120 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230458AbhCKHHX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 02:07:23 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0URQREIY_1615446438;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0URQREIY_1615446438)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 11 Mar 2021 15:07:19 +0800
Subject: Re: [dm-devel] [PATCH v3 00/11] dm: support IO polling
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     axboe@kernel.dk, ejt@redhat.com, caspar@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        joseph.qi@linux.alibaba.com, dm-devel@redhat.com, hch@lst.de
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
 <20210310200127.GA22542@redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <a67102b8-d799-c072-3d57-5267e3ea060e@linux.alibaba.com>
Date:   Thu, 11 Mar 2021 15:07:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210310200127.GA22542@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 3/11/21 4:01 AM, Mike Snitzer wrote:
> On Mon, Feb 08 2021 at  3:52am -0500,
> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> 
>>
>> [Performance]
>> 1. One thread (numjobs=1) randread (bs=4k, direct=1) one dm-linear
>> device, which is built upon 3 nvme devices, with one polling hw
>> queue per nvme device.
>>
>>      | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
>> ---- | --------------- | -------------------- | ----
>>   dm | 		  208k |		 279k | ~34%
>>
>>
>> 2. Three threads (numjobs=3) randread (bs=4k, direct=1) one dm-linear
>> device, which is built upon 3 nvme devices, with one polling hw
>> queue per nvme device.
>>
>> It's compared to 3 threads directly randread 3 nvme devices, with one
>> polling hw queue per nvme device. No CPU affinity set for these 3
>> threads. Thus every thread can access every nvme device
>> (filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1), i.e., every thread
>> need to competing for every polling hw queue.
>>
>>      | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
>> ---- | --------------- | -------------------- | ----
>>   dm | 		  615k |		 728k | ~18%
>> nvme | 		  728k |		 873k | ~20%
>>
>> The result shows that the performance gain of bio-based polling is
>> comparable as that of mq polling in the same test case.
>>
>>
>> 3. Three threads (numjobs=3) randread (bs=12k, direct=1) one
>> **dm-stripe** device, which is built upon 3 nvme devices, with one
>> polling hw queue per nvme device.
>>
>> It's compared to 3 threads directly randread 3 nvme devices, with one
>> polling hw queue per nvme device. No CPU affinity set for these 3
>> threads. Thus every thread can access every nvme device
>> (filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1), i.e., every thread
>> need to competing for every polling hw queue.
>>
>>      | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
>> ---- | --------------- | -------------------- | ----
>>   dm | 		  314k |		 354k | ~13%
>> nvme | 		  728k |		 873k | ~20%
>>
> 
> So this "3." case is meant to illustrate effects of polling when bio is
> split to 3 different underlying blk-mq devices. (think it odd that
> dm-stripe across 3 nvme devices is performing so much worse than a
> single nvme device)
> 
> Would be nice to see comparison of this same workload but _with_ CPU
> affinity to show relative benefit of your patch 11 in this series (where
> you try to leverage CPU pinning).

Actually I have done the test. You can see that without the optimization
in patch 1,, i.e., to leverage CPU pinning, there's only ~13%
performance gain of polling.

As I stated here [1] (see the clause two "2. sub-fastpath"), with the
optimization in patch 11, the performance gain is ~32%. The optimization
behave well. It mainly decreases the race where multiple CPUs competing
for the same hw queue.


[1]
https://patchwork.kernel.org/project/dm-devel/cover/20210303115740.127001-1-jefflexu@linux.alibaba.com/

> 
> In general, I don't think patch 11 a worthwhile effort.  It is a
> half-measure that is trying to paper over the fact that this bio-based
> IO polling patchset is quite coarse grained about how it copes with the
> need to poll multiple devices.

Indeed. It is a result of somewhat compromise. If we have better scheme
improving multi-thread performance, it shall certainly go... I can
explain the difficulty of implementing the optimization in other ways in
the following comment.

> 
> Patch 10 is a proper special case that should be accounted for (when a
> bio isn't split and only gets submitted to a single blk-mq
> device/hctx).  But even patch 10's approach is fragile (we we've
> discussed in private and I'll touch on in reply to patch 10).
> 
> But I think patch 11 should be dropped and we defer optimizing bio
> splitting at a later time with follow-on work.
> 
> Just so you're aware, I'm now thinking the proper way forward is to
> update DM core, at the time of DM table load, to assemble an array of
> underlying _data_ devices in that table (as iterated with
> .iterate_devices) -- this would allow each underlying data device to be
> assigned an immutable index for the lifetime of a DM table.  It'd be
> hooked off the 'struct dm_table' and would share that object's
> lifetime.

I have also considered it. There's two way organizing the table, with
each having its own defect though.

1. Each dm table maintains underlying devices at its own level, e.g., if
dm-0 is built upon dm-1, then the dm table of dm-0 maintains all
underlying devices of dm-0, while the dm table of dm-1 maintaining its
own underlying devices.

In this case, there are multiple arrays at each level. If the returned
cookie is still one integer type, it may be difficult to design the
cookie, making it reflecting one slot among all these multiple arrays.

If the returned cookie is actually a group of indexes, with each
indexing one dm table, then where and how to store these indexes...


2. The dm device at the top most level maintains a large array,
aggregating all underlying devices on all levels.

In this case, one unique array is maintained and one cookie of integer
type is enough. However the defect is that, when one underlying dm
device reloads table, how and when to update the array in the top most
level.

> 
> With that bit of infrastructure in place, we could then take steps to
> make DM's cookie more dense in its description of underlying devices
> that need polling.  This is where I'll get a bit handwavvy.. but I
> raised this idea with Joe Thornber and he is going to have a think about
> it too.
> 
> But this is all to say: optimizing the complex case of bio-splitting
> that is such an integral part of bio-based IO processing needs more than
> what you've attempted to do (noble effort on your part but again, really
> just a half-measure).
> 
> SO I think it best to keep the initial implementation of bio-based
> polling relatively simple by laying foundation for follow-on work.  And
> it is also important to _not_ encode in block core some meaning to what
> _should_ be a largely opaque cookie (blk_qc_t) that is for the
> underlying driver to make sense of.
> 

Agreed. The difficulty of the design pattern is explained in the
corresponding reply for v5.

> 
>>
>> 4. This patchset shall do no harm to the performance of the original mq
>> polling. Following is the test results of one thread (numjobs=1)
>> randread (bs=4k, direct=1) one nvme device.
>>
>> 	    	 | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
>> ---------------- | --------------- | -------------------- | ----
>> without patchset | 	      242k |		     332k | ~39%
>> with patchset    |	      236k |		     332k | ~39%
> 
> OK, good, this needs to be the case.
> 
>>
>> [Changes since v2]
>>
>> Patchset v2 caches all hw queues (in polling mode) of underlying mq
>> devices in dm layer. The polling routine actually iterates through all
>> these cached hw queues.
>>
>> However, mq may change the queue mapping at runtime (e.g., NVMe RESET
>> command), thus the cached hw queues in dm layer may be out-of-date. Thus
>> patchset v3 falls back to the implementation of the very first RFC
>> version, in which the mq layer needs to export one interface iterating
>> all polling hw queues (patch 5), and the bio-based polling routine just
>> calls this interface to iterate all polling hw queues.
>>
>> Besides, several new optimization is proposed.
>>
>>
>> - patch 1,2,7
>> same as v2, untouched
>>
>> - patch 3
>> Considering advice from Christoph Hellwig, while refactoring blk_poll(),
>> split mq and bio-based polling routine from the very beginning. Now
>> blk_poll() is just a simple entry. blk_bio_poll() is simply copied from
>> blk_mq_poll(), while the loop structure is some sort of duplication
>> though.
>>
>> - patch 4
>> This patch is newly added to support turning on/off polling through
>> '/sys/block/<dev>/queue/io_poll' dynamiclly for bio-based devices.
>> Patchset v2 implemented this functionality by added one new queue flag,
>> which is not preferred since the queue flag resource is quite short of
>> nowadays.
>>
>> - patch 5
>> This patch is newly added, preparing for the following bio-based
>> polling. The following bio-based polling will call this helper function,
>> accounting on the corresponding hw queue.
>>
>> - patch 6
>> It's from the very first RFC version, preparing for the following
>> bio-based polling.
>>
>> - patch 8
>> One fixing patch needed by the following bio-based polling. It's
>> actually a v2 of [1]. I had sent the v2 singly in-reply-to [1], though
>> it has not been visible on the mailing list maybe due to the delay.
>>
>> - patch 9
>> It's from the very first RFC version.
>>
>> - patch 10
>> This patch is newly added. Patchset v2 had ever proposed one
>> optimization that, skipping the **busy** hw queues during the iteration
>> phase. Back upon that time, one flag of 'atomic_t' is specifically
>> maintained in dm layer, representing if the corresponding hw queue is
>> busy or not. The idea is inherited, while the implementation changes.
>> Now @nvmeq->cq_poll_lock is used directly here, no need for extra flag
>> anymore.
>>
>> This optimization can significantly reduce the competition for one hw
>> queue between multiple polling instances. Following statistics is the
>> test result when 3 threads concurrently randread (bs=4k, direct=1) one
>> dm-linear device, which is built upon 3 nvme devices, with one polling
>> hw queue per nvme device.
>>
>> 	    | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
>> ----------- | --------------- | -------------------- | ----
>> without opt | 		 318k |		 	256k | ~-20%
>> with opt    |		 314k |		 	354k | ~13%
>> 							
>>
>> - patch 11
>> This is another newly added optimizatin for bio-based polling.
>>
>> One intuitive insight is that, when the original bio submitted to dm
>> device doesn't get split, then the bio gets enqueued into only one hw
>> queue of one of the underlying mq devices. In this case, we no longer
>> need to track all split bios, and one cookie (for the only split bio)
>> is enough. It is implemented by returning the pointer to the
>> corresponding hw queue in this case.
>>
>> It should be safe by directly returning the pointer to the hw queue,
>> since 'struct blk_mq_hw_ctx' won't be freed during the whole lifetime of
>> 'struct request_queue'. Even when the number of hw queues may decrease
>> when NVMe RESET happens, the 'struct request_queue' structure of decreased
>> hw queues won't be freed, instead it's buffered into
>> &q->unused_hctx_list list.
>>
>> Though this optimization seems quite intuitive, the performance test
>> shows that it does no benefit nor harm to the performance, while 3
>> threads concurrently randreading (bs=4k, direct=1) one dm-linear
>> device, which is built upon 3 nvme devices, with one polling hw queue
>> per nvme device.
>>
>> I'm not sure why it doesn't work, maybe because the number of devices,
>> or the depth of the devcice stack is to low in my test case?
> 
> Looks like these patch references are stale (was relative to v3 I
> think).. e.g: "patch 11" from v3 is really "patch 10" in v5.. but its
> implementation has changed because Mikulas pointed out that the
> implementation was unsafe.. IIRC?
> 
> Anyway, I'll just focus on reviewing each patch in this v5 now.
> 
> Thanks,
> Mike
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 

-- 
Thanks,
Jeffle
