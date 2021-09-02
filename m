Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A04A3FF256
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 19:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346620AbhIBRf0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 13:35:26 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:35463 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbhIBRfT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 13:35:19 -0400
Received: by mail-il1-f199.google.com with SMTP id x3-20020a92de03000000b0022458d4e768so1725515ilm.2
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 10:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=uu+62LXCKV0IjWYPMQZXIyUzLF6UVu2gV1ysjy2eKhY=;
        b=UsLmaF3sDyDw3NXFZIT6xVgDai8v9vHDaAWv7vOQWFaL7JEEQaxkyGJ3YzQq1eYHe3
         BYzABFsTPce5Byq9c2Rqgl6aAHg2zfIT0Suq4vdrXm3zA3nwJmpdsO/mVaYRrzmXMOmt
         f9izz4PRI61po9McG2JJjr+nGwcHpbr22mKZk0LRD54B5vgXQ3MhLWF7q7+dKqfCHtuX
         JEbsMQ0Hl3FGQMk4gVGriMPYUIo9Ha2AIPF2eSQVprwqunk5+q8YAFNOkqzECx9vynfP
         tj6ynFPoD1noA1zxcI6M6+bMVk9+W1hu2EBhxb2QCMtYgqihMMXQB8rrBrD/0ceitzfH
         zWPw==
X-Gm-Message-State: AOAM532imslbpoMywPwKL5tUH/6csHoGJTED8KIoM9rompQwl7v+lObg
        yYSG4KDD6aVUIF6PmNFRMIQvE/CU9ZxqZAavObLsbU6Ox1DI
X-Google-Smtp-Source: ABdhPJxGbDwm5sk/q0Epwt2snFiljcEPp9A/ZsbrNImeSYgs4uFBLG80eoExfc0aLsGxdlRAEIZDebg7eayX+GJDvqv74+ETii0m
MIME-Version: 1.0
X-Received: by 2002:a92:d9ce:: with SMTP id n14mr3226117ilq.9.1630604060354;
 Thu, 02 Sep 2021 10:34:20 -0700 (PDT)
Date:   Thu, 02 Sep 2021 10:34:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c96e4e05cb0697ab@google.com>
Subject: [syzbot] general protection fault in io_issue_sqe
From:   syzbot <syzbot+de67aa0cf1053e405871@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, haoxu@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9c849ce86e0f Merge tag '5.15-rc-smb3-fixes-part1' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1292c59d300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf588afb178273fb
dashboard link: https://syzkaller.appspot.com/bug?extid=de67aa0cf1053e405871
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1681ad75300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b72083300000

The issue was bisected to:

commit a8295b982c46d4a7c259a4cdd58a2681929068a9
Author: Hao Xu <haoxu@linux.alibaba.com>
Date:   Fri Aug 27 09:46:09 2021 +0000

    io_uring: fix failed linkchain code logic

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16d17dde300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15d17dde300000
console output: https://syzkaller.appspot.com/x/log.txt?x=11d17dde300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+de67aa0cf1053e405871@syzkaller.appspotmail.com
Fixes: a8295b982c46 ("io_uring: fix failed linkchain code logic")

general protection fault, probably for non-canonical address 0xdffffc0000000010: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000080-0x0000000000000087]
CPU: 1 PID: 8426 Comm: syz-executor497 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_accept fs/io_uring.c:5041 [inline]
RIP: 0010:io_issue_sqe+0x2522/0x6ba0 fs/io_uring.c:6596
Code: 48 c1 ea 03 80 3c 02 00 0f 85 66 42 00 00 48 b8 00 00 00 00 00 fc ff df 4d 8b 27 49 8d bc 24 80 00 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 47 42 00 00 45 8b ac 24 80 00
RSP: 0018:ffffc900010dfb48 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000010 RSI: ffffffff81e2c2cd RDI: 0000000000000080
RBP: ffff888016a5179c R08: 0000000000000000 R09: ffffffff81e29ff8
R10: ffffffff81e2c2bf R11: 000000000000000d R12: 0000000000000000
R13: 1ffff11002d4a2f9 R14: 0000000000000003 R15: ffff888016a51780
FS:  0000000000675300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f74bb07a6c0 CR3: 0000000026e49000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __io_queue_sqe+0x90/0xb50 fs/io_uring.c:6864
 io_req_task_submit+0xbf/0x1b0 fs/io_uring.c:2218
 tctx_task_work+0x166/0x610 fs/io_uring.c:2143
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:212 [inline]
 handle_signal_work kernel/entry/common.c:146 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x256/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f069
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc12dd2538 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000304 RBX: 0000000000000003 RCX: 000000000043f069
RDX: 0000000000000000 RSI: 0000000000000304 RDI: 0000000000000003
RBP: 0000000000403050 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004030e0
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
Modules linked in:
---[ end trace 51fb6b52dc1cb8ce ]---
RIP: 0010:io_accept fs/io_uring.c:5041 [inline]
RIP: 0010:io_issue_sqe+0x2522/0x6ba0 fs/io_uring.c:6596
Code: 48 c1 ea 03 80 3c 02 00 0f 85 66 42 00 00 48 b8 00 00 00 00 00 fc ff df 4d 8b 27 49 8d bc 24 80 00 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 47 42 00 00 45 8b ac 24 80 00
RSP: 0018:ffffc900010dfb48 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000010 RSI: ffffffff81e2c2cd RDI: 0000000000000080
RBP: ffff888016a5179c R08: 0000000000000000 R09: ffffffff81e29ff8
R10: ffffffff81e2c2bf R11: 000000000000000d R12: 0000000000000000
R13: 1ffff11002d4a2f9 R14: 0000000000000003 R15: ffff888016a51780
FS:  0000000000675300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f544adff000 CR3: 0000000026e49000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	48 c1 ea 03          	shr    $0x3,%rdx
   4:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   8:	0f 85 66 42 00 00    	jne    0x4274
   e:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  15:	fc ff df
  18:	4d 8b 27             	mov    (%r15),%r12
  1b:	49 8d bc 24 80 00 00 	lea    0x80(%r12),%rdi
  22:	00
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	74 08                	je     0x3a
  32:	3c 03                	cmp    $0x3,%al
  34:	0f 8e 47 42 00 00    	jle    0x4281
  3a:	45                   	rex.RB
  3b:	8b                   	.byte 0x8b
  3c:	ac                   	lods   %ds:(%rsi),%al
  3d:	24 80                	and    $0x80,%al


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
