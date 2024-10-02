Return-Path: <io-uring+bounces-3358-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC75B98CAB8
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 03:23:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FA601F26AA4
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 01:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E870EAFA;
	Wed,  2 Oct 2024 01:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="NN3U2RLQ"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B14DB66E;
	Wed,  2 Oct 2024 01:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832155; cv=none; b=f/j6ROXc32IlQ+iSLl44relYIAzFYl9zIJdw76VTzBI0oeb4GzAvumLLwiE50bvExIgOygjuUMF5QZpzByFdDuGlDOAgTAgOets/lz5FxBCCYWoUgofgwOfETVO1Ycx9W+QTF3XY+NYrrbJvSTbNCsiXcRcFA8ijhK9Ix+60W+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832155; c=relaxed/simple;
	bh=VNQ+ez5qKBJ3SnuWtn0DrDNWpC2eEvPWUeX31u9P0wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dd7FlbMO/4ONGQA0iffS9cjhVBuZdL4nJnTB2hJ0awTUhm+g8p3t24BcMfL2gMDaE6unhuusI6VAsuuZ3Oof+fXywXpWBsEJK2D6l5VDR0ZI8oZ7QeA5Ua1FGjiG4cVmfJzmTNRhONAXV9ZiDP4tfEsF51GzHmGLTE7KhGF4XR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=NN3U2RLQ; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tuJ0USvtoQ9FyOpmJn8A5DIA56W4830JHccLaKT1zSc=; b=NN3U2RLQo+0FrmyJ5VKGM4pkI1
	jaT4HUbA27mCiEvkQ9hJib8lILtm8tXU4q7ueGu0BSlZxtZRK4rkig1vM9w9eAGCQbc3RR36f8s32
	335/FM9P2wd/Q4IPJsBPpb9lllkAyzxZVMKqIEwWqRLitLvdRz9rMZMz6pfagtOShmLQ2IfsBC/v9
	wrOZ9aPv4XURq2U5eXgNBeKrKee7QI6RQX9540s9HlHbn8HT+hSN2wJ3MneKJoyV/q7+I7YoZvkxg
	2NQSndqY4iQaE2ZsSNXOdyHbs/KKKYZwAVeOtl3qe4g2NZBrl9PDSPoeuLPc03VQ1jAnuHdta6CEC
	f8TpRikA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svo4V-0000000HW0h-08FZ;
	Wed, 02 Oct 2024 01:22:31 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: brauner@kernel.org,
	io-uring@vger.kernel.org,
	cgzones@googlemail.com
Subject: [PATCH 8/9] new helpers: file_removexattr(), filename_removexattr()
Date: Wed,  2 Oct 2024 02:22:29 +0100
Message-ID: <20241002012230.4174585-8-viro@zeniv.linux.org.uk>
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

switch path_removexattrat() and fremovexattr(2) to those

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/xattr.c | 52 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 0a1da16f74b1..6f87f23c0e84 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -954,23 +954,32 @@ removexattr(struct mnt_idmap *idmap, struct dentry *d, const char *name)
 	return vfs_removexattr(idmap, d, name);
 }
 
-static int path_removexattr(const char __user *pathname,
-			    const char __user *name, unsigned int lookup_flags)
+static int file_removexattr(struct file *f, struct xattr_name *kname)
+{
+	int error = mnt_want_write_file(f);
+
+	if (!error) {
+		audit_file(f);
+		error = removexattr(file_mnt_idmap(f),
+				    f->f_path.dentry, kname->name);
+		mnt_drop_write_file(f);
+	}
+	return error;
+}
+
+static int filename_removexattr(int dfd, struct filename *filename,
+				unsigned int lookup_flags, struct xattr_name *kname)
 {
 	struct path path;
 	int error;
-	struct xattr_name kname;
 
-	error = import_xattr_name(&kname, name);
-	if (error)
-		return error;
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
-		return error;
+		goto out;
 	error = mnt_want_write(path.mnt);
 	if (!error) {
-		error = removexattr(mnt_idmap(path.mnt), path.dentry, kname.name);
+		error = removexattr(mnt_idmap(path.mnt), path.dentry, kname->name);
 		mnt_drop_write(path.mnt);
 	}
 	path_put(&path);
@@ -978,9 +987,24 @@ static int path_removexattr(const char __user *pathname,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+out:
+	putname(filename);
 	return error;
 }
 
+static int path_removexattr(const char __user *pathname,
+			    const char __user *name, unsigned int lookup_flags)
+{
+	struct xattr_name kname;
+	int error;
+
+	error = import_xattr_name(&kname, name);
+	if (error)
+		return error;
+	return filename_removexattr(AT_FDCWD, getname(pathname), lookup_flags,
+				    &kname);
+}
+
 SYSCALL_DEFINE2(removexattr, const char __user *, pathname,
 		const char __user *, name)
 {
@@ -1001,19 +1025,11 @@ SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 
 	if (fd_empty(f))
 		return -EBADF;
-	audit_file(fd_file(f));
 
 	error = import_xattr_name(&kname, name);
 	if (error)
 		return error;
-
-	error = mnt_want_write_file(fd_file(f));
-	if (!error) {
-		error = removexattr(file_mnt_idmap(fd_file(f)),
-				    fd_file(f)->f_path.dentry, kname.name);
-		mnt_drop_write_file(fd_file(f));
-	}
-	return error;
+	return file_removexattr(fd_file(f), &kname);
 }
 
 int xattr_list_one(char **buffer, ssize_t *remaining_size, const char *name)
-- 
2.39.5


