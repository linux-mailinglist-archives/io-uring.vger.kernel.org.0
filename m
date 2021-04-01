Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA22B351CA1
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbhDASTB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239646AbhDASQo (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 1 Apr 2021 14:16:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 534F5610E6;
        Thu,  1 Apr 2021 15:45:18 +0000 (UTC)
Date:   Thu, 1 Apr 2021 17:45:15 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        axboe@kernel.dk
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <20210401154515.k24qdd2lzhtneu47@wittgenstein>
References: <0000000000003a565e05bee596f2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0000000000003a565e05bee596f2@google.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 01, 2021 at 02:09:20AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d19cc4bf Merge tag 'trace-v5.12-rc5' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1018f281d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d1a3d65a48dbd1bc
> dashboard link: https://syzkaller.appspot.com/bug?extid=c88a7030da47945a3cc3
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f50d11d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=137694a1d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 8409 at fs/namespace.c:1186 mntput_no_expire+0xaca/0xcb0 fs/namespace.c:1186
> Modules linked in:
> CPU: 1 PID: 8409 Comm: syz-executor035 Not tainted 5.12.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:mntput_no_expire+0xaca/0xcb0 fs/namespace.c:1186
> Code: ff 48 c7 c2 e0 cb 78 89 be c2 02 00 00 48 c7 c7 a0 cb 78 89 c6 05 e5 6d e5 0b 01 e8 ff e1 f6 06 e9 3f fd ff ff e8 c6 a5 a8 ff <0f> 0b e9 fc fc ff ff e8 ba a5 a8 ff e8 55 dc 94 ff 31 ff 89 c5 89
> RSP: 0018:ffffc9000165fc78 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 1ffff920002cbf95 RCX: 0000000000000000
> RDX: ffff88802072d4c0 RSI: ffffffff81cb4b8a RDI: 0000000000000003
> RBP: ffff888011656900 R08: 0000000000000000 R09: ffffffff8fa978af
> R10: ffffffff81cb4884 R11: 0000000000000000 R12: 0000000000000008
> R13: ffffc9000165fcc8 R14: dffffc0000000000 R15: 00000000ffffffff
> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055a722053160 CR3: 000000000bc8e000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  mntput fs/namespace.c:1232 [inline]
>  cleanup_mnt+0x523/0x530 fs/namespace.c:1132
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:140
>  exit_task_work include/linux/task_work.h:30 [inline]
>  do_exit+0xbfc/0x2a60 kernel/exit.c:825
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  __do_sys_exit_group kernel/exit.c:933 [inline]
>  __se_sys_exit_group kernel/exit.c:931 [inline]
>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x446af9
> Code: Unable to access opcode bytes at RIP 0x446acf.
> RSP: 002b:00000000005dfe48 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00000000004ce450 RCX: 0000000000446af9
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
> RBP: 0000000000000001 R08: ffffffffffffffbc R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004ce450
> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001

[+Cc Jens + io_uring]

Hm, this reproducer uses io_uring and it's the io_uring_enter() that
triggers this reliably. With this reproducer I've managed to reproduce
the issue on v5.12-rc4, and v5.12-rc3, v5.12-rc2 and v5.12-rc1.
It's not reproducible at
9820b4dca0f9c6b7ab8b4307286cdace171b724d
which is the commit immediately before the first v5.12 io_uring merge.
It's first reproducible with the first io_uring merge for v5.12, i.e.
5bbb336ba75d95611a7b9456355b48705016bdb1

Christian
