Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF41307BC2
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 18:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhA1RGn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 12:06:43 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:41204 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbhA1RAH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 12:00:07 -0500
Received: by mail-il1-f200.google.com with SMTP id g14so5232982ilk.8
        for <io-uring@vger.kernel.org>; Thu, 28 Jan 2021 08:59:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gQFohrmbf+cd0YVpsCNOhBWiIWwJx9a6ZCiwkwVvh8Y=;
        b=rVURn39pOYIlGKk2Yj4hccZj5yoKFRINE25MIXGpKHXiDjhJOZnrDQT8De26FyjmKx
         iF91tamz588ZqHrazoXer8nJKjtPdF53kl7CUphNTUUXBjE2FymB07B91MkuUx9Fxcuk
         w7Tr/2go1AE108oFlW53wolB/hTh0NEe4ct8G1cBWUikdp0pXC9IxjZdL1yazFWPmIkn
         M8kDm5vEpofQzJEsp5jsvQgwKu/9i3MPuEo9N+1GIAkbUsUTD6heiTv2Cfd0CAWJC4a8
         N2vNGmITvARS2qZkXA3WGWYsKz6HHWP7pG1ox41Q3h5s/Ue7HVaonFPUqqHRdpMsSKDV
         BYuw==
X-Gm-Message-State: AOAM533TCw7q3PevzVXEZ5HYLaRVfmVdruRXzr5z61QSDbhiFZoQrLJM
        d4LRR/2dfQfezqF/+CtEKiaCLqTczaGcv4butkylXPebA+3Z
X-Google-Smtp-Source: ABdhPJxMRMYhF4gC5o3nvyulFZ6GHNErteB7j8tLv50pS7pZvIbbn0xI4qZ9smkYlQYHqD2gtavpw02Jla+Qir5Hpr63RuZvWHIV
MIME-Version: 1.0
X-Received: by 2002:a6b:6e0c:: with SMTP id d12mr437951ioh.74.1611853165860;
 Thu, 28 Jan 2021 08:59:25 -0800 (PST)
Date:   Thu, 28 Jan 2021 08:59:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000619ae405b9f8cf6e@google.com>
Subject: WARNING in io_uring_cancel_task_requests
From:   syzbot <syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d03154e8 Add linux-next specific files for 20210128
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=159d08a0d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6953ffb584722a1
dashboard link: https://syzkaller.appspot.com/bug?extid=3e3d9bd0c6ce9efbc3ef
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 21359 at fs/io_uring.c:9042 io_uring_cancel_task_requests+0xe55/0x10c0 fs/io_uring.c:9042
Modules linked in:
CPU: 0 PID: 21359 Comm: syz-executor.0 Not tainted 5.11.0-rc5-next-20210128-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_uring_cancel_task_requests+0xe55/0x10c0 fs/io_uring.c:9042
Code: 00 00 e9 1c fe ff ff 48 8b 7c 24 18 e8 f4 b4 da ff e9 f2 fc ff ff 48 8b 7c 24 18 e8 e5 b4 da ff e9 64 f2 ff ff e8 eb 16 97 ff <0f> 0b e9 ed f2 ff ff e8 df b4 da ff e9 c8 f5 ff ff 4c 89 ef e8 52
RSP: 0018:ffffc9000c5a7950 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88806e79f000 RCX: 0000000000000000
RDX: ffff88806c9d5400 RSI: ffffffff81dbfe65 RDI: ffff88806e79f0d0
RBP: ffff88806e79f0e8 R08: 0000000000000000 R09: ffff88806c9d5407
R10: ffffffff81dbf0df R11: 0000000000000000 R12: ffff88806e79f000
R13: ffff88806c9d5400 R14: ffff88801cdbb800 R15: ffff88802a151018
FS:  0000000000000000(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000749138 CR3: 0000000011ffd000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_uring_flush+0x47b/0x6e0 fs/io_uring.c:9227
 filp_close+0xb4/0x170 fs/open.c:1295
 close_files fs/file.c:403 [inline]
 put_files_struct fs/file.c:418 [inline]
 put_files_struct+0x1cc/0x350 fs/file.c:415
 exit_files+0x7e/0xa0 fs/file.c:435
 do_exit+0xc22/0x2ae0 kernel/exit.c:820
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x427/0x20f0 kernel/signal.c:2773
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e219
Code: Unable to access opcode bytes at RIP 0x45e1ef.
RSP: 002b:00007f33ed289be8 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
RAX: 0000000000000004 RBX: 0000000020000200 RCX: 000000000045e219
RDX: 0000000020ff8000 RSI: 0000000020000200 RDI: 0000000000002d38
RBP: 000000000119c080 R08: 00000000200002c0 R09: 00000000200002c0
R10: 0000000020000280 R11: 0000000000000206 R12: 0000000020ff8000
R13: 0000000020ff1000 R14: 00000000200002c0 R15: 0000000020000280


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
