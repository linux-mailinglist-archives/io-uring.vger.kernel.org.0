Return-Path: <io-uring+bounces-5799-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CA37A092AC
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 14:56:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F0433A88DA
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 13:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C55120FA87;
	Fri, 10 Jan 2025 13:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HWR7gX9d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258F54400
	for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 13:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736517393; cv=none; b=oUQJA4zFk0C4MqOiwojsbwEZRRyClyi2UaQnX1aMdQ1g7DOtSuMLfcEczkzUEr4/FJN+ZWX8PiurYaXVRJd3BXsz6elV6Z0jp/roEPXpfLlEROHAvfBh8jOc8tIy8+EufVVjIsNxhRebPJW+h/y/zKy3PbbSH9HadmHBrj+vAc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736517393; c=relaxed/simple;
	bh=GUuQ0qNi+85YfTnGGUL7ozoa5i9fRGf6adyGTnMYMyM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X6MwEXMdtV8b9fwguRSKJdd/R1hlDlsAKqB/NbasDkd65MUXMa/RE6X+SwSGVC/+OlnzBR+fQk2rCJgBdYkR/chaCiXijkMWNvQ2Bj/Vtn7DsiNkRXUM2170ALN1HBIeT0LCkGZrFB5bEguYf1PMR/U9OX935w2WrryCgU77Jc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HWR7gX9d; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3003943288bso19192841fa.0
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 05:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736517389; x=1737122189; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WslJcKJmZmn85G/edIxkT6sgz7f7e1hbrpsM6hgjpHY=;
        b=HWR7gX9dD8+fRbI9aFsVgUURQ1D5sYTCKGaUiAP0Iw2lz6HgkQNsLxXBd60QLfHWPj
         z/RIVNuhc96vOtZwFL7pjJgQJuEUVY7uyi9oE1V4mhZD6/Dw87+MusshSC1J5GmYGY9s
         +Uqrh8VoUBiHHQwoiIsE4M3YeyEe1zIEeHI0pBzFQg5C2OpS3NUzQilABNYcbHYuBmnO
         KZTCIrttN4aiLrPwvoe3dhjv/ie9x4pKVO+lrHo79H4BR9WVrYCWAkqqS/cpy9TN8gI/
         EbX0CZqB+PwdF+Okp/vSVBb/XbNOLMgWyF9/AET9xUTTu28L5B9XSD6sAl10SCjoRr5T
         atUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736517389; x=1737122189;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WslJcKJmZmn85G/edIxkT6sgz7f7e1hbrpsM6hgjpHY=;
        b=jO2PSrqZoOqyU0G8IJFy5m+FrfIM/gLGRedclcDgMG6gdXuK3AP+p1qmucu3hVktBi
         qWkddek08izAmRxTEB5bj7iKFZeEYzmjoSxeZ3y8w8bLWt6G9mcieUou6TuhmIK7TP0x
         QREtxH3ySzaAcSaS5e/sljoM8Qwb6FSSx4wwnwiNeWiID6UfzNZlDp+3dlC2zMW0sFss
         Hv3+4HyNl07ORU45RcDSKlDsuV1k/K2h+dX97HFT2QKtzZLoezLvcUxKzb9PfVDi309J
         4TmbowKaUsA/NWFSmJ/l5nwE+XP1SsAE39RmRb8qLrRBNbJJsWEXcLNYYhMIwEDN2GUD
         UTsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVK8/QxRJQQp9W7JkPt7xNxFZRM5uyVfaXn/o5EdKOHufhVfZnogwTGXXIQ5L3gDCilLkhzBZf2zA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxGf+TVC0r6VVxBLNTk7ZNNa3Pae4bZ7xEnFpcn6oKLSFEHvu4Y
	J4H5+7tJ+C7hhr8WBBaiOxGOjh4iFflQON9TjJoEDrq63RxvpX5g5IobPjzeFi4Ba1hDTkCQ9Qr
	+slQj76SwOM8+VH20EOXZQ5LQV2ZfaOCDUraf
