Return-Path: <io-uring+bounces-3312-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E926986B8E
	for <lists+io-uring@lfdr.de>; Thu, 26 Sep 2024 05:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0CCA1C21B0F
	for <lists+io-uring@lfdr.de>; Thu, 26 Sep 2024 03:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF92175D47;
	Thu, 26 Sep 2024 03:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="W1VPfYm6"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E5D1741C6;
	Thu, 26 Sep 2024 03:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727322970; cv=none; b=ee3ENubE4LRs9muk3pu5nNLOQLh81BX8Xnv/NswfamLqosFTqeFOv00/kGUyy2cVYCeV4wOqXcLrl7leYZJN9ytahuovdwth0UK6ZlYBiE7AoSSnPmttJONE+7HDTZ8It5cc8v/crIfDvd+0wCQplNvWvx5iEW8Ls7pouBxs8GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727322970; c=relaxed/simple;
	bh=2JYe+QQf/yUxEXm9IZ33GGv+BhtQF7udwrjZRDYNmkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pPNDWLPKHiZSIHpdtIInMu8RG2BePaQP4crOKuvQmBpfqm5yEramddGrk1B69n/UtvvGnrNV24Oyfer6WZemHy/AlyiT3UL5tdBPecCobNuiv9eRNBM1hUA0V8tA5FtLKLGwZk2KSu3MQ3QiR7FiZENX5MAS4p8u8nqLgdDreKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=W1VPfYm6; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=licKNqn/YkyGHf5ZbZt3M4s2O8Om6zgr4x34oDhQ27Y=; b=W1VPfYm6kI8SRg8SJtrFQtNipX
	516VzkZHfLEfTDjL+gPWC2hizUCDYDfA6Xk5EJi0wFgjxuzCAd8gKl8KSciCnGlXV5+x5ZLfCbep+
	xUQmwh5VFTZ79vU7e+lg7Zia80wiO4N0uYo2HLYzS/gsizvMqBxtRSeo08hrAD6r7OTUvhT/1WLN9
	AGr0wJed1lBtXH2Fnfg8jbAymJiuj8V5yo0aDnI1x3N/w9TRnsQrGmYspFoFI6a/CQlaI/c7dQcDc
	Rx+mGf8KExONjghZG7wS+k81zouPFSSSxy42aKycoe9pjeQLiqPV6QpPwiXOGl4I5zwr0FFJC/ce9
	SkEacRHA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1stfbl-0000000FYtq-40xK;
	Thu, 26 Sep 2024 03:56:01 +0000
Date: Thu, 26 Sep 2024 04:56:01 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC] struct filename, io_uring and audit troubles
Message-ID: <20240926035601.GO3550746@ZenIV>
References: <20240922004901.GA3413968@ZenIV>
 <20240923015044.GE3413968@ZenIV>
 <62104de8-6e9a-4566-bf85-f4c8d55bdb36@kernel.dk>
 <CAHC9VhQMGsL1tZrAbpwTHCriwZE2bzxAd+-7MSO+bPZe=N6+aA@mail.gmail.com>
 <20240923144841.GA3550746@ZenIV>
 <CAHC9VhSuDVW2Dmb6bA3CK6k77cPEv2vMqv3w4FfGvtcRDmgL3A@mail.gmail.com>
 <20240923203659.GD3550746@ZenIV>
 <20240924214046.GG3550746@ZenIV>
 <d3d2c19d-d6a3-4876-87f0-d5709ee1e4b2@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3d2c19d-d6a3-4876-87f0-d5709ee1e4b2@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Sep 25, 2024 at 12:01:01AM -0600, Jens Axboe wrote:

> The normal policy is that anything that is read-only should remain
> stable after ->prep() has been called, so that ->issue() can use it.
> That means the application can keep it on-stack as long as it's valid
> until io_uring_submit() returns. For structs/buffers that are copied to
> after IO, those the application obviously need to keep around until they
> see a completion for that request. So yes, for the xattr cases where the
> struct is copied to at completion time, those do not need to be stable
> after ->prep(), could be handled purely on the ->issue() side.

Looks like io_fsetxattr() was missing audit_file()... Anyway, in a local
branch I've added two helpers -

int file_setxattr(struct file *file, struct xattr_ctx *ctx);
int filename_setxattr(int dfd, struct filename *filename,
                      struct xattr_ctx *ctx, unsigned int lookup_flags);

and converted both fs/xattr.c and io_uring/xattr.c to those.

Completely untested delta follows; it's _not_ in the final form,
it misses getxattr side, etc.

BTW, I think fs/internal.h is a very wrong place for that, as well as
for do_mkdirat() et.al.  include/linux/marshalled_syscalls.h, perhaps?

diff --git a/fs/internal.h b/fs/internal.h
index 8cf42b327e5e..e39f80201ff8 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -285,8 +285,9 @@ ssize_t do_getxattr(struct mnt_idmap *idmap,
 		    struct xattr_ctx *ctx);
 
 int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
