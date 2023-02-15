Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D98A697FFD
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 16:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjBOP40 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 10:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjBOP4Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 10:56:25 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9025BBBC
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 07:56:06 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id d16so7239049ioz.12
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 07:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/6LZWTIlEEy/Yxt7BhCKvwb06QN/c9+iZ58x+2VzkNg=;
        b=q7bU9LKMoGox2MjbMzZRiC/lwLvEtNKLfWfxNNd9TiGKapm1j2LM0ytpEBO60ON1Wr
         zO656zpJjSQ5nQeOkkdhNYoHm1GI3llT46P8dGcFaQIuMcZxxfyccdwkupsof+xRuMBv
         BaT1YCSZIGEnmXz5pmgsvAdFlPoccD7JkGcKyt5XtRZVpbJmD8fIqEris815RD602Yxu
         OWmedTHxuex53a1p0r01WiDX63W2VVjC1eYbhXb5lnCckl/a08G2e2OpkeKblPQDbjl7
         Qo1rVE3CwrC3o5SS4NVqNLHRzLuZ9bRpJ0O0evSi6fTnqV6v+mJidgVzbid1M40wMr2+
         xe0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/6LZWTIlEEy/Yxt7BhCKvwb06QN/c9+iZ58x+2VzkNg=;
        b=Ol6mrvOeZt77KVs2K/hzVB0r6qP39XSmEt3lWkWYaIccPT7XL3tsjzcRuzZRYC3b94
         nGos9oiWvEayXkDHnKbhEMoifZjt63On1Y9E/gWA8+XWAwbQM2EaECZMUnso+QoU08/1
         c5Dkunx4zd5pUnfChaqPyeU4e3XeD0c2DlD77ZKRYDpr/RLfrZfsS/aahhs/okbZXhLT
         tzi4VHz7DSaYwkhIO/7ku/6qy7bVcXA1RGR1IH2jUneiG9601YDM5ff38f/PPIRtlG7d
         4p5gsGLNWvsUVqgT1efCPyCMYj8KnbykJksi8SZ3euPnqkRWp3hEvZUmLcjknIVnIRmP
         KR8w==
X-Gm-Message-State: AO0yUKVSKxsIpFfeW1IuIC8APESu232Uox3Zc1KqEdm+yCmfDWyDN4Y3
        iEDkdgnfRc6YdMLdQw+59NSpMg==
X-Google-Smtp-Source: AK7set9FG18bxOd9oD5VST28VZ+MYbRBznFmxVRU8VwOFSdP94rMXax7a51Fyt4OWHeJHpPPhcu2eQ==
X-Received: by 2002:a6b:b4ca:0:b0:71d:63e5:7b5f with SMTP id d193-20020a6bb4ca000000b0071d63e57b5fmr1746153iof.2.1676476566149;
        Wed, 15 Feb 2023 07:56:06 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 129-20020a6b1487000000b0072763146104sm6291695iou.8.2023.02.15.07.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 07:56:05 -0800 (PST)
Message-ID: <f7c3ef57-f16c-7fe3-30b7-8ca6a9ef00ee@kernel.dk>
Date:   Wed, 15 Feb 2023 08:56:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>,
        John David Anglin <dave.anglin@bell.net>,
        io-uring@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <Y+wUwVxeN87gqN6o@p100>
 <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
 <626cee6f-f542-b7eb-16ca-1cf4e3808ca6@bell.net>
 <5f02fa8b-7fd8-d98f-4876-f1a89024b888@kernel.dk>
 <2b89f252-c430-1c44-7b30-02d927d2c7cb@gmx.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2b89f252-c430-1c44-7b30-02d927d2c7cb@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/15/23 8:52?AM, Helge Deller wrote:
> On 2/15/23 16:16, Jens Axboe wrote:
>> On 2/14/23 7:12?PM, John David Anglin wrote:
>>> On 2023-02-14 6:29 p.m., Jens Axboe wrote:
>>>> On 2/14/23 4:09?PM, Helge Deller wrote:
>>>>> * John David Anglin<dave.anglin@bell.net>:
>>>>>> On 2023-02-13 5:05 p.m., Helge Deller wrote:
>>>>>>> On 2/13/23 22:05, Jens Axboe wrote:
>>>>>>>> On 2/13/23 1:59?PM, Helge Deller wrote:
>>>>>>>>>> Yep sounds like it. What's the caching architecture of parisc?
>>>>>>>>> parisc is Virtually Indexed, Physically Tagged (VIPT).
>>>>>>>> That's what I assumed, so virtual aliasing is what we're dealing with
>>>>>>>> here.
>>>>>>>>
>>>>>>>>> Thanks for the patch!
>>>>>>>>> Sadly it doesn't fix the problem, as the kernel still sees
>>>>>>>>> ctx->rings->sq.tail as being 0.
>>>>>>>>> Interestingly it worked once (not reproduceable) directly after bootup,
>>>>>>>>> which indicates that we at least look at the right address from kernel side.
>>>>>>>>>
>>>>>>>>> So, still needs more debugging/testing.
>>>>>>>> It's not like this is untested stuff, so yeah it'll generally be
>>>>>>>> correct, it just seems that parisc is a bit odd in that the virtual
>>>>>>>> aliasing occurs between the kernel and userspace addresses too. At least
>>>>>>>> that's what it seems like.
>>>>>>> True.
>>>>>>>
>>>>>>>> But I wonder if what needs flushing is the user side, not the kernel
>>>>>>>> side? Either that, or my patch is not flushing the right thing on the
>>>>>>>> kernel side.
>>>>> The patch below seems to fix the issue.
>>>>>
>>>>> I've successfuly tested it with the io_uring-test testcase on
>>>>> physical parisc machines with 32- and 64-bit 6.1.11 kernels.
>>>>>
>>>>> The idea is similiar on how a file is mmapped shared by two
>>>>> userspace processes by keeping the lower bits of the virtual address
>>>>> the same.
>>>>>
>>>>> Cache flushes from userspace don't seem to be needed.
>>>> Are they from the kernel side, if the lower bits mean we end up
>>>> with the same coloring? Because I think this is a bit of a big
>>>> hammer, in terms of overhead for flushing. As an example, on arm64
>>>> that is perfectly fine with the existing code, it's about a 20-25%
>>>> performance hit.
>>>
>>> The io_uring-test testcase still works on rp3440 with the kernel
>>> flushes removed.
>>
>> That's what I suspected, the important bit here is just aligning it for
>> identical coloring. Can you confirm if the below works for you? Had to
>> fiddle it a bit to get it to work without coloring.
> 
> Yes, the patch works for me on 32- and 64-bit, even with PA8900 CPUs...
> 
> Is there maybe somewhere a more detailled testcase which I could try too?

Just git clone liburing:

git clone git://git.kernel.dk/liburing

and run make && make runtests in there, that'll go through the whole
regression suite.

> Some nits below...
> 
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index db623b3185c8..1d4562067949 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -72,6 +72,7 @@
>>   #include <linux/io_uring.h>
>>   #include <linux/audit.h>
>>   #include <linux/security.h>
>> +#include <asm/shmparam.h>
>>
>>   #define CREATE_TRACE_POINTS
>>   #include <trace/events/io_uring.h>
>> @@ -3200,6 +3201,51 @@ static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
>>       return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
>>   }
>>
>> +static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp,
>> +            unsigned long addr, unsigned long len,
>> +            unsigned long pgoff, unsigned long flags)
>> +{
>> +    const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
>> +    struct vm_unmapped_area_info info;
>> +    void *ptr;
>> +
>> +    ptr = io_uring_validate_mmap_request(filp, pgoff, len);
>> +    if (IS_ERR(ptr))
>> +        return -ENOMEM;
>> +
>> +    /* we do not support requesting a specific address */
>> +    if (addr)
>> +        return -EINVAL;
> 
> With this ^ we disallow users to provide a proposed address.
> I think this is ok and I suggest to keep it that way.
> 
> Alternatively one could check the given address against the
> alignment which is calculated below, but this will make the
> code IMHO unnecessary bigger.

liburing won't provide an address, so I'd say let's just keep it as-is.

>> +
>> +    info.flags = VM_UNMAPPED_AREA_TOPDOWN;
>> +    info.length = len;
>> +    info.low_limit = max(PAGE_SIZE, mmap_min_addr);
>> +    info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
>> +    info.align_mask = PAGE_MASK;
>> +    info.align_offset = (unsigned long) ptr;
> 
> For parisc I introduced SHM_COLOUR because it allows userspace
> to map a shared file initially at any PAGE_SIZE-aligned address.
> Only if then a second user maps the same file, the aliasing will be enforced.
> 
> Other platforms just have SHMLBA, and for some SHMLBA is > PAGE_SIZE.
> So, instead of above code, this untested code might be better for those other
> platforms ?
> info.align_mask = PAGE_MASK & (SHMLBA - 1);
> info.align_offset = (unsigned long)ptr & (SHMLBA - 1);

Yeah, I did peek at SHMLBA as well and it seems more common. Could you
test that and send out a "real" patch so we can get it queued up?

> this is ok ->
>> +#ifdef SHM_COLOUR
>> +    info.align_mask &= (SHM_COLOUR - 1);
>> +    info.align_offset &= (SHM_COLOUR - 1)
> 
> ^^ misses a ";" at the end.

Oops indeed.

-- 
Jens Axboe

