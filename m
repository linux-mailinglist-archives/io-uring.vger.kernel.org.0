Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069017556E0
	for <lists+io-uring@lfdr.de>; Sun, 16 Jul 2023 22:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbjGPUy4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Jul 2023 16:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbjGPUyu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Jul 2023 16:54:50 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E6C109;
        Sun, 16 Jul 2023 13:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1689540858; x=1690145658; i=deller@gmx.de;
 bh=s4Yckyeh31GYbwREkyDwEuFn2EloxNa6Hp0jxr3AK+U=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=FS1Tem9TXFzpeBqYFkFtrpevk2uexR6lxkryThCA1LKnaGy+XtG/pMjaHa2jajI0+BZ1n8b
 7GslUiBBePGYM/gN8llWYPR/Mhi9eq9fvc9Ant+XsUA5ni3jUPDiWWtyBfiXY69MRzq/Af7E0
 tD5B+CRx74ZoDNd2AD2ubshQeKJw+fr69kXigqFpSLzbSQki7wAg45gWdMLMzuy1b0IOdUEZC
 w7GAydF0whFLsnbaI4fqZpwPmFBQKsJPQo7IOjbpCW8Vtnj+US/J+OpIe8/tvj4z7MCSWII5d
 BCjl8PXnxShM+MmAX0H4wzzZ6Bh5DYwF0w/2pI33uxw4SJGV+4sg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.154.206]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MHGCo-1q7xSk1bZg-00DIaa; Sun, 16
 Jul 2023 22:54:18 +0200
Message-ID: <7d3fb4b8-a7e6-8a28-0558-75c1c5a0518d@gmx.de>
Date:   Sun, 16 Jul 2023 22:54:16 +0200
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
 <a3ae1656-be97-ccc2-8962-1cb70ebc67fa@gmx.de>
 <802b84f7-94f4-638b-3742-26bca00b262d@gmx.de>
 <8bb091fb5fd00072842fe92b03abac9b@matoro.tk> <ZK+nYIxe6zf2vYwH@ls3530>
 <695fbf1a4f48619de63297b21aa9f6c4@matoro.tk> <ZLOUL+5PxCHW/uc5@p100>
 <58aaccbd483c582b3bfd590c110d45c6@matoro.tk>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <58aaccbd483c582b3bfd590c110d45c6@matoro.tk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ljl0i79Ds+rYcDyfSFZeuv20isnIM2I5DSeInWp4ZGX5Lm/4A9t
 YReNYaTCVA9nqInLm5TFDCQ0l/nLQN1+VMDJZ6LxzQo62NKBi2kaJ+seDQfbwxNHK8Qycbr
 6ILxmJLzh0ResJkC8Cy8UR2baBGLSWlnS+sE4UtOg6y3XLc1RRzsDIwybv8jAxoFJpBdHrv
 QVc9CBIR7xwS3hVUfrF1w==
