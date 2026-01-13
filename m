Return-Path: <io-uring+bounces-11622-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B0DFED1B5D4
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 22:13:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6E2B8300A873
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 21:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E92AE31ED81;
	Tue, 13 Jan 2026 21:13:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3617E2DB7AE
	for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 21:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768338810; cv=none; b=AG3RC4LagU+GeVFAJxyeE2kpj6/nRqagQhHrhUfu2h7fZr9zWU7vp4720FGOPHTHnSZJSnxSZ7000+FJT3rb09NI8wdRi7U+H5Giu1DxBs45EKccFyFFybnSp4Moe6gPr+5eZ67wx+8C3vrWlH+CrVSjR7JNPC9kjZmUepFhmdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768338810; c=relaxed/simple;
	bh=kkfYM9rcmzJqoKTEVUFgB3A/3RIlE2BUbnPkJCE0pb4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QNDBhTh2Rn5VlWjFo04ALt69Iodu1tDdygL4SQx4WjqsRNGd9tymgoVoSg0VTbsym7R32LsyEw8GzEDk0D76PHZSZXU9RCbjBZKsp1YqzVqGxFakFyG2yajyJ10JP8WqIMPOJF5bZOok7dsB0L0QCU1q8Wmn4xqqLpt1iJYZPc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7c70930bdf4so15031133a34.2
        for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 13:13:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768338808; x=1768943608;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ww9K08WdfheEaoLlst1by6MXgbFiqGH2FsG5ZH83AiU=;
        b=vDuIvg4Yk8pX6+IKHml/gSBTVtVBVO3aEgYDSu2ckEA81zrvub3HqctQngXSH/9JWL
         lgEIKp+qyYJoUIkJLKDED/8mmgDU4V3ubisyDnZe5PcUoj8tmof4f9Sh5SYndEWFHExV
         TnelPKgtcltnsRj/auoO9DWqKpicQOM2kMJL7aFbvvwKXEYyhBVEBV2r4ZK74P/eKHUF
         M3PIE6mnrPCLlvauJig4JNDpqMpTw4j5Pog7L7MsfkW8TvO28v2HjvK6zwDjc6H/duP6
         wZx4d33shV0NEB+8jA4vEl7MLoQvWkjq+v74NnTPuWOTUlNuF8INuWpHflHOVjqat82V
         H6cA==
X-Forwarded-Encrypted: i=1; AJvYcCVvcfxJKEoONLpCInYlsl649t1so1p5A/ywQpfdVzxsw3eQl5Q9IRAbXke87awrAr60cyZnba8ITw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxyy/CoQ/pq7DMvq15XtTvbYgGGYkNMkF3RYMgg/ZDhOLhkiJia
	iBQap+SO1SxY+ChDUZ1VM+oL3TmglALtV5iYWScKlxeKJHalczRem7i7Xg/ckDY6WoJipwZf6qt
	XOZP8WS4mwR1XayCX0BhK+DAAp1WyTRl0opvdr/aPq3l1hJdskDLIXXRAS9A=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:161e:b0:65f:6cf5:f963 with SMTP id
 006d021491bc7-661006767e1mr324854eaf.6.1768338808243; Tue, 13 Jan 2026
 13:13:28 -0800 (PST)
