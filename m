Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B0D3999C2
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhFCFVy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:21:54 -0400
Received: from mail-ej1-f53.google.com ([209.85.218.53]:43712 "EHLO
        mail-ej1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhFCFVy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:21:54 -0400
Received: by mail-ej1-f53.google.com with SMTP id ci15so7259721ejc.10;
        Wed, 02 Jun 2021 22:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LdPXeisfjR9wg3D/KtinjwWcwB9HMs8tLTITCUSU3Zg=;
        b=SrIDphEHdV5JBR3sOK3zWVtY3Tolq/bnVxbXNB+UQRpJLTRRJMrt0mdhr9UyDnhLTQ
         ggckFa18tY0kixrN0q2pz4EMox3ynN9w0aPTcsebIpmBO/Jsma6h75kHUEBBQG8bxAah
         msHV/7pK4j34lE0sNjiG41Z3z0rBrowuGpZOQghW1cdV45Jko6ohY1Pu+TwdhOSzkJBp
         HzsupU3j/HxT6T7A5xpdMYkobh6MfX8i4m+1jKz/rHvBhU9DEZw8Vvvn+izMa7hoDo72
         jgiV9vvu15pqFKw9/ALy+y5gkflX9o2f9NnAiYJMgJct5ezY9n+asiAh9M7jxSqMFlBc
         LinQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LdPXeisfjR9wg3D/KtinjwWcwB9HMs8tLTITCUSU3Zg=;
        b=lQFpHFr/Ej4r8kttpgF5DAEJxZpMXhRHUESiX8EmC3mC7ou6q+uJu6q2N0kF17U6xE
         FX6naYGGDWtILOmug+bMgy5QdQGSqC1TG561e2Y/B38Ws/yWMZ9Dzhj2RTN7eE2uyjz1
         C7mNhji2aiF2ZU9n9Nc5e6Ex5WsCzNUGmY30tYAt+gHb3WfsRNZRaSmkQCWIAAnex/Gr
         J/TLqFxsxkMwIfTCxGIxC/LPpNNBr2GXp77AZGJVeq68IHBQyCnwMirTxi7rk/4vqFLM
         HmarJMjBmWQogEddc+PdruL0fWhZ3I/MsOQpka2DEHmFYkqNh8pOIfeC202BikW1AEAF
         0/Zw==
X-Gm-Message-State: AOAM5307kh91Tabogl4+HfDEWepWULoeNIBlKX2H7Rzw1l9cyYd4TQnc
        anwtpFUXpz8Oc9OZIo+yTss=
X-Google-Smtp-Source: ABdhPJyAmEdFPt37PH9Ey69Jhrxsm8vO0pOBh4+jKFymc2GGmnHoWTtx+Dr2RgOO7hZ/ny3y3hcgIg==
X-Received: by 2002:a17:906:b855:: with SMTP id ga21mr10513704ejb.550.1622697549921;
        Wed, 02 Jun 2021 22:19:09 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id f7sm963668ejz.95.2021.06.02.22.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:19:09 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v5 10/10] io_uring: add support for IORING_OP_MKNODAT
Date:   Thu,  3 Jun 2021 12:18:36 +0700
Message-Id: <20210603051836.2614535-11-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603051836.2614535-1-dkadashev@gmail.com>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_MKNODAT behaves like mknodat(2) and takes the same flags and
arguments.

Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/internal.h                 |  2 ++
 fs/io_uring.c                 | 56 +++++++++++++++++++++++++++++++++++
 fs/namei.c                    |  2 +-
 include/uapi/linux/io_uring.h |  2 ++
 4 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/fs/internal.h b/fs/internal.h
index 15a7d210cc67..c6fb9974006f 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -81,6 +81,8 @@ int do_mkdirat(int dfd, struct filename *name, umode_t mode);
 int do_symlinkat(struct filename *from, int newdfd, struct filename *to);
 int do_linkat(int olddfd, struct filename *old, int newdfd,
 			struct filename *new, int flags);
+int do_mknodat(int dfd, struct filename *name, umode_t mode,
+		unsigned int dev);
 
 /*
  * namespace.c
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 31e1aa7dd90b..475632374af8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -688,6 +688,14 @@ struct io_hardlink {
 	int				flags;
 };
 
+struct io_mknod {
+	struct file			*file;
+	int				dfd;
+	umode_t				mode;
+	struct filename		*filename;
+	unsigned int		dev;
+};
+
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
@@ -835,6 +843,7 @@ struct io_kiocb {
 		struct io_mkdir		mkdir;
 		struct io_symlink	symlink;
 		struct io_hardlink	hardlink;
+		struct io_mknod		mknod;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1050,6 +1059,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
 	[IORING_OP_LINKAT] = {},
+	[IORING_OP_MKNODAT] = {},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -3687,6 +3697,44 @@ static int io_linkat(struct io_kiocb *req, int issue_flags)
 	io_req_complete(req, ret);
 	return 0;
 }
+static int io_mknodat_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_mknod *mkn = &req->mknod;
+	const char __user *fname;
+
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	mkn->dfd = READ_ONCE(sqe->fd);
+	mkn->mode = READ_ONCE(sqe->len);
+	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	mkn->dev = READ_ONCE(sqe->mknod_dev);
+
+	mkn->filename = getname(fname);
+	if (IS_ERR(mkn->filename))
+		return PTR_ERR(mkn->filename);
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+static int io_mknodat(struct io_kiocb *req, int issue_flags)
+{
+	struct io_mknod *mkn = &req->mknod;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret = do_mknodat(mkn->dfd, mkn->filename, mkn->mode, mkn->dev);
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+}
 
 static int io_shutdown_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
@@ -6100,6 +6148,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_symlinkat_prep(req, sqe);
 	case IORING_OP_LINKAT:
 		return io_linkat_prep(req, sqe);
+	case IORING_OP_MKNODAT:
+		return io_mknodat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6252,6 +6302,9 @@ static void io_clean_op(struct io_kiocb *req)
 			putname(req->hardlink.oldpath);
 			putname(req->hardlink.newpath);
 			break;
+		case IORING_OP_MKNODAT:
+			putname(req->mknod.filename);
+			break;
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
@@ -6387,6 +6440,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_LINKAT:
 		ret = io_linkat(req, issue_flags);
 		break;
+	case IORING_OP_MKNODAT:
+		ret = io_mknodat(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/fs/namei.c b/fs/namei.c
index b85e457c43b7..a4b1848b5dd1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3743,7 +3743,7 @@ static int may_mknod(umode_t mode)
 	}
 }
 
-static int do_mknodat(int dfd, struct filename *name, umode_t mode,
+int do_mknodat(int dfd, struct filename *name, umode_t mode,
 		unsigned int dev)
 {
 	struct user_namespace *mnt_userns;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 510e64a0a9c3..824b37f53a28 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -45,6 +45,7 @@ struct io_uring_sqe {
 		__u32		rename_flags;
 		__u32		unlink_flags;
 		__u32		hardlink_flags;
+		__u32		mknod_dev;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
@@ -141,6 +142,7 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_MKNODAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.30.2

