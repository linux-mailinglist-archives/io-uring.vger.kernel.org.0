Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FC64E57E0
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 18:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239878AbiCWRyA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 13:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239821AbiCWRx7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 13:53:59 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47ADB8596B
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 10:52:29 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id w28-20020a05660205dc00b00645d3cdb0f7so1544525iox.10
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 10:52:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JGGdnfvE8NQt/Hsqyx0a3k4wVl66FIbV8KbT7INVJQo=;
        b=WubuSUm6fULGmv2wlWQp4xbrQU1otiDfRjt+W7p+V+NTKzhu5D8/ye4QUBXxBWIdJJ
         Cw5P1UoiJ9r8MEcewrRKLdzxCvzVFMkSNALxdp276UGaxF26XdNKMpvnRiHPErx4kiYz
         THbxrfRVrB/f6QFwfBDY3mtXyLxA6FezykbTBQleBZIl+A0ebhv/Ug1d7hgcsVB+svbu
         wIrbomdQb9gB1ZuwoGlBgS5ormoRZDDNkO52X9CfAohrhlaEW6Un4lGI+Ob5mn6Npkvg
         pDu48zm37COr7MyQs8YzXEJA0eeX/yGVV2red8Gevk9nlN00W3S+pHxPe7AjpOLLfzE+
         uzdA==
X-Gm-Message-State: AOAM532Sv2ajF8d3yC0raOL1Sy04Agxdt3gm+c8MkH+pKZvXMDZlkPd2
        ktI/xuT+4mw+4Pfdp0OpwX2RwFCXiNxrXRbqpsa23NWGDhNy
X-Google-Smtp-Source: ABdhPJxEvuGA4NpKyX0id0+7kNbtjJ06SE7T/JaE/IW+vvNm1DgBFbs2jLYzaJvv4Btq/BCHOYf0+nMARGNUA7yXvDZwCdXg8xfY
MIME-Version: 1.0
X-Received: by 2002:a05:6638:12c5:b0:321:38e0:64b with SMTP id
 v5-20020a05663812c500b0032138e0064bmr615067jas.28.1648057948693; Wed, 23 Mar
 2022 10:52:28 -0700 (PDT)
Date:   Wed, 23 Mar 2022 10:52:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000099e7a405dae66418@google.com>
Subject: [syzbot] INFO: task hung in io_wq_put_and_exit (3)
From:   syzbot <syzbot+adb05ed2853417be49ce@syzkaller.appspotmail.com>
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

Hello,

syzbot found the following issue on:

HEAD commit:    b47d5a4f6b8d Merge tag 'audit-pr-20220321' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15e065dd700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=63af44f0631a5c3a
dashboard link: https://syzkaller.appspot.com/bug?extid=adb05ed2853417be49ce
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d673db700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14627e25700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+adb05ed2853417be49ce@syzkaller.appspotmail.com

INFO: task syz-executor123:3634 blocked for more than 143 seconds.
      Tainted: G        W         5.17.0-syzkaller-01442-gb47d5a4f6b8d #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor123 state:D stack:28160 pid: 3634 ppid:  3633 flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4995 [inline]
 __schedule+0xa94/0x4910 kernel/sched/core.c:6304
 schedule+0xd2/0x1f0 kernel/sched/core.c:6376
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x2af/0x360 kernel/sched/completion.c:106
 io_wq_exit_workers fs/io-wq.c:1264 [inline]
 io_wq_put_and_exit+0x4d6/0xe40 fs/io-wq.c:1299
 io_uring_clean_tctx fs/io_uring.c:10512 [inline]
 io_uring_cancel_generic+0x60b/0x695 fs/io_uring.c:10582
 io_uring_files_cancel include/linux/io_uring.h:18 [inline]
 do_exit+0x4f9/0x29d0 kernel/exit.c:761
 do_group_exit+0xd2/0x2f0 kernel/exit.c:936
 __do_sys_exit_group kernel/exit.c:947 [inline]
 __se_sys_exit_group kernel/exit.c:945 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:945
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fa616b7dbd9
RSP: 002b:00007ffd0ba19358 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007fa616bf2350 RCX: 00007fa616b7dbd9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa616bf2350
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>
INFO: lockdep is turned off.
NMI backtrace for cpu 1
CPU: 1 PID: 28 Comm: khungtaskd Tainted: G        W         5.17.0-syzkaller-01442-gb47d5a4f6b8d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1e6/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:212 [inline]
 watchdog+0xc1d/0xf50 kernel/hung_task.c:369
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 3635 Comm: iou-wrk-3634 Tainted: G        W         5.17.0-syzkaller-01442-gb47d5a4f6b8d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__ldsem_down_read_nested+0x32/0x850 drivers/tty/tty_ldsem.c:297
Code: ff df 41 57 41 56 41 89 f6 41 55 41 54 49 89 fc 55 4d 8d 7c 24 70 48 89 d5 53 48 81 ec c8 00 00 00 48 c7 44 24 28 b3 8a b5 41 <4c> 8d 6c 24 28 48 c7 44 24 30 c8 4d 47 8b 49 c1 ed 03 48 c7 44 24
RSP: 0018:ffffc9000115f718 EFLAGS: 00000296
RAX: dffffc0000000000 RBX: ffff88814a2bd000 RCX: 0000000000000000
RDX: 7fffffffffffffff RSI: 0000000000000000 RDI: ffff88814a2bd028
RBP: 7fffffffffffffff R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff843a08bd R11: 0000000000000000 R12: ffff88814a2bd028
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88814a2bd098
FS:  000055555665d300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055555665d2c0 CR3: 0000000072dfd000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:244
 tty_read+0x1a2/0x5d0 drivers/tty/tty_io.c:928
 call_read_iter include/linux/fs.h:2068 [inline]
 io_iter_do_read fs/io_uring.c:3789 [inline]
 io_read+0x330/0x12a0 fs/io_uring.c:3859
 io_issue_sqe+0x813/0x8390 fs/io_uring.c:7172
 io_wq_submit_work+0x1ed/0x590 fs/io_uring.c:7340
 io_worker_handle_work+0xad6/0x1b30 fs/io-wq.c:595
 io_wqe_worker+0x606/0xd40 fs/io-wq.c:642
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.426 msecs
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	df 41 57             	filds  0x57(%rcx)
   3:	41 56                	push   %r14
   5:	41 89 f6             	mov    %esi,%r14d
   8:	41 55                	push   %r13
   a:	41 54                	push   %r12
   c:	49 89 fc             	mov    %rdi,%r12
   f:	55                   	push   %rbp
  10:	4d 8d 7c 24 70       	lea    0x70(%r12),%r15
  15:	48 89 d5             	mov    %rdx,%rbp
  18:	53                   	push   %rbx
  19:	48 81 ec c8 00 00 00 	sub    $0xc8,%rsp
  20:	48 c7 44 24 28 b3 8a 	movq   $0x41b58ab3,0x28(%rsp)
  27:	b5 41
* 29:	4c 8d 6c 24 28       	lea    0x28(%rsp),%r13 <-- trapping instruction
  2e:	48 c7 44 24 30 c8 4d 	movq   $0xffffffff8b474dc8,0x30(%rsp)
  35:	47 8b
  37:	49 c1 ed 03          	shr    $0x3,%r13
  3b:	48                   	rex.W
  3c:	c7                   	.byte 0xc7
  3d:	44                   	rex.R
  3e:	24                   	.byte 0x24


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
