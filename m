Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BB06CA93A
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 17:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbjC0Pjf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 11:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbjC0Pje (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 11:39:34 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8A1F9
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 08:39:32 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r11so37972527edd.5
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 08:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679931570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C18qhnSPh0Y8oB8/t1D4NlnSRxwEhCzdPTQNdgnHEic=;
        b=gNeB8qQiMH3NoSmdW3Z+Epi3EFtt0HAFkaJt9alLb8GEUy13coEnnczQo8J6Og80Vg
         KAFr+sH/BwLH5U22DEh1qofmQvpNuO8IYESl/RryWNUjLn8BM/LWArpm4VJ63iPvpteV
         cdloMQX7AFhorgrtEAp2gxZx/+/qL3XluDeT6bIHu7S1DOHmBmMLiGk3v3SPCffF5fZn
         VRgrLzvSfkwej4CsdPEMdSDu5x0wMnWQQbvj27OY4WBw3jyo//MMAqogGz714gftO43O
         yRAn6/2Putg05RlwWQ3NZYhJvGKq9ST5+OlALRHelQK+Ele1ouJFKgwc9G+AqtF4IzN1
         NHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679931570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C18qhnSPh0Y8oB8/t1D4NlnSRxwEhCzdPTQNdgnHEic=;
        b=vQvEDD2XL/aAjjJI5r6AW5jttGrmESzAHv6tKaeYTtf7YmtUym8uUIfdG+KEeQpFc6
         hKC1cFoGhpFrlIGP/nEwtJ+JUhFB9UmrgtX9kLiv9dleXpvz0zEd+zfFCPQE+9NGGLE/
         qARP1yXW7Jzku84SXaezpEf7mTtSd1GLWjvwMEO6X+UAspa9Tv3bykIHlkJeRLXikYaL
         EOXl0Qu50B04y7kEfEnjL1WdeRzwMrRzJf+g7QTQRf7EiEVogchYnCDFRp77ODccTrxP
         6Q7xEgUvqYA1SgNhlov3v0/vMRsuuxy/m3iq1d8PhoZyyk77xUeZW1roe7yPBU0ujPAX
         X9WQ==
X-Gm-Message-State: AAQBX9eGBwJ7VKG/fYuTzkPeF5IlirhSjjuHfRt9eaqvr0p5Bi8jL0om
        PyneIxzXQ+t5uMzgeWswLunJqZa26zc=
X-Google-Smtp-Source: AKy350awDX1sC9MqW9on+EWbf70VI70IW+i/JZuC4hRIqrbxPbC67mbwrFvcciNkpnIK6IjQaboVkg==
X-Received: by 2002:a17:907:9865:b0:91f:c7e:22ba with SMTP id ko5-20020a170907986500b0091f0c7e22bamr12178065ejc.27.1679931570470;
        Mon, 27 Mar 2023 08:39:30 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:e437])
        by smtp.gmail.com with ESMTPSA id lx12-20020a170906af0c00b008e57b5e0ce9sm14055073ejb.108.2023.03.27.08.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 08:39:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring: encapsulate task_work state
Date:   Mon, 27 Mar 2023 16:38:15 +0100
Message-Id: <25d7bf07b55ec08e19ca2e39ce1260a57d0c1dfb.1679931367.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1679931367.git.asml.silence@gmail.com>
References: <cover.1679931367.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For task works we're passing around a bool pointer for whether the
current ring is locked or not, let's wrap it in a structure, that
will make it more opaque preventing abuse and will also help us
to pass more info in the future if needed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  7 +++-
 io_uring/io_uring.c            | 71 +++++++++++++++++-----------------
 io_uring/io_uring.h            | 14 +++----
 io_uring/notif.c               |  4 +-
 io_uring/poll.c                | 32 +++++++--------
 io_uring/rw.c                  |  6 +--
 io_uring/timeout.c             | 14 +++----
 io_uring/uring_cmd.c           |  2 +-
 8 files changed, 78 insertions(+), 72 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3d152bdcd30a..561fa421c453 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -367,6 +367,11 @@ struct io_ring_ctx {
 	unsigned			evfd_last_cq_tail;
 };
 
