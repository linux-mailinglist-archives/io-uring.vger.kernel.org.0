Return-Path: <io-uring+bounces-2168-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B3E690482A
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 03:11:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 270641C212B6
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 01:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841AA110A;
	Wed, 12 Jun 2024 01:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EHsP9XwS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1E6A21;
	Wed, 12 Jun 2024 01:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718154712; cv=none; b=EPqP4qNHRrzrpSLfz9Toj9lrwdQoTTH5O6TgMFW1/WDOf7npTqXXoWHDyvUFG58ypH5Fr1+UYMSrPcJF13aSBLHvaDrgj1v9iLCxSTpLDILKN0CjdtATbRT/6TOWTCaQi25S1otOfgsVs3VE4//XAWnDHh1gi+ga0YMUsI6t2O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718154712; c=relaxed/simple;
	bh=AuoWTM308a4ddqLr2CqCB9Pa0CBAC1Ih0NLAibB3G2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kbLI+guUH6D0WIzW5tV1UkBmDmWjIVgwD81jl9zbbrTdKNSb/C/PB5J+5owNOe57fTCil6LmuIiXMZyQ83jVPTOoDXXXtMqiT78oy5CPT4h6p1INfIFk6ipSFZsurf0ImxZM6unr6oObLgTxGBGoUoy0nCjVd1GbZfTtYw90Fmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EHsP9XwS; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-421cd1e5f93so12368685e9.0;
        Tue, 11 Jun 2024 18:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718154709; x=1718759509; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7d11LKfvLeHcEozOedKWvtfpPHsBeXWZUr1XaIZCiME=;
        b=EHsP9XwSxrzrU4eI856QrdPEkSUG7cCi8ASy6iLONRMJRMFljDM6T8i2bEGN81o+BS
         DXVJ/du5hOSGEZ+XQ31vNzPCviRd13WZl5dcNI1mzc08Y3RznhIi1jNmxyDERH4Agn5w
         yXt43f3NtjCE2ZShlYz5XJWI8uomDyi677jVAflL9hEcPpqjTa29Pqcf+7lb720ZlYd9
         JY8rMjH/ZGXJLoxur8gRIsOPYtt+D9CE9+XudUle7PTbgl+7nDG7I7m1dArzjiQ+VwfM
         PMcALm6OUnEEzOVWkefBsh9Qev2oZdcKRz2U09MMHCFbwc9JxdoJwn2wPIUinzd0HWaW
         TZWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718154709; x=1718759509;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7d11LKfvLeHcEozOedKWvtfpPHsBeXWZUr1XaIZCiME=;
        b=klKaUd+8Yyhhd7sQCYCoY3Qjm06VosVGj8w5/H73nf60wBZrIVZVgisrdsEQonZdc2
         gP8f6RvZhmUCZrYtK2CySRDUOHOGNh6mYhdI4g5AD3tDb71nzTQSzXYoRa9iYXPAnJ/D
         NFel2GvpKAD5DNPdG/Zwwj1nuERCC1bBTYmeJx4pdbf4SyV4+VH/SPDdH3QZV+TbVkVF
         7MiR/ZDvxMkCdBjjc1dibXjuMJGoBsc27Z4oHDMsmtVt5vqcKjUrI9cwBlojWL+Qe/ac
         Pqj5/zFH9qjc3UyS7K6FL6RWc7mHkvpOEYyUxcOAcOo25n9u/caGvA4Xqdu33sfkm//v
         9ZaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJgmQ5JEEwwigYmUWimDe93/fejklulq/usV+ewPXjwHudfflCrSMcuV3TjAnLRtHsXHm63WKlCzFad9pxgLZFjDe51IS3GZB4XFrEY0m44TdohP4tR8nm/6oAWi5ss53fAsPGUrA=
X-Gm-Message-State: AOJu0YxwVF6lony4v3lrm+62iYEe/ZO59q9I8zoGfjDqXPWUuCH60130
	cfoi1VOcM0mvCgtupjaBcfhPUK+wHHkojAooHswpYT+wKAxmNZ8q
X-Google-Smtp-Source: AGHT+IG7KPkOQaPKItxbq5S6rjs0+RPChr3c3Cu08IRL58d+6EDJCP3Ie3Tw3thQDYmjEfpuPpSmiQ==
X-Received: by 2002:a05:600c:4ed4:b0:41b:f979:e19b with SMTP id 5b1f17b1804b1-422866bda05mr3927335e9.39.1718154708724;
        Tue, 11 Jun 2024 18:11:48 -0700 (PDT)
