Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AAC325408
	for <lists+io-uring@lfdr.de>; Thu, 25 Feb 2021 17:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhBYQvG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Feb 2021 11:51:06 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:35174 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbhBYQtA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Feb 2021 11:49:00 -0500
Received: by mail-il1-f197.google.com with SMTP id i7so4795391ilu.2
        for <io-uring@vger.kernel.org>; Thu, 25 Feb 2021 08:48:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bm5KVUwsuOTCPxuT3237AJb+zASH625uTeaABViY/E4=;
        b=D9ToaOJcj/RRqVQhy5Fw8/75I0vTpEgtk8jNaEvPAiZL59coDx96DDf8JZ62tq+iRl
         s184xLCvsuf6jRnWfuWmNtZIKgYGdBWxLBp+2dLv/kjdLM1+sHuBD5FBnN5iFsKbRAer
         KqFZId5pRdnc4LxeK/husOel07bVdqjKEp/1ac+xB93RAJq+bK4rvQxvBmrHo+sZz+6c
         AZGMKi9vzivzc99YWJ9jLSVJN5OkSC8LgLhoyOxnQzp8WLFrDAEiVDX8kCLPWMAn/TJ0
         U7O9cezfDIwHuGaJ8ijU/USiQKqgg7s4MOYSZdtwba5N3Sqi6F9ZWiuE19EtaBP0KqAa
         Cdlw==
X-Gm-Message-State: AOAM530OJzx068Htq5qHrK/fd1hEO3b/jTfUyhwvgE3ofWMpHAPYlItS
        94bBdIS/fS2/cmBB4//cgKnxh+iTWn4LfxdBES46nuLIgyX7
X-Google-Smtp-Source: ABdhPJzvJ1H0QFwLKUYOmSNqLN/tdD/HPnxUWAv6tONgOjtqmE8onuWd9jXfUqY2vJG3seUNScYY6UXd/ckbLlqrs/x73JvcA4RV
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3316:: with SMTP id b22mr3419944ioz.69.1614271697365;
 Thu, 25 Feb 2021 08:48:17 -0800 (PST)
Date:   Thu, 25 Feb 2021 08:48:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000017b19205bc2beb40@google.com>
Subject: INFO: task can't die in io_sq_thread_finish
From:   syzbot <syzbot+c927c937cba8ef66dd4a@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7f206cf3 Add linux-next specific files for 20210225
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16d9516cd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1746d2802a82a05
dashboard link: https://syzkaller.appspot.com/bug?extid=c927c937cba8ef66dd4a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b9c5a8d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c927c937cba8ef66dd4a@syzkaller.appspotmail.com

INFO: task syz-executor.0:12538 can't die for more than 143 seconds.
task:syz-executor.0  state:D stack:28352 pid:12538 ppid:  8423 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_sq_thread_finish+0x96/0x580 fs/io_uring.c:7152
 io_sq_offload_create fs/io_uring.c:7929 [inline]
 io_uring_create fs/io_uring.c:9465 [inline]
 io_uring_setup+0x1fb2/0x2c20 fs/io_uring.c:9550
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
RSP: 002b:00007fe26f744108 EFLAGS: 00000202 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465ef9
RDX: 0000000020ffd000 RSI: 0000000020000040 RDI: 000000000000563c
RBP: 0000000020000040 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
R13: 0000000020ffd000 R14: 0000000000000000 R15: 0000000020ffc000
INFO: task syz-executor.0:12538 blocked for more than 143 seconds.
      Not tainted 5.11.0-next-20210225-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:28352 pid:12538 ppid:  8423 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_sq_thread_finish+0x96/0x580 fs/io_uring.c:7152
 io_sq_offload_create fs/io_uring.c:7929 [inline]
 io_uring_create fs/io_uring.c:9465 [inline]
 io_uring_setup+0x1fb2/0x2c20 fs/io_uring.c:9550
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
RSP: 002b:00007fe26f744108 EFLAGS: 00000202 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465ef9
RDX: 0000000020ffd000 RSI: 0000000020000040 RDI: 000000000000563c
RBP: 0000000020000040 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
R13: 0000000020ffd000 R14: 0000000000000000 R15: 0000000020ffc000
INFO: task iou-sqp-12538:12557 can't die for more than 143 seconds.
task:iou-sqp-12538   state:D stack:30296 pid:12557 ppid:  8423 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_sq_thread+0x27d/0x19a0 fs/io_uring.c:6731
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task iou-sqp-12538:12557 blocked for more than 143 seconds.
      Not tainted 5.11.0-next-20210225-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:iou-sqp-12538   state:D stack:30296 pid:12557 ppid:  8423 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_sq_thread+0x27d/0x19a0 fs/io_uring.c:6731
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Showing all locks held in the system:
1 lock held by khungtaskd/1653:
 #0: ffffffff8bf744e0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6327
1 lock held by in:imklog/8109:
 #0: ffff8880126b65f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:961
2 locks held by kworker/u4:3/8814:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1653 Comm: khungtaskd Not tainted 5.11.0-next-20210225-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0xfa/0x151 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:147 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
 watchdog+0xd8e/0xf40 kernel/hung_task.c:338
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 10404 Comm: kworker/u4:9 Not tainted 5.11.0-next-20210225-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy14 ieee80211_iface_work
RIP: 0010:orc_find arch/x86/kernel/unwind_orc.c:163 [inline]
RIP: 0010:unwind_next_frame+0x238/0x2000 arch/x86/kernel/unwind_orc.c:443
Code: ff 39 d6 0f 83 69 12 00 00 48 ba 00 00 00 00 00 fc ff df 41 89 f0 4a 8d 3c 85 08 a7 d7 8e 49 89 f9 49 c1 e9 03 45 0f b6 0c 11 <48> 89 fa 83 e2 07 83 c2 03 44 38 ca 7c 32 45 84 c9 74 2d 4c 89 44
RSP: 0018:ffffc9000c146d18 EFLAGS: 00000a02
RAX: 0000000000000000 RBX: 1ffff92001828dab RCX: ffffffff81325e95
RDX: dffffc0000000000 RSI: 000000000000325e RDI: ffffffff8ed87080
RBP: 0000000000000001 R08: 000000000000325e R09: 0000000000000000
R10: 0000000000084087 R11: 0000000000000000 R12: ffffc9000c146e88
R13: ffffc9000c146e75 R14: ffffc9000c146e90 R15: ffffc9000c146e40
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd5c6299010 CR3: 0000000026149000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __unwind_start+0x51b/0x800 arch/x86/kernel/unwind_orc.c:699
 unwind_start arch/x86/include/asm/unwind.h:60 [inline]
 arch_stack_walk+0x5c/0xe0 arch/x86/kernel/stacktrace.c:24
 stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:121
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc mm/kasan/common.c:506 [inline]
 ____kasan_kmalloc mm/kasan/common.c:465 [inline]
 __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
 kmalloc include/linux/slab.h:559 [inline]
 ieee802_11_parse_elems_crc+0x121/0xfe0 net/mac80211/util.c:1473
 ieee802_11_parse_elems net/mac80211/ieee80211_i.h:2041 [inline]
 ieee80211_bss_info_update+0x4b4/0xb20 net/mac80211/scan.c:212
 ieee80211_rx_bss_info net/mac80211/ibss.c:1126 [inline]
 ieee80211_rx_mgmt_probe_beacon+0xccd/0x16b0 net/mac80211/ibss.c:1615
 ieee80211_ibss_rx_queued_mgmt+0xe43/0x1870 net/mac80211/ibss.c:1642
 ieee80211_iface_work+0x761/0x9e0 net/mac80211/iface.c:1439
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
