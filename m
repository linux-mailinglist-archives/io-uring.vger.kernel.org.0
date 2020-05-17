Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CFD1D65DA
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 06:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgEQEaO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 00:30:14 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:56788 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgEQEaO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 00:30:14 -0400
Received: by mail-il1-f197.google.com with SMTP id v87so6368129ill.23
        for <io-uring@vger.kernel.org>; Sat, 16 May 2020 21:30:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xaEu04YoGRCkpn6vFmvFwzgqbWLVIpbeaTWbb3v/APY=;
        b=dijhSmM7imyPy+c/FO7i0hQS3APBE1Mbsvm+/fButze8mG7owqd3F2xG431iSzMpuv
         gdktiT13X/vMHnQntFmoDXRyVScrk2z17CjLcRjKqdFIkUN3s+XS9cE7yE/H3Kge6NUY
         RhBN1mGwIRwCULaCTozW/CS9BMv17aQpVhPEiQrmCaiTrf/slzQTMxGwdHksYPjZsLuV
         1B+/wJ0l4mUCJIyKSqLva8KG+y/33XG94sgwc0uj64tgZsIGyt95iKW7WqOg8TU1RHvH
         vCcRw9ziAzbIaCOJ6mYgIy1HVveg0q5HqmV+R/Ud7JZTWjAvFlaHqsq5YmyToRNeIuVN
         lXzQ==
X-Gm-Message-State: AOAM533mJ75i2A0vD+vHTC/ueW+FbWJlMHf8GEPNbzp4dXc5PBg7gcIY
        JPwpFgbMCENRFDuyMTFDe4hPnQvp0q2Es9YWvKgzVc0hWKok
X-Google-Smtp-Source: ABdhPJydXYeZ322UZxhICGUQDfn28nbDuV377Jh0kG83QVESbPkJTsE4aeDAOEQsdS7oYbXSodLuebAG/XUHZq1ZwNLaRNnmrpCi
MIME-Version: 1.0
X-Received: by 2002:a02:cc45:: with SMTP id i5mr10363125jaq.28.1589689813085;
 Sat, 16 May 2020 21:30:13 -0700 (PDT)
Date:   Sat, 16 May 2020 21:30:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009cb15805a5d080d6@google.com>
Subject: INFO: trying to register non-static key in io_cqring_ev_posted (3)
From:   syzbot <syzbot+8c91f5d054e998721c57@syzkaller.appspotmail.com>
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

HEAD commit:    ac935d22 Add linux-next specific files for 20200415
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12deaa5e100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bc498783097e9019
dashboard link: https://syzkaller.appspot.com/bug?extid=8c91f5d054e998721c57
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11d54c02100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17461e06100000

The bug was bisected to:

commit b41e98524e424d104aa7851d54fd65820759875a
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Feb 17 16:52:41 2020 +0000

    io_uring: add per-task callback handler

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1488dc3c100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1688dc3c100000
console output: https://syzkaller.appspot.com/x/log.txt?x=1288dc3c100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8c91f5d054e998721c57@syzkaller.appspotmail.com
Fixes: b41e98524e42 ("io_uring: add per-task callback handler")

RSP: 002b:00007fffb1fb9aa8 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441319
RDX: 0000000000000001 RSI: 0000000020000140 RDI: 000000000000047b
RBP: 0000000000010475 R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402260
R13: 00000000004022f0 R14: 0000000000000000 R15: 0000000000000000
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 7090 Comm: syz-executor222 Not tainted 5.7.0-rc1-next-20200415-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 assign_lock_key kernel/locking/lockdep.c:913 [inline]
 register_lock_class+0x1664/0x1760 kernel/locking/lockdep.c:1225
 __lock_acquire+0x104/0x4c50 kernel/locking/lockdep.c:4234
 lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4934
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x8c/0xbf kernel/locking/spinlock.c:159
 __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:122
 io_cqring_ev_posted+0xa5/0x1e0 fs/io_uring.c:1160
 io_poll_remove_all fs/io_uring.c:4357 [inline]
 io_ring_ctx_wait_and_kill+0x2bc/0x5a0 fs/io_uring.c:7305
 io_uring_create fs/io_uring.c:7843 [inline]
 io_uring_setup+0x115e/0x22b0 fs/io_uring.c:7870
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x441319
Code: e8 5c ae 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 bb 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffb1fb9aa8 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441319
RDX: 0000000000000001 RSI: 0000000020000140 RDI: 000000000000047b
RBP: 0000000000010475 R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402260
R13: 00000000004022f0 R14: 0000000000000000 R15: 0000000000000000
general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 7090 Comm: syz-executor222 Not tainted 5.7.0-rc1-next-20200415-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__read_once_size include/linux/compiler.h:232 [inline]
RIP: 0010:__wake_up_common+0xdc/0x600 kernel/sched/wait.c:86
Code: b9 04 00 00 4c 8b 43 40 49 83 e8 18 49 8d 78 18 48 39 fd 0f 84 d0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 e3 04 00 00 49 bd 00 00 00 00 00 fc ff df 4d 8b
RSP: 0018:ffffc90001677c20 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff8880a6081120 RCX: 1ffffffff1517002
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000000
RBP: ffff8880a6081160 R08: ffffffffffffffe8 R09: ffffc90001677cb8
R10: 0000000000000003 R11: fffff520002cef7e R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000003 R15: 0000000000000000
FS:  000000000136f880(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000140 CR3: 00000000936b4000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:123
 io_cqring_ev_posted+0xa5/0x1e0 fs/io_uring.c:1160
 io_poll_remove_all fs/io_uring.c:4357 [inline]
 io_ring_ctx_wait_and_kill+0x2bc/0x5a0 fs/io_uring.c:7305
 io_uring_create fs/io_uring.c:7843 [inline]
 io_uring_setup+0x115e/0x22b0 fs/io_uring.c:7870
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x441319
Code: e8 5c ae 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 bb 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffb1fb9aa8 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441319
RDX: 0000000000000001 RSI: 0000000020000140 RDI: 000000000000047b
RBP: 0000000000010475 R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402260
R13: 00000000004022f0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace bf24b131500537a6 ]---
RIP: 0010:__read_once_size include/linux/compiler.h:232 [inline]
RIP: 0010:__wake_up_common+0xdc/0x600 kernel/sched/wait.c:86
Code: b9 04 00 00 4c 8b 43 40 49 83 e8 18 49 8d 78 18 48 39 fd 0f 84 d0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 e3 04 00 00 49 bd 00 00 00 00 00 fc ff df 4d 8b
RSP: 0018:ffffc90001677c20 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff8880a6081120 RCX: 1ffffffff1517002
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000000
RBP: ffff8880a6081160 R08: ffffffffffffffe8 R09: ffffc90001677cb8
R10: 0000000000000003 R11: fffff520002cef7e R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000003 R15: 0000000000000000
FS:  000000000136f880(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000140 CR3: 00000000936b4000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
