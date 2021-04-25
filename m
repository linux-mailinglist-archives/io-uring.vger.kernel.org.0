Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B80436A787
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 15:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhDYNdU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 09:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbhDYNdU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 09:33:20 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDC7C061574
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:40 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j5so52092696wrn.4
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UtiIxQMHHlP0o1mHfpWI6vrlAZnfhwNJEFQFjeXQwdg=;
        b=JQEALOVBSZ8pvY91S4WrgUGqATvSfg4K4eTEY7mF7rKGDyy1xX3i3dH9XOE3/4wXYf
         7griCo57WtTX1+b7xxlAOrSJNwFgKtLNWn3JF0upPlhtyfxhuCxzs496pQEKlRqxB2Kg
         K2W6Xgmhu4cPPlndnbYVLvPlkGtk0AB2CAkHwRvC6iCmy1Lin2xrbilw6YKcjqxO34Yc
         BjvOVv+NBisbAsWONO7AktgVXLfa24tBsgluCBTdPYpMXgbick0KWoDz/d9BsYqAHBri
         lpL1RKArdr7JsHhlikdxw/2SoQ6wWrK3p4n8vdnrarw3JT1axgKWlE0p73YyJNzvYSoZ
         g4mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UtiIxQMHHlP0o1mHfpWI6vrlAZnfhwNJEFQFjeXQwdg=;
        b=cZ4LhWUlpo/Fl3bqgmH0xnfoWanbD39Dr0KZ4Mn6QpLpbF6+0TOoh4HmQcuaY7Fyjj
         btJiayvdBdh7dJJbQv1154pfjYtLyplSThdaJ71B5HhrpQ0KvUpIfe6gnLzQ5nI2Mqoj
         Q30ud+Qgl5+0BaTaaX5HUSCsGuInQpYMoSp34RHmtn+x5/YgOnJeu8R9XUQlHFcfHitd
         r3a4APQqVsCbGMnFdtIDztqmMW87aJRB2JM18RfiR8omNYyRyAowhHsZvAiOGwimYbdd
         I7th/PkG/Lq/BR9lpFhjniUZ/ETRUP4OWi48/qrzHT+PnBuDbuJaymZlOaujlGG8+eDw
         BwSQ==
X-Gm-Message-State: AOAM5304jj4OwxhzjKSH8e6LlZIhMyZ5n9XrWN4l86fbO4MBe/7VQNXZ
        yilbrhN9tLAo73UrU7Ajjic=
X-Google-Smtp-Source: ABdhPJwV1l4nkehdmxSewP92dmHl87bZtT61H7vBohyIiDvH73gi7sW4argCZUxT44srpSV01hjaqQ==
X-Received: by 2002:a5d:58d8:: with SMTP id o24mr3354435wrf.288.1619357558890;
        Sun, 25 Apr 2021 06:32:38 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.108])
        by smtp.gmail.com with ESMTPSA id a2sm16551552wrt.82.2021.04.25.06.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 06:32:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 03/12] io_uring: decouple CQE filling from requests
Date:   Sun, 25 Apr 2021 14:32:17 +0100
Message-Id: <c9b8da9e42772db2033547dfebe479dc972a0f2c.1619356238.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619356238.git.asml.silence@gmail.com>
References: <cover.1619356238.git.asml.silence@gmail.com>
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

