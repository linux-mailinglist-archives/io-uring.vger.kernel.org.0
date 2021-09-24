Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1204178E0
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344536AbhIXQh7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344295AbhIXQhe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:34 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2491C0613B2
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:56 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id v10so33637927edj.10
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ICK5PzlL5i2QqvO+uOhA/pZmBoa9TwplmAAuAcPIBcc=;
        b=CziP585WNT67ciQYCRUgjAC9MJp1hZxgs75RXjWO+Addd/OH7I7NUcYxc6o0YFBIjt
         oVk59QXVx6T93e8QJMlQdJ3mpTiRKlXWNJomUM8ZeFPw+7U3HWOYGtpzwPIq79A+mnTG
         O6G2p2xPaPoj3eq5lmGCJ7eVAfmtaMwwL9h57wKhh6F1YKFIEsCnX1VYl6vgjGk3TCy4
         b+EZgaYxGEx41YVCGk+9XDfMkmkjx4ySVsF5n+foOXtQNkV6cgcKNkC2E00+lmbWczbB
         eNXqxF4SOVzVUjsPBVsflVCVU9sEpkEdszCiA4+zCSPyQuNcCgcoiBAx/TLW0BVNe6DN
         eCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ICK5PzlL5i2QqvO+uOhA/pZmBoa9TwplmAAuAcPIBcc=;
        b=siQoHrJGj0+LDHkT+x1T8w0RaauJhh7EVauzdfLmwMhpQ29RoidTsm1QMdEB5nUlp6
         hT/QT/H90Yc7RbVeHo6t+VBvFc9kX/qulzL7FYW3w2PoFm+G+T0prq2lVWlxETVAMkxa
         ubileMdTcI9avnwcG9upnUGNwBEOwfXEfav6iORqbammhTUgWRO6kwnObSeyjhZQk8tA
         NRlzCDHB/6xTU6agTog6NWJShXKlegu8U5ZLdSOWHXgFGMEoUN4sMWUHarFVv4YAOFI6
         UYAK9AnOP+jU0VgCqWDGqWofX67ApFIOnN7UGGSQ7RmjAz+bVLu5ILLsplXvLYxMoQz2
         +JSA==
X-Gm-Message-State: AOAM531uN1HlViI/26wxOhijRqo15cinDYHE8HYUJbY+lJ3owsag6QUx
        yM/9lz700J8enVLQQrRqofn/uHZ1hy4=
X-Google-Smtp-Source: ABdhPJw2WCKI0L3fhQ9gwWZ3DerIr+QLb8+ZSnkvZmToOitE8XlRaG53C4Qs9I8J8JW62D+8goVH3Q==
X-Received: by 2002:a17:906:cc57:: with SMTP id mm23mr12417867ejb.540.1632501175290;
        Fri, 24 Sep 2021 09:32:55 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:32:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/23] io_uring: use single linked list for iopoll
