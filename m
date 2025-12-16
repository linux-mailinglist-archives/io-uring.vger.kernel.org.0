Return-Path: <io-uring+bounces-11097-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B2E1CC0C90
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:56:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 386CA30414E3
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5774232695D;
	Tue, 16 Dec 2025 03:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="aHqMpdwS"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22370314B9A;
	Tue, 16 Dec 2025 03:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857297; cv=none; b=cLWz2HG+m0dCa9JkgGu/dGExd4mvs3LGCoW4xGHxYFsGntLG7sIID6iEiHBFmjVmAleRx1MvyEhPZhmKOWOGgKwAXRsclwhI8pAfWqg066xDCvky5Ms4FDBQrE/xZi28hYQbOD4yJO5Bu+R5ro6U8NHeJhXtcbB/sNIpP9cRRt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857297; c=relaxed/simple;
	bh=HisoNpAgR+mgX4tncuHrZuEfPnuvtKjkXidy3TwVLYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGBZmX1Jb/Zxj5vsXhfGfVasz67T+Nkdo5rnN3CvuCq4urMffNJg79SwbwGDAKmUOfN+ZLhOapSuU8+Nj3U9FR+S1g1BpfKkkK+1lNhsgCyc2VssF59CFo+KV9LQsaANq3MXdImLcYv1w6WvLqCOIkO6zHanJFQRJ7HxBoCPn/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=aHqMpdwS; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bysgWp1OpU1Iwtu8tKSXbcwgOdD87YviUwK4e/yZWeQ=; b=aHqMpdwSkhulGH/LsWAsFXsDyZ
	HP0EnzIPj3TPoxwrtIKfzmY484aMVpEsLNB+/kN24nHscysJ4IPw2hLmYXkL950Y5u6QuJuBcqCve
	blmwcAngkvOWbATjNJWPweIPlbv+c/RK/uXomJkP1XtUIRs/qMyffbHzKqjQiXp5vdM5MJOgNX0Sk
	QpIfJ4hkvSaIbhfVbNiQUm5aPDbJ1LOArvMtf/R8XbvIJCoqiqz2s4yKFwH1RZoSU2PZDoRvoEFOj
	efRuqbMx5bbnSiuGkMFApCnJLU6kl5qAkB+EKQHkzw3/PrOJM7sXKGIj0kCb8K/plKZ5J5Tpc9S2k
	WG2kqkiQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9j-0000000GwMo-3zsL;
	Tue, 16 Dec 2025 03:55:23 +0000
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
Subject: [RFC PATCH v3 47/59] do_{mknodat,mkdirat,unlinkat,rmdir}(): use CLASS(filename_consume)
Date: Tue, 16 Dec 2025 03:55:06 +0000
Message-ID: <20251216035518.4037331-48-viro@zeniv.linux.org.uk>
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

same rationale as for previous commit

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index fbf306fe8414..0221cdb92297 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5066,9 +5066,10 @@ static int may_mknod(umode_t mode)
 	}
 }
 
-static int do_mknodat(int dfd, struct filename *name, umode_t mode,
+static int do_mknodat(int dfd, struct filename *__name, umode_t mode,
 		unsigned int dev)
 {
+	CLASS(filename_consume, name)(__name);
 	struct delegated_inode di = { };
 	struct mnt_idmap *idmap;
 	struct dentry *dentry;
@@ -5078,12 +5079,11 @@ static int do_mknodat(int dfd, struct filename *name, umode_t mode,
 
 	error = may_mknod(mode);
 	if (error)
-		goto out1;
+		return error;
 retry:
 	dentry = filename_create(dfd, name, &path, lookup_flags);
-	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out1;
+		return PTR_ERR(dentry);
 
 	error = security_path_mknod(&path, dentry,
 			mode_strip_umask(path.dentry->d_inode, mode), dev);
@@ -5117,8 +5117,6 @@ static int do_mknodat(int dfd, struct filename *name, umode_t mode,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out1:
-	putname(name);
 	return error;
 }
 
@@ -5201,8 +5199,9 @@ struct dentry *vfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_mkdir);
 
-int do_mkdirat(int dfd, struct filename *name, umode_t mode)
+int do_mkdirat(int dfd, struct filename *__name, umode_t mode)
 {
+	CLASS(filename_consume, name)(__name);
 	struct dentry *dentry;
 	struct path path;
 	int error;
@@ -5211,9 +5210,8 @@ int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 
 retry:
 	dentry = filename_create(dfd, name, &path, lookup_flags);
-	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out_putname;
+		return PTR_ERR(dentry);
 
 	error = security_path_mkdir(&path, dentry,
 			mode_strip_umask(path.dentry->d_inode, mode));
@@ -5233,8 +5231,6 @@ int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out_putname:
-	putname(name);
 	return error;
 }
 
@@ -5308,8 +5304,9 @@ int vfs_rmdir(struct mnt_idmap *idmap, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_rmdir);
 
-int do_rmdir(int dfd, struct filename *name)
+int do_rmdir(int dfd, struct filename *__name)
 {
+	CLASS(filename_consume, name)(__name);
 	int error;
 	struct dentry *dentry;
 	struct path path;
@@ -5320,7 +5317,7 @@ int do_rmdir(int dfd, struct filename *name)
 retry:
 	error = filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
 	if (error)
-		goto exit1;
+		return error;
 
 	switch (type) {
 	case LAST_DOTDOT:
@@ -5362,8 +5359,6 @@ int do_rmdir(int dfd, struct filename *name)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-exit1:
-	putname(name);
 	return error;
 }
 
@@ -5451,8 +5446,9 @@ EXPORT_SYMBOL(vfs_unlink);
  * writeout happening, and we don't want to prevent access to the directory
  * while waiting on the I/O.
  */
-int do_unlinkat(int dfd, struct filename *name)
+int do_unlinkat(int dfd, struct filename *__name)
 {
+	CLASS(filename_consume, name)(__name);
 	int error;
 	struct dentry *dentry;
 	struct path path;
@@ -5464,7 +5460,7 @@ int do_unlinkat(int dfd, struct filename *name)
 retry:
 	error = filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
 	if (error)
-		goto exit_putname;
+		return error;
 
 	error = -EISDIR;
 	if (type != LAST_NORM)
@@ -5511,8 +5507,6 @@ int do_unlinkat(int dfd, struct filename *name)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-exit_putname:
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


