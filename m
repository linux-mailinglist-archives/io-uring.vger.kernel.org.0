Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3489D32C5CA
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344961AbhCDAYX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 19:24:23 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:51231 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376661AbhCCWYr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 17:24:47 -0500
Received: by mail-io1-f71.google.com with SMTP id i19so12311087ioh.18
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 14:24:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=U0pQ8UeY3jjvyGIA/GmTExIy024e3Gh7t6G65nu29TY=;
        b=Db+BoNMgBGeLcMUlSPwfuAAogcBZRR5dIHLOwPb7TN0MDdiGsjguh/PHah8anqUtW7
         hNUk8v2mRtTmEnU5YISRN64pmpQ3s3MxLmvnSkLHTm4W6MVfwXeWefqRpiIZJz24qAR5
         t3zfPenoCIq0W32YPKJoR5DrMJ44/FRWYAfhKrmUalPiSRqRhPa3AjzuwLtmJfa1td15
         p7CkV8nkFfdT3EUrcEHYuLm+8EYnCBK1I4faqvB3WXaTjyJ31JwJ3rEoWUgus88myM1b
         /h5p5v2iqtNX7KC3oAG4GAXOgDrfc9goFCoTP45tq2S0CRn+sCYITKGMfp7D8Npxck/F
         V1Zg==
X-Gm-Message-State: AOAM530+bPqyqZkibOyWnKbNkgWfM59VvW1VwzFF1MXlMoGSXX0lgZzT
        iHsFs1D8DEFGNbsKIHvjTRUNUCINUREuFBVBXFPEuiQp9o1U
X-Google-Smtp-Source: ABdhPJw4wmNgJQkCl6BM6noRm3a60twCGn3jXdUuhUeeSuXi0iHyQM9FNOTjoTNW5NkzTsNZj8+dmfwxjES+1f2WGoX+VbJ9PlWC
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:c7:: with SMTP id r7mr1408691ilq.288.1614810244587;
 Wed, 03 Mar 2021 14:24:04 -0800 (PST)
Date:   Wed, 03 Mar 2021 14:24:04 -0800
In-Reply-To: <af143fa7-cff3-48eb-5abc-94e3685d0955@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000002261d05bca94f7b@google.com>
Subject: Re: memory leak in io_submit_sqes (2)
From:   syzbot <syzbot+91b4b56ead187d35c9d3@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
memory leak in io_submit_sqes

