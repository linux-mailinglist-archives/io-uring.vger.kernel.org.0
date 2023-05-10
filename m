Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8C16FDBFC
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 12:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236643AbjEJKyX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 06:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236748AbjEJKxm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 06:53:42 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B96D7AA5;
        Wed, 10 May 2023 03:53:33 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 98B63C01E; Wed, 10 May 2023 12:53:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683716011; bh=5MT6qB5ApvVN1dNUb6Euqb9qa0bf88BcEZ2ppeeLcL8=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=0cpQFerv+bBMhI7Mb3hxcD2jLWNdUZV+9n39ITvB/6lA7Y70SBv2uKqD1+eXnYFzN
         f4szV6HMVik/dxrZ8eRC19+xN+8nN72L2FgDbwuFOzThU2VfDBffmOiP3nSG+5JEi1
         ld7YT/Z+pBgAT05iNTI5LH/5NEazE5xSTTCmP0NrFkLoDAdpBxYTqXTa2qBuEsVYf1
         tjflXygr/8A4XdJ4XBsGYS/lAPeSGa2l52/S3SP3T+xmCyyhXLLlCYOw1V+qTYV0BO
         OOnURhTOU7aSd8qqdxvYDgLgsv47aCf5htq0GPCFPF3iZBqj0bbIemggqEC0euAIM+
         mjhyTyl5yQaow==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,WEIRD_QUOTING autolearn=ham
        autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 38023C021;
        Wed, 10 May 2023 12:53:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683716010; bh=5MT6qB5ApvVN1dNUb6Euqb9qa0bf88BcEZ2ppeeLcL8=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=LEwGAG+S61KRMI5strlApS4avLmZSfP9A4cU+u7+5zkn/0uCOxTnfnZ0AM92+L3QR
         73XnFzUmr0n/+u3A586LsJpfvVKIsy456BHiIbQU8k08YGIonSTgfMG0A18I1pJ/pW
         /vi8alO4kG6E5aIoQvGPCvk38ZVI5LNg74zk2D8mms/gTpEC1YR+yqB/rhas/GplqQ
         S7fmSVFHyztq5o6cf0DmxUKnL+tV+mjtXAQqYR+aEsFzjto9jsILR+96q5+PwEoeDZ
         77Sj+PAqAAGZ6hXNPIS7RqWiP9sZcjDRE0JoZQ40xmFAXzi2vOKhhfo2DjnQN0gXL3
         VRDYqcDYS3M+g==
Received: from [127.0.0.2] (localhost [::1])
        by odin.codewreck.org (OpenSMTPD) with ESMTP id 6d09a1f5;
        Wed, 10 May 2023 10:53:02 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
Date:   Wed, 10 May 2023 19:52:54 +0900
Subject: [PATCH v2 6/6] RFC: io_uring getdents: test returning an EOF flag
 in CQE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230422-uring-getdents-v2-6-2db1e37dc55e@codewreck.org>
