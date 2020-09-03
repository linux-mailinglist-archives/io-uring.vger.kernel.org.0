Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEAA25B8B4
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 04:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgICCVG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 22:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbgICCVC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 22:21:02 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96203C061245
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 19:21:02 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id g6so704813pjl.0
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 19:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b2IBSfdkN2//T0RLytqNsVao4yfw3wY76zpYlDHsp78=;
        b=tELEHYvUKyjjbODDsL8nFoHxYK0D28mBAdEJsprWjIPvA04cO8gWK3c6+EbqnfPzEG
         tFXoouMS93EHWgYUodyQAISLFiS+fN5FlR21JATYwTbZZeStVCetKNZUJJ2Q8SdIQLBe
         aPgxVdIc+Hj0ry4eDtLcmuOG2gu76B0KKC/fC9TwgqE9Bj+OqaMoiWOvM088l5hFNsPq
         yURhLd9i+XkZFyUDgGThWOIZ9LvGmSLSkGdMrgyw1KtsaKMOZXrDBSGQVgkIIAwOq9s5
         uyzYUrizTr4JrFxjfjzZC527428boVggsQ252LjQtFg2JfWZk2f1kn0dl1hJkiuK8udb
         dkwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b2IBSfdkN2//T0RLytqNsVao4yfw3wY76zpYlDHsp78=;
        b=regVYAcZyKli+KeorR9e6LRPNQTKbbmpkLCiNW1l2FYc5x4OKuT19UUQznEAzEZpjH
         /uhWAVyJbMqWPgeVSRxply1y5zafxUEiRhWx+nwVHusfl/PfZvliM2oNjV7jw2r1ScEv
         lInGP/0fo5hHrkw+vZTRxj6gOJtICEh1EhounLd+iU5/QR1prvSaasY37ICAsIrTAh3D
         AY+VZrcD9OJlaTeJrs4UTTVLNRvczOgYNSWc+vF9a91x5jtmQus3NOdcLbTM5LKGnUjF
         3RshKIfT24Xq+zQ7Q4ghIcP/qDJnuB+sMenZPmKkMw0QWQvTkqsATaql7ja2+U+8gNJM
         xuOw==
X-Gm-Message-State: AOAM530Ia1fGjhbKdtxeUH7hU9lVURJVGzejKIO16mt1Jlb7JZraMby4
        Od8QStW51U9FQhKzz9DhMpS3vzRUOA29vsSp
X-Google-Smtp-Source: ABdhPJxHXp777n3ZXcuaFiNZoegT22bF/toNTLy5QRIp4+EdiNE0aRQfJbj8XEg6uttzM/6hJ1OVTA==
X-Received: by 2002:a17:90a:9415:: with SMTP id r21mr772613pjo.204.1599099661815;
        Wed, 02 Sep 2020 19:21:01 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id ie13sm663102pjb.5.2020.09.02.19.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 19:21:01 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/8] io_uring: use private ctx wait queue entries for SQPOLL
Date:   Wed,  2 Sep 2020 20:20:48 -0600
Message-Id: <20200903022053.912968-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903022053.912968-1-axboe@kernel.dk>
References: <20200903022053.912968-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is in preparation to sharing the poller thread between rings. For
that we need per-ring wait_queue_entry storage, and we can't easily put
that on the stack if one thread is managing multiple rings.

