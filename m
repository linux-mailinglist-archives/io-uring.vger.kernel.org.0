Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DF328FA83
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 23:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732802AbgJOVO3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 17:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732725AbgJOVO3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 17:14:29 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6337FC061755
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 14:14:28 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id a72so377503wme.5
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 14:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KjZ9cUUtXddZbqlTOqggz4HBcKwqGkWzkKCrrtSw4Zc=;
        b=iUTSU6rDYjP/5AQsB07TDfAgrj0AIASU2XDn5yjGS7ftuJoGzO2m6m+zrZ/ugOhUXA
         OCncdau7Wc2wt8KC3pI8RxBllUy8PeefgjJhpkBob+k6j6FrP6xGZ6akr+bmvG7Dmq7k
         HTQfySvnkPexccj7r9+3rLaQGGs2qDnkmSPEAukPEqZOy6lbACC+tFoqaTA3i2rLYarN
         FcEfoBy795rBN0SFIdQyX4ZURkI1qQIK/OcCluB/D/rqgoNLxYzwX3itzR0u08OaUFGN
         NgVU28LzY1tBn8SKSSfiNvKSsW9H7jat8E1XzVQ7HAu2w/e6uPQhVk3UzOn4ria/2D8s
         jUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KjZ9cUUtXddZbqlTOqggz4HBcKwqGkWzkKCrrtSw4Zc=;
        b=IXa1+DZxyrg5be0iQKSjnrnvqyE5lVN2LYSLbMD4fcRXVWbEREfvxTesLHDjJkxEam
         83fG/19ke+vIN6F9IE6I7ej6w5+1jfiJISjgwK6qztIjlCk7+u1fzISUaehX9qKLU9OM
         XnmKTvqMyA3DuTvBc/T6iI9GsuVCtKRwVWTIyM7muU2uAlowwohL5KxtsHTuI7MtPrJL
         L3UF46bZsNFHxlrIl0cptY+QAnIE+LGTdvRjzdpDYqF5eby+6bsTATZDrlmR0U07UwH5
         xE2cP0fCsEcB+fPrlj0w6JcY4Iv8gDJu+TSuM5SAprchL9kcAAr9CofEfmydc2lZMmHw
         mmYA==
X-Gm-Message-State: AOAM533DC6nkW0LUyQpklZXlo4/+Bh+Q5t2nbmE0ZZMpRGijYtbADtAy
        UWSpOnBhBMTxpq2ZnOWtr9o=
X-Google-Smtp-Source: ABdhPJyiWppUxLI3IfF09uBXCrYRiqM3MWT0ZeKpZn+kOgFl+7Y7BwzYxZZo2B2Qv9l1LQZac3l14A==
X-Received: by 2002:a7b:c01a:: with SMTP id c26mr529453wmb.35.1602796467017;
        Thu, 15 Oct 2020 14:14:27 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id x3sm320865wmi.45.2020.10.15.14.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 14:14:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: link requests with singly linked list
Date:   Thu, 15 Oct 2020 22:11:23 +0100
Message-Id: <75eec7dcca0ef030151a6b9d587435196aa73aa6.1602795685.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602795685.git.asml.silence@gmail.com>
References: <cover.1602795685.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't need a doubly linked list to keep a list of linked requests,
it's not traversed backwards (almost) and removes doesn't happen
arbitrary. The exception is linked_timeout, that needs to keep track
of a previous request, which is also the head of the link. Linked
timeout are anyway a one big corner case, it's not difficult to put a
back reference into timeout struct.

There are 4 main steps here:
- replace link_list with a singly linked io_kiocb *link.
- kills REQ_F_LINK_HEAD and just checks ->link for NULL.
- adds a back reference to linked timeouts.
- adjusts io_submit_sqe() because it needs to know the last request in
a link to append new ones.

The benefits:
- fight back 8 bytes per request
- these 8B are in the 2nd cacheline, moving fixed_file_refs there will
  finally make the 3rd cacheline cold.
- it doesn't touch the last request every time we advance a link, and so
  makes better use of cache
