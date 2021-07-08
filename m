Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125303BF5A5
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 08:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhGHGiI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 02:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbhGHGiF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 02:38:05 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4E8C061574;
        Wed,  7 Jul 2021 23:35:24 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id l2so6929423edt.1;
        Wed, 07 Jul 2021 23:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9/0TTPk6QlPnPGwUZocYubZLcVhXXsqyK1OSZQGMszw=;
        b=pCfOkRHo0Qq9coTSwfnzi5NI71tLqxevuPrmaZCQ8zFdkYX+McOe0hdgEhS+dXY9ne
         Yq6L8G/Z1zsMIDdNHLTMr+VN8oNj+ByR5kSBBE/HEjQX7S99SSBdAa37xAKtd8YQNgtT
         bgl9cEDhuEp8V9add7PnsPXxvLp9TVMCB3VkYNKspS1Aw6WIseAkB2rUiJi1xhlVaq9s
         Q/RrG1j/ufFU4Tgz5lb0X5Cvj53vOsFHABgCTF4VeYsvWopnQL7+NbU3EdObEqjWW2ME
         1KsqDpP4YNwFatX/0ydIKL5+jdWuw/MTOELS56CFPrLxYemXgMplQwEM1XRkaa5forl1
         ZN0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9/0TTPk6QlPnPGwUZocYubZLcVhXXsqyK1OSZQGMszw=;
        b=MtcjpWWtc+mpP2+YLCEWjiSr8lNCJPDyyVyxfX3X8jvFGqMlarLY7idsdmzw0/K9jc
         SDVJhDo1RBr9W1L+z92KWyfMzmH1m3REoNBLnMv4BymrpQmllrE+7A4Bv1ZSEJ38BARx
         QUHoh6JXZddagfzgh7f9L6CldYZw1mLwaiNzQ4zvGsbESo1QJf1hTuf2sj0H447rXuNe
         Ri/eXMBxIO3Xf1mbJpA1Sx3iFL0tbrE4SfUYs05u/zBrvTn5JOD94lc9LYgcryC/Utb8
         NKvDFqEQuKjBxtnKk0RZGGHeGPoPpt4vuZ+cjW/DiXZAqV9IXThknTTV80N7UoRn7Gsd
         THNg==
X-Gm-Message-State: AOAM533jCL/gFRu2DKzw4Z7CRxZhXdZnL0sWvyc7Tnk9hJyqi3wYGs/r
        FGt10LNaOFr0VtKdmWUlZqM=
X-Google-Smtp-Source: ABdhPJw2Q61DmuCUKztHlWGygJftYGW+XirLPSf3xaw9D/Ek4e7Joxhl9Exjt7gcWmcXf8y83Wv+VA==
X-Received: by 2002:a05:6402:1cbc:: with SMTP id cz28mr36681560edb.246.1625726122712;
        Wed, 07 Jul 2021 23:35:22 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id u21sm410260eja.59.2021.07.07.23.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 23:35:22 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v9 09/11] io_uring: add support for IORING_OP_MKDIRAT
Date:   Thu,  8 Jul 2021 13:34:45 +0700
Message-Id: <20210708063447.3556403-10-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210708063447.3556403-1-dkadashev@gmail.com>
References: <20210708063447.3556403-1-dkadashev@gmail.com>
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

