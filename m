Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D8356CD5A
	for <lists+io-uring@lfdr.de>; Sun, 10 Jul 2022 08:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiGJGfd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jul 2022 02:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJGfc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jul 2022 02:35:32 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE91DB49D
        for <io-uring@vger.kernel.org>; Sat,  9 Jul 2022 23:35:29 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id i8-20020a056e020d8800b002d931252904so1586435ilj.23
        for <io-uring@vger.kernel.org>; Sat, 09 Jul 2022 23:35:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=PYHrSxK6D4urlBuvXCPCwYEsgi3h0uafRu68kLSJB5k=;
        b=Xd2JBEDQUlxFM1x1vzUk6hNa+rHCLOvBbSDkYzURyrJ+3mlTBvCaiPkMfXSZZ8dWdF
         xiHF9W+FwzuflNKyGmJ0ERdPljObjYWsfjyRvzhMzFrrRutf8TatVMUtuMCNW2GUrvJY
         g4wVwg250TYrS6X8jrERKBz3du5PQPMxguWTVMTcsNBck1++QgLvoCALZBRppxxwVbh4
         Zpnqz9Yqr5QUfbTb1bXx/w5uJlugnZSfmuJcVOBqaV3PNDa7irDQa+ms5gD4cy+WGMGj
         7uJqlTC3dwm10/nWlOq8VDd3MpaH4QK10TIumGpyNdqEFYarj4Go/AYutMtxaaZRPGjm
         ao6g==
X-Gm-Message-State: AJIora/I1HQ/aArXXJCoJJWXfpiyFFtRIxMCtSwxMQ1hAPKmzzzK3IRc
        GeK/N6hmDLhkMefXXTiprcfy1Na+wBbC10KbpRwEsaqvEHOW
X-Google-Smtp-Source: AGRyM1twZEhViWdO/vM1Cu90saFZ815s7wDAcbYndnheUR22BGcMgDoCynoSySfj6l/8ez4PCtvU/lsVDFZg6eb7j05U7pMkHWRY
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:194c:b0:2dc:3f21:63d9 with SMTP id
 x12-20020a056e02194c00b002dc3f2163d9mr6786632ilu.104.1657434929234; Sat, 09
 Jul 2022 23:35:29 -0700 (PDT)
Date:   Sat, 09 Jul 2022 23:35:29 -0700
In-Reply-To: <00000000000081366905da43b67d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000320b7e05e36da4a0@google.com>
Subject: Re: [syzbot] INFO: task hung in io_uring_del_tctx_node (2)
From:   syzbot <syzbot+771a9fd5d128e0a5708c@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    cb71b93c2dc3 Add linux-next specific files for 20220628
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1779602c080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=badbc1adb2d582eb
dashboard link: https://syzkaller.appspot.com/bug?extid=771a9fd5d128e0a5708c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17011514080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1204baa2080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+771a9fd5d128e0a5708c@syzkaller.appspotmail.com

INFO: task syz-executor616:3671 blocked for more than 143 seconds.
      Not tainted 5.19.0-rc4-next-20220628-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor616 state:D stack:27536 pid: 3671 ppid:  3600 flags:0x00104004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5184 [inline]
 __schedule+0xa09/0x4f10 kernel/sched/core.c:6496
 schedule+0xd2/0x1f0 kernel/sched/core.c:6568
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6627
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa70/0x1350 kernel/locking/mutex.c:747
 io_uring_del_tctx_node+0x110/0x2b6 io_uring/tctx.c:175
 io_uring_clean_tctx+0xce/0x174 io_uring/tctx.c:191
 io_uring_cancel_generic+0x5aa/0x602 io_uring/io_uring.c:2885
 io_uring_files_cancel include/linux/io_uring.h:44 [inline]
 do_exit+0x4f9/0x29f0 kernel/exit.c:750
 do_group_exit+0xd2/0x2f0 kernel/exit.c:925
 __do_sys_exit_group kernel/exit.c:936 [inline]
 __se_sys_exit_group kernel/exit.c:934 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:934
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7ff32cbe16f9
RSP: 002b:00007ffcbffc2738 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007ff32cc563f0 RCX: 00007ff32cbe16f9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000004140
R10: 0000000000008011 R11: 0000000000000246 R12: 00007ff32cc563f0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>

Showing all locks held in the system:
1 lock held by rcu_tasks_kthre/12:
 #0: ffffffff8bd864f0 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0xc70 kernel/rcu/tasks.h:507
