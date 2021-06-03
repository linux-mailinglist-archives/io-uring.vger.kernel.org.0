Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C5C3999C8
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhFCFWH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:22:07 -0400
Received: from mail-ej1-f50.google.com ([209.85.218.50]:33625 "EHLO
        mail-ej1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhFCFWH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:22:07 -0400
Received: by mail-ej1-f50.google.com with SMTP id g20so7387145ejt.0;
        Wed, 02 Jun 2021 22:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V0ZAIxaEcDtjGgd2KDmvA4K6LyrI8LXXSNsuTMTR3P0=;
        b=Jdu3sEwBprZvz5AoxtfhLOEMKJbzLqUOG5l3E8xdUAN47NsQtrW5cK9JtYTVhdRT3v
         WGRorpR+cp6D2IlR3mTyMQWabjKrmJabZ7QA2EFSw/GcSTb3jqoHs5S56fujGCySRkZ/
         x5XK/bW1QKjAGODmWXRA3PTCDDfQQ90haMdKKExeJrkwbZ3FpFOpBAY9ECZpj0y+U3Ki
         yV4gjwxmM7pj/sympF6p4pXdFftrb3H+SGgs3Jgppw0mpUpqhx0ivRd246mWYYlDYs7y
         ywV6zZ6IR7rabFEgYP5a89fl/kD904K6+RysL5QSqmOCqbOxPRJwOZ5h3Fszyc8nnwnZ
         U4ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V0ZAIxaEcDtjGgd2KDmvA4K6LyrI8LXXSNsuTMTR3P0=;
        b=N9vBJ2CmgWUhqbE08YYKEz8HOgnBQsk5aAFWUijssYPzOvYjFiOw/AMGmpM03zKkj0
         kWqBt7B/ihsc8sJPepfe9p5qKCxhbUUtCypNgXUrnyHY3R5h+331ywsMWsIMyZaMzVtP
         Ha0X1zavoeiWh7WlJS1d6UHCDd6GHWdyBRmaPjAPs7Ht4NuU4sxvnOqTDbwiFzI6y+9R
         fnlL1YikJ4H7mygNunAx7kK6gJ/vG8piJ0aGxhpSAUFZaydYc5xg9mvNauVDO8waNZxX
         BbSOhNIPnSHxHx62SsBy7No6fbOvCdPW/GQ/ocmrRrcLJvIhILUolVXpqlc1sPnjlAbY
         aQgA==
X-Gm-Message-State: AOAM531XR6sHEA8ptRtq7Y3xA8XwY+wM8DfYt/OFXSsoKi5iPruUwh5c
        Lu9bxO466YxlqKgNkbS3uno=
X-Google-Smtp-Source: ABdhPJx/wQC6FL/5QXjKOAgdc+xxKZYlyHO70zOObs/hXuvZUKzbYOUKTh731uxVPsT6IfIITqYx7w==
X-Received: by 2002:a17:906:c1ca:: with SMTP id bw10mr38192062ejb.512.1622697548406;
        Wed, 02 Jun 2021 22:19:08 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id f7sm963668ejz.95.2021.06.02.22.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:19:08 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v5 09/10] io_uring: add support for IORING_OP_LINKAT
Date:   Thu,  3 Jun 2021 12:18:35 +0700
Message-Id: <20210603051836.2614535-10-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603051836.2614535-1-dkadashev@gmail.com>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
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

Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/internal.h                 |  2 ++
 fs/io_uring.c                 | 67 +++++++++++++++++++++++++++++++++++
 fs/namei.c                    |  2 +-
 include/uapi/linux/io_uring.h |  2 ++
 4 files changed, 72 insertions(+), 1 deletion(-)

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
index 5fdba9b381e5..31e1aa7dd90b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -679,6 +679,15 @@ struct io_symlink {
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
@@ -825,6 +834,7 @@ struct io_kiocb {
 		struct io_unlink	unlink;
 		struct io_mkdir		mkdir;
 		struct io_symlink	symlink;
+		struct io_hardlink	hardlink;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1039,6 +1049,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_UNLINKAT] = {},
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
+	[IORING_OP_LINKAT] = {},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -3630,6 +3641,53 @@ static int io_symlinkat(struct io_kiocb *req, int issue_flags)
 	return 0;
 }
 
+static int io_linkat_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_hardlink *lnk = &req->hardlink;
+	const char __user *oldf, *newf;
+
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
@@ -6040,6 +6098,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_mkdirat_prep(req, sqe);
 	case IORING_OP_SYMLINKAT:
 		return io_symlinkat_prep(req, sqe);
+	case IORING_OP_LINKAT:
+		return io_linkat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6188,6 +6248,10 @@ static void io_clean_op(struct io_kiocb *req)
 			putname(req->symlink.oldpath);
 			putname(req->symlink.newpath);
 			break;
+		case IORING_OP_LINKAT:
+			putname(req->hardlink.oldpath);
+			putname(req->hardlink.newpath);
+			break;
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
@@ -6320,6 +6384,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
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
index f5b0379d2f8c..b85e457c43b7 100644
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
index 7b8a78d9c947..510e64a0a9c3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -44,6 +44,7 @@ struct io_uring_sqe {
 		__u32		splice_flags;
 		__u32		rename_flags;
 		__u32		unlink_flags;
+		__u32		hardlink_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
@@ -139,6 +140,7 @@ enum {
 	IORING_OP_UNLINKAT,
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
+	IORING_OP_LINKAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.30.2

