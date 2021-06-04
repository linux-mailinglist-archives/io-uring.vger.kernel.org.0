Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066D139B5DD
	for <lists+io-uring@lfdr.de>; Fri,  4 Jun 2021 11:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhFDJYK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Jun 2021 05:24:10 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:39616 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhFDJYJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Jun 2021 05:24:09 -0400
Received: by mail-io1-f72.google.com with SMTP id b1-20020a05660214c1b02904783f688a11so5713910iow.6
        for <io-uring@vger.kernel.org>; Fri, 04 Jun 2021 02:22:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6qiKJRR6x2C0eoWqzz1SZr063RioZ00HFfHptWhb/Cg=;
        b=jz0dp/Kcdi5DklV3A20ipMKPbRi4a++mGL9ZtINVMX3vGB6G9yMchITjXcmsXJql44
         muvPKoim/RZRKis+ugFIIx9SB/redO8lWx9oVkoNsPnU4XUpxSiGVDp/I6EYg4NEjA8Y
         rnHp/SV51IVSCjCg8ZPyhXoO+1Ri63f5wM38YOG7EqgP49KKsoBwerM3U1PjHJJz2eQK
         /pziRhaCJMkblOOSU4DoXKOEEjwatPwrfCzh0pBCJTm52FxL+Fg0DB7+bNEoN1XtdHbc
         t3OkGEMXh6p4m6811HGiEO/mFRH35D70vFs370xRAXfEuAXoo4/PEOFjC3Kg1S4MMjNa
         1quQ==
X-Gm-Message-State: AOAM5330PX7FgU0bTKmsh7oMPMDcICex9Gi77EgT/V9RGaQZh7jfgSxp
        vJzTmo997z2KnmjmEvQcKPGYuA2sOt2A9/Pyo0Qaiz07+EHc
X-Google-Smtp-Source: ABdhPJzveYZVT7BQ0LV3LStrd26gZ3BB09G00IIR2cZLrwSvjZ2+PLV5WB5uJ2ZVgfqqdWZigJSaYt0ffUPow1KeEDb3AsLO+Evm
MIME-Version: 1.0
X-Received: by 2002:a5d:8501:: with SMTP id q1mr3115803ion.66.1622798543409;
 Fri, 04 Jun 2021 02:22:23 -0700 (PDT)
Date:   Fri, 04 Jun 2021 02:22:23 -0700
In-Reply-To: <0000000000006e1be105c3ed13fe@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b8d66e05c3ed3a3c@google.com>
Subject: Re: [syzbot] WARNING in io_wqe_enqueue
From:   syzbot <syzbot+ea2f1484cffe5109dc10@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    f88cd3fb Merge tag 'vfio-v5.13-rc5' of git://github.com/aw..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1629ab6bd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8a9e9956ca52a5f6
dashboard link: https://syzkaller.appspot.com/bug?extid=ea2f1484cffe5109dc10
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ecfd60300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=110abf2fd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ea2f1484cffe5109dc10@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 8435 at fs/io-wq.c:244 io_wqe_wake_worker fs/io-wq.c:244 [inline]
WARNING: CPU: 0 PID: 8435 at fs/io-wq.c:244 io_wqe_enqueue+0x7f6/0x910 fs/io-wq.c:751
Modules linked in:
CPU: 0 PID: 8435 Comm: syz-executor703 Not tainted 5.13.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_wqe_wake_worker fs/io-wq.c:244 [inline]
RIP: 0010:io_wqe_enqueue+0x7f6/0x910 fs/io-wq.c:751
Code: ef e8 4e a5 d8 ff e9 2d f9 ff ff 4c 89 ef e8 41 a5 d8 ff e9 53 f9 ff ff 48 89 ef e8 34 a5 d8 ff e9 9f fa ff ff e8 fa 9e 93 ff <0f> 0b e9 08 fb ff ff 48 8b 7c 24 08 e8 29 a5 d8 ff e9 ca fd ff ff
RSP: 0018:ffffc9000cb17c78 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff888015de3880 RSI: ffffffff81e13d86 RDI: 0000000000000003
RBP: ffff88802a622010 R08: 0000000000000000 R09: ffff88802a6220a3
R10: ffffffff81e1388c R11: 1ffffffff1f34fda R12: ffff88802a622000
R13: ffff88802a622098 R14: ffff88802a6220e8 R15: 0000000000000000
FS:  0000000000bc0300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000180 CR3: 0000000027ebb000 CR4: 0000000000350ef0
Call Trace:
 io_queue_async_work+0x2d0/0x5f0 fs/io_uring.c:1274
 __io_queue_sqe+0x806/0x10f0 fs/io_uring.c:6438
 __io_req_task_submit+0x103/0x120 fs/io_uring.c:2039
 io_async_task_func+0x23e/0x4c0 fs/io_uring.c:5074
 __tctx_task_work fs/io_uring.c:1910 [inline]
 tctx_task_work+0x24e/0x550 fs/io_uring.c:1924
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:212 [inline]
 handle_signal_work kernel/entry/common.c:145 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x24a/0x280 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 do_syscall_64+0x47/0xb0 arch/x86/entry/common.c:57
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f109
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffde115a118 EFLAGS: 00000246 ORIG_RAX: 0000000000000030
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 000000000043f109
RDX: 000000000043f109 RSI: 0000000000000001 RDI: 0000000000000004
RBP: 00000000004030f0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403180
R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488

