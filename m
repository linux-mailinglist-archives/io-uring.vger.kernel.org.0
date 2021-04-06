Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D86354A39
	for <lists+io-uring@lfdr.de>; Tue,  6 Apr 2021 03:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhDFBiv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Apr 2021 21:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbhDFBiv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Apr 2021 21:38:51 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABACC06174A;
        Mon,  5 Apr 2021 18:38:44 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lTafv-002se4-CA; Tue, 06 Apr 2021 01:38:39 +0000
Date:   Tue, 6 Apr 2021 01:38:39 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <YGu7n+dhMep1741/@zeniv-ca.linux.org.uk>
References: <YGns1iPBHeeMAtn8@zeniv-ca.linux.org.uk>
 <20210404170513.mfl5liccdaxjnpls@wittgenstein>
 <YGoKYktYPA86Qwju@zeniv-ca.linux.org.uk>
 <YGoe0VPs/Qmz/RxC@zeniv-ca.linux.org.uk>
 <20210405114437.hjcojekyp5zt6huu@wittgenstein>
 <YGs4clcRhyoXX8D0@zeniv-ca.linux.org.uk>
 <20210405170801.zrdhnon6g4ggb6c7@wittgenstein>
 <YGtVtfbYXck3qPRl@zeniv-ca.linux.org.uk>
 <YGtW5g6EFFArtevk@zeniv-ca.linux.org.uk>
 <20210405200737.qurhkqitoxweousx@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405200737.qurhkqitoxweousx@wittgenstein>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 05, 2021 at 10:07:37PM +0200, Christian Brauner wrote:

> > diff --git a/fs/namei.c b/fs/namei.c
> > index 216f16e74351..82344f1139ff 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -2289,6 +2289,9 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
> >  	int error;
> >  	const char *s = nd->name->name;
> >  
> > +	nd->path.mnt = NULL;
> > +	nd->path.dentry = NULL;
> > +
> >  	/* LOOKUP_CACHED requires RCU, ask caller to retry */
> >  	if ((flags & (LOOKUP_RCU | LOOKUP_CACHED)) == LOOKUP_CACHED)
> >  		return ERR_PTR(-EAGAIN);
> > @@ -2322,8 +2325,6 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
> >  	}
> >  
> >  	nd->root.mnt = NULL;
> > -	nd->path.mnt = NULL;
> > -	nd->path.dentry = NULL;
> >  
> >  	/* Absolute pathname -- fetch the root (LOOKUP_IN_ROOT uses nd->dfd). */
> >  	if (*s == '/' && !(flags & LOOKUP_IN_ROOT)) {
> 
> Bingo. That fixes it.

*grumble*

OK, I suppose it'll do for backports, but longer term... I don't like how
convoluted the rules for nameidata fields' validity are.  In particular,
for nd->path I would rather have it
	* cleared in set_nameidata()
	* cleared when it become invalid.  That would be
		* places that drop rcu_read_lock() without having legitimized the sucker
		  (already done, except for terminate_walk())
		* terminate_walk() in non-RCU case after path_put(&nd->path)

OTOH... wait a sec - the whole thing is this cycle regression, so...

Could you verify that the variant below fixes that crap?

Make sure nd->path.mnt and nd->path.dentry are always valid pointers

Initialize them in set_nameidata() and make sure that terminate_walk() clears them
once the pointers become potentially invalid (i.e. we leave RCU mode or drop them
in non-RCU one).  Currently we have "path_init() always initializes them and nobody
accesses them outside of path_init()/terminate_walk() segments", which is asking
for trouble.

With that change we would have nd->path.{mnt,dentry}
	1) always valid - NULL or pointing to currently allocated objects.
	2) non-NULL while we are successfully walking
	3) NULL when we are not walking at all
	4) contributing to refcounts whenever non-NULL outside of RCU mode.

Hopefully-fixes: 6c6ec2b0a3e0 ("fs: add support for LOOKUP_CACHED")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/namei.c b/fs/namei.c
index 216f16e74351..fc8760d4314e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -579,6 +579,8 @@ static void set_nameidata(struct nameidata *p, int dfd, struct filename *name)
 	p->stack = p->internal;
 	p->dfd = dfd;
 	p->name = name;
+	p->path.mnt = NULL;
+	p->path.dentry = NULL;
 	p->total_link_count = old ? old->total_link_count : 0;
 	p->saved = old;
 	current->nameidata = p;
@@ -652,6 +654,8 @@ static void terminate_walk(struct nameidata *nd)
 		rcu_read_unlock();
 	}
 	nd->depth = 0;
+	nd->path.mnt = NULL;
+	nd->path.dentry = NULL;
 }
 
 /* path_put is needed afterwards regardless of success or failure */
@@ -2322,8 +2326,6 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 	}
 
 	nd->root.mnt = NULL;
-	nd->path.mnt = NULL;
-	nd->path.dentry = NULL;
 
 	/* Absolute pathname -- fetch the root (LOOKUP_IN_ROOT uses nd->dfd). */
 	if (*s == '/' && !(flags & LOOKUP_IN_ROOT)) {
