Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CCA3538F8
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 19:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhDDRFZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 13:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229861AbhDDRFY (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 4 Apr 2021 13:05:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDBC96128B;
        Sun,  4 Apr 2021 17:05:16 +0000 (UTC)
Date:   Sun, 4 Apr 2021 19:05:13 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <20210404170513.mfl5liccdaxjnpls@wittgenstein>
References: <20210401154515.k24qdd2lzhtneu47@wittgenstein>
 <90e7e339-eaec-adb2-cfed-6dc058a117a3@kernel.dk>
 <20210401174613.vymhhrfsemypougv@wittgenstein>
 <20210401175919.jpiylhfrlb4xb67u@wittgenstein>
 <YGYa0B4gabEYi2Tx@zeniv-ca.linux.org.uk>
 <YGkloJhMFc4hEatk@zeniv-ca.linux.org.uk>
 <20210404113445.xo6ntgfpxigcb3x6@wittgenstein>
 <YGnhkoTfVfMSMPpK@zeniv-ca.linux.org.uk>
 <20210404164040.vtxdcfzgliuzghwk@wittgenstein>
 <YGns1iPBHeeMAtn8@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YGns1iPBHeeMAtn8@zeniv-ca.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Apr 04, 2021 at 04:44:06PM +0000, Al Viro wrote:
> On Sun, Apr 04, 2021 at 06:40:40PM +0200, Christian Brauner wrote:
> 
> > > Very interesting.  What happens if you call loop() twice?  And now I wonder
> > > whether it's root or cwd, actually...  Hmm...
> > > 
> > > How about this:
> > > 	fd = open("/proc/self/mountinfo", 0);
> > > 	mkdir("./newroot/foo", 0777);
> > > 	mount("./newroot/foo", "./newroot/foo", 0, MS_BIND, NULL);
> > > 	chroot("./newroot");
> > > 	chdir("/foo");
> > > 	while (1) {
> > > 		static char buf[4096];
> > > 		int n = read(fd, buf, 4096);
> > > 		if (n <= 0)
> > > 			break;
> > > 		write(1, buf, n);
> > > 	}
> > > 	close(fd);
> > > 	drop_caps();
> > > 	loop();
> > > as the end of namespace_sandbox_proc(), instead of
> > > 	chroot("./newroot");
> > > 	chdir("/");
> > > 	drop_caps();
> > > 	loop();
> > > sequence we have there?
> > 
> > Uhum, well then we oops properly with a null-deref.
> 
> Cute...  Could you dump namei.o (ideally - with namei.s) from your build
> someplace public?

Yeah, I have at least namei.o

https://drive.google.com/file/d/1AvO1St0YltIrA86DXjp1Xg3ojtS9owGh/view?usp=sharing

Christian
