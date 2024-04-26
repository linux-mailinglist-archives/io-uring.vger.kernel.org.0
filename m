Return-Path: <io-uring+bounces-1650-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 944B48B3CD1
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 18:32:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B73F61C224F4
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 16:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 623D06BFB1;
	Fri, 26 Apr 2024 16:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=seltendoof.de header.i=@seltendoof.de header.b="U1nKbjcn"
X-Original-To: io-uring@vger.kernel.org
Received: from server02.seltendoof.de (server02.seltendoof.de [168.119.48.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5534A2B9AF;
	Fri, 26 Apr 2024 16:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.48.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714149130; cv=none; b=TlIjW6HirTetfEGaxb8CoEx5tWLBJuJ6lIjqoNGCAHsqmdJjETsQb4TAWuH0zlYti9bpH5wRupvun2SXcCU19wZadFsPBfpZtKySr8XHSsrUC6NGeRf6GFTlgk4HfLT1RYdkcR7o5K+/7UciY1mgTmbZBb2qwWadEn2f8Z+yKbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714149130; c=relaxed/simple;
	bh=fGe0JQqXwScJg7nYQvWsn+u/6hpAOG8C2NbPdKgaIgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XyKD7TsKUnd1pLPzl/yv6wt25uLb8Y3yGITQps9DbNEpNZTrNwNRkhhbOe22tHraTMY1hzZD5WENxUPE7yRYyPE/0BRdo8Do+qQZllJKYm+JDsFxVrj4vDAyqpp6RjLC/jNNIQjrT47xiPtBbaAhIGW/nuNQVYlw8sL9gTCP2dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=seltendoof.de; spf=pass smtp.mailfrom=seltendoof.de; dkim=pass (2048-bit key) header.d=seltendoof.de header.i=@seltendoof.de header.b=U1nKbjcn; arc=none smtp.client-ip=168.119.48.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=seltendoof.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seltendoof.de
From: =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgoettsche@seltendoof.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seltendoof.de;
	s=2023072701; t=1714148463;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cFD0pvg4orrZWH7JCCIWvQcxitlwJBZqeb1sFDYG+1Y=;
	b=U1nKbjcnG/dajzWMm81Rovn1ZBNp4KKwvZKHpnd1e71VjBKWrgmLZsbKnPBzDpCzVlXXi7
	hzTrib9bZXcJfBA5DmYzjniFPX6aJ7IOWU+DoaFUNle4H+/ZgBxSVK6n4SLGL6fYLbTC+t
	ypqv1ZGJm2kVwohG3v34yfEGi6vRrDC9urr/J+/2ckMwXrPaIzVG9mXhlO2p0kkqJRCSA+
	IJki4rz0+T7VgPXW4lVEF7p2hiAyW1qtWOWEi1nb5Nfa/dgVXj2zoSLX/7DQETYuIrsyaF
	z3yvB8IbANBk0Mic2y7iIlx4NBKMEHXmBqQlKWb7UGXSNO1CZPNhGuHTksTaxw==
To: cgzones@googlemail.com
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH v3 1/2] fs: rename struct xattr_ctx to kernel_xattr_ctx
Date: Fri, 26 Apr 2024 18:20:15 +0200
Message-ID: <20240426162042.191916-2-cgoettsche@seltendoof.de>
In-Reply-To: <20240426162042.191916-1-cgoettsche@seltendoof.de>
References: <20240426162042.191916-1-cgoettsche@seltendoof.de>
Reply-To: cgzones@googlemail.com
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Göttsche <cgzones@googlemail.com>

Rename the struct xattr_ctx to increase distinction with the about to be
added user API struct xattr_args.

No functional change.

Suggested-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
v3: added based on feedback
---
 fs/internal.h    |  8 ++++----
 fs/xattr.c       | 10 +++++-----
 io_uring/xattr.c |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 7ca738904e34..1caa6a8f666f 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -260,7 +260,7 @@ struct xattr_name {
 	char name[XATTR_NAME_MAX + 1];
 };
 
-struct xattr_ctx {
+struct kernel_xattr_ctx {
 	/* Value of attribute */
 	union {
 		const void __user *cvalue;
@@ -276,11 +276,11 @@ struct xattr_ctx {
 
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
index f8b643f91a98..941aab719da0 100644
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
@@ -636,7 +636,7 @@ setxattr(struct mnt_idmap *idmap, struct dentry *d,
 	int flags)
 {
 	struct xattr_name kname;
-	struct xattr_ctx ctx = {
+	struct kernel_xattr_ctx ctx = {
 		.cvalue   = value,
 		.kvalue   = NULL,
 		.size     = size,
@@ -719,7 +719,7 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
  */
 ssize_t
 do_getxattr(struct mnt_idmap *idmap, struct dentry *d,
-	struct xattr_ctx *ctx)
+	struct kernel_xattr_ctx *ctx)
 {
 	ssize_t error;
 	char *kname = ctx->kname->name;
@@ -754,7 +754,7 @@ getxattr(struct mnt_idmap *idmap, struct dentry *d,
 {
 	ssize_t error;
 	struct xattr_name kname;
-	struct xattr_ctx ctx = {
+	struct kernel_xattr_ctx ctx = {
 		.value    = value,
 		.kvalue   = NULL,
 		.size     = size,
diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index 44905b82eea8..28b8f7b1af7c 100644
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
2.43.0


