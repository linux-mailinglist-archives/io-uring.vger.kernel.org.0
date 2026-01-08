Return-Path: <io-uring+bounces-11502-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5D07D01A74
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:51:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EBDA8347BD81
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 08:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B20345740;
	Thu,  8 Jan 2026 07:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="kPjYk4Ku"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A97342539;
	Thu,  8 Jan 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857824; cv=none; b=LwzGBhl9E5xlLzAau+HwsAh9xZFhPd0rotTNzfer8jCgRmG5IFMz1JfPDWBvxlI/JiYmqVqL0ajtcBFdQlt/tHTC0hy/pvcFCH2FFS2HTfpkczHX4N6EBrdXzJ0Nlq5LiXGXuRZpBCad+6r3eUHmViEhXBq9CyaYApjD08dSnss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857824; c=relaxed/simple;
	bh=yoBvx7PMTgvFHImcnFs/b/pKX9fsUsb+NkQDY8xLuIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFVWpqU1+p9Q5/+QYf1S+bJPvkjspdnOaznEtn7lP6N1GQlK7l4gP1yQZzZOGQNkc/+ZCEl1lLk/X2Lwfb0d0czifdwIfRCBE0QgKTuy+ZjmqjLZacPoulvKmxHeLFfdFe16xl4kLicbAA2g6mnxYhe/UDgCdXePDS657gEHBSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=kPjYk4Ku; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SSzxc7/Hgm5ux3/KUYvEqBQHfG5T2IKzIwi+kql8s1A=; b=kPjYk4KuYODtLNcxf0QT/cwAzP
	5bsYDO8tac88+CCUDW1OUs2qujwGChRmHzx/IPKYvbqoOleuSP4d0Mq77BK2n6fxamPEaLVAMlxtw
	l//6jg7eRDjmfHm3YitUdLr0zHx2kAwBpYq9ROKLl2d8Yn8TNWImqJaItitX+2VtSz9l1pWDWLtIz
	1dQRoCRBJNyzaPNUItIfbmD9HOB3OwzXpHxjoOMyBdJ/NR5HPvdYcmSBbYPVyb8NJn9D9aUye+cVd
	UPaBRWpZkf/EVFmgq4lesipghKUZHSlCs9xuHTPDIC2elz0WgZkhQJe9IFhkP2gzIKL59GZ/L8Pxw
	bu+aIeFg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkb1-00000001mx4-45bB;
	Thu, 08 Jan 2026 07:38:16 +0000
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
Subject: [PATCH v4 59/59] switch init_mkdir() to use of do_mkdirat(), etc.
Date: Thu,  8 Jan 2026 07:38:03 +0000
Message-ID: <20260108073803.425343-60-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
References: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

Completely straightforward, the only obstacle is do_mknodat() being
static.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/init.c     | 88 ++++-----------------------------------------------
 fs/internal.h |  1 +
 fs/namei.c    |  2 +-
 3 files changed, 8 insertions(+), 83 deletions(-)

