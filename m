Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E944481E01
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 17:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbhL3QQi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Dec 2021 11:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239267AbhL3QQi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Dec 2021 11:16:38 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B167C061574;
        Thu, 30 Dec 2021 08:16:38 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n2y6U-00G2Vv-Pq; Thu, 30 Dec 2021 16:16:34 +0000
Date:   Thu, 30 Dec 2021 16:16:34 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH v10 4/5] io_uring: add fsetxattr and setxattr support
Message-ID: <Yc3bYj33YPwpAg8q@zeniv-ca.linux.org.uk>
References: <20211229203002.4110839-1-shr@fb.com>
 <20211229203002.4110839-5-shr@fb.com>
 <Yc0Ws8LevbWc+N1q@zeniv-ca.linux.org.uk>
 <Yc0hwttkEu4wSPGa@zeniv-ca.linux.org.uk>
 <20211230101242.j6jzxc4ahmx2plqx@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211230101242.j6jzxc4ahmx2plqx@wittgenstein>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 30, 2021 at 11:12:42AM +0100, Christian Brauner wrote:

> @@ -545,6 +545,7 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
>  int setxattr_copy(const char __user *name, struct xattr_ctx *ctx)
>  {
>  	int error;
> +	struct xattr_ctx *new_ctx;
>  
>  	if (ctx->flags & ~(XATTR_CREATE|XATTR_REPLACE))
>  		return -EINVAL;
> @@ -606,12 +607,9 @@ setxattr(struct user_namespace *mnt_userns, struct dentry *d,
>  	int error;
>  
>  	error = setxattr_copy(name, &ctx);
> -	if (error)
> -		return error;
> -
> -	error = do_setxattr(mnt_userns, d, &ctx);
> -
> -	kvfree(ctx.kvalue);
> +	if (!error)
> +		error = do_setxattr(mnt_userns, d, &ctx);
> +	setxattr_finish(&ctx);
>  	return error;
>  }

Huh?  Have you lost a chunk or two in there?  The only modification of
setxattr_copy() in your delta is the introduction of an unused local
variable.  Confused...

What I had in mind is something like this:

// same for getxattr and setxattr
static int xattr_name_from_user(const char __user *name, struct xattr_ctx *ctx)
{
	int copied;

	if (!ctx->xattr_name) {
		ctx->xattr_name = kmalloc(XATTR_NAME_MAX + 1, GFP_KERNEL);
		if (!ctx->xattr_name)
			return -ENOMEM;
	}

	copied = strncpy_from_user(ctx->xattr_name, name, XATTR_NAME_MAX + 1);
 	if (copied < 0)
 		return copied;	// copyin failure; almost always -EFAULT
	if (copied == 0 || copied == XATTR_NAME_MAX + 1)
		return  -ERANGE;
	return 0;
}

// freeing is up to the caller, whether we succeed or not
int setxattr_copy(const char __user *name, struct xattr_ctx *ctx)
{
 	int error;

	if (ctx->flags & ~(XATTR_CREATE|XATTR_REPLACE))
 		return -EINVAL;

	error = xattr_name_from_user(name, ctx);
 	if (error)
 		return error;

	if (ctx->size) {
		void *p;

		if (ctx->size > XATTR_SIZE_MAX)
 			return -E2BIG;

		p = vmemdup_user(ctx->value, ctx->size);
		if (IS_ERR(p))
			return PTR_ERR(p);
		ctx->kvalue = p;
 	}
	return 0;
}

with syscall side concluded with freeing ->kvalue (unconditionally), while
io_uring one - ->kvalue and ->xattr_name (also unconditionally).  And to
hell with struct xattr_name - a string is a string.

However, what I really want to see is the answer to my question re control
flow and the place where we do copy the arguments from userland.  Including
the pathname.

*IF* there's a subtle reason that has to be done from prep phase (and there
might very well be - figuring out the control flow in io_uring is bloody
painful), I would really like to see it spelled out, along with the explanation
of the reasons why statx() doesn't need anything of that sort.

If there's no such reasons, I would bloody well leave marshalling to the
payload, allowing to share a lot more with the syscall path.  In that
case xattr_ctx only needs to carry the userland pointers/size/flags.
And all that "do we allocate the kernel copy of the name dynamically,
or does it live on stack" simply goes away.

Details, please.
