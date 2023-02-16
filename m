Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B77C699B95
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 18:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjBPRwa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 12:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBPRw3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 12:52:29 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B834CC83;
        Thu, 16 Feb 2023 09:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676569944; i=deller@gmx.de;
        bh=JCfFgDwZbHk5YLZcVVpnSBtBcS1HfnM8A4EQTmJ4AMI=;
        h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
        b=M1ZgmOLbotf/mjvOfIYOKlsvBA+5VhapA0wjLg4U/ze4KqTuRrBP0MJJ5NNi5ZSeg
         VSkCsPHRlkf8ptMt/pzE1u7rZBnj11ylcdTs7kHQlx19rj5U4SzkCIMaRwbN6Zg+xy
         0xDyQLlHS8dtXWtAd+aBeEU4KbD3qOXy4qtnUgUOueM1dOKkYdhaITKzfd223lBGGE
         a8wKd1dRfDbm94qnTFUWoEyII1ed5DPDRj/pjXye5QGSKJIpyZe01VULf854W9mgrt
         +jYsZzL77PJRA/ypZwyNyp7bv7EcfXo3krlaN9seXfYyVMVgcJw8cbv5/aPgOy9Xrw
         QzDx5vQ4uRxCw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.164.173]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MqJqD-1ooxtz2lKl-00nUlc; Thu, 16
 Feb 2023 18:52:24 +0100
Message-ID: <8bb3882a-9d88-5436-68ba-029335f11694@gmx.de>
Date:   Thu, 16 Feb 2023 18:52:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] io_uring: Adjust mapping wrt architecture aliasing
 requirements
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>
References: <Y+3kwh8BokobVl6o@p100>
 <47f1f4f3-36c8-a1f0-2d07-3f03454dfb35@kernel.dk>
 <2cafe988-f436-e21f-4ec2-8bcca4d3d7e4@gmx.de>
 <a5442e37-77a8-d4b3-c486-d2078cad4158@kernel.dk>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <a5442e37-77a8-d4b3-c486-d2078cad4158@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:z6eonLs4sK4UAXFYczIzgx9yuuB4QXKR/FK6ZJIx/zMX2TJ1Fi1
 VJscK7npOnleoZFd6rXA0FQ87BwFrMxDmFxzatn3vEcnSrRJbO3e5PVCey4P+E5zX/Fe+h2
 +JMc7PEZHG9WmmoxyBdvookwzfBo/J2jwz8l+lasVCCzjU4I9D92ggFw8C9kdeQtjj8vDiY
 99lUv4FPZjtO7QUR4QN+w==
