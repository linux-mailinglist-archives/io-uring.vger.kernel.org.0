Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A609355404
	for <lists+io-uring@lfdr.de>; Tue,  6 Apr 2021 14:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239469AbhDFMfU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Apr 2021 08:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232730AbhDFMfS (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 6 Apr 2021 08:35:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96597613C6;
        Tue,  6 Apr 2021 12:35:08 +0000 (UTC)
Date:   Tue, 6 Apr 2021 14:35:05 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <20210406123505.auxqtquoys6xg6yf@wittgenstein>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YGu7n+dhMep1741/@zeniv-ca.linux.org.uk>
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
> 
> Could you verify that the variant below fixes that crap?
> 
> Make sure nd->path.mnt and nd->path.dentry are always valid pointers
> 
> Initialize them in set_nameidata() and make sure that terminate_walk() clears them
> once the pointers become potentially invalid (i.e. we leave RCU mode or drop them
> in non-RCU one).  Currently we have "path_init() always initializes them and nobody
> accesses them outside of path_init()/terminate_walk() segments", which is asking
> for trouble.
> 
> With that change we would have nd->path.{mnt,dentry}
> 	1) always valid - NULL or pointing to currently allocated objects.
> 	2) non-NULL while we are successfully walking
> 	3) NULL when we are not walking at all
> 	4) contributing to refcounts whenever non-NULL outside of RCU mode.
> 
> Hopefully-fixes: 6c6ec2b0a3e0 ("fs: add support for LOOKUP_CACHED")
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/fs/namei.c b/fs/namei.c
> index 216f16e74351..fc8760d4314e 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -579,6 +579,8 @@ static void set_nameidata(struct nameidata *p, int dfd, struct filename *name)
>  	p->stack = p->internal;
>  	p->dfd = dfd;
>  	p->name = name;
> +	p->path.mnt = NULL;
> +	p->path.dentry = NULL;
>  	p->total_link_count = old ? old->total_link_count : 0;
>  	p->saved = old;
>  	current->nameidata = p;
> @@ -652,6 +654,8 @@ static void terminate_walk(struct nameidata *nd)
>  		rcu_read_unlock();
>  	}
>  	nd->depth = 0;
> +	nd->path.mnt = NULL;
> +	nd->path.dentry = NULL;
>  }
>  
>  /* path_put is needed afterwards regardless of success or failure */
> @@ -2322,8 +2326,6 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
>  	}
>  
>  	nd->root.mnt = NULL;
> -	nd->path.mnt = NULL;
> -	nd->path.dentry = NULL;
>  
>  	/* Absolute pathname -- fetch the root (LOOKUP_IN_ROOT uses nd->dfd). */
>  	if (*s == '/' && !(flags & LOOKUP_IN_ROOT)) {

Yeah, that works too.
Though I'm not a fan of this open-coding as it looks pretty brittle
especially if we ever introduce another LOOKUP_* flag that requires us
to clear some other field carefully. I think a tiny static inline void
helper might make it easier to grok what's going on.

And while we're at it might I bring up the possibility of an additional
cleanup of how we currently call path_init().
Right now we pass the return value from path_init() directly into e.g.
link_path_walk() which as a first thing checks for error. Which feels
rather wrong and has always confused me when looking at these codepaths.
I get that it might make sense for reasons unrelated to path_init() that
link_path_walk() checks its first argument for error but path_init()
should be checked for error right away especially now that we return
early when LOOKUP_CACHED is set without LOOKUP_RCU. I have two/three
additional patches on top of the one below that massage path_lookupat(),
path_openat() to get rid of such - imho - hard to parse while
constructs:

		while (!(error = link_path_walk(s, nd)) &&
		       (s = <foo>(nd, file, op)) != NULL)
			;

in favor of a for (;;) like we do in link_path_walk() itself already
with early exits to a cleanup label. I'm not too fond of the

if (!error)
	error = foo();
if (!error)
	error = bar();

terminate_walk();
return error;

thing especially in longer functions such as path_lookupat() where it
gets convoluted pretty quickly. I think it would be cleaner to have
something like [1]. The early exists make the code easier to reason
about imho. But I get that that's a style discussion.  If you want to
see the whole thing and not just the patch below I'm happy to send it
though. Here's the tweaked fix for the immediate syzbot issue only:

From d6d669aaaba64debb9c433e281109b5494ad9bc5 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 6 Apr 2021 13:20:26 +0200
Subject: [PATCH 1/3] namei: Ensure nd->path.{dentry,mnt} are always valid
 pointers

Initialize them in set_nameidata() and make sure that terminate_walk()
clears them once the pointers become potentially invalid (i.e.
we leave RCU mode or drop them in non-RCU one).  Currently we have
"path_init() always initializes them and nobody accesses them outside of
path_init()/terminate_walk() segments", which is asking for trouble.

With that change we would have nd->path.{mnt,dentry}
1) always valid - NULL or pointing to currently allocated objects.
2) non-NULL while we are successfully walking
3) NULL when we are not walking at all
4) contributing to refcounts whenever non-NULL outside of RCU mode.

