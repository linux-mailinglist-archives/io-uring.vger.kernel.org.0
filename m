Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BC5699983
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 17:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjBPQL2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 11:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBPQL1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 11:11:27 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBB84D628
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 08:11:26 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id j4so819548iog.8
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 08:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vAhrdbinbCScFKrN/jJtdasED0sinl5gepWbixHt3Sw=;
        b=HWocl2yodqCYB2rWMZAbYWtVZTQnME1F6Kpzzlt+ki5xQbnQTYdq3X44/kfzHeoNIq
         G4fg70VWYDCoBkg+/Ucb7Wh0BlNbwyXa5uTy/V/QlRp2xkw/VexMP85eZQ2IFe45CQON
         wuLoNooU6WvhJaEPQlWN36aRPfMDlh8qyKAsVLUA5Fkk4MUAhsbAPUjhW31v49yFTtdB
         LqXeoxVRXbxX9myedLPQSs0ZJY/0tX0/yL5F3SfE7mDwJb0eRGYnmmkAEcmct1wmxAhO
         BP/Xz7qkQx/MbhlJFcw0AdZbaQg4SVLMV1RT5XHyg67wqWuFVVTUAfk1Ok8iZULRcjDc
         aKbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vAhrdbinbCScFKrN/jJtdasED0sinl5gepWbixHt3Sw=;
        b=GVbc+USsuGs/WmNK7AIVUQd/jLLm7o2IPKQjZK211Suw1XguJdpYnEB1rkA2PDDrKK
         4Ncfm+ViMc5Cz4DoGS0zyN6qZsCaxs8PPIMrICWD6e4/B0s/Dp+s0KKLdS61Iq3W1INO
         k+3HWEq569ceMccJQVoR9bfKZFJyt/UsaB+e4G+2iTHaY/6ropRJKAnr6HwiMLxvl1Wk
         YO7aJjeNXkoag3RBNb3OCD4eitsBypFm7sLxMLfRe4sLW798Ami4o5hTrOLB2rxE1G55
         lgyKp6uMUGhh6CHRPdBLoqK7PZak+X8RSIJ3cuknMNwjYlLhA55lTfkUkl/s2AYmGn+Y
         R2OA==
X-Gm-Message-State: AO0yUKWmVr9hN+TKawmY24k3BypmZs/4KIrcIFZhlwL3fjc79cR2j+6f
        vPdgmICsgOg2B1oNp4WQGuOdX/QK0rKIhVHO
X-Google-Smtp-Source: AK7set+IhFH7lYLD68zlKx3De9BcABqrBJ3Hy9pw4Yk/NxRbD7Hq/8XbV/HU89bKdBBug+ruFOrCBw==
X-Received: by 2002:a05:6602:5cd:b0:73a:6c75:5a85 with SMTP id w13-20020a05660205cd00b0073a6c755a85mr3796551iox.0.1676563885344;
        Thu, 16 Feb 2023 08:11:25 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g19-20020a02c553000000b00374fa5b600csm689443jaj.0.2023.02.16.08.11.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 08:11:24 -0800 (PST)
Message-ID: <47f1f4f3-36c8-a1f0-2d07-3f03454dfb35@kernel.dk>
Date:   Thu, 16 Feb 2023 09:11:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v2] io_uring: Adjust mapping wrt architecture aliasing
 requirements
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>
References: <Y+3kwh8BokobVl6o@p100>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y+3kwh8BokobVl6o@p100>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/16/23 1:09?AM, Helge Deller wrote:
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
>  #include <linux/io_uring.h>
>  #include <linux/audit.h>
>  #include <linux/security.h>
> +#include <asm/shmparam.h>
> 
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/io_uring.h>
> @@ -3059,6 +3060,54 @@ static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
>  	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
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
> +	 * aliasing rules. Userspace is not able to guess the offset address of
> +	 * kernel kmalloc()ed memory area.
> +	 */
> +	if (addr)
> +		return -EINVAL;

Can we relax this so that if the address is correctly aligned, it will
allow it? The reported issue with sqpoll-cancel-hang.t is due to it
crashing because it's a weird syzbot thing that does mmap() with
MAP_FIXED and an address given.

-- 
Jens Axboe

