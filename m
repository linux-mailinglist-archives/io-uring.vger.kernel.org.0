Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30853BD727
	for <lists+io-uring@lfdr.de>; Tue,  6 Jul 2021 14:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbhGFMwm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Jul 2021 08:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241836AbhGFMwN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Jul 2021 08:52:13 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA02EC061760;
        Tue,  6 Jul 2021 05:49:33 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id b40so9158808ljf.12;
        Tue, 06 Jul 2021 05:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gJq2iRTwHGrfYDqYL7yzYFbXyEbtL7aWF6AFG6qJkmM=;
        b=u/KpHxWOeVMb9ymxDIWlZff+1dnE91bMiUZB+giivR0IZAWcowsj1FrfVUlT2QEoNS
         xHQY3CUYTYUcIEscxdlrZ0MKl4muZ1y0tZCt1nITf2oeb87uVvOmlkmskXHbE/B1Xpx9
         HDHtFx5sNQbwVkJ3m3cXnCJbRcJ1y1JROgi9Tbu2Hl89XGtCQWrTwIYoBzRVEt77SXg2
         1fEa+GOae914uJ0qqF8wCrdw1PQ2vQY1q0KP3RKKA34sjDFB1i45OJbgtqhbDF8AIGtY
         dNp3kbImNT7GoGbPNPYVwcmO/b3tj2ldeB8qDfPmU/Zhk7bb1Yx6ZZEnV+crkMPysuTX
         FDoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gJq2iRTwHGrfYDqYL7yzYFbXyEbtL7aWF6AFG6qJkmM=;
        b=HJdQta7oUvd5VGiNRax+N+rwpcDVBhknf0jkiPGn90qZZ/Tg4WRGmn8js09c3e6sH2
         Y5Q41ysLHwL9InyK50KuW6nTC8YhiejuhfH4XoYTbyGUr24G/67i7v/x7SGag0j3Orq6
         qnSwdsDOahmsQkaxcTJ8al5NHk+72vfXZyiUDuSZoVQBVdnVwO4ZiJEv5Je/7mTfKiIU
         JcMDH6SxGvFYBKGR+pg2ZjqpAtBRuhP+dv7mN8mO+I2H6GE0km85R91DqsqpPem0G6wI
         NJER3/9q/O5MhHkPIE/2DaW7yhM/yPubtW0xwPZaZavRVdhoII1sQ+TN7ekJL5HojO8m
         V12g==
X-Gm-Message-State: AOAM532v4oI/O23wHi3WGfoFtM8lkpX7OEuYF0ZsoVqi4MSssDLEZu/1
        0VS3uyV7VXH+9ToNwf0jwys=
X-Google-Smtp-Source: ABdhPJyfaqlQ2gRvLlXcTzEcltO5/3XD2JQtdTCWyONqCZFhG22PpOjkgkcz0aCdfoFikKKto/iSsg==
X-Received: by 2002:a2e:9e8e:: with SMTP id f14mr15154861ljk.468.1625575772041;
        Tue, 06 Jul 2021 05:49:32 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id r18sm139519ljc.120.2021.07.06.05.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 05:49:31 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v7 10/10] io_uring: add support for IORING_OP_LINKAT
Date:   Tue,  6 Jul 2021 19:49:01 +0700
Message-Id: <20210706124901.1360377-11-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706124901.1360377-1-dkadashev@gmail.com>
References: <20210706124901.1360377-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_LINKAT behaves like linkat(2) and takes the same flags and
arguments.

In some internal places 'hardlink' is used instead of 'link' to avoid
confusion with the SQE links. Name 'link' conflicts with the existing
'link' member of io_kiocb.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/internal.h                 |  2 +
 fs/io_uring.c                 | 71 +++++++++++++++++++++++++++++++++++
 fs/namei.c                    |  2 +-
 include/uapi/linux/io_uring.h |  2 +
 4 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/fs/internal.h b/fs/internal.h
