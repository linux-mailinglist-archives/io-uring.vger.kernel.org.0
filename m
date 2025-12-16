Return-Path: <io-uring+bounces-11113-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B34ACC0DDB
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:19:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 92B4030DB8AE
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D45E32C954;
	Tue, 16 Dec 2025 04:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="MvgofVRh"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2460523E23C;
	Tue, 16 Dec 2025 04:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765858302; cv=none; b=tbM2d4OJyOPdUNUh4oL1qWLnCjuV8fCsdmuAweCzXU/dHE3m9eDvG4rrXIA70x2AKLJ6F5flS2/fKFX5kt5uXdubS+Cn5YVLkJiTosUk8HGTwgjEVut55BnXjeza3E2pnpOUZygZ/l9Z0HrxVQmTAwWeQvPtaAo30suINwOiCrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765858302; c=relaxed/simple;
	bh=JxoPlOpcg0oGQLN4QWlbwGiY52Bl6rhu0sCkqkWlB0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Je/VfU8EoXbdet6nO9NOt/5C3n6CyJwcko611/MNhlXnpTnK3DwPihAaJ0fKcyNSn+Nr/HJXsuRwioR0WxC7AvZPp68yUp+8GYmdBKeBopuWehpqwbxqsioXmJ3Bt42j7qFxAFCuoWTCKzaE1IIyNhGGHPmeW94ojTEhGXktBAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=MvgofVRh; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QCkosoRHWsc38Yz0KlJpf83zLfaWiyfCSfICrDx8I1g=; b=MvgofVRhlJOLHbTNrRUKadVjs+
	IFUC9oa6eAuf8WKwU6X1TsZlRbTJzxONFuPVZHp8srfIYBiIW/D9SnOzM1ygY8TX4vp0ZRgNiBVzD
	27pyu/G2LlE6mCjXZtZQcCu8o8BzB3oND3DgHR+x7A3fMKKYCp2NH5S3opdOTv9yrQF1EpvVqNBw+
	96W3qXFEXg1W+HOsF37CxqDspCcjZ8iQAeZ9IXQSVZRCEa+XNzsxE6FA2CkFMBpVtkst3OrzSzFzY
	c4PM4lJFS7wmWVQX1PSRkprpjZrjPJkO+v2aTgCWgdwTbdqDNoMRyo5pJIan/edP+2RWZzTAXuC38
	jnX10G7g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9j-0000000GwMj-3g1J;
	Tue, 16 Dec 2025 03:55:23 +0000
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
Subject: [RFC PATCH v3 46/59] do_{renameat2,linkat,symlinkat}(): use CLASS(filename_consume)
Date: Tue, 16 Dec 2025 03:55:05 +0000
Message-ID: <20251216035518.4037331-47-viro@zeniv.linux.org.uk>
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

more explicit in what we do, lower odds of ending up with a leak,
fewer gotos...

... and if at some point in the future we decide to make some of those
non-consuming, it would be less noisy.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 51 +++++++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f6b5d6a657da..fbf306fe8414 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5575,23 +5575,22 @@ int vfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_symlink);
 
-int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
+int do_symlinkat(struct filename *__from, int newdfd, struct filename *__to)
 {
+	CLASS(filename_consume, from)(__from);
+	CLASS(filename_consume, to)(__to);
 	int error;
 	struct dentry *dentry;
 	struct path path;
 	unsigned int lookup_flags = 0;
 	struct delegated_inode delegated_inode = { };
 
-	if (IS_ERR(from)) {
-		error = PTR_ERR(from);
-		goto out_putnames;
-	}
+	if (IS_ERR(from))
+		return PTR_ERR(from);
 retry:
 	dentry = filename_create(newdfd, to, &path, lookup_flags);
-	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out_putnames;
+		return PTR_ERR(dentry);
 
 	error = security_path_symlink(&path, dentry, from->name);
 	if (!error)
@@ -5607,9 +5606,6 @@ int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out_putnames:
-	putname(to);
-	putname(from);
 	return error;
 }
 
@@ -5724,9 +5720,11 @@ EXPORT_SYMBOL(vfs_link);
  * with linux 2.0, and to avoid hard-linking to directories
  * and other special files.  --ADM
  */
-int do_linkat(int olddfd, struct filename *old, int newdfd,
-	      struct filename *new, int flags)
+int do_linkat(int olddfd, struct filename *__old, int newdfd,
+	      struct filename *__new, int flags)
 {
+	CLASS(filename_consume, old)(__old);
+	CLASS(filename_consume, new)(__new);
 	struct mnt_idmap *idmap;
 	struct dentry *new_dentry;
 	struct path old_path, new_path;
@@ -5734,10 +5732,8 @@ int do_linkat(int olddfd, struct filename *old, int newdfd,
 	int how = 0;
 	int error;
 
-	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0) {
-		error = -EINVAL;
-		goto out_putnames;
-	}
+	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0)
+		return -EINVAL;
 	/*
 	 * To use null names we require CAP_DAC_READ_SEARCH or
 	 * that the open-time creds of the dfd matches current.
@@ -5752,7 +5748,7 @@ int do_linkat(int olddfd, struct filename *old, int newdfd,
 retry:
 	error = filename_lookup(olddfd, old, how, &old_path, NULL);
 	if (error)
-		goto out_putnames;
+		return error;
 
 	new_dentry = filename_create(newdfd, new, &new_path,
 					(how & LOOKUP_REVAL));
@@ -5788,10 +5784,6 @@ int do_linkat(int olddfd, struct filename *old, int newdfd,
 	}
 out_putpath:
 	path_put(&old_path);
-out_putnames:
-	putname(old);
-	putname(new);
-
 	return error;
 }
 
@@ -6022,9 +6014,11 @@ int vfs_rename(struct renamedata *rd)
 }
 EXPORT_SYMBOL(vfs_rename);
 
-int do_renameat2(int olddfd, struct filename *from, int newdfd,
-		 struct filename *to, unsigned int flags)
+int do_renameat2(int olddfd, struct filename *__from, int newdfd,
+		 struct filename *__to, unsigned int flags)
 {
+	CLASS(filename_consume, from)(__from);
+	CLASS(filename_consume, to)(__to);
 	struct renamedata rd;
 	struct path old_path, new_path;
 	struct qstr old_last, new_last;
@@ -6032,20 +6026,20 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
 	struct delegated_inode delegated_inode = { };
 	unsigned int lookup_flags = 0;
 	bool should_retry = false;
-	int error = -EINVAL;
+	int error;
 
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
-		goto put_names;
+		return -EINVAL;
 
 	if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
 	    (flags & RENAME_EXCHANGE))
-		goto put_names;
+		return -EINVAL;
 
 retry:
 	error = filename_parentat(olddfd, from, lookup_flags, &old_path,
 				  &old_last, &old_type);
 	if (error)
-		goto put_names;
+		return error;
 
 	error = filename_parentat(newdfd, to, lookup_flags, &new_path, &new_last,
 				  &new_type);
@@ -6122,9 +6116,6 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-put_names:
-	putname(from);
-	putname(to);
 	return error;
 }
 
-- 
2.47.3


