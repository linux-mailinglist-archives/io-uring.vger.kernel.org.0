Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB14B409C51
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 20:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240351AbhIMSdi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 14:33:38 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:52888 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235706AbhIMSdi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 14:33:38 -0400
Received: by mail-il1-f198.google.com with SMTP id 8-20020a92c648000000b002318992f65bso5691709ill.19
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 11:32:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=NHZDHLYcnktOgU5NNoVaZJ4zgNvYHLZXM7Gbcpsm29s=;
        b=7ekMOXxrgd4Uqa+gXWKiVX+Jg96mfMz5SA3ytpl0axPMI16a4Gs3nvxYKTG11eH0KS
         D4MUEvL1gXgA4RJwMXBX7R12wO08i5Acc42q+DMP3+r+WioDuNVpALZ2l5mMRsdXZGBD
         eTCTwnOUrdtBKElUGJ0+BHo7Y3+A9s3IE/kNBe8Jl9O/H0aLnuQZM58wOeNS3Ck7i5z4
         /g5lfegL3FLdWaDLOm3A2MohgB9OZ6w/uA/ini/8ZkenJQsy0LwgP92D5gbg4I4dwt9Z
         vH+kaHoXOGr1+3jDPfaeII5cY+4ZSmHtaTSJRriWoraQQExJ/Qrf+1w4AqVyvwA3j3M5
         LXZA==
X-Gm-Message-State: AOAM531FNCaIEGLh8+m7Pk3A+/NjNa6tE5eApxwwm2By/0TjW6/uugm1
        yXR6ITSuXrTTkpKPKhAM4gjS/RbxEv4YCuUWRy+5fsu4C65k
X-Google-Smtp-Source: ABdhPJxTPls5IFmATONlxtTSL49mlLZVdjNPiZE5bqHWJgUX6wQhApVBo9BfYVf8ynISWlBMAlZXauZfEadOLWBfm8whFgK4b1Nv
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2001:: with SMTP id y1mr10258322iod.97.1631557941930;
 Mon, 13 Sep 2021 11:32:21 -0700 (PDT)
Date:   Mon, 13 Sep 2021 11:32:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008f30cb05cbe4af29@google.com>
Subject: [syzbot] general protection fault in io_uring_register
From:   syzbot <syzbot+337de45f13a4fd54d708@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        johalun0@gmail.com, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a3fa7a101dcf Merge branches 'akpm' and 'akpm-hotfixes' (pa..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17da7b93300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ddf81d5d49fe3452
dashboard link: https://syzkaller.appspot.com/bug?extid=337de45f13a4fd54d708
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=129e9da5300000

The issue was bisected to:

commit fa84693b3c896460831fe0750554121121a23da8
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Sep 1 20:15:59 2021 +0000

    io_uring: ensure IORING_REGISTER_IOWQ_MAX_WORKERS works with SQPOLL

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=164900c3300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=154900c3300000
console output: https://syzkaller.appspot.com/x/log.txt?x=114900c3300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+337de45f13a4fd54d708@syzkaller.appspotmail.com
Fixes: fa84693b3c89 ("io_uring: ensure IORING_REGISTER_IOWQ_MAX_WORKERS works with SQPOLL")

general protection fault, probably for non-canonical address 0xdffffc0000000103: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000818-0x000000000000081f]
CPU: 0 PID: 12816 Comm: syz-executor.1 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_register_iowq_max_workers fs/io_uring.c:10552 [inline]
RIP: 0010:__io_uring_register fs/io_uring.c:10757 [inline]
RIP: 0010:__do_sys_io_uring_register+0x10e9/0x2e70 fs/io_uring.c:10792
Code: ea 03 80 3c 02 00 0f 85 43 1b 00 00 48 8b 9b a8 00 00 00 b8 ff ff 37 00 48 c1 e0 2a 48 8d bb 18 08 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 11 1b 00 00 48 8b 9b 18 08 00 00 48 85 db 0f 84
RSP: 0018:ffffc90003f3fdf8 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000103 RSI: 0000000000000004 RDI: 0000000000000818
RBP: ffff888073777900 R08: 0000000000000000 R09: ffff88807e916413
R10: ffffed100fd22c82 R11: 0000000000000001 R12: 0000000000000000
R13: ffffc90003f3fec8 R14: 1ffff920007e7fc9 R15: ffff88805cd7e000
FS:  00007f6c631e3700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001907808 CR3: 0000000062c6d000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6c631e3188 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 000000000056c038 RCX: 00000000004665f9
RDX: 0000000020004000 RSI: 0000000000000013 RDI: 0000000000000003
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000246 R12: 000000000056c038
R13: 00007ffdd807e0af R14: 00007f6c631e3300 R15: 0000000000022000
Modules linked in:
---[ end trace 1cd60a7726ee853d ]---
RIP: 0010:io_register_iowq_max_workers fs/io_uring.c:10552 [inline]
RIP: 0010:__io_uring_register fs/io_uring.c:10757 [inline]
RIP: 0010:__do_sys_io_uring_register+0x10e9/0x2e70 fs/io_uring.c:10792
Code: ea 03 80 3c 02 00 0f 85 43 1b 00 00 48 8b 9b a8 00 00 00 b8 ff ff 37 00 48 c1 e0 2a 48 8d bb 18 08 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 11 1b 00 00 48 8b 9b 18 08 00 00 48 85 db 0f 84
RSP: 0018:ffffc90003f3fdf8 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000103 RSI: 0000000000000004 RDI: 0000000000000818
RBP: ffff888073777900 R08: 0000000000000000 R09: ffff88807e916413
R10: ffffed100fd22c82 R11: 0000000000000001 R12: 0000000000000000
R13: ffffc90003f3fec8 R14: 1ffff920007e7fc9 R15: ffff88805cd7e000
FS:  00007f6c631e3700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb988f6b000 CR3: 0000000062c6d000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	03 80 3c 02 00 0f    	add    0xf00023c(%rax),%eax
   6:	85 43 1b             	test   %eax,0x1b(%rbx)
   9:	00 00                	add    %al,(%rax)
   b:	48 8b 9b a8 00 00 00 	mov    0xa8(%rbx),%rbx
  12:	b8 ff ff 37 00       	mov    $0x37ffff,%eax
  17:	48 c1 e0 2a          	shl    $0x2a,%rax
  1b:	48 8d bb 18 08 00 00 	lea    0x818(%rbx),%rdi
  22:	48 89 fa             	mov    %rdi,%rdx
  25:	48 c1 ea 03          	shr    $0x3,%rdx
* 29:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2d:	0f 85 11 1b 00 00    	jne    0x1b44
  33:	48 8b 9b 18 08 00 00 	mov    0x818(%rbx),%rbx
  3a:	48 85 db             	test   %rbx,%rbx
  3d:	0f                   	.byte 0xf
  3e:	84                   	.byte 0x84


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
