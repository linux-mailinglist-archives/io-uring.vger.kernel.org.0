Return-Path: <io-uring+bounces-11641-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 993D0D1C5CF
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:33:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6C6B63065B7D
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BAB0322B74;
	Wed, 14 Jan 2026 04:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="F1NlNsMc"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC94A27B32C;
	Wed, 14 Jan 2026 04:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365113; cv=none; b=O3OCt4HDUF2BwYy/Nw9NTFp+1qgQqnD0c6t9kJ40+20v0k2H9374N5mEelJ79K4YM00hzCAZOnSxQQ4PTvNJbTc0KgPSvp5+vNCK209mgUMOgTaxaDYDJtzudeos9nICMjZgCgqky0X4zZUSXQytcWzbEhzgVj56InUq3AzHFJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365113; c=relaxed/simple;
	bh=av9suRxH/37UFm53T9UpXb9WlDmQfxwVuqUciT4uPIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuIrpYOaMGHw3cueij4SwpA2a16GJ1bSfN2QIOxKYOVDqxqyyo9eviEK3Gm/wfLYIWzXmFF7y/HCYuyl2qQc+cjv3sR9/SZYQlx1IHrQQxWoTDC9iGHl8Blog2gj2YQze5hhbgHaTlGz7hAveUUNhHktT2/5ryLkT3S3eEUk0eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=F1NlNsMc; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=X7jzL/LB8VmNSWhjEMOaVlC5iqrIbTfUbf9f5vgIgz4=; b=F1NlNsMcJw7hphjoW+hHY5faZL
	lFDSxumUMzLujM+2RREYb1fIKsiak47lj+B5xA8TJpLdAUQyTj2ckcuvsUyLXs1/IolhyHttvXabb
	Ur2dPAa98Re73v2YJdbQ9bQMGA8a4R4ElnSSlKJLK96Zm3HegKFZbJXJ93OfVRWZhxHfLtcVSXAoS
	c4jKpUK2yneSeUh/eaOr/tSXLxNR+AQSV3iKzqYBtBxanY3BTPqxwKakU85f6ufeerXvz2ItCcQQV
	jmi7OWQcdNdS5dJX0EVR1nNw95EPPUMH/TnptYoYQW3YZNfy7+kqBAc4aJPETx1D9SKHhegutNHIz
	D7xxIcow==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZH-0000000GIqX-4B4O;
	Wed, 14 Jan 2026 04:33:16 +0000
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
Subject: [PATCH v5 40/68] non-consuming variant of do_linkat()
Date: Wed, 14 Jan 2026 04:32:42 +0000
Message-ID: <20260114043310.3885463-41-viro@zeniv.linux.org.uk>
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

similar to previous commit; replacement is filename_linkat()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 Documentation/filesystems/porting.rst |  6 +++---
 fs/init.c                             |  5 +++--
 fs/internal.h                         |  2 +-
 fs/namei.c                            | 27 ++++++++++++---------------
 io_uring/fs.c                         |  5 +++--
 5 files changed, 22 insertions(+), 23 deletions(-)

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
index 5354f240b86a..e5d494610c2c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5729,9 +5729,9 @@ EXPORT_SYMBOL(vfs_link);
  * We don't follow them on the oldname either to be compatible
  * with linux 2.0, and to avoid hard-linking to directories
  * and other special files.  --ADM
- */
-int do_linkat(int olddfd, struct filename *old, int newdfd,
-	      struct filename *new, int flags)
+*/
+int filename_linkat(int olddfd, struct filename *old,
+		    int newdfd, struct filename *new, int flags)
 {
 	struct mnt_idmap *idmap;
 	struct dentry *new_dentry;
@@ -5740,10 +5740,8 @@ int do_linkat(int olddfd, struct filename *old, int newdfd,
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
@@ -5758,7 +5756,7 @@ int do_linkat(int olddfd, struct filename *old, int newdfd,
 retry:
 	error = filename_lookup(olddfd, old, how, &old_path, NULL);
 	if (error)
-		goto out_putnames;
+		return error;
 
 	new_dentry = filename_create(newdfd, new, &new_path,
 					(how & LOOKUP_REVAL));
@@ -5794,23 +5792,22 @@ int do_linkat(int olddfd, struct filename *old, int newdfd,
 	}
 out_putpath:
 	path_put(&old_path);
-out_putnames:
-	putname(old);
-	putname(new);
-
 	return error;
 }
 
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