+struct io_tw_state {
+	/* ->uring_lock is taken, callbacks can use io_tw_lock to lock it */
+	bool locked;
+};
+
 enum {
 	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
 	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
@@ -473,7 +478,7 @@ enum {
 	REQ_F_HASH_LOCKED	= BIT(REQ_F_HASH_LOCKED_BIT),
 };
 
-typedef void (*io_req_tw_func_t)(struct io_kiocb *req, bool *locked);
+typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
 
 struct io_task_work {
 	struct llist_node		node;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2669aca0ba39..536940675c67 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -247,12 +247,12 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 						fallback_work.work);
 	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
 	struct io_kiocb *req, *tmp;
-	bool locked = true;
+	struct io_tw_state ts = { .locked = true, };
 
 	mutex_lock(&ctx->uring_lock);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
-		req->io_task_work.func(req, &locked);
-	if (WARN_ON_ONCE(!locked))
+		req->io_task_work.func(req, &ts);
+	if (WARN_ON_ONCE(!ts.locked))
 		return;
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
@@ -457,7 +457,7 @@ static void io_prep_async_link(struct io_kiocb *req)
 	}
 }
 
-void io_queue_iowq(struct io_kiocb *req, bool *dont_use)
+void io_queue_iowq(struct io_kiocb *req, struct io_tw_state *ts_dont_use)
 {
 	struct io_kiocb *link = io_prep_linked_timeout(req);
 	struct io_uring_task *tctx = req->task->io_uring;
@@ -1153,22 +1153,23 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	return nxt;
 }
 
