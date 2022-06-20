Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89554550DDC
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 02:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237222AbiFTA0i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 20:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237232AbiFTA0h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 20:26:37 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBB6AE41
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:36 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v14so12472104wra.5
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z6F1kSkayF9VqahsR2vA++YtT0wZ/B8SrjyrYHcF2bA=;
        b=n5inSpA+6K4YZwd5bDBJXuQHIYkA7G4YR3/DnFcUshUK6O16HW9Ojpi9DHdBE0xB5X
         JzjQpkmd1kPCuVirYXtPMN4YdxJq3XuQ4wJdHFARRlnZ2HEyzhc59yLH94ORWnRX8moz
         SVdQWG0vWyh2doDL2F2vDd03fXfdczZyrb1hq+yY4SJCk+t3nA4DNd2Ptu3zlbdmHnDD
         9sqhFuVQDBOKInlCeYbEIDBVOg57NdpL7bmma5LdBrwCAYGIIXSLH4SOhrWEIXFey5tX
         drzuA4mfPnyM/cC4BPwmNPbArjILRzE4ya+xOUeOtUHFI+G33xcxLJLqP0k2Ly9QR73g
         xLAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z6F1kSkayF9VqahsR2vA++YtT0wZ/B8SrjyrYHcF2bA=;
        b=OzGoURgR9y5sMkiBbNHoUSyb9O/BTHcJRaJlEsQlzUbjQ6ssoFMC3wY7iJANZeXNNj
         PnbDAQquD4Nh8fegcquP0mzhVka/yhqkorPMAKffg6gOY+9SH6Me0b/p2VA9tO9YYbHZ
         CtdalorxWks/otDYioB5t3HKPV4OcG49cIqsOtxTUMx6wg9PcEI0XuphBfrDVRPIHknx
         6a/FImtrI0TVtV/nVf2azycKHI2YDStlv/zWuMM/SNqOF25hzduwsWPmEYpRkljXma/R
         0G6VwF+0oXYNbbY6LwT3nM4l/H7Yny9WEUT35GW+hAebjyuktAw3NFHRdUZGpcYv3W0P
         +zKg==
X-Gm-Message-State: AJIora81GwI78iKUVZ86CDVxMk6n13zXTqD0ndpboN6txd9CjBCa0nze
        nxNbmOTZdyTbSHnY5Y9fclKXoDEyRPg8/w==
X-Google-Smtp-Source: AGRyM1uwD+sp+Te5QCydS+/O+hURj/7pxJtLXz/lg7yklLOnugI7GhOkaOzLTRovAG8fZTK961De4w==
X-Received: by 2002:adf:e502:0:b0:21b:8de6:7f14 with SMTP id j2-20020adfe502000000b0021b8de67f14mr3456802wrm.3.1655684794687;
        Sun, 19 Jun 2022 17:26:34 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d4312000000b002167efdd549sm11543807wrq.38.2022.06.19.17.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 17:26:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 04/10] io_uring: hide eventfd assumptions in evenfd paths
Date:   Mon, 20 Jun 2022 01:25:55 +0100
Message-Id: <0ffc66bae37a2513080b601e4370e147faaa72c5.1655684496.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655684496.git.asml.silence@gmail.com>
References: <cover.1655684496.git.asml.silence@gmail.com>
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

Some io_uring-eventfd users assume that there won't be spurious wakeups.
That assumption has to be honoured by all io_cqring_ev_posted() callers,
which is inconvenient and from time to time leads to problems but should
be maintained to not break the userspace.

