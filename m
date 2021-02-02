Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B66630B9D3
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 09:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhBBI0u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 03:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbhBBIZw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 03:25:52 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0E0C061756;
        Tue,  2 Feb 2021 00:25:11 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id e15so6536736lft.13;
        Tue, 02 Feb 2021 00:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lUIoGP9jLQt3z5mlIPKkW70jR6dtNyFuNILhEt6IBME=;
        b=px+50jpSNabGYTenirBJjgo6ApX3mwYvM0Zxs1BxBlK9CCklgURyKo+wXTbpRMvg29
         oC83En//fSqGNI4adq6GBS3bGnnm3erSVx3RC0SrOxKuoZRWnbF+lSAIN5C87Xhjefnp
         KbEYRLlKcQMvwMjxAsiSoC4yrVnTupp6X+DLN3NpVLGZLayDNHbXDG3VWc2EwiLI1rDY
         1nIKaEmDqFweUjRm0U9rq6tLk1VL+KqRJBcywiNd5vf0gcMbJORHJ9CIeSH5/Qy7+Gv7
         Er+FwdBj3DeOeJFHrhUEAL3ArLBGHfKL6HS8+vbCuptriE/bccJZoPpjP/+3VzhVrnbw
         D4Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lUIoGP9jLQt3z5mlIPKkW70jR6dtNyFuNILhEt6IBME=;
        b=n4edmlEb7qSXkJevOFPrs91H4+kTtqDTCe3qdQmgnCTuKIOkS4hPj0hgDHcfbrOdOW
         p/B2A4yrCQBm4HShNbfvzJ6RYIOXOJ5HTB9Q5DiEiPz+V6x5HPhVMRmuh6Y70fD9UKx1
         C+CyWfF+sY/xeAHKPGTNoaV4aoff3cnxUUmCyEPMA9lUeUdP25dCQG1q8gefXO1ICGQB
         H/Q44iHX4Cuug4gFsudfRIgNVVfkkDYrW9xel9W19kS2IFn5XNRlLnmMKczJPwp1wsRt
         hgSudbqeh7x7qCNtrqw44Appa30uCc72oYPy1qKzveUWfsYl2dqisAcRKil1fFH9+ZD6
         gnTA==
X-Gm-Message-State: AOAM531DnNUgX2OZAN5mBTwnNIjxeq3ddVeR23KueNQ7uWiFY48O+el6
        R+W71LcqfFwhQvpGid2REVo=
X-Google-Smtp-Source: ABdhPJzms4LUpbOZ+qN7ZAaMBArII0vwX54EWvj4jPGaa94C0/jOL4S5K47+bSoJKMoITNU3pai4aA==
X-Received: by 2002:a05:6512:b18:: with SMTP id w24mr9807267lfu.131.1612254310172;
        Tue, 02 Feb 2021 00:25:10 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id t6sm4195857ljd.112.2021.02.02.00.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 00:25:09 -0800 (PST)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 2/2] io_uring: add support for IORING_OP_MKDIRAT
Date:   Tue,  2 Feb 2021 15:23:53 +0700
Message-Id: <20210202082353.2152271-3-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202082353.2152271-1-dkadashev@gmail.com>
References: <20210202082353.2152271-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_MKDIRAT behaves like mkdirat(2) and takes the same flags
and arguments.

Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/io_uring.c                 | 58 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 59 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 24ad36d71289..000d7dce5902 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -582,6 +582,13 @@ struct io_unlink {
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
@@ -712,6 +719,7 @@ struct io_kiocb {
 		struct io_shutdown	shutdown;
 		struct io_rename	rename;
 		struct io_unlink	unlink;
+		struct io_mkdir		mkdir;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -996,6 +1004,10 @@ static const struct io_op_def io_op_defs[] = {
 		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
 						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
 	},
+	[IORING_OP_MKDIRAT] = {
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
+						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
+	},
 };
 
 enum io_mem_account {
@@ -3805,6 +3817,44 @@ static int io_unlinkat(struct io_kiocb *req, bool force_nonblock)
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
+static int io_mkdirat(struct io_kiocb *req, bool force_nonblock)
+{
+	struct io_mkdir *mkd = &req->mkdir;
+	int ret;
+
+	if (force_nonblock)
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
@@ -6101,6 +6151,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_MKDIRAT:
+		return io_mkdirat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6228,6 +6280,9 @@ static void __io_clean_op(struct io_kiocb *req)
 		case IORING_OP_UNLINKAT:
 			putname(req->unlink.filename);
 			break;
+		case IORING_OP_MKDIRAT:
+			putname(req->mkdir.filename);
+			break;
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
@@ -6340,6 +6395,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	case IORING_OP_UNLINKAT:
 		ret = io_unlinkat(req, force_nonblock);
 		break;
+	case IORING_OP_MKDIRAT:
+		ret = io_mkdirat(req, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ac4e1738a9af..890edd850a9e 100644
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
2.30.0