UI-OutboundReport: notjunk:1;M01:P0:H4/mw2Zo7Fg=;aD4g8DFZ7ef8jktDcpZst5mXIcF
 DHFQzqMt4CCGVuL9IZqmK3HBWyfF1zvz7sxVwCeV3vi6xI8xxeA/1dQehJFWiPeR71MYlUCX/
 NjCuVtGWYLiw8clRMqhHGZk16NR9jGpLsjm9e4epgbWd8KXapoIAU3b9qsRe2i+napWJsEtvS
 lR51xEYUcy1wsLPp5GTDD687dBdxCFV5MUf7HI3T4LXiZ9LLdZkJPbURT50oRS0yExIHaYe/Q
 aHtqCLCl9BdxvVuV0o7TKpt4NJzROw6+Tt/SWXPoj6fTZ9VHi3cmooBX2VtDq7FuDj4/wxI3n
 Z5nPIZI2QBvyUGNorI/GHlkQ+BhQHoqpa4QhdJ7Nexl840E8J8Nem6WAOVVwssqH9mzzUwHQJ
 jWxoczLTK7R2FVpppZ1B/VRdxX64cx95ZbjPh9wwxrfuF0sVBDwFLm46ORLzq/TVJdRmucxpf
 6hirNaZ7W1S0rQgSsghgH8JeIFcsmuM/UbVhgFlgAewSVq81iHcs5dqoswyYu5to6YY5OPcm2
 1gPFbc+UU6ewnEZtmg88yVtUPXliNEBmUPuJ2rGN2rnia8CJfzbYDAJzD7laphR6T4yMltMBh
 B0NmAFHPaEvY8SBjfYqWVGXGH5g+mwJAYfQBOUicNIylpeBBKgZCh0iTBG9YlcWPKBj1hDObK
 Hp9JTkElFLBcOLfjgqpm5U1h48jaPE7GrctdntsRcpt2izhElu4L8dZks1W36yogO3nZUX6Jx
 LwJwDGdP6lgwoOiRjpEnoWpm4P6KCPD2AQCWjk3qr0BdnW9SnL2Hzkzq93FwAs0PBuVkJcdyO
 F+4u9wbPliOYlqC9Je0WuzQLWPusvbl5BYaPBUr0zLVGTfk+m4WGLuONWYjGyWDDlZPEzKFH/
 Oy03sevuxEJ9GPF7ZvYMubMIkx7mXhR6MjwObIU2chreopqlymSZTzMJfUGkwPKh5rZaXcvVl
 OZBGzMppw30og+Ta2Fsm0tYdahA=
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/16/23 17:46, Jens Axboe wrote:
> On 2/16/23 9:33?AM, Helge Deller wrote:
>> On 2/16/23 17:11, Jens Axboe wrote:
>>> On 2/16/23 1:09?AM, Helge Deller wrote:
>>>> Some architectures have memory cache aliasing requirements (e.g. pari=
sc)
>>>> if memory is shared between userspace and kernel. This patch fixes th=
e
>>>> kernel to return an aliased address when asked by userspace via mmap(=
).
>>>>
>>>> Signed-off-by: Helge Deller <deller@gmx.de>
>>>> ---
>>>> v2: Do not allow to map to a user-provided addresss. This forces
>>>> programs to write portable code, as usually on x86 mapping to any
>>>> address will succeed, while it will fail for most provided address if
>>>> used on stricter architectures.
>>>>
>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> index 862e05e6691d..01fe7437a071 100644
>>>> --- a/io_uring/io_uring.c
>>>> +++ b/io_uring/io_uring.c
>>>> @@ -72,6 +72,7 @@
>>>>    #include <linux/io_uring.h>
>>>>    #include <linux/audit.h>
>>>>    #include <linux/security.h>
>>>> +#include <asm/shmparam.h>
>>>>
>>>>    #define CREATE_TRACE_POINTS
>>>>    #include <trace/events/io_uring.h>
>>>> @@ -3059,6 +3060,54 @@ static __cold int io_uring_mmap(struct file *f=
ile, struct vm_area_struct *vma)
>>>>        return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_pa=
ge_prot);
>>>>    }
>>>>
>>>> +static unsigned long io_uring_mmu_get_unmapped_area(struct file *fil=
p,
>>>> +            unsigned long addr, unsigned long len,
>>>> +            unsigned long pgoff, unsigned long flags)
>>>> +{
>>>> +    const unsigned long mmap_end =3D arch_get_mmap_end(addr, len, fl=
ags);
>>>> +    struct vm_unmapped_area_info info;
>>>> +    void *ptr;
>>>> +
>>>> +    /*
>>>> +     * Do not allow to map to user-provided address to avoid breakin=
g the
>>>> +     * aliasing rules. Userspace is not able to guess the offset add=
ress of
>>>> +     * kernel kmalloc()ed memory area.
>>>> +     */
>>>> +    if (addr)
>>>> +        return -EINVAL;
>>>
>>> Can we relax this so that if the address is correctly aligned, it will
>>> allow it?
>>
>> My previous patch had it relaxed, but after some more thoughts I remove=
d
>> it in this v2-version again.
>>
>> The idea behind it is good, but I see a huge disadvantage in allowing
>> correctly aligned addresses: People develop their code usually on x86
>> which has no such alignment requirements, as it just needs to be PAGE_S=
IZE aligned.
>> So their code will always work fine on x86, but as soon as the same cod=
e
>> is built on other platforms it will break. As you know, on parisc it's =
pure luck
>> if the program chooses an address which is correctly aligned.
>> I'm one of the debian maintainers for parisc, and I've seen similiar
>> mmap-issues in other programs as well. Everytime I've found it to be wr=
ong,
>> you have to explain to the developers what's wrong and sometimes it's
>> not easy to fix it.
>> So, if we can educate people from assuming their code to be correct, I =
think
>> we can save a lot of additional work afterwards.
>> That said, I think it's better to be strict now, unless someone comes
>> up with a really good reason why it needs to be less strict.
>
> I don't disagree with the reasoning at all, but the problem is that it
> may introduce breakage if someone IS doing the right thing. Is it
> guaranteed to be true? No, certainly not. But someone could very well be
> writing perfectly portable code and mapping a ring into a specific
> address, and this will now break.

We will find out if there are such users if we keep it strict now and
open it up if it's really necessary.
If you open it up now, you won't be able to turn it stricter later.

> AFAICT, this is actually the case with the syzbot case. In fact, with
> the patch applied, it'll obviously start crashing on all archs as the
> mmaps will now return -EINVAL rather than work.

Yes, but it's not a real user and just a (invalid) testcase.
For that I think it's OK to just disable it.

Helge
