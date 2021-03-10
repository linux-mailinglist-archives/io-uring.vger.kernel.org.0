Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8080334BDC
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbhCJWoq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbhCJWoc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:32 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F12C061574
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:32 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id l2so12379774pgb.1
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sTi8VO+Et1tjWrDOt3SimemQrp3IyEkEwFt5xPVJM1I=;
        b=Qz6aLDAf2PFe3cvFZJrkzOvOCHUPNYbMCYtMTeVZ7U7Hy1/IyPZHIOGOEjolEAe2GK
         V3WbwEUy2OIHj7cI/Jvg+3vj8FAbhip2VxWtsfVrzvImvhGmM/NNVAEqOvG3UzqLSpIy
         uYglLrQJCR/sLea2WRHPFjkJP3R2z/+4nm9BIYgjhWq82cXBgTBnpgrjYcWn7NgummLJ
         NljIwg9A0KXvpliSmZGH40Wp4+KlBdfJ5UpcPt8U2TYU0yRE31KRA9WlECiAtjLO0Pas
         v2ad0IM10i4BfOKt20QG/hz3uolMNN4VzEPhpjX9PlI5s2as+wqJnR1Ak9ioTOLNIQ2t
         O9kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sTi8VO+Et1tjWrDOt3SimemQrp3IyEkEwFt5xPVJM1I=;
        b=lmbixPxiSX79aiYDnkCK1rbX5bw9YIhbIMuc/GXteAoSiQsXmEArCMNtCSQ2b2XlMj
         1KRwUP9+vbesEYGEfLFjP9Nuf7J01uVCzWZs0jb4gEY6HLMr7Y96GqGQ1+ELPHj+OqGJ
         u91k5zxJqsYw3W7Axhk5yV/NLRzz2mC7P42ezBq+K6LHe9pSewbMFLJUysttkCtccjje
         yNDKJc7WYDQemOpiWUUuraN6vu/VuwUZWbjTUDeDsGfCVZZC5Rc0CRAicdpuyTEjZYqn
         7uXkZOfhnXpYo41RhH+BVQei4IhCuFtJnPKzentrsHgtRGIn0gVyYGi4gwz00NJd1MUx
         aMhQ==
X-Gm-Message-State: AOAM533MAVKldlGsASXUp1ysvDOQsln+z3g+CAHuGeXXk2TMZ4OiaNpj
        T2eDZaf9B3ufMY+yZviCmMCSxbsEoLNqbA==
X-Google-Smtp-Source: ABdhPJwdi8KRTfjkB4Kh6vozMhX/xLPbrbBguOt2Isq3oBrxRxxNZt+TGExaoUehLMDLdF0t2Q4A7A==
X-Received: by 2002:a65:610f:: with SMTP id z15mr4654648pgu.360.1615416271444;
        Wed, 10 Mar 2021 14:44:31 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:31 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 27/27] io_uring: remove indirect ctx into sqo injection
Date:   Wed, 10 Mar 2021 15:43:58 -0700
Message-Id: <20210310224358.1494503-28-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

We use ->ctx_new_list to notify sqo about new ctx pending, then sqo
should stop and splice it to its sqd->ctx_list, paired with
->sq_thread_comp.

The last one is broken because nobody reinitialises it, and trying to
fix it would only add more complexity and bugs. And the first isn't
really needed as is done under park(), that protects from races well.
Add ctx into sqd->ctx_list directly (under park()), it's much simpler
and allows to kill both, ctx_new_list and sq_thread_comp.

note: apparently there is no real problem at the moment, because
sq_thread_comp is used only by io_sq_thread_finish() followed by
parking, where list_del(&ctx->sqd_list) removes it well regardless
whether it's in the new or the active list.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7072c0eb22c1..5c045a9f7ffe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -262,7 +262,6 @@ struct io_sq_data {
 
 	/* ctx's that are using this sqd */
 	struct list_head	ctx_list;
-	struct list_head	ctx_new_list;
 
 	struct task_struct	*thread;
 	struct wait_queue_head	wait;
@@ -398,7 +397,6 @@ struct io_ring_ctx {
 	struct user_struct	*user;
 
 	struct completion	ref_comp;
-	struct completion	sq_thread_comp;
 
 #if defined(CONFIG_UNIX)
 	struct socket		*ring_sock;
@@ -1137,7 +1135,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_waitqueue_head(&ctx->cq_wait);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->ref_comp);
-	init_completion(&ctx->sq_thread_comp);
 	idr_init(&ctx->io_buffer_idr);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
@@ -6640,19 +6637,6 @@ static void io_sqd_update_thread_idle(struct io_sq_data *sqd)
 	sqd->sq_thread_idle = sq_thread_idle;
 }
 
-static void io_sqd_init_new(struct io_sq_data *sqd)
-{
-	struct io_ring_ctx *ctx;
-
-	while (!list_empty(&sqd->ctx_new_list)) {
-		ctx = list_first_entry(&sqd->ctx_new_list, struct io_ring_ctx, sqd_list);
-		list_move_tail(&ctx->sqd_list, &sqd->ctx_list);
-		complete(&ctx->sq_thread_comp);
-	}
-
-	io_sqd_update_thread_idle(sqd);
-}
-
 static int io_sq_thread(void *data)
 {
 	struct io_sq_data *sqd = data;
@@ -6683,11 +6667,8 @@ static int io_sq_thread(void *data)
 			up_read(&sqd->rw_lock);
 			cond_resched();
 			down_read(&sqd->rw_lock);
-			continue;
-		}
-		if (unlikely(!list_empty(&sqd->ctx_new_list))) {
-			io_sqd_init_new(sqd);
 			timeout = jiffies + sqd->sq_thread_idle;
+			continue;
 		}
 		if (fatal_signal_pending(current))
 			break;
@@ -7099,9 +7080,6 @@ static void io_sq_thread_finish(struct io_ring_ctx *ctx)
 
 	if (sqd) {
 		complete(&sqd->startup);
-		if (sqd->thread)
-			wait_for_completion(&ctx->sq_thread_comp);
-
 		io_sq_thread_park(sqd);
 		list_del(&ctx->sqd_list);
 		io_sqd_update_thread_idle(sqd);
@@ -7153,7 +7131,6 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
 
 	refcount_set(&sqd->refs, 1);
 	INIT_LIST_HEAD(&sqd->ctx_list);
-	INIT_LIST_HEAD(&sqd->ctx_new_list);
 	init_rwsem(&sqd->rw_lock);
 	init_waitqueue_head(&sqd->wait);
 	init_completion(&sqd->startup);
@@ -7834,7 +7811,8 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			ctx->sq_thread_idle = HZ;
 
 		io_sq_thread_park(sqd);
-		list_add(&ctx->sqd_list, &sqd->ctx_new_list);
+		list_add(&ctx->sqd_list, &sqd->ctx_list);
+		io_sqd_update_thread_idle(sqd);
 		io_sq_thread_unpark(sqd);
 
 		if (sqd->thread)
-- 
2.30.2

