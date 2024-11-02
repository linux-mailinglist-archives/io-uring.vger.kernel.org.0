Return-Path: <io-uring+bounces-4347-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F33F39B9DA1
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 08:32:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FDFB1C21717
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 07:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B42158A00;
	Sat,  2 Nov 2024 07:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="eh3AmFqN"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1BD1494B3;
	Sat,  2 Nov 2024 07:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730532713; cv=none; b=CyBgF97N5jZs05iJHVEhSoDSYhHq420DEI/mIGEUEoya3CH/+SOjMH/z8xSL+jEGHnlWlV8tYbJ3u6u/e8ZXsuQwC6NOomy6lCYOzGQdZQOPpeZtjLZAqY79yj47mJMYu15gnGqycfeUiQnlZpww2kp0I2xrGEROA1rZxPfdu2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730532713; c=relaxed/simple;
	bh=iET8QBRBtqoalPoanDAyr5M3rnSmEUjI8VaTE7XAbzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCLDbvSTiRGswnL6EvAJOLivij7BF7fKmnY2Bo5LwnCHkKrDcvLGvGFXF2b2Atz6NSuxTaOdMBm/Jb5hw9hrCNlRz1Lpd/PWXMpG+RxJrWN0uhI2e3H51aaNkM0dbsN6eXXnKUU69jy8TBJ2BzYmcTZ8UDXw1vnmT8yTG6av724=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=eh3AmFqN; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WcjWMPIYgNwVesjZZtqGTFXJQRfHhE/DdzXc440ft2Y=; b=eh3AmFqNxYeQn+8Enyr6pysMoe
	08jJtNKWQkVt3lZatFKdOcfmmb16lE9aZCl4/OPJ2UmSqz1uZXccmj7Keyr4MkH83H5dLPso4nrI8
	xZcGWo//GfAv/ljcafIe18LxdjhnZJQX4ZhrA5M1O0GSMxNS0dTP1/k75S823ycV++8RRYR7hADMr
	gtW2kkuXdOP8SEKyH5ninJQni0MKgiBgo3jboUrMGDlcCgY70Ut0y6AYWlK9r82KfPeJrS2wc+Lae
	7tnAkUsJEzb1MfjoWo+jcAoMOMVQAmgglf6jVrF4QF0HMD01O7GBLrtg3qTaqpW1cAUttloxCF789
	5rhrN0AQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t78bu-0000000AJFY-0Bcn;
	Sat, 02 Nov 2024 07:31:50 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	io-uring@vger.kernel.org,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: [PATCH v2 08/13] replace do_setxattr() with saner helpers.
Date: Sat,  2 Nov 2024 07:31:44 +0000
Message-ID: <20241102073149.2457240-8-viro@zeniv.linux.org.uk>
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

io_uring setxattr logics duplicates stuff from fs/xattr.c; provide
saner helpers (filename_setxattr() and file_setxattr() resp.) and
use them.

NB: putname(ERR_PTR()) is a no-op

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/internal.h    |  6 ++---
 fs/xattr.c       | 69 ++++++++++++++++++++++++++++++------------------
 io_uring/xattr.c | 41 +++++-----------------------
 3 files changed, 54 insertions(+), 62 deletions(-)

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
index d8f7c766f28a..38bf8cfbd464 100644
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
@@ -637,32 +637,32 @@ int do_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
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
+/* unconditionally consumes filename */
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
@@ -672,6 +672,30 @@ static int path_setxattr(const char __user *pathname,
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
@@ -707,17 +731,12 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 
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
index 0b3b871eaa65..2671ad05d63b 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -187,12 +187,10 @@ int io_setxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
 
 int io_fsetxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -200,28 +198,14 @@ int io_fsetxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -229,23 +213,12 @@ int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
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
+	ix->filename = NULL;
 	io_xattr_finish(req, ret);
 	return IOU_OK;
 }
-- 
2.39.5


