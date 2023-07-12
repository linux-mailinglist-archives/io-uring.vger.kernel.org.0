Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178E47510EF
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 21:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjGLTGK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 15:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjGLTGJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 15:06:09 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94631FE6;
        Wed, 12 Jul 2023 12:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1689188728; x=1689793528; i=deller@gmx.de;
 bh=Z3x2F72t28Ws+B0G8vsBI9wbGj9qtmWG0gNMlWS+3N4=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=rGHzlecgsZkSRcGClzUnhFa4C9slFlJ03Dh9Bsh1sttGVC5zZvD8p8jDiG2SoJXPBIXt4R2
 o23B4r9hjIbpg27iglyen3gBmD1q+U6vwRK4v1OxqLhyYM+Up4KAzr2LxUjNGePlOetL2SUma
 mZ/xgLEpU1h0/AcIBIg62pd79m9W70DFERX+04cDA1ExO5Jgmsj7bjTBMyg3Pwq1mEQoTnkOR
 04Zu2PGFxXjrjdcljcvvSoJvyaD+seNZ5Z01xZkKhKa8gRxagZt3P3QkeR8AzRz9aia+BpFPh
 QmhLnX1soKvy+I98V772rA/jnTnfjh4zaBm01n8nVm1LM8KLZ6tg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.144.114]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mj8qj-1pntAT2mG5-00fEfZ; Wed, 12
 Jul 2023 21:05:28 +0200
Message-ID: <a3ae1656-be97-ccc2-8962-1cb70ebc67fa@gmx.de>
Date:   Wed, 12 Jul 2023 21:05:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/5] io_uring: Adjust mapping wrt architecture aliasing
 requirements
Content-Language: en-US
To:     matoro <matoro_mailinglist_kernel@matoro.tk>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Linux Ia64 <linux-ia64@vger.kernel.org>,
        glaubitz@physik.fu-berlin.de, Sam James <sam@gentoo.org>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <20230314171641.10542-2-axboe@kernel.dk>
 <1d5f8f99f39e2769b9c76fbc24e2cf50@matoro.tk> <ZK7TrdVXc0O6HMpQ@ls3530>
 <f1bed3cc3c43083cfd86768a91402f6b@matoro.tk>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <f1bed3cc3c43083cfd86768a91402f6b@matoro.tk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:fEC9C6SbQtRip8TOBMdGKkeYnK8K/63cfUwquPxETWVvrUDb4hP
 G6BFSztqQbkde8SCrfQoGPyg257pR/hLVhGAxjPjxHVq1/ty0t11t+OHr5XnFRf+XMlkYJE
 2/KdQ18vDL7tlzakYxo7I/6YNFUVWOjfmI/6x7HY+HKfu/5bH7UqkbRvL7cq0s4Ws3NHU5s
 p4suxfeIakFZsZXFC9DhA==
