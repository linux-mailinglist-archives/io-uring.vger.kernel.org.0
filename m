Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947C776DBA4
	for <lists+io-uring@lfdr.de>; Thu,  3 Aug 2023 01:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjHBXfZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Aug 2023 19:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjHBXfY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Aug 2023 19:35:24 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671E7FB
        for <io-uring@vger.kernel.org>; Wed,  2 Aug 2023 16:35:23 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-31757edd9edso281533f8f.2
        for <io-uring@vger.kernel.org>; Wed, 02 Aug 2023 16:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691019322; x=1691624122;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GO+90fzclJczyKE+cUhJClZTVU5eDVclNQ4EsCMB8CQ=;
        b=Vaz//sCJd54w/NuYmNBgj+SbwssqnJf+7vr2zjK5k2rbCM9KLpugWOapGhvyC725Du
         HNyMLoFdBp+jWgLUIQv/LZuRqZJIMDLoiJz3vfNvg/M5U5JZ1MX7lxasc1bQ4lpBaPP1
         YIhYwqY24nmuwiuJNrDDvQbqQJyc65wrSNRNf4/Q5R21sp79xSXKKd+Phy+PE5sTdvc2
         3faUa5Y5Eg7M5/HpsK1K8QwwSbkH7v7tsQIMPIi8cGDUQ5TPgKrgLNfSMxgcrQql/fdS
         mv/fcbYf81RfKRRC7jCqasIx4oXC6rJpqDijT66GGUFIUAyv8mRoXVFQpEPhUrT+7w4f
         Yfqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691019322; x=1691624122;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GO+90fzclJczyKE+cUhJClZTVU5eDVclNQ4EsCMB8CQ=;
        b=iG54sQL/WQBNa/rfSn58w/zNJWcDtDFiIRZT/9LT8rIDu9Z1U520N4fNfwO1WEPsak
         6Hgxyx6uYGltZt+fIKHbCctjVain+3WKSCViUjdHBUcSz1DOi7bBwvfxkJZx+e8R4/ZM
         ABxHZB9rbsfbYOTyRXkhvQ68pDHUYLbVNLzDYv4Dyb6LFeqMFvH+rcJjwKeIIyH4de/e
         iWs5CIyQj3e484Gv2Faph4Ln4cEjL9zIsjam4KR7r8enyECwQG1FHsZV1JVpvsbLFhTs
         3W4n/4Gj/V5l722Z4Z4+S6wZAlqPAiHcKMoqhPauyZ8SwQaSSr9peiEqiCiJOPxtJm3f
         ClhA==
X-Gm-Message-State: ABy/qLY2flO7nQiqps40aF78WA8LsRBCoqSHFmsGMHwRqd73EgIPwWFH
        qbSgti/XVbvfrUMjpAjpCLw=
X-Google-Smtp-Source: APBJJlHa1N/JMqjlr+codCx49T5SaCCAmgvLo8kgt1l+ytMw/4vHH6WppSWEs6uK7hhqDmbb51Vitw==
X-Received: by 2002:adf:e88f:0:b0:314:35e2:e28d with SMTP id d15-20020adfe88f000000b0031435e2e28dmr5494089wrm.13.1691019321600;
        Wed, 02 Aug 2023 16:35:21 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.233.139])
        by smtp.gmail.com with ESMTPSA id m12-20020adff38c000000b00313f031876esm20288800wro.43.2023.08.02.16.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Aug 2023 16:35:21 -0700 (PDT)
