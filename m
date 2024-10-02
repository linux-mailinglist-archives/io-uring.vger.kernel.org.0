Return-Path: <io-uring+bounces-3353-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70CD198CAAD
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 03:22:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92C491C22467
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 01:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF9691FC8;
	Wed,  2 Oct 2024 01:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="lepJrpI/"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140B69473;
	Wed,  2 Oct 2024 01:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832153; cv=none; b=Kt7c9jCmwq9xzb5FBvoyCRYqyrqJm/Wb/qgfWyqMi/waB2r7KfXSD8n7yNrwSYmk/pPaGFP6fLVHGi4nmFuuWw7kRFij4wDvjqokOPKJ2gP3vmEr4K5F0XkVvBxSh2FXF6XQmcw3EHVaatHM894gmG5P4QM7l+Inv15kEqV28IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832153; c=relaxed/simple;
	bh=6hj6ON21ofjjrr4/UOKvjRRIfFsvmigcJlYXQoJvTDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoHC2XIH3ph6IS+xj6Bd7cKECsuygGGgHuXj+TDSblgyPNItDy9HHAJZWj8PobSV2Or3rVL2bUhHnUGNww2PD16SexwXyVpJ9KHBHai9HOcnykJRMeAuuMer4PfSuwgY/GCVrJR/3xM6lDYZBEwa0oQ/DdjeOc1nLa98ogqo+D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=lepJrpI/; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jFUq21m1sQJr6SiaClIO+hP/wJwmB67aDC/vU2ShIh4=; b=lepJrpI/M0lmoQvOPyEl63MJSQ
	T5L31R3D3dOTjWanQ7ZKvGvSux3xdsA1uzet2AnNrTInMfuHQfSzLr/WAPewfRsoEYMTI0/6+wW87
	9+2MRsYBye0B9JRUdi3G82o1S9RZtZI+SpyoGfuo/VT5uwsNuA8eu+sMyTsp1ZmIAKmB++/vBFbd6
	R73eM0Q0YPoXfy+76I1LClOKjsJFO+6h93xGf+ij144oxALTle5ToZ0Xkd/RM86XbSlMkwlBSgcZc
	Hh9RPrTgETfRmWL9LML0jTIoC3K+cdCFqL2F+vXuiTrorNC63IFiVlixjNWZQ7sRuvRoG8ZDfrl82
	1f3p0uQw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svo4U-0000000HW0F-24Xk;
	Wed, 02 Oct 2024 01:22:30 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: brauner@kernel.org,
	io-uring@vger.kernel.org,
	cgzones@googlemail.com
Subject: [PATCH 4/9] new helper: import_xattr_name()
Date: Wed,  2 Oct 2024 02:22:25 +0100
Message-ID: <20241002012230.4174585-4-viro@zeniv.linux.org.uk>
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

common logics for marshalling xattr names.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/internal.h    |  3 +++
 fs/xattr.c       | 45 +++++++++++++++++++++++----------------------
 io_uring/xattr.c |  7 ++-----
 3 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 81c7a085355c..b9f5ac4d39fc 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -288,6 +288,9 @@ ssize_t do_getxattr(struct mnt_idmap *idmap,
 int setxattr_copy(const char __user *name, struct kernel_xattr_ctx *ctx);
 int do_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		struct kernel_xattr_ctx *ctx);
+
+int import_xattr_name(struct xattr_name *kname, const char __user *name);
+
 int may_write_xattr(struct mnt_idmap *idmap, struct inode *inode);
 
 #ifdef CONFIG_FS_POSIX_ACL
diff --git a/fs/xattr.c b/fs/xattr.c
index 1214ae7e71db..d8f7c766f28a 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -586,6 +586,17 @@ vfs_removexattr(struct mnt_idmap *idmap, struct dentry *dentry,
 }
 EXPORT_SYMBOL_GPL(vfs_removexattr);
 
