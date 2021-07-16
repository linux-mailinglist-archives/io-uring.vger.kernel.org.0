Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65CB3CB005
	for <lists+io-uring@lfdr.de>; Fri, 16 Jul 2021 02:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhGPARC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 20:17:02 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:38869 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhGPARC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 20:17:02 -0400
Received: by mail-il1-f200.google.com with SMTP id s7-20020a92cb070000b02902021736bb95so4209405ilo.5
        for <io-uring@vger.kernel.org>; Thu, 15 Jul 2021 17:14:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0e+Pa0OyImMjzCDiyc/6gdDWXSNMLGetChoTpyH/X/I=;
        b=OA6URbx4D6KgXXJVqFnEIzNlUC2khb+UzHhX2RgPfRvzg9SOfuplQLq9b6W0NcLJPB
         F/L0eW/Ns+1/LpIKtA760MdiCQN+nwNUeJY2eUIjYikt2dg0boB5P2l0GJqaQOgTS2fC
         4dnmPQwZOxv9REQaZMLJ1bc30HwK6fjWBMCmEXXFTcIFz7veiNBPyqexzRy7PEjFJskx
         Tc9fIn/iDES8rTYiztdb1kKNwn5KJwtQlx/xI/+mwrqBPVAypvfXuaoxNUWgettRMX/X
         px9pbBUBQpZhzAwQelxBhI+pTB/6Rl4qGgNCc8imUQWG/ePqyWQjmnZj3t7oNusrb9w3
         i1eA==
X-Gm-Message-State: AOAM531II2u422YBd9gamR2DdejKTbV/E/lNHodbze3w6tWfC2TFbeLC
        fgfkAqpJEUoRt6sqOj+E6yT83w0ZXtNv4MMai9bvkrE0VoJd
X-Google-Smtp-Source: ABdhPJyzc3yFvM9fdwayx6mESIAqp3wMz9hR8TZ6gvHffGQ5iJBUgsm5VAs+E9OwNBDqF03gmhQSOGbC3dMqbM+ne0f0UmfvZM12
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:d41:: with SMTP id h1mr4255760ilj.191.1626394447135;
 Thu, 15 Jul 2021 17:14:07 -0700 (PDT)
Date:   Thu, 15 Jul 2021 17:14:07 -0700
In-Reply-To: <532f6c4a-1066-a31a-bd14-3f5068365f50@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000494b5f05c73277cd@google.com>
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

------------[ cut here ]------------
WARNING: CPU: 1 PID: 25279 at fs/io_uring.c:9122 io_dump fs/io_uring.c:9117 [inline]
WARNING: CPU: 1 PID: 25279 at fs/io_uring.c:9122 io_uring_cancel_generic+0x5fb/0xe50 fs/io_uring.c:9195
Modules linked in:
CPU: 1 PID: 25279 Comm: iou-sqp-25271 Tainted: G        W         5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_dump fs/io_uring.c:9122 [inline]
RIP: 0010:io_uring_cancel_generic+0x5fb/0xe50 fs/io_uring.c:9195
Code: 08 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 9e 06 00 00 48 8b 85 10 08 00 00 48 89 44 24 40 <0f> 0b 48 8b 44 24 10 48 05 98 00 00 00 48 89 c2 48 89 44 24 08 48
RSP: 0018:ffffc9000ab87c50 EFLAGS: 00010246
RAX: ffff88803ddb7800 RBX: ffff888049f73880 RCX: 0000000000000000
RDX: 1ffff110093ee812 RSI: ffffffff81e2ebed RDI: ffff888049f74090
RBP: ffff888049f73880 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81e2ebc5 R11: 0000000000000001 R12: ffffc9000ab87d40
R13: ffff88803ddb7858 R14: 0000000000000001 R15: 0000000000000000
FS:  00007fb893f40700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f68dd0c6080 CR3: 000000002b457000 CR4: 0000000000350ef0
Call Trace:
 io_sq_thread+0xaac/0x1250 fs/io_uring.c:6930
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 25279 Comm: iou-sqp-25271 Tainted: G        W         5.14.0-rc1-syzkaller #0
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
RIP: 0010:io_dump fs/io_uring.c:9122 [inline]
RIP: 0010:io_uring_cancel_generic+0x5fb/0xe50 fs/io_uring.c:9195
Code: 08 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 9e 06 00 00 48 8b 85 10 08 00 00 48 89 44 24 40 <0f> 0b 48 8b 44 24 10 48 05 98 00 00 00 48 89 c2 48 89 44 24 08 48
RSP: 0018:ffffc9000ab87c50 EFLAGS: 00010246
RAX: ffff88803ddb7800 RBX: ffff888049f73880 RCX: 0000000000000000
RDX: 1ffff110093ee812 RSI: ffffffff81e2ebed RDI: ffff888049f74090
RBP: ffff888049f73880 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81e2ebc5 R11: 0000000000000001 R12: ffffc9000ab87d40
R13: ffff88803ddb7858 R14: 0000000000000001 R15: 0000000000000000
 io_sq_thread+0xaac/0x1250 fs/io_uring.c:6930
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Kernel Offset: disabled
Rebooting in 86400 seconds..


Tested on:

commit:         d55b8f3c io_uring: add syz debug info
git tree:       https://github.com/isilence/linux.git syztest_sqpoll_hang
console output: https://syzkaller.appspot.com/x/log.txt?x=16f6cb80300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfe2c0e42bc9993d
dashboard link: https://syzkaller.appspot.com/bug?extid=ac957324022b7132accf
compiler:       