X-Gm-Gg: ASbGnctfOGxIkHg3aK/kX3ZpwH1ZFzKN4GCs80T9SMzo3X1iUxSmqj5ce+ugJOJGwhO
	nPF7xn6mUBN/DUbAhpqkdPYLYlTzyA1Dj4tYHM8R7XM6ce0Cnnx6P00THP49p2ZO5bzk5+e4=
X-Google-Smtp-Source: AGHT+IH8FloY+P97Hj5NmhhnY65QAqo0j62r0TRNW8F9sspQ6ZJOBbvksux923j0HZLf8GP2Q9JqL+9fjtqe5JWwMO8=
X-Received: by 2002:a05:651c:221b:b0:303:4589:d700 with SMTP id
 38308e7fff4ca-305f4524e9emr29689781fa.5.1736517388975; Fri, 10 Jan 2025
 05:56:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <678125df.050a0220.216c54.0011.GAE@google.com>
In-Reply-To: <678125df.050a0220.216c54.0011.GAE@google.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 10 Jan 2025 14:56:17 +0100
X-Gm-Features: AbW1kvYO7O6cov5Uce7dXiguLS1F3Xq_-2uwDHvqYaSnI53HL_K3hz1IDF_8Fag
Message-ID: <CACT4Y+YKGy5a=8=HgyX38To+1yME59n9r=1pJahRVvx_n6F-Bw@mail.gmail.com>
Subject: Re: [syzbot] [kernel?] KASAN: slab-use-after-free Read in thread_group_cputime
To: syzbot <syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com>, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 10 Jan 2025 at 14:51, syzbot
<syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    ccb98ccef0e5 Merge tag 'platform-drivers-x86-v6.13-4' of g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1377fac4580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1c541fa8af5c9cc7
> dashboard link: https://syzkaller.appspot.com/bug?extid=3d92cfcfa84070b0a470
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/6e96673b1b94/disk-ccb98cce.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/528385411880/vmlinux-ccb98cce.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b061a4d50538/bzImage-ccb98cce.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: slab-use-after-free in thread_group_cputime+0x409/0x700 kernel/sched/cputime.c:341
> Read of size 8 at addr ffff88803578c510 by task syz.2.3223/27552
>
> CPU: 1 UID: 0 PID: 27552 Comm: syz.2.3223 Not tainted 6.13.0-rc5-syzkaller-00004-gccb98ccef0e5 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0x169/0x550 mm/kasan/report.c:489
>  kasan_report+0x143/0x180 mm/kasan/report.c:602
>  thread_group_cputime+0x409/0x700 kernel/sched/cputime.c:341
>  thread_group_cputime_adjusted+0xa6/0x340 kernel/sched/cputime.c:639
>  getrusage+0x1000/0x1340 kernel/sys.c:1863
>  io_uring_show_fdinfo+0xdfe/0x1770 io_uring/fdinfo.c:197

This looks to be more likely an io-uring issue rather than cputime.c

#syz set subsystems: io-uring

+maintainers


