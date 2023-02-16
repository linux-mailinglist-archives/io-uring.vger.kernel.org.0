Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1D7699A6D
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 17:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjBPQqJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 11:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBPQqJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 11:46:09 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022CC4CC99
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 08:46:07 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id g14so952928ild.8
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 08:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676565966;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zkqq0kCHR7TLOPcF42SNKUHsMTVAzfnKBHgrT7KkIMY=;
        b=VmztVjh0l7QjgXqb/q/X1db7v7pASw1vKUA4OHR5yOFkw5Bodx6ufKNexDfZwnJ39u
         adFdtMwcgwdzlAqoq3N2+YpGrIfzl0UFW9QXdEDXXeeLzA/hg6yli8lQQhKfMoyTWSv6
         jC6xb3ZepOPEdp1A0pzgNHVh1PlH94AbwcFCCgMAH0vsnfYwCm5Q5WDj0a/qLncotMRy
         ifMIz2LeM4XynkmjQGhnydrI/4KD1qiZjUaEfVUWOxh0bX/obT73ljxfJ7WDTnuzSzz5
         MaRMFS5TUA7AGiXCi7+cE+D0SZth5P37RN6vcVlJqBUSXEUBbdEKzb+ou/YoBv1Bwb84
         Kkmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676565966;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zkqq0kCHR7TLOPcF42SNKUHsMTVAzfnKBHgrT7KkIMY=;
        b=uKvQ+knz9Rc8v2TTfOPG3FSBeqJevEojhYpl38J0xdjZNdaW+utuupEu49v3AeTnPg
         yhj2HxL3rhWCh3iUhFa26k/4Cn2XoYETzDeuWxk7x/lgYA8xQ9hdZ5x1Aki87tr/xjCo
         ADNch0vdRr2/y7+h0pqtv+nG8gDqZ/yBiJmAV2EzeHbJsqizYsFQ2c7StAba6IxG3Nku
         sA1aC86YJrTbmt+cStkaEK4c6fSNlVi/LVFzOlgcZTQ6LxQI2HjLe0PZ8KSyulgdurNT
         wgCG48VmkD0SUS7mKQSLnseUYB8QHBBn04O765QwUS/KfWfxmVeCvKu6L7kEO1amYBfZ
         aFLg==
X-Gm-Message-State: AO0yUKXhdOlVOL1qRe6kMegFC7IzNeAXY9rZIzESHgAeefmHVN3PJHQn
        9Rjoz3ck8ZZ6W+DXOGBJp6stHg==
X-Google-Smtp-Source: AK7set9o3dg0ac3Cui6QVqR4E1cPVOiBmS2fcjEdbBLZWZ5cW+6dzPEo/ePLpyB5Ns92LIUr3wuI9A==
X-Received: by 2002:a92:1910:0:b0:315:8bf9:53d8 with SMTP id 16-20020a921910000000b003158bf953d8mr1085602ilz.2.1676565966268;
        Thu, 16 Feb 2023 08:46:06 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y8-20020a056e021be800b00315766ef15csm577786ilv.35.2023.02.16.08.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 08:46:05 -0800 (PST)
Message-ID: <a5442e37-77a8-d4b3-c486-d2078cad4158@kernel.dk>
Date:   Thu, 16 Feb 2023 09:46:04 -0700
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2cafe988-f436-e21f-4ec2-8bcca4d3d7e4@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/16/23 9:33?AM, Helge Deller wrote:
> On 2/16/23 17:11, Jens Axboe wrote:
>> On 2/16/23 1:09?AM, Helge Deller wrote:
>>> Some architectures have memory cache aliasing requirements (e.g. parisc)
>>> if memory is shared between userspace and kernel. This patch fixes the
>>> kernel to return an aliased address when asked by userspace via mmap().
>>>
>>> Signed-off-by: Helge Deller <deller@gmx.de>
>>> ---
>>> v2: Do not allow to map to a user-provided addresss. This forces
>>> programs to write portable code, as usually on x86 mapping to any
>>> address will succeed, while it will fail for most provided address if
>>> used on stricter architectures.
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 862e05e6691d..01fe7437a071 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -72,6 +72,7 @@
>>>   #include <linux/io_uring.h>
>>>   #include <linux/audit.h>
>>>   #include <linux/security.h>
>>> +#include <asm/shmparam.h>
>>>
>>>   #define CREATE_TRACE_POINTS
>>>   #include <trace/events/io_uring.h>
>>> @@ -3059,6 +3060,54 @@ static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
>>>       return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
>>>   }
>>>
>>> +static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp,
>>> +            unsigned long addr, unsigned long len,
>>> +            unsigned long pgoff, unsigned long flags)
>>> +{
>>> +    const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
>>> +    struct vm_unmapped_area_info info;
>>> +    void *ptr;
>>> +
>>> +    /*
>>> +     * Do not allow to map to user-provided address to avoid breaking the
>>> +     * aliasing rules. Userspace is not able to guess the offset address of
>>> +     * kernel kmalloc()ed memory area.
>>> +     */
>>> +    if (addr)
>>> +        return -EINVAL;
>>
>> Can we relax this so that if the address is correctly aligned, it will
>> allow it?
> 
> My previous patch had it relaxed, but after some more thoughts I removed
> it in this v2-version again.
> 
> The idea behind it is good, but I see a huge disadvantage in allowing
> correctly aligned addresses: People develop their code usually on x86
> which has no such alignment requirements, as it just needs to be PAGE_SIZE aligned.
> So their code will always work fine on x86, but as soon as the same code
> is built on other platforms it will break. As you know, on parisc it's pure luck
> if the program chooses an address which is correctly aligned.
> I'm one of the debian maintainers for parisc, and I've seen similiar
> mmap-issues in other programs as well. Everytime I've found it to be wrong,
> you have to explain to the developers what's wrong and sometimes it's
> not easy to fix it.
> So, if we can educate people from assuming their code to be correct, I think
> we can save a lot of additional work afterwards.
> That said, I think it's better to be strict now, unless someone comes
> up with a really good reason why it needs to be less strict.

I don't disagree with the reasoning at all, but the problem is that it
may introduce breakage if someone IS doing the right thing. Is it
guaranteed to be true? No, certainly not. But someone could very well be
writing perfectly portable code and mapping a ring into a specific
address, and this will now break.

AFAICT, this is actually the case with the syzbot case. In fact, with
the patch applied, it'll obviously start crashing on all archs as the
mmaps will now return -EINVAL rather than work.

-- 
Jens Axboe

