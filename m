Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C85B3B2D91
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 13:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhFXLRq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 07:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhFXLRj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 07:17:39 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490F5C061766;
        Thu, 24 Jun 2021 04:15:19 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id u2so1954361ljo.1;
        Thu, 24 Jun 2021 04:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4vN1HPJGM7EHfZQb4+fkMPYAbTfsiTYN23x5DHBLnOA=;
        b=bMX3s/hKznI0lDavNEMmFSz7rPNjyCWuN5ETD38T9VqtIx4PH/zwieiANp9XVY0cXD
         eNDKIPWNm88Sha53CqnDdtn+MmoT74zFFZ7PjMMGBICwQbLEgl1Pykm3voypN8r5+GUr
         ve26PcTS28NWyAdycXSomf2riTvEHPPE5pD9LVuc+nNf4tGqokllkrgQtVUqWa2aQt0W
         gb99+JqUxsNXdAsKlZfmilEwA++OFVPHYlnB1rFeuLQ52X1YCSkDDqe4cz859GNKA3BA
         6IAtRhOlASjFzKNCPEgfvQTol9hwmfXtE5m6CQ1Iz/sox+oZ4eIHTnP/FWtQoj//fxZd
         fVyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4vN1HPJGM7EHfZQb4+fkMPYAbTfsiTYN23x5DHBLnOA=;
        b=fg+zOxZX6NfdsJtAFBpP3eykhdSyJSmHd7AbmAq+zXW3CN9Pwdt0BmQ6aYfyurNUzC
         wm9SUpO3mxlo7NcHAKkr/kbojKEg4V1nrV+oC5dmGukg6Onk5W0YOtxiwyvQiKEK0BFM
         V6ZFRzKobuQQKpHqjRoj16W3UmzNg7vHfGQeGt24bCignoWqY76H9WG4Mm7hXXo0ohtw
         oQ7yAXExgVSBX4tfWlptsWVGEl7WGkuYnENYvyXa874O20gxRwzckX+53u18p3kZF44X
         Gvg1+TrIODx4yRWI0Qo4McB59Waai9Drmc0F8gm7ivUr+9b1bpTwJEV69YAizWssojmF
         SpFA==
X-Gm-Message-State: AOAM531N/cVebpwL0fQLW6XnQWlrQYS5UzdmD8SsWLNIJr18VLRz7k93
        UDqsHvuKaegMApAI/CnbZeU=
X-Google-Smtp-Source: ABdhPJwU6Kc7FlPT+RzZGMGsoUK2k3f8uwG+CzgTIjEL5eAhIwMyu2+lyHx29HJILTXVLgERfNnqbw==
X-Received: by 2002:a05:651c:546:: with SMTP id q6mr3472438ljp.73.1624533317668;
        Thu, 24 Jun 2021 04:15:17 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id q21sm195293lfp.233.2021.06.24.04.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 04:15:17 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v6 9/9] io_uring: add support for IORING_OP_LINKAT
Date:   Thu, 24 Jun 2021 18:14:52 +0700
Message-Id: <20210624111452.658342-10-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210624111452.658342-1-dkadashev@gmail.com>
References: <20210624111452.658342-1-dkadashev@gmail.com>
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
index c161f06a3cea..14a90e4e4149 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -687,6 +687,15 @@ struct io_symlink {
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
@@ -841,6 +850,7 @@ struct io_kiocb {
 		struct io_unlink	unlink;
 		struct io_mkdir		mkdir;
 		struct io_symlink	symlink;
+		struct io_hardlink	hardlink;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1057,6 +1067,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_UNLINKAT] = {},
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
+	[IORING_OP_LINKAT] = {},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -3656,6 +3667,57 @@ static int io_symlinkat(struct io_kiocb *req, int issue_flags)
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
@@ -6068,6 +6130,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_mkdirat_prep(req, sqe);
 	case IORING_OP_SYMLINKAT:
 		return io_symlinkat_prep(req, sqe);
+	case IORING_OP_LINKAT:
+		return io_linkat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6236,6 +6300,10 @@ static void io_clean_op(struct io_kiocb *req)
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
@@ -6370,6 +6438,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
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
index 796f37ab4ce3..c735fc22e459 100644
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

