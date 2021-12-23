Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E265747E51E
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 15:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbhLWOwK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 09:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbhLWOwJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 09:52:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406A5C061401;
        Thu, 23 Dec 2021 06:52:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCA2EB820E8;
        Thu, 23 Dec 2021 14:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEED0C36AE9;
        Thu, 23 Dec 2021 14:52:04 +0000 (UTC)
Date:   Thu, 23 Dec 2021 15:52:01 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org
Subject: Re: [PATCH v6 4/5] io_uring: add fsetxattr and setxattr support
Message-ID: <20211223145201.4jfjt6wv2dxmai5x@wittgenstein>
References: <20211222210127.958902-1-shr@fb.com>
 <20211222210127.958902-5-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211222210127.958902-5-shr@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 22, 2021 at 01:01:26PM -0800, Stefan Roesch wrote:
> This adds support to io_uring for the fsetxattr and setxattr API.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/io_uring.c                 | 170 ++++++++++++++++++++++++++++++++++
>  include/uapi/linux/io_uring.h |   6 +-
>  2 files changed, 175 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c8258c784116..8b6c70d6cacc 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -82,6 +82,7 @@
>  #include <linux/audit.h>
>  #include <linux/security.h>
>  #include <linux/atomic-ref.h>
> +#include <linux/xattr.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/io_uring.h>
> @@ -726,6 +727,13 @@ struct io_async_rw {
>  	struct wait_page_queue		wpq;
>  };
>  
> +struct io_xattr {
> +	struct file			*file;
> +	struct xattr_ctx		ctx;
> +	void				*value;
> +	struct filename			*filename;
> +};
> +
>  enum {
>  	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
>  	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
> @@ -866,6 +874,7 @@ struct io_kiocb {
>  		struct io_symlink	symlink;
>  		struct io_hardlink	hardlink;
>  		struct io_getdents	getdents;
> +		struct io_xattr		xattr;
>  	};
>  
>  	u8				opcode;
> @@ -1118,6 +1127,10 @@ static const struct io_op_def io_op_defs[] = {
>  	[IORING_OP_GETDENTS] = {
>  		.needs_file		= 1,
>  	},
> +	[IORING_OP_FSETXATTR] = {
> +		.needs_file = 1
> +	},
> +	[IORING_OP_SETXATTR] = {},
>  };
>  
>  /* requests with any of those set should undergo io_disarm_next() */
> @@ -3887,6 +3900,144 @@ static int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
>  	return 0;
>  }
>  
> +static int __io_setxattr_prep(struct io_kiocb *req,
> +			const struct io_uring_sqe *sqe,
> +			struct user_namespace *user_ns)
> +{
> +	struct io_xattr *ix = &req->xattr;
> +	const char __user *name;
> +	void *ret;
> +
> +	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
> +		return -EINVAL;
> +	if (unlikely(sqe->ioprio))
> +		return -EINVAL;
> +	if (unlikely(req->flags & REQ_F_FIXED_FILE))
> +		return -EBADF;
> +
> +	ix->filename = NULL;
> +	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	ix->ctx.value = u64_to_user_ptr(READ_ONCE(sqe->addr2));
> +	ix->ctx.size = READ_ONCE(sqe->len);
> +	ix->ctx.flags = READ_ONCE(sqe->xattr_flags);
> +
> +	ix->ctx.kname = kmalloc(XATTR_NAME_MAX + 1, GFP_KERNEL);
> +	if (!ix->ctx.kname)
> +		return -ENOMEM;
> +	ix->ctx.kname_sz = XATTR_NAME_MAX + 1;
> +
> +	ret = setxattr_setup(user_ns, name, &ix->ctx);

Looking at this a bit closer, the setxattr_setup() function converts the
vfs caps prior to vfs_setxattr(). That shouldn't be done there though.
The conversion should be done when mnt_want_write() is held in
__io_setxattr() exactly how we do for setxattr()-based calls in
fs/xattr.c. This will guard against changes of relevant mount properties
(current or future). It will also allow you to simplify your
setxattr_setup() function a bit and you don't need to retrieve the
mount's idmapping until __io_setxattr().

Right now you're splitting updating the xattrs over the prep and commit
stage and I worry that in fully async contexts this is easy to miss. So
I'd rather do it in one place. Since we can't move it all into
vfs_setxattr() similar to what we did for fscaps because it's used in a
bunch of contexts where the conversion isn't wanted we should simply
expose do_setxattr() similar to do_getxattr() you're adding.

So on top of your current patchset I'd suggest you do something like the
following (completely untested):

From 6bcd3efc3293bb91599ee73272262ac596ab4608 Mon Sep 17 00:00:00 2001
From: Christian Brauner <christian.brauner@ubuntu.com>
Date: Thu, 23 Dec 2021 15:23:14 +0100
Subject: [PATCH] UNTESTED

---
 fs/internal.h |  8 +++++---
 fs/io_uring.c | 21 +++++++++-----------
 fs/xattr.c    | 55 ++++++++++++++++++++++++++++++++++-----------------
 3 files changed, 51 insertions(+), 33 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index ea0433799dbc..08259fa98b2e 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -222,6 +222,8 @@ ssize_t do_getxattr(struct user_namespace *mnt_userns,
 		    void __user *value,
 		    size_t size);
 
-void *setxattr_setup(struct user_namespace *mnt_userns,
-		     const char __user *name,
-		     struct xattr_ctx *ctx);
+int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
+		struct xattr_ctx *ctx, void *xattr_val);
+
+int setxattr_copy(const char __user *name, struct xattr_ctx *ctx,
+		  void **xattr_val);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5dd01f19d915..c910c29e1632 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4040,12 +4040,11 @@ static int io_getxattr(struct io_kiocb *req, unsigned int issue_flags)
 }
 
 static int __io_setxattr_prep(struct io_kiocb *req,
-			const struct io_uring_sqe *sqe,
-			struct user_namespace *user_ns)
+			const struct io_uring_sqe *sqe)
 {
 	struct io_xattr *ix = &req->xattr;
 	const char __user *name;
-	void *ret;
+	int ret;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4065,13 +4064,12 @@ static int __io_setxattr_prep(struct io_kiocb *req,
 		return -ENOMEM;
 	ix->ctx.kname_sz = XATTR_NAME_MAX + 1;
 
-	ret = setxattr_setup(user_ns, name, &ix->ctx);
-	if (IS_ERR(ret)) {
+	ret = setxattr_copy(name, &ix->ctx, &ix->value);
+	if (ret) {
 		kfree(ix->ctx.kname);
-		return PTR_ERR(ret);
+		return ret;
 	}
 
-	ix->value = ret;
 	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
@@ -4083,7 +4081,7 @@ static int io_setxattr_prep(struct io_kiocb *req,
 	const char __user *path;
 	int ret;
 
-	ret = __io_setxattr_prep(req, sqe, current_user_ns());
+	ret = __io_setxattr_prep(req, sqe);
 	if (ret)
 		return ret;
 
@@ -4101,7 +4099,7 @@ static int io_setxattr_prep(struct io_kiocb *req,
 static int io_fsetxattr_prep(struct io_kiocb *req,
 			const struct io_uring_sqe *sqe)
 {
-	return __io_setxattr_prep(req, sqe, file_mnt_user_ns(req->file));
+	return __io_setxattr_prep(req, sqe);
 }
 
 static int __io_setxattr(struct io_kiocb *req, unsigned int issue_flags,
@@ -4112,9 +4110,8 @@ static int __io_setxattr(struct io_kiocb *req, unsigned int issue_flags,
 
 	ret = mnt_want_write(path->mnt);
 	if (!ret) {
-		ret = vfs_setxattr(mnt_user_ns(path->mnt), path->dentry,
-				ix->ctx.kname, ix->value, ix->ctx.size,
-				ix->ctx.flags);
+		ret = do_setxattr(mnt_user_ns(path->mnt), path->dentry,
+				  &ix->ctx, ix->value);
 		mnt_drop_write(path->mnt);
 	}
 
diff --git a/fs/xattr.c b/fs/xattr.c
index a675c7f0ea0c..03a44c5895d1 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -542,40 +542,59 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
  * Extended attribute SET operations
  */
 
-void *setxattr_setup(struct user_namespace *mnt_userns, const char __user *name,
-		struct xattr_ctx *ctx)
+int setxattr_copy(const char __user *name, struct xattr_ctx *ctx,
+		  void **xattr_val)
 {
 	void *kvalue = NULL;
 	int error;
 
 	if (ctx->flags & ~(XATTR_CREATE|XATTR_REPLACE))
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	error = strncpy_from_user(ctx->kname, name, ctx->kname_sz);
 	if (error == 0 || error == ctx->kname_sz)
-		return  ERR_PTR(-ERANGE);
+		return  -ERANGE;
 	if (error < 0)
-		return ERR_PTR(error);
+		return error;
 
 	if (ctx->size) {
 		if (ctx->size > XATTR_SIZE_MAX)
-			return ERR_PTR(-E2BIG);
+			return -E2BIG;
 
 		kvalue = kvmalloc(ctx->size, GFP_KERNEL);
 		if (!kvalue)
-			return ERR_PTR(-ENOMEM);
+			return -ENOMEM;
 
 		if (copy_from_user(kvalue, ctx->value, ctx->size)) {
 			kvfree(kvalue);
-			return ERR_PTR(-EFAULT);
+			return -EFAULT;
 		}
-
-		if ((strcmp(ctx->kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
-		    (strcmp(ctx->kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_from_user(mnt_userns, kvalue, ctx->size);
 	}
 
-	return kvalue;
+	*xattr_val = kvalue;
+	return 0;
+}
+
+static void setxattr_convert(struct user_namespace *mnt_userns,
+			     struct xattr_ctx *ctx, void *kvalue)
+{
+	if (ctx->size &&
+	    ((strcmp(ctx->kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
+	     (strcmp(ctx->kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0)))
+		posix_acl_fix_xattr_from_user(mnt_userns, kvalue, ctx->size);
+}
+
+int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
+		struct xattr_ctx *ctx, void *xattr_val)
+{
+	void *kvalue = NULL;
+	int error;
+
+	setxattr_convert(mnt_userns, ctx, kvalue);
+	error = vfs_setxattr(mnt_userns, dentry, ctx->kname,
+			     kvalue, ctx->size, ctx->flags);
+	kvfree(kvalue);
+	return error;
 }
 
 static long
@@ -591,14 +610,14 @@ setxattr(struct user_namespace *mnt_userns, struct dentry *d,
 		.kname_sz = sizeof(kname),
 		.flags    = flags,
 	};
-	void *kvalue;
+	void *kvalue = NULL;
 	int error;
 
-	kvalue = setxattr_setup(mnt_userns, name, &ctx);
-	if (IS_ERR(kvalue))
-		return PTR_ERR(kvalue);
+	error = setxattr_copy(name, &ctx, &kvalue);
+	if (error)
+		return error;
 
-	error = vfs_setxattr(mnt_userns, d, kname, kvalue, size, flags);
+	error = do_setxattr(mnt_userns, d, &ctx, kvalue);
 
 	kvfree(kvalue);
 	return error;
-- 
2.30.2