1 lock held by rcu_tasks_trace/13:
 #0: ffffffff8bd861f0 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0xc70 kernel/rcu/tasks.h:507
1 lock held by khungtaskd/28:
 #0: ffffffff8bd87040 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6491
2 locks held by getty/3275:
 #0: ffff88807f2e8098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:244
 #1: ffffc90002d162f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xe50/0x13c0 drivers/tty/n_tty.c:2177
1 lock held by syz-executor616/3671:
 #0: ffff88807eb3c0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_uring_del_tctx_node+0x110/0x2b6 io_uring/tctx.c:175
5 locks held by iou-sqp-3671/3672:

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 28 Comm: khungtaskd Not tainted 5.19.0-rc4-next-20220628-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1e6/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:212 [inline]
 watchdog+0xc18/0xf50 kernel/hung_task.c:369
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 3672 Comm: iou-sqp-3671 Not tainted 5.19.0-rc4-next-20220628-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
RIP: 0010:get_current arch/x86/include/asm/current.h:15 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x13/0x60 kernel/kcov.c:199
Code: 02 66 0f 1f 44 00 00 48 8b be a8 01 00 00 e8 b4 ff ff ff 31 c0 c3 90 65 8b 05 29 b8 87 7e 89 c1 48 8b 34 24 81 e1 00 01 00 00 <65> 48 8b 14 25 80 6f 02 00 a9 00 01 ff 00 74 0e 85 c9 74 35 8b 82
RSP: 0018:ffffc9000313f650 EFLAGS: 00000246
RAX: 0000000080000000 RBX: ffff88813fffc320 RCX: 0000000000000000
RDX: ffff8880220a8000 RSI: ffffffff81a97d33 RDI: 0000000000000004
RBP: 0000000000000004 R08: 0000000000000004 R09: 0000000000000004
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: ffff88813fffa000 R14: ffffc9000313f7e0 R15: dffffc0000000000
FS:  000055555676a300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff32cc59370 CR3: 0000000024fc8000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 zonelist_zone_idx include/linux/mmzone.h:1160 [inline]
 next_zones_zonelist include/linux/mmzone.h:1191 [inline]
 shrink_zones mm/vmscan.c:3474 [inline]
 do_try_to_free_pages+0x403/0x16f0 mm/vmscan.c:3590
 try_to_free_mem_cgroup_pages+0x31e/0x920 mm/vmscan.c:3904
 try_charge_memcg+0x500/0x1440 mm/memcontrol.c:2756
 obj_cgroup_charge_pages mm/memcontrol.c:3163 [inline]
 __memcg_kmem_charge_page+0x183/0x3d0 mm/memcontrol.c:3189
 __alloc_pages+0x1ef/0x510 mm/page_alloc.c:5523
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2280
 io_refill_buffer_cache io_uring/kbuf.c:379 [inline]
 io_add_buffers io_uring/kbuf.c:405 [inline]
 io_provide_buffers+0x87d/0xff0 io_uring/kbuf.c:457
 io_issue_sqe+0x15e/0xd20 io_uring/io_uring.c:1601
 io_queue_sqe io_uring/io_uring.c:1778 [inline]
 io_submit_sqe io_uring/io_uring.c:2036 [inline]
 io_submit_sqes+0x9a6/0x1ec0 io_uring/io_uring.c:2147
 __io_sq_thread io_uring/sqpoll.c:193 [inline]
 io_sq_thread+0x708/0xf60 io_uring/sqpoll.c:252
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 </TASK>
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   6:	48 8b be a8 01 00 00 	mov    0x1a8(%rsi),%rdi
   d:	e8 b4 ff ff ff       	callq  0xffffffc6
  12:	31 c0                	xor    %eax,%eax
  14:	c3                   	retq
  15:	90                   	nop
  16:	65 8b 05 29 b8 87 7e 	mov    %gs:0x7e87b829(%rip),%eax        # 0x7e87b846
  1d:	89 c1                	mov    %eax,%ecx
  1f:	48 8b 34 24          	mov    (%rsp),%rsi
  23:	81 e1 00 01 00 00    	and    $0x100,%ecx
* 29:	65 48 8b 14 25 80 6f 	mov    %gs:0x26f80,%rdx <-- trapping instruction
  30:	02 00
  32:	a9 00 01 ff 00       	test   $0xff0100,%eax
  37:	74 0e                	je     0x47
  39:	85 c9                	test   %ecx,%ecx
  3b:	74 35                	je     0x72
  3d:	8b                   	.byte 0x8b
  3e:	82                   	.byte 0x82

