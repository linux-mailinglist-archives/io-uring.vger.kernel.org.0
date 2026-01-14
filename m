Return-Path: <io-uring+bounces-11663-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9298BD1C60E
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:36:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4E1BF30907DC
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3FFD32C331;
	Wed, 14 Jan 2026 04:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="mCJe4VV3"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DA92E7621;
	Wed, 14 Jan 2026 04:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365117; cv=none; b=RFC8vCNFQDnaelZU08LfvsT5EgRRiJZ0KH1mlKF1vMs9rA2twr7230GSU7AWJG7qVtOWNn1h06K5IJxRbIy7x8ixR4x6nJwfESNIk8Wp8B4kaCKUzJL8eSlNCJWDu43C4vy7M4buzZ/VJCQGO6FwNMUXKMNb+5jzmzoDXGfEqyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365117; c=relaxed/simple;
	bh=mH+IhVh+pGWD+wir6/3XrU+oKiUI4iQYDdHOVb/NhH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6aznI5lfUXw5zPxdVcy0Hx+MzASc8SdPY5mc5NOO34JQP+JA9ML/RI9aGs6WCFuIIRQ4et6/r+R0CigMKKQno8DaIE4xR3XPGBtNPEWLxpvEOH5y2YDigRLErC4ephCnDaSRsgIx9SN7TMvtzsPwlEkRsV1twLZQTPILtbhpTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=mCJe4VV3; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OgcfVQFkpDdBHYLYEYn1FYoj0X9C+43KGjqPEVpGXG4=; b=mCJe4VV381ws4rh0IzXRvotLmX
	myQgKzQrFFFJ6CzBMsI6v01FBdOhW9Z0rb276v/FS6pdrmVWUfY2wEUlXb/mWFI6AftfDkxsq8iZG
	wXK1IP1HcROUoIbb+FU1M1kGvRgBuTU5gQ2yoK6yjsajyJdFs3kdkeaF4hITeYQsEX6VrkEj6aHD4
	ye1f2ELjHKB4C2qwN+wats03wFGYLPGx3Azy5gQYH2qV58F40Mi+DWyd06/EwMydPptSQk1Jy0laj
	iqTtZV4fjo0/p3BDZfDtyUYkbC9wNitP/ucZtfzfFElR9Bc1LqbaPd/hlOyUcsNFVCN5MDLgG147M
	uIW0mnWQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZJ-0000000GIsr-0Tfn;
	Wed, 14 Jan 2026 04:33:17 +0000
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
Subject: [PATCH v5 44/68] non-consuming variants of do_{unlinkat,rmdir}()
Date: Wed, 14 Jan 2026 04:32:46 +0000
Message-ID: <20260114043310.3885463-45-viro@zeniv.linux.org.uk>
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

similar to previous commit; replacements are filename_{unlinkat,rmdir}()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 Documentation/filesystems/porting.rst |  6 +++---
 fs/coredump.c                         |  3 ++-
 fs/init.c                             |  6 ++++--
 fs/internal.h                         |  4 ++--
 fs/namei.c                            | 23 +++++++++++------------
 io_uring/fs.c                         |  5 +++--
 6 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 7e68a148dd1e..2b4dddfe6c66 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1339,6 +1339,6 @@ in-tree filesystems have done).
 
 **mandatory**
 
