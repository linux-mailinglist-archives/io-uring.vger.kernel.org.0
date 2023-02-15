Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA2469801E
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 17:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBOQCY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 11:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjBOQCX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 11:02:23 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636BD83ED;
        Wed, 15 Feb 2023 08:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676476935; i=deller@gmx.de;
        bh=17AAVbFX1Fu2yoUoGxZgOE9aG7tdQv6aK+ZdIjL9FlQ=;
        h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
        b=RMiSQjYVZVVZ6lETu0ZT4ZL08sD0tVRwCy19J+CPybVZ5/QPV5s7wGw6X8M3RQkki
         pTX/5lD9On5poOLAfshh57LK1u7uvN/iWPkPjUxD9bPNuSbYRcz/tmtnsFWzyE570Z
         2FNfyp4+SxsoULoFIa0YfWbfGkrxHkaRrPI8UnB9mU/qIkCOhM2Qjir2cR/43VPcrV
         t5BdAV2Fg5oAptcoUXO6LQwRIgtQlhl8eY4dk0uDf7mmE94tJ7RUoZM8r7cH8el9SX
         EiRDKNX0RAo9K5SLczo4AJ3tdOxoD1G9cBxa4UuDjOs/XMfNd0JngSuRZD5b0Hk7i2
         bSr1A7ljBBHZQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.136.89]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MO9z7-1pCkOd3oqH-00OYBh; Wed, 15
 Feb 2023 17:02:14 +0100
Message-ID: <1e77c848-5f8d-9300-8496-6c13a625a15c@gmx.de>
Date:   Wed, 15 Feb 2023 17:02:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: io_uring failure on parisc with VIPT caches
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        John David Anglin <dave.anglin@bell.net>,
        io-uring@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <Y+wUwVxeN87gqN6o@p100>
 <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
 <626cee6f-f542-b7eb-16ca-1cf4e3808ca6@bell.net>
 <5f02fa8b-7fd8-d98f-4876-f1a89024b888@kernel.dk>
 <2b89f252-c430-1c44-7b30-02d927d2c7cb@gmx.de>
 <f7c3ef57-f16c-7fe3-30b7-8ca6a9ef00ee@kernel.dk>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <f7c3ef57-f16c-7fe3-30b7-8ca6a9ef00ee@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:TB50npSdnBxpxL3MjnbVdQwWkjSDCG3E0lGqGTjmdm1pf+xelv+
 I2/uLM1qDd6nm7HF1mbhu1cO3egxV6h6xHf8Vb3kiHRxN5ro0HXEZnmf8CgWBA0uMxYtHNw
 4lQhL54ZVDaVFbNkHR66lzZxHbRY17cN+GpKZ60ztSUn+Dvd+mHfq8uOwYp2kqkCEEVIF7k
 GN+d1ZHZrxaN6oQWeI6cg==
