Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B58C76DD3F
	for <lists+io-uring@lfdr.de>; Thu,  3 Aug 2023 03:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjHCBeJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Aug 2023 21:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjHCBeG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Aug 2023 21:34:06 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC00173F
        for <io-uring@vger.kernel.org>; Wed,  2 Aug 2023 18:34:04 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b89b0c73d7so866725ad.1
        for <io-uring@vger.kernel.org>; Wed, 02 Aug 2023 18:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691026443; x=1691631243;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MjM7+yRE9kopuhFoJKw8FUMo42U1oI4AyrW1Df4YQEc=;
        b=LXZZocwB6hr+LQNc0MRQeaOhRs6td4qYwzOfpGDU2w5zbj67p4hMMTVyLhhVvwVMmq
         +wsJM+vHzqk0uVh+ZaD3Cb6D4wo0TAJkjmul9pgrZ+ss0kmMD4CjOGLwMBTHZsfNpWtA
         gTDN8Pk4O+eGI3xwwEBg3aZWHNOaDqjUB8FJZDyP09kiAgDYf1aZPpdwfmcv6d0zP4lb
         ih+JvGgbGkaUXBR2YFyLdvIVVEuZQO5nvf+Lgae+StofFGkyd2ZXIP81i5mgpdHBOUE4
         2nLqBEg8yLhFOLEkEm1C2Hk6CeZzaenwt/9D+tUHR7ZKBJesf5nSOe2OeUPSTQnmTKMO
         a5OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691026443; x=1691631243;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MjM7+yRE9kopuhFoJKw8FUMo42U1oI4AyrW1Df4YQEc=;
        b=gUnn+jBusspdmmYszrCSiKynoN0Tk4pm81M9m9xeg3iHKKKwe/EI7+TZwEf2vCDMLH
         RCQ1G8Ksi+zd1k9X6hbC3OI9ymBU6c43dJKSR7NWoh6STSUKqrN4TQVQ6Kl5g7I4A2W6
         ZFBR1LIxoGUbv8t8y9wtEU60Y1+Y9zerWxx8zPM3ZIAyfD/LZ/YcPQbjsrIieBCSFImp
         jp1a9HIshxT3RN2YDZCTj+rzWFrhur8Yh3VPKZirC1pGRHW423D/pAs6Q8zd80G2aOiJ
         83fWBsZgqXNr5viA+SJ/SlheNxT5qh6bJad0XQ/E4fpRmdh5ptv95Tmi29ExJIlTrTDc
         T+PQ==
X-Gm-Message-State: ABy/qLY697l0vcMGVNAz3ey/UVILu4gYhCRQj3BVVq+lxGH4VtSWcNqu
        6Yv3e4+ZwHliIVzwctWr/0YdnA==
X-Google-Smtp-Source: APBJJlECZUKepa0LSw+QHWDSzXRqMgUERR8EHt9EPyqxMjVxflNulkf4PR7CsNjiex42nuY9nGFwkQ==
X-Received: by 2002:a17:902:e80e:b0:1b8:35fa:cdcc with SMTP id u14-20020a170902e80e00b001b835facdccmr18257459plg.5.1691026443355;
        Wed, 02 Aug 2023 18:34:03 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jn13-20020a170903050d00b001b895a18472sm12979404plb.117.2023.08.02.18.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Aug 2023 18:34:02 -0700 (PDT)
Message-ID: <a420ea5f-44d1-312d-b86c-cf1f0ebc4f65@kernel.dk>
Date:   Wed, 2 Aug 2023 19:34:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH] io_uring: annotate the struct io_kiocb slab for
 appropriate user copy
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Breno Leitao <leitao@debian.org>
References: <db807b6b-76ca-4101-844a-aa6da1467b98@kernel.dk>
 <31e581d0-2038-684c-0941-2c06d713cbeb@gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <31e581d0-2038-684c-0941-2c06d713cbeb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/2/23 5:30?PM, Pavel Begunkov wrote:
> On 8/2/23 21:42, Jens Axboe wrote:
>> When compiling the kernel with clang and having HARDENED_USERCOPY
>> enabled, the liburing openat2.t test case fails during request setup:
>>
>> usercopy: Kernel memory overwrite attempt detected to SLUB object 'io_kiocb' (offset 24, size 24)!
>> ------------[ cut here ]------------
>> kernel BUG at mm/usercopy.c:102!
>> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> CPU: 3 PID: 413 Comm: openat2.t Tainted: G                 N 6.4.3-g6995e2de6891-dirty #19
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.1-0-g3208b098f51a-prebuilt.qemu.org 04/01/2014
>> RIP: 0010:usercopy_abort+0x84/0x90
>> Code: ce 49 89 ce 48 c7 c3 68 48 98 82 48 0f 44 de 48 c7 c7 56 c6 94 82 4c 89 de 48 89 c1 41 52 41 56 53 e8 e0 51 c5 00 48 83 c4 18 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 41 57 41 56
>> RSP: 0018:ffffc900016b3da0 EFLAGS: 00010296
>> RAX: 0000000000000062 RBX: ffffffff82984868 RCX: 4e9b661ac6275b00
>> RDX: ffff8881b90ec580 RSI: ffffffff82949a64 RDI: 00000000ffffffff
>> RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000000000
>> R10: ffffc900016b3c88 R11: ffffc900016b3c30 R12: 00007ffe549659e0
>> R13: ffff888119014000 R14: 0000000000000018 R15: 0000000000000018
>> FS:  00007f862e3ca680(0000) GS:ffff8881b90c0000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00005571483542a8 CR3: 0000000118c11000 CR4: 00000000003506e0
>> Call Trace:
>>   <TASK>
>>   ? __die_body+0x63/0xb0
>>   ? die+0x9d/0xc0
>>   ? do_trap+0xa7/0x180
>>   ? usercopy_abort+0x84/0x90
>>   ? do_error_trap+0xc6/0x110
>>   ? usercopy_abort+0x84/0x90
>>   ? handle_invalid_op+0x2c/0x40
>>   ? usercopy_abort+0x84/0x90
>>   ? exc_invalid_op+0x2f/0x40
>>   ? asm_exc_invalid_op+0x16/0x20
>>   ? usercopy_abort+0x84/0x90
>>   __check_heap_object+0xe2/0x110
>>   __check_object_size+0x142/0x3d0
>>   io_openat2_prep+0x68/0x140
>>   io_submit_sqes+0x28a/0x680
>>   __se_sys_io_uring_enter+0x120/0x580
>>   do_syscall_64+0x3d/0x80
>>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
>> RIP: 0033:0x55714834de26
>> Code: ca 01 0f b6 82 d0 00 00 00 8b ba cc 00 00 00 45 31 c0 31 d2 41 b9 08 00 00 00 83 e0 01 c1 e0 04 41 09 c2 b8 aa 01 00 00 0f 05 <c3> 66 0f 1f 84 00 00 00 00 00 89 30 eb 89 0f 1f 40 00 8b 00 a8 06
>> RSP: 002b:00007ffe549659c8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
>> RAX: ffffffffffffffda RBX: 00007ffe54965a50 RCX: 000055714834de26
>> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000003
>> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000008
>> R10: 0000000000000000 R11: 0000000000000246 R12: 000055714834f057
>> R13: 00007ffe54965a50 R14: 0000000000000001 R15: 0000557148351dd8
>>   </TASK>
>> Modules linked in:
>> ---[ end trace 0000000000000000 ]---
>> RIP: 0010:usercopy_abort+0x84/0x90
>> Code: ce 49 89 ce 48 c7 c3 68 48 98 82 48 0f 44 de 48 c7 c7 56 c6 94 82 4c 89 de 48 89 c1 41 52 41 56 53 e8 e0 51 c5 00 48 83 c4 18 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 41 57 41 56
>> RSP: 0018:ffffc900016b3da0 EFLAGS: 00010296
>> RAX: 0000000000000062 RBX: ffffffff82984868 RCX: 4e9b661ac6275b00
>> RDX: ffff8881b90ec580 RSI: ffffffff82949a64 RDI: 00000000ffffffff
>> RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000000000
>> R10: ffffc900016b3c88 R11: ffffc900016b3c30 R12: 00007ffe549659e0
>> R13: ffff888119014000 R14: 0000000000000018 R15: 0000000000000018
>> FS:  00007f862e3ca680(0000) GS:ffff8881b90c0000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00005571483542a8 CR3: 0000000118c11000 CR4: 00000000003506e0
>> Kernel panic - not syncing: Fatal exception
>> Kernel Offset: disabled
>> ---[ end Kernel panic - not syncing: Fatal exception ]---
>>
>> when it tries to copy struct open_how from userspace into the per-command
>> space in the io_kiocb. There's nothing wrong with the copy, but we're
>> missing the appropriate annotations for allowing user copies to/from the
>> io_kiocb slab.
>>
>> Allow copies in the per-command area, which is from the 'file' pointer to
>> when 'opcode' starts. We do have existing user copies there, but they are
>> not all annotated like the one that openat2_prep() uses,
>> copy_struct_from_user(). But in practice opcodes should be allowed to
>> copy data into their per-command area in the io_kiocb.
>>
>> Reported-by: Breno Leitao <leitao@debian.org>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 135da2fd0eda..d8e69461786d 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -4627,8 +4627,20 @@ static int __init io_uring_init(void)
>>         io_uring_optable_init();
>>   -    req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
>> -                SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU);
>> +    /*
>> +     * Allow user copy in the per-command field, which starts after the
>> +     * file in io_kiocb and until the opcode field. The openat2 handling
>> +     * requires copying in user memory into the io_kiocb object in that
>> +     * range, and HARDENED_USERCOPY will complain if we haven't
>> +     * correctly annotated this range.
>> +     */
>> +    req_cachep = kmem_cache_create_usercopy("io_kiocb",
>> +                sizeof(struct io_kiocb), 0,
>> +                SLAB_HWCACHE_ALIGN | SLAB_PANIC |
>> +                SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU,
>> +                offsetof(struct io_kiocb, cmd.data),
>> +                offsetof(struct io_kiocb, opcode) -
>> +                offsetof(struct io_kiocb, cmd.data), NULL);
> 
> sizeof_field(struct io_kiocb, cmd.data)
> 
> should be less awkward

