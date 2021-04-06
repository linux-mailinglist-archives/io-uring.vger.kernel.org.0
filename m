Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF253554E1
	for <lists+io-uring@lfdr.de>; Tue,  6 Apr 2021 15:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242509AbhDFNWS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Apr 2021 09:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231897AbhDFNWS (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 6 Apr 2021 09:22:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A3FA613B8;
        Tue,  6 Apr 2021 13:22:08 +0000 (UTC)
Date:   Tue, 6 Apr 2021 15:22:05 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <20210406132205.qnherkzif64xmgxg@wittgenstein>
References: <YGoe0VPs/Qmz/RxC@zeniv-ca.linux.org.uk>
 <20210405114437.hjcojekyp5zt6huu@wittgenstein>
 <YGs4clcRhyoXX8D0@zeniv-ca.linux.org.uk>
 <20210405170801.zrdhnon6g4ggb6c7@wittgenstein>
 <YGtVtfbYXck3qPRl@zeniv-ca.linux.org.uk>
 <YGtW5g6EFFArtevk@zeniv-ca.linux.org.uk>
 <20210405200737.qurhkqitoxweousx@wittgenstein>
 <YGu7n+dhMep1741/@zeniv-ca.linux.org.uk>
 <20210406123505.auxqtquoys6xg6yf@wittgenstein>
 <YGxeaTzdnxn/3dsY@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YGxeaTzdnxn/3dsY@zeniv-ca.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 06, 2021 at 01:13:13PM +0000, Al Viro wrote:
> On Tue, Apr 06, 2021 at 02:35:05PM +0200, Christian Brauner wrote:
> 
> > And while we're at it might I bring up the possibility of an additional
> > cleanup of how we currently call path_init().
> > Right now we pass the return value from path_init() directly into e.g.
> > link_path_walk() which as a first thing checks for error. Which feels
> > rather wrong and has always confused me when looking at these codepaths.
> 
> Why?

Why is a another function in charge of checking the return value of an
initialization function. If something like path_init() fails why is the
next caller responsible for rejecting it's return value and then we're
passing that failure value through the whole function with if (!err)
ladders but as I said it's mostly style preferences.

> 
> > I get that it might make sense for reasons unrelated to path_init() that
> > link_path_walk() checks its first argument for error but path_init()
> > should be checked for error right away especially now that we return
> > early when LOOKUP_CACHED is set without LOOKUP_RCU.
> 
> But you are making the _callers_ of path_init() do that, for no good
> reason.

I'm confused why having callers of functions responsible for checking
error values is such an out-of-band concept suddenly. I don't think it's
worth arguing over this though.

> 
> > thing especially in longer functions such as path_lookupat() where it
> > gets convoluted pretty quickly. I think it would be cleaner to have
> > something like [1]. The early exists make the code easier to reason
> > about imho. But I get that that's a style discussion.
> 
> Your variant is a lot more brittle, actually.
> 
> > @@ -2424,33 +2424,49 @@ static int path_lookupat(struct nameidata *nd, unsigned flags, struct path *path
> >         int err;
> > 
> >         s = path_init(nd, flags);
> > -       if (IS_ERR(s))
> > -               return PTR_ERR(s);
> 
> Where has that come from, BTW?  Currently path_lookupat() does no such thing.

Hm? Are you maybe overlooking path_init() which assigns straight into
the variable declaration? Or are you referring to sm else?

static int path_lookupat(struct nameidata *nd, unsigned flags, struct path *path)
{
	const char *s = path_init(nd, flags);
	int err;

	if (unlikely(flags & LOOKUP_DOWN) && !IS_ERR(s)) {
		err = handle_lookup_down(nd);
		if (unlikely(err < 0))
			s = ERR_PTR(err);
	}

	while (!(err = link_path_walk(s, nd)) &&
	       (s = lookup_last(nd)) != NULL)
		;
