Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1D1290925
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410547AbgJPQCy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395555AbgJPQCx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:53 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76701C0613D3
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:52 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 144so1756614pfb.4
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pK7h1x8d2nCXpw0QDgZ1YJgBb76VkTvFH1fza4m3ZJQ=;
        b=BvtpnYq5br5QloIgiw4WxcRQlFQUz7yN+ycy4flpiLguxrvHGuEUhkaIRF8dgM7DyD
         yPmOHSsASjcSWwJKK1ZNSm+uk2be/F9Ct9+Ond6abtnT0+bc/oUCEusdHU2bZPdQobi2
         UEed8pK6q8FTDKJim1aVQEKTpQgAOm/1Dos33boo6sQBA59uPeyhvQuiFiOqq0TUBmnU
         IfmfvU0i7Jlbk34OindYR7qUTiqCDy2ZCBrsVeCb1YmMnGY1kXJHmsmnMGtndPu1B/35
         KLlztz/s8WjcQLBWnnG2qwBBHo5JC0T6+Y1nitSvQwHGi5D5PUterCxC7bw8mgtz2ZXn
         EWlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pK7h1x8d2nCXpw0QDgZ1YJgBb76VkTvFH1fza4m3ZJQ=;
        b=Nl5LyMfaEWYrLc+qw89NZlS+SfXGERV8we4JOpjMFRbqhparsf7rFeYVcCmDLuq/HB
         H0HOM7fJFO+oSWtiGOT8pveq1bH3WkcHN2xBDHzNYgGWTROHZiwZ/jwL0COMh+qjBqpo
         kWRaUpGSX9Ro+k2v0at7beLAtHvp02LhACfOP8s+UkDhSpjQ/pIItaDAqmJ40VNxTBF0
         PX8UKY5AjD2tDvqj06f4W6jD6kO3WOrZUnh6uoXtwxXE/1wZUyZ8ZrIi6eTJ86z/JkA2
         YGfODDkXJqrxwt2HZhWNicu7tf4dmr3mgZq7kgVrL/gAq3o3C6z+5QmHvPIt/ZEYiNm9
         ximA==
X-Gm-Message-State: AOAM531hXxl3eBbNFPVIjPYldWjSCmtOJ52Zikdl+O1mNx9oWo/I6v+q
        C9WMOgiVJd6xe/4TL/PqrPFODUsTZ2j93gxc
X-Google-Smtp-Source: ABdhPJw2fBl7gzPBCW+shk/zsCtKF2L5CyKrmbhpxO9/taCnRBGgJDHJgHJuPuKWUee2QhVQZFceSg==
X-Received: by 2002:a63:d40d:: with SMTP id a13mr3848939pgh.344.1602864170708;
        Fri, 16 Oct 2020 09:02:50 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 18/18] io_uring: use percpu counters to track inflight requests
Date:   Fri, 16 Oct 2020 10:02:24 -0600
Message-Id: <20201016160224.1575329-19-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Even though we place the req_issued and req_complete in separate
cachelines, there's considerable overhead in doing the atomics
particularly on the completion side.

Get rid of having the two counters, and just use a percpu_counter for
this. That's what it was made for, after all. This considerably
reduces the overhead in __io_free_req().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c            | 50 ++++++++++++++++++++++------------------
 include/linux/io_uring.h |  7 ++----
 2 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5af6dafcc669..6ad04eaf24dd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1810,7 +1810,7 @@ static void __io_free_req(struct io_kiocb *req)
 
 	io_dismantle_req(req);
 
-	atomic_long_inc(&tctx->req_complete);
+	percpu_counter_dec(&tctx->inflight);
 	if (tctx->in_idle)
 		wake_up(&tctx->wait);
 	put_task_struct(req->task);
@@ -2089,7 +2089,9 @@ static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 	if (rb->to_free)
 		__io_req_free_batch_flush(ctx, rb);
 	if (rb->task) {
-		atomic_long_add(rb->task_refs, &rb->task->io_uring->req_complete);
+		struct io_uring_task *tctx = rb->task->io_uring;
+
+		percpu_counter_sub(&tctx->inflight, rb->task_refs);
 		put_task_struct_many(rb->task, rb->task_refs);
 		rb->task = NULL;
 	}
