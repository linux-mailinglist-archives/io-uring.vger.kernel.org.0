Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C2F3E98EF
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 21:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhHKTlY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 15:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbhHKTlY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 15:41:24 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D50DC061765
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:41:00 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so5843662pje.0
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mW9OlmUpEFYmHcfreOWauxVrheYYW80HQSe06BNBED0=;
        b=s4yAftlYHbN4H5PBP1QmlzAIelUN5zx029QryuEpUCkFzgOtmdUPXLF+Xo98JqHh8U
         LQOOXr8EZpx8cQLzp7OSZ/B7xLeuxwYexPLmQXtbPxNZHrW0xJh5Wi/kU7/hBx2P1QEB
         nxzItDnlVdLdQPK/FHYEL1oBkHjE5Uv57xOYURaptJMHXAwS8eeZDaG+C1FygTDL01Cy
         HLx5muoeKYPXDFdXFz6Du2MOWZZMRXug3Crpwq2ldiUuHEFRfL6wY87eWR0Bkl9nnHaH
         KRK63i3G2neNhFUGFwO8mAGxLlkY4+ggBBBDwKe6M2ucc7IXUuPhWcKCZGp5mXJqyQHl
         j1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mW9OlmUpEFYmHcfreOWauxVrheYYW80HQSe06BNBED0=;
        b=WQsN6y6EwfbL5c4x7YjWKwEXhvdiDnsvZDK7NUgn839yg5mzqDd28uiZkgIUA0V60z
         vxu369a/TSgXAvY3EJCDH5w/ec4Axy9Et5LNKsM9hjVjoUqgEBmE8Y6gtHRgR409CcJf
         lSJLr5uDNbA79scz/bRgTlTXL6CcFRKzDO6T/ctEdpZ6eIUx7um09wGqXfhKkp6ijtkG
         A2OnPEWrPM1ZRm6uYHvztdLGU0P+9HfQ6e8z3cStW87LtYUmA8bE/wOWiQcOqnHKwT86
         nEwI90QV/iHn1XboBpw9JFh4RchYDJevz4KtRvFLYOty+Kr4q0CLhouk3i4/Gco3LGns
         C/3Q==
X-Gm-Message-State: AOAM533ZXGPkyDTzyJES2/NfCQED3CACw5uidgF2IZPx9wcSzXzen2yR
        2mBH8fkdUITi6L4rdnr6f6mlrWtUAaq6bGFt
X-Google-Smtp-Source: ABdhPJw374ei5B7QCfMlc4IK0GhU9Rpky7y3ipuZVmq1bPHgewIEIHDn1YCU7Igld2MNlRq9bhI2tQ==
X-Received: by 2002:a63:ba5c:: with SMTP id l28mr297396pgu.311.1628710859825;
        Wed, 11 Aug 2021 12:40:59 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y2sm336118pfe.146.2021.08.11.12.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 12:40:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: remove IRQ aspect of io_ring_ctx completion lock
Date:   Wed, 11 Aug 2021 13:40:53 -0600
Message-Id: <20210811194053.767588-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210811194053.767588-1-axboe@kernel.dk>
References: <20210811194053.767588-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have no hard/soft IRQ users of this lock left, remove any IRQ
disabling/saving and restoring when grabbing this lock.