Date:   Fri, 24 Sep 2021 17:31:47 +0100
Message-Id: <e273e132654f98c6fd659570720a0cc5adf24994.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use single linked lists for keeping iopoll requests, takes less space,
may be faster, but mostly will be of benefit for further patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.h    |  3 +++
 fs/io_uring.c | 53 ++++++++++++++++++++++++++-------------------------
 2 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index c870062105d1..87ba6a733630 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -32,6 +32,9 @@ struct io_wq_work_list {
 #define wq_list_for_each(pos, prv, head)			\
 	for (pos = (head)->first, prv = NULL; pos; prv = pos, pos = (pos)->next)
 
+#define wq_list_for_each_resume(pos, prv)			\
+	for (; pos; prv = pos, pos = (pos)->next)
+
 #define wq_list_empty(list)	(READ_ONCE((list)->first) == NULL)
 #define INIT_WQ_LIST(list)	do {				\
 	(list)->first = NULL;					\
diff --git a/fs/io_uring.c b/fs/io_uring.c
index e0f897c3779d..f4a7468c4570 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -413,7 +413,7 @@ struct io_ring_ctx {
 		 * For SQPOLL, only the single threaded io_sq_thread() will
 		 * manipulate the list, hence no extra locking is needed there.
 		 */
-		struct list_head	iopoll_list;
+		struct io_wq_work_list	iopoll_list;
 		struct hlist_head	*cancel_hash;
 		unsigned		cancel_hash_bits;
 		bool			poll_multi_queue;
@@ -1307,7 +1307,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_waitqueue_head(&ctx->cq_wait);
 	spin_lock_init(&ctx->completion_lock);
 	spin_lock_init(&ctx->timeout_lock);
-	INIT_LIST_HEAD(&ctx->iopoll_list);
+	INIT_WQ_LIST(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	INIT_LIST_HEAD(&ctx->ltimeout_list);
@@ -2443,15 +2443,9 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, struct list_head *done)
 	io_req_free_batch_finish(ctx, &rb);
 }
 
-/* same as "continue" but starts from the pos, not next to it */
-#define list_for_each_entry_safe_resume(pos, n, head, member) 		\
-	for (n = list_next_entry(pos, member);				\
-	     !list_entry_is_head(pos, head, member);			\
-	     pos = n, n = list_next_entry(n, member))
-
 static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
-	struct io_kiocb *req, *tmp;
+	struct io_wq_work_node *pos, *start, *prev;
 	LIST_HEAD(done);
 	int nr_events = 0;
 	bool spin;
@@ -2462,7 +2456,8 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	 */
 	spin = !ctx->poll_multi_queue && !force_nonspin;
 
-	list_for_each_entry(req, &ctx->iopoll_list, inflight_entry) {
+	wq_list_for_each(pos, start, &ctx->iopoll_list) {
+		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
 		struct kiocb *kiocb = &req->rw.kiocb;
 		int ret;
 
@@ -2485,14 +2480,20 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 			break;
 	}
 
-	list_for_each_entry_safe_resume(req, tmp, &ctx->iopoll_list,
-					inflight_entry) {
+	if (!pos)
+		return 0;
+
+	prev = start;
+	wq_list_for_each_resume(pos, prev) {
+		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
+
 		if (!READ_ONCE(req->iopoll_completed))
 			break;
-		list_move_tail(&req->inflight_entry, &done);
+		list_add_tail(&req->inflight_entry, &done);
 		nr_events++;
 	}
 
+	wq_list_cut(&ctx->iopoll_list, prev, start);
 	if (nr_events)
 		io_iopoll_complete(ctx, &done);
 	return nr_events;
@@ -2508,7 +2509,7 @@ static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 		return;
 
 	mutex_lock(&ctx->uring_lock);
-	while (!list_empty(&ctx->iopoll_list)) {
+	while (!wq_list_empty(&ctx->iopoll_list)) {
 		/* let it sleep and repeat later if can't complete a request */
 		if (io_do_iopoll(ctx, true) == 0)
 			break;
@@ -2557,7 +2558,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		 * forever, while the workqueue is stuck trying to acquire the
 		 * very same mutex.
 		 */
-		if (list_empty(&ctx->iopoll_list)) {
+		if (wq_list_empty(&ctx->iopoll_list)) {
 			u32 tail = ctx->cached_cq_tail;
 
 			mutex_unlock(&ctx->uring_lock);
@@ -2566,7 +2567,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 
 			/* some requests don't go through iopoll_list */
 			if (tail != ctx->cached_cq_tail ||
-			    list_empty(&ctx->iopoll_list))
+			    wq_list_empty(&ctx->iopoll_list))
 				break;
 		}
 		ret = io_do_iopoll(ctx, !min);
@@ -2726,14 +2727,14 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	 * how we do polling eventually, not spinning if we're on potentially
 	 * different devices.
 	 */
-	if (list_empty(&ctx->iopoll_list)) {
+	if (wq_list_empty(&ctx->iopoll_list)) {
 		ctx->poll_multi_queue = false;
 	} else if (!ctx->poll_multi_queue) {
 		struct io_kiocb *list_req;
 		unsigned int queue_num0, queue_num1;
 
-		list_req = list_first_entry(&ctx->iopoll_list, struct io_kiocb,
-						inflight_entry);
+		list_req = container_of(ctx->iopoll_list.first, struct io_kiocb,
+					comp_list);
 
 		if (list_req->file != req->file) {
 			ctx->poll_multi_queue = true;
@@ -2750,9 +2751,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	 * it to the front so we find it first.
 	 */
 	if (READ_ONCE(req->iopoll_completed))
-		list_add(&req->inflight_entry, &ctx->iopoll_list);
+		wq_list_add_head(&req->comp_list, &ctx->iopoll_list);
 	else
-		list_add_tail(&req->inflight_entry, &ctx->iopoll_list);
+		wq_list_add_tail(&req->comp_list, &ctx->iopoll_list);
 
 	if (unlikely(in_async)) {
 		/*
@@ -7313,14 +7314,14 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 	if (cap_entries && to_submit > IORING_SQPOLL_CAP_ENTRIES_VALUE)
 		to_submit = IORING_SQPOLL_CAP_ENTRIES_VALUE;
 
-	if (!list_empty(&ctx->iopoll_list) || to_submit) {
+	if (!wq_list_empty(&ctx->iopoll_list) || to_submit) {
 		const struct cred *creds = NULL;
 
 		if (ctx->sq_creds != current_cred())
 			creds = override_creds(ctx->sq_creds);
 
 		mutex_lock(&ctx->uring_lock);
-		if (!list_empty(&ctx->iopoll_list))
+		if (!wq_list_empty(&ctx->iopoll_list))
 			io_do_iopoll(ctx, true);
 
 		/*
@@ -7398,7 +7399,7 @@ static int io_sq_thread(void *data)
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, cap_entries);
 
-			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
+			if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
 		}
 		if (io_run_task_work())
@@ -7419,7 +7420,7 @@ static int io_sq_thread(void *data)
 				io_ring_set_wakeup_flag(ctx);
 
 				if ((ctx->flags & IORING_SETUP_IOPOLL) &&
-				    !list_empty_careful(&ctx->iopoll_list)) {
+				    !wq_list_empty(&ctx->iopoll_list)) {
 					needs_sched = false;
 					break;
 				}
@@ -9541,7 +9542,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		/* SQPOLL thread does its own polling */
 		if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
 		    (ctx->sq_data && ctx->sq_data->thread == current)) {
-			while (!list_empty_careful(&ctx->iopoll_list)) {
+			while (!wq_list_empty(&ctx->iopoll_list)) {
 				io_iopoll_try_reap_events(ctx);
 				ret = true;
 			}
-- 
2.33.0

