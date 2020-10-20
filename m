Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9962936BA
	for <lists+io-uring@lfdr.de>; Tue, 20 Oct 2020 10:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387920AbgJTIYC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Oct 2020 04:24:02 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:60032 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728071AbgJTIYC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Oct 2020 04:24:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UCdOUmP_1603182238;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UCdOUmP_1603182238)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 20 Oct 2020 16:23:58 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH 2/2] io_uring: support multiple rings to share same poll thread by specifying same cpu
Date:   Tue, 20 Oct 2020 16:23:45 +0800
Message-Id: <20201020082345.19628-3-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20201020082345.19628-1-xiaoguang.wang@linux.alibaba.com>
References: <20201020082345.19628-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have already supported multiple rings to share one same poll thread
by passing IORING_SETUP_ATTACH_WQ, but it's not that convenient to use.
IORING_SETUP_ATTACH_WQ needs users to ensure that a parent ring instance
has already existed, that means it will require app to regulate the
creation oder between uring instances.

Currently we can make this a bit simpler, for those rings which will
have SQPOLL enabled and are willing to be bound to one same cpu, add a
capability that these rings can share one poll thread by specifying
a new IORING_SETUP_SQPOLL_PERCPU flag, then we have 3 cases
  1, IORING_SETUP_ATTACH_WQ: if user specifies this flag, we'll always
try to attach this ring to an existing ring's corresponding poll thread,
no matter whether IORING_SETUP_SQ_AFF or IORING_SETUP_SQPOLL_PERCPU is
set.
  2, IORING_SETUP_SQ_AFF and IORING_SETUP_SQPOLL_PERCPU are both enabled,
for this case, we'll create a single poll thread to be shared by these
rings, and this poll thread is bound to a fixed cpu.
  3, for any other cases, we'll just create one new poll thread for the
corresponding ring.

And for case 2, don't need to regulate creation oder of multiple uring
instances, we use a mutex to synchronize creation, for example, say five
rings which all have IORING_SETUP_SQ_AFF & IORING_SETUP_SQPOLL_PERCPU
enabled, and are willing to be bound same cpu, one ring that gets the
mutex lock will create one poll thread, the other four rings will just
attach themselves the previous created poll thread once they get lock
successfully.

To implement above function, define a percpu io_sq_data array:
    static struct io_sq_data __percpu *percpu_sqd;
