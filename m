Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5056B65B98A
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 04:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbjACDF0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 22:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236576AbjACDFY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 22:05:24 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEB0B7FA
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 19:05:23 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id l26so20181953wme.5
        for <io-uring@vger.kernel.org>; Mon, 02 Jan 2023 19:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O/tD7Lk7IpV2oZF2JCtq4S9GMjdkUZ3nZbiGPCh9Wao=;
        b=Oi+RWNvNe9Q7BVmb62RkLBMK4r5cUX6Qze2/0Ea3nKYBeFu2D0CfxNfjQ8ljRXr65l
         gIqjLF3L3+dgdQGsTX9UJYNOfk9NRsHgoLltmhmB8UfojmUaQAJFEsVOl7Z3y6PXA4OJ
         gyqjtTWMS8JN8ZEIVGECtPPYheRWmz3UESqktRjWwzLRHXUmMXQe3CxA2K2Jw/VOoQv+
         crj9ahlKm/jBbpJTMruTred3WK0cgKswXM/UzyWkKJVI1hSkdvPPclNrum9o83A0eUEH
         8NR8BjpYGdOTXP9ZmJ6mbBIugU2+up1NRFn9Kne2kIrBBXq1lsZrOKvZD25KBw8A7Oul
         VPDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O/tD7Lk7IpV2oZF2JCtq4S9GMjdkUZ3nZbiGPCh9Wao=;
        b=ZSicY5Sr6o0oizCAuvJXjbEYgPXuadp/aqMbZcUwPqvl3dnh4sC6wR12+MxsbOr86v
         zwN7J5QJzZ5TV5jW12lGbvYqg72BgAaRq9FqSXSH416Qddw1PlOdbGf5Pvaf2cJUb28O
         3mqhBbWsV4i9ErXgSI5HGKy7E0bqrjCnoeeuABCWqVfYPD4BptDBnTMxFbK+JLAaNruI
         pmbpkAQw9Cj4qEBXTG6JhOBTSEpXd+5q2oAilmAKlka9T/52zIEHxyOa1ZGTtMavVd+I
         xdtsoJxl9SO3UCIuVjpQserbNxJTM4PpH7gfO4tulFRxI9l8R57GKyDloQaKx43xhRim
         mOeQ==
X-Gm-Message-State: AFqh2koOfq+fqBhOYd2mnffepp/yqSH13Id++omcIbU2Ch/uTauQEheL
        8TcutybhmJ9HWDZGFPmrsNbIvtYyg2M=
X-Google-Smtp-Source: AMrXdXvujv1P6DSg+NEpZWpt5jmB8XwxZRf8P2jWyRPzgJBBKNXbG8GWdcG5A6gWXfkAzDhvpn78dA==
X-Received: by 2002:a05:600c:34cf:b0:3d0:7415:c5a9 with SMTP id d15-20020a05600c34cf00b003d07415c5a9mr31074631wmq.21.1672715121496;
        Mon, 02 Jan 2023 19:05:21 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bca41000000b003d1de805de5sm39967839wml.16.2023.01.02.19.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 19:05:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC v2 02/13] io_uring: don't iterate cq wait fast path
Date:   Tue,  3 Jan 2023 03:03:53 +0000
Message-Id: <53f32543f0907a73f1e7c201dd78765485f26213.1672713341.git.asml.silence@gmail.com>
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

Task work runners keep running until all queues tw items are exhausted.
It's also rare for defer tw to queue normal tw and vise versa. Taking it
into account, there is only a dim chance that further iterating the
io_cqring_wait() fast path will get us anything and so we can remove
the loop there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4f12619f9f21..d9a2cf061acc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2507,18 +2507,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 	if (!io_allowed_run_tw(ctx))
 		return -EEXIST;
-
-	do {
-		/* always run at least 1 task work to process local work */
-		ret = io_run_task_work_ctx(ctx);
+	if (!llist_empty(&ctx->work_llist)) {
+		ret = io_run_local_work(ctx);
 		if (ret < 0)
 			return ret;
-		io_cqring_overflow_flush(ctx);
-
-		/* if user messes with these they will just get an early return */
-		if (__io_cqring_events_user(ctx) >= min_events)
-			return 0;
-	} while (ret > 0);
+	}
+	io_run_task_work();
+	io_cqring_overflow_flush(ctx);
+	/* if user messes with these they will just get an early return */
+	if (__io_cqring_events_user(ctx) >= min_events)
+		return 0;
 
 	if (sig) {
 #ifdef CONFIG_COMPAT
-- 
2.38.1

