Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750373CD602
	for <lists+io-uring@lfdr.de>; Mon, 19 Jul 2021 15:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240413AbhGSNFd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jul 2021 09:05:33 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:37410 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240371AbhGSNFc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jul 2021 09:05:32 -0400
Received: by mail-il1-f200.google.com with SMTP id h11-20020a056e021b8bb029020d99b97ad3so10745561ili.4
        for <io-uring@vger.kernel.org>; Mon, 19 Jul 2021 06:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=SQ1me7tSL00Vm0pix0/oPmIKKzt04Y1JeCh/CYBiwwU=;
        b=fz8TmJ+lAspNQFY3izSogY0ex43pCkNluo4obBFzOsb/ku/APCpQFP0XkW7Ygh7Mbd
         3VD1jxBdKke+eKRJWKJkSz2BmNrwYRQp2ujOm2RcXtcnQmR6BBwl36xp9lLtxtCpr+xh
         QcM/56m7iehR9KXsv9ZTjba2m9vhuC2C/BoB0oz4Ps5eGF098w2cyP+UFfRtWHb2q55G
         j73VwK8gQAp4JyeJBnF+1shP/iqpGXcM0rp8hQnE2olY7HZaeLH+AbP8NN2s4l5oxB0w
         j42iTbV/OdwPWsStSnvbWZsOZKiR/zDI0fZVEJ1qFnCffgp+XZAEcRkqLXnj001Qno1d
         eNiw==
X-Gm-Message-State: AOAM532Sc444jOugz1UsUB1pCamrnV1+/PPtdj9GyP953+5UfhDqNGqf
        rSyUmZzwfE/WvVb0VsrRuqnIMU/BSP8R567IvsuqzuSHwPJ9
X-Google-Smtp-Source: ABdhPJwjC1VhmRZ1t+SruPUmx0GE7r/SCAy1KPqPoKzKXiEPOZRLg0+HUJHUUpJe7fQ/cisxwA8yg5Uj39gcCjFk24od5Rk35Yeh
MIME-Version: 1.0
X-Received: by 2002:a92:c504:: with SMTP id r4mr16766291ilg.131.1626702372353;
 Mon, 19 Jul 2021 06:46:12 -0700 (PDT)
Date:   Mon, 19 Jul 2021 06:46:12 -0700
In-Reply-To: <b96f1da5-4e0b-331a-0a81-9a86733c830d@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000f3ac805c77a293d@google.com>
Subject: Re: [syzbot] INFO: task hung in io_sq_thread_park (2)
From:   syzbot <syzbot+ac957324022b7132accf@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in io_uring_cancel_generic

3rd poll ffff88801857e000
ctx ffff88801857e000 submitted 1, dismantled 0, crefs 0, inflight 1, fallbacks 0, poll1 0, poll2 0, tw 0, hash 0, cs 0, issued 1, cqes 1, poll tw 0, dpoll 1 
------------[ cut here ]------------
WARNING: CPU: 0 PID: 19055 at fs/io_uring.c:9166 io_dump fs/io_uring.c:9166 [inline]
WARNING: CPU: 0 PID: 19055 at fs/io_uring.c:9166 io_uring_cancel_generic+0x609/0x1050 fs/io_uring.c:9222
Modules linked in:
CPU: 0 PID: 19055 Comm: iou-sqp-19052 Tainted: G        W         5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_dump fs/io_uring.c:9166 [inline]
RIP: 0010:io_uring_cancel_generic+0x609/0x1050 fs/io_uring.c:9222
Code: 48 c1 ea 03 80 3c 02 00 0f 85 d5 02 00 00 48 8b 44 24 10 48 8b a8 98 00 00 00 48 39 6c 24 08 0f 85 02 03 00 00 e8 e7 97 92 ff <0f> 0b e9 b1 fe ff ff e8 db 97 92 ff 48 8b 74 24 20 b9 08 00 00 00
RSP: 0018:ffffc90002ff7c20 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8880474b54c0 RCX: 0000000000000000
RDX: ffff8880474b54c0 RSI: ffffffff81e2f0c9 RDI: ffff88801857e518
RBP: ffff8880276e9f80 R08: 000000000000009d R09: 0000000000000000
R10: ffffffff815d066e R11: 0000000000000000 R12: ffffc90002ff7d40
R13: ffff888017015058 R14: 0000000000000000 R15: 0000000000000001
FS:  00007f3ab01c2700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000002aad848 CR3: 000000004a024000 CR4: 0000000000350ef0
Call Trace:
 io_sq_thread+0xaac/0x1250 fs/io_uring.c:6944
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 19055 Comm: iou-sqp-19052 Tainted: G        W         5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 panic+0x306/0x73d kernel/panic.c:232
 __warn.cold+0x35/0x44 kernel/panic.c:606
 report_bug+0x1bd/0x210 lib/bug.c:199
 handle_bug+0x3c/0x60 arch/x86/kernel/traps.c:239
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:259
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:566
RIP: 0010:io_dump fs/io_uring.c:9166 [inline]
RIP: 0010:io_uring_cancel_generic+0x609/0x1050 fs/io_uring.c:9222
Code: 48 c1 ea 03 80 3c 02 00 0f 85 d5 02 00 00 48 8b 44 24 10 48 8b a8 98 00 00 00 48 39 6c 24 08 0f 85 02 03 00 00 e8 e7 97 92 ff <0f> 0b e9 b1 fe ff ff e8 db 97 92 ff 48 8b 74 24 20 b9 08 00 00 00
RSP: 0018:ffffc90002ff7c20 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8880474b54c0 RCX: 0000000000000000
RDX: ffff8880474b54c0 RSI: ffffffff81e2f0c9 RDI: ffff88801857e518
RBP: ffff8880276e9f80 R08: 000000000000009d R09: 0000000000000000
R10: ffffffff815d066e R11: 0000000000000000 R12: ffffc90002ff7d40
R13: ffff888017015058 R14: 0000000000000000 R15: 0000000000000001
 io_sq_thread+0xaac/0x1250 fs/io_uring.c:6944
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Kernel Offset: disabled
Rebooting in 86400 seconds..


Tested on:

commit:         6828fc5e io_uring: add syz debug info
git tree:       https://github.com/isilence/linux.git syztest_sqpoll_hang
console output: https://syzkaller.appspot.com/x/log.txt?x=10ed934c300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfe2c0e42bc9993d
dashboard link: https://syzkaller.appspot.com/bug?extid=ac957324022b7132accf
compiler:       

