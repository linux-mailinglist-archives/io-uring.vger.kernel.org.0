Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74A648045C
	for <lists+io-uring@lfdr.de>; Mon, 27 Dec 2021 20:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhL0TMW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Dec 2021 14:12:22 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:38486 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbhL0TMW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Dec 2021 14:12:22 -0500
Received: by mail-io1-f72.google.com with SMTP id l124-20020a6b3e82000000b005ed165a1506so7342311ioa.5
        for <io-uring@vger.kernel.org>; Mon, 27 Dec 2021 11:12:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Wzm0trF7V7vseXUMMgo6/GF3zXg34E8rhJyKwEnCbhQ=;
        b=fPhWYc5maUHAsrFwn+Pi1l4EmrAbdfBC7IRXhTnUkoeWLDf2rk1Z4jICr1MbDAWsfx
         OZMYD4iT5qqCKkVzXJ4G0daMvvePq77++rcEWHx8fCm/dIAZ9vCkYogM6qakEDawKiZs
         VfAZ/kXD3aFoqoKcNbXktvdOG2kUa1VeQfwBFtxn6Z83uLWfshz5exeACboC7UK338PC
         RdDAyFLfH21Yq0B+bZOIWQwuiJ6lA9B0It4ruzpBXNlTLMeDrlBYS5oqHg0wgjCZIB8W
         q+wgsL9WYyZDHCozFCvPl1icwiyQ+qNnkmh++m23/HlNJ4gL68z71EOfU0Jx+4UcACcE
         D/Lw==
X-Gm-Message-State: AOAM530INYyHmHzBNu3mpISlVYbAsM3RYuQROKwP8Wnk32f5F98wdICL
        pGXWDxHVPSHHC4+CMepjpwLhvuNSIerBJDys0Gb9XVFAaVQa
X-Google-Smtp-Source: ABdhPJzUf+4pAwS8C9+VIHwHokwEyE9nHTBmYhZjxu/quXthTEXPsLxjHdeFUCDeNcxqN3O/GgfzvehuIqEHa06xqydfLbSIai7n
MIME-Version: 1.0
X-Received: by 2002:a92:c265:: with SMTP id h5mr8531491ild.36.1640632341580;
 Mon, 27 Dec 2021 11:12:21 -0800 (PST)
Date:   Mon, 27 Dec 2021 11:12:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ed500e05d4257b54@google.com>
Subject: [syzbot] INFO: task hung in io_uring_release (2)
From:   syzbot <syzbot+f4dee1c474a6e3f68100@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bc491fb12513 Merge tag 'fixes-2021-12-22' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=165b1a5db00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6104739ac5f067ea
dashboard link: https://syzkaller.appspot.com/bug?extid=f4dee1c474a6e3f68100
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f4dee1c474a6e3f68100@syzkaller.appspotmail.com

INFO: task syz-executor.2:8284 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:26704 pid: 8284 ppid:  3729 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xb72/0x1460 kernel/sched/core.c:6253
 schedule+0x12b/0x1f0 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common+0xd1f/0x2590 kernel/locking/mutex.c:680
 __mutex_lock kernel/locking/mutex.c:740 [inline]
 mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:792
 io_ring_ctx_wait_and_kill+0xa0/0x36a fs/io_uring.c:9565
 io_uring_release+0x59/0x63 fs/io_uring.c:9594
 __fput+0x3fc/0x870 fs/file_table.c:280
 task_work_run+0x146/0x1c0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x209/0x220 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x2e/0x70 kernel/entry/common.c:300
 do_syscall_64+0x53/0xd0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f7b18378adb
RSP: 002b:00007ffe8c741150 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00007f7b18378adb
RDX: 0000001b2cc20000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007f7b184da960 R08: 0000000000000000 R09: 0000000000000010
R10: 00007ffe8c76b0b8 R11: 0000000000000293 R12: 000000000007cb81
R13: 00007f7b184dfb50 R14: 00007f7b184d9370 R15: 0000000000000005
 </TASK>
INFO: task syz-executor.2:8285 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:23728 pid: 8285 ppid:  3729 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xb72/0x1460 kernel/sched/core.c:6253
 schedule+0x12b/0x1f0 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common+0xd1f/0x2590 kernel/locking/mutex.c:680
 __mutex_lock kernel/locking/mutex.c:740 [inline]
 mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:792
 io_uring_del_tctx_node+0xe4/0x2a9 fs/io_uring.c:9777
 io_uring_clean_tctx+0x192/0x1d5 fs/io_uring.c:9793
 io_uring_cancel_generic+0x629/0x671 fs/io_uring.c:9884
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x281/0x24f0 kernel/exit.c:787
 do_group_exit+0x168/0x2d0 kernel/exit.c:929
 get_signal+0x1740/0x2120 kernel/signal.c:2852
 arch_do_signal_or_restart+0x9c/0x730 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x191/0x220 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x2e/0x70 kernel/entry/common.c:300
 do_syscall_64+0x53/0xd0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f7b183c5e99