-static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
+static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 {
 	if (!ctx)
 		return;
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
-	if (*locked) {
+	if (ts->locked) {
 		io_submit_flush_completions(ctx);
 		mutex_unlock(&ctx->uring_lock);
-		*locked = false;
+		ts->locked = false;
 	}
 	percpu_ref_put(&ctx->refs);
 }
 
 static unsigned int handle_tw_list(struct llist_node *node,
-				   struct io_ring_ctx **ctx, bool *locked,
+				   struct io_ring_ctx **ctx,
+				   struct io_tw_state *ts,
 				   struct llist_node *last)
 {
 	unsigned int count = 0;
@@ -1181,17 +1182,17 @@ static unsigned int handle_tw_list(struct llist_node *node,
 		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
 
 		if (req->ctx != *ctx) {
-			ctx_flush_and_put(*ctx, locked);
+			ctx_flush_and_put(*ctx, ts);
 			*ctx = req->ctx;
 			/* if not contended, grab and improve batching */
-			*locked = mutex_trylock(&(*ctx)->uring_lock);
+			ts->locked = mutex_trylock(&(*ctx)->uring_lock);
 			percpu_ref_get(&(*ctx)->refs);
 		}
-		req->io_task_work.func(req, locked);
+		req->io_task_work.func(req, ts);
 		node = next;
 		count++;
 		if (unlikely(need_resched())) {
-			ctx_flush_and_put(*ctx, locked);
+			ctx_flush_and_put(*ctx, ts);
 			*ctx = NULL;
 			cond_resched();
 		}
@@ -1232,7 +1233,7 @@ static inline struct llist_node *io_llist_cmpxchg(struct llist_head *head,
 
 void tctx_task_work(struct callback_head *cb)
 {
-	bool uring_locked = false;
+	struct io_tw_state ts = {};
 	struct io_ring_ctx *ctx = NULL;
 	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
 						  task_work);
@@ -1249,12 +1250,12 @@ void tctx_task_work(struct callback_head *cb)
 	do {
 		loops++;
 		node = io_llist_xchg(&tctx->task_list, &fake);
-		count += handle_tw_list(node, &ctx, &uring_locked, &fake);
+		count += handle_tw_list(node, &ctx, &ts, &fake);
 
 		/* skip expensive cmpxchg if there are items in the list */
 		if (READ_ONCE(tctx->task_list.first) != &fake)
 			continue;
-		if (uring_locked && !wq_list_empty(&ctx->submit_state.compl_reqs)) {
+		if (ts.locked && !wq_list_empty(&ctx->submit_state.compl_reqs)) {
 			io_submit_flush_completions(ctx);
 			if (READ_ONCE(tctx->task_list.first) != &fake)
 				continue;
@@ -1262,7 +1263,7 @@ void tctx_task_work(struct callback_head *cb)
 		node = io_llist_cmpxchg(&tctx->task_list, &fake, NULL);
 	} while (node != &fake);
 
-	ctx_flush_and_put(ctx, &uring_locked);
+	ctx_flush_and_put(ctx, &ts);
 
 	/* relaxed read is enough as only the task itself sets ->in_cancel */
 	if (unlikely(atomic_read(&tctx->in_cancel)))
@@ -1351,7 +1352,7 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 	}
 }
 
-static int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
+static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 {
 	struct llist_node *node;
 	unsigned int loops = 0;
@@ -1368,7 +1369,7 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
 		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
-		req->io_task_work.func(req, locked);
+		req->io_task_work.func(req, ts);
 		ret++;
 		node = next;
 	}
@@ -1376,7 +1377,7 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
 
 	if (!llist_empty(&ctx->work_llist))
 		goto again;
-	if (*locked) {
+	if (ts->locked) {
 		io_submit_flush_completions(ctx);
 		if (!llist_empty(&ctx->work_llist))
 			goto again;
@@ -1387,46 +1388,46 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
 
 static inline int io_run_local_work_locked(struct io_ring_ctx *ctx)
 {
-	bool locked;
+	struct io_tw_state ts = { .locked = true, };
 	int ret;
 
 	if (llist_empty(&ctx->work_llist))
 		return 0;
 
-	locked = true;
-	ret = __io_run_local_work(ctx, &locked);
+	ret = __io_run_local_work(ctx, &ts);
 	/* shouldn't happen! */
-	if (WARN_ON_ONCE(!locked))
+	if (WARN_ON_ONCE(!ts.locked))
 		mutex_lock(&ctx->uring_lock);
 	return ret;
 }
 
 static int io_run_local_work(struct io_ring_ctx *ctx)
 {
-	bool locked = mutex_trylock(&ctx->uring_lock);
+	struct io_tw_state ts = {};
 	int ret;
 
-	ret = __io_run_local_work(ctx, &locked);
-	if (locked)
+	ts.locked = mutex_trylock(&ctx->uring_lock);
+	ret = __io_run_local_work(ctx, &ts);
+	if (ts.locked)
 		mutex_unlock(&ctx->uring_lock);
 
 	return ret;
 }
 
-static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
+static void io_req_task_cancel(struct io_kiocb *req, struct io_tw_state *ts)
 {
-	io_tw_lock(req->ctx, locked);
+	io_tw_lock(req->ctx, ts);
 	io_req_defer_failed(req, req->cqe.res);
 }
 
-void io_req_task_submit(struct io_kiocb *req, bool *locked)
+void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts)
 {
-	io_tw_lock(req->ctx, locked);
+	io_tw_lock(req->ctx, ts);
 	/* req->task == current here, checking PF_EXITING is safe */
 	if (unlikely(req->task->flags & PF_EXITING))
 		io_req_defer_failed(req, -EFAULT);
 	else if (req->flags & REQ_F_FORCE_ASYNC)
-		io_queue_iowq(req, locked);
+		io_queue_iowq(req, ts);
 	else
 		io_queue_sqe(req);
 }
@@ -1652,9 +1653,9 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 	return ret;
 }
 
-void io_req_task_complete(struct io_kiocb *req, bool *locked)
+void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
-	if (*locked)
+	if (ts->locked)
 		io_req_complete_defer(req);
 	else
 		io_req_complete_post(req, IO_URING_F_UNLOCKED);
@@ -1933,9 +1934,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-int io_poll_issue(struct io_kiocb *req, bool *locked)
+int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts)
 {
-	io_tw_lock(req->ctx, locked);
+	io_tw_lock(req->ctx, ts);
 	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_MULTISHOT|
 				 IO_URING_F_COMPLETE_DEFER);
 }
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2711865f1e19..c33f719731ac 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -52,16 +52,16 @@ void __io_req_task_work_add(struct io_kiocb *req, bool allow_local);
 bool io_is_uring_fops(struct file *file);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
-void io_queue_iowq(struct io_kiocb *req, bool *dont_use);
-void io_req_task_complete(struct io_kiocb *req, bool *locked);
+void io_queue_iowq(struct io_kiocb *req, struct io_tw_state *ts_dont_use);
+void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
-void io_req_task_submit(struct io_kiocb *req, bool *locked);
+void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts);
 void tctx_task_work(struct callback_head *cb);
 __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 int io_uring_alloc_task_context(struct task_struct *task,
 				struct io_ring_ctx *ctx);
 
-int io_poll_issue(struct io_kiocb *req, bool *locked);
+int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts);
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin);
 void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node);