Instead of making the callers to track whether a CQE was posted or not,
hide it inside io_eventfd_signal(). It saves ->cached_cq_tail it saw
last time and triggers the eventfd only when ->cached_cq_tail changed
since then.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  2 ++
 io_uring/io_uring.c            | 44 ++++++++++++++++++++--------------
 io_uring/timeout.c             |  3 +--
 3 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 6bcd7bff6479..5987f8acca38 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -314,6 +314,8 @@ struct io_ring_ctx {
 
 	struct list_head		defer_list;
 	unsigned			sq_thread_idle;
+	/* protected by ->completion_lock */
+	unsigned			evfd_last_cq_tail;
 };
 
 enum {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2d1d4752b955..ded42d884c49 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -473,6 +473,22 @@ static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
 static void io_eventfd_signal(struct io_ring_ctx *ctx)
 {
 	struct io_ev_fd *ev_fd;
+	bool skip;
+
+	spin_lock(&ctx->completion_lock);
+	/*
+	 * Eventfd should only get triggered when at least one event has been
+	 * posted. Some applications rely on the eventfd notification count only
+	 * changing IFF a new CQE has been added to the CQ ring. There's no
+	 * depedency on 1:1 relationship between how many times this function is
+	 * called (and hence the eventfd count) and number of CQEs posted to the
+	 * CQ ring.
+	 */
+	skip = ctx->cached_cq_tail == ctx->evfd_last_cq_tail;
+	ctx->evfd_last_cq_tail = ctx->cached_cq_tail;
+	spin_unlock(&ctx->completion_lock);
+	if (skip)
+		return;
 
 	rcu_read_lock();
 	/*
@@ -511,13 +527,6 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 		io_eventfd_signal(ctx);
 }
 
-/*
- * This should only get called when at least one event has been posted.
- * Some applications rely on the eventfd notification count only changing
- * IFF a new CQE has been added to the CQ ring. There's no depedency on
- * 1:1 relationship between how many times this function is called (and
- * hence the eventfd count) and number of CQEs posted to the CQ ring.
- */
 void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
 	if (unlikely(ctx->off_timeout_used || ctx->drain_active ||
@@ -530,7 +539,7 @@ void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 /* Returns true if there are no backlogged entries after the flush */
 static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
-	bool all_flushed, posted;
+	bool all_flushed;
 	size_t cqe_size = sizeof(struct io_uring_cqe);
 
 	if (!force && __io_cqring_events(ctx) == ctx->cq_entries)
@@ -539,7 +548,6 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	if (ctx->flags & IORING_SETUP_CQE32)
 		cqe_size <<= 1;
 
-	posted = false;
 	spin_lock(&ctx->completion_lock);
 	while (!list_empty(&ctx->cq_overflow_list)) {
 		struct io_uring_cqe *cqe = io_get_cqe(ctx);
@@ -554,7 +562,6 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		else
 			io_account_cq_overflow(ctx);
 
-		posted = true;
 		list_del(&ocqe->list);
 		kfree(ocqe);
 	}
@@ -567,8 +574,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
-	if (posted)
-		io_cqring_ev_posted(ctx);
+	io_cqring_ev_posted(ctx);
 	return all_flushed;
 }
 
@@ -758,8 +764,7 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx,
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
-	if (filled)
-		io_cqring_ev_posted(ctx);
+	io_cqring_ev_posted(ctx);
 	return filled;
 }
 
@@ -940,14 +945,12 @@ __cold void io_free_req(struct io_kiocb *req)
 static void __io_req_find_next_prep(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	bool posted;
 
 	spin_lock(&ctx->completion_lock);
-	posted = io_disarm_next(req);
+	io_disarm_next(req);
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
-	if (posted)
-		io_cqring_ev_posted(ctx);
+	io_cqring_ev_posted(ctx);
 }
 
 static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
@@ -2428,6 +2431,11 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 		kfree(ev_fd);
 		return ret;
 	}
+
+	spin_lock(&ctx->completion_lock);
+	ctx->evfd_last_cq_tail = ctx->cached_cq_tail;
+	spin_unlock(&ctx->completion_lock);
+
 	ev_fd->eventfd_async = eventfd_async;
 	ctx->has_evfd = true;
 	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index a79a7d6ef1b3..424b2fc858b8 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -629,7 +629,6 @@ __cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	spin_unlock_irq(&ctx->timeout_lock);
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
-	if (canceled != 0)
-		io_cqring_ev_posted(ctx);
+	io_cqring_ev_posted(ctx);
 	return canceled != 0;
 }
-- 
2.36.1

