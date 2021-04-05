Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7C23545CE
	for <lists+io-uring@lfdr.de>; Mon,  5 Apr 2021 19:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbhDERIN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Apr 2021 13:08:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232733AbhDERIM (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 5 Apr 2021 13:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 090AA6127A;
        Mon,  5 Apr 2021 17:08:03 +0000 (UTC)
Date:   Mon, 5 Apr 2021 19:08:01 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <20210405170801.zrdhnon6g4ggb6c7@wittgenstein>
References: <YGkloJhMFc4hEatk@zeniv-ca.linux.org.uk>
 <20210404113445.xo6ntgfpxigcb3x6@wittgenstein>
 <YGnhkoTfVfMSMPpK@zeniv-ca.linux.org.uk>
 <20210404164040.vtxdcfzgliuzghwk@wittgenstein>
 <YGns1iPBHeeMAtn8@zeniv-ca.linux.org.uk>
 <20210404170513.mfl5liccdaxjnpls@wittgenstein>
 <YGoKYktYPA86Qwju@zeniv-ca.linux.org.uk>
 <YGoe0VPs/Qmz/RxC@zeniv-ca.linux.org.uk>
 <20210405114437.hjcojekyp5zt6huu@wittgenstein>
 <YGs4clcRhyoXX8D0@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YGs4clcRhyoXX8D0@zeniv-ca.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 05, 2021 at 04:18:58PM +0000, Al Viro wrote:
> On Mon, Apr 05, 2021 at 01:44:37PM +0200, Christian Brauner wrote:
> > On Sun, Apr 04, 2021 at 08:17:21PM +0000, Al Viro wrote:
> > > On Sun, Apr 04, 2021 at 06:50:10PM +0000, Al Viro wrote:
> > > 
> > > > > Yeah, I have at least namei.o
> > > > > 
> > > > > https://drive.google.com/file/d/1AvO1St0YltIrA86DXjp1Xg3ojtS9owGh/view?usp=sharing
> > > > 
> > > > *grumble*
> > > > 
> > > > Is it reproducible without KASAN?  Would be much easier to follow the produced
> > > > asm...
> > > 
> > > 	Looks like inode_permission(_, NULL, _) from may_lookup(nd).  I.e.
> > > nd->inode == NULL.
> > 
> > Yeah, I already saw that.
> > 
> > > 
> > > 	Mind slapping BUG_ON(!nd->inode) right before may_lookup() call in
> > > link_path_walk() and trying to reproduce that oops?
> > 
> > Yep, no problem. If you run the reproducer in a loop for a little while
> > you eventually trigger the BUG_ON() and then you get the following splat
> > (and then an endless loop) in [1] with nd->inode NULL.
> > 
> > _But_ I managed to debug this further and was able to trigger the BUG_ON()
> > directly in path_init() in the AT_FDCWD branch (after all its AT_FDCWD(./file0)
> > with the patch in [3] (it's in LOOKUP_RCU) the corresponding splat is in [2].
> > So the crash happens for a PF_IO_WORKER thread with a NULL nd->inode for the
> > PF_IO_WORKER's pwd (The PF_IO_WORKER seems to be in async context.).
> 
> So we find current->fs->pwd.dentry negative, with current->fs->seq sampled
> equal before and after that?  Lovely...  The only places where we assign
> anything to ->pwd.dentry are
> void set_fs_pwd(struct fs_struct *fs, const struct path *path)
> {
>         struct path old_pwd; 
> 
>         path_get(path);
>         spin_lock(&fs->lock);
>         write_seqcount_begin(&fs->seq);
>         old_pwd = fs->pwd;
>         fs->pwd = *path;
>         write_seqcount_end(&fs->seq);
>         spin_unlock(&fs->lock);
> 
>         if (old_pwd.dentry)
>                 path_put(&old_pwd);
> }
> where we have ->seq bumped between dget new/assignment/ dput old,
> copy_fs_struct() where we have
>                 spin_lock(&old->lock);
>                 fs->root = old->root;
>                 path_get(&fs->root);
>                 fs->pwd = old->pwd;
>                 path_get(&fs->pwd);
>                 spin_unlock(&old->lock);
> fs being freshly allocated instance that couldn't have been observed
> by anyone and chroot_fs_refs(), where we have
>                         spin_lock(&fs->lock);
>                         write_seqcount_begin(&fs->seq);
>                         hits += replace_path(&fs->root, old_root, new_root);
>                         hits += replace_path(&fs->pwd, old_root, new_root);
>                         write_seqcount_end(&fs->seq);
>                         while (hits--) {
>                                 count++;
>                                 path_get(new_root);
>                         }
>                         spin_unlock(&fs->lock);
> ...
> static inline int replace_path(struct path *p, const struct path *old, const struct path *new)
> {
>         if (likely(p->dentry != old->dentry || p->mnt != old->mnt))
>                 return 0;
>         *p = *new;
>         return 1;
> }
> Here we have new_root->dentry pinned from the very beginning,
> and assignments are wrapped into bumps of ->seq.  Moreover,
> we are holding ->lock through that sequence (as all writers
> do), so these references can't be dropped before path_get()
> bumps new_root->dentry refcount.
> 
> chroot_fs_refs() is called only by pivot_root(2):
>         chroot_fs_refs(&root, &new);
> and there new is set by
>         error = user_path_at(AT_FDCWD, new_root,
>                              LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &new);
>         if (error)
>                 goto out0;
> which pins new.dentry *and* verifies that it's positive and a directory,
> at that.  Since pinned positive dentry can't be made negative by anybody
> else, we know it will remain in that state until
> 	path_put(&new);
> well downstream of chroot_fs_refs().  In copy_fs_struct() we are
> copying someone's ->pwd, so it's also pinned positive.  And it
> won't be dropped outside of old->lock, so by the time somebody
> manages to drop the reference in old, path_get() effects will be
> visible (old->lock serving as a barrier).
> 
> That leaves set_fs_pwd() calls:
> fs/init.c:54:           set_fs_pwd(current->fs, &path);
> 	init_chdir(), path set by LOOKUP_DIRECTORY patwalk.  Pinned positive.
> fs/namespace.c:4207:    set_fs_pwd(current->fs, &root);
> 	init_mount_tree(), root.dentry being ->mnt_root of rootfs.  Pinned
> positive (and it would've oopsed much earlier had that been it)
> fs/namespace.c:4485:    set_fs_pwd(fs, &root);
> 	mntns_install(), root filled by successful LOOKUP_DOWN for "/"
> from mnt_ns->root.  Should be pinned positive.
> fs/open.c:501:  set_fs_pwd(current->fs, &path);
> 	chdir(2), path set by LOOKUP_DIRECTORY pathwalk.  Pinned positive.
> fs/open.c:528:          set_fs_pwd(current->fs, &f.file->f_path);
> 	fchdir(2), file->f_path of any opened file.  Pinned positive.
> kernel/usermode_driver.c:130:   set_fs_pwd(current->fs, &umd_info->wd);
> 	umd_setup(), ->wd.dentry equal to ->wd.mnt->mnt_root, should be pinned positive.
> kernel/nsproxy.c:509:           set_fs_pwd(me->fs, &nsset->fs->pwd);
> 	commit_nsset().  Let's see what's going on there...
> 
>         if ((flags & CLONE_NEWNS) && (flags & ~CLONE_NEWNS)) {
>                 set_fs_root(me->fs, &nsset->fs->root);
>                 set_fs_pwd(me->fs, &nsset->fs->pwd);
>         }
> In those conditions nsset.fs has come from copy_fs_struct() done in
> prepare_nsset().  And the only thing that might've been done to it
> would be those set_fs_pwd() in mntns_install() (I'm not fond of the
> entire nsset->fs thing - looks like papering over bad calling
> conventions, but anyway)
> 
> Now, I might've missed some insanity (direct assignments to ->pwd.dentry,
> etc. - wouldn't be the first time io_uring folks went "layering? wassat?
> we'll just poke in whatever we can reach"), but I don't see anything
> obvious of that sort in the area...
> 
> OK, how about this: in path_init(), right after
>                         do {
>                                 seq = read_seqcount_begin(&fs->seq);
>                                 nd->path = fs->pwd;
>                                 nd->inode = nd->path.dentry->d_inode;
>                                 nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
>                         } while (read_seqcount_retry(&fs->seq, seq));
> slap
> 			if (!nd->inode) {
> 				// should never, ever happen
> 				struct dentry *fucked = nd->path.dentry;
> 				printk(KERN_ERR "%pd4 %d %x %p %d %d", fucked, d_count(fucked),
> 							fucked->d_flags, fs, fs->users, seq);
> 				BUG_ON(1);
> 				return ERR_PTR(-EINVAL);
> 			}
> and see what it catches?

Ah dentry count of -127 looks... odd.


[  246.102077] /newroot/foo -127 18008 ffff888012819000 6 0
[  246.102240] ------------[ cut here ]------------
[  246.102264] /newroot/foo -127 18008 ffff888012819000 6 6
[  246.104163] ------------[ cut here ]------------
[  246.104943] kernel BUG at fs/namei.c:2359!
[  246.106342] kernel BUG at fs/namei.c:2359!
[  246.106385] invalid opcode: 0000 [#1] PREEMPT SMP KASAN
[  246.110540] CPU: 0 PID: 6345 Comm: uring_viro Tainted: G        W   E     5.12.0-rc5-1ebc00aa82b08217d1fc4eef5435f8499783194c #53
[  246.113725] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)/LXD, BIOS 0.0.0 02/06/2015
[  246.116115] RIP: 0010:path_init.cold+0xbb/0xea
[  246.117711] Code: d0 7c 04 84 d2 75 4b 4c 8b 45 98 41 89 d9 44 89 f9 4c 89 e6 41 8b 94 24 d0 00 00 00 48 c7 c7 20 93 1a b1 41 55 e8 1c 70 fe ff <0f> 0b 48 8b 7d b8 e8 1f ee e6 f8 e9 55 ff ff ff 48 8b 7d 98 e8 01
[  246.124372] RSP: 0018:ffffc900073275f0 EFLAGS: 00010282
[  246.126466] RAX: 000000000000002c RBX: 0000000000000006 RCX: 0000000000000000
[  246.129685] RDX: 0000000000000000 RSI: ffff88801354d700 RDI: fffff52000e64eb0
[  246.131400] RBP: ffffc900073276a0 R08: 000000000000002c R09: ffffed1002b46045
[  246.133241] R10: ffff888015a30227 R11: ffffed1002b46044 R12: ffff8880303eb028
[  246.135124] R13: 0000000000000006 R14: ffffc90007327820 R15: 0000000000018008
[  246.136931] FS:  00007f8695724800(0000) GS:ffff888015a00000(0000) knlGS:0000000000000000
[  246.139247] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  246.141604] CR2: 000055fdf3c11008 CR3: 000000002e9dd000 CR4: 0000000000350ef0
[  246.143437] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  246.145337] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  246.147114] Call Trace:
[  246.147910]  ? write_comp_data+0x2a/0x90
[  246.149010]  path_openat+0x192/0x2790
[  246.150062]  ? path_lookupat.isra.0+0x530/0x530
[  246.151295]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  246.152561]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[  246.154071]  do_filp_open+0x197/0x270
[  246.155157]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  246.156392]  ? may_open_dev+0xf0/0xf0
[  246.157969]  ? do_raw_spin_lock+0x125/0x2e0
[  246.159167]  ? write_comp_data+0x2a/0x90
[  246.160319]  ? __sanitizer_cov_trace_pc+0x1d/0x50
[  246.161649]  ? _raw_spin_unlock+0x29/0x40
[  246.162823]  ? alloc_fd+0x499/0x640
[  246.164092]  io_openat2+0x1d1/0x8f0
[  246.165403]  ? io_req_complete_post+0xa90/0xa90
[  246.166974]  ? __lock_acquire+0x1847/0x5850
[  246.168455]  ? write_comp_data+0x2a/0x90
[  246.169877]  io_issue_sqe+0x2a2/0x5ac0
[  246.171226]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[  246.173079]  ? io_poll_complete.constprop.0+0x100/0x100
[  246.174960]  ? rcu_read_lock_sched_held+0xa1/0xd0
[  246.176468]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  246.187303]  ? find_held_lock+0x2d/0x110
[  246.197951]  ? __might_fault+0xd8/0x180
[  246.208458]  __io_queue_sqe+0x19f/0xcf0
[  246.218694]  ? __check_object_size+0x1b4/0x4e0
[  246.228802]  ? __ia32_sys_io_uring_setup+0x70/0x70
[  246.239099]  ? write_comp_data+0x2a/0x90
[  246.249152]  io_queue_sqe+0x612/0xb70
[  246.258967]  io_submit_sqes+0x517d/0x6650
[  246.268445]  ? __x64_sys_io_uring_enter+0xb15/0xdd0
[  246.282682]  __x64_sys_io_uring_enter+0xb15/0xdd0
[  246.292110]  ? __ia32_sys_io_uring_enter+0xdd0/0xdd0
[  246.301285]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  246.310116]  ? syscall_enter_from_user_mode+0x27/0x70
[  246.318845]  do_syscall_64+0x2d/0x70
[  246.327328]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  246.336188] RIP: 0033:0x7f869583a67d
[  246.344145] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d bb f7 0c 00 f7 d8 64 89 01 48
[  246.367649] RSP: 002b:000055fdf2a89e98 EFLAGS: 00000212 ORIG_RAX: 00000000000001aa
[  246.377100] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f869583a67d
[  246.386119] RDX: 0000000000000000 RSI: 00000000000045f5 RDI: 0000000000000003
[  246.395095] RBP: 000055fdf2a89f70 R08: 0000000000000000 R09: 0000000000000000
[  246.403925] R10: 0000000000000000 R11: 0000000000000212 R12: 000055fdf295c640
[  246.412977] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  246.425046] Modules linked in: efi_pstore(E) efivarfs(E)
[  246.434681] invalid opcode: 0000 [#2] PREEMPT SMP KASAN
[  246.435099] ---[ end trace b331351bc5a092fa ]---
