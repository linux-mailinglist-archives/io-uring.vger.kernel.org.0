Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610977511D7
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 22:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjGLUbK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 16:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbjGLUbH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 16:31:07 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8EC2116;
        Wed, 12 Jul 2023 13:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1689193833; x=1689798633; i=deller@gmx.de;
 bh=Hf6CmIz2PtSZ4LhrJxL2v+hxwoM5rUHnhBEM8IqV9jA=;
 h=X-UI-Sender-Class:Date:Subject:From:To:Cc:References:In-Reply-To;
 b=XiLNicdpPlv24HXsSZpcn0CJWK81Y6zw+DEAEAYdJMCRFBVQQcBeezquuia4parw3wd747r
 tKwL+1ykKs5H7INsnB9cEeF11Fzd6yUIeqMldmUsHFJcWtEduHdyFsOoG1WU8vxf+itQFJmmD
 hsrGmUvuDw7uIhyrOJqs87iRCkpWKpvj7HRMJo7iMozdhWEYz0I5vDLkRPszw0BXgfhTGCSBM
 IFLzmE3rqNeUNBvNGOmescVCrjZFZL0KrRu6Mv8XiGSRxUk0O9g7g3c9cSMl6O4dJI3q3h4yV
 KdBKJINkdkZ4ND6T8cW3E8bjgCGB0GYWX7Cxn5IBcHR8t0/CMIYQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.144.114]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MIx3C-1qYaxv2QOY-00KSN6; Wed, 12
 Jul 2023 22:30:33 +0200
Message-ID: <802b84f7-94f4-638b-3742-26bca00b262d@gmx.de>
Date:   Wed, 12 Jul 2023 22:30:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/5] io_uring: Adjust mapping wrt architecture aliasing
 requirements
Content-Language: en-US
From:   Helge Deller <deller@gmx.de>
To:     matoro <matoro_mailinglist_kernel@matoro.tk>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Linux Ia64 <linux-ia64@vger.kernel.org>,
        glaubitz@physik.fu-berlin.de, Sam James <sam@gentoo.org>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <20230314171641.10542-2-axboe@kernel.dk>
 <1d5f8f99f39e2769b9c76fbc24e2cf50@matoro.tk> <ZK7TrdVXc0O6HMpQ@ls3530>
 <f1bed3cc3c43083cfd86768a91402f6b@matoro.tk>
 <a3ae1656-be97-ccc2-8962-1cb70ebc67fa@gmx.de>
In-Reply-To: <a3ae1656-be97-ccc2-8962-1cb70ebc67fa@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vgCVHdX+CgDcuzYjpkD7gUQPAY5kU6GvQQ//OzrbsVSx0ivv8HH
 lrPSFEAk9GwPWzRV4Je9hGpc1d/tSvoeENBxVXoZs3wLCTDdju2r5tVVW8TSFUBTlu7CLLC
 QGEx39mcm39gPHDaai5Yo/q7+RskoJ9Noj/44eyClWOZ5e/26BZ1ZoH6yoPgn8a2HF/HIUG
 bpltOXLfJUSu93u7pGAxw==
