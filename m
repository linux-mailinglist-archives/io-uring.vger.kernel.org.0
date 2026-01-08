Return-Path: <io-uring+bounces-11505-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 34C70D01876
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:13:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6F83E30DBF79
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4219F359FA0;
	Thu,  8 Jan 2026 07:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="auFntF8a"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21227359F96;
	Thu,  8 Jan 2026 07:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767858049; cv=none; b=UlRHAVtz4JuZ8o5b/pZMYeM2gIroEVZRx05W2qSXNuw8qZg487BBKcm8Dcf/s0A5ken9o+PyffRBnlgEfR6CYTro89XdnA3RqbynDXQhSkBz81lpOT13dVstH4hVzgHdQndkvXuf0AQgCy5YzyMzNJgmM6j6XoeIPLsg2dJ6dQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767858049; c=relaxed/simple;
	bh=m1gxaMVXLjla2krU+WSjoFNajSj/ZCwInzng15QuCN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEvhNNudE0gEgf6be2KE6C6ZhehUeEyJ3IYcpo3xF1pdh5anCFODbxMGGSAFca1Jk2mXJVJITnz5NK/lncOmHkGY0Lpod8bMR3iX9rCNanpGQCnI2lzYVFWLN10yLlZjhZRRazjdiP1TCMWCIV4njytDpklyRqGIUlZRQF4z2Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=auFntF8a; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sWF5Li2L10U6Q8O1FpOAg34mTLEVdj1sSni5eFWX330=; b=auFntF8a7ddM/R8lWEl01W7TUT
	i4lDiob9gjuRI68lxzVSGL4J53fSYpbh8Hs/n3Sjc0+vn1JKtugZs0spaqkQq6fA+fI5OjJw9eAAT
	yy6KtWz83Bnc/BB+KGIM+4AWfEJgyngiGrRZB8eweWjECjtl90Wv8BLBrlyGxNLyoz9sM0Sjd5EEA
	9684B5SCV0EhifjGkW3rs0msne2UD19qt8wp4bSHWQbUbUNa3g/7MxH8xHDK6L232mFvc4v2x2ENo
	8kWpms3ju8PrTdj93BiXGgcrSmq5/hFg0rcN+mhy4e/8K7utoRm7KIqudjKkXHlH2ApUhH0s0CvKe
	OO19Mzyg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkeg-00000001pFS-0zAt;
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
Subject: [RFC PATCH 1/8] non-consuming variant of do_renameat2()
Date: Thu,  8 Jan 2026 07:41:54 +0000
Message-ID: <20260108074201.435280-2-viro@zeniv.linux.org.uk>
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

filename_renameat2() replaces do_renameat2(); unlike the latter,
it does not drop filename references - these days it can be just
as easily arranged in the caller.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 Documentation/filesystems/porting.rst |  8 ++++++++
 fs/internal.h                         |  2 +-
 fs/namei.c                            | 21 +++++++++++----------
 io_uring/fs.c                         |  7 ++++---
 4 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 3397937ed838..577f7f952a51 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1334,3 +1334,11 @@ end_creating() and the parent will be unlocked precisely when necessary.
 
 kill_litter_super() is gone; convert to DCACHE_PERSISTENT use (as all
 in-tree filesystems have done).
+
+---
+
+**mandatory**
+
+do_renameat2() is gone; filename_renameat2() replaces it.  The difference
+is that the former used to consume filename references; the latter does
+not.
diff --git a/fs/internal.h b/fs/internal.h
index 4c4d2733c47a..5047cfbb8c93 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -57,7 +57,7 @@ extern int filename_lookup(int dfd, struct filename *name, unsigned flags,
 int do_rmdir(int dfd, struct filename *name);
 int do_unlinkat(int dfd, struct filename *name);
 int may_linkat(struct mnt_idmap *idmap, const struct path *link);
-int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
+int filename_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
 int do_mkdirat(int dfd, struct filename *name, umode_t mode);
 int do_mknodat(int dfd, struct filename *name, umode_t mode, unsigned int dev);
diff --git a/fs/namei.c b/fs/namei.c
index 7418a4e725da..c54beaf193e0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5980,11 +5980,9 @@ int vfs_rename(struct renamedata *rd)
 }
 EXPORT_SYMBOL(vfs_rename);
 
-int do_renameat2(int olddfd, struct filename *__from, int newdfd,
-		 struct filename *__to, unsigned int flags)
+int filename_renameat2(int olddfd, struct filename *from,
+		       int newdfd, struct filename *to, unsigned int flags)
 {
-	CLASS(filename_consume, from)(__from);
-	CLASS(filename_consume, to)(__to);
 	struct renamedata rd;
 	struct path old_path, new_path;
 	struct qstr old_last, new_last;
@@ -6088,21 +6086,24 @@ int do_renameat2(int olddfd, struct filename *__from, int newdfd,
 SYSCALL_DEFINE5(renameat2, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname, unsigned int, flags)
 {
-	return do_renameat2(olddfd, getname(oldname), newdfd, getname(newname),
-				flags);
+	CLASS(filename, old)(oldname);
+	CLASS(filename, new)(newname);
+	return filename_renameat2(olddfd, old, newdfd, new, flags);
 }
 
 SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname)
 {
-	return do_renameat2(olddfd, getname(oldname), newdfd, getname(newname),
-				0);
+	CLASS(filename, old)(oldname);
+	CLASS(filename, new)(newname);
+	return filename_renameat2(olddfd, old, newdfd, new, 0);
 }
 
 SYSCALL_DEFINE2(rename, const char __user *, oldname, const char __user *, newname)
 {
-	return do_renameat2(AT_FDCWD, getname(oldname), AT_FDCWD,
-				getname(newname), 0);
+	CLASS(filename, old)(oldname);
+	CLASS(filename, new)(newname);
+	return filename_renameat2(AT_FDCWD, old, AT_FDCWD, new, 0);
 }
 
 int readlink_copy(char __user *buffer, int buflen, const char *link, int linklen)
diff --git a/io_uring/fs.c b/io_uring/fs.c
index c04c6282210a..e5829d112c9e 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -82,13 +82,14 @@ int io_renameat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rename *ren = io_kiocb_to_cmd(req, struct io_rename);
+	CLASS(filename_complete_delayed, old)(&ren->oldpath);
+	CLASS(filename_complete_delayed, new)(&ren->newpath);
 	int ret;
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = do_renameat2(ren->old_dfd, complete_getname(&ren->oldpath),
-			   ren->new_dfd, complete_getname(&ren->newpath),
-			   ren->flags);
+	ret = filename_renameat2(ren->old_dfd, old,
+				 ren->new_dfd, new, ren->flags);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
-- 
2.47.3


