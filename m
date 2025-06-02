Return-Path: <io-uring+bounces-8186-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E160FACAF41
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 15:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35A097A4D7A
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 13:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C5F935968;
	Mon,  2 Jun 2025 13:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YkYOhx0I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234FA221540
	for <io-uring@vger.kernel.org>; Mon,  2 Jun 2025 13:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748871705; cv=none; b=A/7GC5vRr/YTJvj0ouWIS7PgMgqyf5/p7Tn2LC0+ZHd6VS/cBrJ8gzvI0EU4B0mlYnG+tWXHlc/sDYMP+GBA8VNiByrhoZpIu1s/63LAqXz8v5lxP4LUXjMVDrg6noZkgzksqTSi+z+Nl8EXSA4OyEPtSKODGPO+scfoO/YeFhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748871705; c=relaxed/simple;
	bh=4vCxsEOxKy3x3XAqZ6lio1PpMMYYYu/vibPTQ9gfSW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bC/vgxq1vsUbWDCI2PgiEdPbJXCaWtM8F/FOfquXDhP65Qag6tMcu1qb9XUzYRhV+UsnBZ9GEl94ZkAvPgUilHrZPOXY3N7zAKeTCb4TpozcocktSRe2FHF/B/F8wyzG30XbHFqs45/Si9TXUNV6EpN+Ln0yBKVxjLLics+aorM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YkYOhx0I; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3db6ddcef4eso39200765ab.2
        for <io-uring@vger.kernel.org>; Mon, 02 Jun 2025 06:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748871701; x=1749476501; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qCZ1tadutrdX9+DP+Yde5srQLpE83ZG32rhptFxt24k=;
        b=YkYOhx0Ipu6neV9VGoDfTL/6FjRWL2tcImV3QNrAFHQeSaiqXoD7Ly5RrlG90TOfbR
         xETTbtYhEWEsKBizJqcZt8ZB/7a9cgzB9OySAaSv7ehfw6u3+fqLm3ADLlu/ojx1xU2J
         dwqZa50RKmKQTvbTtQ8FE998saMhgObsaBBGEcyOm5wFxkwfC4L8n6tPumu+vd6xMWCE
         rIRHvbpBTNJAJ/Xlhbohn4VABTYcCLNSuuG3tlF5lYxpzCVMKZ8+n90qo1Gyalx9Gkey
         RdnHiW+x/5b8Mk8NmH6IA8eismjh/U5pRyjHc1odNKVVuKPIlrLTHghSmKSpZuo5LFfX
         jIfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748871701; x=1749476501;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qCZ1tadutrdX9+DP+Yde5srQLpE83ZG32rhptFxt24k=;
        b=SPfOlfH7a7pte0wHlcFCXGYEhacEed6kQIrYXLOPjvVwnvxiKuQEw07QTi/lAvC2Lr
         POrFC67j5/N9o2P1N1GkExNCkLm9ncR0SWBdEp1VVm6ZLkV10ruuR2+kgUaFNKYjqUKy
         BBSfcbiKFUVqXKDfvlyPxe0ydaTM/mam5hKBsU56mC01Co5sNQnBQBEuGcpbTxUNsBEi
         BgBZJLPfwftlELaI629igDlOW5liNW7h8JqJJL4m45zqU31YyiImuOtKNyETxmFAEF38
         1gyBEcnqvOxT8MyFCgQJjCk5bjIphi2GaADWxkapXkbRmBOAVnkHWwhbAhuqLkvEc0vZ
         kDPw==
X-Forwarded-Encrypted: i=1; AJvYcCXk1LTsQ2XIUQQNIMYdcIgK6Ctx4mpfVng/mWl97p6/5yootngLHNwVxHXIvU8i/H1sonDsRou+TA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx61gUyo51khz1ZRckXwUGpnzgSk2gwLCpLIWlv6iqhFWq9BkfV
	5zAjSAvoBkcOKBfaarBSk5UplvZuMnmidd8tj5rbppcaMqvbq7mD5XL9aHtLL2K6X08=
X-Gm-Gg: ASbGncvjkyzSw9CGqj/SXHIzWhj3BN+qZFHmhnXTLV/wcRJDP5T++/l/3OZYKRpYleE
	CpHpyF4iz0Yopc4nMS2fgP6w1dOzQTqryt7qsRIUqmNu0cBo4CPUP5Xr72/kIfTR6R9dwj6DM4D
	QqvFya4pl/DJmgZziR5rGEP5c+6I2+/8ZXjprQb+glVh5j/8CLF9FsHb7RSZMtMaRZTuKrGgSj8
	FCWeNlyJp6HdnFeSF56ssCHwJpC7nHcjWWsszmSEJhIdt1hPSqZdOVufhpLHF+tp1j6nq3BetdJ
	/oRzCYJHYMX0O+PgvsWc2064isHaKNHAYKHdFUcm5YRlASA124b75y1G9w==
