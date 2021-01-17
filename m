Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540312F9161
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 09:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbhAQIc3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Jan 2021 03:32:29 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:43494 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbhAQI2D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Jan 2021 03:28:03 -0500
Received: by mail-io1-f71.google.com with SMTP id n18so3689685ioo.10
        for <io-uring@vger.kernel.org>; Sun, 17 Jan 2021 00:27:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cGMwwg6/VNTni+wpFF2nllzxeO74CGTK6I717v9SIzw=;
        b=rSqPLWZSNmcw5S/61bJTFKrp2aIPAU560DgGYT2MagKgzAX+gg5tamJki8t4lQ1btN
         5gy17FTCkIEMoAFgRDuxyHyEnh93cYgDCoSp3k/vxghAFzf5bBOzwANucQpoS7HgePyR
         WgIilWrGY5VHFLGFEZk0aCxNp2aoHn6rhz356VAb+Vz65m9A83d1WywD+oRBmXHa+fbm
         uBTZGv17VNRJvmAh9/ZVdv3SuPJT4skqH4gyCOj7y/rfuDOD8fAEoTyrmzNjtJaFejh+
         rbeOh+bcHUxkuKvikPKmTXOHZDJTQw5t0dEWgLe4SwPgzCVEqlve1KhQBS/n3uqZ4bqo
         3GFg==
X-Gm-Message-State: AOAM533pK0Rl1CheQ8i/fIr+QMS8Wd3StTbjvVEjWJET05TEDbDV0RKQ
        KKt7zjOQQiMZXE9m2GtYgSBGQ3Skjc3U8wSi4J7C5PvOp7+b
X-Google-Smtp-Source: ABdhPJzVmIN8D3KBsTdjunnTCp3kbcm7pPriB6VJsohy45Qq4CWh56rJGuPjuT6x+2YOPAKvwPSjF66QRomC5yHWHYrNKJNMOzZJ
MIME-Version: 1.0
X-Received: by 2002:a92:8b84:: with SMTP id i126mr15704090ild.62.1610872042350;
 Sun, 17 Jan 2021 00:27:22 -0800 (PST)
Date:   Sun, 17 Jan 2021 00:27:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dcecd505b9145f53@google.com>
Subject: WARNING in io_wq_submit_work
From:   syzbot <syzbot+f655445043a26a7cfab8@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0da0a8a0 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12f2309f500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ee2266946ed36986
dashboard link: https://syzkaller.appspot.com/bug?extid=f655445043a26a7cfab8
compiler:       clang version 11.0.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f655445043a26a7cfab8@syzkaller.appspotmail.com

------------[ cut here ]------------
do not call blocking ops when !TASK_RUNNING; state=2 set at [<00000000ced9dbfc>] prepare_to_wait+0x1f4/0x3b0 kernel/sched/wait.c:262
WARNING: CPU: 1 PID: 19888 at kernel/sched/core.c:7853 __might_sleep+0xed/0x100 kernel/sched/core.c:7848
Modules linked in:
CPU: 0 PID: 19888 Comm: syz-executor.3 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__might_sleep+0xed/0x100 kernel/sched/core.c:7848
Code: fc ff df 41 80 3c 06 00 74 08 48 89 ef e8 cb 2e 6c 00 48 8b 4d 00 48 c7 c7 c0 d4 0d 8a 48 89 de 48 89 ca 31 c0 e8 23 5e f3 ff <0f> 0b eb 8e 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
RSP: 0018:ffffc900089df3c0 EFLAGS: 00010246
RAX: 24183d53a1679b00 RBX: 0000000000000002 RCX: ffff888013853780
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffff888013854d98 R08: ffffffff8163c792 R09: ffffed10173a60b8
R10: ffffed10173a60b8 R11: 0000000000000000 R12: ffffffff8a0e5f60
R13: ffff888013853798 R14: 1ffff1100270a9b3 R15: 00000000000003a7
FS:  00007fe439981700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000016b538d CR3: 0000000026e00000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 __mutex_lock_common+0xc4/0x2ef0 kernel/locking/mutex.c:935
 __mutex_lock kernel/locking/mutex.c:1103 [inline]
 mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:1118
 io_wq_submit_work+0x39a/0x720 fs/io_uring.c:6411
 io_run_cancel fs/io-wq.c:856 [inline]
 io_wqe_cancel_pending_work fs/io-wq.c:990 [inline]
 io_wq_cancel_cb+0x614/0xcb0 fs/io-wq.c:1027
 io_uring_cancel_files fs/io_uring.c:8874 [inline]
 io_uring_cancel_task_requests fs/io_uring.c:8952 [inline]
 __io_uring_files_cancel+0x115d/0x19e0 fs/io_uring.c:9038
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 do_exit+0x2e6/0x2490 kernel/exit.c:780
 do_group_exit+0x168/0x2d0 kernel/exit.c:922
 get_signal+0x16b5/0x2030 kernel/signal.c:2770
 arch_do_signal_or_restart+0x8e/0x6a0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0xac/0x1e0 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x48/0x190 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e219
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fe439980cf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000119bf88 RCX: 000000000045e219
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000119bf88
RBP: 000000000119bf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007ffe7c5112ff R14: 00007fe4399819c0 R15: 000000000119bf8c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
