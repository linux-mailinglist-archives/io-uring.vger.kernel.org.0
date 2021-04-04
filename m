Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19BE3538DF
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 18:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhDDQku (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 12:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229861AbhDDQku (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 4 Apr 2021 12:40:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DA3B610CF;
        Sun,  4 Apr 2021 16:40:43 +0000 (UTC)
Date:   Sun, 4 Apr 2021 18:40:40 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <20210404164040.vtxdcfzgliuzghwk@wittgenstein>
References: <0000000000003a565e05bee596f2@google.com>
 <20210401154515.k24qdd2lzhtneu47@wittgenstein>
 <90e7e339-eaec-adb2-cfed-6dc058a117a3@kernel.dk>
 <20210401174613.vymhhrfsemypougv@wittgenstein>
 <20210401175919.jpiylhfrlb4xb67u@wittgenstein>
 <YGYa0B4gabEYi2Tx@zeniv-ca.linux.org.uk>
 <YGkloJhMFc4hEatk@zeniv-ca.linux.org.uk>
 <20210404113445.xo6ntgfpxigcb3x6@wittgenstein>
 <YGnhkoTfVfMSMPpK@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YGnhkoTfVfMSMPpK@zeniv-ca.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Apr 04, 2021 at 03:56:02PM +0000, Al Viro wrote:
> On Sun, Apr 04, 2021 at 01:34:45PM +0200, Christian Brauner wrote:
> 
> > Sorry for not replying to your earlier mail but I've been debugging this
> > too. My current theory is that it's related to LOOKUP_ROOT_GRABBED when
> > LOOKUP_CACHED is specified _possibly_ with an interaction how
> > create_io_thread() is created with CLONE_FS. The reproducer requires you
> > either have called pivot_root() or chroot() in order for the failure to
> > happen. So I think the fact that we skip legitimize_root() when
> > LOOKUP_CACHED is set might figure into this. I can keep digging.
> > 
> 
> > Funny enough I already placed a printk statement into the place you
> > wanted one too so I just amended mine. Here's what you get:
> > 
> > If pivot pivot_root() is used before the chroot() you get:
> > 
> > [  637.464555] AAAA: count(-1) | mnt_mntpoint(/) | mnt->mnt.mnt_root(/) | id(579) | dev(tmpfs)
> > 
> > if you only call chroot, i.e. make the pivot_root() branch a simple
> > if (true) you get:
> > 
> > [  955.206117] AAAA: count(-2) | mnt_mntpoint(/) | mnt->mnt.mnt_root(/) | id(580) | dev(tmpfs)
> 
> Very interesting.  What happens if you call loop() twice?  And now I wonder
> whether it's root or cwd, actually...  Hmm...
> 
> How about this:
> 	fd = open("/proc/self/mountinfo", 0);
> 	mkdir("./newroot/foo", 0777);
> 	mount("./newroot/foo", "./newroot/foo", 0, MS_BIND, NULL);
> 	chroot("./newroot");
> 	chdir("/foo");
> 	while (1) {
> 		static char buf[4096];
> 		int n = read(fd, buf, 4096);
> 		if (n <= 0)
> 			break;
> 		write(1, buf, n);
> 	}
> 	close(fd);
> 	drop_caps();
> 	loop();
> as the end of namespace_sandbox_proc(), instead of
> 	chroot("./newroot");
> 	chdir("/");
> 	drop_caps();
> 	loop();
> sequence we have there?

Uhum, well then we oops properly with a null-deref.

f1-vm login: [  395.046971][ T5856] general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
[  395.049716][ T5856] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[  395.052847][ T5856] CPU: 1 PID: 5856 Comm: iou-wrk-5851 Tainted: G            E     5.12.0-rc5-020f68e042a19f59784f0962004d848181d13b9e #46
[  395.056594][ T5856] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)/LXD, BIOS 0.0.0 02/06/2015
[  395.058962][ T5856] RIP: 0010:inode_permission+0x4e/0x530
[  395.060362][ T5856] Code: ff 89 de e8 34 42 a9 ff 85 db 0f 85 ef 00 00 00 e8 87 40 a9 ff 4c 8d 7d 02 48 b8 00 00 00 00 00 fc ff df 4c 89 fa 48 c1 ea 03 <0f> b6 14 02 4c 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 c2
[  395.065442][ T5856] RSP: 0018:ffffc9000681f640 EFLAGS: 00010246
[  395.067274][ T5856] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff84ac11fc
[  395.069834][ T5856] RDX: 0000000000000000 RSI: ffff888013210000 RDI: 0000000000000002
[  395.072527][ T5856] RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed1000044f22
[  395.075287][ T5856] R10: ffff888031c105d3 R11: ffffed1000044f21 R12: ffffc9000681f8e0
[  395.077026][ T5856] R13: 0000000000000001 R14: ffffffff8e441e60 R15: 0000000000000002
[  395.079001][ T5856] FS:  00007f136886f800(0000) GS:ffff888015a80000(0000) knlGS:0000000000000000
[  395.081181][ T5856] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  395.082659][ T5856] CR2: 000055ecfefe8e70 CR3: 00000000236b7000 CR4: 0000000000350ee0
[  395.084727][ T5856] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  395.087117][ T5856] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  395.089613][ T5856] Call Trace:
[  395.090570][ T5856]  link_path_walk.part.0+0x790/0xc10
[  395.091735][ T5856]  ? write_comp_data+0x2a/0x90
[  395.092931][ T5856]  ? __sanitizer_cov_trace_pc+0x1d/0x50
[  395.094093][ T5856]  ? walk_component+0x6a0/0x6a0
[  395.095021][ T5856]  ? percpu_counter_add_batch+0xbc/0x180
[  395.096255][ T5856]  path_openat+0x269/0x2790
[  395.097305][ T5856]  ? path_lookupat.isra.0+0x530/0x530
[  395.098391][ T5856]  ? ret_from_fork+0x1f/0x30
[  395.099431][ T5856]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[  395.101326][ T5856]  do_filp_open+0x208/0x270
[  395.102894][ T5856]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  395.104525][ T5856]  ? may_open_dev+0xf0/0xf0
[  395.105968][ T5856]  ? do_raw_spin_lock+0x125/0x2e0
[  395.107426][ T5856]  ? write_comp_data+0x2a/0x90
[  395.108651][ T5856]  ? __sanitizer_cov_trace_pc+0x1d/0x50
[  395.110033][ T5856]  ? _raw_spin_unlock+0x29/0x40
[  395.111397][ T5856]  ? alloc_fd+0x499/0x640
[  395.112783][ T5856]  io_openat2+0x1d1/0x8f0
[  395.114237][ T5856]  ? __lock_acquire+0x1847/0x5850
[  395.115982][ T5856]  ? io_req_complete_post+0xa90/0xa90
[  395.117347][ T5856]  ? write_comp_data+0x2a/0x90
[  395.118428][ T5856]  ? io_issue_sqe+0x5ac0/0x5ac0
[  395.119497][ T5856]  io_issue_sqe+0x2a2/0x5ac0
[  395.120707][ T5856]  ? io_poll_complete.constprop.0+0x100/0x100
[  395.130417][ T5856]  ? find_held_lock+0x2d/0x110
[  395.139772][ T5856]  ? io_worker_handle_work+0x55d/0x13b0
[  395.149051][ T5856]  ? lock_downgrade+0x690/0x690
[  395.158262][ T5856]  ? rwlock_bug.part.0+0x90/0x90
[  395.171997][ T5856]  ? io_issue_sqe+0x5ac0/0x5ac0
[  395.180513][ T5856]  io_wq_submit_work+0x1da/0x640
[  395.193646][ T5856]  ? io_issue_sqe+0x5ac0/0x5ac0
[  395.202240][ T5856]  io_worker_handle_work+0x70a/0x13b0
[  395.210276][ T5856]  ? rwlock_bug.part.0+0x90/0x90
[  395.218389][ T5856]  io_wqe_worker+0x2ec/0xd00
[  395.226152][ T5856]  ? io_worker_handle_work+0x13b0/0x13b0
[  395.238492][ T5856]  ? ret_from_fork+0x8/0x30
[  395.245595][ T5856]  ? lock_downgrade+0x690/0x690
[  395.252630][ T5856]  ? do_raw_spin_lock+0x125/0x2e0
[  395.259801][ T5856]  ? rwlock_bug.part.0+0x90/0x90
[  395.271613][ T5856]  ? write_comp_data+0x2a/0x90
[  395.279000][ T5856]  ? _raw_spin_unlock_irq+0x24/0x50
[  395.285999][ T5856]  ? io_worker_handle_work+0x13b0/0x13b0
[  395.297727][ T5856]  ret_from_fork+0x1f/0x30
[  395.304546][ T5856] Modules linked in: efi_pstore(E) efivarfs(E)
[  395.311931][ T5851] general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#2] PREEMPT SMP KASAN
[  395.313449][ T5856] ---[ end trace e9d61a560dd12328 ]---
