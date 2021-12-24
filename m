Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D9F47EEDC
	for <lists+io-uring@lfdr.de>; Fri, 24 Dec 2021 13:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352695AbhLXMrQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Dec 2021 07:47:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50896 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352686AbhLXMrP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Dec 2021 07:47:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F708B822D0;
        Fri, 24 Dec 2021 12:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CF3C36AE5;
        Fri, 24 Dec 2021 12:47:11 +0000 (UTC)
Date:   Fri, 24 Dec 2021 13:47:07 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org
Subject: Re: [PATCH v8 0/5] io_uring: add xattr support
Message-ID: <20211224124707.le6yeeqmghjhilnx@wittgenstein>
References: <20211223235123.4092764-1-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211223235123.4092764-1-shr@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 23, 2021 at 03:51:18PM -0800, Stefan Roesch wrote:
> This adds the xattr support to io_uring. The intent is to have a more
> complete support for file operations in io_uring.
> 
> This change adds support for the following functions to io_uring:
> - fgetxattr
> - fsetxattr
> - getxattr
> - setxattr
> 
> Patch 1: fs: split off do_user_path_at_empty from user_path_at_empty()
>   This splits off a new function do_user_path_at_empty from
>   user_path_at_empty that is based on filename and not on a
>   user-specified string.
> 
> Patch 2: fs: split off setxattr_copy and do_setxattr function from setxattr
>   Split off the setup part of the setxattr function in the setxattr_copy
>   function. Split off the processing part in do_setxattr.
> 
> Patch 3: fs: split off do_getxattr from getxattr
>   Split of the do_getxattr part from getxattr. This will
>   allow it to be invoked it from io_uring.
> 
> Patch 4: io_uring: add fsetxattr and setxattr support
>   This adds new functions to support the fsetxattr and setxattr
>   functions.
> 
> Patch 5: io_uring: add fgetxattr and getxattr support
>   This adds new functions to support the fgetxattr and getxattr
>   functions.
> 
> 
> There are two additional patches:
>   liburing: Add support for xattr api's.
>             This also includes the tests for the new code.
>   xfstests: Add support for io_uring xattr support.
> 
> 
> V8: - introduce xattr_name struct as advised by Linus
>     - remove kname_sz field in xattr_ctx

I'm fine with the series as is. After this goes in we can cleanup a bit
more in xattr.c as I've mentioned in an earlier thread fairly early on.
The new struct xattr_ctx is quite nice for that, I think.

I would have one last suggestion/question. Can we simply keep the copied
value directly in struct xattr_ctx instead of passing it around
separately? Since we're just moving one argument from struct io_xattr to
struct xattr_ctx nothing changes for io_uring in terms of size:

struct xattr_ctx {
	/* Value of attribute */
	const void __user *value;
+       void *kvalue;
	size_t size;
	/* Attribute name */
	struct xattr_name *kname;
	unsigned int flags;
};

(Ultimately we might want to convert some more helpers to use struct
xattr_ctx instead of separately passing arguments. As part of that
struct xattr_ctx might need to grow an additional size_t ksize argument
specific for kvalue because right now some codepaths can end up changing
the size of kvalue. The way it's done right now is pretty messy because
we just update the size argument. But that's not relevant to get this
basic patchset for io_uring merged. I can take care of that cleanup
after the holidays and once the merge-window closes.)

So on top of what you do right here integrating something like:

From ce2d73d2a5f9820e81f207f2908f74cb11e2660f Mon Sep 17 00:00:00 2001
From: Christian Brauner <christian.brauner@ubuntu.com>
Date: Fri, 24 Dec 2021 13:19:26 +0100
Subject: [PATCH] UNTESTED

