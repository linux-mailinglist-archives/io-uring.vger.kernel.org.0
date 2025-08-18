Return-Path: <io-uring+bounces-9014-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E47B29B9C
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 10:06:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8DA23A6F51
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 08:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72A8C2D8382;
	Mon, 18 Aug 2025 08:05:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D07E28032D
	for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 08:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755504335; cv=none; b=kfXnQqbhN2QU3PlfDrT2581RTXLnCPbkEgPOnjhXcyrzb8wpYCnUyS5vqx2f4nOhSewsaT+f1vxhEksN7bt/lkWGq6NWTfJ4T5i4uPhYM1EBL9jyLufAZ7ZNLWL4xtlAgE4cq5qRasYMDasXSCNncu8TW+3QAXfnXOhpM1OhJs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755504335; c=relaxed/simple;
	bh=ig1lCVGIZW1cFY1+bZjuV0LDV6UrnwQRVMUc7Eyi3Ls=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=gy5XYD9GjU/cYJK6Tl4/5hzZ8aV+0JHuw0gQHxFd6yN1QA2awg6dbNuHYWWvqCvEZs6aZXBxgi2P478q7J/kkdzQVeb7N+T46c/ST8p1WJ42N2tI78uGZQsJcjzfaO/QkoKVgbWN0WvmHWERMunwMuDQxkgds9C+BTR0sEM2d1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-88432e1c782so490822739f.2
        for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 01:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755504333; x=1756109133;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eLczjwMaa4aMfcBnpjLNtOtfQ1qI5i1YqFLRTX73HpU=;
        b=ub7+XXfRdVs0GGFgWNWSkKJP39dWeHu7pygg3XzbcRQtTIYtiQAMfty3dsy/swo0LZ
         wlWdSXRH5II5FkzX3ZZYH3CGNKYoILVnx9WV8wnR9IOX3SPl7PF8bPhrrS0Gnu71nwhd
         b4H8TbHc8H8m9iIe3OAHa479mhSbens/W+f8b532FbiMkdy3AbpVXe6OvwxoJ1znz+R5
         XeW6XODOUvv+wh3I3Q4cI/zCivX4uYE4dVvY90q0g7xgNR8+SXS4RXkSl+zUEzhZg9Ic
         ICkC40eK8h5zQ43CcfMjE3oDF7W1h2lA6IlrgvYKa7gsk92aB6tkWC1RgDY48qUSBCBP
         BXXg==
X-Forwarded-Encrypted: i=1; AJvYcCVVFMjFlca14OoPRI/46QSsAhNvR/2lhNN4/smD1SmddIVddiuSEmjM+bzuuqze4Vk4Y8SkdAdHIg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxfH6Jkxeyf8B9Mawj6G7Z0Cul1SLxWaX8wep46vIoH0CZIXgwn
	zGGRAw/+AcR/cJbEP5s+Z8hrUNevxbrxhO5S8yOf+37HmmoXYIBFuGtW0T+g8bGYQUEA5x9Tlkv
	LRO5X8ae95ndoAbA78ar8DnF9szvkamPwkvNUSe0dzEbTYCvmqbCBcX+sJbQ=
X-Google-Smtp-Source: AGHT+IGcAxrYZiXsSOxEzX+IqZscj8Oik174LGo7xM9Q4tyTaDiBl0Q67NqA3VJ7GHDkfFkgsD+fj78I+9j99SqNubVtd9DA6112
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6c10:b0:881:8a58:3bc2 with SMTP id
 ca18e2360f4ac-8843e3d77e5mr2018618339f.6.1755504332825; Mon, 18 Aug 2025
 01:05:32 -0700 (PDT)
Date: Mon, 18 Aug 2025 01:05:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a2decc.050a0220.e29e5.0099.GAE@google.com>
Subject: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (6)
From: syzbot <syzbot+4eb282331cab6d5b6588@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, axboe@kernel.dk, frederic@kernel.org, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    931e46dcbc7e Add linux-next specific files for 20250814
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16d26ba2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a286bd75352e92fa
dashboard link: https://syzkaller.appspot.com/bug?extid=4eb282331cab6d5b6588
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13d206f0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e993a2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fb896162d550/disk-931e46dc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/45f6f857b82c/vmlinux-931e46dc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0f16e70143e1/bzImage-931e46dc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4eb282331cab6d5b6588@syzkaller.appspotmail.com

