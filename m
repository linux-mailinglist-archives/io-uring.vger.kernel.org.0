Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5EE55CB0A
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 14:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbiF0NgW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jun 2022 09:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbiF0NgT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jun 2022 09:36:19 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0416399
        for <io-uring@vger.kernel.org>; Mon, 27 Jun 2022 06:36:18 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656336976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AMJzuZSGA5zOVeL0+SHdCg5RQuGZG9/gdjYNzyrAZ6g=;
        b=bQ30DJtbnKJL2gUsytXfTjebVs7rrhPWXZ02aOsuh74uQJE8BkSKZuBBcsoovZMMAMk6pk
        n50JNAjmUfEQBGvPA+C+0g6QWpleKrjVqB3NdrZ9VO1A4AXKJarC2e1MQ628GYd8iA+Fd1
        6dkU+ZSr/er3g3lke4Po83fiMrXLomk=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 09/11] io_uring: add register fixed worker interface
Date:   Mon, 27 Jun 2022 21:35:39 +0800
Message-Id: <20220627133541.15223-10-hao.xu@linux.dev>
In-Reply-To: <20220627133541.15223-1-hao.xu@linux.dev>
References: <20220627133541.15223-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add an io_uring_register() interface to register fixed workers and
indicate its work capacity.
The argument is an array of two elements each is
    struct {
    	__s32 nr_workers;
    	__s32 max_works;
    }
(nr_workers, max_works)                        meaning

nr_workers or max_works <  -1                  invalid
nr_workers or max_works == -1           get the old value back
nr_workers or max_works >=  0        get the old value and set to the
                                     value

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 include/uapi/linux/io_uring.h |  11 ++++
 io_uring/io-wq.c              | 101 ++++++++++++++++++++++++++++++++++
 io_uring/io-wq.h              |   3 +
 io_uring/io_uring.c           |  71 ++++++++++++++++++++++++
 4 files changed, 186 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8715f0942ec2..5480829d07c0 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -423,6 +423,12 @@ enum {
 	IORING_REGISTER_PBUF_RING		= 22,
 	IORING_UNREGISTER_PBUF_RING		= 23,
 
+	/* set number of fixed workers and number
+	 * of works in a private work list which
+	 * belongs to a fixed worker
+	 */
+	IORING_REGISTER_IOWQ_FIXED_WORKERS	= 24,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -558,4 +564,9 @@ struct io_uring_getevents_arg {
 	__u64	ts;
 };
 
+struct io_uring_fixed_worker_arg {
+	__s32	nr_workers;
+	__s32	max_works;
+};
+
 #endif
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index ce754c78ecac..d54056b98e2b 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1676,6 +1676,107 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
 	return 0;
 }
 
