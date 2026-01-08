Return-Path: <io-uring+bounces-11475-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BB82D01879
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:13:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DDF3C30CC868
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C40334251C;
	Thu,  8 Jan 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="JQdLwO/e"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D0A334C3D;
	Thu,  8 Jan 2026 07:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857818; cv=none; b=PNWKxyb6a9LlG6r92sfmfarvq9ClaBQsl5jbHrepFjsz8KRAavxkLbNRWkArIXr02jcqerwVKRIa18+BML5s98XpmZvnmfDFMhVSXZBNlYm7NlbkpU1HxcPDyVAh7KfD7JM/+WyudydBvU0aIifTaON+A9DzvZy8mC6gHws0KjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857818; c=relaxed/simple;
	bh=SyiCZ+BkgTbuNj29/vmF2KqVFwMK6f6m3rzqyVzJ4sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cR5W+ihu3hTGCABHzpFnLNB6bMYZOlS5fpeTp4BnF1+xNS8DtF+EoATUSfo56NAF+osuI/WdTObz2KtazoReBHKDpRjKge9aYZVSUNQkKsCJ+9VkiApsqlXR/8dZFtZTPChHiZ9AtnCS1w4CMMdA0SW2STjSFS5IEIoFizG7E44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=JQdLwO/e; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JUE8hPERD0FXyjZgOFJkpifcmj2y7nW76IgVSlDIJnk=; b=JQdLwO/eAz0zlyu5thAfVW3EPt
	rOXFsDV2twyaf+VQFrbnf6U1u/T9BQXGpmC3bIbfGJSBwcbr+zgZJUEOoYJURU3VfxWcLxtlXiXJ4
	Br8unqqz2pNzHrMfs3Lo4tmJkNqfvWbsZVpqvc2ltDTOjz/BHVQwSoBLDrnE+09NLYBiCcaTaD46X
	0zWStjF4CQF1roTqYkf+hDgO2a4z3Bd07EEMCyPKii9ppu1H5s74Gu+sWSSPZTfOdLKmKeVtDbFOZ
	duoJs2gTcfZRD7BLfYmjBClAHEIV+i/FylWqJawD7zChbalbZv+ckGxI2KXmpHqxim84tlT9leQjR
	/dMjqm7A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkav-00000001mnx-2soF;
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
Subject: [PATCH v4 31/59] simplify the callers of alloc_bprm()
Date: Thu,  8 Jan 2026 07:37:35 +0000
Message-ID: <20260108073803.425343-32-viro@zeniv.linux.org.uk>
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


