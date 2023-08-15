Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB6677D127
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238903AbjHORdf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238927AbjHORdW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:22 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FB71BD1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:21 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-99bc9e3cbf1so1174802366b.0
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120799; x=1692725599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Inlah7eauKNxkRnddZu2S6oogzyAkD4Jk1qThVpdDDw=;
        b=fU0+PbX9+1kfkD1A1K1SBDmsyx7zzer8Lb4YAb97QRnH+3byu20f7vJPLYKaP8/omo
         4uHv+rc7XyPDa+YhpohhnAVKTqcGfOokhOMrsEUAyKFLTb6QXW3S2Kg4J5K0YAsBhDWv
         /StgOYXiFt8wchhv9nvYSqzdWVXZF2IG7Pihywqb2EABL0TyjLbhSLFP85PTLjJHLllo
         sst+CtxQtt5HQ2WVHxUtC3h3ICocESAycsoJHRmTq2BDAblWEyXtlrVFgq2EqJAx6vru
         GF5WtH3fewGOWW6PuMa7B8Y3RoaNk381Kn3GgAvEkdFLBdhKWiR0S2ic8AIWml3ah9jO
         nRZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120799; x=1692725599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Inlah7eauKNxkRnddZu2S6oogzyAkD4Jk1qThVpdDDw=;
        b=WnvT1a0L2Di5v3uN/YrkR08Xd9Qi693wCEjIbBdFoAz/6Lud+zrGq1ZRb+3v63QwHr
         LEiiGtz9eQoByyjkbGayXyIiElVuMfd39QMWvOmSGEolBzVOAziwF3FrJZ2qbJprDAiH
         3UEF73Wme8xWuOUXHf1ZuhtjjMfdtwdsuREpABUWVibpret0jWYQh/x4l2pr9iXHqPtD
         E/Zvh5qHBIeDxdP51iCx4DP1iU3HmuQwrcHGGqm1T0PMT0+naZlfHNIfeN+LUW6XH2Vm
         bmD6Y1+IjAfdaAh1R/Nz81NI0JTsSZnd8cTZsOavPOu+LZjYjABxFXIPa2/SBasMuXKs
         DyqA==
X-Gm-Message-State: AOJu0YyAOBwYjfsY8aT26fBH0gqkq4IlKq/cbKTWRZKaA6faNBCWMMhe
        QSWsSpbZvltTmGqAuV2vUXjCLPXyh08=
X-Google-Smtp-Source: AGHT+IHcfAvH0QMGpmqma4f9whcoxFycIW2u7CEhtBTebZ7OF8SZ3URCNF9gM0uUDHJq4rZ9eWYYBg==
X-Received: by 2002:a17:907:d94:b0:99b:fcd7:2d7a with SMTP id go20-20020a1709070d9400b0099bfcd72d7amr3119388ejc.34.1692120799320;
        Tue, 15 Aug 2023 10:33:19 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 07/16] io_uring: merge iopoll and normal completion paths
Date:   Tue, 15 Aug 2023 18:31:36 +0100
Message-ID: <efd1e68f819f3507a4983af1dd718381b4cfe9f5.1692119257.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692119257.git.asml.silence@gmail.com>
References: <cover.1692119257.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
index 8d27d2a2e893..204c6a31c5d1 100644
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

