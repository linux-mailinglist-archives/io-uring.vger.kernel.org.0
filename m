Return-Path: <io-uring+bounces-11654-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0182ED1C5B1
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:33:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D1CA43015A57
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E8E0329E46;
	Wed, 14 Jan 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="tnlUhPUv"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9733E2E1F11;
	Wed, 14 Jan 2026 04:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365116; cv=none; b=fF1I1wbkvB+B4YspV5WcHvtNJHU2ZkuFwH6tgAIisAkM1ID1Kbzqa3yBsJ/MKWMVUTybrdufLwciUT4UmtPUbY3XMF/0bxWYWi9YPnns4zPGIJAgEMqRQqOOAyN7gnSNytJUl1Q4/BbIKI3nHJu8CPTrCwrPQpU56C/2tKae77c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365116; c=relaxed/simple;
	bh=A67ihpKuJasra4IoSjVrrwwp2wKDAUjQWXIk+HIcc/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c17rX17L5xQfKzvmln/vretbQmeqnsINutLdwZ/8MjGu/joXzRmqHiGVABb3PmPy2oFT6FYL3/tJ1+dZ6kbn6Kq9IGeamy5BjwJnGJwKFWSRt6evptYpOZUxlxEYmH1v/wKF/1NaHgPHOYT5o4nIlcJtukJVV/5TvRUbh2b/CNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=tnlUhPUv; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PWzRtqCpinFdkapzExjTn2Exm30Ola9EcnVGhZVhRIk=; b=tnlUhPUvDAP4tashfqGNFubDnI
	cZguo7Pyul4dp3oOZAmc9oXr6B1qo+YU01ZvJGbj8DvAgfBGaJNXs/hKjj6ocnpmTVPDxwEY91IR0
	RcglRZNBhMWpkGYXNzD5gZqHOvjdoMB62Lu9qtvocZ3f/ucNk2kANbG8LYuCxouONrqXAgy9m41A3
	K6HfqFT3j4uXvgn8tPV4vHuohAszIyTR4akiTiiRQ+KVWXpRRocApHBYlig74Zyg2iK+GFe5OmUIh
	BLWxItHLOo6aSxuDwQouJVmWvJpLTrel3iOQJJ7lhEaIfiLQbruDwSC6CwBr0ZiEwdEs8dtTcrA6o
	zZM6xY+Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZI-0000000GIsY-425O;
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
Subject: [PATCH v5 43/68] non-consuming variant of do_mknodat()
Date: Wed, 14 Jan 2026 04:32:45 +0000
Message-ID: <20260114043310.3885463-44-viro@zeniv.linux.org.uk>
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

similar to previous commit; replacement is filename_mknodat()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 Documentation/filesystems/porting.rst |  6 +++---
 fs/init.c                             |  3 ++-
 fs/internal.h                         |  2 +-
 fs/namei.c                            | 17 ++++++++---------
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index ace0607fe39c..7e68a148dd1e 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1339,6 +1339,6 @@ in-tree filesystems have done).
 
 **mandatory**
 
-do_{mkdir,link,symlink,renameat2}() are gone; filename_...() counterparts
-replace those.  The difference is that the former used to consume
-filename references; the latter do not.
+do_{mkdir,mknod,link,symlink,renameat2}() are gone; filename_...()
+counterparts replace those.  The difference is that the former used
+to consume filename references; the latter do not.
diff --git a/fs/init.c b/fs/init.c
index 9a550ba4802f..543444c1d79e 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -140,7 +140,8 @@ int __init init_stat(const char *filename, struct kstat *stat, int flags)
 
 int __init init_mknod(const char *filename, umode_t mode, unsigned int dev)
 {
-	return do_mknodat(AT_FDCWD, getname_kernel(filename), mode, dev);
+	CLASS(filename_kernel, name)(filename);
+	return filename_mknodat(AT_FDCWD, name, mode, dev);
 }
 
 int __init init_link(const char *oldname, const char *newname)
diff --git a/fs/internal.h b/fs/internal.h
index 03638008d84a..02b5dec13ff3 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -60,7 +60,7 @@ int may_linkat(struct mnt_idmap *idmap, const struct path *link);
 int filename_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
 int filename_mkdirat(int dfd, struct filename *name, umode_t mode);
-int do_mknodat(int dfd, struct filename *name, umode_t mode, unsigned int dev);
+int filename_mknodat(int dfd, struct filename *name, umode_t mode, unsigned int dev);
 int filename_symlinkat(struct filename *from, int newdfd, struct filename *to);
 int filename_linkat(int olddfd, struct filename *old, int newdfd,
 			struct filename *new, int flags);
diff --git a/fs/namei.c b/fs/namei.c
index 21a2dbd8b9e6..ca524c5b18f4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5072,8 +5072,8 @@ static int may_mknod(umode_t mode)
 	}
 }
 
-int do_mknodat(int dfd, struct filename *name, umode_t mode,
-		unsigned int dev)
+int filename_mknodat(int dfd, struct filename *name, umode_t mode,
+		     unsigned int dev)
 {
 	struct delegated_inode di = { };
 	struct mnt_idmap *idmap;
@@ -5084,12 +5084,11 @@ int do_mknodat(int dfd, struct filename *name, umode_t mode,
 
 	error = may_mknod(mode);
 	if (error)
-		goto out1;
+		return error;
 retry:
 	dentry = filename_create(dfd, name, &path, lookup_flags);
-	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out1;
+		return PTR_ERR(dentry);
 
 	error = security_path_mknod(&path, dentry,
 			mode_strip_umask(path.dentry->d_inode, mode), dev);
@@ -5123,20 +5122,20 @@ int do_mknodat(int dfd, struct filename *name, umode_t mode,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out1:
-	putname(name);
 	return error;
 }
 
 SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, umode_t, mode,
 		unsigned int, dev)
 {
-	return do_mknodat(dfd, getname(filename), mode, dev);
+	CLASS(filename, name)(filename);
+	return filename_mknodat(dfd, name, mode, dev);
 }
 
 SYSCALL_DEFINE3(mknod, const char __user *, filename, umode_t, mode, unsigned, dev)
 {
-	return do_mknodat(AT_FDCWD, getname(filename), mode, dev);
+	CLASS(filename, name)(filename);
+	return filename_mknodat(AT_FDCWD, name, mode, dev);
 }
 
 /**
-- 
2.47.3


