Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85472A2A22
	for <lists+io-uring@lfdr.de>; Mon,  2 Nov 2020 12:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgKBLzv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Nov 2020 06:55:51 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:42447 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbgKBLyV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Nov 2020 06:54:21 -0500
Received: by mail-io1-f71.google.com with SMTP id p67so5218026iod.9
        for <io-uring@vger.kernel.org>; Mon, 02 Nov 2020 03:54:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Jif07879xIdqk8preXUlJynIzSJslPiVsHNblnvjy0g=;
        b=islk2sLjqOEwgrb+csA2acxrjriazrluhXc4DovQvelRUEVyqSNpT7ASdMO/nIFXy7
         Z9Hn2otrT0XpiawmQQDG4LWIl17pUI8BITd2KK+n2VtnFPCYMkHFsRKfVQYS5wW3LOkg
         8mkRCDivzjHsKbssnslF9Sx6/bfgl21NY3WmBiNYkLVxH4eIlH/B+YAKe+Xzm256aSRt
         fSpmmfESYhcRPPGwT5YumfS1N5AdqmTBzbqYyGRaZjv37oSi/oKsVWONlB1CQ+Svhm+b
         jE1QcYjR367v7sNI0nKt77uhU/5vRWaRtL6K967BoXAgOFO6g3JmtanBqnMtBrxN3i/h
         oTqw==
X-Gm-Message-State: AOAM5317T59Uinm79ZOxo+lipHdWhpMBjbBtlQc1wl1ueB3CA/IVTDGk
        c8K9sqsStO7hq4a/HwJsOdDoQyUNHtQGYsf1RzogyLWXnIL2
X-Google-Smtp-Source: ABdhPJxXCVhnlFwd644zkajZIE1B8kF0ijJjuc8EwzFzxiIWmswVFPBj5V4F9nulsIbuz9bZq6taBWf2a8o6jZr87DJCBiLlRtRB
MIME-Version: 1.0
X-Received: by 2002:a02:3b57:: with SMTP id i23mr11915552jaf.110.1604318059322;
 Mon, 02 Nov 2020 03:54:19 -0800 (PST)
Date:   Mon, 02 Nov 2020 03:54:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000008604f05b31e6867@google.com>
Subject: KASAN: null-ptr-deref Write in kthread_use_mm
From:   syzbot <syzbot+b57abf7ee60829090495@syzkaller.appspotmail.com>
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

HEAD commit:    4e78c578 Add linux-next specific files for 20201030
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=148969d4500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83318758268dc331
dashboard link: https://syzkaller.appspot.com/bug?extid=b57abf7ee60829090495
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e1346c500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1388fbca500000

The issue was bisected to:

commit 4d004099a668c41522242aa146a38cc4eb59cb1e
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Oct 2 09:04:21 2020 +0000

    lockdep: Fix lockdep recursion

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1354e614500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10d4e614500000
console output: https://syzkaller.appspot.com/x/log.txt?x=1754e614500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b57abf7ee60829090495@syzkaller.appspotmail.com
Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: null-ptr-deref in atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
BUG: KASAN: null-ptr-deref in mmgrab include/linux/sched/mm.h:36 [inline]
BUG: KASAN: null-ptr-deref in kthread_use_mm+0x11c/0x2a0 kernel/kthread.c:1257
Write of size 4 at addr 0000000000000060 by task io_uring-sq/26191

CPU: 1 PID: 26191 Comm: io_uring-sq Not tainted 5.10.0-rc1-next-20201030-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 __kasan_report mm/kasan/report.c:549 [inline]
 kasan_report.cold+0x5/0x37 mm/kasan/report.c:562
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
 mmgrab include/linux/sched/mm.h:36 [inline]
 kthread_use_mm+0x11c/0x2a0 kernel/kthread.c:1257
 __io_sq_thread_acquire_mm fs/io_uring.c:1092 [inline]
 __io_sq_thread_acquire_mm+0x1c4/0x220 fs/io_uring.c:1085
 io_sq_thread_acquire_mm_files.isra.0+0x125/0x180 fs/io_uring.c:1104
 io_init_req fs/io_uring.c:6661 [inline]
 io_submit_sqes+0x89d/0x25f0 fs/io_uring.c:6757
 __io_sq_thread fs/io_uring.c:6904 [inline]
 io_sq_thread+0x462/0x1630 fs/io_uring.c:6971
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 26191 Comm: io_uring-sq Tainted: G    B             5.10.0-rc1-next-20201030-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 panic+0x306/0x73d kernel/panic.c:231
 end_report+0x58/0x5e mm/kasan/report.c:106
 __kasan_report mm/kasan/report.c:552 [inline]
 kasan_report.cold+0xd/0x37 mm/kasan/report.c:562
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
 mmgrab include/linux/sched/mm.h:36 [inline]
 kthread_use_mm+0x11c/0x2a0 kernel/kthread.c:1257
 __io_sq_thread_acquire_mm fs/io_uring.c:1092 [inline]
 __io_sq_thread_acquire_mm+0x1c4/0x220 fs/io_uring.c:1085
 io_sq_thread_acquire_mm_files.isra.0+0x125/0x180 fs/io_uring.c:1104
 io_init_req fs/io_uring.c:6661 [inline]
 io_submit_sqes+0x89d/0x25f0 fs/io_uring.c:6757
 __io_sq_thread fs/io_uring.c:6904 [inline]
 io_sq_thread+0x462/0x1630 fs/io_uring.c:6971
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
