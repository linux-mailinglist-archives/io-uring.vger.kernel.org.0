Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07BC3537DA
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 13:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhDDLe4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 07:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhDDLez (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 4 Apr 2021 07:34:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAA9361165;
        Sun,  4 Apr 2021 11:34:48 +0000 (UTC)
Date:   Sun, 4 Apr 2021 13:34:45 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <20210404113445.xo6ntgfpxigcb3x6@wittgenstein>
References: <0000000000003a565e05bee596f2@google.com>
 <20210401154515.k24qdd2lzhtneu47@wittgenstein>
 <90e7e339-eaec-adb2-cfed-6dc058a117a3@kernel.dk>
 <20210401174613.vymhhrfsemypougv@wittgenstein>
 <20210401175919.jpiylhfrlb4xb67u@wittgenstein>
 <YGYa0B4gabEYi2Tx@zeniv-ca.linux.org.uk>
 <YGkloJhMFc4hEatk@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YGkloJhMFc4hEatk@zeniv-ca.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Apr 04, 2021 at 02:34:08AM +0000, Al Viro wrote:
> On Thu, Apr 01, 2021 at 07:11:12PM +0000, Al Viro wrote:
> 
> > > I _think_ I see what the issue is. It seems that an assumption made in
> > > this commit might be wrong and we're missing a mnt_add_count() bump that
> > > we would otherwise have gotten if we've moved the failure handling into
> > > the unlazy helpers themselves.
> > > 
> > > Al, does that sound plausible?
> > 
> > mnt_add_count() on _what_?  Failure in legitimize_links() ends up with
> > nd->path.mnt zeroed, in both callers.  So which vfsmount would be
> > affected?

It looks to me like it's the vfsmount of the nd->root after we called
chroot or pivot_root.

> 
> Could you turn that WARN_ON(count < 0) into
> 	if (WARN_ON(count < 0))
> 		printk(KERN_ERR "id = %d, dev = %s, count = %d\n",
> 				mnt->mnt_id,
> 				mnt->mnt_sb->s_id,
> 				count);
> add system("cat /proc/self/mountinfo"); right after sandbox_common()
> call and try to reproduce that?

Sorry for not replying to your earlier mail but I've been debugging this
too. My current theory is that it's related to LOOKUP_ROOT_GRABBED when
LOOKUP_CACHED is specified _possibly_ with an interaction how
create_io_thread() is created with CLONE_FS. The reproducer requires you
either have called pivot_root() or chroot() in order for the failure to
happen. So I think the fact that we skip legitimize_root() when
LOOKUP_CACHED is set might figure into this. I can keep digging.

Funny enough I already placed a printk statement into the place you
wanted one too so I just amended mine. Here's what you get:

If pivot pivot_root() is used before the chroot() you get:

[  637.464555] AAAA: count(-1) | mnt_mntpoint(/) | mnt->mnt.mnt_root(/) | id(579) | dev(tmpfs)

if you only call chroot, i.e. make the pivot_root() branch a simple
if (true) you get:

[  955.206117] AAAA: count(-2) | mnt_mntpoint(/) | mnt->mnt.mnt_root(/) | id(580) | dev(tmpfs)

The cat /proc/self/mountinfo is for the id(579) below:

514 513 8:2 / / rw,relatime - ext4 /dev/sda2 rw
515 514 0:5 / /dev rw,nosuid,noexec,relatime - devtmpfs udev rw,size=302716k,nr_inodes=75679,mode=755
516 515 0:26 / /dev/pts rw,nosuid,noexec,relatime - devpts devpts rw,gid=5,mode=620,ptmxmode=000
517 515 0:28 / /dev/shm rw,nosuid,nodev - tmpfs tmpfs rw
518 515 0:48 / /dev/hugepages rw,relatime - hugetlbfs hugetlbfs rw,pagesize=2M
519 515 0:21 / /dev/mqueue rw,nosuid,nodev,noexec,relatime - mqueue mqueue rw
520 514 0:27 / /run rw,nosuid,nodev,noexec,relatime - tmpfs tmpfs rw,size=62152k,mode=755
521 520 0:29 / /run/lock rw,nosuid,nodev,noexec,relatime - tmpfs tmpfs rw,size=5120k
522 520 0:49 / /run/lxd_agent rw,relatime - tmpfs tmpfs rw,size=51200k,mode=700
523 520 0:59 / /run/user/1000 rw,nosuid,nodev,relatime - tmpfs tmpfs rw,size=62148k,nr_inodes=15537,mode=700,uid=1000,gid=1000
524 514 0:24 / /sys rw,nosuid,nodev,noexec,relatime - sysfs sysfs rw
525 524 0:6 / /sys/kernel/security rw,nosuid,nodev,noexec,relatime - securityfs securityfs rw
526 524 0:30 / /sys/fs/cgroup ro,nosuid,nodev,noexec - tmpfs tmpfs ro,size=4096k,nr_inodes=1024,mode=755
527 526 0:31 /../../.. /sys/fs/cgroup/unified rw,nosuid,nodev,noexec,relatime - cgroup2 cgroup2 rw
528 526 0:32 /../../.. /sys/fs/cgroup/systemd rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,xattr,name=systemd
529 526 0:36 /../../.. /sys/fs/cgroup/memory rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,memory
530 526 0:37 /.. /sys/fs/cgroup/cpu,cpuacct rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,cpu,cpuacct
531 526 0:38 / /sys/fs/cgroup/hugetlb rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,hugetlb
549 526 0:39 /.. /sys/fs/cgroup/blkio rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,blkio
550 526 0:40 /../../.. /sys/fs/cgroup/freezer rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,freezer
551 526 0:41 /../../.. /sys/fs/cgroup/pids rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,pids
552 526 0:42 / /sys/fs/cgroup/net_cls,net_prio rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,net_cls,net_prio
553 526 0:43 / /sys/fs/cgroup/perf_event rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,perf_event
554 526 0:44 / /sys/fs/cgroup/cpuset rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,cpuset,clone_children
555 526 0:45 /.. /sys/fs/cgroup/devices rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,devices
556 526 0:46 / /sys/fs/cgroup/rdma rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,rdma
557 524 0:33 / /sys/fs/pstore rw,nosuid,nodev,noexec,relatime - pstore pstore rw
558 524 0:34 / /sys/firmware/efi/efivars rw,nosuid,nodev,noexec,relatime - efivarfs efivarfs rw
559 524 0:35 / /sys/fs/bpf rw,nosuid,nodev,noexec,relatime - bpf none rw,mode=700
560 524 0:7 / /sys/kernel/debug rw,nosuid,nodev,noexec,relatime - debugfs debugfs rw
561 524 0:12 / /sys/kernel/tracing rw,nosuid,nodev,noexec,relatime - tracefs tracefs rw
562 524 0:51 / /sys/fs/fuse/connections rw,nosuid,nodev,noexec,relatime - fusectl fusectl rw
563 524 0:20 / /sys/kernel/config rw,nosuid,nodev,noexec,relatime - configfs configfs rw
564 514 0:25 / /proc rw,nosuid,nodev,noexec,relatime - proc proc rw
565 564 0:47 / /proc/sys/fs/binfmt_misc rw,relatime - autofs systemd-1 rw,fd=29,pgrp=0,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=31453
566 565 0:52 / /proc/sys/fs/binfmt_misc rw,nosuid,nodev,noexec,relatime - binfmt_misc binfmt_misc rw
567 514 0:50 / /home/ubuntu/src/compiled rw,relatime - virtiofs lxd_lxc rw
568 514 8:1 / /boot/efi rw,relatime - vfat /dev/sda1 rw,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro
569 514 0:57 / /var/lib/lxcfs rw,nosuid,nodev,relatime - fuse.lxcfs lxcfs rw,user_id=0,group_id=0,allow_other

> 
> I really wonder what mount is it happening to.  BTW, how painful would
> it be to teach syzcaller to turn those cascades of
> 	NONFAILING(*(uint8_t*)0x20000080 = 0x12);
> 	NONFAILING(*(uint8_t*)0x20000081 = 0);
> 	NONFAILING(*(uint16_t*)0x20000082 = 0);
> 	NONFAILING(*(uint32_t*)0x20000084 = 0xffffff9c);
> 	NONFAILING(*(uint64_t*)0x20000088 = 0);
> 	NONFAILING(*(uint64_t*)0x20000090 = 0x20000180);
> 	NONFAILING(memcpy((void*)0x20000180, "./file0\000", 8));
> 	NONFAILING(*(uint32_t*)0x20000098 = 0);
> 	NONFAILING(*(uint32_t*)0x2000009c = 0x80);
> 	NONFAILING(*(uint64_t*)0x200000a0 = 0x23456);
> 	....
> 	NONFAILING(syz_io_uring_submit(r[1], r[2], 0x20000080, 0));
> into something more readable?  Bloody annoyance every time...  Sure, I can
> manually translate it into
> 	struct io_uring_sqe *sqe = (void *)0x20000080;
> 	char *s = (void *)0x20000180;
> 	memset(sqe, '\0', sizeof(*sqe));
> 	sqe->opcode = 0x12; // IORING_OP_OPENAT?
> 	sqe->fd = -100;	// AT_FDCWD?
> 	sqe->addr = s;
> 	strcpy(s, "./file0");
> 	sqe->open_flags = 0x80;	// O_EXCL???
> 	sqe->user_data = 0x23456;	// random tag?
> 	syz_io_uring_submit(r[1], r[2], (unsigned long)p, 0);
> but it's really annoying as hell, especially since syz_io_uring_submit()
> comes from syzcaller and the damn thing _knows_ that the third argument
> is sodding io_uring_sqe, and never passed to anything other than
> memcpy() in there, at that, so the exact address can't matter.

Yeah, it's terrible to get an idea of what's going on in such produces.
I did the same exercise as you. I should probably have replied with all
of that data sooner so you wouldn't have to do the same shite I had to.
Oh well.

> 
> Incidentally, solitary O_EXCL (without O_CREAT) is... curious.  Does that
> sucker still trigger without it?  I.e. with store to 0x2000009c replaced
> with storing 0?

Yeah, I did that as well yesterday morning and it still triggers.

Christian
