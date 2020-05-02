Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD451C2514
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2020 14:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgEBMKm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 May 2020 08:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727951AbgEBMKm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 May 2020 08:10:42 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9189C061A0C;
        Sat,  2 May 2020 05:10:41 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e26so2912613wmk.5;
        Sat, 02 May 2020 05:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KpfvJecLL3a77wRaEiE1iD1YWA6MRqbUFAwQ0V5rD8U=;
        b=r+QdoZKQ3oV2+/dqyF9Q3ZPu7/x2VEIRUn2uWg0aEpfVMc975LtdWxKusSEWm+zFnh
         3MJdfLLu/K/AhjZBr9w4ynM5LF3mQFxi/+qWORR/+IZQ5CdYgzzYXWzuKRFYTnkolhY/
         DAfrnxESyd3hdYujeJEifJvIjQZE+BUemuu1HJXKKDhJRmQDT8cjA4+n4aXDBJCm0lxz
         Vm0k8dI9R0hNt91uBMnuyf7ked/Q1SEz/n2Uf72fJa6YYdw5zSpPKy6yXzU7euytKnLN
         FEjCPXW+RQx8X2vTrcxIsmc5dEct+Ks+09BkPWWaSCfrKZ3SQCHUTyFx0ksgVdids4XY
         uvOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KpfvJecLL3a77wRaEiE1iD1YWA6MRqbUFAwQ0V5rD8U=;
        b=FDhzR692EHcOqnUDUXmhwR+vFdz4U7mvHa3fpD8tCcOnU4DVnqSDYZDyFFxJ/XMHyJ
         EmFKkBTTBNBb/3meSIB+tDyw8Sp02bxLD9zUuEFGNNip6WsoAHvsEtHVgSJoHqP3gbDW
         bXniBZj/AhQUP1F0qRRP3Ynowfa5ST0mQsA+eiJN5ZC9PXzsm3pTklcteOfo0EvbM3V7
         yyZvAYYirf7f7fU/DkP+5l67+e+fTfpmrXX+HhjssmZGbOtTWIi3IGiAUcyfQ3lMk7o6
         qq7Jf5N8PrgQAUN1JZi20fImCUUBhPUXQNNumc3lhSrc1RftWgHdTtV9zi8sWAdoXn2L
         +iiQ==
X-Gm-Message-State: AGi0PuYUnXWWBDlGPd4ZuGV1gJtvyOqW3tPOhXYtW2YjX3Ninxlj5vio
        PIVaVak24Qd/YPd3Or5Vffk=
X-Google-Smtp-Source: APiQypLiYFkxgSfD8yXv1FY3q2MHs/3gjyCgFdoNZjDplObNqqNEJw95OsTWpXJWZc4pgGxlvVtfTQ==
X-Received: by 2002:a1c:1c8:: with SMTP id 191mr4178633wmb.37.1588421440464;
        Sat, 02 May 2020 05:10:40 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id m15sm3858297wmc.35.2020.05.02.05.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 05:10:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Clay Harris <bugs@claycon.org>
Subject: [PATCH 2/2] io_uring: add tee(2) support
Date:   Sat,  2 May 2020 15:09:26 +0300
Message-Id: <ea033201ae4e8359420ab1b50bce95ed47c8cd90.1588421219.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1588421219.git.asml.silence@gmail.com>
References: <cover.1588421219.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add IORING_OP_TEE implementing tee(2) support. Almost identical to
splice bits, but without offsets.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 64 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4ed82d39540b..dc314f66fbc9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -855,6 +855,11 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_PROVIDE_BUFFERS] = {},
 	[IORING_OP_REMOVE_BUFFERS] = {},
+	[IORING_OP_TEE] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -2754,7 +2759,8 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 	return ret;
 }
 
-static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int __io_splice_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
 {
 	struct io_splice* sp = &req->splice;
 	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL;
@@ -2764,8 +2770,6 @@ static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return 0;
 
 	sp->file_in = NULL;
-	sp->off_in = READ_ONCE(sqe->splice_off_in);
-	sp->off_out = READ_ONCE(sqe->off);
 	sp->len = READ_ONCE(sqe->len);
 	sp->flags = READ_ONCE(sqe->splice_flags);
 
@@ -2784,6 +2788,48 @@ static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+static int io_tee_prep(struct io_kiocb *req,
+		       const struct io_uring_sqe *sqe)
+{
+	if (READ_ONCE(sqe->splice_off_in) || READ_ONCE(sqe->off))
+		return -EINVAL;
+	return __io_splice_prep(req, sqe);
+}
+
+static int io_tee(struct io_kiocb *req, bool force_nonblock)
+{
+	struct io_splice *sp = &req->splice;
+	struct file *in = sp->file_in;
+	struct file *out = sp->file_out;
+	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
+	long ret;
+
+	if (force_nonblock)
+		return -EAGAIN;
+
+	ret = do_tee(in, out, sp->len, flags);
+	if (force_nonblock && ret == -EAGAIN)
+		return -EAGAIN;
+
+	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+
+	io_cqring_add_event(req, ret);
+	if (ret != sp->len)
+		req_set_fail_links(req);
+	io_put_req(req);
+	return 0;
+}
+
+static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_splice* sp = &req->splice;
+
+	sp->off_in = READ_ONCE(sqe->splice_off_in);
+	sp->off_out = READ_ONCE(sqe->off);
+	return __io_splice_prep(req, sqe);
+}
+
 static int io_splice(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_splice *sp = &req->splice;
@@ -4978,6 +5024,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_REMOVE_BUFFERS:
 		ret = io_remove_buffers_prep(req, sqe);
 		break;
+	case IORING_OP_TEE:
+		ret = io_tee_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -5051,6 +5100,7 @@ static void io_cleanup_req(struct io_kiocb *req)
 		putname(req->open.filename);
 		break;
 	case IORING_OP_SPLICE:
+	case IORING_OP_TEE:
 		io_put_file(req, req->splice.file_in,
 			    (req->splice.flags & SPLICE_F_FD_IN_FIXED));
 		break;
@@ -5281,6 +5331,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_remove_buffers(req, force_nonblock);
 		break;
+	case IORING_OP_TEE:
+		if (sqe) {
+			ret = io_tee_prep(req, sqe);
+			if (ret < 0)
+				break;
+		}
+		ret = io_tee(req, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e48d746b8e2a..a279151437fc 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -129,6 +129,7 @@ enum {
 	IORING_OP_SPLICE,
 	IORING_OP_PROVIDE_BUFFERS,
 	IORING_OP_REMOVE_BUFFERS,
+	IORING_OP_TEE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.0

