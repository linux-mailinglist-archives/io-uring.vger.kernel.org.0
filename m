Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5379035450E
	for <lists+io-uring@lfdr.de>; Mon,  5 Apr 2021 18:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242381AbhDEQTS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Apr 2021 12:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242354AbhDEQTN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Apr 2021 12:19:13 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499B0C061756;
        Mon,  5 Apr 2021 09:19:07 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lTRwI-002mLy-UI; Mon, 05 Apr 2021 16:18:59 +0000
Date:   Mon, 5 Apr 2021 16:18:58 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <YGs4clcRhyoXX8D0@zeniv-ca.linux.org.uk>
References: <YGYa0B4gabEYi2Tx@zeniv-ca.linux.org.uk>
 <YGkloJhMFc4hEatk@zeniv-ca.linux.org.uk>
 <20210404113445.xo6ntgfpxigcb3x6@wittgenstein>
 <YGnhkoTfVfMSMPpK@zeniv-ca.linux.org.uk>
 <20210404164040.vtxdcfzgliuzghwk@wittgenstein>
 <YGns1iPBHeeMAtn8@zeniv-ca.linux.org.uk>
 <20210404170513.mfl5liccdaxjnpls@wittgenstein>
 <YGoKYktYPA86Qwju@zeniv-ca.linux.org.uk>
 <YGoe0VPs/Qmz/RxC@zeniv-ca.linux.org.uk>
 <20210405114437.hjcojekyp5zt6huu@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405114437.hjcojekyp5zt6huu@wittgenstein>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 05, 2021 at 01:44:37PM +0200, Christian Brauner wrote:
> On Sun, Apr 04, 2021 at 08:17:21PM +0000, Al Viro wrote:
> > On Sun, Apr 04, 2021 at 06:50:10PM +0000, Al Viro wrote:
> > 
> > > > Yeah, I have at least namei.o
> > > > 
> > > > https://drive.google.com/file/d/1AvO1St0YltIrA86DXjp1Xg3ojtS9owGh/view?usp=sharing
> > > 
> > > *grumble*
> > > 
> > > Is it reproducible without KASAN?  Would be much easier to follow the produced
> > > asm...
> > 
> > 	Looks like inode_permission(_, NULL, _) from may_lookup(nd).  I.e.
> > nd->inode == NULL.
> 
> Yeah, I already saw that.
> 
> > 
> > 	Mind slapping BUG_ON(!nd->inode) right before may_lookup() call in
> > link_path_walk() and trying to reproduce that oops?
> 
> Yep, no problem. If you run the reproducer in a loop for a little while
> you eventually trigger the BUG_ON() and then you get the following splat
> (and then an endless loop) in [1] with nd->inode NULL.
> 
> _But_ I managed to debug this further and was able to trigger the BUG_ON()
> directly in path_init() in the AT_FDCWD branch (after all its AT_FDCWD(./file0)
> with the patch in [3] (it's in LOOKUP_RCU) the corresponding splat is in [2].
> So the crash happens for a PF_IO_WORKER thread with a NULL nd->inode for the
> PF_IO_WORKER's pwd (The PF_IO_WORKER seems to be in async context.).

So we find current->fs->pwd.dentry negative, with current->fs->seq sampled
equal before and after that?  Lovely...  The only places where we assign
anything to ->pwd.dentry are
void set_fs_pwd(struct fs_struct *fs, const struct path *path)
{
        struct path old_pwd; 

        path_get(path);
        spin_lock(&fs->lock);
        write_seqcount_begin(&fs->seq);
        old_pwd = fs->pwd;
        fs->pwd = *path;
        write_seqcount_end(&fs->seq);
        spin_unlock(&fs->lock);

        if (old_pwd.dentry)
                path_put(&old_pwd);
}
where we have ->seq bumped between dget new/assignment/ dput old,
copy_fs_struct() where we have
                spin_lock(&old->lock);
                fs->root = old->root;
                path_get(&fs->root);
                fs->pwd = old->pwd;
                path_get(&fs->pwd);
                spin_unlock(&old->lock);
fs being freshly allocated instance that couldn't have been observed
by anyone and chroot_fs_refs(), where we have
                        spin_lock(&fs->lock);
                        write_seqcount_begin(&fs->seq);
                        hits += replace_path(&fs->root, old_root, new_root);
                        hits += replace_path(&fs->pwd, old_root, new_root);
                        write_seqcount_end(&fs->seq);
                        while (hits--) {
                                count++;
                                path_get(new_root);
                        }
                        spin_unlock(&fs->lock);
...
static inline int replace_path(struct path *p, const struct path *old, const struct path *new)
{
        if (likely(p->dentry != old->dentry || p->mnt != old->mnt))
                return 0;
        *p = *new;
        return 1;
}
Here we have new_root->dentry pinned from the very beginning,
and assignments are wrapped into bumps of ->seq.  Moreover,
we are holding ->lock through that sequence (as all writers
do), so these references can't be dropped before path_get()
bumps new_root->dentry refcount.

chroot_fs_refs() is called only by pivot_root(2):
        chroot_fs_refs(&root, &new);
and there new is set by
        error = user_path_at(AT_FDCWD, new_root,
                             LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &new);
        if (error)
                goto out0;
which pins new.dentry *and* verifies that it's positive and a directory,
at that.  Since pinned positive dentry can't be made negative by anybody
else, we know it will remain in that state until
	path_put(&new);
well downstream of chroot_fs_refs().  In copy_fs_struct() we are
copying someone's ->pwd, so it's also pinned positive.  And it
won't be dropped outside of old->lock, so by the time somebody
manages to drop the reference in old, path_get() effects will be
visible (old->lock serving as a barrier).

That leaves set_fs_pwd() calls:
fs/init.c:54:           set_fs_pwd(current->fs, &path);
	init_chdir(), path set by LOOKUP_DIRECTORY patwalk.  Pinned positive.
fs/namespace.c:4207:    set_fs_pwd(current->fs, &root);
	init_mount_tree(), root.dentry being ->mnt_root of rootfs.  Pinned
positive (and it would've oopsed much earlier had that been it)
fs/namespace.c:4485:    set_fs_pwd(fs, &root);
	mntns_install(), root filled by successful LOOKUP_DOWN for "/"
from mnt_ns->root.  Should be pinned positive.
fs/open.c:501:  set_fs_pwd(current->fs, &path);
	chdir(2), path set by LOOKUP_DIRECTORY pathwalk.  Pinned positive.
fs/open.c:528:          set_fs_pwd(current->fs, &f.file->f_path);
	fchdir(2), file->f_path of any opened file.  Pinned positive.
kernel/usermode_driver.c:130:   set_fs_pwd(current->fs, &umd_info->wd);
	umd_setup(), ->wd.dentry equal to ->wd.mnt->mnt_root, should be pinned positive.
kernel/nsproxy.c:509:           set_fs_pwd(me->fs, &nsset->fs->pwd);
	commit_nsset().  Let's see what's going on there...

        if ((flags & CLONE_NEWNS) && (flags & ~CLONE_NEWNS)) {
                set_fs_root(me->fs, &nsset->fs->root);
                set_fs_pwd(me->fs, &nsset->fs->pwd);
        }
In those conditions nsset.fs has come from copy_fs_struct() done in
prepare_nsset().  And the only thing that might've been done to it
would be those set_fs_pwd() in mntns_install() (I'm not fond of the
entire nsset->fs thing - looks like papering over bad calling
conventions, but anyway)

Now, I might've missed some insanity (direct assignments to ->pwd.dentry,
etc. - wouldn't be the first time io_uring folks went "layering? wassat?
we'll just poke in whatever we can reach"), but I don't see anything
obvious of that sort in the area...

OK, how about this: in path_init(), right after
                        do {
                                seq = read_seqcount_begin(&fs->seq);
                                nd->path = fs->pwd;
                                nd->inode = nd->path.dentry->d_inode;
                                nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
                        } while (read_seqcount_retry(&fs->seq, seq));
slap
			if (!nd->inode) {
				// should never, ever happen
				struct dentry *fucked = nd->path.dentry;
				printk(KERN_ERR "%pd4 %d %x %p %d %d", fucked, d_count(fucked),
							fucked->d_flags, fs, fs->users, seq);
				BUG_ON(1);
				return ERR_PTR(-EINVAL);
			}
and see what it catches?
