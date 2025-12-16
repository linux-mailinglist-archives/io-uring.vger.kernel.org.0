Return-Path: <io-uring+bounces-11101-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C5294CC0D05
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:00:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 92E8A3097E63
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C186532A3EC;
	Tue, 16 Dec 2025 03:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="JgXu22ez"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DA53128A2;
	Tue, 16 Dec 2025 03:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857297; cv=none; b=Y7/W06tyBnZ6dIouqnEgo9xPAAa+Qb5Q3EzxAvubVzFDqkuu1S+U2ESeMv5w6TVWWG74vGfa66z/ykr24wTg9Er2sJuH9V3etv7TSdCMywjBDiK1y5Zf0tXHdnz+DSXWx+6yphj96soM78kzpDeaiXdEx2SjfBZwPWWyDZdnysM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857297; c=relaxed/simple;
	bh=SyiCZ+BkgTbuNj29/vmF2KqVFwMK6f6m3rzqyVzJ4sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5qXejBD5rOO60VFfDG2aPCVMQWuSoc53US0TU3ugGqqUVFr6NoGO9Egf+S8MEYC/H7aaPzMh/Pjq1kdEQ7Bhmi+Oye0RpQt2ICRAfNNUU9gtrICRDGOKG5vfcOvWv76Ppup4coTQH8eI2oF4YqmMnuhHe5lWNOGRImeM26Oezk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=JgXu22ez; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JUE8hPERD0FXyjZgOFJkpifcmj2y7nW76IgVSlDIJnk=; b=JgXu22ezCrA1eArKElhGet6Gdb
	hbvjL7xiwSuV3T587D1vpw4IwHUf6KJt56gmKL2IYWbFpt1axWKz/mFSqhLimfn38I1cT1JwiZ0dR
	MCeFnaDkIvfqkQXBBjrbiybYZ+OBBjKz9pSBiF0SJynclpBUvYM/YDpbfY7JDtR50KUWDFPe8wdSc
	BpV7Fm1tGDuyqXQyRRopBsjrRZL9/gTENklkaru+qBUdnpTwOvya2SzejAGh1fcdAajzVizGDNUkD
	SeUnFhFsnOjIq/+otR05+TTbjbkTkI5HAkL5We8Xx2QDN34/nEe2acpTEnal57rwWCuYHojkMtMrc
	Y2qKnuAg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9h-0000000GwKy-2ZIC;
	Tue, 16 Dec 2025 03:55:21 +0000
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
Subject: [RFC PATCH v3 30/59] simplify the callers of alloc_bprm()
Date: Tue, 16 Dec 2025 03:54:49 +0000
Message-ID: <20251216035518.4037331-31-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
References: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

alloc_bprm() starts with do_open_execat() and it will do the right
thing if given ERR_PTR() for name.  Allows to drop such checks in
its callers...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/exec.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 5b4110c7522e..1473e8c06a8c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1782,9 +1782,6 @@ static int do_execveat_common(int fd, struct filename *filename,
 	struct linux_binprm *bprm;
 	int retval;
 
-	if (IS_ERR(filename))
-		return PTR_ERR(filename);
-
 	/*
 	 * We move the actual failure in case of RLIMIT_NPROC excess from
 	 * set*uid() to execve() because too many poorly written programs
@@ -1862,7 +1859,6 @@ static int do_execveat_common(int fd, struct filename *filename,
 int kernel_execve(const char *kernel_filename,
 		  const char *const *argv, const char *const *envp)
 {
-	struct filename *filename;
 	struct linux_binprm *bprm;
 	int fd = AT_FDCWD;
 	int retval;
@@ -1871,15 +1867,10 @@ int kernel_execve(const char *kernel_filename,
 	if (WARN_ON_ONCE(current->flags & PF_KTHREAD))
 		return -EINVAL;
 
-	filename = getname_kernel(kernel_filename);
-	if (IS_ERR(filename))
-		return PTR_ERR(filename);
-
+	CLASS(filename_kernel, filename)(kernel_filename);
 	bprm = alloc_bprm(fd, filename, 0);
-	if (IS_ERR(bprm)) {
-		retval = PTR_ERR(bprm);
-		goto out_ret;
-	}
+	if (IS_ERR(bprm))
+		return PTR_ERR(bprm);
 
 	retval = count_strings_kernel(argv);
 	if (WARN_ON_ONCE(retval == 0))
@@ -1913,8 +1904,6 @@ int kernel_execve(const char *kernel_filename,
 	retval = bprm_execve(bprm);
 out_free:
 	free_bprm(bprm);
-out_ret:
-	putname(filename);
 	return retval;
 }
 
-- 
2.47.3