@@ -299,11 +299,11 @@ static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 	return task_work_pending(current) || !wq_list_empty(&ctx->work_llist);
 }
 
-static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
+static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 {
-	if (!*locked) {
+	if (!ts->locked) {
 		mutex_lock(&ctx->uring_lock);
-		*locked = true;
+		ts->locked = true;
 	}
 }
 
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 09dfd0832d19..172105eb347d 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -9,7 +9,7 @@
 #include "notif.h"
 #include "rsrc.h"
 
-static void io_notif_complete_tw_ext(struct io_kiocb *notif, bool *locked)
+static void io_notif_complete_tw_ext(struct io_kiocb *notif, struct io_tw_state *ts)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
 	struct io_ring_ctx *ctx = notif->ctx;
@@ -21,7 +21,7 @@ static void io_notif_complete_tw_ext(struct io_kiocb *notif, bool *locked)
 		__io_unaccount_mem(ctx->user, nd->account_pages);
 		nd->account_pages = 0;
 	}
-	io_req_task_complete(notif, locked);
+	io_req_task_complete(notif, ts);
 }
 
 static void io_tx_ubuf_callback(struct sk_buff *skb, struct ubuf_info *uarg,
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 795facbd0e9f..37513fb38fad 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -148,7 +148,7 @@ static void io_poll_req_insert_locked(struct io_kiocb *req)
 	hlist_add_head(&req->hash_node, &table->hbs[index].list);
 }
 
