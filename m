Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0EB754D89
	for <lists+io-uring@lfdr.de>; Sun, 16 Jul 2023 08:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjGPGzT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Jul 2023 02:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjGPGzS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Jul 2023 02:55:18 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609BB189;
        Sat, 15 Jul 2023 23:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1689490482; x=1690095282; i=deller@gmx.de;
 bh=8P/J6Nmb8NHZ0IHKBT+p5ZNKlFbfYh9lmGNDwZ5ZYvA=;
 h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
 b=Bqt7N3C6haVV99CNjrV8rLxcacWZtzK1/hhXBdAvxYiMjmJrGFCH7wh9xJrzhmgnxztycpM
 RrfQiBsvWzCUuAQWL6KC5v2M0DGFn8kTnY/X8R32W9kmB7CZOLS7pKIYxV3wbYcgfyZcyIaWe
 QWGwbIwD6vk0oyz4FxCnOKejLijsFHmOmHUa+F/62fUjiGNxsygZ5Yk0orkGJxHIUMdHxgdxF
 Ey6BH7XMubQyefBsgrU2Ktjlq6g0UrrnltZnVFDfVVFXX46F1koEW8qeSVx50w5UGGLQUi9ck
 OeED8ZFP7GKOEZTcvJsSwz3WneDIrrjqm41aWh82+m/rgFilZl/Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100 ([94.134.154.206]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MysVs-1pyIUa1GuA-00vwaI; Sun, 16
 Jul 2023 08:54:42 +0200
Date:   Sun, 16 Jul 2023 08:54:39 +0200
From:   Helge Deller <deller@gmx.de>
To:     matoro <matoro_mailinglist_kernel@matoro.tk>
Cc:     Helge Deller <deller@gmx.de>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, Linux Ia64 <linux-ia64@vger.kernel.org>,
        glaubitz@physik.fu-berlin.de, Sam James <sam@gentoo.org>
Subject: Re: [PATCH 1/5] io_uring: Adjust mapping wrt architecture aliasing
 requirements
Message-ID: <ZLOUL+5PxCHW/uc5@p100>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <20230314171641.10542-2-axboe@kernel.dk>
 <1d5f8f99f39e2769b9c76fbc24e2cf50@matoro.tk>
 <ZK7TrdVXc0O6HMpQ@ls3530>
 <f1bed3cc3c43083cfd86768a91402f6b@matoro.tk>
 <a3ae1656-be97-ccc2-8962-1cb70ebc67fa@gmx.de>
 <802b84f7-94f4-638b-3742-26bca00b262d@gmx.de>
 <8bb091fb5fd00072842fe92b03abac9b@matoro.tk>
 <ZK+nYIxe6zf2vYwH@ls3530>
 <695fbf1a4f48619de63297b21aa9f6c4@matoro.tk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <695fbf1a4f48619de63297b21aa9f6c4@matoro.tk>
X-Provags-ID: V03:K1:4SCU7YJKR6led+hMZz7vwVSJTR2p37pFonK2bYzuP4JvHBn9MaZ
 cuYp2nHfpVyjjRuDePMnIG/33nuqoMFo4pz2PybYqaZc9zUvko9UP0iLkGjDAM4sExyOFcV
 67X+mn0Q08eJ6sU+lLURNo55SRVu6sHrMFqTD9pLBeL1MlP2o/HerOKv3ZNwSZkR85CwQGr
 zaRCYcicZBSnrA8ekTNiw==
UI-OutboundReport: notjunk:1;M01:P0:RtZ+aw5/bvM=;wD2/UHFRtp/TOUG2e8/0doEnguz
 i4igJJh8P8/9j6EzPYBKk4RxxzYl0ABV752V1JnxTn3C3OGcmftT3qM3t3ldzTIU+XNKelV44
 YCROrJRgqzF78+Ic3xEhVzmxCfVdbhbntuigzSlSHrvxI0cEVxVOQuDYA0m7aGS3aMQtISioq
 pnAGXxpoPF3VqRPiPmxXEtkZi1aI1QObargC4QlfV5v49FoxED0gGSRL1mqbF36PyuYgoKbz2
 JQwOaNaDSyC8/lI77Bq/+XAYBsiJ4XzF18Ory27wNTC4TW97kjbz/my7VjKgl7ZmZUtBZtnIR
 BidrpEk0ibQh8noNkR8ZHWJJh8Gvx00Fk/tMhTmyrEXFYG/SqJY0H5XkHLraSx1wqQRrfDm9P
 4v1epVZAOM5jI09mqwsurSPLkf4noC5vZMaEvvtSRC4nouYH7fMQ0VHDLsdN/byIyXEro32jp
 Io2tzVdXodeeplToJTUybHMsVy5Ci0zjVG8QtkDvFFCDMJVSar3fFl2ifdAznTHyH7Ag+yKfr
 k7JX8YomHHjEarJtSm6CIIc9+fYPkhherkN39Zsj75CVT+KY3Hfcw2sc5AwYyqmDkrx8kIBr4
 XIDinRcKyutCd4fFb9Lpjxu70wlEKK3EYBskQCRQFwzq25d/649MGMpbmDMTxaGX6c4tkDKy+
 G92TcBTn+w4L7VQTUjO4JULOAZQPYAPLxMgDSiA2AfIVlw7LQyUBAt1tLPHQ0mL41DHo9dmHw
 btILirT9Apz9G1plTQyOF5AuNVQiLiR73+jmTNZpSEwtqHi5rAfx/eS0EQqzQID/5ak4c6kCV
 vml2F+85uQYYu2LtITRv76AHNlhWrXEdfk/LnVt4a7oLbzqwYPaSpeSz08Y6i/Y4+a9J/KFRp
 puI0y7cgDsv9VCMJ23Cw9Y4EQz06ehSu3Yf74p/XWTzE/mkzsiN9X80qSAS/BIFOZfReqfxh6
 036J7BGpX5hpjptK5V01z66dzus=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

* matoro <matoro_mailinglist_kernel@matoro.tk>:
> On 2023-07-13 03:27, Helge Deller wrote:
> > * matoro <matoro_mailinglist_kernel@matoro.tk>:
> > > On 2023-07-12 16:30, Helge Deller wrote:
> > > > On 7/12/23 21:05, Helge Deller wrote:
> > > > > On 7/12/23 19:28, matoro wrote:
> > > > > > On 2023-07-12 12:24, Helge Deller wrote:
> > > > > > > Hi Matoro,
> > > > > > >
> > > > > > > * matoro <matoro_mailinglist_kernel@matoro.tk>:
> > > > > > > > On 2023-03-14 13:16, Jens Axboe wrote:
> > > > > > > > > From: Helge Deller <deller@gmx.de>
> > > > > > > > >
> > > > > > > > > Some architectures have memory cache aliasing requiremen=
ts (e.g. parisc)
> > > > > > > > > if memory is shared between userspace and kernel. This p=
atch fixes the
> > > > > > > > > kernel to return an aliased address when asked by usersp=
ace via mmap().
> > > > > > > > >
> > > > > > > > > Signed-off-by: Helge Deller <deller@gmx.de>
> > > > > > > > > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > > > > > > > > ---
> > > > > > > > >=A0 io_uring/io_uring.c | 51 ++++++++++++++++++++++++++++=
+++++++++++++++++
> > > > > > > > >=A0 1 file changed, 51 insertions(+)
> > > > > > > > >
> > > > > > > > > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > > > > > > > > index 722624b6d0dc..3adecebbac71 100644
> > > > > > > > > --- a/io_uring/io_uring.c
> > > > > > > > > +++ b/io_uring/io_uring.c
> > > > > > > > > @@ -72,6 +72,7 @@
> > > > > > > > >=A0 #include <linux/io_uring.h>
> > > > > > > > >=A0 #include <linux/audit.h>
> > > > > > > > >=A0 #include <linux/security.h>
> > > > > > > > > +#include <asm/shmparam.h>
> > > > > > > > >
> > > > > > > > >=A0 #define CREATE_TRACE_POINTS
> > > > > > > > >=A0 #include <trace/events/io_uring.h>
> > > > > > > > > @@ -3317,6 +3318,54 @@ static __cold int io_uring_mmap(s=
truct file
> > > > > > > > > *file, struct vm_area_struct *vma)
> > > > > > > > >=A0=A0=A0=A0=A0 return remap_pfn_range(vma, vma->vm_start=
, pfn, sz,
> > > > > > > > > vma->vm_page_prot);
> > > > > > > > >=A0 }
> > > > > > > > >
> > > > > > > > > +static unsigned long io_uring_mmu_get_unmapped_area(str=
uct file *filp,
> > > > > > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned long addr, u=
nsigned long len,
> > > > > > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned long pgoff, =
unsigned long flags)
> > > > > > > > > +{
> > > > > > > > > +=A0=A0=A0 const unsigned long mmap_end =3D arch_get_mma=
p_end(addr, len, flags);
> > > > > > > > > +=A0=A0=A0 struct vm_unmapped_area_info info;
> > > > > > > > > +=A0=A0=A0 void *ptr;
> > > > > > > > > +
> > > > > > > > > +=A0=A0=A0 /*
> > > > > > > > > +=A0=A0=A0=A0 * Do not allow to map to user-provided add=
ress to avoid breaking the
> > > > > > > > > +=A0=A0=A0=A0 * aliasing rules. Userspace is not able to=
 guess the offset address
> > > > > > > > > of
> > > > > > > > > +=A0=A0=A0=A0 * kernel kmalloc()ed memory area.
> > > > > > > > > +=A0=A0=A0=A0 */
> > > > > > > > > +=A0=A0=A0 if (addr)
> > > > > > > > > +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
> > > > > > > > > +
> > > > > > > > > +=A0=A0=A0 ptr =3D io_uring_validate_mmap_request(filp, =
pgoff, len);
> > > > > > > > > +=A0=A0=A0 if (IS_ERR(ptr))
> > > > > > > > > +=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;
> > > > > > > > > +
> > > > > > > > > +=A0=A0=A0 info.flags =3D VM_UNMAPPED_AREA_TOPDOWN;
> > > > > > > > > +=A0=A0=A0 info.length =3D len;
> > > > > > > > > +=A0=A0=A0 info.low_limit =3D max(PAGE_SIZE, mmap_min_ad=
dr);
> > > > > > > > > +=A0=A0=A0 info.high_limit =3D arch_get_mmap_base(addr, =
current->mm->mmap_base);
> > > > > > > > > +#ifdef SHM_COLOUR
> > > > > > > > > +=A0=A0=A0 info.align_mask =3D PAGE_MASK & (SHM_COLOUR -=
 1UL);
> > > > > > > > > +#else
> > > > > > > > > +=A0=A0=A0 info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL=
);
> > > > > > > > > +#endif
> > > > > > > > > +=A0=A0=A0 info.align_offset =3D (unsigned long) ptr;
> > > > > > > > > +
> > > > > > > > > +=A0=A0=A0 /*
> > > > > > > > > +=A0=A0=A0=A0 * A failed mmap() very likely causes appli=
cation failure,
> > > > > > > > > +=A0=A0=A0=A0 * so fall back to the bottom-up function h=
ere. This scenario
> > > > > > > > > +=A0=A0=A0=A0 * can happen with large stack limits and l=
arge mmap()
> > > > > > > > > +=A0=A0=A0=A0 * allocations.
> > > > > > > > > +=A0=A0=A0=A0 */
> > > > > > > > > +=A0=A0=A0 addr =3D vm_unmapped_area(&info);
> > > > > > > > > +=A0=A0=A0 if (offset_in_page(addr)) {
> > > > > > > > > +=A0=A0=A0=A0=A0=A0=A0 info.flags =3D 0;
> > > > > > > > > +=A0=A0=A0=A0=A0=A0=A0 info.low_limit =3D TASK_UNMAPPED_=
BASE;
> > > > > > > > > +=A0=A0=A0=A0=A0=A0=A0 info.high_limit =3D mmap_end;
> > > > > > > > > +=A0=A0=A0=A0=A0=A0=A0 addr =3D vm_unmapped_area(&info);
> > > > > > > > > +=A0=A0=A0 }
> > > > > > > > > +
> > > > > > > > > +=A0=A0=A0 return addr;
> > > > > > > > > +}
> > > > > > > > > +
> > > > > > > > >=A0 #else /* !CONFIG_MMU */
> > > > > > > > >
> > > > > > > > >=A0 static int io_uring_mmap(struct file *file, struct vm=
_area_struct *vma)
> > > > > > > > > @@ -3529,6 +3578,8 @@ static const struct file_operation=
s io_uring_fops
> > > > > > > > > =3D {
> > > > > > > > >=A0 #ifndef CONFIG_MMU
> > > > > > > > >=A0=A0=A0=A0=A0 .get_unmapped_area =3D io_uring_nommu_get=
_unmapped_area,
> > > > > > > > >=A0=A0=A0=A0=A0 .mmap_capabilities =3D io_uring_nommu_mma=
p_capabilities,
> > > > > > > > > +#else
> > > > > > > > > +=A0=A0=A0 .get_unmapped_area =3D io_uring_mmu_get_unmap=
ped_area,
> > > > > > > > >=A0 #endif
> > > > > > > > >=A0=A0=A0=A0=A0 .poll=A0=A0=A0=A0=A0=A0=A0 =3D io_uring_p=
oll,
> > > > > > > > >=A0 #ifdef CONFIG_PROC_FS
> > > > > > > >
> > > > > > > > Hi Jens, Helge - I've bisected a regression with
> > > > > > > > io_uring on ia64 to this
> > > > > > > > patch in 6.4.=A0 Unfortunately this breaks userspace
> > > > > > > > programs using io_uring,
> > > > > > > > the easiest one to test is cmake with an io_uring
> > > > > > > > enabled libuv (i.e., libuv
> > > > > > > > >=3D 1.45.0) which will hang.
> > > > > > > >
> > > > > > > > I am aware that ia64 is in a vulnerable place right now
> > > > > > > > which I why I am
> > > > > > > > keeping this spread limited.=A0 Since this clearly involve=
s
> > > > > > > > architecture-specific changes for parisc,
> > > > > > >
> > > > > > > it isn't so much architecture-specific... (just one ifdef)
> > > > > > >
> > > > > > > > is there any chance of looking at
> > > > > > > > what is required to do the same for ia64?=A0 I looked at
> > > > > > > > 0ef36bd2b37815719e31a72d2beecc28ca8ecd26 ("parisc:
> > > > > > > > change value of SHMLBA
> > > > > > > > from 0x00400000 to PAGE_SIZE") and tried to replicate the =
SHMLBA ->
> > > > > > > > SHM_COLOUR change, but it made no difference.
> > > > > > > >
> > > > > > > > If hardware is necessary for testing, I can provide it,
> > > > > > > > including remote BMC
> > > > > > > > access for restarts/kernel debugging.=A0 Any takers?
> > > > > > >
> > > > > > > I won't have time to test myself, but maybe you could test?
> > > > > > >
> > > > > > > Basically we should try to find out why
> > > > > > > io_uring_mmu_get_unmapped_area()
> > > > > > > doesn't return valid addresses, while arch_get_unmapped_area=
()
> > > > > > > [in arch/ia64/kernel/sys_ia64.c] does.
> > > > > > >
> > > > > > > You could apply this patch first:
> > > > > > > It introduces a memory leak (as it requests memory twice),
> > > > > > > but maybe we
> > > > > > > get an idea?
> > > > > > > The ia64 arch_get_unmapped_area() searches for memory from b=
ottom
> > > > > > > (flags=3D0), while io_uring function tries top-down first.
> > > > > > > Maybe that's
> > > > > > > the problem. And I don't understand the offset_in_page() che=
ck right
> > > > > > > now.
> > > > > > >
> > > > > > > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > > > > > > index 3bca7a79efda..93b1964d2bbb 100644
> > > > > > > --- a/io_uring/io_uring.c
> > > > > > > +++ b/io_uring/io_uring.c
> > > > > > > @@ -3431,13 +3431,17 @@ static unsigned long
> > > > > > > io_uring_mmu_get_unmapped_area(struct file *filp,
> > > > > > > =A0=A0=A0=A0=A0 * can happen with large stack limits and lar=
ge mmap()
> > > > > > > =A0=A0=A0=A0=A0 * allocations.
> > > > > > > =A0=A0=A0=A0=A0 */
> > > > > > > +/* compare to arch_get_unmapped_area() in
> > > > > > > arch/ia64/kernel/sys_ia64.c */
> > > > > > > =A0=A0=A0=A0 addr =3D vm_unmapped_area(&info);
> > > > > > > -=A0=A0=A0 if (offset_in_page(addr)) {
> > > > > > > +printk("io_uring_mmu_get_unmapped_area() address 1 is:
> > > > > > > %px\n", addr);
> > > > > > > +=A0=A0=A0 addr =3D NULL;
> > > > > > > +=A0=A0=A0 if (!addr) {
> > > > > > > =A0=A0=A0=A0=A0=A0=A0=A0 info.flags =3D 0;
> > > > > > > =A0=A0=A0=A0=A0=A0=A0=A0 info.low_limit =3D TASK_UNMAPPED_BA=
SE;
> > > > > > > =A0=A0=A0=A0=A0=A0=A0=A0 info.high_limit =3D mmap_end;
> > > > > > > =A0=A0=A0=A0=A0=A0=A0=A0 addr =3D vm_unmapped_area(&info);
> > > > > > > =A0=A0=A0=A0 }
> > > > > > > +printk("io_uring_mmu_get_unmapped_area() returns address
> > > > > > > %px\n", addr);
> > > > > > >
> > > > > > > =A0=A0=A0=A0 return addr;
> > > > > > > =A0}
> > > > > > >
> > > > > > >
> > > > > > > Another option is to disable the call to
> > > > > > > io_uring_nommu_get_unmapped_area())
> > > > > > > with the next patch. Maybe you could add printks() to ia64's
> > > > > > > arch_get_unmapped_area()
> > > > > > > and check what it returns there?
> > > > > > >
> > > > > > > @@ -3654,6 +3658,8 @@ static const struct file_operations
> > > > > > > io_uring_fops =3D {
> > > > > > > =A0#ifndef CONFIG_MMU
> > > > > > > =A0=A0=A0=A0 .get_unmapped_area =3D io_uring_nommu_get_unmap=
ped_area,
> > > > > > > =A0=A0=A0=A0 .mmap_capabilities =3D io_uring_nommu_mmap_capa=
bilities,
> > > > > > > +#elif 0=A0=A0=A0 /* IS_ENABLED(CONFIG_IA64) */
> > > > > > > +=A0=A0=A0 .get_unmapped_area =3D NULL,
> > > > > > > =A0#else
> > > > > > > =A0=A0=A0=A0 .get_unmapped_area =3D io_uring_mmu_get_unmappe=
d_area,
> > > > > > > =A0#endif
> > > > > > >
> > > > > > > Helge
> > > > > >
> > > > > > Thanks Helge.=A0 Sample output from that first patch:
> > > > > >
> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
> > > > > > address 1 is: 1ffffffffff40000
> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
> > > > > > returns address 2000000001e40000
> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
> > > > > > address 1 is: 1ffffffffff20000
> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
> > > > > > returns address 2000000001f20000
> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
> > > > > > address 1 is: 1ffffffffff30000
> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
> > > > > > returns address 2000000001f30000
> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
> > > > > > address 1 is: 1ffffffffff90000
> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
> > > > > > returns address 2000000001f90000
> > > > > >
> > > > > > This pattern seems to be pretty stable, I tried instead just
> > > > > > directly returning the result of a call to
> > > > > > arch_get_unmapped_area() at the end of the function and it see=
ms
> > > > > > similar:
> > > > > >
> > > > > > [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area()
> > > > > > would return address 1ffffffffffd0000
> > > > > > [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would
> > > > > > return address 2000000001f00000
> > > > > > [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area()
> > > > > > would return address 1ffffffffff00000
> > > > > > [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would
> > > > > > return address 1ffffffffff00000
> > > > > > [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area()
> > > > > > would return address 1fffffffffe20000
> > > > > > [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would
> > > > > > return address 2000000002000000
> > > > > > [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area()
> > > > > > would return address 1fffffffffe30000
> > > > > > [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would
> > > > > > return address 2000000002100000
> > > > > >
> > > > > > Is that enough of a clue to go on?
> > > > >
> > > > > SHMLBA on ia64 is 0x100000:
> > > > > arch/ia64/include/asm/shmparam.h:#define=A0=A0=A0=A0=A0=A0=A0 SH=
MLBA=A0 (1024*1024)
> > > > > but the values returned by io_uring_mmu_get_unmapped_area() does=
 not
> > > > > fullfill this.
> > > > >
> > > > > So, probably ia64's SHMLBA isn't pulled in correctly in
> > > > > io_uring/io_uring.c.
> > > > > Check value of this line:
> > > > >  =A0=A0=A0=A0info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL);
> > > > >
> > > > > You could also add
> > > > > #define SHM_COLOUR=A0 0x100000
> > > > > in front of the
> > > > >  =A0=A0=A0=A0#ifdef SHM_COLOUR
> > > > > (define SHM_COLOUR in io_uring/kbuf.c too).
> > > >
> > > > What is the value of PAGE_SIZE and "ptr" on your machine?
> > > > For 4k page size I get:
> > > > SHMLBA -1   ->        FFFFF
> > > > PAGE_MASK   -> FFFFFFFFF000
> > > > so,
> > > > info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL) =3D 0xFF000;
> > > > You could try to set nfo.align_mask =3D 0xfffff;
> > > >
> > > > Helge
> > >
> > > Using 64KiB (65536) PAGE_SIZE here.  64-bit pointers.
> > >
> > > Tried both #define SHM_COLOUR 0x100000, as well and info.align_mask =
=3D
> > > 0xFFFFF, but both of them made the problem change from 100%
> > > reproducible, to
> > > intermittent.
> > >
> > > After inspecting the ouput I observed that it hangs only when the
> > > first
> > > allocation returns an address below 0x2000000000000000, and the seco=
nd
> > > returns an address above it.  When both addresses are above it, it
> > > does not
> > > hang.  Examples:
> > >
> > > When it works:
> > > $ cmake --version
> > > cmake version 3.26.4
> > >
> > > CMake suite maintained and supported by Kitware (kitware.com/cmake).
> > > $ dmesg --color=3Dalways -T | tail -n 4
> > > [Wed Jul 12 20:32:37 2023] io_uring_mmu_get_unmapped_area() would
> > > return
> > > address 1fffffffffe20000
> > > [Wed Jul 12 20:32:37 2023] but arch_get_unmapped_area() would return
> > > address
> > > 2000000002000000
> > > [Wed Jul 12 20:32:37 2023] io_uring_mmu_get_unmapped_area() would
> > > return
> > > address 1fffffffffe50000
> > > [Wed Jul 12 20:32:37 2023] but arch_get_unmapped_area() would return
> > > address
> > > 2000000002100000
> > >
> > >
> > > When it hangs:
> > > $ cmake --version
> > > cmake version 3.26.4
> > >
> > > CMake suite maintained and supported by Kitware (kitware.com/cmake).
> > > ^C
> > > $ dmesg --color=3Dalways -T | tail -n 4
> > > [Wed Jul 12 20:33:12 2023] io_uring_mmu_get_unmapped_area() would
> > > return
> > > address 1ffffffffff00000
> > > [Wed Jul 12 20:33:12 2023] but arch_get_unmapped_area() would return
> > > address
> > > 1ffffffffff00000
> > > [Wed Jul 12 20:33:12 2023] io_uring_mmu_get_unmapped_area() would
> > > return
> > > address 1fffffffffe60000
> > > [Wed Jul 12 20:33:12 2023] but arch_get_unmapped_area() would return
> > > address
> > > 2000000001f00000
> > >
> > > Is io_uring_mmu_get_unmapped_area supported to always return
> > > addresses above
> > > 0x2000000000000000?
> >
> > Yes, with the patch below.
> >
> > > Any reason why it is not doing so sometimes?
> >
> > It depends on the parameters for vm_unmapped_area(). Specifically
> > info.flags=3D0.
> >
> > Try this patch:
> >
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > index 3bca7a79efda..b259794ab53b 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -3429,10 +3429,13 @@ static unsigned long
> > io_uring_mmu_get_unmapped_area(struct file *filp,
> >  	 * A failed mmap() very likely causes application failure,
> >  	 * so fall back to the bottom-up function here. This scenario
> >  	 * can happen with large stack limits and large mmap()
> > -	 * allocations.
> > +	 * allocations. Use bottom-up on IA64 for correct aliasing.
> >  	 */
> > -	addr =3D vm_unmapped_area(&info);
> > -	if (offset_in_page(addr)) {
> > +	if (IS_ENABLED(CONFIG_IA64))
> > +		addr =3D NULL;
> > +	else
> > +		addr =3D vm_unmapped_area(&info);
> > +	if (!addr) {
> >  		info.flags =3D 0;
> >  		info.low_limit =3D TASK_UNMAPPED_BASE;
> >  		info.high_limit =3D mmap_end;
> >
> > Helge
>
> This patch does do the trick, but I am a little unsure if it's the right=
 one
> to go in:
>
> * Adding an arch-specific conditional feels like a bad hack, why is it n=
ot
> working with the other vm_unmapped_area_info settings?

because it tries to map below TASK_UNMAPPED_BASE, for which (I assume) IA-=
64
has different aliasing/caching rules. There are some comments in the arch/=
ia64
files, but I'm not a IA-64 expert...

> * What happened to the offset_in_page check for other arches?

I thought it's not necessary.

But below is another (and much better) approach, which you may test.
I see quite some errors with the liburing testcases on hppa, but I think
they are not related to this function.

Can you test and report back?

Helge


=46rom 457f2c2db984bc159119bfb4426d9dc6c2779ed6 Mon Sep 17 00:00:00 2001
From: Helge Deller <deller@gmx.de>
Date: Sun, 16 Jul 2023 08:45:17 +0200
Subject: [PATCH] io_uring: Adjust mapping wrt architecture aliasing
 requirements

When mapping memory to userspace use the architecture-provided
get_unmapped_area() function instead of the own copy which fails on
IA-64 since it doesn't allow mappings below TASK_UNMAPPED_BASE.

Additionally make sure to flag the requested memory as MAP_SHARED so
that any architecture-specific aliasing rules will be applied.

Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3bca7a79efda..2e7dd93e45d0 100644
=2D-- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3398,48 +3398,27 @@ static unsigned long io_uring_mmu_get_unmapped_are=
a(struct file *filp,
 			unsigned long addr, unsigned long len,
 			unsigned long pgoff, unsigned long flags)
 {
-	const unsigned long mmap_end =3D arch_get_mmap_end(addr, len, flags);
-	struct vm_unmapped_area_info info;
 	void *ptr;

 	/*
 	 * Do not allow to map to user-provided address to avoid breaking the
-	 * aliasing rules. Userspace is not able to guess the offset address of
-	 * kernel kmalloc()ed memory area.
+	 * aliasing rules of various architectures. Userspace is not able to
+	 * guess the offset address of kernel kmalloc()ed memory area.
 	 */
-	if (addr)
+	if (addr | (flags & MAP_FIXED))
 		return -EINVAL;

+	/*
+	 * The requested memory region is required to be shared between kernel
+	 * and userspace application.
+	 */
+	flags |=3D MAP_SHARED;
+
 	ptr =3D io_uring_validate_mmap_request(filp, pgoff, len);
 	if (IS_ERR(ptr))
 		return -ENOMEM;

-	info.flags =3D VM_UNMAPPED_AREA_TOPDOWN;
-	info.length =3D len;
-	info.low_limit =3D max(PAGE_SIZE, mmap_min_addr);
-	info.high_limit =3D arch_get_mmap_base(addr, current->mm->mmap_base);
-#ifdef SHM_COLOUR
-	info.align_mask =3D PAGE_MASK & (SHM_COLOUR - 1UL);
-#else
-	info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL);
-#endif
-	info.align_offset =3D (unsigned long) ptr;
-
-	/*
-	 * A failed mmap() very likely causes application failure,
-	 * so fall back to the bottom-up function here. This scenario
-	 * can happen with large stack limits and large mmap()
-	 * allocations.
-	 */
-	addr =3D vm_unmapped_area(&info);
-	if (offset_in_page(addr)) {
-		info.flags =3D 0;
-		info.low_limit =3D TASK_UNMAPPED_BASE;
-		info.high_limit =3D mmap_end;
-		addr =3D vm_unmapped_area(&info);
-	}
-
-	return addr;
+	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
 }

 #else /* !CONFIG_MMU */
