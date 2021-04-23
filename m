Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907A23689B0
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 02:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbhDWAUS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Apr 2021 20:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbhDWAUR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Apr 2021 20:20:17 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2938AC06174A
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:42 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id t14-20020a05600c198eb029012eeb3edfaeso262472wmq.2
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UtiIxQMHHlP0o1mHfpWI6vrlAZnfhwNJEFQFjeXQwdg=;
        b=Yw+6uhRrHBOaJ/3qSyvAXJMCPjH+CKHd4gRBs4Y/JXsugYle3p9XkI3C2/nE2hUctU
         dY9OPmb9fAdNSYZ6+kgYwDHjDMXSPLFYYdDLV6SrHaRFxXe25uZZUCoE1e1lvGpOC1pE
         C/62rkUvIcAyWvuvhlPNWx3BwZT8EBQuw2lYmMPJHPsUl8XXIylbHL5pwMERJHqbFt+J
         qxMVSiHtuc9VqRNMGpAMQvyicyYSY0XUfQqaeMgvMUA5novRU96JUhyULjtDf1LqEaoM
         GJM6vbAKQsPrSK3s4GHJD5F1WI7Si/Ym7C6PEaSYwsaq2aU+fnGFzLqUyygSyLfVx5ou
         4I2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UtiIxQMHHlP0o1mHfpWI6vrlAZnfhwNJEFQFjeXQwdg=;
        b=IWdXlM5ypy0TO5hwWXZFq0k8BUxYkJa7mQ+jbx3+cHM6sBF/g9wOpBrrdGrkQWLUhu
         c6XTBaDTas4iroi4+b+pRE1mmmzjBICXF9R4VQlaczXtcvIpmValn/Py0Ly6Pmg7PdxH
         b0lRaKB5pZzGSqY82yzuyb7Bpko+EFTq3edYE2RsPtkvSyn1jBaseRxjhY7IKk6QuDsZ
         T34UOTevb34FupmDxDQ/SL/towzW5NXzNeIQCgR85mKYlp7OKGG++/im8Y0F7O4vtPYV
         WZ4Ok8YsEtyjvkzHGqD9wGIXSG9KpGt5XGBjXKYrTHQiXE2khv9mgmDJSXyJB7xJKFLq
         OPiA==
X-Gm-Message-State: AOAM5316FQE6kJRZDP1A4WdUG0URDvpwXtQmXv5XEQzl5/s21zbpJnQy
        ESZKA5m/tzPU+x6h9IRXyQA=
X-Google-Smtp-Source: ABdhPJxuIQ02EcPlCjhgu/wZE4EnAD/IUjrzYL2DJduLTi1QTweXJN7ui5VUKuRgTaCqfg9NHc7x5A==
X-Received: by 2002:a1c:2c0a:: with SMTP id s10mr2621024wms.158.1619137180974;
        Thu, 22 Apr 2021 17:19:40 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id g12sm6369605wru.47.2021.04.22.17.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 17:19:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/11] io_uring: decouple CQE filling from requests
Date:   Fri, 23 Apr 2021 01:19:20 +0100
Message-Id: <c9b8da9e42772db2033547dfebe479dc972a0f2c.1619128798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619128798.git.asml.silence@gmail.com>
References: <cover.1619128798.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make __io_cqring_fill_event() agnostic of struct io_kiocb, pass all the
data needed directly into it. Will be used to post rsrc removal
completions, which don't have an associated request.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 55 ++++++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a1f89340e844..23f052a1d964 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1025,7 +1025,8 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 static void io_uring_cancel_sqpoll(struct io_sq_data *sqd);
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 
-static bool io_cqring_fill_event(struct io_kiocb *req, long res, unsigned cflags);
+static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
+				 long res, unsigned int cflags);
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req, int nr);
 static void io_dismantle_req(struct io_kiocb *req);
@@ -1266,7 +1267,7 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		io_cqring_fill_event(req, status, 0);
+		io_cqring_fill_event(req->ctx, req->user_data, status, 0);
 		io_put_req_deferred(req, 1);
 	}
 }
@@ -1500,10 +1501,9 @@ static inline void req_ref_get(struct io_kiocb *req)
 	atomic_inc(&req->refs);
 }
 
-static bool io_cqring_event_overflow(struct io_kiocb *req, long res,
-				     unsigned int cflags)
+static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
+				     long res, unsigned int cflags)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	struct io_overflow_cqe *ocqe;
 
 	ocqe = kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
@@ -1521,20 +1521,19 @@ static bool io_cqring_event_overflow(struct io_kiocb *req, long res,
 		set_bit(0, &ctx->cq_check_overflow);
 		ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
 	}
-	ocqe->cqe.user_data = req->user_data;
+	ocqe->cqe.user_data = user_data;
 	ocqe->cqe.res = res;
 	ocqe->cqe.flags = cflags;
 	list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
 	return true;
 }
 
-static inline bool __io_cqring_fill_event(struct io_kiocb *req, long res,
-					     unsigned int cflags)
+static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
+					  long res, unsigned int cflags)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_cqe *cqe;
 