This is straight forward with no users entering with IRQs disabled
anymore, the only thing to look out for is the waitqueue poll head
lock which nests inside the completion lock. That needs IRQs disabled,
and hence we have to do that now instead of relying on the outer lock
doing so.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 149 ++++++++++++++++++++++++--------------------------
 1 file changed, 72 insertions(+), 77 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d1dac7adbec6..08025ef39d7b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1290,10 +1290,10 @@ static void io_prep_async_link(struct io_kiocb *req)
 	if (req->flags & REQ_F_LINK_TIMEOUT) {
 		struct io_ring_ctx *ctx = req->ctx;
 
-		spin_lock_irq(&ctx->completion_lock);
+		spin_lock(&ctx->completion_lock);
 		io_for_each_link(cur, req)
 			io_prep_async_work(cur);
-		spin_unlock_irq(&ctx->completion_lock);
+		spin_unlock(&ctx->completion_lock);
 	} else {
 		io_for_each_link(cur, req)
 			io_prep_async_work(cur);
@@ -1477,14 +1477,13 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 /* Returns true if there are no backlogged entries after the flush */
 static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
-	unsigned long flags;
 	bool all_flushed, posted;
 
 	if (!force && __io_cqring_events(ctx) == ctx->cq_entries)
 		return false;
 
 	posted = false;
-	spin_lock_irqsave(&ctx->completion_lock, flags);
+	spin_lock(&ctx->completion_lock);
 	while (!list_empty(&ctx->cq_overflow_list)) {
 		struct io_uring_cqe *cqe = io_get_cqe(ctx);
 		struct io_overflow_cqe *ocqe;
@@ -1512,7 +1511,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 
 	if (posted)
 		io_commit_cqring(ctx);
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	spin_unlock(&ctx->completion_lock);
 	if (posted)
 		io_cqring_ev_posted(ctx);
 	return all_flushed;
@@ -1641,9 +1640,8 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 				 unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->completion_lock, flags);
+	spin_lock(&ctx->completion_lock);
 	__io_cqring_fill_event(ctx, req->user_data, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
@@ -1667,7 +1665,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 			req = NULL;
 	}
 	io_commit_cqring(ctx);
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	spin_unlock(&ctx->completion_lock);
 
 	if (req) {
 		io_cqring_ev_posted(ctx);
@@ -1727,10 +1725,10 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
 static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
 					struct io_submit_state *state)
 {
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	list_splice_init(&ctx->locked_free_list, &state->free_list);
 	ctx->locked_free_nr = 0;
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 }
 
 /* Returns true IFF there are requests in the cache */
@@ -1820,15 +1818,14 @@ static void io_dismantle_req(struct io_kiocb *req)
 static void __io_free_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned long flags;
 
 	io_dismantle_req(req);
 	io_put_task(req->task, 1);
 
-	spin_lock_irqsave(&ctx->completion_lock, flags);
+	spin_lock(&ctx->completion_lock);
 	list_add(&req->inflight_entry, &ctx->locked_free_list);
 	ctx->locked_free_nr++;
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	spin_unlock(&ctx->completion_lock);
 
 	percpu_ref_put(&ctx->refs);
 }
@@ -1915,14 +1912,13 @@ static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
 	 */
 	if (req->flags & (REQ_F_LINK_TIMEOUT | REQ_F_FAIL)) {
 		struct io_ring_ctx *ctx = req->ctx;
-		unsigned long flags;
 		bool posted;
 
-		spin_lock_irqsave(&ctx->completion_lock, flags);
+		spin_lock(&ctx->completion_lock);
 		posted = io_disarm_next(req);
 		if (posted)
 			io_commit_cqring(req->ctx);
-		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+		spin_unlock(&ctx->completion_lock);
 		if (posted)
 			io_cqring_ev_posted(ctx);
 	}
@@ -2144,7 +2140,7 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 	int i, nr = state->compl_nr;
 	struct req_batch rb;
 
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	for (i = 0; i < nr; i++) {
 		struct io_kiocb *req = state->compl_reqs[i];
 
@@ -2152,7 +2148,7 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 					req->compl.cflags);
 	}
 	io_commit_cqring(ctx);
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
 
 	io_init_req_batch(&rb);
@@ -4857,7 +4853,7 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 		req->result = vfs_poll(req->file, &pt) & poll->events;
 	}
 
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	if (!req->result && !READ_ONCE(poll->canceled)) {
 		add_wait_queue(poll->head, &poll->wait);
 		return true;
@@ -4891,12 +4887,12 @@ static void io_poll_remove_double(struct io_kiocb *req)
 	if (poll && poll->head) {
 		struct wait_queue_head *head = poll->head;
 
-		spin_lock(&head->lock);
+		spin_lock_irq(&head->lock);
 		list_del_init(&poll->wait.entry);
 		if (poll->wait.private)
 			req_ref_put(req);
 		poll->head = NULL;
-		spin_unlock(&head->lock);
+		spin_unlock_irq(&head->lock);
 	}
 }
 
