Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66803BF5AA
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 08:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhGHGiJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 02:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbhGHGiJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 02:38:09 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E30C061574;
        Wed,  7 Jul 2021 23:35:27 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id gb6so7596364ejc.5;
        Wed, 07 Jul 2021 23:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gYlonjHEqq+ciO9uXQTdjBC9hqLlNtpIxlPjlB/koR0=;
        b=G3ZckjUACjE4bjxSM0aVHwZ+/dOxUXcShlR94lZTxRC71/rfakEcUJhiCuIbxh/2PN
         MFbhEOpYNEzIaFx9YF2JnmPBut2MtMAKstwBjMuwEimOcimFaHWEb8MEAw/LdFaEAJ8K
         phXTihF2KY33vRjNapkURa6ubE7DNfsjpoZtanngG8EoUALhSZT5D3X57fzgYwl1Gbqk
         RdfzP0UmJzaPpP3F+GdTpgK7K0KUljZ/Rn8tJhkoKQgzsYmjTNufTKQa4GjmYzqKxzI2
         x68jaxfSxA+pCmtnHg32xeziTa8KMBbpw/vXGc7/E+PnRsByfKSkkFb4rWh6v7g15Dtf
         Hb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gYlonjHEqq+ciO9uXQTdjBC9hqLlNtpIxlPjlB/koR0=;
        b=B8EWIkjq+jUZS7WAShNIdAUg2sV7ENk6la+iNtSqYCCF9ojFnzXCvxuVf1u3rusHvN
         IKpj8upMoEeKBNupXHg8BRHI/cZvjhSHfbhWzxb4hiirdS0KvXT0k+wqCNsL5RjnJtOY
         OUIBt1vyXwAa6QemkC/F6LQ3R6wwAUY3RGZYiMzUPKYoS8J970X4VRrEa/ZSqRzitypl
         pYH3QjYjghAdPeyHt2sgTUWU+uRRPkWFEspfKxXudZNPskpyGQEJk/88hzZVWIkL8wTu
         ohXsW+C05WU8JJF8BPv6bBBxN6AKDLrlUm9Hx9Wzkn0HzkZRZ022Ln6HNSF5XkRd9/kO
         a0gQ==
X-Gm-Message-State: AOAM530JmJ2KwKbG/+DLpgJ+shfOilNIHC5pQ6XSxeVjEJG9B2nnOU8o
        xmQ9vIvSZMrlYsfTNqmfUG0=
X-Google-Smtp-Source: ABdhPJxXZWesmc/DxB+dQsqyC2iaU+1r1JqJUWaJGIKUeBkWu/4ybf2ielgsN6jNAoUK6Tz/UBumNw==
X-Received: by 2002:a17:907:3e9c:: with SMTP id hs28mr15407063ejc.473.1625726126280;
        Wed, 07 Jul 2021 23:35:26 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id u21sm410260eja.59.2021.07.07.23.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 23:35:26 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v9 11/11] io_uring: add support for IORING_OP_LINKAT
Date:   Thu,  8 Jul 2021 13:34:47 +0700
Message-Id: <20210708063447.3556403-12-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210708063447.3556403-1-dkadashev@gmail.com>
References: <20210708063447.3556403-1-dkadashev@gmail.com>
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
index f241348e64f4..b5adfd4f7de6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4358,7 +4358,7 @@ EXPORT_SYMBOL(vfs_link);
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

