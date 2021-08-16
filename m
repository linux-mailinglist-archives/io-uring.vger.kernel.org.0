Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40AD3ED75A
	for <lists+io-uring@lfdr.de>; Mon, 16 Aug 2021 15:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240993AbhHPNbv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Aug 2021 09:31:51 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:37611 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241542AbhHPN3t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Aug 2021 09:29:49 -0400
Received: by mail-io1-f69.google.com with SMTP id h3-20020a056602008300b005b7c0e23e11so1209207iob.4
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 06:29:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SPj4+myJ8JzhjGfXTTH/Z+OtZy43EqV2wJdhxiY1nKw=;
        b=Vt1u6BhXwCrHYgwzFS/zyCMnK0u2m3PFtaxBurXfUb6T8EJlGFDV1O5kcF95Fihvy5
         p/9/BcbqUkbUpI/+wWNnEMnO6GWkeVDTQKOflySEa0PXjeCjPjQXVtmH8XlGQS1iYFty
         JnSJlR4agLVGqz71MY/cpepu9AmAcNwQp/KwyYbXk5/TDDc9XsjLUxuj5EKAboSmn/Gz
         HZu336b0A/Vv+qv0aIm0PDgDua03cYyOwi3t6QIlMlrOsf0O6a7N92RSiBRfptfAcq4V
         gP19WW5ABqv9fDgI3gjUipGnH3DJxd2OiSQPf2FfN1xM7ZFrKkB2yGJyqcGfZxkLRFvy
         Bm3A==
X-Gm-Message-State: AOAM532mLomULggL/oIDXNlxvMt2o7aiuedt67g+g96mtr58YCbQxG0C
        INhlCdWyo2eA68b7tPccDIIAzQoOV9NFMm09+wRmkuGgNB/C
X-Google-Smtp-Source: ABdhPJzdFf1fUonPWgBMICFHQ9n+A3WIhVwouHe1nI1iOJn6/OQWrzU3ZXPFaBWCxwkT67w9KcFotwb20V+bX6r8Rpt1g/Z81EAI
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a4f:: with SMTP id u15mr11985302ilv.251.1629120557493;
 Mon, 16 Aug 2021 06:29:17 -0700 (PDT)
Date:   Mon, 16 Aug 2021 06:29:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000020339705c9ad30ee@google.com>
Subject: [syzbot] general protection fault in __io_queue_sqe
From:   syzbot <syzbot+2b85e9379c34945fe38f@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b9011c7e671d Add linux-next specific files for 20210816
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15474781300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a245d1aa4f055cc1
dashboard link: https://syzkaller.appspot.com/bug?extid=2b85e9379c34945fe38f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2b85e9379c34945fe38f@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000000b: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
CPU: 0 PID: 6232 Comm: syz-executor.1 Not tainted 5.14.0-rc5-next-20210816-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__io_req_set_refcount fs/io_uring.c:1152 [inline]
RIP: 0010:__io_prep_linked_timeout fs/io_uring.c:1348 [inline]
RIP: 0010:io_prep_linked_timeout fs/io_uring.c:1356 [inline]
RIP: 0010:__io_queue_sqe+0x278/0xeb0 fs/io_uring.c:6708
Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 07 0c 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b 65 70 49 8d 7c 24 58 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 3e 0b 00 00 45 8b 74 24 58 31
RSP: 0018:ffffc9000a9ffd48 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 1ffff9200153ffb0 RCX: ffffc9000ba6a000
RDX: 000000000000000b RSI: ffffffff81e1bcbf RDI: 0000000000000058
RBP: ffff888037d15dc0 R08: 0000000000000001 R09: ffff888037d15e1f
R10: ffffed1006fa2bc3 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff888037d15e30 R15: ffff888037d15e30
FS:  00007fb490054700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000388c5000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_req_task_submit+0xaa/0x120 fs/io_uring.c:2139
 tctx_task_work+0x106/0x540 fs/io_uring.c:2063
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:212 [inline]
 handle_signal_work kernel/entry/common.c:146 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x256/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb490054188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000081 RBX: 000000000056bf80 RCX: 00000000004665e9
RDX: 0000000000000000 RSI: 00000000000045f5 RDI: 0000000000000003
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffe3ce9ca1f R14: 00007fb490054300 R15: 0000000000022000
Modules linked in:
---[ end trace 221813d58846ad59 ]---
RIP: 0010:__io_req_set_refcount fs/io_uring.c:1152 [inline]
RIP: 0010:__io_prep_linked_timeout fs/io_uring.c:1348 [inline]
RIP: 0010:io_prep_linked_timeout fs/io_uring.c:1356 [inline]
RIP: 0010:__io_queue_sqe+0x278/0xeb0 fs/io_uring.c:6708
Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 07 0c 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b 65 70 49 8d 7c 24 58 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 3e 0b 00 00 45 8b 74 24 58 31
RSP: 0018:ffffc9000a9ffd48 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 1ffff9200153ffb0 RCX: ffffc9000ba6a000
RDX: 000000000000000b RSI: ffffffff81e1bcbf RDI: 0000000000000058
RBP: ffff888037d15dc0 R08: 0000000000000001 R09: ffff888037d15e1f
R10: ffffed1006fa2bc3 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff888037d15e30 R15: ffff888037d15e30
FS:  00007fb490054700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b3213a000 CR3: 00000000388c5000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	89 fa                	mov    %edi,%edx
   2:	48 c1 ea 03          	shr    $0x3,%rdx
   6:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   a:	0f 85 07 0c 00 00    	jne    0xc17
  10:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  17:	fc ff df 
  1a:	4c 8b 65 70          	mov    0x70(%rbp),%r12
  1e:	49 8d 7c 24 58       	lea    0x58(%r12),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
  2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	74 08                	je     0x3a
  32:	3c 03                	cmp    $0x3,%al
  34:	0f 8e 3e 0b 00 00    	jle    0xb78
  3a:	45 8b 74 24 58       	mov    0x58(%r12),%r14d
  3f:	31                   	.byte 0x31


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
