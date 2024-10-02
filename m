Return-Path: <io-uring+bounces-3360-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10DFF98CABA
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 03:23:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C4D01F26BE3
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 01:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7FE10A3E;
	Wed,  2 Oct 2024 01:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="BDSI127M"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140FC9475;
	Wed,  2 Oct 2024 01:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832155; cv=none; b=bIusIcYTKi29G4LEGua7znDcflWajvGkSGig+Z4qPh0zut0yMfYWKKQGTGD8/DYF7l91XvUoJShosmR80AczglFFhZdh9uot5w/bX1x+wKxzRWrWT86VHJJUNYIn9fJ4yeRyj2Ls0U1rnBnQVnggw2ZKt4pAWWgk7PD+yOr+qyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832155; c=relaxed/simple;
	bh=XtkxNFlzMcN60nLZXGyHQK9m1nCmZ2Em9nhZWDimLMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ew81CfR98n7b4mr/Rke2/doSR4PMi8S/u/v3aukkdPFD5AZkgPJoccBAw9RIEU3It+lX+dNLNGBEYm3Y2nMVfajlJWlTAYcjAVf8B6uj5WEWhE/IQLV1JI32fygCK86rdoiZ/LPrWPj+x84AW9WB45Kq13/AFdsmhMqA3VxY7dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=BDSI127M; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MUCkAroewEGiX5jQBsx3C0g+/ee/jcxLR3LB+g9sTJs=; b=BDSI127MIaxGUGYNmAWveSpQJZ
	mzRKzx0W34KgR9qYHkdjYibKindXvzJOLMKIw1buDku0YAhRn1fxnweT1VqszNHq91fNn+IzBkQ0/
	7GQMwUY4VtjLTI+XNcb7w+qZyAP9x0B3ginsGMdVX/B4bJAaoYLlDB3d81Q6HJ92G7LLdiAmWFAo+
	MkYK5c3d9BpXRBRjnWWZo++x4nW9a8AdUZ93Td0fHJ0gqBba93zgRhS1kAS5mbRF31/XOlFgy1L3Z
	MpHd+GzHq/1lhdrJXHxTdzXjzreWm81Py6t+iOmrfC8xvDpfjW9R83V+YOWl72NQpw2881/G2Sq9i
	m1IFRt2Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svo4U-0000000HW0Q-2f4a;
	Wed, 02 Oct 2024 01:22:30 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: brauner@kernel.org,
	io-uring@vger.kernel.org,
	cgzones@googlemail.com
Subject: [PATCH 5/9] replace do_setxattr() with saner helpers.
Date: Wed,  2 Oct 2024 02:22:26 +0100
Message-ID: <20241002012230.4174585-5-viro@zeniv.linux.org.uk>
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

io_uring setxattr logics duplicates stuff from fs/xattr.c; provide
saner helpers (filename_setxattr() and file_setxattr() resp.) and
use them.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/internal.h    |  6 ++---
 fs/xattr.c       | 68 ++++++++++++++++++++++++++++++------------------
 io_uring/xattr.c | 32 +++--------------------
 3 files changed, 49 insertions(+), 57 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index b9f5ac4d39fc..be7c0da3bcec 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -285,10 +285,10 @@ ssize_t do_getxattr(struct mnt_idmap *idmap,
 		    struct dentry *d,
 		    struct kernel_xattr_ctx *ctx);
 
+int file_setxattr(struct file *file, struct kernel_xattr_ctx *ctx);
+int filename_setxattr(int dfd, struct filename *filename,
+		      unsigned int lookup_flags, struct kernel_xattr_ctx *ctx);
 int setxattr_copy(const char __user *name, struct kernel_xattr_ctx *ctx);
-int do_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
-		struct kernel_xattr_ctx *ctx);
-
 int import_xattr_name(struct xattr_name *kname, const char __user *name);
 
 int may_write_xattr(struct mnt_idmap *idmap, struct inode *inode);
diff --git a/fs/xattr.c b/fs/xattr.c
index d8f7c766f28a..6326a1ea28e9 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -626,7 +626,7 @@ int setxattr_copy(const char __user *name, struct kernel_xattr_ctx *ctx)
 	return error;
 }
 
-int do_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
+static int do_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		struct kernel_xattr_ctx *ctx)
 {
 	if (is_posix_acl_xattr(ctx->kname->name))
@@ -637,32 +637,31 @@ int do_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
 			ctx->kvalue, ctx->size, ctx->flags);
 }
 
