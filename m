Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F059E3CB677
	for <lists+io-uring@lfdr.de>; Fri, 16 Jul 2021 12:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhGPLAE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Jul 2021 07:00:04 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:57041 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239587AbhGPLAD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Jul 2021 07:00:03 -0400
Received: by mail-io1-f70.google.com with SMTP id p19-20020a5d8b930000b02904a03acf5d82so5737453iol.23
        for <io-uring@vger.kernel.org>; Fri, 16 Jul 2021 03:57:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=nozPs/V48VMIkx5cQQACEBpxEU2di5c6d9qVAx+/xvw=;
        b=ogoLww4vi1RZQY40veLVU8RjoNKGO+F8lI55yaurzdyc8AFnbJiBisx8rOPeN+86jf
         Hymssg1lAN/psmuo7WlN+k+mu6KGxOOuBHzWKwaB1+cf4EFGlbl6FhEznu+yJoXbW2TR
         A6VbZeN4mRb7v97ydDdksn9ifB5sy7WqiEcCYkbakqIM0Rl2TBo1v61jWYhGGYV4nx5+
         O0BbRlvmEFDeBn513SvckpzEdy9rT5tBLIi+74rJG8sfSdTalxa++nX81KPiplmKa1px
         gGXMzMXUmIbANt7NYSxoRjThotKaT6iIMoloTUAg8y/zG090ZLXreL9+wWucyxpmmkqk
         DUPw==
X-Gm-Message-State: AOAM532BgR71avJ9auYk3fXXuKKw1oNtA2CpaImHMuBA6Z/cEb+A4z0+
        MNvcHb6296VlW63gvU/BRqYl1VBumXFRu00dvX+6czPnHU9u
X-Google-Smtp-Source: ABdhPJyTy0iXWl8RJXyIzfZpi59tIQJEQ45cIod4s8+6N8E93vF+M6CIgoFTe7HDDMF458Qyqqsy8CbTGhxOG9DJY2R6GnjDw9h5
MIME-Version: 1.0
X-Received: by 2002:a92:2a05:: with SMTP id r5mr5739495ile.69.1626433027959;
 Fri, 16 Jul 2021 03:57:07 -0700 (PDT)
Date:   Fri, 16 Jul 2021 03:57:07 -0700
In-Reply-To: <632ddc1b-b664-3e60-90be-03bdf556aa49@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e1f38205c73b72cc@google.com>
Subject: Re: [syzbot] INFO: task hung in io_sq_thread_park (2)
From:   syzbot <syzbot+ac957324022b7132accf@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in io_uring_cancel_generic

ctx ffff8880467ee000 submitted 1, dismantled 0, crefs 0, inflight 1, fallbacks 0, poll1 0, poll2 0, tw 0, hash 0, cs 0, issued 1 
------------[ cut here ]------------
WARNING: CPU: 0 PID: 18216 at fs/io_uring.c:9142 io_dump fs/io_uring.c:9142 [inline]
WARNING: CPU: 0 PID: 18216 at fs/io_uring.c:9142 io_uring_cancel_generic+0x608/0xea0 fs/io_uring.c:9198
Modules linked in:
CPU: 0 PID: 18216 Comm: iou-sqp-18211 Not tainted 5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_dump fs/io_uring.c:9142 [inline]
RIP: 0010:io_uring_cancel_generic+0x608/0xea0 fs/io_uring.c:9198
Code: 48 c1 ea 03 80 3c 02 00 0f 85 d5 02 00 00 48 8b 44 24 10 48 8b a8 98 00 00 00 48 39 6c 24 08 0f 85 02 03 00 00 e8 f8 97 92 ff <0f> 0b e9 af fe ff ff e8 ec 97 92 ff 48 8b 74 24 20 b9 08 00 00 00
RSP: 0018:ffffc9000afefc40 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88802a09d4c0 RCX: 0000000000000000
RDX: ffff88802a09d4c0 RSI: ffffffff81e2f0b8 RDI: ffff8880467ee510
RBP: ffff8880462fb788 R08: 0000000000000081 R09: 0000000000000000
R10: ffffffff815d066e R11: 0000000000000000 R12: ffff8880462fa458
R13: ffffc9000afefd40 R14: 0000000000000001 R15: 0000000000000000
FS:  00007f9295c2d700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1c3f1a3000 CR3: 0000000018755000 CR4: 0000000000350ee0
Call Trace:
 io_sq_thread+0xaac/0x1250 fs/io_uring.c:6932
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 18216 Comm: iou-sqp-18211 Not tainted 5.14.0-rc1-syzkaller #0
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
RIP: 0010:io_dump fs/io_uring.c:9142 [inline]
RIP: 0010:io_uring_cancel_generic+0x608/0xea0 fs/io_uring.c:9198
Code: 48 c1 ea 03 80 3c 02 00 0f 85 d5 02 00 00 48 8b 44 24 10 48 8b a8 98 00 00 00 48 39 6c 24 08 0f 85 02 03 00 00 e8 f8 97 92 ff <0f> 0b e9 af fe ff ff e8 ec 97 92 ff 48 8b 74 24 20 b9 08 00 00 00
RSP: 0018:ffffc9000afefc40 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88802a09d4c0 RCX: 0000000000000000
RDX: ffff88802a09d4c0 RSI: ffffffff81e2f0b8 RDI: ffff8880467ee510
RBP: ffff8880462fb788 R08: 0000000000000081 R09: 0000000000000000
R10: ffffffff815d066e R11: 0000000000000000 R12: ffff8880462fa458
R13: ffffc9000afefd40 R14: 0000000000000001 R15: 0000000000000000
 io_sq_thread+0xaac/0x1250 fs/io_uring.c:6932
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Kernel Offset: disabled
Rebooting in 86400 seconds..


Tested on:

commit:         81fee56e io_uring: add syz debug info
git tree:       https://github.com/isilence/linux.git syztest_sqpoll_hang
console output: https://syzkaller.appspot.com/x/log.txt?x=12bb485c300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfe2c0e42bc9993d
dashboard link: https://syzkaller.appspot.com/bug?extid=ac957324022b7132accf
compiler:       

