Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51D43747A9
	for <lists+io-uring@lfdr.de>; Wed,  5 May 2021 20:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbhEESBx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 14:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234528AbhEESBr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 14:01:47 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE8FC061574
        for <io-uring@vger.kernel.org>; Wed,  5 May 2021 10:40:18 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id m9so2753389wrx.3
        for <io-uring@vger.kernel.org>; Wed, 05 May 2021 10:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qgxm+F1Ku34dkXJdaYPEQ4LeLPvjOit3Yo3VyvIkPwM=;
        b=qTht1HSCqCiUKpb5SzCBhUJxJVFO8kFwhUzFY6f/sGVqsKghAA+1kSagy/yqWBoNbP
         woXC5TJohET9IHUwWUcr3i0j6OUkN5SEJmMSQbcMtpmskMXPC0B5Q+ptMpfJhfKve/8w
         KGDVBcsJcwvBPnJNeFJFvyrEft4kQ/o+nMqUS+d2meCmaF/DdeGXmLBuHz3td/dor3VL
         B8dXO3CQQTHotW6X/Llr8tpKYVIGZKfAwgo7hX4vfj6U5hIcVi0noc5z6me5ZD9o1+RH
         /dA8U9B8FDnoL6B1OxxqPsFuTSQAudIhJyKENxAtIENpRCw3IXS66Kg/uIdWY0YU7cb0
         f+ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qgxm+F1Ku34dkXJdaYPEQ4LeLPvjOit3Yo3VyvIkPwM=;
        b=PpKpwZIZ4OLxTgMf/7p0PKuLwrs0Cir6ksAYQ08Mh6XM8AyuKS0wgneOiQCG8LN4iC
         LutXFkAFT2a/EEsMAfTW906ymRE7OOSbAXiF7xH265g53oECi1iba0HoQXqu+dWOAy+j
         LDwbMDD2xQz/3n7qQCUsAx4HnMlXzMcI/Koh3YPo9fK2N017lXpyf/pIBKjFUxk2hzth
         /b2buxmf2gvzWMxEWH4PtnHNUz5OpF7UBswCq53gHZJDCUUhtnYpSoe20Jx3sXoZEhum
         43F5zH5+fg3lpf85BbGQLvzzTYPKsu6lTdHLriYPvqbZaaCkhhWE1AX+W/zMrrPOde+P
         7Siw==
X-Gm-Message-State: AOAM533IBIOwSqFc4+duco6FzckaKDoULEipyXPVEUePum7LSMe37t5T
        r/s6eN36B7d9o2NKnUw1962/pN63Pew=
X-Google-Smtp-Source: ABdhPJzX47XcSu2ELxdub3ExOj6vi9CSZcEkOU6R+VRd5jgr4QIfywN6Wwnw/ZkRs3ULCc0jFRXGcg==
X-Received: by 2002:adf:cd06:: with SMTP id w6mr193237wrm.93.1620236417089;
        Wed, 05 May 2021 10:40:17 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.196])
        by smtp.gmail.com with ESMTPSA id y21sm6476025wmc.46.2021.05.05.10.40.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 10:40:16 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of
 io_sq_thread_idle
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
 <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
 <2fadf565-beb3-4227-8fe7-3f9e308a14a0@kernel.dk>
 <3aa943b1-b53e-c3c5-7a45-278c2eebb861@linux.alibaba.com>
 <d936d0b1-880e-601f-b27e-f36f79947cde@gmail.com>
 <1b19b9c4-c0ed-6fbd-3e9c-9c4de942bc32@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <ceae5eb0-5afb-f9fa-8bc1-a1da2b57f7f4@gmail.com>
Date:   Wed, 5 May 2021 18:40:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <1b19b9c4-c0ed-6fbd-3e9c-9c4de942bc32@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/21 3:07 PM, Hao Xu wrote:
> 在 2021/4/29 下午5:11, Pavel Begunkov 写道:
>> On 4/29/21 4:41 AM, Hao Xu wrote:
>>> 在 2021/4/28 下午10:16, Jens Axboe 写道:
>>>> On 4/28/21 8:07 AM, Pavel Begunkov wrote:
>>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>>> index e1ae46683301..311532ff6ce3 100644
>>>>>> --- a/include/uapi/linux/io_uring.h
>>>>>> +++ b/include/uapi/linux/io_uring.h
>>>>>> @@ -98,6 +98,7 @@ enum {
>>>>>>    #define IORING_SETUP_CLAMP    (1U << 4)    /* clamp SQ/CQ ring sizes */
>>>>>>    #define IORING_SETUP_ATTACH_WQ    (1U << 5)    /* attach to existing wq */
>>>>>>    #define IORING_SETUP_R_DISABLED    (1U << 6)    /* start with ring disabled */
>>>>>> +#define IORING_SETUP_IDLE_NS    (1U << 7)    /* unit of thread_idle is nano second */
>>>>>>      enum {
>>>>>>        IORING_OP_NOP,
>>>>>> @@ -259,7 +260,7 @@ struct io_uring_params {
>>>>>>        __u32 cq_entries;
>>>>>>        __u32 flags;
>>>>>>        __u32 sq_thread_cpu;
>>>>>> -    __u32 sq_thread_idle;
>>>>>> +    __u64 sq_thread_idle;
>>>>>
>>>>> breaks userspace API
>>>>
>>>> And I don't think we need to. If you're using IDLE_NS, then the value
>>>> should by definition be small enough that it'd fit in 32-bits. If you
>>> I make it u64 since I thought users may want a full flexibility to set
>>> idle in nanosecond granularity(eg. (1e6 + 10) ns cannot be set by
>>
>> It's a really weird user requiring such a precision. u32 allows up to
>> ~1s, and if more is needed users can switch to ms mode, so in the worst
>> case the precision is 1/1000 of the desired value, more than enough.
>>
>>> millisecond granularity). But I'm not sure if this deserve changing the
>>> userspace API.
>>   That's not about deserve or not, we can't break ABI. Can be worked around,
> Is it for compatibility reason?

Right, all binaries should work without recompilation, including
those not using liburing.


>> e.g. by taking resv fields, but don't see a reason
>>
>>>> need higher timeouts, don't set it and it's in usec instead.
>>>>
>>>> So I'd just leave this one alone.
>>>>
>>>
>>
> 

-- 
Pavel Begunkov