>  seq_show+0x608/0x770 fs/proc/fd.c:68
>  seq_read_iter+0x43f/0xd70 fs/seq_file.c:230
>  seq_read+0x3a9/0x4f0 fs/seq_file.c:162
>  vfs_read+0x1fc/0xb70 fs/read_write.c:563
>  ksys_read+0x18f/0x2b0 fs/read_write.c:708
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f277b585d29
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f277c409038 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 00007f277b775fa0 RCX: 00007f277b585d29
> RDX: 00000000fffffd79 RSI: 0000000020000100 RDI: 0000000000000004
> RBP: 00007f277b601b08 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 00007f277b775fa0 R15: 00007f277b89fa28
>  </TASK>
>
> Allocated by task 27552:
>  kasan_save_stack mm/kasan/common.c:47 [inline]
>  kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
>  unpoison_slab_object mm/kasan/common.c:319 [inline]
>  __kasan_slab_alloc+0x66/0x80 mm/kasan/common.c:345
>  kasan_slab_alloc include/linux/kasan.h:250 [inline]
>  slab_post_alloc_hook mm/slub.c:4119 [inline]
>  slab_alloc_node mm/slub.c:4168 [inline]
>  kmem_cache_alloc_node_noprof+0x1d9/0x380 mm/slub.c:4220
>  alloc_task_struct_node kernel/fork.c:180 [inline]
>  dup_task_struct+0x57/0x8c0 kernel/fork.c:1108
>  copy_process+0x5d1/0x3d50 kernel/fork.c:2224
>  create_io_thread+0x166/0x1d0 kernel/fork.c:2754
>  io_sq_offload_create+0xa35/0x11b0 io_uring/sqpoll.c:477
>  io_uring_create+0x68b/0xc00 io_uring/io_uring.c:3729
>  io_uring_setup io_uring/io_uring.c:3811 [inline]
>  __do_sys_io_uring_setup io_uring/io_uring.c:3838 [inline]
>  __se_sys_io_uring_setup+0x2ba/0x330 io_uring/io_uring.c:3832
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 6390:
>  kasan_save_stack mm/kasan/common.c:47 [inline]
>  kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
>  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:582
>  poison_slab_object mm/kasan/common.c:247 [inline]
>  __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
>  kasan_slab_free include/linux/kasan.h:233 [inline]
>  slab_free_hook mm/slub.c:2353 [inline]
>  slab_free mm/slub.c:4613 [inline]
>  kmem_cache_free+0x195/0x410 mm/slub.c:4715
>  put_task_struct include/linux/sched/task.h:144 [inline]
>  delayed_put_task_struct+0x125/0x300 kernel/exit.c:227
>  rcu_do_batch kernel/rcu/tree.c:2567 [inline]
>  rcu_core+0xaaa/0x17a0 kernel/rcu/tree.c:2823
>  handle_softirqs+0x2d4/0x9b0 kernel/softirq.c:561
>  do_softirq+0x11b/0x1e0 kernel/softirq.c:462
>  __local_bh_enable_ip+0x1bb/0x200 kernel/softirq.c:389
>  spin_unlock_bh include/linux/spinlock.h:396 [inline]
>  nsim_dev_trap_report drivers/net/netdevsim/dev.c:820 [inline]
>  nsim_dev_trap_report_work+0x7c4/0xb50 drivers/net/netdevsim/dev.c:851
>  process_one_work kernel/workqueue.c:3229 [inline]
>  process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
>  worker_thread+0x870/0xd30 kernel/workqueue.c:3391
>  kthread+0x2f0/0x390 kernel/kthread.c:389
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>
> Last potentially related work creation:
>  kasan_save_stack+0x3f/0x60 mm/kasan/common.c:47
>  __kasan_record_aux_stack+0xac/0xc0 mm/kasan/generic.c:544
>  __call_rcu_common kernel/rcu/tree.c:3086 [inline]
>  call_rcu+0x167/0xa70 kernel/rcu/tree.c:3190
>  context_switch kernel/sched/core.c:5372 [inline]
>  __schedule+0x1858/0x4c30 kernel/sched/core.c:6756
>  preempt_schedule_common+0x84/0xd0 kernel/sched/core.c:6935
>  preempt_schedule+0xe1/0xf0 kernel/sched/core.c:6959
>  preempt_schedule_thunk+0x1a/0x30 arch/x86/entry/thunk.S:12
>  __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:160 [inline]
>  _raw_spin_unlock_irq+0x44/0x50 kernel/locking/spinlock.c:202
>  spin_unlock_irq include/linux/spinlock.h:401 [inline]
>  do_group_exit+0x1f7/0x2c0 kernel/exit.c:1084
>  __do_sys_exit_group kernel/exit.c:1098 [inline]
>  __se_sys_exit_group kernel/exit.c:1096 [inline]
>  __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1096
>  x64_sys_call+0x26a8/0x26b0 arch/x86/include/generated/asm/syscalls_64.h:232
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88803578bc00
>  which belongs to the cache task_struct of size 7424
> The buggy address is located 2320 bytes inside of
>  freed 7424-byte region [ffff88803578bc00, ffff88803578d900)
>
> The buggy address belongs to the physical page:
> page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x35788
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> memcg:ffff888033adae01
> anon flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
> page_type: f5(slab)
> raw: 00fff00000000040 ffff88801bafe500 0000000000000000 dead000000000001
> raw: 0000000000000000 0000000000040004 00000001f5000000 ffff888033adae01
> head: 00fff00000000040 ffff88801bafe500 0000000000000000 dead000000000001
> head: 0000000000000000 0000000000040004 00000001f5000000 ffff888033adae01
> head: 00fff00000000003 ffffea0000d5e201 ffffffffffffffff 0000000000000000
> head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0x252800(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP|__GFP_THISNODE), pid 2, tgid 2 (kthreadd), ts 59377995710, free_ts 59377910116
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1558
>  prep_new_page mm/page_alloc.c:1566 [inline]
>  get_page_from_freelist+0x365c/0x37a0 mm/page_alloc.c:3476
>  __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4753
>  __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
>  alloc_slab_page+0x59/0x110 mm/slub.c:2425
>  allocate_slab+0x5a/0x2b0 mm/slub.c:2589
>  new_slab mm/slub.c:2642 [inline]
>  ___slab_alloc+0xc27/0x14a0 mm/slub.c:3830
>  __slab_alloc+0x58/0xa0 mm/slub.c:3920
>  __slab_alloc_node mm/slub.c:3995 [inline]
>  slab_alloc_node mm/slub.c:4156 [inline]
>  kmem_cache_alloc_node_noprof+0x269/0x380 mm/slub.c:4220
>  alloc_task_struct_node kernel/fork.c:180 [inline]
>  dup_task_struct+0x57/0x8c0 kernel/fork.c:1108
>  copy_process+0x5d1/0x3d50 kernel/fork.c:2224
>  kernel_clone+0x226/0x8e0 kernel/fork.c:2806
>  kernel_thread+0x1bc/0x240 kernel/fork.c:2868
>  create_kthread kernel/kthread.c:412 [inline]
>  kthreadd+0x60d/0x810 kernel/kthread.c:767
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> page last free pid 5833 tgid 5833 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1127 [inline]
>  free_unref_page+0xd3f/0x1010 mm/page_alloc.c:2659
>  discard_slab mm/slub.c:2688 [inline]
>  __put_partials+0x160/0x1c0 mm/slub.c:3157
>  put_cpu_partial+0x17c/0x250 mm/slub.c:3232
>  __slab_free+0x290/0x380 mm/slub.c:4483
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:329
>  kasan_slab_alloc include/linux/kasan.h:250 [inline]
>  slab_post_alloc_hook mm/slub.c:4119 [inline]
>  slab_alloc_node mm/slub.c:4168 [inline]
>  __kmalloc_cache_node_noprof+0x1ec/0x3a0 mm/slub.c:4337
>  kmalloc_node_noprof include/linux/slab.h:924 [inline]
>  alloc_worker kernel/workqueue.c:2638 [inline]
>  create_worker+0x11b/0x720 kernel/workqueue.c:2781
>  maybe_create_worker kernel/workqueue.c:3054 [inline]
>  manage_workers kernel/workqueue.c:3106 [inline]
>  worker_thread+0x318/0xd30 kernel/workqueue.c:3366
>  kthread+0x2f0/0x390 kernel/kthread.c:389
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>
> Memory state around the buggy address:
>  ffff88803578c400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88803578c480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88803578c500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                          ^
>  ffff88803578c580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88803578c600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-bugs/678125df.050a0220.216c54.0011.GAE%40google.com.