diff --git a/fs/init.c b/fs/init.c
index e0f5429c0a49..da6500d2ee98 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -140,78 +140,19 @@ int __init init_stat(const char *filename, struct kstat *stat, int flags)
 
 int __init init_mknod(const char *filename, umode_t mode, unsigned int dev)
 {
-	struct dentry *dentry;
-	struct path path;
-	int error;
-
-	if (S_ISFIFO(mode) || S_ISSOCK(mode))
-		dev = 0;
-	else if (!(S_ISBLK(mode) || S_ISCHR(mode)))
-		return -EINVAL;
-
-	dentry = start_creating_path(AT_FDCWD, filename, &path, 0);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-
-	mode = mode_strip_umask(d_inode(path.dentry), mode);
-	error = security_path_mknod(&path, dentry, mode, dev);
-	if (!error)
-		error = vfs_mknod(mnt_idmap(path.mnt), path.dentry->d_inode,
-				  dentry, mode, new_decode_dev(dev), NULL);
-	end_creating_path(&path, dentry);
-	return error;
+	return do_mknodat(AT_FDCWD, getname_kernel(filename), mode, dev);
 }
 
 int __init init_link(const char *oldname, const char *newname)
 {
-	struct dentry *new_dentry;
-	struct path old_path, new_path;
-	struct mnt_idmap *idmap;
-	int error;
-
-	error = kern_path(oldname, 0, &old_path);
-	if (error)
-		return error;
-
-	new_dentry = start_creating_path(AT_FDCWD, newname, &new_path, 0);
-	error = PTR_ERR(new_dentry);
-	if (IS_ERR(new_dentry))
-		goto out;
-
-	error = -EXDEV;
-	if (old_path.mnt != new_path.mnt)
-		goto out_dput;
-	idmap = mnt_idmap(new_path.mnt);
-	error = may_linkat(idmap, &old_path);
-	if (unlikely(error))
-		goto out_dput;
-	error = security_path_link(old_path.dentry, &new_path, new_dentry);
-	if (error)
-		goto out_dput;
-	error = vfs_link(old_path.dentry, idmap, new_path.dentry->d_inode,
-			 new_dentry, NULL);
-out_dput:
-	end_creating_path(&new_path, new_dentry);
-out:
-	path_put(&old_path);
-	return error;
+	return do_linkat(AT_FDCWD, getname_kernel(oldname),
+			 AT_FDCWD, getname_kernel(newname), 0);
 }
 
 int __init init_symlink(const char *oldname, const char *newname)
 {
-	struct dentry *dentry;
-	struct path path;
-	int error;
-
-	dentry = start_creating_path(AT_FDCWD, newname, &path, 0);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-	error = security_path_symlink(&path, dentry, oldname);
-	if (!error)
-		error = vfs_symlink(mnt_idmap(path.mnt), path.dentry->d_inode,
-				    dentry, oldname, NULL);
-	end_creating_path(&path, dentry);
-	return error;
+	return do_symlinkat(getname_kernel(oldname), AT_FDCWD,
+			    getname_kernel(newname));
 }
 
 int __init init_unlink(const char *pathname)
@@ -221,24 +162,7 @@ int __init init_unlink(const char *pathname)
 
 int __init init_mkdir(const char *pathname, umode_t mode)
 {
-	struct dentry *dentry;
-	struct path path;
-	int error;
-
-	dentry = start_creating_path(AT_FDCWD, pathname, &path,
-				     LOOKUP_DIRECTORY);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-	mode = mode_strip_umask(d_inode(path.dentry), mode);
-	error = security_path_mkdir(&path, dentry, mode);
-	if (!error) {
-		dentry = vfs_mkdir(mnt_idmap(path.mnt), path.dentry->d_inode,
-				  dentry, mode, NULL);
-		if (IS_ERR(dentry))
-			error = PTR_ERR(dentry);
-	}
-	end_creating_path(&path, dentry);
-	return error;
+	return do_mkdirat(AT_FDCWD, getname_kernel(pathname), mode);
 }
 
 int __init init_rmdir(const char *pathname)
diff --git a/fs/internal.h b/fs/internal.h
index 5c3e4eac34f2..4c4d2733c47a 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -60,6 +60,7 @@ int may_linkat(struct mnt_idmap *idmap, const struct path *link);
 int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
 int do_mkdirat(int dfd, struct filename *name, umode_t mode);
+int do_mknodat(int dfd, struct filename *name, umode_t mode, unsigned int dev);
 int do_symlinkat(struct filename *from, int newdfd, struct filename *to);
 int do_linkat(int olddfd, struct filename *old, int newdfd,
 			struct filename *new, int flags);
diff --git a/fs/namei.c b/fs/namei.c
index cbddd5d44a12..7418a4e725da 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5038,7 +5038,7 @@ static int may_mknod(umode_t mode)
 	}
 }
 
-static int do_mknodat(int dfd, struct filename *__name, umode_t mode,
+int do_mknodat(int dfd, struct filename *__name, umode_t mode,
 		unsigned int dev)
 {
 	CLASS(filename_consume, name)(__name);
-- 
2.47.3


