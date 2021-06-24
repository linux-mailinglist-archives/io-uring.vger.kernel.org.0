Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD123B2D90
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 13:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbhFXLRr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 07:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbhFXLRh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 07:17:37 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3CCC061760;
        Thu, 24 Jun 2021 04:15:17 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id d16so9615520lfn.3;
        Thu, 24 Jun 2021 04:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1KNgQk+iy7YsDX0I+gkA6jbhtLveDWzi1UxDTxURyJk=;
        b=jdfioBcgTHWXEO34cbrzxBSwx/uq69rpDwGTYds0zIvMEreYVYr26XLYxxObVn+m2D
         JoSoNEnLdME5kxZQryZSdBWVSsy1bgt8KscMfhBO+J2BqE66Wt2vbxla5QkZpQwZe5jy
         94ndCxbe78KoxFi8J3y+/QEVayf6ML2IvdI7Q43gG9Es0jxjEU4DT8nke8yRzgjIMMQV
         WJDX0LpEgYH6voknaS5RCohlOR1daCiHatBbAV/xL3CrZn6ZmSUUZ9q4/OdyfbLbaJng
         XkxgQuyxGG9XN77JvU6cLERH28c+GUhIu3TqJT1cCNC/EZOj1bSAYV8qebtDkwnDqSb1
         SAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1KNgQk+iy7YsDX0I+gkA6jbhtLveDWzi1UxDTxURyJk=;
        b=uZ7Eya+UAmGk4EvdihLqJEWhymKcqW2+EKu5OCvQfTV/uLbz7xmIbXBEr486PO510X
         vO3P7PnsYEMgLvJGa+PyKsYIRHCgVWyxAn4ftIjSx0pEz8QXEa09YyY8wecjjsAyneDV
         OwZmYIf/Jw2a67oZBh+K/OA6SZc4eW31/p2YIZOOj0o6kthE7hgHndGGch/nYhXXbGJx
         KxVFMlG/LJ5g4sfv7q5VgPArvsVfVVPJRPhtIM8MN6YjnJ9KWW7YYgHFTTo85GokOPFk
         DWt1/MTCfm4VXOpkncQeL5+mpQWYqNs0dPmmfAsE357hp3ulLru/urU1BvMmXGwf5wsw
         wcHA==
X-Gm-Message-State: AOAM530ga4t3jq6zkK92k2m5naLCJtM72mF7PVi2PJ18/TBEzwFdQGUQ
        ls6blQNLUtLKTQTUbYiCwiA=
X-Google-Smtp-Source: ABdhPJzoHHxmv8xlFm8HD+l7/ea9//h0iSu2MS2le9wSnDhNaDaVYkGSEf0x7hWk6jBLqzruFi8wNw==
X-Received: by 2002:ac2:4db0:: with SMTP id h16mr3517610lfe.579.1624533316229;
        Thu, 24 Jun 2021 04:15:16 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id q21sm195293lfp.233.2021.06.24.04.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 04:15:15 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v6 8/9] io_uring: add support for IORING_OP_SYMLINKAT
Date:   Thu, 24 Jun 2021 18:14:51 +0700
Message-Id: <20210624111452.658342-9-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210624111452.658342-1-dkadashev@gmail.com>
References: <20210624111452.658342-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_SYMLINKAT behaves like symlinkat(2) and takes the same flags
and arguments.

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
index 7aa08ed78452..c161f06a3cea 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -680,6 +680,13 @@ struct io_mkdir {
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
@@ -833,6 +840,7 @@ struct io_kiocb {
 		struct io_rename	rename;
 		struct io_unlink	unlink;
 		struct io_mkdir		mkdir;
+		struct io_symlink	symlink;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1048,6 +1056,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINKAT] = {},
 	[IORING_OP_MKDIRAT] = {},
+	[IORING_OP_SYMLINKAT] = {},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -3599,6 +3608,54 @@ static int io_mkdirat(struct io_kiocb *req, int issue_flags)
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
@@ -6009,6 +6066,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_unlinkat_prep(req, sqe);
 	case IORING_OP_MKDIRAT:
 		return io_mkdirat_prep(req, sqe);
+	case IORING_OP_SYMLINKAT:
+		return io_symlinkat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6173,6 +6232,10 @@ static void io_clean_op(struct io_kiocb *req)
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
@@ -6304,6 +6367,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
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
index f99de6e294ad..f5b0379d2f8c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4208,8 +4208,7 @@ int vfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_symlink);
 
-static int do_symlinkat(struct filename *from, int newdfd,
-		  struct filename *to)
+int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
 {
 	int error;
 	struct dentry *dentry;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 49a24a149eeb..796f37ab4ce3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -138,6 +138,7 @@ enum {
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
 	IORING_OP_MKDIRAT,
+	IORING_OP_SYMLINKAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.30.2

