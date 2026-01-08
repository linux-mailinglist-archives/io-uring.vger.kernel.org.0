Return-Path: <io-uring+bounces-11493-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AEE0D0296E
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 13:22:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B559730B4319
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 12:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1ECC345CA5;
	Thu,  8 Jan 2026 07:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="skyrTFjD"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D33340D92;
	Thu,  8 Jan 2026 07:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857822; cv=none; b=dGAlWPGtsHlDju284HVvJy6BoBY2Yj/KQ17MoGO1G8GYVVGGuLjOCsWNskOGjh9BoiRqmaEy4PHRypisG058rbh3v3h4oOHfPGD8iXVpESI9HHoTcgV2JL+NKhQPYJoUrad07bCT7oNnaEN1MpmCEDkVC419DAY5wLwqq6WmpPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857822; c=relaxed/simple;
	bh=+PwKgi/02suRYVooSrcTQ74mPtX7iYni4fKimRheEbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuAg13G0/1AL0kahvEgw1sG+pYhq9pdE2fx0QTYuBfdc6fOwe//EteM2FqXZSdrIb/TIwEqVuf3lqFHH2ArnuJ4V7Byudgc40GqSkvzIfheJ9JQlufSrc0gJ2+Br+fWfPLG7dp8rh9z4CH6Ie4i2/BNaZslZZ4xEZmKfi5iHqLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=skyrTFjD; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=58ApSCbomH5xnx9mYPWsN3IKMopiJHG9xz18HM9ct5I=; b=skyrTFjDkXzsebQNT+sIouo3dT
	ZbIWtfzCalIxsCuZCKOFeN1gQhwDBR6S+X0o2dKRztyTpobAEnQBnrN7eyt//7F+zwfl2wb4VA1go
	E8JNBJtkIHxL1hKqPZbk/y8yLPqYd49dhrQOmcylrE4pSmYbJNotJa3hKty5OXuhaN45D1DwqM27i
	hI3guhlmodUzMTaJSo3N0ylZVU8wDf3TrszPURDIuGXIz3bmbLwI7Wke+vurlOWkEjbAz0luJljQ4
	NBEodOMkCN+06/4Sles13LdArn4BacJ5g41KKvbeAR67YV7T/q0KImr/pgSzDdQW/YGeBmVRjtgHX
	+rguFUaw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkaz-00000001msv-0eHf;
	Thu, 08 Jan 2026 07:38:13 +0000
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
Subject: [PATCH v4 46/59] do_{mknodat,mkdirat,unlinkat,rmdir}(): use CLASS(filename_consume)
Date: Thu,  8 Jan 2026 07:37:50 +0000
Message-ID: <20260108073803.425343-47-viro@zeniv.linux.org.uk>
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

same rationale as for previous commit

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 86e2467c5460..5acb071c92c4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5063,9 +5063,10 @@ static int may_mknod(umode_t mode)
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
@@ -5075,12 +5076,11 @@ static int do_mknodat(int dfd, struct filename *name, umode_t mode,
 
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
@@ -5114,8 +5114,6 @@ static int do_mknodat(int dfd, struct filename *name, umode_t mode,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out1:
-	putname(name);
 	return error;
 }
 
@@ -5198,8 +5196,9 @@ struct dentry *vfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_mkdir);
 
-int do_mkdirat(int dfd, struct filename *name, umode_t mode)
+int do_mkdirat(int dfd, struct filename *__name, umode_t mode)
 {
+	CLASS(filename_consume, name)(__name);
 	struct dentry *dentry;
 	struct path path;
 	int error;
@@ -5208,9 +5207,8 @@ int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 
 retry:
 	dentry = filename_create(dfd, name, &path, lookup_flags);
-	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out_putname;
+		return PTR_ERR(dentry);
 
 	error = security_path_mkdir(&path, dentry,
 			mode_strip_umask(path.dentry->d_inode, mode));
@@ -5230,8 +5228,6 @@ int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out_putname:
-	putname(name);
 	return error;
 }
 
@@ -5305,8 +5301,9 @@ int vfs_rmdir(struct mnt_idmap *idmap, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_rmdir);
 
-int do_rmdir(int dfd, struct filename *name)
+int do_rmdir(int dfd, struct filename *__name)
 {
+	CLASS(filename_consume, name)(__name);
 	int error;
 	struct dentry *dentry;
 	struct path path;
@@ -5317,7 +5314,7 @@ int do_rmdir(int dfd, struct filename *name)
 retry:
 	error = filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
 	if (error)
-		goto exit1;
+		return error;
 
 	switch (type) {
 	case LAST_DOTDOT:
@@ -5359,8 +5356,6 @@ int do_rmdir(int dfd, struct filename *name)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-exit1:
-	putname(name);
 	return error;
 }
 
@@ -5448,8 +5443,9 @@ EXPORT_SYMBOL(vfs_unlink);
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
@@ -5461,7 +5457,7 @@ int do_unlinkat(int dfd, struct filename *name)
 retry:
 	error = filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
 	if (error)
-		goto exit_putname;
+		return error;
 
 	error = -EISDIR;
 	if (type != LAST_NORM)
@@ -5508,8 +5504,6 @@ int do_unlinkat(int dfd, struct filename *name)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-exit_putname:
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


