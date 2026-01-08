Return-Path: <io-uring+bounces-11496-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D9C3D0184F
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:11:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1E1B130EAADA
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F69345CD3;
	Thu,  8 Jan 2026 07:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="CNpDKD9+"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B88329E47;
	Thu,  8 Jan 2026 07:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857823; cv=none; b=Fhqv3JzRGE4cJ5Si19vnXx2MLqcUTW+by7IzpR35K74/aFKeCkBeKGokjsTdQYjBgduzXEQpy1OO8yv3r8vrqbf27o/dgthLkgQkSDQ3Yci9r3QxXSYUFtDzJOmLeg5jJTggo8d/yLQ1+LVGIDx0ebTkbR6jaHYhS5nu+oPUzvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857823; c=relaxed/simple;
	bh=XEXjfy6VIDObTBv09OYWsTKJyw4xhl6Gt/Rc8d8rX18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/wpt6uoXs0ok6FvFQcNI3Xst6BqTHBxmOnVXj+9oDf8+w32aw1Mv1cQ0WsYgXqDkIcMWjuHA7pDbeDZovXJGjHKhZZ1DgCc0D9UAjMQnLWbH34EGQVvAgPWWk5xfsoOvVBhjcjpgxJhICwo0gPRb6tOpfA+Z4hVE/E4w0YvxDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=CNpDKD9+; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tvKSPzQno1NrhNJ2sm6h+65XME8D8yvpinTQF+W8yKw=; b=CNpDKD9+FRr/pt7RPA0OnBdLlR
	mYeDfo+LGLKxOCRcjS0EuhYA5MlRv73iR/IJ6JaXbSmiaekWQxPyHgeBfjL2iKgaGqqzXlDnCHZPN
	reDFOidnOHaNU5f8NDxx6wkKr0Pg1DSlK7OiDmcNF6wvelfsZvxS62x5P4o63atG9cfOw8NEHljV1
	VpG86vwytf74+ceh4I6fCGlXmHYmUaxkF+BL8wkEykopt1lH1TTNZqV1CkG+ofKpZNny9Sl/4t7NG
	qQMItJnHSOuJ02iwMmSnJgM1aCW0cV1MH4dPH6RnWL6YDZxXTNheI+LjMXNTB1rVXrAgOA9YdseHC
	DIJY55Aw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkaz-00000001mtY-2WQi;
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
Subject: [PATCH v4 49/59] filename_...xattr(): don't consume filename reference
Date: Thu,  8 Jan 2026 07:37:53 +0000
Message-ID: <20260108073803.425343-50-viro@zeniv.linux.org.uk>
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

Callers switched to CLASS(filename_maybe_null) (in fs/xattr.c)
and CLASS(filename_complete_delayed) (in io_uring/xattr.c).

Experimental calling conventions change; with the existing
infrastructure it does not inconvenience the callers, at least
for these ones...

Might be worth doing the same to do_renameat2() and friends.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/xattr.c       | 33 ++++++++-------------------------
 io_uring/xattr.c |  8 ++++----
 2 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 32d445fb60aa..3e49e612e1ba 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -649,7 +649,6 @@ int file_setxattr(struct file *f, struct kernel_xattr_ctx *ctx)
 	return error;
 }
 
