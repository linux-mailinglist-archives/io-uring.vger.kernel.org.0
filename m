Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544F925B8B6
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 04:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgICCVH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 22:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgICCVH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 22:21:07 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E8CC061245
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 19:21:06 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b124so935523pfg.13
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 19:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0epCeH3oe3TiZHpZX9TOghFRxuNTCn0YJin+mH5UEEo=;
        b=frNI/Suhn1cPMQIYpX+99T5RsIfbgCr7Z83dcJSt71LM+Kx/nz3Us83rKRIpwlyzP7
         HMK18vWffY/WJmHgJBHvnkagxy6kG5PFy0UhZGeFtm8Ehy54FYPCvgZ0KKfB+YYF/Tma
         KGZxz5HcL2CZGffc2gTC3uC/nBrKPJgZNiegZ8NtdXO8xC9HX0nhhHDLZzrC5IT7JjS5
         HIynZ7UU1ehTohPWpp60VVLGawOUuPNe0OR2gAZt3wpKOPDsckqcjMR5OIP9Aukdydfw
         U2tKGMUe54g50wj0a1ePKHOmRkgACxOxJbdynx174IM+hDk96KEaHAXhIJErG1DvUWcY
         NaIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0epCeH3oe3TiZHpZX9TOghFRxuNTCn0YJin+mH5UEEo=;
        b=pKHxXv7mzUeRLM1XwcMHyYkee1KBns6vJpPVGJ4OlATonqe/uUW5noekpF2iExmM3j
         4lPXzZAL234it8HaEutlwwvDbLVazdlCAXwM67E3VJBdulhz/EqaiklsaUVdx+Xqq5Vh
         VEALNs8d+XiLkUIqMgmcKijxRcS3n/a1H1yeNbFxQXMtZrbeCtFoasjuIlo/gT1qTHbP
         kVnikXQMDNZZ8OB19v/3oGAmA8FsgTpXUnVlykTcPy0zBX9WG7vkfMph3ED0RLf1QIYl
         VQyNUgI6Apl8seI92vwmzELpXUj6YxGseabui3rZ5NAHHBOnkqIWfTCqtqgwZ7tv7DqG
         75Jg==
X-Gm-Message-State: AOAM530fgsJJXpYhQbSmgAl28A1oigMYPqZ7mgjDVK0y6jsbGoqVbAIo
        DgGKA0ZaWcuGtbsF+t0J0BTPreN2NNEdHGlL
X-Google-Smtp-Source: ABdhPJym6gbb2ZAxBGi63bpqz+sp/aCgXA9M167QtwFfA2h14TuuuX+6t40eakbNiX4pLeqO/sN3MA==
X-Received: by 2002:aa7:8f03:: with SMTP id x3mr1440698pfr.256.1599099666095;
        Wed, 02 Sep 2020 19:21:06 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id ie13sm663102pjb.5.2020.09.02.19.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 19:21:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/8] io_uring: split SQPOLL data into separate structure
Date:   Wed,  2 Sep 2020 20:20:51 -0600
Message-Id: <20200903022053.912968-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903022053.912968-1-axboe@kernel.dk>
References: <20200903022053.912968-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move all the necessary state out of io_ring_ctx, and into a new
structure, io_sq_data. The latter now deals with any state or
variables associated with the SQPOLL thread itself.

In preparation for supporting more than one io_ring_ctx per SQPOLL
thread.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 104 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 73 insertions(+), 31 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8ce1b4247120..35ea69aad9c0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -229,6 +229,12 @@ struct io_restriction {
 	bool registered;
 };
 
+struct io_sq_data {
+	refcount_t		refs;
+	struct task_struct	*thread;
+	struct wait_queue_head	wait;
+};
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -275,13 +281,7 @@ struct io_ring_ctx {
 
 	/* IO offload */
 	struct io_wq		*io_wq;
-	struct task_struct	*sqo_thread;	/* if using sq thread polling */
 	struct mm_struct	*sqo_mm;
-	struct wait_queue_head	*sqo_wait;
-	struct wait_queue_head	__sqo_wait;
-	struct wait_queue_entry	sqo_wait_entry;
-
-
 	/*
 	 * For SQPOLL usage - no reference is held to this file table, we
 	 * rely on fops->flush() and our callback there waiting for the users
@@ -289,6 +289,10 @@ struct io_ring_ctx {
 	 */
 	struct files_struct	*sqo_files;
 
+	struct wait_queue_entry	sqo_wait_entry;
+
+	struct io_sq_data	*sq_data;	/* if using sq thread polling */
+
 	/*
 	 * If used, fixed file set. Writers must ensure that ->refs is dead,
 	 * readers must ensure that ->refs is alive as long as the file* is
@@ -1086,8 +1090,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 
 	ctx->flags = p->flags;
-	init_waitqueue_head(&ctx->__sqo_wait);
-	ctx->sqo_wait = &ctx->__sqo_wait;
 	init_waitqueue_head(&ctx->cq_wait);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->ref_comp);
@@ -1350,8 +1352,8 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
-	if (waitqueue_active(ctx->sqo_wait))
-		wake_up(ctx->sqo_wait);
+	if (ctx->sq_data && waitqueue_active(&ctx->sq_data->wait))
+		wake_up(&ctx->sq_data->wait);
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
 }
@@ -2415,8 +2417,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	else
 		list_add_tail(&req->inflight_entry, &ctx->iopoll_list);
 
-	if ((ctx->flags & IORING_SETUP_SQPOLL) && wq_has_sleeper(ctx->sqo_wait))
-		wake_up(ctx->sqo_wait);
+	if ((ctx->flags & IORING_SETUP_SQPOLL) &&
+	    wq_has_sleeper(&ctx->sq_data->wait))
+		wake_up(&ctx->sq_data->wait);
 }
 
 static void __io_state_file_put(struct io_submit_state *state)
@@ -6635,6 +6638,7 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 				  unsigned long start_jiffies)
 {
 	unsigned long timeout = start_jiffies + ctx->sq_thread_idle;
+	struct io_sq_data *sqd = ctx->sq_data;
 	unsigned int to_submit;
 	int ret = 0;
 
@@ -6675,7 +6679,7 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 		    !percpu_ref_is_dying(&ctx->refs)))
 			return SQT_SPIN;
 
-		prepare_to_wait(ctx->sqo_wait, &ctx->sqo_wait_entry,
+		prepare_to_wait(&sqd->wait, &ctx->sqo_wait_entry,
 					TASK_INTERRUPTIBLE);
 
 		/*
@@ -6687,7 +6691,7 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 		 */
 		if ((ctx->flags & IORING_SETUP_IOPOLL) &&
 		    !list_empty_careful(&ctx->iopoll_list)) {
-			finish_wait(ctx->sqo_wait, &ctx->sqo_wait_entry);
+			finish_wait(&sqd->wait, &ctx->sqo_wait_entry);
 			goto again;
 		}
 
@@ -6697,7 +6701,7 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 		if (!to_submit || ret == -EBUSY)
 			return SQT_IDLE;
 
-		finish_wait(ctx->sqo_wait, &ctx->sqo_wait_entry);
+		finish_wait(&sqd->wait, &ctx->sqo_wait_entry);
 		io_ring_clear_wakeup_flag(ctx);
 	}
 
