Return-Path: <io-uring+bounces-4348-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 334679B9DA4
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 08:32:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B49F21F223E5
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 07:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B68DC1591EA;
	Sat,  2 Nov 2024 07:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="sskV78z2"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF0445016;
	Sat,  2 Nov 2024 07:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730532713; cv=none; b=Urw1aXGTaYT6UhAHiFkJTn9dBYa1WfSyzZm7rx+Nhu83dmSd+KJcpi11f381MVl8HOr02TRZiRi4jv5DjG5feUo9Izf9diHmmpTUGkm6zs7wVsdPOwaTQpCUE/K/3+leca0NLv5c8cvnxb465Dot8ZXVoEF99UZp9lwqPrRjvGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730532713; c=relaxed/simple;
	bh=nqMcjBz8OfEZR+0v3ZB8jwQ8xqq1cB2f9ecGjIT/2ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMTObQl0r8Db3CHjWQlPcZJPnYnjxj6+b4GRCxNLt4r/KVvCpBb5LmCFhTBnkWUBWGFPH2LmyoI22rM9oNsD31Z0NjUTPK3WZzUv3eNZ5cR/4B8QwY+Ny4lgggK+EyHm5in+b1hCV+CXe3CNBoLs72KluoBmzz0F4gSgqVGtz+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=sskV78z2; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RuuIHHAbSyNxuYTJWEVQRL3m+2YxijPnhKo52Q8Rk6I=; b=sskV78z2/+q8q6hSLzYMopxDaC
	oqg6EowVdFRE+bviTB+WeIu6i4FTw5yT2nuimgBWC9VeswHKkm6eMwS+8x8UUjvUlZRk9ENA3OJMa
	UjeY/vsW6AM2gNrlENNpxB9mFE1ieckfAe/ynm8rmQ7YedahdDWOZb/qIth9rK9EBc07sRSYTONtE
	Im5uu+xp7xVbiqcPvO3yLmwdLL7ulaShtZIAa5ZXZJaSoCnYeVT81+7cbOK391tG5PQD4kzQhjFqj
	ti8aPz6ZpsmjaiH2vx9xRid6Q6V57k9PAc/yAZ27Ls2LpSBr5CyCaKl9t/KykA96GeFyUXvePncdv
	+nBp5LQQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t78bt-0000000AJF3-1XWL;
	Sat, 02 Nov 2024 07:31:49 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	io-uring@vger.kernel.org,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: [PATCH v2 02/13] getname_maybe_null() - the third variant of pathname copy-in
Date: Sat,  2 Nov 2024 07:31:38 +0000
Message-ID: <20241102073149.2457240-2-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241102073149.2457240-1-viro@zeniv.linux.org.uk>
References: <20241102072834.GQ1350452@ZenIV>
 <20241102073149.2457240-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

Semantics used by statx(2) (and later *xattrat(2)): without AT_EMPTY_PATH
it's standard getname() (i.e. ERR_PTR(-ENOENT) on empty string,
ERR_PTR(-EFAULT) on NULL), with AT_EMPTY_PATH both empty string and
NULL are accepted.

Calling conventions: getname_maybe_null(user_pointer, flags) returns
	* pointer to struct filename when non-empty string had been
successfully read
	* ERR_PTR(...) on error
	* NULL if an empty string or NULL pointer had been given
with AT_EMPTY_PATH in the flags argument.

It tries to avoid allocation in the last case; it's not always
able to do so, in which case the temporary struct filename instance
is freed and NULL returned anyway.

Fast path is inlined.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c         | 30 +++++++++++++++++++++++-------
 fs/stat.c          | 28 ++++------------------------
 include/linux/fs.h | 10 ++++++++++
 3 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index aaf3cd6c802f..2bfe476c3bd0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -211,22 +211,38 @@ getname_flags(const char __user *filename, int flags)
 	return result;
 }
 
