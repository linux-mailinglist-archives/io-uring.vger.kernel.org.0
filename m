Return-Path: <io-uring+bounces-10338-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3831C2DF56
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 21:01:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 461AA1893165
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 20:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF469205E3B;
	Mon,  3 Nov 2025 20:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FOCQLmBr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37C821ABD7
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 20:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762200091; cv=none; b=csp1kRbdqIai8PKuDQt9S/njtZzYToxEqtsW89Hf07glEDMzYmDLRXk/VvV60m4t4QzOhpfOHzyn4NxfHKK2CsSbyoIeUMUd1mlZXZCeAMjMaZL8OP/NDLpjz7qpWJjOk0+OZR5lk6D3h6vCyI/He2GFMmnXiqII8qUoEQe+Nv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762200091; c=relaxed/simple;
	bh=qzldxMMkVoEE2VqY+Ynx7lupxOMCYeivocIeeRnDwvw=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=aCJXQLmZF7nEHYcTKhTlmoZ/LGu1MoyRPzw4tK95vK6RUZQIrtnNzOG62tUaGGM/YJafILRqh67XUcySGwtQni3WNIzgkV1Nqkk2zk3hJRaTlpLjtyhRJ6+PxjUfPjoCT46FukVhKU+W1f983jCI/RVDSmRLj7oic5RxiwzvgBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FOCQLmBr; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-4332381ba9bso26998335ab.1
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 12:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762200086; x=1762804886; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6sqLqs5Tsr9slv9lcK7zA2RSfqsnH5pZFd0NGQUfuQ=;
        b=FOCQLmBrAzKNN2+bYbAnsBcqMSj7mJlZQc5FtgH8NjWr6bTIFJREp5rtpFXuPPy0i8
         62NYD7wMAsqIJ+ie6SM6lYuUunlbbtfrNuzWt3G9G/hedwm6CC9Qg6Fw/iDcg2fan8Wl
         InMOx/doFYVBJyiWqsi5/A+VkfCyr3TQlAUzw+xE/5E3gYgRncARHbtQJRUyD6QQ3qMo
         UfESF+wVXaW8L9u/NFsxJVtUZ6qI/WGsIrkf3YOHM4o8rl/gmNfQSqzQWyPU+Jq8pj2C
         I/R6pto+94hRzbaejIq9IHMfu1mUVP/+kcQDuuzWst79sMQ6WgkX1xvOQmGdU2Y9YeWE
         Jn6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762200086; x=1762804886;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N6sqLqs5Tsr9slv9lcK7zA2RSfqsnH5pZFd0NGQUfuQ=;
        b=TePBcn5TOJNy4qKzZTSEonzd3IlMDkzgk7N4DB7dh0JWtylzKW5HoD7l8e43BB4ITb
         g3/KLJkOhuMiIfK3grz+31YxN1y9amXOzwbHpiecsc2JALT0fGIu5muGlKyZc/ZfecRJ
         HQz7Q/YoV78eLVH224ZURmaepDR5VEi8dIuuKgXfQDIt/Z9XpYNu8uhjY6xWRqYbIXVM
         cpd+A+T8mv5JzxlKI9qcGdSHN5GetjgO28p/oNAm8zYHgWkFS/TXj2jp5z0Uj8HYTOFw
         meYQl6fLFRapoqgT3+/Xg6zUSmAapbqBAgYGRJlA/1sMvjR8LsknOIyIulvBTtSxayzj
         /FEw==
X-Gm-Message-State: AOJu0Yyop1+LEMwKsrr5xg92RQORXag+o7xVZ84ytom+e/GiIbcEq8gp
	fdjcRQkwpVBDsjfi+7K/UtHjv5l1GZzIx3dijSlQIX+KhqIqQE0fSA/79bQPQnCsHlUNIzmgct5
	Uv8Cq