X-Google-Smtp-Source: AGHT+IHpy4OY0Xvrqz2LWBVKz//lK9RGTVdrFfhuY1u28VS48DyqobQEBdM75qgMtrqRy5u5y711bA==
X-Received: by 2002:a05:6e02:2184:b0:3dc:88ca:5ea4 with SMTP id e9e14a558f8ab-3dd99be4ab3mr148508865ab.8.1748871701040;
        Mon, 02 Jun 2025 06:41:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7dfe599sm1746035173.12.2025.06.02.06.41.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 06:41:40 -0700 (PDT)
Message-ID: <70392bfa-269b-4bca-bcef-0a9073454769@kernel.dk>
Date: Mon, 2 Jun 2025 07:41:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_uring_del_tctx_node
 (4)
To: syzbot <syzbot+818ea33e64f8caf968d1@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org, krisman@suse.de,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <683d14f9.a00a0220.d8eae.003d.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <683d14f9.a00a0220.d8eae.003d.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/1/25 9:05 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    feacb1774bd5 Merge tag 'sched_ext-for-6.16' of git://git.k..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1410dbf4580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ded97a85afe9a6c8
> dashboard link: https://syzkaller.appspot.com/bug?extid=818ea33e64f8caf968d1
> compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d5fbf4580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d5fbf4580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/927d3353c6ef/disk-feacb177.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/00070c1b5ee0/vmlinux-feacb177.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d7e700ecb777/bzImage-feacb177.xz
> 
> The issue was bisected to:
> 
> commit b3a4dbc89d4021b3f90ff6a13537111a004f9d07
> Author: Gabriel Krisman Bertazi <krisman@suse.de>
> Date:   Thu Oct 5 00:05:31 2023 +0000
> 
>     io_uring/kbuf: Use slab for struct io_buffer objects

