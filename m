Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9895662FFE
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 20:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbjAITK3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 14:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235434AbjAITKT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 14:10:19 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC1C4EC94
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 11:10:18 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id n15-20020a056e021baf00b0030387c2e1d3so6719127ili.5
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 11:10:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qipXSH1J20AC+wKAB2KjTCOSuds0oDzQzeLap2sBh/o=;
        b=0qssMuRT2zAZ3lWbFBKhSoFoSS7wzRIL8jow7t0HgOOujeXNFMxD51dNFBoj4XxJlO
         kB86OBvDRMRxikkbM3RQaAGorF3PyGOesKb4lmFRRdGZdSZHBGc7FUY/UR346H6TVQ7r
         5QRMU4UxQ7QUOE3vOLu614uLG5+02uMF98w6KlDUJZkZj5NzFwXAYv5Xr6ceCz64NazG
         vIgdR9NpZ4u/VuXXFZo/E8gsgZnO4WoY9nmdY1X+/DYLZ/1z+W4PqdyZ+U6uZ1OAhq2r
         AKQMuahfcset4gnbbq/iRJC1/gdpBR55dRJsxVEw7v0fAxtvpatdKyxtHRiVaQEg+sCv
         gyRA==
X-Gm-Message-State: AFqh2kquMfJ58ui4F9F52EQwbzdgburFcH+1qRjuqTIkIJRccfHVzBrj
        Dh4wW5duyN/oHuChev9Glz6nKcsZCgg/VH+Tacgjkocfs1Sj
X-Google-Smtp-Source: AMrXdXvekfGtpmxBwAA8jYkJiOeGaSTE4S050BkI8YGNuRcxcli6hv9NIhm554AyWQfQ9PRtJLTEJkqcMARSAq/gpxvJcaPtfz1m
MIME-Version: 1.0
X-Received: by 2002:a92:c5cb:0:b0:30c:25e4:34f5 with SMTP id
 s11-20020a92c5cb000000b0030c25e434f5mr3757800ilt.222.1673291417865; Mon, 09
 Jan 2023 11:10:17 -0800 (PST)
Date:   Mon, 09 Jan 2023 11:10:17 -0800
In-Reply-To: <c955f0b8-f7f7-b3b7-970b-32aefc06a010@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009156db05f1d984c7@google.com>
Subject: Re: [syzbot] memory leak in io_submit_sqes (4)
From:   syzbot <syzbot+6c95df01470a47fc3af4@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
memory leak in io_submit_sqes

