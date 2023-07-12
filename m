Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5A374FE87
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 06:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjGLE7V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 00:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjGLE7V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 00:59:21 -0400
X-Greylist: delayed 925 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 11 Jul 2023 21:59:16 PDT
Received: from matoro.tk (unknown [IPv6:2600:1700:4b10:9d80::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7150F10C7;
        Tue, 11 Jul 2023 21:59:16 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; bh=AmT1aKMPK3gKXs7To3pWHL7mFVXHJwu4qHL/FOUhizU=;
 c=relaxed/relaxed; d=matoro.tk;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@matoro.tk; s=20230516; t=1689137029; v=1; x=1689569029;
 b=rRss77qfVCKw89Q2KXKOka+BUVOa3JEY+rFpC+0QULQXIL0mYRZv2ny4XQVltTDlb3U82oVX
 lIkeYmIE9kpLVU+U+HJBjSedPG6GfqEHJYQUHbm3rFm/GI18hxPhn1myX0qL+csrcgIL72xuigH
 TCS2yS5GOolB7MBnaXB9CDreXfOORIUuEJRGV2GdE8R+05oxZBx1liKbW02UI4ZsfcqxP/1ZtZc
 zsIqJ0FsITOO6oLBbRH3swD1P4W7JXVrInuCNb+3wO61v+HrKxzsQOEKt9qXihGgVLgvniWJQww
 DJO3halzoGboGaF2Qf74908qQouswzS3eGCUqCm3rfjmNrXTllzhYALJvX0sAOGzJDQBpTHLazZ
 F+yFqyH/75JabQ9lDJMLJTpOmpN0e7fiMJKSrHwfCRIeyEn+cbSQTfwThVIH9ojN/VV851OfWCQ
 EywODCF0Y63r4Y2TqSymZG4ja6bFNkmpmGu+FKzQcCDza/F2gNS6tVJUZcEnYsgU1sAAx530PsT
 mKDrChXr+d08U/FcU+4Io2Y15o7C6vEYiP6lHVLtI6RL/odnuPTHlvt1DE/5PHx6MDj7zeFuzph
 TE68gygYnCmDbXJW7adytx2L1lOYLtzM0BWwk5VfQXoIpfEIgiHNirEaojmXUHYZMBdPEIEy4qb
 G47EiCHJZzY=
Received: by matoro.tk (envelope-sender
 <matoro_mailinglist_kernel@matoro.tk>) with ESMTPS id efb31db1; Wed, 12 Jul
 2023 00:43:49 -0400
MIME-Version: 1.0
Date:   Wed, 12 Jul 2023 00:43:49 -0400
From:   matoro <matoro_mailinglist_kernel@matoro.tk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, deller@gmx.de,
        Linux Ia64 <linux-ia64@vger.kernel.org>,
        glaubitz@physik.fu-berlin.de, Sam James <sam@gentoo.org>
Subject: Re: [PATCH 1/5] io_uring: Adjust mapping wrt architecture aliasing
 requirements
In-Reply-To: <20230314171641.10542-2-axboe@kernel.dk>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <20230314171641.10542-2-axboe@kernel.dk>
Message-ID: <1d5f8f99f39e2769b9c76fbc24e2cf50@matoro.tk>
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

On 2023-03-14 13:16, Jens Axboe wrote:
> From: Helge Deller <deller@gmx.de>
> 
> Some architectures have memory cache aliasing requirements (e.g. 
> parisc)
> if memory is shared between userspace and kernel. This patch fixes the
> kernel to return an aliased address when asked by userspace via mmap().
> 
> Signed-off-by: Helge Deller <deller@gmx.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/io_uring.c | 51 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 722624b6d0dc..3adecebbac71 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -72,6 +72,7 @@
>  #include <linux/io_uring.h>
>  #include <linux/audit.h>
>  #include <linux/security.h>
> +#include <asm/shmparam.h>
> 
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/io_uring.h>
> @@ -3317,6 +3318,54 @@ static __cold int io_uring_mmap(struct file 
> *file, struct vm_area_struct *vma)
>  	return remap_pfn_range(vma, vma->vm_start, pfn, sz, 
> vma->vm_page_prot);
>  }
> 
> +static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp,
> +			unsigned long addr, unsigned long len,
> +			unsigned long pgoff, unsigned long flags)
> +{
> +	const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
> +	struct vm_unmapped_area_info info;
> +	void *ptr;
> +
> +	/*
> +	 * Do not allow to map to user-provided address to avoid breaking the
> +	 * aliasing rules. Userspace is not able to guess the offset address 
> of
> +	 * kernel kmalloc()ed memory area.
> +	 */
> +	if (addr)
> +		return -EINVAL;
> +
> +	ptr = io_uring_validate_mmap_request(filp, pgoff, len);
> +	if (IS_ERR(ptr))
> +		return -ENOMEM;
> +
> +	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
> +	info.length = len;
> +	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
> +	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
> +#ifdef SHM_COLOUR
> +	info.align_mask = PAGE_MASK & (SHM_COLOUR - 1UL);
> +#else
> +	info.align_mask = PAGE_MASK & (SHMLBA - 1UL);
> +#endif
> +	info.align_offset = (unsigned long) ptr;
> +
> +	/*
> +	 * A failed mmap() very likely causes application failure,
> +	 * so fall back to the bottom-up function here. This scenario
> +	 * can happen with large stack limits and large mmap()
> +	 * allocations.
> +	 */
> +	addr = vm_unmapped_area(&info);
> +	if (offset_in_page(addr)) {
> +		info.flags = 0;
> +		info.low_limit = TASK_UNMAPPED_BASE;
> +		info.high_limit = mmap_end;
> +		addr = vm_unmapped_area(&info);
> +	}
> +
> +	return addr;
> +}
> +
>  #else /* !CONFIG_MMU */
> 
>  static int io_uring_mmap(struct file *file, struct vm_area_struct 
> *vma)
> @@ -3529,6 +3578,8 @@ static const struct file_operations io_uring_fops 
> = {
>  #ifndef CONFIG_MMU
>  	.get_unmapped_area = io_uring_nommu_get_unmapped_area,
>  	.mmap_capabilities = io_uring_nommu_mmap_capabilities,
> +#else
> +	.get_unmapped_area = io_uring_mmu_get_unmapped_area,
>  #endif
>  	.poll		= io_uring_poll,
>  #ifdef CONFIG_PROC_FS

Hi Jens, Helge - I've bisected a regression with io_uring on ia64 to 
this patch in 6.4.  Unfortunately this breaks userspace programs using 
io_uring, the easiest one to test is cmake with an io_uring enabled 
libuv (i.e., libuv >= 1.45.0) which will hang.

I am aware that ia64 is in a vulnerable place right now which I why I am 
keeping this spread limited.  Since this clearly involves 
architecture-specific changes for parisc, is there any chance of looking 
at what is required to do the same for ia64?  I looked at 
0ef36bd2b37815719e31a72d2beecc28ca8ecd26 ("parisc: change value of 
SHMLBA from 0x00400000 to PAGE_SIZE") and tried to replicate the SHMLBA 
-> SHM_COLOUR change, but it made no difference.

If hardware is necessary for testing, I can provide it, including remote 
BMC access for restarts/kernel debugging.  Any takers?

$ git bisect log
git bisect start
# status: waiting for both good and bad commits
# good: [eceb0b18ae34b399856a2dd1eee8c18b2341e6f0] Linux 6.3.12
git bisect good eceb0b18ae34b399856a2dd1eee8c18b2341e6f0
# status: waiting for bad commit, 1 good commit known
# bad: [59377679473491963a599bfd51cc9877492312ee] Linux 6.4.1
git bisect bad 59377679473491963a599bfd51cc9877492312ee
# good: [457391b0380335d5e9a5babdec90ac53928b23b4] Linux 6.3
git bisect good 457391b0380335d5e9a5babdec90ac53928b23b4
# bad: [cb6fe2ceb667eb78f252d473b03deb23999ab1cf] Merge tag 
'devicetree-for-6.4-2' of 
git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux
git bisect bad cb6fe2ceb667eb78f252d473b03deb23999ab1cf
# good: [f5468bec213ec2ad3f2724e3f1714b3bc7bf1515] Merge tag 
'regmap-v6.4' of 
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
git bisect good f5468bec213ec2ad3f2724e3f1714b3bc7bf1515
# good: [207296f1a03bfead0110ffc4f192f242100ce4ff] netfilter: nf_tables: 
allow to create netdev chain without device
git bisect good 207296f1a03bfead0110ffc4f192f242100ce4ff
# good: [85d7ab2463822a4ab096c0b7b59feec962552572] Merge tag 
'for-6.4-tag' of 
git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
git bisect good 85d7ab2463822a4ab096c0b7b59feec962552572
# bad: [b68ee1c6131c540a62ecd443be89c406401df091] Merge tag 'scsi-misc' 
of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
git bisect bad b68ee1c6131c540a62ecd443be89c406401df091
# bad: [48dc810012a6b4f4ba94073d6b7edb4f76edeb72] Merge tag 
'for-6.4/dm-changes' of 
git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm
git bisect bad 48dc810012a6b4f4ba94073d6b7edb4f76edeb72
# bad: [5b9a7bb72fddbc5247f56ede55d485fab7abdf92] Merge tag 
'for-6.4/io_uring-2023-04-21' of git://git.kernel.dk/linux
git bisect bad 5b9a7bb72fddbc5247f56ede55d485fab7abdf92
# good: [5c7ecada25d2086aee607ff7deb69e77faa4aa92] Merge tag 
'f2fs-for-6.4-rc1' of 
git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs
git bisect good 5c7ecada25d2086aee607ff7deb69e77faa4aa92
# bad: [6e7248adf8f7adb5e36ec1e91efcc85a83bf8aeb] io_uring: refactor 
io_cqring_wake()
git bisect bad 6e7248adf8f7adb5e36ec1e91efcc85a83bf8aeb
# bad: [2ad57931db641f3de627023afb8147a8ec0b41dc] io_uring: rename 
trace_io_uring_submit_sqe() tracepoint
git bisect bad 2ad57931db641f3de627023afb8147a8ec0b41dc
# bad: [efba1a9e653e107577a48157b5424878c46f2285] io_uring: Move from 
hlist to io_wq_work_node
git bisect bad efba1a9e653e107577a48157b5424878c46f2285
# bad: [ba56b63242d12df088ed9a701cad320e6b306dfe] io_uring/kbuf: move 
pinning of provided buffer ring into helper
git bisect bad ba56b63242d12df088ed9a701cad320e6b306dfe
# good: [d4755e15386c38e4ae532ace5acc29fbfaee42e7] io_uring: avoid 
hashing O_DIRECT writes if the filesystem doesn't need it
git bisect good d4755e15386c38e4ae532ace5acc29fbfaee42e7
# bad: [d808459b2e31bd5123a14258a7a529995db974c8] io_uring: Adjust 
mapping wrt architecture aliasing requirements
git bisect bad d808459b2e31bd5123a14258a7a529995db974c8
# first bad commit: [d808459b2e31bd5123a14258a7a529995db974c8] io_uring: 
Adjust mapping wrt architecture aliasing requirements
