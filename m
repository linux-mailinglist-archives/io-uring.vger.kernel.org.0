Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E408336E7AB
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 11:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbhD2JMt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 05:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbhD2JMt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 05:12:49 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22635C06138B
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 02:12:03 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n84so8198559wma.0
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 02:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZUVhnmxK/gTDIXETJpvPfdgnFDmeU+JLvtk0C0cOCtQ=;
        b=uwBpJNC/iWEiUTw24Gp2qyaSAkKgwcd9obHDJthVW44nGpmLYR4BZ6kdNoFwfFYAbt
         iTfxQL3WLHN3FqJsLZZHPkoKmXP77mVRW+SFGo8f6RsldxeN+clzk/Wj/Mxi3G4NwqAq
         lh1HpSnIxibMlqH1fwGPwiwc7HZDMj0K0E6se05+SFb205KIDcBDFY4jRdLbJdhEMvXL
         CouJBVlaPslVBzBoaaI690dOXdnvcZu4pfjhLuaisfHk8cqvBBMwcg0o83tY/ftdwRXq
         Y1VI5u1vx+uhXV70OWBzZ66A4hktJ7kviOyDrGQezT/Kp0YbtNrGUctwa6aMXrrQPMIv
         V1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZUVhnmxK/gTDIXETJpvPfdgnFDmeU+JLvtk0C0cOCtQ=;
        b=Z61tRHpwQZm983Qx8IUGx4eWXFN9YSEf5x87O9oRCv/zqvzt2b9FezX9ip+oiWLiZY
         L0Unx0QEQGFj6QWP7PcBxB6yStoqCswQNDYTE5s5qJmkNhRfiYZp5HedrNTuNKRJ96tc
         ZmK5lh0NLnThxe8UUte8PziiWlGMJv3rudfXMbDA03BqpBtG/Z/i5NWLJFbtg0XBm5Kj
         KTLJLEa7XjQe5EqmHTG9yzDh3LHogTNqq9fdU7BdX4vVSxiH5hmP0GqN0y9R8ZyS5l+1
         VWCF85vT6Evnrk7I5z7VO12H7xddvb6xbfiXBUmMu3438oilCYVazA1Jm6hP0vzpvTlv
         /UFw==
X-Gm-Message-State: AOAM5302qtVtR/H8CeWg9+XlZFlU8ZotN0LEhQ9eIN96xzl1ZHtmW0hs
        /K5rxDDii6gq0Sshtq1OvN4VLu/cKAI=
X-Google-Smtp-Source: ABdhPJzIQQdhNiHXoDfRXdF3iF5qABbhrJzClp4uwAvOXH9tW9mQ7+/pM2EGrrNukch/PM7CAE8byA==
X-Received: by 2002:a1c:7311:: with SMTP id d17mr34926075wmb.183.1619687521867;
        Thu, 29 Apr 2021 02:12:01 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id c5sm3844342wrs.73.2021.04.29.02.12.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 02:12:00 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of
 io_sq_thread_idle
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
 <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
 <2fadf565-beb3-4227-8fe7-3f9e308a14a0@kernel.dk>
 <3aa943b1-b53e-c3c5-7a45-278c2eebb861@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d936d0b1-880e-601f-b27e-f36f79947cde@gmail.com>
Date:   Thu, 29 Apr 2021 10:11:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <3aa943b1-b53e-c3c5-7a45-278c2eebb861@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/21 4:41 AM, Hao Xu wrote:
> 在 2021/4/28 下午10:16, Jens Axboe 写道:
>> On 4/28/21 8:07 AM, Pavel Begunkov wrote:
>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>> index e1ae46683301..311532ff6ce3 100644
>>>> --- a/include/uapi/linux/io_uring.h
>>>> +++ b/include/uapi/linux/io_uring.h
>>>> @@ -98,6 +98,7 @@ enum {
>>>>   #define IORING_SETUP_CLAMP    (1U << 4)    /* clamp SQ/CQ ring sizes */
>>>>   #define IORING_SETUP_ATTACH_WQ    (1U << 5)    /* attach to existing wq */
>>>>   #define IORING_SETUP_R_DISABLED    (1U << 6)    /* start with ring disabled */
>>>> +#define IORING_SETUP_IDLE_NS    (1U << 7)    /* unit of thread_idle is nano second */
>>>>     enum {
>>>>       IORING_OP_NOP,
>>>> @@ -259,7 +260,7 @@ struct io_uring_params {
>>>>       __u32 cq_entries;
>>>>       __u32 flags;
>>>>       __u32 sq_thread_cpu;
>>>> -    __u32 sq_thread_idle;
>>>> +    __u64 sq_thread_idle;
>>>
>>> breaks userspace API
>>
>> And I don't think we need to. If you're using IDLE_NS, then the value
>> should by definition be small enough that it'd fit in 32-bits. If you
> I make it u64 since I thought users may want a full flexibility to set
> idle in nanosecond granularity(eg. (1e6 + 10) ns cannot be set by

It's a really weird user requiring such a precision. u32 allows up to
~1s, and if more is needed users can switch to ms mode, so in the worst
case the precision is 1/1000 of the desired value, more than enough.

> millisecond granularity). But I'm not sure if this deserve changing the
> userspace API.
 
That's not about deserve or not, we can't break ABI. Can be worked around,
e.g. by taking resv fields, but don't see a reason

>> need higher timeouts, don't set it and it's in usec instead.
>>
>> So I'd just leave this one alone.
>>
> 

-- 
Pavel Begunkov
