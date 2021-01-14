Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A192F5D20
	for <lists+io-uring@lfdr.de>; Thu, 14 Jan 2021 10:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbhANJRP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jan 2021 04:17:15 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:51902 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726478AbhANJRN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jan 2021 04:17:13 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0ULhhF75_1610615776;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0ULhhF75_1610615776)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 Jan 2021 17:16:17 +0800
Subject: Re: [dm-devel] [PATCH RFC 6/7] block: track cookies of split bios for
 bio-based device
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
 <20201223112624.78955-7-jefflexu@linux.alibaba.com>
 <20210107221825.GF21239@redhat.com>
 <97ec2025-4937-b476-4f15-446cc304e799@linux.alibaba.com>
 <20210108172635.GA29915@redhat.com>
 <16ba3a63-86f5-1acd-c129-767540186689@linux.alibaba.com>
 <20210112161320.GA13931@redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <56e1f2a2-9300-e3c8-4013-9d371385a082@linux.alibaba.com>
Date:   Thu, 14 Jan 2021 17:16:16 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210112161320.GA13931@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 1/13/21 12:13 AM, Mike Snitzer wrote:
> On Tue, Jan 12 2021 at 12:46am -0500,
> JeffleXu <jefflexu@linux.alibaba.com> wrote:
> 
>>
>>
>> On 1/9/21 1:26 AM, Mike Snitzer wrote:
>>> On Thu, Jan 07 2021 at 10:08pm -0500,
>>> JeffleXu <jefflexu@linux.alibaba.com> wrote:
>>>
>>>> Thanks for reviewing.
>>>>
>>>>
>>>> On 1/8/21 6:18 AM, Mike Snitzer wrote:
>>>>> On Wed, Dec 23 2020 at  6:26am -0500,
>>>>> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
>>>>>
>>>>>> This is actuaaly the core when supporting iopoll for bio-based device.
>>>>>>
>>>>>> A list is maintained in the top bio (the original bio submitted to dm
>>>>>> device), which is used to maintain all valid cookies of split bios. The
>>>>>> IO polling routine will actually iterate this list and poll on
>>>>>> corresponding hardware queues of the underlying mq devices.
>>>>>>
>>>>>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>>>>>
>>>>> Like I said in response to patch 4 in this series: please fold patch 4
>>>>> into this patch and _really_ improve this patch header.
>>>>>
>>>>> In particular, the (ab)use of bio_inc_remaining() needs be documented in
>>>>> this patch header very well.
>>>>>
>>>>> But its use could easily be why you're seeing a performance hit (coupled
>>>>> with the extra spinlock locking and list management used).  Just added
>>>>> latency and contention across CPUs.
>>>>
>>>> Indeed bio_inc_remaining() is abused here and the code seems quite hacky
>>>> here.
>>>>
>>>> Actually I'm regarding implementing the split bio tracking mechanism in
>>>> a recursive way you had ever suggested. That is, the split bios could be
>>>> maintained in an array, which is allocated with 'struct dm_io'. This way
>>>> the overhead of spinlock protecting the &root->bi_plist may be omitted
>>>> here. Also the lifetime management may be simplified somehow. But the
>>>> block core needs to fetch the per-bio private data now, just like what
>>>> you had ever suggested before.
>>>>
>>>> How do you think, Mike?
>>>
>>> Yes, using per-bio-data is a requirement (we cannot bloat 'struct bio').
>>
>> Agreed. Then MD will need some refactor to support IO polling, if
>> possible, since just like I mentioned in patch 0 before, MD doesn't
>> allocate extra clone bio, and just re-uses the original bio structure.
>>
>>
>>>
>>> As for using an array, how would you index the array?  
>>
>> The 'array' here is not an array of 'struct blk_mq_hw_ctx *' maintained
>> in struct dm_table as you mentioned. Actually what I mean is to maintain
>> an array of struct dm_poll_data (or something like that, e.g. just
>> struct blk_mq_hw_ctx *) in per-bio private data. The size of the array
>> just equals the number of the target devices.
>>
>> For example, for the following device stack,
>>
>>>>
>>>> Suppose we have the following device stack hierarchy, that is, dm0 is
>>>> stacked on dm1, while dm1 is stacked on nvme0 and nvme1.
>>>>
>>>>     dm0
>>>>     dm1
>>>> nvme0  nvme1
>>>>
>>>>
>>>> Then the bio graph is like:
>>>>
>>>>
>>>>                                    +------------+
>>>>                                    |bio0(to dm0)|
>>>>                                    +------------+
>>>>                                          ^
>>>>                                          | orig_bio
>>>>                                    +--------------------+
>>>>                                    |struct dm_io A      |
>>>> +--------------------+ bi_private  ----------------------
>>>> |bio3(to dm1)        |------------>|bio1(to dm1)        |
>>>> +--------------------+             +--------------------+
>>>>         ^                                ^
>>>>         | ->orig_bio                     | ->orig_bio
>>>> +--------------------+             +--------------------+
>>>> |struct dm_io        |             |struct dm_io B      |
>>>> ----------------------             ----------------------
>>>> |bio2(to nvme0)      |             |bio4(to nvme1)      |
>>>> +--------------------+             +--------------------+
>>>>
>>
>> An array of struct blk_mq_hw_ctx * is maintained in struct dm_io B.
>>
>>
>> struct blk_mq_hw_ctx * hctxs[2];
>>
>> The array size is two since dm1 maps to two target devices (i.e. nvme0
>> and nvme1). Then hctxs[0] points to the hw queue of nvme0, while
>> hctxs[1] points to the hw queue of nvme1.
> 
> Both nvme0 and nvme1 may have multiple hctxs.  Not sure why you're
> thinking there is just one per device?
> 
>>
>>
>> This mechanism supports arbitrary device stacking. Similarly, an array
>> of struct blk_mq_hw_ctx * is maintained in struct dm_io A. The array
>> size is one since dm0 only maps to one target device (i.e. dm1). In this
>> case, hctx[0] points to the struct dm_io of the next level, i.e. struct
>> dm_io B.
>>
>>
>> But I'm afraid the implementation of this style may be more complex.
> 
> We are running the risk of talking in circles about this design...

