Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EE228A034
	for <lists+io-uring@lfdr.de>; Sat, 10 Oct 2020 13:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgJJLgW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 07:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728984AbgJJKUC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 06:20:02 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D03C0613E8;
        Sat, 10 Oct 2020 03:10:26 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id d3so12097480wma.4;
        Sat, 10 Oct 2020 03:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+5Kk22A1F12ZCDKSgxuLiVNU0UIB3cywAG+dlY1imeQ=;
        b=eq7AarxeDEoSqYIc/cu4LdN3vXvJyPq0+41F5eXBCCQqrrI36cuYuYjFo90IC9A40G
         AF8MKaxDqHmG8k/ylfp5hitQoiHpNQm2Cy8tmW54tqovxaTv2acIJFRT/aKqLYHDgHw6
         IpaGZfqA1iIbN6WQTZrdon9+HIXeNsKw0DMohQvEX2criIXnJG5Y9+i5eLXIyXLXxUiT
         Zi9YXaGh9CcAig13DI7P9H9XegQumHIxp6lXU6nKc8vs8vPQC27645kVnXhnBsBJWuhp
         5lDpcUsepHYbaSN6PeXf2um89U3t8i7ikxgKVxYjFKp2jDMSS5e7TawE3MzMkIjfzd8Z
         44ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+5Kk22A1F12ZCDKSgxuLiVNU0UIB3cywAG+dlY1imeQ=;
        b=icS0PY1Iyb/mOFEIL1C9P8zbdl3caR2zjDZNiuxNACxM9lwmPLoKQKht7dyxvk5pfP
         UvGKdb6s1c8ROT4TEbwTdTqb0jh3KJKswhRLEX+7tDFkMNcfZmS/2HV76MGY/pPKh0R7
         FQCsYduC+pNI3eznjkq4U0wMuTmnGw4APA4ax9ETC3OZhk6hCu1RcSt6hSsfkkSkKPM2
         mmWb+ozL+8syPymlCuMUncgS4kS5Vc+123iSySDiDxp6VkT17PBwVknavMWwa8iIv1ou
         9+rPanzQS61SxYHgS88gdX9HF7SjdH48sr3ZAllo0HghEDrt/csg4tv6gMNowWvZtCJR
         XStA==
X-Gm-Message-State: AOAM531hjlv12vXbXkVdf86Dm1bYSaJYPxX241VdZ+N0kFojvLEVgkns
        4P/2Ib6y7aCt6SAqmBEfOO3NpiwgZS/+3QfL
X-Google-Smtp-Source: ABdhPJznbleH2Zg/Q+gXbEw4ZFD2S3/C2VgCY65xN5MQ7lGZNIFYp2vCCFf4tdCMpa3Jl1PZtNBI3w==
X-Received: by 2002:a7b:c401:: with SMTP id k1mr2106929wmi.120.1602324624558;
        Sat, 10 Oct 2020 03:10:24 -0700 (PDT)
Received: from [10.247.113.199] ([217.163.2.179])
        by smtp.gmail.com with ESMTPSA id b25sm12693333wmj.21.2020.10.10.03.10.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2020 03:10:23 -0700 (PDT)
Subject: Re: [io_uring] b166b25674: BUG:KASAN:null-ptr-deref_in_i
To:     kernel test robot <lkp@intel.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        lkp@lists.01.org
References: <20201010094154.GA393@shao2-debian>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <17da1022-8918-0b6b-4492-685773b80b8d@gmail.com>
Date:   Sat, 10 Oct 2020 11:07:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201010094154.GA393@shao2-debian>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/10/2020 12:41, kernel test robot wrote:
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-9):
> 
> commit: b166b25674b991268afbe1bcbfee7d1eadf1203d ("io_uring: Fix XArray usage in io_uring_add_task_file")
> url: https://github.com/0day-ci/linux/commits/Matthew-Wilcox-Oracle/io_uring-Fix-use-of-XArray-in-__io_uring_files_cancel/20201009-205103

