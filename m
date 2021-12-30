Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418D04818D2
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 04:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbhL3DEh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 22:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhL3DEg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 22:04:36 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF64C061574;
        Wed, 29 Dec 2021 19:04:36 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n2lk2-00Ft24-Pu; Thu, 30 Dec 2021 03:04:34 +0000
Date:   Thu, 30 Dec 2021 03:04:34 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH v10 4/5] io_uring: add fsetxattr and setxattr support
Message-ID: <Yc0hwttkEu4wSPGa@zeniv-ca.linux.org.uk>
References: <20211229203002.4110839-1-shr@fb.com>
 <20211229203002.4110839-5-shr@fb.com>
 <Yc0Ws8LevbWc+N1q@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yc0Ws8LevbWc+N1q@zeniv-ca.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 30, 2021 at 02:17:23AM +0000, Al Viro wrote:
> On Wed, Dec 29, 2021 at 12:30:01PM -0800, Stefan Roesch wrote:
> 
> > +static int __io_setxattr_prep(struct io_kiocb *req,
> > +			const struct io_uring_sqe *sqe)
> > +{
> > +	struct io_xattr *ix = &req->xattr;
> > +	const char __user *name;
> > +	int ret;
> > +
> > +	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
> > +		return -EINVAL;
> > +	if (unlikely(sqe->ioprio))
> > +		return -EINVAL;
> > +	if (unlikely(req->flags & REQ_F_FIXED_FILE))
> > +		return -EBADF;
> > +
> > +	ix->filename = NULL;
> > +	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
> > +	ix->ctx.value = u64_to_user_ptr(READ_ONCE(sqe->addr2));
> > +	ix->ctx.kvalue = NULL;
> > +	ix->ctx.size = READ_ONCE(sqe->len);
> > +	ix->ctx.flags = READ_ONCE(sqe->xattr_flags);
> > +
> > +	ix->ctx.kname = kmalloc(sizeof(*ix->ctx.kname), GFP_KERNEL);
> > +	if (!ix->ctx.kname)
> > +		return -ENOMEM;
> > +
> > +	ret = setxattr_copy(name, &ix->ctx);
> > +	if (ret) {
> > +		kfree(ix->ctx.kname);
> > +		return ret;
> > +	}
> > +
> > +	req->flags |= REQ_F_NEED_CLEANUP;
> > +	return 0;
> > +}
> 
> OK, so you
> 	* allocate a buffer for xattr name
> 	* have setxattr_copy() copy the name in *and* memdup the contents
> 	* on failure, you have the buffer for xattr name freed and return
> an error.  memdup'ed stuff is left for cleanup, presumably.
> 
> > +static int io_setxattr_prep(struct io_kiocb *req,
> > +			const struct io_uring_sqe *sqe)
> > +{
> > +	struct io_xattr *ix = &req->xattr;
> > +	const char __user *path;
> > +	int ret;
> > +
> > +	ret = __io_setxattr_prep(req, sqe);
> > +	if (ret)
> > +		return ret;
> > +
> > +	path = u64_to_user_ptr(READ_ONCE(sqe->addr3));
> > +
> > +	ix->filename = getname_flags(path, LOOKUP_FOLLOW, NULL);
> > +	if (IS_ERR(ix->filename)) {
> > +		ret = PTR_ERR(ix->filename);
> > +		ix->filename = NULL;
> > +	}
> > +
> > +	return ret;
> > +}
> 
> ... and here you use it and bring the pathname in.  Should the latter
> step fail, you restore ->filename to NULL and return an error.
> 
> Could you explain what kind of magic could allow the caller to tell
> whether ix->ctx.kname needs to be freed on error?  I don't see any way
> that could possibly work...

FWIW, your calling conventions make no sense whatsoever.  OK, you have
a helper that does copyin of the arguments.  And it needs to be shared
between the syscall path (where you put the xattr name on stack) and
io_uring one (where you allocate it dynamically).  Why not simply move
the allocation into that helper, conditional upon the passed value being
NULL?  And leave it alone on any failure paths in that helper.

Syscall user would set it pointing to local structure/string/whatnot.
No freeing is needed there in any case.

io_uring one would set it to NULL and free the value left there on
cleanup.  Again, same in all cases, error or no error.  Just make sure
you have it zeroed *before* any failure exits (including those on req->flags,
etc.)

While we are at it, syscall path needs to free the copied xattr contents
anyway.  So screw freeing anything in that helper (both allocation failures
and copyin ones); have all freeing done by caller, and make it unconditional
there.  An error is usually a slow path; an error of that sort - definitely
so.  IOW,
	1) call the helper, copying userland data into the buffers allocated
by the helper
	2) if helper hasn't returned an error, do work
	3) free whatever the helper has allocated
With (3) being unconditional.  It doesn't make any sense to have a separate
early exit, especially since with your approach you end up paying the price
on failure exits in the helper anyway.

	error = setxattr_copy(...);
	if (likely(!error))
		error = do_setxattr(...);
	kvfree(...);
	return error;

would've been better for the syscall side as well.
