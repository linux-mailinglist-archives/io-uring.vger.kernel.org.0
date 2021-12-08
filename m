Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE10B46C86F
	for <lists+io-uring@lfdr.de>; Wed,  8 Dec 2021 01:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242692AbhLHAIK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Dec 2021 19:08:10 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:42757 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242662AbhLHAIJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Dec 2021 19:08:09 -0500
Received: by mail-io1-f70.google.com with SMTP id k125-20020a6bba83000000b005e7a312f86dso1123572iof.9
        for <io-uring@vger.kernel.org>; Tue, 07 Dec 2021 16:04:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=LLxo9yR1C18zIZFvHekT6AM9u91kgXbh230N0pjOmj0=;
        b=qSAlETV8bUIkW5b7FuEmckZLnr9GNAgy4sCYNrQMzD/hHNQTKcI01fAv/Nz2iJ/LlZ
         xf7XfRlnXgieTzDWZzP2coFFLBPuKiyeXBZ0m2GtxIanxR0J1OhwWMW3+r6KgIlJClpg
         pgPTYSW2rdz7yY5m9yheWSdcgyh1mdoEWTfHRkjx27RqWkNYZyYKss1b87C0IBzRC/jp
         3dWPhcc99bFnbncORV7vyayTsgm3UDqHd7q6YaOLBpHlFa0SSDvgQxdJyTysy0v8i8PI
         nh8m1+aEG6HaCaPsIrtSe8ZbQHQJbktEGNLwqD9J5b4YgCQFqOpbtEHKrGCrbkxCLAmB
         zeJg==
X-Gm-Message-State: AOAM5318XYtii1mZsGQNyfUntslVfgcX6ZUdGdfFuwwokeBU01f7sZj/
        sMfzWp6RbgYqNaQ4rwbhHkHxzdxXY98i7hLtPAipiYKMYSjK
X-Google-Smtp-Source: ABdhPJzwtIGXpwhfc9nPR0X8NX8x3rvEQSVjP9FRj6evJC/xYLpptRmTscIkhvqr+WbnevHpJ6HZ1lUDP0k8Su+rE4LfgJPNanqJ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d1e:: with SMTP id i30mr2058617ila.182.1638921878414;
 Tue, 07 Dec 2021 16:04:38 -0800 (PST)
Date:   Tue, 07 Dec 2021 16:04:38 -0800
In-Reply-To: <000000000000e016c205d1025f4c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000060ab3b05d2973c1a@google.com>
Subject: Re: [syzbot] INFO: task hung in io_uring_cancel_generic (2)
From:   syzbot <syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    cd8c917a56f2 Makefile: Do not quote value for CONFIG_CC_IM..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=153be575b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5247c9e141823545
dashboard link: https://syzkaller.appspot.com/bug?extid=21e6887c0be14181206d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1218dce1b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16f91d89b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com

INFO: task syz-executor255:7795 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor255 state:D stack:28448 pid: 7795 ppid:  6531 flags:0x00024004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 io_uring_cancel_generic+0x53d/0x690 fs/io_uring.c:9877
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x60c/0x2b40 kernel/exit.c:787
 do_group_exit+0x125/0x310 kernel/exit.c:929
 get_signal+0x47d/0x2220 kernel/signal.c:2852
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f413d0aaa59
RSP: 002b:00007f413d05c308 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f413d132408 RCX: 00007f413d0aaa59
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f413d132408
RBP: 00007f413d132400 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f413d13240c
R13: 0000000000000003 R14: 00007f413d05c400 R15: 0000000000022000
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/27:
 #0: ffffffff8bb811a0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6458
1 lock held by in:imklog/6223:
 #0: ffff88801d98d670 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:994

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 27 Comm: khungtaskd Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xc1d/0xf50 kernel/hung_task.c:295
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 2964 Comm: systemd-journal Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:on_stack arch/x86/include/asm/stacktrace.h:58 [inline]
RIP: 0010:stack_access_ok arch/x86/kernel/unwind_orc.c:342 [inline]
RIP: 0010:deref_stack_reg+0x0/0x150 arch/x86/kernel/unwind_orc.c:352
Code: 14 24 e9 7b ff ff ff 48 89 14 24 e8 da 25 89 00 48 8b 14 24 e9 48 ff ff ff 48 89 0c 24 e8 c8 25 89 00 48 8b 0c 24 eb 9d 66 90 <48> b8 00 00 00 00 00 fc ff df 41 55 41 54 49 89 fc 55 48 89 f5 53
RSP: 0018:ffffc90001ad79b0 EFLAGS: 00000046
RAX: ffffc90001ad7bb8 RBX: 1ffff9200035af3f RCX: ffffffff8e10151b
RDX: ffffc90001ad7ad8 RSI: ffffc90001ad7bb0 RDI: ffffc90001ad7a90
RBP: 0000000000000001 R08: ffffffff8e101516 R09: 0000000000000001
R10: fffff5200035af5d R11: 000000000008808a R12: ffffc90001ad7ad8
R13: ffffc90001ad7ac5 R14: ffffc90001ad7a90 R15: ffffffff8e10151a
FS:  00007f48af6af8c0(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f48aca93018 CR3: 000000007738a000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 unwind_next_frame+0xcdc/0x1ce0 arch/x86/kernel/unwind_orc.c:534
 arch_stack_walk+0x7d/0xe0 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:122
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xd1/0x110 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:235 [inline]
 __cache_free mm/slab.c:3445 [inline]
 kmem_cache_free.part.0+0x91/0x200 mm/slab.c:3741
 security_file_free+0xa4/0xd0 security/security.c:1535
 file_free fs/file_table.c:55 [inline]
 __fput+0x3d6/0x9f0 fs/file_table.c:298
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f48aec3e840
Code: 73 01 c3 48 8b 0d 68 77 20 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 bb 20 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 1e f6 ff ff 48 89 04 24
RSP: 002b:00007ffd32e9b188 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: fffffffffffffffe RBX: 00007ffd32e9b490 RCX: 00007f48aec3e840
RDX: 00000000000001a0 RSI: 0000000000080042 RDI: 000055dc34efa230
RBP: 000000000000000d R08: 00000000000001e0 R09: 00000000ffffffff
R10: 0000000000000069 R11: 0000000000000246 R12: 00000000ffffffff
R13: 000055dc34eef060 R14: 00007ffd32e9b450 R15: 000055dc34efa320
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.354 msecs
----------------
Code disassembly (best guess):
   0:	14 24                	adc    $0x24,%al
   2:	e9 7b ff ff ff       	jmpq   0xffffff82
   7:	48 89 14 24          	mov    %rdx,(%rsp)
   b:	e8 da 25 89 00       	callq  0x8925ea
  10:	48 8b 14 24          	mov    (%rsp),%rdx
  14:	e9 48 ff ff ff       	jmpq   0xffffff61
  19:	48 89 0c 24          	mov    %rcx,(%rsp)
  1d:	e8 c8 25 89 00       	callq  0x8925ea
  22:	48 8b 0c 24          	mov    (%rsp),%rcx
  26:	eb 9d                	jmp    0xffffffc5
  28:	66 90                	xchg   %ax,%ax
* 2a:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax <-- trapping instruction
  31:	fc ff df
  34:	41 55                	push   %r13
  36:	41 54                	push   %r12
  38:	49 89 fc             	mov    %rdi,%r12
  3b:	55                   	push   %rbp
  3c:	48 89 f5             	mov    %rsi,%rbp
  3f:	53                   	push   %rbx

