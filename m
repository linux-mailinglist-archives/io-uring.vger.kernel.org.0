Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6A82F2808
	for <lists+io-uring@lfdr.de>; Tue, 12 Jan 2021 06:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731367AbhALFwq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 00:52:46 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:59105 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727374AbhALFwq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jan 2021 00:52:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0ULUehui_1610430419;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0ULUehui_1610430419)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 12 Jan 2021 13:46:59 +0800
From:   JeffleXu <jefflexu@linux.alibaba.com>
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
Message-ID: <16ba3a63-86f5-1acd-c129-767540186689@linux.alibaba.com>
Date:   Tue, 12 Jan 2021 13:46:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108172635.GA29915@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 1/9/21 1:26 AM, Mike Snitzer wrote:
> On Thu, Jan 07 2021 at 10:08pm -0500,
> JeffleXu <jefflexu@linux.alibaba.com> wrote:
> 
>> Thanks for reviewing.
>>
>>
>> On 1/8/21 6:18 AM, Mike Snitzer wrote:
>>> On Wed, Dec 23 2020 at  6:26am -0500,
>>> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
>>>
>>>> This is actuaaly the core when supporting iopoll for bio-based device.
>>>>
>>>> A list is maintained in the top bio (the original bio submitted to dm
>>>> device), which is used to maintain all valid cookies of split bios. The
>>>> IO polling routine will actually iterate this list and poll on
>>>> corresponding hardware queues of the underlying mq devices.
>>>>
>>>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>>>
>>> Like I said in response to patch 4 in this series: please fold patch 4
>>> into this patch and _really_ improve this patch header.
>>>
>>> In particular, the (ab)use of bio_inc_remaining() needs be documented in
>>> this patch header very well.
>>>
>>> But its use could easily be why you're seeing a performance hit (coupled
>>> with the extra spinlock locking and list management used).  Just added
>>> latency and contention across CPUs.
>>
>> Indeed bio_inc_remaining() is abused here and the code seems quite hacky
>> here.
>>
>> Actually I'm regarding implementing the split bio tracking mechanism in
>> a recursive way you had ever suggested. That is, the split bios could be
>> maintained in an array, which is allocated with 'struct dm_io'. This way
>> the overhead of spinlock protecting the &root->bi_plist may be omitted
>> here. Also the lifetime management may be simplified somehow. But the
>> block core needs to fetch the per-bio private data now, just like what
>> you had ever suggested before.
>>
>> How do you think, Mike?
> 
> Yes, using per-bio-data is a requirement (we cannot bloat 'struct bio').

Agreed. Then MD will need some refactor to support IO polling, if
possible, since just like I mentioned in patch 0 before, MD doesn't
allocate extra clone bio, and just re-uses the original bio structure.


> 
> As for using an array, how would you index the array?  

The 'array' here is not an array of 'struct blk_mq_hw_ctx *' maintained
in struct dm_table as you mentioned. Actually what I mean is to maintain
an array of struct dm_poll_data (or something like that, e.g. just
struct blk_mq_hw_ctx *) in per-bio private data. The size of the array
just equals the number of the target devices.

For example, for the following device stack,

>>
>> Suppose we have the following device stack hierarchy, that is, dm0 is
>> stacked on dm1, while dm1 is stacked on nvme0 and nvme1.
>>
>>     dm0
>>     dm1
>> nvme0  nvme1
>>
>>
>> Then the bio graph is like:
>>
>>
>>                                    +------------+
>>                                    |bio0(to dm0)|
>>                                    +------------+
>>                                          ^
>>                                          | orig_bio
>>                                    +--------------------+
>>                                    |struct dm_io A      |
>> +--------------------+ bi_private  ----------------------
>> |bio3(to dm1)        |------------>|bio1(to dm1)        |
>> +--------------------+             +--------------------+
>>         ^                                ^
>>         | ->orig_bio                     | ->orig_bio
>> +--------------------+             +--------------------+
>> |struct dm_io        |             |struct dm_io B      |
>> ----------------------             ----------------------
>> |bio2(to nvme0)      |             |bio4(to nvme1)      |
>> +--------------------+             +--------------------+
>>

An array of struct blk_mq_hw_ctx * is maintained in struct dm_io B.


struct blk_mq_hw_ctx * hctxs[2];

The array size is two since dm1 maps to two target devices (i.e. nvme0
and nvme1). Then hctxs[0] points to the hw queue of nvme0, while
hctxs[1] points to the hw queue of nvme1.


This mechanism supports arbitrary device stacking. Similarly, an array
of struct blk_mq_hw_ctx * is maintained in struct dm_io A. The array
size is one since dm0 only maps to one target device (i.e. dm1). In this
case, hctx[0] points to the struct dm_io of the next level, i.e. struct
dm_io B.


But I'm afraid the implementation of this style may be more complex.


>> struct node {
>>     struct blk_mq_hw_ctx *hctx;
>>     blk_qc_t cookie;
>> };
> 
> Needs a better name, think I had 'struct dm_poll_data'

Sure, the name here is just for example.


>  
>> Actually currently the tracking objects are all allocated with 'struct
>> bio', then the lifetime management of the tracking objects is actually
>> equivalent to lifetime management of bio. Since the returned cookie is
>> actually a pointer to the bio, the refcount of this bio must be
>> incremented, since we release a reference to this bio through the
>> returned cookie, in which case the abuse of the refcount trick seems
>> unavoidable? Unless we allocate the tracking object individually, then
>> the returned cookie is actually pointing to the tracking object, and the
>> refcount is individually maintained for the tracking object.
> 
> The refcounting and lifetime of the per-bio-data should all work as is.
> Would hope you can avoid extra bio_inc_remaining().. that infratsructure
> is way too tightly coupled to bio_chain()'ing, etc.
> 
> The challenge you have is the array that would point at these various
> per-bio-data needs to be rooted somewhere (you put it in the topmost
> original bio with the current patchset).  But why not manage that as
> part of 'struct mapped_device'?  It'd need proper management at DM table
> reload boundaries and such but it seems like the most logical place to
> put the array.  But again, this array needs to be dynamic.. so thinking
> further, maybe a better model would be to have a fixed array in 'struct
> dm_table' for each hctx associated with a blk_mq _data_ device directly
> used/managed by that dm_table?

It seems that you are referring 'array' here as an array of 'struct
blk_mq_hw_ctx *'? Such as

struct dm_table {
    ...
    struct blk_mq_hw_ctx *hctxs[];
};

Certainly with this we can replace the original 'struct blk_mq_hw_ctx *'
pointer in 'struct dm_poll_data' with the index into this array, such as

struct dm_poll_data {
     int hctx_index; /* index into dm_table->hctxs[] */
     blk_qc_t cookie;
};


But I'm doubted if this makes much sense. The core difficulty here is
maintaining a list (or dynamic sized array) to track all split bios.
With the array of 'struct blk_mq_hw_ctx *' maintained in struct
dm_table, we still need some **per-bio** structure (e.g., &bio->bi_plist
in current patch set) to track these split bios.




-- 
Thanks,
Jeffle