UI-OutboundReport: notjunk:1;M01:P0:9Q/jEzQSH+U=;Ehekau0dC42DU8tJrkCzKp/IRfd
 IDL3jWu/Pzd6UBv9TyjT/vy8Xh3fhAjXxLqRk/ae6EyN/0so5mqYqeoGxEsGUnFiKbaDJnc1H
 ibVm2xQnCt4w0VmHql9bGJcPqAPYT/ew71Uz9uPLhYOCsl6Ch2iGE3ArFhzswLDmJ85ck8beV
 zp7UYRuBnxGbfdT56PdghIVqEfMldj1dOAqLkeX75GIRxyZGIgQoLwKLGsEJb+nzV+f5tuK0e
 1QKDWBjJFyRinFQgxnfQpdaxuFarSaj5Dk9ikaDDqECKmB9t0pkadhwMJY2LNPx+gkTDyWliQ
 OOeL/fPVsbZe68Xby15JtOGq5I/xanaVjYwl853hegPJLHJ7ppk42Ct7pEUDC2jNXX0Pskuho
 cRzJe6ADmfgFDVuy+6eHEToh8TcM6NybUwpQc1AA11H5iDcZP76/0Yibn7YHt+oFDswHPkVLe
 KYpaIT+fGZ+U14nKn4JlMfAe6MUJS17fKoBjTQFi/CeoqIt2la9ESyI5NcTX+Cmqd/Tj1XiNv
 TCoMEnqnW6Jx4afHEgxswGjIPYQRe33zxKqX7cbAapubNUixdPZv+5Em0lABFEzz3MToR2758
 Z1onvyhAVeh1zlNJOy5S5PkYHgWXe32iP12eYXoo0gz9t+fp2TfixPWc3Ry25qY5goKTzoCCm
 /LnQFlbw5fq+uqmZpVTBR+2gpR333pJm4H4Mt0YjR2lXXaJdtvi3eSUw15Ukv2CMQ2pinghpq
 nKlkNT5sR+RUiXNB1mhT6dh+jRO4pE1OjSJ2njSJoFMN0muLXQnkWj4YXzbdtyJgGppG5KLR7
 Fe8PIXcwNBuf+siPywfxFt4Hq8Dt2CRBh5Ijw6Gk8qpYzgZhUssFjq4i6AHl/hueSLF03YHek
 VLDV9WhERxnt1t5ygGtvAQcyehBBNdEvKizB9xYbBJ9WSkL3VQielkhxFst4ae3MMu/7DCmzv
 +zz7mumCAGXsOJhlQycvPgvI/lc=
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/12/23 21:05, Helge Deller wrote:
> On 7/12/23 19:28, matoro wrote:
>> On 2023-07-12 12:24, Helge Deller wrote:
>>> Hi Matoro,
>>>
>>> * matoro <matoro_mailinglist_kernel@matoro.tk>:
>>>> On 2023-03-14 13:16, Jens Axboe wrote:
>>>> > From: Helge Deller <deller@gmx.de>
>>>> >
>>>> > Some architectures have memory cache aliasing requirements (e.g. pa=
risc)
>>>> > if memory is shared between userspace and kernel. This patch fixes =
the
>>>> > kernel to return an aliased address when asked by userspace via mma=
p().
>>>> >
>>>> > Signed-off-by: Helge Deller <deller@gmx.de>
>>>> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> > ---
>>>> >=C2=A0 io_uring/io_uring.c | 51 ++++++++++++++++++++++++++++++++++++=
+++++++++
>>>> >=C2=A0 1 file changed, 51 insertions(+)
>>>> >
>>>> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> > index 722624b6d0dc..3adecebbac71 100644
>>>> > --- a/io_uring/io_uring.c
>>>> > +++ b/io_uring/io_uring.c
>>>> > @@ -72,6 +72,7 @@
>>>> >=C2=A0 #include <linux/io_uring.h>
>>>> >=C2=A0 #include <linux/audit.h>
>>>> >=C2=A0 #include <linux/security.h>
>>>> > +#include <asm/shmparam.h>
>>>> >
>>>> >=C2=A0 #define CREATE_TRACE_POINTS
>>>> >=C2=A0 #include <trace/events/io_uring.h>
>>>> > @@ -3317,6 +3318,54 @@ static __cold int io_uring_mmap(struct file
>>>> > *file, struct vm_area_struct *vma)
>>>> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return remap_pfn_range(vma, vma->vm_s=
tart, pfn, sz,
>>>> > vma->vm_page_prot);
>>>> >=C2=A0 }
>>>> >
>>>> > +static unsigned long io_uring_mmu_get_unmapped_area(struct file *f=
ilp,
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 unsigned long addr, unsigned long len,
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 unsigned long pgoff, unsigned long flags)
>>>> > +{
>>>> > +=C2=A0=C2=A0=C2=A0 const unsigned long mmap_end =3D arch_get_mmap_=
end(addr, len, flags);
>>>> > +=C2=A0=C2=A0=C2=A0 struct vm_unmapped_area_info info;
>>>> > +=C2=A0=C2=A0=C2=A0 void *ptr;
>>>> > +
>>>> > +=C2=A0=C2=A0=C2=A0 /*
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 * Do not allow to map to user-provided ad=
dress to avoid breaking the
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 * aliasing rules. Userspace is not able t=
o guess the offset address
>>>> > of
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 * kernel kmalloc()ed memory area.
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>> > +=C2=A0=C2=A0=C2=A0 if (addr)
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>>> > +
>>>> > +=C2=A0=C2=A0=C2=A0 ptr =3D io_uring_validate_mmap_request(filp, pg=
off, len);
>>>> > +=C2=A0=C2=A0=C2=A0 if (IS_ERR(ptr))
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>>> > +
>>>> > +=C2=A0=C2=A0=C2=A0 info.flags =3D VM_UNMAPPED_AREA_TOPDOWN;
>>>> > +=C2=A0=C2=A0=C2=A0 info.length =3D len;
>>>> > +=C2=A0=C2=A0=C2=A0 info.low_limit =3D max(PAGE_SIZE, mmap_min_addr=
);
>>>> > +=C2=A0=C2=A0=C2=A0 info.high_limit =3D arch_get_mmap_base(addr, cu=
rrent->mm->mmap_base);
>>>> > +#ifdef SHM_COLOUR
>>>> > +=C2=A0=C2=A0=C2=A0 info.align_mask =3D PAGE_MASK & (SHM_COLOUR - 1=
UL);
>>>> > +#else
>>>> > +=C2=A0=C2=A0=C2=A0 info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL);
>>>> > +#endif
>>>> > +=C2=A0=C2=A0=C2=A0 info.align_offset =3D (unsigned long) ptr;
>>>> > +
>>>> > +=C2=A0=C2=A0=C2=A0 /*
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 * A failed mmap() very likely causes appl=
ication failure,
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 * so fall back to the bottom-up function =
here. This scenario
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 * can happen with large stack limits and =
large mmap()
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 * allocations.
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>> > +=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_area(&info);
>>>> > +=C2=A0=C2=A0=C2=A0 if (offset_in_page(addr)) {
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.flags =3D 0;
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.low_limit =3D TASK=
_UNMAPPED_BASE;
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.high_limit =3D mma=
p_end;
>>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_ar=
ea(&info);
>>>> > +=C2=A0=C2=A0=C2=A0 }
>>>> > +
>>>> > +=C2=A0=C2=A0=C2=A0 return addr;
>>>> > +}
>>>> > +
>>>> >=C2=A0 #else /* !CONFIG_MMU */
>>>> >
>>>> >=C2=A0 static int io_uring_mmap(struct file *file, struct vm_area_st=
ruct *vma)
>>>> > @@ -3529,6 +3578,8 @@ static const struct file_operations io_uring_=
fops
>>>> > =3D {
>>>> >=C2=A0 #ifndef CONFIG_MMU
>>>> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .get_unmapped_area =3D io_uring_nommu=
_get_unmapped_area,
>>>> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .mmap_capabilities =3D io_uring_nommu=
_mmap_capabilities,
>>>> > +#else
>>>> > +=C2=A0=C2=A0=C2=A0 .get_unmapped_area =3D io_uring_mmu_get_unmappe=
d_area,
>>>> >=C2=A0 #endif
>>>> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .poll=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 =3D io_uring_poll,
>>>> >=C2=A0 #ifdef CONFIG_PROC_FS
>>>>
>>>> Hi Jens, Helge - I've bisected a regression with io_uring on ia64 to =
this
>>>> patch in 6.4.=C2=A0 Unfortunately this breaks userspace programs usin=
g io_uring,
>>>> the easiest one to test is cmake with an io_uring enabled libuv (i.e.=
, libuv
>>>> >=3D 1.45.0) which will hang.
>>>>
>>>> I am aware that ia64 is in a vulnerable place right now which I why I=
 am
>>>> keeping this spread limited.=C2=A0 Since this clearly involves
>>>> architecture-specific changes for parisc,
>>>
>>> it isn't so much architecture-specific... (just one ifdef)
>>>
>>>> is there any chance of looking at
>>>> what is required to do the same for ia64?=C2=A0 I looked at
>>>> 0ef36bd2b37815719e31a72d2beecc28ca8ecd26 ("parisc: change value of SH=
MLBA
>>>> from 0x00400000 to PAGE_SIZE") and tried to replicate the SHMLBA ->
>>>> SHM_COLOUR change, but it made no difference.
>>>>
>>>> If hardware is necessary for testing, I can provide it, including rem=
ote BMC
>>>> access for restarts/kernel debugging.=C2=A0 Any takers?
>>>
>>> I won't have time to test myself, but maybe you could test?
>>>
>>> Basically we should try to find out why io_uring_mmu_get_unmapped_area=
()
>>> doesn't return valid addresses, while arch_get_unmapped_area()
>>> [in arch/ia64/kernel/sys_ia64.c] does.
>>>
>>> You could apply this patch first:
>>> It introduces a memory leak (as it requests memory twice), but maybe w=
e
>>> get an idea?
>>> The ia64 arch_get_unmapped_area() searches for memory from bottom
>>> (flags=3D0), while io_uring function tries top-down first. Maybe that'=
s
>>> the problem. And I don't understand the offset_in_page() check right
>>> now.
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 3bca7a79efda..93b1964d2bbb 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -3431,13 +3431,17 @@ static unsigned long io_uring_mmu_get_unmapped=
_area(struct file *filp,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * can happen with large stack limits an=
d large mmap()
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * allocations.
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +/* compare to arch_get_unmapped_area() in arch/ia64/kernel/sys_ia64.c=
 */
>>> =C2=A0=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_area(&info);
>>> -=C2=A0=C2=A0=C2=A0 if (offset_in_page(addr)) {
>>> +printk("io_uring_mmu_get_unmapped_area() address 1 is: %px\n", addr);
>>> +=C2=A0=C2=A0=C2=A0 addr =3D NULL;
>>> +=C2=A0=C2=A0=C2=A0 if (!addr) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.flags =3D 0;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.low_limit =3D TA=
SK_UNMAPPED_BASE;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.high_limit =3D m=
map_end;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_=
area(&info);
>>> =C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +printk("io_uring_mmu_get_unmapped_area() returns address %px\n", addr=
);
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0 return addr;
>>> =C2=A0}
>>>
>>>
>>> Another option is to disable the call to io_uring_nommu_get_unmapped_a=
rea())
>>> with the next patch. Maybe you could add printks() to ia64's arch_get_=
unmapped_area()
>>> and check what it returns there?
>>>
>>> @@ -3654,6 +3658,8 @@ static const struct file_operations io_uring_fop=
s =3D {
>>> =C2=A0#ifndef CONFIG_MMU
>>> =C2=A0=C2=A0=C2=A0=C2=A0 .get_unmapped_area =3D io_uring_nommu_get_unm=
apped_area,
>>> =C2=A0=C2=A0=C2=A0=C2=A0 .mmap_capabilities =3D io_uring_nommu_mmap_ca=
pabilities,
>>> +#elif 0=C2=A0=C2=A0=C2=A0 /* IS_ENABLED(CONFIG_IA64) */
>>> +=C2=A0=C2=A0=C2=A0 .get_unmapped_area =3D NULL,
>>> =C2=A0#else
>>> =C2=A0=C2=A0=C2=A0=C2=A0 .get_unmapped_area =3D io_uring_mmu_get_unmap=
ped_area,
>>> =C2=A0#endif
>>>
>>> Helge
>>
>> Thanks Helge.=C2=A0 Sample output from that first patch:
>>
>> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() address 1 i=
s: 1ffffffffff40000
>> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() returns add=
ress 2000000001e40000
>> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() address 1 i=
s: 1ffffffffff20000
>> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() returns add=
ress 2000000001f20000
>> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() address 1 i=
s: 1ffffffffff30000
>> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() returns add=
ress 2000000001f30000
>> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() address 1 i=
s: 1ffffffffff90000
>> [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() returns add=
ress 2000000001f90000
>>
>> This pattern seems to be pretty stable, I tried instead just directly r=
eturning the result of a call to arch_get_unmapped_area() at the end of th=
e function and it seems similar:
>>
>> [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area() would retur=
n address 1ffffffffffd0000
>> [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would return ad=
dress 2000000001f00000
>> [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area() would retur=
n address 1ffffffffff00000
>> [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would return ad=
dress 1ffffffffff00000
>> [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area() would retur=
n address 1fffffffffe20000
>> [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would return ad=
dress 2000000002000000
>> [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area() would retur=
n address 1fffffffffe30000
>> [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would return ad=
dress 2000000002100000
>>
>> Is that enough of a clue to go on?
>
> SHMLBA on ia64 is 0x100000:
> arch/ia64/include/asm/shmparam.h:#define=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 SHMLBA=C2=A0 (1024*1024)
> but the values returned by io_uring_mmu_get_unmapped_area() does not ful=
lfill this.
>
> So, probably ia64's SHMLBA isn't pulled in correctly in io_uring/io_urin=
g.c.
> Check value of this line:
>  =C2=A0=C2=A0=C2=A0=C2=A0info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL);
>
> You could also add
> #define SHM_COLOUR=C2=A0 0x100000
> in front of the
>  =C2=A0=C2=A0=C2=A0=C2=A0#ifdef SHM_COLOUR
> (define SHM_COLOUR in io_uring/kbuf.c too).

What is the value of PAGE_SIZE and "ptr" on your machine?
For 4k page size I get:
SHMLBA -1   ->        FFFFF
PAGE_MASK   -> FFFFFFFFF000
so,
info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL) =3D 0xFF000;
You could try to set nfo.align_mask =3D 0xfffff;

Helge