X-Gm-Gg: ASbGncuK6yy43IqQkvA2ct/o/XO2FYkh2tI12aIkV0nMQPaIXO6LEJQG88jVRT6gWDH
	I42Xu9Kb2GE1Vwqee7mqYZQlzxsZqXN7xhMYkUSsgiv1r/BczkHrpX/C/IBwSU/4IvtJgRnTn1K
	qcJzu5rjjAVRAUgr3tqm6cqVWsD8pkmVL41hw/FPbU2Rbkd5WU0isXeopht5KFaD216GYpsk4Og
	TD1BIjB5tPf8AJd+5u4rAGfnFZEyyEQgcZiA/8/eymIZv/cvPtrHPJyUB3kfGOXqBBgQXE/FV99
	s5iLwhLv1vst0lpcV7G5LgJS4QlulJTfSlI3k+I1ppkWgxED8zE7UNjewp5SUfiwYK5i4STUM3i
	nuyZbSO1xtLfwYv49JY6SvpUGMXpYAnBwBl4TPnmNgt6b1fNvjs7ObMSktQJ+nQTkMSN28QjVwV
	ayvsKSo5k=
X-Google-Smtp-Source: AGHT+IFwQJqmJqUa6N5SscvoNWpUUUPiVI28Yd7ua3Pj5fMaMI9pUsrHFvt4fC/InWu8e7jKpJzMdg==
X-Received: by 2002:a05:6e02:160c:b0:433:30d4:389e with SMTP id e9e14a558f8ab-43330d43958mr56215035ab.3.1762200086104;
        Mon, 03 Nov 2025 12:01:26 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43335b5ab8dsm5138955ab.30.2025.11.03.12.01.24
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 12:01:25 -0800 (PST)
Message-ID: <cf58b2cf-7846-4411-a876-db4e14f785b7@kernel.dk>
Date: Mon, 3 Nov 2025 13:01:23 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/cancel: move cancelation code from io_uring.c to
 cancel.c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

There's a bunch of code strictly dealing with cancelations, and that
code really belongs in cancel.c rather than in the core io_uring.c file.
Move the code there. Mostly mechanical, only real oddity here is that
struct io_defer_entry now needs to be visible across both io_uring.c
and cancel.c.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

On top of this series:

https://lore.kernel.org/io-uring/20251103184937.61634-1-axboe@kernel.dk/

and also no functional changes in this patch, just shuffling some
code around, placing it where it makes more sense to have it.

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 3ba82a1bfe80..ca12ac10c0ae 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -14,6 +14,8 @@
 #include "filetable.h"
 #include "io_uring.h"
 #include "tctx.h"
+#include "sqpoll.h"
+#include "uring_cmd.h"
 #include "poll.h"
 #include "timeout.h"
 #include "waitid.h"
@@ -428,3 +430,227 @@ void __io_uring_cancel(bool cancel_all)
 	io_uring_unreg_ringfd();
 	io_uring_cancel_generic(cancel_all, NULL);
 }
