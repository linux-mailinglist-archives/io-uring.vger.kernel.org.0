Return-Path: <io-uring+bounces-4353-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3CFC9B9DB0
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 08:32:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A7501F223B9
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 07:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0442D16A95B;
	Sat,  2 Nov 2024 07:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="MKwDjBw1"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB6C1448C1;
	Sat,  2 Nov 2024 07:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730532714; cv=none; b=Z+yxuPnepy1QUKK6ONyE5dT5M8ikl7i0mLagmG05tdVBXHbtuVjlVP3OHUqpJ/TbBQke4XdCOHgn+R3EnMowMK4A32DDcZPX/kh+C7kWpVynK/Oc7xDvlOfiUT2IKLMrI7/5vzRDknSfi2+eIIo5s8JFnAXJk/RnBD+C93aKpgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730532714; c=relaxed/simple;
	bh=zQQnTZimkNdhhEgtbCqbtkYZqWPqNugT62UQir086FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlgh9ycwRnAwOvQ/aZMwbl+AQd3It+cNAfPiJQOebvQlvY5B1qAF0diMfTgA2+vBdigDmwuFBDmzumNL3Qz6pklrcu9+2CKTSqEsuQNahuoRugYdFdQddlWtSAPrWCwu2/zhIF0qC5GpmcNb4r5AEo3RbJ/wYDbNpwI4CMaNdg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=MKwDjBw1; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VVU5A6PnIxPNnXJuEEHW+GW30MbPjzG1/fG7IlvwPPI=; b=MKwDjBw1sBmmI/D74EgozmiWm0
	fpIxTIW22+42Pd8/PoYYZkv9vWqwweNjspaDDcpRn1aPT3dxE5iWRs91JSrNKk/yx0v6kftuJecd/
	oWoc3eDVTZHw/HeVTY+nva6b3oqe1okHdpco+o+gU9BzK42lPLxx9OzxCTk0TLwlewevlNDsbbSJM
	2fB8VO9iqnQdp+PSEsR7E8mIxGcfR1vlENRASEk+mSR5lPpztxOF2w/q6YkhC48Fak3/88UNamZy7
	c9T0kBLU+eT+A46fwhCD1SZPrPufBCXzJYgDRqKg8cDEXRV7QRsyxFy+x+58UH1cNOL6/s/Z4Lnnd
	+7IUydkg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t78bt-0000000AJFS-3qTt;
	Sat, 02 Nov 2024 07:31:49 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	io-uring@vger.kernel.org,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: [PATCH v2 07/13] new helper: import_xattr_name()
Date: Sat,  2 Nov 2024 07:31:43 +0000
Message-ID: <20241102073149.2457240-7-viro@zeniv.linux.org.uk>
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

common logics for marshalling xattr names.

Reviewed-by: Christian Brauner <brauner@kernel.org>
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
index f440121c3984..0b3b871eaa65 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -62,11 +62,8 @@ static int __io_getxattr_prep(struct io_kiocb *req,
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


