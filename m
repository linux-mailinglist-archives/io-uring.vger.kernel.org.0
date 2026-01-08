Return-Path: <io-uring+bounces-11509-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E4BB7D01C7C
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 10:17:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5CFC231BAE3E
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 08:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DFBA35A942;
	Thu,  8 Jan 2026 07:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="BRhrk4U3"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CB0359FAC;
	Thu,  8 Jan 2026 07:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767858052; cv=none; b=vBy7W6dPq7mmueHZyvzoOHkMp/LNP1+Ow32g2PBDUsNQXFt+ndbRAEAcGSmvqd4wiefO8XFuXGOME1tyrqDKwhCIEzjcwuUCIWfal7a59FwqXr9LJ0Nn7+Ee5xDI0uj3q2avqxiFLZfhEPgjlgTKiXowhxCTPsGUBEMKtO5SyyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767858052; c=relaxed/simple;
	bh=YYYAsBcchiEX6jTu4koZi5Dx1eLSczpR7tymQfKyC4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBZi5mN8dpPbocpnQ3KjUCNGu53Yqt+6qCok+suyG2zFpK8FjficwRS30jYlLH4FbMlbZZAkA5FpepkvygYQNX9aqrYex/JXGzt/4XUAF11Th629+SmwnCpLw+/uns1obJGYXexBZfLJl67kNq/ZuOfNX2qx78IkTfzedId2qrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=BRhrk4U3; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JcA9xF/qUKyoDRsfXihT0Yhg31Gwyc+UC3U5oSPw9as=; b=BRhrk4U37T4C/59dzw/BVHex+o
	w9rNf0hgGN3RR2j6SvisFi6w3CQXU9UWdTOX2j7LiTbfql1x7/S8ysn99zohIyN5tMEQHCNYEytTM
	IWXE3TPrzxIIcBU/60YYCdOyzxfpx99ILJL8l89BQcytSp1qyshbYj19e94BsSS3t3OLeoS3FGCcn
	ktDjjoJe8yWH3w+3rJasA0HNMriAVZ/usO5BWTcgpZSihFRffZXdsmQCvdxzExm/N38XkkPgrJONX
	68skXOMFSqrPMUOV+azBfLFDJfLPugNjxm/7KUZabcF6NLklV8VmyPjySxKiWADnZejAt3MT03Prd
	fRyGKuOg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkei-00000001pHZ-0AhU;
	Thu, 08 Jan 2026 07:42:04 +0000
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
Subject: [RFC PATCH 8/8] do_execveat_common(): don't consume filename reference
Date: Thu,  8 Jan 2026 07:42:01 +0000
Message-ID: <20260108074201.435280-9-viro@zeniv.linux.org.uk>
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

... and convert its callers to CLASS(filename...)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/exec.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 4e192d7b7e71..3405c754da80 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1775,12 +1775,11 @@ static int bprm_execve(struct linux_binprm *bprm)
 	return retval;
 }
 
-static int do_execveat_common(int fd, struct filename *__filename,
+static int do_execveat_common(int fd, struct filename *filename,
 			      struct user_arg_ptr argv,
 			      struct user_arg_ptr envp,
 			      int flags)
 {
-	CLASS(filename_consume, filename)(__filename);
 	int retval;
 
 	/*
@@ -1927,7 +1926,8 @@ SYSCALL_DEFINE3(execve,
 		const char __user *const __user *, argv,
 		const char __user *const __user *, envp)
 {
-	return do_execveat_common(AT_FDCWD, getname(filename),
+	CLASS(filename, name)(filename);
+	return do_execveat_common(AT_FDCWD, name,
 				  native_arg(argv), native_arg(envp), 0);
 }
 
@@ -1937,7 +1937,8 @@ SYSCALL_DEFINE5(execveat,
 		const char __user *const __user *, envp,
 		int, flags)
 {
-	return do_execveat_common(fd, getname_uflags(filename, flags),
+	CLASS(filename_uflags, name)(filename, flags);
+	return do_execveat_common(fd, name,
 				  native_arg(argv), native_arg(envp), flags);
 }
 
@@ -1952,7 +1953,8 @@ COMPAT_SYSCALL_DEFINE3(execve, const char __user *, filename,
 	const compat_uptr_t __user *, argv,
 	const compat_uptr_t __user *, envp)
 {
-	return do_execveat_common(AT_FDCWD, getname(filename),
+	CLASS(filename, name)(filename);
+	return do_execveat_common(AT_FDCWD, name,
 				  compat_arg(argv), compat_arg(envp), 0);
 }
 
@@ -1962,7 +1964,8 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
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