UI-OutboundReport: notjunk:1;M01:P0:ixFdK8QcT74=;uI9ni5F5V68Oo+kE82ztd4v3+vW
 zmbc58dwu4G/EkgcpUyevH3qnLhFe+6o5+6sIy/sEpP06LLa0mDVq1frTodjq/w64IW3cFs0V
 sfTeOGEipx4bbpyQwvDdqJkJuNzkBUy8VaKwNbJ8bQ5EAubSXwbLBxNvTOyC5XbiSMBqSDPuC
 1T9dkwZFyi8aStCdTYo3aXpx+VxfnaSj+X3KzB7mUbLT/3DjjrlqcR75i44pufkP762RhN22F
 AeTs6HQrmW3yp4qX3H7GihxyagUERBVBphkvwv2DsTA3yv12Xdj0fP3rUYX3LXzat89O7jD7W
 K4GIz6QMc4T0hOlKn1EuvwR2zWIUE68pBPyVln5wcZeT8ttobq44lg8Nv1in0PVuICuw2NdY/
 ktSdynIDslaPzF8yTnthNdLGzeY/lSjT2GAcGCa0TnHtp859/rdz0hveUV7JWAQJYKVDSc4dm
 ctNRpExP1kCwgzxL0mAJUgwMGI3nKAkZSqXZtk6pGRTIuDsgQBNVTjaVHz0Ik6DTbwXMuEiVc
 HJQnfSCaLCGi6Aav4RB9h2421k0Cf8XOUotRxC/KLIiT7om75IW/c4gNNQwUwZJVwErFpQQq0
 AbwubgACacXjVUmdRjlJE+yg6SXkOh5Y0rFU8IIu4iZMLOWCRfqpTBcLYPBnMigqW8m/9DUva
 r6Df1VX6RJ4tWxV6rJCQx1fKyegGmvljEXNb1zw42kJxF03xmsvKtoXAFW6hWzc1zRuFAKSOK
 t55JGAc6zNNCi2eskjUeh9sSfRUsnRcQOr/CUKeBhY2l1TbY3SLW/qVZVK2qPkUOEBezcPO/T
 PYxXQljEB8jMJnUEaqz5QkngxfP2FD2RTERHiEeH7/KzxJqwcUWAAbRTh5pT7wZ9Rruv6+mM3
 uYrCWrnM/ZaPmDiQV1K1qe6l7cj7dglVHr2RUSp40OUsMtRxSo2KR4tBdKj3CqeDI//8pZKYT
 iyh42A==
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/15/23 16:56, Jens Axboe wrote:
> On 2/15/23 8:52?AM, Helge Deller wrote:
>> On 2/15/23 16:16, Jens Axboe wrote:
>>> On 2/14/23 7:12?PM, John David Anglin wrote:
>>>> On 2023-02-14 6:29 p.m., Jens Axboe wrote:
>>>>> On 2/14/23 4:09?PM, Helge Deller wrote:
>>>>>> * John David Anglin<dave.anglin@bell.net>:
>>>>>>> On 2023-02-13 5:05 p.m., Helge Deller wrote:
>>>>>>>> On 2/13/23 22:05, Jens Axboe wrote:
>>>>>>>>> On 2/13/23 1:59?PM, Helge Deller wrote:
>>>>>>>>>>> Yep sounds like it. What's the caching architecture of parisc?
>>>>>>>>>> parisc is Virtually Indexed, Physically Tagged (VIPT).
>>>>>>>>> That's what I assumed, so virtual aliasing is what we're dealing=
 with
>>>>>>>>> here.
>>>>>>>>>
>>>>>>>>>> Thanks for the patch!
>>>>>>>>>> Sadly it doesn't fix the problem, as the kernel still sees
>>>>>>>>>> ctx->rings->sq.tail as being 0.
>>>>>>>>>> Interestingly it worked once (not reproduceable) directly after=
 bootup,
>>>>>>>>>> which indicates that we at least look at the right address from=
 kernel side.