-static void io_poll_tw_hash_eject(struct io_kiocb *req, bool *locked)
+static void io_poll_tw_hash_eject(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -159,7 +159,7 @@ static void io_poll_tw_hash_eject(struct io_kiocb *req, bool *locked)
 		 * already grabbed the mutex for us, but there is a chance it
 		 * failed.
 		 */
-		io_tw_lock(ctx, locked);
+		io_tw_lock(ctx, ts);
 		hash_del(&req->hash_node);
 		req->flags &= ~REQ_F_HASH_LOCKED;
 	} else {
@@ -238,7 +238,7 @@ enum {
  * req->cqe.res. IOU_POLL_REMOVE_POLL_USE_RES indicates to remove multishot
  * poll and that the result is stored in req->cqe.
  */
-static int io_poll_check_events(struct io_kiocb *req, bool *locked)
+static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	int v;
 
@@ -300,13 +300,13 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 			__poll_t mask = mangle_poll(req->cqe.res &
 						    req->apoll_events);
 
-			if (!io_aux_cqe(req->ctx, *locked, req->cqe.user_data,
+			if (!io_aux_cqe(req->ctx, ts->locked, req->cqe.user_data,
 					mask, IORING_CQE_F_MORE, false)) {
 				io_req_set_res(req, mask, 0);
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
 		} else {
-			int ret = io_poll_issue(req, locked);
+			int ret = io_poll_issue(req, ts);
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			if (ret < 0)
@@ -326,15 +326,15 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 	return IOU_POLL_NO_ACTION;
 }
 
-static void io_poll_task_func(struct io_kiocb *req, bool *locked)
+static void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	int ret;
 
-	ret = io_poll_check_events(req, locked);
+	ret = io_poll_check_events(req, ts);
 	if (ret == IOU_POLL_NO_ACTION)
 		return;
 	io_poll_remove_entries(req);
-	io_poll_tw_hash_eject(req, locked);
+	io_poll_tw_hash_eject(req, ts);
 
 	if (req->opcode == IORING_OP_POLL_ADD) {
 		if (ret == IOU_POLL_DONE) {
@@ -343,7 +343,7 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 			poll = io_kiocb_to_cmd(req, struct io_poll);
 			req->cqe.res = mangle_poll(req->cqe.res & poll->events);
 		} else if (ret == IOU_POLL_REISSUE) {
-			io_req_task_submit(req, locked);
+			io_req_task_submit(req, ts);
 			return;
 		} else if (ret != IOU_POLL_REMOVE_POLL_USE_RES) {
 			req->cqe.res = ret;
@@ -351,14 +351,14 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 		}
 
 		io_req_set_res(req, req->cqe.res, 0);
-		io_req_task_complete(req, locked);
+		io_req_task_complete(req, ts);
 	} else {
-		io_tw_lock(req->ctx, locked);
+		io_tw_lock(req->ctx, ts);
 
 		if (ret == IOU_POLL_REMOVE_POLL_USE_RES)
-			io_req_task_complete(req, locked);
+			io_req_task_complete(req, ts);
 		else if (ret == IOU_POLL_DONE || ret == IOU_POLL_REISSUE)
-			io_req_task_submit(req, locked);
+			io_req_task_submit(req, ts);
 		else
 			io_req_defer_failed(req, ret);
 	}
@@ -976,7 +976,7 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_hash_bucket *bucket;
 	struct io_kiocb *preq;
 	int ret2, ret = 0;
-	bool locked;
+	struct io_tw_state ts = {};
 
 	preq = io_poll_find(ctx, true, &cd, &ctx->cancel_table, &bucket);
 	ret2 = io_poll_disarm(preq);
@@ -1026,8 +1026,8 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 
 	req_set_fail(preq);
 	io_req_set_res(preq, -ECANCELED, 0);
-	locked = !(issue_flags & IO_URING_F_UNLOCKED);
-	io_req_task_complete(preq, &locked);
+	ts.locked = !(issue_flags & IO_URING_F_UNLOCKED);
+	io_req_task_complete(preq, &ts);
 out:
 	if (ret < 0) {
 		req_set_fail(req);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 8f3b86c20075..0200f563a98f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -283,16 +283,16 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 	return res;
 }
 
-static void io_req_rw_complete(struct io_kiocb *req, bool *locked)
+static void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	io_req_io_end(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
-		unsigned issue_flags = *locked ? 0 : IO_URING_F_UNLOCKED;
+		unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
 
 		req->cqe.flags |= io_put_kbuf(req, issue_flags);
 	}
-	io_req_task_complete(req, locked);
+	io_req_task_complete(req, ts);
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res)
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 826a51bca3e4..5c6c6f720809 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -101,9 +101,9 @@ __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 	spin_unlock_irq(&ctx->timeout_lock);
 }
 
-static void io_req_tw_fail_links(struct io_kiocb *link, bool *locked)
+static void io_req_tw_fail_links(struct io_kiocb *link, struct io_tw_state *ts)
 {
-	io_tw_lock(link->ctx, locked);
+	io_tw_lock(link->ctx, ts);
 	while (link) {
 		struct io_kiocb *nxt = link->link;
 		long res = -ECANCELED;
@@ -112,7 +112,7 @@ static void io_req_tw_fail_links(struct io_kiocb *link, bool *locked)
 			res = link->cqe.res;
 		link->link = NULL;
 		io_req_set_res(link, res, 0);
-		io_req_task_complete(link, locked);
+		io_req_task_complete(link, ts);
 		link = nxt;
 	}
 }
@@ -265,9 +265,9 @@ int io_timeout_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 	return 0;
 }
 
-static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
+static void io_req_task_link_timeout(struct io_kiocb *req, struct io_tw_state *ts)
 {
-	unsigned issue_flags = *locked ? 0 : IO_URING_F_UNLOCKED;
+	unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_kiocb *prev = timeout->prev;
 	int ret = -ENOENT;
@@ -282,11 +282,11 @@ static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 			ret = io_try_cancel(req->task->io_uring, &cd, issue_flags);
 		}
 		io_req_set_res(req, ret ?: -ETIME, 0);
-		io_req_task_complete(req, locked);
+		io_req_task_complete(req, ts);
 		io_put_req(prev);
 	} else {
 		io_req_set_res(req, -ETIME, 0);
-		io_req_task_complete(req, locked);
+		io_req_task_complete(req, ts);
 	}
 }
 
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 2e4c483075d3..871ce53fe833 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -12,7 +12,7 @@
 #include "rsrc.h"
 #include "uring_cmd.h"
 
-static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
+static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 
-- 
2.39.1

