Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF3632C5C6
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241523AbhCDAYS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 19:24:18 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:39515 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243808AbhCCSkG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 13:40:06 -0500
Received: by mail-io1-f69.google.com with SMTP id x6so8930172ioj.6
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 10:39:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=twiBAGSXeQOsvCjesuCZeg8swb+act6s62X+SsOEbkg=;
        b=YQ53PSteVEXn9lDmkDmul/ZQ8wwXMbz8VBQr75CPJvb04KHDLPIZbX4EUxQbiny2SW
         dMWy9aMgBx6zWUe5qs+mAK14b8meWaWG6jjsWwYorXaQVyx2XtRyp1dvQgK/+k+jBbqc
         C8thJXEyVyDyMiliuW9dbu9b2Y2MFX8Ei6K/HKbB3DZ+XDlAo1K+qw16x/owJXSFk8N5
         Kn3EdOszA/Ph6MG1tIVw0Q2SysB28KbigDuoZJDTFQfnmxqqgrwVv44Mn1X1Zcr8Ezxx
         WrnEZInnygoDkfAcJg8ZMWCg2DnJw0L1blRii3RocScwrPusDrMOVAOU6R4MAIyI19WB
         EAYw==
X-Gm-Message-State: AOAM532qgrG350ZpWgdDlIOSrw8wqdwu57Pe9KWNiy+jISRCIkWN/9xg
        30etWf0gpsNIMTg+WaZzfUzxE7EUREfoTMOIw8K0tdb1DlWc
X-Google-Smtp-Source: ABdhPJzN+UGe0UNaMPg9sxOGawtltlw4Xn2xlz4uns/sntD9AXsFZZVVtEWQpBondkRogM8IwJkbbY07XwQUI9jC9dtPST844Tti
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b27:: with SMTP id e7mr556205ilu.253.1614796761667;
 Wed, 03 Mar 2021 10:39:21 -0800 (PST)
Date:   Wed, 03 Mar 2021 10:39:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005d1fe305bca62b07@google.com>
Subject: memory leak in io_submit_sqes (2)
From:   syzbot <syzbot+91b4b56ead187d35c9d3@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7a7fd0de Merge branch 'kmap-conversion-for-5.12' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=152ae9cad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c66ab79a61c783f3
dashboard link: https://syzkaller.appspot.com/bug?extid=91b4b56ead187d35c9d3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148cf242d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172bb6dad00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+91b4b56ead187d35c9d3@syzkaller.appspotmail.com

