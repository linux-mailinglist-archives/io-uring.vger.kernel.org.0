Return-Path: <io-uring+bounces-5602-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E5749FC68F
	for <lists+io-uring@lfdr.de>; Wed, 25 Dec 2024 22:11:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 671AA7A13C7
	for <lists+io-uring@lfdr.de>; Wed, 25 Dec 2024 21:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D5D21922E6;
	Wed, 25 Dec 2024 21:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ur0mjdMS"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EAE14A0A8
	for <io-uring@vger.kernel.org>; Wed, 25 Dec 2024 21:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735161089; cv=none; b=NjHhXhgfXm5/FEpiXmuTldQg4ZMtxD2t0uOAhamwEbaS5kb5EuweNI16Y7i1LBaO42iATo6+F2Cf5pWVSs6TroG0zNrjtEqpO7pUExtvhIetdLZf9mYIphq1sjUjGOEJV1Qyojsz8rztrWt1doVL6cmYr7Osu6X9ovpbzQipx3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735161089; c=relaxed/simple;
	bh=VtN8E2rcBCiiFCOgSPHgXEL5TZ+iEgTWIlw8rJjWr10=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=SRXMF7VFccq5Zv7Z9kLbKJyNbVGv7LgTNEvCE8X3AwSw6bhg7si0Tyr4J6SMpxNWNweGjo1AJrmKakKYTZEM8kWXH0OGScLPXCHAwcG0LojB3y4jAJGeaf30osr6lpYS3vWwWwMi10BEI2DElwMTy8UNWL5EPtD795MgdHYGjCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ur0mjdMS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735161086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sCj7Ohh3EemdwzH3uNBVZ969b2D6w2JNfZwv7EsVsao=;
	b=Ur0mjdMS7NPsHzaM8uT/oMk/d0EDuI2WP0dsEgAeS+7ogaO9rzoUttcW9NmVVgiC98oHyC
	59rpZ+qxypKoYGRth5/yXLhncm3KAQRUuzDeDCLujr8/pqXzs1EF5xcMeoZPKHCvJBCnZr
	SMulx5yuwA8FtOH7ftdatrgSbV8p0tA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-HYHIupJkNvGbC1toSQHpDg-1; Wed, 25 Dec 2024 16:11:25 -0500
X-MC-Unique: HYHIupJkNvGbC1toSQHpDg-1
X-Mimecast-MFC-AGG-ID: HYHIupJkNvGbC1toSQHpDg
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6d899291908so196104666d6.0
        for <io-uring@vger.kernel.org>; Wed, 25 Dec 2024 13:11:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735161082; x=1735765882;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sCj7Ohh3EemdwzH3uNBVZ969b2D6w2JNfZwv7EsVsao=;
        b=XyReSb3WsNBVIk6eqT3MFVMjTlmEqH9xhZgIHBjOQ0RDP7CO7DQd0oI1nS1CLYcXMg
         AtAa46RTiA8KFpkr8fjEVydBy8ZVzIO9FsDQr4yGkaYwFfIENPRx/pCFnY3f37q48api
         4fcDHRV7IaAjOnupm35XZF9yulvHrev6RaW9Z1UJ7fwYdylgYuh4BheiLpytwkAklkmX
         3nU39vUUMutJUjvcSa0cxapJv0zUmxi1w+kz4eLsDpBpqqQGA6FjD4735qeXNjUJmV09
         iOtvKWvf0WBVPs+sCjwrDZZxE4qKRKkq9VUQB1Vd20+KE4UgZyVNe4dPs/q6b346ZMdP
         cm3Q==
