Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC03537F669
	for <lists+io-uring@lfdr.de>; Thu, 13 May 2021 13:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbhEMLJB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 May 2021 07:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbhEMLIw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 May 2021 07:08:52 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DC3C061574;
        Thu, 13 May 2021 04:07:40 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id w3so39333707ejc.4;
        Thu, 13 May 2021 04:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=997ZGUVR0cKNGhBerayC/Je0jRNZc41f5vDl0HcgNSw=;
        b=T6NvetaB7FqQQpdfUaNBFRLi5HM67s2RXBBEB/eBQS7HBFBcmMQApscnNQQfTCyelm
         6OKow3NZ4aqUW3pHrJtEvZmaBwM7BHZPCSr5q4SiqLAzV2fkktE0pzBXWRAU3h2ZnaqG
         Dua1y4JHKg1EFPg0eLKqErQW2pnNmrMD0k2QztD4aZuQD2sDZwlue9Qu5SLF0+3MRB0s
         yByefmd1LWXqX3wbhf3xffEAU6Z5aw96L1YiFK7DGiLeh/m4wPyHoupexFV3s3wreMKJ
         yuoOfkM73lUPb9NUgplcjwn5rluaTm6gtlbzo8pLAyEX7ouxgYWZ5mjWlACTWNE1mfLA
         Y+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=997ZGUVR0cKNGhBerayC/Je0jRNZc41f5vDl0HcgNSw=;
        b=BcPoXz1UVpeKVVnBC2VmARokN/lR2DI3Fr0EakPM+erKMHwd6aQ427aDRE6WQgXhjg
         mSIeW+aSUbLHKZ26ulVO0mkKoofm2FZAgo2qtZ6L96n/Vpo536Xt4BPr6kYtecA5w+Av
         HQr8sFVSkDA71Wv50DFbX/1vv/Gyd1ka2MvEwDAgDndDyd4XbmDEUnePlFYxlTL5ztqG
         8lY2adcZTGSNMGR+Lkt/ElKVoLI2bEZs0xfHCKtr3CMa4cRfJmP6FilG9qwAL/J8G8Fb
         a7CNdEfhx0Q3QRggrUa3hfJegDqJwiycbaymokqSMhEmgNqD1/evbXTA/0ypfaKJhVqf
         81rQ==
X-Gm-Message-State: AOAM531HqEIKgoSwJw/V+kXPeLFrEO1DINpEwUeBI5GPllDh8iNk3UeQ
        cebQoWRoV7zl0PULGKyDb+wyCbNwCi3skA==
X-Google-Smtp-Source: ABdhPJy0L0twz6FdKY3zWAkg9URtKqGP50QofOm86TyKVLTdF/b9qIuiGa0Q7smvt6QAWd6JVMqsZQ==
X-Received: by 2002:a17:906:91d3:: with SMTP id b19mr43190524ejx.242.1620904059463;
        Thu, 13 May 2021 04:07:39 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id bn7sm1670864ejb.111.2021.05.13.04.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 04:07:39 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v4 2/6] io_uring: add support for IORING_OP_MKDIRAT
Date:   Thu, 13 May 2021 18:06:08 +0700
Message-Id: <20210513110612.688851-3-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210513110612.688851-1-dkadashev@gmail.com>
References: <20210513110612.688851-1-dkadashev@gmail.com>
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
index 9ac5e278a91e..0486ee6f0dd3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -668,6 +668,13 @@ struct io_unlink {
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
@@ -812,6 +819,7 @@ struct io_kiocb {
 		struct io_shutdown	shutdown;
 		struct io_rename	rename;
 		struct io_unlink	unlink;
+		struct io_mkdir		mkdir;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1024,6 +1032,7 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINKAT] = {},
+	[IORING_OP_MKDIRAT] = {},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -3531,6 +3540,44 @@ static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -5939,6 +5986,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_MKDIRAT:
+		return io_mkdirat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6080,6 +6129,9 @@ static void io_clean_op(struct io_kiocb *req)
 		case IORING_OP_UNLINKAT:
 			putname(req->unlink.filename);
 			break;
+		case IORING_OP_MKDIRAT:
+			putname(req->mkdir.filename);
+			break;
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
@@ -6206,6 +6258,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
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
index e1ae46683301..bf9d720d371f 100644
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

