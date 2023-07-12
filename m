Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9E1750FAA
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 19:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbjGLR3G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 13:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbjGLR3F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 13:29:05 -0400
Received: from matoro.tk (unknown [IPv6:2600:1700:4b10:9d80::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C3F510C7;
        Wed, 12 Jul 2023 10:28:49 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; bh=v/CrIgqYsKINm/wBSxhw3SfPio2VzDPLrtQmtYz80D0=;
 c=relaxed/relaxed; d=matoro.tk;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@matoro.tk; s=20230516; t=1689182925; v=1; x=1689614925;
 b=xC2ONklKe9lAiVa/YACe+T8Tx+uKnW6fdxxayyMkFkblhnLGwocffs8E1V75OPrMqsOfHS7t
 GohyDcx8WaSsk9isA86Tyu0MtioCao3T3YVNfctlZyemeVj8O1nOTdNb1Ks7hUT0TyxA59vGhIv
 v9XUFMmbYPDIsSY9qZk+f8uUrYaf7PcayrTdlXY/W4MytBUQ0eU+jZRNtsjQ9+3mfbx3IIDhxXs
 KGVsOhaITct6SI2rKNVWStrEsQA7Da8mzG2+EAQjtZaUR34A/G4qQDo1yvsEwVD+ecAayV0w9Xq
 LhcZLrGhnwn1h74IpLr4RxzwK58yTPwMBgewSGSadIx5ZZRk9seqkHH9MJOXM9GWv2Wd8Pg96b5
 OBvEX/Ubg1o98zVuCZHOz4q928In7POsY3VdOYJnEzspO9yChkl6UzJ/BHYvXRTP5xzDMNhiamG
 Nejg9YKnN5d7zH3TYVL4F3llt8lLCp407pUwQdLzQjIPJ5M4GZNxFOnbStvXqSVo8aRNdo1f0E8
 QPM86mWAcF5Lnn8jMdFQmbj+m4264F0qeajaWrz1kG4NjnCHcdIAVICeJJjZ/c/PnyH6zPXtHJc
 fFvgV0wVH5oRUty2gcQbnHRIuf7Y9DC47+Da74h/z6TwTgnufDHBi7TShnk8U+RbXJ8JhSJU81B
 0Ay5XOIMxjU=
Received: by matoro.tk (envelope-sender
 <matoro_mailinglist_kernel@matoro.tk>) with ESMTPS id 55dcdc0f; Wed, 12 Jul
 2023 13:28:45 -0400
MIME-Version: 1.0
Date:   Wed, 12 Jul 2023 13:28:45 -0400
From:   matoro <matoro_mailinglist_kernel@matoro.tk>
To:     Helge Deller <deller@gmx.de>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Linux Ia64 <linux-ia64@vger.kernel.org>,
        glaubitz@physik.fu-berlin.de, Sam James <sam@gentoo.org>
Subject: Re: [PATCH 1/5] io_uring: Adjust mapping wrt architecture aliasing
 requirements
In-Reply-To: <ZK7TrdVXc0O6HMpQ@ls3530>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <20230314171641.10542-2-axboe@kernel.dk>
 <1d5f8f99f39e2769b9c76fbc24e2cf50@matoro.tk> <ZK7TrdVXc0O6HMpQ@ls3530>
Message-ID: <f1bed3cc3c43083cfd86768a91402f6b@matoro.tk>
X-Sender: matoro_mailinglist_kernel@matoro.tk
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RDNS_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-07-12 12:24, Helge Deller wrote:
> Hi Matoro,
> 
> * matoro <matoro_mailinglist_kernel@matoro.tk>:
>> On 2023-03-14 13:16, Jens Axboe wrote:
>> > From: Helge Deller <deller@gmx.de>
>> >
>> > Some architectures have memory cache aliasing requirements (e.g. parisc)
>> > if memory is shared between userspace and kernel. This patch fixes the
>> > kernel to return an aliased address when asked by userspace via mmap().
>> >
>> > Signed-off-by: Helge Deller <deller@gmx.de>
>> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> > ---
>> >  io_uring/io_uring.c | 51 +++++++++++++++++++++++++++++++++++++++++++++
>> >  1 file changed, 51 insertions(+)
>> >
>> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> > index 722624b6d0dc..3adecebbac71 100644
>> > --- a/io_uring/io_uring.c
>> > +++ b/io_uring/io_uring.c
>> > @@ -72,6 +72,7 @@
>> >  #include <linux/io_uring.h>
>> >  #include <linux/audit.h>
>> >  #include <linux/security.h>
>> > +#include <asm/shmparam.h>
>> >
>> >  #define CREATE_TRACE_POINTS
>> >  #include <trace/events/io_uring.h>
>> > @@ -3317,6 +3318,54 @@ static __cold int io_uring_mmap(struct file
>> > *file, struct vm_area_struct *vma)
>> >  	return remap_pfn_range(vma, vma->vm_start, pfn, sz,
>> > vma->vm_page_prot);
>> >  }
>> >
>> > +static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp,
>> > +			unsigned long addr, unsigned long len,
>> > +			unsigned long pgoff, unsigned long flags)
>> > +{
>> > +	const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
>> > +	struct vm_unmapped_area_info info;
>> > +	void *ptr;
>> > +
>> > +	/*
>> > +	 * Do not allow to map to user-provided address to avoid breaking the
>> > +	 * aliasing rules. Userspace is not able to guess the offset address
>> > of
>> > +	 * kernel kmalloc()ed memory area.
>> > +	 */
>> > +	if (addr)
>> > +		return -EINVAL;
>> > +
>> > +	ptr = io_uring_validate_mmap_request(filp, pgoff, len);
>> > +	if (IS_ERR(ptr))
>> > +		return -ENOMEM;
>> > +
>> > +	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
>> > +	info.length = len;
>> > +	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
>> > +	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
>> > +#ifdef SHM_COLOUR
>> > +	info.align_mask = PAGE_MASK & (SHM_COLOUR - 1UL);
>> > +#else
>> > +	info.align_mask = PAGE_MASK & (SHMLBA - 1UL);
>> > +#endif
>> > +	info.align_offset = (unsigned long) ptr;
>> > +
>> > +	/*
>> > +	 * A failed mmap() very likely causes application failure,
>> > +	 * so fall back to the bottom-up function here. This scenario
>> > +	 * can happen with large stack limits and large mmap()
>> > +	 * allocations.
>> > +	 */
>> > +	addr = vm_unmapped_area(&info);
>> > +	if (offset_in_page(addr)) {
>> > +		info.flags = 0;
>> > +		info.low_limit = TASK_UNMAPPED_BASE;
>> > +		info.high_limit = mmap_end;
>> > +		addr = vm_unmapped_area(&info);
>> > +	}
>> > +
>> > +	return addr;
>> > +}
>> > +
>> >  #else /* !CONFIG_MMU */
>> >
>> >  static int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
>> > @@ -3529,6 +3578,8 @@ static const struct file_operations io_uring_fops
>> > = {
>> >  #ifndef CONFIG_MMU
>> >  	.get_unmapped_area = io_uring_nommu_get_unmapped_area,
>> >  	.mmap_capabilities = io_uring_nommu_mmap_capabilities,
>> > +#else
>> > +	.get_unmapped_area = io_uring_mmu_get_unmapped_area,
>> >  #endif
>> >  	.poll		= io_uring_poll,
>> >  #ifdef CONFIG_PROC_FS
>> 
>> Hi Jens, Helge - I've bisected a regression with io_uring on ia64 to 
>> this
>> patch in 6.4.  Unfortunately this breaks userspace programs using 
>> io_uring,
>> the easiest one to test is cmake with an io_uring enabled libuv (i.e., 
>> libuv
>> >= 1.45.0) which will hang.
>> 
>> I am aware that ia64 is in a vulnerable place right now which I why I 
>> am
>> keeping this spread limited.  Since this clearly involves
>> architecture-specific changes for parisc,
> 
> it isn't so much architecture-specific... (just one ifdef)
> 
>> is there any chance of looking at
>> what is required to do the same for ia64?  I looked at
>> 0ef36bd2b37815719e31a72d2beecc28ca8ecd26 ("parisc: change value of 
>> SHMLBA
>> from 0x00400000 to PAGE_SIZE") and tried to replicate the SHMLBA ->
>> SHM_COLOUR change, but it made no difference.
>> 
>> If hardware is necessary for testing, I can provide it, including 
>> remote BMC
>> access for restarts/kernel debugging.  Any takers?
> 
> I won't have time to test myself, but maybe you could test?
> 
> Basically we should try to find out why 
> io_uring_mmu_get_unmapped_area()
> doesn't return valid addresses, while arch_get_unmapped_area()
> [in arch/ia64/kernel/sys_ia64.c] does.
> 
> You could apply this patch first:
> It introduces a memory leak (as it requests memory twice), but maybe we
> get an idea?
> The ia64 arch_get_unmapped_area() searches for memory from bottom
> (flags=0), while io_uring function tries top-down first. Maybe that's
> the problem. And I don't understand the offset_in_page() check right
> now.
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 3bca7a79efda..93b1964d2bbb 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3431,13 +3431,17 @@ static unsigned long 
> io_uring_mmu_get_unmapped_area(struct file *filp,
>  	 * can happen with large stack limits and large mmap()
>  	 * allocations.
>  	 */
> +/* compare to arch_get_unmapped_area() in arch/ia64/kernel/sys_ia64.c 
> */
>  	addr = vm_unmapped_area(&info);
> -	if (offset_in_page(addr)) {
> +printk("io_uring_mmu_get_unmapped_area() address 1 is: %px\n", addr);
> +	addr = NULL;
> +	if (!addr) {
>  		info.flags = 0;
>  		info.low_limit = TASK_UNMAPPED_BASE;
>  		info.high_limit = mmap_end;
>  		addr = vm_unmapped_area(&info);
>  	}
> +printk("io_uring_mmu_get_unmapped_area() returns address %px\n", 
> addr);
> 
>  	return addr;
>  }
> 
> 
> Another option is to disable the call to 
> io_uring_nommu_get_unmapped_area())
> with the next patch. Maybe you could add printks() to ia64's 
> arch_get_unmapped_area()
> and check what it returns there?
> 
> @@ -3654,6 +3658,8 @@ static const struct file_operations io_uring_fops 
> = {
>  #ifndef CONFIG_MMU
>  	.get_unmapped_area = io_uring_nommu_get_unmapped_area,
>  	.mmap_capabilities = io_uring_nommu_mmap_capabilities,
> +#elif 0    /* IS_ENABLED(CONFIG_IA64) */
> +	.get_unmapped_area = NULL,
>  #else
>  	.get_unmapped_area = io_uring_mmu_get_unmapped_area,
>  #endif
> 
> Helge

Thanks Helge.  Sample output from that first patch:

[Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() address 1 
is: 1ffffffffff40000
[Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() returns 
address 2000000001e40000
[Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() address 1 
is: 1ffffffffff20000
[Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() returns 
address 2000000001f20000
[Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() address 1 
is: 1ffffffffff30000
[Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() returns 
address 2000000001f30000
[Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() address 1 
is: 1ffffffffff90000
[Wed Jul 12 13:09:50 2023] io_uring_mmu_get_unmapped_area() returns 
address 2000000001f90000

This pattern seems to be pretty stable, I tried instead just directly 
returning the result of a call to arch_get_unmapped_area() at the end of 
the function and it seems similar:

[Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area() would return 
address 1ffffffffffd0000
[Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would return 
address 2000000001f00000
[Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area() would return 
address 1ffffffffff00000
[Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would return 
address 1ffffffffff00000
[Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area() would return 
address 1fffffffffe20000
[Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would return 
address 2000000002000000
[Wed Jul 12 13:27:07 2023] io_uring_mmu_get_unmapped_area() would return 
address 1fffffffffe30000
[Wed Jul 12 13:27:07 2023] but arch_get_unmapped_area() would return 
address 2000000002100000

Is that enough of a clue to go on?
