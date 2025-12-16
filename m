Return-Path: <io-uring+bounces-11111-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C51ADCC0F4A
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 06:04:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6C1D6313A572
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 452F232D0F5;
	Tue, 16 Dec 2025 04:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="S75BdoE1"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C85341AB1;
	Tue, 16 Dec 2025 04:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765858260; cv=none; b=gs7bLG4I4sytURVX/gRO2+TKLUtprXt6Eu5rmh8uGJHNF73sF2Hr0oWHEGpwoiJ/PCnaQ1YgRaj71oRoRu+maTBESQJs+qGI730sdUerx4ifSFmT9323zamuqVyRqM1XUIT7GzpYt2oFNSijb/B0clRcii7iziXMlVoOxIHUqiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765858260; c=relaxed/simple;
	bh=BvvZDQO63zqCjWl4pWRuppkkNIKt2GO9ndvqxLd0JdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLGL9SovOMWX1yOldfv7L5BCfZ/mK2K47xXRwKsI4Fz9uflvsuGoEKkkU+7C4XGteVBNeTB6rEtwjuy8qXhEVwUOyIqMkQDRivOYzya+RrFIsvHAKm5+vAEcY270/wGxHTsna/QrEzIhiKRLPu4HcNhufkxepBkAoISDYc90A64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=S75BdoE1; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bEYM/fep+gGEfkOyqQHHsVq2A/G1M+lIwbK9CkjneDA=; b=S75BdoE14QsrVzM8nbRQGfOzhR
	4lRTZa2HW++dWzpYce3LxLBwfVsmkKMzG9FiLmizQnZUHWoizHj1M+IKTTFQ3V0SSFtxaiJE7GXtB
	oXyBNP9Jkl+0AY6FIJ9X9BlKxIHvYDY9wya71qCo8JFCfN8ySBH4BEfBuMVHkFITGhxeNEEHZ3hck
	q+N9+dVSX1tZNQ2lJlqrzaHBMUbDU+BQwMBHtQEMfBajMbEitU1MRhZsj+hviPk0h9gynwlmoe9g0
	W4u/krGaox/VhfKSKjjixx4stiUhLlVLysGSEXnhNI0m9HWgrdB++A3zl5q91twlviiEY3qIGTC/m
	VCPgGlRQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9k-0000000GwMq-01eZ;
	Tue, 16 Dec 2025 03:55:24 +0000
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
Subject: [RFC PATCH v3 48/59] namei.c: convert getname_kernel() callers to CLASS(filename_kernel)
Date: Tue, 16 Dec 2025 03:55:07 +0000
Message-ID: <20251216035518.4037331-49-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
References: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
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
index 0221cdb92297..e0c8d3832861 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2996,7 +2996,7 @@ static struct dentry *__start_removing_path(int dfd, struct filename *name,
 struct dentry *kern_path_parent(const char *name, struct path *path)
 {
 	struct path parent_path __free(path_put) = {};
-	struct filename *filename __free(putname) = getname_kernel(name);
+	CLASS(filename_kernel, filename)(name);
 	struct dentry *d;
 	struct qstr last;
 	int type, error;
@@ -3017,11 +3017,8 @@ struct dentry *kern_path_parent(const char *name, struct path *path)
 
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
@@ -3038,12 +3035,8 @@ EXPORT_SYMBOL(start_removing_user_path_at);
 
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
 
@@ -3077,15 +3070,11 @@ int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
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
 
@@ -4882,13 +4871,12 @@ struct file *do_file_open_root(const struct path *root,
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
 
@@ -4899,7 +4887,6 @@ struct file *do_file_open_root(const struct path *root,
 	if (unlikely(file == ERR_PTR(-ESTALE)))
 		file = path_openat(&nd, op, flags | LOOKUP_REVAL);
 	restore_nameidata();
-	putname(filename);
 	return file;
 }
 
@@ -4955,11 +4942,8 @@ static struct dentry *filename_create(int dfd, struct filename *name,
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