+
+struct io_task_cancel {
+	struct io_uring_task *tctx;
+	bool all;
+};
+
+static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_task_cancel *cancel = data;
+
+	return io_match_task_safe(req, cancel->tctx, cancel->all);
+}
+
+static __cold bool io_cancel_defer_files(struct io_ring_ctx *ctx,
+					 struct io_uring_task *tctx,
+					 bool cancel_all)
+{
+	struct io_defer_entry *de;
+	LIST_HEAD(list);
+
+	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
+		if (io_match_task_safe(de->req, tctx, cancel_all)) {
+			list_cut_position(&list, &ctx->defer_list, &de->list);
+			break;
+		}
+	}
+	if (list_empty(&list))
+		return false;
+
+	while (!list_empty(&list)) {
+		de = list_first_entry(&list, struct io_defer_entry, list);
+		list_del_init(&de->list);
+		ctx->nr_drained -= io_linked_nr(de->req);
+		io_req_task_queue_fail(de->req, -ECANCELED);
+		kfree(de);
+	}
+	return true;
+}
+
+__cold bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+
+	return req->ctx == data;
+}
+
+static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
+{
+	struct io_tctx_node *node;
+	enum io_wq_cancel cret;
+	bool ret = false;
+
+	mutex_lock(&ctx->uring_lock);
+	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
+		struct io_uring_task *tctx = node->task->io_uring;
+
+		/*
+		 * io_wq will stay alive while we hold uring_lock, because it's
+		 * killed after ctx nodes, which requires to take the lock.
+		 */
+		if (!tctx || !tctx->io_wq)
+			continue;
+		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_ctx_cb, ctx, true);
+		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
+	}
+	mutex_unlock(&ctx->uring_lock);
+
+	return ret;
+}
+
+__cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
+					 struct io_uring_task *tctx,
+					 bool cancel_all, bool is_sqpoll_thread)
+{
+	struct io_task_cancel cancel = { .tctx = tctx, .all = cancel_all, };
+	enum io_wq_cancel cret;
+	bool ret = false;
+
+	/* set it so io_req_local_work_add() would wake us up */
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+		atomic_set(&ctx->cq_wait_nr, 1);
+		smp_mb();
+	}
+
+	/* failed during ring init, it couldn't have issued any requests */
+	if (!ctx->rings)
+		return false;
+
+	if (!tctx) {
+		ret |= io_uring_try_cancel_iowq(ctx);
+	} else if (tctx->io_wq) {
+		/*
+		 * Cancels requests of all rings, not only @ctx, but
+		 * it's fine as the task is in exit/exec.
+		 */
+		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_task_cb,
+				       &cancel, true);
+		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
+	}
+
+	/* SQPOLL thread does its own polling */
+	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
+	    is_sqpoll_thread) {
+		while (!wq_list_empty(&ctx->iopoll_list)) {
+			io_iopoll_try_reap_events(ctx);
+			ret = true;
+			cond_resched();
+		}
+	}
+
+	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
+	    io_allowed_defer_tw_run(ctx))
+		ret |= io_run_local_work(ctx, INT_MAX, INT_MAX) > 0;
+	mutex_lock(&ctx->uring_lock);
+	ret |= io_cancel_defer_files(ctx, tctx, cancel_all);
+	ret |= io_poll_remove_all(ctx, tctx, cancel_all);
+	ret |= io_waitid_remove_all(ctx, tctx, cancel_all);
+	ret |= io_futex_remove_all(ctx, tctx, cancel_all);
+	ret |= io_uring_try_cancel_uring_cmd(ctx, tctx, cancel_all);
+	mutex_unlock(&ctx->uring_lock);
+	ret |= io_kill_timeouts(ctx, tctx, cancel_all);
+	if (tctx)
+		ret |= io_run_task_work() > 0;
+	else
+		ret |= flush_delayed_work(&ctx->fallback_work);
+	return ret;
+}
+
+static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
+{
+	if (tracked)
+		return atomic_read(&tctx->inflight_tracked);
+	return percpu_counter_sum(&tctx->inflight);
+}
+
+/*
+ * Find any io_uring ctx that this task has registered or done IO on, and cancel
+ * requests. @sqd should be not-null IFF it's an SQPOLL thread cancellation.
+ */
+__cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	struct io_ring_ctx *ctx;
+	struct io_tctx_node *node;
+	unsigned long index;
+	s64 inflight;
+	DEFINE_WAIT(wait);
+
+	WARN_ON_ONCE(sqd && sqpoll_task_locked(sqd) != current);
+
+	if (!current->io_uring)
+		return;
+	if (tctx->io_wq)
+		io_wq_exit_start(tctx->io_wq);
+
+	atomic_inc(&tctx->in_cancel);
+	do {
+		bool loop = false;
+
+		io_uring_drop_tctx_refs(current);
+		if (!tctx_inflight(tctx, !cancel_all))
+			break;
+
+		/* read completions before cancelations */
+		inflight = tctx_inflight(tctx, false);
+		if (!inflight)
+			break;
+
+		if (!sqd) {
+			xa_for_each(&tctx->xa, index, node) {
+				/* sqpoll task will cancel all its requests */
+				if (node->ctx->sq_data)
+					continue;
+				loop |= io_uring_try_cancel_requests(node->ctx,
+							current->io_uring,
+							cancel_all,
+							false);
+			}
+		} else {
+			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+				loop |= io_uring_try_cancel_requests(ctx,
+								     current->io_uring,
+								     cancel_all,
+								     true);
+		}
+
+		if (loop) {
+			cond_resched();
+			continue;
+		}
+
+		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
+		io_run_task_work();
+		io_uring_drop_tctx_refs(current);
+		xa_for_each(&tctx->xa, index, node) {
+			if (io_local_work_pending(node->ctx)) {
+				WARN_ON_ONCE(node->ctx->submitter_task &&
+					     node->ctx->submitter_task != current);
+				goto end_wait;
+			}
+		}
+		/*
+		 * If we've seen completions, retry without waiting. This
+		 * avoids a race where a completion comes in before we did
+		 * prepare_to_wait().
+		 */
+		if (inflight == tctx_inflight(tctx, !cancel_all))
+			schedule();
+end_wait:
+		finish_wait(&tctx->wait, &wait);
+	} while (1);
+
+	io_uring_clean_tctx(tctx);
+	if (cancel_all) {
+		/*
+		 * We shouldn't run task_works after cancel, so just leave
+		 * ->in_cancel set for normal exit.
+		 */
+		atomic_dec(&tctx->in_cancel);
+		/* for exec all current's requests should be gone, kill tctx */
+		__io_uring_free(current);
+	}
+}
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 6d5208e9d7a6..6783961ede1b 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -29,10 +29,14 @@ bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
 bool io_cancel_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			  struct hlist_head *list, bool cancel_all,
 			  bool (*cancel)(struct io_kiocb *));
