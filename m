Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391A5364CDF
	for <lists+io-uring@lfdr.de>; Mon, 19 Apr 2021 23:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhDSVK5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Apr 2021 17:10:57 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:36607 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhDSVK4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Apr 2021 17:10:56 -0400
Received: by mail-il1-f200.google.com with SMTP id t15-20020a92dc0f0000b029016b11675c42so12350933iln.3
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 14:10:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GxSpPYxkUsP/ERiVTjpzjF3u68ZCtAv+UgFiC84CCo4=;
        b=ND7gkJlTJIFjejtdZW6+t8Do5536u1v57+my6n891FyAG9QCXMSB3FPFog5njAKPQV
         Osf1OvlCOj2a0rL65+EBED4eqpnQzdwWNMS0ZIQR8IkW4mdVRy7FuiIK/6skZNmkxABJ
         7u4z2/rW4ISq+EQT6ee1Uovg8Wm+z1oWGGEDy0QaoJtYWM0XxCA4YFINQms3do9rzoOT
         kEAi5SSh7h6YHVkTsKFxGUhFy89Z9vtpGDdO5KCE3IlFUVVggl11g1nI0Rtm4esILBSL
         822sL4w+s+S+AQMfIWiBI0J2BSerbkkudvI4bCbGMxm+rNfQmEtygcPvY12N6kaHC5q9
         IYZA==
X-Gm-Message-State: AOAM53338ULvWQwKMzt1A5+5OmHYCE8lnsDhkoEThx4CNdU8SYg8lqqf
        R151hbrBTbeZdD55FdfYF1+6ac6GKw2mAqbeBY6v8x1FXYT6
X-Google-Smtp-Source: ABdhPJyH+56P9BDVL61iQj8tqGBuwYwwY3RHME4kqm6YgYLbwY+ooRl4E5DS2k8OkGzfxtfxjoBbKn/UsdjXNYaCUoHfZz1qYtBo
MIME-Version: 1.0
X-Received: by 2002:a6b:d60e:: with SMTP id w14mr16037432ioa.187.1618866625653;
 Mon, 19 Apr 2021 14:10:25 -0700 (PDT)
Date:   Mon, 19 Apr 2021 14:10:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029326505c059c220@google.com>
Subject: [syzbot] INFO: task hung in __io_uring_cancel
From:   syzbot <syzbot+47fc00967b06a3019bd2@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1216f02e Add linux-next specific files for 20210415
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=130bbeded00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3491b04113499f81
dashboard link: https://syzkaller.appspot.com/bug?extid=47fc00967b06a3019bd2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14734dc5d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16dfaf65d00000

The issue was bisected to:

commit d9d05217cb6990b9a56e13b56e7a1b71e2551f6c
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Fri Jan 8 20:57:25 2021 +0000

    io_uring: stop SQPOLL submit on creator's death

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11b86f9ad00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13b86f9ad00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15b86f9ad00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+47fc00967b06a3019bd2@syzkaller.appspotmail.com
Fixes: d9d05217cb69 ("io_uring: stop SQPOLL submit on creator's death")

INFO: task iou-sqp-8700:8701 blocked for more than 143 seconds.
      Not tainted 5.12.0-rc7-next-20210415-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:iou-sqp-8700    state:D stack:28960 pid: 8701 ppid:  8414 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4329 [inline]
 __schedule+0x917/0x2170 kernel/sched/core.c:5079
 schedule+0xcf/0x270 kernel/sched/core.c:5158
 __io_uring_cancel+0x285/0x420 fs/io_uring.c:8977
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x299/0x2a70 kernel/exit.c:780
 io_sq_thread+0x60a/0x1340 fs/io_uring.c:6873
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Showing all locks held in the system:
1 lock held by khungtaskd/1653:
 #0: ffffffff8bf76560 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6333
1 lock held by in:imklog/8133:
 #0: ffff888013088370 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:990

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1653 Comm: khungtaskd Not tainted 5.12.0-rc7-next-20210415-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
 watchdog+0xd3b/0xf50 kernel/hung_task.c:338
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 7 Comm: kworker/0:1 Not tainted 5.12.0-rc7-next-20210415-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events toggle_allocation_gate
RIP: 0010:__preempt_count_sub arch/x86/include/asm/preempt.h:85 [inline]
RIP: 0010:preempt_count_sub+0x56/0x150 kernel/sched/core.c:4772
Code: 85 e4 00 00 00 8b 0d 19 08 e5 0e 85 c9 75 1b 65 8b 05 ae 60 b3 7e 89 c2 81 e2 ff ff ff 7f 39 da 7c 13 81 fb fe 00 00 00 76 63 <f7> db 65 01 1d 91 60 b3 7e 5b c3 e8 4a cd c2 07 85 c0 74 f5 48 c7
RSP: 0018:ffffc90000cc79f8 EFLAGS: 00000002
RAX: 0000000080000002 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff83e7543f RDI: 0000000000000001
RBP: ffff8880b9c34a80 R08: 0000000000000002 R09: 000000000000eb19
R10: ffffffff83e7538c R11: 000000000000003f R12: 0000000000000008
R13: ffff888140120660 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffa2b511018 CR3: 000000000bc8e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 flush_tlb_mm_range+0x111/0x230 arch/x86/mm/tlb.c:957
 __text_poke+0x590/0x8c0 arch/x86/kernel/alternative.c:837
 text_poke_bp_batch+0x3d7/0x560 arch/x86/kernel/alternative.c:1150
 text_poke_flush arch/x86/kernel/alternative.c:1240 [inline]
 text_poke_flush arch/x86/kernel/alternative.c:1237 [inline]
 text_poke_finish+0x16/0x30 arch/x86/kernel/alternative.c:1247
 arch_jump_label_transform_apply+0x13/0x20 arch/x86/kernel/jump_label.c:122
 jump_label_update+0x1da/0x400 kernel/jump_label.c:825
 static_key_enable_cpuslocked+0x1b1/0x260 kernel/jump_label.c:177
 static_key_enable+0x16/0x20 kernel/jump_label.c:190
 toggle_allocation_gate mm/kfence/core.c:610 [inline]
 toggle_allocation_gate+0xbf/0x2e0 mm/kfence/core.c:602
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
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
