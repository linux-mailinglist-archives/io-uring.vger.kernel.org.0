Return-Path: <io-uring+bounces-11489-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EC473D01B68
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 10:00:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DDACC334FE4E
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 08:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E20343D78;
	Thu,  8 Jan 2026 07:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="r6eFesjx"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EBE33345E;
	Thu,  8 Jan 2026 07:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857821; cv=none; b=ncR1yKsWtH/5hBmJrO91FyJivhd4GXRdQka4Oxkh0zwV87YiaqKJ+OkB5l2ogVXVzYabhhZ79fiLAgwDViGU0OyyVDjfdokSiyAULp7Yid9ZzSS2xVH0/0pMBYVFZF1ANLiQ8EbuOvq2bE9kXximw3p4M9HsxAeowNH8jsYU090=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857821; c=relaxed/simple;
	bh=1CZiS82AAJJXS45jvCbc+gzS87qKdtRZQd/MOUEsnqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2hdqFznzswyQ+b8nBQGEGGXVxl8MrpG8/REH/4N9w/LuExLNsT774ihs7zVnywlafXTHNW/c/FAv1ouI/I7VdHHq+spUJa9atf192E6UbTkmTwiEehMnLkgtPADvR8aMvjt18TKCcarfVBERv9I5QoyDiUGaxqtWSqE7UtLI2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=r6eFesjx; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wPQk+O8gCXhfaPo4McPyrI7a2N9wWNcxUGToz4YmPIc=; b=r6eFesjx31MYemdCwQzeW8MTGl
	p9u5KYy/8x4nQXo0x8gP8qmUX9TkcKyVSr2NpDg7rPT+JLsCZ580kUXPwEyGLxninygNvHxoSUEoB
	ZGL9IjdKcPKzUaL5E3ZykMcJ1aOv2PI/cig34JGg3qiZA1RPMZ/RN6dpEzm0mWolOc4VFzh57Vu1P
	6F3jFSAEbEq0Y5yI9B7MrR01jplrN1xmSk1J16CD182zoiWFQINPEzp7qXgQJDrOjvNcnnOcwpdVz
	/H7i8O+bPAjXcSSHk/UAud1AQ4vI+7pDwY4wIwfNRRgV7G1ZC6l9WxnNUx9vZvfWoCJUbb0UL6Lqj
	fHKvlTDA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkay-00000001msf-4Axk;
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
Subject: [PATCH v4 45/59] do_{renameat2,linkat,symlinkat}(): use CLASS(filename_consume)
Date: Thu,  8 Jan 2026 07:37:49 +0000
Message-ID: <20260108073803.425343-46-viro@zeniv.linux.org.uk>
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

more explicit in what we do, lower odds of ending up with a leak,
fewer gotos...

... and if at some point in the future we decide to make some of those
non-consuming, it would be less noisy.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 51 +++++++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 9beb667f0307..86e2467c5460 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5572,23 +5572,22 @@ int vfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
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
@@ -5604,9 +5603,6 @@ int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out_putnames:
-	putname(to);
-	putname(from);
 	return error;
 }
 
@@ -5721,9 +5717,11 @@ EXPORT_SYMBOL(vfs_link);
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
@@ -5731,10 +5729,8 @@ int do_linkat(int olddfd, struct filename *old, int newdfd,
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
@@ -5749,7 +5745,7 @@ int do_linkat(int olddfd, struct filename *old, int newdfd,
 retry:
 	error = filename_lookup(olddfd, old, how, &old_path, NULL);
 	if (error)
-		goto out_putnames;
+		return error;
 
 	new_dentry = filename_create(newdfd, new, &new_path,
 					(how & LOOKUP_REVAL));
@@ -5785,10 +5781,6 @@ int do_linkat(int olddfd, struct filename *old, int newdfd,
 	}
 out_putpath:
 	path_put(&old_path);
-out_putnames:
-	putname(old);
-	putname(new);
-
 	return error;
 }
 
@@ -6019,9 +6011,11 @@ int vfs_rename(struct renamedata *rd)
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
@@ -6029,20 +6023,20 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
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
@@ -6119,9 +6113,6 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
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