-
 int io_cancel_remove(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		     unsigned int issue_flags, struct hlist_head *list,
 		     bool (*cancel)(struct io_kiocb *));
+__cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
+					 struct io_uring_task *tctx,
+					 bool cancel_all, bool is_sqpoll_thread);
+__cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
+__cold bool io_cancel_ctx_cb(struct io_wq_work *work, void *data);
 
 static inline bool io_cancel_match_sequence(struct io_kiocb *req, int sequence)
 {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b3be305b99be..3f0489261d11 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -124,11 +124,6 @@
 #define IO_REQ_ALLOC_BATCH		8
 #define IO_LOCAL_TW_DEFAULT_MAX		20
 
-struct io_defer_entry {
-	struct list_head	list;
-	struct io_kiocb		*req;
-};
-
 /* requests with any of those set should undergo io_disarm_next() */
 #define IO_DISARM_MASK (REQ_F_ARM_LTIMEOUT | REQ_F_LINK_TIMEOUT | REQ_F_FAIL)
 
@@ -140,11 +135,6 @@ struct io_defer_entry {
 /* Forced wake up if there is a waiter regardless of ->cq_wait_nr */
 #define IO_CQ_WAKE_FORCE	(IO_CQ_WAKE_INIT >> 1)
 
-static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
-					 struct io_uring_task *tctx,
-					 bool cancel_all,
-					 bool is_sqpoll_thread);
-
 static void io_queue_sqe(struct io_kiocb *req, unsigned int extra_flags);
 static void __io_req_caches_free(struct io_ring_ctx *ctx);
 
@@ -512,7 +502,7 @@ void io_req_queue_iowq(struct io_kiocb *req)
 	io_req_task_work_add(req);
 }
 
-static unsigned io_linked_nr(struct io_kiocb *req)
+unsigned io_linked_nr(struct io_kiocb *req)
 {
 	struct io_kiocb *tmp;
 	unsigned nr = 0;
@@ -681,7 +671,7 @@ void io_task_refs_refill(struct io_uring_task *tctx)
 	tctx->cached_refs += refill;
 }
 
-static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
+__cold void io_uring_drop_tctx_refs(struct task_struct *task)
 {
 	struct io_uring_task *tctx = task->io_uring;
 	unsigned int refs = tctx->cached_refs;
@@ -1409,8 +1399,7 @@ static inline int io_run_local_work_locked(struct io_ring_ctx *ctx,
 					max(IO_LOCAL_TW_DEFAULT_MAX, min_events));
 }
 
-static int io_run_local_work(struct io_ring_ctx *ctx, int min_events,
-			     int max_events)
+int io_run_local_work(struct io_ring_ctx *ctx, int min_events, int max_events)
 {
 	struct io_tw_state ts = {};
 	int ret;
@@ -1564,7 +1553,7 @@ static unsigned io_cqring_events(struct io_ring_ctx *ctx)
  * We can't just wait for polled events to come to us, we have to actively
  * find and complete them.
  */
-static __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
+__cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 {
 	if (!(ctx->flags & IORING_SETUP_IOPOLL))
 		return;
@@ -2978,13 +2967,6 @@ static __cold void io_tctx_exit_cb(struct callback_head *cb)
 	complete(&work->completion);
 }
 
-static __cold bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-
-	return req->ctx == data;
-}
-
 static __cold void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