-do_{mkdir,mknod,link,symlink,renameat2}() are gone; filename_...()
-counterparts replace those.  The difference is that the former used
-to consume filename references; the latter do not.
+do_{mkdir,mknod,link,symlink,renameat2,rmdir,unlink}() are gone; filename_...()
+counterparts replace those.  The difference is that the former used to consume
+filename references; the latter do not.
diff --git a/fs/coredump.c b/fs/coredump.c
index 8feb9c1cf83d..d9597610a6ca 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -895,11 +895,12 @@ static bool coredump_file(struct core_name *cn, struct coredump_params *cprm,
 	 * privs and don't want to unlink another user's coredump.
 	 */
 	if (!coredump_force_suid_safe(cprm)) {
+		CLASS(filename_kernel, name)(cn->corename);
 		/*
 		 * If it doesn't exist, that's fine. If there's some
 		 * other problem, we'll catch it at the filp_open().
 		 */
-		do_unlinkat(AT_FDCWD, getname_kernel(cn->corename));
+		filename_unlinkat(AT_FDCWD, name);
 	}
 
 	/*
diff --git a/fs/init.c b/fs/init.c
index 543444c1d79e..ea528b020cd1 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -160,7 +160,8 @@ int __init init_symlink(const char *oldname, const char *newname)
 
 int __init init_unlink(const char *pathname)
 {
-	return do_unlinkat(AT_FDCWD, getname_kernel(pathname));
+	CLASS(filename_kernel, name)(pathname);
+	return filename_unlinkat(AT_FDCWD, name);
 }
 
 int __init init_mkdir(const char *pathname, umode_t mode)
@@ -171,7 +172,8 @@ int __init init_mkdir(const char *pathname, umode_t mode)
 
 int __init init_rmdir(const char *pathname)
 {
-	return do_rmdir(AT_FDCWD, getname_kernel(pathname));
+	CLASS(filename_kernel, name)(pathname);
+	return filename_rmdir(AT_FDCWD, name);
 }
 
 int __init init_utimes(char *filename, struct timespec64 *ts)
diff --git a/fs/internal.h b/fs/internal.h
index 02b5dec13ff3..4821f8b8fdda 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -54,8 +54,8 @@ extern int finish_clean_context(struct fs_context *fc);
  */
 extern int filename_lookup(int dfd, struct filename *name, unsigned flags,
 			   struct path *path, const struct path *root);
-int do_rmdir(int dfd, struct filename *name);
-int do_unlinkat(int dfd, struct filename *name);
+int filename_rmdir(int dfd, struct filename *name);
+int filename_unlinkat(int dfd, struct filename *name);
 int may_linkat(struct mnt_idmap *idmap, const struct path *link);
 int filename_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
diff --git a/fs/namei.c b/fs/namei.c
index ca524c5b18f4..ba6e15339ad6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5312,7 +5312,7 @@ int vfs_rmdir(struct mnt_idmap *idmap, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_rmdir);
 
-int do_rmdir(int dfd, struct filename *name)
+int filename_rmdir(int dfd, struct filename *name)
 {
 	int error;
 	struct dentry *dentry;
@@ -5324,7 +5324,7 @@ int do_rmdir(int dfd, struct filename *name)
 retry:
 	error = filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
 	if (error)
-		goto exit1;
+		return error;
 
 	switch (type) {
 	case LAST_DOTDOT:
@@ -5366,14 +5366,13 @@ int do_rmdir(int dfd, struct filename *name)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-exit1:
-	putname(name);
 	return error;
 }
 
 SYSCALL_DEFINE1(rmdir, const char __user *, pathname)
 {
-	return do_rmdir(AT_FDCWD, getname(pathname));
+	CLASS(filename, name)(pathname);
+	return filename_rmdir(AT_FDCWD, name);
 }
 
 /**
@@ -5455,7 +5454,7 @@ EXPORT_SYMBOL(vfs_unlink);
  * writeout happening, and we don't want to prevent access to the directory
  * while waiting on the I/O.
  */
-int do_unlinkat(int dfd, struct filename *name)
+int filename_unlinkat(int dfd, struct filename *name)
 {
 	int error;
 	struct dentry *dentry;
@@ -5468,7 +5467,7 @@ int do_unlinkat(int dfd, struct filename *name)
 retry:
 	error = filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
 	if (error)
-		goto exit_putname;
+		return error;
 
 	error = -EISDIR;
 	if (type != LAST_NORM)
@@ -5515,8 +5514,6 @@ int do_unlinkat(int dfd, struct filename *name)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-exit_putname:
-	putname(name);
 	return error;
 }
 
@@ -5525,14 +5522,16 @@ SYSCALL_DEFINE3(unlinkat, int, dfd, const char __user *, pathname, int, flag)
 	if ((flag & ~AT_REMOVEDIR) != 0)
 		return -EINVAL;
 
+	CLASS(filename, name)(pathname);
 	if (flag & AT_REMOVEDIR)
-		return do_rmdir(dfd, getname(pathname));
-	return do_unlinkat(dfd, getname(pathname));
+		return filename_rmdir(dfd, name);
+	return filename_unlinkat(dfd, name);
 }
 
 SYSCALL_DEFINE1(unlink, const char __user *, pathname)
 {
-	return do_unlinkat(AT_FDCWD, getname(pathname));
+	CLASS(filename, name)(pathname);
+	return filename_unlinkat(AT_FDCWD, name);
 }
 
 /**
diff --git a/io_uring/fs.c b/io_uring/fs.c
index 40541b539e0d..d0580c754bf8 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -134,14 +134,15 @@ int io_unlinkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_unlink *un = io_kiocb_to_cmd(req, struct io_unlink);
+	CLASS(filename_complete_delayed, name)(&un->filename);
 	int ret;
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
 	if (un->flags & AT_REMOVEDIR)
-		ret = do_rmdir(un->dfd, complete_getname(&un->filename));
+		ret = filename_rmdir(un->dfd, name);
 	else
-		ret = do_unlinkat(un->dfd, complete_getname(&un->filename));
+		ret = filename_unlinkat(un->dfd, name);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
-- 
2.47.3


