Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D9D3999C1
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhFCFVJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhFCFVJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:21:09 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31273C06174A;
        Wed,  2 Jun 2021 22:19:08 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ci15so7259572ejc.10;
        Wed, 02 Jun 2021 22:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yUMTxJMtrIi0JQV4gg8vuuIPcQQdP8TYlw+/Ck8CwhI=;
        b=hYhtOs8rU5cMJXpwB0wxwH8LCloPTDBA52+e4IfZ9lBr2zqW6g4FqCxt6s3PROntsY
         LezgIfTpKs1jgTS6odMtT9K4VrQZ+VhEa0n3Zkjnm8yVSKmicuBzNePe2ufXAUf/KAqR
         gAYyVy4xUdcDPCL/bbE0azNKW9aA2WPF1eHsdYTaX7B0xo3t7pwbXFESjbMpKFc5CoB0
         VOcquron1DuGOnpkbwavRyipnqXuMuqt/+Gu+/veJ4wsQ5ggpz31YHhUsCGGdKJYH+24
         hIha27LU9vm8m1mIdGTpmr44N5Fke/QksDpMcrtmz5C246CH3D4BXSAbfOYa02PHYWJ1
         R80Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yUMTxJMtrIi0JQV4gg8vuuIPcQQdP8TYlw+/Ck8CwhI=;
        b=aXfF/PfkpBlr0GHKHZHgbtHjD8TRwr1ZDNzDxOLq4TD21Jp4q0ktXlur4MkYABmGiA
         mrqZb1czS77nZ82ut9E8ECzB36DLm70xCNgCUTB2fwv75dfrhhPYY2yYYjgsjzKrV/JC
         pQluoilMStncVawcYHDGKYyN0X7hrNom8hGsVZ1Pn1laTpp6i51awJMVJtVIhJ54Cj3b
         mw2vQU7bK8r9UxZjmOCcxwxf38qBx08cH+gm67BLFXmWxaDJk/y7NkSByABXssZqrlQ7
         csQoP2lMhFckSYebnO8perw3qSqeEl54gnhk6KHXK6hLItt+86rBIVhGSu65DgFufb/i
         LT8w==
X-Gm-Message-State: AOAM5326Rz2ABvqwIzPU3Hy2U186VJcMeOfxxSTybMJVWW6Zi0OjWXaO
        gWery298fsDlrmwCi0BsoxM=
X-Google-Smtp-Source: ABdhPJzRW05EHE7Ovaw8rOwgwu7M+wnkrjtepHKdSiXarQikH2et9C0OaHXwK8XIjemGFKYoBWNYYw==
X-Received: by 2002:a17:906:e10d:: with SMTP id gj13mr20161946ejb.150.1622697546856;
        Wed, 02 Jun 2021 22:19:06 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id f7sm963668ejz.95.2021.06.02.22.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:19:06 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v5 08/10] io_uring: add support for IORING_OP_SYMLINKAT
Date:   Thu,  3 Jun 2021 12:18:34 +0700
Message-Id: <20210603051836.2614535-9-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603051836.2614535-1-dkadashev@gmail.com>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
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
---
 fs/internal.h                 |  1 +
 fs/io_uring.c                 | 64 ++++++++++++++++++++++++++++++++++-
 fs/namei.c                    |  3 +-
 include/uapi/linux/io_uring.h |  1 +
 4 files changed, 66 insertions(+), 3 deletions(-)

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
index 8ab4eb559520..5fdba9b381e5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -672,6 +672,13 @@ struct io_mkdir {
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
@@ -817,6 +824,7 @@ struct io_kiocb {
 		struct io_rename	rename;
 		struct io_unlink	unlink;
 		struct io_mkdir		mkdir;
+		struct io_symlink	symlink;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1030,6 +1038,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINKAT] = {},
 	[IORING_OP_MKDIRAT] = {},
+	[IORING_OP_SYMLINKAT] = {},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -3572,7 +3581,51 @@ static int io_mkdirat(struct io_kiocb *req, int issue_flags)
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
+static int io_symlinkat_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_symlink *sl = &req->symlink;
+	const char __user *oldpath, *newpath;
+
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
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -5985,6 +6038,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_unlinkat_prep(req, sqe);
 	case IORING_OP_MKDIRAT:
 		return io_mkdirat_prep(req, sqe);
+	case IORING_OP_SYMLINKAT:
+		return io_symlinkat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6129,6 +6184,10 @@ static void io_clean_op(struct io_kiocb *req)
 		case IORING_OP_MKDIRAT:
 			putname(req->mkdir.filename);
 			break;
+		case IORING_OP_SYMLINKAT:
+			putname(req->symlink.oldpath);
+			putname(req->symlink.newpath);
+			break;
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
@@ -6258,6 +6317,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
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
index bf9d720d371f..7b8a78d9c947 100644
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

