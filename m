Return-Path: <io-uring+bounces-11684-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A05E8D1C6A7
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:38:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6928B30C911B
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0842331239;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="HGTog5Y8"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B82D318EE3;
	Wed, 14 Jan 2026 04:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365119; cv=none; b=LVWKtVQ8qpwDGWd5ee+kGrr62s75Lm/SrRKFKyhH3QeX1/OT28Ya4yBxWzgLVfasSeFJJLUEzz+J1kkfjnQiwJDJPj24xuYGry3dr6Z3fw3YedtndcJ7Xc+AtK0HKovDm55PyvML4nHua625YbtYbOPMRLANa+D5dHKq+CtWr6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365119; c=relaxed/simple;
	bh=ljJhsM2UM5HEh3KIUjpWPjWzR98+V6slammE6w3oPzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpHvqaYjMKj35XS9UgCE49KmOKTUVVCitMFNJsV6jqiAg/SR4uh1vKcIVATqkSqkzl5Y1BS9TlrU3UEkV5VHp8L5SkOnCbscFwL5TmDFdbDwrBmQbT32CfPQTfKgoSsV3NCv/nBTcWlpw+Tn1aQIkh2GLOu4d3H+rUVX9aIWEgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=HGTog5Y8; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=u60OFkXUnAqsCaBd4FJv+u2v9etfYl45qHO74HpFUVs=; b=HGTog5Y8Lmgj/rKKNAyvdvcIuG
	2Z96leJmRV9ue55kTKUWWbeGw/WqV40ehHQ4NfZG8+Xqz/nkcIuIVS1hvD5FFY+5NjaZrjBf82PCY
	LbyWr+5GIm30ZznDjJRXTyZxU5GIj0ftzCqvkkyIWMjdT+oy8pWitlVKyQCTRtS3utBFy0XmAZ5cg
	YOazENxsQQ32l2bIKisq0OVLEbgj787yi0nukFRVSp4aAaOuxJpJad+AxmNcN5Zcm3BGTISJ3tlmR
	9o5YDn+34bQptxTHmsilOW/FHhsA+sYkW77lh0b1V8cEh++Y7ev4cNY7zBNlABkWjE6dW2gK9SQvN
	lkbRpfgg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZM-0000000GIyW-32vR;
	Wed, 14 Jan 2026 04:33:20 +0000
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
Subject: [PATCH v5 57/68] namei.c: convert getname_kernel() callers to CLASS(filename_kernel)
Date: Wed, 14 Jan 2026 04:32:59 +0000
Message-ID: <20260114043310.3885463-58-viro@zeniv.linux.org.uk>
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ba6e15339ad6..1158beb9a399 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3002,7 +3002,7 @@ static struct dentry *__start_removing_path(int dfd, struct filename *name,
 struct dentry *kern_path_parent(const char *name, struct path *path)
 {
 	struct path parent_path __free(path_put) = {};
-	struct filename *filename __free(putname) = getname_kernel(name);
+	CLASS(filename_kernel, filename)(name);
 	struct dentry *d;
 	struct qstr last;
 	int type, error;
@@ -3023,11 +3023,8 @@ struct dentry *kern_path_parent(const char *name, struct path *path)
 
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
@@ -3044,12 +3041,8 @@ EXPORT_SYMBOL(start_removing_user_path_at);
 
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
 
@@ -3083,15 +3076,11 @@ int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
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
 
@@ -4888,13 +4877,12 @@ struct file *do_file_open_root(const struct path *root,
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
 
@@ -4905,7 +4893,6 @@ struct file *do_file_open_root(const struct path *root,
 	if (unlikely(file == ERR_PTR(-ESTALE)))
 		file = path_openat(&nd, op, flags | LOOKUP_REVAL);
 	restore_nameidata();
-	putname(filename);
 	return file;
 }
 
@@ -4961,11 +4948,8 @@ static struct dentry *filename_create(int dfd, struct filename *name,
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


