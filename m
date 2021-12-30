Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80FB481EF8
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 19:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241521AbhL3SBV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Dec 2021 13:01:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55494 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236001AbhL3SBV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Dec 2021 13:01:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1261361716;
        Thu, 30 Dec 2021 18:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7EFC36AE9;
        Thu, 30 Dec 2021 18:01:18 +0000 (UTC)
Date:   Thu, 30 Dec 2021 19:01:14 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH v10 4/5] io_uring: add fsetxattr and setxattr support
Message-ID: <20211230180114.vuum3zorhafd2zta@wittgenstein>
References: <20211229203002.4110839-1-shr@fb.com>
 <20211229203002.4110839-5-shr@fb.com>
 <Yc0Ws8LevbWc+N1q@zeniv-ca.linux.org.uk>
 <Yc0hwttkEu4wSPGa@zeniv-ca.linux.org.uk>
 <20211230101242.j6jzxc4ahmx2plqx@wittgenstein>
 <Yc3bYj33YPwpAg8q@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yc3bYj33YPwpAg8q@zeniv-ca.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 30, 2021 at 04:16:34PM +0000, Al Viro wrote:
> On Thu, Dec 30, 2021 at 11:12:42AM +0100, Christian Brauner wrote:
> 
> > @@ -545,6 +545,7 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
> >  int setxattr_copy(const char __user *name, struct xattr_ctx *ctx)
> >  {
> >  	int error;
> > +	struct xattr_ctx *new_ctx;
> >  
> >  	if (ctx->flags & ~(XATTR_CREATE|XATTR_REPLACE))
> >  		return -EINVAL;
> > @@ -606,12 +607,9 @@ setxattr(struct user_namespace *mnt_userns, struct dentry *d,
> >  	int error;
> >  
> >  	error = setxattr_copy(name, &ctx);
> > -	if (error)
> > -		return error;
> > -
> > -	error = do_setxattr(mnt_userns, d, &ctx);
> > -
> > -	kvfree(ctx.kvalue);
> > +	if (!error)
> > +		error = do_setxattr(mnt_userns, d, &ctx);
> > +	setxattr_finish(&ctx);
> >  	return error;
> >  }
> 
> Huh?  Have you lost a chunk or two in there?  The only modification of
> setxattr_copy() in your delta is the introduction of an unused local
> variable.  Confused...
> 
> What I had in mind is something like this:
> 
> // same for getxattr and setxattr
> static int xattr_name_from_user(const char __user *name, struct xattr_ctx *ctx)
> {
> 	int copied;
> 
> 	if (!ctx->xattr_name) {
> 		ctx->xattr_name = kmalloc(XATTR_NAME_MAX + 1, GFP_KERNEL);
> 		if (!ctx->xattr_name)
> 			return -ENOMEM;
> 	}
> 
> 	copied = strncpy_from_user(ctx->xattr_name, name, XATTR_NAME_MAX + 1);
>  	if (copied < 0)
>  		return copied;	// copyin failure; almost always -EFAULT
> 	if (copied == 0 || copied == XATTR_NAME_MAX + 1)
> 		return  -ERANGE;
> 	return 0;
> }
> 
> // freeing is up to the caller, whether we succeed or not
> int setxattr_copy(const char __user *name, struct xattr_ctx *ctx)
> {
>  	int error;
> 
> 	if (ctx->flags & ~(XATTR_CREATE|XATTR_REPLACE))
>  		return -EINVAL;
> 
> 	error = xattr_name_from_user(name, ctx);
>  	if (error)
>  		return error;
> 
> 	if (ctx->size) {
> 		void *p;
> 
> 		if (ctx->size > XATTR_SIZE_MAX)
>  			return -E2BIG;
> 
> 		p = vmemdup_user(ctx->value, ctx->size);
> 		if (IS_ERR(p))
> 			return PTR_ERR(p);
> 		ctx->kvalue = p;
>  	}
> 	return 0;
> }
> 
> with syscall side concluded with freeing ->kvalue (unconditionally), while
> io_uring one - ->kvalue and ->xattr_name (also unconditionally).  And to
> hell with struct xattr_name - a string is a string.

Uhm, it wasn't obvious at all that you were just talking about
attr_ctx->kname. At least to me. I thought you were saying to allocate
struct xattr_ctx dynamically for io_uring and have it static for the
syscall path. Anyway, that change seems sensible to me. I don't care
much if there's a separate struct xattr_name or not.

> 
> However, what I really want to see is the answer to my question re control
> flow and the place where we do copy the arguments from userland.  Including
> the pathname.
> 
> *IF* there's a subtle reason that has to be done from prep phase (and there
> might very well be - figuring out the control flow in io_uring is bloody
> painful), I would really like to see it spelled out, along with the explanation
> of the reasons why statx() doesn't need anything of that sort.
> 
> If there's no such reasons, I would bloody well leave marshalling to the

That's really something the io_uring folks should explain to us. I can't
help much there either apart from what I can gather from looking through
the io_req_prep() switch.

Where it's clear that nearly all syscall-operations immediately do a
getname() and/or copy their arguments in the *_prep() phase as, not in
the actual "do-the-work" phase. For example, io_epoll_ctl_prep() which
copies struct epoll_event via copy_from_user(). It doesn't do it in
io_epoll_ctl(). So as such io_statx_prep() is the outlier...