+/*
+ * Set max number of fixed workers and the capacity of private work list,
+ * returns old value. If new_count is -1, then just return the old value.
+ */
+int io_wq_fixed_workers(struct io_wq *wq,
+			struct io_uring_fixed_worker_arg *new_count)
+{
+	struct io_uring_fixed_worker_arg prev[IO_WQ_ACCT_NR];
+	bool first_node = true;
+	int i, node;
+	bool readonly[2] = {
+		(new_count[0].nr_workers == -1 && new_count[0].max_works == -1),
+		(new_count[1].nr_workers == -1 && new_count[1].max_works == -1),
+	};
+
+	BUILD_BUG_ON((int) IO_WQ_ACCT_BOUND   != (int) IO_WQ_BOUND);
+	BUILD_BUG_ON((int) IO_WQ_ACCT_UNBOUND != (int) IO_WQ_UNBOUND);
+	BUILD_BUG_ON((int) IO_WQ_ACCT_NR      != 2);
+
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		if (new_count[i].nr_workers > task_rlimit(current, RLIMIT_NPROC))
+			new_count[i].nr_workers =
+				task_rlimit(current, RLIMIT_NPROC);
+	}
+
+	rcu_read_lock();
+	for_each_node(node) {
+		int j;
+		struct io_wqe *wqe = wq->wqes[node];
+
+		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+			struct io_wqe_acct *acct = &wqe->fixed_acct[i];
+			int *nr_fixed, *max_works;
+			struct io_worker **fixed_workers;
+			int nr = new_count[i].nr_workers;
+
+			raw_spin_lock(&acct->lock);
+			nr_fixed = &acct->nr_fixed;
+			max_works = &acct->max_works;
+			fixed_workers = acct->fixed_workers;
+			if (first_node) {
+				prev[i].nr_workers = *nr_fixed;
+				prev[i].max_works = *max_works;
+			}
+			if (readonly[i]) {
+				raw_spin_unlock(&acct->lock);
+				continue;
+			}
+			if (*nr_fixed == nr || nr == -1) {
+				*max_works = new_count[i].max_works;
+				raw_spin_unlock(&acct->lock);
+				continue;
+			}
+			for (j = 0; j < *nr_fixed; j++) {
+				struct io_worker *worker = fixed_workers[j];
+
+				if (!worker)
+					continue;
+				worker->flags |= IO_WORKER_F_EXIT;
+				/*
+				 * Mark index to -1 to avoid false deletion
+				 * in io_fixed_worker_exit()
+				 */
+				worker->index = -1;
+				/*
+				 * Once a worker is in fixed_workers array
+				 * it is definitely there before we release
+				 * the acct->lock below. That's why we don't
+				 * need to increment the worker->ref here.
+				 */
+				wake_up_process(worker->task);
+			}
+			kfree(fixed_workers);
+			acct->fixed_workers = NULL;
+			*nr_fixed = 0;
+			*max_works = new_count[i].max_works;
+			acct->fixed_workers = kzalloc_node(
+						sizeof(*fixed_workers) * nr,
+						GFP_KERNEL, wqe->node);
+			if (!acct->fixed_workers) {
+				raw_spin_unlock(&acct->lock);
+				return -ENOMEM;
+			}
+			raw_spin_unlock(&acct->lock);
+			for (j = 0; j < nr; j++)
+				io_wqe_create_worker(wqe, acct);
+
+			acct->fixed_worker_registered = !!nr;
+		}
+		first_node = false;
+	}
+	rcu_read_unlock();
+
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		new_count[i].nr_workers = prev[i].nr_workers;
+		new_count[i].max_works = prev[i].max_works;
+	}
+
+	return 0;
+}
+
 static __init int io_wq_init(void)
 {
 	int ret;
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 78efbb8c53f0..fbbe13d75595 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -3,6 +3,7 @@
 
 #include <linux/refcount.h>
 #include <linux/io_uring_types.h>
+#include <uapi/linux/io_uring.h>
 
 struct io_wq;
 
@@ -188,6 +189,8 @@ void io_wq_hash_work(struct io_wq_work *work, void *val);
 
 int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask);
 int io_wq_max_workers(struct io_wq *wq, int *new_count);
+int io_wq_fixed_workers(struct io_wq *wq,
+			struct io_uring_fixed_worker_arg *new_count);
 
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index afda42246d12..637c5a50c97f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3764,6 +3764,71 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+static __cold int io_register_iowq_fixed_workers(struct io_ring_ctx *ctx,
+						 void __user *arg)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_uring_task *tctx = NULL;
+	struct io_sq_data *sqd = NULL;
+	struct io_uring_fixed_worker_arg new_count[2];
+	int i, ret;
+
+	if (copy_from_user(new_count, arg, sizeof(new_count)))
+		return -EFAULT;
+	for (i = 0; i < ARRAY_SIZE(new_count); i++) {
+		int nr_workers = new_count[i].nr_workers;
+		int max_works = new_count[i].max_works;
+
+		if (nr_workers < -1 || max_works < -1)
+			return -EINVAL;
+	}
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
+	if (tctx && tctx->io_wq) {
+		ret = io_wq_fixed_workers(tctx->io_wq, new_count);
+		if (ret)
+			goto err;
+	} else {
+		memset(new_count, -1, sizeof(new_count));
+	}
+
+	if (sqd) {
+		mutex_unlock(&sqd->lock);
+		io_put_sq_data(sqd);
+	}
+
+	if (copy_to_user(arg, new_count, sizeof(new_count)))
+		return -EFAULT;
+
+	/* that's it for SQPOLL, only the SQPOLL task creates requests */
+	if (sqd)
+		return 0;
+
+err:
+	if (sqd) {
+		mutex_unlock(&sqd->lock);
+		io_put_sq_data(sqd);
+	}
+	return ret;
+}
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -3910,6 +3975,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_unregister_pbuf_ring(ctx, arg);
 		break;
+	case IORING_REGISTER_IOWQ_FIXED_WORKERS:
+		ret = -EINVAL;
+		if (!arg || nr_args != 2)
+			break;
+		ret = io_register_iowq_fixed_workers(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.25.1

