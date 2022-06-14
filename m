Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881D854B381
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237979AbiFNOim (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348963AbiFNOiM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:38:12 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997002253A
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:38:09 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id k19so11560954wrd.8
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FnpmHNOzLmPzZqlagM4s9zuVri1qJ9NLqujQ99u3Owo=;
        b=PuFylavCOt+W/9Uo29+Z271fp2DAP5jMsIFFk7EP941Hx34YHthhJAjU2Pzr2z/Ypr
         yVcuegLDk4kI6f3JSraG87MLjZfM3L88WQG7vdb+Z5ViqG5SfxsHcSL2hOq8CV1Q+huz
         K7Caz6gmtVqHOBnhUC/MftMmUmgBgU4MCbYNr9g8ofLwLcJ/M5RD7GofiZ9A2kvcDqQH
         hfzqjn7k7xLav2Ono4Sz0B9vJcbhDmp9RvqqTxNj2iiDbnKg/ln03aRw1hm4L3o4viHr
         CriZTcFbbb1Bgao6g+Uz0/0j1SwS33JLbEbAIt591gvI8epLs+8aJ0qGEbq2LM+YNukW
         bxEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FnpmHNOzLmPzZqlagM4s9zuVri1qJ9NLqujQ99u3Owo=;
        b=E+nUyfKAsY/szR0yvy2OhpPUTXQgG9+kgGeQqcYpUn5nWLGtc8fjxT4nTfLIUcbds9
         r4TfTVOU/Sb6QkYViTGvaa40+ffeqi8MJl9TUeljZden9EeZPRlJt/nhzg+fFGxl6m+I
         CpHOucmKaaKnFsxvkqrCjgVwMTctLTWRpXB5zKf9M2SuEcHOuYAkS7jYEexxlyblnI0d
         wb7Ar5YZmRYASe/aUH6MN3EuE2Ej+UM7dge3N2CrAGEhUVG5IG+lEKWiBYqv1pOzyiWU
         ktKPQVC9D2GWP4j2o4eRkblOs8xiBKbsNIKmFhlzHw9NUamziA4j3zGLY26UKj6dY6AT
         PWgw==
X-Gm-Message-State: AJIora9fG3mDgD9UA/naICyfWNm/8riavwYn8T73+b4cgvUVCRghqZB0
        KnEAuuRz+VuqY0FndpVrPbDpYL9TTcgTPw==
X-Google-Smtp-Source: AGRyM1vWMZVd2gRiS5wVVoCqpGNpUBRaY9oZatCpWctQUkmhe2zLkBb44O+s7dkXFZH7WrSOHHmqow==
X-Received: by 2002:a5d:4d8f:0:b0:210:3e14:ff27 with SMTP id b15-20020a5d4d8f000000b002103e14ff27mr5080991wru.81.1655217487802;
        Tue, 14 Jun 2022 07:38:07 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:38:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 24/25] io_uring: propagate locking state to poll cancel
Date:   Tue, 14 Jun 2022 15:37:14 +0100
Message-Id: <ea64457d5d745096c0038f4f29d6b0e8518d0d0b.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Poll cancellation will be soon need to grab ->uring_lock inside, pass
the locking state, i.e. issue_flags, inside the cancellation functions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/cancel.c  | 7 ++++---
 io_uring/cancel.h  | 3 ++-
 io_uring/poll.c    | 3 ++-
 io_uring/poll.h    | 3 ++-
 io_uring/timeout.c | 3 ++-
 5 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index f28f0a7d1272..f07bfd27c98a 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -78,7 +78,8 @@ static int io_async_cancel_one(struct io_uring_task *tctx,
 	return ret;
 }
 
-int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
+int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd,
+		  unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -93,7 +94,7 @@ int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
 	if (!ret)
 		return 0;
 
-	ret = io_poll_cancel(ctx, cd);
+	ret = io_poll_cancel(ctx, cd, issue_flags);
 	if (ret != -ENOENT)
 		return ret;
 
@@ -136,7 +137,7 @@ static int __io_async_cancel(struct io_cancel_data *cd, struct io_kiocb *req,
 	int ret, nr = 0;
 
 	do {
-		ret = io_try_cancel(req, cd);
+		ret = io_try_cancel(req, cd, issue_flags);
 		if (ret == -ENOENT)
 			break;
 		if (!all)
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index fd4cb1a2595d..8dd259dc383e 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -3,5 +3,6 @@
 int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
 
-int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd);
+int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd,
+		  unsigned int issue_flags);
 void init_hash_table(struct io_hash_table *table, unsigned size);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 9c7793f5e93b..07157da1c2cb 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -643,7 +643,8 @@ static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 	return req ? 0 : -ENOENT;
 }
 
-int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
+int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
+		   unsigned issue_flags)
 {
 	return __io_poll_cancel(ctx, cd, &ctx->cancel_table);
 }
diff --git a/io_uring/poll.h b/io_uring/poll.h
index cc75c1567a84..fa3e19790281 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -24,7 +24,8 @@ int io_poll_add(struct io_kiocb *req, unsigned int issue_flags);
 int io_poll_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags);
 
-int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd);
+int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
+		   unsigned issue_flags);
 int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags);
 bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 			bool cancel_all);
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 69cca42d6835..526fc8b2e3b6 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -262,6 +262,7 @@ int io_timeout_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 
 static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 {
+	unsigned issue_flags = *locked ? 0 : IO_URING_F_UNLOCKED;
 	struct io_timeout *timeout = io_kiocb_to_cmd(req);
 	struct io_kiocb *prev = timeout->prev;
 	int ret = -ENOENT;
@@ -273,7 +274,7 @@ static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 				.data		= prev->cqe.user_data,
 			};
 
-			ret = io_try_cancel(req, &cd);
+			ret = io_try_cancel(req, &cd, issue_flags);
 		}
 		io_req_set_res(req, ret ?: -ETIME, 0);
 		io_req_complete_post(req);
-- 
2.36.1