References: <20230422-uring-getdents-v2-0-2db1e37dc55e@codewreck.org>
In-Reply-To: <20230422-uring-getdents-v2-0-2db1e37dc55e@codewreck.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>
Cc:     Clay Harris <bugs@claycon.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=6420;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=EOQY5TIMFcFLfz+pvWNR1o8nxPHoG0dUpAU+Ei2h49c=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkW3eOP/DmSN+k75DDH8LGzVVwQYQ04IO47OygJ
 fqAOQAsdMaJAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZFt3jgAKCRCrTpvsapjm
 cNpcD/0WCbelxKAz8+4oVltN6dyFWbD5b4RLLKuWU6kuMeN9iOvEMiKwNyxhrZ9XnLrzJ/j7B8Y
 YHSO63fVZeCImAKYUsaDSWwBRjISBkCoa7xd4SPCTOBd6h0TK62epEDA/gLyDC+ySv/1UUkXfQb
 l88gwbj0P0WO6b6IG5SniuV5bQc6HxzgbuBsPlrkSQhE639aeN0tJYJ/X/3Do6WmTW0r0F8tki5
 a0mxZ3xBU7lKpI1+miIpn+B/1764Vr6f39yeGQVTt3FDv917NbrCjDxUX3/iD8zaCT2N60rVJB2
 kl6jSuetvLqjO42gLII0sVVsLLA4kKe6BhkHWhrFhWJ8Xd4CmW/bhUadzMdX9tvLy6rKLc7+U3I
 Lm88y6PFHt9LGqpn+yEA+nfXel5jYDWfv8zs5frMW47X/K9ERDYplwF8e0UyiTx30ojtAEAzoYe
 7+LXwhFYku7qDFE+arKPjHQXrlQxCOF26/tx9FfRkNFRuo3l9Rvq91UHiFqEW23m5BGSeuGVw/3
 nD5F6qp0uP7ysB3qSQhZycbUR7SS8dSLD5801FVmScYg0sd/q8C03PYRSiyZIGVbWzOxJrHqfAE
 Zk7dWZXT95EvMJzeohRle0HGtl2yVU7ANPDf1stJR2uo/7LkCqhh4Aqvt2+XnRqMeQxeFHM+Bhq
 zWw/Kngpf219KFg==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This turns out to be very slightly faster than an extra call to
getdents, but in practice it doesn't seem to be such an improvement as
the trailing getdents will return almost immediately be absorbed by the
scheduling noise in a find-like context (my ""server"" is too noisy to
get proper benchmarks out, but results look slightly better with this in
async mode, and almost identical in the NOWAIT path)

If the user is waiting the end of a single directory though it might be
worth it, so including the patch for comments.
(in particular I'm not really happy that the flag has become in-out for
vfs_getdents, especially when the getdents64 syscall does not use it,
but I don't see much other way around it)

If this approach is acceptable/wanted then this patch will be split down
further (at least dir_context/vfs_getdents, kernfs, libfs, uring in four
separate commits)

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 fs/internal.h                 |  2 +-
 fs/kernfs/dir.c               |  1 +
 fs/libfs.c                    |  9 ++++++---
 fs/readdir.c                  | 10 ++++++----
 include/linux/fs.h            |  2 ++
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/fs.c                 |  8 ++++++--
 7 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 0264b001d99a..0b1552c7a870 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -267,4 +267,4 @@ void mnt_idmap_put(struct mnt_idmap *idmap);
 struct linux_dirent64;
 
 int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
-		 unsigned int count, unsigned long flags);
+		 unsigned int count, unsigned long *flags);
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 5a5b3e7881bf..53a6b4804c34 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1860,6 +1860,7 @@ static int kernfs_fop_readdir(struct file *file, struct dir_context *ctx)
 	up_read(&root->kernfs_rwsem);
 	file->private_data = NULL;
 	ctx->pos = INT_MAX;
+	ctx->flags |= DIR_CONTEXT_F_EOD;
 	return 0;
 }
 
diff --git a/fs/libfs.c b/fs/libfs.c
index a3c7e42d90a7..b2a95dadffbd 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -208,10 +208,12 @@ int dcache_readdir(struct file *file, struct dir_context *ctx)
 		p = &next->d_child;
 	}
 	spin_lock(&dentry->d_lock);
-	if (next)
+	if (next) {
 		list_move_tail(&cursor->d_child, &next->d_child);
-	else
+	} else {
 		list_del_init(&cursor->d_child);
+		ctx->flags |= DIR_CONTEXT_F_EOD;
+	}
 	spin_unlock(&dentry->d_lock);
 	dput(next);
 
@@ -1347,7 +1349,8 @@ static loff_t empty_dir_llseek(struct file *file, loff_t offset, int whence)
 
 static int empty_dir_readdir(struct file *file, struct dir_context *ctx)
 {
-	dir_emit_dots(file, ctx);
+	if (dir_emit_dots(file, ctx))
+		ctx->flags |= DIR_CONTEXT_F_EOD;
 	return 0;
 }
 