-struct filename *
-getname_uflags(const char __user *filename, int uflags)
+struct filename *getname_uflags(const char __user *filename, int uflags)
 {
 	int flags = (uflags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
 
 	return getname_flags(filename, flags);
 }
 
-struct filename *
-getname(const char __user * filename)
+struct filename *getname(const char __user * filename)
 {
 	return getname_flags(filename, 0);
 }
 
-struct filename *
-getname_kernel(const char * filename)
+struct filename *__getname_maybe_null(const char __user *pathname)
+{
+	struct filename *name;
+	char c;
+
+	/* try to save on allocations; loss on um, though */
+	if (get_user(c, pathname))
+		return ERR_PTR(-EFAULT);
+	if (!c)
+		return NULL;
+
+	name = getname_flags(pathname, LOOKUP_EMPTY);
+	if (!IS_ERR(name) && !(name->name[0])) {
+		putname(name);
+		name = NULL;
+	}
+	return name;
+}
+
+struct filename *getname_kernel(const char * filename)
 {
 	struct filename *result;
 	int len = strlen(filename) + 1;
@@ -264,7 +280,7 @@ EXPORT_SYMBOL(getname_kernel);
 
 void putname(struct filename *name)
 {
-	if (IS_ERR(name))
+	if (IS_ERR_OR_NULL(name))
 		return;
 
 	if (WARN_ON_ONCE(!atomic_read(&name->refcnt)))
diff --git a/fs/stat.c b/fs/stat.c
index 41e598376d7e..b74831dc7ae6 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -326,18 +326,11 @@ int vfs_fstatat(int dfd, const char __user *filename,
 {
 	int ret;
 	int statx_flags = flags | AT_NO_AUTOMOUNT;
-	struct filename *name;
+	struct filename *name = getname_maybe_null(filename, flags);
 
-	/*
-	 * Work around glibc turning fstat() into fstatat(AT_EMPTY_PATH)
-	 *
-	 * If AT_EMPTY_PATH is set, we expect the common case to be that
-	 * empty path, and avoid doing all the extra pathname work.
-	 */
-	if (flags == AT_EMPTY_PATH && vfs_empty_path(dfd, filename))
+	if (!name && dfd >= 0)
 		return vfs_fstat(dfd, stat);
 
-	name = getname_flags(filename, getname_statx_lookup_flags(statx_flags));
 	ret = vfs_statx(dfd, name, statx_flags, stat, STATX_BASIC_STATS);
 	putname(name);
 
@@ -774,24 +767,11 @@ SYSCALL_DEFINE5(statx,
 		struct statx __user *, buffer)
 {
 	int ret;
-	unsigned lflags;
-	struct filename *name;
+	struct filename *name = getname_maybe_null(filename, flags);
 
-	/*
-	 * Short-circuit handling of NULL and "" paths.
-	 *
-	 * For a NULL path we require and accept only the AT_EMPTY_PATH flag
-	 * (possibly |'d with AT_STATX flags).
-	 *
-	 * However, glibc on 32-bit architectures implements fstatat as statx
-	 * with the "" pathname and AT_NO_AUTOMOUNT | AT_EMPTY_PATH flags.
-	 * Supporting this results in the uglification below.
-	 */
-	lflags = flags & ~(AT_NO_AUTOMOUNT | AT_STATX_SYNC_TYPE);
-	if (lflags == AT_EMPTY_PATH && vfs_empty_path(dfd, filename))
+	if (!name && dfd >= 0)
 		return do_statx_fd(dfd, flags & ~AT_NO_AUTOMOUNT, mask, buffer);
 
-	name = getname_flags(filename, getname_statx_lookup_flags(flags));
 	ret = do_statx(dfd, name, flags, mask, buffer);
 	putname(name);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e3c603d01337..403258ac2ea2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2766,6 +2766,16 @@ extern struct filename *getname_flags(const char __user *, int);
 extern struct filename *getname_uflags(const char __user *, int);
 extern struct filename *getname(const char __user *);
 extern struct filename *getname_kernel(const char *);
+extern struct filename *__getname_maybe_null(const char __user *);
+static inline struct filename *getname_maybe_null(const char __user *name, int flags)
+{
+	if (!(flags & AT_EMPTY_PATH))
+		return getname(name);
+
+	if (!name)
+		return NULL;
+	return __getname_maybe_null(name);
+}
 extern void putname(struct filename *name);
 
 extern int finish_open(struct file *file, struct dentry *dentry,
-- 
2.39.5


