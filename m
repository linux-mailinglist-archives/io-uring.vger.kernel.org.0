Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6F3403CB0
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 17:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349596AbhIHPmq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 11:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240206AbhIHPmp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 11:42:45 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E715C061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 08:41:37 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id z9-20020a7bc149000000b002e8861aff59so2006865wmi.0
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 08:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=r86w1Mr31sYxDQFvzTVRu+TtvwAd5tN9op6porDzEnI=;
        b=VTDL3yh/NrxZbe16JvKqQulRYCfxvDv5vSRCqT8SCwFtRwlXtU0bhLAWHUbaP1RNTd
         Z27sVy81bNDpq4y+7P5gdKwdlE5JRAwbpTHgYQDi0KssnU5gBt+H4i9lIRMHnOUL3KmP
         VFPlS9alqP/9WPiv81V2+UxFu05hKpu+Ny+TR+4EqD1mQRuy+v3V+7uIthx44UMhLBTd
         bd3ITC8mS2vNs/vt59gSzarV76GnWzK5kNrLS+E6WhoUv9a+knWDFngRN7e7fSqW5QRD
         oyvFRknvQoFgfVBTVPljk1yAH9xXFiU+HhPnaRL2w2hRh672+ENwE/eHUpSUQTH5OmAE
         WnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r86w1Mr31sYxDQFvzTVRu+TtvwAd5tN9op6porDzEnI=;
        b=fiWele8jx+oLQdMAQHJtWvmcOKMZ5EOps4FKJ1F0QslvA9qpuv0WQAgyg35m1WOsS/
         Y5q6iVvkhG0fR32skjT6vAAhak2F2XOpSnlen1Sa7qFXNRafzU7RMYxs/Xx0MebzF3Dc
         e6RgY/3dp4t1gBb9QF586s4bIZYNc+/0ULt9gy1yspATdOZpPRqjn5QHv7LcYwRi+Jhk
         bsyumhg2F/u3mFug882DmCPxFFZNGAu//OpUv1VGHk0UdTs3BsughJg4mh1RVSl/nG+t
         ocng5u3TACiPagR/2KCIMDVLPRvLXpZFGjE0A/SIK9GFHoIrnnX00vZ0n8ubNWnU+osQ
         A6VA==
X-Gm-Message-State: AOAM532JKTURjLhdT17P1cdzWqEuN/06uE/juOVNumD/I/FV0JprLyqZ
        FLtXiqmcn0EndmXxZa6nQ5weZtbPHyU=
X-Google-Smtp-Source: ABdhPJx4Pw9IJL4UMwbzUHiio51YbxyeVfWU4y9pB/p3rglwpyPfnfCQPiRy1r9/uWxUVmZl7wUQVQ==
X-Received: by 2002:a1c:a9d2:: with SMTP id s201mr4339661wme.81.1631115696316;
        Wed, 08 Sep 2021 08:41:36 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id s10sm2580979wrg.42.2021.09.08.08.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 08:41:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/5] io_uring: dedup CQE flushing non-empty checks
Date:   Wed,  8 Sep 2021 16:40:52 +0100
Message-Id: <d7ff8cef5da1b38e8ea648f5aad9a315ddfc7b57.1631115443.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631115443.git.asml.silence@gmail.com>
References: <cover.1631115443.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't do io_submit_flush_completions() when there is no requests
enqueued, and every single caller checks for it. Hide that check into
the function not forgetting about inlining. That will make it much
easier for changing the empty check condition in the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 45e9cd1af97a..3d911f8808bf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1094,7 +1094,7 @@ static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
 static void io_req_task_queue(struct io_kiocb *req);
-static void io_submit_flush_completions(struct io_ring_ctx *ctx);
+static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 static int io_req_prep_async(struct io_kiocb *req);
 
 static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
@@ -1164,6 +1164,12 @@ static inline void req_ref_get(struct io_kiocb *req)
 	atomic_inc(&req->refs);
 }
 
+static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
+{
+	if (ctx->submit_state.compl_nr)
+		__io_submit_flush_completions(ctx);
+}
+
 static inline void __io_req_set_refcount(struct io_kiocb *req, int nr)
 {
 	if (!(req->flags & REQ_F_REFCOUNT)) {
@@ -1252,8 +1258,7 @@ static void io_fallback_req_func(struct work_struct *work)
 		req->io_task_work.func(req, &locked);
 
 	if (locked) {
-		if (ctx->submit_state.compl_nr)
-			io_submit_flush_completions(ctx);
+		io_submit_flush_completions(ctx);
 		mutex_unlock(&ctx->uring_lock);
 	}
 	percpu_ref_put(&ctx->refs);
@@ -2111,8 +2116,7 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
 	if (!ctx)
 		return;
 	if (*locked) {
-		if (ctx->submit_state.compl_nr)
-			io_submit_flush_completions(ctx);
+		io_submit_flush_completions(ctx);
 		mutex_unlock(&ctx->uring_lock);
 		*locked = false;
 	}
@@ -2129,7 +2133,7 @@ static void tctx_task_work(struct callback_head *cb)
 	while (1) {
 		struct io_wq_work_node *node;
 
-		if (!tctx->task_list.first && locked && ctx->submit_state.compl_nr)
+		if (!tctx->task_list.first && locked)
 			io_submit_flush_completions(ctx);
 
 		spin_lock_irq(&tctx->task_lock);
@@ -2314,7 +2318,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 		list_add(&req->inflight_entry, &state->free_list);
 }
 
-static void io_submit_flush_completions(struct io_ring_ctx *ctx)
+static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state = &ctx->submit_state;
@@ -7135,8 +7139,7 @@ static void io_submit_state_end(struct io_submit_state *state,
 {
 	if (state->link.head)
 		io_queue_sqe(state->link.head);
-	if (state->compl_nr)
-		io_submit_flush_completions(ctx);
+	io_submit_flush_completions(ctx);
 	if (state->plug_started)
 		blk_finish_plug(&state->plug);
 }
-- 
2.33.0

