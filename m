Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A5B3B2D80
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 13:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbhFXLRa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 07:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbhFXLRa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 07:17:30 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED2BC061574;
        Thu, 24 Jun 2021 04:15:10 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id h15so9533744lfv.12;
        Thu, 24 Jun 2021 04:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9qDoYzfl0bIPxzQm1x+MMcHUZDjEANw5MIs77Mv++MA=;
        b=rbnuKqs2nQwSXP6WvLVJhlh6Yqvyv/5ylWQZ20rCOa3mbdvlKtdNwHtr3UDE1oQV+m
         3jO50HkA4jilDzehwFBNAPYysd+L2l+FFZNYJh3jkd3GnARncu3KDVDp2UCHgjH9ClVL
         n6PiAPP7EzmblBxcrJECS+6mLPkBtU1l9hrVIGbLJZszggX/9CZSZNOmhS2P55WasQO4
         C+pGr+0qJL+bOgQYF9lpq0EuaNdfd+FKYrmv0Nz1W5Iel7Aw6o/PZa52ghfCb1wJ+sYR
         ouD1n1QSTCZtNCa9fpYtIk1TC9fM/9T5qEGFMydGfiC1IXA8miFqsWE3iWWbLcblCeO8
         /Xww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9qDoYzfl0bIPxzQm1x+MMcHUZDjEANw5MIs77Mv++MA=;
        b=iFtVZ3s5ymO/En0bn3Z+rfaJaRw04yqyA4/QzJX96zZ6o6c0UhS+nUOHoLfaAIXG+W
         jxuFsvR9XMbdgxpPbo+n8L6/dzbx2hYKuC6/wsRCKC6KIOeqw+mdZPzs0YQfmxliXQ1E
         u8NUNAMLQSzLdmHybxFhMrbiHiW9TB79k6webnUg59zYZpa8MIPXZTZxvPB+4A7KNKMl
         svp4oxmdaYSBcxZ3eLr7Fl9QG5SKWdt3edaNaGAEkOwmcmaqtjQ0sCGe168j8S/HpP4B
         Zew3zgOAg6bH/A5kUgHd/umRgy8iFHa5qCErR6J/sDk33I+wu5nPVr9RC8+RfXGaSVZV
         o1lA==
X-Gm-Message-State: AOAM530EoUyz1mjcktNCLR00lPUQo0DnuafC5nc4BLqfC6KLjMp1ocym
        ynN43dS7FSpYOxyTMpPy7+FeAcR7Xm/pSQ==
X-Google-Smtp-Source: ABdhPJx7z74mo6SGqEyer211Zu/L5FKsM9uCQO9UmW0FaEC6RTROucTFmOyGOJ6pM6mscqodsQS5vA==
X-Received: by 2002:a05:6512:230e:: with SMTP id o14mr3444223lfu.124.1624533308454;
        Thu, 24 Jun 2021 04:15:08 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id q21sm195293lfp.233.2021.06.24.04.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 04:15:08 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v6 2/9] io_uring: add support for IORING_OP_MKDIRAT
Date:   Thu, 24 Jun 2021 18:14:45 +0700
Message-Id: <20210624111452.658342-3-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210624111452.658342-1-dkadashev@gmail.com>
References: <20210624111452.658342-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_MKDIRAT behaves like mkdirat(2) and takes the same flags
and arguments.

Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/io_uring.c                 | 59 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 60 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e7997f9bf879..7aa08ed78452 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -673,6 +673,13 @@ struct io_unlink {
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
@@ -825,6 +832,7 @@ struct io_kiocb {
 		struct io_shutdown	shutdown;
 		struct io_rename	rename;
 		struct io_unlink	unlink;
+		struct io_mkdir		mkdir;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1039,6 +1047,7 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINKAT] = {},
+	[IORING_OP_MKDIRAT] = {},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -3548,6 +3557,48 @@ static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -5956,6 +6007,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_MKDIRAT:
+		return io_mkdirat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6117,6 +6170,9 @@ static void io_clean_op(struct io_kiocb *req)
 		case IORING_OP_UNLINKAT:
 			putname(req->unlink.filename);
 			break;
+		case IORING_OP_MKDIRAT:
+			putname(req->mkdir.filename);
+			break;
 		}
 	}
 	if ((req->flags & REQ_F_POLLED) && req->apoll) {
@@ -6245,6 +6301,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
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
index f1f9ac114b51..49a24a149eeb 100644
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

