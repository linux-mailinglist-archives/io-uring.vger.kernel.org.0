Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C13040786E
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 15:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbhIKNx7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 09:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235906AbhIKNx6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 09:53:58 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AD2C061574
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 06:52:45 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id m9so6966238wrb.1
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 06:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7SjmRH14w4hr2azwpkqm+ECjSOAnBY208Jf+zURRAm4=;
        b=Jk8toOFtQE3tHvY+cjBlVp6ZPFRJmLxfMLpg16EGsP7/4ahCfj7sR+1ZeekPWSCrSR
         YBjgdGstJpM/ldzOhZRErOwIA1LW8LdF2cqS83R/ziazDWCnNub7i7Vol7Zg1D5iEuEv
         yHW4NziUDCqqrTmNkpvCJdBipFNTdBiuJ6UwZLDX7fQzPUH5FdfD1F0Z7R8mpaKUUvQP
         21BWp+aG/wp8yJKsrHn6THVQocCxSUo+rhlTbFCHQEQECVyIlZynLRFKVibeUzr23T6J
         vvL0ZxU+HlYXLWEwYOi+rPkGAYpksB93C06gDsW6sIaMLaXwX6oFwCABVR7etnY9Jihi
         BeJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7SjmRH14w4hr2azwpkqm+ECjSOAnBY208Jf+zURRAm4=;
        b=exRC+aFPPUEj9H4zEm2b0Jx62f07CJADyI4o0/d4wClObjtvVvrHJOnHwslVrqncw7
         jv5H6WRQaj9G+e1srwjAvpQcsqfzBeXvkr/bKThVeru8UTXvFQ5lKAsqYeCzA1RCSw1D
         sSMWOFiuALUbag7av6hvnBT/fugLgKu7bdjbMHIsgeQutbTgK0I3JGZaEIfbJ6NHaeFu
         dBb/KWYKLC/a77p25Xly6GVob2n6S85pFjg313ywyf2Sb2WclyA7tWxrJg0KgPqtialx
         SuztzAxpOkBtgDM7IDny/8hmy7AvWT8fZ36qLFzIVpl2XtaHzWJrokBSE7Gg3TTzo8Au
         ijyQ==
X-Gm-Message-State: AOAM531BR4SQqs97KiHX/0XtPwaYz4nGSVH9uskIQzqBZCHVLDt1hjjj
        wjYGIo6BvyOqqT988CVjECKkENJe9/Q=
X-Google-Smtp-Source: ABdhPJy244W9KQlIqBPXH/ZOFhBetDELsK/Kk96u663qjxVbX2M1jaLuSu4gkSywj35qybCbEnV+Jw==
X-Received: by 2002:adf:ce85:: with SMTP id r5mr3226994wrn.323.1631368363848;
        Sat, 11 Sep 2021 06:52:43 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.175])
        by smtp.gmail.com with ESMTPSA id n10sm1774928wrt.78.2021.09.11.06.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 06:52:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: clean cqe filling functions
Date:   Sat, 11 Sep 2021 14:52:00 +0100
Message-Id: <c1c50ac6b6badf319006f580715b8da6438e8e23.1631367587.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631367587.git.asml.silence@gmail.com>
References: <cover.1631367587.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Split io_cqring_fill_event() into a couple of more targeted functions.
The first on is io_fill_cqe_aux() for completions that are not
associated with request completions and doing the ->cq_extra accounting.
Examples are additional CQEs from multishot poll and rsrc notifications.

The second is io_fill_cqe_req(), should be called when it's a normal
request completion. Nothing more to it at the moment, will be used in
later patches.

The last one is inlined __io_fill_cqe() for a finer grained control,
should be used with caution and in hottest places.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 58 ++++++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e6ccdae189b0..1703130ae8df 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1078,8 +1078,8 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 bool cancel_all);
 static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 
-static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-				 long res, unsigned int cflags);
+static void io_fill_cqe_req(struct io_kiocb *req, long res, unsigned int cflags);
+
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req);
 static void io_dismantle_req(struct io_kiocb *req);
@@ -1491,7 +1491,7 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		io_cqring_fill_event(req->ctx, req->user_data, status, 0);
+		io_fill_cqe_req(req, status, 0);
 		io_put_req_deferred(req);
 	}
 }
@@ -1760,8 +1760,8 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	return true;
 }
 
-static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  long res, unsigned int cflags)
+static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
+				 long res, unsigned int cflags)
 {
 	struct io_uring_cqe *cqe;
 
@@ -1782,11 +1782,17 @@ static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data
 	return io_cqring_event_overflow(ctx, user_data, res, cflags);
 }
 
