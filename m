Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51992453BA
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 00:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgHOWEe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 18:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728547AbgHOVvB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 17:51:01 -0400
Received: from mail-il1-x148.google.com (mail-il1-x148.google.com [IPv6:2607:f8b0:4864:20::148])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B89EC0F26ED
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 11:14:18 -0700 (PDT)
Received: by mail-il1-x148.google.com with SMTP id t79so8897832ild.5
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 11:14:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Tsrf0W3zdR8N6Sz4q9zL/K2/kh+E+ME01i4FhEUCMRQ=;
        b=Rqw63jYX2IR6x2KOfNC3Udx6u3DqKzCukG1TpTtkFv1ub1rjiNXkAaQ6xo05dlU1ZG
         pejNynwMCVlQ21bDiJYeW874nDDhaXEeqIA9F6HAlM7GUyr546tWa+yoogNKWX/71mIW
         h3nOEpS7CrX69cs0kuKqZWVlfpOziGP0m7u/QWVo3wBAcNEUSUGkxfd9084VubsMCzKX
         Lma4TU1iUutQwuhNwEke64RBnn+zRj/vtLUBUPMvtZ0GE5MNb0jGTaT3bmNMkAeAwjr9
         KLqNtG7YqeMmVSzz3PGAXYVB4wXUsxfNWwfaFnwbbBOe/M7f5GGjwqHxCDpn6q2Hfbq+
         3Bcg==
X-Gm-Message-State: AOAM530z6aWvcSk5vXLfgEQPRU7mQT1Bmi/uYMl6qSEBW5hn7uWispUR
        ylyxjMOE8AwHM7s512iCJiem0x4RSPz++jfYgCfKoHP3ioG2
X-Google-Smtp-Source: ABdhPJxYqKqeKYXpBI+HjSS1BvnO9LP/5Zfu3IqMgkk1OcFJhfjveTF2PxtjTI1vWp6rJMeM+xx5/uYZ8rnvmalXEbxnC2kMkSXi
MIME-Version: 1.0
X-Received: by 2002:a92:d4cc:: with SMTP id o12mr7100103ilm.90.1597515257724;
 Sat, 15 Aug 2020 11:14:17 -0700 (PDT)
Date:   Sat, 15 Aug 2020 11:14:17 -0700
In-Reply-To: <000000000000923cee05acee6f61@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000075c7e805acee8158@google.com>
Subject: Re: possible deadlock in io_poll_double_wake
From:   syzbot <syzbot+0d56cfeec64f045baffc@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    c9c9735c Merge tag 'scsi-misc' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=165d3b6a900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=adea84f38e7bc8d
dashboard link: https://syzkaller.appspot.com/bug?extid=0d56cfeec64f045baffc
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1018494a900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c8e1e2900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0d56cfeec64f045baffc@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.8.0-syzkaller #0 Not tainted
--------------------------------------------
syz-executor639/6830 is trying to acquire lock:
ffff8880a6bc5530 (&tty->write_wait){-.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff8880a6bc5530 (&tty->write_wait){-.-.}-{2:2}, at: io_poll_double_wake+0x108/0x360 fs/io_uring.c:4599

but task is already holding lock:
ffff8880a6bc5530 (&tty->write_wait){-.-.}-{2:2}, at: __wake_up_common_lock kernel/sched/wait.c:122 [inline]
ffff8880a6bc5530 (&tty->write_wait){-.-.}-{2:2}, at: __wake_up+0xb8/0x150 kernel/sched/wait.c:142

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&tty->write_wait);
  lock(&tty->write_wait);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by syz-executor639/6830:
 #0: ffff8880a6bc5098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x21/0x70 drivers/tty/tty_ldisc.c:267
 #1: ffff8880a6bc52e8 (&tty->termios_rwsem){++++}-{3:3}, at: tty_set_termios+0xc5/0x1510 drivers/tty/tty_ioctl.c:328
 #2: ffff8880a6bc5098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref+0x18/0x80 drivers/tty/tty_ldisc.c:288
 #3: ffff8880a6bc5530 (&tty->write_wait){-.-.}-{2:2}, at: __wake_up_common_lock kernel/sched/wait.c:122 [inline]
 #3: ffff8880a6bc5530 (&tty->write_wait){-.-.}-{2:2}, at: __wake_up+0xb8/0x150 kernel/sched/wait.c:142

stack backtrace:
CPU: 0 PID: 6830 Comm: syz-executor639 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 print_deadlock_bug kernel/locking/lockdep.c:2391 [inline]
 check_deadlock kernel/locking/lockdep.c:2432 [inline]
 validate_chain+0x69a4/0x88a0 kernel/locking/lockdep.c:3202
 __lock_acquire+0x1161/0x2ab0 kernel/locking/lockdep.c:4426
 lock_acquire+0x160/0x730 kernel/locking/lockdep.c:5005
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 io_poll_double_wake+0x108/0x360 fs/io_uring.c:4599
 __wake_up_common+0x30a/0x4e0 kernel/sched/wait.c:93
 __wake_up_common_lock kernel/sched/wait.c:123 [inline]
 __wake_up+0xd4/0x150 kernel/sched/wait.c:142
 n_tty_set_termios+0xa60/0x1080 drivers/tty/n_tty.c:1874
 tty_set_termios+0xcac/0x1510 drivers/tty/tty_ioctl.c:341
 set_termios+0x4a1/0x580 drivers/tty/tty_ioctl.c:414
 tty_mode_ioctl+0x7b2/0xa80 drivers/tty/tty_ioctl.c:770
 tty_ioctl+0xf81/0x15c0 drivers/tty/tty_io.c:2665
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:739
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4405b9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdae6bfd28 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00000000004405b9
RDX: 0000000020000000 RSI: 0000000000005404 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401e20
R13: 0000000000401eb0 R14: 0000000000000000 R15: 0000000000000000

