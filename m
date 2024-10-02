Return-Path: <io-uring+bounces-3355-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9135798CAB1
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 03:22:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C38871C22515
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 01:22:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534216FB0;
	Wed,  2 Oct 2024 01:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ch0X0zpb"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84729450;
	Wed,  2 Oct 2024 01:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832154; cv=none; b=bxHag7TB27c6mr0JnAhk5G1uA/RFAvQpI4tu9cL2UZP+aw6b2RQz645Sg3o7/ISag3Qf2UZxWlr3mg+n40yAd9a2tYK3sS0pMFDGNflabU00hKV/G1gS65Yfzg7z3bkda3fWG8DMYCtmS1v/fe5D3yuoYhaYYWQJs1skQmocloE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832154; c=relaxed/simple;
	bh=f88IB4PTDKAV6GtuYOuya4kyGV9E9/vovooueg0ZoLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SISslf/oINiDX3Ks6rcUCfdgtA63khmLkMoqp51hetJkjzwiURy9yuuDyFjMkG5NpZttcndkx5fHAmoRAEGSgyiZTJL70vaM/CkOAkfBtqwA4PT+jtaV/iZ5XFFzDALLwahzY09BZwkJhEAtk14Tenk+i/q4n4zqkjvAti0rPwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ch0X0zpb; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Reply-To:Content-ID:Content-Description;
	bh=pkYbQ6A2E8yrKld2874J/quEWv8Girhvo1LfyLaZNPg=; b=ch0X0zpblgb/GayVafec7IRzPa
	6RoPMifBXUgBg+kfqfESAQcAonG7vuiOzFn9SY/vdq4e4qcT9z/SMRgkY0a+wJqZIBOlsWHFmwnsU
	cjM8+dyXtevVgMLU8/pGcKhd2J6GtEY9NyOCgd4QVj6kNMXKfNPkVwVA9Cud/YGwAJcElaa4ZRvpv
	fD2c7S5IJcZtwwkzQ4t2DY2HXc8ouFuB8I77QSnZlQxLlqlHIBEtOwBRGg8HjFcqXVicNmEuFTe91
	hKzbTFHvRwNcICC171O6OXC6UHoPVSTVjXNM7ctIFKXf/q3GOrbuRegHn80gjGiNLgHQ3PurkkOC+
	byINkQKw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svo4U-0000000HW0B-1ST7;
	Wed, 02 Oct 2024 01:22:30 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: brauner@kernel.org,
	io-uring@vger.kernel.org,
	cgzones@googlemail.com
Subject: [PATCH 2/9] fs: rename struct xattr_ctx to kernel_xattr_ctx
Date: Wed,  2 Oct 2024 02:22:23 +0100
Message-ID: <20241002012230.4174585-2-viro@zeniv.linux.org.uk>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

From: Christian Göttsche <cgzones@googlemail.com>

Rename the struct xattr_ctx to increase distinction with the about to be
added user API struct xattr_args.

No functional change.

Suggested-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Link: https://lore.kernel.org/r/20240426162042.191916-2-cgoettsche@seltendoof.de
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/internal.h    |  8 ++++----
 fs/xattr.c       | 12 ++++++------
 io_uring/xattr.c |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 8c1b7acbbe8f..81c7a085355c 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -267,7 +267,7 @@ struct xattr_name {
 	char name[XATTR_NAME_MAX + 1];
 };
 
-struct xattr_ctx {
+struct kernel_xattr_ctx {
 	/* Value of attribute */
 	union {
 		const void __user *cvalue;
@@ -283,11 +283,11 @@ struct xattr_ctx {
 
 ssize_t do_getxattr(struct mnt_idmap *idmap,
 		    struct dentry *d,
-		    struct xattr_ctx *ctx);
+		    struct kernel_xattr_ctx *ctx);
 
-int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
+int setxattr_copy(const char __user *name, struct kernel_xattr_ctx *ctx);
 int do_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
-		struct xattr_ctx *ctx);
+		struct kernel_xattr_ctx *ctx);
 int may_write_xattr(struct mnt_idmap *idmap, struct inode *inode);
 
 #ifdef CONFIG_FS_POSIX_ACL
diff --git a/fs/xattr.c b/fs/xattr.c
index 0fc813cb005c..1214ae7e71db 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -590,7 +590,7 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
  * Extended attribute SET operations
  */
 
-int setxattr_copy(const char __user *name, struct xattr_ctx *ctx)
+int setxattr_copy(const char __user *name, struct kernel_xattr_ctx *ctx)
 {
 	int error;
 
@@ -620,7 +620,7 @@ int setxattr_copy(const char __user *name, struct xattr_ctx *ctx)
 }
 
 int do_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
-		struct xattr_ctx *ctx)
+		struct kernel_xattr_ctx *ctx)
 {
 	if (is_posix_acl_xattr(ctx->kname->name))
 		return do_set_acl(idmap, dentry, ctx->kname->name,
@@ -635,7 +635,7 @@ static int path_setxattr(const char __user *pathname,
 			 size_t size, int flags, unsigned int lookup_flags)
 {
 	struct xattr_name kname;
-	struct xattr_ctx ctx = {
+	struct kernel_xattr_ctx ctx = {
 		.cvalue   = value,
 		.kvalue   = NULL,
 		.size     = size,
@@ -687,7 +687,7 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 		const void __user *,value, size_t, size, int, flags)
 {
 	struct xattr_name kname;
-	struct xattr_ctx ctx = {
+	struct kernel_xattr_ctx ctx = {
 		.cvalue   = value,
 		.kvalue   = NULL,
 		.size     = size,
@@ -720,7 +720,7 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
  */
 ssize_t
 do_getxattr(struct mnt_idmap *idmap, struct dentry *d,
-	struct xattr_ctx *ctx)
+	struct kernel_xattr_ctx *ctx)
 {
 	ssize_t error;
 	char *kname = ctx->kname->name;
@@ -755,7 +755,7 @@ getxattr(struct mnt_idmap *idmap, struct dentry *d,
 {
 	ssize_t error;
 	struct xattr_name kname;
-	struct xattr_ctx ctx = {
+	struct kernel_xattr_ctx ctx = {
 		.value    = value,
 		.kvalue   = NULL,
 		.size     = size,
diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index 6cf41c3bc369..5b4594ede935 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -18,7 +18,7 @@
 
 struct io_xattr {
 	struct file			*file;
-	struct xattr_ctx		ctx;
+	struct kernel_xattr_ctx		ctx;
 	struct filename			*filename;
 };
 
-- 
2.39.5