-/* unconditionally consumes filename */
 int filename_setxattr(int dfd, struct filename *filename,
 		      unsigned int lookup_flags, struct kernel_xattr_ctx *ctx)
 {
@@ -659,7 +658,7 @@ int filename_setxattr(int dfd, struct filename *filename,
 retry:
 	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
-		goto out;
+		return error;
 	error = mnt_want_write(path.mnt);
 	if (!error) {
 		error = do_setxattr(mnt_idmap(path.mnt), path.dentry, ctx);
@@ -670,9 +669,6 @@ int filename_setxattr(int dfd, struct filename *filename,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-
-out:
-	putname(filename);
 	return error;
 }
 
@@ -688,7 +684,6 @@ static int path_setxattrat(int dfd, const char __user *pathname,
 		.kname	= &kname,
 		.flags	= flags,
 	};
-	struct filename *filename;
 	unsigned int lookup_flags = 0;
 	int error;
 
@@ -702,7 +697,7 @@ static int path_setxattrat(int dfd, const char __user *pathname,
 	if (error)
 		return error;
 
-	filename = getname_maybe_null(pathname, at_flags);
+	CLASS(filename_maybe_null, filename)(pathname, at_flags);
 	if (!filename && dfd >= 0) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
@@ -804,7 +799,6 @@ ssize_t file_getxattr(struct file *f, struct kernel_xattr_ctx *ctx)
 	return do_getxattr(file_mnt_idmap(f), f->f_path.dentry, ctx);
 }
 
-/* unconditionally consumes filename */
 ssize_t filename_getxattr(int dfd, struct filename *filename,
 			  unsigned int lookup_flags, struct kernel_xattr_ctx *ctx)
 {
@@ -813,15 +807,13 @@ ssize_t filename_getxattr(int dfd, struct filename *filename,
 retry:
 	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
-		goto out;
+		return error;
 	error = do_getxattr(mnt_idmap(path.mnt), path.dentry, ctx);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out:
-	putname(filename);
 	return error;
 }
 
@@ -836,7 +828,6 @@ static ssize_t path_getxattrat(int dfd, const char __user *pathname,
 		.kname    = &kname,
 		.flags    = 0,
 	};
-	struct filename *filename;
 	ssize_t error;
 
 	if ((at_flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
@@ -846,7 +837,7 @@ static ssize_t path_getxattrat(int dfd, const char __user *pathname,
 	if (error)
 		return error;
 
-	filename = getname_maybe_null(pathname, at_flags);
+	CLASS(filename_maybe_null, filename)(pathname, at_flags);
 	if (!filename && dfd >= 0) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
@@ -943,7 +934,6 @@ ssize_t file_listxattr(struct file *f, char __user *list, size_t size)
 	return listxattr(f->f_path.dentry, list, size);
 }
 
-/* unconditionally consumes filename */
 static
 ssize_t filename_listxattr(int dfd, struct filename *filename,
 			   unsigned int lookup_flags,
@@ -954,15 +944,13 @@ ssize_t filename_listxattr(int dfd, struct filename *filename,
 retry:
 	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
-		goto out;
+		return error;
 	error = listxattr(path.dentry, list, size);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out:
-	putname(filename);
 	return error;
 }
 
@@ -970,13 +958,12 @@ static ssize_t path_listxattrat(int dfd, const char __user *pathname,
 				unsigned int at_flags, char __user *list,
 				size_t size)
 {
-	struct filename *filename;
 	int lookup_flags;
 
 	if ((at_flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
 		return -EINVAL;
 
-	filename = getname_maybe_null(pathname, at_flags);
+	CLASS(filename_maybe_null, filename)(pathname, at_flags);
 	if (!filename) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
@@ -1036,7 +1023,6 @@ static int file_removexattr(struct file *f, struct xattr_name *kname)
 	return error;
 }
 
-/* unconditionally consumes filename */
 static int filename_removexattr(int dfd, struct filename *filename,
 				unsigned int lookup_flags, struct xattr_name *kname)
 {
@@ -1046,7 +1032,7 @@ static int filename_removexattr(int dfd, struct filename *filename,
 retry:
 	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
-		goto out;
+		return error;
 	error = mnt_want_write(path.mnt);
 	if (!error) {
 		error = removexattr(mnt_idmap(path.mnt), path.dentry, kname->name);
@@ -1057,8 +1043,6 @@ static int filename_removexattr(int dfd, struct filename *filename,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out:
-	putname(filename);
 	return error;
 }
 
@@ -1066,7 +1050,6 @@ static int path_removexattrat(int dfd, const char __user *pathname,
 			      unsigned int at_flags, const char __user *name)
 {
 	struct xattr_name kname;
-	struct filename *filename;
 	unsigned int lookup_flags;
 	int error;
 
@@ -1077,7 +1060,7 @@ static int path_removexattrat(int dfd, const char __user *pathname,
 	if (error)
 		return error;
 
-	filename = getname_maybe_null(pathname, at_flags);
+	CLASS(filename_maybe_null, filename)(pathname, at_flags);
 	if (!filename) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index 0fb4e5303500..ba2b98cf13f9 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -109,12 +109,12 @@ int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
 int io_getxattr(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
+	CLASS(filename_complete_delayed, name)(&ix->filename);
 	int ret;
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = filename_getxattr(AT_FDCWD, complete_getname(&ix->filename),
-				LOOKUP_FOLLOW, &ix->ctx);
+	ret = filename_getxattr(AT_FDCWD, name, LOOKUP_FOLLOW, &ix->ctx);
 	io_xattr_finish(req, ret);
 	return IOU_COMPLETE;
 }
@@ -186,12 +186,12 @@ int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
 int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
+	CLASS(filename_complete_delayed, name)(&ix->filename);
 	int ret;
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = filename_setxattr(AT_FDCWD, complete_getname(&ix->filename),
-				LOOKUP_FOLLOW, &ix->ctx);
+	ret = filename_setxattr(AT_FDCWD, name, LOOKUP_FOLLOW, &ix->ctx);
 	io_xattr_finish(req, ret);
 	return IOU_COMPLETE;
 }
-- 
2.47.3


