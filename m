Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCDD65B98B
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 04:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbjACDF1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 22:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236572AbjACDFY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 22:05:24 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADCCB7F8
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 19:05:23 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id z8-20020a05600c220800b003d33b0bda11so15897308wml.0
        for <io-uring@vger.kernel.org>; Mon, 02 Jan 2023 19:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dKZTw9ynuvwT3BWG3xafuTprhv2oUDeCYdXR4dPur1U=;
        b=T76KYE5D2srVZxZ4dqgcU1yjFSxOtZb4TabU7uTAgZxEykx6FG0YBdxK5Uvodyzc3e
         2QGejU1hg91WqfK1HzwhMN8p5656VRhHq+So/DvEXzCee6w89yXqMo+jjVPXrMJnB4Lp
         WvJfwY5/7ON7l/7rxPIPc6OezaALb/fn7hajJoHe5D6rT/mZWL0UKH4zBwG+2jWKyqxr
         flKJYrQRLZHZlVS8Ju//iEsEKibJuLm9RRkcDKeM8UJ/zCjl+irb+yHiWkv9tGoe0MZN
         I/8MaLrL0kmIjRLX8JWSjyrcRnki8S3x3y1yTAzNNwBdB48sXXw4ZvnAcacFp0XIwNjC
         pmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dKZTw9ynuvwT3BWG3xafuTprhv2oUDeCYdXR4dPur1U=;
        b=oe5N8gLOvtWo0PK21O6QBy0Rwp6w9qtXM+hSqB3mazSswI7pkvIheKbcUUGmU5WA9A
         +mxLg122LemN5Xv2I8IDBhEEsrBSG5lm0uJXcoqZQV7534HUGxvcbtlYvAMYnuoyCsf6
         l6qF7iezC1YH6HyjMg0sLlgXflNjL6VXR6NDbOUICBJcdzAZElecB3dYMYZPihuu/wkj
         /IbIaDvdKFhRXHiW+WZPID6QNyZjGeDgAL2E4XPtwZ3oVrFEu8vdeJJJp4dhWD1UTrd1
         13Sr/T1TfFGhNYhzxAHbwz0EZIRG0oMHdZ44X8NCo/7OX23ULrGHtQ+Q0Zwd4iRFH5ov
         /yiQ==
X-Gm-Message-State: AFqh2koob/7JDHMlNIuQqf7TOwwmmypsOuFkWvZn4xL5mLNmV1rd1UPn
        ooWVCPQrdZEgsd8CT84alithQBM3Jh8=
X-Google-Smtp-Source: AMrXdXsnki7NheOUxQa1ahD9scmYHdyL9v84iHE+m66Y8o7pVqAlxoj5ks8f4dWJbjmh7nCPwmEuUw==
X-Received: by 2002:a05:600c:43ca:b0:3d0:73f5:b2c0 with SMTP id f10-20020a05600c43ca00b003d073f5b2c0mr31897276wmn.20.1672715122176;
        Mon, 02 Jan 2023 19:05:22 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bca41000000b003d1de805de5sm39967839wml.16.2023.01.02.19.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 19:05:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC v2 03/13] io_uring: kill io_run_task_work_ctx
Date:   Tue,  3 Jan 2023 03:03:54 +0000
Message-Id: <8a6592ceb47d808d3e83507c133845c9029e7a2f.1672713341.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672713341.git.asml.silence@gmail.com>
References: <cover.1672713341.git.asml.silence@gmail.com>
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

There is only one user of io_run_task_work_ctx(), inline it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  6 +++++-
 io_uring/io_uring.h | 20 --------------------
 2 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d9a2cf061acc..a22c6778a988 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2452,7 +2452,11 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 
 int io_run_task_work_sig(struct io_ring_ctx *ctx)
 {
-	if (io_run_task_work_ctx(ctx) > 0)
+	if (!llist_empty(&ctx->work_llist)) {
+		if (io_run_local_work(ctx) > 0)
+			return 1;
+	}
+	if (io_run_task_work() > 0)
 		return 1;
 	if (task_sigpending(current))
 		return -EINTR;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 46c0f765a77a..8a5c3affd724 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -269,26 +269,6 @@ static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 	return task_work_pending(current) || !wq_list_empty(&ctx->work_llist);
 }
 
-static inline int io_run_task_work_ctx(struct io_ring_ctx *ctx)
-{
-	int ret = 0;
-	int ret2;
-
-	if (!llist_empty(&ctx->work_llist))
-		ret = io_run_local_work(ctx);
-
-	/* want to run this after in case more is added */
-	ret2 = io_run_task_work();
-
-	/* Try propagate error in favour of if tasks were run,
-	 * but still make sure to run them if requested
-	 */
-	if (ret >= 0)
-		ret += ret2;
-
-	return ret;
-}
-
 static inline int io_run_local_work_locked(struct io_ring_ctx *ctx)
 {
 	bool locked;
-- 
2.38.1

