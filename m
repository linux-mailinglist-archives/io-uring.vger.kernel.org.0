Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE5D481438
	for <lists+io-uring@lfdr.de>; Wed, 29 Dec 2021 15:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240361AbhL2OsK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 09:48:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56024 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236856AbhL2OsJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 09:48:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8BD3614F0;
        Wed, 29 Dec 2021 14:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5786CC36AE7;
        Wed, 29 Dec 2021 14:48:06 +0000 (UTC)
Date:   Wed, 29 Dec 2021 15:48:02 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org
Subject: Re: [PATCH v9 2/5] fs: split off setxattr_copy and do_setxattr
 function from setxattr
Message-ID: <20211229144802.udabxntfvcsxlnii@wittgenstein>
References: <20211228184145.1131605-1-shr@fb.com>
 <20211228184145.1131605-3-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211228184145.1131605-3-shr@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 28, 2021 at 10:41:42AM -0800, Stefan Roesch wrote:
> This splits of the setup part of the function
> setxattr in its own dedicated function called
> setxattr_copy. In addition it also exposes a
> new function called do_setxattr for making the
> setxattr call.
> 
> This makes it possible to call these two functions
> from io_uring in the processing of an xattr request.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---

(One completely optional thing below.)

Looks good,
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

>  fs/internal.h | 21 +++++++++++++
>  fs/xattr.c    | 82 ++++++++++++++++++++++++++++++++++++---------------
>  2 files changed, 80 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index 432ea3ce76ec..00c98b0cd634 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -202,3 +202,24 @@ struct linux_dirent64;
>  
>  int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
>  		 unsigned int count, loff_t *pos);
> +
> + /*
> +  * fs/xattr.c:
> +  */
> +struct xattr_name {
> +	char name[XATTR_NAME_MAX + 1];
> +};

Fwiw, one additional idea is to implement this similar to struct
filename and have it keep the __user name together with the kernel name:

struct xattr_name {
	const __user char	*uname;	/* original userland pointer */
	char name[XATTR_NAME_MAX + 1];
};

and then sm like:

From 3d85d31eb65f007e48e838fce776f16811732fc0 Mon Sep 17 00:00:00 2001
From: Christian Brauner <christian.brauner@ubuntu.com>
Date: Wed, 29 Dec 2021 15:43:46 +0100
Subject: [PATCH] UNTESTED

