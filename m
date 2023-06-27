Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5173F73FD8F
	for <lists+io-uring@lfdr.de>; Tue, 27 Jun 2023 16:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjF0OOs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Jun 2023 10:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjF0OOs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Jun 2023 10:14:48 -0400
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2ABDD;
        Tue, 27 Jun 2023 07:14:46 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-51d946d2634so3168810a12.3;
        Tue, 27 Jun 2023 07:14:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687875285; x=1690467285;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=an7J0hwuqPQSAn7P2uZk1B4J/zfKMTy4fTuFeR6jrO8=;
        b=jWdapPdkyDv54UpwYS/d0/fCYLLOm+EomoAzDnh9WETwUBfeTs1ZFO9xqcG6J/UXSb
         nNErSSpNTKuWsad85fuhcUoxmpyLmSPSDBNWm/O3d9Jw/AZUix4G2ueJEpOsc+ARlWba
         aaoGUqQ4r5RlBnAFdX+rwsvGYa7pmhYrBO6MWTqVeP3xCDL4HeMYFZatUUb5atKpYME7
         TZJKTvF2t9KOshanSnixZ0qQ+HyFyJ50bb5ipYMNwJe/+TNbAXoEHqGQut/r39oommLV
         e5s+iu6c7B40UId4fYizU+2QdEaIB/WC/nrous6U/XdcCLHGdkqCWbv5dT4c6w8BVFhM
         uioQ==
X-Gm-Message-State: AC+VfDz7Au9Tay5vK6BQOAXAhEV42N6DHcZhkk0A5WVGN0924KQLmISa
        NksNzfGW5oJWFsvi3DyOF0A=
X-Google-Smtp-Source: ACHHUZ7VXrLgUhwrWzk6/KfueRoIfZhcZ+Y/vW+FFPyDljzDvtAYuZQLU6Poa4kBj4QT8TElotMPcg==
X-Received: by 2002:aa7:de9a:0:b0:51b:dcb4:a9b3 with SMTP id j26-20020aa7de9a000000b0051bdcb4a9b3mr13713612edv.24.1687875284962;
        Tue, 27 Jun 2023 07:14:44 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:59? ([2a0b:e7c0:0:107::aaaa:59])
        by smtp.gmail.com with ESMTPSA id e2-20020a50ec82000000b0051dac65fa3csm628527edr.93.2023.06.27.07.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 07:14:44 -0700 (PDT)
Message-ID: <818c95bc-50f8-4b2e-d5ca-2511310de47c@kernel.org>
Date:   Tue, 27 Jun 2023 16:14:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2] io_uring: Adjust mapping wrt architecture aliasing
 requirements
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-parisc@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>
References: <Y+3kwh8BokobVl6o@p100>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <Y+3kwh8BokobVl6o@p100>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16. 02. 23, 9:09, Helge Deller wrote:
> Some architectures have memory cache aliasing requirements (e.g. parisc)
> if memory is shared between userspace and kernel. This patch fixes the
> kernel to return an aliased address when asked by userspace via mmap().
> 
> Signed-off-by: Helge Deller <deller@gmx.de>
> ---
> v2: Do not allow to map to a user-provided addresss. This forces
> programs to write portable code, as usually on x86 mapping to any
> address will succeed, while it will fail for most provided address if
> used on stricter architectures.
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 862e05e6691d..01fe7437a071 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -72,6 +72,7 @@
>   #include <linux/io_uring.h>
>   #include <linux/audit.h>
>   #include <linux/security.h>
> +#include <asm/shmparam.h>
> 
>   #define CREATE_TRACE_POINTS
>   #include <trace/events/io_uring.h>
> @@ -3059,6 +3060,54 @@ static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
>   	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
>   }
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
> +	 * aliasing rules. Userspace is not able to guess the offset address of
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

Hi,

this breaks compat (x86_32) on x86_64 in 6.4. When you run most liburing 
tests, you'll get ENOMEM, as this high_limit is something in 64-bit space...

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

So the found addr here is > TASK_SIZE - len for 32-bit bins. And 
get_unmapped_area() returns ENOMEM.

> +	if (offset_in_page(addr)) {
> +		info.flags = 0;
> +		info.low_limit = TASK_UNMAPPED_BASE;
> +		info.high_limit = mmap_end;
> +		addr = vm_unmapped_area(&info);
> +	}
> +
> +	return addr;
> +}

Reverting the whole commit helps of course. Even this completely 
incorrect hack helps:
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3398,7 +3398,7 @@ static unsigned long 
io_uring_mmu_get_unmapped_area(struct file *filp,
                         unsigned long addr, unsigned long len,
                         unsigned long pgoff, unsigned long flags)
  {
-       const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
+       const unsigned long mmap_end = in_32bit_syscall() ? 
task_size_32bit() : arch_get_mmap_end(addr, len, flags);
         struct vm_unmapped_area_info info;
         void *ptr;

@@ -3417,7 +3417,7 @@ static unsigned long 
io_uring_mmu_get_unmapped_area(struct file *filp,
         info.flags = VM_UNMAPPED_AREA_TOPDOWN;
         info.length = len;
         info.low_limit = max(PAGE_SIZE, mmap_min_addr);
-       info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
+       info.high_limit = in_32bit_syscall() ? task_size_32bit() : 
arch_get_mmap_base(addr, current->mm->mmap_base);
  #ifdef SHM_COLOUR
         info.align_mask = PAGE_MASK & (SHM_COLOUR - 1UL);
  #else


Any ideas? Note that the compat mmap apparently uses bottomup expansion. 
See:
         if (!in_32bit_syscall() && (flags & MAP_32BIT))
                 goto bottomup;

in arch_get_unmapped_area_topdown().

thanks,
-- 
js
suse labs

