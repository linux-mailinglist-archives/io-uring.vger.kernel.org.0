Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEBB787BB7
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243973AbjHXWzp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244033AbjHXWzf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:35 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1816A1FD3
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:26 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-99c1f6f3884so35181466b.0
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917724; x=1693522524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IgZ/67ABnBamuCv5GTpb6bProem6msgVgR9jIq/TUv4=;
        b=sxd7AiU7ZPL+TShbFg4l+3e5oI8hDkEplvoAoeVGIHI9MEBRGHYApHJ62FhY2SdHWB
         nlc6BiyiP/0dA9c0n66KWsh3f7kMih5NcpUMhkjUB+OSnxnMkmLw0f/rpOSoLyYVlKfr
         B9CU2dG0CiBewLh3DJ16g3lEjbsJ1nzsNpadifUjQYYeP9xWDV3W9G+66qbL3Ir/iRLv
         //+gCWPuXoUdDCJrbJ5XUJokrnnWXJy0obteTsRYyjh6rDHDrwRGHCokZORCX7zSq41n
         mSekAS5iuf97zDHucDfTCsPrb2Nfl5JK7KwWrLbsVq6rvVT3AJwvxnaV4/IJGxhwzqc4
         WVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917724; x=1693522524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IgZ/67ABnBamuCv5GTpb6bProem6msgVgR9jIq/TUv4=;
        b=GBLlo5zpUW9TU27DfuHFokgqMTHpfvWpA0BmrTkkeSuUSQLMG+H6pEJ5vTzJ9GA3J7
         +xR7Y7aG9f1fMFtjjvfn6jALNMgyc8pwbRSxgpDeJNVV2XCI6VwxObXhqGQZSLDZrgWY
         NBPxletn95BuouXnK7G1s87xBOkikEj/X+DqXX+lRQtiqCIBcexbidJep6qB83ZUYgfz
         cZC7HieyT3eXJpDHGNsNrVIOkv7h+k9whn7IxRZuZyJT/Vt4iaMCp+JjPjTkdB8n0VNx
         c4ZxGYhHRdQ5K1UvclJJ4m5UW919Coc3koiDcnBe5OSgOh3ve4IOgeIY9pyfmPfgu9zc
         Kd4g==
X-Gm-Message-State: AOJu0Yy5u+OCkiqI1sQURZcOzVbVLzA8QyD1uinmYNeVNrVuRd1ibwg7
        RsbOargldM3+EewNQ1lFMytEfdoFJKo=
X-Google-Smtp-Source: AGHT+IGvLUKG9Lt4y8d51sYJ2LOtZWu8iqG5+NORwXkd3AFDS/kFQ65EymKi1P5M0Hg29B8zb8djeA==
X-Received: by 2002:a17:906:6b92:b0:969:93f2:259a with SMTP id l18-20020a1709066b9200b0096993f2259amr12132165ejr.73.1692917723924;
        Thu, 24 Aug 2023 15:55:23 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 07/15] io_uring: merge iopoll and normal completion paths
Date:   Thu, 24 Aug 2023 23:53:29 +0100
Message-ID: <3840473f5e8a960de35b77292026691880f6bdbc.1692916914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692916914.git.asml.silence@gmail.com>
References: <cover.1692916914.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_do_iopoll() and io_submit_flush_completions() are pretty similar,
both filling CQEs and then free a list of requests. Don't duplicate it
and make iopoll use __io_submit_flush_completions(), which also helps
with inlining and other optimisations.

For that, we need to first find all completed iopoll requests and splice
them from the iopoll list and then pass it down. This adds one extra
list traversal, which should be fine as requests will stay hot in cache.

CQ locking is already conditional, introduce ->lockless_cq and skip
locking for IOPOLL as it's protected by ->uring_lock.

