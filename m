Return-Path: <io-uring+bounces-3239-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF9CE97D0E9
	for <lists+io-uring@lfdr.de>; Fri, 20 Sep 2024 07:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85DBD285BA4
	for <lists+io-uring@lfdr.de>; Fri, 20 Sep 2024 05:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F4AE2D613;
	Fri, 20 Sep 2024 05:20:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FA72AEEC
	for <io-uring@vger.kernel.org>; Fri, 20 Sep 2024 05:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726809632; cv=none; b=X/gjU3cWZqESnFFIog4ge23S7Im4LxPCXAk2QD07moQZv03n+H7ID9lIZe7fntTms9SoKHUmRsqupqsLvCjXa8L9HAtSmYhLqvtZHFhrKabF+V8ujJtUT2MdVBR4olDBHVbIT8T6XJ7GVBlOExCoNhvGEHgYvAJzJ+71jB5Ges4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726809632; c=relaxed/simple;
	bh=6YnpSwKUWaQ4buegiBGaJ38MqU2GXmIRrf2jduQ8lqI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=iG9gobkSQsgKrtKptvw6CJHvxX0Okiu+iiEZYhUQa//IPcjNMKQ8d9Z/stz+qJ/NeDwmmUa2b1uuOs30YsBRc6CFdFwq+4qPKMxTZHySWjIU/qP3Zso0QoEZIkPzezncRsvD7h+w+wF4+MZGDRZG8mpWgYhwKyFtAFq4xEUnuA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a05311890bso23433065ab.1
        for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 22:20:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726809630; x=1727414430;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BXpyJi4ScEHKG0uivZiURNoKfrUIBk+b39E5lLQSWBE=;
        b=tU4wZSyb+c8j4gBo4eBiLzgGRQ6EBpKR0LZFosyOt5Ov438OAuR8yHcfGp7KDrES4j
         1rJzJxIqY5gU8a/UfgP8+zsyOpXKb87+Hs8RhjqLCkh/Rdkq9vd8sVlfnnEKoe8voibQ
         UAjSEFAeJgujPhBIADaK1a7+R7lioPHmxiHtYQ6Ulj8nQxaXXlXfiuj5jkbo4jpUOkS4
         VFyb+t2jJuGfK8Y+Nkq6YfAKEP6wE2LZD2vIs1ZkCzhRMLUvLRjdZI2QCi7ydp+ZZTU0
         ZTX+IsT9gly0c6d6XgAb4a1DIXEkjrNZVGPVwi1MQGFr5CflK2pj0ggA1LnRvKvjk6VL
         /5bA==
X-Forwarded-Encrypted: i=1; AJvYcCWnKtCZf3YjJgGK1UJnchqoOauUFIiNBCbaRg42SadUWotJlQ1W3eWO6HUP80TD0SgGSGYHBUbwdA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxmO+1OP+syl+L+3oZtRBrGigfOS89sc4ePweJLi6u/BvS6u/zp
	+9hImLiYieN19vq97ADt5HwB10LB5lY5m+igitvWmKaZgozUtqGCdawPzvW7Fb1+hNkxfNpp4Sy
	jkGL47xE7lwMUvEXfEc+vqBptZvLt/cFfDpVmCkMw2cDz/9C18zYUyu8=
X-Google-Smtp-Source: AGHT+IG8xvnR+YM0kcvlwke6BBs0a03a8Fn7VpNaJN8llKVkkFQBdg4JsFRwDS3pR5FlW2SPzS7gHHPtT5OjCJ1geujd8pzdTvpK
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a2d:b0:39f:5e18:239d with SMTP id
 e9e14a558f8ab-3a0c8d1342emr14587475ab.15.1726809629828; Thu, 19 Sep 2024
 22:20:29 -0700 (PDT)