BUG: memory leak
unreferenced object 0xffff88811043cc00 (size 232):
  comm "syz-executor.0", pid 10595, jiffies 4294944973 (age 10.850s)
  hex dump (first 32 bytes):
    00 f0 40 10 81 88 ff ff 00 00 00 00 00 00 00 00  ..@.............
    00 7a 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .z_.............
  backtrace:
    [<000000005cfa592c>] io_alloc_req fs/io_uring.c:1610 [inline]
    [<000000005cfa592c>] io_submit_sqes+0x7ae/0x22f0 fs/io_uring.c:6518
    [<00000000bffe23f4>] __do_sys_io_uring_enter+0x857/0x10c0 fs/io_uring.c:9108
    [<000000002e2222f2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005e5fec34>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888124dd1300 (size 256):
  comm "syz-executor.0", pid 10595, jiffies 4294944973 (age 10.850s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000099ea7aac>] kmalloc include/linux/slab.h:559 [inline]
    [<0000000099ea7aac>] __io_alloc_async_data fs/io_uring.c:3060 [inline]
    [<0000000099ea7aac>] io_setup_async_rw fs/io_uring.c:3079 [inline]
    [<0000000099ea7aac>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3072
    [<0000000002d951db>] io_read+0x1fe/0x560 fs/io_uring.c:3257
    [<00000000ca56953d>] io_issue_sqe+0x18d/0x23e0 fs/io_uring.c:5933
    [<00000000a5a737fd>] __io_queue_sqe+0x9a/0x4f0 fs/io_uring.c:6200
    [<00000000af920b23>] io_queue_sqe+0x361/0x560 fs/io_uring.c:6253
    [<00000000deecb73d>] io_submit_sqe fs/io_uring.c:6417 [inline]
    [<00000000deecb73d>] io_submit_sqes+0x1fc1/0x22f0 fs/io_uring.c:6531
    [<00000000bffe23f4>] __do_sys_io_uring_enter+0x857/0x10c0 fs/io_uring.c:9108
    [<000000002e2222f2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005e5fec34>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810d21fa00 (size 232):
  comm "syz-executor.0", pid 10613, jiffies 4294944997 (age 10.610s)
  hex dump (first 32 bytes):
    00 47 b1 11 81 88 ff ff 00 00 00 00 00 00 00 00  .G..............
    00 7a 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .z_.............
  backtrace:
    [<000000005cfa592c>] io_alloc_req fs/io_uring.c:1610 [inline]
    [<000000005cfa592c>] io_submit_sqes+0x7ae/0x22f0 fs/io_uring.c:6518
    [<00000000bffe23f4>] __do_sys_io_uring_enter+0x857/0x10c0 fs/io_uring.c:9108
    [<000000002e2222f2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005e5fec34>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888124e98500 (size 256):
  comm "syz-executor.0", pid 10613, jiffies 4294944997 (age 10.610s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000099ea7aac>] kmalloc include/linux/slab.h:559 [inline]
    [<0000000099ea7aac>] __io_alloc_async_data fs/io_uring.c:3060 [inline]
    [<0000000099ea7aac>] io_setup_async_rw fs/io_uring.c:3079 [inline]
    [<0000000099ea7aac>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3072
    [<0000000002d951db>] io_read+0x1fe/0x560 fs/io_uring.c:3257
    [<00000000ca56953d>] io_issue_sqe+0x18d/0x23e0 fs/io_uring.c:5933
    [<00000000a5a737fd>] __io_queue_sqe+0x9a/0x4f0 fs/io_uring.c:6200
    [<00000000af920b23>] io_queue_sqe+0x361/0x560 fs/io_uring.c:6253
    [<00000000deecb73d>] io_submit_sqe fs/io_uring.c:6417 [inline]
    [<00000000deecb73d>] io_submit_sqes+0x1fc1/0x22f0 fs/io_uring.c:6531
    [<00000000bffe23f4>] __do_sys_io_uring_enter+0x857/0x10c0 fs/io_uring.c:9108
    [<000000002e2222f2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005e5fec34>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810edcff00 (size 232):
  comm "syz-executor.0", pid 10633, jiffies 4294945010 (age 10.480s)
  hex dump (first 32 bytes):
    00 99 b3 11 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    00 7a 5f 81 ff ff ff ff 00 00 00 00 00 00 00 00  .z_.............
  backtrace:
    [<000000005cfa592c>] io_alloc_req fs/io_uring.c:1610 [inline]
    [<000000005cfa592c>] io_submit_sqes+0x7ae/0x22f0 fs/io_uring.c:6518
    [<00000000bffe23f4>] __do_sys_io_uring_enter+0x857/0x10c0 fs/io_uring.c:9108
    [<000000002e2222f2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005e5fec34>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888124c06300 (size 256):
  comm "syz-executor.0", pid 10633, jiffies 4294945010 (age 10.480s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000099ea7aac>] kmalloc include/linux/slab.h:559 [inline]
    [<0000000099ea7aac>] __io_alloc_async_data fs/io_uring.c:3060 [inline]
    [<0000000099ea7aac>] io_setup_async_rw fs/io_uring.c:3079 [inline]
    [<0000000099ea7aac>] io_setup_async_rw+0xa3/0x1e0 fs/io_uring.c:3072
    [<0000000002d951db>] io_read+0x1fe/0x560 fs/io_uring.c:3257
    [<00000000ca56953d>] io_issue_sqe+0x18d/0x23e0 fs/io_uring.c:5933
    [<00000000a5a737fd>] __io_queue_sqe+0x9a/0x4f0 fs/io_uring.c:6200
    [<00000000af920b23>] io_queue_sqe+0x361/0x560 fs/io_uring.c:6253
    [<00000000deecb73d>] io_submit_sqe fs/io_uring.c:6417 [inline]
    [<00000000deecb73d>] io_submit_sqes+0x1fc1/0x22f0 fs/io_uring.c:6531
    [<00000000bffe23f4>] __do_sys_io_uring_enter+0x857/0x10c0 fs/io_uring.c:9108
    [<000000002e2222f2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005e5fec34>] entry_SYSCALL_64_after_hwframe+0x44/0xae



Tested on:

commit:         4f766d6f io_uring: ensure that threads freeze on suspend
git tree:       git://git.kernel.dk/linux-block io_uring-5.12
console output: https://syzkaller.appspot.com/x/log.txt?x=143ce02ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c43bda1f1543d72b
dashboard link: https://syzkaller.appspot.com/bug?extid=91b4b56ead187d35c9d3
compiler:       