We also add a wakeup optimisation for IOPOLL to __io_cq_unlock_post(),
so it works just like io_cqring_ev_posted_iopoll().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            | 18 ++++++++++++------
 io_uring/io_uring.h            |  2 +-
 io_uring/rw.c                  | 24 +++++-------------------
 4 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 9795eda529f7..c0c03d8059df 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -205,6 +205,7 @@ struct io_ring_ctx {
 		unsigned int		has_evfd: 1;
 		/* all CQEs should be posted only by the submitter task */
 		unsigned int		task_complete: 1;
+		unsigned int		lockless_cq: 1;
 		unsigned int		syscall_iopoll: 1;
 		unsigned int		poll_activated: 1;
 		unsigned int		drain_disabled: 1;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7c1ef5b6628d..e8321903e3f3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -147,7 +147,6 @@ static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 bool cancel_all);
 
 static void io_queue_sqe(struct io_kiocb *req);
-static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 
 struct kmem_cache *req_cachep;
 
@@ -616,7 +615,7 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 
 static inline void __io_cq_lock(struct io_ring_ctx *ctx)
 {
-	if (!ctx->task_complete)
+	if (!ctx->lockless_cq)
 		spin_lock(&ctx->completion_lock);
 }
 
@@ -630,8 +629,11 @@ static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
 {
 	io_commit_cqring(ctx);
 	if (!ctx->task_complete) {
-		spin_unlock(&ctx->completion_lock);
-		io_cqring_wake(ctx);
+		if (!ctx->lockless_cq)
+			spin_unlock(&ctx->completion_lock);
+		/* IOPOLL rings only need to wake up if it's also SQPOLL */
+		if (!ctx->syscall_iopoll)
+			io_cqring_wake(ctx);
 	}
 	io_commit_cqring_flush(ctx);
 }
@@ -1485,7 +1487,8 @@ void io_queue_next(struct io_kiocb *req)
 		io_req_task_queue(nxt);
 }
 
-void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node)
+static void io_free_batch_list(struct io_ring_ctx *ctx,
+			       struct io_wq_work_node *node)
 	__must_hold(&ctx->uring_lock)
 {
 	do {
@@ -1522,7 +1525,7 @@ void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node)
 	} while (node);
 }
 
-static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
+void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state = &ctx->submit_state;
@@ -3836,6 +3839,9 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	    !(ctx->flags & IORING_SETUP_SQPOLL))
 		ctx->task_complete = true;
 
+	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL))
+		ctx->lockless_cq = true;
+
 	/*
 	 * lazy poll_wq activation relies on ->task_complete for synchronisation
 	 * purposes, see io_activate_pollwq()
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2960e35b32a5..07fd185064d2 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -72,7 +72,7 @@ int io_ring_add_registered_file(struct io_uring_task *tctx, struct file *file,
 int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts);
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin);
-void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node);
+void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 int io_req_prep_async(struct io_kiocb *req);
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 20140d3505f1..0a1e515f0510 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -983,13 +983,6 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
-static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
-{
-	if (ctx->flags & IORING_SETUP_SQPOLL)
-		io_cqring_wake(ctx);
-	io_commit_cqring_flush(ctx);
-}
-
 void io_rw_fail(struct io_kiocb *req)
 {
 	int res;
@@ -1060,24 +1053,17 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
 		nr_events++;
-		if (unlikely(req->flags & REQ_F_CQE_SKIP))
-			continue;
-
 		req->cqe.flags = io_put_kbuf(req, 0);
-		if (unlikely(!io_fill_cqe_req(ctx, req))) {
-			spin_lock(&ctx->completion_lock);
-			io_req_cqe_overflow(req);
-			spin_unlock(&ctx->completion_lock);
-		}
 	}
-
 	if (unlikely(!nr_events))
 		return 0;
 
-	io_commit_cqring(ctx);
-	io_cqring_ev_posted_iopoll(ctx);
 	pos = start ? start->next : ctx->iopoll_list.first;
 	wq_list_cut(&ctx->iopoll_list, prev, start);
-	io_free_batch_list(ctx, pos);
+
+	if (WARN_ON_ONCE(!wq_list_empty(&ctx->submit_state.compl_reqs)))
+		return 0;
+	ctx->submit_state.compl_reqs.first = pos;
+	__io_submit_flush_completions(ctx);
 	return nr_events;
 }
-- 
2.41.0

