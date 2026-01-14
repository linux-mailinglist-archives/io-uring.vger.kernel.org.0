Return-Path: <io-uring+bounces-11632-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CC14D1C57B
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:32:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 27315303490D
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E695C2EA731;
	Wed, 14 Jan 2026 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="mhVIJlc7"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E845A2DF152;
	Wed, 14 Jan 2026 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365112; cv=none; b=aezPgzH8NAvJnhW8yz88kFj+pypmXVQdmhIa9vGokQ4lAGqcYyyvygap7A4+kgVGXaZwmes7Wbb+sbigxdfa5yyNIVq51at8DPS9us/Y23F6YDMlC0M/b/f4Q/zsHFiuBx+xp3VlrUgsNgT/CSvo9QG+9DxgfYujRGPPm3huhcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365112; c=relaxed/simple;
	bh=SyiCZ+BkgTbuNj29/vmF2KqVFwMK6f6m3rzqyVzJ4sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUv+GvK6vBWrm7V8aRuGgMkwzscASxC4HL90zjC/lIjSqzSX4gDGk1PamkswKMrZ+OxR8bxQgIXcQdVlpItbHujLHEOKpziWVFA4rsfeo7jdjTD6A4eTVYyB0I63IOat1zBqWTHLD8ZJLVgaQoPGO1eNO3aFsgo/g4pG+YxrnK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=mhVIJlc7; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JUE8hPERD0FXyjZgOFJkpifcmj2y7nW76IgVSlDIJnk=; b=mhVIJlc76GvD3yIlbMEZgTvgRI
	PbDGuK7YDVNZjC2PEBexK+/jJ2eOj5a+826Bxpo+KvLLOuF6ZmSJX4wZsSbfAPGp0WEaWKem5E1E1
	KK5TuAywPoGduOE83XlTcBhCFxh04ZzJepMW4JD6p+JadXtKApiHOStNJyPgW4DRVq3YAYn6sUS6K
	0NVmX9ml1LEgyzC5boMdpNn3VhcllxWgEHr20pgwBmfRIv3mNpubYxVcl4Fk2QWpXK2kRs20C65I9
	//QTN6c0sG9OUYWWD7p3aTdz6JLGN4eK/KuNYHA0DT0hjT0AgCEFei/JhiPPARqsvz4y4r9QIdbLp
	dTIT9M2Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZG-0000000GIoT-3Con;
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
Subject: [PATCH v5 35/68] simplify the callers of alloc_bprm()
Date: Wed, 14 Jan 2026 04:32:37 +0000
Message-ID: <20260114043310.3885463-36-viro@zeniv.linux.org.uk>
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


