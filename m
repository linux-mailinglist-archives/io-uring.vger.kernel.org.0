Return-Path: <io-uring+bounces-11508-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 73372D01C4B
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 10:13:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7A16031B80CA
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 08:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF1435A940;
	Thu,  8 Jan 2026 07:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="YtuuawKP"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1338359FAD;
	Thu,  8 Jan 2026 07:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767858052; cv=none; b=ogYHuADXN3umqSvlmI2OnjsYBgEKujtjcgmIDLiXF8VETVBuJgK5HcELEFvMtlB+Ny6lWSLev8++vA6A3mt5hhC/NelJ2EmibnrhDY6iuYKT0y4CW24p2zG+oVOX3H6oLPHr6jRIgPAPoIMg8Eb5smnJdWIWS2PYu/VW/9soOb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767858052; c=relaxed/simple;
	bh=fcxK99omi71ZX5/vGICEMfV9f5uRJvbTSEl8O7XJD4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYW2dap28tSUJWpJiBhx/vNIzoinGzYzBtp97CRfcU5S6y25qiGoT5SeduatDL8Pk3Qbyo9iEcQXepm0kRMioZqTnRikif6FiFcTkiXwuAcmG1DFA80ZAc5Q73OQZ1mbzrfwuJBwuEgc0+h5Y3E6CXm93KFKMylGFbthbirHLwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=YtuuawKP; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pgDVY/Wqivs0D0jtpgR/Ursc2PaFW0/C2mD54qOQgy4=; b=YtuuawKPFgpAj1ZU4OttR1lMI4
	VUe73VDlm/5uNoCsmedkoSrGYbHq7+H7DVf/i0F648z/qfWeaQw4GC1HpCCNjw2bIr7dcYesnSCoG
	UR1u0k/HmWAf7Q0Z8yevsik2e51Mwo5H0dfZI/6BzksYohLMcHrFQhZv/hGk3QjTLhWFNhLPSFeO5
	HIgauzH8URBiaLRXGzeRuj/5NCcmSEI9h4AaLSy0tGUSCtrCWlbaWWBmNlAgMnGH1/CRhm8ixEkMb
	0zXMZWQkjWdwEp2Rn4GcdevIsFXwOMCKnJzrfiVZpbPm0sv//usm32cecKYyASgu+vyuDRzoJ7cY7
	qfOnc+sw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkeh-00000001pGJ-0MiZ;
	Thu, 08 Jan 2026 07:42:03 +0000
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
Subject: [RFC PATCH 4/8] non-consuming variant of do_mkdirat()
Date: Thu,  8 Jan 2026 07:41:57 +0000
Message-ID: <20260108074201.435280-5-viro@zeniv.linux.org.uk>
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

similar to previous commit; replacement is filename_mkdirat()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 Documentation/filesystems/porting.rst | 2 +-
 fs/init.c                             | 3 ++-
 fs/internal.h                         | 2 +-
 fs/namei.c                            | 9 +++++----
 io_uring/fs.c                         | 3 ++-
 5 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index c44c351bc297..ace0607fe39c 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1339,6 +1339,6 @@ in-tree filesystems have done).
 
 **mandatory**
 
-do_{link,symlink,renameat2}() are gone; filename_...() counterparts
+do_{mkdir,link,symlink,renameat2}() are gone; filename_...() counterparts
 replace those.  The difference is that the former used to consume
 filename references; the latter do not.
diff --git a/fs/init.c b/fs/init.c
index a54ef750ffe3..9a550ba4802f 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -164,7 +164,8 @@ int __init init_unlink(const char *pathname)
 
 int __init init_mkdir(const char *pathname, umode_t mode)
 {
-	return do_mkdirat(AT_FDCWD, getname_kernel(pathname), mode);
+	CLASS(filename_kernel, name)(pathname);
+	return filename_mkdirat(AT_FDCWD, name, mode);
 }
 
 int __init init_rmdir(const char *pathname)
diff --git a/fs/internal.h b/fs/internal.h
index 4a63b89c02d7..03638008d84a 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -59,7 +59,7 @@ int do_unlinkat(int dfd, struct filename *name);
 int may_linkat(struct mnt_idmap *idmap, const struct path *link);
 int filename_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
-int do_mkdirat(int dfd, struct filename *name, umode_t mode);
+int filename_mkdirat(int dfd, struct filename *name, umode_t mode);
 int do_mknodat(int dfd, struct filename *name, umode_t mode, unsigned int dev);
 int filename_symlinkat(struct filename *from, int newdfd, struct filename *to);
 int filename_linkat(int olddfd, struct filename *old, int newdfd,
diff --git a/fs/namei.c b/fs/namei.c
index 338e2934c520..e3252d4abce4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5171,9 +5171,8 @@ struct dentry *vfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_mkdir);
 
-int do_mkdirat(int dfd, struct filename *__name, umode_t mode)
+int filename_mkdirat(int dfd, struct filename *name, umode_t mode)
 {
-	CLASS(filename_consume, name)(__name);
 	struct dentry *dentry;
 	struct path path;
 	int error;
@@ -5208,12 +5207,14 @@ int do_mkdirat(int dfd, struct filename *__name, umode_t mode)
 
 SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, umode_t, mode)
 {
-	return do_mkdirat(dfd, getname(pathname), mode);
+	CLASS(filename, name)(pathname);
+	return filename_mkdirat(dfd, name, mode);
 }
 
 SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
 {
-	return do_mkdirat(AT_FDCWD, getname(pathname), mode);
+	CLASS(filename, name)(pathname);
+	return filename_mkdirat(AT_FDCWD, name, mode);
 }
 
 /**
diff --git a/io_uring/fs.c b/io_uring/fs.c
index cd4d88d37795..40541b539e0d 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -182,11 +182,12 @@ int io_mkdirat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_mkdirat(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_mkdir *mkd = io_kiocb_to_cmd(req, struct io_mkdir);
+	CLASS(filename_complete_delayed, name)(&mkd->filename);
 	int ret;
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = do_mkdirat(mkd->dfd, complete_getname(&mkd->filename), mkd->mode);
+	ret = filename_mkdirat(mkd->dfd, name, mkd->mode);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
-- 
2.47.3


