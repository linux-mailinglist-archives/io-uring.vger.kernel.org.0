Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA24135363C
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 04:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236655AbhDDCii (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 3 Apr 2021 22:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236618AbhDDCii (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 3 Apr 2021 22:38:38 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B660CC061756;
        Sat,  3 Apr 2021 19:38:34 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSsek-002NjV-B3; Sun, 04 Apr 2021 02:38:30 +0000
Date:   Sun, 4 Apr 2021 02:38:30 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <YGkmpv1xNrTExS6l@zeniv-ca.linux.org.uk>
References: <0000000000003a565e05bee596f2@google.com>
 <20210401154515.k24qdd2lzhtneu47@wittgenstein>
 <90e7e339-eaec-adb2-cfed-6dc058a117a3@kernel.dk>
 <20210401174613.vymhhrfsemypougv@wittgenstein>
 <20210401175919.jpiylhfrlb4xb67u@wittgenstein>
 <YGYa0B4gabEYi2Tx@zeniv-ca.linux.org.uk>
 <YGkloJhMFc4hEatk@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGkloJhMFc4hEatk@zeniv-ca.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Apr 04, 2021 at 02:34:08AM +0000, Al Viro wrote:

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

... especially since the native syzcaller reproducer clearly *does* have
that information.  Simply putting that into comments side-by-side with
what gets put into C reproducer would be nice, especially if it goes with
field names...
