Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FA43FC2C2
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 08:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbhHaG1V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 02:27:21 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:36662 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbhHaG1U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 02:27:20 -0400
Received: by mail-io1-f71.google.com with SMTP id e187-20020a6bb5c4000000b005b5fe391cf9so10141373iof.3
        for <io-uring@vger.kernel.org>; Mon, 30 Aug 2021 23:26:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2fBMnjsX5AdFGq7XzKbhCElEWldrauYArDk/5jg/9mA=;
        b=t7PuOWG4sR/tAYvJTNKruigOpd8vYva4StFrFyL4+eGB54ar3QEruU3q6/pPF+6gH3
         aI6TqTp+AGflzpQicxVKtuPJmdOK32WLIYyWHVcOBw8d807UiftLParSTVLaIBFi9UGV
         V/qQZ0+Kcj/PHd9zYt0bA/5lIiza3TdGFtM++1M15FvKiAdCJCVaR/7cdv999WxlY53S
         IxPQz0SoeuBGZ1OFhQcQ2t+i2TgwxtCRXIM1hDGVwLYTHNNY8v+eJXcUStFcznqsX416
         cjsfH11r4CxsLZqRoEh0xWZnkmE+YT/8PpWiOAMXkXOufj58SAD9nnCOwvyPZLd29k09
         OXOg==
X-Gm-Message-State: AOAM531IdxXtt5EjXXlK5yDbMRqhD5gufSMS8Sv3cdgwhs1FKMRaMtMn
        WyUKELEJtrXEGPaeVst474srJHpVUMpcUloWAwovwmKj7ejX
X-Google-Smtp-Source: ABdhPJzQG9wQ49aRQcCksX58ZAPVm+IqKVAYhBpqfwYsWyUuF6d4zd5zS2M4iMR35CtZb8B6Bu6C2UYHwFn0hJqKv9bNPx1jOG69
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1504:: with SMTP id b4mr1372068jat.144.1630391185806;
 Mon, 30 Aug 2021 23:26:25 -0700 (PDT)
Date:   Mon, 30 Aug 2021 23:26:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007997ea05cad507ad@google.com>
Subject: [syzbot] general protection fault in io_poll_remove_waitqs
From:   syzbot <syzbot+a593162d40b4e4bc57cc@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7e96bf476270 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12cde0ae300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=40eef000d7648480
dashboard link: https://syzkaller.appspot.com/bug?extid=a593162d40b4e4bc57cc
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a593162d40b4e4bc57cc@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xe0807c8080808083: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0x0404040404040418-0x040404040404041f]
CPU: 1 PID: 3257 Comm: syz-executor.5 Not tainted 5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__lock_acquire+0xd7d/0x54a0 kernel/locking/lockdep.c:4885
Code: e7 0d 41 be 01 00 00 00 0f 86 c8 00 00 00 89 05 f9 64 e7 0d e9 bd 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 f3 2f 00 00 48 81 3b c0 63 ed 8e 0f 84 52 f3 ff
RSP: 0018:ffffc90017037740 EFLAGS: 00010003
RAX: dffffc0000000000 RBX: 040404040404041c RCX: 0000000000000000
RDX: 0080808080808083 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000006 R12: 0000000000000000
R13: ffff888083f28000 R14: 0000000000000000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f557cdb0 CR3: 0000000063b0c000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 __io_poll_remove_one fs/io_uring.c:5219 [inline]
 io_poll_remove_waitqs+0xc7/0x540 fs/io_uring.c:5237
 io_poll_remove_one fs/io_uring.c:5251 [inline]
 io_poll_remove_all+0x230/0x590 fs/io_uring.c:5279
 io_ring_ctx_wait_and_kill+0x1b0/0x3c0 fs/io_uring.c:8874
 io_uring_release+0x3e/0x50 fs/io_uring.c:8894
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbd4/0x2a60 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2160 kernel/signal.c:2808
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 __do_fast_syscall_32+0x72/0xf0 arch/x86/entry/common.c:181
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:203
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f5d549
Code: Unable to access opcode bytes at RIP 0xf7f5d51f.
RSP: 002b:00000000f555759c EFLAGS: 00000206 ORIG_RAX: 00000000000000c0
RAX: 0000000020eea000 RBX: 0000000020eea000 RCX: 0000000000200000
RDX: 0000000000000003 RSI: 0000000000008011 RDI: 0000000000000004
RBP: 0000000000010000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 1200cfeeff2833d2 ]---
RIP: 0010:__lock_acquire+0xd7d/0x54a0 kernel/locking/lockdep.c:4885
Code: e7 0d 41 be 01 00 00 00 0f 86 c8 00 00 00 89 05 f9 64 e7 0d e9 bd 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 f3 2f 00 00 48 81 3b c0 63 ed 8e 0f 84 52 f3 ff
RSP: 0018:ffffc90017037740 EFLAGS: 00010003
RAX: dffffc0000000000 RBX: 040404040404041c RCX: 0000000000000000
RDX: 0080808080808083 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000006 R12: 0000000000000000
R13: ffff888083f28000 R14: 0000000000000000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f557cdb0 CR3: 0000000063b0c000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
