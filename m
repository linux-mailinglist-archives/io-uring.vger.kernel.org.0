Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0671256ADE
	for <lists+io-uring@lfdr.de>; Sun, 30 Aug 2020 02:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgH3AI2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Aug 2020 20:08:28 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:49819 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728109AbgH3AIQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Aug 2020 20:08:16 -0400
Received: by mail-il1-f198.google.com with SMTP id b18so2225918ilh.16
        for <io-uring@vger.kernel.org>; Sat, 29 Aug 2020 17:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=WP/oTxD4ikGNevYxi/Gik02i9253kfcXZ0yBayVCSiw=;
        b=KP6ULYqU/EErSxIZgu0QVocNalIm4m7sV4WkqLZ11KWVr24Wv66OB8syOvax/o56+V
         cWttkrQlL3WP678KEsKyP2VavI7a6hPQoQgrezIuYt9/sktJ0cSR7gM8T20yjICsqjFm
         d8afq8P1ysdVJwpc2mKQI8cudUBnDDbpQ3gnYlWWKZbIJjAra+H618knIMwT1ABVC1qz
         em8wsGVEturLgwX97YUn0BWU8R6DLblNlqb8k22//bAs57qNmE6ALji5uOFFgP7VRIhc
         Dyp9ukU6Cgh6jr2Hv7hcR/erXQg31EYSQfK0JIgUNCRe9i/VrdzugGpznwPy1y+nqzM4
         883A==
X-Gm-Message-State: AOAM533NVPR29qbloOKYKaDtpAKwv+eqAU/XDblb1TWoMrl2hCkOg2mg
        27W9p7j84tjC5dbItAQvw3cZdeVrlHwnHsBlPMR249/ZfqOR
X-Google-Smtp-Source: ABdhPJw0JMQM6lalm7PDDjvr3fjL+p7YaO8HuhgTbLhVq72JaBaadXE+3ga9zfRLPZamFWJ2sINujFnqlzWJO93bryjdalEo7G+0
MIME-Version: 1.0
X-Received: by 2002:a92:5e5b:: with SMTP id s88mr3893010ilb.65.1598746095507;
 Sat, 29 Aug 2020 17:08:15 -0700 (PDT)
Date:   Sat, 29 Aug 2020 17:08:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001bdf9705ae0d151b@google.com>
Subject: possible deadlock in __lock_task_sighand
From:   syzbot <syzbot+6e8f5b555cce8fac0423@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, christian@brauner.io, ebiederm@xmission.com,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, liuzhiqiang26@huawei.com,
        oleg@redhat.com, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    abb3438d Merge tag 'm68knommu-for-v5.9-rc3' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10bb5105900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=978db74cb30aa994
dashboard link: https://syzkaller.appspot.com/bug?extid=6e8f5b555cce8fac0423
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=123a3996900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=158b8eb6900000

The issue was bisected to:

commit 0ba9c9edcd152158a0e321a4c13ac1dfc571ff3d
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Aug 7 01:41:50 2020 +0000

    io_uring: use TWA_SIGNAL for task_work uncondtionally

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1672c549900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1572c549900000
console output: https://syzkaller.appspot.com/x/log.txt?x=1172c549900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6e8f5b555cce8fac0423@syzkaller.appspotmail.com
Fixes: 0ba9c9edcd15 ("io_uring: use TWA_SIGNAL for task_work uncondtionally")

============================================
WARNING: possible recursive locking detected
5.9.0-rc2-syzkaller #0 Not tainted
--------------------------------------------
syz-executor339/7010 is trying to acquire lock:
ffff888094030058 (&sighand->siglock){....}-{2:2}, at: __lock_task_sighand+0x106/0x2d0 kernel/signal.c:1390

but task is already holding lock:
ffff888094030058 (&sighand->siglock){....}-{2:2}, at: force_sig_info_to_task+0x6c/0x3a0 kernel/signal.c:1316

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&sighand->siglock);
  lock(&sighand->siglock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by syz-executor339/7010:
 #0: ffff888094030058 (&sighand->siglock){....}-{2:2}, at: force_sig_info_to_task+0x6c/0x3a0 kernel/signal.c:1316
 #1: ffff8880940300a0 (&sighand->signalfd_wqh){....}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:122
 #2: ffffffff89bd6900 (rcu_read_lock){....}-{1:2}, at: __lock_task_sighand+0x0/0x2d0 kernel/signal.c:1352

stack backtrace:
CPU: 1 PID: 7010 Comm: syz-executor339 Not tainted 5.9.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_deadlock_bug kernel/locking/lockdep.c:2391 [inline]
 check_deadlock kernel/locking/lockdep.c:2432 [inline]
 validate_chain kernel/locking/lockdep.c:3202 [inline]
 __lock_acquire.cold+0x115/0x396 kernel/locking/lockdep.c:4426
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:5005
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x8c/0xc0 kernel/locking/spinlock.c:159
 __lock_task_sighand+0x106/0x2d0 kernel/signal.c:1390
 lock_task_sighand include/linux/sched/signal.h:687 [inline]
 task_work_add+0x1d7/0x290 kernel/task_work.c:51
 io_req_task_work_add fs/io_uring.c:1765 [inline]
 __io_async_wake+0x415/0x980 fs/io_uring.c:4589
 __wake_up_common+0x147/0x650 kernel/sched/wait.c:93
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:123
 signalfd_notify include/linux/signalfd.h:22 [inline]
 __send_signal+0x75b/0xf90 kernel/signal.c:1163
 force_sig_info_to_task+0x2a0/0x3a0 kernel/signal.c:1333
 force_sig_fault_to_task kernel/signal.c:1672 [inline]
 force_sig_fault+0xb0/0xf0 kernel/signal.c:1679
 __bad_area_nosemaphore+0x32a/0x480 arch/x86/mm/fault.c:778
 do_user_addr_fault+0x852/0xbf0 arch/x86/mm/fault.c:1257
 handle_page_fault arch/x86/mm/fault.c:1351 [inline]
 exc_page_fault+0xa8/0x160 arch/x86/mm/fault.c:1404
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:538
RIP: 0033:0x4013f9
Code: 00 20 00 c6 04 25 3d 02 00 20 00 c6 04 25 3e 02 00 20 00 c6 04 25 3f 02 00 20 00 48 8b 15 a7 ac 2d 00 48 8b 34 25 00 02 00 20 <8b> 8a 0c 01 00 00 48 89 30 48 8b 34 25 08 02 00 20 c1 e1 04 48 89
RSP: 002b:00007f8507d67d10 EFLAGS: 00010246
RAX: ffffffffffffffff RBX: 00000000006f0038 RCX: 0000000000000000
RDX: ffffffffffffffff RSI: 0000000600000002 RDI: 0000000000000000
RBP: 00000000006f0030 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006f003c
R13: 00007f8507d67d10 R14: 00007f8507d67d10 R15: 0000000000000001


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