INFO: task syz-executor369:6499 blocked for more than 143 seconds.
      Not tainted 6.17.0-rc1-next-20250814-syzkaller #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor369 state:D stack:27984 pid:6499  tgid:6498  ppid:5865   task_flags:0x400548 flags:0x00024002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7058
 schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:100 [inline]
 __wait_for_common kernel/sched/completion.c:121 [inline]
 wait_for_common kernel/sched/completion.c:132 [inline]
 wait_for_completion+0x2bf/0x5d0 kernel/sched/completion.c:153
 io_wq_exit_workers io_uring/io-wq.c:1327 [inline]
 io_wq_put_and_exit+0x316/0x650 io_uring/io-wq.c:1355
 io_uring_clean_tctx+0x11f/0x1a0 io_uring/tctx.c:203
 io_uring_cancel_generic+0x6ca/0x7d0 io_uring/io_uring.c:3272
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x345/0x2300 kernel/exit.c:907
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1102
 get_signal+0x1286/0x1340 kernel/signal.c:3034
 arch_do_signal_or_restart+0x9a/0x750 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop+0x75/0x110 kernel/entry/common.c:40
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fec3779c659
RSP: 002b:00007fec37752218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fec37823328 RCX: 00007fec3779c659
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fec37823328
RBP: 00007fec37823320 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fec377f0270
R13: 0000000000000000 R14: 0000200000000200 R15: 00007ffd3af7b848
 </TASK>
INFO: lockdep is turned off.
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Not tainted 6.17.0-rc1-next-20250814-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:332 [inline]
 watchdog+0xf60/0xfa0 kernel/hung_task.c:495
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6811 Comm: iou-wrk-6807 Not tainted 6.17.0-rc1-next-20250814-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:native_read_msr_safe arch/x86/include/asm/msr.h:121 [inline]
RIP: 0010:__rdmsr_safe_on_cpu+0x3c/0x130 arch/x86/lib/msr-smp.c:156
Code: bd 00 00 00 00 00 fc ff df e8 10 d2 bd fc 48 89 d8 48 c1 e8 03 42 0f b6 04 28 84 c0 0f 85 82 00 00 00 44 8b 23 44 89 e1 0f 32 <31> ed 49 89 c7 49 89 d6 0f 1f 44 00 00 e8 e2 d1 bd fc 49 c1 e6 20
RSP: 0018:ffffc90004e17428 EFLAGS: 00000046
RAX: 0000000000000000 RBX: ffffc90004e17600 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8be34be0 RDI: ffffc90004e17600
RBP: ffffc90004e17538 R08: ffffffff8fa3b137 R09: 1ffffffff1f47626
R10: dffffc0000000000 R11: ffffffff8501d3e0 R12: 0000000000000000
R13: dffffc0000000000 R14: ffffffff8501d3e0 R15: 1ffff920009c2eb9
FS:  00007fec377526c0(0000) GS:ffff888125c0f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000a89000 CR3: 0000000026df2000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 csd_do_func kernel/smp.c:136 [inline]
 generic_exec_single+0x237/0x500 kernel/smp.c:439
 smp_call_function_single_async+0x79/0x110 kernel/smp.c:732
 rdmsr_safe_on_cpu+0x127/0x230 arch/x86/lib/msr-smp.c:179
 msr_read+0x14d/0x250 arch/x86/kernel/msr.c:66
 loop_rw_iter+0x425/0x660 include/linux/uio.h:-1
 io_iter_do_read io_uring/rw.c:830 [inline]
 __io_read+0x1326/0x14f0 io_uring/rw.c:941
 io_read+0x1c/0x60 io_uring/rw.c:1020
 __io_issue_sqe+0x17e/0x4b0 io_uring/io_uring.c:1773
 io_issue_sqe+0x165/0xfd0 io_uring/io_uring.c:1796
 io_wq_submit_work+0x6e9/0xb90 io_uring/io_uring.c:1908
 io_worker_handle_work+0x7cd/0x1180 io_uring/io-wq.c:650
 io_wq_worker+0x42f/0xeb0 io_uring/io-wq.c:704
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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