- it looks better and for_each is shorter

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 164 ++++++++++++++++++++++----------------------------
 1 file changed, 73 insertions(+), 91 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8065df90ce98..fd5360a238a7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -437,6 +437,8 @@ struct io_timeout {
 	u32				off;
 	u32				target_seq;
 	struct list_head		list;
+	/* head of the link, used by linked timeouts only */
+	struct io_kiocb			*head;
 };
 
 struct io_timeout_rem {
@@ -567,7 +569,6 @@ enum {
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 
-	REQ_F_LINK_HEAD_BIT,
 	REQ_F_FAIL_LINK_BIT,
 	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
@@ -598,8 +599,6 @@ enum {
 	/* IOSQE_BUFFER_SELECT */
 	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
 
-	/* head of a link */
-	REQ_F_LINK_HEAD		= BIT(REQ_F_LINK_HEAD_BIT),
 	/* fail rest of links */
 	REQ_F_FAIL_LINK		= BIT(REQ_F_FAIL_LINK_BIT),
 	/* on inflight list */
@@ -675,7 +674,7 @@ struct io_kiocb {
 	struct task_struct		*task;
 	u64				user_data;
 
-	struct list_head		link_list;
+	struct io_kiocb			*link;
 
 	/*
 	 * 1. used with ctx->iopoll_list with reads/writes
@@ -998,6 +997,9 @@ struct sock *io_uring_get_socket(struct file *file)
 }
 EXPORT_SYMBOL(io_uring_get_socket);
 
+#define io_for_each_link(pos, head) \
+	for (pos = (head); pos; pos = pos->link)
+
 static inline void io_clean_op(struct io_kiocb *req)
 {
 	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
@@ -1274,10 +1276,8 @@ static void io_prep_async_link(struct io_kiocb *req)
 {
 	struct io_kiocb *cur;
 
-	io_prep_async_work(req);
-	if (req->flags & REQ_F_LINK_HEAD)
-		list_for_each_entry(cur, &req->link_list, link_list)
-			io_prep_async_work(cur);
+	io_for_each_link(cur, req)
+		io_prep_async_work(cur);
 }
 
 static struct io_kiocb *__io_queue_async_work(struct io_kiocb *req)
@@ -1724,6 +1724,14 @@ static void __io_free_req(struct io_kiocb *req)
 	percpu_ref_put(&ctx->refs);
 }
 
+static inline void io_remove_next_linked(struct io_kiocb *req)
+{
+	struct io_kiocb *nxt = req->link;
+
+	req->link = nxt->link;
+	nxt->link = NULL;
+}
+
 static bool io_link_cancel_timeout(struct io_kiocb *req)
 {
 	struct io_timeout_data *io = req->async_data;
@@ -1732,10 +1740,10 @@ static bool io_link_cancel_timeout(struct io_kiocb *req)
 
 	ret = hrtimer_try_to_cancel(&io->timer);
 	if (ret != -1) {
-		list_del_init(&req->link_list);
+		io_remove_next_linked(req->timeout.head);
+		req->timeout.head = NULL;
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(ctx);
-		req->flags &= ~REQ_F_LINK_HEAD;
 		io_put_req_deferred(req, 1);
 		return true;
 	}
@@ -1745,11 +1753,9 @@ static bool io_link_cancel_timeout(struct io_kiocb *req)
 
 static bool __io_kill_linked_timeout(struct io_kiocb *req)
 {
-	struct io_kiocb *link;
+	struct io_kiocb *link = req->link;
 	bool wake_ev;
 
-	link = list_first_entry_or_null(&req->link_list, struct io_kiocb,
-					link_list);
 	if (!link || link->opcode != IORING_OP_LINK_TIMEOUT)
 		return false;
 
@@ -1772,41 +1778,21 @@ static void io_kill_linked_timeout(struct io_kiocb *req)
 		io_cqring_ev_posted(ctx);
 }
 
-static struct io_kiocb *io_req_link_next(struct io_kiocb *req)
-{
-	struct io_kiocb *nxt;
-
-	/*
-	 * The list should never be empty when we are called here. But could
-	 * potentially happen if the chain is messed up, check to be on the
-	 * safe side.
-	 */
-	if (unlikely(list_empty(&req->link_list)))
-		return NULL;
-
-	nxt = list_first_entry(&req->link_list, struct io_kiocb, link_list);
-	list_del_init(&req->link_list);
-	if (!list_empty(&nxt->link_list))
-		nxt->flags |= REQ_F_LINK_HEAD;
-	return nxt;
-}
-
-/*
- * Called if REQ_F_LINK_HEAD is set, and we fail the head request
- */
 static void io_fail_links(struct io_kiocb *req)
 {
+	struct io_kiocb *link, *nxt;
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	while (!list_empty(&req->link_list)) {
-		struct io_kiocb *link = list_first_entry(&req->link_list,
-						struct io_kiocb, link_list);
+	link = req->link;
+	req->link = NULL;
 
-		list_del_init(&link->link_list);
-		trace_io_uring_fail_link(req, link);
+	while (link) {
+		nxt = link->link;
+		link->link = NULL;
 
+		trace_io_uring_fail_link(req, link);
 		io_cqring_fill_event(link, -ECANCELED);
 
 		/*
@@ -1818,8 +1804,8 @@ static void io_fail_links(struct io_kiocb *req)
 			io_put_req_deferred(link, 2);
 		else
 			io_double_put_req(link);
+		link = nxt;
 	}
-
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
@@ -1828,7 +1814,6 @@ static void io_fail_links(struct io_kiocb *req)
 
 static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
 {
-	req->flags &= ~REQ_F_LINK_HEAD;
 	if (req->flags & REQ_F_LINK_TIMEOUT)
 		io_kill_linked_timeout(req);
 
@@ -1838,15 +1823,19 @@ static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
 	 * dependencies to the next request. In case of failure, fail the rest
 	 * of the chain.
 	 */
-	if (likely(!(req->flags & REQ_F_FAIL_LINK)))
-		return io_req_link_next(req);
+	if (likely(!(req->flags & REQ_F_FAIL_LINK))) {
+		struct io_kiocb *nxt = req->link;
+
+		req->link = NULL;
+		return nxt;
+	}
 	io_fail_links(req);
 	return NULL;
 }
 
-static struct io_kiocb *io_req_find_next(struct io_kiocb *req)
+static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 {
-	if (likely(!(req->flags & REQ_F_LINK_HEAD)))
+	if (likely(!(req->link)))
 		return NULL;
 	return __io_req_find_next(req);
 }
@@ -1940,7 +1929,7 @@ static void io_req_task_queue(struct io_kiocb *req)
 	}
 }
 
-static void io_queue_next(struct io_kiocb *req)
+static inline void io_queue_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = io_req_find_next(req);
 
@@ -1995,8 +1984,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 		io_free_req(req);
 		return;
 	}
-	if (req->flags & REQ_F_LINK_HEAD)
-		io_queue_next(req);
+	io_queue_next(req);
 
 	if (req->task != rb->task) {
 		if (rb->task) {
@@ -5633,11 +5621,10 @@ static u32 io_get_sequence(struct io_kiocb *req)
 {
 	struct io_kiocb *pos;
 	struct io_ring_ctx *ctx = req->ctx;
-	u32 total_submitted, nr_reqs = 1;
+	u32 total_submitted, nr_reqs = 0;
 
-	if (req->flags & REQ_F_LINK_HEAD)
-		list_for_each_entry(pos, &req->link_list, link_list)
-			nr_reqs++;
+	io_for_each_link(pos, req)
+		nr_reqs++;
 
 	total_submitted = ctx->cached_sq_head - ctx->cached_sq_dropped;
 	return total_submitted - nr_reqs;
@@ -5974,10 +5961,11 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	prev = list_entry(req->link_list.prev, struct io_kiocb, link_list);
+	prev = req->timeout.head;
 
 	if (refcount_inc_not_zero(&prev->refs)) {
-		list_del_init(&req->link_list);
+		io_remove_next_linked(prev);
+		req->timeout.head = NULL;
 		prev->flags &= ~REQ_F_LINK_TIMEOUT;
 	} else
 		prev = NULL;
@@ -5996,10 +5984,10 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 static void __io_queue_linked_timeout(struct io_kiocb *req)
 {
 	/*
-	 * If the list is now empty, then our linked request finished before
-	 * we got a chance to setup the timer
+	 * If the back reference is NULL, then our linked request finished
+	 * before we got a chance to setup the timer
 	 */
-	if (!list_empty(&req->link_list)) {
+	if (req->timeout.head) {
 		struct io_timeout_data *data = req->async_data;
 
 		data->timer.function = io_link_timeout_fn;
@@ -6022,18 +6010,14 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
 
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 {
-	struct io_kiocb *nxt;
+	struct io_kiocb *nxt = req->link;
 
-	if (!(req->flags & REQ_F_LINK_HEAD))
+	if (!nxt || nxt->opcode != IORING_OP_LINK_TIMEOUT)
 		return NULL;
 	if (req->flags & REQ_F_LINK_TIMEOUT)
 		return NULL;
 
-	nxt = list_first_entry_or_null(&req->link_list, struct io_kiocb,
-					link_list);
-	if (!nxt || nxt->opcode != IORING_OP_LINK_TIMEOUT)
-		return NULL;
-
+	nxt->timeout.head = req;
 	req->flags |= REQ_F_LINK_TIMEOUT;
 	return nxt;
 }
@@ -6152,8 +6136,13 @@ static inline void io_queue_link_head(struct io_kiocb *req,
 		io_queue_sqe(req, NULL, cs);
 }
 
+struct io_link {
+	struct io_kiocb *head;
+	struct io_kiocb *last;
+};
+
 static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			 struct io_kiocb **link, struct io_comp_state *cs)
+			 struct io_link *link, struct io_comp_state *cs)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -6165,8 +6154,8 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	 * submitted sync once the chain is complete. If none of those
 	 * conditions are true (normal request), then just queue it.
 	 */
-	if (*link) {
-		struct io_kiocb *head = *link;
+	if (link->head) {
+		struct io_kiocb *head = link->head;
 
 		/*
 		 * Taking sequential execution of a link, draining both sides
@@ -6186,12 +6175,13 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			return ret;
 		}
 		trace_io_uring_link(ctx, req, head);
-		list_add_tail(&req->link_list, &head->link_list);
+		link->last->link = req;
+		link->last = req;
 
 		/* last request of a link, enqueue the link */
 		if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
 			io_queue_link_head(head, cs);
-			*link = NULL;
+			link->head = NULL;
 		}
 	} else {
 		if (unlikely(ctx->drain_next)) {
@@ -6199,13 +6189,11 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			ctx->drain_next = 0;
 		}
 		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
-			req->flags |= REQ_F_LINK_HEAD;
-			INIT_LIST_HEAD(&req->link_list);
-
 			ret = io_req_defer_prep(req, sqe);
 			if (unlikely(ret))
 				req->flags |= REQ_F_FAIL_LINK;
-			*link = req;
+			link->head = req;
+			link->last = req;
 		} else {
 			io_queue_sqe(req, sqe, cs);
 		}
@@ -6333,6 +6321,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->file = NULL;
 	req->ctx = ctx;
 	req->flags = 0;
+	req->link = NULL;
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
 	req->task = current;
@@ -6378,8 +6367,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 {
+	struct io_link link;
 	struct io_submit_state state;
-	struct io_kiocb *link = NULL;
 	int i, submitted = 0;
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
@@ -6399,6 +6388,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	refcount_add(nr, &current->usage);
 
 	io_submit_state_start(&state, ctx, nr);
+	link.head = NULL;
 
 	for (i = 0; i < nr; i++) {
 		const struct io_uring_sqe *sqe;
@@ -6442,8 +6432,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		atomic_long_sub(nr - ref_used, &current->io_uring->req_issue);
 		put_task_struct_many(current, nr - ref_used);
 	}
-	if (link)
-		io_queue_link_head(link, &state.comp);
+	if (link.head)
+		io_queue_link_head(link.head, &state.comp);
 	io_submit_state_end(&state);
 
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
@@ -8240,29 +8230,21 @@ static bool io_match_link(struct io_kiocb *preq, struct io_kiocb *req)
 {
 	struct io_kiocb *link;
 
-	if (!(preq->flags & REQ_F_LINK_HEAD))
-		return false;
-
-	list_for_each_entry(link, &preq->link_list, link_list) {
+	io_for_each_link(link, preq->link) {
 		if (link == req)
 			return true;
 	}
-
 	return false;
 }
 
-static bool io_match_link_files(struct io_kiocb *req,
+static bool io_match_link_files(struct io_kiocb *head,
 				struct files_struct *files)
 {
-	struct io_kiocb *link;
+	struct io_kiocb *req;
 
-	if (io_match_files(req, files))
-		return true;
-	if (req->flags & REQ_F_LINK_HEAD) {
-		list_for_each_entry(link, &req->link_list, link_list) {
-			if (io_match_files(link, files))
-				return true;
-		}
+	io_for_each_link(req, head) {
+		if (io_match_files(req, files))
+			return true;
 	}
 	return false;
 }
-- 
2.24.0