---
 fs/internal.h |  3 ++-
 fs/io_uring.c | 18 ++++++++----------
 fs/xattr.c    | 20 +++++++++++---------
 3 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 942b2005a2be..bb97042ebd04 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -207,7 +207,8 @@ int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
   * fs/xattr.c:
   */
 struct xattr_name {
-	char name[XATTR_NAME_MAX + 1];
+	const char __user *uname;
+	char kname[XATTR_NAME_MAX + 1];
 };
 
 struct xattr_ctx {
diff --git a/fs/io_uring.c b/fs/io_uring.c
index c88916b8cccc..55ad854d3c64 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3916,7 +3916,6 @@ static int __io_getxattr_prep(struct io_kiocb *req,
 			      const struct io_uring_sqe *sqe)
 {
 	struct io_xattr *ix = &req->xattr;
-	const char __user *name;
 	int ret;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
@@ -3928,7 +3927,7 @@ static int __io_getxattr_prep(struct io_kiocb *req,
 
 	ix->filename = NULL;
 	ix->ctx.kvalue = NULL;
-	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	ix->ctx.name = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	ix->ctx.value = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	ix->ctx.size = READ_ONCE(sqe->len);
 	ix->ctx.flags = READ_ONCE(sqe->xattr_flags);
@@ -3940,9 +3939,9 @@ static int __io_getxattr_prep(struct io_kiocb *req,
 	if (!ix->ctx.kname)
 		return -ENOMEM;
 
-	ret = strncpy_from_user(ix->ctx.kname->name, name,
-				sizeof(ix->ctx.kname->name));
-	if (!ret || ret == sizeof(ix->ctx.kname->name))
+	ret = strncpy_from_user(ix->ctx.kname->kname, ix->ctx.name,
+				sizeof(ix->ctx.kname->kname));
+	if (!ret || ret == sizeof(ix->ctx.kname->kname))
 		ret = -ERANGE;
 	if (ret < 0) {
 		kfree(ix->ctx.kname);
@@ -3991,7 +3990,7 @@ static int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = do_getxattr(mnt_user_ns(req->file->f_path.mnt),
 			req->file->f_path.dentry,
-			ix->ctx.kname->name,
+			ix->ctx.kname->kname,
 			(void __user *)ix->ctx.value,
 			ix->ctx.size);
 
@@ -4019,7 +4018,7 @@ static int io_getxattr(struct io_kiocb *req, unsigned int issue_flags)
 	if (!ret) {
 		ret = do_getxattr(mnt_user_ns(path.mnt),
 				path.dentry,
-				ix->ctx.kname->name,
+				ix->ctx.kname->kname,
 				(void __user *)ix->ctx.value,
 				ix->ctx.size);
 
@@ -4044,7 +4043,6 @@ static int __io_setxattr_prep(struct io_kiocb *req,
 			const struct io_uring_sqe *sqe)
 {
 	struct io_xattr *ix = &req->xattr;
-	const char __user *name;
 	int ret;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
@@ -4055,7 +4053,7 @@ static int __io_setxattr_prep(struct io_kiocb *req,
 		return -EBADF;
 
 	ix->filename = NULL;
-	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	ix->ctx.name = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	ix->ctx.value = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	ix->ctx.kvalue = NULL;
 	ix->ctx.size = READ_ONCE(sqe->len);
@@ -4065,7 +4063,7 @@ static int __io_setxattr_prep(struct io_kiocb *req,
 	if (!ix->ctx.kname)
 		return -ENOMEM;
 
-	ret = setxattr_copy(name, &ix->ctx);
+	ret = setxattr_copy(&ix->ctx);
 	if (ret) {
 		kfree(ix->ctx.kname);
 		return ret;
diff --git a/fs/xattr.c b/fs/xattr.c
index 3b6d683d07b9..27c64bb0ca65 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -542,16 +542,16 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
  * Extended attribute SET operations
  */
 
-int setxattr_copy(const char __user *name, struct xattr_ctx *ctx)
+int setxattr_copy(struct xattr_ctx *ctx)
 {
 	int error;
 
 	if (ctx->flags & ~(XATTR_CREATE|XATTR_REPLACE))
 		return -EINVAL;
 
-	error = strncpy_from_user(ctx->kname->name, name,
-				sizeof(ctx->kname->name));
-	if (error == 0 || error == sizeof(ctx->kname->name))
+	error = strncpy_from_user(ctx->kname->kname, ctx->kname->name,
+				sizeof(ctx->kname->kname));
+	if (error == 0 || error == sizeof(ctx->kname->kname))
 		return  -ERANGE;
 	if (error < 0)
 		return error;
@@ -577,8 +577,8 @@ static void setxattr_convert(struct user_namespace *mnt_userns,
 			struct xattr_ctx *ctx)
 {
 	if (ctx->size &&
-		((strcmp(ctx->kname->name, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
-		(strcmp(ctx->kname->name, XATTR_NAME_POSIX_ACL_DEFAULT) == 0)))
+		((strcmp(ctx->kname->kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
+		(strcmp(ctx->kname->kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0)))
 		posix_acl_fix_xattr_from_user(mnt_userns, ctx->kvalue, ctx->size);
 }
 
@@ -586,7 +586,7 @@ int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 		struct xattr_ctx *ctx)
 {
 	setxattr_convert(mnt_userns, ctx);
-	return vfs_setxattr(mnt_userns, dentry, ctx->kname->name,
+	return vfs_setxattr(mnt_userns, dentry, ctx->kname->kname,
 			ctx->kvalue, ctx->size, ctx->flags);
 }
 
@@ -595,7 +595,9 @@ setxattr(struct user_namespace *mnt_userns, struct dentry *d,
 	const char __user *name, const void __user *value, size_t size,
 	int flags)
 {
-	struct xattr_name kname;
+	struct xattr_name kname = {
+		.uname = name;
+	};
 	struct xattr_ctx ctx = {
 		.value    = value,
 		.kvalue   = NULL,
@@ -605,7 +607,7 @@ setxattr(struct user_namespace *mnt_userns, struct dentry *d,
 	};
 	int error;
 
-	error = setxattr_copy(name, &ctx);
+	error = setxattr_copy(&ctx);
 	if (error)
 		return error;
 
-- 
2.30.2