-static int path_setxattr(const char __user *pathname,
-			 const char __user *name, const void __user *value,
-			 size_t size, int flags, unsigned int lookup_flags)
+int file_setxattr(struct file *f, struct kernel_xattr_ctx *ctx)
+{
+	int error = mnt_want_write_file(f);
+
+	if (!error) {
+		audit_file(f);
+		error = do_setxattr(file_mnt_idmap(f), f->f_path.dentry, ctx);
+		mnt_drop_write_file(f);
+	}
+	return error;
+}
+
+int filename_setxattr(int dfd, struct filename *filename,
+		      unsigned int lookup_flags, struct kernel_xattr_ctx *ctx)
 {
-	struct xattr_name kname;
-	struct kernel_xattr_ctx ctx = {
-		.cvalue   = value,
-		.kvalue   = NULL,
-		.size     = size,
-		.kname    = &kname,
-		.flags    = flags,
-	};
 	struct path path;
 	int error;
 
-	error = setxattr_copy(name, &ctx);
-	if (error)
-		return error;
-
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
 		goto out;
 	error = mnt_want_write(path.mnt);
 	if (!error) {
-		error = do_setxattr(mnt_idmap(path.mnt), path.dentry, &ctx);
+		error = do_setxattr(mnt_idmap(path.mnt), path.dentry, ctx);
 		mnt_drop_write(path.mnt);
 	}
 	path_put(&path);
@@ -672,6 +671,30 @@ static int path_setxattr(const char __user *pathname,
 	}
 
 out:
+	putname(filename);
+	return error;
+}
+
+static int path_setxattr(const char __user *pathname,
+			 const char __user *name, const void __user *value,
+			 size_t size, int flags, unsigned int lookup_flags)
+{
+	struct xattr_name kname;
+	struct kernel_xattr_ctx ctx = {
+		.cvalue   = value,
+		.kvalue   = NULL,
+		.size     = size,
+		.kname    = &kname,
+		.flags    = flags,
+	};
+	int error;
+
+	error = setxattr_copy(name, &ctx);
+	if (error)
+		return error;
+
+	error = filename_setxattr(AT_FDCWD, getname(pathname), lookup_flags,
+				  &ctx);
 	kvfree(ctx.kvalue);
 	return error;
 }
@@ -707,17 +730,12 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 
 	if (fd_empty(f))
 		return -EBADF;
-	audit_file(fd_file(f));
+
 	error = setxattr_copy(name, &ctx);
 	if (error)
 		return error;
 
-	error = mnt_want_write_file(fd_file(f));
-	if (!error) {
-		error = do_setxattr(file_mnt_idmap(fd_file(f)),
-				    fd_file(f)->f_path.dentry, &ctx);
-		mnt_drop_write_file(fd_file(f));
-	}
+	error = file_setxattr(fd_file(f), &ctx);
 	kvfree(ctx.kvalue);
 	return error;
 }
diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index 71d9e2569a2f..7f6bbfd846b9 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -200,28 +200,14 @@ int io_fsetxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return __io_setxattr_prep(req, sqe);
 }
 
-static int __io_setxattr(struct io_kiocb *req, unsigned int issue_flags,
-			const struct path *path)
-{
-	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
-	int ret;
-
-	ret = mnt_want_write(path->mnt);
-	if (!ret) {
-		ret = do_setxattr(mnt_idmap(path->mnt), path->dentry, &ix->ctx);
-		mnt_drop_write(path->mnt);
-	}
-
-	return ret;
-}
-
 int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
 	int ret;
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = __io_setxattr(req, issue_flags, &req->file->f_path);
+	ret = file_setxattr(req->file, &ix->ctx);
 	io_xattr_finish(req, ret);
 	return IOU_OK;
 }
@@ -229,23 +215,11 @@ int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
 int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
-	unsigned int lookup_flags = LOOKUP_FOLLOW;
-	struct path path;
 	int ret;
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-retry:
-	ret = filename_lookup(AT_FDCWD, ix->filename, lookup_flags, &path, NULL);
-	if (!ret) {
-		ret = __io_setxattr(req, issue_flags, &path);
-		path_put(&path);
-		if (retry_estale(ret, lookup_flags)) {
-			lookup_flags |= LOOKUP_REVAL;
-			goto retry;
-		}
-	}
-
+	ret = filename_setxattr(AT_FDCWD, ix->filename, LOOKUP_FOLLOW, &ix->ctx);
 	io_xattr_finish(req, ret);
 	return IOU_OK;
 }
-- 
2.39.5


