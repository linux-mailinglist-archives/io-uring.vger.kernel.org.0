Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46CF3BE7EE
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 14:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhGGMbA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 08:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbhGGMa6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 08:30:58 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38702C061574;
        Wed,  7 Jul 2021 05:28:18 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id hc16so2942311ejc.12;
        Wed, 07 Jul 2021 05:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gYlonjHEqq+ciO9uXQTdjBC9hqLlNtpIxlPjlB/koR0=;
        b=YROoudLM21q5MuNyCiUuu5tCfzZ8g0aDJXjG9WJL+c0Qee6Rm+Q7JrQ7CPuhK2wWRi
         kNVEvJgpL1sNK8OS4LnDfIkL5AdT18NNpBoIVUKiUewvjKe8xaerAj9xZEy+fO81PRke
         /T5vZG9phZDg2xxgvWYSJRUyAzBQ1dmfqgTpU1ihkoJ/eoMggfgzOZgN3iGIXxH71jgk
         c6jmy/kygu56LW86S2rD5r711pYcklAFBUes2nWGbNLWcC8Dkr5MOxmWV/tIOZl2iwv7
         UqOc9ZE/3dhV1cW9C37GJe9+wZQRmbX3BQKhJPLc/j16MvqdjKVS/R3yMJAtAoDwqYQW
         gbUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gYlonjHEqq+ciO9uXQTdjBC9hqLlNtpIxlPjlB/koR0=;
        b=emrFOey9ds5xAZ6E03jXWDH77le2wqQlIfPPoI1Dozdjt1D1fy4OaTvOvom8jh4UFT
         6ldI8c7iVhx/CLiDOHxyOW5FVVQH2QN/1uPy2QRwyMwS+zymngc/IzF403G7ryQm1oMb
         COgPaWRI57zur+E3SkvO2ze7AJCFWNZX3BkguXClUl8MhOjbn6WvuSSiUPt/jtZDtIL+
         aBJiLds5aEkSSbtCbnpFz9vwfcTh/wXAsOSMHTFchqXrcswkb8xqcypHbIy2SXrcEaxb
         P77ST+JluzhpFWN82jck8Gs0PTlONoZE5zGqWcW3/vytJ8B5xc549XWqX8tdcp4u4JwT
         o+3A==
X-Gm-Message-State: AOAM5324Q7kxy4rdAtzqy8+Ts1hlITdJ4W522OvwDW7Mha/k94mc61Zc
        NXkKFNBQIvR3ow5GUzHUTNk=
X-Google-Smtp-Source: ABdhPJzBeGM6H5FI9aSMOoxBk7ae3kyJriE7AyjlYO2b+N2WL+2Ac6H+PxzVSaCqjvWmttQQmf/RUg==
X-Received: by 2002:a17:906:3a53:: with SMTP id a19mr23855526ejf.88.1625660896865;
        Wed, 07 Jul 2021 05:28:16 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id ze15sm7019821ejb.79.2021.07.07.05.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 05:28:16 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v8 11/11] io_uring: add support for IORING_OP_LINKAT
Date:   Wed,  7 Jul 2021 19:27:47 +0700
Message-Id: <20210707122747.3292388-12-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210707122747.3292388-1-dkadashev@gmail.com>
References: <20210707122747.3292388-1-dkadashev@gmail.com>
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

