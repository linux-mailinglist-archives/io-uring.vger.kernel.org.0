Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F197299FC
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 14:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbjFIM3i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 08:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240506AbjFIM3e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 08:29:34 -0400
Received: from out-46.mta0.migadu.com (out-46.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636233C19
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 05:28:56 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686313259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a5OtU3AeT801fzenuZasRsfvUafYbVDhac6dEZreRlU=;
        b=bXyer4xJN+MgIvHx/TnVl8zyTaENMHEEegnOgqtNs9ZMVEFu1G2UN5EBUHqsO0MOVOeFsM
        /8fT10lSyHYnZDyrjRywB1FTHZnCGck989Uzkbpu1tJv4CNHtUuN908MpGce5nDEkxYrVT
        a/wT3BDpEthsz3iFJc+8crag3sYtbxs=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 07/11] io_uring: add new api to register fixed workers
Date:   Fri,  9 Jun 2023 20:20:27 +0800
Message-Id: <20230609122031.183730-8-hao.xu@linux.dev>
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

Add a new api to register fixed workers. The api is designed to register
fixed workers for the current task. For simplicity, it doesn't allow
worker number update. We have a separate unregister api to uninstall all
the fixed workers. And then we can register different number of fixed
workers again.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 include/uapi/linux/io_uring.h |  9 ++++
 io_uring/io-wq.c              | 85 +++++++++++++++++++++++++++++++++++
 io_uring/io-wq.h              |  1 +
 io_uring/io_uring.c           | 71 +++++++++++++++++++++++++++++
 4 files changed, 166 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f222d263bc55..6dc43be5009d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -535,6 +535,9 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation */
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
+	/* set/get number of fixed workers */
+	IORING_REGISTER_IOWQ_FIXED_WORKERS      = 26,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -715,6 +718,12 @@ struct io_uring_recvmsg_out {
 	__u32 flags;
 };
 
+struct io_uring_fixed_worker_arg {
+	__u32	nr_workers;
+	__u32	resv;
+	__u64	resv2[3];
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 4338e5b23b07..28f13c1c38f4 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1371,6 +1371,91 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
 	return 0;
 }
 
+static void io_wq_clean_fixed_workers(struct io_wq *wq)
+{
+	int i, j;
+
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		struct io_wq_acct *acct = &wq->acct[i];
+		struct io_worker **workers = acct->fixed_workers;
+
+		if (!workers)
+			continue;
+
+		for (j = 0; j < acct->fixed_nr; j++) {
+			if (!workers[j])
+				continue;
+			workers[j]->flags |= IO_WORKER_F_EXIT;
+			wake_up_process(worker->task);
+		}
+		kfree(workers);
+	}
+}
+
+/*
+ * Set number of fixed workers.
+ */
+int io_wq_fixed_workers(struct io_wq *wq, struct io_uring_fixed_worker_arg *count)
+{
+	struct io_wq_acct *acct;
+	int i, j, ret = 0;
+
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		if (wq->acct[i].fixed_nr) {
+			ret = -EBUSY;
+			break;
+		}
+	}
+	if (ret)
+		return ret;
+
+	BUILD_BUG_ON((int) IO_WQ_ACCT_BOUND   != (int) IO_WQ_BOUND);
+	BUILD_BUG_ON((int) IO_WQ_ACCT_UNBOUND != (int) IO_WQ_UNBOUND);
+	BUILD_BUG_ON((int) IO_WQ_ACCT_NR      != 2);
+
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		if (count[i].nr_workers > task_rlimit(current, RLIMIT_NPROC))
+			count[i].nr_workers =
+				task_rlimit(current, RLIMIT_NPROC);
+	}
+
+	rcu_read_lock();
+
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		unsigned int nr = count[i].nr_workers;
+
+		acct = &wq->acct[i];
+		acct->fixed_nr = nr;
+		acct->fixed_workers = kcalloc(nr, sizeof(struct io_worker *),
+					      GFP_KERNEL);
+		if (!acct->fixed_workers) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		for (j = 0; j < nr; j++) {
+			struct io_worker *worker =
+				io_wq_create_worker(wq, acct, true);
+			if (IS_ERR(worker)) {
+				ret = PTR_ERR(worker);
+				break;
+			}
+			acct->fixed_workers[j] = worker;
+		}
+		if (j < nr)
+			break;
+	}
+	rcu_read_unlock();
+
+	if (ret)
+		goto err;
+	return 0;
+
+err:
+	io_wq_clean_fixed_workers(wq);
+	return ret;
+}
+
 static __init int io_wq_init(void)
 {
 	int ret;
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 31228426d192..88a1ee9fde24 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -52,6 +52,7 @@ void io_wq_hash_work(struct io_wq_work *work, void *val);
 
 int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask);
 int io_wq_max_workers(struct io_wq *wq, int *new_count);
+int io_wq_fixed_workers(struct io_wq *wq, struct io_uring_fixed_worker_arg *count);
 
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c99a7a0c3f21..bb8342b4a2c6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4351,6 +4351,71 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+/*
+ * note: this function sets fixed workers for a single task, so every
+ * task which wants to set the fixed workers has to call this function
+ */
+static __cold int io_register_iowq_fixed_workers(struct io_ring_ctx *ctx,
+					       void __user *arg, int nr_args)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_uring_task *tctx = NULL;
+	struct io_sq_data *sqd = NULL;
+	struct io_uring_fixed_worker_arg *res;
+	size_t size;
+	int i, ret;
+	bool zero = true;
+
+	size = array_size(nr_args, sizeof(*res));
+	if (size == SIZE_MAX)
+		return -EOVERFLOW;
+
+	res = memdup_user(arg, size);
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+
+	for (i = 0; i < nr_args; i++) {
+		if (res[i].nr_workers) {
+			zero = false;
+			break;
+		}
+	}
+
+	if (zero)
+		return 0;
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
+		ret = io_wq_fixed_workers(tctx->io_wq, res);
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
@@ -4509,6 +4574,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_file_alloc_range(ctx, arg);
 		break;
+	case IORING_REGISTER_IOWQ_FIXED_WORKERS:
+		ret = -EINVAL;
+		if (!arg || nr_args != 2)
+			break;
+		ret = io_register_iowq_fixed_workers(ctx, arg, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.25.1

