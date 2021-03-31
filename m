Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3901C3503FF
	for <lists+io-uring@lfdr.de>; Wed, 31 Mar 2021 18:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhCaP7i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Mar 2021 11:59:38 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:49377 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232805AbhCaP7b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Mar 2021 11:59:31 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UTyvTgi_1617206366;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UTyvTgi_1617206366)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 31 Mar 2021 23:59:26 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com
Subject: [PATCH] io_uring: support multiple rings to share same poll thread by specifying same cpu
Date:   Wed, 31 Mar 2021 23:59:26 +0800
Message-Id: <20210331155926.22913-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have already supported multiple rings to share one same poll thread
by passing IORING_SETUP_ATTACH_WQ, but it's not that convenient to use.
IORING_SETUP_ATTACH_WQ needs users to ensure that a parent ring instance
has beed created firstly, that means it will require app to regulate the
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
for this case, we'll create a single poll thread to be shared by rings
rings which have same sq_thread_cpu.
  3, for any other cases, we'll just create one new poll thread for the
corresponding ring.

And for case 2, don't need to regulate creation oder of multiple uring
instances, we use a mutex to synchronize creation, for example, say five
rings which all have IORING_SETUP_SQ_AFF & IORING_SETUP_SQPOLL_PERCPU
enabled, and are willing to be bound same cpu, one ring that gets the
mutex lock will create one poll thread, the other four rings will just
attach themselves to the previous created poll thread once they get lock
successfully.

To implement above function, define below data structs:
  struct percpu_sqd_entry {
        struct list_head        node;
        struct io_sq_data       *sqd;
        pid_t                   tgid;
  };

  struct percpu_sqd_list {
        struct list_head        head;
        struct mutex            lock;
  };

  static struct percpu_sqd_list __percpu *percpu_sqd_list;

sqthreads that have same sq_thread_cpu will be linked together in a percpu
percpu_sqd_list's head. When IORING_SETUP_SQ_AFF and IORING_SETUP_SQPOLL_PERCPU
are both enabled, we will use struct io_uring_params' sq_thread_cpu and
current-tgid locate corresponding sqd.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c                 | 155 ++++++++++++++++++++++++++++------
 include/uapi/linux/io_uring.h |   1 +
 2 files changed, 131 insertions(+), 25 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1949b80677e7..4c24ceb1893b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -255,6 +255,8 @@ enum {
 	IO_SQ_THREAD_SHOULD_PARK,
 };
 
+struct percpu_sqd_entry;
+
 struct io_sq_data {
 	refcount_t		refs;
 	atomic_t		park_pending;
@@ -271,11 +273,25 @@ struct io_sq_data {
 	pid_t			task_pid;
 	pid_t			task_tgid;
 
+	struct percpu_sqd_entry	*percpu_sqd_entry;
 	unsigned long		state;
 	struct completion	exited;
 	struct callback_head	*park_task_work;
 };
 
+struct percpu_sqd_entry {
+	struct list_head	node;
+	struct io_sq_data	*sqd;
+	pid_t			tgid;
+};
+
+struct percpu_sqd_list {
+	struct list_head	head;
+	struct mutex		lock;
+};
+
+static struct percpu_sqd_list __percpu *percpu_sqd_list;
+
 #define IO_IOPOLL_BATCH			8
 #define IO_COMPL_BATCH			32
 #define IO_REQ_CACHE_SIZE		32
@@ -7153,7 +7169,18 @@ static void io_put_sq_data(struct io_sq_data *sqd)
 		WARN_ON_ONCE(atomic_read(&sqd->park_pending));
 
 		io_sq_thread_stop(sqd);
-		kfree(sqd);
+		if (sqd->percpu_sqd_entry) {
+			struct percpu_sqd_list *psl;
+
+			psl = per_cpu_ptr(percpu_sqd_list, sqd->sq_cpu);
+			mutex_lock(&psl->lock);
+			list_del(&sqd->percpu_sqd_entry->node);
+			kfree(sqd->percpu_sqd_entry);
+			kfree(sqd);
+			mutex_unlock(&psl->lock);
+		} else {
+			kfree(sqd);
+		}
 	}
 }
 
@@ -7204,10 +7231,30 @@ static struct io_sq_data *io_attach_sq_data(struct io_uring_params *p)
 	return sqd;
 }
 