BUG: memory leak
unreferenced object 0xffff888113562900 (size 256):
  comm "syz-executor.0", pid 5682, jiffies 4294944681 (age 14.960s)
  hex dump (first 32 bytes):
    00 9f 50 13 81 88 ff ff 00 00 00 00 00 00 00 00  ..P.............
    00 00 00 00 00 00 00 00 00 40 00 00 00 00 00 00  .........@......
  backtrace:
    [<ffffffff8476aaf4>] __io_alloc_req_refill+0x55/0x193 io_uring/io_uring.c:1040
    [<ffffffff8476c085>] io_alloc_req_refill io_uring/io_uring.h:378 [inline]
    [<ffffffff8476c085>] io_submit_sqes.cold+0x65/0x8a io_uring/io_uring.c:2384
    [<ffffffff82398a3d>] __do_sys_io_uring_enter+0x76d/0x1490 io_uring/io_uring.c:3345
    [<ffffffff848f0745>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff848f0745>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

BUG: memory leak
unreferenced object 0xffff88810522d080 (size 96):
  comm "syz-executor.0", pid 5682, jiffies 4294944681 (age 14.960s)
  hex dump (first 32 bytes):
    00 9f 50 13 81 88 ff ff 00 00 00 00 00 00 00 00  ..P.............
    7b 20 00 c0 00 00 00 00 00 00 00 00 00 00 00 00  { ..............
  backtrace:
    [<ffffffff814f94a0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1062
    [<ffffffff823a73ac>] kmalloc include/linux/slab.h:580 [inline]
    [<ffffffff823a73ac>] io_req_alloc_apoll io_uring/poll.c:650 [inline]
    [<ffffffff823a73ac>] io_arm_poll_handler+0x1fc/0x470 io_uring/poll.c:694
    [<ffffffff823961cd>] io_queue_async+0x8d/0x2e0 io_uring/io_uring.c:2006
    [<ffffffff82397f18>] io_queue_sqe io_uring/io_uring.c:2037 [inline]
    [<ffffffff82397f18>] io_submit_sqe io_uring/io_uring.c:2286 [inline]
    [<ffffffff82397f18>] io_submit_sqes+0x968/0xb70 io_uring/io_uring.c:2397
    [<ffffffff82398a3d>] __do_sys_io_uring_enter+0x76d/0x1490 io_uring/io_uring.c:3345
    [<ffffffff848f0745>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff848f0745>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

BUG: memory leak
unreferenced object 0xffff888113564f00 (size 256):
  comm "syz-executor.0", pid 5682, jiffies 4294944681 (age 14.960s)
  hex dump (first 32 bytes):
    00 9f 50 13 81 88 ff ff 00 00 00 00 00 00 00 00  ..P.............
    00 00 00 00 00 00 00 00 00 40 00 00 00 00 00 00  .........@......
  backtrace:
    [<ffffffff8476aaf4>] __io_alloc_req_refill+0x55/0x193 io_uring/io_uring.c:1040
    [<ffffffff8476c085>] io_alloc_req_refill io_uring/io_uring.h:378 [inline]
    [<ffffffff8476c085>] io_submit_sqes.cold+0x65/0x8a io_uring/io_uring.c:2384
    [<ffffffff82398a3d>] __do_sys_io_uring_enter+0x76d/0x1490 io_uring/io_uring.c:3345
    [<ffffffff848f0745>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff848f0745>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

BUG: memory leak
unreferenced object 0xffff88810522dc00 (size 96):
  comm "syz-executor.0", pid 5682, jiffies 4294944681 (age 14.960s)
  hex dump (first 32 bytes):
    00 9f 50 13 81 88 ff ff 00 00 00 00 00 00 00 00  ..P.............
    7b 20 00 c0 00 00 00 00 00 00 00 00 00 00 00 00  { ..............
  backtrace:
    [<ffffffff814f94a0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1062
    [<ffffffff823a73ac>] kmalloc include/linux/slab.h:580 [inline]
    [<ffffffff823a73ac>] io_req_alloc_apoll io_uring/poll.c:650 [inline]
    [<ffffffff823a73ac>] io_arm_poll_handler+0x1fc/0x470 io_uring/poll.c:694
    [<ffffffff823961cd>] io_queue_async+0x8d/0x2e0 io_uring/io_uring.c:2006
    [<ffffffff82397f18>] io_queue_sqe io_uring/io_uring.c:2037 [inline]
    [<ffffffff82397f18>] io_submit_sqe io_uring/io_uring.c:2286 [inline]
    [<ffffffff82397f18>] io_submit_sqes+0x968/0xb70 io_uring/io_uring.c:2397
    [<ffffffff82398a3d>] __do_sys_io_uring_enter+0x76d/0x1490 io_uring/io_uring.c:3345
    [<ffffffff848f0745>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff848f0745>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

BUG: memory leak
unreferenced object 0xffff8881135a7600 (size 256):
  comm "syz-executor.0", pid 5682, jiffies 4294944681 (age 14.960s)
  hex dump (first 32 bytes):
    00 9f 50 13 81 88 ff ff 00 00 00 00 00 00 00 00  ..P.............
    00 00 00 00 00 00 00 00 00 40 00 00 00 00 00 00  .........@......
  backtrace:
    [<ffffffff8476aaf4>] __io_alloc_req_refill+0x55/0x193 io_uring/io_uring.c:1040
    [<ffffffff8476c085>] io_alloc_req_refill io_uring/io_uring.h:378 [inline]
    [<ffffffff8476c085>] io_submit_sqes.cold+0x65/0x8a io_uring/io_uring.c:2384
    [<ffffffff82398a3d>] __do_sys_io_uring_enter+0x76d/0x1490 io_uring/io_uring.c:3345
    [<ffffffff848f0745>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff848f0745>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

BUG: memory leak
unreferenced object 0xffff888109a6d900 (size 96):
  comm "syz-executor.0", pid 5682, jiffies 4294944681 (age 14.960s)
  hex dump (first 32 bytes):
    00 9f 50 13 81 88 ff ff 00 00 00 00 00 00 00 00  ..P.............
    7b 20 00 c0 00 00 00 00 00 00 00 00 00 00 00 00  { ..............
  backtrace:
    [<ffffffff814f94a0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1062
    [<ffffffff823a73ac>] kmalloc include/linux/slab.h:580 [inline]
    [<ffffffff823a73ac>] io_req_alloc_apoll io_uring/poll.c:650 [inline]
    [<ffffffff823a73ac>] io_arm_poll_handler+0x1fc/0x470 io_uring/poll.c:694
    [<ffffffff823961cd>] io_queue_async+0x8d/0x2e0 io_uring/io_uring.c:2006
    [<ffffffff82397f18>] io_queue_sqe io_uring/io_uring.c:2037 [inline]
    [<ffffffff82397f18>] io_submit_sqe io_uring/io_uring.c:2286 [inline]
    [<ffffffff82397f18>] io_submit_sqes+0x968/0xb70 io_uring/io_uring.c:2397
    [<ffffffff82398a3d>] __do_sys_io_uring_enter+0x76d/0x1490 io_uring/io_uring.c:3345
    [<ffffffff848f0745>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff848f0745>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd



Tested on:

commit:         a4b98579 Merge branch 'io_uring-6.2' into syztest
git tree:       git://git.kernel.dk/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=1560579a480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=72a4287b7f412c8a
dashboard link: https://syzkaller.appspot.com/bug?extid=6c95df01470a47fc3af4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