@@ -4932,7 +4928,7 @@ static void io_poll_task_func(struct io_kiocb *req)
 	struct io_kiocb *nxt;
 
 	if (io_poll_rewait(req, &req->poll)) {
-		spin_unlock_irq(&ctx->completion_lock);
+		spin_unlock(&ctx->completion_lock);
 	} else {
 		bool done;
 
@@ -4944,7 +4940,7 @@ static void io_poll_task_func(struct io_kiocb *req)
 			req->result = 0;
 			add_wait_queue(req->poll.head, &req->poll.wait);
 		}
-		spin_unlock_irq(&ctx->completion_lock);
+		spin_unlock(&ctx->completion_lock);
 		io_cqring_ev_posted(ctx);
 
 		if (done) {
@@ -4961,6 +4957,7 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 	struct io_kiocb *req = wait->private;
 	struct io_poll_iocb *poll = io_poll_get_single(req);
 	__poll_t mask = key_to_poll(key);
+	unsigned long flags;
 
 	/* for instances that support it check for an event match first: */
 	if (mask && !(mask & poll->events))
@@ -4973,13 +4970,13 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 	if (poll->head) {
 		bool done;
 
-		spin_lock(&poll->head->lock);
+		spin_lock_irqsave(&poll->head->lock, flags);
 		done = list_empty(&poll->wait.entry);
 		if (!done)
 			list_del_init(&poll->wait.entry);
 		/* make sure double remove sees this as being gone */
 		wait->private = NULL;
-		spin_unlock(&poll->head->lock);
+		spin_unlock_irqrestore(&poll->head->lock, flags);
 		if (!done) {
 			/* use wait func handler, so it matches the rq type */
 			poll->wait.func(&poll->wait, mode, sync, key);
@@ -5067,13 +5064,13 @@ static void io_async_task_func(struct io_kiocb *req)
 	trace_io_uring_task_run(req->ctx, req, req->opcode, req->user_data);
 
 	if (io_poll_rewait(req, &apoll->poll)) {
-		spin_unlock_irq(&ctx->completion_lock);
+		spin_unlock(&ctx->completion_lock);
 		return;
 	}
 
 	hash_del(&req->hash_node);
 	io_poll_remove_double(req);
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 
 	if (!READ_ONCE(apoll->poll.canceled))
 		io_req_task_submit(req);
@@ -5125,11 +5122,11 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 	if (unlikely(!ipt->nr_entries) && !ipt->error)
 		ipt->error = -EINVAL;
 
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	if (ipt->error || (mask && (poll->events & EPOLLONESHOT)))
 		io_poll_remove_double(req);
 	if (likely(poll->head)) {
-		spin_lock(&poll->head->lock);
+		spin_lock_irq(&poll->head->lock);
 		if (unlikely(list_empty(&poll->wait.entry))) {
 			if (ipt->error)
 				cancel = true;
@@ -5142,7 +5139,7 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 			WRITE_ONCE(poll->canceled, true);
 		else if (!poll->done) /* actually waiting for an event */
 			io_poll_req_insert(req);
-		spin_unlock(&poll->head->lock);
+		spin_unlock_irq(&poll->head->lock);
 	}
 
 	return mask;
@@ -5198,12 +5195,12 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
 	if (ret || ipt.error) {
-		spin_unlock_irq(&ctx->completion_lock);
+		spin_unlock(&ctx->completion_lock);
 		if (ret)
 			return IO_APOLL_READY;
 		return IO_APOLL_ABORTED;
 	}
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 	trace_io_uring_poll_arm(ctx, req, req->opcode, req->user_data,
 				mask, apoll->poll.events);
 	return IO_APOLL_OK;
@@ -5217,14 +5214,14 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 
 	if (!poll->head)
 		return false;
-	spin_lock(&poll->head->lock);
+	spin_lock_irq(&poll->head->lock);
 	if (do_cancel)
 		WRITE_ONCE(poll->canceled, true);
 	if (!list_empty(&poll->wait.entry)) {
 		list_del_init(&poll->wait.entry);
 		do_complete = true;
 	}
-	spin_unlock(&poll->head->lock);
+	spin_unlock_irq(&poll->head->lock);
 	hash_del(&req->hash_node);
 	return do_complete;
 }
@@ -5260,7 +5257,7 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	struct io_kiocb *req;
 	int posted = 0, i;
 
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
 		struct hlist_head *list;
 
@@ -5270,7 +5267,7 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 				posted += io_poll_remove_one(req);
 		}
 	}
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 
 	if (posted)
 		io_cqring_ev_posted(ctx);
@@ -5408,7 +5405,7 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 		ipt.error = 0;
 		io_poll_complete(req, mask);
 	}
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 
 	if (mask) {
 		io_cqring_ev_posted(ctx);
@@ -5425,7 +5422,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 	bool completing;
 	int ret;
 
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	preq = io_poll_find(ctx, req->poll_update.old_user_data, true);
 	if (!preq) {
 		ret = -ENOENT;
@@ -5452,7 +5449,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 	ret = 0;
 err:
 	if (ret < 0) {
-		spin_unlock_irq(&ctx->completion_lock);
+		spin_unlock(&ctx->completion_lock);
 		req_set_fail(req);
 		io_req_complete(req, ret);
 		return 0;
@@ -5465,7 +5462,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 	}
 	if (req->poll_update.update_user_data)
 		preq->user_data = req->poll_update.new_user_data;
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 
 	/* complete update request, we're done with it */
 	io_req_complete(req, ret);
@@ -5484,10 +5481,10 @@ static void io_req_task_timeout(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	io_cqring_fill_event(ctx, req->user_data, -ETIME, 0);
 	io_commit_cqring(ctx);
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 
 	io_cqring_ev_posted(ctx);
 	req_set_fail(req);
@@ -5619,10 +5616,10 @@ static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 					io_translate_timeout_mode(tr->flags));
 	spin_unlock_irq(&ctx->timeout_lock);
 
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	io_cqring_fill_event(ctx, req->user_data, ret, 0);
 	io_commit_cqring(ctx);
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
 	if (ret < 0)
 		req_set_fail(req);
@@ -5674,7 +5671,7 @@ static int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 	struct list_head *entry;
 	u32 tail, off = req->timeout.off;
 
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 
 	/*
 	 * sqe->off holds how many events that need to occur for this
@@ -5713,7 +5710,7 @@ static int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 	list_add(&req->timeout.list, entry);
 	data->timer.function = io_timeout_fn;
 	hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), data->mode);
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 	return 0;
 }
 
@@ -5760,16 +5757,15 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 				     struct io_kiocb *req, __u64 sqe_addr,
 				     int success_ret)
 {
-	unsigned long flags;
 	int ret;
 
 	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
-	spin_lock_irqsave(&ctx->completion_lock, flags);
+	spin_lock(&ctx->completion_lock);
 	if (ret != -ENOENT)
 		goto done;
-	spin_lock(&ctx->timeout_lock);
+	spin_lock_irq(&ctx->timeout_lock);
 	ret = io_timeout_cancel(ctx, sqe_addr);
-	spin_unlock(&ctx->timeout_lock);
+	spin_unlock_irq(&ctx->timeout_lock);
 	if (ret != -ENOENT)
 		goto done;
 	ret = io_poll_cancel(ctx, sqe_addr, false);
@@ -5778,7 +5774,7 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 		ret = success_ret;
 	io_cqring_fill_event(ctx, req->user_data, ret, 0);
 	io_commit_cqring(ctx);
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
 
 	if (ret < 0)
@@ -5808,18 +5804,18 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 
 	/* tasks should wait for their io-wq threads, so safe w/o sync */
 	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	if (ret != -ENOENT)
 		goto done;
-	spin_lock(&ctx->timeout_lock);
+	spin_lock_irq(&ctx->timeout_lock);
 	ret = io_timeout_cancel(ctx, sqe_addr);
-	spin_unlock(&ctx->timeout_lock);
+	spin_unlock_irq(&ctx->timeout_lock);
 	if (ret != -ENOENT)
 		goto done;
 	ret = io_poll_cancel(ctx, sqe_addr, false);
 	if (ret != -ENOENT)
 		goto done;
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 
 	/* slow path, try all io-wq's */
 	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
@@ -5833,11 +5829,11 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	}
 	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
 
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 done:
 	io_cqring_fill_event(ctx, req->user_data, ret, 0);
 	io_commit_cqring(ctx);
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
 
 	if (ret < 0)
@@ -6053,9 +6049,9 @@ static bool io_drain_req(struct io_kiocb *req)
 		return true;
 	}
 
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	if (!req_need_defer(req, seq) && list_empty(&ctx->defer_list)) {
-		spin_unlock_irq(&ctx->completion_lock);
+		spin_unlock(&ctx->completion_lock);
 		kfree(de);
 		io_queue_async_work(req);
 		return true;
@@ -6065,7 +6061,7 @@ static bool io_drain_req(struct io_kiocb *req)
 	de->req = req;
 	de->seq = seq;
 	list_add_tail(&de->list, &ctx->defer_list);
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 	return true;
 }
 
