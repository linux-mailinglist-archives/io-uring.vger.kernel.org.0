Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148EB699A16
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 17:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjBPQd3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 11:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjBPQd1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 11:33:27 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B3ADC;
        Thu, 16 Feb 2023 08:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676565196; i=deller@gmx.de;
        bh=igojhHqQvfso7u86oH/CRAxtU3ITFmb69p5Yje8hKZI=;
        h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
        b=oppLhqD1wx0FR1SbOuEL1fbJrrG7EXENHmXYOA0b1cBbk/w25YKiEfXxAllec6uO2
         AC3s2QW3Vo+62+4QQ1G0tcKT+qqzho1s26iudFOfBQ2wSf6fj1hDa77tPLrdGxf3UQ
         K5Xlv96SFbBYeeps2qLXfQvaL2TOQBWDkQOvSUlVyoQcGNxHfLcJucgrGqawRiP39k
         Yvl/YEGPX+HIqqX3RDTFmH65Sse3+gegG8EVcOmQcaw0Wf3XtfbV4piSCC8zfZcDjT
         QHx1Mkko0UF+lf01wQzdv1QAM+oZ5sBB2A5qxFJSG7W4Ui3rqL+/NfTdNRQC1ifWxm
         VgGZBzWZMi/bw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.164.173]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MZktj-1p5H2J0geV-00Wkp7; Thu, 16
 Feb 2023 17:33:16 +0100
Message-ID: <2cafe988-f436-e21f-4ec2-8bcca4d3d7e4@gmx.de>
Date:   Thu, 16 Feb 2023 17:33:15 +0100
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
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <47f1f4f3-36c8-a1f0-2d07-3f03454dfb35@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nXczfz+0El9hLi3mIyzDLrfihlFHjD0ajMTBIRg6PL5lgaYiOIC
 2wZ0tabXW50AxN2ltzrsf7a5D2pN7dX9n7T+F2OAjcg3wsJamuMnm8b1J70N7OVclk8fQSs
 DP2eZ2XlFX+MWHbpAoZeCZu3sGBByo/lZk12e0aSoz99YqeVX27yOldop1wojmPOcpo0G5t
 2OWjAHlBn6b5jblVgwzCw==
UI-OutboundReport: notjunk:1;M01:P0:cXaOAGlXE9A=;MzGkGP5T+wwMWnLubO4o9Lxxhgp
 Pn0ZlMpWYyB7Iw1NwpwjQm67ZMhnDd4Wd3A/Rk4+E1T/QcUgHk9FBs+uCvBYfgtUMYRNTRoBd
 atVSg0rYjqrUkDfHILRt+xaFgw01okzIZtdW6nat75lfYNkT4kR31z4pdUFkrSZq3cOVWWofE
 4w5AiojouBaPFy1W//gd8MdYSZuPRCcdn0/xtxryl4PdKG+2TUITtN/4T5B93bOV/gXo2aR1M
 Ynwx9lOAIfyjLej0PohKu20QwYc5go/nLlqpdU0/Fmduca8XCn3AGwkGQX5AP4ppTnsFe1mal
 D6MC8Y+eBDJaDK45GBiXvlvw4VYfcKBGbfGgL9jyESV+3mKvv62NUT88secJA624xyoKyE+Vr
 rZQBHH9DoOMjyFt9G4C7271f4EjaroqhXaVaNqRkbxcVr7/3EyZoFoA6KgYDvcnYRQCrc6SCB
 xCsEi0za03ON6R5YEaqMqD1MOSMgNH0UNuXDwZQVlqznh5or2WnXtWgghHCw1jFbJOeiga6Ym
 6ISqJbGgmP067x/62X3JGlIiSCzQK+SaQoluEKxLXqgy9J+ppJlSMhnRptC/OW5ELAJuEqsqR
 USA5fySPc9HXKVrm6t9z5SxX6TgAwkkL7DKUaxdi3PX6LGyj38SR6M9HtPfD3ZEcRHFKV5nkY
 kyWJGdHurl6Bmbhbz7uBre4CHvk6RQIJAQ/w37LP2xkLuDIeaGegXdCE4ZauYmVWXNgPOQM1+
 EfxqKSjs7x/OZT5z2BbT28HqJnU68JuRuB3xPYpKWUY8e3ncEl+1i4+SFefv6TeFS0BIinQ68
 oTBC3lFM8DYdJe5tYhG9Trts0U1wmyjJ8DmdgXzCeDXsLCO3rhrP8b0ClHRmVN5JXBegy4Glu
 kD0Opm2Wf+rf2cR9X4nC/722tvLq1a53TSnW1/ZX/vZZEmaMu1glb0B6qHdBybJNMe7YnAsrf
 i6BsXOSpGGubTGzsuvhIA881Dtg=
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/16/23 17:11, Jens Axboe wrote:
> On 2/16/23 1:09?AM, Helge Deller wrote:
>> Some architectures have memory cache aliasing requirements (e.g. parisc=
)
>> if memory is shared between userspace and kernel. This patch fixes the
>> kernel to return an aliased address when asked by userspace via mmap().
>>
>> Signed-off-by: Helge Deller <deller@gmx.de>
>> ---
>> v2: Do not allow to map to a user-provided addresss. This forces
>> programs to write portable code, as usually on x86 mapping to any
>> address will succeed, while it will fail for most provided address if
>> used on stricter architectures.
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 862e05e6691d..01fe7437a071 100644
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
>> @@ -3059,6 +3060,54 @@ static __cold int io_uring_mmap(struct file *fil=
e, struct vm_area_struct *vma)
>>   	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_pro=
t);
>>   }
>>
>> +static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp,
>> +			unsigned long addr, unsigned long len,
>> +			unsigned long pgoff, unsigned long flags)
>> +{
>> +	const unsigned long mmap_end =3D arch_get_mmap_end(addr, len, flags);
>> +	struct vm_unmapped_area_info info;
>> +	void *ptr;
>> +
>> +	/*
>> +	 * Do not allow to map to user-provided address to avoid breaking the
>> +	 * aliasing rules. Userspace is not able to guess the offset address =
of
>> +	 * kernel kmalloc()ed memory area.
>> +	 */
>> +	if (addr)
>> +		return -EINVAL;
>
> Can we relax this so that if the address is correctly aligned, it will
> allow it?

My previous patch had it relaxed, but after some more thoughts I removed
it in this v2-version again.

The idea behind it is good, but I see a huge disadvantage in allowing
correctly aligned addresses: People develop their code usually on x86
which has no such alignment requirements, as it just needs to be PAGE_SIZE=
 aligned.
So their code will always work fine on x86, but as soon as the same code
is built on other platforms it will break. As you know, on parisc it's pur=
e luck
if the program chooses an address which is correctly aligned.
I'm one of the debian maintainers for parisc, and I've seen similiar
mmap-issues in other programs as well. Everytime I've found it to be wrong=
,
you have to explain to the developers what's wrong and sometimes it's
not easy to fix it.
So, if we can educate people from assuming their code to be correct, I thi=
nk
we can save a lot of additional work afterwards.
That said, I think it's better to be strict now, unless someone comes
up with a really good reason why it needs to be less strict.

> The reported issue with sqpoll-cancel-hang.t is due to it
> crashing because it's a weird syzbot thing that does mmap() with
> MAP_FIXED and an address given.

Ok, but nevertheless I think it's better to be strict.

Helge