Fixes: 6c6ec2b0a3e0 ("fs: add support for LOOKUP_CACHED")
Reported-by: syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/namei.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 216f16e74351..618055419da3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -573,9 +573,18 @@ struct nameidata {
 	umode_t		dir_mode;
 } __randomize_layout;
 
+static inline void clear_nameidata(struct nameidata *nd)
+{
+	nd->depth = 0;
+	nd->path.mnt = NULL;
+	nd->path.dentry = NULL;
+}
+
 static void set_nameidata(struct nameidata *p, int dfd, struct filename *name)
 {
 	struct nameidata *old = current->nameidata;
+
+	clear_nameidata(p);
 	p->stack = p->internal;
 	p->dfd = dfd;
 	p->name = name;
@@ -651,7 +660,7 @@ static void terminate_walk(struct nameidata *nd)
 		nd->flags &= ~LOOKUP_RCU;
 		rcu_read_unlock();
 	}
-	nd->depth = 0;
+	clear_nameidata(nd);
 }
 
 /* path_put is needed afterwards regardless of success or failure */
@@ -2322,8 +2331,6 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 	}
 
 	nd->root.mnt = NULL;
-	nd->path.mnt = NULL;
-	nd->path.dentry = NULL;
 
 	/* Absolute pathname -- fetch the root (LOOKUP_IN_ROOT uses nd->dfd). */
 	if (*s == '/' && !(flags & LOOKUP_IN_ROOT)) {
-- 
2.27.0



[1]:
diff --git a/fs/namei.c b/fs/namei.c
index ae1b5cd7b1a9..572a0d6e22cc 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2424,33 +2424,49 @@ static int path_lookupat(struct nameidata *nd, unsigned flags, struct path *path
        int err;

        s = path_init(nd, flags);
-       if (IS_ERR(s))
-               return PTR_ERR(s);
+       if (IS_ERR(s)) {
+               err = PTR_ERR(s);
+               goto out_terminate;
+       }

        if (unlikely(flags & LOOKUP_DOWN)) {
                err = handle_lookup_down(nd);
                if (unlikely(err < 0))
-                       s = ERR_PTR(err);
+                       goto out_terminate;
        }

-       while (!(err = link_path_walk(s, nd)) &&
-              (s = lookup_last(nd)) != NULL)
-               ;
-       if (!err)
-               err = complete_walk(nd);
+       for (;;) {
+               err = link_path_walk(s, nd);
+               if (err)
+                       goto out_terminate;

-       if (!err && nd->flags & LOOKUP_DIRECTORY)
-               if (!d_can_lookup(nd->path.dentry))
-                       err = -ENOTDIR;
-       if (!err && unlikely(nd->flags & LOOKUP_MOUNTPOINT)) {
+               s = lookup_last(nd);
+               if (!s)
+                       break;
+       }
+
+       err = complete_walk(nd);
+       if (err)
+               goto out_terminate;
+
+       if ((nd->flags & LOOKUP_DIRECTORY) &&
+           (!d_can_lookup(nd->path.dentry))) {
+               err = -ENOTDIR;
+               goto out_terminate;
+       }
+
+       if (unlikely(nd->flags & LOOKUP_MOUNTPOINT)) {
                err = handle_lookup_down(nd);
                nd->flags &= ~LOOKUP_JUMPED; // no d_weak_revalidate(), please...
+               if (err)
+                       goto out_terminate;
        }
-       if (!err) {
-               *path = nd->path;
-               nd->path.mnt = NULL;
-               nd->path.dentry = NULL;
-       }
+
+       *path = nd->path;
+       nd->path.mnt = NULL;
+       nd->path.dentry = NULL;
+
+out_terminate:
        terminate_walk(nd);
        return err;
 }
