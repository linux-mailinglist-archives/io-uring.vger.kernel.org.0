Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAC454B135
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244453AbiFNMei (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244877AbiFNMe0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:34:26 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A795446673
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:31:05 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id w17so3574055wrg.7
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=62dWMekHuhr5uFwrGJkmLtFH6YzJbWWvh8PXlOiIzdE=;
        b=HIB/T825Z1g8+8Shi0uhyXRzr+e8hseyNEl7uoYbz1k9nwBj9Xjy6Qz3td3w+JAcVz
         jf9Qj5/6pRb+s5EemMSYO3Ro+tE7qbQ2SV6owvfIM3ERAEFCu3P7MNQcp0+aRBEgLbRj
         LO4uSJrHeFTsoxrerz7Kgt0CsqZVAyjajUyx2UzFuiFS0fDkGRInzbydbzsQyBssyu9i
         1holW9bjkt8RvhfqhJCMjvYxthsBzWFcpMkytYfiaFM7xlqSMgBuNoO3AVEqV9tw2gqV
         YMNldpMsGPyfv3BQNfN9HLAcRDy1YkyfLMsxVWcvQ+r1P4c6k4ReT33olsesO0tpAwfQ
         6ROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=62dWMekHuhr5uFwrGJkmLtFH6YzJbWWvh8PXlOiIzdE=;
        b=HJdAY2vNeAOPLEkdRf6mhJHUARh7yQdM20IGOSDUuLgDfU2Oe4A4W14OVQFBMCykaD
         RpUg0G+C2O/0ghiBLt3tfq7aw3KYor0/FkgAlWwnNk8NLP9dYOuJIpswx5eDRw8ry0x4
         jXk1E6i8BhZnlSM+m7TheItxi2yq43q5O7KkWVFW8+3/HbqZ3rom5wYj/qyjNfB6lIdH
         wLYOEeLHmivXU/DjXvpgiilK9F3wPns4uBA1+vPOCPQVdRgZ9XKGN2w3pfvq95JlMEYL
         f3ZYsPPaiqew336xOeZI0LDurp8LAqIU/kfLzKUVdUFHJcnMIeR2Hti1L6XGZmB7iTRk
         FBfQ==
X-Gm-Message-State: AJIora+GzeV0nn70yPdEwLvNqPfSkwNaVf2sP0PDCEXfXWxZXilIJyMP
        jUqeGmOHZ3hyD6syBNQeu4jPpbXeQsnsTA==
X-Google-Smtp-Source: AGRyM1s3j7H2Cl96Pgeg0UEv7DN0FdKnRlcEErbrQ3n6q+FhuHiW6vA+qfd874ZdXehB6q3ZdHKbGQ==
X-Received: by 2002:adf:e10d:0:b0:20c:dc8f:e5a5 with SMTP id t13-20020adfe10d000000b0020cdc8fe5a5mr4736778wrz.265.1655209864981;
        Tue, 14 Jun 2022 05:31:04 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:31:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 24/25] io_uring: propagate locking state to poll cancel
Date:   Tue, 14 Jun 2022 13:30:02 +0100
Message-Id: <19652167659a9e397fecd155ea152713791bd826.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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
index 1ee7bacd447f..14fcd4fd10d9 100644
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
index 2f49d15cfcce..db7357de7f8c 100644
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
index 89000aae65d9..0b3751959e88 100644
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