-static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
+static struct io_sq_data *io_alloc_sq_data(void)
+{
+	struct io_sq_data *sqd;
+
+	sqd = kzalloc(sizeof(*sqd), GFP_KERNEL);
+	if (!sqd)
+		return ERR_PTR(-ENOMEM);
+
+	atomic_set(&sqd->park_pending, 0);
+	refcount_set(&sqd->refs, 1);
+	INIT_LIST_HEAD(&sqd->ctx_list);
+	mutex_init(&sqd->lock);
+	init_waitqueue_head(&sqd->wait);
+	init_completion(&sqd->exited);
+	return sqd;
+}
+
+static struct io_sq_data *io_get_sq_data(struct io_uring_params *p, int cpu,
 					 bool *attached)
 {
 	struct io_sq_data *sqd;
+	struct percpu_sqd_entry *sqd_entry;
+	struct percpu_sqd_list *psl;
+	bool found = false;
 
 	*attached = false;
 	if (p->flags & IORING_SETUP_ATTACH_WQ) {
@@ -7221,16 +7268,43 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
 			return sqd;
 	}
 
-	sqd = kzalloc(sizeof(*sqd), GFP_KERNEL);
+	if (!(p->flags & IORING_SETUP_SQ_AFF) ||
+	    !(p->flags & IORING_SETUP_SQ_PERCPU)) {
+		sqd = io_alloc_sq_data();
+		if (!IS_ERR(sqd))
+			sqd->sq_cpu = cpu;
+		return sqd;
+	}
+
+	psl = per_cpu_ptr(percpu_sqd_list, cpu);
+	list_for_each_entry(sqd_entry, &psl->head, node) {
+		if (sqd_entry->tgid == current->tgid) {
+			found = true;
+			break;
+		}
+	}
+	if (found) {
+		sqd = sqd_entry->sqd;
+		refcount_inc(&sqd->refs);
+		*attached = true;
+		return sqd;
+	}
+
+	sqd = io_alloc_sq_data();
 	if (!sqd)
 		return ERR_PTR(-ENOMEM);
 
-	atomic_set(&sqd->park_pending, 0);
-	refcount_set(&sqd->refs, 1);
-	INIT_LIST_HEAD(&sqd->ctx_list);
-	mutex_init(&sqd->lock);
-	init_waitqueue_head(&sqd->wait);
-	init_completion(&sqd->exited);
+	sqd_entry = kzalloc(sizeof(*sqd_entry), GFP_KERNEL);
+	if (!sqd_entry) {
+		kfree(sqd);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	sqd->sq_cpu = cpu;
+	sqd->percpu_sqd_entry = sqd_entry;
+	sqd_entry->sqd = sqd;
+	sqd_entry->tgid = current->tgid;
+	list_add(&sqd_entry->node, &psl->head);
 	return sqd;
 }
 
@@ -7870,6 +7944,8 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 				struct io_uring_params *p)
 {
 	int ret;
+	struct percpu_sqd_list *psl;
+	bool lock_held = false;
 
 	/* Retain compatibility with failing for an invalid attach attempt */
 	if ((ctx->flags & (IORING_SETUP_ATTACH_WQ | IORING_SETUP_SQPOLL)) ==
@@ -7889,12 +7965,36 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		struct task_struct *tsk;
 		struct io_sq_data *sqd;
 		bool attached;
+		int cpu;
 
 		ret = -EPERM;
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
 			goto err;
 
-		sqd = io_get_sq_data(p, &attached);
+		if (p->flags & IORING_SETUP_SQ_AFF) {
+			cpu = p->sq_thread_cpu;
+
+			ret = -EINVAL;
+			if (cpu >= nr_cpu_ids)
+				goto err;
+			if (!cpu_online(cpu))
+				goto err;
+		} else {
+			cpu = -1;
+		}
+
+		/*
+		 * For percpu sqthread, need to synchronize creation oder
+		 * between uring instances.
+		 */
+		if ((p->flags & IORING_SETUP_SQ_AFF) &&
+		    (p->flags & IORING_SETUP_SQ_PERCPU)) {
+			psl = per_cpu_ptr(percpu_sqd_list, cpu);
+			lock_held = true;
+			mutex_lock(&psl->lock);
+		}
+
+		sqd = io_get_sq_data(p, cpu, &attached);
 		if (IS_ERR(sqd)) {
 			ret = PTR_ERR(sqd);
 			goto err;
@@ -7917,21 +8017,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 
 		if (ret < 0)
 			goto err;
-		if (attached)
+		if (attached) {
+			if (lock_held)
+				mutex_unlock(&psl->lock);
 			return 0;
-
-		if (p->flags & IORING_SETUP_SQ_AFF) {
-			int cpu = p->sq_thread_cpu;
-
-			ret = -EINVAL;
-			if (cpu >= nr_cpu_ids)
-				goto err_sqpoll;
-			if (!cpu_online(cpu))
-				goto err_sqpoll;
-
-			sqd->sq_cpu = cpu;
-		} else {
-			sqd->sq_cpu = -1;
 		}
 
 		sqd->task_pid = current->pid;
@@ -7953,9 +8042,13 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		goto err;
 	}
 
+	if (lock_held)
+		mutex_unlock(&psl->lock);
 	return 0;
 err:
 	io_sq_thread_finish(ctx);
+	if (lock_held)
+		mutex_unlock(&psl->lock);
 	return ret;
 err_sqpoll:
 	complete(&ctx->sq_data->exited);
@@ -9593,7 +9686,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED))
+			IORING_SETUP_R_DISABLED | IORING_SETUP_SQ_PERCPU))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
@@ -9928,6 +10021,8 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 
 static int __init io_uring_init(void)
 {
+	int cpu;
+
 #define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
 	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
 	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
@@ -9969,6 +10064,16 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				SLAB_ACCOUNT);
+
+	percpu_sqd_list = alloc_percpu(struct percpu_sqd_list);
+	for_each_possible_cpu(cpu) {
+		struct percpu_sqd_list *sqd_list;
+
+		sqd_list = per_cpu_ptr(percpu_sqd_list, cpu);
+		INIT_LIST_HEAD(&sqd_list->head);
+		mutex_init(&sqd_list->lock);
+	}
+
 	return 0;
 };
 __initcall(io_uring_init);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2514eb6b1cf2..0b80472fd3c5 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -98,6 +98,7 @@ enum {
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
+#define IORING_SETUP_SQ_PERCPU	(1U << 7)	/* use percpu SQ poll thread */
 
 enum {
 	IORING_OP_NOP,
-- 
2.17.2

