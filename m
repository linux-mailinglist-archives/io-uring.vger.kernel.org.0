Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DEE32B552
	for <lists+io-uring@lfdr.de>; Wed,  3 Mar 2021 07:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346663AbhCCGoK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 01:44:10 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:43674 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238752AbhCCCKz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Mar 2021 21:10:55 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UQ9w27U_1614736537;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQ9w27U_1614736537)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Mar 2021 09:55:38 +0800
Subject: Re: [dm-devel] [PATCH v3 11/11] dm: fastpath of bio-based polling
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     axboe@kernel.dk, snitzer@redhat.com, caspar@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        joseph.qi@linux.alibaba.com, dm-devel@redhat.com, hch@lst.de
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
 <20210208085243.82367-12-jefflexu@linux.alibaba.com>
 <alpine.LRH.2.02.2102191351200.10545@file01.intranet.prod.int.rdu2.redhat.com>
 <af9223b9-8960-1ed4-799a-bcd56299c587@linux.alibaba.com>
 <alpine.LRH.2.02.2103021353490.9353@file01.intranet.prod.int.rdu2.redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <3ce93e18-190a-fb63-3efa-9d0d7119920c@linux.alibaba.com>
Date:   Wed, 3 Mar 2021 09:55:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2103021353490.9353@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 3/3/21 3:03 AM, Mikulas Patocka wrote:
> 
> 
> On Fri, 26 Feb 2021, JeffleXu wrote:
> 
>>
>>
>> On 2/20/21 3:38 AM, Mikulas Patocka wrote:
>>>
>>>
>>> On Mon, 8 Feb 2021, Jeffle Xu wrote:
>>>
>>>> Offer one fastpath of bio-based polling when bio submitted to dm device
>>>> is not split.
>>>>
>>>> In this case, there will be only one bio submitted to only one polling
>>>> hw queue of one underlying mq device, and thus we don't need to track
>>>> all split bios or iterate through all polling hw queues. The pointer to
>>>> the polling hw queue the bio submitted to is returned here as the
>>>> returned cookie.
>>>
>>> This doesn't seem safe - note that between submit_bio() and blk_poll(), no 
>>> locks are held - so the device mapper device may be reconfigured 
>>> arbitrarily. When you call blk_poll() with a pointer returned by 
>>> submit_bio(), the pointer may point to a stale address.
>>>
>>
>> Thanks for the feedback. Indeed maybe it's not a good idea to directly
>> return a 'struct blk_mq_hw_ctx *' pointer as the returned cookie.
>>
>> Currently I have no idea to fix it, orz... The
>> blk_get_queue()/blk_put_queue() tricks may not work in this case.
>> Because the returned cookie may not be used at all. Before calling
>> blk_poll(), the polling routine may find that the corresponding IO has
>> already completed, and thus won't call blk_poll(), in which case we have
>> no place to put the refcount.
>>
>> But I really don't want to drop this optimization, since this
>> optimization is quite intuitive when dm device maps to a lot of
>> underlying devices. Though this optimization doesn't actually achieve
>> reasonable performance gain in my test, maybe because there are at most
>> seven nvme devices in my test machine.
>>
>> Any thoughts?
>>
>> Thanks,
>> Jeffle
> 
> Hi
> 
> I reworked device mapper polling, so that we poll in the function 
> __split_and_process_bio. The pointer to a queue and the polling cookie is 
> passed only inside device mapper code, it never leaves it.
> 
> I'll send you my patches - try them and tell me how does it perform 
> compared to your patchset.
> 

Thanks. Be glad to hear that you're also working on this. I'm glad to
give some comments on your patch set.


-- 
Thanks,
Jeffle
