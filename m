Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF1C3BD724
	for <lists+io-uring@lfdr.de>; Tue,  6 Jul 2021 14:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbhGFMwi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Jul 2021 08:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241426AbhGFMwL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Jul 2021 08:52:11 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72353C061764;
        Tue,  6 Jul 2021 05:49:32 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id v14so12546074lfb.4;
        Tue, 06 Jul 2021 05:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tsMm5RVkk7HjOAg6FFDUzu6dgkNFgLiUvnWCmOkKYN0=;
        b=O1gTq7K8zViQw+flUMMEU+hJo6BwsJPeO3Kx+BsZFlvzZdBgTeyx7GWYnsvB9RSWdc
         6r+DFs9ygFK9/6OJVbt6gJd1LjV9CENN86Dq1GIN+OmIxkCGXJpOwX/lkeTQqw9MNZDg
         vlKpXfwV35LnYB7HOTry6SoShk6DnITR1ArMi3CbA+UMHsWfCmPBweWTOBkNOQT36SDx
         uVAqkzI1phlGn5rkIYCW8k7AjdnHz3FmisPTerDHSWYcITOevwbClyoZM57J318wBMCc
         FQ0k3y/iKGetPp4D0CE8JOOFDggxN0AgQFsCaSzM/WTiieOsa4IzcYgG6j7Mfy4gNs6s
         zQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tsMm5RVkk7HjOAg6FFDUzu6dgkNFgLiUvnWCmOkKYN0=;
        b=IYa7vo5dgt9ns/PubO3Xlzdu4JszEbk+FNyy+MLRQ3zQHJhz95l67tdMjJx/UHxKep
         ZPFo5aICRvLHZ1wSrbVbiqWEbb05KlxerKRlxu22jWxqvpFDt+QR1dLJFgCBOKcJsSf6
         1avuW/+nBkTOeGCDFbzWWiHHyo0ca2upZz35uL+IkwkIyvXffnaioYKT/tcBh8VSZ543
         FEcoF6oHUvPYrVkxwmR/cafQLmfJs6BxBGeOcEOCCGRcyAGn3NE+VxFAN+cDLmQ6hcaV
         waBImqYiCw6gTZG724lcCa4QPHUHBPyqsCE6BYCJMxYoes4qgwIawkKQ+A2uCmZbF8r7
         rvnQ==
X-Gm-Message-State: AOAM530owAAErrn+zt24MDkV7hzo48D81K+LsIqSq0GRel8MLZibLt6e
        SqAYixjWsJg1CepQQwN5yk4=
X-Google-Smtp-Source: ABdhPJyQVSR+QDqKEPXLsdeP0fnDXD1VG0KSEazsIvjcidrEqzyQDCfq2hl6Wnqarq9d+nSyDRxexw==
X-Received: by 2002:a19:9156:: with SMTP id y22mr14678803lfj.207.1625575770840;
        Tue, 06 Jul 2021 05:49:30 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id r18sm139519ljc.120.2021.07.06.05.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 05:49:30 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v7 09/10] io_uring: add support for IORING_OP_SYMLINKAT
Date:   Tue,  6 Jul 2021 19:49:00 +0700
Message-Id: <20210706124901.1360377-10-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706124901.1360377-1-dkadashev@gmail.com>
References: <20210706124901.1360377-1-dkadashev@gmail.com>
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
index 1656073ca493..3cf8f5e3b155 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4210,8 +4210,7 @@ int vfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
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

