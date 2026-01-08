Return-Path: <io-uring+bounces-11488-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FCFED0177A
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:55:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BF7AD302EA36
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA7F834403B;
	Thu,  8 Jan 2026 07:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Y+cpbH2y"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E42D33DEE9;
	Thu,  8 Jan 2026 07:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857821; cv=none; b=G45zvcHmTwBYoIJIoLqr5B2qssK4L67ADb3941YNFmGos6JheDSuxourWnaUJKMp2AW/8bLxDmLnZnZbKvZk/gKa3Jp5qzG96t1468LtRDluFIMpQe2K1XQ6lFHvrh4sP1r9VnzI+tKT0Hz56ENZC16hvTREJGd5BPbYy2RFeFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857821; c=relaxed/simple;
	bh=RL/R/o810ZMmcjOAU4F/DFBw8sn97MkOpigt0uJ4rh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcVkNWPiW9RqPJhUSjB8PI4JWn21BJMojQ3zc9W8dYtoMTH+xnJ2xrdwC4JMq4orzz1XCPjDGdZc1LdRr/AMqUoHVRSXJJTBqkE5sjVaTNNPQSuQd2okt+nQQU3YZVwKyhqwcnvV1g98k0FGv/1vzf3mxt58faQah4qyDOeYpbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Y+cpbH2y; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+C4CkgqhnHhwu2xYL6rgmPkMOKMGn4QaEm3wdQcVbl0=; b=Y+cpbH2yfYsz3vrcTLAvY6Aece
	X9o8BZmb0lp9VCp3EVHQcl6GZ43sjPb2FTrjWY6Dn9frPJWAwCgYoFX6tt2QzwkirGYs4PusNgZRv
	lFWhny5Jo/IO6PPqwpuitXgNfSH3gaAtfCPFsAVWuWjwTQkNU+7dMvt5zs/bNdAA7AeWbgmtl0ssT
	bc4pXApCFSJjeRYg+ok40rBjh0Gl/zNPGne4AwLi+6VwD7hZe3Yn+eSN5n9VZ/BBXB9HulVG6kqAb
	wQGH/igZDZRYflITaBPZmuy6lfrXbKNPMfdJfQBpK7fBUlneJxdcvP9rqWq9VJ2v9IcoSMW7hip3x
	x9Ug7a8A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkaz-00000001mt5-13LH;
	Thu, 08 Jan 2026 07:38:13 +0000
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
Subject: [PATCH v4 47/59] namei.c: convert getname_kernel() callers to CLASS(filename_kernel)
Date: Thu,  8 Jan 2026 07:37:51 +0000
Message-ID: <20260108073803.425343-48-viro@zeniv.linux.org.uk>
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 5acb071c92c4..325a69f2bfff 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2993,7 +2993,7 @@ static struct dentry *__start_removing_path(int dfd, struct filename *name,
 struct dentry *kern_path_parent(const char *name, struct path *path)
 {
 	struct path parent_path __free(path_put) = {};
-	struct filename *filename __free(putname) = getname_kernel(name);
+	CLASS(filename_kernel, filename)(name);
 	struct dentry *d;
 	struct qstr last;
 	int type, error;
@@ -3014,11 +3014,8 @@ struct dentry *kern_path_parent(const char *name, struct path *path)
 
 struct dentry *start_removing_path(const char *name, struct path *path)
 {
-	struct filename *filename = getname_kernel(name);
-	struct dentry *res = __start_removing_path(AT_FDCWD, filename, path);
-
-	putname(filename);
-	return res;
+	CLASS(filename_kernel, filename)(name);
+	return __start_removing_path(AT_FDCWD, filename, path);
 }
 
 struct dentry *start_removing_user_path_at(int dfd,
@@ -3035,12 +3032,8 @@ EXPORT_SYMBOL(start_removing_user_path_at);
 
 int kern_path(const char *name, unsigned int flags, struct path *path)
 {
-	struct filename *filename = getname_kernel(name);
-	int ret = filename_lookup(AT_FDCWD, filename, flags, path, NULL);
-
-	putname(filename);
-	return ret;
-
+	CLASS(filename_kernel, filename)(name);
+	return filename_lookup(AT_FDCWD, filename, flags, path, NULL);
 }
 EXPORT_SYMBOL(kern_path);
 
@@ -3074,15 +3067,11 @@ int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
 		    const char *name, unsigned int flags,
 		    struct path *path)
 {
-	struct filename *filename;
+	CLASS(filename_kernel, filename)(name);
 	struct path root = {.mnt = mnt, .dentry = dentry};
-	int ret;
 
-	filename = getname_kernel(name);
 	/* the first argument of filename_lookup() is ignored with root */
-	ret = filename_lookup(AT_FDCWD, filename, flags, path, &root);
-	putname(filename);
-	return ret;
+	return filename_lookup(AT_FDCWD, filename, flags, path, &root);
 }
 EXPORT_SYMBOL(vfs_path_lookup);
 
@@ -4879,13 +4868,12 @@ struct file *do_file_open_root(const struct path *root,
 {
 	struct nameidata nd;
 	struct file *file;
-	struct filename *filename;
 	int flags = op->lookup_flags;
 
 	if (d_is_symlink(root->dentry) && op->intent & LOOKUP_OPEN)
 		return ERR_PTR(-ELOOP);
 
-	filename = getname_kernel(name);
+	CLASS(filename_kernel, filename)(name);
 	if (IS_ERR(filename))
 		return ERR_CAST(filename);
 
@@ -4896,7 +4884,6 @@ struct file *do_file_open_root(const struct path *root,
 	if (unlikely(file == ERR_PTR(-ESTALE)))
 		file = path_openat(&nd, op, flags | LOOKUP_REVAL);
 	restore_nameidata();
-	putname(filename);
 	return file;
 }
 
@@ -4952,11 +4939,8 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 struct dentry *start_creating_path(int dfd, const char *pathname,
 				   struct path *path, unsigned int lookup_flags)
 {
-	struct filename *filename = getname_kernel(pathname);
-	struct dentry *res = filename_create(dfd, filename, path, lookup_flags);
-
-	putname(filename);
-	return res;
+	CLASS(filename_kernel, filename)(pathname);
+	return filename_create(dfd, filename, path, lookup_flags);
 }
 EXPORT_SYMBOL(start_creating_path);
 
-- 
2.47.3