Sorry for the inconvenience. I have started working on the next version,
but I do want to clarify some design issues first.

> 
> 
>>>> struct node {
>>>>     struct blk_mq_hw_ctx *hctx;
>>>>     blk_qc_t cookie;
>>>> };
>>>
>>> Needs a better name, think I had 'struct dm_poll_data'
>>
>> Sure, the name here is just for example.
>>
>>
>>>  
>>>> Actually currently the tracking objects are all allocated with 'struct
>>>> bio', then the lifetime management of the tracking objects is actually
>>>> equivalent to lifetime management of bio. Since the returned cookie is
>>>> actually a pointer to the bio, the refcount of this bio must be
>>>> incremented, since we release a reference to this bio through the
>>>> returned cookie, in which case the abuse of the refcount trick seems
>>>> unavoidable? Unless we allocate the tracking object individually, then
>>>> the returned cookie is actually pointing to the tracking object, and the
>>>> refcount is individually maintained for the tracking object.
>>>
>>> The refcounting and lifetime of the per-bio-data should all work as is.
>>> Would hope you can avoid extra bio_inc_remaining().. that infratsructure
>>> is way too tightly coupled to bio_chain()'ing, etc.
>>>
>>> The challenge you have is the array that would point at these various
>>> per-bio-data needs to be rooted somewhere (you put it in the topmost
>>> original bio with the current patchset).  But why not manage that as
>>> part of 'struct mapped_device'?  It'd need proper management at DM table
>>> reload boundaries and such but it seems like the most logical place to
>>> put the array.  But again, this array needs to be dynamic.. so thinking
>>> further, maybe a better model would be to have a fixed array in 'struct
>>> dm_table' for each hctx associated with a blk_mq _data_ device directly
>>> used/managed by that dm_table?
>>

Confusion also stated in the following comment. How 'struct
dm_poll_data' could be involved with 'struct dm_table' or 'struct
mapped_device'. In the current patchset, every bio need to maintain one
list to track all its 'struct dm_poll_data' structures. Then how to
maintain this per-bio information in one single 'struct dm_table' or
'struct mapped_device'?


