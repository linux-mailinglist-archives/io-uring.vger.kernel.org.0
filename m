Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5E350A116
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 15:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386713AbiDUNsM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 09:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386772AbiDUNsL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 09:48:11 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9480B1C3
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:19 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id u17-20020a05600c211100b0038eaf4cdaaeso5932184wml.1
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PB9POyQ9nWSEKrWVEnmzbo/vhTy+U8yHXmjsWbTC3Pg=;
        b=bJR1T4iKBUWzAcbV9jfxsNhCZaxNmttS1R7gbNpcC8Y0x/VAnpfaMsJeJwTae9H78S
         NPMNiTbw4s+bX7DPI5NgcDgTZptjzTTMPEWsOPIUH7fDuMQSnFAUbJF09AZUJgH6qIeP
         Pt9srmxOaYLyrCW7okZ2bWUjhMw4GZMC4UxYYF/bSZOu4yoNo82xI1al6zWhFXJyLqWI
         5Ryi95zEgW13iLd/T1eK7YGGz36NOEB7AlRvotyRvMYFvq3ofNrdo8z37jf534ofwQyn
         uUvYWp+CKqL21HzTIPMq2igzFHbaRHAljOCVdlc97UJNxf9jHUARbWVGeFAPDDEOFq/h
         r/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PB9POyQ9nWSEKrWVEnmzbo/vhTy+U8yHXmjsWbTC3Pg=;
        b=WvhHHIOd94mf+ZkUIG+c0TCVtDpwgSGlx93aqHp8ZaBSDd6G2qxlP2HrhdMHqxIgXh
         QADCmwnujppyxK0fRSxoSzyDW3YkDmO6r9KOHUClAKN1heddEQ3ixUMHsoHvHN5vvj3X
         lYvrabFboEGmUcxL3qbEOKsfcV13OC5SrGG2k3omcKmA/3s5xYrZsOVn8DwYhMqVeT+N
         eJXxR695WpoJbaMwHPIHuaKs1mlhJfzlIpiwMFOCPDxEX57ESbmxQ8zn07EhtWuegeTd
         3TbN8NcyxI5cla5+/GYinNujLfz2mLn/Gua2AcT3bg95wswSI3x3uuP8qYGEiQ99CMS4
         Ej6Q==
X-Gm-Message-State: AOAM531dHJPYvSiDd8iaTyf2ULaLomSXhcT8dz6BzCf74AUxDSN6IQU6
        Vpa1ghp+Erwct8XIiJV/8zMdShihlTM=
X-Google-Smtp-Source: ABdhPJwlH2RbKx43yo32E4poCNpid8Q0v1FsZGAXkbp+QAUabYKGPE23Vjo2ZvKS3QmsLtkJbIwaWw==
X-Received: by 2002:a05:600c:3641:b0:38e:4b2f:330 with SMTP id y1-20020a05600c364100b0038e4b2f0330mr8780378wmq.180.1650548718208;
        Thu, 21 Apr 2022 06:45:18 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.218])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe0c7000000b002060e7bbe49sm2837821wri.45.2022.04.21.06.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:45:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 11/11] io_uring: lock-free task_work stack
Date:   Thu, 21 Apr 2022 14:44:24 +0100
Message-Id: <c7c3d1a6d7a038f414658314eeeadbbd186c1435.1650548192.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1650548192.git.asml.silence@gmail.com>
References: <cover.1650548192.git.asml.silence@gmail.com>
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

Instead of keeping a list of task_work items keep them in a lock-free
stack. However, we still would like to keep the ordering guarantees, so
reverse the list upon execution in io_uring_task_work_run().

First, for each tw add it a spin_lock/unlock_irq() pair with a single
cmpxchg(). Same on the execution side but per batch. And it also kills
the final lock/unlock at the end of io_uring_task_work_run().

The main downside here is that we need to reverse the tw list on
execution messing up with caches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 120 +++++++++++++++++++++++---------------------------
 1 file changed, 56 insertions(+), 64 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 51b6ee2b70f2..97b5559bb660 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -506,10 +506,8 @@ struct io_uring_task {
 	struct percpu_counter	inflight;
 	atomic_t		in_idle;
 
-	spinlock_t		task_lock;
-	struct io_wq_work_list	task_list;
+	struct io_task_work	*task_list;
 	struct file		**registered_rings;
-	bool			task_running;
 };
 
 /*
@@ -860,7 +858,7 @@ typedef void (*io_req_tw_func_t)(struct io_kiocb *req, bool *locked);
 
 struct io_task_work {
 	union {
-		struct io_wq_work_node	node;
+		struct io_task_work	*next;
 		struct llist_node	fallback_node;
 	};
 	io_req_tw_func_t		func;
@@ -2482,15 +2480,29 @@ static inline void ctx_commit_and_unlock(struct io_ring_ctx *ctx)
 	io_cqring_ev_posted(ctx);
 }
 
-static void handle_tw_list(struct io_wq_work_node *node,
+static struct io_task_work tw_work_exited; /* all we need is ->next == NULL */
+
+static void handle_tw_list(struct io_task_work *node,
 			   struct io_ring_ctx **ctx, bool *locked)
 {
+	struct io_task_work *next;
+	struct io_task_work *prev = NULL;
+
+	/* reverse the list */
+	while (node->next) {
+		next = node->next;
+		node->next = prev;
+		prev = node;
+		node = next;
+	}
+	node->next = prev;
+
 	do {
-		struct io_wq_work_node *next = node->next;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
-						    io_task_work.node);
+						    io_task_work);
 
