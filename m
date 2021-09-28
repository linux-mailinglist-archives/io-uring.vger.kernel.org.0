Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864DE41AD4D
	for <lists+io-uring@lfdr.de>; Tue, 28 Sep 2021 12:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbhI1Kxa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Sep 2021 06:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239895AbhI1Kxa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Sep 2021 06:53:30 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FC5C061575
        for <io-uring@vger.kernel.org>; Tue, 28 Sep 2021 03:51:50 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id d207-20020a1c1dd8000000b00307e2d1ec1aso2382665wmd.5
        for <io-uring@vger.kernel.org>; Tue, 28 Sep 2021 03:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xZMnEsx8/WSsCJly0vU8b8FRn24xg5bu0QFoDO9E+DM=;
        b=PWOJ+xUDTmDmWtweAR01dnsxmO+ODpyTO4pqUTvGSCFd50y2wWUJgM25/lwNGF7a4n
         hdr+7Q2AeN9Ui3JyVEs2C2wdgrc2ekpiDAaApihd7C5a3j8K/bo2H5abxfvrT+w6EUYC
         CKSewTE6KU5byN1w+Pdd0jKBkYlNUfXgKe7FvowrWRW/OGcrZfNsMzSHfdLE65TEmR78
         VpL5t4FlopdJktj9DPYMCUBXlIvrIxM3KmZJVbsTctd3rsqOrixPRI+RwUW53YeokYnQ
         47XV55w6F6fxQ8Et3xlEPrS/nEtiHG5XmQCXhWw4i8kkbT1k+dTBZQq7lTi17o+wamuR
         zrLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xZMnEsx8/WSsCJly0vU8b8FRn24xg5bu0QFoDO9E+DM=;
        b=sd68jpsUo9qNlPldbHod31+bWgi1CpNmU1m+RWtfL1uB7lrhvGP5Bj1A6HXiDeOH1r
         Y0YR4vziFx/hbTNyLOlddGcDlSu0bKS+8hg7rCqKLlXmxKXOEwE/luHkAB3rkgLDiwCc
         LwlzVm0Y7F2gTq87I/lTjoCzzAeenOm0E/dG3HiIvld188pQbt2AA9VuYvSSXSXquYDO
         xlXbJXvlOy4GsIpZECTZZkp2EpeWCr5Ls7J6DI9Hoi25tuxAmaDhtFtCTdzf3flOboTg
         DyEiGrlcarAmPcqauDAkfgiXOjC/1uZ8oQxysinw1VxAlPf7ufgiyUnkZcE73fRjPMxj
         G/Uw==
X-Gm-Message-State: AOAM530IBQduyXVulnlUL/OtJHumOJ3JYGBk0EKb8N+l0fvl54ycZP86
        FJh8VyXgdpteceIW5UpUQCI=
X-Google-Smtp-Source: ABdhPJz+3FhlG4SDW1dGYOB8AFyNoOzEqVTPYjGB4lej7UkOi6YhMAFbK+hBv1zYwU+NzzYQaftwZA==
X-Received: by 2002:a05:600c:4b87:: with SMTP id e7mr4003428wmp.108.1632826309580;
        Tue, 28 Sep 2021 03:51:49 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.229])
        by smtp.gmail.com with ESMTPSA id c7sm3202168wmq.13.2021.09.28.03.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 03:51:49 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
 <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
 <51308ac4-03b7-0f66-7f26-8678807195ca@linux.alibaba.com>
 <96ef70e8-7abf-d820-3cca-0f8aedc969d8@gmail.com>
 <0d781b5f-3d2d-5ad4-9ad3-8fabc994313a@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of
 io_sq_thread_idle
Message-ID: <11c738b2-8024-1870-d54b-79e89c5bea54@gmail.com>
Date:   Tue, 28 Sep 2021 11:51:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <0d781b5f-3d2d-5ad4-9ad3-8fabc994313a@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/21 11:00 AM, Hao Xu wrote:
> 在 2021/4/30 上午6:15, Pavel Begunkov 写道:
>> On 4/29/21 4:28 AM, Hao Xu wrote:
>>> 在 2021/4/28 下午10:07, Pavel Begunkov 写道:
>>>> On 4/28/21 2:32 PM, Hao Xu wrote:
>>>>> currently unit of io_sq_thread_idle is millisecond, the smallest value
>>>>> is 1ms, which means for IOPS > 1000, sqthread will very likely  take
>>>>> 100% cpu usage. This is not necessary in some cases, like users may
>>>>> don't care about latency much in low IO pressure
>>>>> (like 1000 < IOPS < 20000), but cpu resource does matter. So we offer
>>>>> an option of nanosecond granularity of io_sq_thread_idle. Some test
>>>>> results by fio below:
>>>>
>>>> If numbers justify it, I don't see why not do it in ns, but I'd suggest
>>>> to get rid of all the mess and simply convert to jiffies during ring
>>>> creation (i.e. nsecs_to_jiffies64()), and leave io_sq_thread() unchanged.
>>> 1) here I keep millisecond mode for compatibility
>>> 2) I saw jiffies is calculated by HZ, and HZ could be large enough
>>> (like HZ = 1000) to make nsecs_to_jiffies64() = 0:
>>>
>>>   u64 nsecs_to_jiffies64(u64 n)
>>>   {
>>>   #if (NSEC_PER_SEC % HZ) == 0
>>>           /* Common case, HZ = 100, 128, 200, 250, 256, 500, 512, 1000 etc. */
>>>           return div_u64(n, NSEC_PER_SEC / HZ);
>>>   #elif (HZ % 512) == 0
>>>           /* overflow after 292 years if HZ = 1024 */
>>>           return div_u64(n * HZ / 512, NSEC_PER_SEC / 512);
>>>   #else
>>>           /*
>>>           ¦* Generic case - optimized for cases where HZ is a multiple of 3.
>>>           ¦* overflow after 64.99 years, exact for HZ = 60, 72, 90, 120 etc.
>>>           ¦*/
>>>           return div_u64(n * 9, (9ull * NSEC_PER_SEC + HZ / 2) / HZ);
>>>   #endif
>>>   }
>>>
>>> say HZ = 1000, then nsec_to_jiffies64(1us) = 1e3 / (1e9 / 1e3) = 0
>>> iow, nsec_to_jiffies64() doesn't work for n < (1e9 / HZ).
>>
>> Agree, apparently jiffies precision fractions of a second, e.g. 0.001s
>> But I'd much prefer to not duplicate all that. So, jiffies won't do,
>> ktime() may be ok but a bit heavier that we'd like it to be...
>>
>> Jens, any chance you remember something in the middle? Like same source
>> as ktime() but without the heavy correction it does.
> I'm gonna pick this one up again, currently this patch
> with ktime_get_ns() works good on our productions. This
> patch makes the latency a bit higher than before, but
> still lower than aio.
> I haven't gotten a faster alternate for ktime_get_ns(),
> any hints?

Good, I'd suggest to look through Documentation/core-api/timekeeping.rst
In particular coarse variants may be of interest.
https://www.kernel.org/doc/html/latest/core-api/timekeeping.html#coarse-and-fast-ns-access


Off topic: it sounds that you're a long user of SQPOLL. Interesting to
ask how do you find it in general. i.e. does it help much with
latency? Performance? Anything else?

-- 
Pavel Begunkov
