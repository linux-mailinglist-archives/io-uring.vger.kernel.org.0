Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1424F3BE7EC
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 14:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhGGMbA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 08:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbhGGMa5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 08:30:57 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C28C06175F;
        Wed,  7 Jul 2021 05:28:16 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id eb14so3211328edb.0;
        Wed, 07 Jul 2021 05:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=miRy2lgiuN42/MSS5JbhcjI1baujjkLTDwAmJ5AFvKA=;
        b=MVrRAE3XJGNqGyZDJP4Hnhuf9uOACBiCH8HwlCTVDxbWr+sV0C+RunqnwcKJDCSs9H
         l76g7czlittNJV9X4lpPrnTgwT3uqPibLyFPKgJ9N/F+xptFTVFoOJLwJ1UNOlo6cjzb
         6B49R3i8RCtKsxO+lR+DxH+N7gcGvUcmjyz/PDED06eCLgCie4dHxwU/VPS69pM+4PHm
         WvED3XfHeNKxfvjHdSeFQdXbeMZ5OTFNNZSUgUbc1NokA/ZsQYaGshjTmq/AEnEvhQGR
         3CQqPx0BZKhvZsQgfKvp3sGOZ1/bPxaEjOQ4bPn3FL16nFkUTpqwtVtx1t5K+ZQbJG16
         V4jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=miRy2lgiuN42/MSS5JbhcjI1baujjkLTDwAmJ5AFvKA=;
        b=rA6bCp/qg08qepIhh+AZ0M+L2StErKrdPMshq0PGuJzsHtje4u5Clqjb3j6q8dOjG6
         hQWgJnwK7atBWAUn8s/k7A9QBuplqFIA1u+Pwj1rjIqJDE/rlNc0T7G+Wj+DFp+W7BBi
         3za7scsQW2xdhJkNnBHiy7p+jlUVCCALnk6ba+0SCIKB6eE3Yxx2M2dN40uqm31X2Aqt
         vT0CkAy00TprOdbO2IR7ukdldYJFx7gnCptYY1znG1xsZWrd3FFG9Ghux7GAyEufc9p7
         QrpO8RamH0/XNkUZn+jGj2Z529YwA79HrR1CybSiJJ4WtAXDuQWIe98XahEvLzWfdag7
         fQCQ==
X-Gm-Message-State: AOAM530lTpt0mQG/g9seAn4y1Gy0GuDCt2gyn4jksZm0ol8OxZqFcSII
        1AHO1O8SzuUfyQoWkUUHoUM=
X-Google-Smtp-Source: ABdhPJwKZ8OuOVlU5ktkQAC2cEHXV4R9gENsiIqfe0UDLb5V0vHbVYdRE1TbD7xa/gQDUcG4LXpPvw==
X-Received: by 2002:a05:6402:1d86:: with SMTP id dk6mr533647edb.136.1625660895121;
        Wed, 07 Jul 2021 05:28:15 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id ze15sm7019821ejb.79.2021.07.07.05.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 05:28:14 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v8 10/11] io_uring: add support for IORING_OP_SYMLINKAT
Date:   Wed,  7 Jul 2021 19:27:46 +0700
Message-Id: <20210707122747.3292388-11-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210707122747.3292388-1-dkadashev@gmail.com>
References: <20210707122747.3292388-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_SYMLINKAT behaves like symlinkat(2) and takes the same flags
and arguments.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/internal.h                 |  1 +
 fs/io_uring.c                 | 66 +++++++++++++++++++++++++++++++++++
 fs/namei.c                    |  3 +-
 include/uapi/linux/io_uring.h |  1 +
 4 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 207a455e32d3..3b3954214385 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -78,6 +78,7 @@ int may_linkat(struct user_namespace *mnt_userns, struct path *link);
 int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
 int do_mkdirat(int dfd, struct filename *name, umode_t mode);
+int do_symlinkat(struct filename *from, int newdfd, struct filename *to);
 
 /*
  * namespace.c
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 42d54f9bbbb2..a0f681ec25bb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -681,6 +681,13 @@ struct io_mkdir {
 	struct filename			*filename;
 };
 
+struct io_symlink {
+	struct file			*file;
+	int				new_dfd;
+	struct filename			*oldpath;
+	struct filename			*newpath;
+};
+
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
@@ -839,6 +846,7 @@ struct io_kiocb {
 		struct io_rename	rename;
 		struct io_unlink	unlink;
 		struct io_mkdir		mkdir;
+		struct io_symlink	symlink;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1051,6 +1059,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINKAT] = {},
 	[IORING_OP_MKDIRAT] = {},
+	[IORING_OP_SYMLINKAT] = {},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -3596,6 +3605,54 @@ static int io_mkdirat(struct io_kiocb *req, int issue_flags)
 	return 0;
 }
 
+static int io_symlinkat_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_symlink *sl = &req->symlink;
+	const char __user *oldpath, *newpath;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->len || sqe->rw_flags || sqe->buf_index)
+		return -EINVAL;
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	sl->new_dfd = READ_ONCE(sqe->fd);
+	oldpath = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	newpath = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+
+	sl->oldpath = getname(oldpath);
+	if (IS_ERR(sl->oldpath))
+		return PTR_ERR(sl->oldpath);
+
+	sl->newpath = getname(newpath);
+	if (IS_ERR(sl->newpath)) {
+		putname(sl->oldpath);
+		return PTR_ERR(sl->newpath);
+	}
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+static int io_symlinkat(struct io_kiocb *req, int issue_flags)
+{
+	struct io_symlink *sl = &req->symlink;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret = do_symlinkat(sl->oldpath, sl->new_dfd, sl->newpath);
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
 static int io_shutdown_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -6006,6 +6063,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_unlinkat_prep(req, sqe);
 	case IORING_OP_MKDIRAT:
 		return io_mkdirat_prep(req, sqe);
+	case IORING_OP_SYMLINKAT:
+		return io_symlinkat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6170,6 +6229,10 @@ static void io_clean_op(struct io_kiocb *req)
 		case IORING_OP_MKDIRAT:
 			putname(req->mkdir.filename);
 			break;
+		case IORING_OP_SYMLINKAT:
+			putname(req->symlink.oldpath);
+			putname(req->symlink.newpath);
+			break;
 		}
 	}
 	if ((req->flags & REQ_F_POLLED) && req->apoll) {
@@ -6301,6 +6364,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_MKDIRAT:
 		ret = io_mkdirat(req, issue_flags);
 		break;
+	case IORING_OP_SYMLINKAT:
+		ret = io_symlinkat(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/fs/namei.c b/fs/namei.c
index d06aeaf5da00..f241348e64f4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4213,8 +4213,7 @@ int vfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_symlink);
 
-static int do_symlinkat(struct filename *from, int newdfd,
-		  struct filename *to)
+int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
 {
 	int error;
 	struct dentry *dentry;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a926407c230e..61fd347ab176 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -134,6 +134,7 @@ enum {
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
 	IORING_OP_MKDIRAT,
+	IORING_OP_SYMLINKAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.30.2

