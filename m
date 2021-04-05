Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D45354756
	for <lists+io-uring@lfdr.de>; Mon,  5 Apr 2021 22:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240469AbhDEUHu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Apr 2021 16:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239120AbhDEUHt (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 5 Apr 2021 16:07:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85237613C2;
        Mon,  5 Apr 2021 20:07:40 +0000 (UTC)
Date:   Mon, 5 Apr 2021 22:07:37 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <20210405200737.qurhkqitoxweousx@wittgenstein>
References: <20210404164040.vtxdcfzgliuzghwk@wittgenstein>
 <YGns1iPBHeeMAtn8@zeniv-ca.linux.org.uk>
 <20210404170513.mfl5liccdaxjnpls@wittgenstein>
 <YGoKYktYPA86Qwju@zeniv-ca.linux.org.uk>
 <YGoe0VPs/Qmz/RxC@zeniv-ca.linux.org.uk>
 <20210405114437.hjcojekyp5zt6huu@wittgenstein>
 <YGs4clcRhyoXX8D0@zeniv-ca.linux.org.uk>
 <20210405170801.zrdhnon6g4ggb6c7@wittgenstein>
 <YGtVtfbYXck3qPRl@zeniv-ca.linux.org.uk>
 <YGtW5g6EFFArtevk@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YGtW5g6EFFArtevk@zeniv-ca.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 05, 2021 at 06:28:54PM +0000, Al Viro wrote:
> On Mon, Apr 05, 2021 at 06:23:49PM +0000, Al Viro wrote:
> > On Mon, Apr 05, 2021 at 07:08:01PM +0200, Christian Brauner wrote:
> > 
> > > Ah dentry count of -127 looks... odd.
> > 
> > dead + 1...
> > 
> > void lockref_mark_dead(struct lockref *lockref)
> > {
> >         assert_spin_locked(&lockref->lock);
> > 	lockref->count = -128;
> > }
> > 
> > IOW, a leaked (uncounted) reference to dentry, that got dget() called on
> > it after dentry had been freed.
> > 
> > 	IOW, current->fs->pwd.dentry happens to point to an already freed
> > struct dentry here.  Joy...
> > 
> > 	Could you slap
> > 
> > spin_lock(&current->fs->lock);
> > WARN_ON(d_count(current->fs->pwd.dentry) < 0);
> > spin_unlock(&current->fs->lock);
> > 
> > before and after calls of io_issue_sqe() and see if it triggers?  We definitely
> > are seeing buggered dentry refcounting here.
> 
> Check if this helps, please.
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 216f16e74351..82344f1139ff 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2289,6 +2289,9 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
>  	int error;
>  	const char *s = nd->name->name;
>  
> +	nd->path.mnt = NULL;
> +	nd->path.dentry = NULL;
> +
>  	/* LOOKUP_CACHED requires RCU, ask caller to retry */
>  	if ((flags & (LOOKUP_RCU | LOOKUP_CACHED)) == LOOKUP_CACHED)
>  		return ERR_PTR(-EAGAIN);
> @@ -2322,8 +2325,6 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
>  	}
>  
>  	nd->root.mnt = NULL;
> -	nd->path.mnt = NULL;
> -	nd->path.dentry = NULL;
>  
>  	/* Absolute pathname -- fetch the root (LOOKUP_IN_ROOT uses nd->dfd). */
>  	if (*s == '/' && !(flags & LOOKUP_IN_ROOT)) {

Bingo. That fixes it.
