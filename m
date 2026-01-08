Return-Path: <io-uring+bounces-11507-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 308A6D01C2C
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 10:11:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D085830B3328
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 09:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F71635A932;
	Thu,  8 Jan 2026 07:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="UMUIKYQU"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17A0359FAF;
	Thu,  8 Jan 2026 07:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767858051; cv=none; b=VEs3pferbl/unzqMJiERtxZzLPnqak20XV5rWM9ZIETNbK8BXYgSH9SiZ2vBtqzn/gG/gbcLr/FQmjlDsU01kkvlAi4Dx6pfGFWaP25uG98qevuNXJGtL6Y3nFFrBTx9mCWu3zaCpRsZjKB2m44jggZ+YmvGQxFFyZDjc4Get0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767858051; c=relaxed/simple;
	bh=QKH/VHjmimuM2elpWlBC6NTasYCowfM7G0/nY8QEgfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PePKmalABcMoGBMmpnhGBXmMaXVGw7mKnZb5yawitgCJBacr9xkE2MtLLg7euASK1xWimvAzlOeE9mJCaUwx+2cSgrGkN1z+KWuzQaTns+3++OW6JeGflCkkEtKRic5h4+pkZowmJp+FseMtyyRComl6nEu3vxGdMKq4Nm3PDhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=UMUIKYQU; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/xK9ccOp9W934T9AOt1ksaAZDsego1UZsXXZaN3Rosk=; b=UMUIKYQU5CmVXwKeaogQCx7jwD
	k5bhcmjj0LxDLwMXUh1jHcH+IZ9oIeRs2VGSWlYqExPuH2hRl0w9FLDZN/seAbvZrE7g92Dqt2b7+
	Dh/PPsud7usKwBN0JwjD/bS/NwjLSvoEBk4DBXbkZ8WYCIELMnlfUfXmNVwsPP79gGulgQE9ryhAn
	WooHz3KLhczjoqBQwYk1NZfbN0i+tzSPDcNfGdkkOIA/vAiw1odVv0HmrScBdtiBCSoVSxtSZnRLI
	H+rVy56VJBFqyhiRPHsCKTSINw3hD+/GS/DLqMlQpoGiTA3HXDml7IhJr0S3uPoq4QgDd52gRC4yG
	GvblqNQw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkeh-00000001pGj-1lf7;
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
Subject: [RFC PATCH 5/8] non-consuming variant of do_mknodat()
Date: Thu,  8 Jan 2026 07:41:58 +0000
Message-ID: <20260108074201.435280-6-viro@zeniv.linux.org.uk>
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

similar to previous commit; replacement is filename_mknodat()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 Documentation/filesystems/porting.rst |  6 +++---
 fs/init.c                             |  3 ++-
 fs/internal.h                         |  2 +-
 fs/namei.c                            | 11 ++++++-----
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index ace0607fe39c..7e68a148dd1e 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1339,6 +1339,6 @@ in-tree filesystems have done).
 
 **mandatory**
 
-do_{mkdir,link,symlink,renameat2}() are gone; filename_...() counterparts
-replace those.  The difference is that the former used to consume
-filename references; the latter do not.
+do_{mkdir,mknod,link,symlink,renameat2}() are gone; filename_...()
+counterparts replace those.  The difference is that the former used
+to consume filename references; the latter do not.
diff --git a/fs/init.c b/fs/init.c
index 9a550ba4802f..543444c1d79e 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -140,7 +140,8 @@ int __init init_stat(const char *filename, struct kstat *stat, int flags)
 
 int __init init_mknod(const char *filename, umode_t mode, unsigned int dev)
 {
-	return do_mknodat(AT_FDCWD, getname_kernel(filename), mode, dev);
+	CLASS(filename_kernel, name)(filename);
+	return filename_mknodat(AT_FDCWD, name, mode, dev);
 }
 
 int __init init_link(const char *oldname, const char *newname)
diff --git a/fs/internal.h b/fs/internal.h
index 03638008d84a..02b5dec13ff3 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -60,7 +60,7 @@ int may_linkat(struct mnt_idmap *idmap, const struct path *link);
 int filename_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
 int filename_mkdirat(int dfd, struct filename *name, umode_t mode);
-int do_mknodat(int dfd, struct filename *name, umode_t mode, unsigned int dev);
+int filename_mknodat(int dfd, struct filename *name, umode_t mode, unsigned int dev);
 int filename_symlinkat(struct filename *from, int newdfd, struct filename *to);
 int filename_linkat(int olddfd, struct filename *old, int newdfd,
 			struct filename *new, int flags);
diff --git a/fs/namei.c b/fs/namei.c
index e3252d4abce4..1aa19dde50e4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5038,10 +5038,9 @@ static int may_mknod(umode_t mode)
 	}
 }
 
-int do_mknodat(int dfd, struct filename *__name, umode_t mode,
-		unsigned int dev)
+int filename_mknodat(int dfd, struct filename *name, umode_t mode,
+		     unsigned int dev)
 {
-	CLASS(filename_consume, name)(__name);
 	struct delegated_inode di = { };
 	struct mnt_idmap *idmap;
 	struct dentry *dentry;
@@ -5095,12 +5094,14 @@ int do_mknodat(int dfd, struct filename *__name, umode_t mode,
 SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, umode_t, mode,
 		unsigned int, dev)
 {
-	return do_mknodat(dfd, getname(filename), mode, dev);
+	CLASS(filename, name)(filename);
+	return filename_mknodat(dfd, name, mode, dev);
 }
 
 SYSCALL_DEFINE3(mknod, const char __user *, filename, umode_t, mode, unsigned, dev)
 {
-	return do_mknodat(AT_FDCWD, getname(filename), mode, dev);
+	CLASS(filename, name)(filename);
+	return filename_mknodat(AT_FDCWD, name, mode, dev);
 }
 
 /**
-- 
2.47.3


