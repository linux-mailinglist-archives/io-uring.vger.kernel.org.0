Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486AB3EC3D3
	for <lists+io-uring@lfdr.de>; Sat, 14 Aug 2021 18:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhHNQ1V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Aug 2021 12:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235478AbhHNQ1U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Aug 2021 12:27:20 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81460C061764
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 09:26:51 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id f5so17459213wrm.13
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 09:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HMbyNc94/vcA0kuEZrL9Z+JMXWyVa61prZN2evtjA2M=;
        b=dEqUHInkp+sJjjq+IY7vQOSiYtGPPvZG+EXtqDx/QO93k4xt4JUCaXXsT3qKc/YD0F
         2MTUJhsyerwZJHy0xVvfVR0yea19hqn2IAr+qCDIUU2PANP/V6Je97Ds0bapapM7wtHP
         YoNn17IU6N8ILw28kkYZA/DW25IL9AhOHBn+97rA7kCRwxjT2jYGi/8+YOUjKU6KxW89
         JC/7zsTmdh1SCg28bjn3GBqi7/jTqqyIWQiuY0L+JTw9zqBrzoEA1yeXCbYwgpeO4dOP
         pXHI1m04PwSFvtXOzmtIhXSmm2lE/kY6Ub5tmurb4DPRWbEYeUs4JSQJV0IgWZrwqk2L
         VJGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HMbyNc94/vcA0kuEZrL9Z+JMXWyVa61prZN2evtjA2M=;
        b=BIK9CB9IoriABFIj6s5ZfSw59/q7JCtPlAQVHG8MqpyRsck7HAflloEh5XPlsh6RgK
         k8ijQdqBWfYPWnFjc+M5X68VfLCPOXczi8yocEcnCe9zBIBPbNbndNvDgn9DaDmrPIUf
         xhhBRCOmP0CE++8MFWXkqYP4hfdDeXcc8AoV09HaMv4fvMD8pl6LC4ZXi9pWuUel+dGO
         /WPGtpfLEmO15ZBRgMNB8AN0zGSSEifiL/TiWLtc5n8X18c9nZFxa1cvr+p5d8Bj/9ox
         w4sNE9M4PUCJ6iDH057I9hdneZBLN69FM9szsPbMgFIPi5jjLDZeoRhLomXyjCxvBd/X
         2D4w==
X-Gm-Message-State: AOAM533bDMJY0mvYK39aPexpp0iI+IGQaJYZOKeqOKg0okCbnb66uWed
        oQTIhPvDo04V5tq1TI2vOIY=
X-Google-Smtp-Source: ABdhPJxcWlifYth4MXwNauFDi3bwZUYNykR+PI09S2UW1YttcZHakTyeZ//9u0Vvv+ZW9BtYEuf+RA==
X-Received: by 2002:adf:ed8d:: with SMTP id c13mr9102066wro.405.1628958410176;
        Sat, 14 Aug 2021 09:26:50 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id m62sm5028263wmm.8.2021.08.14.09.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 09:26:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/5] io_uring: kill not necessary resubmit switch
Date:   Sat, 14 Aug 2021 17:26:09 +0100
Message-Id: <a94cd1a31c60527e36eba94726c464b6d0e4ce87.1628957788.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628957788.git.asml.silence@gmail.com>
References: <cover.1628957788.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

773af69121ecc ("io_uring: always reissue from task_work context") makes
all resubmission to be made from task_work, so we don't need that hack
with resubmit/not-resubmit switch anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 37b5516b63c8..c16d172ca37f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2291,7 +2291,7 @@ static inline bool io_run_task_work(void)
  * Find and free completed poll iocbs
  */
 static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			       struct list_head *done, bool resubmit)
+			       struct list_head *done)
 {
 	struct req_batch rb;
 	struct io_kiocb *req;
@@ -2306,7 +2306,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
 
-		if (READ_ONCE(req->result) == -EAGAIN && resubmit &&
+		if (READ_ONCE(req->result) == -EAGAIN &&
 		    !(req->flags & REQ_F_DONT_REISSUE)) {
 			req->iopoll_completed = 0;
 			io_req_task_queue_reissue(req);
@@ -2329,7 +2329,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 }
 
 static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			long min, bool resubmit)
+			long min)
 {
 	struct io_kiocb *req, *tmp;
 	LIST_HEAD(done);
@@ -2369,7 +2369,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	}
 
 	if (!list_empty(&done))
-		io_iopoll_complete(ctx, nr_events, &done, resubmit);
+		io_iopoll_complete(ctx, nr_events, &done);
 
 	return 0;
 }
@@ -2387,7 +2387,7 @@ static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 	while (!list_empty(&ctx->iopoll_list)) {
 		unsigned int nr_events = 0;
 
-		io_do_iopoll(ctx, &nr_events, 0, false);
+		io_do_iopoll(ctx, &nr_events, 0);
 
 		/* let it sleep and repeat later if can't complete a request */
 		if (nr_events == 0)
@@ -2449,7 +2449,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 			    list_empty(&ctx->iopoll_list))
 				break;
 		}
-		ret = io_do_iopoll(ctx, &nr_events, min, true);
+		ret = io_do_iopoll(ctx, &nr_events, min);
 	} while (!ret && nr_events < min && !need_resched());
 out:
 	mutex_unlock(&ctx->uring_lock);
@@ -6855,7 +6855,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 
 		mutex_lock(&ctx->uring_lock);
 		if (!list_empty(&ctx->iopoll_list))
-			io_do_iopoll(ctx, &nr_events, 0, true);
+			io_do_iopoll(ctx, &nr_events, 0);
 
 		/*
 		 * Don't submit if refs are dying, good for io_uring_register(),
-- 
2.32.0

