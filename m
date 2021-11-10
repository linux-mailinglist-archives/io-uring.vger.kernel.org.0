Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A2344C49F
	for <lists+io-uring@lfdr.de>; Wed, 10 Nov 2021 16:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhKJPwa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Nov 2021 10:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbhKJPwa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Nov 2021 10:52:30 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D0EC061764
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 07:49:42 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d3so4802933wrh.8
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 07:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+bN+F7YfUVibFGV7dogvPZX9KZOQ/+5TVQSgxLejRH4=;
        b=T0hHShw8g3wP5Trp8xtJwRjHeTgZHCwHvDrsIKCG7wiLZzu6mCnDfVlW+1Xkqqul/0
         rkbZhjcO/rtCT6hgJjCiKmOwhGgeebip9IrzF8+sQw8mzc0npHGB2a/2yQyVqYvsPSd9
         J6OiEnVGg7TaWt9WYQ9E9HgMwOIvWoG2NW/Kf8NpLXIKqOdubypx2IGiVY7gOIm5xHyY
         ZJ2cKnbc5pq/DqSdpDW67U8RC0eZYmzM35AnClx56T4M/j626II4/qnazKnj9uYzDCrF
         6RDNMrHLNlg7/wkjwkVsxXyzYWAZZ8erFuaWXAzqjLZdqdpg4l/N3GxklAp2ybHlaUHP
         Y63w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+bN+F7YfUVibFGV7dogvPZX9KZOQ/+5TVQSgxLejRH4=;
        b=kshizwxCOhyozwz5N4sdDlCEBvslLS0SFu99kRq8EXGd8+kbUOff1nFgSGsB4957Wh
         /pBEr58zd+5vvh81Wk6siuEVP5W3aRpdUf1MBZOCXCLr+0NSJyn5luc5wvs+NDDO4gBi
         r6c8k1ael/WjY6NNtQfudHd8LY8lB+nTeJwG0GHYAnRzyKYrjhXrYnkr5q90louKlRCc
         z6Sq6N9zReWG593c+Th/gm/BB56VXLtCZXkP9/kmKwv756nL8WcphsXxZ/gok0HmrVTY
         7z1HJq+2k4R8CSXfZ4voeq1yglmXOn4iILaGYncYvM94/WkbM/l04nKuAi/KchXhwIHm
         D7mg==
X-Gm-Message-State: AOAM531Cw0N5R3Ypu5/MB8T/NtPBSSABBrPo6eeZSYn78YjZmCEewxvN
        WnfgFsX1+dLWJeYuXLv7qyd3XMNscXc=
X-Google-Smtp-Source: ABdhPJy33t8BeJFVWmfhpHub+MLREFz7w0i+/v8IRJ1FrbXZqgLxH3oY9WN30Q2lbYdcPL1p44wicA==
X-Received: by 2002:a5d:400e:: with SMTP id n14mr3817wrp.368.1636559380867;
        Wed, 10 Nov 2021 07:49:40 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.183])
        by smtp.gmail.com with ESMTPSA id l15sm108820wme.47.2021.11.10.07.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 07:49:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 1/4] io_uring: clean cqe filling functions
Date:   Wed, 10 Nov 2021 15:49:31 +0000
Message-Id: <59a9117a4a44fc9efcf04b3afa51e0d080f5943c.1636559119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636559119.git.asml.silence@gmail.com>
References: <cover.1636559119.git.asml.silence@gmail.com>
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
index b07196b4511c..e624f3f850bd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1108,8 +1108,8 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 bool cancel_all);
 static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 
-static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-				 s32 res, u32 cflags);
+static void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags);
+
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req);
 static void io_dismantle_req(struct io_kiocb *req);
@@ -1560,7 +1560,7 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		io_cqring_fill_event(req->ctx, req->user_data, status, 0);
+		io_fill_cqe_req(req, status, 0);
 		io_put_req_deferred(req);
 	}
 }
@@ -1819,8 +1819,8 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	return true;
 }
 
-static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  s32 res, u32 cflags)
+static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
+				 s32 res, u32 cflags)
 {
 	struct io_uring_cqe *cqe;
 
@@ -1841,11 +1841,16 @@ static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data
 	return io_cqring_event_overflow(ctx, user_data, res, cflags);
 }
 