Date: Thu, 19 Sep 2024 22:20:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66ed061d.050a0220.29194.0053.GAE@google.com>
Subject: [syzbot] [io-uring?] INFO: rcu detected stall in sys_io_uring_enter (2)
From: syzbot <syzbot+5fca234bd7eb378ff78e@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    98f7e32f20d2 Linux 6.11
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17271c07980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c78874575ba70f27
dashboard link: https://syzkaller.appspot.com/bug?extid=5fca234bd7eb378ff78e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/20d79fec7eb2/disk-98f7e32f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/57606ddb0989/vmlinux-98f7e32f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/901e6ba22e57/bzImage-98f7e32f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5fca234bd7eb378ff78e@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	1-...!: (0 ticks this GP) idle=11bc/1/0x4000000000000000 softirq=116660/116660 fqs=17
rcu: 	(detected by 0, t=10502 jiffies, g=200145, q=315 ncpus=2)
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 6917 Comm: syz.2.16175 Not tainted 6.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:match_held_lock+0x0/0xb0 kernel/locking/lockdep.c:5204
Code: 08 75 11 48 89 d8 48 83 c4 10 5b 41 5e 41 5f c3 cc cc cc cc e8 11 f9 ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <55> 53 bd 01 00 00 00 48 39 77 10 74 67 48 89 fb 81 7f 20 00 00 20
RSP: 0018:ffffc90000a18d10 EFLAGS: 00000083
RAX: 0000000000000002 RBX: ffff888057310b08 RCX: ffff888057310000
RDX: ffff888057310000 RSI: ffff8880b892c898 RDI: ffff888057310b08
RBP: 0000000000000001 R08: ffffffff8180cfbe R09: 0000000000000000
R10: ffff88803641a340 R11: ffffed1006c8346b R12: 0000000000000046
R13: ffff888057310000 R14: 00000000ffffffff R15: ffff8880b892c898
FS:  00007f183bd6c6c0(0000) GS:ffff8880b8900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7205d61f98 CR3: 000000001bb10000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <IRQ>
 __lock_is_held kernel/locking/lockdep.c:5500 [inline]
 lock_is_held_type+0xa9/0x190 kernel/locking/lockdep.c:5831
 lock_is_held include/linux/lockdep.h:249 [inline]
 __run_hrtimer kernel/time/hrtimer.c:1655 [inline]
 __hrtimer_run_queues+0x2d9/0xd50 kernel/time/hrtimer.c:1753
 hrtimer_interrupt+0x396/0x990 kernel/time/hrtimer.c:1815
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1032 [inline]
 __sysvec_apic_timer_interrupt+0x110/0x3f0 arch/x86/kernel/apic/apic.c:1049
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1043 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1043
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:lock_acquire+0x264/0x550 kernel/locking/lockdep.c:5763
Code: 2b 00 74 08 4c 89 f7 e8 ea e1 87 00 f6 44 24 61 02 0f 85 85 01 00 00 41 f7 c7 00 02 00 00 74 01 fb 48 c7 44 24 40 0e 36 e0 45 <4b> c7 44 25 00 00 00 00 00 43 c7 44 25 09 00 00 00 00 43 c7 44 25
RSP: 0018:ffffc9000c5c79a0 EFLAGS: 00000206
RAX: 0000000000000001 RBX: 1ffff920018b8f40 RCX: 2e46bf6ba4daf100
RDX: dffffc0000000000 RSI: ffffffff8beae6c0 RDI: ffffffff8c3fbac0
RBP: ffffc9000c5c7ae8 R08: ffffffff93fa6967 R09: 1ffffffff27f4d2c
R10: dffffc0000000000 R11: fffffbfff27f4d2d R12: 1ffff920018b8f3c
R13: dffffc0000000000 R14: ffffc9000c5c7a00 R15: 0000000000000246
 __mutex_lock_common kernel/locking/mutex.c:608 [inline]
 __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
 io_cqring_do_overflow_flush io_uring/io_uring.c:644 [inline]
 io_cqring_wait io_uring/io_uring.c:2486 [inline]
 __do_sys_io_uring_enter io_uring/io_uring.c:3255 [inline]
 __se_sys_io_uring_enter+0x1c2a/0x2670 io_uring/io_uring.c:3147
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f183af7def9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f183bd6c038 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007f183b135f80 RCX: 00007f183af7def9
RDX: 0000000000400000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007f183aff0b76 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f183b135f80 R15: 00007ffdf58fafa8
 </TASK>