-int do_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
-		struct xattr_ctx *ctx);
+int file_setxattr(struct file *file, struct xattr_ctx *ctx);
+int filename_setxattr(int dfd, struct filename *filename,
+		      struct xattr_ctx *ctx, unsigned int lookup_flags);
 int may_write_xattr(struct mnt_idmap *idmap, struct inode *inode);
 
 #ifdef CONFIG_FS_POSIX_ACL
diff --git a/fs/xattr.c b/fs/xattr.c
index 0fc813cb005c..fc6409181c46 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -619,7 +619,7 @@ int setxattr_copy(const char __user *name, struct xattr_ctx *ctx)
 	return error;
 }
 
-int do_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
+static int do_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		struct xattr_ctx *ctx)
 {
 	if (is_posix_acl_xattr(ctx->kname->name))
@@ -630,32 +630,31 @@ int do_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
 			ctx->kvalue, ctx->size, ctx->flags);
 }
 
-static int path_setxattr(const char __user *pathname,
-			 const char __user *name, const void __user *value,
-			 size_t size, int flags, unsigned int lookup_flags)
+int file_setxattr(struct file *f, struct xattr_ctx *ctx)
+{
+	int error = mnt_want_write_file(f);
+
+	if (!error) {
+		audit_file(f);
+		error = do_setxattr(file_mnt_idmap(f), f->f_path.dentry, ctx);
+		mnt_drop_write_file(f);
+	}
+	return error;
+}
+
+int filename_setxattr(int dfd, struct filename *filename,
+		      struct xattr_ctx *ctx, unsigned int lookup_flags)
 {
-	struct xattr_name kname;
-	struct xattr_ctx ctx = {
-		.cvalue   = value,
-		.kvalue   = NULL,
-		.size     = size,
-		.kname    = &kname,
-		.flags    = flags,
-	};
 	struct path path;
 	int error;
 
-	error = setxattr_copy(name, &ctx);
-	if (error)
-		return error;
-
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
 		goto out;
 	error = mnt_want_write(path.mnt);
 	if (!error) {
-		error = do_setxattr(mnt_idmap(path.mnt), path.dentry, &ctx);
+		error = do_setxattr(mnt_idmap(path.mnt), path.dentry, ctx);
 		mnt_drop_write(path.mnt);
 	}
 	path_put(&path);
@@ -665,6 +664,30 @@ static int path_setxattr(const char __user *pathname,
 	}
 
 out:
+	putname(filename);
+	return error;
+}
+
+static int path_setxattr(const char __user *pathname,
+			 const char __user *name, const void __user *value,
+			 size_t size, int flags, unsigned int lookup_flags)
+{
+	struct xattr_name kname;
+	struct xattr_ctx ctx = {
+		.cvalue   = value,
+		.kvalue   = NULL,
+		.size     = size,
+		.kname    = &kname,
+		.flags    = flags,
+	};
+	int error;
+
+	error = setxattr_copy(name, &ctx);
+	if (error)
+		return error;
+
+	error = filename_setxattr(AT_FDCWD, getname(pathname),
+				  &ctx, lookup_flags);
 	kvfree(ctx.kvalue);
 	return error;
 }
@@ -700,17 +723,11 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 
 	if (fd_empty(f))
 		return -EBADF;
-	audit_file(fd_file(f));
 	error = setxattr_copy(name, &ctx);
 	if (error)
 		return error;
 
-	error = mnt_want_write_file(fd_file(f));
-	if (!error) {
-		error = do_setxattr(file_mnt_idmap(fd_file(f)),
-				    fd_file(f)->f_path.dentry, &ctx);
-		mnt_drop_write_file(fd_file(f));
-	}
+	error = file_setxattr(fd_file(f), &ctx);
 	kvfree(ctx.kvalue);
 	return error;
 }
diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index 13e8d7d2cdc2..702d5981fd63 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -203,28 +203,14 @@ int io_fsetxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return __io_setxattr_prep(req, sqe);
 }
 
-static int __io_setxattr(struct io_kiocb *req, unsigned int issue_flags,
-			const struct path *path)
-{
-	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
-	int ret;
-
-	ret = mnt_want_write(path->mnt);
-	if (!ret) {
-		ret = do_setxattr(mnt_idmap(path->mnt), path->dentry, &ix->ctx);
-		mnt_drop_write(path->mnt);
-	}
-
-	return ret;
-}
-
 int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
 	int ret;
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = __io_setxattr(req, issue_flags, &req->file->f_path);
+	ret = file_setxattr(req->file, &ix->ctx);
 	io_xattr_finish(req, ret);
 	return IOU_OK;
 }
@@ -232,22 +218,11 @@ int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
 int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
-	unsigned int lookup_flags = LOOKUP_FOLLOW;
-	struct path path;
 	int ret;
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-retry:
-	ret = filename_lookup(AT_FDCWD, ix->filename, lookup_flags, &path, NULL);
-	if (!ret) {
-		ret = __io_setxattr(req, issue_flags, &path);
-		path_put(&path);
-		if (retry_estale(ret, lookup_flags)) {
-			lookup_flags |= LOOKUP_REVAL;
-			goto retry;
-		}
-	}
+	ret = filename_setxattr(AT_FDCWD, ix->filename, &ix->ctx, LOOKUP_FOLLOW);
 
 	io_xattr_finish(req, ret);
 	return IOU_OK;

