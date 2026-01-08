Return-Path: <io-uring+bounces-11511-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 21F57D0221E
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 11:33:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AB5D630AF9D3
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 10:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF0F835A952;
	Thu,  8 Jan 2026 07:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="qT5ZFckx"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D333596ED;
	Thu,  8 Jan 2026 07:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767858052; cv=none; b=cRHBCsb37H7oAdTH+m9vl9xi/JiG+Z/4z9y9mEg8kGiiqZKuZxATWuMRb+NRM7SwPvK2UfqzKTOHvluGr3sPNZTvcHtVbi8HidfE/3jhYl6SQCS/xa669AlBkvKCh3WHuxqmneZCWjn6wNQNXL9C52MIi6tNME8wa28RwPj59Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767858052; c=relaxed/simple;
	bh=jkwPdqDCuCzpLz2Phw84lK5ontai7k34YK7XKohnrjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDTQbvqag9d0Fc35Vb3H1JGUSaVENsaNVXWJfqqR3m81eIyJLVIyzxbU8Uvu/aYIdSbz8aXpHPJQdcM80k3qANwCAi+6w6CSTCa6alvoTdqTM95fDZPJf0dUOJfL0HEj/106PjceTorG2xxcX0BIjZhi0NCc9qYxO2b8C0b37f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=qT5ZFckx; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=f/pcKaypqceFHEPfKK+Ibfi/4eqr2qKDeXT4i6nPJGc=; b=qT5ZFckxz+D5UD9knFKpfSmoi6
	Uc/4tmOuR70gjIkmEJ6hUQiYihBrN6c2WXTwjks72w3M+VULritw11RQGvXB7pYQyJptel/1ym6dH
	rrAMP6LnIpoDpbn3RckoNleMnHYYf76OO1hcYoJ1Hu7JL6FdolIMt6VVaB9rbk2wlNadptrad+4S1
	sf0JP6xYNlSf6Hh7poDlrkRNywCokngP6hVBlVTMNnUnPuVH4AQJ8GoOweUtmx41SdASiweWuqSmE
	dCLLBOFY+l0qnKsenEsEYZA7noQOx9piYFsQs+Jia2+nH8vvxTcd8UeKXjGj+TSp4aUvzBMpU+Rnh
	qTyM1Rxg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkeg-00000001pFm-2YYu;
	Thu, 08 Jan 2026 07:42:02 +0000
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
Subject: [RFC PATCH 2/8] non-consuming variant of do_linkat()
Date: Thu,  8 Jan 2026 07:41:55 +0000
Message-ID: <20260108074201.435280-3-viro@zeniv.linux.org.uk>
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

similar to previous commit; replacement is filename_linkat()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 Documentation/filesystems/porting.rst |  6 +++---
 fs/init.c                             |  5 +++--
 fs/internal.h                         |  2 +-
 fs/namei.c                            | 17 +++++++++--------
 io_uring/fs.c                         |  5 +++--
 5 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 577f7f952a51..8ecbc41d6d82 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1339,6 +1339,6 @@ in-tree filesystems have done).
 
 **mandatory**
 
-do_renameat2() is gone; filename_renameat2() replaces it.  The difference
-is that the former used to consume filename references; the latter does
-not.
+do_{link,renameat2}() are gone; filename_{link,renameat2}() replaces those.
+The difference is that the former used to consume filename references;
+the latter do not.
diff --git a/fs/init.c b/fs/init.c
index da6500d2ee98..f46e54552931 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -145,8 +145,9 @@ int __init init_mknod(const char *filename, umode_t mode, unsigned int dev)
 
 int __init init_link(const char *oldname, const char *newname)
 {
-	return do_linkat(AT_FDCWD, getname_kernel(oldname),
-			 AT_FDCWD, getname_kernel(newname), 0);
+	CLASS(filename_kernel, old)(oldname);
+	CLASS(filename_kernel, new)(newname);
+	return filename_linkat(AT_FDCWD, old, AT_FDCWD, new, 0);
 }
 
 int __init init_symlink(const char *oldname, const char *newname)
diff --git a/fs/internal.h b/fs/internal.h
index 5047cfbb8c93..c9b70c2716d1 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -62,7 +62,7 @@ int filename_renameat2(int olddfd, struct filename *oldname, int newdfd,
 int do_mkdirat(int dfd, struct filename *name, umode_t mode);
 int do_mknodat(int dfd, struct filename *name, umode_t mode, unsigned int dev);
 int do_symlinkat(struct filename *from, int newdfd, struct filename *to);
-int do_linkat(int olddfd, struct filename *old, int newdfd,
+int filename_linkat(int olddfd, struct filename *old, int newdfd,
 			struct filename *new, int flags);
 int vfs_tmpfile(struct mnt_idmap *idmap,
 		const struct path *parentpath,
diff --git a/fs/namei.c b/fs/namei.c
index c54beaf193e0..1f003ac9470e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5685,12 +5685,10 @@ EXPORT_SYMBOL(vfs_link);
  * We don't follow them on the oldname either to be compatible
  * with linux 2.0, and to avoid hard-linking to directories
  * and other special files.  --ADM
- */
-int do_linkat(int olddfd, struct filename *__old, int newdfd,
-	      struct filename *__new, int flags)
+*/
+int filename_linkat(int olddfd, struct filename *old,
+		    int newdfd, struct filename *new, int flags)
 {
-	CLASS(filename_consume, old)(__old);
-	CLASS(filename_consume, new)(__new);
 	struct mnt_idmap *idmap;
 	struct dentry *new_dentry;
 	struct path old_path, new_path;
@@ -5756,13 +5754,16 @@ int do_linkat(int olddfd, struct filename *__old, int newdfd,
 SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname, int, flags)
 {
-	return do_linkat(olddfd, getname_uflags(oldname, flags),
-		newdfd, getname(newname), flags);
+	CLASS(filename_uflags, old)(oldname, flags);
+	CLASS(filename, new)(newname);
+	return filename_linkat(olddfd, old, newdfd, new, flags);
 }
 
 SYSCALL_DEFINE2(link, const char __user *, oldname, const char __user *, newname)
 {
-	return do_linkat(AT_FDCWD, getname(oldname), AT_FDCWD, getname(newname), 0);
+	CLASS(filename, old)(oldname);
+	CLASS(filename, new)(newname);
+	return filename_linkat(AT_FDCWD, old, AT_FDCWD, new, 0);
 }
 
 /**
diff --git a/io_uring/fs.c b/io_uring/fs.c
index e5829d112c9e..e39cd1ca1942 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -280,12 +280,13 @@ int io_linkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_link *lnk = io_kiocb_to_cmd(req, struct io_link);
+	CLASS(filename_complete_delayed, old)(&lnk->oldpath);
+	CLASS(filename_complete_delayed, new)(&lnk->newpath);
 	int ret;
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = do_linkat(lnk->old_dfd, complete_getname(&lnk->oldpath),
-			lnk->new_dfd, complete_getname(&lnk->newpath), lnk->flags);
+	ret = filename_linkat(lnk->old_dfd, old, lnk->new_dfd, new, lnk->flags);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
-- 
2.47.3


