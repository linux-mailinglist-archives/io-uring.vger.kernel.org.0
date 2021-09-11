Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1898E407871
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 15:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbhIKNyn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 09:54:43 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:46952 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbhIKNym (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 09:54:42 -0400
Received: by mail-il1-f198.google.com with SMTP id w15-20020a056e021a6f00b0022b284d1de4so11579873ilv.13
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 06:53:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=KpL7BP3z/hVNFmo9YP7Q9+ewRQkOssx6pF+EU1BmXmY=;
        b=wjK92BIIycrua1ImsVX4mUN9Y73iEYTvjgAN2fB88CxKrx/H4pzTvatZfESVwJdtb1
         cvTtA6FYz9Kih2CBUSIGpVLUXYYUmrKcIfJXNw6/0BEGtdgAGRVp8FSDLufqyt5gygOF
         d7j0X0eyP5ZNIJ07+XkDuaY4N+EWqBb831H20YCCybyeDthGyP35rM9A+F58IaWMxysm
         HptkIAm49yuk+DlitUQpnRsT9Ehy+2vKH0RczPPxst+LmkkACIz6Qyx2VY5hnP2/oRUY
         f8o43HEtdu7NUnaIHIGkkVyg2dpmtUkq7SJIQDJw4BpQfQmFLz2yk908WKMymYgx8ZQ+
         B8Vg==
X-Gm-Message-State: AOAM533ehzyJpTF6T3sjG3jRv6HqCtoRAHwMyysys/QEP3u1fQTb4ACn
        QGhd0/H/nPJSGj50BLru+xLHxGUg1agahLc3fcbF6nyJzp2K
X-Google-Smtp-Source: ABdhPJxcyLNv+1JIYshftyp6J+/W7J6p1g4JRtW9CCaSvyG2F6emlWd+OeaZ44Wb5ZIozNCAUbNWB35rTdxpZRHxAvizuWqo6uTT
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1ca6:: with SMTP id x6mr1819664ill.86.1631368409925;
 Sat, 11 Sep 2021 06:53:29 -0700 (PDT)
Date:   Sat, 11 Sep 2021 06:53:29 -0700
In-Reply-To: <0000000000004bda3905cb84cfc0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000092509d05cbb88ebc@google.com>
Subject: Re: [syzbot] WARNING in io_wq_submit_work (2)
From:   syzbot <syzbot+bc2d90f602545761f287@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    926de8c4326c Merge tag 'acpi-5.15-rc1-3' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17fefe8b300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=37df9ef5660a8387
dashboard link: https://syzkaller.appspot.com/bug?extid=bc2d90f602545761f287
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e4357d300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1173a663300000

The issue was bisected to:

commit 3146cba99aa284b1d4a10fbd923df953f1d18035
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Sep 1 17:20:10 2021 +0000

    io-wq: make worker creation resilient against signals

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11098e0d300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13098e0d300000
console output: https://syzkaller.appspot.com/x/log.txt?x=15098e0d300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bc2d90f602545761f287@syzkaller.appspotmail.com
Fixes: 3146cba99aa2 ("io-wq: make worker creation resilient against signals")

RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 000000000043f6d9
RDX: 0000000000000000 RSI: 0000000000000304 RDI: 0000000000000003
RBP: 00007ffed8512ba0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488
------------[ cut here ]------------
WARNING: CPU: 0 PID: 6524 at fs/io_uring.c:1164 req_ref_get fs/io_uring.c:1164 [inline]
WARNING: CPU: 0 PID: 6524 at fs/io_uring.c:1164 io_wq_submit_work+0x272/0x300 fs/io_uring.c:6733
Modules linked in:
CPU: 0 PID: 6524 Comm: syz-executor339 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:req_ref_get fs/io_uring.c:1164 [inline]
RIP: 0010:io_wq_submit_work+0x272/0x300 fs/io_uring.c:6733
Code: e8 43 33 91 ff 83 fb 7f 76 1b e8 f9 2b 91 ff be 04 00 00 00 4c 89 ef e8 3c 7a d8 ff f0 ff 45 a4 e9 41 fe ff ff e8 de 2b 91 ff <0f> 0b eb dc e8 d5 2b 91 ff 4c 89 e7 e8 ed db fb ff 48 85 c0 49 89
RSP: 0018:ffffc9000116fae8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 000000000000007f RCX: 0000000000000000
RDX: ffff88801be91c80 RSI: ffffffff81e4e162 RDI: 0000000000000003
RBP: ffff88801a793978 R08: 000000000000007f R09: ffff88801a79391f
R10: ffffffff81e4e13d R11: 0000000000000000 R12: ffff88801a7938c0
R13: ffff88801a79391c R14: ffff88801a793918 R15: 0000000000100000
FS:  0000000000a12300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000480310 CR3: 00000000778f6000 CR4: 0000000000350ef0
Call Trace:
 io_run_cancel fs/io-wq.c:809 [inline]
 io_acct_cancel_pending_work.isra.0+0x2a9/0x5e0 fs/io-wq.c:950
 io_wqe_cancel_pending_work+0x6c/0x130 fs/io-wq.c:968
 io_wq_destroy fs/io-wq.c:1185 [inline]
 io_wq_put_and_exit+0x7d1/0xc70 fs/io-wq.c:1198
 io_uring_clean_tctx fs/io_uring.c:9609 [inline]
 io_uring_cancel_generic+0x5fe/0x740 fs/io_uring.c:9689
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x265/0x2a30 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43e3d9
Code: 90 49 c7 c0 c0 ff ff ff be e7 00 00 00 ba 3c 00 00 00 eb 12 0f 1f 44 00 00 89 d0 0f 05 48 3d 00 f0 ff ff 77 1c f4 89 f0 0f 05 <48> 3d 00 f0 ff ff 76 e7 f7 d8 64 41 89 00 eb df 0f 1f 80 00 00 00
RSP: 002b:00007ffed8512b78 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004af3b0 RCX: 000000000043e3d9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004af3b0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001

