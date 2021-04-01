Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AD73518F6
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbhDARse (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235535AbhDARq0 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 1 Apr 2021 13:46:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BF6261165;
        Thu,  1 Apr 2021 17:46:17 +0000 (UTC)
Date:   Thu, 1 Apr 2021 19:46:13 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <20210401174613.vymhhrfsemypougv@wittgenstein>
References: <0000000000003a565e05bee596f2@google.com>
 <20210401154515.k24qdd2lzhtneu47@wittgenstein>
 <90e7e339-eaec-adb2-cfed-6dc058a117a3@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <90e7e339-eaec-adb2-cfed-6dc058a117a3@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 01, 2021 at 10:09:18AM -0600, Jens Axboe wrote:
> On 4/1/21 9:45 AM, Christian Brauner wrote:
> > On Thu, Apr 01, 2021 at 02:09:20AM -0700, syzbot wrote:
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit:    d19cc4bf Merge tag 'trace-v5.12-rc5' of git://git.kernel.o..
> >> git tree:       upstream
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=1018f281d00000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=d1a3d65a48dbd1bc
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=c88a7030da47945a3cc3
> >> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f50d11d00000
> >> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=137694a1d00000
> >>
> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> Reported-by: syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com
> >>
> >> ------------[ cut here ]------------
> >> WARNING: CPU: 1 PID: 8409 at fs/namespace.c:1186 mntput_no_expire+0xaca/0xcb0 fs/namespace.c:1186
> >> Modules linked in:
> >> CPU: 1 PID: 8409 Comm: syz-executor035 Not tainted 5.12.0-rc5-syzkaller #0
> >> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> >> RIP: 0010:mntput_no_expire+0xaca/0xcb0 fs/namespace.c:1186
> >> Code: ff 48 c7 c2 e0 cb 78 89 be c2 02 00 00 48 c7 c7 a0 cb 78 89 c6 05 e5 6d e5 0b 01 e8 ff e1 f6 06 e9 3f fd ff ff e8 c6 a5 a8 ff <0f> 0b e9 fc fc ff ff e8 ba a5 a8 ff e8 55 dc 94 ff 31 ff 89 c5 89
> >> RSP: 0018:ffffc9000165fc78 EFLAGS: 00010293
> >> RAX: 0000000000000000 RBX: 1ffff920002cbf95 RCX: 0000000000000000
> >> RDX: ffff88802072d4c0 RSI: ffffffff81cb4b8a RDI: 0000000000000003
> >> RBP: ffff888011656900 R08: 0000000000000000 R09: ffffffff8fa978af
> >> R10: ffffffff81cb4884 R11: 0000000000000000 R12: 0000000000000008
> >> R13: ffffc9000165fcc8 R14: dffffc0000000000 R15: 00000000ffffffff
> >> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> >> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> CR2: 000055a722053160 CR3: 000000000bc8e000 CR4: 00000000001506e0
> >> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >> Call Trace:
> >>  mntput fs/namespace.c:1232 [inline]
> >>  cleanup_mnt+0x523/0x530 fs/namespace.c:1132
> >>  task_work_run+0xdd/0x1a0 kernel/task_work.c:140
> >>  exit_task_work include/linux/task_work.h:30 [inline]
> >>  do_exit+0xbfc/0x2a60 kernel/exit.c:825
> >>  do_group_exit+0x125/0x310 kernel/exit.c:922
> >>  __do_sys_exit_group kernel/exit.c:933 [inline]
> >>  __se_sys_exit_group kernel/exit.c:931 [inline]
> >>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
> >>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >> RIP: 0033:0x446af9
> >> Code: Unable to access opcode bytes at RIP 0x446acf.
> >> RSP: 002b:00000000005dfe48 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> >> RAX: ffffffffffffffda RBX: 00000000004ce450 RCX: 0000000000446af9
> >> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
> >> RBP: 0000000000000001 R08: ffffffffffffffbc R09: 0000000000000000
> >> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004ce450
> >> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
> > 
> > [+Cc Jens + io_uring]
> > 
> > Hm, this reproducer uses io_uring and it's the io_uring_enter() that
> > triggers this reliably. With this reproducer I've managed to reproduce
> > the issue on v5.12-rc4, and v5.12-rc3, v5.12-rc2 and v5.12-rc1.
> > It's not reproducible at
> > 9820b4dca0f9c6b7ab8b4307286cdace171b724d
> > which is the commit immediately before the first v5.12 io_uring merge.
> > It's first reproducible with the first io_uring merge for v5.12, i.e.
> > 5bbb336ba75d95611a7b9456355b48705016bdb1
> 
> Thanks, that's good info. I'll take a look at it and see if I can
> reproduce.

Ok, I was deep into this anyway and it didn't make much sense to do
anything else at that point so I bisected this a bit further. The first
bad commit is:

commit 3a81fd02045c329f25e5900fa61f613c9b317644
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Dec 10 12:25:36 2020 -0700

    io_uring: enable LOOKUP_CACHED path resolution for filename lookups

    Instead of being pessimistic and assume that path lookup will block, use
    LOOKUP_CACHED to attempt just a cached lookup. This ensures that the
    fast path is always done inline, and we only punt to async context if
    IO is needed to satisfy the lookup.

    For forced nonblock open attempts, mark the file O_NONBLOCK over the
    actual ->open() call as well. We can safely clear this again before
    doing fd_install(), so it'll never be user visible that we fiddled with
    it.

    This greatly improves the performance of file open where the dentry is
    already cached:

    ached           5.10-git        5.10-git+LOOKUP_CACHED  Speedup
    ---------------------------------------------------------------
    33%             1,014,975       900,474                 1.1x
    89%              545,466        292,937                 1.9x
    100%             435,636        151,475                 2.9x

    The more cache hot we are, the faster the inline LOOKUP_CACHED
    optimization helps. This is unsurprising and expected, as a thread
    offload becomes a more dominant part of the total overhead. If we look
    at io_uring tracing, doing an IORING_OP_OPENAT on a file that isn't in
    the dentry cache will yield:

    275.550481: io_uring_create: ring 00000000ddda6278, fd 3 sq size 8, cq size 16, flags 0
    275.550491: io_uring_submit_sqe: ring 00000000ddda6278, op 18, data 0x0, non block 1, sq_thread 0
    275.550498: io_uring_queue_async_work: ring 00000000ddda6278, request 00000000c0267d17, flags 69760, normal queue, work 000000003d683991
    275.550502: io_uring_cqring_wait: ring 00000000ddda6278, min_events 1
    275.550556: io_uring_complete: ring 00000000ddda6278, user_data 0x0, result 4

    which shows a failed nonblock lookup, then punt to worker, and then we
    complete with fd == 4. This takes 65 usec in total. Re-running the same
    test case again:

    281.253956: io_uring_create: ring 0000000008207252, fd 3 sq size 8, cq size 16, flags 0
    281.253967: io_uring_submit_sqe: ring 0000000008207252, op 18, data 0x0, non block 1, sq_thread 0
    281.253973: io_uring_complete: ring 0000000008207252, user_data 0x0, result 4

    shows the same request completing inline, also returning fd == 4. This
    takes 6 usec.

    Signed-off-by: Jens Axboe <axboe@kernel.dk>
