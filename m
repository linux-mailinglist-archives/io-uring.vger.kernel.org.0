Return-Path: <io-uring+bounces-11510-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 315BCD0179E
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E8D86301FC2A
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B195035A953;
	Thu,  8 Jan 2026 07:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="cHZoLiSk"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DDA359FB0;
	Thu,  8 Jan 2026 07:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767858052; cv=none; b=E79hXzWdTNZIUzXKQ646n6amDCX304BzcQZV/0v7rzeD99vzsmeLxID4wAObCNfWi5vnhFyKHVgGSLpQw9gNJOgO4okU462cVm5ISx+Vo117Z5iaaZcRUoqjLRJjTOHUjilcb66wMpLkvQy0YBhTVMoxQrh5Bd+h+xPSrhV6tmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767858052; c=relaxed/simple;
	bh=RLE6cYBOmecz8ThObxPKrJavV5HxVpo51hQfHRxANaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwQiY2KDvEAqZ0RMAemx7ldZapEA93BlIYaQit7ECQABT21K2QaecjYMd4amBNu74jjCl96QXyAHDHqjbvyvcQIDGy7QvjTlc6GKjS55jLE71vKuHpP5aoteQ6jIvpLtGy3lWDw88wxsn6Yu2nwy+j3EoxEG8GgazIxB7wIXlBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=cHZoLiSk; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QEG7CrTkV6vj/sLksys6/DKX0L1lzK+giJ8dBT8N0WU=; b=cHZoLiSk5pn0XEsY8oWl5/zxJe
	jvxCf9faPZnY/B0kUQuLnl2slrzQ+qmYoUs1/4Q+bo9jxIV71VbdWxOlWxYNGL/L+vpU/1uwBjiRe
	WJDEIvZAAs4k17DAxzEe6GJ36ieBaVBB7ZgFaWVQyDJq/C5RGEP2I13rpHjWWxQsu6/okgbqVjaXL
	auS1rOfaGvA3H6P/VrKkb7iq43A7+1fdCWal6Wd3SHc8kux6ahzQ0/kxf+ovT4hZ08hO7nhssj0J6
	gUZz1hmO9gGD5T/xiaipmZoIXws2JRkrf6IkkBUcfBSuqTtlp/k7R9p+X1UVx49h6zj+ImdPrvVHk
	gAcckIaQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkeh-00000001pGv-2DNO;
	Thu, 08 Jan 2026 07:42:03 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 6/8] non-consuming variants of do_{unlinkat,rmdir}()
Date: Thu,  8 Jan 2026 07:41:59 +0000
Message-ID: <20260108074201.435280-7-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108074201.435280-1-viro@zeniv.linux.org.uk>
References: <20260108074201.435280-1-viro@zeniv.linux.org.uk>
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
 fs/namei.c                            | 17 +++++++++--------
 io_uring/fs.c                         |  5 +++--
 6 files changed, 23 insertions(+), 18 deletions(-)

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
index 1aa19dde50e4..42b33bb0f892 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5278,9 +5278,8 @@ int vfs_rmdir(struct mnt_idmap *idmap, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_rmdir);
 
-int do_rmdir(int dfd, struct filename *__name)
+int filename_rmdir(int dfd, struct filename *name)
 {
-	CLASS(filename_consume, name)(__name);
 	int error;
 	struct dentry *dentry;
 	struct path path;
@@ -5338,7 +5337,8 @@ int do_rmdir(int dfd, struct filename *__name)
 
 SYSCALL_DEFINE1(rmdir, const char __user *, pathname)
 {
-	return do_rmdir(AT_FDCWD, getname(pathname));
+	CLASS(filename, name)(pathname);
+	return filename_rmdir(AT_FDCWD, name);
 }
 
 /**
@@ -5420,9 +5420,8 @@ EXPORT_SYMBOL(vfs_unlink);
  * writeout happening, and we don't want to prevent access to the directory
  * while waiting on the I/O.
  */
-int do_unlinkat(int dfd, struct filename *__name)
+int filename_unlinkat(int dfd, struct filename *name)
 {
-	CLASS(filename_consume, name)(__name);
 	int error;
 	struct dentry *dentry;
 	struct path path;
@@ -5489,14 +5488,16 @@ SYSCALL_DEFINE3(unlinkat, int, dfd, const char __user *, pathname, int, flag)
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


