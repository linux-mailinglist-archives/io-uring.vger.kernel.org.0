Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA9B7403FD
	for <lists+io-uring@lfdr.de>; Tue, 27 Jun 2023 21:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjF0TYX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Jun 2023 15:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjF0TYW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Jun 2023 15:24:22 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCA410CC;
        Tue, 27 Jun 2023 12:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1687893852; x=1688498652; i=deller@gmx.de;
 bh=gFcHggE30DKUM2JgtlT+me9FNYXWWHP2feaOMJWLRvM=;
 h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
 b=iJzgJvlgoTgt0ziQXTscpq77ppjl9FDUbS+3g1Jmdtvxf55jphfKZK6uKSMkio+qDBk6uTv
 AhD6VstRUPEpvsqzmohChpryEfqjU4ZgvzVHaJvQtYr4h/zGDq8vOC3zh9gsNdbE/r/ET8SPL
 fOBPtol7YtctFaQAcOinPRskGwxfA7JJOmSeXWJXFSU0W7PPFpkzT1AGsliw4WIMgh/hviIWU
 DSudbYSmrX/1iu5Wcbt8Md+gAacEVZhPv/huUdmrprEIWcW03QndBtoLXa/srNExlAm1WAA1m
 feFKSPD+9m0WTbH1944pmKYuxqfnRW6h6nDtJNN7L79OSMjhiNEg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.155.6]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MuUj2-1pwHjl4838-00rWMR; Tue, 27
 Jun 2023 21:24:12 +0200
Message-ID: <c65f5b3a-e65f-8033-8f75-3c2247285977@gmx.de>
Date:   Tue, 27 Jun 2023 21:24:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2] io_uring: Adjust mapping wrt architecture aliasing
 requirements
Content-Language: en-US
To:     Jiri Slaby <jirislaby@kernel.org>, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-parisc@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>
References: <Y+3kwh8BokobVl6o@p100>
 <818c95bc-50f8-4b2e-d5ca-2511310de47c@kernel.org>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <818c95bc-50f8-4b2e-d5ca-2511310de47c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:hJ0Y6qgU64jUJdqm+N7J/p5TXyi+iMc0vEBJkte+bKz23ah/AhJ
 3/UQ+5zvYoudLG6bwH0gZ81Cws3Vacjm+MgRfXoPdCtrfVo6esqmPbampfCWWE0MNm/CDnr
 9vjV8Fem0rzZK1HLvd3r7NRWdTHfiydAs5q3VDFZICR9guPoGTQUgEpig8bjDFx9Y24BDa7
 gvvZPK2UZzJFNK+JJbK2w==
