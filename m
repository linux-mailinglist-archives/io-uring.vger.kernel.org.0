Return-Path: <io-uring+bounces-11639-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BAEC9D1C59D
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:32:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 672D1300CB74
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87F3D3242A4;
	Wed, 14 Jan 2026 04:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="esNL/zwR"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FB91DD877;
	Wed, 14 Jan 2026 04:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365113; cv=none; b=Rk8nfmyp+sX5KJ1u1a5YE7IN+uD+430guHtoJMTWDa0GpNDiqeh2rqFSFuQ1ejAGQ5ujxIH+E+GkHKJDevNKnoPHCndEY20mzagnbf3y0WbImmfB2/X11N7L4Cl9oYfnh48nVRGBerwI5AiHdrIiFex08RxqZOpssbBhGJE0Owc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365113; c=relaxed/simple;
	bh=yfzVKOGC6J1mfQAkrJGAOfs9h1A24vTRVEs1IwTgzSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7XHb5yG6WoO/SFUegU6UgHvcdzuYOuhKLwJWh3CYFU66/S8rZy86Ejny9lk7qyu7Uf6gs1NOkR+PkdOsLoAh/KE8FIyvdQobWgbhDGpmAC0LkIoClg/Kd/QD+tRqHXnyaV/mh6ecZh1IysRvtqXYssq3Uaw2NfJTbbIccuHo6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=esNL/zwR; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=glqNvFd2WCWs9BPH2ZT1TzGGKLgx5BNyq9RljQnkTIg=; b=esNL/zwRFaIc6HXCD9ivssxvLX
	OFZXOop3QmRIelnyfyzk+/EBiloD5R0xQZjfc2rNesa/5qiqjnQ7NPNo10ZdL9efAWy2jZmINWzCk
	/Vjwp9DJvTFBk8JLvqrjIlqsZErcChBVsdKUqtdKY3TWAyScjTdIIGr+0IuM6BgunUGtvb/tNhm/q
	oAfz62ZjXK3liPbvIbbiTzH4y09Y71/wAGbrvZpEbXCj2xBe0JErPm9rT1KM/zfzuS1MgFRkbEmJo
	0ArxqTpQ9XZIzQsS1NZu7xajqWtdcvHiow2kfxj5DuXcCfXC2sluAEaD5d3ClmE3dsyHKgymbAqzu
	E9pltGXA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZG-0000000GIoZ-4BOQ;
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
Subject: [PATCH v5 37/68] do_execveat_common(): don't consume filename reference
Date: Wed, 14 Jan 2026 04:32:39 +0000
Message-ID: <20260114043310.3885463-38-viro@zeniv.linux.org.uk>
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

... and convert its callers to CLASS(filename...)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/exec.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 5d15c0440c3d..9e799af13602 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1789,20 +1789,16 @@ static int do_execveat_common(int fd, struct filename *filename,
 	 * whether NPROC limit is still exceeded.
 	 */
 	if ((current->flags & PF_NPROC_EXCEEDED) &&
-	    is_rlimit_overlimit(current_ucounts(), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC))) {
-		retval = -EAGAIN;
-		goto out_ret;
-	}
+	    is_rlimit_overlimit(current_ucounts(), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)))
+		return -EAGAIN;
 
 	/* We're below the limit (still or again), so we don't want to make
 	 * further execve() calls fail. */
 	current->flags &= ~PF_NPROC_EXCEEDED;
 
 	bprm = alloc_bprm(fd, filename, flags);
-	if (IS_ERR(bprm)) {
-		retval = PTR_ERR(bprm);
-		goto out_ret;
-	}
+	if (IS_ERR(bprm))
+		return PTR_ERR(bprm);
 
 	retval = count(argv, MAX_ARG_STRINGS);
 	if (retval < 0)
@@ -1850,9 +1846,6 @@ static int do_execveat_common(int fd, struct filename *filename,
 	retval = bprm_execve(bprm);
 out_free:
 	free_bprm(bprm);
-
-out_ret:
-	putname(filename);
 	return retval;
 }
 
@@ -1941,7 +1934,8 @@ SYSCALL_DEFINE3(execve,
 		const char __user *const __user *, argv,
 		const char __user *const __user *, envp)
 {
-	return do_execveat_common(AT_FDCWD, getname(filename),
+	CLASS(filename, name)(filename);
+	return do_execveat_common(AT_FDCWD, name,
 				  native_arg(argv), native_arg(envp), 0);
 }
 
@@ -1951,7 +1945,8 @@ SYSCALL_DEFINE5(execveat,
 		const char __user *const __user *, envp,
 		int, flags)
 {
-	return do_execveat_common(fd, getname_uflags(filename, flags),
+	CLASS(filename_uflags, name)(filename, flags);
+	return do_execveat_common(fd, name,
 				  native_arg(argv), native_arg(envp), flags);
 }
 
@@ -1966,7 +1961,8 @@ COMPAT_SYSCALL_DEFINE3(execve, const char __user *, filename,
 	const compat_uptr_t __user *, argv,
 	const compat_uptr_t __user *, envp)
 {
-	return do_execveat_common(AT_FDCWD, getname(filename),
+	CLASS(filename, name)(filename);
+	return do_execveat_common(AT_FDCWD, name,
 				  compat_arg(argv), compat_arg(envp), 0);
 }
 
@@ -1976,7 +1972,8 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
 		       const compat_uptr_t __user *, envp,
 		       int,  flags)
 {
-	return do_execveat_common(fd, getname_uflags(filename, flags),
+	CLASS(filename_uflags, name)(filename, flags);
+	return do_execveat_common(fd, name,
 				  compat_arg(argv), compat_arg(envp), flags);
 }
 #endif
-- 
2.47.3


