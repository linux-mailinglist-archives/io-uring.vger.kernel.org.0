Return-Path: <io-uring+bounces-11659-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 364A2D1C5CC
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:33:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D59C630178EA
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C0132B9A5;
	Wed, 14 Jan 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="vWd3xDPe"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A8C2C3271;
	Wed, 14 Jan 2026 04:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365117; cv=none; b=bZkfjlSU4ICdxNUJczfI0YYcubVgvFbGMCHWn6XCOShetVX/Umq25gayYVO/eEKzQqHIMmQfI15bXukSJZoQEe/5is+J/r3eZYin6Yg/XuGPK1yABoJ9+YBd2jSFrczphzknYR4qF4D5kf4nc+1Zm1htLkVLFh4OXlZnOb87bx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365117; c=relaxed/simple;
	bh=JNyL/TkYANPwxDw7dlyv46R3RBrMV8xyuHfsJyK8y0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHxeipwoa317iHhcPw9/wWRTwxUpSeda/VKmBJtuab0yBBUu1aVj0B3XDXQMv7gqldhmqjONLXAH0aM0zPfPwRlCblVP8XgxpTvcFBdpOG6HcWKAXwHpz0aSHOS9giVhjOmkdGtMkNiCyPLHPt+mjE4Q43Yag4DV8ogrTz2SFs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=vWd3xDPe; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KOMlKW8pfcycdT4Ipg1Qdr7EnS+wAoBtH9cW6rO73XY=; b=vWd3xDPePPFmjSk2dllWO5ezb5
	1XDp4vYarggMGW0ppjMXoUxsZnN+m2NnWo8Oe7ndfvzsZboBjxQi8o4fDGQLmBAJ603GbSsXp1GWi
	iTvO1iiClBikFD5KWNCuakAgHsbkSQ9cK6gm4jJW3xUz1XVy6LigcW6iudctKOpH+Ti6wARyxVPze
	4JylUD9qyJlQTT0fffBQEcXZcqpCU3P0lJifjzYSTC55/S5eG47btjq8yCU8Iec+DqwTuhh4fHtOS
	mdCjPvaU97QCi+3Uu1Ub1qhJMZ7UAoJPh6zQ/FsDGesX3fVD+U0eqxdwAhqatm/5xF97cD6aF45DE
	19TGewMA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZI-0000000GIrg-267z;
	Wed, 14 Jan 2026 04:33:16 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Jens Axboe <axboe@kernel.dk>,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 42/68] non-consuming variant of do_mkdirat()
Date: Wed, 14 Jan 2026 04:32:44 +0000
Message-ID: <20260114043310.3885463-43-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
References: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

similar to previous commit; replacement is filename_mkdirat()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 Documentation/filesystems/porting.rst |  2 +-
 fs/init.c                             |  3 ++-
 fs/internal.h                         |  2 +-
 fs/namei.c                            | 13 ++++++-------
 io_uring/fs.c                         |  3 ++-
 5 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index c44c351bc297..ace0607fe39c 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1339,6 +1339,6 @@ in-tree filesystems have done).
 
 **mandatory**
 
-do_{link,symlink,renameat2}() are gone; filename_...() counterparts
+do_{mkdir,link,symlink,renameat2}() are gone; filename_...() counterparts
 replace those.  The difference is that the former used to consume
 filename references; the latter do not.
diff --git a/fs/init.c b/fs/init.c
index a54ef750ffe3..9a550ba4802f 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -164,7 +164,8 @@ int __init init_unlink(const char *pathname)
 
 int __init init_mkdir(const char *pathname, umode_t mode)
 {
-	return do_mkdirat(AT_FDCWD, getname_kernel(pathname), mode);
+	CLASS(filename_kernel, name)(pathname);
+	return filename_mkdirat(AT_FDCWD, name, mode);
 }
 
 int __init init_rmdir(const char *pathname)
diff --git a/fs/internal.h b/fs/internal.h
index 4a63b89c02d7..03638008d84a 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -59,7 +59,7 @@ int do_unlinkat(int dfd, struct filename *name);
 int may_linkat(struct mnt_idmap *idmap, const struct path *link);
 int filename_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
-int do_mkdirat(int dfd, struct filename *name, umode_t mode);
+int filename_mkdirat(int dfd, struct filename *name, umode_t mode);
 int do_mknodat(int dfd, struct filename *name, umode_t mode, unsigned int dev);
 int filename_symlinkat(struct filename *from, int newdfd, struct filename *to);
 int filename_linkat(int olddfd, struct filename *old, int newdfd,
diff --git a/fs/namei.c b/fs/namei.c
index c88ad27f66c7..21a2dbd8b9e6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5207,7 +5207,7 @@ struct dentry *vfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_mkdir);
 
-int do_mkdirat(int dfd, struct filename *name, umode_t mode)
+int filename_mkdirat(int dfd, struct filename *name, umode_t mode)
 {
 	struct dentry *dentry;
 	struct path path;
@@ -5217,9 +5217,8 @@ int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 
 retry:
 	dentry = filename_create(dfd, name, &path, lookup_flags);
-	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out_putname;
+		return PTR_ERR(dentry);
 
 	error = security_path_mkdir(&path, dentry,
 			mode_strip_umask(path.dentry->d_inode, mode));
@@ -5239,19 +5238,19 @@ int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out_putname:
-	putname(name);
 	return error;
 }
 
 SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, umode_t, mode)
 {
-	return do_mkdirat(dfd, getname(pathname), mode);
+	CLASS(filename, name)(pathname);
+	return filename_mkdirat(dfd, name, mode);
 }
 
 SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
 {
-	return do_mkdirat(AT_FDCWD, getname(pathname), mode);
+	CLASS(filename, name)(pathname);
+	return filename_mkdirat(AT_FDCWD, name, mode);
 }
 
 /**
diff --git a/io_uring/fs.c b/io_uring/fs.c
index cd4d88d37795..40541b539e0d 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -182,11 +182,12 @@ int io_mkdirat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_mkdirat(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_mkdir *mkd = io_kiocb_to_cmd(req, struct io_mkdir);
+	CLASS(filename_complete_delayed, name)(&mkd->filename);
 	int ret;
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = do_mkdirat(mkd->dfd, complete_getname(&mkd->filename), mkd->mode);
+	ret = filename_mkdirat(mkd->dfd, name, mkd->mode);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
-- 
2.47.3