-		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
+		next = node->next;
+		prefetch(container_of(next, struct io_kiocb, io_task_work));
 
 		if (req->ctx != *ctx) {
 			ctx_flush_and_put(*ctx, locked);
@@ -2511,25 +2523,27 @@ void io_uring_task_work_run(void)
 
 	if (!tctx)
 		return;
+	/*
+	 * The poison is only assigned from the task context we're currently in.
+	 * Nobody can set it while io_uring_task_work_run() is running
+	 */
+	if (READ_ONCE(tctx->task_list) == &tw_work_exited)
+		return;
 
-	while (1) {
-		struct io_wq_work_node *node2;
-
-		spin_lock_irq(&tctx->task_lock);
-		node2 = tctx->task_list.first;
-		INIT_WQ_LIST(&tctx->task_list);
-		if (!node2)
-			tctx->task_running = false;
-		spin_unlock_irq(&tctx->task_lock);
-		if (!node2)
+	do {
+		struct io_task_work *head = xchg(&tctx->task_list, NULL);
+
+		if (unlikely(!head))
 			break;
+		handle_tw_list(head, &ctx, &uring_locked);
 
-		handle_tw_list(node2, &ctx, &uring_locked);
 		cond_resched();
-
-		if (data_race(!tctx->task_list.first) && uring_locked)
-			io_submit_flush_completions(ctx);
-	}
+		if (READ_ONCE(tctx->task_list))
+			continue;
+		if (!uring_locked)
+			break;
+		io_submit_flush_completions(ctx);
+	} while (READ_ONCE(tctx->task_list));
 
 	ctx_flush_and_put(ctx, &uring_locked);
 }
@@ -2538,26 +2552,26 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 {
 	struct task_struct *tsk = req->task;
 	struct io_uring_task *tctx = tsk->io_uring;
-	struct io_wq_work_node *node;
-	unsigned long flags;
-	bool running;
+	struct io_task_work *head;
 
 	WARN_ON_ONCE(!tctx);
 
 	io_drop_inflight_file(req);
 
-	spin_lock_irqsave(&tctx->task_lock, flags);
-	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
-	if (unlikely(atomic_read(&tctx->in_idle)))
-		goto cancel_locked;
+	do {
+		head = READ_ONCE(tctx->task_list);
+		if (unlikely(head == &tw_work_exited)) {
+			req_set_fail(req);
+			if (llist_add(&req->io_task_work.fallback_node,
+				      &req->ctx->fallback_llist))
+				schedule_delayed_work(&req->ctx->fallback_work, 1);
+			return;
+		}
 
-	running = tctx->task_running;
-	if (!running)
-		tctx->task_running = true;
-	spin_unlock_irqrestore(&tctx->task_lock, flags);
+		req->io_task_work.next = head;
+	} while (cmpxchg(&tctx->task_list, head, &req->io_task_work) != head);
 
-	/* task_work already pending, we're done */
-	if (!running) {
+	if (!head) {
 		/*
 		 * SQPOLL kernel thread doesn't need notification, just a wakeup. For
 		 * all other cases, use TWA_SIGNAL unconditionally to ensure we're
@@ -2569,22 +2583,6 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 		else
 			task_work_notify(tsk, TWA_SIGNAL);
 	}
-	return;
-
-	spin_lock_irqsave(&tctx->task_lock, flags);
-cancel_locked:
-	node = tctx->task_list.first;
-	INIT_WQ_LIST(&tctx->task_list);
-	spin_unlock_irqrestore(&tctx->task_lock, flags);
-
-	while (node) {
-		req = container_of(node, struct io_kiocb, io_task_work.node);
-		req_set_fail(req);
-		node = node->next;
-		if (llist_add(&req->io_task_work.fallback_node,
-			      &req->ctx->fallback_llist))
-			schedule_delayed_work(&req->ctx->fallback_work, 1);
-	}
 }
 
 static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
@@ -7977,7 +7975,7 @@ static int io_sq_thread(void *data)
 			if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
 		}
-		if (tctx->task_running) {
+		if (READ_ONCE(tctx->task_list)) {
 			io_uring_task_work_run();
 			sqt_spin = true;
 		}
@@ -7990,7 +7988,7 @@ static int io_sq_thread(void *data)
 		}
 
 		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
-		if (!io_sqd_events_pending(sqd) && !tctx->task_running) {
+		if (!io_sqd_events_pending(sqd) && !READ_ONCE(tctx->task_list)) {
 			bool needs_sched = true;
 
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
@@ -9088,8 +9086,6 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_idle, 0);
 	task->io_uring = tctx;
-	spin_lock_init(&tctx->task_lock);
-	INIT_WQ_LIST(&tctx->task_list);
 	return 0;
 }
 
@@ -10301,16 +10297,16 @@ static __cold void io_uring_cancel_generic(bool cancel_all,
 
 	if (!current->io_uring)
 		return;
+	if (WARN_ON_ONCE(READ_ONCE(tctx->task_list) == &tw_work_exited))
+		return;
 	if (tctx->io_wq)
 		io_wq_exit_start(tctx->io_wq);
+	while (cmpxchg(&tctx->task_list, NULL, &tw_work_exited) != NULL)
+		io_uring_task_work_run();
 
-	spin_lock_irq(&tctx->task_lock);
 	atomic_inc(&tctx->in_idle);
-	spin_unlock_irq(&tctx->task_lock);
-
 	do {
 		io_uring_drop_tctx_refs(current);
-		io_run_task_work();
 		/* read completions before cancelations */
 		inflight = tctx_inflight(tctx, !cancel_all);
 		if (!inflight)
@@ -10335,10 +10331,6 @@ static __cold void io_uring_cancel_generic(bool cancel_all,
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
 		io_run_task_work();
-		if (tctx->task_running) {
-			__set_current_state(TASK_RUNNING);
-			io_uring_task_work_run();
-		}
 		io_uring_drop_tctx_refs(current);
 
 		/*
-- 
2.36.0

