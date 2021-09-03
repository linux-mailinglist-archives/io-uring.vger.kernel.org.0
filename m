Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48D640069C
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 22:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350334AbhICU3Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 16:29:24 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:46927 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350477AbhICU3X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 16:29:23 -0400
Received: by mail-io1-f70.google.com with SMTP id s6-20020a5ec646000000b005b7f88ffdd3so89189ioo.13
        for <io-uring@vger.kernel.org>; Fri, 03 Sep 2021 13:28:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jGLhEUFplOoJ/qo+jFNjFkkgA39xQY0d5R4eHXBI6Is=;
        b=kKA+verI9OyJcpPsNqWlfizp7kuXuahaLWkJ0q/DbVnkUhLXVzYOrPe5Tb/BJGrT/e
         FBZcETmCxqPdlIF5/D5nWmhcBy7Pla81n7eJO3T0z2QFeepCd2KErPpcAwHdxQEXllHw
         G+9LM/R1YBTDX6d0ZhYdw6MnAmgBVoz5UG/koa47nOhUaftAUTxAiy84KK+hd5LkbLGV
         3s21YwgaJRldgz03YkliqaPZsP5X54F1Ersd7+AxsW4cylxcP9RhyHlWaENrBdK9LzVJ
         GgYczm5O+Pd4NGq+gqOPnsc8YHMFP46NnvAL9oKg9asFjK4vH1phT7wjS16Whw+prEzI
         t6vA==
X-Gm-Message-State: AOAM531soUIO+2bwAoLHqBhmL9cUIGDYJDLOe5/1yUu+yKgzRp/YWGXl
        7l7Vnlg+Q2l/MV54C9cNhJUeKc/OKYNCAx+AoPbG14RAJlyb
X-Google-Smtp-Source: ABdhPJwRR3R37SyRCc56Rr+B4b549z3ZvwSe44oL+ErPSk5IaOKhNUNeM1ougkw1Zkod3QP7QTDAUPf04VcYxJIiONxJBu3oCEbs
MIME-Version: 1.0
X-Received: by 2002:a5e:c903:: with SMTP id z3mr599354iol.61.1630700903132;
 Fri, 03 Sep 2021 13:28:23 -0700 (PDT)
Date:   Fri, 03 Sep 2021 13:28:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000010f70d05cb1d2407@google.com>
Subject: [syzbot] general protection fault in __io_arm_poll_handler
From:   syzbot <syzbot+ba74b85fa15fd7a96437@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14e6c8cd300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c84ed2c3f57ace
dashboard link: https://syzkaller.appspot.com/bug?extid=ba74b85fa15fd7a96437
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137a45a3300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105ba169300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ba74b85fa15fd7a96437@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
CPU: 1 PID: 8812 Comm: iou-sqp-8804 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:vfs_poll include/linux/poll.h:88 [inline]
RIP: 0010:__io_arm_poll_handler+0x2fa/0xb10 fs/io_uring.c:5476
Code: 24 38 42 80 3c 20 00 74 08 48 89 ef e8 df 15 db ff 48 8b 6d 00 48 8d 5d 28 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 b8 15 db ff 4c 8b 23 49 83 c4 48 4c
RSP: 0018:ffffc90001e7f0a8 EFLAGS: 00010206
RAX: 0000000000000005 RBX: 0000000000000028 RCX: dffffc0000000000
RDX: 0000000000000010 RSI: 0000000000000000 RDI: ffffc90001e7f1f0
RBP: 0000000000000000 R08: dffffc0000000000 R09: ffff88801252e820
R10: ffffed10024a5d06 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff920003cfe3f R14: ffffc90001e7f1fc R15: ffffc90001e7f1f8
FS:  00007f6951c24700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000049a01d CR3: 000000002b182000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_poll_add+0xf1/0x590 fs/io_uring.c:5751
 io_issue_sqe+0x192b/0x9280 fs/io_uring.c:6569
 __io_queue_sqe+0xe3/0x1000 fs/io_uring.c:6864
 tctx_task_work+0x2ad/0x560 fs/io_uring.c:2143
 task_work_run+0x146/0x1c0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:212 [inline]
 io_run_task_work+0x110/0x140 fs/io_uring.c:2403
 io_sq_thread+0xb5e/0x1220 fs/io_uring.c:7337
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Modules linked in:
---[ end trace 65dffd9e454d7c44 ]---
RIP: 0010:vfs_poll include/linux/poll.h:88 [inline]
RIP: 0010:__io_arm_poll_handler+0x2fa/0xb10 fs/io_uring.c:5476
Code: 24 38 42 80 3c 20 00 74 08 48 89 ef e8 df 15 db ff 48 8b 6d 00 48 8d 5d 28 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 b8 15 db ff 4c 8b 23 49 83 c4 48 4c
RSP: 0018:ffffc90001e7f0a8 EFLAGS: 00010206
RAX: 0000000000000005 RBX: 0000000000000028 RCX: dffffc0000000000
RDX: 0000000000000010 RSI: 0000000000000000 RDI: ffffc90001e7f1f0
RBP: 0000000000000000 R08: dffffc0000000000 R09: ffff88801252e820
R10: ffffed10024a5d06 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff920003cfe3f R14: ffffc90001e7f1fc R15: ffffc90001e7f1f8
FS:  00007f6951c24700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd472d29c0 CR3: 000000002b182000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	24 38                	and    $0x38,%al
   2:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
   7:	74 08                	je     0x11
   9:	48 89 ef             	mov    %rbp,%rdi
   c:	e8 df 15 db ff       	callq  0xffdb15f0
  11:	48 8b 6d 00          	mov    0x0(%rbp),%rbp
  15:	48 8d 5d 28          	lea    0x28(%rbp),%rbx
  19:	48 89 d8             	mov    %rbx,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  27:	fc ff df
* 2a:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	48 89 df             	mov    %rbx,%rdi
  33:	e8 b8 15 db ff       	callq  0xffdb15f0
  38:	4c 8b 23             	mov    (%rbx),%r12
  3b:	49 83 c4 48          	add    $0x48,%r12
  3f:	4c                   	rex.WR


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