-/* not as hot to bloat with inlining */
-static noinline bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  s32 res, u32 cflags)
+static noinline void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
+{
+	__io_fill_cqe(req->ctx, req->user_data, res, cflags);
+}
+
+static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
+				     s32 res, u32 cflags)
 {
-	return __io_cqring_fill_event(ctx, user_data, res, cflags);
+	ctx->cq_extra++;
+	return __io_fill_cqe(ctx, user_data, res, cflags);
 }
 
 static void io_req_complete_post(struct io_kiocb *req, s32 res,
@@ -1854,7 +1859,7 @@ static void io_req_complete_post(struct io_kiocb *req, s32 res,
 	struct io_ring_ctx *ctx = req->ctx;
 
 	spin_lock(&ctx->completion_lock);
-	__io_cqring_fill_event(ctx, req->user_data, res, cflags);
+	__io_fill_cqe(ctx, req->user_data, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
@@ -2062,8 +2067,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		link->timeout.head = NULL;
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
 			list_del(&link->timeout.list);
-			io_cqring_fill_event(link->ctx, link->user_data,
-					     -ECANCELED, 0);
+			io_fill_cqe_req(link, -ECANCELED, 0);
 			io_put_req_deferred(link);
 			return true;
 		}
@@ -2087,7 +2091,7 @@ static void io_fail_links(struct io_kiocb *req)
 		link->link = NULL;
 
 		trace_io_uring_fail_link(req, link);
-		io_cqring_fill_event(link->ctx, link->user_data, res, 0);
+		io_fill_cqe_req(link, res, 0);
 		io_put_req_deferred(link);
 		link = nxt;
 	}
@@ -2104,8 +2108,7 @@ static bool io_disarm_next(struct io_kiocb *req)
 		req->flags &= ~REQ_F_ARM_LTIMEOUT;
 		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_remove_next_linked(req);
-			io_cqring_fill_event(link->ctx, link->user_data,
-					     -ECANCELED, 0);
+			io_fill_cqe_req(link, -ECANCELED, 0);
 			io_put_req_deferred(link);
 			posted = true;
 		}
@@ -2369,8 +2372,8 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    comp_list);
 
-		__io_cqring_fill_event(ctx, req->user_data, req->result,
-					req->cflags);
+		__io_fill_cqe(ctx, req->user_data, req->result,
+			      req->cflags);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
@@ -2504,8 +2507,8 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
-		__io_cqring_fill_event(ctx, req->user_data, req->result,
-					io_put_rw_kbuf(req));
+		__io_fill_cqe(ctx, req->user_data, req->result,
+			      io_put_rw_kbuf(req));
 		nr_events++;
 	}
 
@@ -5356,13 +5359,13 @@ static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	}
 	if (req->poll.events & EPOLLONESHOT)
 		flags = 0;
-	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
+
+	if (!(flags & IORING_CQE_F_MORE)) {
+		io_fill_cqe_req(req, error, flags);
+	} else if (!io_fill_cqe_aux(ctx, req->user_data, error, flags)) {
 		req->poll.events |= EPOLLONESHOT;
 		flags = 0;
 	}
-	if (flags & IORING_CQE_F_MORE)
-		ctx->cq_extra++;
-
 	return !(flags & IORING_CQE_F_MORE);
 }
 
@@ -5680,9 +5683,9 @@ static bool io_poll_remove_one(struct io_kiocb *req)
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
@@ -5982,7 +5985,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 		return PTR_ERR(req);
 
 	req_set_fail(req);
-	io_cqring_fill_event(ctx, req->user_data, -ECANCELED, 0);
+	io_fill_cqe_req(req, -ECANCELED, 0);
 	io_put_req_deferred(req);
 	return 0;
 }
@@ -8215,8 +8218,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 
 			io_ring_submit_lock(ctx, lock_ring);
 			spin_lock(&ctx->completion_lock);
-			io_cqring_fill_event(ctx, prsrc->tag, 0, 0);
-			ctx->cq_extra++;
+			io_fill_cqe_aux(ctx, prsrc->tag, 0, 0);
 			io_commit_cqring(ctx);
 			spin_unlock(&ctx->completion_lock);
 			io_cqring_ev_posted(ctx);
-- 
2.33.1

