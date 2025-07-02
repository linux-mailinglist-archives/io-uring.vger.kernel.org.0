Return-Path: <io-uring+bounces-8581-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 930E3AF5DA4
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 17:52:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC1EC7B47DD
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 15:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E5E2E041A;
	Wed,  2 Jul 2025 15:52:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286B12E03EB
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 15:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751471547; cv=none; b=DhrFoajXlfo5f8kp0UR3C72TyhFw5a5GLX3BwFfhdmxIpAmZlwXekenvXtxEiAZ70NKqGuJLhpqAv8/FbbZGAgET0EUZh9uOQSYyzGD09PRA2jaHXev6Hk5T0EVLKSBDiebrN0/tE7dLf7ZHqhHFPKS3SWwoPJAvnKCjpuy3wz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751471547; c=relaxed/simple;
	bh=EKjGXiFN00GIPDQgDrbn1nyQjKhsapJn8ddASHSThF8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=NYrBVn32LvckrhRETfPLljdzUKSG/vRlrgzZyeLgL5WvNdIOLI2QpI3TZpP7OW0XawQZDxbSl1CiOwNVXepftbSKTJVUeTdAYErrFaet8DiNz/0KhIkDO9l+6fJQBKQIqbXd39IuPJEXnxmoP8xXPS/AEzZ+4NEjU5W1Xeb9+Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3e059add15eso5856345ab.0
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 08:52:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751471545; x=1752076345;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cN8mYzo5FBmuFkWim2a0jWGJX55lrKzHtBCwmXXY/Kg=;
        b=j6TxsUBjvEQPDMBXDqkx7R8GWUuvgnCE4OfCrnfUjeMbQc3Ogss29wlYqrlw2IRSUd
         FzMOpEtbx3rpozJelhOr4lJY4hdB3Xr/oEugM0Jpa0AAikL0aBNQ9qjDZXuCup9xznRa
         OqneaZqAKeIS+SIKN5kxCXVsKS6KJ7rD9xSlf505FO5GccpGXwf83kwUccKWjfrz3L4n
         82UpjtEYDVpDL7FDVmehe8b3Z+w9jRM48iXW3iCDT5nCVL3xj2ohrqwIik3v0LUd+VH3
         JRVIjYjMCAjyc91ITT1gggTy0bzM2VEPiss8aoUxq4cP7BCjNmp3/EY6XZVIrhw6HLhD
         l1fg==
X-Forwarded-Encrypted: i=1; AJvYcCWQe8jNvd7+u+Y+6lyX+1wXP7jdBlU3CFj9LD4/EtErN4Wn+qULNj/q+SG9hlcQuWb4YeyYJyaedQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk6krSBXr8ka4MnMP9FbX2lKWc85cFEdhF0z075mRx8ytCXCQD
	kWeenSnK+1ZtyVkhTOf1LdqMsLbdafKtC1T3UZLUCJa1xZ8UADEGdvC5SFIwkGXwVdK2EJ0E3Zk
	Hp2cd2bsJbh9PjFMCgRr+kwGKebSba0suGR93BcJ9+DzYoDvs8dZBDSMDkC8=
X-Google-Smtp-Source: AGHT+IEk9VHGhxmALpwL9xlHwrwBAlnIJzUpnpkmkEI5lcE4kbqtcZuc8RH0PJDAaFO8gtWolChHpi8L+GZlUmk9JoofAQjSwfx0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3983:b0:3dd:d653:5a05 with SMTP id
 e9e14a558f8ab-3e054923d74mr45389065ab.3.1751471545369; Wed, 02 Jul 2025
 08:52:25 -0700 (PDT)
Date: Wed, 02 Jul 2025 08:52:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686555b9.a00a0220.270cb1.0002.GAE@google.com>
Subject: [syzbot] [io-uring?] INFO: task hung in vfs_coredump
From: syzbot <syzbot+c29db0c6705a06cb65f2@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, axboe@kernel.dk, frederic@kernel.org, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2aeda9592360 Add linux-next specific files for 20250627
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12f9a982580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f5c1d958b70bf47
dashboard link: https://syzkaller.appspot.com/bug?extid=c29db0c6705a06cb65f2
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ff688c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d532560074a3/disk-2aeda959.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/483001f76864/vmlinux-2aeda959.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f233cdc1c77/bzImage-2aeda959.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c29db0c6705a06cb65f2@syzkaller.appspotmail.com