index 3b3954214385..15a7d210cc67 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -79,6 +79,8 @@ int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
 int do_mkdirat(int dfd, struct filename *name, umode_t mode);
 int do_symlinkat(struct filename *from, int newdfd, struct filename *to);
+int do_linkat(int olddfd, struct filename *old, int newdfd,
+			struct filename *new, int flags);
 
 /*
  * namespace.c
diff --git a/fs/io_uring.c b/fs/io_uring.c
index a0f681ec25bb..d18ca8afd1fb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -688,6 +688,15 @@ struct io_symlink {
 	struct filename			*newpath;
 };
 
+struct io_hardlink {
+	struct file			*file;
+	int				old_dfd;
+	int				new_dfd;
+	struct filename			*oldpath;
+	struct filename			*newpath;
+	int				flags;
+};
+
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
@@ -847,6 +856,7 @@ struct io_kiocb {
 		struct io_unlink	unlink;
 		struct io_mkdir		mkdir;
 		struct io_symlink	symlink;
+		struct io_hardlink	hardlink;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1060,6 +1070,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_UNLINKAT] = {},
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
+	[IORING_OP_LINKAT] = {},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -3653,6 +3664,57 @@ static int io_symlinkat(struct io_kiocb *req, int issue_flags)
 	return 0;
 }
 
+static int io_linkat_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_hardlink *lnk = &req->hardlink;
+	const char __user *oldf, *newf;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->rw_flags || sqe->buf_index)
+		return -EINVAL;
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	lnk->old_dfd = READ_ONCE(sqe->fd);
+	lnk->new_dfd = READ_ONCE(sqe->len);
+	oldf = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	newf = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	lnk->flags = READ_ONCE(sqe->hardlink_flags);
+
+	lnk->oldpath = getname(oldf);
+	if (IS_ERR(lnk->oldpath))
+		return PTR_ERR(lnk->oldpath);
+
+	lnk->newpath = getname(newf);
+	if (IS_ERR(lnk->newpath)) {
+		putname(lnk->oldpath);
+		return PTR_ERR(lnk->newpath);
+	}
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+static int io_linkat(struct io_kiocb *req, int issue_flags)
+{
+	struct io_hardlink *lnk = &req->hardlink;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret = do_linkat(lnk->old_dfd, lnk->oldpath, lnk->new_dfd,
+				lnk->newpath, lnk->flags);
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
@@ -6065,6 +6127,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_mkdirat_prep(req, sqe);
 	case IORING_OP_SYMLINKAT:
 		return io_symlinkat_prep(req, sqe);
+	case IORING_OP_LINKAT:
+		return io_linkat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6233,6 +6297,10 @@ static void io_clean_op(struct io_kiocb *req)
 			putname(req->symlink.oldpath);
 			putname(req->symlink.newpath);
 			break;
+		case IORING_OP_LINKAT:
+			putname(req->hardlink.oldpath);
+			putname(req->hardlink.newpath);
+			break;
 		}
 	}
 	if ((req->flags & REQ_F_POLLED) && req->apoll) {
@@ -6367,6 +6435,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_SYMLINKAT:
 		ret = io_symlinkat(req, issue_flags);
 		break;
+	case IORING_OP_LINKAT:
+		ret = io_linkat(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/fs/namei.c b/fs/namei.c
index 3cf8f5e3b155..99d315462c42 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4356,7 +4356,7 @@ EXPORT_SYMBOL(vfs_link);
  * with linux 2.0, and to avoid hard-linking to directories
  * and other special files.  --ADM
  */
-static int do_linkat(int olddfd, struct filename *old, int newdfd,
+int do_linkat(int olddfd, struct filename *old, int newdfd,
 	      struct filename *new, int flags)
 {
 	struct user_namespace *mnt_userns;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 61fd347ab176..10eb38d2864f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -44,6 +44,7 @@ struct io_uring_sqe {
 		__u32		splice_flags;
 		__u32		rename_flags;
 		__u32		unlink_flags;
+		__u32		hardlink_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -135,6 +136,7 @@ enum {
 	IORING_OP_UNLINKAT,
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
+	IORING_OP_LINKAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.30.2

