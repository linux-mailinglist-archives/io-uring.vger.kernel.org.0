Return-Path: <io-uring+bounces-4356-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FB199B9DB6
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 08:32:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 558561C2134F
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 07:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B8A16F0CA;
	Sat,  2 Nov 2024 07:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="iYzPTdNb"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7BA14F12F;
	Sat,  2 Nov 2024 07:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730532716; cv=none; b=FMBXWpk72J7pSqcAjWWTgULoGFHSk8IrmfJNeVui/mNhZj0XHy9t3ZuoX7ackaIRg7ATKZgbsUhWGaw35z3zJ34GPKc/6lZzunobSQAExpXSaH3IG3bzzglPZVwNNEwUcNXk2mqEWXowzihOn+7c+IhnTf1p9fbD4tbJocsJpLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730532716; c=relaxed/simple;
	bh=LkpnveijF39+X/7mCS0EQnhVIUc56Yi3rPaPtn0Du8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QE1V6efH1BfaRoIuw+sn6zSXY9j6iIgYfltRGbn4OMsFehPmORn/ql9ZKFkcVN18Zb32kxI+3FnqoTzcqsRYf0ImK2u3cwyfDvbgjMin9nMWP8oKIvXCIjrcgawvNilz/27w8VYTA3NWFphsFXLC9Wc5wwiCdImnt2x5jWPhC4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=iYzPTdNb; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YEoR7ZhCfUEbk+5+IEhniLUK6GKI/myN5Dr6DI5ii+8=; b=iYzPTdNb3FGQjIWOOgjzYChuSC
	vkN6KHIrqrvrffPVZuEj+J1Z5nBPWJNK7mz7aUlAvof+4o2DKNbv/dMBMi3VLLLS9dWIusN9H2TV7
	6wiX4RkUCFpGmkSi02//GrBkkMgIN7eKO5A58kiZ7tAUyusAVfrCiadrE1Cy4Gcw883XP2dFnnVfq
	oWIGxfQBcu0DPh5xmAXNO/SaV8O25CV/NVqDcmzg+y1jl2W2muzTjk0fBkhhPgZQwc1Ogvm6Z7OVx
	HPrp3bhWDokUlfRnqfWhk7xbqXYZNe5CPi+YlWyd1lchwD1JdInade23qDHJq80SSLt5je0qC5jbh
	zYZpjM/Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t78bu-0000000AJFm-1dHH;
	Sat, 02 Nov 2024 07:31:50 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	io-uring@vger.kernel.org,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: [PATCH v2 10/13] new helpers: file_listxattr(), filename_listxattr()
Date: Sat,  2 Nov 2024 07:31:46 +0000
Message-ID: <20241102073149.2457240-10-viro@zeniv.linux.org.uk>
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

switch path_listxattr() and flistxattr(2) to those

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/xattr.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index d55f3d1e7589..988ea737ae7e 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -888,24 +888,43 @@ listxattr(struct dentry *d, char __user *list, size_t size)
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
+/* unconditionally consumes filename */
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
@@ -924,8 +943,7 @@ SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
 
 	if (fd_empty(f))
 		return -EBADF;
-	audit_file(fd_file(f));
-	return listxattr(fd_file(f)->f_path.dentry, list, size);
+	return file_listxattr(fd_file(f), list, size);
 }
 
 /*
-- 
2.39.5