@@ -6805,18 +6801,18 @@ static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
 static inline void io_ring_set_wakeup_flag(struct io_ring_ctx *ctx)
 {
 	/* Tell userspace we may need a wakeup call */
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	WRITE_ONCE(ctx->rings->sq_flags,
 		   ctx->rings->sq_flags | IORING_SQ_NEED_WAKEUP);
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 }
 
 static inline void io_ring_clear_wakeup_flag(struct io_ring_ctx *ctx)
 {
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	WRITE_ONCE(ctx->rings->sq_flags,
 		   ctx->rings->sq_flags & ~IORING_SQ_NEED_WAKEUP);
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 }
 
 static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
@@ -7663,11 +7659,11 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 			bool lock_ring = ctx->flags & IORING_SETUP_IOPOLL;
 
 			io_ring_submit_lock(ctx, lock_ring);
-			spin_lock_irq(&ctx->completion_lock);
+			spin_lock(&ctx->completion_lock);
 			io_cqring_fill_event(ctx, prsrc->tag, 0, 0);
 			ctx->cq_extra++;
 			io_commit_cqring(ctx);
-			spin_unlock_irq(&ctx->completion_lock);
+			spin_unlock(&ctx->completion_lock);
 			io_cqring_ev_posted(ctx);
 			io_ring_submit_unlock(ctx, lock_ring);
 		}
