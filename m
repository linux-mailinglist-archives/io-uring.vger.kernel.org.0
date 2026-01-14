Return-Path: <io-uring+bounces-11647-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 16E38D1C5F3
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 85B13307B82A
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45C44328B40;
	Wed, 14 Jan 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="HZ9/vhS0"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF08E2857CF;
	Wed, 14 Jan 2026 04:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365114; cv=none; b=roqLAx6lzvhKRs1EHRxjYM+glUn0zy+IpiQQpbqZUfkzTbnAZlvDmQ7mBPvxSlNIswtK3Zn6mHrGt+mi3AweBiQWikz6LhtSvW2M4nF9RgptvQVHsBnlq9zW148rzuFRZuTjmngApXo/LurYv+YqL732TpaAlubX1FG4klT+jZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365114; c=relaxed/simple;
	bh=2CZDB7CVYrwN3abWlCUw0yD3m+FK/tJCczDNaUGSNs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3mHRCek3kPAjBKIfWsfQkANImOQ+hqlE1LRCcJPX27Ier7K8wSsAFP8kD2in19ZIeF2/05OLMsHibaHhXNCptE7i2W/udAieNI6UazO6We0uDHAq8W3TGJVTYBNIZMqhwV3AjtblRL8kY8aDLFQ3nnsdiZrLy98bFK5O2o1vhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=HZ9/vhS0; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Rqf9YbK1w0YURS2qwgaIL0HRl5N0+iceYMjcZ+ffdn0=; b=HZ9/vhS097gxnXNkSE5B0lB29u
	nuQrmFtqQa1yZeDDsTyXqSzQft04PcGSozLNgL2jbkzYtgRCqhRzM3V433EXCfoHDlAythrAUDAJo
	MSWUrJO+GwEb8+da5dOMxAMXVrDG4VqDxuJsAODIUar1CPrmvOyP6YpD/4fTb0x1enViuUiBydXwK
	AFTcl6ggyXDHZO2Cyy7Vm9DWfb3RXfMbBByV+IHNn3VMC+OqvoskHXw8zTgnqXyudFBqO1R2NJrl6
	5VMubMbSisY4dAkh8PDnxrbZURqKE+OJokwQzTYnunI8guq+TTulf6GlY5MDNryr1S/PSVWNC9cHZ
	OZPx2SVw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZH-0000000GIps-1K1K;
	Wed, 14 Jan 2026 04:33:15 +0000
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
Subject: [PATCH v5 39/68] non-consuming variant of do_renameat2()
Date: Wed, 14 Jan 2026 04:32:41 +0000
Message-ID: <20260114043310.3885463-40-viro@zeniv.linux.org.uk>
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

filename_renameat2() replaces do_renameat2(); unlike the latter,
it does not drop filename references - these days it can be just
as easily arranged in the caller.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 Documentation/filesystems/porting.rst |  8 +++++++
 fs/internal.h                         |  2 +-
 fs/namei.c                            | 30 +++++++++++++--------------
 io_uring/fs.c                         |  7 ++++---
 4 files changed, 28 insertions(+), 19 deletions(-)

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
index 65a06fb312af..5354f240b86a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -6028,8 +6028,8 @@ int vfs_rename(struct renamedata *rd)
 }
 EXPORT_SYMBOL(vfs_rename);
 
-int do_renameat2(int olddfd, struct filename *from, int newdfd,
-		 struct filename *to, unsigned int flags)
+int filename_renameat2(int olddfd, struct filename *from,
+		       int newdfd, struct filename *to, unsigned int flags)
 {
 	struct renamedata rd;
 	struct path old_path, new_path;
@@ -6038,20 +6038,20 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
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
@@ -6128,30 +6128,30 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-put_names:
-	putname(from);
-	putname(to);
 	return error;
 }
 
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