Ah yes, good point. Updated below:

commit 8c57ecb0f5e58bcff0a8b7e984b77b261440b8c3
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Aug 2 14:38:01 2023 -0600

    io_uring: annotate the struct io_kiocb slab for appropriate user copy
    
    When compiling the kernel with clang and having HARDENED_USERCOPY
    enabled, the liburing openat2.t test case fails during request setup:
    
    usercopy: Kernel memory overwrite attempt detected to SLUB object 'io_kiocb' (offset 24, size 24)!
    ------------[ cut here ]------------
    kernel BUG at mm/usercopy.c:102!
    invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
    CPU: 3 PID: 413 Comm: openat2.t Tainted: G                 N 6.4.3-g6995e2de6891-dirty #19
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.1-0-g3208b098f51a-prebuilt.qemu.org 04/01/2014
    RIP: 0010:usercopy_abort+0x84/0x90
    Code: ce 49 89 ce 48 c7 c3 68 48 98 82 48 0f 44 de 48 c7 c7 56 c6 94 82 4c 89 de 48 89 c1 41 52 41 56 53 e8 e0 51 c5 00 48 83 c4 18 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 41 57 41 56
    RSP: 0018:ffffc900016b3da0 EFLAGS: 00010296
    RAX: 0000000000000062 RBX: ffffffff82984868 RCX: 4e9b661ac6275b00
    RDX: ffff8881b90ec580 RSI: ffffffff82949a64 RDI: 00000000ffffffff
    RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000000000
    R10: ffffc900016b3c88 R11: ffffc900016b3c30 R12: 00007ffe549659e0
    R13: ffff888119014000 R14: 0000000000000018 R15: 0000000000000018
    FS:  00007f862e3ca680(0000) GS:ffff8881b90c0000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 00005571483542a8 CR3: 0000000118c11000 CR4: 00000000003506e0
    Call Trace:
     <TASK>
     ? __die_body+0x63/0xb0
     ? die+0x9d/0xc0
     ? do_trap+0xa7/0x180
     ? usercopy_abort+0x84/0x90
     ? do_error_trap+0xc6/0x110
     ? usercopy_abort+0x84/0x90
     ? handle_invalid_op+0x2c/0x40
     ? usercopy_abort+0x84/0x90
     ? exc_invalid_op+0x2f/0x40
     ? asm_exc_invalid_op+0x16/0x20
     ? usercopy_abort+0x84/0x90
     __check_heap_object+0xe2/0x110
     __check_object_size+0x142/0x3d0
     io_openat2_prep+0x68/0x140
     io_submit_sqes+0x28a/0x680
     __se_sys_io_uring_enter+0x120/0x580
     do_syscall_64+0x3d/0x80
     entry_SYSCALL_64_after_hwframe+0x46/0xb0
    RIP: 0033:0x55714834de26
    Code: ca 01 0f b6 82 d0 00 00 00 8b ba cc 00 00 00 45 31 c0 31 d2 41 b9 08 00 00 00 83 e0 01 c1 e0 04 41 09 c2 b8 aa 01 00 00 0f 05 <c3> 66 0f 1f 84 00 00 00 00 00 89 30 eb 89 0f 1f 40 00 8b 00 a8 06
    RSP: 002b:00007ffe549659c8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
    RAX: ffffffffffffffda RBX: 00007ffe54965a50 RCX: 000055714834de26
    RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000003
    RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000008
    R10: 0000000000000000 R11: 0000000000000246 R12: 000055714834f057
    R13: 00007ffe54965a50 R14: 0000000000000001 R15: 0000557148351dd8
     </TASK>
    Modules linked in:
    ---[ end trace 0000000000000000 ]---
    
    when it tries to copy struct open_how from userspace into the per-command
    space in the io_kiocb. There's nothing wrong with the copy, but we're
    missing the appropriate annotations for allowing user copies to/from the
    io_kiocb slab.
    
    Allow copies in the per-command area, which is from the 'file' pointer to
    when 'opcode' starts. We do have existing user copies there, but they are
    not all annotated like the one that openat2_prep() uses,
    copy_struct_from_user(). But in practice opcodes should be allowed to
    copy data into their per-command area in the io_kiocb.
    
    Reported-by: Breno Leitao <leitao@debian.org>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 135da2fd0eda..e70cf5c2dc7f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4627,8 +4627,19 @@ static int __init io_uring_init(void)
 
 	io_uring_optable_init();
 
-	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
-				SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU);
+	/*
+	 * Allow user copy in the per-command field, which starts after the
+	 * file in io_kiocb and until the opcode field. The openat2 handling
+	 * requires copying in user memory into the io_kiocb object in that
+	 * range, and HARDENED_USERCOPY will complain if we haven't
+	 * correctly annotated this range.
+	 */
+	req_cachep = kmem_cache_create_usercopy("io_kiocb",
+				sizeof(struct io_kiocb), 0,
+				SLAB_HWCACHE_ALIGN | SLAB_PANIC |
+				SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU,
+				offsetof(struct io_kiocb, cmd.data),
+				sizeof_field(struct io_kiocb, cmd.data), NULL);
 
 #ifdef CONFIG_SYSCTL
 	register_sysctl_init("kernel", kernel_io_uring_disabled_table);

-- 
Jens Axboe

