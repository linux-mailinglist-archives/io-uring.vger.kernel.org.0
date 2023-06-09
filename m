Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C99729A06
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 14:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238967AbjFIMak (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 08:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239082AbjFIMaj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 08:30:39 -0400
X-Greylist: delayed 556 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Jun 2023 05:29:56 PDT
Received: from out-21.mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0097B1FE9
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 05:29:56 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686313262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gaD/cBBg+X5hxLR5Nw1m3BpyHfWuwSitgkQ8D/QMqj4=;
        b=JEwQ1VgC7K/GGROyMsqttASO9IN751Mi+cZEJnurv/sCUJytX/t+3xjkatsL0c0Pe5i5uN
        7Y5Y8Ti5us3yHBzP+iIzOL0DutN6q3OR4qAYjUK5Mcs5lGBzNzE5WxcNvqn+mPCbt4idCP
        1ErXvrK2LvSl+AvtJc0cFCSM84uhljo=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 08/11] io_uring: add function to unregister fixed workers
Date:   Fri,  9 Jun 2023 20:20:28 +0800
Message-Id: <20230609122031.183730-9-hao.xu@linux.dev>
In-Reply-To: <20230609122031.183730-1-hao.xu@linux.dev>
References: <20230609122031.183730-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add a new register api to unregister fixed workers.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 include/uapi/linux/io_uring.h |  3 +++
 io_uring/io-wq.c              | 50 ++++++++++++++++++++++++++++++++++-
 io_uring/io-wq.h              |  1 +
 io_uring/io_uring.c           | 45 +++++++++++++++++++++++++++++++
 4 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6dc43be5009d..b0a6e3106b42 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -538,6 +538,9 @@ enum {
 	/* set/get number of fixed workers */
 	IORING_REGISTER_IOWQ_FIXED_WORKERS      = 26,
 
+	/* destroy fixed workers */
+	IORING_UNREGISTER_IOWQ_FIXED_WORKERS      = 27,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 28f13c1c38f4..f39e6b931d17 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1386,7 +1386,7 @@ static void io_wq_clean_fixed_workers(struct io_wq *wq)
 			if (!workers[j])
 				continue;
 			workers[j]->flags |= IO_WORKER_F_EXIT;
-			wake_up_process(worker->task);
+			wake_up_process(workers[j]->task);
 		}
 		kfree(workers);
 	}
@@ -1456,6 +1456,54 @@ int io_wq_fixed_workers(struct io_wq *wq, struct io_uring_fixed_worker_arg *coun
 	return ret;
 }
 
+/*
+ * destroy fixed workers.
+ */
+int io_wq_destroy_fixed_workers(struct io_wq *wq)
+{
+	int i, j;
+
+	raw_spin_lock(&wq->lock);
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		if (wq->acct[i].fixed_nr)
+			break;
+	}
+	raw_spin_unlock(&wq->lock);
+	if (i == IO_WQ_ACCT_NR)
+		return -EFAULT;
+
+	BUILD_BUG_ON((int) IO_WQ_ACCT_BOUND   != (int) IO_WQ_BOUND);
+	BUILD_BUG_ON((int) IO_WQ_ACCT_UNBOUND != (int) IO_WQ_UNBOUND);
+	BUILD_BUG_ON((int) IO_WQ_ACCT_NR      != 2);
+
+	rcu_read_lock();
+	raw_spin_lock(&wq->lock);
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		struct io_wq_acct *acct = &wq->acct[i];
+		struct io_worker **workers = acct->fixed_workers;
+		unsigned int nr = acct->fixed_nr;
+
+		if (!nr)
+			continue;
+
+		for (j = 0; j < nr; j++) {
+			struct io_worker *worker = workers[j];
+
+			BUG_ON(!worker);
+			BUG_ON(!worker->task);
+
+			workers[j]->flags |= IO_WORKER_F_EXIT;
+			wake_up_process(worker->task);
+		}
+		// wait for all workers exit
+		kfree(workers);
+	}
+	raw_spin_unlock(&wq->lock);
+	rcu_read_unlock();
+
+	return 0;
+}
+
 static __init int io_wq_init(void)
 {
 	int ret;
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 88a1ee9fde24..15e93af36511 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -53,6 +53,7 @@ void io_wq_hash_work(struct io_wq_work *work, void *val);
 int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask);
 int io_wq_max_workers(struct io_wq *wq, int *new_count);
 int io_wq_fixed_workers(struct io_wq *wq, struct io_uring_fixed_worker_arg *count);
+int io_wq_destroy_fixed_workers(struct io_wq *wq);
 
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bb8342b4a2c6..b37224cc1d05 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4416,6 +4416,45 @@ static __cold int io_register_iowq_fixed_workers(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+static __cold int io_unregister_iowq_fixed_workers(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_uring_task *tctx = NULL;
+	struct io_sq_data *sqd = NULL;
+	int ret;
+
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		sqd = ctx->sq_data;
+		if (sqd) {
+			/*
+			 * Observe the correct sqd->lock -> ctx->uring_lock
+			 * ordering. Fine to drop uring_lock here, we hold
+			 * a ref to the ctx.
+			 */
+			refcount_inc(&sqd->refs);
+			mutex_unlock(&ctx->uring_lock);
+			mutex_lock(&sqd->lock);
+			mutex_lock(&ctx->uring_lock);
+			if (sqd->thread)
+				tctx = sqd->thread->io_uring;
+		}
+	} else {
+		tctx = current->io_uring;
+	}
+
+	if (tctx && tctx->io_wq)
+		ret = io_wq_destroy_fixed_workers(tctx->io_wq);
+	else
+		ret = -EFAULT;
+
+	if (sqd) {
+		mutex_unlock(&sqd->lock);
+		io_put_sq_data(sqd);
+	}
+
+	return ret;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -4580,6 +4619,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_iowq_fixed_workers(ctx, arg, nr_args);
 		break;
+	case IORING_UNREGISTER_IOWQ_FIXED_WORKERS:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_unregister_iowq_fixed_workers(ctx);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.25.1

