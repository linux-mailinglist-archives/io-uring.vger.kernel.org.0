Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEE6485382
	for <lists+io-uring@lfdr.de>; Wed,  5 Jan 2022 14:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240314AbiAENXM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jan 2022 08:23:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40772 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240316AbiAENW5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jan 2022 08:22:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F62FB81929;
        Wed,  5 Jan 2022 13:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AABC36AE9;
        Wed,  5 Jan 2022 13:22:52 +0000 (UTC)
Date:   Wed, 5 Jan 2022 14:22:49 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org
Subject: Re: [PATCH v11 2/4] fs: split off do_getxattr from getxattr
Message-ID: <20220105132249.p3jwgshoe7lhpna3@wittgenstein>
References: <20220104190936.3085647-1-shr@fb.com>
 <20220104190936.3085647-3-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220104190936.3085647-3-shr@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jan 04, 2022 at 11:09:34AM -0800, Stefan Roesch wrote:
> This splits off do_getxattr function from the getxattr
> function. This will allow io_uring to call it from its
> io worker.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  fs/internal.h |  7 +++++++
>  fs/xattr.c    | 32 ++++++++++++++++++++------------
>  2 files changed, 27 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index 00c98b0cd634..942b2005a2be 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -220,6 +220,13 @@ struct xattr_ctx {
>  	unsigned int flags;
>  };
>  
> +
> +ssize_t do_getxattr(struct user_namespace *mnt_userns,
> +		    struct dentry *d,
> +		    const char *kname,
> +		    void __user *value,
> +		    size_t size);
> +
>  int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
>  int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
>  		struct xattr_ctx *ctx);
> diff --git a/fs/xattr.c b/fs/xattr.c
> index dec7ac3e0e89..7f2b805ed56c 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -675,19 +675,12 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
>  /*
>   * Extended attribute GET operations
>   */
> -static ssize_t
> -getxattr(struct user_namespace *mnt_userns, struct dentry *d,
> -	 const char __user *name, void __user *value, size_t size)
> +ssize_t
> +do_getxattr(struct user_namespace *mnt_userns, struct dentry *d,
> +	const char *kname, void __user *value, size_t size)
>  {
> -	ssize_t error;
>  	void *kvalue = NULL;
> -	char kname[XATTR_NAME_MAX + 1];
> -
> -	error = strncpy_from_user(kname, name, sizeof(kname));
> -	if (error == 0 || error == sizeof(kname))
> -		error = -ERANGE;
> -	if (error < 0)
> -		return error;
> +	ssize_t error;
>  
>  	if (size) {
>  		if (size > XATTR_SIZE_MAX)
> @@ -711,10 +704,25 @@ getxattr(struct user_namespace *mnt_userns, struct dentry *d,
>  	}
>  
>  	kvfree(kvalue);
> -
>  	return error;
>  }
>  
> +static ssize_t
> +getxattr(struct user_namespace *mnt_userns, struct dentry *d,
> +	 const char __user *name, void __user *value, size_t size)
> +{
> +	ssize_t error;
> +	struct xattr_name kname;
> +
> +	error = strncpy_from_user(kname.name, name, sizeof(kname.name));
> +	if (error == 0 || error == sizeof(kname.name))
> +		error = -ERANGE;
> +	if (error < 0)
> +		return error;
> +
> +	return do_getxattr(mnt_userns, d, kname.name, value, size);
> +}

Fwiw, this could have the same signature as do_setxattr(). So sm along
the lines of (completely untested):

Subject: [PATCH] UNTESTED

---
 fs/internal.h |  8 ++------
 fs/xattr.c    | 36 ++++++++++++++++++++++--------------
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 942b2005a2be..d2332496724b 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -220,12 +220,8 @@ struct xattr_ctx {
 	unsigned int flags;
 };
 
-
-ssize_t do_getxattr(struct user_namespace *mnt_userns,
-		    struct dentry *d,
-		    const char *kname,
-		    void __user *value,
-		    size_t size);
+ssize_t do_getxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
+		    struct xattr_ctx *ctx);
 
 int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
 int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
diff --git a/fs/xattr.c b/fs/xattr.c
index 7f2b805ed56c..52bcfe149a9f 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -675,35 +675,34 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 /*
  * Extended attribute GET operations
  */
-ssize_t
-do_getxattr(struct user_namespace *mnt_userns, struct dentry *d,
-	const char *kname, void __user *value, size_t size)
+ssize_t do_getxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
+		    struct xattr_ctx *ctx)
+
 {
-	void *kvalue = NULL;
 	ssize_t error;
+	char *kname = ctx->kname.name;
 
-	if (size) {
-		if (size > XATTR_SIZE_MAX)
-			size = XATTR_SIZE_MAX;
-		kvalue = kvzalloc(size, GFP_KERNEL);
-		if (!kvalue)
+	if (ctx->size) {
+		if (ctx->size > XATTR_SIZE_MAX)
+			ctx->size = XATTR_SIZE_MAX;
+		ctx->kvalue = kvzalloc(ctx->size, GFP_KERNEL);
+		if (!ctx->kvalue)
 			return -ENOMEM;
 	}
 
-	error = vfs_getxattr(mnt_userns, d, kname, kvalue, size);
+	error = vfs_getxattr(mnt_userns, d, kname, ctx->kvalue, ctx->size);
 	if (error > 0) {
 		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
 		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
 			posix_acl_fix_xattr_to_user(mnt_userns, kvalue, error);
-		if (size && copy_to_user(value, kvalue, error))
+		if (ctx->size && copy_to_user(value, kvalue, error))
 			error = -EFAULT;
-	} else if (error == -ERANGE && size >= XATTR_SIZE_MAX) {
+	} else if (error == -ERANGE && ctx->size >= XATTR_SIZE_MAX) {
 		/* The file system tried to returned a value bigger
 		   than XATTR_SIZE_MAX bytes. Not possible. */
 		error = -E2BIG;
 	}
 
-	kvfree(kvalue);
 	return error;
 }
 
@@ -713,6 +712,12 @@ getxattr(struct user_namespace *mnt_userns, struct dentry *d,
 {
 	ssize_t error;
 	struct xattr_name kname;
+	struct xattr_ctx ctx = {
+		.value    = value,
+		.kvalue   = NULL,
+		.size     = size,
+		.kname    = &kname,
+	};
 
 	error = strncpy_from_user(kname.name, name, sizeof(kname.name));
 	if (error == 0 || error == sizeof(kname.name))
@@ -720,7 +725,10 @@ getxattr(struct user_namespace *mnt_userns, struct dentry *d,
 	if (error < 0)
 		return error;
 
-	return do_getxattr(mnt_userns, d, kname.name, value, size);
+	error = do_getxattr(mnt_userns, d, &ctx);
+
+	kvfree(ctx.kvalue);
+	return error;
 }
 
 static ssize_t path_getxattr(const char __user *pathname,
-- 
2.32.0

