Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B041550DD4
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 02:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237175AbiFTA0e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 20:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237207AbiFTA0e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 20:26:34 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBFFAE41
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:33 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id z9so4950554wmf.3
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jY2nSkB+1l8Zp48/Y+s7yDtln5iA6jefEHAekgrMJ2c=;
        b=GfswRFATgb3RGO+wXEvC30nBsw8nmR79sGjAqG7UxuDkt2NJG9pGAAbvv6iK2DtDCW
         Num8IHwi7AO1cyBF8FXsa7Xv6lxRWnVapLL/7cZuS0xAyUjqkd8NoW7lMlM5ka2NNSsG
         oVSQuSIOWK0ManD8hYeiHRGeU5FXgWQujwlv4qznYmguJrh14Y29x2NYShGuf1bHarwL
         eVOLfGEbdJ311Hbvzi5UkEzp9REyoB1L2aE11WnfYOFaJ6MYE37FitA+F+iPryCx8k3v
         ZOfcDtKTk/INB0xXD39B19NnyeS4yt+euSSH90fh2PSlDow6w7N40Jb0L+mrXKBDwTSj
         2myA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jY2nSkB+1l8Zp48/Y+s7yDtln5iA6jefEHAekgrMJ2c=;
        b=mOKcE4bE8cuYCzMpZKYytJ172/lQfAFTnnIwbr7qwWHyvfVOVqfrroNH5u1r4LINdU
         a5ur+3wrgpgjnBFzHXE/y2WpCc/1rBDBWklD95KMN8qldwtjNPAkteOA2y0HxBj1dZft
         bNDFM1REp4MAEsAuF3ojVSWlWDPALJDDuMGW2LmVwrZyEW+zAGImH/SIf1fkljnkJDB8
         M8TfZ/rZRu7xCGxScJRJpGhraIguk65UdbUAAZ4+BNj+j852LvyyclLpCkWj249Tn3H3
         c6qgfLUB1UANudv7AmFtMa1HqxEGSfduCt0190lE4PZ6wbf7maaPl5WEBuiW4fcIDP3V
         s22Q==
X-Gm-Message-State: AOAM530/K8L9AQTPxLx1ycTDy9nhnv+U15fnIVgPWNZbzQ9TltIYk6Cm
        ChkilkcGF8BpZ2berLcGOzhL6/UGhNsRAQ==
X-Google-Smtp-Source: ABdhPJxq2xEOCaivjjgulBn/nEQrsZkRVM+kemWjr02NmmUB0LbE0a1NdM3/iku1k1vMUYAY58Ojzg==
X-Received: by 2002:a05:600c:358f:b0:39c:7fe7:cbe2 with SMTP id p15-20020a05600c358f00b0039c7fe7cbe2mr32109057wmq.46.1655684791127;
        Sun, 19 Jun 2022 17:26:31 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d4312000000b002167efdd549sm11543807wrq.38.2022.06.19.17.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 17:26:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 01/10] io_uring: fix multi ctx cancellation
Date:   Mon, 20 Jun 2022 01:25:52 +0100
Message-Id: <8d491fe02d8ac4c77ff38061cf86b9a827e8845c.1655684496.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655684496.git.asml.silence@gmail.com>
References: <cover.1655684496.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_try_cancel_requests() loops until there is nothing left to do
with the ring, however there might be several rings and they might have
dependencies between them, e.g. via poll requests.

Instead of cancelling rings one by one, try to cancel them all and only
then loop over if we still potenially some work to do.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 87 ++++++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 41 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0f18a86f3f8c..2d1d4752b955 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -132,7 +132,7 @@ struct io_defer_entry {
 #define IO_DISARM_MASK (REQ_F_ARM_LTIMEOUT | REQ_F_LINK_TIMEOUT | REQ_F_FAIL)
 #define IO_REQ_LINK_FLAGS (REQ_F_LINK | REQ_F_HARDLINK)
 
-static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
+static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 bool cancel_all);
 
