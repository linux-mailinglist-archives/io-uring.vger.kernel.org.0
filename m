Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 947261A5A6B
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2020 01:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgDKXnQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Apr 2020 19:43:16 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33019 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728337AbgDKXGV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Apr 2020 19:06:21 -0400
Received: by mail-wr1-f66.google.com with SMTP id a25so6323148wrd.0;
        Sat, 11 Apr 2020 16:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UAPPdZgmNKOCKDm/C5wWEA99bGYuEuYYzhgzenpdA08=;
        b=A35hXGIH6duuun1CFP5LbsmnNUMFYmzusYtQ9MwfWVkHV1gvKiMzjPG2tmnL68VnHO
         rpj+TiTa777dj9VDrpVE0m7zGKd76kGaP5EBMJK5r2m6LEiVfGTDZmbs6vhujvmMyWbk
         rfwDN8U5e5wncueBpGX+IgZMfIH5GL33UL0acjdvrNxmH+H6bITfZc9gzDs5GTkwMHXE
         fqmWDOxR3YOk5wohk3SVFglGy6FkIrTUifDk82oFeGNM0bziNV8obb9EzXBufTWOMP5g
         ARtR3gQItQYRI+kFLklNaqVcxBwEYQ71sTQvSxaROsOyA+fiFpGR2NL7hj5HOq3XTY82
         SC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UAPPdZgmNKOCKDm/C5wWEA99bGYuEuYYzhgzenpdA08=;
        b=ho3jAcJJ/BVMtVkecT0ozxlNvj2U1HI+f6lif0DT0ORZlR0DxrDlv5NSeqiCw8rJH2
         0ctB6Dkrw0HuDDRMk/WdQC3uZAha4obpYrzBFcFEhqUzSitZSI2nlQaIOF4BXSsJZx/w
         mu0HNH0M4a2wbZg3t8ws2JB2tD5tyw8eFXzg8wShooMAPtXiPbetzUkve98MrvNK50iC
         lU9YFsUvYq44OmYaoOYm3jOuYUhdLXKwQY1KPt5TI1y7cQIAlaJfkSXAmqG1XdP5yek3
         U91VeKWc3xPqNvDJsUbfl0+abH0jTqZ1dfJy0bmdWMLwhPc3Ot5wrBz+Jtl/a+qMCLoR
         pUSA==
X-Gm-Message-State: AGi0PuZgIAvcPusenJlewel02GjVgipzhtfmDxarXzDQWF09h9dJT9+c
        mqiLGZQbCAQ8eL1L8OOr4D0=
X-Google-Smtp-Source: APiQypIpl6R1I8xZA5yVhJgKZ8/GQTRobKXLBwELJmnjh3MRl2CZa4juQNgDAILFYYF7/V1v8futzg==
X-Received: by 2002:adf:fdc1:: with SMTP id i1mr1666174wrs.158.1586646379981;
        Sat, 11 Apr 2020 16:06:19 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id k133sm8992741wma.0.2020.04.11.16.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2020 16:06:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] io_uring: DRY early submission req fail code
Date:   Sun, 12 Apr 2020 02:05:03 +0300
Message-Id: <4eadf5c0ce4adc93426d84d94e88d12f0f89d60a.1586645520.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1586645520.git.asml.silence@gmail.com>
References: <cover.1586645520.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Having only one place for cleaning up a request after a link assembly/
submission failure will play handy in the future. At least it allows
to remove duplicated cleanup sequence.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 50 +++++++++++++++++++-------------------------------
 1 file changed, 19 insertions(+), 31 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 27868ec328b8..90b806e4022a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5606,7 +5606,7 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
 				IOSQE_BUFFER_SELECT)
 
-static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			  struct io_submit_state *state, struct io_kiocb **link)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5616,24 +5616,18 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	sqe_flags = READ_ONCE(sqe->flags);
 
 	/* enforce forwards compatibility on users */
-	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
-		ret = -EINVAL;
-		goto err_req;
-	}
+	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
+		return -EINVAL;
 
 	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
-	    !io_op_defs[req->opcode].buffer_select) {
-		ret = -EOPNOTSUPP;
-		goto err_req;
-	}
+	    !io_op_defs[req->opcode].buffer_select)
+		return -EOPNOTSUPP;
 
 	id = READ_ONCE(sqe->personality);
 	if (id) {
 		req->work.creds = idr_find(&ctx->personality_idr, id);
-		if (unlikely(!req->work.creds)) {
-			ret = -EINVAL;
-			goto err_req;
-		}
+		if (unlikely(!req->work.creds))
+			return -EINVAL;
 		get_cred(req->work.creds);
 	}
 
@@ -5644,12 +5638,8 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	fd = READ_ONCE(sqe->fd);
 	ret = io_req_set_file(state, req, fd, sqe_flags);
-	if (unlikely(ret)) {
-err_req:
-		io_cqring_add_event(req, ret);
-		io_double_put_req(req);
-		return false;
-	}
+	if (unlikely(ret))
+		return ret;
 
 	/*
 	 * If we already have a head request, queue this one for async
@@ -5672,16 +5662,14 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			head->flags |= REQ_F_IO_DRAIN;
 			ctx->drain_next = 1;
 		}
-		if (io_alloc_async_ctx(req)) {
-			ret = -EAGAIN;
-			goto err_req;
-		}
+		if (io_alloc_async_ctx(req))
+			return -EAGAIN;
 
 		ret = io_req_defer_prep(req, sqe);
 		if (ret) {
 			/* fail even hard links since we don't submit */
 			head->flags |= REQ_F_FAIL_LINK;
-			goto err_req;
+			return ret;
 		}
 		trace_io_uring_link(ctx, req, head);
 		list_add_tail(&req->link_list, &head->link_list);
@@ -5700,10 +5688,9 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			req->flags |= REQ_F_LINK;
 			INIT_LIST_HEAD(&req->link_list);
 
-			if (io_alloc_async_ctx(req)) {
-				ret = -EAGAIN;
-				goto err_req;
-			}
+			if (io_alloc_async_ctx(req))
+				return -EAGAIN;
+
 			ret = io_req_defer_prep(req, sqe);
 			if (ret)
 				req->flags |= REQ_F_FAIL_LINK;
@@ -5713,7 +5700,7 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 	}
 
-	return true;
+	return 0;
 }
 
 /*
@@ -5878,8 +5865,9 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, async);
-		if (!io_submit_sqe(req, sqe, statep, &link))
-			break;
+		err = io_submit_sqe(req, sqe, statep, &link);
+		if (err)
+			goto fail_req;
 	}
 
 	if (unlikely(submitted != nr)) {
-- 
2.24.0

