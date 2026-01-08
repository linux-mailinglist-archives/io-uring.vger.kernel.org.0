Return-Path: <io-uring+bounces-11482-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 12EF8D017BC
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:59:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7E65B300874E
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82A4A34252C;
	Thu,  8 Jan 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ZEenvuQP"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AEE33B6F5;
	Thu,  8 Jan 2026 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857819; cv=none; b=lP2UfPv5x/a4Yo/2P4aIZt/4N0CC3XckXyCXzdxZ/8C8466xk1RtnSJFBBaDaFt6kiLsYw+8kwS5UBKJotkWY7ExesBXuW6RjavrWJojbixzloyjshfMh3Pvld+hVQRmhkzwDEJdWgP0S69bPmwvqUEO9MW0MYsHQ0pn7mX0i1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857819; c=relaxed/simple;
	bh=cxQv9hkw8QvbbztEqUBdFUa0fr0GoUOWAGNW8N8F0vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBXXN5vX7ikp9PF7GckzHPwPvsAiSd5qh8mlaB1Ftou7Udd/vV4DH7fMmC9vwOqbefMZ7dgpc3AwcP1LHqNI6nzSgn9erYgtwye+6VNcOs5KE1Io6e3G5zu/oVXqITg64lHrm3YumfxAMqt3l+uFQ+Y9ePX0dHBXJKl8ayUhJvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ZEenvuQP; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WNzQneQlsedcwVuOQMGa7ReO8KdF8AB19IKu4tOS5i4=; b=ZEenvuQPSO+KpeNc7B0F9QMNWx
	mIgpL4LMjCG7D66wSfpLc+vnmfgRccfz0aF3cxnH4i3rGgFsKScSONhCHj8UcOr4isSMGS/bYmI90
	jmRNZg0B+bdl/PwWYaqbH1XGeYzpqebfsRVO5HAzREzoZ4GVZRsMm+iYxEyVC+ponjn0ds2Gsc5lC
	EvqpsIushIAoeFgTcXOK1D8WAGNtyQjkuxonSEAwaqqdfTv6Ww2TI2Jlds9vPwZJcS1zdfOUyIIXb
	oiQwaiaZKNmWAxPLTGco0yVyX9WRWAzrMEPLBZbz3vMCHD6+K8q728bAloiKOOUNOACNBeeRfwXqA
	bbqeVwpQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkav-00000001moD-3OXi;
	Thu, 08 Jan 2026 07:38:09 +0000
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
Subject: [PATCH v4 32/59] switch {alloc,free}_bprm() to CLASS()
Date: Thu,  8 Jan 2026 07:37:36 +0000
Message-ID: <20260108073803.425343-33-viro@zeniv.linux.org.uk>
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

All linux_binprm instances come from alloc_bprm() and are unconditionally
destroyed by free_bprm() in the end of the same scope.  IOW, CLASS()
machinery is a decent fit for those.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/exec.c | 68 +++++++++++++++++++++++--------------------------------
 1 file changed, 28 insertions(+), 40 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 1473e8c06a8c..68986dca9b9d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1465,6 +1465,9 @@ static struct linux_binprm *alloc_bprm(int fd, struct filename *filename, int fl
 	return ERR_PTR(retval);
 }
 
+DEFINE_CLASS(bprm, struct linux_binprm *, if (!IS_ERR(_T)) free_bprm(_T),
+	alloc_bprm(fd, name, flags), int fd, struct filename *name, int flags)
+
 int bprm_change_interp(const char *interp, struct linux_binprm *bprm)
 {
 	/* If a binfmt changed the interp, free it first. */
@@ -1774,12 +1777,12 @@ static int bprm_execve(struct linux_binprm *bprm)
 	return retval;
 }
 
-static int do_execveat_common(int fd, struct filename *filename,
+static int do_execveat_common(int fd, struct filename *__filename,
 			      struct user_arg_ptr argv,
 			      struct user_arg_ptr envp,
 			      int flags)
 {
-	struct linux_binprm *bprm;
+	CLASS(filename_consume, filename)(__filename);
 	int retval;
 
 	/*
@@ -1788,48 +1791,44 @@ static int do_execveat_common(int fd, struct filename *filename,
 	 * don't check setuid() return code.  Here we additionally recheck
 	 * whether NPROC limit is still exceeded.
 	 */
-	if ((current->flags & PF_NPROC_EXCEEDED) &&
-	    is_rlimit_overlimit(current_ucounts(), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC))) {
-		retval = -EAGAIN;
-		goto out_ret;
-	}
+	if (unlikely(current->flags & PF_NPROC_EXCEEDED) &&
+	    is_rlimit_overlimit(current_ucounts(), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)))
+		return -EAGAIN;
 
 	/* We're below the limit (still or again), so we don't want to make
 	 * further execve() calls fail. */
 	current->flags &= ~PF_NPROC_EXCEEDED;
 
