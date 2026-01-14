Return-Path: <io-uring+bounces-11629-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EFCE6D1C578
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5BA5A303A3DC
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9CCD2EA75E;
	Wed, 14 Jan 2026 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="VFyCCnM6"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F009A2E0925;
	Wed, 14 Jan 2026 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365111; cv=none; b=QjUyjx5fL+yWE4rejgSB1M8hrL5x2N2+GTYM9e/Qf+S9zqpAhN1eOzlLaxtIGEO9yvFz9ccSzpGwWDMRVRPZUMdb6xUm2hW3D+/xXelCs2xwYlQ0uG4qj0enFDSoa+rS83jhMM5jznujhdvDGsxgSp3eMZQ09XmRqFu49efTjio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365111; c=relaxed/simple;
	bh=R4BsGEh9vRT+BWogUYDjPeXxE9IBI/2X8eig9G6UMZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvDnzkcysEa4Pwqyc0AbAxcS9q/hVdIda7nfIGr4gsKMh9fgA7eCjusF3v4vV+KQxBNUu4mx+xGWKdy7oywBjkgdxPlz2Du3xY6J0s31q2mG8U1Oid0KYFyFFWhDEXE7VqmUQAkHDJkqFrFYY9fEuZ9hZWNr6ZkbD5YBzWL6U+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=VFyCCnM6; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=it1twp1kX+r0juotLWglqQevDLHy0Ifx1JDSAtZd98I=; b=VFyCCnM6ICp7S5eHjWCwecFiJL
	TBqa7RXugzN3lg/fOdmSNwE0pmn+2MobLicLTcQB3HaSuNO9kysb2PQ8O1XfdaDSe5qBWJPKzAtyq
	YwDqr0yhHjpzwvpawwdLpsf044V476T7ohzQfwJBUTtb1yBZLmtndgy9ljHUoqGOrCpRVh6oJSwRx
	rjJD4sw9nMgJMiJpuDSYChdU+J4KVvjpH533OQAfRg6rBnmmo5Nlrc/4PBXDr7Qs9Ke0lMvYqLYdf
	0nwutecw522t7eT1n+0UUrtyrdyd/huWJo3InlyaxumP2kxny0bY53W8KvdFbn0NSKaVREv4kYHBQ
	gV0QsL9Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZG-0000000GIoW-3fa1;
	Wed, 14 Jan 2026 04:33:14 +0000
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
Subject: [PATCH v5 36/68] execve: fold {compat_,}do_execve{,at}() into their sole callers
Date: Wed, 14 Jan 2026 04:32:38 +0000
Message-ID: <20260114043310.3885463-37-viro@zeniv.linux.org.uk>
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

All of them are wrappers for do_execveat_common() and each has
exactly one caller.  The only difference is in the way they are
constructing argv/envp arguments for do_execveat_common() and
that's easy to do with less boilerplate.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/exec.c | 80 +++++++++++++------------------------------------------
 1 file changed, 19 insertions(+), 61 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 1473e8c06a8c..5d15c0440c3d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1907,59 +1907,6 @@ int kernel_execve(const char *kernel_filename,
 	return retval;
 }
 
-static int do_execve(struct filename *filename,
-	const char __user *const __user *__argv,
-	const char __user *const __user *__envp)
-{
-	struct user_arg_ptr argv = { .ptr.native = __argv };
-	struct user_arg_ptr envp = { .ptr.native = __envp };
-	return do_execveat_common(AT_FDCWD, filename, argv, envp, 0);
-}
-
-static int do_execveat(int fd, struct filename *filename,
-		const char __user *const __user *__argv,
-		const char __user *const __user *__envp,
-		int flags)
-{
-	struct user_arg_ptr argv = { .ptr.native = __argv };
-	struct user_arg_ptr envp = { .ptr.native = __envp };
-
-	return do_execveat_common(fd, filename, argv, envp, flags);
-}
-
-#ifdef CONFIG_COMPAT
-static int compat_do_execve(struct filename *filename,
-	const compat_uptr_t __user *__argv,
-	const compat_uptr_t __user *__envp)
-{
-	struct user_arg_ptr argv = {
-		.is_compat = true,
-		.ptr.compat = __argv,
-	};
-	struct user_arg_ptr envp = {
-		.is_compat = true,
-		.ptr.compat = __envp,
-	};
-	return do_execveat_common(AT_FDCWD, filename, argv, envp, 0);
-}
-
-static int compat_do_execveat(int fd, struct filename *filename,
-			      const compat_uptr_t __user *__argv,
-			      const compat_uptr_t __user *__envp,
-			      int flags)
-{
-	struct user_arg_ptr argv = {
-		.is_compat = true,
-		.ptr.compat = __argv,
-	};
-	struct user_arg_ptr envp = {
-		.is_compat = true,
-		.ptr.compat = __envp,
-	};
-	return do_execveat_common(fd, filename, argv, envp, flags);
-}
-#endif
-
 void set_binfmt(struct linux_binfmt *new)
 {
 	struct mm_struct *mm = current->mm;
@@ -1984,12 +1931,18 @@ void set_dumpable(struct mm_struct *mm, int value)
 	__mm_flags_set_mask_dumpable(mm, value);
 }
 
+static inline struct user_arg_ptr native_arg(const char __user *const __user *p)
+{
+	return (struct user_arg_ptr){.ptr.native = p};
+}
+
 SYSCALL_DEFINE3(execve,
 		const char __user *, filename,
 		const char __user *const __user *, argv,
 		const char __user *const __user *, envp)
 {
-	return do_execve(getname(filename), argv, envp);
+	return do_execveat_common(AT_FDCWD, getname(filename),
+				  native_arg(argv), native_arg(envp), 0);
 }
 
 SYSCALL_DEFINE5(execveat,
@@ -1998,17 +1951,23 @@ SYSCALL_DEFINE5(execveat,
 		const char __user *const __user *, envp,
 		int, flags)
 {
-	return do_execveat(fd,
-			   getname_uflags(filename, flags),
-			   argv, envp, flags);
+	return do_execveat_common(fd, getname_uflags(filename, flags),
+				  native_arg(argv), native_arg(envp), flags);
 }
 
 #ifdef CONFIG_COMPAT
+
+static inline struct user_arg_ptr compat_arg(const compat_uptr_t __user *p)
+{
+	return (struct user_arg_ptr){.is_compat = true, .ptr.compat = p};
+}
+
 COMPAT_SYSCALL_DEFINE3(execve, const char __user *, filename,
 	const compat_uptr_t __user *, argv,
 	const compat_uptr_t __user *, envp)
 {
-	return compat_do_execve(getname(filename), argv, envp);
+	return do_execveat_common(AT_FDCWD, getname(filename),
+				  compat_arg(argv), compat_arg(envp), 0);
 }
 
 COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
@@ -2017,9 +1976,8 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
 		       const compat_uptr_t __user *, envp,
 		       int,  flags)
 {
-	return compat_do_execveat(fd,
-				  getname_uflags(filename, flags),
-				  argv, envp, flags);
+	return do_execveat_common(fd, getname_uflags(filename, flags),
+				  compat_arg(argv), compat_arg(envp), flags);
 }
 #endif
 
-- 
2.47.3


