Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE4E29CCFB
	for <lists+io-uring@lfdr.de>; Wed, 28 Oct 2020 02:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgJ1Bie (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Oct 2020 21:38:34 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:46567 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1833006AbgJ0X2r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Oct 2020 19:28:47 -0400
Received: by mail-wr1-f50.google.com with SMTP id n6so3690851wrm.13
        for <io-uring@vger.kernel.org>; Tue, 27 Oct 2020 16:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SZ8JL9NuoRfpXV6y1R3XCIaH9sg8r1jEZ8fj1xtfz7k=;
        b=JAYJu2iQWYEhumTo70vILTYxArnuLouKrr5ymocYC76tBTH4VrTar/Zv0Ccg3dcnrZ
         M1bo7oxgstoXJzP7JTPly3xclMI2CdTIHrPP7km7/LcTJEB6mSy9+Sm8Snz30BYjTdeo
         MJunC6jBdCoXnvfyq8dVtlzJd18Ab+w3GtMJBARbUpn5lGzDpr0ppecNdTAa0jcuYEDa
         0UXvxZeWQhBNAooeuTOG4Hl8ybaGDTBFN7BkWvbu0c5WA2/lOBZ4ySfGNSAwd2R8hjxn
         tzoqwSsckgFy5zZKwJB3mxih8/NFi1DDI5CMUFgfr+cB5CAtucCeFnk9T6vvwefaOR1N
         ZYsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SZ8JL9NuoRfpXV6y1R3XCIaH9sg8r1jEZ8fj1xtfz7k=;
        b=CjpDE++JvcvL7IeqTnFxuo3Jm3BUdE0AvieuGWdqXHzDX9EMLZ32a37A7k7CAEKw6k
         eUzvgn3FdDbfIKRvaWIwb3GxcvAk+GV3q/pUZMkeD1MXrqg4ollJLItVMXSu56r7GbNO
         3j68zq+I80wMvbgUiPFrP0hlVmxCSigvoePKUejI7PBVPaVm+ZnkMIORieSpJ1AlUkXy
         88on3+xPAptez2G6KovZ98l+IJOqW4vxK2F9Np22nt7Kd1PF4COZ5lIyOzn+OUaDiCxr
         s/lkhP6nv6KfdqoKne/HWqN4siFY4NZGBs3N0fPuy45KfYwKrYDmaOaqSU5x6ILMjVu5
         UPCQ==
X-Gm-Message-State: AOAM533W3GidJkeYgMRyLmW3Et9qzhqDqXRpsMhFs/EtBjoFpP7pqJPs
        dHDKeM1egDnDLnuJvc8HrntnORBlo8lCdQ==
X-Google-Smtp-Source: ABdhPJzfDUND36OnAT135ZtYDkZGim45QtAFTjhxXl01sr/map/XAezBZwaOG7SVm0Nrxg4SON/nMw==
X-Received: by 2002:adf:906b:: with SMTP id h98mr5357096wrh.310.1603841324039;
        Tue, 27 Oct 2020 16:28:44 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id a15sm4336990wrp.90.2020.10.27.16.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 16:28:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: link requests with singly linked list
Date:   Tue, 27 Oct 2020 23:25:37 +0000
Message-Id: <1de0691149127b43845aea8295163cdf7c78e11d.1603840701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603840701.git.asml.silence@gmail.com>
References: <cover.1603840701.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Singly linked list for keeping linked requests is enough, because we
almost always operate on the head and traverse forward with the
exception of linked timeouts going 1 hop backwards.

Replace ->link_list with a handmade singly linked list. Also kill
REQ_F_LINK_HEAD in favour of checking a newly added ->list for NULL
directly.

That saves 8B in io_kiocb, is not as heavy as list fixup, makes better
use of cache by not touching a previous request (i.e. last request of
the link) each time on list modification and optimises cache use further
in the following patch, and actually makes travesal easier removing in
the end some lines. Also, keeping invariant in ->list instead of having
REQ_F_LINK_HEAD is less error-prone.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 132 ++++++++++++++++++++------------------------------
 1 file changed, 52 insertions(+), 80 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4eb1cb8a8bf8..b8b5131dd017 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -577,7 +577,6 @@ enum {
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 
-	REQ_F_LINK_HEAD_BIT,
 	REQ_F_FAIL_LINK_BIT,
 	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
@@ -609,8 +608,6 @@ enum {
 	/* IOSQE_BUFFER_SELECT */
 	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
 
-	/* head of a link */
-	REQ_F_LINK_HEAD		= BIT(REQ_F_LINK_HEAD_BIT),
 	/* fail rest of links */
 	REQ_F_FAIL_LINK		= BIT(REQ_F_FAIL_LINK_BIT),
 	/* on inflight list */
@@ -689,7 +686,7 @@ struct io_kiocb {
 	struct task_struct		*task;
 	u64				user_data;
 
-	struct list_head		link_list;
+	struct io_kiocb			*link;
 
 	/*
 	 * 1. used with ctx->iopoll_list with reads/writes
@@ -986,6 +983,9 @@ struct sock *io_uring_get_socket(struct file *file)
 }
 EXPORT_SYMBOL(io_uring_get_socket);
 
+#define io_for_each_link(pos, head) \
+	for (pos = (head); pos; pos = pos->link)
+
 static inline void io_clean_op(struct io_kiocb *req)
 {
 	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
@@ -1404,10 +1404,8 @@ static void io_prep_async_link(struct io_kiocb *req)
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
@@ -1854,6 +1852,14 @@ static void __io_free_req(struct io_kiocb *req)
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
 static void io_kill_linked_timeout(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1862,8 +1868,8 @@ static void io_kill_linked_timeout(struct io_kiocb *req)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	link = list_first_entry_or_null(&req->link_list, struct io_kiocb,
-					link_list);
+	link = req->link;
+
 	/*
 	 * Can happen if a linked timeout fired and link had been like
 	 * req -> link t-out -> link t-out [-> ...]
@@ -1872,7 +1878,7 @@ static void io_kill_linked_timeout(struct io_kiocb *req)
 		struct io_timeout_data *io = link->async_data;
 		int ret;
 
-		list_del_init(&link->link_list);
+		io_remove_next_linked(req);
 		link->timeout.head = NULL;
 		ret = hrtimer_try_to_cancel(&io->timer);
 		if (ret != -1) {
@@ -1890,41 +1896,22 @@ static void io_kill_linked_timeout(struct io_kiocb *req)
 	}
 }
 
-static struct io_kiocb *io_req_link_next(struct io_kiocb *req)
-{
-	struct io_kiocb *nxt;
 
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
@@ -1936,8 +1923,8 @@ static void io_fail_links(struct io_kiocb *req)
 			io_put_req_deferred(link, 2);
 		else
 			io_double_put_req(link);
+		link = nxt;
 	}
-
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
@@ -1946,7 +1933,6 @@ static void io_fail_links(struct io_kiocb *req)
 
 static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
 {
-	req->flags &= ~REQ_F_LINK_HEAD;
 	if (req->flags & REQ_F_LINK_TIMEOUT)
 		io_kill_linked_timeout(req);
 
@@ -1956,15 +1942,19 @@ static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
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
+	if (likely(!(req->link) && !(req->flags & REQ_F_LINK_TIMEOUT)))
 		return NULL;
 	return __io_req_find_next(req);
 }
@@ -2058,7 +2048,7 @@ static void io_req_task_queue(struct io_kiocb *req)
 	}
 }
 
-static void io_queue_next(struct io_kiocb *req)
+static inline void io_queue_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = io_req_find_next(req);
 
@@ -2115,8 +2105,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 		io_free_req(req);
 		return;
 	}
-	if (req->flags & REQ_F_LINK_HEAD)
-		io_queue_next(req);
+	io_queue_next(req);
 
 	if (req->task != rb->task) {
 		if (rb->task) {
@@ -5751,11 +5740,10 @@ static u32 io_get_sequence(struct io_kiocb *req)
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
@@ -6100,7 +6088,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	 * race with the completion of the linked work.
 	 */
 	if (prev && refcount_inc_not_zero(&prev->refs))
-		list_del_init(&req->link_list);
+		io_remove_next_linked(prev);
 	else
 		prev = NULL;
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
@@ -6118,8 +6106,8 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 static void __io_queue_linked_timeout(struct io_kiocb *req)
 {
 	/*
-	 * If the list is now empty, then our linked request finished before
-	 * we got a chance to setup the timer
+	 * If the back reference is NULL, then our linked request finished
+	 * before we got a chance to setup the timer
 	 */
 	if (req->timeout.head) {
 		struct io_timeout_data *data = req->async_data;
@@ -6144,16 +6132,10 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
 
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 {
-	struct io_kiocb *nxt;
+	struct io_kiocb *nxt = req->link;
 
-	if (!(req->flags & REQ_F_LINK_HEAD))
-		return NULL;
-	if (req->flags & REQ_F_LINK_TIMEOUT)
-		return NULL;
-
-	nxt = list_first_entry_or_null(&req->link_list, struct io_kiocb,
-					link_list);
-	if (!nxt || nxt->opcode != IORING_OP_LINK_TIMEOUT)
+	if (!nxt || (req->flags & REQ_F_LINK_TIMEOUT) ||
+	    nxt->opcode != IORING_OP_LINK_TIMEOUT)
 		return NULL;
 
 	nxt->timeout.head = req;
@@ -6301,7 +6283,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			return ret;
 		}
 		trace_io_uring_link(ctx, req, head);
-		list_add_tail(&req->link_list, &head->link_list);
+		link->last->link = req;
 		link->last = req;
 
 		/* last request of a link, enqueue the link */
@@ -6315,9 +6297,6 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			ctx->drain_next = 0;
 		}
 		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
-			req->flags |= REQ_F_LINK_HEAD;
-			INIT_LIST_HEAD(&req->link_list);
-
 			ret = io_req_defer_prep(req, sqe);
 			if (unlikely(ret))
 				req->flags |= REQ_F_FAIL_LINK;
@@ -6450,6 +6429,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->file = NULL;
 	req->ctx = ctx;
 	req->flags = 0;
+	req->link = NULL;
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
 	req->task = current;
@@ -8385,29 +8365,21 @@ static bool io_match_link(struct io_kiocb *preq, struct io_kiocb *req)
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

