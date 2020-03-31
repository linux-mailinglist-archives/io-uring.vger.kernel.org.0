Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5AFB198D72
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2020 09:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbgCaHvU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Mar 2020 03:51:20 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:51845 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729955AbgCaHvU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Mar 2020 03:51:20 -0400
Received: by mail-il1-f197.google.com with SMTP id j12so19213428ilf.18
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2020 00:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ImrKMa3+NOdhC7TK5w/1EhNipc5Vv/NoOaS4eKx7PoU=;
        b=LJSMy6yM+VqieuMWIBk5+ShydK3trVDtxCEvpHyFXVlkyD7m+t5eR/RCGHO3kHjhVD
         mltLuoZ3/EhPwiFf8mNRNMDEPgscUGxagVSE1LEf1PFpeY7IW4SuXwhmV2GSPDt0jUrb
         G7UIcGsTQkG1xIwgIwVZoALN7dPgYp9ILRf7oh+lJvLdWCLvmQL5K6j/GlLy31am8AOQ
         eqP1MEmgc938qMcLe9IyeHOSmOvNAv9EiWPSMkbUSQBxJKmvFTNnF2hWIjMDVp0nTYC3
         fuyI/4Rg+2xvVpYY6ztiXudGHkOFsNIig5cELN+u3GhW1RU9PfOXD9zlKdFcLDVOxkUT
         ep3A==
X-Gm-Message-State: ANhLgQ0dV0BJHJjCPVSzSszZvTDb9WbJOnqtGsaFwAwOdK9bs8GhpOf8
        rKSvYywO4IeZQ0ktDCwSXH95tIX5qp02W5GNzbyF2n4IU4Q+
X-Google-Smtp-Source: ADFU+vvSDT0ILN24GEzPtyM3+wsLzeItjGvFwelbv5/AdND2JEv8lFrsU+N9RQv0L4v+PyZn7ej/Cgfo89SqFlT06BoHIzbac+0G
MIME-Version: 1.0
X-Received: by 2002:a5d:9648:: with SMTP id d8mr5608670ios.115.1585641077799;
 Tue, 31 Mar 2020 00:51:17 -0700 (PDT)
Date:   Tue, 31 Mar 2020 00:51:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002efe6505a221d5be@google.com>
Subject: INFO: trying to register non-static key in io_cqring_ev_posted (2)
From:   syzbot <syzbot+0c3370f235b74b3cfd97@syzkaller.appspotmail.com>
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

HEAD commit:    673b41e0 staging/octeon: fix up merge error
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=141bd4b7e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=acf766c0e3d3f8c6
dashboard link: https://syzkaller.appspot.com/bug?extid=0c3370f235b74b3cfd97
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ac1b9de00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10449493e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0c3370f235b74b3cfd97@syzkaller.appspotmail.com

RSP: 002b:00007ffe08a3a528 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004412a9
RDX: 0000000000000001 RSI: 0000000020000000 RDI: 0000000000000910
RBP: 000000000000acfd R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021f0
R13: 0000000000402280 R14: 0000000000000000 R15: 0000000000000000
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 7017 Comm: syz-executor095 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 register_lock_class+0x76a/0x1000 kernel/locking/lockdep.c:472
 __lock_acquire+0x102/0x2b90 kernel/locking/lockdep.c:4223
 lock_acquire+0x169/0x480 kernel/locking/lockdep.c:4923
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x9e/0xc0 kernel/locking/spinlock.c:159
 __wake_up_common_lock kernel/sched/wait.c:122 [inline]
 __wake_up+0xb8/0x150 kernel/sched/wait.c:142
 io_cqring_ev_posted+0x9f/0x1c0 fs/io_uring.c:1150
 io_poll_remove_all fs/io_uring.c:4343 [inline]
 io_ring_ctx_wait_and_kill+0x537/0xfd0 fs/io_uring.c:7223
 io_uring_create fs/io_uring.c:7761 [inline]
 io_uring_setup fs/io_uring.c:7788 [inline]
 __do_sys_io_uring_setup fs/io_uring.c:7801 [inline]
 __se_sys_io_uring_setup+0x1e49/0x2650 fs/io_uring.c:7798
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4412a9
Code: e8 5c ae 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 bb 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe08a3a528 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004412a9
RDX: 0000000000000001 RSI: 0000000020000000 RDI: 0000000000000910
RBP: 000000000000acfd R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021f0
R13: 0000000000402280 R14: 0000000000000000 R15: 0000000000000000
general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 7017 Comm: syz-executor095 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__wake_up_common+0x297/0x4d0 kernel/sched/wait.c:86
Code: fb 01 00 00 45 31 f6 eb 13 66 2e 0f 1f 84 00 00 00 00 00 4d 39 fc 0f 84 e3 01 00 00 4c 89 fb 49 8d 6f e8 4c 89 f8 48 c1 e8 03 <80> 3c 10 00 74 12 48 89 df e8 6b b5 59 00 48 ba 00 00 00 00 00 fc
RSP: 0018:ffffc900043e7c00 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000003 RDI: ffff8880a6860120
RBP: ffffffffffffffe8 R08: 0000000000000000 R09: ffffc900043e7c68
R10: fffff5200087cf80 R11: 0000000000000000 R12: ffff8880a6860160
R13: 1ffff9200087cf8d R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000afd880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 00000000a6821000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __wake_up_common_lock kernel/sched/wait.c:123 [inline]
 __wake_up+0xd4/0x150 kernel/sched/wait.c:142
 io_cqring_ev_posted+0x9f/0x1c0 fs/io_uring.c:1150
 io_poll_remove_all fs/io_uring.c:4343 [inline]
 io_ring_ctx_wait_and_kill+0x537/0xfd0 fs/io_uring.c:7223
 io_uring_create fs/io_uring.c:7761 [inline]
 io_uring_setup fs/io_uring.c:7788 [inline]
 __do_sys_io_uring_setup fs/io_uring.c:7801 [inline]
 __se_sys_io_uring_setup+0x1e49/0x2650 fs/io_uring.c:7798
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4412a9
Code: e8 5c ae 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 bb 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe08a3a528 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004412a9
RDX: 0000000000000001 RSI: 0000000020000000 RDI: 0000000000000910
RBP: 000000000000acfd R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021f0
R13: 0000000000402280 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace c289123c7e157e7b ]---
RIP: 0010:__wake_up_common+0x297/0x4d0 kernel/sched/wait.c:86
Code: fb 01 00 00 45 31 f6 eb 13 66 2e 0f 1f 84 00 00 00 00 00 4d 39 fc 0f 84 e3 01 00 00 4c 89 fb 49 8d 6f e8 4c 89 f8 48 c1 e8 03 <80> 3c 10 00 74 12 48 89 df e8 6b b5 59 00 48 ba 00 00 00 00 00 fc
RSP: 0018:ffffc900043e7c00 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000003 RDI: ffff8880a6860120
RBP: ffffffffffffffe8 R08: 0000000000000000 R09: ffffc900043e7c68
R10: fffff5200087cf80 R11: 0000000000000000 R12: ffff8880a6860160
R13: 1ffff9200087cf8d R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000afd880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 00000000a6821000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