X-Forwarded-Encrypted: i=1; AJvYcCX+XWHQihNi2TglCrdRKQ1O3ywOs0MVkniFeT4sN+Tv0/Xm9gcDwU8VwZqieNjRtWK+6Hy7sb/9lA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPB2f+vEXwmcSMqZSi7RK2pVlr7+n5g+6/KrcA/rk1pm+5vQhb
	FmGI1uq/+CXCet6lP7WgeVIMTS/gU4tKbEY5WsxfHAyFhIpBhkTKMvV5Iw8pGOmoKnirFfmBiIu
	t1dchsQaEY+3iWGRTgh2tNKPyRtHNOlWNYQOqjKRmfzVg3atQ4d/xVOZ9
X-Gm-Gg: ASbGncu9kyxj9nh2/mz+5xtxDHxvJI76dl3HK8Oc4wQS0YVF9aSEbPyP3KSvfJOGpZS
	X/qK+Ok4FwmlZzoiYNF71DiquIC/jKGvtK4uDNpvbY33UdToNeRuXxxGcHNFwzz1WpzD4M5K9e7
	e6i4757ZBcfvPTZxoJFtSHHougKfhOVS03OqLYxy8mmAMPqqFK62RkikJTTkHzzGpfmz6YpiD1Z
	kVcxRMtzkP0axToOsBYBL4nQG1sI4pc5nj6DeVllPl7bLGiJQ5XzDSbUkQ6e8xawcCfG4w8XAX+
	LW8/YtvXj98J2Cft8HvpIXHT
X-Received: by 2002:ad4:5c6c:0:b0:6d8:a856:133 with SMTP id 6a1803df08f44-6dd233360b9mr298119976d6.12.1735161082357;
        Wed, 25 Dec 2024 13:11:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGo3QQfF4AQKlAY++qw4+x/A4+w4xFeHtkzLjq1YvkQGKF8PPKQdZf5wAgU+i7SKfDM8azT1Q==
X-Received: by 2002:ad4:5c6c:0:b0:6d8:a856:133 with SMTP id 6a1803df08f44-6dd233360b9mr298119736d6.12.1735161081981;
        Wed, 25 Dec 2024 13:11:21 -0800 (PST)