UI-OutboundReport: notjunk:1;M01:P0:R0/Tp12ZGKQ=;pWLgqgpe5px+MaqzmXKAW9dS/L2
 egxJbDJgPTzE06Cv3wQGf0g4CWmdXZlVSbq22fwrH2Y140ep66tFqVa10WBjpqmFTWqTsHE7z
 IYhsDkmM6lP1ucrmS02aT5r7qRj6BU0FeKyzbCfgQrKwxslDSBkhpdZc9WJCoRJkhBc9r91G6
 nBZUkm91XkEgg9jG/2YWPjnPA8ggDvD8r/wnf8Qq/Td4TAWpkJOvuglSkEvAm4TLWNxiASXY7
 s1jkDjc5I7pL/1N7XsUFuFI3GcuOiwHEfRqJwLQ9QT4u5jr1RBe/Whf+qFR10alBdZOMOhHrF
 gz41rbIagiZVZ+xnkzn2BW4gVWvf0UD16xDbmXKiTAOXUrrC9bKV3L8uwNADhT1OyD3CxICnE
 KfYSpXmdc1jdUkMCCyklFv01HBO4YD+SZdm31kCnezyiswobxEHD8Qp8TH+p/qnElIa/SPPFL
 2Jn3qJF5JjXL5jCLkBQ41FLegDdfgUvasUOK90GdIwcD1nBIt/qdvuBOppyX/QlzbaKg8XHYT
 PknPF9GjLySPDUiFs6Iq1/L43sz7aRK9iSCX0FnLvzcEdX3Tlzh8thsIwhq1OxyQX7icvnsDP
 XGnIAygSv4avtRfEp3LY1YWqkKItTM4MXqIawFzxuEqMuzj75mKlIq0Ci0KsU7+fMXsK3ABsh
 OsW0XrGirB5Ae+SzbiOnnj+1Mi1DaTpSOPAs+aCBj3tv3Gj6DQ4AVLhKC85Qb8FD9q8JdkeyD
 u+Ulx49OnGuVudl0L2G0B4IcIuyEOik/8luWbEEZZEBBP7Desx/U7TqleX66ptZTXsPFsBefn
 i+JXaFoCpzUJBSOHDEMpj7tYcfNewjHuRFVcF3w33Q1Ft1ws3T92QW5+f7RRHkSy/4JVkX4UU
 Xfu8X2yn7iP+u2AjEQHr7bZigL7n6xYQftGga80f2tHOxfSYqtcNLx/8Ar2bfPMlrdcSWRkqh
 vRuKzQ==
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/12/23 19:28, matoro wrote:
> On 2023-07-12 12:24, Helge Deller wrote:
>> Hi Matoro,
>>
>> * matoro <matoro_mailinglist_kernel@matoro.tk>:
>>> On 2023-03-14 13:16, Jens Axboe wrote:
>>> > From: Helge Deller <deller@gmx.de>
>>> >
>>> > Some architectures have memory cache aliasing requirements (e.g. par=
isc)
>>> > if memory is shared between userspace and kernel. This patch fixes t=
he
>>> > kernel to return an aliased address when asked by userspace via mmap=
().
>>> >
>>> > Signed-off-by: Helge Deller <deller@gmx.de>
>>> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> > ---
>>> >=C2=A0 io_uring/io_uring.c | 51 +++++++++++++++++++++++++++++++++++++=
++++++++
>>> >=C2=A0 1 file changed, 51 insertions(+)
>>> >
>>> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> > index 722624b6d0dc..3adecebbac71 100644
>>> > --- a/io_uring/io_uring.c
>>> > +++ b/io_uring/io_uring.c
>>> > @@ -72,6 +72,7 @@
>>> >=C2=A0 #include <linux/io_uring.h>
>>> >=C2=A0 #include <linux/audit.h>
>>> >=C2=A0 #include <linux/security.h>
>>> > +#include <asm/shmparam.h>
>>> >
>>> >=C2=A0 #define CREATE_TRACE_POINTS
>>> >=C2=A0 #include <trace/events/io_uring.h>
>>> > @@ -3317,6 +3318,54 @@ static __cold int io_uring_mmap(struct file
>>> > *file, struct vm_area_struct *vma)
>>> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return remap_pfn_range(vma, vma->vm_st=
art, pfn, sz,
>>> > vma->vm_page_prot);
>>> >=C2=A0 }
>>> >
>>> > +static unsigned long io_uring_mmu_get_unmapped_area(struct file *fi=
lp,
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
unsigned long addr, unsigned long len,
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
unsigned long pgoff, unsigned long flags)
>>> > +{
>>> > +=C2=A0=C2=A0=C2=A0 const unsigned long mmap_end =3D arch_get_mmap_e=
nd(addr, len, flags);
>>> > +=C2=A0=C2=A0=C2=A0 struct vm_unmapped_area_info info;
>>> > +=C2=A0=C2=A0=C2=A0 void *ptr;
>>> > +
>>> > +=C2=A0=C2=A0=C2=A0 /*
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 * Do not allow to map to user-provided add=
ress to avoid breaking the
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 * aliasing rules. Userspace is not able to=
 guess the offset address
>>> > of
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 * kernel kmalloc()ed memory area.
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> > +=C2=A0=C2=A0=C2=A0 if (addr)
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>> > +
>>> > +=C2=A0=C2=A0=C2=A0 ptr =3D io_uring_validate_mmap_request(filp, pgo=
ff, len);
>>> > +=C2=A0=C2=A0=C2=A0 if (IS_ERR(ptr))
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>> > +
>>> > +=C2=A0=C2=A0=C2=A0 info.flags =3D VM_UNMAPPED_AREA_TOPDOWN;
>>> > +=C2=A0=C2=A0=C2=A0 info.length =3D len;
>>> > +=C2=A0=C2=A0=C2=A0 info.low_limit =3D max(PAGE_SIZE, mmap_min_addr)=
;
>>> > +=C2=A0=C2=A0=C2=A0 info.high_limit =3D arch_get_mmap_base(addr, cur=
rent->mm->mmap_base);
>>> > +#ifdef SHM_COLOUR
>>> > +=C2=A0=C2=A0=C2=A0 info.align_mask =3D PAGE_MASK & (SHM_COLOUR - 1U=
L);
>>> > +#else
>>> > +=C2=A0=C2=A0=C2=A0 info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL);
>>> > +#endif
>>> > +=C2=A0=C2=A0=C2=A0 info.align_offset =3D (unsigned long) ptr;
>>> > +
>>> > +=C2=A0=C2=A0=C2=A0 /*
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 * A failed mmap() very likely causes appli=
cation failure,
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 * so fall back to the bottom-up function h=
ere. This scenario
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 * can happen with large stack limits and l=
arge mmap()
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 * allocations.
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> > +=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_area(&info);
>>> > +=C2=A0=C2=A0=C2=A0 if (offset_in_page(addr)) {
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.flags =3D 0;
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.low_limit =3D TASK_=
UNMAPPED_BASE;
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.high_limit =3D mmap=
_end;
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_are=
a(&info);
>>> > +=C2=A0=C2=A0=C2=A0 }
>>> > +
>>> > +=C2=A0=C2=A0=C2=A0 return addr;
>>> > +}
>>> > +
>>> >=C2=A0 #else /* !CONFIG_MMU */
>>> >
>>> >=C2=A0 static int io_uring_mmap(struct file *file, struct vm_area_str=
uct *vma)
>>> > @@ -3529,6 +3578,8 @@ static const struct file_operations io_uring_f=
ops
>>> > =3D {
>>> >=C2=A0 #ifndef CONFIG_MMU
>>> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .get_unmapped_area =3D io_uring_nommu_=
get_unmapped_area,
>>> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .mmap_capabilities =3D io_uring_nommu_=
mmap_capabilities,
>>> > +#else
>>> > +=C2=A0=C2=A0=C2=A0 .get_unmapped_area =3D io_uring_mmu_get_unmapped=
_area,
>>> >=C2=A0 #endif
>>> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .poll=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 =3D io_uring_poll,
>>> >=C2=A0 #ifdef CONFIG_PROC_FS
>>>
>>> Hi Jens, Helge - I've bisected a regression with io_uring on ia64 to t=
his
>>> patch in 6.4.=C2=A0 Unfortunately this breaks userspace programs using=
 io_uring,
>>> the easiest one to test is cmake with an io_uring enabled libuv (i.e.,=
 libuv
>>> >=3D 1.45.0) which will hang.
>>>
>>> I am aware that ia64 is in a vulnerable place right now which I why I =
am
>>> keeping this spread limited.=C2=A0 Since this clearly involves
>>> architecture-specific changes for parisc,
>>
>> it isn't so much architecture-specific... (just one ifdef)
>>
>>> is there any chance of looking at
>>> what is required to do the same for ia64?=C2=A0 I looked at
>>> 0ef36bd2b37815719e31a72d2beecc28ca8ecd26 ("parisc: change value of SHM=
LBA
>>> from 0x00400000 to PAGE_SIZE") and tried to replicate the SHMLBA ->
>>> SHM_COLOUR change, but it made no difference.
>>>
>>> If hardware is necessary for testing, I can provide it, including remo=
te BMC
>>> access for restarts/kernel debugging.=C2=A0 Any takers?
>>
>> I won't have time to test myself, but maybe you could test?
>>
>> Basically we should try to find out why io_uring_mmu_get_unmapped_area(=
)
>> doesn't return valid addresses, while arch_get_unmapped_area()
>> [in arch/ia64/kernel/sys_ia64.c] does.
>>
>> You could apply this patch first:
>> It introduces a memory leak (as it requests memory twice), but maybe we
>> get an idea?
>> The ia64 arch_get_unmapped_area() searches for memory from bottom
>> (flags=3D0), while io_uring function tries top-down first. Maybe that's
>> the problem. And I don't understand the offset_in_page() check right
>> now.
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 3bca7a79efda..93b1964d2bbb 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -3431,13 +3431,17 @@ static unsigned long io_uring_mmu_get_unmapped_=
area(struct file *filp,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * can happen with large stack limits and=
 large mmap()
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * allocations.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +/* compare to arch_get_unmapped_area() in arch/ia64/kernel/sys_ia64.c =
*/
>> =C2=A0=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_area(&info);
>> -=C2=A0=C2=A0=C2=A0 if (offset_in_page(addr)) {
>> +printk("io_uring_mmu_get_unmapped_area() address 1 is: %px\n", addr);
>> +=C2=A0=C2=A0=C2=A0 addr =3D NULL;
>> +=C2=A0=C2=A0=C2=A0 if (!addr) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.flags =3D 0;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.low_limit =3D TAS=
K_UNMAPPED_BASE;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.high_limit =3D mm=
ap_end;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_a=
rea(&info);
>> =C2=A0=C2=A0=C2=A0=C2=A0 }
>> +printk("io_uring_mmu_get_unmapped_area() returns address %px\n", addr)=
;
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 return addr;
>> =C2=A0}
>>
>>
>> Another option is to disable the call to io_uring_nommu_get_unmapped_ar=
ea())
>> with the next patch. Maybe you could add printks() to ia64's arch_get_u=
nmapped_area()
>> and check what it returns there?
>>
>> @@ -3654,6 +3658,8 @@ static const struct file_operations io_uring_fops=
 =3D {
>> =C2=A0#ifndef CONFIG_MMU
>> =C2=A0=C2=A0=C2=A0=C2=A0 .get_unmapped_area =3D io_uring_nommu_get_unma=
pped_area,
>> =C2=A0=C2=A0=C2=A0=C2=A0 .mmap_capabilities =3D io_uring_nommu_mmap_cap=
abilities,
>> +#elif 0=C2=A0=C2=A0=C2=A0 /* IS_ENABLED(CONFIG_IA64) */
>> +=C2=A0=C2=A0=C2=A0 .get_unmapped_area =3D NULL,
>> =C2=A0#else
>> =C2=A0=C2=A0=C2=A0=C2=A0 .get_unmapped_area =3D io_uring_mmu_get_unmapp=
ed_area,
>> =C2=A0#endif
>>
>> Helge
>
> Thanks Helge.=C2=A0 Sample output from that first patch:
>
> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() address 1 is=
: 1ffffffffff40000
> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() returns addr=
ess 2000000001e40000
> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() address 1 is=
: 1ffffffffff20000
> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() returns addr=
ess 2000000001f20000
> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() address 1 is=
: 1ffffffffff30000
> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() returns addr=
ess 2000000001f30000
> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() address 1 is=
: 1ffffffffff90000
> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() returns addr=
ess 2000000001f90000
>
> This pattern seems to be pretty stable, I tried instead just directly re=
turning the result of a call to arch_get_unmapped_area() at the end of the=
 function and it seems similar:
>
> [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area() would return=
 address 1ffffffffffd0000
> [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would return add=
ress 2000000001f00000
> [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area() would return=
 address 1ffffffffff00000
> [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would return add=
ress 1ffffffffff00000
> [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area() would return=
 address 1fffffffffe20000
> [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would return add=
ress 2000000002000000
> [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area() would return=
 address 1fffffffffe30000
> [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would return add=
ress 2000000002100000
>
> Is that enough of a clue to go on?

SHMLBA on ia64 is 0x100000:
arch/ia64/include/asm/shmparam.h:#define        SHMLBA  (1024*1024)
but the values returned by io_uring_mmu_get_unmapped_area() does not fullf=
ill this.

So, probably ia64's SHMLBA isn't pulled in correctly in io_uring/io_uring.=
c.
Check value of this line:
	info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL);

You could also add
#define SHM_COLOUR  0x100000
in front of the
	#ifdef SHM_COLOUR
(define SHM_COLOUR in io_uring/kbuf.c too).

Helge
