Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99EC54B146
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245146AbiFNMe0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiFNMd4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:33:56 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3004B864
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:53 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id m39-20020a05600c3b2700b0039c511ebbacso6133314wms.3
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R4fEAW3IwnjCgPgFIiQUdI5m2WItkDGjr8AmxNsgZaI=;
        b=PHPZ8jjekPVuUliMXV5pGuBP/yF1BZuT0iorpX/003+XR5JkQ45gMD64UsgGzXA24h
         nwNTybqwZT5I6T2vNHRGDoeAP9FFOzq2Gh24lfv+FZJG/JMsw8yxYqGlOqgjB8VsN3+x
         G7EcacKwJG467tuiW4GUB/gkXvYVz5AdKiB9Lr4HKNIgDRLN7OblQ/NIBivWdEFh3yk8
         MtlX1BS/pqhdcrOlLK5J3H4Oqt+9Y+F9KfY+cDXEu1oeYAa6KpCtzwGtJx+teiSQHKSL
         UTbPuBn7Lt3wRRIm7O7P/H6UmJiMd1oyrYjEm8BTFpj3qYe10VtAuBonvIWOso3+YWF4
         l6aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R4fEAW3IwnjCgPgFIiQUdI5m2WItkDGjr8AmxNsgZaI=;
        b=FdYznlxelBQVM0+wqiRIErmUhKyeuHrv/f0yn4NM0iRo9sNpE9paqe71hlpSI6xCGs
         Vf3uJ2pJkg2meNqnpcSgJHtS97GvQSC1SqPUcKCrHoZZ972cVUOHF0gj+R+5KErDhj3V
         IkSW8NFnn503wA3Vq8UD/ivKtNIY4dQhn49jE/bnKEyZIgN4COhqf6lrfvE7y9lLG2WU
         +XnGCdW0H3pktYDHakUhym5ZNT1GRpYuJwGmBlP+Gm5tvXkPpNNb9EIUTKgVSBWyzH8J
         qM9Pdvb4FPZnH98uJ4SKrJQjGlykKM0mUeK86w78dbZFTeDA3Ogpsk50Tt+bY/PjWdHI
         TWDw==
X-Gm-Message-State: AOAM530QjvGeLTubTBZdyKxkWmdfsT5WXg3iOKrt6XfuvT14GVUwpwus
        Yb9oVeSVL7rQtCWI0CM8/w548d8N24YRBw==
X-Google-Smtp-Source: ABdhPJwKKhI0KlomPet6ynDBihho4ZpZapSjOOFXa0QbXzboL48tDBHolKtJQp0y+o/1A1B3tK3ZZg==
X-Received: by 2002:a05:600c:2194:b0:39c:419c:1a24 with SMTP id e20-20020a05600c219400b0039c419c1a24mr3900533wme.186.1655209851382;
        Tue, 14 Jun 2022 05:30:51 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 13/25] io_uring: remove check_cq checking from hot paths
Date:   Tue, 14 Jun 2022 13:29:51 +0100
Message-Id: <35d95aeb2c0bb749398f8eeb05f3006391469d0b.1655209709.git.asml.silence@gmail.com>
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

All ctx->check_cq events are slow path, don't test every single flag one
by one in the hot path, but add a common guarding if.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f3cae98471b8..bd2aab895e29 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1807,24 +1807,25 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
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
@@ -2752,12 +2753,15 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
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