@@ -3118,224 +3100,6 @@ static int io_uring_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-struct io_task_cancel {
-	struct io_uring_task *tctx;
-	bool all;
-};
-
-static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct io_task_cancel *cancel = data;
-
-	return io_match_task_safe(req, cancel->tctx, cancel->all);
-}
-
-static __cold bool io_cancel_defer_files(struct io_ring_ctx *ctx,
-					 struct io_uring_task *tctx,
-					 bool cancel_all)
-{
-	struct io_defer_entry *de;
-	LIST_HEAD(list);
-
-	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
-		if (io_match_task_safe(de->req, tctx, cancel_all)) {
-			list_cut_position(&list, &ctx->defer_list, &de->list);
-			break;
-		}
-	}
-	if (list_empty(&list))
-		return false;
-
-	while (!list_empty(&list)) {
-		de = list_first_entry(&list, struct io_defer_entry, list);
-		list_del_init(&de->list);
-		ctx->nr_drained -= io_linked_nr(de->req);
-		io_req_task_queue_fail(de->req, -ECANCELED);
-		kfree(de);
-	}
-	return true;
-}
-
-static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
-{
-	struct io_tctx_node *node;
-	enum io_wq_cancel cret;
-	bool ret = false;
-
-	mutex_lock(&ctx->uring_lock);
-	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
-		struct io_uring_task *tctx = node->task->io_uring;
-
-		/*
-		 * io_wq will stay alive while we hold uring_lock, because it's
-		 * killed after ctx nodes, which requires to take the lock.
-		 */
-		if (!tctx || !tctx->io_wq)
-			continue;
-		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_ctx_cb, ctx, true);
-		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
-	}
-	mutex_unlock(&ctx->uring_lock);
-
-	return ret;
-}
-
-static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
-						struct io_uring_task *tctx,
-						bool cancel_all,
-						bool is_sqpoll_thread)
-{
-	struct io_task_cancel cancel = { .tctx = tctx, .all = cancel_all, };
-	enum io_wq_cancel cret;
-	bool ret = false;
-
-	/* set it so io_req_local_work_add() would wake us up */
-	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
-		atomic_set(&ctx->cq_wait_nr, 1);
-		smp_mb();
-	}
-
-	/* failed during ring init, it couldn't have issued any requests */
-	if (!ctx->rings)
-		return false;
-
-	if (!tctx) {
-		ret |= io_uring_try_cancel_iowq(ctx);
-	} else if (tctx->io_wq) {
-		/*
-		 * Cancels requests of all rings, not only @ctx, but
-		 * it's fine as the task is in exit/exec.
-		 */
-		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_task_cb,
-				       &cancel, true);
-		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
-	}
-
-	/* SQPOLL thread does its own polling */
-	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
-	    is_sqpoll_thread) {
-		while (!wq_list_empty(&ctx->iopoll_list)) {
-			io_iopoll_try_reap_events(ctx);
-			ret = true;
-			cond_resched();
-		}
-	}
-
-	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
-	    io_allowed_defer_tw_run(ctx))
-		ret |= io_run_local_work(ctx, INT_MAX, INT_MAX) > 0;
-	mutex_lock(&ctx->uring_lock);
-	ret |= io_cancel_defer_files(ctx, tctx, cancel_all);
-	ret |= io_poll_remove_all(ctx, tctx, cancel_all);
-	ret |= io_waitid_remove_all(ctx, tctx, cancel_all);
-	ret |= io_futex_remove_all(ctx, tctx, cancel_all);
-	ret |= io_uring_try_cancel_uring_cmd(ctx, tctx, cancel_all);
-	mutex_unlock(&ctx->uring_lock);
-	ret |= io_kill_timeouts(ctx, tctx, cancel_all);
-	if (tctx)
-		ret |= io_run_task_work() > 0;
-	else
-		ret |= flush_delayed_work(&ctx->fallback_work);
-	return ret;
-}
-
-static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
-{
-	if (tracked)
-		return atomic_read(&tctx->inflight_tracked);
-	return percpu_counter_sum(&tctx->inflight);
-}
-
-/*
- * Find any io_uring ctx that this task has registered or done IO on, and cancel
- * requests. @sqd should be not-null IFF it's an SQPOLL thread cancellation.
- */
-__cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
-{
-	struct io_uring_task *tctx = current->io_uring;
-	struct io_ring_ctx *ctx;
-	struct io_tctx_node *node;
-	unsigned long index;
-	s64 inflight;
-	DEFINE_WAIT(wait);
-
-	WARN_ON_ONCE(sqd && sqpoll_task_locked(sqd) != current);
-
-	if (!current->io_uring)
-		return;
-	if (tctx->io_wq)
-		io_wq_exit_start(tctx->io_wq);
-
-	atomic_inc(&tctx->in_cancel);
-	do {
-		bool loop = false;
-
-		io_uring_drop_tctx_refs(current);
-		if (!tctx_inflight(tctx, !cancel_all))
-			break;
-
-		/* read completions before cancelations */
-		inflight = tctx_inflight(tctx, false);
-		if (!inflight)
-			break;
-
-		if (!sqd) {
-			xa_for_each(&tctx->xa, index, node) {
-				/* sqpoll task will cancel all its requests */
-				if (node->ctx->sq_data)
-					continue;
-				loop |= io_uring_try_cancel_requests(node->ctx,
-							current->io_uring,
-							cancel_all,
-							false);
-			}
-		} else {
-			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-				loop |= io_uring_try_cancel_requests(ctx,
-								     current->io_uring,
-								     cancel_all,
-								     true);
-		}
-
-		if (loop) {
-			cond_resched();
-			continue;
-		}
-
-		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
-		io_run_task_work();
-		io_uring_drop_tctx_refs(current);
-		xa_for_each(&tctx->xa, index, node) {
-			if (io_local_work_pending(node->ctx)) {
-				WARN_ON_ONCE(node->ctx->submitter_task &&
-					     node->ctx->submitter_task != current);
-				goto end_wait;
-			}
-		}
-		/*
-		 * If we've seen completions, retry without waiting. This
-		 * avoids a race where a completion comes in before we did
-		 * prepare_to_wait().
-		 */
-		if (inflight == tctx_inflight(tctx, !cancel_all))
-			schedule();
-end_wait:
-		finish_wait(&tctx->wait, &wait);
-	} while (1);
-
-	io_uring_clean_tctx(tctx);
-	if (cancel_all) {
-		/*
-		 * We shouldn't run task_works after cancel, so just leave
-		 * ->in_cancel set for normal exit.
-		 */
-		atomic_dec(&tctx->in_cancel);
-		/* for exec all current's requests should be gone, kill tctx */
-		__io_uring_free(current);
-	}
-}
-
 static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
 			const struct io_uring_getevents_arg __user *uarg)
 {
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2f4d43e69648..23c268ab1c8f 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -96,6 +96,11 @@ enum {
 	IOU_REQUEUE		= -3072,
 };
 
+struct io_defer_entry {
+	struct list_head	list;
+	struct io_kiocb		*req;
+};
+
 struct io_wait_queue {
 	struct wait_queue_entry wq;
 	struct io_ring_ctx *ctx;
@@ -134,6 +139,7 @@ unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 int io_uring_fill_params(unsigned entries, struct io_uring_params *p);
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
+int io_run_local_work(struct io_ring_ctx *ctx, int min_events, int max_events);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
@@ -141,6 +147,7 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
 bool io_req_post_cqe32(struct io_kiocb *req, struct io_uring_cqe src_cqe[2]);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
+unsigned io_linked_nr(struct io_kiocb *req);
 void io_req_track_inflight(struct io_kiocb *req);
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
@@ -155,7 +162,7 @@ void io_req_task_submit(struct io_tw_req tw_req, io_tw_token_t tw);
 struct llist_node *io_handle_tw_list(struct llist_node *node, unsigned int *count, unsigned int max_entries);
 struct llist_node *tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries, unsigned int *count);
 void tctx_task_work(struct callback_head *cb);
-__cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
+__cold void io_uring_drop_tctx_refs(struct task_struct *task);
 
 int io_ring_add_registered_file(struct io_uring_task *tctx, struct file *file,
 				     int start, int end);
@@ -164,6 +171,7 @@ void io_req_queue_iowq(struct io_kiocb *req);
 int io_poll_issue(struct io_kiocb *req, io_tw_token_t tw);
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin);
+__cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx);
 void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index a3f11349ce06..e82997d26ebb 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -18,6 +18,7 @@
 #include "io_uring.h"
 #include "tctx.h"
 #include "napi.h"
+#include "cancel.h"
 #include "sqpoll.h"
 
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8

-- 
Jens Axboe