executing program
executing program
executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88810f335800 (size 232):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 19.500s)
  hex dump (first 32 bytes):
    00 62 7e 01 81 88 ff ff 00 00 00 00 00 00 00 00  .b~.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0300 (size 256):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 19.500s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888110916200 (size 232):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 19.490s)
  hex dump (first 32 bytes):
    00 fa b7 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0200 (size 256):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 19.490s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8a2800 (size 232):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 19.490s)
  hex dump (first 32 bytes):
    00 5c 33 0f 81 88 ff ff 00 00 00 00 00 00 00 00  .\3.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0100 (size 256):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 19.490s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f335800 (size 232):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 20.620s)
  hex dump (first 32 bytes):
    00 62 7e 01 81 88 ff ff 00 00 00 00 00 00 00 00  .b~.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0300 (size 256):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 20.620s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888110916200 (size 232):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 20.610s)
  hex dump (first 32 bytes):
    00 fa b7 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0200 (size 256):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 20.610s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8a2800 (size 232):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 20.610s)
  hex dump (first 32 bytes):
    00 5c 33 0f 81 88 ff ff 00 00 00 00 00 00 00 00  .\3.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0100 (size 256):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 20.610s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f335800 (size 232):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 21.750s)
  hex dump (first 32 bytes):
    00 62 7e 01 81 88 ff ff 00 00 00 00 00 00 00 00  .b~.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0300 (size 256):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 21.750s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888110916200 (size 232):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 21.740s)
  hex dump (first 32 bytes):
    00 fa b7 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0200 (size 256):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 21.740s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8a2800 (size 232):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 21.740s)
  hex dump (first 32 bytes):
    00 5c 33 0f 81 88 ff ff 00 00 00 00 00 00 00 00  .\3.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0100 (size 256):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 21.740s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f335800 (size 232):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 22.860s)
  hex dump (first 32 bytes):
    00 62 7e 01 81 88 ff ff 00 00 00 00 00 00 00 00  .b~.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0300 (size 256):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 22.860s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888110916200 (size 232):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 22.850s)
  hex dump (first 32 bytes):
    00 fa b7 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0200 (size 256):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 22.850s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8a2800 (size 232):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 22.850s)
  hex dump (first 32 bytes):
    00 5c 33 0f 81 88 ff ff 00 00 00 00 00 00 00 00  .\3.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0100 (size 256):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 22.850s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f335800 (size 232):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 23.970s)
  hex dump (first 32 bytes):
    00 62 7e 01 81 88 ff ff 00 00 00 00 00 00 00 00  .b~.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0300 (size 256):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 23.970s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888110916200 (size 232):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 23.960s)
  hex dump (first 32 bytes):
    00 fa b7 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0200 (size 256):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 23.960s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8a2800 (size 232):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 23.960s)
  hex dump (first 32 bytes):
    00 5c 33 0f 81 88 ff ff 00 00 00 00 00 00 00 00  .\3.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0100 (size 256):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 23.960s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f335800 (size 232):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 25.110s)
  hex dump (first 32 bytes):
    00 62 7e 01 81 88 ff ff 00 00 00 00 00 00 00 00  .b~.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0300 (size 256):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 25.110s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888110916200 (size 232):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 25.100s)
  hex dump (first 32 bytes):
    00 fa b7 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0200 (size 256):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 25.100s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8a2800 (size 232):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 25.100s)
  hex dump (first 32 bytes):
    00 5c 33 0f 81 88 ff ff 00 00 00 00 00 00 00 00  .\3.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0100 (size 256):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 25.100s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f335800 (size 232):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 26.240s)
  hex dump (first 32 bytes):
    00 62 7e 01 81 88 ff ff 00 00 00 00 00 00 00 00  .b~.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0300 (size 256):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 26.240s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888110916200 (size 232):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 26.230s)
  hex dump (first 32 bytes):
    00 fa b7 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0200 (size 256):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 26.230s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8a2800 (size 232):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 26.230s)
  hex dump (first 32 bytes):
    00 5c 33 0f 81 88 ff ff 00 00 00 00 00 00 00 00  .\3.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0100 (size 256):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 26.230s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f335800 (size 232):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 27.390s)
  hex dump (first 32 bytes):
    00 62 7e 01 81 88 ff ff 00 00 00 00 00 00 00 00  .b~.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0300 (size 256):
  comm "syz-executor079", pid 8386, jiffies 4294945178 (age 27.390s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888110916200 (size 232):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 27.380s)
  hex dump (first 32 bytes):
    00 fa b7 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0200 (size 256):
  comm "syz-executor079", pid 8398, jiffies 4294945179 (age 27.380s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8a2800 (size 232):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 27.380s)
  hex dump (first 32 bytes):
    00 5c 33 0f 81 88 ff ff 00 00 00 00 00 00 00 00  .\3.............
    f0 98 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .._.............
  backtrace:
    [<000000008b690cb4>] io_alloc_req fs/io_uring.c:1680 [inline]
    [<000000008b690cb4>] io_submit_sqes+0x803/0x2340 fs/io_uring.c:6553
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810f8c0100 (size 256):
  comm "syz-executor079", pid 8404, jiffies 4294945179 (age 27.380s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2e0a7ef>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000e2e0a7ef>] __io_alloc_async_data fs/io_uring.c:3104 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw fs/io_uring.c:3123 [inline]
    [<00000000e2e0a7ef>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3116
    [<0000000066815854>] io_read+0x1fe/0x540 fs/io_uring.c:3299
    [<00000000cfdf0aa9>] io_issue_sqe+0xb6/0x1c50 fs/io_uring.c:5957
    [<00000000ae810f5a>] __io_queue_sqe+0x118/0x5c0 fs/io_uring.c:6226
    [<000000001fd21177>] io_queue_sqe+0x2af/0x4d0 fs/io_uring.c:6282
    [<00000000a078f546>] io_submit_sqe fs/io_uring.c:6452 [inline]
    [<00000000a078f546>] io_submit_sqes+0x2016/0x2340 fs/io_uring.c:6566
    [<000000007cfdba48>] __do_sys_io_uring_enter+0x86f/0x1110 fs/io_uring.c:9175
    [<00000000d605a0db>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005fafd51e>] entry_SYSCALL_64_after_hwframe+0x44/0xae



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