UI-OutboundReport: notjunk:1;M01:P0:poctkaI9GPE=;m7T45jtVfrBiKAm76cbW4OYPWJD
 DnlHSENzFmoiwsqff2cp6ddQzxJmQCj3JeP3sdYTKTeLOi4iAtsN0CHyn5ARJIDP015fwfg8b
 C/R493ubpDccVpffqQUuoBvTPFJ0BbusTzuas8oKbuRWY6WyZ5fOQnUeBBtXpQuFJHlL2rbjg
 UiWc12z0cqoKoNdZ8/aO4RaUqpbMoDSPLyA7O1TiQPKYqUgAyy18YMWfFk31NSLs7dzmnJPZf
 9m+eX6UQ3gXOtbjN6iM6nZIZ+5UosHbeexjVVfN4FP2HWTZg8GQJk7xM+cBtS99ijVNFZj1if
 Ga/hFEsUkIX9XnJHuydM19C6Xmoielg78FqKy6ImT2fzXxGitrGFv6cmOIu7lE+69hcnd/Zbp
 RJ5csF+KZJD1d46OZBngC3Wvq6FyUwNxXYOc0XIXN5kumsqTyuyWpbEgStq9VyHXdDev+U+jw
 nrVoaTFVF++CB8g2vM0xV2UkI3M5gvYooGOgYBe62dU8sKI1b7K2c/ds85FouAehDH6Wyqmzp
 Xg3BvY24ThUJbfFu8YkLqTIPXktnWr+dwZQeVueQ0FYRkgI+sGBo8JXCFqxThUkYzZD135/V4
 Gn1eAp64bF4ncrtq2eqC1kxJCjYmLFKNox2733b3WHkCUazHANvv/ZUem5A4YqwSv/dwJyQkI
 deq6j9XAYIgx34FdovFB1GK0p3cSSJuhg94Pa6NBv8164dkVoSsrXj3ehde99fGkNg3DsYVOh
 +duPv8N0MXFQOdhS6l/HXIUjxJkMahnaOy7s4kdh/aAt+s5EP6sok6shIMddGtZgqHzoA76qG
 lXiA9rB4mg0fi0Wu4ujK0YCD44srVMMpHrS2UT07dHm4slphZJKnVzKmtXNIW38ZpiZ0QltDa
 l6CEyjo+yUpOnPzHLYMG05OT/S/uF5Jc1Nq4ubp8bFeGhCkadNSezdfRSP0sQ4zm/ll1d8Ryl
 0eSqPGo4T6hPUIctGyYApJKqKa4=
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/16/23 20:03, matoro wrote:
> On 2023-07-16 02:54, Helge Deller wrote:
>> * matoro <matoro_mailinglist_kernel@matoro.tk>:
>>> On 2023-07-13 03:27, Helge Deller wrote:
>>> > * matoro <matoro_mailinglist_kernel@matoro.tk>:
>>> > > On 2023-07-12 16:30, Helge Deller wrote:
>>> > > > On 7/12/23 21:05, Helge Deller wrote:
>>> > > > > On 7/12/23 19:28, matoro wrote:
>>> > > > > > On 2023-07-12 12:24, Helge Deller wrote:
>>> > > > > > > Hi Matoro,
>>> > > > > > >
>>> > > > > > > * matoro <matoro_mailinglist_kernel@matoro.tk>:
>>> > > > > > > > On 2023-03-14 13:16, Jens Axboe wrote:
>>> > > > > > > > > From: Helge Deller <deller@gmx.de>
>>> > > > > > > > >
>>> > > > > > > > > Some architectures have memory cache aliasing requirem=
ents (e.g. parisc)
>>> > > > > > > > > if memory is shared between userspace and kernel. This=
 patch fixes the
