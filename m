Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9471775A320
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 02:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjGTAOL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Jul 2023 20:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGTAOK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Jul 2023 20:14:10 -0400
Received: from matoro.tk (unknown [IPv6:2600:1700:4b10:9d80::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B86CB3;
        Wed, 19 Jul 2023 17:14:07 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; bh=krxhcGA0YRu6w/OVQGooFwevTuGhPpdkcQGnNSuY7Fk=;
 c=relaxed/relaxed; d=matoro.tk;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@matoro.tk; s=20230715; t=1689812043; v=1; x=1690244043;
 b=lUyQm/YPC3RcuZ0lcei7e7yp906tjIu2Fxr/2DRaypXzrkMxt+prbNRCiGMjOsBXgssgIoaE
 4gijtYv5t5jRWSiTsFMz6h+yyhJs7Adbatj8t+2jQQ+YGn/I2HmcrKQvt0uLIN/CAe0BowzhDML
 tbQ17FNk0U5qUT0WMd3HYbiXbZhGmP4RVM+xdSxYGx06HfdfwZU3C7e+I9LMNYi48PXHTeFQiFF
 BHd6FWndQYZINRgV+JNPjAUw1GKDqO9irsnYX860LCPgbjReiw1h2KVaJNSjRlbE5IKETpfrOAU
 94xzjD5svfzSiwq/WTjE0SisnMghxyCRKzeKds+kvKc0sVKWseynFZkZljuspQPmn4Gybae+NiQ
 T/tQChnt5TS925S5kHRzogNuEhiQYdGuVyRk3FY/VfPjJru0v3laDs8ygwSKggCtseJE1NGhkpI
 UrZao4DW2z9cqvz3YBKKI1ZBMR2eo9H1wIhfsdt2SGKfK6ZhIwOYDLhetL/m9VCYn69DET2K1jO
 gjvHYE8F4UeT2JbVfafZXJiOgdjAIfiyaxYWV1++iUMHSHDbo4N9aTTXzrCq5gtg6OeudADceTk
 xIFAXGI8gOnLmEm7xGt/Pccg9v068jlyOxoBifpYsFDAl7v92/7+hh2CS+kSCOI3DT/fW7mKrYv
 S0fBQ+4/w+0=
Received: by matoro.tk (envelope-sender
 <matoro_mailinglist_kernel@matoro.tk>) with ESMTPS id 16423bbb; Wed, 19 Jul
 2023 20:14:03 -0400
MIME-Version: 1.0
Date:   Wed, 19 Jul 2023 20:14:03 -0400
From:   matoro <matoro_mailinglist_kernel@matoro.tk>
To:     Helge Deller <deller@gmx.de>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: [PATCH][RFC] io_uring: Fix io_uring_mmu_get_unmapped_area() for
 IA-64
In-Reply-To: <ZLhTuTPecx2fGuH1@p100>
References: <ZLhTuTPecx2fGuH1@p100>
Message-ID: <27b05e18b406621584b29653e5aafd43@matoro.tk>
X-Sender: matoro_mailinglist_kernel@matoro.tk
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RDNS_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-07-19 17:20, Helge Deller wrote:
> The io_uring testcase is broken on IA-64 since commit d808459b2e31
> ("io_uring: Adjust mapping wrt architecture aliasing requirements").
> 
> The reason is, that this commit introduced an own architecture
> independend get_unmapped_area() search algorithm which doesn't suite 
> the
> memory region requirements for IA-64.
> 
> To avoid similar problems in the future it's better to switch back to
> the architecture-provided get_unmapped_area() function and adjust the
> needed input parameters before the call.  Additionally
> io_uring_mmu_get_unmapped_area() will now become easier to understand
> and maintain.
> 
> This patch has been tested on physical IA-64 and PA-RISC machines,
> without any failures in the io_uring testcases. On PA-RISC the
> LTP mmmap testcases did not report any regressions either.
> 
> I don't expect issues for other architectures, but it would be nice if
> this patch could be tested on other machines too.
> 
> Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
> Fixes: d808459b2e31 ("io_uring: Adjust mapping wrt architecture 
> aliasing requirements")
> Signed-off-by: Helge Deller <deller@gmx.de>
> 
> diff --git a/arch/ia64/kernel/sys_ia64.c b/arch/ia64/kernel/sys_ia64.c
> index 6e948d015332..eb561cc93632 100644
> --- a/arch/ia64/kernel/sys_ia64.c
> +++ b/arch/ia64/kernel/sys_ia64.c
> @@ -63,7 +63,7 @@ arch_get_unmapped_area (struct file *filp, unsigned 
> long addr, unsigned long len
>  	info.low_limit = addr;
>  	info.high_limit = TASK_SIZE;
>  	info.align_mask = align_mask;
> -	info.align_offset = 0;
> +	info.align_offset = pgoff << PAGE_SHIFT;
>  	return vm_unmapped_area(&info);
>  }
> 
> diff --git a/arch/parisc/kernel/sys_parisc.c 
> b/arch/parisc/kernel/sys_parisc.c
> index 39acccabf2ed..465b7cb9d44f 100644
> --- a/arch/parisc/kernel/sys_parisc.c
> +++ b/arch/parisc/kernel/sys_parisc.c
> @@ -26,12 +26,17 @@
>  #include <linux/compat.h>
> 
>  /*
> - * Construct an artificial page offset for the mapping based on the 
> physical
> + * Construct an artificial page offset for the mapping based on the 
> virtual
>   * address of the kernel file mapping variable.
> + * If filp is zero the calculated pgoff value aliases the memory of 
> the given
> + * address. This is useful for io_uring where the mapping shall alias 
> a kernel
> + * address and a userspace adress where both the kernel and the 
> userspace
> + * access the same memory region.
>   */
> -#define GET_FILP_PGOFF(filp)		\
> -	(filp ? (((unsigned long) filp->f_mapping) >> 8)	\
> -		 & ((SHM_COLOUR-1) >> PAGE_SHIFT) : 0UL)
> +#define GET_FILP_PGOFF(filp, addr)		\
> +	((filp ? (((unsigned long) filp->f_mapping) >> 8)	\
> +		 & ((SHM_COLOUR-1) >> PAGE_SHIFT) : 0UL)	\
> +	  + (addr >> PAGE_SHIFT))
> 
>  static unsigned long shared_align_offset(unsigned long filp_pgoff,
>  					 unsigned long pgoff)
> @@ -111,7 +116,7 @@ static unsigned long 
> arch_get_unmapped_area_common(struct file *filp,
>  	do_color_align = 0;
>  	if (filp || (flags & MAP_SHARED))
>  		do_color_align = 1;
> -	filp_pgoff = GET_FILP_PGOFF(filp);
> +	filp_pgoff = GET_FILP_PGOFF(filp, addr);
> 
>  	if (flags & MAP_FIXED) {
>  		/* Even MAP_FIXED mappings must reside within TASK_SIZE */
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index f1b79959d1c1..70eb01faf15f 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3425,8 +3425,6 @@ static unsigned long 
> io_uring_mmu_get_unmapped_area(struct file *filp,
>  			unsigned long addr, unsigned long len,
>  			unsigned long pgoff, unsigned long flags)
>  {
> -	const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
> -	struct vm_unmapped_area_info info;
>  	void *ptr;
> 
>  	/*
> @@ -3441,32 +3439,26 @@ static unsigned long 
> io_uring_mmu_get_unmapped_area(struct file *filp,
>  	if (IS_ERR(ptr))
>  		return -ENOMEM;
> 
> -	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
> -	info.length = len;
> -	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
> -	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
> +	/*
> +	 * Some architectures have strong cache aliasing requirements.
> +	 * For such architectures we need a coherent mapping which aliases
> +	 * kernel memory *and* userspace memory. To achieve that:
> +	 * - use a NULL file pointer to reference physical memory, and
> +	 * - use the kernel virtual address of the shared io_uring context
> +	 *   (instead of the userspace-provided address, which has to be 0UL
> +	 *   anyway).
> +	 * For architectures without such aliasing requirements, the
> +	 * architecture will return any suitable mapping because addr is 0.
> +	 */
> +	filp = NULL;
> +	flags |= MAP_SHARED;
> +	pgoff = 0;	/* has been translated to ptr above */
>  #ifdef SHM_COLOUR
> -	info.align_mask = PAGE_MASK & (SHM_COLOUR - 1UL);
> +	addr = (uintptr_t) ptr;
>  #else
> -	info.align_mask = PAGE_MASK & (SHMLBA - 1UL);
> +	addr = 0UL;
>  #endif
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

Tested-by: matoro <matoro_mailinglist_kernel@matoro.tk>

On 6.4.4.  The NFS thing I mentioned in our previous emails appears to 
be a separate regression not related to io_uring.
