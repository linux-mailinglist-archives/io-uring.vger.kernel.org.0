Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC326D97F2
	for <lists+io-uring@lfdr.de>; Thu,  6 Apr 2023 15:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238390AbjDFNVJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Apr 2023 09:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238213AbjDFNU7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Apr 2023 09:20:59 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C290A24A;
        Thu,  6 Apr 2023 06:20:29 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-50263dfe37dso6341573a12.0;
        Thu, 06 Apr 2023 06:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680787227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oqZbUgv+5sJFBzHrCS1hTYdTwSuWj9s9ZIzsmU8yC2w=;
        b=maOYQjQq1ZPe9acCFlODIHwUftIv67eW0Nk33eytV7fht+mIS6IOChb1Fpyyf+ladC
         /jzbQ1Uh7XIyb3FhHZN1Y3USpm4DFrMrP2/EMOyMOTG4f7J+6aB517MwlQvVUaQctn5N
         Wg2z/ofeOItPpQtCPxHv3ZBywLDnNr8qYlBl8IQE9Dmu2rtzjCmsct/cUcKRMNNIiPwY
         EcdjaphACQqnpXYQ1llqNRibnTn9t+cVpBPAPNd9Y2/oDXDqe+IeAQHHVntwt6tkoE5G
         IBdJ/xlK0gqFMwYJb7sQfdvS8ddABQ6+/Q7ng7HWI+ACFWT/YezGm0VDNDKgRgdq7KlJ
         b71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680787227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oqZbUgv+5sJFBzHrCS1hTYdTwSuWj9s9ZIzsmU8yC2w=;
        b=VO01mcZ+KeCbMJ7VjSdCAWCGyb0ppVnkcPuTtmESna9RNLosurPiz9cSwr3ujMHNiZ
         gygpbuaTZSIU4jtOMjbGsMdyu50gZjBNeRe9gsUaGc9woFFtZn4WKPNnQUrKoeWVTkmM
         nMjCdMQ8NhaQYrWwNMhzbd/uQjAf0oHOMJmxKhQ0myk9FrkO+iucUkkiEX90zuMd0kjR
         47IMjAPg6R4Q9Jd62aGlxkKeycQOCKxQtPxlXszfDKij2ME4arIGdwsTnAJuGU+mU7x+
         pYHYtLpr/wJ4bG/dg2tgDHi4VwqXetUQfNVlkvqGcE244Ogznz92NElDMnkQXkvaoyVn
         5tpw==
X-Gm-Message-State: AAQBX9cGUqo2efz0f2BRGVYmvfvHgFURddHR92JZubupCuYLlwKe3j4R
        63utAEz9TJ81W+MWfDgSufhXa0BLccE=
X-Google-Smtp-Source: AKy350ZH1y4lO92mtQ+oGAOmmz/4VGtw0S/ag8WjFpP1TR8VRgW/7kKdvzi/z1PQxSNAHPAb4acOrw==
X-Received: by 2002:aa7:c0d1:0:b0:501:cf67:97fc with SMTP id j17-20020aa7c0d1000000b00501cf6797fcmr5477693edp.10.1680787227544;
        Thu, 06 Apr 2023 06:20:27 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a638])
        by smtp.gmail.com with ESMTPSA id m20-20020a509994000000b0050470aa444fsm312732edb.51.2023.04.06.06.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 06:20:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/8] io_uring: optimise io_req_local_work_add
Date:   Thu,  6 Apr 2023 14:20:14 +0100
Message-Id: <fb11597e9bbcb365901824f8c5c2cf0d6ee100d0.1680782017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1680782016.git.asml.silence@gmail.com>
References: <cover.1680782016.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Chains of memory accesses are never good for performance.
The req->task->io_uring->in_cancel in io_req_local_work_add() is there
so that when a task is exiting via io_uring_try_cancel_requests() and
starts waiting for completions it gets woken up by every new task_work
item queued.

Do a little trick by announcing waiting in io_uring_try_cancel_requests()
making io_req_local_work_add() to wake us up. We also need to check for
deferred tw items after prepare_to_wait(TASK_INTERRUPTIBLE);

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0ea50c46f27f..9bbf58297a0e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1335,10 +1335,6 @@ static void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 			      &req->io_task_work.node));
 
 	if (!first) {
-		if (unlikely(atomic_read(&req->task->io_uring->in_cancel))) {
-			io_move_task_work_from_local(ctx);
-			return;
-		}
 		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 		if (ctx->has_evfd)
@@ -3205,6 +3201,12 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	enum io_wq_cancel cret;
 	bool ret = false;
 
+	/* set it so io_req_local_work_add() would wake us up */
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+		atomic_set(&ctx->cq_wait_nr, 1);
+		smp_mb();
+	}
+
 	/* failed during ring init, it couldn't have issued any requests */
 	if (!ctx->rings)
 		return false;
@@ -3259,6 +3261,8 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_ring_ctx *ctx;
+	struct io_tctx_node *node;
+	unsigned long index;
 	s64 inflight;
 	DEFINE_WAIT(wait);
 
@@ -3280,9 +3284,6 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 			break;
 
 		if (!sqd) {
-			struct io_tctx_node *node;
-			unsigned long index;
-
 			xa_for_each(&tctx->xa, index, node) {
 				/* sqpoll task will cancel all its requests */
 				if (node->ctx->sq_data)
@@ -3305,7 +3306,13 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
 		io_run_task_work();
 		io_uring_drop_tctx_refs(current);
-
+		xa_for_each(&tctx->xa, index, node) {
+			if (!llist_empty(&node->ctx->work_llist)) {
+				WARN_ON_ONCE(node->ctx->submitter_task &&
+					     node->ctx->submitter_task != current);
+				goto end_wait;
+			}
+		}
 		/*
 		 * If we've seen completions, retry without waiting. This
 		 * avoids a race where a completion comes in before we did
@@ -3313,6 +3320,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		 */
 		if (inflight == tctx_inflight(tctx, !cancel_all))
 			schedule();
+end_wait:
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
 
-- 
2.40.0

