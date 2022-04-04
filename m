Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14EA24F20C2
	for <lists+io-uring@lfdr.de>; Tue,  5 Apr 2022 04:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiDEBTC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Apr 2022 21:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiDEBTC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Apr 2022 21:19:02 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D173243176
        for <io-uring@vger.kernel.org>; Mon,  4 Apr 2022 17:32:04 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id q129so11827948oif.4
        for <io-uring@vger.kernel.org>; Mon, 04 Apr 2022 17:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IwUkq5raNlOPSuLRKSySr78Qb1zfYgUHCaNywpiORlE=;
        b=oCbyoBbY+RoESlEhBQfRdtkoELBDB0gST1sbTllNwa4xMA7mQ7MxCzAX9raVuV6EOs
         4Dml1PcdP9jC1n56RoSC7ryr73AoK6yDb8YF1U75oEZ2j2WWG1X/98bYHIHeTKHd81Yf
         dQFyzEMRYOezgHMV2faXaEuf7NDAxVlGHBOK//i16KR+BhCYXBjAYrTPSy3fLpNcQCGi
         Tg4WQZamVIGWo4IyxMFM2GRlQz6TNf22njMs/4WaCGyyGAHTlVHHOEXaneVpSlIT77ce
         D+UDjf2GWnjUtz4h05dd/LZXQcBbgCpji/O40d0w7N+fR/gKdWfb+eQrPbZAPlxvSPMO
         /ahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IwUkq5raNlOPSuLRKSySr78Qb1zfYgUHCaNywpiORlE=;
        b=KDDdOFvY0qEvvPUFo4LWAA7EkoN4sb9Sb9lH8vSgklBiDUQfOFwbrw5ZJibvbnTD+3
         m1OFuk++r3ydLzzwI6mb7/SXiSal3NUWZhC1QXIevx1QuYDHEslaCL0FhVjJzCoWwKP1
         iXftNj1vOJna0tE8KWTemGytPbsPy3VjaJeGJ2XM7/Z6RYQaWMpu7rvFvnggy3cqsD2M
         D86BgXh+DAqiAet7T56KQ+hWRwaQJ7O6xRqHP9FYwlQI7irDUQaz/MjzyeMkbWenQMCb
         L5zqiG7y7fANLpqFWuNVRJ3Q14gSJC2GvmQRDKySsYXZ9ddZYpwRDyeujAu/zc/KxoPf
         nMYw==
X-Gm-Message-State: AOAM5339UJLAprVxy8ZirFnUFcKjzkKuXQ3SSc/EYd/APb7uBIJtpYaE
        aIEi+I8QzWZMJBxchj/bDShibGlxM3VNxg==
X-Google-Smtp-Source: ABdhPJyccH9jWG5wxC2+ha20hLsgEsxWU4rhyF1nNC952UwSpTU4/54rsnwK5HNEjru0h8459zLBtA==
X-Received: by 2002:a17:90a:8e82:b0:1ca:81fb:180d with SMTP id f2-20020a17090a8e8200b001ca81fb180dmr799403pjo.137.1649116598185;
        Mon, 04 Apr 2022 16:56:38 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i7-20020a628707000000b004fa6eb33b02sm13157977pfe.49.2022.04.04.16.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 16:56:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring: propagate issue_flags state down to file assignment
Date:   Mon,  4 Apr 2022 17:56:24 -0600
Message-Id: <20220404235626.374753-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404235626.374753-1-axboe@kernel.dk>
References: <20220404235626.374753-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We'll need this in a future patch, when we could be assigning the file
after the prep stage.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 48 ++++++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 969f65de9972..d9b4b3a71a0f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1184,7 +1184,8 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 				     unsigned nr_args);
 static void io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_ring_ctx *ctx,
-				struct io_kiocb *req, int fd, bool fixed);
+				struct io_kiocb *req, int fd, bool fixed,
+				bool locked);
 static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
@@ -1314,13 +1315,18 @@ static void io_rsrc_refs_refill(struct io_ring_ctx *ctx)
 }
 
 static inline void io_req_set_rsrc_node(struct io_kiocb *req,
-					struct io_ring_ctx *ctx)
+					struct io_ring_ctx *ctx, bool locked)
 {
 	if (!req->fixed_rsrc_refs) {
 		req->fixed_rsrc_refs = &ctx->rsrc_node->refs;
-		ctx->rsrc_cached_refs--;
-		if (unlikely(ctx->rsrc_cached_refs < 0))
-			io_rsrc_refs_refill(ctx);
+
+		if (locked) {
+			ctx->rsrc_cached_refs--;
+			if (unlikely(ctx->rsrc_cached_refs < 0))
+				io_rsrc_refs_refill(ctx);
+		} else {
+			percpu_ref_get(req->fixed_rsrc_refs);
+		}
 	}
 }
 
