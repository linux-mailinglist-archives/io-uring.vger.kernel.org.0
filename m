Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3ABC28E4F6
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 19:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgJNRAb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 13:00:31 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:40793 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728154AbgJNRAb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 13:00:31 -0400
Received: by mail-il1-f199.google.com with SMTP id w12so22673ilj.7
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 10:00:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RnJBl0Hmt3VbdPCKojapfwyMp88sA/Fx2rpPy2khylI=;
        b=hFniht+BpfpMLbKqKDN57QmPWOcAb+QsZ9DjUbaqsVWp6EbGWrIw8JWLeLI2+nRohA
         3ojMiAg6O9fGL/pGMckXMcG9wGTuLiy3XIwIZVoXR3N90b752UyXI1uzgGLmMHJZ3vbD
         6UFJm3AJO7Zifwyvo0t701gJBDVR/CziqmdFR2JrQyaGBcHAGYWb69WoJSwDHWo3Ukc+
         /puokLsXdNNjfVw18C2AvGKFSLMmbt1vCQ2p2l+Xw/Lx+sCTm037RvJX9/b/U3y6a5R6
         FiYyJl4Sr/ltDnjCa14KFdo1SQ/G6jAWj635sYOmK4QGNfHoqY8d0KK1wqQOcHJnTZwI
         INSw==
X-Gm-Message-State: AOAM533wwRYRXfwdFKVdtvolBTUHsKkzZ1oYsEEzsGBKRqV8cVOH4QOs
        DDi+crMoaSGjy7WoFKgAIN8lR35SYnSJnWmt4dr2XfroMEbM
X-Google-Smtp-Source: ABdhPJyu0KgRC/6EhCBxf9s4T2rjtKgw4fFsPDJPRmFQstZjg5fujQkhnex6YxX/y1We5/Rg9m8e/DuHsEOloFtvvabVNJhHtwU0
MIME-Version: 1.0
X-Received: by 2002:a05:6602:148:: with SMTP id v8mr239346iot.33.1602694830372;
 Wed, 14 Oct 2020 10:00:30 -0700 (PDT)
Date:   Wed, 14 Oct 2020 10:00:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000c3be205b1a4782f@google.com>
Subject: general protection fault in __se_sys_io_uring_register
From:   syzbot <syzbot+4520eff3d84059553f13@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    029f56db Merge tag 'x86_asm_for_v5.10' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1421c89b900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c5327fbeef7650a
dashboard link: https://syzkaller.appspot.com/bug?extid=4520eff3d84059553f13
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4520eff3d84059553f13@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 8347 Comm: syz-executor.3 Not tainted 5.9.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_file_from_index fs/io_uring.c:5963 [inline]
RIP: 0010:io_sqe_files_register fs/io_uring.c:7369 [inline]
RIP: 0010:__io_uring_register fs/io_uring.c:9463 [inline]
RIP: 0010:__do_sys_io_uring_register fs/io_uring.c:9553 [inline]
RIP: 0010:__se_sys_io_uring_register+0x3343/0x3ea0 fs/io_uring.c:9535
Code: ff df 48 8b 5c 24 18 42 80 3c 23 00 48 8b 6c 24 60 74 08 48 89 ef e8 bc 36 e0 ff 41 8d 5e ff 4c 8b 7d 00 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 9e 36 e0 ff 89 d8 c1 f8 09 48 63
RSP: 0018:ffffc9001633fdc0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 1ffff11011eb5638
RDX: ffff888051844080 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff88808f5ab1b8 R08: ffffffff81d56c63 R09: ffffed1012046ab8
R10: ffffed1012046ab8 R11: 0000000000000000 R12: dffffc0000000000
R13: 00000000fffffff7 R14: 0000000000000001 R15: 0000000000000000
FS:  00007f5b96b14700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000768000 CR3: 000000009ed9c000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45de59
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f5b96b13c78 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00000000000083c0 RCX: 000000000045de59
RDX: 0000000020000040 RSI: 0000000000000002 RDI: 0000000000000003
RBP: 000000000118bf68 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007ffcf7ec75bf R14: 00007f5b96b149c0 R15: 000000000118bf2c
Modules linked in:
---[ end trace ae2cc3c0d259d867 ]---
RIP: 0010:io_file_from_index fs/io_uring.c:5963 [inline]
RIP: 0010:io_sqe_files_register fs/io_uring.c:7369 [inline]
RIP: 0010:__io_uring_register fs/io_uring.c:9463 [inline]
RIP: 0010:__do_sys_io_uring_register fs/io_uring.c:9553 [inline]
RIP: 0010:__se_sys_io_uring_register+0x3343/0x3ea0 fs/io_uring.c:9535
Code: ff df 48 8b 5c 24 18 42 80 3c 23 00 48 8b 6c 24 60 74 08 48 89 ef e8 bc 36 e0 ff 41 8d 5e ff 4c 8b 7d 00 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 9e 36 e0 ff 89 d8 c1 f8 09 48 63
RSP: 0018:ffffc9001633fdc0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 1ffff11011eb5638
RDX: ffff888051844080 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff88808f5ab1b8 R08: ffffffff81d56c63 R09: ffffed1012046ab8
R10: ffffed1012046ab8 R11: 0000000000000000 R12: dffffc0000000000
R13: 00000000fffffff7 R14: 0000000000000001 R15: 0000000000000000
FS:  00007f5b96b14700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000768000 CR3: 000000009ed9c000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
