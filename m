Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3AF54CECA
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 18:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356746AbiFOQen (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 12:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356726AbiFOQek (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 12:34:40 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272942BB1B
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:36 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w17so8603008wrg.7
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qNT+ZB+G8mcMlHFOU8EhXjkZoMhG/NfZq2/GkAr9hA4=;
        b=S9YDcuwNx7lbUBbjX5Sce4keLjMcx6Pd7bOpIZh/x0nyr7uk8blJ7OEqdlM1PU4+y4
         XsAG/KxW4gMpTNBs94y98udt1KmUQwbQoMoUNWC+lFT32CAw3kfp2U8V8RV9Icu9qwjX
         8lXAFvg3jMdWgmubGbdymAw7zp7KUKVRZcrrsmxmu15cetE0F9v1xtG+Fp5qP6W77S4c
         3puFi+kA95O4K335etGyDa8/F0DYeGUVUhUfQ7fYoup6okihYwygNjyTgGaeHe+rkoUQ
         V/77+RFL5B50BgKy5fmd2z+x7/FnLdx/iClL3ngXHNJ42FHuwCVLuQASJfSprrSBzt+q
         bWfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qNT+ZB+G8mcMlHFOU8EhXjkZoMhG/NfZq2/GkAr9hA4=;
        b=Lgav6nIV3tHPHs+1OUVDT+gytiN/FKlWYUQ17LNYAmkFW13H91+2WPOWqUdyoz9Lrg
         fKZNS46rYGdEHuT8R8PqxhEjyV1Sfi08srv6Qvreyo688BExhNIt5nzrrhNYC4hKVg5Y
         K/pyIWVNZ7gTSG06K3F5hw5eP1ujYJPYur+W1uDMxDPu9vtWI051LdJM3Z6IJaVqT30n
         GESHFh1SmxpS30TbvBkZL4nRoJ3SGYV77hw2P/kn+hUOpUvy8kN/z7B64wHncXAw4Ksk
         SfeYiz/4E657otBA0Ll7qbM8efi+kl7vhQ+gb3KushueeQpJ/3KFuDbjGwsVxvSjtep+
         pKng==
X-Gm-Message-State: AJIora/lo1n7esiRdiTjkMYdl7/1z93yPld6U0tnuhiyBMxgck1JwKPJ
        YPXCnlbIQj1JsOjVI/BNadLkmgVl0viU/Q==
X-Google-Smtp-Source: AGRyM1sfkxLkTv7ns+f7+T3UxwwuTzvU0QdHR5QolUBCWD7STtfeDWQNz8HagmUJqiMpv1d9og9ejg==
X-Received: by 2002:adf:eb90:0:b0:21a:b9e:c3fe with SMTP id t16-20020adfeb90000000b0021a0b9ec3femr602806wrn.429.1655310874410;
        Wed, 15 Jun 2022 09:34:34 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a056000038200b0020ff3a2a925sm17894953wrf.63.2022.06.15.09.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:34:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 09/10] io_uring: remove check_cq checking from hot paths
Date:   Wed, 15 Jun 2022 17:33:55 +0100
Message-Id: <dff026585cea7ff3a172a7c83894a3b0111bbf6a.1655310733.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655310733.git.asml.silence@gmail.com>
References: <cover.1655310733.git.asml.silence@gmail.com>
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

All ctx->check_cq events are slow path, don't test every single flag one
by one in the hot path, but add a common guarding if.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 68ce8666bd32..f47de2906549 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1714,24 +1714,25 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 	int ret = 0;
 	unsigned long check_cq;
 
+	check_cq = READ_ONCE(ctx->check_cq);
+	if (unlikely(check_cq)) {
+		if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
+			__io_cqring_overflow_flush(ctx, false);
+		/*
+		 * Similarly do not spin if we have not informed the user of any
+		 * dropped CQE.
+		 */
+		if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT))
+			return -EBADR;
+	}
 	/*
 	 * Don't enter poll loop if we already have events pending.
 	 * If we do, we can potentially be spinning for commands that
 	 * already triggered a CQE (eg in error).
 	 */
-	check_cq = READ_ONCE(ctx->check_cq);
-	if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
-		__io_cqring_overflow_flush(ctx, false);
 	if (io_cqring_events(ctx))
 		return 0;
 
-	/*
-	 * Similarly do not spin if we have not informed the user of any
-	 * dropped CQE.
-	 */
-	if (unlikely(check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT)))
-		return -EBADR;
-
 	do {
 		/*
 		 * If a submit got punted to a workqueue, we can have the
@@ -2657,12 +2658,15 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	ret = io_run_task_work_sig();
 	if (ret || io_should_wake(iowq))
 		return ret;
+
 	check_cq = READ_ONCE(ctx->check_cq);
-	/* let the caller flush overflows, retry */
-	if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
-		return 1;
-	if (unlikely(check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT)))
-		return -EBADR;
+	if (unlikely(check_cq)) {
+		/* let the caller flush overflows, retry */
+		if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
+			return 1;
+		if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT))
+			return -EBADR;
+	}
 	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
 	return 1;
-- 
2.36.1

