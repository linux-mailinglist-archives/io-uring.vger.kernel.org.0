Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B964481B41
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 11:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238388AbhL3KMt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Dec 2021 05:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238256AbhL3KMt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Dec 2021 05:12:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D9AC061574;
        Thu, 30 Dec 2021 02:12:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8531161650;
        Thu, 30 Dec 2021 10:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B54AC36AE9;
        Thu, 30 Dec 2021 10:12:44 +0000 (UTC)
Date:   Thu, 30 Dec 2021 11:12:42 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH v10 4/5] io_uring: add fsetxattr and setxattr support
Message-ID: <20211230101242.j6jzxc4ahmx2plqx@wittgenstein>
References: <20211229203002.4110839-1-shr@fb.com>
 <20211229203002.4110839-5-shr@fb.com>
 <Yc0Ws8LevbWc+N1q@zeniv-ca.linux.org.uk>
 <Yc0hwttkEu4wSPGa@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yc0hwttkEu4wSPGa@zeniv-ca.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 30, 2021 at 03:04:34AM +0000, Al Viro wrote:
> On Thu, Dec 30, 2021 at 02:17:23AM +0000, Al Viro wrote:
> > On Wed, Dec 29, 2021 at 12:30:01PM -0800, Stefan Roesch wrote:
> > 
> > > +static int __io_setxattr_prep(struct io_kiocb *req,
> > > +			const struct io_uring_sqe *sqe)
> > > +{
> > > +	struct io_xattr *ix = &req->xattr;
> > > +	const char __user *name;
> > > +	int ret;
> > > +
> > > +	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
> > > +		return -EINVAL;
> > > +	if (unlikely(sqe->ioprio))
> > > +		return -EINVAL;
> > > +	if (unlikely(req->flags & REQ_F_FIXED_FILE))
> > > +		return -EBADF;
> > > +
> > > +	ix->filename = NULL;
> > > +	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
> > > +	ix->ctx.value = u64_to_user_ptr(READ_ONCE(sqe->addr2));
> > > +	ix->ctx.kvalue = NULL;
> > > +	ix->ctx.size = READ_ONCE(sqe->len);
> > > +	ix->ctx.flags = READ_ONCE(sqe->xattr_flags);
> > > +
> > > +	ix->ctx.kname = kmalloc(sizeof(*ix->ctx.kname), GFP_KERNEL);
> > > +	if (!ix->ctx.kname)
> > > +		return -ENOMEM;
> > > +
> > > +	ret = setxattr_copy(name, &ix->ctx);
> > > +	if (ret) {
> > > +		kfree(ix->ctx.kname);
> > > +		return ret;
> > > +	}
> > > +
> > > +	req->flags |= REQ_F_NEED_CLEANUP;
> > > +	return 0;
> > > +}
> > 
> > OK, so you
> > 	* allocate a buffer for xattr name
> > 	* have setxattr_copy() copy the name in *and* memdup the contents
> > 	* on failure, you have the buffer for xattr name freed and return
> > an error.  memdup'ed stuff is left for cleanup, presumably.
> > 
> > > +static int io_setxattr_prep(struct io_kiocb *req,
> > > +			const struct io_uring_sqe *sqe)
> > > +{
> > > +	struct io_xattr *ix = &req->xattr;
> > > +	const char __user *path;
> > > +	int ret;
> > > +
> > > +	ret = __io_setxattr_prep(req, sqe);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	path = u64_to_user_ptr(READ_ONCE(sqe->addr3));
> > > +
> > > +	ix->filename = getname_flags(path, LOOKUP_FOLLOW, NULL);
> > > +	if (IS_ERR(ix->filename)) {
> > > +		ret = PTR_ERR(ix->filename);
> > > +		ix->filename = NULL;
> > > +	}
> > > +
> > > +	return ret;
> > > +}
> > 
> > ... and here you use it and bring the pathname in.  Should the latter
> > step fail, you restore ->filename to NULL and return an error.
> > 
> > Could you explain what kind of magic could allow the caller to tell
> > whether ix->ctx.kname needs to be freed on error?  I don't see any way
> > that could possibly work...
> 
> FWIW, your calling conventions make no sense whatsoever.  OK, you have
> a helper that does copyin of the arguments.  And it needs to be shared
> between the syscall path (where you put the xattr name on stack) and
> io_uring one (where you allocate it dynamically).  Why not simply move
> the allocation into that helper, conditional upon the passed value being
> NULL?  And leave it alone on any failure paths in that helper.