RSP: 002b:00007f7b16d3b218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f7b184d8f68 RCX: 00007f7b183c5e99
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f7b184d8f68
RBP: 00007f7b184d8f60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f7b184d8f6c
R13: 00007ffe8c7410ef R14: 00007f7b16d3b300 R15: 0000000000022000
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/27:
 #0: ffffffff8cb1de00 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30
2 locks held by getty/3280:
 #0: ffff88807f219098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x21/0x70 drivers/tty/tty_ldisc.c:252
 #1: ffffc90002b962e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6c5/0x1c60 drivers/tty/n_tty.c:2113
1 lock held by syz-executor.2/8284:
 #0: ffff88801de6e0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_ring_ctx_wait_and_kill+0xa0/0x36a fs/io_uring.c:9565
1 lock held by syz-executor.2/8285:
 #0: ffff88801de6e0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_uring_del_tctx_node+0xe4/0x2a9 fs/io_uring.c:9777
1 lock held by syz-executor.2/8302:
 #0: ffff88801de6e0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: tctx_task_work+0x2e5/0x560 fs/io_uring.c:2242

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 27 Comm: khungtaskd Not tainted 5.16.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1dc/0x2d8 lib/dump_stack.c:106
 nmi_cpu_backtrace+0x45f/0x490 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x16a/0x280 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xc82/0xcd0 kernel/hung_task.c:295
 kthread+0x468/0x490 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 1090 Comm: kworker/u4:5 Not tainted 5.16.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy4 ieee80211_iface_work
RIP: 0010:unwind_next_frame+0x42f/0x1fc0 arch/x86/kernel/unwind_orc.c:456
Code: 03 42 8a 04 30 84 c0 0f 85 0c 16 00 00 c6 03 01 48 c7 c5 80 80 6b 8a 4c 8d 7d 04 48 8d 5d 05 4d 89 fc 49 c1 ec 03 43 8a 04 34 <84> c0 0f 85 8e 15 00 00 48 89 d8 48 c1 e8 03 42 8a 04 30 84 c0 0f
RSP: 0018:ffffc90004ecf0c0 EFLAGS: 00000a06
RAX: 0000000000000000 RBX: ffffffff8efe0283 RCX: ffffffff8e677054
RDX: ffffffff8efe027e RSI: ffffffff89835db7 RDI: ffffffff813ab429
RBP: ffffffff8efe027e R08: 0000000000000001 R09: ffffc90004ecf270
R10: fffff520009d9e3c R11: 0000000000000000 R12: 1ffffffff1dfc050
R13: ffffffff8e677050 R14: dffffc0000000000 R15: ffffffff8efe0282
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c015a2e2c8 CR3: 000000000c88e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 arch_stack_walk+0x112/0x140 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x11b/0x1e0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc+0xdc/0x110 mm/kasan/common.c:513
 kasan_kmalloc include/linux/kasan.h:269 [inline]
 __kmalloc+0x253/0x380 mm/slub.c:4423
 kmalloc include/linux/slab.h:595 [inline]
 kzalloc+0x1d/0x30 include/linux/slab.h:724
 cfg80211_inform_single_bss_frame_data net/wireless/scan.c:2397 [inline]
 cfg80211_inform_bss_frame_data+0x427/0x1f40 net/wireless/scan.c:2458
 ieee80211_bss_info_update+0x75b/0xbe0 net/mac80211/scan.c:190
 ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
 ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1610 [inline]
 ieee80211_ibss_rx_queued_mgmt+0x1690/0x2b30 net/mac80211/ibss.c:1639
 ieee80211_iface_process_skb net/mac80211/iface.c:1468 [inline]
 ieee80211_iface_work+0x709/0xc90 net/mac80211/iface.c:1522
 process_one_work+0x853/0x1140 kernel/workqueue.c:2298
 worker_thread+0xac1/0x1320 kernel/workqueue.c:2445
 kthread+0x468/0x490 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30
 </TASK>
----------------
Code disassembly (best guess):
   0:	03 42 8a             	add    -0x76(%rdx),%eax
   3:	04 30                	add    $0x30,%al
   5:	84 c0                	test   %al,%al
   7:	0f 85 0c 16 00 00    	jne    0x1619
   d:	c6 03 01             	movb   $0x1,(%rbx)
  10:	48 c7 c5 80 80 6b 8a 	mov    $0xffffffff8a6b8080,%rbp
  17:	4c 8d 7d 04          	lea    0x4(%rbp),%r15
  1b:	48 8d 5d 05          	lea    0x5(%rbp),%rbx
  1f:	4d 89 fc             	mov    %r15,%r12
  22:	49 c1 ec 03          	shr    $0x3,%r12
  26:	43 8a 04 34          	mov    (%r12,%r14,1),%al
* 2a:	84 c0                	test   %al,%al <-- trapping instruction
  2c:	0f 85 8e 15 00 00    	jne    0x15c0
  32:	48 89 d8             	mov    %rbx,%rax
  35:	48 c1 e8 03          	shr    $0x3,%rax
  39:	42 8a 04 30          	mov    (%rax,%r14,1),%al
  3d:	84 c0                	test   %al,%al
  3f:	0f                   	.byte 0xf


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
