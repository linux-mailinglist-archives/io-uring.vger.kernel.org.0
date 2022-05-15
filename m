Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88DE35277C1
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 15:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236841AbiEONNR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 09:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236859AbiEONNQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 09:13:16 -0400
Received: from pv50p00im-ztdg10022001.me.com (pv50p00im-ztdg10022001.me.com [17.58.6.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7630313F57
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 06:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652620395;
        bh=LE5V/iIh+SDCPYldNcWVy0tTktUXqXrbGWnxxq/DV5Q=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=fXCyFh9e0H7zUa54cfzhiDHLmMPTCJJB1cwIG0P74WgXxwBsrFSause48czmPXVUG
         w1FVSo1tpcO5oHWs+aq5jTh9wdwO7sESNf1ylIsMysBVc8pzZ0qGv9tipK3oqKUwZt
         NlQjRMXUlHhcW3CVUoXo5GZp2r60xnIIipOajX7vnNjRRCMcfpgqKIxJjo63W/Q3+X
         ZYAsrLmXLvPcSUriO0p9ORLXvFb72Kheqla782KSYVIRtshJ+JkoCOFqavaMfBAZzP
         E0VGrqd4cWDY2z6Yj8wwuaFXK9CGSFBHF8SFZExluUVqSvh+TVX5+PPPoUmXhofeHs
         sI4YrMdS1BHxA==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10022001.me.com (Postfix) with ESMTPSA id A6D1C3E1D48;
        Sun, 15 May 2022 13:13:12 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 09/11] io_uring: add register fixed worker interface
Date:   Sun, 15 May 2022 21:12:28 +0800
Message-Id: <20220515131230.155267-10-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220515131230.155267-1-haoxu.linux@icloud.com>
References: <20220515131230.155267-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-15_07:2022-05-13,2022-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=726 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205150069
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <haoxu.linux@gmail.com>

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
index 7c13cc01e5e5..66d3c741613f 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1678,6 +1678,107 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
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
index 3c39f5413c1b..b223dbd44891 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11974,6 +11974,71 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
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
@@ -12105,6 +12170,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
index 15f821af9242..6fc649259142 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -384,6 +384,12 @@ enum {
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
@@ -487,4 +493,9 @@ struct io_uring_getevents_arg {
 	__u64	ts;
 };
 
+struct io_uring_fixed_worker_arg {
+	__s32	nr_workers;
+	__s32	max_works;
+};
+
 #endif
-- 
2.25.1

