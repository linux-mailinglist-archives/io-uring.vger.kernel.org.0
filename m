Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE9E34E0F8
	for <lists+io-uring@lfdr.de>; Tue, 30 Mar 2021 08:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhC3GBR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Mar 2021 02:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhC3GAw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Mar 2021 02:00:52 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1F1C061762;
        Mon, 29 Mar 2021 23:00:51 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id d12so899782lfv.11;
        Mon, 29 Mar 2021 23:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yLK0swGoAGAfWrFvdyaIBTEbLse0KE0XBAgDjxBZppA=;
        b=R6fnDhi+6UM/fZamHcltmjBIsqP4pdQZZvnHqGxOdKjSr9yZ95gmjWbsV01YocnSrv
         HWC/BoY2ZygLo3tfcObOL9vrJFuw+f/gYmjVCPu0t2Zu2nB5VfeNBnJeD3FzcOxjoUuv
         4+KilRtXvS0CWd5mmZDrNkHx+hD3E9A7Ptj52JAX40ITwdgPWkRcyolfsq8IOFIupfTS
         ork+/dkIjJew2duvaWUJeo+wHnWzwdGFaVoxK7+Ez6ZnNd48VVczQnZx1FS2TdNSRY5h
         n/nOwBmg1W129DRdd8C+ZXL5k4tnf8ggOVnbdHactNqeEBMe2+gskSbklAjsnE0O4so7
         E0Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yLK0swGoAGAfWrFvdyaIBTEbLse0KE0XBAgDjxBZppA=;
        b=nD52O5I4joeeo4RIYlZwmVJea3Ph1xf0LRDWck6zTVawBpIPbDpQWijSxQhUGlx/go
         x50sWnoze0+ltbcIDnXqLVrvksdpPrjoO76yrJ6bpI1qY0iDigrqlVfAP+F0AmoJVhTv
         aiqCsS6R+Fv+95CJqIdpm6+RVwklIJryi40B9HiXSNsmqSBgE3N29yVHtlXpNi7Jip2J
         Sk0T8cQ38yH3+yIr6tZJEzULKqYrfNfiXjAo39YRDsZGAN7BZuxJpIuTjod4yPfaCFCN
         qrT2W6Eo1ECIwx+dpIaKfQmsCEqnJVQWaKKM8vv3RQiMXOBj/68TptXudBXGPjiT2jPf
         fsSQ==
X-Gm-Message-State: AOAM531g/AoJjvq6E2HLufFBjEf0Gdu2PqcG4QQDj8BY/2m73PIk4Kl0
        pJv++aMVrJfWt+0Wm9DXt3A=
X-Google-Smtp-Source: ABdhPJwcosGN8xcjtwRUGS7nQZAXNXFXE2RbGvwntJ8stZj1d7Vq+Aqkc31vPdAYoKfo2ZvtQPMYYw==
X-Received: by 2002:a05:6512:6cd:: with SMTP id u13mr18737993lff.326.1617084050511;
        Mon, 29 Mar 2021 23:00:50 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id e6sm2050089lfj.96.2021.03.29.23.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 23:00:50 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v3 2/2] io_uring: add support for IORING_OP_MKDIRAT
Date:   Tue, 30 Mar 2021 12:59:57 +0700
Message-Id: <20210330055957.3684579-3-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330055957.3684579-1-dkadashev@gmail.com>
References: <20210330055957.3684579-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_MKDIRAT behaves like mkdirat(2) and takes the same flags
and arguments.

Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/io_uring.c                 | 55 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 56 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9a1a02fb3c9a..d9c100ed6132 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -663,6 +663,13 @@ struct io_unlink {
 	struct filename			*filename;
 };
 
+struct io_mkdir {
+	struct file			*file;
+	int				dfd;
+	umode_t				mode;
+	struct filename			*filename;
+};
+
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
@@ -803,6 +810,7 @@ struct io_kiocb {
 		struct io_shutdown	shutdown;
 		struct io_rename	rename;
 		struct io_unlink	unlink;
+		struct io_mkdir		mkdir;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1016,6 +1024,7 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINKAT] = {},
+	[IORING_OP_MKDIRAT] = {},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -3523,6 +3532,44 @@ static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_mkdirat_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_mkdir *mkd = &req->mkdir;
+	const char __user *fname;
+
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	mkd->dfd = READ_ONCE(sqe->fd);
+	mkd->mode = READ_ONCE(sqe->len);
+
+	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	mkd->filename = getname(fname);
+	if (IS_ERR(mkd->filename))
+		return PTR_ERR(mkd->filename);
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+static int io_mkdirat(struct io_kiocb *req, int issue_flags)
+{
+	struct io_mkdir *mkd = &req->mkdir;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret = do_mkdirat(mkd->dfd, mkd->filename, mkd->mode);
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
 static int io_shutdown_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -5942,6 +5989,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_MKDIRAT:
+		return io_mkdirat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6083,6 +6132,9 @@ static void io_clean_op(struct io_kiocb *req)
 		case IORING_OP_UNLINKAT:
 			putname(req->unlink.filename);
 			break;
+		case IORING_OP_MKDIRAT:
+			putname(req->mkdir.filename);
+			break;
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
@@ -6198,6 +6250,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_UNLINKAT:
 		ret = io_unlinkat(req, issue_flags);
 		break;
+	case IORING_OP_MKDIRAT:
+		ret = io_mkdirat(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 5beaa6bbc6db..cf26a94ab880 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -137,6 +137,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_MKDIRAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.30.2

