Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1B93541C8
	for <lists+io-uring@lfdr.de>; Mon,  5 Apr 2021 13:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbhDELot (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Apr 2021 07:44:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233775AbhDELot (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 5 Apr 2021 07:44:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE2A6613AE;
        Mon,  5 Apr 2021 11:44:40 +0000 (UTC)
Date:   Mon, 5 Apr 2021 13:44:37 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <20210405114437.hjcojekyp5zt6huu@wittgenstein>
References: <20210401175919.jpiylhfrlb4xb67u@wittgenstein>
 <YGYa0B4gabEYi2Tx@zeniv-ca.linux.org.uk>
 <YGkloJhMFc4hEatk@zeniv-ca.linux.org.uk>
 <20210404113445.xo6ntgfpxigcb3x6@wittgenstein>
 <YGnhkoTfVfMSMPpK@zeniv-ca.linux.org.uk>
 <20210404164040.vtxdcfzgliuzghwk@wittgenstein>
 <YGns1iPBHeeMAtn8@zeniv-ca.linux.org.uk>
 <20210404170513.mfl5liccdaxjnpls@wittgenstein>
 <YGoKYktYPA86Qwju@zeniv-ca.linux.org.uk>
 <YGoe0VPs/Qmz/RxC@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YGoe0VPs/Qmz/RxC@zeniv-ca.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Apr 04, 2021 at 08:17:21PM +0000, Al Viro wrote:
> On Sun, Apr 04, 2021 at 06:50:10PM +0000, Al Viro wrote:
> 
> > > Yeah, I have at least namei.o
> > > 
> > > https://drive.google.com/file/d/1AvO1St0YltIrA86DXjp1Xg3ojtS9owGh/view?usp=sharing
> > 
> > *grumble*
> > 
> > Is it reproducible without KASAN?  Would be much easier to follow the produced
> > asm...
> 
> 	Looks like inode_permission(_, NULL, _) from may_lookup(nd).  I.e.
> nd->inode == NULL.

Yeah, I already saw that.

> 
> 	Mind slapping BUG_ON(!nd->inode) right before may_lookup() call in
> link_path_walk() and trying to reproduce that oops?

Yep, no problem. If you run the reproducer in a loop for a little while
you eventually trigger the BUG_ON() and then you get the following splat
(and then an endless loop) in [1] with nd->inode NULL.

_But_ I managed to debug this further and was able to trigger the BUG_ON()
directly in path_init() in the AT_FDCWD branch (after all its AT_FDCWD(./file0)
with the patch in [3] (it's in LOOKUP_RCU) the corresponding splat is in [2].
So the crash happens for a PF_IO_WORKER thread with a NULL nd->inode for the
PF_IO_WORKER's pwd (The PF_IO_WORKER seems to be in async context.).

[3]:
diff --git a/fs/namei.c b/fs/namei.c
index 28a70diff --git a/fs/namei.c b/fs/namei.c
index 28a7006bdb04..8a31ccb61c45 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2336,8 +2336,8 @@ static const char *path_init(struct nameidata *nd, unsigned flags)

        /* Relative pathname -- get the starting-point it is relative to. */
        if (nd->dfd == AT_FDCWD) {
+               struct fs_struct *fs = current->fs;
                if (flags & LOOKUP_RCU) {
-                       struct fs_struct *fs = current->fs;
                        unsigned seq;

                        do {
@@ -2347,9 +2347,14 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
                                nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
                        } while (read_seqcount_retry(&fs->seq, seq));
                } else {
-                       get_fs_pwd(current->fs, &nd->path);
+                       get_fs_pwd(fs, &nd->path);
                        nd->inode = nd->path.dentry->d_inode;
                }
+
+               BUG_ON(!fs->users);
+               BUG_ON(fs->users < 0);
+               BUG_ON(!nd->inode && (current->flags & PF_IO_WORKER));
+               BUG_ON(!nd->inode);
        } else {
                /* Caller must check execute permissions on the starting path component */
                struct fd f = fdget_raw(nd->dfd);

[1]:
[  257.564526] ------------[ cut here ]------------
[  257.564549] kernel BUG at fs/namei.c:2208!
[  257.564998] ------------[ cut here ]------------
[  257.565773] kernel BUG at fs/namei.c:2208!
[  257.567632] invalid opcode: 0000 [#1] PREEMPT SMP KASAN
[  257.569113] CPU: 3 PID: 6086 Comm: uring_viro Tainted: G        W   E     5.12.0-rc5-b47394a22e3dce3d03165e48ef0462f41c198ac7 #47
[  257.572028] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)/LXD, BIOS 0.0.0 02/06/2015
[  257.573687] RIP: 0010:link_path_walk.part.0+0x6c9/0xd30
[  257.575008] Code: 00 48 8b 43 18 48 89 44 24 18 48 8b 44 24 38 80 38 00 0f 85 b1 04 00 00 49 8b 6e 30 48 85 ed 0f 85 82 fb ff ff e8 67 35 a8 ff <0f> 0b e8 60 35 a8 ff 49 83 c7 01 48 bf 00 00 00 00 00 fc ff df 4c
[  257.580853] RSP: 0018:ffffc900052af5c0 EFLAGS: 00010246
[  257.582513] RAX: 0000000000000000 RBX: ffff88802f7b2da0 RCX: ffffffff8ecd175c
[  257.584211] RDX: 0000000000000000 RSI: ffff8880133a0000 RDI: 0000000000000002
[  257.585985] RBP: 0000000000000000 R08: 0000000000000001 R09: fffffbfff388f13e
[  257.588061] R10: ffff8880322e0353 R11: fffffbfff388f13d R12: ffffc900052af820
[  257.590059] R13: ffff8880133a0000 R14: ffffc900052af820 R15: ffff888031149120
[  257.592605] FS:  00007f445b331800(0000) GS:ffff888015b80000(0000) knlGS:0000000000000000
[  257.595266] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  257.597262] CR2: 00005578c2c17008 CR3: 00000000307a4000 CR4: 0000000000350ee0
[  257.599546] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  257.601331] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  257.602938] Call Trace:
[  257.603764]  ? write_comp_data+0x2a/0x90
[  257.605637]  ? __sanitizer_cov_trace_pc+0x1d/0x50
[  257.607107]  ? path_init+0x662/0x1800
[  257.608713]  ? walk_component+0x6a0/0x6a0
[  257.610125]  path_openat+0x269/0x2790
[  257.611601]  ? path_lookupat.isra.0+0x530/0x530
[  257.613180]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  257.614586]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[  257.615898]  do_filp_open+0x197/0x270
[  257.616881]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  257.618293]  ? may_open_dev+0xf0/0xf0
[  257.619700]  ? do_raw_spin_lock+0x125/0x2e0
[  257.621159]  ? write_comp_data+0x2a/0x90
[  257.622574]  ? __sanitizer_cov_trace_pc+0x1d/0x50
[  257.624271]  ? _raw_spin_unlock+0x29/0x40
[  257.625737]  ? alloc_fd+0x499/0x640
[  257.627075]  io_openat2+0x1d1/0x8f0
[  257.628458]  ? io_req_complete_post+0xa90/0xa90
[  257.629921]  ? __lock_acquire+0x1847/0x5850
[  257.631108]  ? write_comp_data+0x2a/0x90
[  257.632069]  io_issue_sqe+0x2a2/0x5ac0
[  257.633112]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[  257.634534]  ? io_poll_complete.constprop.0+0x100/0x100
[  257.636129]  ? rcu_read_lock_sched_held+0xa1/0xd0
[  257.647374]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  257.656776]  ? find_held_lock+0x2d/0x110
[  257.665481]  ? __might_fault+0xd8/0x180
[  257.674198]  __io_queue_sqe+0x19f/0xcf0
[  257.688028]  ? __check_object_size+0x1b4/0x4e0
[  257.696724]  ? __ia32_sys_io_uring_setup+0x70/0x70
[  257.705177]  ? write_comp_data+0x2a/0x90
[  257.713125]  io_queue_sqe+0x612/0xb70
[  257.720757]  io_submit_sqes+0x517d/0x6650
[  257.733042]  ? __x64_sys_io_uring_enter+0xb15/0xdd0
[  257.741308]  __x64_sys_io_uring_enter+0xb15/0xdd0
[  257.748782]  ? __ia32_sys_io_uring_enter+0xdd0/0xdd0
[  257.756094]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  257.764428]  ? syscall_enter_from_user_mode+0x27/0x70
[  257.773331]  do_syscall_64+0x2d/0x70
[  257.780447]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  257.787936] RIP: 0033:0x7f445b44767d
[  257.795186] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d bb f7 0c 00 f7 d8 64 89 01 48
[  257.816184] RSP: 002b:00005578c0f91e98 EFLAGS: 00000212 ORIG_RAX: 00000000000001aa
[  257.824286] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f445b44767d
[  257.832553] RDX: 0000000000000000 RSI: 00000000000045f5 RDI: 0000000000000003
[  257.844189] RBP: 00005578c0f91f70 R08: 0000000000000000 R09: 0000000000000000
[  257.853290] R10: 0000000000000000 R11: 0000000000000212 R12: 00005578c0e64640
[  257.861454] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  257.874753] Modules linked in: efi_pstore(E) efivarfs(E)
[  257.883235] invalid opcode: 0000 [#2] PREEMPT SMP KASAN
[  257.891763] ---[ end trace a40a2f46a1222bc8 ]---

[2]:
[  228.106433] ------------[ cut here ]------------
[  228.106449] kernel BUG at fs/namei.c:2356!
[  228.106596] ------------[ cut here ]------------
[  228.109523] invalid opcode: 0000 [#1] PREEMPT SMP KASAN
[  228.110025] kernel BUG at fs/namei.c:2357!
[  228.111226] CPU: 1 PID: 6052 Comm: iou-wrk-6049 Tainted: G        W   E     5.12.0-rc5-cc402ba42485f28e932348e7627433eb1dccef5c #51
[  228.115791] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)/LXD, BIOS 0.0.0 02/06/2015
[  228.118150] RIP: 0010:path_init+0x141c/0x1730
[  228.119523] Code: fb ff ff 48 c7 c7 00 47 c1 91 e8 4f c9 f0 ff e9 b5 ed ff ff 48 c7 c7 40 46 c1 91 e8 3e c9 f0 ff e9 5b ee ff ff e8 b4 78 a8 ff <0f> 0b 48 8b bd 60 ff ff ff e8 26 c9 f0 ff e9 52 f5 ff ff e8 1c c9
[  228.124889] RSP: 0018:ffffc90004d8f6c0 EFLAGS: 00010246
[  228.126702] RAX: 0000000000000000 RBX: 0000000000000010 RCX: ffffffff884cd98c
[  228.129228] RDX: 0000000000000000 RSI: ffff8880007a9d00 RDI: 0000000000000002
[  228.131765] RBP: ffffc90004d8f760 R08: 0000000000000001 R09: ffffed10026e1ba2
[  228.133962] R10: ffff88801370dd0b R11: ffffed10026e1ba1 R12: ffff88801370dd08
[  228.135843] R13: ffff88801370dd00 R14: ffffc90004d8f8e0 R15: 0000000000000001
[  228.137812] FS:  00007fd5db164800(0000) GS:ffff888015a80000(0000) knlGS:0000000000000000
[  228.140069] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  228.141894] CR2: 00007fe892801000 CR3: 0000000036041000 CR4: 0000000000350ee0
[  228.144485] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  228.146914] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  228.149326] Call Trace:
[  228.150372]  ? write_comp_data+0x2a/0x90
[  228.151870]  ? percpu_counter_add_batch+0xbc/0x180
[  228.153667]  path_openat+0x192/0x2790
[  228.155038]  ? path_lookupat.isra.0+0x530/0x530
[  228.156573]  ? ret_from_fork+0x1f/0x30
[  228.157757]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[  228.159136]  do_filp_open+0x208/0x270
[  228.160252]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  228.161598]  ? may_open_dev+0xf0/0xf0
[  228.162653]  ? do_raw_spin_lock+0x125/0x2e0
[  228.163856]  ? write_comp_data+0x2a/0x90
[  228.165213]  ? __sanitizer_cov_trace_pc+0x1d/0x50
[  228.166782]  ? _raw_spin_unlock+0x29/0x40
[  228.168176]  ? alloc_fd+0x499/0x640
[  228.169402]  io_openat2+0x1d1/0x8f0
[  228.170607]  ? __lock_acquire+0x1847/0x5850
[  228.172381]  ? io_req_complete_post+0xa90/0xa90
[  228.174218]  ? write_comp_data+0x2a/0x90
[  228.175843]  ? io_issue_sqe+0x5ac0/0x5ac0
[  228.177600]  io_issue_sqe+0x2a2/0x5ac0
[  228.179183]  ? io_poll_complete.constprop.0+0x100/0x100
[  228.180821]  ? find_held_lock+0x2d/0x110
[  228.181963]  ? io_worker_handle_work+0x55d/0x13b0
[  228.183154]  ? lock_downgrade+0x690/0x690
[  228.192463]  ? rwlock_bug.part.0+0x90/0x90
[  228.202181]  ? io_issue_sqe+0x5ac0/0x5ac0
[  228.211962]  io_wq_submit_work+0x1da/0x640
[  228.227152]  ? io_issue_sqe+0x5ac0/0x5ac0
[  228.236852]  io_worker_handle_work+0x70a/0x13b0
[  228.246583]  ? rwlock_bug.part.0+0x90/0x90
[  228.256009]  io_wqe_worker+0x2ec/0xd00
[  228.264954]  ? io_worker_handle_work+0x13b0/0x13b0
[  228.274045]  ? ret_from_fork+0x8/0x30
[  228.288365]  ? lock_downgrade+0x690/0x690
[  228.297032]  ? do_raw_spin_lock+0x125/0x2e0
[  228.305457]  ? rwlock_bug.part.0+0x90/0x90
[  228.313717]  ? write_comp_data+0x2a/0x90
[  228.321685]  ? _raw_spin_unlock_irq+0x24/0x50
[  228.329596]  ? io_worker_handle_work+0x13b0/0x13b0
[  228.343015]  ret_from_fork+0x1f/0x30
[  228.351033] Modules linked in: efi_pstore(E) efivarfs(E)
[  228.359699] invalid opcode: 0000 [#2] PREEMPT SMP KASAN
[  228.370439] CPU: 3 PID: 6049 Comm: uring_viro Tainted: G      D W   E     5.12.0-rc5-cc402ba42485f28e932348e7627433eb1dccef5c #51
[  228.394578] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)/LXD, BIOS 0.0.0 02/06/2015
[  228.396859] ---[ end trace 5ac6a4c645048000 ]---
