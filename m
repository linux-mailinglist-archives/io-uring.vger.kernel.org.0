Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC7A318DE38
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2020 06:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgCUFuO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Mar 2020 01:50:14 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:48425 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgCUFuN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Mar 2020 01:50:13 -0400
Received: by mail-il1-f197.google.com with SMTP id c12so7134973ilo.15
        for <io-uring@vger.kernel.org>; Fri, 20 Mar 2020 22:50:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Ro/B9jenTZO+tdDGyTIWCstmRnpqPpcDs+7mvrNB3nY=;
        b=U29b+sZcUay0w1w+z4ulTIbhpJpw1iGC2xZpt9Mlt2cGCiX4ZkuEw5vM10FUuAQ9cS
         vYWpuarLKZ9adYQZabZHF+SFDX6MWIOkVaxvsZU4ifZAFat0Tw9N4cwXWtCmQVh1T6ne
         r78B20aO61sPiTLlDgOA9Nab4d7f/n4GQ5EpDqTa3ESRb+gtlec+S5tbtzxsHd4eHmUz
         h17XpFgRoh9tLWmVy8GaMyB+LKa0nDT9zm0fkOr905lluysUShNOveLjZAVPBojN+M2p
         J8SXGNHhdcgSxfzA173aTSeP+NIgbCK/ICJ9ALgXLJziJfVkQsh/aLWM+VJ2+ByEilTE
         TgEQ==
X-Gm-Message-State: ANhLgQ3OqBrCNsaTgPm1N5Y5SXby6d2/cY4pfEjG0bksDD4ERBeaGZ8Y
        7mRk/+1S/34h7QF/Sazhy64J0ZKE4/JR59Gd0neLU8LNcw9k
X-Google-Smtp-Source: ADFU+vuLFUrKMFhhz0YD9MWpxOqaiweOznxlVJRJ09oE1bGKoGNbIeFDq0OV7pNU426bT0/FcqjdiecKf+U6IThLJwjvV/oVq75E
MIME-Version: 1.0
X-Received: by 2002:a92:5ccd:: with SMTP id d74mr11187208ilg.59.1584769812467;
 Fri, 20 Mar 2020 22:50:12 -0700 (PDT)
Date:   Fri, 20 Mar 2020 22:50:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b9175f05a156f991@google.com>
Subject: INFO: task hung in io_queue_file_removal
From:   syzbot <syzbot+538d1957ce178382a394@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    cd607737 Merge tag '5.6-rc6-smb3-fixes' of git://git.samba..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1730c023e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9f894bd92023de02
dashboard link: https://syzkaller.appspot.com/bug?extid=538d1957ce178382a394
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=108ebbe3e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139fb973e00000

The bug was bisected to:

commit 05f3fb3c5397524feae2e73ee8e150a9090a7da2
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Dec 9 18:22:50 2019 +0000

    io_uring: avoid ring quiesce for fixed file set unregister and update

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1237ad73e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1137ad73e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1637ad73e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+538d1957ce178382a394@syzkaller.appspotmail.com
Fixes: 05f3fb3c5397 ("io_uring: avoid ring quiesce for fixed file set unregister and update")

INFO: task syz-executor975:9880 blocked for more than 143 seconds.
      Not tainted 5.6.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor975 D27576  9880   9878 0x80004000
Call Trace:
 schedule+0xd0/0x2a0 kernel/sched/core.c:4154
 schedule_timeout+0x6db/0xba0 kernel/time/timer.c:1871
 do_wait_for_common kernel/sched/completion.c:83 [inline]
 __wait_for_common kernel/sched/completion.c:104 [inline]
 wait_for_common kernel/sched/completion.c:115 [inline]
 wait_for_completion+0x26a/0x3c0 kernel/sched/completion.c:136
 io_queue_file_removal+0x1af/0x1e0 fs/io_uring.c:5826
 __io_sqe_files_update.isra.0+0x3a1/0xb00 fs/io_uring.c:5867
 io_sqe_files_update fs/io_uring.c:5918 [inline]
 __io_uring_register+0x377/0x2c00 fs/io_uring.c:7131
 __do_sys_io_uring_register fs/io_uring.c:7202 [inline]
 __se_sys_io_uring_register fs/io_uring.c:7184 [inline]
 __x64_sys_io_uring_register+0x192/0x560 fs/io_uring.c:7184
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440659
Code: Bad RIP value.
RSP: 002b:00007ffc4689a358 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007ffc4689a360 RCX: 0000000000440659
RDX: 0000000020000300 RSI: 0000000000000006 RDI: 0000000000000003
RBP: 0000000000000005 R08: 0000000000000001 R09: 00007ffc46890031
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000401f40
R13: 0000000000401fd0 R14: 0000000000000000 R15: 0000000000000000

Showing all locks held in the system:
1 lock held by khungtaskd/1137:
 #0: ffffffff897accc0 (rcu_read_lock){....}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5331
1 lock held by rsyslogd/9761:
 #0: ffff8880a8f3ada0 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xe3/0x100 fs/file.c:821
2 locks held by getty/9850:
 #0: ffff88809fad3090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
 #1: ffffc900017bb2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x21d/0x1b30 drivers/tty/n_tty.c:2156
2 locks held by getty/9851:
 #0: ffff8880a7b96090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
 #1: ffffc900017cb2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x21d/0x1b30 drivers/tty/n_tty.c:2156
2 locks held by getty/9852:
 #0: ffff88809e41c090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
 #1: ffffc900017eb2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x21d/0x1b30 drivers/tty/n_tty.c:2156
2 locks held by getty/9853:
 #0: ffff888090392090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
 #1: ffffc900017ab2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x21d/0x1b30 drivers/tty/n_tty.c:2156
2 locks held by getty/9854:
 #0: ffff88809fb1b090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
 #1: ffffc900017db2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x21d/0x1b30 drivers/tty/n_tty.c:2156
2 locks held by getty/9855:
 #0: ffff88809a302090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
 #1: ffffc9000178b2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x21d/0x1b30 drivers/tty/n_tty.c:2156
2 locks held by getty/9856:
 #0: ffff88809d9dc090 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
 #1: ffffc9000172b2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x21d/0x1b30 drivers/tty/n_tty.c:2156
1 lock held by syz-executor975/9880:
 #0: ffff88808f392320 (&ctx->uring_lock){+.+.}, at: __do_sys_io_uring_register fs/io_uring.c:7201 [inline]
 #0: ffff88808f392320 (&ctx->uring_lock){+.+.}, at: __se_sys_io_uring_register fs/io_uring.c:7184 [inline]
 #0: ffff88808f392320 (&ctx->uring_lock){+.+.}, at: __x64_sys_io_uring_register+0x181/0x560 fs/io_uring.c:7184

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1137 Comm: khungtaskd Not tainted 5.6.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
 watchdog+0xa8c/0x1010 kernel/hung_task.c:289
 kthread+0x357/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0 skipped: idling at native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:60


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
