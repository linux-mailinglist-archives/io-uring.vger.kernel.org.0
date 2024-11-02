Return-Path: <io-uring+bounces-4346-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 767FC9B9DA0
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 08:32:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B47CD28303B
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 07:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DDE215852E;
	Sat,  2 Nov 2024 07:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="DVdl+kRG"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7159313C914;
	Sat,  2 Nov 2024 07:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730532713; cv=none; b=O3upnL1k/eUJmi3c71xKjCWNCTo5R3atSGuF1FpyxrLpPuebLcmT7ktOxkMBZPjo4NofVYAKm4NTfXwPtpp963gG7XuzE71wbObmTC3OwieWDxvhJTA4HjXUjpY2AJL9/SVj32YraocXA3Qvkr6qd5YuQjqNdEpRCFF7pXpRgNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730532713; c=relaxed/simple;
	bh=KZIdB10TNGT1qv2uszYxOzMneBQkka9o/T+Vt7ucH7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IiY6e3VBggDGtguhPLbtr0Tlmdgw1hCYJ4bw5SRcClsWY4+dCU2MLS2eS/hTWfULz2NDkUzw7dGNpLudF7VK/njh6aHPDphPHCYUMfrFJO1EktB4RnhcqRJdIknKaiwmKUQgoSNhrjiZ2E2B/2UhC1uKBWrpPwa1ZGA9KIaFheU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=DVdl+kRG; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Reply-To:Content-ID:Content-Description;
	bh=q0MuLEeJwSLEDP/uaE9xqULL5Bg/hzF02oMQL0NWn/A=; b=DVdl+kRGmxpAaseHah1CpTPunD
	xNtuX0yvaJCnx01p1Vo5Wl5o4ssUHrFK3WsQjo+9w07IJx0XR2bMlHAzJOf75xn4kL3mdaUTpYS15
	xVapW8kMEexUKbzotNIyRYIR7pQttTTetUZnLcX+NMqtDq4qL+OLVOwFwI8Hn2LtLVUWbTtkL73LK
	J7AWFjGlPsr3YIUMcvf8GvmM6DCF0ThDvXUYaopZQ7OmkmRK1/0xytfAFftQe7/83GQ3B/6Dx+uX9
	49FBnLUyztn7Y1D9gq7qdGUvFKCyY4eGnm5RmiighONZRExaBc5HoqG4J9l0/MmyckVlwCL716tdJ
	eVpmVMbw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t78bt-0000000AJFN-3LGS;
	Sat, 02 Nov 2024 07:31:49 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	io-uring@vger.kernel.org,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: [PATCH v2 06/13] fs: rename struct xattr_ctx to kernel_xattr_ctx
Date: Sat,  2 Nov 2024 07:31:42 +0000
Message-ID: <20241102073149.2457240-6-viro@zeniv.linux.org.uk>
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
index 967c5d8da061..f440121c3984 100644
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