@@ -2648,7 +2648,9 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	 * as nobody else will be looking for them.
 	 */
 	do {
-		io_uring_try_cancel_requests(ctx, NULL, true);
+		while (io_uring_try_cancel_requests(ctx, NULL, true))
+			cond_resched();
+
 		if (ctx->sq_data) {
 			struct io_sq_data *sqd = ctx->sq_data;
 			struct task_struct *tsk;
@@ -2806,53 +2808,48 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-static __cold void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
+static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 						struct task_struct *task,
 						bool cancel_all)
 {
 	struct io_task_cancel cancel = { .task = task, .all = cancel_all, };
 	struct io_uring_task *tctx = task ? task->io_uring : NULL;
+	enum io_wq_cancel cret;
+	bool ret = false;
 
 	/* failed during ring init, it couldn't have issued any requests */
 	if (!ctx->rings)
-		return;
-
-	while (1) {
-		enum io_wq_cancel cret;
-		bool ret = false;
+		return false;
 
-		if (!task) {
-			ret |= io_uring_try_cancel_iowq(ctx);
-		} else if (tctx && tctx->io_wq) {
-			/*
-			 * Cancels requests of all rings, not only @ctx, but
-			 * it's fine as the task is in exit/exec.
-			 */
-			cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_task_cb,
-					       &cancel, true);
-			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
-		}
+	if (!task) {
+		ret |= io_uring_try_cancel_iowq(ctx);
+	} else if (tctx && tctx->io_wq) {
+		/*
+		 * Cancels requests of all rings, not only @ctx, but
+		 * it's fine as the task is in exit/exec.
+		 */
+		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_task_cb,
+				       &cancel, true);
+		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
+	}
 
-		/* SQPOLL thread does its own polling */
-		if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
-		    (ctx->sq_data && ctx->sq_data->thread == current)) {
-			while (!wq_list_empty(&ctx->iopoll_list)) {
-				io_iopoll_try_reap_events(ctx);
-				ret = true;
-			}
+	/* SQPOLL thread does its own polling */
+	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
+	    (ctx->sq_data && ctx->sq_data->thread == current)) {
+		while (!wq_list_empty(&ctx->iopoll_list)) {
+			io_iopoll_try_reap_events(ctx);
+			ret = true;
 		}
-
-		ret |= io_cancel_defer_files(ctx, task, cancel_all);
-		mutex_lock(&ctx->uring_lock);
-		ret |= io_poll_remove_all(ctx, task, cancel_all);
-		mutex_unlock(&ctx->uring_lock);
-		ret |= io_kill_timeouts(ctx, task, cancel_all);
-		if (task)
-			ret |= io_run_task_work();
-		if (!ret)
-			break;
-		cond_resched();
 	}
+
+	ret |= io_cancel_defer_files(ctx, task, cancel_all);
+	mutex_lock(&ctx->uring_lock);
+	ret |= io_poll_remove_all(ctx, task, cancel_all);
+	mutex_unlock(&ctx->uring_lock);
+	ret |= io_kill_timeouts(ctx, task, cancel_all);
+	if (task)
+		ret |= io_run_task_work();
+	return ret;
 }
 
 static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
@@ -2882,6 +2879,8 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 
 	atomic_inc(&tctx->in_idle);
 	do {
+		bool loop = false;
+
 		io_uring_drop_tctx_refs(current);
 		/* read completions before cancelations */
 		inflight = tctx_inflight(tctx, !cancel_all);
@@ -2896,13 +2895,19 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 				/* sqpoll task will cancel all its requests */
 				if (node->ctx->sq_data)
 					continue;
-				io_uring_try_cancel_requests(node->ctx, current,
-							     cancel_all);
+				loop |= io_uring_try_cancel_requests(node->ctx,
+							current, cancel_all);
 			}
 		} else {
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-				io_uring_try_cancel_requests(ctx, current,
-							     cancel_all);
+				loop |= io_uring_try_cancel_requests(ctx,
+								     current,
+								     cancel_all);
+		}
+
+		if (loop) {
+			cond_resched();
+			continue;
 		}
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
-- 
2.36.1

