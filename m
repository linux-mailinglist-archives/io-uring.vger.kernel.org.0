Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952E23538B8
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 17:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhDDP4N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 11:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhDDP4L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Apr 2021 11:56:11 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B70C061756;
        Sun,  4 Apr 2021 08:56:06 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lT56Y-002UUF-A9; Sun, 04 Apr 2021 15:56:02 +0000
Date:   Sun, 4 Apr 2021 15:56:02 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <YGnhkoTfVfMSMPpK@zeniv-ca.linux.org.uk>
References: <0000000000003a565e05bee596f2@google.com>
 <20210401154515.k24qdd2lzhtneu47@wittgenstein>
 <90e7e339-eaec-adb2-cfed-6dc058a117a3@kernel.dk>
 <20210401174613.vymhhrfsemypougv@wittgenstein>
 <20210401175919.jpiylhfrlb4xb67u@wittgenstein>
 <YGYa0B4gabEYi2Tx@zeniv-ca.linux.org.uk>
 <YGkloJhMFc4hEatk@zeniv-ca.linux.org.uk>
 <20210404113445.xo6ntgfpxigcb3x6@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210404113445.xo6ntgfpxigcb3x6@wittgenstein>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Apr 04, 2021 at 01:34:45PM +0200, Christian Brauner wrote:

> Sorry for not replying to your earlier mail but I've been debugging this
> too. My current theory is that it's related to LOOKUP_ROOT_GRABBED when
> LOOKUP_CACHED is specified _possibly_ with an interaction how
> create_io_thread() is created with CLONE_FS. The reproducer requires you
> either have called pivot_root() or chroot() in order for the failure to
> happen. So I think the fact that we skip legitimize_root() when
> LOOKUP_CACHED is set might figure into this. I can keep digging.
> 

> Funny enough I already placed a printk statement into the place you
> wanted one too so I just amended mine. Here's what you get:
> 
> If pivot pivot_root() is used before the chroot() you get:
> 
> [  637.464555] AAAA: count(-1) | mnt_mntpoint(/) | mnt->mnt.mnt_root(/) | id(579) | dev(tmpfs)
> 
> if you only call chroot, i.e. make the pivot_root() branch a simple
> if (true) you get:
> 
> [  955.206117] AAAA: count(-2) | mnt_mntpoint(/) | mnt->mnt.mnt_root(/) | id(580) | dev(tmpfs)

Very interesting.  What happens if you call loop() twice?  And now I wonder
whether it's root or cwd, actually...  Hmm...

How about this:
	fd = open("/proc/self/mountinfo", 0);
	mkdir("./newroot/foo", 0777);
	mount("./newroot/foo", "./newroot/foo", 0, MS_BIND, NULL);
	chroot("./newroot");
	chdir("/foo");
	while (1) {
		static char buf[4096];
		int n = read(fd, buf, 4096);
		if (n <= 0)
			break;
		write(1, buf, n);
	}
	close(fd);
	drop_caps();
	loop();
as the end of namespace_sandbox_proc(), instead of
	chroot("./newroot");
	chdir("/");
	drop_caps();
	loop();
sequence we have there?

> The cat /proc/self/mountinfo is for the id(579) below:
... and it misses the damn thing, since we call it before the mount
in question had been created ;-/  So we'd probably be better off not
trying to be clever and just doing that as explicit (and completely
untested) read-write loop above.