INFO: task syz.0.23:6175 blocked for more than 143 seconds.
      Not tainted 6.16.0-rc3-next-20250627-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.23        state:D stack:27624 pid:6175  tgid:6170  ppid:5972   task_flags:0x400640 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5313 [inline]
 __schedule+0x16f5/0x4d00 kernel/sched/core.c:6696
 __schedule_loop kernel/sched/core.c:6774 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6789
 schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:100 [inline]
 __wait_for_common+0x3da/0x710 kernel/sched/completion.c:121
 wait_for_common kernel/sched/completion.c:132 [inline]
 wait_for_completion_state+0x1c/0x40 kernel/sched/completion.c:269
 coredump_wait fs/coredump.c:534 [inline]
 vfs_coredump+0x8c2/0x2ab0 fs/coredump.c:1128
 get_signal+0x1109/0x1340 kernel/signal.c:3019
 arch_do_signal_or_restart+0x9a/0x750 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop+0x75/0x110 kernel/entry/common.c:111
 exit_to_user_mode_prepare include/linux/entry-common.h:330 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:414 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:449 [inline]
 do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f612984f830
RSP: 002b:00007f612a722b38 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000000 RBX: 00007f6129bb6088 RCX: 00007f612998e929
RDX: 00007f612a722b40 RSI: 00007f612a722c70 RDI: 000000000000000b
RBP: 00007f6129bb6080 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6129bb608c
R13: 0000000000000000 R14: 00007fff3502f910 R15: 00007fff3502f9f8
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8e13bf20 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e13bf20 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #0: ffffffff8e13bf20 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6770
3 locks held by kworker/u9:1/5156:
 #0: ffff88804419a148 ((wq_completion)hci7){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #0: ffff88804419a148 ((wq_completion)hci7){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3322
 #1: ffffc9001023fbc0 ((work_completion)(&hdev->power_on)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3215 [inline]
 #1: ffffc9001023fbc0 ((work_completion)(&hdev->power_on)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3322
 #2: ffff888020f40dc0 (&hdev->req_lock){+.+.}-{4:4}, at: hci_dev_do_open net/bluetooth/hci_core.c:428 [inline]
 #2: ffff888020f40dc0 (&hdev->req_lock){+.+.}-{4:4}, at: hci_power_on+0x1ac/0x680 net/bluetooth/hci_core.c:959
2 locks held by getty/5598:
 #0: ffff8880303340a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000331b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
1 lock held by syz.0.23/6171:
1 lock held by syz.2.43/6314:
1 lock held by syz.3.47/6351:
1 lock held by syz.4.49/6392:
1 lock held by syz.5.51/6429:
1 lock held by syz.6.54/6471:
1 lock held by dhcpcd/6476:
 #0: ffff888077ab0e08 (&sb->s_type->i_mutex_key#11){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #0: ffff888077ab0e08 (&sb->s_type->i_mutex_key#11){+.+.}-{4:4}, at: __sock_release net/socket.c:648 [inline]
 #0: ffff888077ab0e08 (&sb->s_type->i_mutex_key#11){+.+.}-{4:4}, at: sock_close+0x9b/0x240 net/socket.c:1439
2 locks held by dhcpcd/6477:
 #0: ffff88805fcdc258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1667 [inline]
 #0: ffff88805fcdc258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x32/0xcd0 net/packet/af_packet.c:3252
 #1: ffffffff8e141a38 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:343 [inline]
 #1: ffffffff8e141a38 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x3b9/0x730 kernel/rcu/tree_exp.h:967
1 lock held by dhcpcd/6478:
 #0: ffff888044c5a258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1667 [inline]
 #0: ffff888044c5a258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x32/0xcd0 net/packet/af_packet.c:3252
