Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB721354AD8
	for <lists+io-uring@lfdr.de>; Tue,  6 Apr 2021 04:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243379AbhDFCYT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Apr 2021 22:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243371AbhDFCYR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Apr 2021 22:24:17 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64324C06174A;
        Mon,  5 Apr 2021 19:24:10 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lTbNw-002t98-0J; Tue, 06 Apr 2021 02:24:08 +0000
Date:   Tue, 6 Apr 2021 02:24:07 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <YGvGR1zpWgg8mwLa@zeniv-ca.linux.org.uk>
References: <20210404170513.mfl5liccdaxjnpls@wittgenstein>
 <YGoKYktYPA86Qwju@zeniv-ca.linux.org.uk>
 <YGoe0VPs/Qmz/RxC@zeniv-ca.linux.org.uk>
 <20210405114437.hjcojekyp5zt6huu@wittgenstein>
 <YGs4clcRhyoXX8D0@zeniv-ca.linux.org.uk>
 <20210405170801.zrdhnon6g4ggb6c7@wittgenstein>
 <YGtVtfbYXck3qPRl@zeniv-ca.linux.org.uk>
 <YGtW5g6EFFArtevk@zeniv-ca.linux.org.uk>
 <20210405200737.qurhkqitoxweousx@wittgenstein>
 <YGu7n+dhMep1741/@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGu7n+dhMep1741/@zeniv-ca.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 06, 2021 at 01:38:39AM +0000, Al Viro wrote:
> On Mon, Apr 05, 2021 at 10:07:37PM +0200, Christian Brauner wrote:
> 
> > > diff --git a/fs/namei.c b/fs/namei.c
> > > index 216f16e74351..82344f1139ff 100644
> > > --- a/fs/namei.c
> > > +++ b/fs/namei.c
> > > @@ -2289,6 +2289,9 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
> > >  	int error;
> > >  	const char *s = nd->name->name;
> > >  
> > > +	nd->path.mnt = NULL;
> > > +	nd->path.dentry = NULL;
> > > +
> > >  	/* LOOKUP_CACHED requires RCU, ask caller to retry */
> > >  	if ((flags & (LOOKUP_RCU | LOOKUP_CACHED)) == LOOKUP_CACHED)
> > >  		return ERR_PTR(-EAGAIN);
> > > @@ -2322,8 +2325,6 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
> > >  	}
> > >  
> > >  	nd->root.mnt = NULL;
> > > -	nd->path.mnt = NULL;
> > > -	nd->path.dentry = NULL;
> > >  
> > >  	/* Absolute pathname -- fetch the root (LOOKUP_IN_ROOT uses nd->dfd). */
> > >  	if (*s == '/' && !(flags & LOOKUP_IN_ROOT)) {
> > 
> > Bingo. That fixes it.
> 
> *grumble*
> 
> OK, I suppose it'll do for backports, but longer term... I don't like how
> convoluted the rules for nameidata fields' validity are.  In particular,
> for nd->path I would rather have it
> 	* cleared in set_nameidata()
> 	* cleared when it become invalid.  That would be
> 		* places that drop rcu_read_lock() without having legitimized the sucker
> 		  (already done, except for terminate_walk())
> 		* terminate_walk() in non-RCU case after path_put(&nd->path)
> 
> OTOH... wait a sec - the whole thing is this cycle regression, so...

BTW, there's another piece of brittleness that almost accidentally doesn't
end up biting us - nd->depth should be cleared in set_nameidata(), not
in path_init().  In this case we are saved by the fact that the only
really early failure in path_init() can't happen on the first call,
so if we do leave the sucker before zeroing nd->depth, we are saved by
the fact that terminate_walk() has just been called and it *does*
clear nd->depth.  It's obviously cleaner to have it initialized from
the very beginning and not bother with it in path_init() at all.
Separate patch, though - this is not, strictly speaking, a bug.