+int import_xattr_name(struct xattr_name *kname, const char __user *name)
+{
+	int error = strncpy_from_user(kname->name, name,
+					sizeof(kname->name));
+	if (error == 0 || error == sizeof(kname->name))
+		return -ERANGE;
+	if (error < 0)
+		return error;
+	return 0;
+}
+
 /*
  * Extended attribute SET operations
  */
@@ -597,14 +608,10 @@ int setxattr_copy(const char __user *name, struct kernel_xattr_ctx *ctx)
 	if (ctx->flags & ~(XATTR_CREATE|XATTR_REPLACE))
 		return -EINVAL;
 
-	error = strncpy_from_user(ctx->kname->name, name,
-				sizeof(ctx->kname->name));
-	if (error == 0 || error == sizeof(ctx->kname->name))
-		return  -ERANGE;
-	if (error < 0)
+	error = import_xattr_name(ctx->kname, name);
+	if (error)
 		return error;
 
-	error = 0;
 	if (ctx->size) {
 		if (ctx->size > XATTR_SIZE_MAX)
 			return -E2BIG;
@@ -763,10 +770,8 @@ getxattr(struct mnt_idmap *idmap, struct dentry *d,
 		.flags    = 0,
 	};
 
-	error = strncpy_from_user(kname.name, name, sizeof(kname.name));
-	if (error == 0 || error == sizeof(kname.name))
-		error = -ERANGE;
-	if (error < 0)
+	error = import_xattr_name(&kname, name);
+	if (error)
 		return error;
 
 	error =  do_getxattr(idmap, d, &ctx);
@@ -906,12 +911,10 @@ static int path_removexattr(const char __user *pathname,
 {
 	struct path path;
 	int error;
-	char kname[XATTR_NAME_MAX + 1];
+	struct xattr_name kname;
 
-	error = strncpy_from_user(kname, name, sizeof(kname));
-	if (error == 0 || error == sizeof(kname))
-		error = -ERANGE;
-	if (error < 0)
+	error = import_xattr_name(&kname, name);
+	if (error)
 		return error;
 retry:
 	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
@@ -919,7 +922,7 @@ static int path_removexattr(const char __user *pathname,
 		return error;
 	error = mnt_want_write(path.mnt);
 	if (!error) {
-		error = removexattr(mnt_idmap(path.mnt), path.dentry, kname);
+		error = removexattr(mnt_idmap(path.mnt), path.dentry, kname.name);
 		mnt_drop_write(path.mnt);
 	}
 	path_put(&path);
@@ -945,23 +948,21 @@ SYSCALL_DEFINE2(lremovexattr, const char __user *, pathname,
 SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 {
 	CLASS(fd, f)(fd);
-	char kname[XATTR_NAME_MAX + 1];
+	struct xattr_name kname;
 	int error;
 
 	if (fd_empty(f))
 		return -EBADF;
 	audit_file(fd_file(f));
 
-	error = strncpy_from_user(kname, name, sizeof(kname));
-	if (error == 0 || error == sizeof(kname))
-		error = -ERANGE;
-	if (error < 0)
+	error = import_xattr_name(&kname, name);
+	if (error)
 		return error;
 
 	error = mnt_want_write_file(fd_file(f));
 	if (!error) {
 		error = removexattr(file_mnt_idmap(fd_file(f)),
-				    fd_file(f)->f_path.dentry, kname);
+				    fd_file(f)->f_path.dentry, kname.name);
 		mnt_drop_write_file(fd_file(f));
 	}
 	return error;
diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index 04abf0739668..71d9e2569a2f 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -65,11 +65,8 @@ static int __io_getxattr_prep(struct io_kiocb *req,
 	if (!ix->ctx.kname)
 		return -ENOMEM;
 
-	ret = strncpy_from_user(ix->ctx.kname->name, name,
-				sizeof(ix->ctx.kname->name));
-	if (!ret || ret == sizeof(ix->ctx.kname->name))
-		ret = -ERANGE;
-	if (ret < 0) {
+	ret = import_xattr_name(ix->ctx.kname, name);
+	if (ret) {
 		kfree(ix->ctx.kname);
 		return ret;
 	}
-- 
2.39.5


