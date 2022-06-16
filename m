Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2976754DE21
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 11:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376658AbiFPJXE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 05:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376662AbiFPJXC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 05:23:02 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91531C90A
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:23:00 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id z17so430734wmi.1
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FnpmHNOzLmPzZqlagM4s9zuVri1qJ9NLqujQ99u3Owo=;
        b=XWnFDQU0Gi/azSH6aKGhHo/JPuqEDbU2VLToGd5eFqPHRErjfXajRLLSmigHGyI/CV
         WZ1aJqXnky/ENobi7VxM9zVb+MaUqbWONysHgotL3WX/kfe5vESQ2AJpUm9PWaEh1M/b
         KWvanOI8s7VU7zn/7KWjo4QNVFeLWMjuQ9yWL1PJYkt7HBZSZlhf0Bdl4IB4z4bY5/fi
         vsY91kGVg5hn0Wr8p+NFMM/xsV4WianZcjJHxOelD8OO5Z2OWSezXJaAcIbN7skFhiVm
         Fj5c3/Y8OJQO8oe3bOEtGJz2cpIXzXxLd/YfuGLjdFMNa9gbnl+njUu6M2LUodBBPC7U
         Eo0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FnpmHNOzLmPzZqlagM4s9zuVri1qJ9NLqujQ99u3Owo=;
        b=OaSKRo+fhMueKNEviNoKCOmMDPtLGN1Iqid7FB9MEZzO5zGsej90Bvu6RYWZKgSwRl
         zsaJo3u3FL2R89UWCnJshSgkYb5vbxdbP8c5l8byDreeZl/Ebf5gaEroYT65t+J61zKL
         esDsvcvrFzWmyXc8jhF5bMAeQUWrZXL8+aaekejJ1wjdIxIFz9fuY3B7gL4DrodiNCgk
         vNiH2q2xdqXQg4yJlhevNAje3XH9a1GgB81gX0p44TUs8q7ZTh2tibhXz1rlRIxJ/JzB
         Akml9/R+v0bc9DxcPK7FZtQB37veruQXto2oIE68FhTCiaEXiEj/VSGYR+itonni0HQL
         hjnw==
X-Gm-Message-State: AJIora85lVuQdQJx1Z4wQEHPehbB/sYt17xfnLf1TKfsE4MPAl64XtgZ
        RJBuU6yABGb45yf1C6Ne37jSUsUhC4RVcQ==
X-Google-Smtp-Source: AGRyM1v06kNkBWjrCIbQbTIv2A326E/5I3M2RlnVVJofY4hGOB5l53dCV0kUFjAChJX2X6zU10rfYg==
X-Received: by 2002:a05:600c:3510:b0:39c:7fe7:cbd3 with SMTP id h16-20020a05600c351000b0039c7fe7cbd3mr4037494wmq.191.1655371379275;
        Thu, 16 Jun 2022 02:22:59 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b0039c975aa553sm1695221wmc.25.2022.06.16.02.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 02:22:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v3 15/16] io_uring: propagate locking state to poll cancel
Date:   Thu, 16 Jun 2022 10:22:11 +0100
Message-Id: <b86781d047727c07163443b57551a3fa57c7c5e1.1655371007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655371007.git.asml.silence@gmail.com>
References: <cover.1655371007.git.asml.silence@gmail.com>
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

