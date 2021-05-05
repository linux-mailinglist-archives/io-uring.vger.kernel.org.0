Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20761373D06
	for <lists+io-uring@lfdr.de>; Wed,  5 May 2021 16:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhEEOIs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 10:08:48 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:46645 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232569AbhEEOIr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 10:08:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UXogiuT_1620223659;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UXogiuT_1620223659)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 May 2021 22:07:40 +0800
Subject: Re: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of
 io_sq_thread_idle
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
 <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
 <2fadf565-beb3-4227-8fe7-3f9e308a14a0@kernel.dk>
 <3aa943b1-b53e-c3c5-7a45-278c2eebb861@linux.alibaba.com>
 <d936d0b1-880e-601f-b27e-f36f79947cde@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <1b19b9c4-c0ed-6fbd-3e9c-9c4de942bc32@linux.alibaba.com>
Date:   Wed, 5 May 2021 22:07:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <d936d0b1-880e-601f-b27e-f36f79947cde@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/29 下午5:11, Pavel Begunkov 写道:
> On 4/29/21 4:41 AM, Hao Xu wrote:
>> 在 2021/4/28 下午10:16, Jens Axboe 写道:
>>> On 4/28/21 8:07 AM, Pavel Begunkov wrote:
>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>> index e1ae46683301..311532ff6ce3 100644
>>>>> --- a/include/uapi/linux/io_uring.h
>>>>> +++ b/include/uapi/linux/io_uring.h
>>>>> @@ -98,6 +98,7 @@ enum {
>>>>>    #define IORING_SETUP_CLAMP    (1U << 4)    /* clamp SQ/CQ ring sizes */
>>>>>    #define IORING_SETUP_ATTACH_WQ    (1U << 5)    /* attach to existing wq */
>>>>>    #define IORING_SETUP_R_DISABLED    (1U << 6)    /* start with ring disabled */
>>>>> +#define IORING_SETUP_IDLE_NS    (1U << 7)    /* unit of thread_idle is nano second */
>>>>>      enum {
>>>>>        IORING_OP_NOP,
>>>>> @@ -259,7 +260,7 @@ struct io_uring_params {
>>>>>        __u32 cq_entries;
>>>>>        __u32 flags;
>>>>>        __u32 sq_thread_cpu;
>>>>> -    __u32 sq_thread_idle;
>>>>> +    __u64 sq_thread_idle;
>>>>
>>>> breaks userspace API
>>>
>>> And I don't think we need to. If you're using IDLE_NS, then the value
>>> should by definition be small enough that it'd fit in 32-bits. If you
>> I make it u64 since I thought users may want a full flexibility to set
>> idle in nanosecond granularity(eg. (1e6 + 10) ns cannot be set by
> 
> It's a really weird user requiring such a precision. u32 allows up to
> ~1s, and if more is needed users can switch to ms mode, so in the worst
> case the precision is 1/1000 of the desired value, more than enough.
> 
>> millisecond granularity). But I'm not sure if this deserve changing the
>> userspace API.
>   
> That's not about deserve or not, we can't break ABI. Can be worked around,
Is it for compatibility reason?
> e.g. by taking resv fields, but don't see a reason
> 
>>> need higher timeouts, don't set it and it's in usec instead.
>>>
>>> So I'd just leave this one alone.
>>>
>>
> 