---
 fs/internal.h |  6 +++---
 fs/io_uring.c | 19 ++++++++-----------
 fs/xattr.c    | 36 ++++++++++++++----------------------
 3 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 420d0283be12..942b2005a2be 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -213,6 +213,7 @@ struct xattr_name {
 struct xattr_ctx {
 	/* Value of attribute */
 	const void __user *value;
+	void *kvalue;
 	size_t size;
 	/* Attribute name */
 	struct xattr_name *kname;
@@ -226,7 +227,6 @@ ssize_t do_getxattr(struct user_namespace *mnt_userns,
 		    void __user *value,
 		    size_t size);
 
-int setxattr_copy(const char __user *name, struct xattr_ctx *ctx,
-		void **xattr_val);
+int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
 int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
-		struct xattr_ctx *ctx, void *xattr_val);
+		struct xattr_ctx *ctx);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 93a85cefd69a..b9ecece28cf5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -729,7 +729,6 @@ struct io_async_rw {
 struct io_xattr {
 	struct file			*file;
 	struct xattr_ctx		ctx;
-	void				*value;
 	struct filename			*filename;
 };
 
@@ -873,7 +872,7 @@ struct io_kiocb {
 		struct io_symlink	symlink;
 		struct io_hardlink	hardlink;
 		struct io_getdents	getdents;
 		struct io_xattr		xattr;
 	};
 
 	u8				opcode;
@@ -3927,7 +3926,6 @@ static int __io_getxattr_prep(struct io_kiocb *req,
 		return -EBADF;
 
 	ix->filename = NULL;
-	ix->value = NULL;
 	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	ix->ctx.value = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	ix->ctx.size = READ_ONCE(sqe->len);
@@ -4064,7 +4062,7 @@ static int __io_setxattr_prep(struct io_kiocb *req,
 	if (!ix->ctx.kname)
 		return -ENOMEM;
 
-	ret = setxattr_copy(name, &ix->ctx, &ix->value);
+	ret = setxattr_copy(name, &ix->ctx);
 	if (ret) {
 		kfree(ix->ctx.kname);
 		return ret;
@@ -4110,8 +4108,7 @@ static int __io_setxattr(struct io_kiocb *req, unsigned int issue_flags,
 
 	ret = mnt_want_write(path->mnt);
 	if (!ret) {
-		ret = do_setxattr(mnt_user_ns(path->mnt), path->dentry,
-				&ix->ctx, ix->value);
+		ret = do_setxattr(mnt_user_ns(path->mnt), path->dentry, &ix->ctx);
 		mnt_drop_write(path->mnt);
 	}
 
@@ -4131,8 +4128,8 @@ static int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	kfree(ix->ctx.kname);
 
-	if (ix->value)
-		kvfree(ix->value);
+	if (ix->ctx.kvalue)
+		kvfree(ix->ctx.kvalue);
 	if (ret < 0)
 		req_set_fail(req);
 
@@ -4165,8 +4162,8 @@ static int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	kfree(ix->ctx.kname);
 
-	if (ix->value)
-		kvfree(ix->value);
+	if (ix->ctx.kvalue)
+		kvfree(ix->ctx.kvalue);
 	if (ret < 0)
 		req_set_fail(req);
 
@@ -7065,7 +7062,7 @@ static void io_clean_op(struct io_kiocb *req)
 			fallthrough;
 		case IORING_OP_FSETXATTR:
 			kfree(req->xattr.ctx.kname);
-			kvfree(req->xattr.value);
+			kvfree(req->xattr.ctx.kvalue);
 			break;
 		case IORING_OP_GETXATTR:
 			if (req->xattr.filename)
diff --git a/fs/xattr.c b/fs/xattr.c
index 51e305db426f..32f97e58a125 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -542,10 +542,8 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
  * Extended attribute SET operations
  */
 
-int setxattr_copy(const char __user *name, struct xattr_ctx *ctx,
-		void **xattr_val)
+int setxattr_copy(const char __user *name, struct xattr_ctx *ctx)
 {
-	void *kvalue = NULL;
 	int error;
 
 	if (ctx->flags & ~(XATTR_CREATE|XATTR_REPLACE))
@@ -562,39 +560,34 @@ int setxattr_copy(const char __user *name, struct xattr_ctx *ctx,
 		if (ctx->size > XATTR_SIZE_MAX)
 			return -E2BIG;
 
-		kvalue = kvmalloc(ctx->size, GFP_KERNEL);
-		if (!kvalue)
+		ctx->kvalue = kvmalloc(ctx->size, GFP_KERNEL);
+		if (!ctx->kvalue)
 			return -ENOMEM;
 
-		if (copy_from_user(kvalue, ctx->value, ctx->size)) {
-			kvfree(kvalue);
+		if (copy_from_user(ctx->kvalue, ctx->value, ctx->size)) {
+			kvfree(ctx->kvalue);
 			return -EFAULT;
 		}
 	}
 
-	*xattr_val = kvalue;
 	return 0;
 }
 
 static void setxattr_convert(struct user_namespace *mnt_userns,
-			struct xattr_ctx *ctx, void *xattr_value)
+			struct xattr_ctx *ctx)
 {
 	if (ctx->size &&
 		((strcmp(ctx->kname->name, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
 		(strcmp(ctx->kname->name, XATTR_NAME_POSIX_ACL_DEFAULT) == 0)))
-		posix_acl_fix_xattr_from_user(mnt_userns, xattr_value, ctx->size);
+		posix_acl_fix_xattr_from_user(mnt_userns, ctx->kvalue, ctx->size);
 }
 
 int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
-		struct xattr_ctx *ctx, void *xattr_value)
+		struct xattr_ctx *ctx)
 {
-	int error;
-
-	setxattr_convert(mnt_userns, ctx, xattr_value);
-	error = vfs_setxattr(mnt_userns, dentry, ctx->kname->name,
-			xattr_value, ctx->size, ctx->flags);
-
-	return error;
+	setxattr_convert(mnt_userns, ctx);
+	return vfs_setxattr(mnt_userns, dentry, ctx->kname->name,
+			    ctx->kvalue, ctx->size, ctx->flags);
 }
 
 static long
@@ -609,16 +602,15 @@ setxattr(struct user_namespace *mnt_userns, struct dentry *d,
 		.kname    = &kname,
 		.flags    = flags,
 	};
-	void *xattr_value = NULL;
 	int error;
 
-	error = setxattr_copy(name, &ctx, &xattr_value);
+	error = setxattr_copy(name, &ctx);
 	if (error)
 		return error;
 
-	error = do_setxattr(mnt_userns, d, &ctx, xattr_value);
+	error = do_setxattr(mnt_userns, d, &ctx);
 
-	kvfree(xattr_value);
+	kvfree(ctx.kvalue);
 	return error;
 }
 
-- 
2.30.2


