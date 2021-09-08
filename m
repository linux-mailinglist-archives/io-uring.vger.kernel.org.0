Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81477403DC7
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 18:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346619AbhIHQqf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 12:46:35 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53294 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349992AbhIHQqc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 12:46:32 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631119524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xK7tnDBt7Mv35ZlbOM5hzY0NbTi3hoQEG+jDHcstiBU=;
        b=Z3VvjVBqWpYprjI90RYCkIn1Ut7i7OHzPVKd+y8vxDr6xD4IBqNJy5oAbYe3DrFzvg7cQm
        iCNFjb3WSt2JKTB5wWDD683aMlqm+HouAl/mSqKIj4dtb4NEg1KJFKeiB9MKcIEbc+ACkz
        FZ+kNeeMMRp6Tf9U8M9G/PWS8lHJap/xUuWl7Mfv4NRZ+one5dcqwlaGu50luOcvAooIhD
        9k3149NL/g8Y5/Nv+jw22Q0yiyLADTbAAXEL0ui/TqbgTBWxh+SkRFERilFeZnsXsrpal9
        uzu+TayGQZCJlIe5FBCw8DVK//Os/6a8nuDxLhV7zXJGJgH0bD3QAPjb2BLpyA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631119524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xK7tnDBt7Mv35ZlbOM5hzY0NbTi3hoQEG+jDHcstiBU=;
        b=yDRBvFNBZ0NS5+a+rKB5Q0alY89xKXFQ5/iX3zJaSeYqm9x+72fYs96R+mn4yLU9JwHnz9
        J0HSq3jvgV/QCBDA==
To:     syzbot <syzbot+b935db3fe409625cca1b@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] general protection fault in hrtimer_start_range_ns
In-Reply-To: <0000000000009eeadd05cb511b60@google.com>
References: <0000000000009eeadd05cb511b60@google.com>
Date:   Wed, 08 Sep 2021 18:45:23 +0200
Message-ID: <875yvbf23g.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 06 2021 at 03:28, syzbot wrote:
> syzbot found the following issue on:
>
> HEAD commit:    835d31d319d9 Merge tag 'media/v5.15-1' of git://git.kernel..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14489886300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d793523866f2daea
> dashboard link: https://syzkaller.appspot.com/bug?extid=b935db3fe409625cca1b
> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b935db3fe409625cca1b@syzkaller.appspotmail.com
>
> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 PID: 12936 Comm: iou-sqp-12929 Not tainted 5.14.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:lock_hrtimer_base kernel/time/hrtimer.c:173 [inline]

That's almost certainly deferencing hrtimer->base and as that is NULL this looks
like a not initialized hrtimer.

Jens?

> RIP: 0010:hrtimer_start_range_ns+0xc9/0x1ae0 kernel/time/hrtimer.c:1296
> Code: 89 9c 24 88 00 00 00 42 80 3c 33 00 74 08 48 89 ef e8 7b 34 5b 00 4c 8b 6d 00 4d 39 fd 0f 84 95 00 00 00 4d 89 ef 49 c1 ef 03 <43> 80 3c 37 00 74 08 4c 89 ef e8 58 34 5b 00 49 8b 7d 00 e8 6f 19
> RSP: 0018:ffffc900097af170 EFLAGS: 00010046
> RAX: ffff888016d49508 RBX: 1ffff11002da92a7 RCX: ffff888027371c80
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
> RBP: ffff888016d49538 R08: ffffffff816fb4b5 R09: 0000000000000003
> R10: fffff520012f5e2d R11: 0000000000000004 R12: 0000000000000000
> R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
> FS:  00007f7386f28700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000002b5e4000 CR4: 00000000001526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  hrtimer_start include/linux/hrtimer.h:418 [inline]
>  io_timeout fs/io_uring.c:6120 [inline]
>  io_issue_sqe+0x53d3/0x9280 fs/io_uring.c:6590
>  __io_queue_sqe+0xe3/0x1000 fs/io_uring.c:6864
>  tctx_task_work+0x2ad/0x560 fs/io_uring.c:2143
>  task_work_run+0x146/0x1c0 kernel/task_work.c:164
>  tracehook_notify_signal include/linux/tracehook.h:212 [inline]
>  io_run_task_work+0x110/0x140 fs/io_uring.c:2403
>  io_sq_thread+0xb5e/0x1220 fs/io_uring.c:7337
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> Modules linked in:
> ---[ end trace 841fafb7511d53d3 ]---
> RIP: 0010:lock_hrtimer_base kernel/time/hrtimer.c:173 [inline]
> RIP: 0010:hrtimer_start_range_ns+0xc9/0x1ae0 kernel/time/hrtimer.c:1296
> Code: 89 9c 24 88 00 00 00 42 80 3c 33 00 74 08 48 89 ef e8 7b 34 5b 00 4c 8b 6d 00 4d 39 fd 0f 84 95 00 00 00 4d 89 ef 49 c1 ef 03 <43> 80 3c 37 00 74 08 4c 89 ef e8 58 34 5b 00 49 8b 7d 00 e8 6f 19
> RSP: 0018:ffffc900097af170 EFLAGS: 00010046
> RAX: ffff888016d49508 RBX: 1ffff11002da92a7 RCX: ffff888027371c80
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
> RBP: ffff888016d49538 R08: ffffffff816fb4b5 R09: 0000000000000003
> R10: fffff520012f5e2d R11: 0000000000000004 R12: 0000000000000000
> R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
> FS:  00007f7386f28700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000002b5e4000 CR4: 00000000001526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0:	89 9c 24 88 00 00 00 	mov    %ebx,0x88(%rsp)
>    7:	42 80 3c 33 00       	cmpb   $0x0,(%rbx,%r14,1)
>    c:	74 08                	je     0x16
>    e:	48 89 ef             	mov    %rbp,%rdi
>   11:	e8 7b 34 5b 00       	callq  0x5b3491
>   16:	4c 8b 6d 00          	mov    0x0(%rbp),%r13
>   1a:	4d 39 fd             	cmp    %r15,%r13
>   1d:	0f 84 95 00 00 00    	je     0xb8
>   23:	4d 89 ef             	mov    %r13,%r15
>   26:	49 c1 ef 03          	shr    $0x3,%r15
> * 2a:	43 80 3c 37 00       	cmpb   $0x0,(%r15,%r14,1) <-- trapping instruction
>   2f:	74 08                	je     0x39
>   31:	4c 89 ef             	mov    %r13,%rdi
>   34:	e8 58 34 5b 00       	callq  0x5b3491
>   39:	49 8b 7d 00          	mov    0x0(%r13),%rdi
>   3d:	e8                   	.byte 0xe8
>   3e:	6f                   	outsl  %ds:(%rsi),(%dx)
>   3f:	19                   	.byte 0x19
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