The patch was fixed by Jens upon queueing into io_uring tree, see
https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.10/io_uring&id=236434c3438c4da3dfbd6aeeab807577b85e951a

> 
> 
> in testcase: trinity
> version: trinity-static-x86_64-x86_64-f93256fb_2019-08-28
> with following parameters:
> 
> 	runtime: 300s
> 
> test-description: Trinity is a linux system call fuzz tester.
> test-url: http://codemonkey.org.uk/projects/trinity/
> 
> 
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 8G
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> +---------------------------------------------+------------+------------+
> |                                             | 0fcb19f37b | b166b25674 |
> +---------------------------------------------+------------+------------+
> | boot_successes                              | 4          | 0          |
> | boot_failures                               | 0          | 4          |
> | BUG:KASAN:null-ptr-deref_in_i               | 0          | 4          |
> | BUG:kernel_NULL_pointer_dereference,address | 0          | 4          |
> | Oops:#[##]                                  | 0          | 4          |
> | RIP:io_uring_add_task_file                  | 0          | 4          |
> | Kernel_panic-not_syncing:Fatal_exception    | 0          | 4          |
> +---------------------------------------------+------------+------------+
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> [   62.517646] BUG: KASAN: null-ptr-deref in io_uring_add_task_file+0x4c/0xe0
> [   62.519048] Read of size 8 at addr 00000000000000b0 by task trinity-c1/829
> [   62.523951] 
> [   62.524242] CPU: 1 PID: 829 Comm: trinity-c1 Not tainted 5.9.0-rc8-next-20201009-00002-gb166b25674b9 #2
> [   62.526099] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> [   62.527815] Call Trace:
> [   62.528308]  dump_stack+0xd1/0x119
> [   62.529059]  ? io_uring_add_task_file+0x4c/0xe0
> [   62.529957]  ? io_uring_add_task_file+0x4c/0xe0
> [   62.530314] random: get_random_u64 called from arch_pick_mmap_layout+0xb6/0x280 with crng_init=1
> [   62.530331] random: get_random_u64 called from arch_pick_mmap_layout+0x1d4/0x280 with crng_init=1
> [   62.534194]  kasan_report.cold+0x5/0x37
> [   62.535041]  ? io_uring_add_task_file+0x4c/0xe0
> [   62.535996]  io_uring_add_task_file+0x4c/0xe0
> [   62.536869]  io_uring_create+0xa0c/0xc60
> [   62.537703]  io_uring_setup+0xb6/0x120
> [   62.538429]  ? io_uring_create+0xc60/0xc60
> [   62.539309]  ? syscall_enter_from_user_mode+0x74/0xc0
> [   62.540382]  ? trace_hardirqs_on+0x48/0x120
> [   62.541262]  do_syscall_64+0x34/0x50
> [   62.542051]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   62.543035] RIP: 0033:0x453b29
> [   62.543562] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 84 00 00 c3 66 2e 0f 1f 84 00 00 00 00
> [   62.547371] RSP: 002b:00007ffc0a17d778 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
> [   62.565017] RAX: ffffffffffffffda RBX: 00000000000001a9 RCX: 0000000000453b29
> [   62.566269] RDX: 00000000000000e7 RSI: 00007f36ac820000 RDI: 00000000000000cf
> [   62.567534] RBP: 00007ffc0a17d820 R08: 00000000c00000ce R09: 00000000000000bb
> [   62.568803] R10: 000000000000ff93 R11: 0000000000000246 R12: 0000000000000002
> [   62.570093] R13: 00007f36acb4e058 R14: 0000000001afd830 R15: 00007f36acb4e000
> [   62.571485] ==================================================================
> [   62.572888] Disabling lock debugging due to kernel taint
> [   62.574137] BUG: kernel NULL pointer dereference, address: 00000000000000b0
> [   62.575657] #PF: supervisor read access in kernel mode
> [   62.576757] #PF: error_code(0x0000) - not-present page
> [   62.577826] PGD 8000000125f81067 P4D 8000000125f81067 PUD 10c4f8067 PMD 0 
> [   62.579272] Oops: 0000 [#1] SMP KASAN PTI
> [   62.590855] CPU: 1 PID: 829 Comm: trinity-c1 Tainted: G    B             5.9.0-rc8-next-20201009-00002-gb166b25674b9 #2
> [   62.592683] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> [   62.594078] RIP: 0010:io_uring_add_task_file+0x4c/0xe0
> [   62.594962] Code: e8 69 70 f1 ff 49 8b ac 24 e8 05 00 00 48 85 ed 0f 84 89 00 00 00 e8 13 4b d1 ff 4c 8d a5 b0 00 00 00 4c 89 e7 e8 44 70 f1 ff <48> 39 9d b0 00 00 00 74 29 e8 f6 4a d1 ff 48 89 de 48 89 ef e8 ab
> [   62.597942] RSP: 0018:ffff8881180b7db0 EFLAGS: 00010282
> [   62.598810] RAX: 0000000000000001 RBX: ffff88811bb9c7c0 RCX: ffffffff81192dd3
> [   62.600042] RDX: 0000000000000000 RSI: ffffffff8127c238 RDI: ffffffff823657c9
> [   62.601200] RBP: 0000000000000000 R08: ffffffff81192dc4 R09: fffffbfff0722d8d
> [   62.602476] R10: ffffffff83916c63 R11: fffffbfff0722d8c R12: 00000000000000b0
> [   62.603680] R13: ffff8881180b7e6c R14: ffff8881268b8aa8 R15: ffff88811bb9c7c0
> [   62.604885] FS:  0000000001afd880(0000) GS:ffff8881f7200000(0000) knlGS:0000000000000000
> [   62.609926] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   62.611890] CR2: 00000000000000b0 CR3: 000000010d07e000 CR4: 00000000000406a0
> [   62.614187] DR0: 00007f36ac420000 DR1: 0000000000000000 DR2: 0000000000000000
> [   62.616402] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [   62.617646] Call Trace:
> [   62.618083]  io_uring_create+0xa0c/0xc60
> [   62.618744]  io_uring_setup+0xb6/0x120
> [   62.630890]  ? io_uring_create+0xc60/0xc60
> [   62.633250]  ? syscall_enter_from_user_mode+0x74/0xc0
> [   62.635172]  ? trace_hardirqs_on+0x48/0x120
> [   62.644116]  do_syscall_64+0x34/0x50
> [   62.644736]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   62.645564] RIP: 0033:0x453b29
> [   62.646478] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 84 00 00 c3 66 2e 0f 1f 84 00 00 00 00
> [   62.658096] RSP: 002b:00007ffc0a17d778 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
> [   62.659354] RAX: ffffffffffffffda RBX: 00000000000001a9 RCX: 0000000000453b29
> [   62.660754] RDX: 00000000000000e7 RSI: 00007f36ac820000 RDI: 00000000000000cf
> [   62.661911] RBP: 00007ffc0a17d820 R08: 00000000c00000ce R09: 00000000000000bb
> [   62.663066] R10: 000000000000ff93 R11: 0000000000000246 R12: 0000000000000002
> [   62.664242] R13: 00007f36acb4e058 R14: 0000000001afd830 R15: 00007f36acb4e000
> [   62.665397] Modules linked in: input_leds led_class parport_pc qemu_fw_cfg
> [   62.666562] CR2: 00000000000000b0
> [   62.667344] ---[ end trace b0d4015dae9c12ae ]---
> 
> 
> To reproduce:
> 
>         # build kernel
> 	cd linux
> 	cp config-5.9.0-rc8-next-20201009-00002-gb166b25674b9 .config
> 	make HOSTCC=gcc-9 CC=gcc-9 ARCH=x86_64 olddefconfig prepare modules_prepare bzImage
> 
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         bin/lkp qemu -k <bzImage> job-script # job-script is attached in this email
> 
> 
> 
> Thanks,
> lkp
> 

-- 
Pavel Begunkov