UI-OutboundReport: notjunk:1;M01:P0:tuu21xzxWE4=;xJAfg/Z8VdNsA3gXtDvgg7DunZi
 r5CWDgBM477k+EBUlc3qsWqF/ScuTHmKqM/ufNY54v3hAQFJJGxHFpu6dYLVmczsvRJL+5SKr
 EaVKdICCijS7EP3+fEl8xL8YMFeSi/9RVfvPDstvlVM2WgqH0c6p/5j1HvTZYiPNRI8trzrFr
 gQOUIkWw0OKZiCWA1YVFazBHkAFwn1cl6lpTGTlvfG6XHllTJKPk0jY1g0c4KTKh2ELpZ6ij+
 jlnFgXbXGrc011GZM/Z0urMC8dcPx3gYFDvaxKlK4o3reE+WNhVVUlcMPUCLAF892uBhpBqpd
 HiADpZi5MWGqeaRWvgSfLZE1pQ3H4s+Hbh4a3Erl7DI2y8iJGaDtBy+K+CFihoG3DCb47V7s8
 vcmKi8aoce1i+OFUFM8fNHKTSweSwy6tRqKZq1ywJ60v1UQdFBis6KpAPjHqQT07ClzpgctBn
 sPB46jWXn1xV5uQg52oNtczKQdrdPuNkDUfBtiygAq83YyjykaV/PMRVNdqg9+aOfILvMHCz/
 TlQXS6GBl2aHw9jILCKvzWufIt6CAiAL2cWUBCdYI2LnPSS40Fs3ORgs5KEiWo4pN6Qq82glp
 a8zRNWZVfZUoC9t7NtzCtsQnL5UZcnASL+jBQU3etjtVKyz/dkA0AHpO5WO+8S4aLYFwr1wU1
 xj5XYVr3xu7uRt47qbE2y9whHgPIydUTKSYDCFtdw/e1M5ki3t72fWiqhLR8vOefpku65GIQy
 nPVuOy2hejKd220fjmc18mBAtoMRoGEzIuiYT+5Y378oMkGuUMBM/vPEUUA03GkcGpdyXaw6a
 fQgWllQP80W3pT1c6H4Xm/1Fa+evlP/30tSe+msCg64WPV8XVi6XSDLQbyeQwK86N+Otlax3k
 8OfaQnaqWhZh0xqDTFtKNPTxecsLWfD81G9DGXAWgeR6hH+4WnZ81/n7Nq2+aUSnsFhhFKTrm
 cNq3N7Q2MZUWDM4xLMIKBWvRpw4=
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/27/23 16:14, Jiri Slaby wrote:
> On 16. 02. 23, 9:09, Helge Deller wrote:
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
>> =C2=A0 #include <linux/io_uring.h>
>> =C2=A0 #include <linux/audit.h>
>> =C2=A0 #include <linux/security.h>
>> +#include <asm/shmparam.h>
>>
>> =C2=A0 #define CREATE_TRACE_POINTS
>> =C2=A0 #include <trace/events/io_uring.h>
>> @@ -3059,6 +3060,54 @@ static __cold int io_uring_mmap(struct file *fil=
e, struct vm_area_struct *vma)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return remap_pfn_range(vma, vma->vm_star=
t, pfn, sz, vma->vm_page_prot);
>> =C2=A0 }
>>
>> +static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uns=
igned long addr, unsigned long len,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uns=
igned long pgoff, unsigned long flags)
>> +{
>> +=C2=A0=C2=A0=C2=A0 const unsigned long mmap_end =3D arch_get_mmap_end(=
addr, len, flags);
>> +=C2=A0=C2=A0=C2=A0 struct vm_unmapped_area_info info;
>> +=C2=A0=C2=A0=C2=A0 void *ptr;
>> +
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Do not allow to map to user-provided addres=
s to avoid breaking the
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * aliasing rules. Userspace is not able to gu=
ess the offset address of
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * kernel kmalloc()ed memory area.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 if (addr)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>> +
>> +=C2=A0=C2=A0=C2=A0 ptr =3D io_uring_validate_mmap_request(filp, pgoff,=
 len);
>> +=C2=A0=C2=A0=C2=A0 if (IS_ERR(ptr))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>> +
>> +=C2=A0=C2=A0=C2=A0 info.flags =3D VM_UNMAPPED_AREA_TOPDOWN;
>> +=C2=A0=C2=A0=C2=A0 info.length =3D len;
>> +=C2=A0=C2=A0=C2=A0 info.low_limit =3D max(PAGE_SIZE, mmap_min_addr);
>> +=C2=A0=C2=A0=C2=A0 info.high_limit =3D arch_get_mmap_base(addr, curren=
t->mm->mmap_base);
>
> Hi,
>
> this breaks compat (x86_32) on x86_64 in 6.4. When you run most liburing=
 tests, you'll get ENOMEM, as this high_limit is something in 64-bit space=
...
>
>> +#ifdef SHM_COLOUR
>> +=C2=A0=C2=A0=C2=A0 info.align_mask =3D PAGE_MASK & (SHM_COLOUR - 1UL);
>> +#else
>> +=C2=A0=C2=A0=C2=A0 info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL);
>> +#endif
>> +=C2=A0=C2=A0=C2=A0 info.align_offset =3D (unsigned long) ptr;
>> +
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * A failed mmap() very likely causes applicat=
ion failure,
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * so fall back to the bottom-up function here=
. This scenario
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * can happen with large stack limits and larg=
e mmap()
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * allocations.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_area(&info);
>
> So the found addr here is > TASK_SIZE - len for 32-bit bins. And get_unm=
apped_area() returns ENOMEM.
>
>> +=C2=A0=C2=A0=C2=A0 if (offset_in_page(addr)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.flags =3D 0;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.low_limit =3D TASK_UNM=
APPED_BASE;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.high_limit =3D mmap_en=
d;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_area(&=
info);
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 return addr;
>> +}
>
> Reverting the whole commit helps of course. Even this completely incorre=
ct hack helps:
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3398,7 +3398,7 @@ static unsigned long io_uring_mmu_get_unmapped_are=
a(struct file *filp,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsi=
gned long addr, unsigned long len,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsi=
gned long pgoff, unsigned long flags)
>  =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const unsigned long mmap_end =3D a=
rch_get_mmap_end(addr, len, flags);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const unsigned long mmap_end =3D i=
n_32bit_syscall() ? task_size_32bit() : arch_get_mmap_end(addr, len, flags=
);
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct vm_unmapped_area_info=
 info;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *ptr;
>
> @@ -3417,7 +3417,7 @@ static unsigned long io_uring_mmu_get_unmapped_are=
a(struct file *filp,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.flags =3D VM_UNMAPPED_A=
REA_TOPDOWN;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.length =3D len;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.low_limit =3D max(PAGE_=
SIZE, mmap_min_addr);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.high_limit =3D arch_get_mmap_=
base(addr, current->mm->mmap_base);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.high_limit =3D in_32bit_sysca=
ll() ? task_size_32bit() : arch_get_mmap_base(addr, current->mm->mmap_base=
);

I think your "incorrect hack" is actually correct.
If it's the compat case which breaks, then task_size_32bit() might be righ=
t.
Maybe adding arch_get_mmap_base() and arch_get_mmap_end() macros to handle
the compat case in to arch/x86/include/asm/* does work, e.g.
#define arch_get_mmap_base(addr, base) \
	(in_32bit_syscall() ? task_size_32bit() : base)

?
Helge
