Return-Path: <io-uring+bounces-3354-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 529B798CAAE
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 03:22:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 849FC1C20B94
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 01:22:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A91C522F;
	Wed,  2 Oct 2024 01:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="mtU4GHf5"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687DCB661;
	Wed,  2 Oct 2024 01:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832154; cv=none; b=m41m24WP9Oe43acWxN7+V8pSV13azHBv06Dc3to9xLN3y6phT+X+YS0i8CKOZ+40XwAtOYUhwEjsPn4zYntOVjKTzjepX22aLAHLBYRVBTVxceri6WVtHtu7VqVvxa6hKE7kv5FDQYoVqNYAyrde9uHrWZt2DgGfCjgwAquDP/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832154; c=relaxed/simple;
	bh=LAcO6kLar/jzXelC+U7P8E30181ld+xL6+yS0dU/V7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tN8H4gHIpv02f4X5ZY2snRMGv38vjJOCx6O521doVQLd0alwP3RgxcSKIJ+Cgc0SV0RwLHPPKBrsejSdlixl/VMpvBqkT2waynI+SHbHM2nuTapHH8KuQw5VaSF/AUi0xiC690zYXH9x7nWSlXOImbScyIxfvl19S475hAHLydg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=mtU4GHf5; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ohpVJLn9t4W/NiAg7UbpvG1tUTmBfnNzLpci18vWTkE=; b=mtU4GHf56PEUYo6Zk80af3alDL
	F+BVu2NizvprXT0NlX5nXPvgJdSTw8GIP4b+Kz6SGN2e3njQEBfltHQ0cESOdbU7+i5Gzce5ELbuf
	SOiCC3t1fQfbshkAqporuD+PZM8ovonzlq6nmCnMVmA7TgJ6+6W5iAaWnJbP8idJ5/Sjn7VacnqI6
	8rjl9LZr8vnHKy5mRl9Bsj49oh90kQCGIMYoWMo/xPHwONad6UrqxLJSn8SvWLOpAac+4tU98YQH3
	SR9BH5bWkwTSslBo25VAdXXaF2Q3X99LIsoVw8DkP1mEQ5rkLxRS5WEN1ayEM6mYsSQtfuio+jRbx
	E4W0yM+A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svo4U-0000000HW0b-3eNo;
	Wed, 02 Oct 2024 01:22:30 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: brauner@kernel.org,
	io-uring@vger.kernel.org,
	cgzones@googlemail.com
Subject: [PATCH 7/9] new helpers: file_listxattr(), filename_listxattr()
Date: Wed,  2 Oct 2024 02:22:28 +0100
Message-ID: <20241002012230.4174585-7-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

switch path_listxattr() and flistxattr(2) to those

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/xattr.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index a0e304c65d51..0a1da16f74b1 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -886,24 +886,42 @@ listxattr(struct dentry *d, char __user *list, size_t size)
 	return error;
 }
 
-static ssize_t path_listxattr(const char __user *pathname, char __user *list,
-			      size_t size, unsigned int lookup_flags)
+static
+ssize_t file_listxattr(struct file *f, char __user *list, size_t size)
+{
+	audit_file(f);
+	return listxattr(f->f_path.dentry, list, size);
+}
+
+static
+ssize_t filename_listxattr(int dfd, struct filename *filename,
+			   unsigned int lookup_flags,
+			   char __user *list, size_t size)
 {
 	struct path path;
 	ssize_t error;
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
-		return error;
+		goto out;
 	error = listxattr(path.dentry, list, size);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+out:
+	putname(filename);
 	return error;
 }
 
+static ssize_t path_listxattr(const char __user *pathname, char __user *list,
+			      size_t size, unsigned int lookup_flags)
+{
+	return filename_listxattr(AT_FDCWD, getname(pathname), lookup_flags,
+				  list, size);
+}
+
 SYSCALL_DEFINE3(listxattr, const char __user *, pathname, char __user *, list,
 		size_t, size)
 {
@@ -922,8 +940,7 @@ SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
 
 	if (fd_empty(f))
 		return -EBADF;
-	audit_file(fd_file(f));
-	return listxattr(fd_file(f)->f_path.dentry, list, size);
+	return file_listxattr(fd_file(f), list, size);
 }
 
 /*
-- 
2.39.5


