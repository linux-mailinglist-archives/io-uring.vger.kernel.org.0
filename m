Return-Path: <io-uring+bounces-3357-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55DFF98CAB3
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 03:23:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 711931C2170A
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 01:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993B679D0;
	Wed,  2 Oct 2024 01:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="BwjfJBE6"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33290B666;
	Wed,  2 Oct 2024 01:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832154; cv=none; b=bmg6oJrorCxBwQMutRpifWlpZuiLwBP2oTrcY1DIc/VTjKsW8Iy5I2erTGB6AsgMw33czakSfVFA2zWJka+tQRTeF2LE05w2JZjC351qnuxo0JB43wbIZJW0aFq3E32NAiiaPD61d9FLZg/dN8mug9dJipjeOKOvznDoaIVP8a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832154; c=relaxed/simple;
	bh=bO29qYIKUmAWtU9x8C4mT/xTRvzYTVcFJX7e3m+sSZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tt7tTolmS+dQXFXyhlZg5WsX85zPYGu1UVy2EV19/StEa0PTfCIkbVgRZMWbeQwrqWwthE2w9Db47XQCWYTZZhIWjijkMSFh+iVz5z15c2wscIj8isEfo+szytKGktzUEUYpc1+aPOP+V9rT1IBihwpQdObPYuBBooP0QovVLbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=BwjfJBE6; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hiUGDWGTezfrBN4XzYAYFGCx6wv0AV4FV5hhTU1DsOg=; b=BwjfJBE6cNGeLbxpmNa/kHhLX7
	djaaseT1q51cOLCwmFckGQ9/L0LRZ1K5wZLprGWu7uqW5UzmFsP2ChH/0o6arOm8Xptfzt/l7oH6c
	S1hFHZKULrbKpFnHZwmSqqLIO00p6KIfHW80SKBjSdl/SZcNe8ZJZE37+/5iQQpEz6qNHnMrbrsZs
	JOAY1cjbLVv3ypzlAp8cnCeGObTd5Tzk9FSPnp8b4MDqHIzAzltGrb4hT+pJCHC0vKHhM4eE9H+HE
	KHO05Z8xoPY+LMYV5ZMZ/gtmc5PjwXPvv1zwNJQAI+9Xij+/Hlgny2U9iEU56E6oXPnFNJIs5wCBH
	kZl2Gi9g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svo4U-0000000HW0W-3CQL;
	Wed, 02 Oct 2024 01:22:30 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: brauner@kernel.org,
	io-uring@vger.kernel.org,
	cgzones@googlemail.com
Subject: [PATCH 6/9] replace do_getxattr() with saner helpers.
Date: Wed,  2 Oct 2024 02:22:27 +0100
Message-ID: <20241002012230.4174585-6-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

similar to do_setxattr() in the previous commit...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/internal.h    |  8 ++---
 fs/xattr.c       | 87 ++++++++++++++++++++++++++++--------------------
 io_uring/xattr.c | 22 ++----------
 3 files changed, 56 insertions(+), 61 deletions(-)

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
index 6326a1ea28e9..a0e304c65d51 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -743,27 +743,28 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
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
@@ -771,52 +772,55 @@ do_getxattr(struct mnt_idmap *idmap, struct dentry *d,
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
@@ -832,13 +836,22 @@ SYSCALL_DEFINE4(lgetxattr, const char __user *, pathname,
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
index 7f6bbfd846b9..0eaeaed39649 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -54,7 +54,7 @@ static int __io_getxattr_prep(struct io_kiocb *req,
 	ix->filename = NULL;
 	ix->ctx.kvalue = NULL;
 	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	ix->ctx.cvalue = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	ix->ctx.value = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	ix->ctx.size = READ_ONCE(sqe->len);
 	ix->ctx.flags = READ_ONCE(sqe->xattr_flags);
 
@@ -109,10 +109,7 @@ int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = do_getxattr(file_mnt_idmap(req->file),
-			req->file->f_path.dentry,
-			&ix->ctx);
-
+	ret = file_getxattr(req->file, &ix->ctx);
 	io_xattr_finish(req, ret);
 	return IOU_OK;
 }
@@ -120,24 +117,11 @@ int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
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
 	io_xattr_finish(req, ret);
 	return IOU_OK;
 }
-- 
2.39.5