Not really related, other than that it may change the timing somewhat
which I can see influencing this test. But it's not a root cause as
such.

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=169feed4580000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=159feed4580000
> console output: https://syzkaller.appspot.com/x/log.txt?x=119feed4580000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+818ea33e64f8caf968d1@syzkaller.appspotmail.com
> Fixes: b3a4dbc89d40 ("io_uring/kbuf: Use slab for struct io_buffer objects")
> 
> INFO: task syz-executor266:5869 blocked for more than 143 seconds.
>       Not tainted 6.15.0-syzkaller-03589-gfeacb1774bd5 #0
>       Blocked by coredump.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor266 state:D stack:26952 pid:5869  tgid:5863  ppid:5860   task_flags:0x400548 flags:0x00004002
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5392 [inline]
>  __schedule+0x16f5/0x4d00 kernel/sched/core.c:6781
>  __schedule_loop kernel/sched/core.c:6859 [inline]
>  schedule+0x165/0x360 kernel/sched/core.c:6874
>  schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6931
>  __mutex_lock_common kernel/locking/mutex.c:678 [inline]
>  __mutex_lock+0x724/0xe80 kernel/locking/mutex.c:746
>  io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
>  io_uring_clean_tctx+0xd4/0x1a0 io_uring/tctx.c:195
>  io_uring_cancel_generic+0x68f/0x730 io_uring/io_uring.c:3204
>  io_uring_files_cancel include/linux/io_uring.h:19 [inline]
>  do_exit+0x56a/0x2550 kernel/exit.c:915
>  do_group_exit+0x21c/0x2d0 kernel/exit.c:1108
>  get_signal+0x125e/0x1310 kernel/signal.c:3034
>  arch_do_signal_or_restart+0x9a/0x750 arch/x86/kernel/signal.c:337
>  exit_to_user_mode_loop+0x75/0x110 kernel/entry/common.c:111
>  exit_to_user_mode_prepare include/linux/entry-common.h:330 [inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:414 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:449 [inline]
>  do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff7ab3f0599
> RSP: 002b:00007ff7ab3a9218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 00007ff7ab47a328 RCX: 00007ff7ab3f0599
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007ff7ab47a328
> RBP: 00007ff7ab47a320 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
> R13: 00002000000000c0 R14: 0000200000000340 R15: 0000200000000980
>  </TASK>
> 
> Showing all locks held in the system:
> 5 locks held by kworker/u8:1/13:
>  #0: ffff8880b8739f58 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:606
>  #1: ffff8880b8723f08 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x39e/0x6d0 kernel/sched/psi.c:987
>  #2: ffff8880b8725958 (&base->lock){-.-.}-{2:2}, at: __mod_timer+0x8ee/0xf30 kernel/time/timer.c:1117
>  #3: ffffffff99cfa278 (&obj_hash[i].lock){-.-.}-{2:2}, at: debug_object_activate+0xbb/0x420 lib/debugobjects.c:818
>  #4: ffffffff8dfe8928 (text_mutex){+.+.}-{4:4}, at: arch_jump_label_transform_apply+0x17/0x30 arch/x86/kernel/jump_label.c:145
> 1 lock held by khungtaskd/31:
>  #0: ffffffff8e13ccc0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
>  #0: ffffffff8e13ccc0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
>  #0: ffffffff8e13ccc0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6770
> 2 locks held by getty/5589:
>  #0: ffff888030bef0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
>  #1: ffffc90002fee2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
> 1 lock held by syz-executor266/5865:
> 1 lock held by syz-executor266/5866:
> 2 locks held by syz-executor266/5867:
> 1 lock held by syz-executor266/5869:
>  #0: ffff8880781600a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
> 2 locks held by syz-executor266/5870:
> 2 locks held by syz-executor266/5868:
> 
> =============================================
> 
> NMI backtrace for cpu 1
> CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Not tainted 6.15.0-syzkaller-03589-gfeacb1774bd5 #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
>  nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:158 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:274 [inline]
>  watchdog+0xfee/0x1030 kernel/hung_task.c:437
>  kthread+0x70e/0x8a0 kernel/kthread.c:464
>  ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 UID: 0 PID: 5868 Comm: syz-executor266 Not tainted 6.15.0-syzkaller-03589-gfeacb1774bd5 #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
> RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:32 [inline]
> RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:109 [inline]
> RIP: 0010:arch_local_irq_save arch/x86/include/asm/irqflags.h:127 [inline]
> RIP: 0010:lock_release+0xaa/0x3e0 kernel/locking/lockdep.c:5888
> Code: 92 41 83 bf ec 0a 00 00 00 0f 85 1e 02 00 00 49 81 3e 80 f3 5c 93 0f 84 11 02 00 00 48 c7 44 24 20 00 00 00 00 9c 8f 44 24 20 <48> 8b 5c 24 20 fa 48 c7 c7 0e 10 97 8d e8 94 56 c0 09 65 ff 05 8d
> RSP: 0018:ffffc900045ef3f0 EFLAGS: 00000202
> RAX: 0000000000000000 RBX: 00007ff7ab47a301 RCX: 2c8b038b74fda600
> RDX: ffffffff9025c800 RSI: ffffffff8be24de0 RDI: ffffffff8be24da0
> RBP: dffffc0000000000 R08: 0000000000000022 R09: ffffffff81724865
> R10: ffffc900045ef578 R11: ffffffff81ac98f0 R12: 00007ff7ab3a9208
> R13: ffffffff81724865 R14: ffffffff8e13ccc0 R15: ffff888077b2da00
> FS:  00007ff7ab3a96c0(0000) GS:ffff888125c8c000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd695af76c8 CR3: 000000007fa2e000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  rcu_lock_release include/linux/rcupdate.h:341 [inline]
>  rcu_read_unlock include/linux/rcupdate.h:871 [inline]
>  class_rcu_destructor include/linux/rcupdate.h:1155 [inline]
>  unwind_next_frame+0x19a9/0x2390 arch/x86/kernel/unwind_orc.c:680
>  arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
>  stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
>  kasan_save_stack mm/kasan/common.c:47 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
>  poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:394
>  kasan_kmalloc include/linux/kasan.h:260 [inline]
>  __kmalloc_cache_noprof+0x230/0x3d0 mm/slub.c:4358
>  kmalloc_noprof include/linux/slab.h:905 [inline]
>  io_add_buffers io_uring/kbuf.c:497 [inline]
>  __io_manage_buffers_legacy io_uring/kbuf.c:538 [inline]
>  io_manage_buffers_legacy+0x334/0xc90 io_uring/kbuf.c:551
>  __io_issue_sqe+0x17e/0x4b0 io_uring/io_uring.c:1730
>  io_issue_sqe+0x165/0xfd0 io_uring/io_uring.c:1753
>  io_queue_sqe io_uring/io_uring.c:1960 [inline]
>  io_submit_sqe io_uring/io_uring.c:2216 [inline]
>  io_submit_sqes+0xa38/0x1c50 io_uring/io_uring.c:2329
>  __do_sys_io_uring_enter io_uring/io_uring.c:3396 [inline]
>  __se_sys_io_uring_enter+0x2df/0x2b20 io_uring/io_uring.c:3330
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff7ab3f0599
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 51 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ff7ab3a9208 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: ffffffffffffffda RBX: 00007ff7ab47a328 RCX: 00007ff7ab3f0599
> RDX: 00000000000000f0 RSI: 0000000000003516 RDI: 0000000000000003
> RBP: 00007ff7ab47a320 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
> R13: 00002000000000c0 R14: 0000200000000340 R15: 0000200000000980
>  </TASK>
> INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.349 msecs

This isn't a real bug, it's simply the usual syzbot approach of flooding
the request machinery (with provide buffers, a popular choice), and then
with KASAN+PROVE_LOCKING enabled it'll take forever to finish.

#syz invalid

-- 
Jens Axboe