Received: from [192.168.42.217] ([85.255.235.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422871ec9e6sm5459435e9.38.2024.06.11.18.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jun 2024 18:11:48 -0700 (PDT)
Message-ID: <4fd9cd27-487d-4a23-b17a-aa9dcb09075f@gmail.com>
Date: Wed, 12 Jun 2024 02:11:54 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [io-uring] WARNING in io_fill_cqe_req_aux
To: chase xd <sl1589472800@gmail.com>, axboe@kernel.dk,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CADZouDQx4tqCfCfmCHjUp9nhAJ8_qTX=cCYOFzMYiQQwtsNuag@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADZouDQx4tqCfCfmCHjUp9nhAJ8_qTX=cCYOFzMYiQQwtsNuag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/24 18:07, chase xd wrote:
> Dear Linux kernel maintainers,
> 
> Syzkaller reports this previously unknown bug on Linux
> 6.8.0-rc3-00043-ga69d20885494-dirty #4. Seems like the bug was
> silently or unintendedly fixed in the latest version.

That branch you're using is confusing, apart from being
dirty and rc3, apparently it has never been merged. The
patch the test fails on looks different upstream:


commit 902ce82c2aa130bea5e3feca2d4ae62781865da7
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Mon Mar 18 22:00:32 2024 +0000

     io_uring: get rid of intermediate aux cqe caches


It reproduces with your version but not with anything
upstream


> ```
> Syzkaller hit 'WARNING in io_fill_cqe_req_aux' bug.
> 
> ------------[ cut here ]------------
> WARNING: CPU: 7 PID: 8369 at io_uring/io_uring.h:132
> io_lockdep_assert_cq_locked+0x2c7/0x340 io_uring/io_uring.h:132
> Modules linked in:
> CPU: 7 PID: 8369 Comm: syz-executor263 Not tainted
> 6.8.0-rc3-00043-ga69d20885494-dirty #4
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RIP: 0010:io_lockdep_assert_cq_locked+0x2c7/0x340 io_uring/io_uring.h:132
> Code: 48 8d bb 98 03 00 00 be ff ff ff ff e8 52 45 4b 06 31 ff 89 c3
> 89 c6 e8 b7 e2 2d fd 85 db 0f 85 d5 fe ff ff e8 0a e7 2d fd 90 <0f> 0b
> 90 e9 c7 fe ff ff e8 fc e6 2d fd e8 c7 38 fa fc 48 85 c0 0f
> RSP: 0018:ffffc90012af79a8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff845cf059
> RDX: ffff8880252ea440 RSI: ffffffff845cf066 RDI: 0000000000000005
> RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
> FS:  00005555570e13c0(0000) GS:ffff88823bd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1bdbcae020 CR3: 0000000022624000 CR4: 0000000000750ef0
> PKRU: 55555554
> Call Trace:
>   <TASK>
>   io_fill_cqe_req_aux+0xd6/0x1f0 io_uring/io_uring.c:925
>   io_poll_check_events io_uring/poll.c:325 [inline]
>   io_poll_task_func+0x16f/0x1000 io_uring/poll.c:357
>   io_handle_tw_list+0x172/0x560 io_uring/io_uring.c:1154
>   tctx_task_work_run+0xaa/0x330 io_uring/io_uring.c:1226
>   tctx_task_work+0x7b/0xd0 io_uring/io_uring.c:1244
>   task_work_run+0x16d/0x260 kernel/task_work.c:180
>   get_signal+0x1cb/0x25a0 kernel/signal.c:2669
>   arch_do_signal_or_restart+0x81/0x7e0 arch/x86/kernel/signal.c:310
>   exit_to_user_mode_loop kernel/entry/common.c:105 [inline]
>   exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
>   __syscall_exit_to_user_mode_work kernel/entry/common.c:201 [inline]
>   syscall_exit_to_user_mode+0x156/0x2b0 kernel/entry/common.c:212
>   do_syscall_64+0xe5/0x270 arch/x86/entry/common.c:89
>   entry_SYSCALL_64_after_hwframe+0x6f/0x77
> RIP: 0033:0x7f1bdbc2d88d
> Code: c3 e8 a7 1f 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd12f6fa18 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: 0000000000000001 RBX: 000000000000220b RCX: 00007f1bdbc2d88d
> RDX: 0000000000000000 RSI: 0000000000005012 RDI: 0000000000000003
> RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> R13: 431bde82d7b634db R14: 00007f1bdbcaa4f0 R15: 0000000000000001
>   </TASK>
> 
> 
> Syzkaller reproducer:
> # {Threaded:false Repeat:true RepeatTimes:0 Procs:1 Slowdown:1
> Sandbox: SandboxArg:0 Leak:false NetInjection:false NetDevices:false
> NetReset:false Cgroups:false BinfmtMisc:false CloseFDs:false
> KCSAN:false DevlinkPCI:false NicVF:false USB:false VhciInjection:false
> Wifi:false IEEE802154:false Sysctl:false Swap:false UseTmpDir:false
> HandleSegv:false Repro:false Trace:false LegacyOptions:{Collide:false
> Fault:false FaultCall:0 FaultNth:0}}
> r0 = syz_io_uring_setup(0x220b, &(0x7f0000000000)={0x0, 0x63db,
> 0x10000, 0x800}, &(0x7f0000000080)=<r1=>0x0,
> &(0x7f0000000200)=<r2=>0x0)
> r3 = socket$inet(0x2, 0x1, 0x0)
> syz_io_uring_submit(r1, r2,
> &(0x7f0000000a80)=@IORING_OP_POLL_ADD={0x6, 0x0, 0x0, @fd=r3, 0x0,
> 0x0, 0x1})
> io_uring_enter(r0, 0x5012, 0x0, 0x0, 0x0, 0x0)
> ```
> 
> crepro is in the attachment.
> 
> Best Regards
> Xdchase

-- 
Pavel Begunkov

