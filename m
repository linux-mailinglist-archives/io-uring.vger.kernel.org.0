Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3603BD719
	for <lists+io-uring@lfdr.de>; Tue,  6 Jul 2021 14:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241986AbhGFMwU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Jul 2021 08:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241504AbhGFMwE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Jul 2021 08:52:04 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B96C0613DB;
        Tue,  6 Jul 2021 05:49:25 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id r26so20584299lfp.2;
        Tue, 06 Jul 2021 05:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9/0TTPk6QlPnPGwUZocYubZLcVhXXsqyK1OSZQGMszw=;
        b=maAgfnQQhcmybjersNcyDtz5dEf3hwUIni7IiCoOxQALsntxRyzOdaTQ25cDyg0Z0x
         hvIHI1waz0dKchNgPyqiEjVldS/YojMuyPZS7Gwy3xL1M98Pr6pCmHOG9q8YXoVIKlxj
         s5ZipOnwL3/hNr1AN/2WJFe1cY1dpfNkouMCUuMdPY4Ai5Qc/1gWamvRHgxGDKZc5pDj
         CfOJ0hGlYzckrILC977J65CyXBUAorCy0RysSpBPVYA3Hc9v0GGoGS6A7XfBe/X/e23u
         bNujsIdwgycmCIVh/Z176pyzSlgTpTYRSRmnS9iFaCxwZPHOLT/P/kH/Inca98fRET77
         bpzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9/0TTPk6QlPnPGwUZocYubZLcVhXXsqyK1OSZQGMszw=;
        b=irarXY88Wo8XcVDfr9Ihr5zAMWVsh98B6/veuA9kZXwa6+GJJ5I3SVGX8rPJIJ6Wto
         DdrRP+fDee/TS/XrEYwqAjJ4/7U93exjg9eef1YxLhidTmuh/oIbCUnM0Fv/pTT/B4LP
         E5d0GCN7LCXT4HxifNdFzGGip3LDVn4lRWhkT8MwNEw+5+IImabjnuUE/NW0G58a/raC
         HKCci7c9U2OWjZ5Ok8blpwdTIREDHL3xly4Sj9MeD2YVxqao15gcLai5aCAagE6HqQlq
         vBaLBISdw3ktXxUUi63uuU+5NlmJF5uydEQRq1KcNOgm/LWI+Q1wJg0upmi+yyY1l9xC
         mm/Q==
X-Gm-Message-State: AOAM531T9iuYRPQIXVbwz2Qohew0M8Guc5SJ44VhK0SzMfj0NmtoqXkV
        PCJev0MdspUX15AV1dV5KOc=
X-Google-Smtp-Source: ABdhPJwD3UDi088NAuuJeqDuzwEA9UnwEbXwEyOWWMjUmwvtqsM26Y6xx4brIpo9/ONbWss0oQW9bg==
X-Received: by 2002:ac2:54a4:: with SMTP id w4mr5012072lfk.100.1625575763634;
        Tue, 06 Jul 2021 05:49:23 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id r18sm139519ljc.120.2021.07.06.05.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 05:49:23 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v7 03/10] io_uring: add support for IORING_OP_MKDIRAT
Date:   Tue,  6 Jul 2021 19:48:54 +0700
Message-Id: <20210706124901.1360377-4-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706124901.1360377-1-dkadashev@gmail.com>
References: <20210706124901.1360377-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_MKDIRAT behaves like mkdirat(2) and takes the same flags
and arguments.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/io_uring.c                 | 59 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 60 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5b840bb1e8ec..42d54f9bbbb2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -674,6 +674,13 @@ struct io_unlink {
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
@@ -831,6 +838,7 @@ struct io_kiocb {
 		struct io_shutdown	shutdown;
 		struct io_rename	rename;
 		struct io_unlink	unlink;
+		struct io_mkdir		mkdir;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1042,6 +1050,7 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINKAT] = {},
+	[IORING_OP_MKDIRAT] = {},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -3545,6 +3554,48 @@ static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_mkdirat_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_mkdir *mkd = &req->mkdir;
+	const char __user *fname;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->off || sqe->rw_flags || sqe->buf_index)
+		return -EINVAL;
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
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
 static int io_shutdown_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -5953,6 +6004,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_MKDIRAT:
+		return io_mkdirat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6114,6 +6167,9 @@ static void io_clean_op(struct io_kiocb *req)
 		case IORING_OP_UNLINKAT:
 			putname(req->unlink.filename);
 			break;
+		case IORING_OP_MKDIRAT:
+			putname(req->mkdir.filename);
+			break;
 		}
 	}
 	if ((req->flags & REQ_F_POLLED) && req->apoll) {
@@ -6242,6 +6298,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
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
index 79126d5cd289..a926407c230e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -133,6 +133,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_MKDIRAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.30.2

