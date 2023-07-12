Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30429750E70
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 18:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbjGLQZT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 12:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbjGLQZA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 12:25:00 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA161BD6;
        Wed, 12 Jul 2023 09:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1689179055; x=1689783855; i=deller@gmx.de;
 bh=LNgVsqTps5zVhzXdi1K2riJTjlblK3FNLr1XpLga/Fk=;
 h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
 b=OyNUpA8UJl+6JrAjYnnmWhUZYBTSkEZgHrSxnGTQXM6doYXlLnI0bGoXa2dEASLR00emOAL
 4yJuBmD/5v5uz97bMctnvjmaRXm8bzP0pfrzYXo93+JPZpSDIgoV+IoXnEXgvZvNrwaci6p1S
 2Icqz/9Zk9di0YqJxaqdGDanB+ILkzm7lEwr3luTwJy3B+A1Eu/vJJ34MDast6aV7oaVTTEzr
 ZTLfhsiEDOv+eLQ6M8f+PAltU87gKSXg46r3u45ab+HE32S2jx7meMzFMMPsEumX6VocYz/Ng
 LqmNbB6n5+8AuKntsgjZ8X2EOVv4G9P1v5pQDOK5Pu10w4hPsrJA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from ls3530 ([94.134.144.114]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mg6Zq-1pkpW518EY-00heg1; Wed, 12
 Jul 2023 18:24:15 +0200
Date:   Wed, 12 Jul 2023 18:24:13 +0200
From:   Helge Deller <deller@gmx.de>
To:     matoro <matoro_mailinglist_kernel@matoro.tk>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Linux Ia64 <linux-ia64@vger.kernel.org>,
        glaubitz@physik.fu-berlin.de, Sam James <sam@gentoo.org>
Subject: Re: [PATCH 1/5] io_uring: Adjust mapping wrt architecture aliasing
 requirements
Message-ID: <ZK7TrdVXc0O6HMpQ@ls3530>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <20230314171641.10542-2-axboe@kernel.dk>
 <1d5f8f99f39e2769b9c76fbc24e2cf50@matoro.tk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d5f8f99f39e2769b9c76fbc24e2cf50@matoro.tk>
X-Provags-ID: V03:K1:g+GuwCUxidisN/5OR52tKAYke0p1Fqn8eriHq5fDUVsRbjIgWhU
 Gbu5YAoISLO6am29Owu6acAlWPxG8LcmTu0H7ieBjBDNWnnXAEq42ZFO5Q2YC5ivzHfBLgc
 EowLQkDYK0XSAwGHjoQbvAHBX7YgNSpeOG5Dn+mx9xw3kfIlXq/o8g/4LxefqMvCsGl3Ddk
 uOeZy61am8O1vegSQtSSA==
UI-OutboundReport: notjunk:1;M01:P0:0PHNx0ZWVJE=;BmdDmaqmxplwHugWQskXFZyJl4w
 dUnwPnveOuceXCZQS+VQzGfLIlaCrdim1LKLmxupxtYTrI8bYjMfYawNFv9a9NsZWk+3qbbPI
 kIfY8f7ZXpyNeNiwHVtUN4wNHsVKPjRwI2rEyRlSJ6P54/xYQvmS2yFraHLHg/e6X0M6E57VC
 CRNcdlcj831BX9ybBWGaaYbEgj5dm2ANGS5yR2Sp1hVSqXESRTksNCF71v6qyCIHTxFjsHln9
 E4tXPJh+Bxk717PDLdSbFXeOUUrkBmFsM2IQ0cGOjyKs3Y8xr+gxZDrStxdBHwxomz1dbXm1K
 YxRs8IraBGDKIOP23jFaxruvP2Y/0mIx02d626mxV5Hx5npLXJR0tLyvDXW7qz82/vIVEsGvL
 BeHcy1PCccyDf+kwrEAPG/gCCK/LP4jk9uwO6jf+VSnW5fAaTQHl8sAH4xSORUEPghTytemqR
 X5GnOV+dKKlVCVGY1umlO6jluIkBhJhHfxbtYDl2dkk6Zvv5kKiatGuHBNrZSwdo4p9JiXDeo
 xotMVD3PKIMcIfMZRTwX2tOVTp9U1Jm2xwOnZ60tM/9m9fim0umDsyQ/lfSdaVoW0A54ddWNU
 pVevAsAtovDrVDTkJSJ/y1U2eHcQxX/BPT6bhGraeZOKa4RjDvj/x2ggJnODQoYhHKfVXupC8
 p3Zz/Hs8fzXwjizug5Dud6MmvypyFCJU+48aFKCdDR0pGfia9/PbtFGhn5nKB3OIdJKGJEppp
 BxMpuy/333UJylArJulFCmv2OP6bu1lXZc8JdK/o9o+YlfFuopYfRlrErWNA6QaRAM/Z4KcRb
 idtmCdps0w59x1pezgUCLmV8KrEstxwJPtv1Tvy4TDeROJMv8slDwLd489N6XP+DUU4pfep0Z
 0ThWSV/l2akAAo8DSZNi9nw1ULxN4QyAhzL58Yq9ICiPS+hBqMvt5W9V97VFfNBq7Q8t05uMS
 fYM63K9ugA/tt9qIkbfqrLU+XOo=
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Matoro,

* matoro <matoro_mailinglist_kernel@matoro.tk>:
> On 2023-03-14 13:16, Jens Axboe wrote:
> > From: Helge Deller <deller@gmx.de>
> >
> > Some architectures have memory cache aliasing requirements (e.g. paris=
c)
> > if memory is shared between userspace and kernel. This patch fixes the
> > kernel to return an aliased address when asked by userspace via mmap()=
.
> >
> > Signed-off-by: Helge Deller <deller@gmx.de>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > ---
> >  io_uring/io_uring.c | 51 ++++++++++++++++++++++++++++++++++++++++++++=
+
> >  1 file changed, 51 insertions(+)
> >
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > index 722624b6d0dc..3adecebbac71 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -72,6 +72,7 @@
> >  #include <linux/io_uring.h>
> >  #include <linux/audit.h>
> >  #include <linux/security.h>
> > +#include <asm/shmparam.h>
> >
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/io_uring.h>
> > @@ -3317,6 +3318,54 @@ static __cold int io_uring_mmap(struct file
> > *file, struct vm_area_struct *vma)
> >  	return remap_pfn_range(vma, vma->vm_start, pfn, sz,
> > vma->vm_page_prot);
> >  }
> >
> > +static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp=
,
> > +			unsigned long addr, unsigned long len,
> > +			unsigned long pgoff, unsigned long flags)
> > +{
> > +	const unsigned long mmap_end =3D arch_get_mmap_end(addr, len, flags)=
;
> > +	struct vm_unmapped_area_info info;
> > +	void *ptr;
> > +
> > +	/*
> > +	 * Do not allow to map to user-provided address to avoid breaking th=
e
> > +	 * aliasing rules. Userspace is not able to guess the offset address
> > of
> > +	 * kernel kmalloc()ed memory area.
> > +	 */
> > +	if (addr)
> > +		return -EINVAL;
> > +
> > +	ptr =3D io_uring_validate_mmap_request(filp, pgoff, len);
> > +	if (IS_ERR(ptr))
> > +		return -ENOMEM;
> > +
> > +	info.flags =3D VM_UNMAPPED_AREA_TOPDOWN;
> > +	info.length =3D len;
> > +	info.low_limit =3D max(PAGE_SIZE, mmap_min_addr);
> > +	info.high_limit =3D arch_get_mmap_base(addr, current->mm->mmap_base)=
;
> > +#ifdef SHM_COLOUR
> > +	info.align_mask =3D PAGE_MASK & (SHM_COLOUR - 1UL);
> > +#else
> > +	info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL);
> > +#endif
> > +	info.align_offset =3D (unsigned long) ptr;
> > +
> > +	/*
> > +	 * A failed mmap() very likely causes application failure,
> > +	 * so fall back to the bottom-up function here. This scenario
> > +	 * can happen with large stack limits and large mmap()
> > +	 * allocations.
> > +	 */
> > +	addr =3D vm_unmapped_area(&info);
> > +	if (offset_in_page(addr)) {
> > +		info.flags =3D 0;
> > +		info.low_limit =3D TASK_UNMAPPED_BASE;
> > +		info.high_limit =3D mmap_end;
> > +		addr =3D vm_unmapped_area(&info);
> > +	}
> > +
> > +	return addr;
> > +}
> > +
> >  #else /* !CONFIG_MMU */
> >
> >  static int io_uring_mmap(struct file *file, struct vm_area_struct *vm=
a)
> > @@ -3529,6 +3578,8 @@ static const struct file_operations io_uring_fop=
s
> > =3D {
> >  #ifndef CONFIG_MMU
> >  	.get_unmapped_area =3D io_uring_nommu_get_unmapped_area,
> >  	.mmap_capabilities =3D io_uring_nommu_mmap_capabilities,
> > +#else
> > +	.get_unmapped_area =3D io_uring_mmu_get_unmapped_area,
> >  #endif
> >  	.poll		=3D io_uring_poll,
> >  #ifdef CONFIG_PROC_FS
>
> Hi Jens, Helge - I've bisected a regression with io_uring on ia64 to thi=
s
> patch in 6.4.  Unfortunately this breaks userspace programs using io_uri=
ng,
> the easiest one to test is cmake with an io_uring enabled libuv (i.e., l=
ibuv
> >=3D 1.45.0) which will hang.
>
> I am aware that ia64 is in a vulnerable place right now which I why I am
> keeping this spread limited.  Since this clearly involves
> architecture-specific changes for parisc,

it isn't so much architecture-specific... (just one ifdef)

> is there any chance of looking at
> what is required to do the same for ia64?  I looked at
> 0ef36bd2b37815719e31a72d2beecc28ca8ecd26 ("parisc: change value of SHMLB=
A
> from 0x00400000 to PAGE_SIZE") and tried to replicate the SHMLBA ->
> SHM_COLOUR change, but it made no difference.
>
> If hardware is necessary for testing, I can provide it, including remote=
 BMC
> access for restarts/kernel debugging.  Any takers?

I won't have time to test myself, but maybe you could test?

Basically we should try to find out why io_uring_mmu_get_unmapped_area()
doesn't return valid addresses, while arch_get_unmapped_area()
[in arch/ia64/kernel/sys_ia64.c] does.

You could apply this patch first:
It introduces a memory leak (as it requests memory twice), but maybe we
get an idea?
The ia64 arch_get_unmapped_area() searches for memory from bottom
(flags=3D0), while io_uring function tries top-down first. Maybe that's
the problem. And I don't understand the offset_in_page() check right
now.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3bca7a79efda..93b1964d2bbb 100644
=2D-- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3431,13 +3431,17 @@ static unsigned long io_uring_mmu_get_unmapped_are=
a(struct file *filp,
 	 * can happen with large stack limits and large mmap()
 	 * allocations.
 	 */
+/* compare to arch_get_unmapped_area() in arch/ia64/kernel/sys_ia64.c */
 	addr =3D vm_unmapped_area(&info);
-	if (offset_in_page(addr)) {
+printk("io_uring_mmu_get_unmapped_area() address 1 is: %px\n", addr);
+	addr =3D NULL;
+	if (!addr) {
 		info.flags =3D 0;
 		info.low_limit =3D TASK_UNMAPPED_BASE;
 		info.high_limit =3D mmap_end;
 		addr =3D vm_unmapped_area(&info);
 	}
+printk("io_uring_mmu_get_unmapped_area() returns address %px\n", addr);

 	return addr;
 }


Another option is to disable the call to io_uring_nommu_get_unmapped_area(=
))
with the next patch. Maybe you could add printks() to ia64's arch_get_unma=
pped_area()
and check what it returns there?

@@ -3654,6 +3658,8 @@ static const struct file_operations io_uring_fops =
=3D {
 #ifndef CONFIG_MMU
 	.get_unmapped_area =3D io_uring_nommu_get_unmapped_area,
 	.mmap_capabilities =3D io_uring_nommu_mmap_capabilities,
+#elif 0    /* IS_ENABLED(CONFIG_IA64) */
+	.get_unmapped_area =3D NULL,
 #else
 	.get_unmapped_area =3D io_uring_mmu_get_unmapped_area,
 #endif

Helge
