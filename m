Return-Path: <io-uring+bounces-4349-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8138B9B9DA6
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 08:32:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1080C1F223B6
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 07:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF22415A87C;
	Sat,  2 Nov 2024 07:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="jL0gX63+"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B5014B965;
	Sat,  2 Nov 2024 07:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730532713; cv=none; b=SdIE13G5Doq+m1n4n9W2s+9ftdxSQ5vSRvh12XKh5DVXJm7ZLC4vysnLpVw1b3wzgSw2UBUK3AG2N2uW3+43sjIyZWF5UfmZtvVKE4s9EjVe0vhUbC6jr4lKJC5Qp0dz651sEzYJdVoUJ3uRRkVXtriX912dIFKZEOHAD4k42c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730532713; c=relaxed/simple;
	bh=Q0bq6g1WYuRXDA29tV5jeRWut8wFRc32lj0esrOc7VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlVH9Oj6++w0VgadQnF5M0iXXGYjZwjIK2ytblFmeAS3wN5GmBYhQFrWh3wYv7I9v3mPKR2+593RmuEL7vKOinMxBir7ZMLkXZDepw//6IYHIrMDlyX9Z0hIBcQelgeRpRt08q4udXKGAt0k1YmfGME5jEruVa7kmMDadA4s6aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=jL0gX63+; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RLdqrzxshGAwc4Fl6p/LGqqBkZF/ZdDToNXKS8zEB5E=; b=jL0gX63+PqNfNWrSY4EO4DedV0
	Wjb83E2bpqXgfSK/3j+KKusWfAbfLC1awX/hEaBvUGEPjlHI+VUVMM1pm7UU/mhovnz26dgoxameq
	Mtfk1GwSIGhEKJQmXbIivxpNas7yqqJe/K9PrO2ajw3iVxXMOgJC9L3AeUkBCT/2pNS6v/ElN8SdH
	/eCaXhk0OSn/qKflumNlBNbtQ4xEYENlPBhzpvrMpJJooBXduvzTonsiSwLyzdfmS8I9gQzs/3jN3
	CVpnXosFZbMVfu3/UDV6P09V+KOnp+9c32FRTrOMA56vPWeA7vzimyUng7kSU1kmUcoBBPvnQWJNO
	+mHtYXfA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t78bu-0000000AJFe-0zIV;
	Sat, 02 Nov 2024 07:31:50 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	io-uring@vger.kernel.org,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: [PATCH v2 09/13] replace do_getxattr() with saner helpers.
Date: Sat,  2 Nov 2024 07:31:45 +0000
Message-ID: <20241102073149.2457240-9-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241102073149.2457240-1-viro@zeniv.linux.org.uk>
References: <20241102072834.GQ1350452@ZenIV>
 <20241102073149.2457240-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

similar to do_setxattr() in the previous commit...

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/internal.h    |  8 ++---
 fs/xattr.c       | 88 ++++++++++++++++++++++++++++--------------------
 io_uring/xattr.c | 31 ++++-------------
 3 files changed, 61 insertions(+), 66 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index be7c0da3bcec..8001efd1f047 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -280,11 +280,9 @@ struct kernel_xattr_ctx {
 	unsigned int flags;
 };
 
-
-ssize_t do_getxattr(struct mnt_idmap *idmap,
-		    struct dentry *d,
-		    struct kernel_xattr_ctx *ctx);
-
+ssize_t file_getxattr(struct file *file, struct kernel_xattr_ctx *ctx);
+ssize_t filename_getxattr(int dfd, struct filename *filename,
+			  unsigned int lookup_flags, struct kernel_xattr_ctx *ctx);
 int file_setxattr(struct file *file, struct kernel_xattr_ctx *ctx);
 int filename_setxattr(int dfd, struct filename *filename,
 		      unsigned int lookup_flags, struct kernel_xattr_ctx *ctx);
diff --git a/fs/xattr.c b/fs/xattr.c
index 38bf8cfbd464..d55f3d1e7589 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -744,27 +744,28 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 /*
  * Extended attribute GET operations
  */
