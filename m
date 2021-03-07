Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F00432FFFC
	for <lists+io-uring@lfdr.de>; Sun,  7 Mar 2021 10:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbhCGJtl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Mar 2021 04:49:41 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:42767 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhCGJtW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Mar 2021 04:49:22 -0500
Received: by mail-il1-f198.google.com with SMTP id i16so5362205ila.9
        for <io-uring@vger.kernel.org>; Sun, 07 Mar 2021 01:49:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=V07qsaGEoHXexYmfa3BXedCZSaCtnYmBs8rqfZyeYlI=;
        b=ArylnujVLa49h+Spsd4r8YwuHL9JyLIpXWWkBTcoDBnMC5jIdDI2mNyHCnocrbwlqg
         XpGctWZJ7i7poxNWJtxVPxz/J0TYCSLirCLdgxUmbinT95wn3PYTLWTWGLr2EgF3BROu
         y3XRJLpjCUIeIlnTLfbLOEUPkUXbwwiwPFmdbjaBkirnWwOto76WgZCep5c2UVytAg0L
         8Mvoll8NJUgRzE8RaNnn6Od43/KcjQYxKw0TYduYPqYNgk+FCQGSh1F0BY/S2sQczQsF
         DFRUrKUWQS3ncsbIgumIXfXJ3DoYLlKNpIQhy+GlPCRadWjxFzXKgiaMW+Al46t+cO9M
         4OVQ==
X-Gm-Message-State: AOAM533Ov8eQ/WcKw4QZOwPlP85Z8BbJZHmfOubJBBgrUuZnQnY2maNd
        h8CB51oPOgyuNtZSR00VZ1VexBhAVGO/3YplDmem20y4UorB
X-Google-Smtp-Source: ABdhPJwkMgrO8DdTP9D02PdvTssCcIDOHdhMWUcL6D8tNcsYsyvMCXFxrbUITUzQjhzJDzcuxmb9r/VYn5+q4srYatU+tzgtMvom
MIME-Version: 1.0
X-Received: by 2002:a02:1702:: with SMTP id 2mr18006148jah.43.1615110561007;
 Sun, 07 Mar 2021 01:49:21 -0800 (PST)
Date:   Sun, 07 Mar 2021 01:49:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000430bf505bcef3b00@google.com>
Subject: [syzbot] possible deadlock in io_sq_thread_finish
From:   syzbot <syzbot+ac39856cb1b332dbbdda@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a38fd874 Linux 5.12-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=143ee02ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=db9c6adb4986f2f2
dashboard link: https://syzkaller.appspot.com/bug?extid=ac39856cb1b332dbbdda

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ac39856cb1b332dbbdda@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.12.0-rc2-syzkaller #0 Not tainted
--------------------------------------------
kworker/u4:7/7615 is trying to acquire lock:
ffff888144a02870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_stop fs/io_uring.c:7099 [inline]
ffff888144a02870 (&sqd->lock){+.+.}-{3:3}, at: io_put_sq_data fs/io_uring.c:7115 [inline]
ffff888144a02870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_finish+0x408/0x650 fs/io_uring.c:7139

but task is already holding lock:
ffff888144a02870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7088 [inline]
ffff888144a02870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park+0x63/0xc0 fs/io_uring.c:7082

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&sqd->lock);
  lock(&sqd->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/u4:7/7615:
 #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc900023a7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
 #2: ffff888144a02870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7088 [inline]
 #2: ffff888144a02870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park+0x63/0xc0 fs/io_uring.c:7082

stack backtrace:
CPU: 1 PID: 7615 Comm: kworker/u4:7 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_deadlock_bug kernel/locking/lockdep.c:2829 [inline]
 check_deadlock kernel/locking/lockdep.c:2872 [inline]
 validate_chain kernel/locking/lockdep.c:3661 [inline]
 __lock_acquire.cold+0x14c/0x3b4 kernel/locking/lockdep.c:4900
 lock_acquire kernel/locking/lockdep.c:5510 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
 __mutex_lock_common kernel/locking/mutex.c:946 [inline]
 __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1093
 io_sq_thread_stop fs/io_uring.c:7099 [inline]
 io_put_sq_data fs/io_uring.c:7115 [inline]
 io_sq_thread_finish+0x408/0x650 fs/io_uring.c:7139
 io_ring_ctx_free fs/io_uring.c:8408 [inline]
 io_ring_exit_work+0x82/0x9a0 fs/io_uring.c:8539
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
