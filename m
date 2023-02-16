Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96C5699BB9
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 19:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjBPSAw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 13:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjBPSAv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 13:00:51 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0470837737
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 10:00:50 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id z5so971213iow.1
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 10:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sGiUPg+YQbrrMZoRLbCteBQsCe8d3FD1qjjzfX59sv4=;
        b=mObhKUlYr3zrQyrE8kIlF+Q6j16afukcw2WbQ5dAMwjH6YcEx73RDHPgVtNnQTRYOH
         SsMo7hxeywMsMMfgpEhwGWzF7ODxWfKg1uP0R+Q6RSW+EZJE2xp5NdmUt3SMuHNKDhun
         7lfmlAlQBDTyh6Iv/zeLOaX9oYSGI8HOngem/KgETrJAUS5BRr+CIQ5B7zH2bbGUJplg
         0s0YobvVg5HGBzRaLPIiHPm/cK5NPFrubfF3f8mvqrA+Baf+fnh3Rj6OlXeg3TU5wkNJ
         JUwpvgvg8k5Vvcb7Cd/JzEsgtOCaqwDN2XgL8lNJlhWj1kzcb0T83pjIYmKpfmPb2hXP
         UgMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sGiUPg+YQbrrMZoRLbCteBQsCe8d3FD1qjjzfX59sv4=;
        b=5W/F+ay6epSxT8iS7owp/oggXpI+cflqHn6QdVEGLcdn3DEiHPRqfLRc1r0Cvi5fzL
         25Nhm22WsTEn7SfUa0KDmgLpqDUQLUPrIlAi+Sfuf/VSfqheqBZOKkatP0kK34zrk4Jg
         eGcJjAyEGHu73sTC8jT1McEUdyQx59fa+wC0QG/PcwpMgrngPvqai8gSB2+5mZ0gU2tP
         +IQczjs2GqToSB+t30o5LcazvuRhioLj5Ax0bpAT7XvgBLtFNSG3bn+vu14TS8RqjFzR
         9RNfZUbtEiu8D8tZhK7jh5/C9fHorVV3QVst+K12J+XvSkUya6qKG2E+lbJ3sufyDVmt
         kfpQ==
X-Gm-Message-State: AO0yUKXEM93eETCScS+8VU3tVL66sZPrapZn9/H2HfwFBiUTUofBIS/p
        ZfZU8KYfO3bChXCUw9sAqj2zew==
X-Google-Smtp-Source: AK7set/mcWMzWmbPSvkKa/v4Ob55rYpGONuZH5gmuGCH/RIsZ/A84YFxLgoo9VSMPotTsX2u5XMyJw==
X-Received: by 2002:a05:6602:1415:b0:70a:9fce:853c with SMTP id t21-20020a056602141500b0070a9fce853cmr4461844iov.2.1676570449196;
        Thu, 16 Feb 2023 10:00:49 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p14-20020a6bce0e000000b00734d27b267dsm675719iob.17.2023.02.16.10.00.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 10:00:48 -0800 (PST)
Message-ID: <74e71dac-5096-1500-bf54-7ba3b870404f@kernel.dk>
Date:   Thu, 16 Feb 2023 11:00:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v2] io_uring: Adjust mapping wrt architecture aliasing
 requirements
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>
References: <Y+3kwh8BokobVl6o@p100>
 <47f1f4f3-36c8-a1f0-2d07-3f03454dfb35@kernel.dk>
 <2cafe988-f436-e21f-4ec2-8bcca4d3d7e4@gmx.de>
 <a5442e37-77a8-d4b3-c486-d2078cad4158@kernel.dk>
 <8bb3882a-9d88-5436-68ba-029335f11694@gmx.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8bb3882a-9d88-5436-68ba-029335f11694@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/16/23 10:52?AM, Helge Deller wrote:
