Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC5C514680
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 12:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357399AbiD2KWi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 06:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357388AbiD2KWe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 06:22:34 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3153BC6EC4;
        Fri, 29 Apr 2022 03:19:16 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id s14so6745026plk.8;
        Fri, 29 Apr 2022 03:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B3NCzom8hJlx0zEy79Sz4qhJxcFl7hPctwsRA5jCJVg=;
        b=n5e2gCVMetK60EV0yAY1ZD2lqkuRIIdUATIgR3jexzzkaMC8uaAWT9rNxFUAdvCLbH
         vVZ9m9DA9XA5BSYrmH3+/xL2rYNAqdrF7ij4qDlpioRQO92Vgf+pCqUUoOYcCG+OFAFe
         gLlcOVSONcpXDQiy68mGWbJkbJ8NHcMMR7ThVXFUncaJgdAPS+ztw0aNBSN7r/p+/GO+
         fQYAHjthDn1s6T9Qee7aR9YX13QKL6LrL0jvPvQbuBV/ad8BaN0ev0Uru72L4ZVrM5zp
         gtzvQQ8KAacKFsk2fR0omTbWb8f7AWXNHyRiGcvMKq9xcWEXF/YyZRFyxfqYWZogCwYl
         xBXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B3NCzom8hJlx0zEy79Sz4qhJxcFl7hPctwsRA5jCJVg=;
        b=ZlcNf0NsRTWQTyRiuhrceCT5Wre/3il+nDB/BKpcQDcVli3Nqj7sAWVBWOOPJ2ia/t
         AoYgVH0LvDy9CB/R0J2yzpdDbfbwAv2BMBrGqkHJMj2NfOvrz1s1bGlJSq81dOzLhlxf
         GnvVFk0/Fp5yJf2rIO0bN/zV6KRBPyhRyW36O7bVievQ1y3BYREr5bjvGG4GCC+KxWWv
         gOMPF5U+tjYJS+jsc8bZfpM6kSI0kQ7E8G3fH/2TiJRNykWGNsTmAV+BTOQNdJwHuK4E
         9CLDUDQRbsmAiayZMR6bVKK1IZr/8t3iZXeIxa71CvIIr6FqtTlXfulf7FTc3F+OSN4X
         Etxg==
X-Gm-Message-State: AOAM533gWUJfdFcAl1qhcIGnpPep0GVP/rRhN18V0i1J6HFXINP+MzU/
        zIewtbBkui0gAwfcY95aPWGqWYyhaQc=
X-Google-Smtp-Source: ABdhPJyRVy4Th8+Q8iCMIdMzGLmF4M6s5YI9UwjImZYV5uDo9pI0HszSp7nM2ZUuUPrSn3m3XiDrXA==
X-Received: by 2002:a17:90a:c402:b0:1d9:a003:3f8a with SMTP id i2-20020a17090ac40200b001d9a0033f8amr3065685pjt.18.1651227555375;
        Fri, 29 Apr 2022 03:19:15 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id k17-20020a628e11000000b0050d8d373331sm2600016pfe.214.2022.04.29.03.19.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Apr 2022 03:19:15 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] io_uring: add register fixed worker interface
Date:   Fri, 29 Apr 2022 18:18:58 +0800
Message-Id: <20220429101858.90282-10-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429101858.90282-1-haoxu.linux@gmail.com>
References: <20220429101858.90282-1-haoxu.linux@gmail.com>
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
                                     new value

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c                    | 101 ++++++++++++++++++++++++++++++++++
 fs/io-wq.h                    |   3 +
 fs/io_uring.c                 |  71 ++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  11 ++++
 4 files changed, 186 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index df2d480395e8..c1e87b29c960 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1671,6 +1671,107 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
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
diff --git a/fs/io-wq.h b/fs/io-wq.h
index ef3ce577e6b7..bf90488b0283 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -2,6 +2,7 @@
 #define INTERNAL_IO_WQ_H
 
 #include <linux/refcount.h>
+#include <uapi/linux/io_uring.h>
 
 struct io_wq;
 
@@ -202,6 +203,8 @@ void io_wq_hash_work(struct io_wq_work *work, void *val);
 
 int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask);
 int io_wq_max_workers(struct io_wq *wq, int *new_count);
+int io_wq_fixed_workers(struct io_wq *wq,
+			struct io_uring_fixed_worker_arg *new_count);
 
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1e7466079af7..c0c7c1fd94fd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11806,6 +11806,71 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
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
@@ -11934,6 +11999,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	case IORING_UNREGISTER_RING_FDS:
 		ret = io_ringfd_unregister(ctx, arg, nr_args);
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
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index fad63564678a..f0ec9523ab42 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -360,6 +360,12 @@ enum {
 	IORING_REGISTER_RING_FDS		= 20,
 	IORING_UNREGISTER_RING_FDS		= 21,
 
+	/* set number of fixed workers and number
+	 * of works in a private work list which
+	 * belongs to a fixed worker
+	 */
+	IORING_REGISTER_IOWQ_FIXED_WORKERS	= 22,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -457,4 +463,9 @@ struct io_uring_getevents_arg {
 	__u64	ts;
 };
 
+struct io_uring_fixed_worker_arg {
+	__s32	nr_workers;
+	__s32	max_works;
+};
+
 #endif
-- 
2.36.0

