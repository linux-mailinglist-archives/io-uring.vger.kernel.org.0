Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9D8790155
	for <lists+io-uring@lfdr.de>; Fri,  1 Sep 2023 19:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349051AbjIARXE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Sep 2023 13:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244116AbjIARXE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Sep 2023 13:23:04 -0400
Received: from mail-pj1-f78.google.com (mail-pj1-f78.google.com [209.85.216.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AFA107
        for <io-uring@vger.kernel.org>; Fri,  1 Sep 2023 10:23:00 -0700 (PDT)
Received: by mail-pj1-f78.google.com with SMTP id 98e67ed59e1d1-26b10a6dbcaso2584284a91.1
        for <io-uring@vger.kernel.org>; Fri, 01 Sep 2023 10:23:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693588975; x=1694193775;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L1GA6UIkyb5UVHLOkCx2m8vhe4FTUtbJOdVN7nKc4qA=;
        b=YMGrKrDwoV0Rgf+qAWaNCHF6ofVVquUWb0xCEbL1RQFaX/erFtzrhQHpVkcJHeS513
         dAB9c1OiLnpUb+L3ilrQjzviRHuCDWgpL0CM/ZSfNF5qOBQaMWoDWYtQPw2uS3tA1QJd
         M3JoXuAeFxZhk1ZvTgPEIXTqt1mBcuv/nSOzY4TVnDfn9y5l1OEA31pgc93IK5N+4ekV
         U3ryxyHVmGJ+5liX1yyZFPAS19tpfAsevVKlEvloB+nyMoVWk7NvI2ktcfzBlU9EYLi6
         oBlXiOzsp522QO1+1IPivHAH3YVghT8H7wfsEPl4bNi8316k54rX5uk31m/PVkvqT3cF
         yu3A==
X-Gm-Message-State: AOJu0YzjInt0I03EZhfkd/P5hPmECrGvn27PRH++jgRi+ddoXZ9Wn5hE
        RZZRRYi3EhaKI+amDq+T3Dl+MhHVgv95jlBjQJKdIJSwFiCY
X-Google-Smtp-Source: AGHT+IFB0VKr/Pju9qY8XI6DVSbiKcPGK1ArxeP9yOUdvGF0IiEzaPvZsHYd9XcY1UD0Vfd0vpwOqWIgYgyQ3U3EcD3K1SUzepfN
MIME-Version: 1.0
X-Received: by 2002:a17:90a:8c91:b0:268:3469:d86e with SMTP id
 b17-20020a17090a8c9100b002683469d86emr757087pjo.1.1693588975412; Fri, 01 Sep
 2023 10:22:55 -0700 (PDT)
Date:   Fri, 01 Sep 2023 10:22:55 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000466a6106044f6986@google.com>
Subject: [syzbot] [io-uring?] general protection fault in io_uring_show_fdinfo
From:   syzbot <syzbot+216e2ea6e0bf4a0acdd7@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    99d99825fc07 Merge tag 'nfs-for-6.6-1' of git://git.linux-..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12e9fc13a80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cce54b04d9a3d05b
dashboard link: https://syzkaller.appspot.com/bug?extid=216e2ea6e0bf4a0acdd7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1749fa10680000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10211c10680000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/dc52c367d995/disk-99d99825.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4387aed6fe34/vmlinux-99d99825.xz
kernel image: https://storage.googleapis.com/syzbot-assets/653ab6d1ead8/bzImage-99d99825.xz

The issue was bisected to:

commit 2af89abda7d9c2aeb573677e2c498ddb09f8058a
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Thu Aug 24 22:53:32 2023 +0000

    io_uring: add option to remove SQ indirection

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1017518fa80000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1217518fa80000
console output: https://syzkaller.appspot.com/x/log.txt?x=1417518fa80000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+216e2ea6e0bf4a0acdd7@syzkaller.appspotmail.com
Fixes: 2af89abda7d9 ("io_uring: add option to remove SQ indirection")

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 5026 Comm: syz-executor249 Not tainted 6.5.0-syzkaller-09276-g99d99825fc07 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/26/2023
RIP: 0010:io_uring_show_fdinfo+0x391/0x1790 io_uring/fdinfo.c:96
Code: 00 00 00 42 80 3c 28 00 74 0f 48 8b 7c 24 30 e8 d5 9d 22 f7 48 8b 4c 24 30 44 21 f3 48 c1 e3 02 48 03 19 48 89 d8 48 c1 e8 03 <42> 8a 04 28 84 c0 0f 85 64 02 00 00 8b 1b 89 df 44 89 f6 e8 c7 c9
RSP: 0018:ffffc900038ffc20 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8880299e60d0
RDX: ffff8880262f9dc0 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc900038ffd98 R08: ffffffff8ac4995f R09: 1ffff11004f01013
R10: dffffc0000000000 R11: ffffed1004f01014 R12: ffff888021153de0
R13: dffffc0000000000 R14: 0000000000003fff R15: 0000000000000001
FS:  000055555700b480(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6f2394f653 CR3: 0000000029588000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 seq_show+0x57d/0x6a0 fs/proc/fd.c:70
 traverse+0x1d5/0x530 fs/seq_file.c:111
 seq_lseek+0x129/0x240 fs/seq_file.c:323
 vfs_llseek fs/read_write.c:289 [inline]
 ksys_lseek fs/read_write.c:302 [inline]
 __do_sys_lseek fs/read_write.c:313 [inline]
 __se_sys_lseek fs/read_write.c:311 [inline]
 __x64_sys_lseek+0x14f/0x1d0 fs/read_write.c:311
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f6f238f2fe9
Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc7fc29dc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000008
RAX: ffffffffffffffda RBX: 00007ffc7fc29de0 RCX: 00007f6f238f2fe9
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc7fc2a048 R14: 0000000000000001 R15: 0000000000000001
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:io_uring_show_fdinfo+0x391/0x1790 io_uring/fdinfo.c:96
Code: 00 00 00 42 80 3c 28 00 74 0f 48 8b 7c 24 30 e8 d5 9d 22 f7 48 8b 4c 24 30 44 21 f3 48 c1 e3 02 48 03 19 48 89 d8 48 c1 e8 03 <42> 8a 04 28 84 c0 0f 85 64 02 00 00 8b 1b 89 df 44 89 f6 e8 c7 c9
RSP: 0018:ffffc900038ffc20 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8880299e60d0
RDX: ffff8880262f9dc0 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc900038ffd98 R08: ffffffff8ac4995f R09: 1ffff11004f01013
R10: dffffc0000000000 R11: ffffed1004f01014 R12: ffff888021153de0
R13: dffffc0000000000 R14: 0000000000003fff R15: 0000000000000001
FS:  000055555700b480(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6f2394f653 CR3: 0000000029588000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	00 42 80             	add    %al,-0x80(%rdx)
   5:	3c 28                	cmp    $0x28,%al
   7:	00 74 0f 48          	add    %dh,0x48(%rdi,%rcx,1)
   b:	8b 7c 24 30          	mov    0x30(%rsp),%edi
   f:	e8 d5 9d 22 f7       	call   0xf7229de9
  14:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  19:	44 21 f3             	and    %r14d,%ebx
  1c:	48 c1 e3 02          	shl    $0x2,%rbx
  20:	48 03 19             	add    (%rcx),%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 8a 04 28          	mov    (%rax,%r13,1),%al <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 64 02 00 00    	jne    0x29a
  36:	8b 1b                	mov    (%rbx),%ebx
  38:	89 df                	mov    %ebx,%edi
  3a:	44 89 f6             	mov    %r14d,%esi
  3d:	e8                   	.byte 0xe8
  3e:	c7                   	(bad)
  3f:	c9                   	leave


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