> On 2/16/23 17:46, Jens Axboe wrote:
>> On 2/16/23 9:33?AM, Helge Deller wrote:
>>> On 2/16/23 17:11, Jens Axboe wrote:
>>>> On 2/16/23 1:09?AM, Helge Deller wrote:
>>>>> Some architectures have memory cache aliasing requirements (e.g. parisc)
>>>>> if memory is shared between userspace and kernel. This patch fixes the
>>>>> kernel to return an aliased address when asked by userspace via mmap().
>>>>>
>>>>> Signed-off-by: Helge Deller <deller@gmx.de>
>>>>> ---
>>>>> v2: Do not allow to map to a user-provided addresss. This forces
>>>>> programs to write portable code, as usually on x86 mapping to any
>>>>> address will succeed, while it will fail for most provided address if
>>>>> used on stricter architectures.
>>>>>
>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>> index 862e05e6691d..01fe7437a071 100644
>>>>> --- a/io_uring/io_uring.c
>>>>> +++ b/io_uring/io_uring.c
>>>>> @@ -72,6 +72,7 @@
>>>>>    #include <linux/io_uring.h>
>>>>>    #include <linux/audit.h>
>>>>>    #include <linux/security.h>
>>>>> +#include <asm/shmparam.h>
>>>>>
>>>>>    #define CREATE_TRACE_POINTS
>>>>>    #include <trace/events/io_uring.h>
>>>>> @@ -3059,6 +3060,54 @@ static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
>>>>>        return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
>>>>>    }
>>>>>
>>>>> +static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp,
>>>>> +            unsigned long addr, unsigned long len,
>>>>> +            unsigned long pgoff, unsigned long flags)
>>>>> +{
>>>>> +    const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
>>>>> +    struct vm_unmapped_area_info info;
>>>>> +    void *ptr;
>>>>> +
>>>>> +    /*
>>>>> +     * Do not allow to map to user-provided address to avoid breaking the
>>>>> +     * aliasing rules. Userspace is not able to guess the offset address of
>>>>> +     * kernel kmalloc()ed memory area.
>>>>> +     */
>>>>> +    if (addr)
>>>>> +        return -EINVAL;
>>>>
>>>> Can we relax this so that if the address is correctly aligned, it will
>>>> allow it?
>>>
>>> My previous patch had it relaxed, but after some more thoughts I removed
>>> it in this v2-version again.
>>>
>>> The idea behind it is good, but I see a huge disadvantage in allowing
>>> correctly aligned addresses: People develop their code usually on x86
>>> which has no such alignment requirements, as it just needs to be PAGE_SIZE aligned.
>>> So their code will always work fine on x86, but as soon as the same code
>>> is built on other platforms it will break. As you know, on parisc it's pure luck
>>> if the program chooses an address which is correctly aligned.
>>> I'm one of the debian maintainers for parisc, and I've seen similiar
>>> mmap-issues in other programs as well. Everytime I've found it to be wrong,
>>> you have to explain to the developers what's wrong and sometimes it's
>>> not easy to fix it.
>>> So, if we can educate people from assuming their code to be correct, I think
>>> we can save a lot of additional work afterwards.
>>> That said, I think it's better to be strict now, unless someone comes
>>> up with a really good reason why it needs to be less strict.
>>
>> I don't disagree with the reasoning at all, but the problem is that it
>> may introduce breakage if someone IS doing the right thing. Is it
>> guaranteed to be true? No, certainly not. But someone could very well be
>> writing perfectly portable code and mapping a ring into a specific
>> address, and this will now break.
> 
> We will find out if there are such users if we keep it strict now and
> open it up if it's really necessary. If you open it up now, you won't
> be able to turn it stricter later.

But it has been open up until now, that's the issue. And you're now
trying to make it stricter, which is indeed later...

>> AFAICT, this is actually the case with the syzbot case. In fact, with
>> the patch applied, it'll obviously start crashing on all archs as the
>> mmaps will now return -EINVAL rather than work.
> 
> Yes, but it's not a real user and just a (invalid) testcase.
> For that I think it's OK to just disable it.

Totally agree, and I did just disable it, but that part of the test is
not invalid. I don't care about this particular test case, it's more of
a general concern.

-- 
Jens Axboe