-ssize_t
+static ssize_t
 do_getxattr(struct mnt_idmap *idmap, struct dentry *d,
 	struct kernel_xattr_ctx *ctx)
 {
 	ssize_t error;
 	char *kname = ctx->kname->name;
+	void *kvalue = NULL;
 
 	if (ctx->size) {
 		if (ctx->size > XATTR_SIZE_MAX)
 			ctx->size = XATTR_SIZE_MAX;
-		ctx->kvalue = kvzalloc(ctx->size, GFP_KERNEL);
-		if (!ctx->kvalue)
+		kvalue = kvzalloc(ctx->size, GFP_KERNEL);
+		if (!kvalue)
 			return -ENOMEM;
 	}
 
-	if (is_posix_acl_xattr(ctx->kname->name))
-		error = do_get_acl(idmap, d, kname, ctx->kvalue, ctx->size);
+	if (is_posix_acl_xattr(kname))
+		error = do_get_acl(idmap, d, kname, kvalue, ctx->size);
 	else
-		error = vfs_getxattr(idmap, d, kname, ctx->kvalue, ctx->size);
+		error = vfs_getxattr(idmap, d, kname, kvalue, ctx->size);
 	if (error > 0) {
-		if (ctx->size && copy_to_user(ctx->value, ctx->kvalue, error))
+		if (ctx->size && copy_to_user(ctx->value, kvalue, error))
 			error = -EFAULT;
 	} else if (error == -ERANGE && ctx->size >= XATTR_SIZE_MAX) {
 		/* The file system tried to returned a value bigger
@@ -772,52 +773,56 @@ do_getxattr(struct mnt_idmap *idmap, struct dentry *d,
 		error = -E2BIG;
 	}
 
+	kvfree(kvalue);
 	return error;
 }
 
-static ssize_t
-getxattr(struct mnt_idmap *idmap, struct dentry *d,
-	 const char __user *name, void __user *value, size_t size)
+ssize_t file_getxattr(struct file *f, struct kernel_xattr_ctx *ctx)
 {
-	ssize_t error;
-	struct xattr_name kname;
-	struct kernel_xattr_ctx ctx = {
-		.value    = value,
-		.kvalue   = NULL,
-		.size     = size,
-		.kname    = &kname,
-		.flags    = 0,
-	};
-
-	error = import_xattr_name(&kname, name);
-	if (error)
-		return error;
-
-	error =  do_getxattr(idmap, d, &ctx);
-
-	kvfree(ctx.kvalue);
-	return error;
+	audit_file(f);
+	return do_getxattr(file_mnt_idmap(f), f->f_path.dentry, ctx);
 }
 
-static ssize_t path_getxattr(const char __user *pathname,
-			     const char __user *name, void __user *value,
-			     size_t size, unsigned int lookup_flags)
+/* unconditionally consumes filename */
+ssize_t filename_getxattr(int dfd, struct filename *filename,
+			  unsigned int lookup_flags, struct kernel_xattr_ctx *ctx)
 {
 	struct path path;
 	ssize_t error;
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
-		return error;
-	error = getxattr(mnt_idmap(path.mnt), path.dentry, name, value, size);
+		goto out;
+	error = do_getxattr(mnt_idmap(path.mnt), path.dentry, ctx);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+out:
+	putname(filename);
 	return error;
 }
 
+static ssize_t path_getxattr(const char __user *pathname,
+			     const char __user *name, void __user *value,
+			     size_t size, unsigned int lookup_flags)
+{
+	ssize_t error;
+	struct xattr_name kname;
+	struct kernel_xattr_ctx ctx = {
+		.value    = value,
+		.size     = size,
+		.kname    = &kname,
+		.flags    = 0,
+	};
+
+	error = import_xattr_name(&kname, name);
+	if (error)
+		return error;
+	return filename_getxattr(AT_FDCWD, getname(pathname), lookup_flags, &ctx);
+}
+
 SYSCALL_DEFINE4(getxattr, const char __user *, pathname,
 		const char __user *, name, void __user *, value, size_t, size)
 {
@@ -833,13 +838,22 @@ SYSCALL_DEFINE4(lgetxattr, const char __user *, pathname,
 SYSCALL_DEFINE4(fgetxattr, int, fd, const char __user *, name,
 		void __user *, value, size_t, size)
 {
+	ssize_t error;
+	struct xattr_name kname;
+	struct kernel_xattr_ctx ctx = {
+		.value    = value,
+		.size     = size,
+		.kname    = &kname,
+		.flags    = 0,
+	};
 	CLASS(fd, f)(fd);
 
 	if (fd_empty(f))
 		return -EBADF;
-	audit_file(fd_file(f));
-	return getxattr(file_mnt_idmap(fd_file(f)), fd_file(f)->f_path.dentry,
-			 name, value, size);
+	error = import_xattr_name(&kname, name);
+	if (error)
+		return error;
+	return file_getxattr(fd_file(f), &ctx);
 }
 
 /*
diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index 2671ad05d63b..de5064fcae8a 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -51,7 +51,7 @@ static int __io_getxattr_prep(struct io_kiocb *req,
 	ix->filename = NULL;
 	ix->ctx.kvalue = NULL;
 	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	ix->ctx.cvalue = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	ix->ctx.value = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	ix->ctx.size = READ_ONCE(sqe->len);
 	ix->ctx.flags = READ_ONCE(sqe->xattr_flags);
 
@@ -94,12 +94,10 @@ int io_getxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	path = u64_to_user_ptr(READ_ONCE(sqe->addr3));
 
 	ix->filename = getname(path);
-	if (IS_ERR(ix->filename)) {
-		ret = PTR_ERR(ix->filename);
-		ix->filename = NULL;
-	}
+	if (IS_ERR(ix->filename))
+		return PTR_ERR(ix->filename);
 
-	return ret;
+	return 0;
 }
 
 int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
@@ -109,10 +107,7 @@ int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = do_getxattr(file_mnt_idmap(req->file),
-			req->file->f_path.dentry,
-			&ix->ctx);
-
+	ret = file_getxattr(req->file, &ix->ctx);
 	io_xattr_finish(req, ret);
 	return IOU_OK;
 }
@@ -120,24 +115,12 @@ int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
 int io_getxattr(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
-	unsigned int lookup_flags = LOOKUP_FOLLOW;
-	struct path path;
 	int ret;
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-retry:
-	ret = filename_lookup(AT_FDCWD, ix->filename, lookup_flags, &path, NULL);
-	if (!ret) {
-		ret = do_getxattr(mnt_idmap(path.mnt), path.dentry, &ix->ctx);
-
-		path_put(&path);
-		if (retry_estale(ret, lookup_flags)) {
-			lookup_flags |= LOOKUP_REVAL;
-			goto retry;
-		}
-	}
-
+	ret = filename_getxattr(AT_FDCWD, ix->filename, LOOKUP_FOLLOW, &ix->ctx);
+	ix->filename = NULL;
 	io_xattr_finish(req, ret);
 	return IOU_OK;
 }
-- 
2.39.5