Received: from ?IPV6:2601:188:ca00:a00:f844:fad5:7984:7bd7? ([2601:188:ca00:a00:f844:fad5:7984:7bd7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dd181c1e99sm64272906d6.93.2024.12.25.13.11.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Dec 2024 13:11:21 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <abe46bc0-d4a7-4076-bed8-c48e0267ebed@redhat.com>
Date: Wed, 25 Dec 2024 16:11:19 -0500
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: slab-use-after-free Read in try_to_wake_up
To: Kun Hu <huk23@m.fudan.edu.cn>, peterz@infradead.org, mingo@redhat.com,
 will@kernel.org, boqun.feng@gmail.com
Cc: linux-kernel@vger.kernel.org,
 "jjtan24@m.fudan.edu.cn" <jjtan24@m.fudan.edu.cn>,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org
References: <1CF89E16-3A37-494F-831C-5CA24BCEEE50@m.fudan.edu.cn>
Content-Language: en-US
In-Reply-To: <1CF89E16-3A37-494F-831C-5CA24BCEEE50@m.fudan.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/24/24 7:28 AM, Kun Hu wrote:
> Hello,
>
> When using fuzzer tool to fuzz the latest Linux kernel, the following crash
> was triggered.
>
> HEAD commit: 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8
> git tree: upstream
> Console output:https://drive.google.com/file/d/11IXj9a4uRbOaqIK90F2px6nLiHhJ04rw/view?usp=sharing
> Kernel config: https://drive.google.com/file/d/1RhT5dFTs6Vx1U71PbpenN7TPtnPoa3NI/view?usp=sharing
> C reproducer: https://drive.google.com/file/d/1BP2d5rfb4XBuq0njxKnS6d3AoysIiT61/view?usp=sharing
> Syzlang reproducer: https://drive.google.com/file/d/1lTQrXRQfndtigBiKBxelQeHszr2dzbLp/view?usp=sharing
> Similar report: https://lore.kernel.org/lkml/CALcu4rZOs3sbXBWARhjM6d8UngPUF3bU1CPmSZBugUpgaP_0WA@mail.gmail.com/T/
>
>
> This bug seems to have been reported and fixed in the old kernel, which seems to be a regression issue? If you fix this issue, please add the following tag to the commit:
> Reported-by: Kun Hu <huk23@m.fudan.edu.cn>
>
>
> ==================================================================
> BUG: KASAN: slab-use-after-free in __lock_acquire+0x370b/0x4a10 kernel/locking/lockdep.c:5089
> Read of size 8 at addr ff1100000289acb8 by task syz.6.1904/11159
>
> CPU: 1 UID: 0 PID: 11159 Comm: syz.6.1904 Not tainted 6.13.0-rc3 #3
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0x116/0x1b0 lib/dump_stack.c:120
> print_address_description mm/kasan/report.c:378 [inline]
> print_report+0xcf/0x5f0 mm/kasan/report.c:489
> kasan_report+0x93/0xc0 mm/kasan/report.c:602
> __lock_acquire+0x370b/0x4a10 kernel/locking/lockdep.c:5089
> lock_acquire kernel/locking/lockdep.c:5849 [inline]
> lock_acquire+0x1b1/0x580 kernel/locking/lockdep.c:5814
> __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
> _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
> class_raw_spinlock_irqsave_constructor include/linux/spinlock.h:551 [inline]
> try_to_wake_up+0xb5/0x23c0 kernel/sched/core.c:4205
> io_sq_thread_park+0xac/0xe0 io_uring/sqpoll.c:55
> io_sq_thread_finish+0x6b/0x310 io_uring/sqpoll.c:96
> io_sq_offload_create+0x162/0x11d0 io_uring/sqpoll.c:497
> io_uring_create io_uring/io_uring.c:3724 [inline]
> io_uring_setup+0x1728/0x3230 io_uring/io_uring.c:3806
> __do_sys_io_uring_setup io_uring/io_uring.c:3833 [inline]
> __se_sys_io_uring_setup io_uring/io_uring.c:3827 [inline]
> __x64_sys_io_uring_setup+0x94/0x140 io_uring/io_uring.c:3827
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa4396a071d
> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fa4382f3ba8 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
> RAX: ffffffffffffffda RBX: 00007fa439862f80 RCX: 00007fa4396a071d
> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000002616
> RBP: 00007fa4382f3c00 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000015
> R13: 00007fa439862f8c R14: 00007fa439863018 R15: 00007fa4382f3d40
> </TASK>

This is not caused by a locking bug. The freed structure is a 
task_struct which is passed by io_sq_thread() to try_to_wake_up(). So 
the culprit is probably in the io_uring code. cc'ing the io_uring 
developers for further review.

Cheers,
Longman

> Allocated by task 11159:
> kasan_save_stack+0x24/0x50 mm/kasan/common.c:47
> kasan_save_track+0x14/0x30 mm/kasan/common.c:68
> unpoison_slab_object mm/kasan/common.c:319 [inline]
> __kasan_slab_alloc+0x87/0x90 mm/kasan/common.c:345
> kasan_slab_alloc include/linux/kasan.h:250 [inline]
> slab_post_alloc_hook mm/slub.c:4119 [inline]
> slab_alloc_node mm/slub.c:4168 [inline]
> kmem_cache_alloc_node_noprof+0x14a/0x430 mm/slub.c:4220
> alloc_task_struct_node kernel/fork.c:180 [inline]
> dup_task_struct kernel/fork.c:1113 [inline]
> copy_process+0x487/0x7500 kernel/fork.c:2225
> create_io_thread+0xac/0xf0 kernel/fork.c:2755
> io_sq_offload_create+0xc62/0x11d0 io_uring/sqpoll.c:476
> io_uring_create io_uring/io_uring.c:3724 [inline]
> io_uring_setup+0x1728/0x3230 io_uring/io_uring.c:3806
> __do_sys_io_uring_setup io_uring/io_uring.c:3833 [inline]
> __se_sys_io_uring_setup io_uring/io_uring.c:3827 [inline]
> __x64_sys_io_uring_setup+0x94/0x140 io_uring/io_uring.c:3827
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 24:
> kasan_save_stack+0x24/0x50 mm/kasan/common.c:47
> kasan_save_track+0x14/0x30 mm/kasan/common.c:68
> kasan_save_free_info+0x3a/0x60 mm/kasan/generic.c:582
> poison_slab_object mm/kasan/common.c:247 [inline]
> __kasan_slab_free+0x54/0x70 mm/kasan/common.c:264
> kasan_slab_free include/linux/kasan.h:233 [inline]
> slab_free_hook mm/slub.c:2353 [inline]
> slab_free mm/slub.c:4613 [inline]
> kmem_cache_free+0x126/0x4d0 mm/slub.c:4715
> put_task_struct include/linux/sched/task.h:144 [inline]
> put_task_struct include/linux/sched/task.h:131 [inline]
> delayed_put_task_struct+0x229/0x300 kernel/exit.c:227
> rcu_do_batch kernel/rcu/tree.c:2567 [inline]
> rcu_core+0x7cb/0x16c0 kernel/rcu/tree.c:2823
> handle_softirqs+0x1ad/0x870 kernel/softirq.c:561
> run_ksoftirqd kernel/softirq.c:950 [inline]
> run_ksoftirqd+0x3a/0x60 kernel/softirq.c:942
> smpboot_thread_fn+0x669/0xa80 kernel/smpboot.c:164
> kthread+0x345/0x450 kernel/kthread.c:389
> ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
> ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>
> Last potentially related work creation:
> kasan_save_stack+0x24/0x50 mm/kasan/common.c:47
> __kasan_record_aux_stack+0xa6/0xc0 mm/kasan/generic.c:544
> __call_rcu_common.constprop.0+0x99/0x790 kernel/rcu/tree.c:3086
> put_task_struct_rcu_user+0x75/0xc0 kernel/exit.c:233
> finish_task_switch+0x4d2/0x720 kernel/sched/core.c:5278
> context_switch kernel/sched/core.c:5372 [inline]
> __schedule+0xe68/0x4120 kernel/sched/core.c:6756
> __schedule_loop kernel/sched/core.c:6833 [inline]
> schedule+0xd4/0x210 kernel/sched/core.c:6848
> do_nanosleep+0x20e/0x4e0 kernel/time/hrtimer.c:2079
> hrtimer_nanosleep+0x122/0x330 kernel/time/hrtimer.c:2126
> common_nsleep+0xaa/0xd0 kernel/time/posix-timers.c:1356
> __do_sys_clock_nanosleep kernel/time/posix-timers.c:1402 [inline]
> __se_sys_clock_nanosleep kernel/time/posix-timers.c:1379 [inline]
> __x64_sys_clock_nanosleep+0x33c/0x490 kernel/time/posix-timers.c:1379
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ff1100000289a340
> which belongs to the cache task_struct of size 8712
> The buggy address is located 2424 bytes inside of
> freed 8712-byte region [ff1100000289a340, ff1100000289c548)
>
> The buggy address belongs to the physical page:
> page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2898
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x100000000000040(head|node=0|zone=1)
> page_type: f5(slab)
> raw: 0100000000000040 ff110000014cb040 ffd4000000549800 dead000000000004
> raw: 0000000000000000 0000000080030003 00000001f5000000 0000000000000000
> head: 0100000000000040 ff110000014cb040 ffd4000000549800 dead000000000004
> head: 0000000000000000 0000000080030003 00000001f5000000 0000000000000000
> head: 0100000000000003 ffd40000000a2601 ffffffffffffffff 0000000000000000
> head: ff11000000000008 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
> ff1100000289ab80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ff1100000289ac00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ff1100000289ac80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ^
> ff1100000289ad00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ff1100000289ad80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
>
>
> ——————
> Thanks,
> Kun Hu
>


