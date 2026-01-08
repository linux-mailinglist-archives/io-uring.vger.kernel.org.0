Return-Path: <io-uring+bounces-11506-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DEA2AD01807
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:04:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B17FA30E2B89
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2DE359F8E;
	Thu,  8 Jan 2026 07:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="mTLiShWx"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA08358D2A;
	Thu,  8 Jan 2026 07:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767858050; cv=none; b=L3KjV1jh2wQyEsFpR+gD3LQrjZO5yfLyUJPu//XM2Vvo6yP6p0KtGf3d8tywufyBqdtburRemprDJEuEZjQXLpPAWybkMEnYRWmpSV/sUEtT08R8kId8m2msSI42LITfB7JTFGHCSIcAZD6FCYjg3v8Szjc3ceNx4MjtL9TZlgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767858050; c=relaxed/simple;
	bh=leubmykB72bFyFYFv1vCavUwDsqB4Ig52/6Yn54CKFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDVV+71bnXsLR4JIIaNNdkKpfqgNC7hjBoNpqhVY6u5UWToiQm37+MwyNuoWNkI5AjdTI3DaGCYxFJvhVYQzrL5562v1nZV/dDNBMPotYl0UZHRb3iOlL3OKqUaXgwr/eijxLraCeWNJLTwj5MOYemNLwO3Pai+8qFEj+a9XLpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=mTLiShWx; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EJN4KixNtyjOJLNsHsMCjr0MU8HqNHsUlayBGko7Et0=; b=mTLiShWxgiIEG5cNXbyZdzNw3U
	lOBGxLeYN1122PVFu7NUcCLpJF1iKBXhMobUMIOA2ZVO9eTNXFnShgROTJ/ljWPVZbyi1gXYd+Cqf
	lAVI22s3jasCXxDvZD7o8FEG2IBxjWxe4GdjJTs9QX7dg9d9kJWOQR2Smt0sRy3lJ+JaNC3znbvvB
	6yJNRg/gA8r54arVIepQSbS0oXunlDZEXA0zUs2b+U/zIGjNqpj0t/+EwczPYcx3kx9YixDA3AMoi
	mHVNs/2Oc7o/9hggaWupi5Rd8HhqFvI/D6VMrA5xbn+oO5RdqT75wUMEAKCTdASXA8mkDE6lfc//C
	WtcBhhSQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkeg-00000001pFx-38c6;
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
Subject: [RFC PATCH 3/8] non-consuming variant of do_symlinkat()
Date: Thu,  8 Jan 2026 07:41:56 +0000
Message-ID: <20260108074201.435280-4-viro@zeniv.linux.org.uk>
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

similar to previous commit; replacement is filename_symlinkat()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 Documentation/filesystems/porting.rst |  6 +++---
 fs/init.c                             |  5 +++--
 fs/internal.h                         |  2 +-
 fs/namei.c                            | 12 +++++++-----
 io_uring/fs.c                         |  5 +++--
 5 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 8ecbc41d6d82..c44c351bc297 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1339,6 +1339,6 @@ in-tree filesystems have done).
 
 **mandatory**
 
-do_{link,renameat2}() are gone; filename_{link,renameat2}() replaces those.
-The difference is that the former used to consume filename references;
-the latter do not.
+do_{link,symlink,renameat2}() are gone; filename_...() counterparts
+replace those.  The difference is that the former used to consume
+filename references; the latter do not.
diff --git a/fs/init.c b/fs/init.c
index f46e54552931..a54ef750ffe3 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -152,8 +152,9 @@ int __init init_link(const char *oldname, const char *newname)
 
 int __init init_symlink(const char *oldname, const char *newname)
 {
-	return do_symlinkat(getname_kernel(oldname), AT_FDCWD,
-			    getname_kernel(newname));
+	CLASS(filename_kernel, old)(oldname);
+	CLASS(filename_kernel, new)(newname);
+	return filename_symlinkat(old, AT_FDCWD, new);
 }
 
 int __init init_unlink(const char *pathname)
diff --git a/fs/internal.h b/fs/internal.h
index c9b70c2716d1..4a63b89c02d7 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -61,7 +61,7 @@ int filename_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
 int do_mkdirat(int dfd, struct filename *name, umode_t mode);
 int do_mknodat(int dfd, struct filename *name, umode_t mode, unsigned int dev);
-int do_symlinkat(struct filename *from, int newdfd, struct filename *to);
+int filename_symlinkat(struct filename *from, int newdfd, struct filename *to);
 int filename_linkat(int olddfd, struct filename *old, int newdfd,
 			struct filename *new, int flags);
 int vfs_tmpfile(struct mnt_idmap *idmap,
diff --git a/fs/namei.c b/fs/namei.c
index 1f003ac9470e..338e2934c520 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5541,10 +5541,8 @@ int vfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_symlink);
 
-int do_symlinkat(struct filename *__from, int newdfd, struct filename *__to)
+int filename_symlinkat(struct filename *from, int newdfd, struct filename *to)
 {
-	CLASS(filename_consume, from)(__from);
-	CLASS(filename_consume, to)(__to);
 	int error;
 	struct dentry *dentry;
 	struct path path;
@@ -5578,12 +5576,16 @@ int do_symlinkat(struct filename *__from, int newdfd, struct filename *__to)
 SYSCALL_DEFINE3(symlinkat, const char __user *, oldname,
 		int, newdfd, const char __user *, newname)
 {
-	return do_symlinkat(getname(oldname), newdfd, getname(newname));
+	CLASS(filename, old)(oldname);
+	CLASS(filename, new)(newname);
+	return filename_symlinkat(old, newdfd, new);
 }
 
 SYSCALL_DEFINE2(symlink, const char __user *, oldname, const char __user *, newname)
 {
-	return do_symlinkat(getname(oldname), AT_FDCWD, getname(newname));
+	CLASS(filename, old)(oldname);
+	CLASS(filename, new)(newname);
+	return filename_symlinkat(old, AT_FDCWD, new);
 }
 
 /**
diff --git a/io_uring/fs.c b/io_uring/fs.c
index e39cd1ca1942..cd4d88d37795 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -233,12 +233,13 @@ int io_symlinkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_symlinkat(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_link *sl = io_kiocb_to_cmd(req, struct io_link);
+	CLASS(filename_complete_delayed, old)(&sl->oldpath);
+	CLASS(filename_complete_delayed, new)(&sl->newpath);
 	int ret;
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = do_symlinkat(complete_getname(&sl->oldpath), sl->new_dfd,
-			   complete_getname(&sl->newpath));
+	ret = filename_symlinkat(old, sl->new_dfd, new);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
-- 
2.47.3