>>>>>>>>>>
>>>>>>>>>> So, still needs more debugging/testing.
>>>>>>>>> It's not like this is untested stuff, so yeah it'll generally be
>>>>>>>>> correct, it just seems that parisc is a bit odd in that the virt=
ual
>>>>>>>>> aliasing occurs between the kernel and userspace addresses too. =
At least
>>>>>>>>> that's what it seems like.
>>>>>>>> True.
>>>>>>>>
>>>>>>>>> But I wonder if what needs flushing is the user side, not the ke=
rnel
>>>>>>>>> side? Either that, or my patch is not flushing the right thing o=
n the
>>>>>>>>> kernel side.
>>>>>> The patch below seems to fix the issue.
>>>>>>
>>>>>> I've successfuly tested it with the io_uring-test testcase on
>>>>>> physical parisc machines with 32- and 64-bit 6.1.11 kernels.
>>>>>>
>>>>>> The idea is similiar on how a file is mmapped shared by two
>>>>>> userspace processes by keeping the lower bits of the virtual addres=
s
>>>>>> the same.
>>>>>>
>>>>>> Cache flushes from userspace don't seem to be needed.
>>>>> Are they from the kernel side, if the lower bits mean we end up
>>>>> with the same coloring? Because I think this is a bit of a big
>>>>> hammer, in terms of overhead for flushing. As an example, on arm64
>>>>> that is perfectly fine with the existing code, it's about a 20-25%
>>>>> performance hit.
>>>>
>>>> The io_uring-test testcase still works on rp3440 with the kernel
>>>> flushes removed.
>>>
>>> That's what I suspected, the important bit here is just aligning it fo=
r
>>> identical coloring. Can you confirm if the below works for you? Had to
>>> fiddle it a bit to get it to work without coloring.
>>
>> Yes, the patch works for me on 32- and 64-bit, even with PA8900 CPUs...
>>
>> Is there maybe somewhere a more detailled testcase which I could try to=
o?
>
> Just git clone liburing:
>
> git clone git://git.kernel.dk/liburing
>
> and run make && make runtests in there, that'll go through the whole
> regression suite.

Thanks!
I'll test.

>> Some nits below...
>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index db623b3185c8..1d4562067949 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -72,6 +72,7 @@
>>>    #include <linux/io_uring.h>
>>>    #include <linux/audit.h>
>>>    #include <linux/security.h>
>>> +#include <asm/shmparam.h>
>>>
>>>    #define CREATE_TRACE_POINTS
>>>    #include <trace/events/io_uring.h>
>>> @@ -3200,6 +3201,51 @@ static __cold int io_uring_mmap(struct file *fi=
le, struct vm_area_struct *vma)
>>>        return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_pag=
e_prot);
>>>    }
>>>
>>> +static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp=
,
>>> +            unsigned long addr, unsigned long len,
>>> +            unsigned long pgoff, unsigned long flags)
>>> +{
>>> +    const unsigned long mmap_end =3D arch_get_mmap_end(addr, len, fla=
gs);
>>> +    struct vm_unmapped_area_info info;
>>> +    void *ptr;
>>> +
>>> +    ptr =3D io_uring_validate_mmap_request(filp, pgoff, len);
>>> +    if (IS_ERR(ptr))
>>> +        return -ENOMEM;
>>> +
>>> +    /* we do not support requesting a specific address */
>>> +    if (addr)
>>> +        return -EINVAL;
>>
>> With this ^ we disallow users to provide a proposed address.
>> I think this is ok and I suggest to keep it that way.
>>
>> Alternatively one could check the given address against the
>> alignment which is calculated below, but this will make the
>> code IMHO unnecessary bigger.
>
> liburing won't provide an address, so I'd say let's just keep it as-is.

Good.

>>> +
>>> +    info.flags =3D VM_UNMAPPED_AREA_TOPDOWN;
>>> +    info.length =3D len;
>>> +    info.low_limit =3D max(PAGE_SIZE, mmap_min_addr);
>>> +    info.high_limit =3D arch_get_mmap_base(addr, current->mm->mmap_ba=
se);
>>> +    info.align_mask =3D PAGE_MASK;
>>> +    info.align_offset =3D (unsigned long) ptr;
>>
>> For parisc I introduced SHM_COLOUR because it allows userspace
>> to map a shared file initially at any PAGE_SIZE-aligned address.
>> Only if then a second user maps the same file, the aliasing will be enf=
orced.
>>
>> Other platforms just have SHMLBA, and for some SHMLBA is > PAGE_SIZE.
>> So, instead of above code, this untested code might be better for those=
 other
>> platforms ?
>> info.align_mask =3D PAGE_MASK & (SHMLBA - 1);
>> info.align_offset =3D (unsigned long)ptr & (SHMLBA - 1);
>
> Yeah, I did peek at SHMLBA as well and it seems more common. Could you
> test that and send out a "real" patch so we can get it queued up?

Sure, I'll do.

Helge
