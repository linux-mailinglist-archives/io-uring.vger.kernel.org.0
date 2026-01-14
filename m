Return-Path: <io-uring+bounces-11644-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B492D1C5D8
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:34:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 41ED0306CA72
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BACE2EBBB7;
	Wed, 14 Jan 2026 04:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="AMW+vAzX"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E4F2857CC;
	Wed, 14 Jan 2026 04:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365114; cv=none; b=cl0ELShPdb9ztrO4ApOn4L1byKWV6zc/sVpVNTtHvXol9uGI1ZQcfM+PG4ofvF5CgOEmQHxCemlbIi2mpiW+3fiAIUKFZ5V58SX7LrJwqcI4ZiAGxbYvA/hJICjCRw1M8oi2r6SB5JVF9nwELfBO45V/N3GiutwEyRJAOyXKZ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365114; c=relaxed/simple;
	bh=wyl2OwewftmSzA2GDeE7hJpAYHdBh4Z9OpsDMrLqY5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVU5yDObrwdSTwd97ZPBiQ+fkngQxpfuAOFWfnrhVDaUtgEW401Ol3ukjIs1W6W+3CfWPqeAp455Cn0qn0Brfy4/0pCECsEBiGuv+EM1VogUHAbarr2zrAvZB1qlHQfsLlbvrYdYUZ5JtMoVkXVqIDhsqwN03GzAoOUhJ36rAmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=AMW+vAzX; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8t9Yib6JJzwfWRyoSOX6RtjnhtOU3jM57OI5Cs+WPdk=; b=AMW+vAzX7YsaDU7sVIaXb7nGrS
	HYr249VOST23QoBmkeG2eIexjkd3x2KGetxgrmUCSzf9+zHqOhrWUntrn8vF5J4gtUNk7BhjW9f3U
	ub0YoQfFFntcFaMNIPrMGXXeWyczHSTAvdCa2m8sNOAmFwDhNM6w4g+5/05vQix30E0ZVGZg1H8JR
	2I/ywPvS6XP2XaIB67Ke5vcFldH+x4kJaJk4ASH2XwPNmXQi/Y+PsI0JRvvCd9Q371hvQCvCtQFzT
	8S5oL3LHXLIbCW0KkvE2I+790mWF9G/TGXN3JVWnlJS+3f6jjpUbbQFfCjoyUAwLYgW3XltrOXSPA
	tMbbIBlw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZH-0000000GIpm-0x4N;
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
Subject: [PATCH v5 38/68] switch {alloc,free}_bprm() to CLASS()
Date: Wed, 14 Jan 2026 04:32:40 +0000
Message-ID: <20260114043310.3885463-39-viro@zeniv.linux.org.uk>
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

All linux_binprm instances come from alloc_bprm() and are unconditionally
destroyed by free_bprm() in the end of the same scope.  IOW, CLASS()
machinery is a decent fit for those.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/exec.c | 48 +++++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 9e799af13602..5dd8ff61f27a 100644
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
@@ -1779,7 +1782,6 @@ static int do_execveat_common(int fd, struct filename *filename,
 			      struct user_arg_ptr envp,
 			      int flags)
 {
-	struct linux_binprm *bprm;
 	int retval;
 
 	/*
@@ -1796,36 +1798,36 @@ static int do_execveat_common(int fd, struct filename *filename,
 	 * further execve() calls fail. */
 	current->flags &= ~PF_NPROC_EXCEEDED;
 
-	bprm = alloc_bprm(fd, filename, flags);
+	CLASS(bprm, bprm)(fd, filename, flags);
 	if (IS_ERR(bprm))
 		return PTR_ERR(bprm);
 
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
@@ -1836,24 +1838,19 @@ static int do_execveat_common(int fd, struct filename *filename,
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
@@ -1861,43 +1858,40 @@ int kernel_execve(const char *kernel_filename,
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
 
 void set_binfmt(struct linux_binfmt *new)
-- 
2.47.3