@@ -6925,18 +6929,46 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	return 0;
 }
 
-static void io_sq_thread_stop(struct io_ring_ctx *ctx)
+static void io_put_sq_data(struct io_sq_data *sqd)
 {
-	if (ctx->sqo_thread) {
-		wait_for_completion(&ctx->sq_thread_comp);
+	if (refcount_dec_and_test(&sqd->refs)) {
 		/*
 		 * The park is a bit of a work-around, without it we get
 		 * warning spews on shutdown with SQPOLL set and affinity
 		 * set to a single CPU.
 		 */
-		kthread_park(ctx->sqo_thread);
-		kthread_stop(ctx->sqo_thread);
-		ctx->sqo_thread = NULL;
+		if (sqd->thread) {
+			kthread_park(sqd->thread);
+			kthread_stop(sqd->thread);
+		}
+
+		kfree(sqd);
+	}
+}
+
+static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
+{
+	struct io_sq_data *sqd;
+
+	sqd = kzalloc(sizeof(*sqd), GFP_KERNEL);
+	if (!sqd)
+		return ERR_PTR(-ENOMEM);
+
+	refcount_set(&sqd->refs, 1);
+	init_waitqueue_head(&sqd->wait);
+	return sqd;
+}
+
+static void io_sq_thread_stop(struct io_ring_ctx *ctx)
+{
+	struct io_sq_data *sqd = ctx->sq_data;
+
+	if (sqd) {
+		if (sqd->thread)
+			wait_for_completion(&ctx->sq_thread_comp);
+
+		io_put_sq_data(sqd);
+		ctx->sq_data = NULL;
 	}
 }
 
@@ -7576,10 +7608,19 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 	int ret;
 
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		struct io_sq_data *sqd;
+
 		ret = -EPERM;
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
 			goto err;
 
+		sqd = io_get_sq_data(p);
+		if (IS_ERR(sqd)) {
+			ret = PTR_ERR(sqd);
+			goto err;
+		}
+		ctx->sq_data = sqd;
+
 		/*
 		 * We will exit the sqthread before current exits, so we can
 		 * avoid taking a reference here and introducing weird
@@ -7600,16 +7641,15 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			if (!cpu_online(cpu))
 				goto err;
 
-			ctx->sqo_thread = kthread_create_on_cpu(io_sq_thread,
-							ctx, cpu,
-							"io_uring-sq");
+			sqd->thread = kthread_create_on_cpu(io_sq_thread, ctx,
+							cpu, "io_uring-sq");
 		} else {
-			ctx->sqo_thread = kthread_create(io_sq_thread, ctx,
+			sqd->thread = kthread_create(io_sq_thread, ctx,
 							"io_uring-sq");
 		}
-		if (IS_ERR(ctx->sqo_thread)) {
-			ret = PTR_ERR(ctx->sqo_thread);
-			ctx->sqo_thread = NULL;
+		if (IS_ERR(sqd->thread)) {
+			ret = PTR_ERR(sqd->thread);
+			sqd->thread = NULL;
 			goto err;
 		}
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
@@ -7631,8 +7671,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 
 static void io_sq_offload_start(struct io_ring_ctx *ctx)
 {
-	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sqo_thread)
-		wake_up_process(ctx->sqo_thread);
+	struct io_sq_data *sqd = ctx->sq_data;
+
+	if ((ctx->flags & IORING_SETUP_SQPOLL) && sqd->thread)
+		wake_up_process(sqd->thread);
 }
 
 static inline void __io_unaccount_mem(struct user_struct *user,
@@ -8396,7 +8438,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		if (!list_empty_careful(&ctx->cq_overflow_list))
 			io_cqring_overflow_flush(ctx, false);
 		if (flags & IORING_ENTER_SQ_WAKEUP)
-			wake_up(ctx->sqo_wait);
+			wake_up(&ctx->sq_data->wait);
 		submitted = to_submit;
 	} else if (to_submit) {
 		mutex_lock(&ctx->uring_lock);
-- 
2.28.0

