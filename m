Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A350731EBA3
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 16:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbhBRPkR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 10:40:17 -0500
Received: from hmm.wantstofly.org ([213.239.204.108]:57150 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbhBRM2x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 07:28:53 -0500
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id 4DB447F4BD; Thu, 18 Feb 2021 14:27:21 +0200 (EET)
Date:   Thu, 18 Feb 2021 14:27:21 +0200
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     David Laight <David.Laight@aculab.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v3 1/2] readdir: split the core of getdents64(2) out into
 vfs_getdents()
Message-ID: <20210218122721.GB334506@wantstofly.org>
References: <20210218122640.GA334506@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218122640.GA334506@wantstofly.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

So that IORING_OP_GETDENTS may use it, split out the core of the
getdents64(2) syscall into a helper function, vfs_getdents().

vfs_getdents() calls into filesystems' ->iterate{,_shared}() which
expect serialization on struct file, which means that callers of
vfs_getdents() are responsible for either using fdget_pos() or
performing the equivalent serialization by hand.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
---
 fs/readdir.c       | 25 +++++++++++++++++--------
 include/linux/fs.h |  4 ++++
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index 19434b3c982c..f52167c1eb61 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -348,10 +348,9 @@ static int filldir64(struct dir_context *ctx, const char *name, int namlen,
 	return -EFAULT;
 }
 
-SYSCALL_DEFINE3(getdents64, unsigned int, fd,
-		struct linux_dirent64 __user *, dirent, unsigned int, count)
+int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
+		 unsigned int count)
 {
-	struct fd f;
 	struct getdents_callback64 buf = {
 		.ctx.actor = filldir64,
 		.count = count,
@@ -359,11 +358,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 	};
 	int error;
 
-	f = fdget_pos(fd);
-	if (!f.file)
-		return -EBADF;
-
-	error = iterate_dir(f.file, &buf.ctx);
+	error = iterate_dir(file, &buf.ctx);
 	if (error >= 0)
 		error = buf.error;
 	if (buf.prev_reclen) {
@@ -376,6 +371,20 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 		else
 			error = count - buf.count;
 	}
+	return error;
+}
+
+SYSCALL_DEFINE3(getdents64, unsigned int, fd,
+		struct linux_dirent64 __user *, dirent, unsigned int, count)
+{
+	struct fd f;
+	int error;
+
+	f = fdget_pos(fd);
+	if (!f.file)
+		return -EBADF;
+
+	error = vfs_getdents(f.file, dirent, count);
 	fdput_pos(f);
 	return error;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fd47deea7c17..114885d3f6c4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3109,6 +3109,10 @@ extern const struct inode_operations simple_symlink_inode_operations;
 
 extern int iterate_dir(struct file *, struct dir_context *);
 
+struct linux_dirent64;
+int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
+		 unsigned int count);
+
 int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
 		int flags);
 int vfs_fstat(int fd, struct kstat *stat);
-- 
2.29.2
