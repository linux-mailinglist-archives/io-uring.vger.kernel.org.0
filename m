Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3002DC832
	for <lists+io-uring@lfdr.de>; Wed, 16 Dec 2020 22:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgLPVOw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 16:14:52 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:56268 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729173AbgLPVOw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 16:14:52 -0500
Received: by mail-io1-f70.google.com with SMTP id j25so25215267iog.22
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 13:14:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7rbBwBeV/nUETB0HX2YQTZLq8NtHHXhsQ9iVBDLUlb8=;
        b=rveOOLlNdYZuE/00ZBo2fOUiqS4IVW5m9J+wuhslcrVV7kUU7n2QhsbSx52ZQRhIpt
         9k5y7tQy6Elj9DslI2J6VKX8Q2wWTib4Xg74bPXAvDf8aXfLmXOh26M68iZgc2i+pnJ8
         wfSS38WeieLSxx7yGHRwZyN9lgqrxrtt1kx6XiYAS2tdLcQ/VGEz5WHLqielBVOlegRO
         o/GARQ+ZEyeUQaQq+HXUtRLl0AJlMq6rVwznxqEncte1Svit9T1wWd8JBDjFeUUAjqfN
         Zjpl33XR1YaSRa/n0hcwsQvwKrG2ORZho6U/blr4L2ImG0gLeeooqCoRUwDIrGOUpjhs
         hvKw==
X-Gm-Message-State: AOAM530ytLpuBwRE573Bb3uNLMrYM21y2UCh7AExZ1YQe8XtWmcZ5V/F
        xdpnsVPZ465wanJmbb9diWSX/lJBUpb8KV0KGTs9yujDGXm8
X-Google-Smtp-Source: ABdhPJyqmiJMUD6GHtjjg2+G/jYr1VHHiSnXuOqnG8Qh4hgNXA50xhKwIh3GkFHi34aGlEINr2arQQoNpkvYiPztEFNF3LUKc3i/
MIME-Version: 1.0
X-Received: by 2002:a92:6b05:: with SMTP id g5mr46445714ilc.289.1608153251528;
 Wed, 16 Dec 2020 13:14:11 -0800 (PST)
Date:   Wed, 16 Dec 2020 13:14:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004d454d05b69b5bd3@google.com>
Subject: WARNING in percpu_ref_kill_and_confirm (2)
From:   syzbot <syzbot+c9937dfb2303a5f18640@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, mingo@redhat.com, peterz@infradead.org,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7b1b868e Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1156046b500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3416bb960d5c705d
dashboard link: https://syzkaller.appspot.com/bug?extid=c9937dfb2303a5f18640
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1407c287500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10ed5f07500000

The issue was bisected to:

commit 4d004099a668c41522242aa146a38cc4eb59cb1e
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Oct 2 09:04:21 2020 +0000

    lockdep: Fix lockdep recursion

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14e9d433500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16e9d433500000
console output: https://syzkaller.appspot.com/x/log.txt?x=12e9d433500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c9937dfb2303a5f18640@syzkaller.appspotmail.com
Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")

RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441309
RDX: 0000000000000002 RSI: 00000000200000c0 RDI: 0000000000003ad1
RBP: 000000000000f2ae R08: 0000000000000002 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021d0
R13: 0000000000402260 R14: 0000000000000000 R15: 0000000000000000
------------[ cut here ]------------
percpu_ref_kill_and_confirm called more than once on io_ring_ctx_ref_free!
WARNING: CPU: 0 PID: 8476 at lib/percpu-refcount.c:382 percpu_ref_kill_and_confirm+0x126/0x180 lib/percpu-refcount.c:382
Modules linked in:
CPU: 0 PID: 8476 Comm: syz-executor389 Not tainted 5.10.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:percpu_ref_kill_and_confirm+0x126/0x180 lib/percpu-refcount.c:382
Code: 5d 08 48 8d 7b 08 48 89 fa 48 c1 ea 03 80 3c 02 00 75 5d 48 8b 53 08 48 c7 c6 00 4b 9d 89 48 c7 c7 60 4a 9d 89 e8 c6 97 f6 04 <0f> 0b 48 b8 00 00 00 00 00 fc ff df 48 89 ea 48 c1 ea 03 80 3c 02
RSP: 0018:ffffc9000b94fe10 EFLAGS: 00010086
RAX: 0000000000000000 RBX: ffff888011da4580 RCX: 0000000000000000
RDX: ffff88801fe84ec0 RSI: ffffffff8158c835 RDI: fffff52001729fb4
RBP: ffff88801539f000 R08: 0000000000000001 R09: ffff8880b9e2011b
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000293
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88802de28758
FS:  00000000014ab880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2a7046b000 CR3: 0000000023368000 CR4: 0000000000350ef0
Call Trace:
 percpu_ref_kill include/linux/percpu-refcount.h:149 [inline]
 io_ring_ctx_wait_and_kill+0x2b/0x450 fs/io_uring.c:8382
 io_uring_release+0x3e/0x50 fs/io_uring.c:8420
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:151
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:164 [inline]
 exit_to_user_mode_prepare+0x17e/0x1a0 kernel/entry/common.c:191
 syscall_exit_to_user_mode+0x38/0x260 kernel/entry/common.c:266
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441309
Code: e8 5c ae 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffed6545d38 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: fffffffffffffff4 RBX: 0000000000000000 RCX: 0000000000441309
RDX: 0000000000000002 RSI: 00000000200000c0 RDI: 0000000000003ad1
RBP: 000000000000f2ae R08: 0000000000000002 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021d0
R13: 0000000000402260 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
