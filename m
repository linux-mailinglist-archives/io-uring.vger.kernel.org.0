Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF513C6800
	for <lists+io-uring@lfdr.de>; Tue, 13 Jul 2021 03:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhGMBWJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 21:22:09 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:49080 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbhGMBWH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 21:22:07 -0400
Received: by mail-il1-f200.google.com with SMTP id v6-20020a927a060000b0290205af2e2342so9641314ilc.15
        for <io-uring@vger.kernel.org>; Mon, 12 Jul 2021 18:19:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=oqGoqxBcxwH89D72Mbw8ZlYrShpEoTNGBpgI5zCNG3w=;
        b=CD8TKaBOeeXBOgc5t4tthSZWmJIAXtK3r3T1TDv7XLMAHKowK13CESezRbTwSpr6A+
         n7rA/SAOcS6x1zFr5p8XLmkJ1L1a/JKikYTosE7X/hvGenlZxHzh14uIDFwlQTWNFVof
         Y1KdXXf9jjFsxoEiX5Iarr0oauPY7qaEQfMMWr4k4JhBUZW3ZlUHR/KyS1ZF/Jp2fVx8
         /97D2cLOR9622GcsE3nKt1de7EMGhZbVJs8Vv23L6uIHBFaMuduvPsJu0zC2C3MRfJiN
         YrabpSjj5RdqwxVvGP0P/qG0uhLyGaWoDGBo2frwKBwOdG4bzYJO1K+oJ0WazEYmoNb0
         m9BA==
X-Gm-Message-State: AOAM531jNLzMADAe+Cg9zHtpUzmSGrm+ArOq4ypLBApOKuNHsZLXYDWH
        SZFbW4i3ctcPmIlTLOBfNYiqwiS1yHNPISKDfkfqXA/esK1u
X-Google-Smtp-Source: ABdhPJwG1TGHvY+XxcBbg9Rmoisd/7BEnxstTyQ7p1rQwH7sowzndNCi69QPL4T2kRhZ5YPlFlPp71GiIeguF/MDGFa4PAL9wPjl
MIME-Version: 1.0
X-Received: by 2002:a5d:914a:: with SMTP id y10mr1316270ioq.140.1626139158567;
 Mon, 12 Jul 2021 18:19:18 -0700 (PDT)
Date:   Mon, 12 Jul 2021 18:19:18 -0700
In-Reply-To: <000000000000d0615505c6e9bd7f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e6deea05c6f706af@google.com>
Subject: Re: [syzbot] kernel BUG in io_queue_async_work
From:   syzbot <syzbot+d50e4f20cfad4510ec22@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    7fef2edf sd: don't mess with SD_MINORS for CONFIG_DEBUG_BL..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1575c9b0300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=957eaf08bd3bb8d6
dashboard link: https://syzkaller.appspot.com/bug?extid=d50e4f20cfad4510ec22
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104c3949d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167cc06c300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d50e4f20cfad4510ec22@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/io_uring.c:1293!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8139 Comm: kworker/1:3 Tainted: G        W         5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events io_fallback_req_func
RIP: 0010:io_queue_async_work+0x539/0x5f0 fs/io_uring.c:1293
Code: 89 be 89 00 00 00 48 c7 c7 40 53 9a 89 c6 05 de 38 78 0b 01 e8 72 6b 08 07 e9 6e ff ff ff e8 ee 68 95 ff 0f 0b e8 e7 68 95 ff <0f> 0b e8 e0 68 95 ff 0f 0b e9 1a fd ff ff e8 34 0f db ff e9 47 fb
RSP: 0018:ffffc9000c627ba8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88802d256000 RCX: 0000000000000000
RDX: ffff888030f4e180 RSI: ffffffff81df55c9 RDI: ffff88802ef66a50
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000019
R10: ffffffff81df517c R11: 000000000000000f R12: ffff8880441eb6c0
R13: 0000000000000019 R14: ffff88802d2560b0 R15: ffff8880441eb718
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000049a01d CR3: 00000000396af000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __io_queue_sqe+0x913/0xf10 fs/io_uring.c:6448
 io_req_task_submit+0x100/0x120 fs/io_uring.c:2020
 io_fallback_req_func+0x81/0xb0 fs/io_uring.c:2441
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Modules linked in:
---[ end trace aa15edd5dcdbd7e3 ]---
RIP: 0010:io_queue_async_work+0x539/0x5f0 fs/io_uring.c:1293
Code: 89 be 89 00 00 00 48 c7 c7 40 53 9a 89 c6 05 de 38 78 0b 01 e8 72 6b 08 07 e9 6e ff ff ff e8 ee 68 95 ff 0f 0b e8 e7 68 95 ff <0f> 0b e8 e0 68 95 ff 0f 0b e9 1a fd ff ff e8 34 0f db ff e9 47 fb
RSP: 0018:ffffc9000c627ba8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88802d256000 RCX: 0000000000000000
RDX: ffff888030f4e180 RSI: ffffffff81df55c9 RDI: ffff88802ef66a50
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000019
R10: ffffffff81df517c R11: 000000000000000f R12: ffff8880441eb6c0
R13: 0000000000000019 R14: ffff88802d2560b0 R15: ffff8880441eb718
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000444 CR3: 0000000042660000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

