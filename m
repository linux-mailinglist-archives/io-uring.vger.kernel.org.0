Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C593FCF6A
	for <lists+io-uring@lfdr.de>; Wed,  1 Sep 2021 00:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhHaWGT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 18:06:19 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:52854 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhHaWGS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 18:06:18 -0400
Received: by mail-io1-f71.google.com with SMTP id e18-20020a6b7312000000b005be766a70dbso326040ioh.19
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 15:05:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=a8wS8La3XxEogcajdJZCQlNQNh7GcJyYpgdD6AtRXmM=;
        b=BfGiZnUc/NzGoLuqgeNly0UZNBAQUZAkcRPlKSWzKPu7jcVHouOuvUvvKwa5+Q6iGO
         H6qwIqS1cpB2TCrv1T3qyvBAo2SjJzEB7UtRHx7C3AArYqQp39MqX+xVTRiMMJQgu6lW
         eyUSV25oXNiZYtosb9Y4gMOZXvzB8rZCm7t4n1ROlEZAdf0z9rhKvYaWgLvuE1o0kFMu
         qvkarq1ZGHYw+GiEvJQRvpm2sK1fAVTvx+nts+uaXgET4EZvDIYdBJ2WUGIwB+T5MzA/
         IimAho1WA0szI+P3ORoCSFDZfOmOnd2y8Hx1Wbw4RB+w/DR7IrylWLEiaKHusJaKqN2J
         To1Q==
X-Gm-Message-State: AOAM533gypCNnznzVi2KeKldQ8Z9y95hLcLzE5N0HXbjTe2rc4ThXvqg
        Z12kPZq77jTeHh5c2Dc5KWGFQpQs5bt0A4r1fbC96HdplDN8
X-Google-Smtp-Source: ABdhPJwJXFBbWWQUdtsbteM4dz4QX0pxE+wvhYmcC738h2dw+tFVL4xJ5mWdzUqMH8AoHbFeZNkGswoWt4k8wcHN7FlkF1vnwGES
MIME-Version: 1.0
X-Received: by 2002:a92:7108:: with SMTP id m8mr22206148ilc.238.1630447522885;
 Tue, 31 Aug 2021 15:05:22 -0700 (PDT)
Date:   Tue, 31 Aug 2021 15:05:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006d354305cae2253f@google.com>
Subject: [syzbot] general protection fault in __io_file_supports_nowait
From:   syzbot <syzbot+e51249708aaa9b0e4d2c@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9c849ce86e0f Merge tag '5.15-rc-smb3-fixes-part1' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16eead75300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf588afb178273fb
dashboard link: https://syzkaller.appspot.com/bug?extid=e51249708aaa9b0e4d2c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e51249708aaa9b0e4d2c@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 PID: 13658 Comm: syz-executor.1 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:file_inode include/linux/fs.h:1344 [inline]
RIP: 0010:__io_file_supports_nowait+0x26/0x500 fs/io_uring.c:2785
Code: 00 00 00 00 41 55 41 54 41 89 f4 55 48 89 fd 53 e8 6f 61 96 ff 48 8d 7d 20 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 2d 04 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b
RSP: 0018:ffffc90003247948 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000008 RCX: ffffc9000b8c4000
RDX: 0000000000000004 RSI: ffffffff81dfb791 RDI: 0000000000000020
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffc90003247a00
R10: ffffffff81e293dc R11: 0000000000000001 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000003 R15: 0000000000000001
FS:  00007fd0a23d1700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000014a53ad CR3: 000000002ebbe000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_file_supports_nowait fs/io_uring.c:2823 [inline]
 io_file_supports_nowait fs/io_uring.c:2816 [inline]
 io_write+0x4cf/0xed0 fs/io_uring.c:3545
 io_issue_sqe+0x289/0x6ba0 fs/io_uring.c:6563
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
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd0a23d1188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000200 RBX: 000000000056bf80 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 00000000000045f5 RDI: 0000000000000004
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 0000000000a9fb1f R14: 00007fd0a23d1300 R15: 0000000000022000
Modules linked in:
---[ end trace 2fda19a8d1802890 ]---
RIP: 0010:file_inode include/linux/fs.h:1344 [inline]
RIP: 0010:__io_file_supports_nowait+0x26/0x500 fs/io_uring.c:2785
Code: 00 00 00 00 41 55 41 54 41 89 f4 55 48 89 fd 53 e8 6f 61 96 ff 48 8d 7d 20 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 2d 04 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b
RSP: 0018:ffffc90003247948 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000008 RCX: ffffc9000b8c4000
RDX: 0000000000000004 RSI: ffffffff81dfb791 RDI: 0000000000000020
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffc90003247a00
R10: ffffffff81e293dc R11: 0000000000000001 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000003 R15: 0000000000000001
FS:  00007fd0a23d1700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000512630 CR3: 000000002ebbe000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	41 55                	push   %r13
   6:	41 54                	push   %r12
   8:	41 89 f4             	mov    %esi,%r12d
   b:	55                   	push   %rbp
   c:	48 89 fd             	mov    %rdi,%rbp
   f:	53                   	push   %rbx
  10:	e8 6f 61 96 ff       	callq  0xff966184
  15:	48 8d 7d 20          	lea    0x20(%rbp),%rdi
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 2d 04 00 00    	jne    0x461
  34:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  3b:	fc ff df
  3e:	4c                   	rex.WR
  3f:	8b                   	.byte 0x8b


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
