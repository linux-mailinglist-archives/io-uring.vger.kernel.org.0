Return-Path: <io-uring+bounces-11512-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FC97D01870
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:13:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6C99130BF004
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8AE535A954;
	Thu,  8 Jan 2026 07:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="msEkBD12"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08E9359FA9;
	Thu,  8 Jan 2026 07:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767858052; cv=none; b=QweKkijBrO5tdS2efXA+Cp9lTmvhaVLbXBTtarhOiLIMDxpHSvcZFsTjtCVsOfwL0Ezdy8mpB+NquXjT5JIYsdZ1J6mQC0SiOfMFX/1UrguB1SQr+IyGxHvznzrVsRZjY+STwb4N6PvxjzV5h59Ros5eeQ87O6+aAxprNwTB4fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767858052; c=relaxed/simple;
	bh=7LPhhj5IsozaA6yrMzSUNTnp+kwn2SaqLUWClhf7DUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAqwQHSGtz/ZWFb8oP4oK4G5NMRyKtKHHVUKT9vRSffgk0kfLyY0FdWDB1BfVL+nGE18JZvyYLsBibQgBPJZVuiJd4e22kMemwOcA1XmTihMNCyu2QD/Bd5sA4CbY3jaBQxrRm7jTUNBWrNeQtPzguekyww0Gav2aDffmGZ8khA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=msEkBD12; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zD3kiYRGctHzh4A2P9AGiCndO4lLbN2+6+4Iwm7Yc98=; b=msEkBD12l/06upOy/bTdMDK+Ar
	kYxqJP/FR41rW6cMY/XMOv6RP+EYz/0FZ9RRtzRygiwbcQto/t9z6XuNm8I0NMGkrK2hcCaIK8A4+
	/OvbvNw+yPOAaIVAIV97U4mN3k+b582nVoOxdtHQYoq/7CAmIpD9QYN5tLoFoIwLfvf7P7YdxcAPQ
	8FTjQdrvJrFWM14LwQNNgYN4a8aNCXOkk3dsoqoe2i/tUYwTs2mbPDVzqxdQOEQWtDXygLJo8WCZg
	g5EZCJeOsE9SL7djNPqqFneck9eYQqJRPCMwOa6ZZ5sBG4K2GvtdcVNvDoNmvXKu9bjpVoGQBqQaZ
	SKaYWiMg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkeh-00000001pHF-3Ddb;
	Thu, 08 Jan 2026 07:42:03 +0000
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
Subject: [RFC PATCH 7/8] execve: fold {compat_,}do_execve{,at}() into their sole callers
Date: Thu,  8 Jan 2026 07:42:00 +0000
Message-ID: <20260108074201.435280-8-viro@zeniv.linux.org.uk>
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

All of them are wrappers for do_execveat_common() and each has
exactly one caller.  The only difference is in the way they are
constructing argv/envp arguments for do_execveat_common() and
that's easy to do with less boilerplate.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/exec.c | 80 +++++++++++++------------------------------------------
 1 file changed, 19 insertions(+), 61 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 902561a878ff..4e192d7b7e71 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1893,59 +1893,6 @@ int kernel_execve(const char *kernel_filename,
 	return bprm_execve(bprm);
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
@@ -1970,12 +1917,18 @@ void set_dumpable(struct mm_struct *mm, int value)
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
@@ -1984,17 +1937,23 @@ SYSCALL_DEFINE5(execveat,
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
@@ -2003,9 +1962,8 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
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