rcu: rcu_preempt kthread starved for 10467 jiffies! g200145 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:25584 pid:17    tgid:17    ppid:2      flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5188 [inline]
 __schedule+0x17ae/0x4a10 kernel/sched/core.c:6529
 __schedule_loop kernel/sched/core.c:6606 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6621
 schedule_timeout+0x1be/0x310 kernel/time/timer.c:2581
 rcu_gp_fqs_loop+0x2df/0x1330 kernel/rcu/tree.c:2034
 rcu_gp_kthread+0xa7/0x3b0 kernel/rcu/tree.c:2236
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 0 UID: 0 PID: 8860 Comm: syz.4.17008 Not tainted 6.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:csd_lock_wait kernel/smp.c:312 [inline]
RIP: 0010:smp_call_function_many_cond+0x1860/0x29d0 kernel/smp.c:856
Code: 45 8b 65 00 44 89 e6 83 e6 01 31 ff e8 39 18 0c 00 41 83 e4 01 49 bc 00 00 00 00 00 fc ff df 75 07 e8 e4 13 0c 00 eb 38 f3 90 <42> 0f b6 04 23 84 c0 75 11 41 f7 45 00 01 00 00 00 74 1e e8 c8 13
RSP: 0018:ffffc9000387f400 EFLAGS: 00000246
RAX: ffffffff81877898 RBX: 1ffff110171288e9 RCX: 0000000000040000
RDX: ffffc9000ebfe000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: ffffc9000387f5e0 R08: ffffffff81877867 R09: 1ffffffff27f4d08
R10: dffffc0000000000 R11: fffffbfff27f4d09 R12: dffffc0000000000
R13: ffff8880b8944748 R14: ffff8880b883fb00 R15: 0000000000000001
FS:  00007f7205d626c0(0000) GS:ffff8880b8800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1e72c656c0 CR3: 000000007b528000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 </IRQ>
 <TASK>
 on_each_cpu_cond_mask+0x3f/0x80 kernel/smp.c:1023
 on_each_cpu include/linux/smp.h:71 [inline]
 text_poke_sync arch/x86/kernel/alternative.c:2085 [inline]
 text_poke_bp_batch+0x352/0xb30 arch/x86/kernel/alternative.c:2295
 text_poke_bp+0xb0/0x100 arch/x86/kernel/alternative.c:2522
 __static_call_transform+0x51a/0x810 arch/x86/kernel/static_call.c:111
 arch_static_call_transform+0x141/0x380 arch/x86/kernel/static_call.c:163
 __static_call_update+0xd8/0x5e0 kernel/static_call_inline.c:147
 tracepoint_update_call kernel/tracepoint.c:317 [inline]
 tracepoint_add_func+0x918/0x9e0 kernel/tracepoint.c:358
 tracepoint_probe_register_prio_may_exist+0x122/0x190 kernel/tracepoint.c:482
 bpf_raw_tp_link_attach+0x48b/0x6e0 kernel/bpf/syscall.c:3896
 bpf_raw_tracepoint_open+0x1c2/0x240 kernel/bpf/syscall.c:3927
 __sys_bpf+0x3c0/0x810 kernel/bpf/syscall.c:5752
 __do_sys_bpf kernel/bpf/syscall.c:5817 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5815 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:5815
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7204f7def9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7205d62038 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f7205135f80 RCX: 00007f7204f7def9
RDX: 0000000000000010 RSI: 0000000020000200 RDI: 0000000000000011
RBP: 00007f7204ff0b76 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f7205135f80 R15: 00007ffda5863568
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

