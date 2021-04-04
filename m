Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3618353638
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 04:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236641AbhDDCed (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 3 Apr 2021 22:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236621AbhDDCed (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 3 Apr 2021 22:34:33 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C618FC061756;
        Sat,  3 Apr 2021 19:34:29 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSsaW-002Ng2-6V; Sun, 04 Apr 2021 02:34:08 +0000
Date:   Sun, 4 Apr 2021 02:34:08 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <YGkloJhMFc4hEatk@zeniv-ca.linux.org.uk>
References: <0000000000003a565e05bee596f2@google.com>
 <20210401154515.k24qdd2lzhtneu47@wittgenstein>
 <90e7e339-eaec-adb2-cfed-6dc058a117a3@kernel.dk>
 <20210401174613.vymhhrfsemypougv@wittgenstein>
 <20210401175919.jpiylhfrlb4xb67u@wittgenstein>
 <YGYa0B4gabEYi2Tx@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGYa0B4gabEYi2Tx@zeniv-ca.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 01, 2021 at 07:11:12PM +0000, Al Viro wrote:

> > I _think_ I see what the issue is. It seems that an assumption made in
> > this commit might be wrong and we're missing a mnt_add_count() bump that
> > we would otherwise have gotten if we've moved the failure handling into
> > the unlazy helpers themselves.
> > 
> > Al, does that sound plausible?
> 
> mnt_add_count() on _what_?  Failure in legitimize_links() ends up with
> nd->path.mnt zeroed, in both callers.  So which vfsmount would be
> affected?

Could you turn that WARN_ON(count < 0) into
	if (WARN_ON(count < 0))
		printk(KERN_ERR "id = %d, dev = %s, count = %d\n",
				mnt->mnt_id,
				mnt->mnt_sb->s_id,
				count);
add system("cat /proc/self/mountinfo"); right after sandbox_common()
call and try to reproduce that?

I really wonder what mount is it happening to.  BTW, how painful would
it be to teach syzcaller to turn those cascades of
	NONFAILING(*(uint8_t*)0x20000080 = 0x12);
	NONFAILING(*(uint8_t*)0x20000081 = 0);
	NONFAILING(*(uint16_t*)0x20000082 = 0);
	NONFAILING(*(uint32_t*)0x20000084 = 0xffffff9c);
	NONFAILING(*(uint64_t*)0x20000088 = 0);
	NONFAILING(*(uint64_t*)0x20000090 = 0x20000180);
	NONFAILING(memcpy((void*)0x20000180, "./file0\000", 8));
	NONFAILING(*(uint32_t*)0x20000098 = 0);
	NONFAILING(*(uint32_t*)0x2000009c = 0x80);
	NONFAILING(*(uint64_t*)0x200000a0 = 0x23456);
	....
	NONFAILING(syz_io_uring_submit(r[1], r[2], 0x20000080, 0));
into something more readable?  Bloody annoyance every time...  Sure, I can
manually translate it into
	struct io_uring_sqe *sqe = (void *)0x20000080;
	char *s = (void *)0x20000180;
	memset(sqe, '\0', sizeof(*sqe));
	sqe->opcode = 0x12; // IORING_OP_OPENAT?
	sqe->fd = -100;	// AT_FDCWD?
	sqe->addr = s;
	strcpy(s, "./file0");
	sqe->open_flags = 0x80;	// O_EXCL???
	sqe->user_data = 0x23456;	// random tag?
	syz_io_uring_submit(r[1], r[2], (unsigned long)p, 0);
but it's really annoying as hell, especially since syz_io_uring_submit()
comes from syzcaller and the damn thing _knows_ that the third argument
is sodding io_uring_sqe, and never passed to anything other than
memcpy() in there, at that, so the exact address can't matter.

Incidentally, solitary O_EXCL (without O_CREAT) is... curious.  Does that
sucker still trigger without it?  I.e. with store to 0x2000009c replaced
with storing 0?