-/* not as hot to bloat with inlining */
-static noinline bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  long res, unsigned int cflags)
+static noinline void io_fill_cqe_req(struct io_kiocb *req, long res,
+				     unsigned int cflags)
+{
+	__io_fill_cqe(req->ctx, req->user_data, res, cflags);
+}
+
+static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
+				     long res, unsigned int cflags)
 {
-	return __io_cqring_fill_event(ctx, user_data, res, cflags);
+	ctx->cq_extra++;
+	return __io_fill_cqe(ctx, user_data, res, cflags);
 }
 
 static void io_req_complete_post(struct io_kiocb *req, long res,
@@ -1795,7 +1801,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 	struct io_ring_ctx *ctx = req->ctx;
 
 	spin_lock(&ctx->completion_lock);
-	__io_cqring_fill_event(ctx, req->user_data, res, cflags);
+	__io_fill_cqe(ctx, req->user_data, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
@@ -2021,8 +2027,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		link->timeout.head = NULL;
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
 			list_del(&link->timeout.list);
-			io_cqring_fill_event(link->ctx, link->user_data,
-					     -ECANCELED, 0);
+			io_fill_cqe_req(link, -ECANCELED, 0);
 			io_put_req_deferred(link);
 			return true;
 		}
@@ -2046,7 +2051,7 @@ static void io_fail_links(struct io_kiocb *req)
 		link->link = NULL;
 
 		trace_io_uring_fail_link(req, link);
-		io_cqring_fill_event(link->ctx, link->user_data, res, 0);
+		io_fill_cqe_req(link, res, 0);
 		io_put_req_deferred(link);
 		link = nxt;
 	}
@@ -2063,8 +2068,7 @@ static bool io_disarm_next(struct io_kiocb *req)
 		req->flags &= ~REQ_F_ARM_LTIMEOUT;
 		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_remove_next_linked(req);
-			io_cqring_fill_event(link->ctx, link->user_data,
-					     -ECANCELED, 0);
+			io_fill_cqe_req(link, -ECANCELED, 0);
 			io_put_req_deferred(link);
 			posted = true;
 		}
@@ -2335,8 +2339,8 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	for (i = 0; i < nr; i++) {
 		struct io_kiocb *req = state->compl_reqs[i];
 
-		__io_cqring_fill_event(ctx, req->user_data, req->result,
-					req->compl.cflags);
+		__io_fill_cqe(ctx, req->user_data, req->result,
+			      req->compl.cflags);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
@@ -2454,8 +2458,8 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 			continue;
 		}
 
-		__io_cqring_fill_event(ctx, req->user_data, req->result,
-					io_put_rw_kbuf(req));
+		__io_fill_cqe(ctx, req->user_data, req->result,
+			      io_put_rw_kbuf(req));
 		(*nr_events)++;
 
 		if (req_ref_put_and_test(req))
@@ -5293,13 +5297,12 @@ static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	}
 	if (req->poll.events & EPOLLONESHOT)
 		flags = 0;
-	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
+	if (!(flags & IORING_CQE_F_MORE)) {
+		io_fill_cqe_req(req, error, flags);
+	} else if (!io_fill_cqe_aux(ctx, req->user_data, error, flags)) {
 		req->poll.done = true;
 		flags = 0;
 	}
-	if (flags & IORING_CQE_F_MORE)
-		ctx->cq_extra++;
-
 	return !(flags & IORING_CQE_F_MORE);
 }
 
@@ -5627,9 +5630,9 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 	do_complete = __io_poll_remove_one(req, io_poll_get_single(req), true);
 
 	if (do_complete) {
-		io_cqring_fill_event(req->ctx, req->user_data, -ECANCELED, 0);
-		io_commit_cqring(req->ctx);
 		req_set_fail(req);
+		io_fill_cqe_req(req, -ECANCELED, 0);
+		io_commit_cqring(req->ctx);
 		io_put_req_deferred(req);
 	}
 	return do_complete;
@@ -5924,7 +5927,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 		return PTR_ERR(req);
 
 	req_set_fail(req);
-	io_cqring_fill_event(ctx, req->user_data, -ECANCELED, 0);
+	io_fill_cqe_req(req, -ECANCELED, 0);
 	io_put_req_deferred(req);
 	return 0;
 }
@@ -8122,8 +8125,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 
 			io_ring_submit_lock(ctx, lock_ring);
 			spin_lock(&ctx->completion_lock);
-			io_cqring_fill_event(ctx, prsrc->tag, 0, 0);
-			ctx->cq_extra++;
+			io_fill_cqe_aux(ctx, prsrc->tag, 0, 0);
 			io_commit_cqring(ctx);
 			spin_unlock(&ctx->completion_lock);
 			io_cqring_ev_posted(ctx);
-- 
2.33.0