-	trace_io_uring_complete(ctx, req->user_data, res, cflags);
+	trace_io_uring_complete(ctx, user_data, res, cflags);
 
 	/*
 	 * If we can't get a cq entry, userspace overflowed the
@@ -1543,19 +1542,19 @@ static inline bool __io_cqring_fill_event(struct io_kiocb *req, long res,
 	 */
 	cqe = io_get_cqring(ctx);
 	if (likely(cqe)) {
-		WRITE_ONCE(cqe->user_data, req->user_data);
+		WRITE_ONCE(cqe->user_data, user_data);
 		WRITE_ONCE(cqe->res, res);
 		WRITE_ONCE(cqe->flags, cflags);
 		return true;
 	}
-	return io_cqring_event_overflow(req, res, cflags);
+	return io_cqring_event_overflow(ctx, user_data, res, cflags);
 }
 
 /* not as hot to bloat with inlining */
-static noinline bool io_cqring_fill_event(struct io_kiocb *req, long res,
-					  unsigned int cflags)
+static noinline bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
+					  long res, unsigned int cflags)
 {
-	return __io_cqring_fill_event(req, res, cflags);
+	return __io_cqring_fill_event(ctx, user_data, res, cflags);
 }
 
 static void io_req_complete_post(struct io_kiocb *req, long res,
@@ -1565,7 +1564,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	__io_cqring_fill_event(req, res, cflags);
+	__io_cqring_fill_event(ctx, req->user_data, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
@@ -1776,7 +1775,8 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		io_remove_next_linked(req);
 		link->timeout.head = NULL;
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
-			io_cqring_fill_event(link, -ECANCELED, 0);
+			io_cqring_fill_event(link->ctx, link->user_data,
+					     -ECANCELED, 0);
 			io_put_req_deferred(link, 1);
 			return true;
 		}
@@ -1795,7 +1795,7 @@ static void io_fail_links(struct io_kiocb *req)
 		link->link = NULL;
 
 		trace_io_uring_fail_link(req, link);
-		io_cqring_fill_event(link, -ECANCELED, 0);
+		io_cqring_fill_event(link->ctx, link->user_data, -ECANCELED, 0);
 		io_put_req_deferred(link, 2);
 		link = nxt;
 	}
@@ -2116,7 +2116,8 @@ static void io_submit_flush_completions(struct io_comp_state *cs,
 	spin_lock_irq(&ctx->completion_lock);
 	for (i = 0; i < nr; i++) {
 		req = cs->reqs[i];
-		__io_cqring_fill_event(req, req->result, req->compl.cflags);
+		__io_cqring_fill_event(ctx, req->user_data, req->result,
+					req->compl.cflags);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
@@ -2256,7 +2257,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		if (req->flags & REQ_F_BUFFER_SELECTED)
 			cflags = io_put_rw_kbuf(req);
 
-		__io_cqring_fill_event(req, req->result, cflags);
+		__io_cqring_fill_event(ctx, req->user_data, req->result, cflags);
 		(*nr_events)++;
 
 		if (req_ref_put_and_test(req))
@@ -4869,7 +4870,7 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	}
 	if (req->poll.events & EPOLLONESHOT)
 		flags = 0;
-	if (!io_cqring_fill_event(req, error, flags)) {
+	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
 		io_poll_remove_waitqs(req);
 		req->poll.done = true;
 		flags = 0;
@@ -5197,7 +5198,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 
 	do_complete = io_poll_remove_waitqs(req);
 	if (do_complete) {
-		io_cqring_fill_event(req, -ECANCELED, 0);
+		io_cqring_fill_event(req->ctx, req->user_data, -ECANCELED, 0);
 		io_commit_cqring(req->ctx);
 		req_set_fail_links(req);
 		io_put_req_deferred(req, 1);
@@ -5449,7 +5450,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	atomic_set(&req->ctx->cq_timeouts,
 		atomic_read(&req->ctx->cq_timeouts) + 1);
 
-	io_cqring_fill_event(req, -ETIME, 0);
+	io_cqring_fill_event(ctx, req->user_data, -ETIME, 0);
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
@@ -5491,7 +5492,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 		return PTR_ERR(req);
 
 	req_set_fail_links(req);
-	io_cqring_fill_event(req, -ECANCELED, 0);
+	io_cqring_fill_event(ctx, req->user_data, -ECANCELED, 0);
 	io_put_req_deferred(req, 1);
 	return 0;
 }
@@ -5564,7 +5565,7 @@ static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_timeout_update(ctx, tr->addr, &tr->ts,
 					io_translate_timeout_mode(tr->flags));
 
-	io_cqring_fill_event(req, ret, 0);
+	io_cqring_fill_event(ctx, req->user_data, ret, 0);
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
@@ -5716,7 +5717,7 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 done:
 	if (!ret)
 		ret = success_ret;
-	io_cqring_fill_event(req, ret, 0);
+	io_cqring_fill_event(ctx, req->user_data, ret, 0);
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	io_cqring_ev_posted(ctx);
@@ -5773,7 +5774,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 
 	spin_lock_irq(&ctx->completion_lock);
 done:
-	io_cqring_fill_event(req, ret, 0);
+	io_cqring_fill_event(ctx, req->user_data, ret, 0);
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
-- 
2.31.1