@@ -8838,8 +8834,8 @@ static void io_ring_exit_work(struct work_struct *work)
 		mutex_lock(&ctx->uring_lock);
 	}
 	mutex_unlock(&ctx->uring_lock);
-	spin_lock_irq(&ctx->completion_lock);
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 
 	io_ring_ctx_free(ctx);
 }
@@ -8851,7 +8847,7 @@ static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	struct io_kiocb *req, *tmp;
 	int canceled = 0;
 
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
 		if (io_match_task(req, tsk, cancel_all)) {
 			io_kill_timeout(req, -ECANCELED);
@@ -8860,7 +8856,7 @@ static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	}
 	if (canceled != 0)
 		io_commit_cqring(ctx);
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 	if (canceled != 0)
 		io_cqring_ev_posted(ctx);
 	return canceled != 0;
@@ -8916,13 +8912,12 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 	bool ret;
 
 	if (!cancel->all && (req->flags & REQ_F_LINK_TIMEOUT)) {
-		unsigned long flags;
 		struct io_ring_ctx *ctx = req->ctx;
 
 		/* protect against races with linked timeouts */
-		spin_lock_irqsave(&ctx->completion_lock, flags);
+		spin_lock(&ctx->completion_lock);
 		ret = io_match_task(req, cancel->task, cancel->all);
-		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+		spin_unlock(&ctx->completion_lock);
 	} else {
 		ret = io_match_task(req, cancel->task, cancel->all);
 	}
@@ -8935,14 +8930,14 @@ static bool io_cancel_defer_files(struct io_ring_ctx *ctx,
 	struct io_defer_entry *de;
 	LIST_HEAD(list);
 
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
 		if (io_match_task(de->req, task, cancel_all)) {
 			list_cut_position(&list, &ctx->defer_list, &de->list);
 			break;
 		}
 	}
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 	if (list_empty(&list))
 		return false;
 
@@ -9491,7 +9486,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 			io_uring_show_cred(m, index, cred);
 	}
 	seq_printf(m, "PollList:\n");
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock(&ctx->completion_lock);
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
 		struct hlist_head *list = &ctx->cancel_hash[i];
 		struct io_kiocb *req;
@@ -9500,7 +9495,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 			seq_printf(m, "  op=%d, task_works=%d\n", req->opcode,
 					req->task->task_works != NULL);
 	}
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
 	if (has_lock)
 		mutex_unlock(&ctx->uring_lock);
 }
-- 
2.32.0

