Return-Path: <io-uring+bounces-4351-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D04B9B9DA9
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 08:32:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 389FE1F228F9
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 07:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2761A13C689;
	Sat,  2 Nov 2024 07:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="gR0Cz1p8"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286B114F9F9;
	Sat,  2 Nov 2024 07:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730532714; cv=none; b=sV47GjrSL+MYCRL2N48eGegyCLKWv5DvljgPoKXIEsw3XtNk3eINYQoSDZ4j0CmDB4ZyloYRckqcqAe+bU/c2mT5YkcRlkiHXFC2ImYCZxVsixLGS3aaTYQYqDcDXvQJxtNqvNzbKCzGuHhRQg4RXi2ZjpYP880/xZRlrwDXPyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730532714; c=relaxed/simple;
	bh=Cxns49oeB/jZqnRQmZBupXFGxbal6058CA2EL4Y2l/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5Xf6rnJ740JhAcblus7Hy2rT/9UWBOf0h5w9v4Kzy2nxjxLMHy5UbJjU+taCjVc2SLzSynFIDGGQO/r4S89EtFfu1xv3tvntTF4QWwpIH8wleu0540y63uRODXyRxIrVn4c60glaYp+fRey5vT7k3X7EIMwdDohK3yhp7P6I1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=gR0Cz1p8; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Rew3+6cBj+9i5jhdTRZP9TEsWMPPsZB7QXK94fQIrnM=; b=gR0Cz1p8TYHA7s9m7Oh6IKbsdP
	I/BDa4Yw3OBkngQaTczGGj+XKOyG40pD44fjyapAcEtJ7O/kN9YTR5JlJ/KnyoQWXGNa+kXVqGfTW
	23OCisg+5J4ag8XqV37OmJjkFtKUP/IBdW9xG8gPkS84wXN5+ZPNWOjXebtjOCzh4YKDt3iM4XiR9
	oOk2mciLFMh3dIalWeyLbwQQCBMYg0OtRF24WdlssTIYL0DQhs6oI7XRH435aJWDeHmePLjrxZ061
	RSbd/ppF/089Z/A7oZ7+lORwToA30TL0hbZJB/wZhGM3MGPF6Y6PXUWdxSDVDG/LON+7tjBDjtQ6M
	hKEfxwGg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t78bu-0000000AJFs-205Q;
	Sat, 02 Nov 2024 07:31:50 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	io-uring@vger.kernel.org,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: [PATCH v2 11/13] new helpers: file_removexattr(), filename_removexattr()
Date: Sat,  2 Nov 2024 07:31:47 +0000
Message-ID: <20241102073149.2457240-11-viro@zeniv.linux.org.uk>
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

switch path_removexattrat() and fremovexattr(2) to those

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/xattr.c | 53 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 18 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 988ea737ae7e..b76911b23293 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -957,23 +957,33 @@ removexattr(struct mnt_idmap *idmap, struct dentry *d, const char *name)
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
+/* unconditionally consumes filename */
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
@@ -981,9 +991,24 @@ static int path_removexattr(const char __user *pathname,
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
@@ -1004,19 +1029,11 @@ SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 
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