@@ -3330,7 +3336,8 @@ static int __io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter
 	return 0;
 }
 
-static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
+static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
+			   bool locked)
 {
 	struct io_mapped_ubuf *imu = req->imu;
 	u16 index, buf_index = req->buf_index;
@@ -3340,7 +3347,7 @@ static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 
 		if (unlikely(buf_index >= ctx->nr_user_bufs))
 			return -EFAULT;
-		io_req_set_rsrc_node(req, ctx);
+		io_req_set_rsrc_node(req, ctx, locked);
 		index = array_index_nospec(buf_index, ctx->nr_user_bufs);
 		imu = READ_ONCE(ctx->user_bufs[index]);
 		req->imu = imu;
@@ -3502,7 +3509,8 @@ static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 	ssize_t ret;
 
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
-		ret = io_import_fixed(req, rw, iter);
+		ret = io_import_fixed(req, rw, iter,
+					!(issue_flags & IO_URING_F_UNLOCKED));
 		if (ret)
 			return ERR_PTR(ret);
 		return NULL;
@@ -4395,7 +4403,8 @@ static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 		return -EAGAIN;
 
 	in = io_file_get(req->ctx, req, sp->splice_fd_in,
-				  (sp->flags & SPLICE_F_FD_IN_FIXED));
+				  (sp->flags & SPLICE_F_FD_IN_FIXED),
+				  !(issue_flags & IO_URING_F_UNLOCKED));
 	if (!in) {
 		ret = -EBADF;
 		goto done;
@@ -4435,7 +4444,8 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 		return -EAGAIN;
 
 	in = io_file_get(req->ctx, req, sp->splice_fd_in,
-				  (sp->flags & SPLICE_F_FD_IN_FIXED));
+				  (sp->flags & SPLICE_F_FD_IN_FIXED),
+				  !(issue_flags & IO_URING_F_UNLOCKED));
 	if (!in) {
 		ret = -EBADF;
 		goto done;
@@ -5973,7 +5983,7 @@ static void io_poll_remove_entries(struct io_kiocb *req)
  * either spurious wakeup or multishot CQE is served. 0 when it's done with
  * the request, then the mask is stored in req->result.
  */
-static int io_poll_check_events(struct io_kiocb *req)
+static int io_poll_check_events(struct io_kiocb *req, bool locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_poll_iocb *poll = io_poll_get_single(req);
@@ -6030,7 +6040,7 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	ret = io_poll_check_events(req);
+	ret = io_poll_check_events(req, *locked);
 	if (ret > 0)
 		return;
 
@@ -6055,7 +6065,7 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	ret = io_poll_check_events(req);
+	ret = io_poll_check_events(req, *locked);
 	if (ret > 0)
 		return;
 
@@ -7461,7 +7471,8 @@ static void io_fixed_file_set(struct io_fixed_file *file_slot, struct file *file
 }
 
 static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
-					     struct io_kiocb *req, int fd)
+					     struct io_kiocb *req, int fd,
+					     bool locked)
 {
 	struct file *file;
 	unsigned long file_ptr;
@@ -7474,7 +7485,7 @@ static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
 	file_ptr &= ~FFS_MASK;
 	/* mask in overlapping REQ_F and FFS bits */
 	req->flags |= (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
-	io_req_set_rsrc_node(req, ctx);
+	io_req_set_rsrc_node(req, ctx, locked);
 	return file;
 }
 
@@ -7492,10 +7503,11 @@ static struct file *io_file_get_normal(struct io_ring_ctx *ctx,
 }
 
 static inline struct file *io_file_get(struct io_ring_ctx *ctx,
-				       struct io_kiocb *req, int fd, bool fixed)
+				       struct io_kiocb *req, int fd, bool fixed,
+				       bool locked)
 {
 	if (fixed)
-		return io_file_get_fixed(ctx, req, fd);
+		return io_file_get_fixed(ctx, req, fd, locked);
 	else
 		return io_file_get_normal(ctx, req, fd);
 }
@@ -7750,7 +7762,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		}
 
 		req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
-					(sqe_flags & IOSQE_FIXED_FILE));
+					(sqe_flags & IOSQE_FIXED_FILE), true);
 		if (unlikely(!req->file))
 			return -EBADF;
 	}
-- 
2.35.1