1 lock held by syz-executor/6480:
2 locks held by dhcpcd/6483:
 #0: ffff888079892258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1667 [inline]
 #0: ffff888079892258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x32/0xcd0 net/packet/af_packet.c:3252
 #1: ffffffff8e141a38 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:343 [inline]
 #1: ffffffff8e141a38 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x3b9/0x730 kernel/rcu/tree_exp.h:967

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Not tainted 6.16.0-rc3-next-20250627-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:307 [inline]
 watchdog+0xfee/0x1030 kernel/hung_task.c:470
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6314 Comm: syz.2.43 Not tainted 6.16.0-rc3-next-20250627-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:arch_atomic_read arch/x86/include/asm/atomic.h:23 [inline]
RIP: 0010:raw_atomic_read include/linux/atomic/atomic-arch-fallback.h:457 [inline]
RIP: 0010:rcu_is_watching_curr_cpu include/linux/context_tracking.h:128 [inline]
RIP: 0010:rcu_is_watching+0x5a/0xb0 kernel/rcu/tree.c:751
Code: f0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 f7 e8 7c 42 7d 00 48 c7 c3 18 4f a1 92 49 03 1e 48 89 d8 48 c1 e8 03 42 0f b6 04 38 <84> c0 75 34 8b 03 65 ff 0d 89 90 f9 10 74 11 83 e0 04 c1 e8 02 5b
RSP: 0018:ffffc900000079a8 EFLAGS: 00000802
RAX: 0000000000000000 RBX: ffff8880b8632f18 RCX: 1370d027c6756400
RDX: 0000000000000000 RSI: ffffffff8be31f60 RDI: ffffffff8be31f20
RBP: ffffffff81745448 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff33acaae R12: 0000000000000002
R13: ffffffff8e13bfe0 R14: ffffffff8dbb8cb0 R15: dffffc0000000000
FS:  00007f61f8d9d6c0(0000) GS:ffff888125c1e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a134a81660 CR3: 000000007fa0a000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 trace_lock_acquire include/trace/events/lock.h:24 [inline]
 lock_acquire+0x5f/0x360 kernel/locking/lockdep.c:5834
 rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 rcu_read_lock_sched include/linux/rcupdate.h:932 [inline]
 pfn_valid include/linux/mmzone.h:2163 [inline]
 __virt_addr_valid+0x1e5/0x5c0 arch/x86/mm/physaddr.c:65
 kasan_addr_to_slab+0xf/0x90 mm/kasan/common.c:37
 kasan_record_aux_stack+0xf/0xd0 mm/kasan/generic.c:533
 insert_work+0x3d/0x330 kernel/workqueue.c:2187
 __queue_work+0xbaf/0xfb0 kernel/workqueue.c:2346
 call_timer_fn+0x17b/0x5f0 kernel/time/timer.c:1747
 expire_timers kernel/time/timer.c:1793 [inline]
 __run_timers kernel/time/timer.c:2372 [inline]
 __run_timer_base+0x646/0x860 kernel/time/timer.c:2384
 run_timer_base kernel/time/timer.c:2393 [inline]
 run_timer_softirq+0xb7/0x180 kernel/time/timer.c:2403
 handle_softirqs+0x286/0x870 kernel/softirq.c:579
 __do_softirq kernel/softirq.c:613 [inline]
 invoke_softirq kernel/softirq.c:453 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:680
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:696
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1050
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:lock_acquire+0x175/0x360 kernel/locking/lockdep.c:5875
Code: 00 00 00 00 9c 8f 44 24 30 f7 44 24 30 00 02 00 00 0f 85 cd 00 00 00 f7 44 24 08 00 02 00 00 74 01 fb 65 48 8b 05 5b 83 02 11 <48> 3b 44 24 58 0f 85 f2 00 00 00 48 83 c4 60 5b 41 5c 41 5d 41 5e
RSP: 0018:ffffc90003e6f980 EFLAGS: 00000206
RAX: 1370d027c6756400 RBX: 0000000000000000 RCX: 1370d027c6756400
RDX: 0000000000000000 RSI: ffffffff8db80736 RDI: ffffffff8be31f80
RBP: ffffffff84bc6539 R08: 0000000000000000 R09: ffffffff84bc6539
R10: ffffc90003e6fb00 R11: fffff520007cdf65 R12: 0000000000000000
R13: ffff88806038c0a8 R14: 0000000000000001 R15: 0000000000000246
 __mutex_lock_common kernel/locking/mutex.c:602 [inline]
 __mutex_lock+0x182/0xe80 kernel/locking/mutex.c:747
 io_cqring_do_overflow_flush+0x19/0x30 io_uring/io_uring.c:665
 io_cqring_wait io_uring/io_uring.c:2701 [inline]
 __do_sys_io_uring_enter io_uring/io_uring.c:3508 [inline]
 __se_sys_io_uring_enter+0x1fce/0x2b20 io_uring/io_uring.c:3403
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f61f7f8e929
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f61f8d9d038 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007f61f81b5fa0 RCX: 00007f61f7f8e929
RDX: 0000000000001797 RSI: 0000000000000001 RDI: 0000000000000003
RBP: 00007f61f8010b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f61f81b5fa0 R15: 00007ffcfc501968
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

