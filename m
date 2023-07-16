Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D51C755035
	for <lists+io-uring@lfdr.de>; Sun, 16 Jul 2023 20:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjGPSDc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Jul 2023 14:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjGPSDb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Jul 2023 14:03:31 -0400
Received: from matoro.tk (unknown [IPv6:2600:1700:4b10:9d80::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1957E5D;
        Sun, 16 Jul 2023 11:03:08 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; bh=lBCu875hBTJQjrXzP9INfq7wCtjMNqiFZDtzShlesq4=;
 c=relaxed/relaxed; d=matoro.tk;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@matoro.tk; s=20230715; t=1689530582; v=1; x=1689962582;
 b=ob9aYkdLsVdFnY2WMY78eyJ+dXZdO78yUQ/arRIYcFPKhgsSV8Pg9MrXNAorsADpgpEk/A++
 pI0L6cmiBXeTvt0RVFyOSNujK3kn0uEjplAZZ6G0KFhCG8E5ksrmk3ThY3N+jPGLndUoJ8Er5kr
 pYhnlKa0TBm4pUsrkuoVwhHAL4TiTWnlKq9Zy0Khf9UiHqSXh2sHK8t+fHT2LFVatMiqrc1QXsX
 Iu1Xjbr/LWkx6aW+C3W3BIbTLO4Ks2j6WCjL/b/+objQXdJ5fvPvi45ixRzuhZmMyUgFKof/2zG
 cUEFIkwckZCneOT5SLiz0e+bED98l02ToUPHkAegiCpdY2BM15AxUaP8va6i6js3/u/s/QoltfB
 lOMwY0WCgA4ikx0Sha4L2UTYhc7wsDjcXxOmUMjW93jfVhTO8YbtZhzooemMC9SupiOWM9V4CzX
 Nr26C6kfMaq68fQU+pMZ2X45R4JtQIP/O+TtpGeOTYW24M0dSIyvZZADPdswaIpSUJA/xVGNEX/
 Q4SIHZiRpsRJZ3HeEIYflsVF0MH+9X4ee+AP2TwIqrfUqIYCbK88RNUnDzrRjU/hr0V83InPEAO
 b2Z4e7fKxr1Xk6c+w5/qqavNRPvUKW6Q/Za1J14t1G1V7F7RyVrxqV6Axypd3MHAvROd0mtTO5a
 9U1J973jCqY=
Received: by matoro.tk (envelope-sender
 <matoro_mailinglist_kernel@matoro.tk>) with ESMTPS id 55a17822; Sun, 16 Jul
 2023 14:03:02 -0400
MIME-Version: 1.0
Date:   Sun, 16 Jul 2023 14:03:02 -0400
From:   matoro <matoro_mailinglist_kernel@matoro.tk>
To:     Helge Deller <deller@gmx.de>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Linux Ia64 <linux-ia64@vger.kernel.org>,
        glaubitz@physik.fu-berlin.de, Sam James <sam@gentoo.org>
Subject: Re: [PATCH 1/5] io_uring: Adjust mapping wrt architecture aliasing
 requirements
In-Reply-To: <ZLOUL+5PxCHW/uc5@p100>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <20230314171641.10542-2-axboe@kernel.dk>
 <1d5f8f99f39e2769b9c76fbc24e2cf50@matoro.tk> <ZK7TrdVXc0O6HMpQ@ls3530>
 <f1bed3cc3c43083cfd86768a91402f6b@matoro.tk>
 <a3ae1656-be97-ccc2-8962-1cb70ebc67fa@gmx.de>
 <802b84f7-94f4-638b-3742-26bca00b262d@gmx.de>
 <8bb091fb5fd00072842fe92b03abac9b@matoro.tk> <ZK+nYIxe6zf2vYwH@ls3530>
 <695fbf1a4f48619de63297b21aa9f6c4@matoro.tk> <ZLOUL+5PxCHW/uc5@p100>
Message-ID: <58aaccbd483c582b3bfd590c110d45c6@matoro.tk>
X-Sender: matoro_mailinglist_kernel@matoro.tk
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RDNS_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-07-16 02:54, Helge Deller wrote:
> * matoro <matoro_mailinglist_kernel@matoro.tk>:
>> On 2023-07-13 03:27, Helge Deller wrote:
>> > * matoro <matoro_mailinglist_kernel@matoro.tk>:
>> > > On 2023-07-12 16:30, Helge Deller wrote:
>> > > > On 7/12/23 21:05, Helge Deller wrote:
>> > > > > On 7/12/23 19:28, matoro wrote:
>> > > > > > On 2023-07-12 12:24, Helge Deller wrote:
>> > > > > > > Hi Matoro,
>> > > > > > >
>> > > > > > > * matoro <matoro_mailinglist_kernel@matoro.tk>:
>> > > > > > > > On 2023-03-14 13:16, Jens Axboe wrote:
>> > > > > > > > > From: Helge Deller <deller@gmx.de>
>> > > > > > > > >
>> > > > > > > > > Some architectures have memory cache aliasing requirements (e.g. parisc)
>> > > > > > > > > if memory is shared between userspace and kernel. This patch fixes the
>> > > > > > > > > kernel to return an aliased address when asked by userspace via mmap().
>> > > > > > > > >
>> > > > > > > > > Signed-off-by: Helge Deller <deller@gmx.de>
>> > > > > > > > > Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> > > > > > > > > ---
>> > > > > > > > >  io_uring/io_uring.c | 51 +++++++++++++++++++++++++++++++++++++++++++++
>> > > > > > > > >  1 file changed, 51 insertions(+)
>> > > > > > > > >
>> > > > > > > > > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> > > > > > > > > index 722624b6d0dc..3adecebbac71 100644
>> > > > > > > > > --- a/io_uring/io_uring.c
>> > > > > > > > > +++ b/io_uring/io_uring.c
>> > > > > > > > > @@ -72,6 +72,7 @@
>> > > > > > > > >  #include <linux/io_uring.h>
>> > > > > > > > >  #include <linux/audit.h>
>> > > > > > > > >  #include <linux/security.h>
>> > > > > > > > > +#include <asm/shmparam.h>
>> > > > > > > > >
>> > > > > > > > >  #define CREATE_TRACE_POINTS
>> > > > > > > > >  #include <trace/events/io_uring.h>
>> > > > > > > > > @@ -3317,6 +3318,54 @@ static __cold int io_uring_mmap(struct file
>> > > > > > > > > *file, struct vm_area_struct *vma)
>> > > > > > > > >      return remap_pfn_range(vma, vma->vm_start, pfn, sz,
>> > > > > > > > > vma->vm_page_prot);
>> > > > > > > > >  }
>> > > > > > > > >
>> > > > > > > > > +static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp,
>> > > > > > > > > +            unsigned long addr, unsigned long len,
>> > > > > > > > > +            unsigned long pgoff, unsigned long flags)
>> > > > > > > > > +{
>> > > > > > > > > +    const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
>> > > > > > > > > +    struct vm_unmapped_area_info info;
>> > > > > > > > > +    void *ptr;
>> > > > > > > > > +
>> > > > > > > > > +    /*
>> > > > > > > > > +     * Do not allow to map to user-provided address to avoid breaking the
>> > > > > > > > > +     * aliasing rules. Userspace is not able to guess the offset address
>> > > > > > > > > of
>> > > > > > > > > +     * kernel kmalloc()ed memory area.
>> > > > > > > > > +     */
>> > > > > > > > > +    if (addr)
>> > > > > > > > > +        return -EINVAL;
>> > > > > > > > > +
>> > > > > > > > > +    ptr = io_uring_validate_mmap_request(filp, pgoff, len);
>> > > > > > > > > +    if (IS_ERR(ptr))
>> > > > > > > > > +        return -ENOMEM;
>> > > > > > > > > +
>> > > > > > > > > +    info.flags = VM_UNMAPPED_AREA_TOPDOWN;
>> > > > > > > > > +    info.length = len;
>> > > > > > > > > +    info.low_limit = max(PAGE_SIZE, mmap_min_addr);
>> > > > > > > > > +    info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
>> > > > > > > > > +#ifdef SHM_COLOUR
>> > > > > > > > > +    info.align_mask = PAGE_MASK & (SHM_COLOUR - 1UL);
>> > > > > > > > > +#else
>> > > > > > > > > +    info.align_mask = PAGE_MASK & (SHMLBA - 1UL);
>> > > > > > > > > +#endif
>> > > > > > > > > +    info.align_offset = (unsigned long) ptr;
>> > > > > > > > > +
>> > > > > > > > > +    /*
>> > > > > > > > > +     * A failed mmap() very likely causes application failure,
>> > > > > > > > > +     * so fall back to the bottom-up function here. This scenario
>> > > > > > > > > +     * can happen with large stack limits and large mmap()
>> > > > > > > > > +     * allocations.
>> > > > > > > > > +     */
>> > > > > > > > > +    addr = vm_unmapped_area(&info);
>> > > > > > > > > +    if (offset_in_page(addr)) {
>> > > > > > > > > +        info.flags = 0;
>> > > > > > > > > +        info.low_limit = TASK_UNMAPPED_BASE;
>> > > > > > > > > +        info.high_limit = mmap_end;
>> > > > > > > > > +        addr = vm_unmapped_area(&info);
>> > > > > > > > > +    }
>> > > > > > > > > +
>> > > > > > > > > +    return addr;
>> > > > > > > > > +}
>> > > > > > > > > +
>> > > > > > > > >  #else /* !CONFIG_MMU */
>> > > > > > > > >
>> > > > > > > > >  static int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
>> > > > > > > > > @@ -3529,6 +3578,8 @@ static const struct file_operations io_uring_fops
>> > > > > > > > > = {
>> > > > > > > > >  #ifndef CONFIG_MMU
>> > > > > > > > >      .get_unmapped_area = io_uring_nommu_get_unmapped_area,
>> > > > > > > > >      .mmap_capabilities = io_uring_nommu_mmap_capabilities,
>> > > > > > > > > +#else
>> > > > > > > > > +    .get_unmapped_area = io_uring_mmu_get_unmapped_area,
>> > > > > > > > >  #endif
>> > > > > > > > >      .poll        = io_uring_poll,
>> > > > > > > > >  #ifdef CONFIG_PROC_FS
>> > > > > > > >
>> > > > > > > > Hi Jens, Helge - I've bisected a regression with
>> > > > > > > > io_uring on ia64 to this
>> > > > > > > > patch in 6.4.  Unfortunately this breaks userspace
>> > > > > > > > programs using io_uring,
>> > > > > > > > the easiest one to test is cmake with an io_uring
>> > > > > > > > enabled libuv (i.e., libuv
>> > > > > > > > >= 1.45.0) which will hang.
>> > > > > > > >
>> > > > > > > > I am aware that ia64 is in a vulnerable place right now
>> > > > > > > > which I why I am
>> > > > > > > > keeping this spread limited.  Since this clearly involves
>> > > > > > > > architecture-specific changes for parisc,
>> > > > > > >
>> > > > > > > it isn't so much architecture-specific... (just one ifdef)
>> > > > > > >
>> > > > > > > > is there any chance of looking at
>> > > > > > > > what is required to do the same for ia64?  I looked at
>> > > > > > > > 0ef36bd2b37815719e31a72d2beecc28ca8ecd26 ("parisc:
>> > > > > > > > change value of SHMLBA
>> > > > > > > > from 0x00400000 to PAGE_SIZE") and tried to replicate the SHMLBA ->
>> > > > > > > > SHM_COLOUR change, but it made no difference.
>> > > > > > > >
>> > > > > > > > If hardware is necessary for testing, I can provide it,
>> > > > > > > > including remote BMC
>> > > > > > > > access for restarts/kernel debugging.  Any takers?
>> > > > > > >
>> > > > > > > I won't have time to test myself, but maybe you could test?
>> > > > > > >
>> > > > > > > Basically we should try to find out why
>> > > > > > > io_uring_mmu_get_unmapped_area()
>> > > > > > > doesn't return valid addresses, while arch_get_unmapped_area()
>> > > > > > > [in arch/ia64/kernel/sys_ia64.c] does.
>> > > > > > >
>> > > > > > > You could apply this patch first:
>> > > > > > > It introduces a memory leak (as it requests memory twice),
>> > > > > > > but maybe we
>> > > > > > > get an idea?
>> > > > > > > The ia64 arch_get_unmapped_area() searches for memory from bottom
>> > > > > > > (flags=0), while io_uring function tries top-down first.
>> > > > > > > Maybe that's
>> > > > > > > the problem. And I don't understand the offset_in_page() check right
>> > > > > > > now.
>> > > > > > >
>> > > > > > > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> > > > > > > index 3bca7a79efda..93b1964d2bbb 100644
>> > > > > > > --- a/io_uring/io_uring.c
>> > > > > > > +++ b/io_uring/io_uring.c
>> > > > > > > @@ -3431,13 +3431,17 @@ static unsigned long
>> > > > > > > io_uring_mmu_get_unmapped_area(struct file *filp,
>> > > > > > >       * can happen with large stack limits and large mmap()
>> > > > > > >       * allocations.
>> > > > > > >       */
>> > > > > > > +/* compare to arch_get_unmapped_area() in
>> > > > > > > arch/ia64/kernel/sys_ia64.c */
>> > > > > > >      addr = vm_unmapped_area(&info);
>> > > > > > > -    if (offset_in_page(addr)) {
>> > > > > > > +printk("io_uring_mmu_get_unmapped_area() address 1 is:
>> > > > > > > %px\n", addr);
>> > > > > > > +    addr = NULL;
>> > > > > > > +    if (!addr) {
>> > > > > > >          info.flags = 0;
>> > > > > > >          info.low_limit = TASK_UNMAPPED_BASE;
>> > > > > > >          info.high_limit = mmap_end;
>> > > > > > >          addr = vm_unmapped_area(&info);
>> > > > > > >      }
>> > > > > > > +printk("io_uring_mmu_get_unmapped_area() returns address
>> > > > > > > %px\n", addr);
>> > > > > > >
>> > > > > > >      return addr;
>> > > > > > >  }
>> > > > > > >
>> > > > > > >
>> > > > > > > Another option is to disable the call to
>> > > > > > > io_uring_nommu_get_unmapped_area())
>> > > > > > > with the next patch. Maybe you could add printks() to ia64's
>> > > > > > > arch_get_unmapped_area()
>> > > > > > > and check what it returns there?
>> > > > > > >
>> > > > > > > @@ -3654,6 +3658,8 @@ static const struct file_operations
>> > > > > > > io_uring_fops = {
>> > > > > > >  #ifndef CONFIG_MMU
>> > > > > > >      .get_unmapped_area = io_uring_nommu_get_unmapped_area,
>> > > > > > >      .mmap_capabilities = io_uring_nommu_mmap_capabilities,
>> > > > > > > +#elif 0    /* IS_ENABLED(CONFIG_IA64) */
>> > > > > > > +    .get_unmapped_area = NULL,
>> > > > > > >  #else
>> > > > > > >      .get_unmapped_area = io_uring_mmu_get_unmapped_area,
>> > > > > > >  #endif
>> > > > > > >
>> > > > > > > Helge
>> > > > > >
>> > > > > > Thanks Helge.  Sample output from that first patch:
>> > > > > >
>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>> > > > > > address 1 is: 1ffffffffff40000
>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>> > > > > > returns address 2000000001e40000
>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>> > > > > > address 1 is: 1ffffffffff20000
>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>> > > > > > returns address 2000000001f20000
>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>> > > > > > address 1 is: 1ffffffffff30000
>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>> > > > > > returns address 2000000001f30000
>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>> > > > > > address 1 is: 1ffffffffff90000
>> > > > > > [Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area()
>> > > > > > returns address 2000000001f90000
>> > > > > >
>> > > > > > This pattern seems to be pretty stable, I tried instead just
>> > > > > > directly returning the result of a call to
>> > > > > > arch_get_unmapped_area() at the end of the function and it seems
>> > > > > > similar:
>> > > > > >
>> > > > > > [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area()
>> > > > > > would return address 1ffffffffffd0000
>> > > > > > [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would
>> > > > > > return address 2000000001f00000
>> > > > > > [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area()
>> > > > > > would return address 1ffffffffff00000
>> > > > > > [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would
>> > > > > > return address 1ffffffffff00000
>> > > > > > [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area()
>> > > > > > would return address 1fffffffffe20000
>> > > > > > [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would
>> > > > > > return address 2000000002000000
>> > > > > > [Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area()
>> > > > > > would return address 1fffffffffe30000
>> > > > > > [Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would
>> > > > > > return address 2000000002100000
>> > > > > >
>> > > > > > Is that enough of a clue to go on?
>> > > > >
>> > > > > SHMLBA on ia64 is 0x100000:
>> > > > > arch/ia64/include/asm/shmparam.h:#define        SHMLBA  (1024*1024)
>> > > > > but the values returned by io_uring_mmu_get_unmapped_area() does not
>> > > > > fullfill this.
>> > > > >
>> > > > > So, probably ia64's SHMLBA isn't pulled in correctly in
>> > > > > io_uring/io_uring.c.
>> > > > > Check value of this line:
>> > > > >      info.align_mask = PAGE_MASK & (SHMLBA - 1UL);
>> > > > >
>> > > > > You could also add
>> > > > > #define SHM_COLOUR  0x100000
>> > > > > in front of the
>> > > > >      #ifdef SHM_COLOUR
>> > > > > (define SHM_COLOUR in io_uring/kbuf.c too).
>> > > >
>> > > > What is the value of PAGE_SIZE and "ptr" on your machine?
>> > > > For 4k page size I get:
>> > > > SHMLBA -1   ->        FFFFF
>> > > > PAGE_MASK   -> FFFFFFFFF000
>> > > > so,
>> > > > info.align_mask = PAGE_MASK & (SHMLBA - 1UL) = 0xFF000;
>> > > > You could try to set nfo.align_mask = 0xfffff;
>> > > >
>> > > > Helge
>> > >
>> > > Using 64KiB (65536) PAGE_SIZE here.  64-bit pointers.
>> > >
>> > > Tried both #define SHM_COLOUR 0x100000, as well and info.align_mask =
>> > > 0xFFFFF, but both of them made the problem change from 100%
>> > > reproducible, to
>> > > intermittent.
>> > >
>> > > After inspecting the ouput I observed that it hangs only when the
>> > > first
>> > > allocation returns an address below 0x2000000000000000, and the second
>> > > returns an address above it.  When both addresses are above it, it
>> > > does not
>> > > hang.  Examples:
>> > >
>> > > When it works:
>> > > $ cmake --version
>> > > cmake version 3.26.4
>> > >
>> > > CMake suite maintained and supported by Kitware (kitware.com/cmake).
>> > > $ dmesg --color=always -T | tail -n 4
>> > > [Wed Jul 12 20:32:37 2023] io_uring_mmu_get_unmapped_area() would
>> > > return
>> > > address 1fffffffffe20000
>> > > [Wed Jul 12 20:32:37 2023] but arch_get_unmapped_area() would return
>> > > address
>> > > 2000000002000000
>> > > [Wed Jul 12 20:32:37 2023] io_uring_mmu_get_unmapped_area() would
>> > > return
>> > > address 1fffffffffe50000
>> > > [Wed Jul 12 20:32:37 2023] but arch_get_unmapped_area() would return
>> > > address
>> > > 2000000002100000
>> > >
>> > >
>> > > When it hangs:
>> > > $ cmake --version
>> > > cmake version 3.26.4
>> > >
>> > > CMake suite maintained and supported by Kitware (kitware.com/cmake).
>> > > ^C
>> > > $ dmesg --color=always -T | tail -n 4
>> > > [Wed Jul 12 20:33:12 2023] io_uring_mmu_get_unmapped_area() would
>> > > return
>> > > address 1ffffffffff00000
>> > > [Wed Jul 12 20:33:12 2023] but arch_get_unmapped_area() would return
>> > > address
>> > > 1ffffffffff00000
>> > > [Wed Jul 12 20:33:12 2023] io_uring_mmu_get_unmapped_area() would
>> > > return
>> > > address 1fffffffffe60000
>> > > [Wed Jul 12 20:33:12 2023] but arch_get_unmapped_area() would return
>> > > address
>> > > 2000000001f00000
>> > >
>> > > Is io_uring_mmu_get_unmapped_area supported to always return
>> > > addresses above
>> > > 0x2000000000000000?
>> >
>> > Yes, with the patch below.
>> >
>> > > Any reason why it is not doing so sometimes?
>> >
>> > It depends on the parameters for vm_unmapped_area(). Specifically
>> > info.flags=0.
>> >
>> > Try this patch:
>> >
>> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> > index 3bca7a79efda..b259794ab53b 100644
>> > --- a/io_uring/io_uring.c
>> > +++ b/io_uring/io_uring.c
>> > @@ -3429,10 +3429,13 @@ static unsigned long
>> > io_uring_mmu_get_unmapped_area(struct file *filp,
>> >  	 * A failed mmap() very likely causes application failure,
>> >  	 * so fall back to the bottom-up function here. This scenario
>> >  	 * can happen with large stack limits and large mmap()
>> > -	 * allocations.
>> > +	 * allocations. Use bottom-up on IA64 for correct aliasing.
>> >  	 */
>> > -	addr = vm_unmapped_area(&info);
>> > -	if (offset_in_page(addr)) {
>> > +	if (IS_ENABLED(CONFIG_IA64))
>> > +		addr = NULL;
>> > +	else
>> > +		addr = vm_unmapped_area(&info);
>> > +	if (!addr) {
>> >  		info.flags = 0;
>> >  		info.low_limit = TASK_UNMAPPED_BASE;
>> >  		info.high_limit = mmap_end;
>> >
>> > Helge
>> 
>> This patch does do the trick, but I am a little unsure if it's the 
>> right one
>> to go in:
>> 
>> * Adding an arch-specific conditional feels like a bad hack, why is it 
>> not
>> working with the other vm_unmapped_area_info settings?
> 
> because it tries to map below TASK_UNMAPPED_BASE, for which (I assume) 
> IA-64
> has different aliasing/caching rules. There are some comments in the 
> arch/ia64
> files, but I'm not a IA-64 expert...
> 
>> * What happened to the offset_in_page check for other arches?
> 
> I thought it's not necessary.
> 
> But below is another (and much better) approach, which you may test.
> I see quite some errors with the liburing testcases on hppa, but I 
> think
> they are not related to this function.
> 
> Can you test and report back?
> 
> Helge
> 
> 
> From 457f2c2db984bc159119bfb4426d9dc6c2779ed6 Mon Sep 17 00:00:00 2001
> From: Helge Deller <deller@gmx.de>
> Date: Sun, 16 Jul 2023 08:45:17 +0200
> Subject: [PATCH] io_uring: Adjust mapping wrt architecture aliasing
>  requirements
> 
> When mapping memory to userspace use the architecture-provided
> get_unmapped_area() function instead of the own copy which fails on
> IA-64 since it doesn't allow mappings below TASK_UNMAPPED_BASE.
> 
> Additionally make sure to flag the requested memory as MAP_SHARED so
> that any architecture-specific aliasing rules will be applied.
> 
> Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
> Signed-off-by: Helge Deller <deller@gmx.de>
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 3bca7a79efda..2e7dd93e45d0 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3398,48 +3398,27 @@ static unsigned long 
> io_uring_mmu_get_unmapped_area(struct file *filp,
>  			unsigned long addr, unsigned long len,
>  			unsigned long pgoff, unsigned long flags)
>  {
> -	const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
> -	struct vm_unmapped_area_info info;
>  	void *ptr;
> 
>  	/*
>  	 * Do not allow to map to user-provided address to avoid breaking the
> -	 * aliasing rules. Userspace is not able to guess the offset address 
> of
> -	 * kernel kmalloc()ed memory area.
> +	 * aliasing rules of various architectures. Userspace is not able to
> +	 * guess the offset address of kernel kmalloc()ed memory area.
>  	 */
> -	if (addr)
> +	if (addr | (flags & MAP_FIXED))
>  		return -EINVAL;
> 
> +	/*
> +	 * The requested memory region is required to be shared between 
> kernel
> +	 * and userspace application.
> +	 */
> +	flags |= MAP_SHARED;
> +
>  	ptr = io_uring_validate_mmap_request(filp, pgoff, len);
>  	if (IS_ERR(ptr))
>  		return -ENOMEM;
> 
> -	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
> -	info.length = len;
> -	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
> -	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
> -#ifdef SHM_COLOUR
> -	info.align_mask = PAGE_MASK & (SHM_COLOUR - 1UL);
> -#else
> -	info.align_mask = PAGE_MASK & (SHMLBA - 1UL);
> -#endif
> -	info.align_offset = (unsigned long) ptr;
> -
> -	/*
> -	 * A failed mmap() very likely causes application failure,
> -	 * so fall back to the bottom-up function here. This scenario
> -	 * can happen with large stack limits and large mmap()
> -	 * allocations.
> -	 */
> -	addr = vm_unmapped_area(&info);
> -	if (offset_in_page(addr)) {
> -		info.flags = 0;
> -		info.low_limit = TASK_UNMAPPED_BASE;
> -		info.high_limit = mmap_end;
> -		addr = vm_unmapped_area(&info);
> -	}
> -
> -	return addr;
> +	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
>  }
> 
>  #else /* !CONFIG_MMU */

This seems really close.  It worked for the trivial test case, so I ran 
the test suite from https://github.com/axboe/liburing to compare.  With 
kernel 6.3, I get 100% pass, after I get one failure:
Running test read-write.t                                           
cqe->res=33, expected=32
test_rem_buf_single(BUFFERS + 1) failed
Not root, skipping test_write_efbig
Test read-write.t failed with ret 1

Trying this patch out on other arches to see if it also affects them or 
is ia64-specific.