>>> > > > > > > > > kernel to return an aliased address when asked by user=
space via mmap().
>>> > > > > > > > >
>>> > > > > > > > > Signed-off-by: Helge Deller <deller@gmx.de>
>>> > > > > > > > > Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> > > > > > > > > ---
>>> > > > > > > > >=C2=A0 io_uring/io_uring.c | 51 +++++++++++++++++++++++=
++++++++++++++++++++++
>>> > > > > > > > >=C2=A0 1 file changed, 51 insertions(+)
>>> > > > > > > > >
>>> > > > > > > > > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> > > > > > > > > index 722624b6d0dc..3adecebbac71 100644
>>> > > > > > > > > --- a/io_uring/io_uring.c
>>> > > > > > > > > +++ b/io_uring/io_uring.c
>>> > > > > > > > > @@ -72,6 +72,7 @@
>>> > > > > > > > >=C2=A0 #include <linux/io_uring.h>
>>> > > > > > > > >=C2=A0 #include <linux/audit.h>
>>> > > > > > > > >=C2=A0 #include <linux/security.h>
>>> > > > > > > > > +#include <asm/shmparam.h>
>>> > > > > > > > >
>>> > > > > > > > >=C2=A0 #define CREATE_TRACE_POINTS
>>> > > > > > > > >=C2=A0 #include <trace/events/io_uring.h>
>>> > > > > > > > > @@ -3317,6 +3318,54 @@ static __cold int io_uring_mmap=
(struct file
>>> > > > > > > > > *file, struct vm_area_struct *vma)
>>> > > > > > > > >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return remap_pfn_range(v=
ma, vma->vm_start, pfn, sz,
>>> > > > > > > > > vma->vm_page_prot);
>>> > > > > > > > >=C2=A0 }
>>> > > > > > > > >
>>> > > > > > > > > +static unsigned long io_uring_mmu_get_unmapped_area(s=
truct file *filp,
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 unsigned long addr, unsigned long len,
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 unsigned long pgoff, unsigned long flags)
>>> > > > > > > > > +{
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 const unsigned long mmap_end =3D a=
rch_get_mmap_end(addr, len, flags);
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 struct vm_unmapped_area_info info;
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 void *ptr;
>>> > > > > > > > > +
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 /*
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0 * Do not allow to map to use=
r-provided address to avoid breaking the
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0 * aliasing rules. Userspace =
is not able to guess the offset address
>>> > > > > > > > > of
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0 * kernel kmalloc()ed memory =
area.
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 if (addr)
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EI=
NVAL;
>>> > > > > > > > > +
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 ptr =3D io_uring_validate_mmap_req=
uest(filp, pgoff, len);
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 if (IS_ERR(ptr))
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EN=
OMEM;
>>> > > > > > > > > +
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 info.flags =3D VM_UNMAPPED_AREA_TO=
PDOWN;
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 info.length =3D len;
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 info.low_limit =3D max(PAGE_SIZE, =
mmap_min_addr);
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 info.high_limit =3D arch_get_mmap_=
base(addr, current->mm->mmap_base);
>>> > > > > > > > > +#ifdef SHM_COLOUR
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 info.align_mask =3D PAGE_MASK & (S=
HM_COLOUR - 1UL);
>>> > > > > > > > > +#else
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 info.align_mask =3D PAGE_MASK & (S=
HMLBA - 1UL);
>>> > > > > > > > > +#endif
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 info.align_offset =3D (unsigned lo=
ng) ptr;
>>> > > > > > > > > +
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 /*
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0 * A failed mmap() very likel=
y causes application failure,
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0 * so fall back to the bottom=
-up function here. This scenario
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0 * can happen with large stac=
k limits and large mmap()
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0 * allocations.
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_area(&info);
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 if (offset_in_page(addr)) {
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.flags=
 =3D 0;
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.low_l=
imit =3D TASK_UNMAPPED_BASE;
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.high_=
limit =3D mmap_end;
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 addr =3D v=
m_unmapped_area(&info);
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 }
>>> > > > > > > > > +
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 return addr;
>>> > > > > > > > > +}
>>> > > > > > > > > +
>>> > > > > > > > >=C2=A0 #else /* !CONFIG_MMU */
>>> > > > > > > > >
>>> > > > > > > > >=C2=A0 static int io_uring_mmap(struct file *file, stru=
ct vm_area_struct *vma)
>>> > > > > > > > > @@ -3529,6 +3578,8 @@ static const struct file_operati=
ons io_uring_fops
>>> > > > > > > > > =3D {
>>> > > > > > > > >=C2=A0 #ifndef CONFIG_MMU
>>> > > > > > > > >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .get_unmapped_area =3D i=
o_uring_nommu_get_unmapped_area,
>>> > > > > > > > >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .mmap_capabilities =3D i=
o_uring_nommu_mmap_capabilities,
>>> > > > > > > > > +#else
>>> > > > > > > > > +=C2=A0=C2=A0=C2=A0 .get_unmapped_area =3D io_uring_mm=
u_get_unmapped_area,
>>> > > > > > > > >=C2=A0 #endif
>>> > > > > > > > >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .poll=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 =3D io_uring_poll,
>>> > > > > > > > >=C2=A0 #ifdef CONFIG_PROC_FS
>>> > > > > > > >
>>> > > > > > > > Hi Jens, Helge - I've bisected a regression with
>>> > > > > > > > io_uring on ia64 to this
>>> > > > > > > > patch in 6.4.=C2=A0 Unfortunately this breaks userspace
>>> > > > > > > > programs using io_uring,
>>> > > > > > > > the easiest one to test is cmake with an io_uring
>>> > > > > > > > enabled libuv (i.e., libuv
>>> > > > > > > > >=3D 1.45.0) which will hang.
>>> > > > > > > >
>>> > > > > > > > I am aware that ia64 is in a vulnerable place right now
>>> > > > > > > > which I why I am
>>> > > > > > > > keeping this spread limited.=C2=A0 Since this clearly in=
volves
>>> > > > > > > > architecture-specific changes for parisc,
>>> > > > > > >
>>> > > > > > > it isn't so much architecture-specific... (just one ifdef)
>>> > > > > > >
>>> > > > > > > > is there any chance of looking at
>>> > > > > > > > what is required to do the same for ia64?=C2=A0 I looked=
 at
>>> > > > > > > > 0ef36bd2b37815719e31a72d2beecc28ca8ecd26 ("parisc:
>>> > > > > > > > change value of SHMLBA
>>> > > > > > > > from 0x00400000 to PAGE_SIZE") and tried to replicate th=
e SHMLBA ->
>>> > > > > > > > SHM_COLOUR change, but it made no difference.
>>> > > > > > > >
>>> > > > > > > > If hardware is necessary for testing, I can provide it,
>>> > > > > > > > including remote BMC
>>> > > > > > > > access for restarts/kernel debugging.=C2=A0 Any takers?
>>> > > > > > >
>>> > > > > > > I won't have time to test myself, but maybe you could test=
?
>>> > > > > > >
>>> > > > > > > Basically we should try to find out why
>>> > > > > > > io_uring_mmu_get_unmapped_area()
>>> > > > > > > doesn't return valid addresses, while arch_get_unmapped_ar=
ea()
>>> > > > > > > [in arch/ia64/kernel/sys_ia64.c] does.
>>> > > > > > >
>>> > > > > > > You could apply this patch first:
>>> > > > > > > It introduces a memory leak (as it requests memory twice),
>>> > > > > > > but maybe we
>>> > > > > > > get an idea?
>>> > > > > > > The ia64 arch_get_unmapped_area() searches for memory from=
 bottom
>>> > > > > > > (flags=3D0), while io_uring function tries top-down first.
>>> > > > > > > Maybe that's
>>> > > > > > > the problem. And I don't understand the offset_in_page() c=
heck right
>>> > > > > > > now.
>>> > > > > > >
>>> > > > > > > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> > > > > > > index 3bca7a79efda..93b1964d2bbb 100644
>>> > > > > > > --- a/io_uring/io_uring.c
>>> > > > > > > +++ b/io_uring/io_uring.c
>>> > > > > > > @@ -3431,13 +3431,17 @@ static unsigned long
>>> > > > > > > io_uring_mmu_get_unmapped_area(struct file *filp,
>>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * can happen with large sta=
ck limits and large mmap()
>>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * allocations.
>>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> > > > > > > +/* compare to arch_get_unmapped_area() in
>>> > > > > > > arch/ia64/kernel/sys_ia64.c */
>>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_area(&info);
>>> > > > > > > -=C2=A0=C2=A0=C2=A0 if (offset_in_page(addr)) {
>>> > > > > > > +printk("io_uring_mmu_get_unmapped_area() address 1 is:
>>> > > > > > > %px\n", addr);
>>> > > > > > > +=C2=A0=C2=A0=C2=A0 addr =3D NULL;
>>> > > > > > > +=C2=A0=C2=A0=C2=A0 if (!addr) {
>>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.flag=
s =3D 0;
>>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.low_=
limit =3D TASK_UNMAPPED_BASE;
>>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.high=
_limit =3D mmap_end;
>>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 addr =3D =
vm_unmapped_area(&info);
>>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0 }
>>> > > > > > > +printk("io_uring_mmu_get_unmapped_area() returns address
>>> > > > > > > %px\n", addr);
>>> > > > > > >
>>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0 return addr;
>>> > > > > > > =C2=A0}
>>> > > > > > >
>>> > > > > > >
>>> > > > > > > Another option is to disable the call to
>>> > > > > > > io_uring_nommu_get_unmapped_area())
>>> > > > > > > with the next patch. Maybe you could add printks() to ia64=
's
>>> > > > > > > arch_get_unmapped_area()
>>> > > > > > > and check what it returns there?
>>> > > > > > >
>>> > > > > > > @@ -3654,6 +3658,8 @@ static const struct file_operations
>>> > > > > > > io_uring_fops =3D {
>>> > > > > > > =C2=A0#ifndef CONFIG_MMU
>>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0 .get_unmapped_area =3D io_uring_n=
ommu_get_unmapped_area,
>>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0 .mmap_capabilities =3D io_uring_n=
ommu_mmap_capabilities,
>>> > > > > > > +#elif 0=C2=A0=C2=A0=C2=A0 /* IS_ENABLED(CONFIG_IA64) */
>>> > > > > > > +=C2=A0=C2=A0=C2=A0 .get_unmapped_area =3D NULL,
>>> > > > > > > =C2=A0#else
>>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0 .get_unmapped_area =3D io_uring_m=
mu_get_unmapped_area,
>>> > > > > > > =C2=A0#endif
>>> > > > > > >
>>> > > > > > > Helge
>>> > > > > >
>>> > > > > > Thanks Helge.=C2=A0 Sample output from that first patch:
>>> > > > > >
>>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>>> > > > > > address 1 is: 1ffffffffff40000
>>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>>> > > > > > returns address 2000000001e40000
>>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>>> > > > > > address 1 is: 1ffffffffff20000
>>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>>> > > > > > returns address 2000000001f20000
>>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>>> > > > > > address 1 is: 1ffffffffff30000
>>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>>> > > > > > returns address 2000000001f30000
>>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>>> > > > > > address 1 is: 1ffffffffff90000
>>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>>> > > > > > returns address 2000000001f90000
>>> > > > > >
>>> > > > > > This pattern seems to be pretty stable, I tried instead just
>>> > > > > > directly returning the result of a call to
>>> > > > > > arch_get_unmapped_area() at the end of the function and it s=
eems
>>> > > > > > similar:
>>> > > > > >
>>> > > > > > [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area()
>>> > > > > > would return address 1ffffffffffd0000
>>> > > > > > [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() woul=
d
>>> > > > > > return address 2000000001f00000
>>> > > > > > [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area()
>>> > > > > > would return address 1ffffffffff00000
>>> > > > > > [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() woul=
d
>>> > > > > > return address 1ffffffffff00000
>>> > > > > > [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area()
>>> > > > > > would return address 1fffffffffe20000
>>> > > > > > [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() woul=
d
>>> > > > > > return address 2000000002000000
>>> > > > > > [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area()
>>> > > > > > would return address 1fffffffffe30000
>>> > > > > > [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() woul=
d
>>> > > > > > return address 2000000002100000
>>> > > > > >
>>> > > > > > Is that enough of a clue to go on?
>>> > > > >
>>> > > > > SHMLBA on ia64 is 0x100000:
>>> > > > > arch/ia64/include/asm/shmparam.h:#define=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 SHMLBA=C2=A0 (1024*1024)
>>> > > > > but the values returned by io_uring_mmu_get_unmapped_area() do=
es not
>>> > > > > fullfill this.
>>> > > > >
>>> > > > > So, probably ia64's SHMLBA isn't pulled in correctly in
>>> > > > > io_uring/io_uring.c.
>>> > > > > Check value of this line:
>>> > > > >=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0info.align_mask =3D PAGE_MASK & =
(SHMLBA - 1UL);
>>> > > > >
>>> > > > > You could also add
>>> > > > > #define SHM_COLOUR=C2=A0 0x100000
>>> > > > > in front of the
>>> > > > >=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0#ifdef SHM_COLOUR
>>> > > > > (define SHM_COLOUR in io_uring/kbuf.c too).
>>> > > >
>>> > > > What is the value of PAGE_SIZE and "ptr" on your machine?
>>> > > > For 4k page size I get:
>>> > > > SHMLBA -1=C2=A0=C2=A0 ->=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 FFFFF
>>> > > > PAGE_MASK=C2=A0=C2=A0 -> FFFFFFFFF000
>>> > > > so,
>>> > > > info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL) =3D 0xFF000;
>>> > > > You could try to set nfo.align_mask =3D 0xfffff;
>>> > > >
>>> > > > Helge
>>> > >
>>> > > Using 64KiB (65536) PAGE_SIZE here.=C2=A0 64-bit pointers.
>>> > >
>>> > > Tried both #define SHM_COLOUR 0x100000, as well and info.align_mas=
k =3D
>>> > > 0xFFFFF, but both of them made the problem change from 100%
>>> > > reproducible, to
>>> > > intermittent.
>>> > >
>>> > > After inspecting the ouput I observed that it hangs only when the
>>> > > first
>>> > > allocation returns an address below 0x2000000000000000, and the se=
cond
>>> > > returns an address above it.=C2=A0 When both addresses are above i=
t, it
>>> > > does not
>>> > > hang.=C2=A0 Examples:
>>> > >
>>> > > When it works:
>>> > > $ cmake --version
>>> > > cmake version 3.26.4
>>> > >
>>> > > CMake suite maintained and supported by Kitware (kitware.com/cmake=
).
>>> > > $ dmesg --color=3Dalways -T | tail -n 4
>>> > > [Wed Jul 12 20:32:37 2023] io_uring_mmu_get_unmapped_area() would
>>> > > return
>>> > > address 1fffffffffe20000
>>> > > [Wed Jul 12 20:32:37 2023] but arch_get_unmapped_area() would retu=
rn
>>> > > address
>>> > > 2000000002000000
>>> > > [Wed Jul 12 20:32:37 2023] io_uring_mmu_get_unmapped_area() would
>>> > > return
>>> > > address 1fffffffffe50000
>>> > > [Wed Jul 12 20:32:37 2023] but arch_get_unmapped_area() would retu=
rn
>>> > > address
>>> > > 2000000002100000
>>> > >
>>> > >
>>> > > When it hangs:
>>> > > $ cmake --version
>>> > > cmake version 3.26.4
>>> > >
>>> > > CMake suite maintained and supported by Kitware (kitware.com/cmake=
).
>>> > > ^C
>>> > > $ dmesg --color=3Dalways -T | tail -n 4
>>> > > [Wed Jul 12 20:33:12 2023] io_uring_mmu_get_unmapped_area() would
>>> > > return
>>> > > address 1ffffffffff00000
>>> > > [Wed Jul 12 20:33:12 2023] but arch_get_unmapped_area() would retu=
rn
>>> > > address
>>> > > 1ffffffffff00000
>>> > > [Wed Jul 12 20:33:12 2023] io_uring_mmu_get_unmapped_area() would
>>> > > return
>>> > > address 1fffffffffe60000
>>> > > [Wed Jul 12 20:33:12 2023] but arch_get_unmapped_area() would retu=
rn
>>> > > address
>>> > > 2000000001f00000
>>> > >
>>> > > Is io_uring_mmu_get_unmapped_area supported to always return
>>> > > addresses above
>>> > > 0x2000000000000000?
>>> >
>>> > Yes, with the patch below.
>>> >
>>> > > Any reason why it is not doing so sometimes?
>>> >
>>> > It depends on the parameters for vm_unmapped_area(). Specifically
>>> > info.flags=3D0.
>>> >
>>> > Try this patch:
>>> >
>>> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> > index 3bca7a79efda..b259794ab53b 100644
>>> > --- a/io_uring/io_uring.c
>>> > +++ b/io_uring/io_uring.c
>>> > @@ -3429,10 +3429,13 @@ static unsigned long
>>> > io_uring_mmu_get_unmapped_area(struct file *filp,
>>> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * A failed mmap() very likely ca=
uses application failure,
>>> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * so fall back to the bottom-up =
function here. This scenario
>>> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * can happen with large stack li=
mits and large mmap()
>>> > -=C2=A0=C2=A0=C2=A0=C2=A0 * allocations.
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0 * allocations. Use bottom-up on IA64 for c=
orrect aliasing.
>>> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> > -=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_area(&info);
>>> > -=C2=A0=C2=A0=C2=A0 if (offset_in_page(addr)) {
>>> > +=C2=A0=C2=A0=C2=A0 if (IS_ENABLED(CONFIG_IA64))
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 addr =3D NULL;
>>> > +=C2=A0=C2=A0=C2=A0 else
>>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_are=
a(&info);
>>> > +=C2=A0=C2=A0=C2=A0 if (!addr) {
>>> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.flags =3D=
 0;
>>> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.low_limit=
 =3D TASK_UNMAPPED_BASE;
>>> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.high_limi=
t =3D mmap_end;
>>> >
>>> > Helge
>>>
>>> This patch does do the trick, but I am a little unsure if it's the rig=
ht one
>>> to go in:
>>>
>>> * Adding an arch-specific conditional feels like a bad hack, why is it=
 not
>>> working with the other vm_unmapped_area_info settings?
>>
>> because it tries to map below TASK_UNMAPPED_BASE, for which (I assume) =
IA-64
>> has different aliasing/caching rules. There are some comments in the ar=
ch/ia64
>> files, but I'm not a IA-64 expert...
>>
>>> * What happened to the offset_in_page check for other arches?
>>
>> I thought it's not necessary.
>>
>> But below is another (and much better) approach, which you may test.
>> I see quite some errors with the liburing testcases on hppa, but I thin=
k
>> they are not related to this function.
>>
>> Can you test and report back?
>>
>> Helge
>>
>>
>> From 457f2c2db984bc159119bfb4426d9dc6c2779ed6 Mon Sep 17 00:00:00 2001
>> From: Helge Deller <deller@gmx.de>
>> Date: Sun, 16 Jul 2023 08:45:17 +0200
>> Subject: [PATCH] io_uring: Adjust mapping wrt architecture aliasing
>> =C2=A0requirements
>>
>> When mapping memory to userspace use the architecture-provided
>> get_unmapped_area() function instead of the own copy which fails on
>> IA-64 since it doesn't allow mappings below TASK_UNMAPPED_BASE.
>>
>> Additionally make sure to flag the requested memory as MAP_SHARED so
>> that any architecture-specific aliasing rules will be applied.
>>
>> Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
>> Signed-off-by: Helge Deller <deller@gmx.de>
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 3bca7a79efda..2e7dd93e45d0 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -3398,48 +3398,27 @@ static unsigned long io_uring_mmu_get_unmapped_=
area(struct file *filp,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 unsigned long addr, unsigned long len,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 unsigned long pgoff, unsigned long flags)
>> =C2=A0{
>> -=C2=A0=C2=A0=C2=A0 const unsigned long mmap_end =3D arch_get_mmap_end(=
addr, len, flags);
>> -=C2=A0=C2=A0=C2=A0 struct vm_unmapped_area_info info;
>> =C2=A0=C2=A0=C2=A0=C2=A0 void *ptr;
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 /*
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Do not allow to map to user-provided a=
ddress to avoid breaking the
>> -=C2=A0=C2=A0=C2=A0=C2=A0 * aliasing rules. Userspace is not able to gu=
ess the offset address of
>> -=C2=A0=C2=A0=C2=A0=C2=A0 * kernel kmalloc()ed memory area.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * aliasing rules of various architectures. Us=
erspace is not able to
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * guess the offset address of kernel kmalloc(=
)ed memory area.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> -=C2=A0=C2=A0=C2=A0 if (addr)
>> +=C2=A0=C2=A0=C2=A0 if (addr | (flags & MAP_FIXED))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * The requested memory region is required to =
be shared between kernel
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * and userspace application.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 flags |=3D MAP_SHARED;
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0 ptr =3D io_uring_validate_mmap_request(filp, p=
goff, len);
>> =C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(ptr))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>
>> -=C2=A0=C2=A0=C2=A0 info.flags =3D VM_UNMAPPED_AREA_TOPDOWN;
>> -=C2=A0=C2=A0=C2=A0 info.length =3D len;
>> -=C2=A0=C2=A0=C2=A0 info.low_limit =3D max(PAGE_SIZE, mmap_min_addr);
>> -=C2=A0=C2=A0=C2=A0 info.high_limit =3D arch_get_mmap_base(addr, curren=
t->mm->mmap_base);
>> -#ifdef SHM_COLOUR
>> -=C2=A0=C2=A0=C2=A0 info.align_mask =3D PAGE_MASK & (SHM_COLOUR - 1UL);
>> -#else
>> -=C2=A0=C2=A0=C2=A0 info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL);
>> -#endif
>> -=C2=A0=C2=A0=C2=A0 info.align_offset =3D (unsigned long) ptr;
>> -
>> -=C2=A0=C2=A0=C2=A0 /*
>> -=C2=A0=C2=A0=C2=A0=C2=A0 * A failed mmap() very likely causes applicat=
ion failure,
>> -=C2=A0=C2=A0=C2=A0=C2=A0 * so fall back to the bottom-up function here=
. This scenario
>> -=C2=A0=C2=A0=C2=A0=C2=A0 * can happen with large stack limits and larg=
e mmap()
>> -=C2=A0=C2=A0=C2=A0=C2=A0 * allocations.
>> -=C2=A0=C2=A0=C2=A0=C2=A0 */
>> -=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_area(&info);
>> -=C2=A0=C2=A0=C2=A0 if (offset_in_page(addr)) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.flags =3D 0;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.low_limit =3D TASK_UNM=
APPED_BASE;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.high_limit =3D mmap_en=
d;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 addr =3D vm_unmapped_area(&=
info);
>> -=C2=A0=C2=A0=C2=A0 }
>> -
>> -=C2=A0=C2=A0=C2=A0 return addr;
>> +=C2=A0=C2=A0=C2=A0 return current->mm->get_unmapped_area(filp, addr, l=
en, pgoff, flags);
>> =C2=A0}
>>
>> =C2=A0#else /* !CONFIG_MMU */
>
> This seems really close.=C2=A0 It worked for the trivial test case, so I=
 ran the test suite from https://github.com/axboe/liburing to compare.=C2=
=A0 With kernel 6.3, I get 100% pass, after I get one failure:
> Running test read-write.t cqe->res=3D33, expected=3D32
> test_rem_buf_single(BUFFERS + 1) failed
> Not root, skipping test_write_efbig
> Test read-write.t failed with ret 1
>
> Trying this patch out on other arches to see if it also affects them or =
is ia64-specific.

I'm sorry, but this patch does break parisc heavily...

I'll need to think more...

Helge



