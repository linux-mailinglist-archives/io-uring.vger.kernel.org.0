Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADA954B37B
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242898AbiFNOiF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242741AbiFNOh4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:56 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D19193C5
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:55 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id s1so11559122wra.9
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6eJxYgBNpK8cENMseaGM9WlOCNZFZvANvUQtryLvK5Y=;
        b=K5DTZNouAcLLflzs3R+LX0vttt9U1ZUHVC0hlnvTuYofknZyBI2thYo4wZoGUE/+Aj
         q13zyWWg3iYPySo5BrX8YKWUVF2F6EK5VHXWbi33HjNqejG/nF7Fqb+ZVeh1JLgvZgq4
         voqzqAYB4wRU1dyRoXZrbog/M0nxtk6fvx8aZwVkRQ77JpOzRQAQP0NU37AvTzdxWa5F
         K/DkM+kWt94MwgpwAYgape+/KyyIPnxzfgwpCK2/jn6l4JPIb53uMnf6x44IqLaIvz0/
         OD67ioKhNSEu2dpaqUX1ghh+tu4keJW3aTkWdYvIrK/sNBSz4X01oYdIEe3q6G7L4uJ2
         u7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6eJxYgBNpK8cENMseaGM9WlOCNZFZvANvUQtryLvK5Y=;
        b=4ltucL6+iERdSnGdyqp2UtO1l4XG/T2+HnxwaLwFzM83RD71t9gOSgfIsTI8099KIV
         aiVeSUje/9A2mt9PaBFSvv3abVP+M9vectzBJRkoGfQfIWGJYFzOLxFeJcuOLnYJZWGz
         ekXOjJ++TUwIuODGL2VpZUlwp+jAsajq+DzXXo+qCjltt0n5HXNUdwDH/Q7FrxGAf9TU
         1EIL06vHIbivieid6848EqIbXl55D0BxvOHheJsEcgWlQ+Bsl1+EBXGpUDH5w9n5zzCT
         2i1j1DL1LyEwZZR7B3ZM9/o7einzuPy+OkqoYGVHVojVKOn37i4C9r4sKF7x0rYca93g
         xOqg==
X-Gm-Message-State: AJIora/7lvpNGC81GWkPT124YEBEYTnGVbQzZ1POs+2bNT6goBVBnFdc
        gxyhFbrhEK8/xcRtT8Ic1uDdVeEsSd5MXg==
X-Google-Smtp-Source: AGRyM1tML264tJAB1VQTJo8R8A6tqR1itUcGYC0CAgkrmiQVWp7wPXlg4hrtl7AyA9jrZNc9M5ruzg==
X-Received: by 2002:adf:d1e7:0:b0:215:2126:dede with SMTP id g7-20020adfd1e7000000b002152126dedemr5230940wrd.297.1655217473913;
        Tue, 14 Jun 2022 07:37:53 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 13/25] io_uring: remove check_cq checking from hot paths
Date:   Tue, 14 Jun 2022 15:37:03 +0100
Message-Id: <9ab7e307e77ffeb92ec788694c87beff27d55c05.1655213915.git.asml.silence@gmail.com>
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

All ctx->check_cq events are slow path, don't test every single flag one
by one in the hot path, but add a common guarding if.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0f6edf82f262..e43eccf173ff 100644
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