diff --git a/fs/readdir.c b/fs/readdir.c
index 1311b89d75e1..be75a2154b4f 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -358,14 +358,14 @@ static bool filldir64(struct dir_context *ctx, const char *name, int namlen,
  * @file    : pointer to file struct of directory
  * @dirent  : pointer to user directory structure
  * @count   : size of buffer
- * @flags   : additional dir_context flags
+ * @flags   : pointer to additional dir_context flags
  */
 int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
-		 unsigned int count, unsigned long flags)
+		 unsigned int count, unsigned long *flags)
 {
 	struct getdents_callback64 buf = {
 		.ctx.actor = filldir64,
-		.ctx.flags = flags,
+		.ctx.flags = flags ? *flags : 0,
 		.count = count,
 		.current_dir = dirent
 	};
@@ -384,6 +384,8 @@ int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
 		else
 			error = count - buf.count;
 	}
+	if (flags)
+		*flags = buf.ctx.flags;
 	return error;
 }
 
@@ -397,7 +399,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 	if (!f.file)
 		return -EBADF;
 
-	error = vfs_getdents(f.file, dirent, count, 0);
+	error = vfs_getdents(f.file, dirent, count, NULL);
 
 	fdput_pos(f);
 	return error;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f7de2b5ca38e..d1e31bccfb4f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1723,8 +1723,10 @@ struct dir_context {
  * flags for dir_context flags
  * DIR_CONTEXT_F_NOWAIT: Request non-blocking iterate
  *                       (requires file->f_mode & FMODE_NOWAIT)
+ * DIR_CONTEXT_F_EOD: Signal directory has been fully iterated, set by the fs
  */
 #define DIR_CONTEXT_F_NOWAIT	0x1
+#define DIR_CONTEXT_F_EOD	0x2
 
 /*
  * These flags let !MMU mmap() govern direct device mapping vs immediate
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 35d0de18d893..35877132027e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -381,11 +381,13 @@ struct io_uring_cqe {
  * IORING_CQE_F_SOCK_NONEMPTY	If set, more data to read after socket recv
  * IORING_CQE_F_NOTIF	Set for notification CQEs. Can be used to distinct
  * 			them from sends.
+ * IORING_CQE_F_EOF     If set, file or directory has reached end of file.
  */
 #define IORING_CQE_F_BUFFER		(1U << 0)
 #define IORING_CQE_F_MORE		(1U << 1)
 #define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
 #define IORING_CQE_F_NOTIF		(1U << 3)
+#define IORING_CQE_F_EOF		(1U << 4)
 
 enum {
 	IORING_CQE_BUFFER_SHIFT		= 16,
diff --git a/io_uring/fs.c b/io_uring/fs.c
index b15ec81c1ed2..f6222b0148ef 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -322,6 +322,7 @@ int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
 	unsigned long getdents_flags = 0;
+	u32 cqe_flags = 0;
 	int ret;
 
 	if (issue_flags & IO_URING_F_NONBLOCK) {
@@ -338,13 +339,16 @@ int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
 			goto out;
 	}
 
-	ret = vfs_getdents(req->file, gd->dirent, gd->count, getdents_flags);
+	ret = vfs_getdents(req->file, gd->dirent, gd->count, &getdents_flags);
 out:
 	if (ret == -EAGAIN &&
 	    (issue_flags & IO_URING_F_NONBLOCK))
 			return -EAGAIN;
 
-	io_req_set_res(req, ret, 0);
+	if (getdents_flags & DIR_CONTEXT_F_EOD)
+		cqe_flags |= IORING_CQE_F_EOF;
+
+	io_req_set_res(req, ret, cqe_flags);
 	return 0;
 }
 

-- 
2.39.2

