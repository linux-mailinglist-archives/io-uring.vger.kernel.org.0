Return-Path: <io-uring+bounces-11646-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3860D1C5DE
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:34:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7ED07306ECFC
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C52327C10;
	Wed, 14 Jan 2026 04:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="OI6NBWMg"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84C82DFA2D;
	Wed, 14 Jan 2026 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365114; cv=none; b=p8k1urQI7l8XjPXROZzUcDMYiSXM0Z1Z94reWrUnXf0fDL9PrHovJzcUf2aWp/JpULFC0UjCXTuCoZgZEJhDWJV4yrH/t9bEc9lgKKK8NkL9EG8Rx6XhmjQAanlIvZaDrLV5fe+nLV+VtaWRi0F6iMVh20mylBl9z/1bLGS70+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365114; c=relaxed/simple;
	bh=1z22d7wevdkqvPYggkzE3KL6dU8cNEgUkn1BxtLOP2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TN0FUq2rJGmWlQKvmLYWcP6a8BKP0aWMF/AejiLQU4Vr8zYwYJ2Olz9IHUe/BBTbPyDKgQ/Mms9NOVDK4a62YCVGaRk4oKOm17WdXTMgGjh5Lyg+u4m9RClXIcNDyLn5/Z2NKW0AnOKlTvkr1lKeTN7mli7ozBTLEBtKGbuN0uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=OI6NBWMg; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RbNOPaetTuN0lnTiQCg917aHs5AZU0T1trGPnAd363c=; b=OI6NBWMgr3YzU0+ImkTR5mdtGf
	yq/3DzfmgnvAyhPnMK3YlXuIaAUof8Eh8ZZGSVmdydNidpeFGu2t6qE4mgYWM9WcyYrk7i82aE4hR
	S7pvUx/cnXMBGp2I4TiIyJlAK49w8DZGyxGIklivnNf3HmLTZhPI02dKecp8IV3TvRrUnnCqPeXZ8
	CyBd/URPTbdgXbNVlIRcm6bUTxRm90uJBBdg7TaPPAmWYfrAoURr4k3upWbQehxZqKAfO6GZXFqcE
	KhoaOujDDPV47lxYRG+9jv+bVivbYxMWNzj+hnB7lEid9l8h3rLg1fPpqOKCY6UpPCl4+Klp91TZ1
	kYbv10zg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZC-0000000GImz-35ZI;
	Wed, 14 Jan 2026 04:33:10 +0000
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
Subject: [PATCH v5 01/68] init_mknod(): turn into a trivial wrapper for do_mknodat()
Date: Wed, 14 Jan 2026 04:32:03 +0000
Message-ID: <20260114043310.3885463-2-viro@zeniv.linux.org.uk>
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

Same as init_unlink() and init_rmdir() already are; the only obstacle
is do_mknodat() being static.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/init.c     | 21 +--------------------
 fs/internal.h |  1 +
 fs/namei.c    |  2 +-
 3 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/fs/init.c b/fs/init.c
index e0f5429c0a49..746d02628bc3 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -140,26 +140,7 @@ int __init init_stat(const char *filename, struct kstat *stat, int flags)
 
 int __init init_mknod(const char *filename, umode_t mode, unsigned int dev)
 {
-	struct dentry *dentry;
-	struct path path;
-	int error;
-
-	if (S_ISFIFO(mode) || S_ISSOCK(mode))
-		dev = 0;
-	else if (!(S_ISBLK(mode) || S_ISCHR(mode)))
-		return -EINVAL;
-
-	dentry = start_creating_path(AT_FDCWD, filename, &path, 0);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-
-	mode = mode_strip_umask(d_inode(path.dentry), mode);
-	error = security_path_mknod(&path, dentry, mode, dev);
-	if (!error)
-		error = vfs_mknod(mnt_idmap(path.mnt), path.dentry->d_inode,
-				  dentry, mode, new_decode_dev(dev), NULL);
-	end_creating_path(&path, dentry);
-	return error;
+	return do_mknodat(AT_FDCWD, getname_kernel(filename), mode, dev);
 }
 
 int __init init_link(const char *oldname, const char *newname)
diff --git a/fs/internal.h b/fs/internal.h
index ab638d41ab81..7267aa0926a1 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -60,6 +60,7 @@ int may_linkat(struct mnt_idmap *idmap, const struct path *link);
 int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
 int do_mkdirat(int dfd, struct filename *name, umode_t mode);
+int do_mknodat(int dfd, struct filename *name, umode_t mode, unsigned int dev);
 int do_symlinkat(struct filename *from, int newdfd, struct filename *to);
 int do_linkat(int olddfd, struct filename *old, int newdfd,
 			struct filename *new, int flags);
diff --git a/fs/namei.c b/fs/namei.c
index cf16b6822dd3..4595b355b3ce 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5018,7 +5018,7 @@ static int may_mknod(umode_t mode)
 	}
 }
 
-static int do_mknodat(int dfd, struct filename *name, umode_t mode,
+int do_mknodat(int dfd, struct filename *name, umode_t mode,
 		unsigned int dev)
 {
 	struct delegated_inode di = { };
-- 
2.47.3