I had thought about that too when looking at Stefan's code at first but
then concluded that doesn't make sense since io_uring doesn't allocate
xattr_ctx dynamically either. It embedds it directly in io_xattrs which
itself isn't allocated dynamically either.

But I think the unconditional cleanup you proposed makes sense. If we
add a simple static inline helper to internal.h to cleanup xattr_ctx
once the caller is done we can use that in __io_setxattr() and
setxattr(): 

From 248cae031c21d3103c8ab46afd729aa46114019a Mon Sep 17 00:00:00 2001
From: Christian Brauner <christian.brauner@ubuntu.com>
Date: Thu, 30 Dec 2021 11:02:57 +0100
Subject: [PATCH] UNTESTED

---
 fs/internal.h |  7 +++++++
 fs/io_uring.c | 11 +----------
 fs/xattr.c    | 10 ++++------
 3 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 942b2005a2be..446dca46d845 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -228,5 +228,12 @@ ssize_t do_getxattr(struct user_namespace *mnt_userns,
 		    size_t size);
 
 int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
+static inline void setxattr_finish(struct xattr_ctx *ctx)
+{
+	kfree(ctx->kname);
+	kvfree(ctx->kvalue);
+	memset(ctx, 0, sizeof(struct xattr_ctx));
+}
+
 int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 		struct xattr_ctx *ctx);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7204b8d593e4..2e30c7a87eb9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4114,7 +4114,7 @@ static int __io_setxattr(struct io_kiocb *req, unsigned int issue_flags,
 		ret = do_setxattr(mnt_user_ns(path->mnt), path->dentry, &ix->ctx);
 		mnt_drop_write(path->mnt);
 	}
-
+	setxattr_finish(&ix->ctx);
 	return ret;
 }
 
@@ -4127,12 +4127,7 @@ static int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
 		return -EAGAIN;
 
 	ret = __io_setxattr(req, issue_flags, &req->file->f_path);
-
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	kfree(ix->ctx.kname);
-
-	if (ix->ctx.kvalue)
-		kvfree(ix->ctx.kvalue);
 	if (ret < 0)
 		req_set_fail(req);
 
@@ -4163,10 +4158,6 @@ static int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
 	putname(ix->filename);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	kfree(ix->ctx.kname);
-
-	if (ix->ctx.kvalue)
-		kvfree(ix->ctx.kvalue);
 	if (ret < 0)
 		req_set_fail(req);
 
diff --git a/fs/xattr.c b/fs/xattr.c
index 3b6d683d07b9..0f4e067816bc 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -545,6 +545,7 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
 int setxattr_copy(const char __user *name, struct xattr_ctx *ctx)
 {
 	int error;
+	struct xattr_ctx *new_ctx;
 
 	if (ctx->flags & ~(XATTR_CREATE|XATTR_REPLACE))
 		return -EINVAL;
@@ -606,12 +607,9 @@ setxattr(struct user_namespace *mnt_userns, struct dentry *d,
 	int error;
 
 	error = setxattr_copy(name, &ctx);
-	if (error)
-		return error;
-
-	error = do_setxattr(mnt_userns, d, &ctx);
-
-	kvfree(ctx.kvalue);
+	if (!error)
+		error = do_setxattr(mnt_userns, d, &ctx);
+	setxattr_finish(&ctx);
 	return error;
 }
 
-- 
2.30.2


> 
> Syscall user would set it pointing to local structure/string/whatnot.
> No freeing is needed there in any case.
> 
> io_uring one would set it to NULL and free the value left there on
> cleanup.  Again, same in all cases, error or no error.  Just make sure
> you have it zeroed *before* any failure exits (including those on req->flags,
> etc.)
> 
> While we are at it, syscall path needs to free the copied xattr contents
> anyway.  So screw freeing anything in that helper (both allocation failures
> and copyin ones); have all freeing done by caller, and make it unconditional
> there.  An error is usually a slow path; an error of that sort - definitely
> so.  IOW,
> 	1) call the helper, copying userland data into the buffers allocated
> by the helper
> 	2) if helper hasn't returned an error, do work
> 	3) free whatever the helper has allocated
> With (3) being unconditional.  It doesn't make any sense to have a separate
> early exit, especially since with your approach you end up paying the price
> on failure exits in the helper anyway.
> 
> 	error = setxattr_copy(...);
> 	if (likely(!error))
> 		error = do_setxattr(...);
> 	kvfree(...);
> 	return error;
> 
> would've been better for the syscall side as well.
