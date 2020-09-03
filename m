Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF0925B8B7
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 04:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgICCVJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 22:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727921AbgICCVI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 22:21:08 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE294C061244
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 19:21:07 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w7so968587pfi.4
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 19:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5vPvKZSCDTewOQL7Zk2TfYJ4uTHSN6aO/4VElkMYPlo=;
        b=k8U98ee98lnZr4YJMnnDjpvK6DkSAf/MO+bfvzP74Me4xSFpEIisg2CWKnMS/uHjCD
         Pb+R/fy2R8P/V27aaDAZSyjVb2XZi0wbAkuDONYYWdqAiuVU3Gp+8vm7DPnbHOdfReCw
         CujLA7xvXXqJjmXd1cmfWT1JZR0+VwtXa92C0Pf4vSzYiL7Rbx9Y/EpJHyNiEGDg6zvs
         cfiKbA1NF1GoOLmLE0TjVJ1/IQPo+ImWXa7Blfq4OibtT4cwU5yCSyzHjQQC5O915/I0
         JErkBPLi+0IUL1F9IMOKTo2WJsp474uhRlzBUZmypNYgGHF/8qo72g64YFNtDbPHhMcZ
         4/mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5vPvKZSCDTewOQL7Zk2TfYJ4uTHSN6aO/4VElkMYPlo=;
        b=b1+sFYpEKXDyG/vc/aLLI0nmaW/auA2WJNHw7p3o+dG3trrWhy3bWGjHnfx1RQtSVV
         mT4PVTPze4cVkc44XnaA1M03VeKCal5skU32bGtmNDgD0+kna/5K/deToS46otV+ut4V
         6Mz7rb/h57RLInlaZuKSBkddCMAPudaEI3voZEeIBbjezcL0FyyQGiiE1fJevzVJ78Q8
         5IFBfIgCbMz4saZo6mTt8MaShJ4L7tRU1kgxyDoC5sKYkiw4cxgSxyVSU2GVL9Vx7ENl
         tdpG4p1+njdCo0SWKpKjiviilTTdySVeoXz+11BNno2bzpqqObY8raQZf1lF3ZrzmsSl
         Cf7Q==
X-Gm-Message-State: AOAM533piG7HvcJj9j7eabrR0Vr3zQ0lKxtOAmciN01PjELIkjJ/5i7a
        w2y1gaOSng+PRS8hF3YSRNgqpDFKM4Sz+RGr
X-Google-Smtp-Source: ABdhPJzwGmYGD/dF3C3tPPx7WocEgRw9J+2K70a/yD3+c1cbfI1KVAScPwV96fK8nQupm3D8SDYa4Q==
X-Received: by 2002:a62:ce41:0:b029:13c:1611:66bc with SMTP id y62-20020a62ce410000b029013c161166bcmr553048pfg.7.1599099667169;
        Wed, 02 Sep 2020 19:21:07 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id ie13sm663102pjb.5.2020.09.02.19.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 19:21:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/8] io_uring: base SQPOLL handling off io_sq_data
Date:   Wed,  2 Sep 2020 20:20:52 -0600
Message-Id: <20200903022053.912968-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903022053.912968-1-axboe@kernel.dk>
References: <20200903022053.912968-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove the SQPOLL thread from the ctx, and use the io_sq_data as the
data structure we pass in. io_sq_data has a list of ctx's that we can
then iterate over and handle.

As of now we're ready to handle multiple ctx's, though we're still just
handling a single one after this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 101 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 72 insertions(+), 29 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 35ea69aad9c0..5bafc7a2c65c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -231,6 +231,12 @@ struct io_restriction {
 
 struct io_sq_data {
 	refcount_t		refs;
+
+	/* ctx's that are using this sqd */
+	struct list_head	ctx_list;
+	struct list_head	ctx_new_list;
+	struct mutex		ctx_lock;
+
 	struct task_struct	*thread;
 	struct wait_queue_head	wait;
 };
@@ -290,6 +296,7 @@ struct io_ring_ctx {
 	struct files_struct	*sqo_files;
 
 	struct wait_queue_entry	sqo_wait_entry;
+	struct list_head	sqd_list;
 
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
@@ -1090,6 +1097,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 
 	ctx->flags = p->flags;
+	INIT_LIST_HEAD(&ctx->sqd_list);
 	init_waitqueue_head(&ctx->cq_wait);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->ref_comp);
@@ -6712,49 +6720,74 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 	return SQT_DID_WORK;
 }
 