@@ -2106,7 +2108,9 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 
 	if (req->task != rb->task) {
 		if (rb->task) {
-			atomic_long_add(rb->task_refs, &rb->task->io_uring->req_complete);
+			struct io_uring_task *tctx = rb->task->io_uring;
+
+			percpu_counter_sub(&tctx->inflight, rb->task_refs);
 			put_task_struct_many(rb->task, rb->task_refs);
 		}
 		rb->task = req->task;
@@ -6517,7 +6521,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
 
-	atomic_long_add(nr, &current->io_uring->req_issue);
+	percpu_counter_add(&current->io_uring->inflight, nr);
 	refcount_add(nr, &current->usage);
 
 	io_submit_state_start(&state, ctx, nr);
@@ -6559,10 +6563,12 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 	if (unlikely(submitted != nr)) {
 		int ref_used = (submitted == -EAGAIN) ? 0 : submitted;
+		struct io_uring_task *tctx = current->io_uring;
+		int unused = nr - ref_used;
 
-		percpu_ref_put_many(&ctx->refs, nr - ref_used);
-		atomic_long_sub(nr - ref_used, &current->io_uring->req_issue);
-		put_task_struct_many(current, nr - ref_used);
+		percpu_ref_put_many(&ctx->refs, unused);
+		percpu_counter_sub(&tctx->inflight, unused);
+		put_task_struct_many(current, unused);
 	}
 	if (link)
 		io_queue_link_head(link, &state.comp);
@@ -7680,17 +7686,22 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
 static int io_uring_alloc_task_context(struct task_struct *task)
 {
 	struct io_uring_task *tctx;
+	int ret;
 
 	tctx = kmalloc(sizeof(*tctx), GFP_KERNEL);
 	if (unlikely(!tctx))
 		return -ENOMEM;
 
+	ret = percpu_counter_init(&tctx->inflight, 0, GFP_KERNEL);
+	if (unlikely(ret)) {
+		kfree(tctx);
+		return ret;
+	}
+
 	xa_init(&tctx->xa);
 	init_waitqueue_head(&tctx->wait);
 	tctx->last = NULL;
 	tctx->in_idle = 0;
-	atomic_long_set(&tctx->req_issue, 0);
-	atomic_long_set(&tctx->req_complete, 0);
 	io_init_identity(&tctx->__identity);
 	tctx->identity = &tctx->__identity;
 	task->io_uring = tctx;
@@ -7705,6 +7716,7 @@ void __io_uring_free(struct task_struct *tsk)
 	WARN_ON_ONCE(refcount_read(&tctx->identity->count) != 1);
 	if (tctx->identity != &tctx->__identity)
 		kfree(tctx->identity);
+	percpu_counter_destroy(&tctx->inflight);
 	kfree(tctx);
 	tsk->io_uring = NULL;
 }
@@ -8689,12 +8701,6 @@ void __io_uring_files_cancel(struct files_struct *files)
 	}
 }
 
-static inline bool io_uring_task_idle(struct io_uring_task *tctx)
-{
-	return atomic_long_read(&tctx->req_issue) ==
-		atomic_long_read(&tctx->req_complete);
-}
-
 /*
  * Find any io_uring fd that this task has registered or done IO on, and cancel
  * requests.
@@ -8703,14 +8709,16 @@ void __io_uring_task_cancel(void)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	DEFINE_WAIT(wait);
-	long completions;
+	s64 inflight;
 
 	/* make sure overflow events are dropped */
 	tctx->in_idle = true;
 
-	while (!io_uring_task_idle(tctx)) {
+	do {
 		/* read completions before cancelations */
-		completions = atomic_long_read(&tctx->req_complete);
+		inflight = percpu_counter_sum(&tctx->inflight);
+		if (!inflight)
+			break;
 		__io_uring_files_cancel(NULL);
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
@@ -8719,12 +8727,10 @@ void __io_uring_task_cancel(void)
 		 * If we've seen completions, retry. This avoids a race where
 		 * a completion comes in before we did prepare_to_wait().
 		 */
-		if (completions != atomic_long_read(&tctx->req_complete))
+		if (inflight != percpu_counter_sum(&tctx->inflight))
 			continue;
-		if (io_uring_task_idle(tctx))
-			break;
 		schedule();
-	}
+	} while (1);
 
 	finish_wait(&tctx->wait, &wait);
 	tctx->in_idle = false;
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 607d14f61132..28939820b6b0 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -23,13 +23,10 @@ struct io_uring_task {
 	struct xarray		xa;
 	struct wait_queue_head	wait;
 	struct file		*last;
-	atomic_long_t		req_issue;
+	struct percpu_counter	inflight;
 	struct io_identity	__identity;
 	struct io_identity	*identity;
-
-	/* completion side */
-	bool			in_idle ____cacheline_aligned_in_smp;
-	atomic_long_t		req_complete;
+	bool			in_idle;
 };
 
 #if defined(CONFIG_IO_URING)
-- 
2.28.0

