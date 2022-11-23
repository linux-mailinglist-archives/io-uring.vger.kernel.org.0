Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CBE635BDF
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237499AbiKWLfZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236402AbiKWLfI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:35:08 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDCEE0A
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:07 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id i64-20020a1c3b43000000b003d016c21100so1204688wma.3
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GPobMHqO/KcnKYrLjIDJGleMQe2iQ6KyZgXk4HC1KKQ=;
        b=n+7JFFMv8/qzP772rFSXFBfTy9KwQEAcaULRTs6pq+YJlNI9z1F9x7IYN1fdn2ltK7
         RbPJ0NyyCQlMzEFS/kWAQjJXDq1qPJ7+awzSDdmPHmXHzBszOAyEFMox8a62qwqvaJvJ
         XgT12VH6sG8fD00i8Vj0EQ0E16q/VTc8k3rz8rXKy/zaqwNb2LmkEUDxYQW9b7O6fWuv
         zR7w2ZJtsLbHMd2+gwDlcYPZWbUw6jyIxXzetgaNipG5y4q8lOMVx53VEs9h96sdysIz
         QcMS/tZA/S4mR+WxW1CsfM6qpfdKm6qVc1iQpguAZZBjwVS17S7HWkAQWapMgznIl/la
         sLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GPobMHqO/KcnKYrLjIDJGleMQe2iQ6KyZgXk4HC1KKQ=;
        b=sqsfvZfVedOFiK2M0IpLq6inXr7h/2dFQD6kycj5QVI0GGxxJvwh5v4PS7lPSE1NHK
         wxeXYjH1ij+3A8MYahdSECxKHOk2Vj9GR2xpmGa0GQevcOYI35y9cIyXf0zXJsYCEZHj
         FL1QTLtsQeT94lTMOyiLIu0/ZCjPD6IvKFc6xHCMaNcO23KlW2z84r3Z41ur1Xh5O7r7
         KjRT085akYfEV9XQxi6Gl4LWVOpANOJY+DPEUAq2u0E047C2AUN19KYV+y0CQ47/uVE+
         S2ObArReowso8Xwn68BhJKPH7UfqAee5DIJwcyFXQNdVRi5tpY4Be0QDfYSHPljFvMFo
         9TKg==
X-Gm-Message-State: ANoB5pkCKfpC+GPDNJ2+lwe/MeQMfL+Wqs78IZZ1FsHh7hGvQdKTtTB+
        0jxeWsV0yhQ5fSoW1TrJ3Gr7PqFaey4=
X-Google-Smtp-Source: AA0mqf4MF1exsB3Jy8jCH9/34koXVT1hUDucE6YJAPO9bK/esodUA/2URdMkrXvCsM1V29Q577GgRw==
X-Received: by 2002:a1c:ed04:0:b0:3cf:d08d:3eb2 with SMTP id l4-20020a1ced04000000b003cfd08d3eb2mr19986814wmh.129.1669203305882;
        Wed, 23 Nov 2022 03:35:05 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e1b])
        by smtp.gmail.com with ESMTPSA id g9-20020a05600c4ec900b003cfd58409desm2262064wmq.13.2022.11.23.03.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 03:35:05 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 6/7] io_uring: iopoll protect complete_post
Date:   Wed, 23 Nov 2022 11:33:41 +0000
Message-Id: <cc6d854065c57c838ca8e8806f707a226b70fd2d.1669203009.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669203009.git.asml.silence@gmail.com>
References: <cover.1669203009.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_complete_post() may be used by iopoll enabled rings, grab locks
in this case. That requires to pass issue_flags to propagate the locking
state.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c  | 21 +++++++++++++++------
 io_uring/io_uring.h  | 10 ++++++++--
 io_uring/kbuf.c      |  4 ++--
 io_uring/poll.c      |  2 +-
 io_uring/uring_cmd.c |  2 +-
 5 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bd9b286eb031..54a9966bbb47 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -813,7 +813,7 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx,
 	return filled;
 }
 
-void io_req_complete_post(struct io_kiocb *req)
+static void __io_req_complete_post(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -849,9 +849,18 @@ void io_req_complete_post(struct io_kiocb *req)
 	io_cq_unlock_post(ctx);
 }
 
-inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags)
+void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
-	io_req_complete_post(req);
+	if (!(issue_flags & IO_URING_F_UNLOCKED) ||
+	    !(req->ctx->flags & IORING_SETUP_IOPOLL)) {
+		__io_req_complete_post(req);
+	} else {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		mutex_lock(&ctx->uring_lock);
+		__io_req_complete_post(req);
+		mutex_unlock(&ctx->uring_lock);
+	}
 }
 
 void io_req_complete_failed(struct io_kiocb *req, s32 res)
@@ -865,7 +874,7 @@ void io_req_complete_failed(struct io_kiocb *req, s32 res)
 	io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
 	if (def->fail)
 		def->fail(req);
-	io_req_complete_post(req);
+	io_req_complete_post(req, 0);
 }
 
 /*
@@ -1449,7 +1458,7 @@ void io_req_task_complete(struct io_kiocb *req, bool *locked)
 	if (*locked)
 		io_req_complete_defer(req);
 	else
-		io_req_complete_post(req);
+		io_req_complete_post_tw(req, locked);
 }
 
 /*
@@ -1717,7 +1726,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 			io_req_complete_defer(req);
 		else
-			io_req_complete_post(req);
+			io_req_complete_post(req, issue_flags);
 	} else if (ret != IOU_ISSUE_SKIP_COMPLETE)
 		return ret;
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 002b6cc842a5..e908966f081a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -30,12 +30,18 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx);
 int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked);
 int io_run_local_work(struct io_ring_ctx *ctx);
 void io_req_complete_failed(struct io_kiocb *req, s32 res);
-void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
-void io_req_complete_post(struct io_kiocb *req);
+void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
+static inline void io_req_complete_post_tw(struct io_kiocb *req, bool *locked)
+{
+	unsigned flags = *locked ? 0 : IO_URING_F_UNLOCKED;
+
+	io_req_complete_post(req, flags);
+}
+
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
 
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 25cd724ade18..c33b53b7f435 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -311,7 +311,7 @@ int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	/* complete before unlock, IOPOLL may need the lock */
 	io_req_set_res(req, ret, 0);
-	__io_req_complete(req, issue_flags);
+	io_req_complete_post(req, 0);
 	io_ring_submit_unlock(ctx, issue_flags);
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
@@ -460,7 +460,7 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	/* complete before unlock, IOPOLL may need the lock */
 	io_req_set_res(req, ret, 0);
-	__io_req_complete(req, issue_flags);
+	io_req_complete_post(req, 0);
 	io_ring_submit_unlock(ctx, issue_flags);
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 2830b7daf952..583fc0d745a6 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -298,7 +298,7 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 	io_poll_tw_hash_eject(req, locked);
 
 	if (ret == IOU_POLL_REMOVE_POLL_USE_RES)
-		io_req_complete_post(req);
+		io_req_complete_post_tw(req, locked);
 	else if (ret == IOU_POLL_DONE)
 		io_req_task_submit(req, locked);
 	else
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index e50de0b6b9f8..446a189b78b0 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -56,7 +56,7 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
 		smp_store_release(&req->iopoll_completed, 1);
 	else
-		__io_req_complete(req, 0);
+		io_req_complete_post(req, 0);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
-- 
2.38.1