+static void io_sqd_init_new(struct io_sq_data *sqd)
+{
+	struct io_ring_ctx *ctx;
+
+	while (!list_empty(&sqd->ctx_new_list)) {
+		ctx = list_first_entry(&sqd->ctx_new_list, struct io_ring_ctx, sqd_list);
+		init_wait(&ctx->sqo_wait_entry);
+		ctx->sqo_wait_entry.func = io_sq_wake_function;
+		list_move_tail(&ctx->sqd_list, &sqd->ctx_list);
+		complete(&ctx->sq_thread_comp);
+	}
+}
+
 static int io_sq_thread(void *data)
 {
-	struct io_ring_ctx *ctx = data;
-	const struct cred *old_cred;
+	struct io_sq_data *sqd = data;
+	struct io_ring_ctx *ctx;
 	unsigned long start_jiffies;
 
-	init_wait(&ctx->sqo_wait_entry);
-	ctx->sqo_wait_entry.func = io_sq_wake_function;
+	start_jiffies = jiffies;
+	while (!kthread_should_park()) {
+		const struct cred *old_cred = NULL;
+		enum sq_ret ret = 0;
 
-	complete(&ctx->sq_thread_comp);
+		mutex_lock(&sqd->ctx_lock);
 
-	old_cred = override_creds(ctx->creds);
+		if (unlikely(!list_empty(&sqd->ctx_new_list)))
+			io_sqd_init_new(sqd);
 
-	task_lock(current);
-	current->files = ctx->sqo_files;
-	task_unlock(current);
+		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+			if (current->cred != ctx->creds) {
+				if (old_cred)
+					revert_creds(old_cred);
+				old_cred = override_creds(ctx->creds);
+			}
 
-	start_jiffies = jiffies;
-	while (!kthread_should_park()) {
-		enum sq_ret ret;
+			if (current->files != ctx->sqo_files) {
+				task_lock(current);
+				current->files = ctx->sqo_files;
+				task_unlock(current);
+			}
 
-		ret = __io_sq_thread(ctx, start_jiffies);
-		switch (ret) {
-		case SQT_IDLE:
-			schedule();
-			start_jiffies = jiffies;
-			continue;
-		case SQT_SPIN:
+			ret |= __io_sq_thread(ctx, start_jiffies);
+
+			io_sq_thread_drop_mm();
+		}
+
+		mutex_unlock(&sqd->ctx_lock);
+
+		if (old_cred)
+			revert_creds(old_cred);
+
+		if (ret & SQT_SPIN) {
 			io_run_task_work();
 			cond_resched();
-			fallthrough;
-		case SQT_DID_WORK:
-			continue;
+		} else if (ret == SQT_IDLE) {
+			schedule();
+			start_jiffies = jiffies;
 		}
 	}
 
 	io_run_task_work();
 
-	io_sq_thread_drop_mm();
-	task_lock(current);
-	current->files = NULL;
-	task_unlock(current);
-	revert_creds(old_cred);
+	if (current->files) {
+		task_lock(current);
+		current->files = NULL;
+		task_unlock(current);
+	}
 
 	kthread_parkme();
 
@@ -6955,6 +6988,9 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
 		return ERR_PTR(-ENOMEM);
 
 	refcount_set(&sqd->refs, 1);
+	INIT_LIST_HEAD(&sqd->ctx_list);
+	INIT_LIST_HEAD(&sqd->ctx_new_list);
+	mutex_init(&sqd->ctx_lock);
 	init_waitqueue_head(&sqd->wait);
 	return sqd;
 }
@@ -6967,6 +7003,10 @@ static void io_sq_thread_stop(struct io_ring_ctx *ctx)
 		if (sqd->thread)
 			wait_for_completion(&ctx->sq_thread_comp);
 
+		mutex_lock(&sqd->ctx_lock);
+		list_del(&ctx->sqd_list);
+		mutex_unlock(&sqd->ctx_lock);
+
 		io_put_sq_data(sqd);
 		ctx->sq_data = NULL;
 	}
@@ -7620,6 +7660,9 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			goto err;
 		}
 		ctx->sq_data = sqd;
+		mutex_lock(&sqd->ctx_lock);
+		list_add(&ctx->sqd_list, &sqd->ctx_new_list);
+		mutex_unlock(&sqd->ctx_lock);
 
 		/*
 		 * We will exit the sqthread before current exits, so we can
@@ -7641,10 +7684,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			if (!cpu_online(cpu))
 				goto err;
 
-			sqd->thread = kthread_create_on_cpu(io_sq_thread, ctx,
+			sqd->thread = kthread_create_on_cpu(io_sq_thread, sqd,
 							cpu, "io_uring-sq");
 		} else {
-			sqd->thread = kthread_create(io_sq_thread, ctx,
+			sqd->thread = kthread_create(io_sq_thread, sqd,
 							"io_uring-sq");
 		}
 		if (IS_ERR(sqd->thread)) {
-- 
2.28.0

