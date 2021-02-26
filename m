Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD55D32645E
	for <lists+io-uring@lfdr.de>; Fri, 26 Feb 2021 15:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhBZOtD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 09:49:03 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:44731 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhBZOs4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Feb 2021 09:48:56 -0500
Received: by mail-il1-f198.google.com with SMTP id a9so7232674ilm.11
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 06:48:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=UL/N5d3J1rT+ym+/Jn9kHXUDPqBkiL4ljBzXNafEZSU=;
        b=YEzhTYsAa15qxALMhjHtIw/riLN0k0sB7zuYAYnO9kwALWZjywyNTOZoJ2bZ0tfUuG
         WzellbUMYeC3uItZ38vwTvTUIFWi93sKAQzLpSDVT/t0BqDbhSTHiv3+sjBR+0DsnkxN
         P0+aOF1MWSTkV3iF37Fy2ho41U/MqrSOOPXSSDf3Fjb/KVm+NiYh/IMg/f56xoowUjtU
         qXGZoRiYThDklgRjZFEYAUTSHBzt+O8WNO3AXglaaujss46CJr8W7aPJ54XQTxCdiqsg
         LSydQxiuRwTILqa4dpPz6QkQ20lr+tr6WFKLFRTgEFTsucjs2sp3++ZnWvC2yne9vL0q
         Z1MA==
X-Gm-Message-State: AOAM533gR8dO3isWzc0E6cc80+X1Zf2PacZjJ9zoty4h4gEPgaIeVH6q
        jBolkCbCdxUDpxobz47rFXSEMmly3D8v0dOXDp+rZFycJN7U
X-Google-Smtp-Source: ABdhPJzI+gtHTkL5rLWZ9Ur1x5Itb6365yRJD2pcnhr2YLIsGNcZcow+L1pOt9HtAKFwwHIPFq/WH8JQLq0WtnLDcrQEIicldJOb
MIME-Version: 1.0
X-Received: by 2002:a5e:8903:: with SMTP id k3mr3029786ioj.54.1614350895999;
 Fri, 26 Feb 2021 06:48:15 -0800 (PST)
Date:   Fri, 26 Feb 2021 06:48:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b304d505bc3e5b3a@google.com>
Subject: general protection fault in try_to_wake_up (2)
From:   syzbot <syzbot+b4a81dc8727e513f364d@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, christian@brauner.io,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7f206cf3 Add linux-next specific files for 20210225
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15280e32d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1746d2802a82a05
dashboard link: https://syzkaller.appspot.com/bug?extid=b4a81dc8727e513f364d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10bc8466d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14f5bf5ad00000

The issue was bisected to:

commit 7c25c0d16ef3c37e49c593ac92f69fa3884d4bb9
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Feb 16 14:17:00 2021 +0000

    io_uring: remove the need for relying on an io-wq fallback worker

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14269b96d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16269b96d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12269b96d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b4a81dc8727e513f364d@syzkaller.appspotmail.com
Fixes: 7c25c0d16ef3 ("io_uring: remove the need for relying on an io-wq fallback worker")

general protection fault, probably for non-canonical address 0xdffffc000000011a: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000008d0-0x00000000000008d7]
CPU: 0 PID: 8677 Comm: iou-wrk-8423 Not tainted 5.11.0-next-20210225-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__lock_acquire+0xcfe/0x54c0 kernel/locking/lockdep.c:4770
Code: 0c 0e 41 bf 01 00 00 00 0f 86 8c 00 00 00 89 05 08 41 0c 0e e9 81 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02 00 0f 85 5b 31 00 00 49 81 3e 80 73 3a 8f 0f 84 d0 f3 ff
RSP: 0018:ffffc9000213f988 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000011a RSI: 1ffff92000427f42 RDI: 00000000000008d0
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88801ae7d400
R13: 0000000000000000 R14: 00000000000008d0 R15: 0000000000000000
FS:  000000000088a400(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa46e8f46c0 CR3: 000000001be5b000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_acquire kernel/locking/lockdep.c:5510 [inline]
 lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
 try_to_wake_up+0x98/0x14a0 kernel/sched/core.c:3347
 io_wqe_wake_worker+0x51a/0x680 fs/io-wq.c:248
 io_wqe_dec_running.isra.0+0xe6/0x100 fs/io-wq.c:265
 __io_worker_busy fs/io-wq.c:296 [inline]
 io_worker_handle_work+0x34f/0x1950 fs/io-wq.c:449
 io_wqe_worker fs/io-wq.c:531 [inline]
 task_thread.isra.0+0xfa8/0x1340 fs/io-wq.c:608
 task_thread_bound+0x18/0x20 fs/io-wq.c:614
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Modules linked in:
---[ end trace 1ccdee97cc2e65dd ]---
RIP: 0010:__lock_acquire+0xcfe/0x54c0 kernel/locking/lockdep.c:4770
Code: 0c 0e 41 bf 01 00 00 00 0f 86 8c 00 00 00 89 05 08 41 0c 0e e9 81 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02 00 0f 85 5b 31 00 00 49 81 3e 80 73 3a 8f 0f 84 d0 f3 ff
RSP: 0018:ffffc9000213f988 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000011a RSI: 1ffff92000427f42 RDI: 00000000000008d0
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88801ae7d400
R13: 0000000000000000 R14: 00000000000008d0 R15: 0000000000000000
FS:  000000000088a400(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa46e8f46c0 CR3: 000000001be5b000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
