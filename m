Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF01263E01
	for <lists+io-uring@lfdr.de>; Thu, 10 Sep 2020 09:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730450AbgIJHGL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Sep 2020 03:06:11 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:25540 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729992AbgIJHEK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Sep 2020 03:04:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0U8TUO26_1599721446;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U8TUO26_1599721446)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Sep 2020 15:04:07 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [RFC PATCH for-next] io_uring: support multiple rings to share same poll thread by specifying same cpu
Date:   Thu, 10 Sep 2020 15:03:59 +0800
Message-Id: <20200910070359.14683-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
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
attach themselves the previous created poll thread.

To implement above function, add one global hlist_head hash table, only
sqd that is created for IORING_SETUP_SQ_AFF & IORING_SETUP_SQPOLL_PERCPU
will be added to this global list, and its search key are current->files
and cpu number.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c                 | 160 ++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h |   1 +
 2 files changed, 126 insertions(+), 35 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0490edfcdd88..fdd143ff36bb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -232,9 +232,9 @@ struct io_restriction {
 struct io_sq_data {
 	refcount_t		refs;
 
-	/* global sqd lookup */
-	struct list_head	all_sqd_list;
-	int			attach_fd;
+	struct hlist_node	hash;
+	struct files_struct	*files;
+	int			sq_thread_cpu;
 
 	/* ctx's that are using this sqd */
 	struct list_head	ctx_list;
@@ -248,6 +248,10 @@ struct io_sq_data {
 static LIST_HEAD(sqd_list);
 static DEFINE_MUTEX(sqd_lock);
 
+#define	IORING_SQD_HASHTABLE_SIZE	256
+#define	IORING_SQD_HASHTABLE_BITS	8
+static struct hlist_head *sqd_hashtable;
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -7034,51 +7038,114 @@ static void io_put_sq_data(struct io_sq_data *sqd)
 			kthread_stop(sqd->thread);
 		}
 
-		mutex_lock(&sqd_lock);
-		list_del(&sqd->all_sqd_list);
-		mutex_unlock(&sqd_lock);
-
+		if (!hlist_unhashed(&sqd->hash)) {
+			mutex_lock(&sqd_lock);
+			hlist_del(&sqd->hash);
+			mutex_unlock(&sqd_lock);
+		}
 		kfree(sqd);
 	}
 }
 
 static struct io_sq_data *io_attach_sq_data(struct io_uring_params *p)
 {
-	struct io_sq_data *sqd, *ret = ERR_PTR(-ENXIO);
+	struct io_ring_ctx *ctx_attach;
+	struct io_sq_data *sqd;
+	struct fd f;
 
-	mutex_lock(&sqd_lock);
-	list_for_each_entry(sqd, &sqd_list, all_sqd_list) {
-		if (sqd->attach_fd == p->wq_fd) {
-			refcount_inc(&sqd->refs);
-			ret = sqd;
-			break;
-		}
+	f = fdget(p->wq_fd);
+	if (!f.file)
+		return ERR_PTR(-ENXIO);
+	if (f.file->f_op != &io_uring_fops) {
+		fdput(f);
+		return ERR_PTR(-EINVAL);
 	}
-	mutex_unlock(&sqd_lock);
 
-	return ret;
+	ctx_attach = f.file->private_data;
+	sqd = ctx_attach->sq_data;
+	if (!sqd) {
+		fdput(f);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (!refcount_inc_not_zero(&sqd->refs)) {
+		fdput(f);
+		return ERR_PTR(-EINVAL);
+	}
+
+	fdput(f);
+	return sqd;
 }
 
-static struct io_sq_data *io_get_sq_data(struct io_uring_params *p, int ring_fd)
+static struct io_sq_data *io_alloc_sq_data(void)
 {
 	struct io_sq_data *sqd;
 
-	if (p->flags & IORING_SETUP_ATTACH_WQ)
-		return io_attach_sq_data(p);
-
 	sqd = kzalloc(sizeof(*sqd), GFP_KERNEL);
 	if (!sqd)
 		return ERR_PTR(-ENOMEM);
 
 	refcount_set(&sqd->refs, 1);
-	sqd->attach_fd = ring_fd;
 	INIT_LIST_HEAD(&sqd->ctx_list);
 	INIT_LIST_HEAD(&sqd->ctx_new_list);
+	INIT_HLIST_NODE(&sqd->hash);
 	mutex_init(&sqd->ctx_lock);
 	init_waitqueue_head(&sqd->wait);
+	return sqd;
+}
+
+static inline void io_attach_ctx_to_sqd(struct io_sq_data *sqd, struct io_ring_ctx *ctx)
+{
+	mutex_lock(&sqd->ctx_lock);
+	list_add(&ctx->sqd_list, &sqd->ctx_new_list);
+	ctx->sq_data = sqd;
+	mutex_unlock(&sqd->ctx_lock);
+}
+
+/*
+ * Only if IORING_SETUP_ATTACH_WQ is not specified and IORING_SETUP_SQ_AFF &
+ * IORING_SETUP_SQPOLL_PERCPU are both enabled, can this function be called.
+ *
+ * This function finds the corresponding sqd in the global hash list in the
+ * key of current->files and cpu number, if not find one, create a new sqd
+ * and insert to the global hash list.
+ */
+static struct io_sq_data *io_find_or_create_sq_data(struct io_ring_ctx *ctx,
+				struct io_uring_params *p)
+{
+	struct io_sq_data *sqd;
+	struct hlist_head *head;
+	int cpu = p->sq_thread_cpu;
+	struct task_struct *tsk;
+	struct files_struct *files = current->files;
 
 	mutex_lock(&sqd_lock);
-	list_add_tail(&sqd->all_sqd_list, &sqd_list);
+	head = sqd_hashtable + hash_ptr(files, IORING_SQD_HASHTABLE_BITS);
+	hlist_for_each_entry(sqd, head, hash) {
+		if ((sqd->files == files) && (sqd->sq_thread_cpu == cpu)) {
+			refcount_inc(&sqd->refs);
+			mutex_unlock(&sqd_lock);
+			return sqd;
+		}
+	}
+
+	sqd = io_alloc_sq_data();
+	if (IS_ERR(sqd))
+		goto out;
+
+	tsk = kthread_create_on_cpu(io_sq_thread, sqd, cpu, "io_uring-sq");
+	if (IS_ERR(tsk)) {
+		kfree(sqd);
+		sqd = ERR_PTR(PTR_ERR(tsk));
+		goto out;
+	}
+
+	sqd->thread = tsk;
+	sqd->files = files;
+	sqd->sq_thread_cpu = cpu;
+	hlist_add_head(&sqd->hash, head);
+
+out:
 	mutex_unlock(&sqd_lock);
 	return sqd;
 }
@@ -7757,15 +7824,17 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
 			goto err;
 
-		sqd = io_get_sq_data(p, ring_fd);
-		if (IS_ERR(sqd)) {
-			ret = PTR_ERR(sqd);
-			goto err;
+		if (p->flags & IORING_SETUP_ATTACH_WQ) {
+			sqd = io_attach_sq_data(p);
+			if (IS_ERR(sqd)) {
+				ret = PTR_ERR(sqd);
+				goto err;
+			}
+			io_attach_ctx_to_sqd(sqd, ctx);
+			WARN_ON(!sqd->thread);
+			if (sqd->thread)
+				goto done;
 		}
-		ctx->sq_data = sqd;
-		mutex_lock(&sqd->ctx_lock);
-		list_add(&ctx->sqd_list, &sqd->ctx_new_list);
-		mutex_unlock(&sqd->ctx_lock);
 
 		/*
 		 * We will exit the sqthread before current exits, so we can
@@ -7778,8 +7847,14 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		if (!ctx->sq_thread_idle)
 			ctx->sq_thread_idle = HZ;
 
-		if (sqd->thread)
-			goto done;
+		if (!(p->flags & IORING_SETUP_SQ_AFF) ||
+		    !(p->flags & IORING_SETUP_SQPOLL_PERCPU)) {
+			sqd = io_alloc_sq_data();
+			if (IS_ERR(sqd)) {
+				ret = PTR_ERR(sqd);
+				goto err;
+			}
+		}
 
 		if (p->flags & IORING_SETUP_SQ_AFF) {
 			int cpu = p->sq_thread_cpu;
@@ -7790,7 +7865,14 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			if (!cpu_online(cpu))
 				goto err;
 
-			sqd->thread = kthread_create_on_cpu(io_sq_thread, sqd,
+			if (p->flags & IORING_SETUP_SQPOLL_PERCPU) {
+				sqd = io_find_or_create_sq_data(ctx, p);
+				if (IS_ERR(sqd)) {
+					ret = PTR_ERR(sqd);
+					goto err;
+				}
+			} else
+				sqd->thread = kthread_create_on_cpu(io_sq_thread, sqd,
 							cpu, "io_uring-sq");
 		} else {
 			sqd->thread = kthread_create(io_sq_thread, sqd,
@@ -7801,6 +7883,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			sqd->thread = NULL;
 			goto err;
 		}
+		io_attach_ctx_to_sqd(sqd, ctx);
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
 		/* Can't have SQ_AFF without SQPOLL */
 		ret = -EINVAL;
@@ -9052,7 +9135,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED))
+			IORING_SETUP_R_DISABLED | IORING_SETUP_SQPOLL_PERCPU))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
@@ -9387,6 +9470,8 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 
 static int __init io_uring_init(void)
 {
+	int i;
+
 #define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
 	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
 	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
@@ -9427,6 +9512,11 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
+
+	sqd_hashtable = kvmalloc_array(IORING_SQD_HASHTABLE_SIZE,
+				sizeof(sqd_hashtable[0]), GFP_KERNEL);
+	for (i = 0; i < IORING_SQD_HASHTABLE_SIZE; i++)
+		INIT_HLIST_HEAD(&sqd_hashtable[i]);
 	return 0;
 };
 __initcall(io_uring_init);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2301c37e86cb..4147e5a5f752 100644
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