When IORING_SETUP_SQ_AFF and IORING_SETUP_SQPOLL_PERCPU are both enabled,
we will use struct io_uring_params' sq_thread_cpu to locate corresponding
sqd, and use this sqd to save poll thread info.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c                 | 142 +++++++++++++++++++++++++++-------
 include/uapi/linux/io_uring.h |   1 +
 2 files changed, 115 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f7b65a9ed5b8..b9ebf1ca93d7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -235,6 +235,7 @@ struct io_restriction {
 struct io_sq_data {
 	refcount_t		refs;
 	struct mutex		lock;
+	struct mutex		percpu_sq_lock;
 
 	/* ctx's that are using this sqd */
 	struct list_head	ctx_list;
@@ -247,6 +248,8 @@ struct io_sq_data {
 	unsigned		sq_thread_idle;
 };
 
+static struct io_sq_data __percpu *percpu_sqd;
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -6504,10 +6507,12 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 	if (cap_entries && to_submit > 8)
 		to_submit = 8;
 
-	mutex_lock(&ctx->uring_lock);
-	if (likely(!percpu_ref_is_dying(&ctx->refs)))
-		ret = io_submit_sqes(ctx, to_submit);
-	mutex_unlock(&ctx->uring_lock);
+	if (to_submit) {
+		mutex_lock(&ctx->uring_lock);
+		if (likely(!percpu_ref_is_dying(&ctx->refs)))
+			ret = io_submit_sqes(ctx, to_submit);
+		mutex_unlock(&ctx->uring_lock);
+	}
 
 	if (!io_sqring_full(ctx) && wq_has_sleeper(&ctx->sqo_sq_wait))
 		wake_up(&ctx->sqo_sq_wait);
@@ -6814,8 +6819,17 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	return 0;
 }
 
-static void io_put_sq_data(struct io_sq_data *sqd)
+static void io_put_sq_data(struct io_ring_ctx *ctx, struct io_sq_data *sqd)
 {
+	int percpu_sqd = 0;
+
+	if ((ctx->flags & IORING_SETUP_SQ_AFF) &&
+	    (ctx->flags & IORING_SETUP_SQPOLL_PERCPU))
+		percpu_sqd = 1;
+
+	if (percpu_sqd)
+		mutex_lock(&sqd->percpu_sq_lock);
+
 	if (refcount_dec_and_test(&sqd->refs)) {
 		/*
 		 * The park is a bit of a work-around, without it we get
@@ -6827,8 +6841,14 @@ static void io_put_sq_data(struct io_sq_data *sqd)
 			kthread_stop(sqd->thread);
 		}
 
-		kfree(sqd);
+		if (!percpu_sqd)
+			kfree(sqd);
+		else
+			sqd->thread = NULL;
 	}
+
+	if (percpu_sqd)
+		mutex_unlock(&sqd->percpu_sq_lock);
 }
 
 static struct io_sq_data *io_attach_sq_data(struct io_uring_params *p)
@@ -6857,13 +6877,10 @@ static struct io_sq_data *io_attach_sq_data(struct io_uring_params *p)
 	return sqd;
 }
 
-static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
+static struct io_sq_data *io_alloc_sq_data(struct io_uring_params *p)
 {
 	struct io_sq_data *sqd;
 
-	if (p->flags & IORING_SETUP_ATTACH_WQ)
-		return io_attach_sq_data(p);
-
 	sqd = kzalloc(sizeof(*sqd), GFP_KERNEL);
 	if (!sqd)
 		return ERR_PTR(-ENOMEM);
@@ -6873,7 +6890,9 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
 	INIT_LIST_HEAD(&sqd->ctx_new_list);
 	mutex_init(&sqd->ctx_lock);
 	mutex_init(&sqd->lock);
+	mutex_init(&sqd->percpu_sq_lock);
 	init_waitqueue_head(&sqd->wait);
+
 	return sqd;
 }
 
@@ -6895,6 +6914,43 @@ static void io_sq_thread_park(struct io_sq_data *sqd)
 	kthread_park(sqd->thread);
 }
 
+static void io_attach_ctx_to_sqd(struct io_sq_data *sqd, struct io_ring_ctx *ctx)
+{
+	ctx->sq_data = sqd;
+	io_sq_thread_park(sqd);
+	mutex_lock(&sqd->ctx_lock);
+	list_add(&ctx->sqd_list, &sqd->ctx_new_list);
+	mutex_unlock(&sqd->ctx_lock);
+	io_sq_thread_unpark(sqd);
+}
+
+static struct io_sq_data *io_find_or_create_percpu_sq_thread(struct io_ring_ctx *ctx,
+					struct io_uring_params *p)
+{
+	struct io_sq_data *sqd;
+	struct task_struct *tsk;
+	int cpu = p->sq_thread_cpu;
+
+	sqd = per_cpu_ptr(percpu_sqd, cpu);
+	mutex_lock(&sqd->percpu_sq_lock);
+	if (sqd->thread) {
+		refcount_inc(&sqd->refs);
+		mutex_unlock(&sqd->percpu_sq_lock);
+		return sqd;
+	}
+
+	tsk = kthread_create_on_cpu(io_sq_thread, sqd, cpu, "io_uring-sq");
+	if (IS_ERR(tsk)) {
+		sqd = ERR_PTR(PTR_ERR(tsk));
+		goto out;
+	}
+	sqd->thread = tsk;
+	refcount_set(&sqd->refs, 1);
+out:
+	mutex_unlock(&sqd->percpu_sq_lock);
+	return sqd;
+}
+
 static void io_sq_thread_stop(struct io_ring_ctx *ctx)
 {
 	struct io_sq_data *sqd = ctx->sq_data;
@@ -6921,7 +6977,7 @@ static void io_sq_thread_stop(struct io_ring_ctx *ctx)
 		if (sqd->thread)
 			io_sq_thread_unpark(sqd);
 
-		io_put_sq_data(sqd);
+		io_put_sq_data(ctx, sqd);
 		ctx->sq_data = NULL;
 	}
 }
@@ -7578,25 +7634,29 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		if (!capable(CAP_SYS_ADMIN))
 			goto err;
 
-		sqd = io_get_sq_data(p);
-		if (IS_ERR(sqd)) {
-			ret = PTR_ERR(sqd);
-			goto err;
-		}
-
-		ctx->sq_data = sqd;
-		io_sq_thread_park(sqd);
-		mutex_lock(&sqd->ctx_lock);
-		list_add(&ctx->sqd_list, &sqd->ctx_new_list);
-		mutex_unlock(&sqd->ctx_lock);
-		io_sq_thread_unpark(sqd);
-
 		ctx->sq_thread_idle = msecs_to_jiffies(p->sq_thread_idle);
 		if (!ctx->sq_thread_idle)
 			ctx->sq_thread_idle = HZ;
 
-		if (sqd->thread)
-			goto done;
+		if (p->flags & IORING_SETUP_ATTACH_WQ) {
+			sqd = io_attach_sq_data(p);
+			if (IS_ERR(sqd)) {
+				ret = PTR_ERR(sqd);
+				goto err;
+			}
+			io_attach_ctx_to_sqd(sqd, ctx);
+			if (sqd->thread)
+				goto done;
+		}
+
+		if (!(p->flags & IORING_SETUP_SQ_AFF) ||
+		    !(p->flags & IORING_SETUP_SQPOLL_PERCPU)) {
+			sqd = io_alloc_sq_data(p);
+			if (IS_ERR(sqd)) {
+				ret = PTR_ERR(sqd);
+				goto err;
+			}
+		}
 
 		if (p->flags & IORING_SETUP_SQ_AFF) {
 			int cpu = p->sq_thread_cpu;
@@ -7607,7 +7667,14 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			if (!cpu_online(cpu))
 				goto err;
 
-			sqd->thread = kthread_create_on_cpu(io_sq_thread, sqd,
+			if (p->flags & IORING_SETUP_SQPOLL_PERCPU) {
+				sqd = io_find_or_create_percpu_sq_thread(ctx, p);
+				if (IS_ERR(sqd)) {
+					ret = PTR_ERR(sqd);
+					goto err;
+				}
+			} else
+				sqd->thread = kthread_create_on_cpu(io_sq_thread, sqd,
 							cpu, "io_uring-sq");
 		} else {
 			sqd->thread = kthread_create(io_sq_thread, sqd,
@@ -7618,6 +7685,8 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			sqd->thread = NULL;
 			goto err;
 		}
+		io_attach_ctx_to_sqd(sqd, ctx);
+
 		ret = io_uring_alloc_task_context(sqd->thread);
 		if (ret)
 			goto err;
@@ -9157,7 +9226,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED))
+			IORING_SETUP_R_DISABLED | IORING_SETUP_SQPOLL_PERCPU))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
@@ -9500,6 +9569,8 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 
 static int __init io_uring_init(void)
 {
+	int cpu;
+
 #define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
 	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
 	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
@@ -9540,6 +9611,21 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
+
+	percpu_sqd = alloc_percpu(struct io_sq_data);
+
+	for_each_possible_cpu(cpu) {
+		struct io_sq_data *sqd;
+
+		sqd = per_cpu_ptr(percpu_sqd, cpu);
+		INIT_LIST_HEAD(&sqd->ctx_list);
+		INIT_LIST_HEAD(&sqd->ctx_new_list);
+		mutex_init(&sqd->ctx_lock);
+		mutex_init(&sqd->lock);
+		mutex_init(&sqd->percpu_sq_lock);
+		init_waitqueue_head(&sqd->wait);
+
+	}
 	return 0;
 };
 __initcall(io_uring_init);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 98d8e06dea22..a162b077a453 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -96,6 +96,7 @@ enum {
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
+#define IORING_SETUP_SQPOLL_PERCPU	(1U << 7)	/* use percpu SQ poll thread */
 
 enum {
 	IORING_OP_NOP,
-- 
2.17.2

