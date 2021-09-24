Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B37F417CAE
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346598AbhIXVCj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346621AbhIXVCc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:32 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DE5C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:58 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id bx4so40994769edb.4
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=AhL/uGkkqVme3HwIYhGPT1OnPIfzPuTwTFFHj7MnJfE=;
        b=KJdiVm6AeGlpQd1TBe1oZld/GZK0uO6oxWt46biv0zBiEa1WAuoCmcmRnLqsokGkBD
         NvE3TNpJvgzM5nVQlHEyr5AR8RKM+ZLNIa3sPik9r+yVTbkL5zmJFey2ZrLk50MmMZKH
         yyH1iOarMWgjHV2zjJyekMszCfLeT0M89XukuQ9xex+Nvs3TLOw42/1pafIxJ687NnBn
         yI0sq/Q9g6tYDKmG7dwd1TKLhT+wQehr0WvpgViRMfiRs4SzSykLCl54BgczYK/DHNdP
         pXP/yh+GSU2oi75X0b0eiKnbeiaUOZvHMaxJc4S0BTVdpzn7vlxYVvgAn1TfB3ZkB7ql
         DG0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AhL/uGkkqVme3HwIYhGPT1OnPIfzPuTwTFFHj7MnJfE=;
        b=LRIwfeOErTaGXI4KB1pf3kW/yezHgXJrzKWexAI3mNrzUIRogcRxnKdbTw9VK0KNaD
         vPcYmBUtLRpqKmh9kvjV68egJg2PtW8/SLDapKxIxuTrZ6MKytwKkfs9JmXmhzhcmFYq
         lV92cLgFghYbq6GXQjWzCmSNtUv3o2Jx+jQYiJzzT7q04wVuhxveM6/QBAWNR50IHRO9
         QjY/rXYN1pgWtXe3h/MdRtj0nfU3FKJlP65/2IiZhC9kKveVXNfRyRiGOlu81ZBT1s+L
         6L2aDtdOZaxJvZBUvvCd8St6EDeqL5VLB8kKlrnSq1jJFlfOhkZiIZzdFvg8WyUzoMoD
         hefQ==
X-Gm-Message-State: AOAM531n3NDGDLa+Z6mG6vEont2L1U2cvxQ8J2IY0onDVAUPzBbaAB+X
        zuI6H7LixjKgq60L8fm0OSzkPsyux9k=
X-Google-Smtp-Source: ABdhPJwXbdKP6S6XyHE4pAxky0CrrXPYInAtg4LLQVzeHWg26mt7f/jyGW53xGe2ihSAEpWeiA44tw==
X-Received: by 2002:a17:906:7847:: with SMTP id p7mr13047234ejm.335.1632517257256;
        Fri, 24 Sep 2021 14:00:57 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:00:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 09/24] io_uring: use single linked list for iopoll
Date:   Fri, 24 Sep 2021 21:59:49 +0100
Message-Id: <314033676b100cd485518c3bc55e1b95a0dcd71f.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
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
index 0e683d0f5b73..205127394649 100644
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
@@ -1310,7 +1310,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_waitqueue_head(&ctx->cq_wait);
 	spin_lock_init(&ctx->completion_lock);
 	spin_lock_init(&ctx->timeout_lock);
-	INIT_LIST_HEAD(&ctx->iopoll_list);
+	INIT_WQ_LIST(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	INIT_LIST_HEAD(&ctx->ltimeout_list);
@@ -2446,15 +2446,9 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, struct list_head *done)
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
@@ -2465,7 +2459,8 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	 */
 	spin = !ctx->poll_multi_queue && !force_nonspin;
 
-	list_for_each_entry(req, &ctx->iopoll_list, inflight_entry) {
+	wq_list_for_each(pos, start, &ctx->iopoll_list) {
+		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
 		struct kiocb *kiocb = &req->rw.kiocb;
 		int ret;
 
@@ -2488,14 +2483,20 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
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
@@ -2511,7 +2512,7 @@ static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 		return;
 
 	mutex_lock(&ctx->uring_lock);
-	while (!list_empty(&ctx->iopoll_list)) {
+	while (!wq_list_empty(&ctx->iopoll_list)) {
 		/* let it sleep and repeat later if can't complete a request */
 		if (io_do_iopoll(ctx, true) == 0)
 			break;
@@ -2560,7 +2561,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		 * forever, while the workqueue is stuck trying to acquire the
 		 * very same mutex.
 		 */
-		if (list_empty(&ctx->iopoll_list)) {
+		if (wq_list_empty(&ctx->iopoll_list)) {
 			u32 tail = ctx->cached_cq_tail;
 
 			mutex_unlock(&ctx->uring_lock);
@@ -2569,7 +2570,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 
 			/* some requests don't go through iopoll_list */
 			if (tail != ctx->cached_cq_tail ||
-			    list_empty(&ctx->iopoll_list))
+			    wq_list_empty(&ctx->iopoll_list))
 				break;
 		}
 		ret = io_do_iopoll(ctx, !min);
@@ -2729,14 +2730,14 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
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
@@ -2753,9 +2754,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
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
@@ -7329,14 +7330,14 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
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
@@ -7414,7 +7415,7 @@ static int io_sq_thread(void *data)
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, cap_entries);
 
-			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
+			if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
 		}
 		if (io_run_task_work())
@@ -7435,7 +7436,7 @@ static int io_sq_thread(void *data)
 				io_ring_set_wakeup_flag(ctx);
 
 				if ((ctx->flags & IORING_SETUP_IOPOLL) &&
-				    !list_empty_careful(&ctx->iopoll_list)) {
+				    !wq_list_empty(&ctx->iopoll_list)) {
 					needs_sched = false;
 					break;
 				}
@@ -9597,7 +9598,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
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