We'll also be sharing the wait_queue_head across rings for the purposes
of wakeups, provide the usual private ring wait_queue_head for now but
make it a pointer so we can easily override it when sharing.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e2e62dbc4b93..76f02db37ffc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -277,7 +277,10 @@ struct io_ring_ctx {
 	struct io_wq		*io_wq;
 	struct task_struct	*sqo_thread;	/* if using sq thread polling */
 	struct mm_struct	*sqo_mm;
-	wait_queue_head_t	sqo_wait;
+	struct wait_queue_head	*sqo_wait;
+	struct wait_queue_head	__sqo_wait;
+	struct wait_queue_entry	sqo_wait_entry;
+
 
 	/*
 	 * For SQPOLL usage - no reference is held to this file table, we
@@ -1083,7 +1086,8 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 
 	ctx->flags = p->flags;
-	init_waitqueue_head(&ctx->sqo_wait);
+	init_waitqueue_head(&ctx->__sqo_wait);
+	ctx->sqo_wait = &ctx->__sqo_wait;
 	init_waitqueue_head(&ctx->cq_wait);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->ref_comp);
@@ -1346,8 +1350,8 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
-	if (waitqueue_active(&ctx->sqo_wait))
-		wake_up(&ctx->sqo_wait);
+	if (waitqueue_active(ctx->sqo_wait))
+		wake_up(ctx->sqo_wait);
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
 }
@@ -2411,9 +2415,8 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	else
 		list_add_tail(&req->inflight_entry, &ctx->iopoll_list);
 
-	if ((ctx->flags & IORING_SETUP_SQPOLL) &&
-	    wq_has_sleeper(&ctx->sqo_wait))
-		wake_up(&ctx->sqo_wait);
+	if ((ctx->flags & IORING_SETUP_SQPOLL) && wq_has_sleeper(ctx->sqo_wait))
+		wake_up(ctx->sqo_wait);
 }
 
 static void __io_state_file_put(struct io_submit_state *state)
@@ -6614,10 +6617,11 @@ static int io_sq_thread(void *data)
 {
 	struct io_ring_ctx *ctx = data;
 	const struct cred *old_cred;
-	DEFINE_WAIT(wait);
 	unsigned long timeout;
 	int ret = 0;
 
+	init_wait(&ctx->sqo_wait_entry);
+
 	complete(&ctx->sq_thread_comp);
 
 	old_cred = override_creds(ctx->creds);
@@ -6671,7 +6675,7 @@ static int io_sq_thread(void *data)
 				continue;
 			}
 
-			prepare_to_wait(&ctx->sqo_wait, &wait,
+			prepare_to_wait(ctx->sqo_wait, &ctx->sqo_wait_entry,
 						TASK_INTERRUPTIBLE);
 
 			/*
@@ -6683,7 +6687,7 @@ static int io_sq_thread(void *data)
 			 */
 			if ((ctx->flags & IORING_SETUP_IOPOLL) &&
 			    !list_empty_careful(&ctx->iopoll_list)) {
-				finish_wait(&ctx->sqo_wait, &wait);
+				finish_wait(ctx->sqo_wait, &ctx->sqo_wait_entry);
 				continue;
 			}
 
@@ -6692,22 +6696,22 @@ static int io_sq_thread(void *data)
 			to_submit = io_sqring_entries(ctx);
 			if (!to_submit || ret == -EBUSY) {
 				if (kthread_should_park()) {
-					finish_wait(&ctx->sqo_wait, &wait);
+					finish_wait(ctx->sqo_wait, &ctx->sqo_wait_entry);
 					break;
 				}
 				if (io_run_task_work()) {
-					finish_wait(&ctx->sqo_wait, &wait);
+					finish_wait(ctx->sqo_wait, &ctx->sqo_wait_entry);
 					io_ring_clear_wakeup_flag(ctx);
 					continue;
 				}
 				schedule();
-				finish_wait(&ctx->sqo_wait, &wait);
+				finish_wait(ctx->sqo_wait, &ctx->sqo_wait_entry);
 
 				io_ring_clear_wakeup_flag(ctx);
 				ret = 0;
 				continue;
 			}
-			finish_wait(&ctx->sqo_wait, &wait);
+			finish_wait(ctx->sqo_wait, &ctx->sqo_wait_entry);
 
 			io_ring_clear_wakeup_flag(ctx);
 		}
@@ -8371,7 +8375,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		if (!list_empty_careful(&ctx->cq_overflow_list))
 			io_cqring_overflow_flush(ctx, false);
 		if (flags & IORING_ENTER_SQ_WAKEUP)
-			wake_up(&ctx->sqo_wait);
+			wake_up(ctx->sqo_wait);
 		submitted = to_submit;
 	} else if (to_submit) {
 		mutex_lock(&ctx->uring_lock);
-- 
2.28.0

