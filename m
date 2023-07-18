Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53CED757D47
	for <lists+io-uring@lfdr.de>; Tue, 18 Jul 2023 15:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbjGRNWC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jul 2023 09:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbjGRNVi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jul 2023 09:21:38 -0400
Received: from out-52.mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C797B170D
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 06:21:37 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689686496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e5tdpTadoLYdZJB8cQ8K1ymkQcAcLx9XJrtCjJGJaVs=;
        b=BDFNXL5SyhanwGjSp9H3JcUxF9FJyYHjc5mRUjs0KvEPz4iwpDWr2EZ27A09CGETB3uayX
        Pp7nztzQr9b2mDmFt87cf/FLuj3CVJG/9lQ975PmlCYDEBNNhbF6FIGcUBTXWgRsKe3bMO
        7ta+qcVtBFiyJrd99WTSWuUgDgBeOlE=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 2/5] vfs_getdents/struct dir_context: add flags field
Date:   Tue, 18 Jul 2023 21:21:09 +0800
Message-Id: <20230718132112.461218-3-hao.xu@linux.dev>
In-Reply-To: <20230718132112.461218-1-hao.xu@linux.dev>
References: <20230718132112.461218-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

The flags will allow passing DIR_CONTEXT_F_NOWAIT to iterate()
implementations that support it (as signaled through FMODE_NWAIT
in file->f_mode)

Notes:
- considered using IOCB_NOWAIT but if we add more flags later it
would be confusing to keep track of which values are valid, use
dedicated flags
- might want to check ctx.flags & DIR_CONTEXT_F_NOWAIT is only set
when file->f_mode & FMODE_NOWAIT in iterate_dir() as e.g. WARN_ONCE?

Co-developed-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/internal.h      | 2 +-
 fs/readdir.c       | 6 ++++--
 include/linux/fs.h | 8 ++++++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index b1f66e52d61b..7508d485c655 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -311,4 +311,4 @@ void mnt_idmap_put(struct mnt_idmap *idmap);
 struct linux_dirent64;
 
 int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
-		 unsigned int count);
+		 unsigned int count, unsigned long flags);
diff --git a/fs/readdir.c b/fs/readdir.c
index 9592259b7e7f..b80caf4c9321 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -358,12 +358,14 @@ static bool filldir64(struct dir_context *ctx, const char *name, int namlen,
  * @file    : pointer to file struct of directory
  * @dirent  : pointer to user directory structure
  * @count   : size of buffer
+ * @flags   : additional dir_context flags
  */
 int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
-		 unsigned int count)
+		 unsigned int count, unsigned long flags)
 {
 	struct getdents_callback64 buf = {
 		.ctx.actor = filldir64,
+		.ctx.flags = flags,
 		.count = count,
 		.current_dir = dirent
 	};
@@ -395,7 +397,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 	if (!f.file)
 		return -EBADF;
 
-	error = vfs_getdents(f.file, dirent, count);
+	error = vfs_getdents(f.file, dirent, count, 0);
 
 	fdput_pos(f);
 	return error;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6867512907d6..f3e315e8efdd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1719,8 +1719,16 @@ typedef bool (*filldir_t)(struct dir_context *, const char *, int, loff_t, u64,
 struct dir_context {
 	filldir_t actor;
 	loff_t pos;
+	unsigned long flags;
 };
 
+/*
+ * flags for dir_context flags
+ * DIR_CONTEXT_F_NOWAIT: Request non-blocking iterate
+ *                       (requires file->f_mode & FMODE_NOWAIT)
+ */
+#define DIR_CONTEXT_F_NOWAIT	(1 << 0)
+
 /*
  * These flags let !MMU mmap() govern direct device mapping vs immediate
  * copying more easily for MAP_PRIVATE, especially for ROM filesystems.
-- 
2.25.1