>> It seems that you are referring 'array' here as an array of 'struct
>> blk_mq_hw_ctx *'? Such as
>>
>> struct dm_table {
>>     ...
>>     struct blk_mq_hw_ctx *hctxs[];
>> };
>>
>> Certainly with this we can replace the original 'struct blk_mq_hw_ctx *'
>> pointer in 'struct dm_poll_data' with the index into this array, such as
>>
>> struct dm_poll_data {
>>      int hctx_index; /* index into dm_table->hctxs[] */
>>      blk_qc_t cookie;
>> };
> 
> You seized on my mentioning blk-mq's array of hctx too literally.  I was
> illustrating that blk-mq's cookie is converted to an index into that
> array.
> 
> But for this DM bio-polling application we'd need to map the blk-mq
> returned cookie to a request_queue.  Hence the original 2 members of
> dm_poll_data needing to be 'struct request_queue *' and blk_qc_t.
> 
>> But I'm doubted if this makes much sense. The core difficulty here is
>> maintaining a list (or dynamic sized array) to track all split bios.
>> With the array of 'struct blk_mq_hw_ctx *' maintained in struct
>> dm_table, we still need some **per-bio** structure (e.g., &bio->bi_plist
>> in current patch set) to track these split bios.
> 
> One primary goal of all of this design is to achieve bio-polling cleanly
> (without extra locking, without block core data structure bloat, etc).
> I know you share that goal.  But we need to nail down the core data
> structures and what needs tracking at scale and then associate them with
> DM's associated objects with consideration for object lifetime.
> 
> My suggestion was to anchor your core data structures (e.g. 'struct
> dm_poll_data' array, etc) to 'struct dm_table'.  I suggested that
> because the dm_table is what dm_get_device()s each underlying _data_
> device (a subset of all devices in a dm_table, as iterated through
> .iterate_devices).  But a DM 'struct mapped_device' has 2 potential
> dm_tables, active and inactive slots, that would imply some complexity
> in handing off any outstanding bio's associated 'struct dm_poll_data'
> array on DM table reload.

1) If 'struct dm_poll_data' resides in per-bio-data, then how do you
**link** or **associate** all the 'struct dm_poll_data' structures from
one original bio? Do we link them by the internal relationship between
bio/dm_io/dm_target_io, or some other auxiliary data structure?

2) I get confused how 'struct dm_poll_data' could be involved with
'struct dm_table'. Is there an array of 'struct dm_poll_data' or 'struct
dm_poll_data *' maintained in 'struct dm_table'? If this is the case,
then the size of the array may be incredible large, or expanded/shrank
frequently, since one dm_table could correspond to millions bios.



> 
> Anyway, you seem to be gravitating to a more simplistic approach of a
> single array of 'struct dm_poll_data' for each DM device (regardless of
> how arbitrarily deep that DM device stack is, the topmost DM device
> would accumulate the list of 'struct dm_poll_data'?).

I'm open to this. At least you don't need to care the lifetime of other
disparate 'struct dm_poll_data's, if all 'struct dm_poll_data's are
accumulated in one (e.g., the topmost) place.


> 
> I'm now questioning the need for any high-level data structure to track
> all N of the 'struct dm_poll_data' that may result from a given bio (as
> it is split to multiple blk-mq hctxs across multiple blk-mq devices).
> Each 'struct dm_poll_data', that will be returned to block core and
> stored in struct kiocb's ki_cookie, would have an object lifetime that
> matches the original DM bio clone's per-bio-data that the 'struct
> dm_poll_data' was part of; then we just need to cast that ki_cookie's
> blk_qc_t as 'struct dm_poll_data' and call blk_poll().
> 
> The hardest part is to ensure that all the disparate 'struct
> dm_poll_data' (and associated clone bios) aren't free'd until the
> _original_ bio completes.  That would create quite some back-pressure
> with more potential to exhaust system resources -- because then the
> cataylst for dropping reference counts on these clone bios would then
> need to be tied to the blk_bio_poll() interface... which feels "wrong"
> (e.g. it ushers in the (ab)use of bio_inc_remaining you had in your most
> recent patchset).
> 
> All said, maybe post a v2 that takes the incremental steps of:
> 1) using DM per-bio-data for 'struct dm_poll_data'
> 2) simplify blk_bio_poll() to call into DM to translate provided
>    blk_qc_t (from struct kiocb's ki_cookie) to request_queue and
>    blk_qc_t.
>    - this eliminates any need for extra list processing
> 3) keep your (ab)use of bio_inc_remaining() to allow for exploring this 

-- 
Thanks,
Jeffle
