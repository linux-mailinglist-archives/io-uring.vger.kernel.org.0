Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879C73FD0FE
	for <lists+io-uring@lfdr.de>; Wed,  1 Sep 2021 04:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241698AbhIACBV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 22:01:21 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:33356 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241692AbhIACBU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 22:01:20 -0400
Received: by mail-il1-f200.google.com with SMTP id h10-20020a056e020d4a00b00227fc2e6687so851286ilj.0
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 19:00:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=M6ewVAPbO/i5ZRnfbguGk+MVnZhkA3eB63sbFYEWhO0=;
        b=ZIOlFhh9w3moTFByfbV/YPPzGvAMb3y7MDmPRPZALXA/ow4/og0smqPxXKMwTec/W9
         OThdScf9uIWjz+699Gc+L0FJxnAvtU/9vLuLhwj4cu+Vlpjy42+zbhLJmVu5ujCOz62U
         8KCnZgS4B44mYh7/QhCpkOXxS7S5rAJXcpps+tJ4F8VT7PgTdbb6HyhrfiFPHg/dg94Y
         +GfO7i/+f2mfLjgLeT98Kv7Oy6uQw4IKwjT/nc9kspR/yF4QcWV63dbI5beJMDdIGFPm
         HGKd9BTplCmzSKMYY2F80aXUuuRFCAB27RBLFA/bf5Xo8S0VLAICE5e9gCMLfndrtgXb
         utxw==
X-Gm-Message-State: AOAM530INKRyciTIQ53FRvvS+ZFisZJIn5rjPu1/7glZ53kObdxg4htZ
        LyX8ugSwymIqH1y7/kUM4619Iwo6gp9RPwGi/W6cQ4nZrqiu
X-Google-Smtp-Source: ABdhPJwFoeLYEE3K/VEdjf7b1fW+5ExXTWG210ng8YQxRo1vrGeiIRzpHuYR+5QoezbtfzUj5pyjywx+jirLDY0qZu+E4TYP9w47
MIME-Version: 1.0
X-Received: by 2002:a5d:8d06:: with SMTP id p6mr25833176ioj.7.1630461624447;
 Tue, 31 Aug 2021 19:00:24 -0700 (PDT)
Date:   Tue, 31 Aug 2021 19:00:24 -0700
In-Reply-To: <0000000000006d354305cae2253f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f1f81105cae56d48@google.com>
Subject: Re: [syzbot] general protection fault in __io_file_supports_nowait
From:   syzbot <syzbot+e51249708aaa9b0e4d2c@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    b91db6a0b52e Merge tag 'for-5.15/io_uring-vfs-2021-08-30' ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12718683300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=210537ff2ddcc232
dashboard link: https://syzkaller.appspot.com/bug?extid=e51249708aaa9b0e4d2c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12615c35300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c57845300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e51249708aaa9b0e4d2c@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 0 PID: 13214 Comm: iou-sqp-13213 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:file_inode include/linux/fs.h:1344 [inline]
RIP: 0010:__io_file_supports_nowait+0x26/0x500 fs/io_uring.c:2785
Code: 00 00 00 00 41 55 41 54 41 89 f4 55 48 89 fd 53 e8 6f 61 96 ff 48 8d 7d 20 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 2d 04 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b
RSP: 0018:ffffc9000305f800 EFLAGS: 00010212
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff81dfb791 RDI: 0000000000000020
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81e28292 R11: 0000000000000001 R12: 0000000000000000
R13: ffffc9000305f8d8 R14: 0000000000000000 R15: 0000000000000001
FS:  00007fa1a4652700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000084 CR3: 0000000027153000 CR4: 0000000000350ef0
Call Trace:
 io_file_supports_nowait fs/io_uring.c:2823 [inline]
 io_file_supports_nowait fs/io_uring.c:2816 [inline]
 io_read+0x4a9/0x1140 fs/io_uring.c:3440
 io_issue_sqe+0x209/0x6ba0 fs/io_uring.c:6558
 __io_queue_sqe+0x90/0xb50 fs/io_uring.c:6864
 io_req_task_submit+0xbf/0x1b0 fs/io_uring.c:2218
 tctx_task_work+0x166/0x610 fs/io_uring.c:2143
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:212 [inline]
 io_run_task_work fs/io_uring.c:2403 [inline]
 io_run_task_work fs/io_uring.c:2399 [inline]
 io_sq_thread+0x867/0x1370 fs/io_uring.c:7337
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Modules linked in:
---[ end trace f12dea0e85a314d8 ]---
RIP: 0010:file_inode include/linux/fs.h:1344 [inline]
RIP: 0010:__io_file_supports_nowait+0x26/0x500 fs/io_uring.c:2785
Code: 00 00 00 00 41 55 41 54 41 89 f4 55 48 89 fd 53 e8 6f 61 96 ff 48 8d 7d 20 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 2d 04 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b
RSP: 0018:ffffc9000305f800 EFLAGS: 00010212
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff81dfb791 RDI: 0000000000000020
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81e28292 R11: 0000000000000001 R12: 0000000000000000
R13: ffffc9000305f8d8 R14: 0000000000000000 R15: 0000000000000001
FS:  00007fa1a4652700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7e4803c008 CR3: 0000000027153000 CR4: 0000000000350ee0
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

