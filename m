Return-Path: <io-uring+bounces-11657-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C052D1C5BD
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:33:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E911C30116D3
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA00332B98E;
	Wed, 14 Jan 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="htEazoqk"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A3628CF77;
	Wed, 14 Jan 2026 04:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365116; cv=none; b=TGmfK5jRw9OrNScQgUUJhzrCkg/TLqTDW0C1PaOQwQG3YtvNWEPDvnkqec9q49gKn/7AnbKRhjHY1G2jYRnMc+7CjJkzANcU5yoAC74SAU+10B3w2friSOOgihatLrI4viamjpRb6BVcqHi+56ZpeUQtVUWl4+umSWTACBPkrvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365116; c=relaxed/simple;
	bh=cdXfVHKKa0r3+DKEEAMGsiNrPAZtfzZXYTdRSq3MJh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdJ37rDE2skIuFbMs8sm0jrG4NjTSpNpkLJ+4i6/umgvQP+5s7hA48dna8QFsjDVE2BPGpi1bamoVqbr2ruX/129UlfcDcMd2EkElvIS/caFIaCxa77aticFamA+WUTlR1iTNhUPxGF4FfKhK6o0/fHJYrYH8HUfliH4jUXFSKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=htEazoqk; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QgePtgHmD8xN/7LrFzcz/pHX+x7oQtmi+XaPljSl06E=; b=htEazoqkGzok/iZdwRjRWkmJ4j
	A8NhIKGZKOqnEtrKP6NAm7nMbJsZS7Vfe8nbc+9RVS6Q8kDSNunzOoxLljvGkVg3DJgySa31cCQhL
	Uk4N4TufpPW/u6zLas5YSbe+icHb6izlWqEARVWzeqILvEzo0fNxU+k5LCSTX9+WRImTTvytTixml
	KieIJ1VkCMUum7oC+Zb0/7PzyIybsLsrbYMKNzTdDsYHva5369Vf1krahkK6mYfnGhrYJDHe59NZB
	i/0PI/NAIFy/TYROx3/rdcVcj7Bepj8li/GQ/FbG42s197yfNn7a+YpKxKuT97JsPH3odTBVek193
	MUKT4GTg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZI-0000000GIrE-0sAX;
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
Subject: [PATCH v5 41/68] non-consuming variant of do_symlinkat()
Date: Wed, 14 Jan 2026 04:32:43 +0000
Message-ID: <20260114043310.3885463-42-viro@zeniv.linux.org.uk>
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

similar to previous commit; replacement is filename_symlinkat()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 Documentation/filesystems/porting.rst |  6 +++---
 fs/init.c                             |  5 +++--
 fs/internal.h                         |  2 +-
 fs/namei.c                            | 23 +++++++++++------------
 io_uring/fs.c                         |  5 +++--
 5 files changed, 21 insertions(+), 20 deletions(-)

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
index e5d494610c2c..c88ad27f66c7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5581,7 +5581,7 @@ int vfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_symlink);
 
-int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
+int filename_symlinkat(struct filename *from, int newdfd, struct filename *to)
 {
 	int error;
 	struct dentry *dentry;
@@ -5589,15 +5589,13 @@ int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
 	unsigned int lookup_flags = 0;
 	struct delegated_inode delegated_inode = { };
 
-	if (IS_ERR(from)) {
-		error = PTR_ERR(from);
-		goto out_putnames;
-	}
+	if (IS_ERR(from))
+		return PTR_ERR(from);
+
 retry:
 	dentry = filename_create(newdfd, to, &path, lookup_flags);
-	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out_putnames;
+		return PTR_ERR(dentry);
 
 	error = security_path_symlink(&path, dentry, from->name);
 	if (!error)
@@ -5613,21 +5611,22 @@ int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out_putnames:
-	putname(to);
-	putname(from);
 	return error;
 }
 
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


