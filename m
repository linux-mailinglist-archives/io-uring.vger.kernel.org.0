Return-Path: <io-uring+bounces-4352-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B53B69B9DAD
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 08:32:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2DCD3B21F02
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 07:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CAEB1494B3;
	Sat,  2 Nov 2024 07:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="kd0+eeQg"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5993513BC39;
	Sat,  2 Nov 2024 07:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730532714; cv=none; b=cohw/GoH0a5rCZLAjmTyfxMnkrrwRqmBoXTMIeDRTgza3XkYxU3gEO27fQgGBfyAcF/ssAKb759TwkXEgMkNgB/RvHsvfiX7+ngaNyWxXgJYgsKpppTEQOy14kzHptAyKUVbVQcOkeXR2r0h4moT9gZMY4VC4ifvYOMjrzLlaag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730532714; c=relaxed/simple;
	bh=rZIixYCVAgXjg7EeXFhuy7MGoTFaqUAyWO43RarR0es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtFIJoAchLn/mb6/QxBzchpOBU4/4eVcKug8XeKYuTqO+TVvpcrqwElOPa3ob6llf9Q/xunrOFn7XfYmYouzbIRTWNDL6uSaTi+eT/s3zUQgdWJU6fbiw8BsqjnIy2dAN1gxyfZ59xJlAMi0mMx6gA8Jb6XABW7EO2lg/85I9PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=kd0+eeQg; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uTtnVIFSfaEcDJ36yf/YHOGeZdYKnakFbEqlgGoMnro=; b=kd0+eeQgGc1mIvIRIx7vH36Q9l
	6Phkeh1dRj9awITXthxryFxj/zcmW4JX5I/tHdIxcOGwsJ912aph9Nh4mry5yJ3/GlzSZOZMbp7UR
	ZFYQj7W8IxEsn6p5jf527kPzQ69j9qIc63FUic/cV1IYBuvGx8GFz5/8hl4DPVxBrW4JE+xS2Pyl9
	nzy9NiUR6vaokI2uXQTUUsCbEOxEdXqN9GGDJ7ZIWnndaIs8xa08lhKoXMi2cvIRYyZYz7b0z1WLE
	2M7nKd+pPkWGU+xEJIVCqQEfN7bKMZpxtQMjCH2yRXW6VkGtcjHWSaCAdibCFLlfasrzDx6s0bycI
	N6WCQL4w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t78bt-0000000AJFI-31pv;
	Sat, 02 Nov 2024 07:31:49 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	io-uring@vger.kernel.org,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: [PATCH v2 05/13] xattr: switch to CLASS(fd)
Date: Sat,  2 Nov 2024 07:31:41 +0000
Message-ID: <20241102073149.2457240-5-viro@zeniv.linux.org.uk>
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

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/xattr.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 05ec7e7d9e87..0fc813cb005c 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -697,9 +697,9 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 	int error;
 
 	CLASS(fd, f)(fd);
-	if (!fd_file(f))
-		return -EBADF;
 
+	if (fd_empty(f))
+		return -EBADF;
 	audit_file(fd_file(f));
 	error = setxattr_copy(name, &ctx);
 	if (error)
@@ -809,16 +809,13 @@ SYSCALL_DEFINE4(lgetxattr, const char __user *, pathname,
 SYSCALL_DEFINE4(fgetxattr, int, fd, const char __user *, name,
 		void __user *, value, size_t, size)
 {
-	struct fd f = fdget(fd);
-	ssize_t error = -EBADF;
+	CLASS(fd, f)(fd);
 
-	if (!fd_file(f))
-		return error;
+	if (fd_empty(f))
+		return -EBADF;
 	audit_file(fd_file(f));
-	error = getxattr(file_mnt_idmap(fd_file(f)), fd_file(f)->f_path.dentry,
+	return getxattr(file_mnt_idmap(fd_file(f)), fd_file(f)->f_path.dentry,
 			 name, value, size);
-	fdput(f);
-	return error;
 }
 
 /*
@@ -885,15 +882,12 @@ SYSCALL_DEFINE3(llistxattr, const char __user *, pathname, char __user *, list,
 
 SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
 {
-	struct fd f = fdget(fd);
-	ssize_t error = -EBADF;
+	CLASS(fd, f)(fd);
 
-	if (!fd_file(f))
-		return error;
+	if (fd_empty(f))
+		return -EBADF;
 	audit_file(fd_file(f));
-	error = listxattr(fd_file(f)->f_path.dentry, list, size);
-	fdput(f);
-	return error;
+	return listxattr(fd_file(f)->f_path.dentry, list, size);
 }
 
 /*
@@ -950,12 +944,12 @@ SYSCALL_DEFINE2(lremovexattr, const char __user *, pathname,
 
 SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 {
-	struct fd f = fdget(fd);
+	CLASS(fd, f)(fd);
 	char kname[XATTR_NAME_MAX + 1];
-	int error = -EBADF;
+	int error;
 
-	if (!fd_file(f))
-		return error;
+	if (fd_empty(f))
+		return -EBADF;
 	audit_file(fd_file(f));
 
 	error = strncpy_from_user(kname, name, sizeof(kname));
@@ -970,7 +964,6 @@ SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 				    fd_file(f)->f_path.dentry, kname);
 		mnt_drop_write_file(fd_file(f));
 	}
-	fdput(f);
 	return error;
 }
 
-- 
2.39.5