Message-ID: <31e581d0-2038-684c-0941-2c06d713cbeb@gmail.com>
Date:   Thu, 3 Aug 2023 00:30:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: annotate the struct io_kiocb slab for
 appropriate user copy
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     Breno Leitao <leitao@debian.org>
References: <db807b6b-76ca-4101-844a-aa6da1467b98@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <db807b6b-76ca-4101-844a-aa6da1467b98@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/2/23 21:42, Jens Axboe wrote:
> When compiling the kernel with clang and having HARDENED_USERCOPY
> enabled, the liburing openat2.t test case fails during request setup:
> 
> usercopy: Kernel memory overwrite attempt detected to SLUB object 'io_kiocb' (offset 24, size 24)!
> ------------[ cut here ]------------
> kernel BUG at mm/usercopy.c:102!
> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> CPU: 3 PID: 413 Comm: openat2.t Tainted: G                 N 6.4.3-g6995e2de6891-dirty #19
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.1-0-g3208b098f51a-prebuilt.qemu.org 04/01/2014
> RIP: 0010:usercopy_abort+0x84/0x90
> Code: ce 49 89 ce 48 c7 c3 68 48 98 82 48 0f 44 de 48 c7 c7 56 c6 94 82 4c 89 de 48 89 c1 41 52 41 56 53 e8 e0 51 c5 00 48 83 c4 18 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 41 57 41 56
> RSP: 0018:ffffc900016b3da0 EFLAGS: 00010296
> RAX: 0000000000000062 RBX: ffffffff82984868 RCX: 4e9b661ac6275b00
> RDX: ffff8881b90ec580 RSI: ffffffff82949a64 RDI: 00000000ffffffff
> RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffc900016b3c88 R11: ffffc900016b3c30 R12: 00007ffe549659e0
> R13: ffff888119014000 R14: 0000000000000018 R15: 0000000000000018
> FS:  00007f862e3ca680(0000) GS:ffff8881b90c0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005571483542a8 CR3: 0000000118c11000 CR4: 00000000003506e0
> Call Trace:
>   <TASK>
>   ? __die_body+0x63/0xb0
>   ? die+0x9d/0xc0
>   ? do_trap+0xa7/0x180
>   ? usercopy_abort+0x84/0x90
>   ? do_error_trap+0xc6/0x110
>   ? usercopy_abort+0x84/0x90
>   ? handle_invalid_op+0x2c/0x40
>   ? usercopy_abort+0x84/0x90
>   ? exc_invalid_op+0x2f/0x40
>   ? asm_exc_invalid_op+0x16/0x20
>   ? usercopy_abort+0x84/0x90
>   __check_heap_object+0xe2/0x110
>   __check_object_size+0x142/0x3d0
>   io_openat2_prep+0x68/0x140
>   io_submit_sqes+0x28a/0x680
>   __se_sys_io_uring_enter+0x120/0x580
>   do_syscall_64+0x3d/0x80
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x55714834de26
> Code: ca 01 0f b6 82 d0 00 00 00 8b ba cc 00 00 00 45 31 c0 31 d2 41 b9 08 00 00 00 83 e0 01 c1 e0 04 41 09 c2 b8 aa 01 00 00 0f 05 <c3> 66 0f 1f 84 00 00 00 00 00 89 30 eb 89 0f 1f 40 00 8b 00 a8 06
> RSP: 002b:00007ffe549659c8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: ffffffffffffffda RBX: 00007ffe54965a50 RCX: 000055714834de26
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000008
> R10: 0000000000000000 R11: 0000000000000246 R12: 000055714834f057
> R13: 00007ffe54965a50 R14: 0000000000000001 R15: 0000557148351dd8
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:usercopy_abort+0x84/0x90
> Code: ce 49 89 ce 48 c7 c3 68 48 98 82 48 0f 44 de 48 c7 c7 56 c6 94 82 4c 89 de 48 89 c1 41 52 41 56 53 e8 e0 51 c5 00 48 83 c4 18 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 41 57 41 56
> RSP: 0018:ffffc900016b3da0 EFLAGS: 00010296
> RAX: 0000000000000062 RBX: ffffffff82984868 RCX: 4e9b661ac6275b00
> RDX: ffff8881b90ec580 RSI: ffffffff82949a64 RDI: 00000000ffffffff
> RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffc900016b3c88 R11: ffffc900016b3c30 R12: 00007ffe549659e0
> R13: ffff888119014000 R14: 0000000000000018 R15: 0000000000000018
> FS:  00007f862e3ca680(0000) GS:ffff8881b90c0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005571483542a8 CR3: 0000000118c11000 CR4: 00000000003506e0
> Kernel panic - not syncing: Fatal exception
> Kernel Offset: disabled
> ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> when it tries to copy struct open_how from userspace into the per-command
> space in the io_kiocb. There's nothing wrong with the copy, but we're
> missing the appropriate annotations for allowing user copies to/from the
> io_kiocb slab.
> 
> Allow copies in the per-command area, which is from the 'file' pointer to
> when 'opcode' starts. We do have existing user copies there, but they are
> not all annotated like the one that openat2_prep() uses,
> copy_struct_from_user(). But in practice opcodes should be allowed to
> copy data into their per-command area in the io_kiocb.
> 
> Reported-by: Breno Leitao <leitao@debian.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 135da2fd0eda..d8e69461786d 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -4627,8 +4627,20 @@ static int __init io_uring_init(void)
>   
>   	io_uring_optable_init();
>   
> -	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
> -				SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU);
> +	/*
> +	 * Allow user copy in the per-command field, which starts after the
> +	 * file in io_kiocb and until the opcode field. The openat2 handling
> +	 * requires copying in user memory into the io_kiocb object in that
> +	 * range, and HARDENED_USERCOPY will complain if we haven't
> +	 * correctly annotated this range.
> +	 */
> +	req_cachep = kmem_cache_create_usercopy("io_kiocb",
> +				sizeof(struct io_kiocb), 0,
> +				SLAB_HWCACHE_ALIGN | SLAB_PANIC |
> +				SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU,
> +				offsetof(struct io_kiocb, cmd.data),
> +				offsetof(struct io_kiocb, opcode) -
> +				offsetof(struct io_kiocb, cmd.data), NULL);

sizeof_field(struct io_kiocb, cmd.data)

should be less awkward

-- 
Pavel Begunkov
