Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4CA363753
	for <lists+io-uring@lfdr.de>; Sun, 18 Apr 2021 21:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhDRTam (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Apr 2021 15:30:42 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:46944 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhDRTal (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Apr 2021 15:30:41 -0400
Received: by mail-io1-f71.google.com with SMTP id p8-20020a5d9c880000b02903dc877cd48dso8225816iop.13
        for <io-uring@vger.kernel.org>; Sun, 18 Apr 2021 12:30:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=o4KQiklVcBx9Xsuj2l4QvFT11+qMXN3OVLiwWc6tv00=;
        b=AmJ/uCNMVkXeYLO00bo2XKU+a7EWRpSALwE5Co3joFSznVzol0CfOUK/6Q0R54MCSF
         S9blIs90KgFtkxKJpdaYExTlQTYdkjtDx8KM+ZjHrDoMLQw6vYQ3RJQPrsMYyIUoIKy6
         UB7q/7BJ8S10IexdprMNoakART1dEpsoz9Z8lrC48HqYwDBDJVGPaRYEVaved/p0rTev
         Ao6g+8HqTiaXsPqbkV8bQpTN7mugSgw528ldqjbgzsD2J8R8mbr8+iAPFOrIYx1pLIwm
         pA98KF7AtlV+fewUhVNQ6S2z4PD/+lkYMcQFs9CBudyvmL30TYzr0xVrYgKt6CixvUca
         g//Q==
X-Gm-Message-State: AOAM531cufCjDvUmwDhW5BerUNBXmtQyH512i9FaMPxoMRY5+ocPRomw
        qMfmb7zWD7vC5cvGaRswE9/45Qmd0kBCtrq7RFuyM9hP/OG1
X-Google-Smtp-Source: ABdhPJwMzHZdP4U+GhKlzG5cfrk3jeLXo4gFMq/u/1fZUy1oRz6DVYk499bN0SZZFZxp9u+/WG3tBkgJkBjGF67jt+g/n9KfqhP0
MIME-Version: 1.0
X-Received: by 2002:a6b:5819:: with SMTP id m25mr11499054iob.99.1618774212883;
 Sun, 18 Apr 2021 12:30:12 -0700 (PDT)
Date:   Sun, 18 Apr 2021 12:30:12 -0700
In-Reply-To: <0000000000006e9e0705bd91f762@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ee3bbf05c0443da6@google.com>
Subject: Re: [syzbot] WARNING in __percpu_ref_exit (2)
From:   syzbot <syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, hdanton@sina.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        ming.lei@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    c98ff1d0 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=163d7229d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1c70e618af4c2e92
dashboard link: https://syzkaller.appspot.com/bug?extid=d6218cb2fae0b2411e9d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145cb2b6d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=157b72b1d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 169 at lib/percpu-refcount.c:113 __percpu_ref_exit+0x98/0x100 lib/percpu-refcount.c:113
Modules linked in:
CPU: 1 PID: 169 Comm: kworker/u4:3 Not tainted 5.12.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound io_ring_exit_work
RIP: 0010:__percpu_ref_exit+0x98/0x100 lib/percpu-refcount.c:113
Code: fd 49 8d 7c 24 10 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 61 49 83 7c 24 10 00 74 07 e8 a8 4a ab fd <0f> 0b e8 a1 4a ab fd 48 89 ef e8 69 f0 d9 fd 48 89 da 48 b8 00 00
RSP: 0018:ffffc90001077b48 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88802d5ca000 RCX: 0000000000000000
RDX: ffff88801217a1c0 RSI: ffffffff83c7db28 RDI: ffff88801d58f010
RBP: 0000607f4607bcb8 R08: 0000000000000000 R09: ffffffff8fa9f977
R10: ffffffff83c7dac8 R11: 0000000000000009 R12: ffff88801d58f000
R13: 000000010002865e R14: ffff88801d58f000 R15: ffff88802d5ca8b0
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000044 CR3: 0000000015c02000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 percpu_ref_exit+0x3b/0x140 lib/percpu-refcount.c:134
 io_ring_ctx_free fs/io_uring.c:8483 [inline]
 io_ring_exit_work+0xa64/0x12d0 fs/io_uring.c:8620
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