-	bprm = alloc_bprm(fd, filename, flags);
-	if (IS_ERR(bprm)) {
-		retval = PTR_ERR(bprm);
-		goto out_ret;
-	}
+	CLASS(bprm, bprm)(fd, filename, flags);
+	if (IS_ERR(bprm))
+		return PTR_ERR(bprm);
 
 	retval = count(argv, MAX_ARG_STRINGS);
 	if (retval < 0)
-		goto out_free;
+		return retval;
 	bprm->argc = retval;
 
 	retval = count(envp, MAX_ARG_STRINGS);
 	if (retval < 0)
-		goto out_free;
+		return retval;
 	bprm->envc = retval;
 
 	retval = bprm_stack_limits(bprm);
 	if (retval < 0)
-		goto out_free;
+		return retval;
 
 	retval = copy_string_kernel(bprm->filename, bprm);
 	if (retval < 0)
-		goto out_free;
+		return retval;
 	bprm->exec = bprm->p;
 
 	retval = copy_strings(bprm->envc, envp, bprm);
 	if (retval < 0)
-		goto out_free;
+		return retval;
 
 	retval = copy_strings(bprm->argc, argv, bprm);
 	if (retval < 0)
-		goto out_free;
+		return retval;
 
 	/*
 	 * When argv is empty, add an empty string ("") as argv[0] to
@@ -1840,27 +1839,19 @@ static int do_execveat_common(int fd, struct filename *filename,
 	if (bprm->argc == 0) {
 		retval = copy_string_kernel("", bprm);
 		if (retval < 0)
-			goto out_free;
+			return retval;
 		bprm->argc = 1;
 
 		pr_warn_once("process '%s' launched '%s' with NULL argv: empty string added\n",
 			     current->comm, bprm->filename);
 	}
 
-	retval = bprm_execve(bprm);
-out_free:
-	free_bprm(bprm);
-
-out_ret:
-	putname(filename);
-	return retval;
+	return bprm_execve(bprm);
 }
 
 int kernel_execve(const char *kernel_filename,
 		  const char *const *argv, const char *const *envp)
 {
-	struct linux_binprm *bprm;
-	int fd = AT_FDCWD;
 	int retval;
 
 	/* It is non-sense for kernel threads to call execve */
@@ -1868,43 +1859,40 @@ int kernel_execve(const char *kernel_filename,
 		return -EINVAL;
 
 	CLASS(filename_kernel, filename)(kernel_filename);
-	bprm = alloc_bprm(fd, filename, 0);
+	CLASS(bprm, bprm)(AT_FDCWD, filename, 0);
 	if (IS_ERR(bprm))
 		return PTR_ERR(bprm);
 
 	retval = count_strings_kernel(argv);
 	if (WARN_ON_ONCE(retval == 0))
-		retval = -EINVAL;
+		return -EINVAL;
 	if (retval < 0)
-		goto out_free;
+		return retval;
 	bprm->argc = retval;
 
 	retval = count_strings_kernel(envp);
 	if (retval < 0)
-		goto out_free;
+		return retval;
 	bprm->envc = retval;
 
 	retval = bprm_stack_limits(bprm);
 	if (retval < 0)
-		goto out_free;
+		return retval;
 
 	retval = copy_string_kernel(bprm->filename, bprm);
 	if (retval < 0)
-		goto out_free;
+		return retval;
 	bprm->exec = bprm->p;
 
 	retval = copy_strings_kernel(bprm->envc, envp, bprm);
 	if (retval < 0)
-		goto out_free;
+		return retval;
 
 	retval = copy_strings_kernel(bprm->argc, argv, bprm);
 	if (retval < 0)
-		goto out_free;
+		return retval;
 
-	retval = bprm_execve(bprm);
-out_free:
-	free_bprm(bprm);
-	return retval;
+	return bprm_execve(bprm);
 }
 
 static int do_execve(struct filename *filename,
-- 
2.47.3