Date: Tue, 13 Jan 2026 13:13:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6966b578.a70a0220.245e30.0004.GAE@google.com>
Subject: [syzbot] [io-uring?] INFO: rcu detected stall in io_ring_exit_work (3)
From: syzbot <syzbot+33504742c13bcd6c9541@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f0b9d8eb98df Merge tag 'nfsd-6.19-3' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17eba922580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a11e0f726bfb6765
dashboard link: https://syzkaller.appspot.com/bug?extid=33504742c13bcd6c9541
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4dbba2a806a3/disk-f0b9d8eb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2a52c0f94de7/vmlinux-f0b9d8eb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5ddf9a24988b/bzImage-f0b9d8eb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+33504742c13bcd6c9541@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P7809/1:b..l
rcu: 	(detected by 0, t=10503 jiffies, g=47705, q=685 ncpus=2)
task:kworker/u8:22   state:R  running task     stack:23544 pid:7809  tgid:7809  ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: iou_exit io_ring_exit_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x1139/0x6150 kernel/sched/core.c:6863
 preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7190
 irqentry_exit+0x1d8/0x8c0 kernel/entry/common.c:216
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:unwind_next_frame+0x162b/0x20b0 arch/x86/kernel/unwind_orc.c:680
Code: 00 00 fc ff df 80 3c 02 00 0f 84 31 f8 ff ff 4c 89 e7 e8 58 f3 bb 00 e9 24 f8 ff ff 48 b8 00 00 00 00 00 fc ff df 48 8b 14 24 <48> c1 ea 03 80 3c 02 00 0f 85 a8 05 00 00 49 8d 7d 08 49 8b 5d 38
RSP: 0018:ffffc9000c7e7558 EFLAGS: 00000246
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: ffffc9000c7e8000
RDX: ffffc9000c7e7600 RSI: ffffc9000c7e79e0 RDI: ffffc9000c7e7608
RBP: ffffc9000c7e7bd0 R08: 0000000000000001 R09: 0000000077ba390a
R10: 0000000000000002 R11: 000000000003a058 R12: ffffc9000c7e7618
R13: ffffc9000c7e75c8 R14: ffffc9000c7e7a10 R15: ffffc9000c7e75fc
 arch_stack_walk+0x94/0x100 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:415
 kmalloc_noprof include/linux/slab.h:957 [inline]
 slab_free_hook mm/slub.c:2492 [inline]
 slab_free mm/slub.c:6670 [inline]
 kmem_cache_free+0x147/0x770 mm/slub.c:6781
 __io_req_caches_free+0x19e/0x5c0 io_uring/io_uring.c:2827
 io_req_caches_free io_uring/io_uring.c:2839 [inline]
 io_ring_exit_work+0x33c/0x1170 io_uring/io_uring.c:3025
 process_one_work+0x9ba/0x1b20 kernel/workqueue.c:3257
 process_scheduled_works kernel/workqueue.c:3340 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3421
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: rcu_preempt kthread starved for 10528 jiffies! g47705 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:28328 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x1139/0x6150 kernel/sched/core.c:6863
 __schedule_loop kernel/sched/core.c:6945 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:6960
 schedule_timeout+0x123/0x290 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x1ea/0xaf0 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x26d/0x380 kernel/rcu/tree.c:2285
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 0 UID: 0 PID: 12129 Comm: syz.5.1498 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:160 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x29/0x50 kernel/locking/spinlock.c:202
Code: 90 f3 0f 1e fa 53 48 8b 74 24 08 48 89 fb 48 83 c7 18 e8 7a fe 1e f6 48 89 df e8 32 51 1f f6 e8 9d 14 4c f6 fb bf 01 00 00 00 <e8> 42 54 0f f6 65 8b 05 9b b9 37 08 85 c0 74 06 5b e9 01 4d 00 00
RSP: 0018:ffffc9000ec8fca0 EFLAGS: 00000202
RAX: 0000000007584837 RBX: ffff888031ace5c0 RCX: ffffffff81c70a2f
RDX: 0000000000000000 RSI: ffffffff8dace031 RDI: 0000000000000001
RBP: ffff888031ace9c0 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff9088b8d7 R11: ffff88802bec0b30 R12: 0000000000000000
R13: 0000000000000021 R14: 0000000000000400 R15: ffff888031ace5c0
FS:  00007fc1128de6c0(0000) GS:ffff8881248f5000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc1128de040 CR3: 0000000043610000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 spin_unlock_irq include/linux/spinlock.h:401 [inline]
 get_signal+0x1e6a/0x26d0 kernel/signal.c:3037
 arch_do_signal_or_restart+0x8f/0x7e0 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
 exit_to_user_mode_loop+0x8c/0x540 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x4ee/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc11198f747
Code: ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 <0f> 05 48 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89
RSP: 002b:00007fc1128de0e8 EFLAGS: 00000246
RAX: 00000000000000ca RBX: 00007fc111be6098 RCX: 00007fc11198f749
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fc111be6098
RBP: 00007fc111be6090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc111be6128 R14: 00007fff61d0e6b0 R15: 00007fff61d0e798
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

