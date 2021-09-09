Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A8B40420D
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 02:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348062AbhIIAK2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 20:10:28 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:35620 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347973AbhIIAK0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 20:10:26 -0400
Received: by mail-il1-f198.google.com with SMTP id b5-20020a92db05000000b0022c6493d0e5so161959iln.2
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 17:09:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=f9JDtlDNgAiKWOeJQqZ+jhVp+uIKqLFY+K0VgxPDgJM=;
        b=bxP2WSxcBztEl8KSSFVTk4IEL6nR73VEQ1OI42xIpXmpryGOAumGHMbAJ2pRkCskiD
         gittTE5HGnc3NNs/Ml58v+yfirTEiCsTfoAd5HsFRPMw1AlbSVjHWhh0MzSxxugpn7fv
         oWfxMbinlJPxbfLRRRmW3u4rPyOrCoR8ehjuh4SzizA4ILHT3OPbwVWEanyQwv2OEXMu
         pJ0wpON7j4ps4YfxhR7w/3bmmTv204f3o2/C6aHccKYzPq2jzp3mZtifZjp4hyOxTyOD
         Fx67ipujLM1fbJxrsoEFlTkgBtjC4II7iI6+92d/TWU7OFOZRSkJTWk/gwwu911+1WqA
         dafw==
X-Gm-Message-State: AOAM533pxXSL7MZakBSpPrOhbXHckGiF1WfMMPzqjSZopjZk2NI17ttU
        nWuYuOOxoJRqFSl/rj86KMeRuZPFLw74tvJTuRPwp/nJGfNS
X-Google-Smtp-Source: ABdhPJxjutmq8HJxRTZP3PZbQnLw7sP2X/GtXKENjZnKlQ4sP7zvgMgtTg7TjTD/FScccZGMUHtmHVTSyxULFQcNiQ+t9WmNipal
MIME-Version: 1.0
X-Received: by 2002:a92:130e:: with SMTP id 14mr95475ilt.129.1631146157259;
 Wed, 08 Sep 2021 17:09:17 -0700 (PDT)
Date:   Wed, 08 Sep 2021 17:09:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000047c10a05cb84cf00@google.com>
Subject: [syzbot] INFO: task hung in io_wq_put_and_exit
From:   syzbot <syzbot+f62d3e0a4ea4f38f5326@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4b93c544e90e thunderbolt: test: split up test cases in tb_..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=111b2c2b300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ac2f9cc43f6b17e4
dashboard link: https://syzkaller.appspot.com/bug?extid=f62d3e0a4ea4f38f5326
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1152501b300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16612dcd300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f62d3e0a4ea4f38f5326@syzkaller.appspotmail.com

INFO: task syz-executor687:8514 blocked for more than 143 seconds.
      Not tainted 5.14.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor687 state:D stack:27296 pid: 8514 ppid:  8479 flags:0x00024004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
 io_wq_exit_workers fs/io-wq.c:1162 [inline]
 io_wq_put_and_exit+0x40c/0xc70 fs/io-wq.c:1197
 io_uring_clean_tctx fs/io_uring.c:9607 [inline]
 io_uring_cancel_generic+0x5fe/0x740 fs/io_uring.c:9687
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x265/0x2a30 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2160 kernel/signal.c:2868
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x445cd9
RSP: 002b:00007fc657f4b308 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000001 RBX: 00000000004cb448 RCX: 0000000000445cd9
RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00000000004cb44c
RBP: 00000000004cb440 R08: 000000000000000e R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000049b154
R13: 0000000000000003 R14: 00007fc657f4b400 R15: 0000000000022000

Showing all locks held in the system:
1 lock held by khungtaskd/1655:
 #0: ffffffff8b97f960 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1655 Comm: khungtaskd Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xc1d/0xf50 kernel/hung_task.c:295
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 10 Comm: kworker/u4:1 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:__text_poke+0x5f0/0x8c0 arch/x86/kernel/alternative.c:878
Code: fb 48 8b 7c 24 60 e8 5f 67 0d 08 48 8b 4c 24 18 48 b8 00 00 00 00 00 fc ff df 48 c7 04 01 00 00 00 00 48 8b 84 24 98 00 00 00 <65> 48 2b 04 25 28 00 00 00 0f 85 2e 02 00 00 48 81 c4 a0 00 00 00
RSP: 0018:ffffc90000cf7a00 EFLAGS: 00000286
RAX: cfe52cf07638a100 RBX: 0000000000000007 RCX: 1ffff9200019ef48
RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000001
RBP: ffff888011eaa558 R08: 0000000000000000 R09: ffff888010db8123
R10: ffffed10021b7024 R11: 000000000000003f R12: ffffffff81bcfd53
R13: 0000000000000001 R14: 0000000000000d54 R15: ffffffff8baa9900
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f442218f000 CR3: 000000000b68e000 CR4: 0000000000350ef0
Call Trace:
 text_poke_bp_batch+0x3d7/0x560 arch/x86/kernel/alternative.c:1178
 text_poke_flush arch/x86/kernel/alternative.c:1268 [inline]
 text_poke_flush arch/x86/kernel/alternative.c:1265 [inline]
 text_poke_finish+0x16/0x30 arch/x86/kernel/alternative.c:1275
 arch_jump_label_transform_apply+0x13/0x20 arch/x86/kernel/jump_label.c:146
 jump_label_update+0x1d5/0x430 kernel/jump_label.c:830
 static_key_enable_cpuslocked+0x1b1/0x260 kernel/jump_label.c:177
 static_key_enable+0x16/0x20 kernel/jump_label.c:190
 toggle_allocation_gate mm/kfence/core.c:623 [inline]
 toggle_allocation_gate+0x100/0x390 mm/kfence/core.c:615
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
----------------
Code disassembly (best guess):
   0:	fb                   	sti
   1:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
   6:	e8 5f 67 0d 08       	callq  0x80d676a
   b:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  10:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  17:	fc ff df
  1a:	48 c7 04 01 00 00 00 	movq   $0x0,(%rcx,%rax,1)
  21:	00
  22:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  29:	00
* 2a:	65 48 2b 04 25 28 00 	sub    %gs:0x28,%rax <-- trapping instruction
  31:	00 00
  33:	0f 85 2e 02 00 00    	jne    0x267
  39:	48 81 c4 a0 00 00 00 	add    $0xa0,%rsp


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
