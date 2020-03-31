Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3EB5198C0C
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2020 08:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgCaGFu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Mar 2020 02:05:50 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:55471 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725809AbgCaGFu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Mar 2020 02:05:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Tu82K2E_1585634741;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Tu82K2E_1585634741)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 31 Mar 2020 14:05:47 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH v3] io_uring: refactor file register/unregister/update codes
Date:   Tue, 31 Mar 2020 14:05:18 +0800
Message-Id: <20200331060518.15324-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While diving into iouring fileset resigster/unregister/update codes,
we found one bug in fileset update codes. Iouring fileset update codes
use a percpu_ref variable to check whether can put previous registered
file, only when the refcnt of the perfcpu_ref variable reachs zero, can
we safely put these files, but this do not work well. If applications
always issue requests continually, this perfcpu_ref will never have an
chance to reach zero, and it'll always be in atomic mode, also will
defeat the gains introduced by fileset register/unresiger/update feature,
which are used to reduce the atomic operation overhead of fput/fget.

To fix this issue, while applications do IORING_REGISTER_FILES or
IORING_REGISTER_FILES_UPDATE operations, we allocate a new percpu_ref
and kill the old percpu_ref, new requests will use the new percpu_ref.
Once all previous old requests complete, old percpu_refs will be dropped
and registered files will be put safely.

Link: https://lore.kernel.org/io-uring/5a8dac33-4ca2-4847-b091-f7dcd3ad0ff3@linux.alibaba.com/T/#t
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

---
V3:
  rebase to upstream v5.6 code base.
---
 fs/io_uring.c | 203 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 123 insertions(+), 80 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 358f97be9c7b..6cfaeee355e2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -186,14 +186,23 @@ struct fixed_file_table {
 	struct file		**files;
 };
 
+struct fixed_file_ref_node {
+	struct percpu_ref		refs;
+	struct list_head		node;
+	struct list_head		file_list;
+	struct fixed_file_data		*file_data;
+	struct work_struct		work;
+};
+
 struct fixed_file_data {
 	struct fixed_file_table		*table;
 	struct io_ring_ctx		*ctx;
 
+	struct percpu_ref		*cur_refs;
 	struct percpu_ref		refs;
-	struct llist_head		put_llist;
-	struct work_struct		ref_work;
 	struct completion		done;
+	struct list_head		ref_list;
+	spinlock_t			lock;
 };
 
 struct io_buffer {
@@ -633,6 +642,7 @@ struct io_kiocb {
 		};
 		struct io_wq_work	work;
 	};
+	struct percpu_ref	*fixed_file_refs;
 };
 
 #define IO_PLUG_THRESHOLD		2
@@ -848,7 +858,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_files_update *ip,
 				 unsigned nr_args);
 static int io_grab_files(struct io_kiocb *req);
-static void io_ring_file_ref_flush(struct fixed_file_data *data);
 static void io_cleanup_req(struct io_kiocb *req);
 static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 		       int fd, struct file **out_file, bool fixed);
@@ -1341,7 +1350,7 @@ static inline void io_put_file(struct io_kiocb *req, struct file *file,
 			  bool fixed)
 {
 	if (fixed)
-		percpu_ref_put(&req->ctx->file_data->refs);
+		percpu_ref_put(req->fixed_file_refs);
 	else
 		fput(file);
 }
@@ -1393,21 +1402,18 @@ struct req_batch {
 
 static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 {
-	int fixed_refs = rb->to_free;
-
 	if (!rb->to_free)
 		return;
 	if (rb->need_iter) {
 		int i, inflight = 0;
 		unsigned long flags;
 
-		fixed_refs = 0;
 		for (i = 0; i < rb->to_free; i++) {
 			struct io_kiocb *req = rb->reqs[i];
 
 			if (req->flags & REQ_F_FIXED_FILE) {
 				req->file = NULL;
-				fixed_refs++;
+				percpu_ref_put(req->fixed_file_refs);
 			}
 			if (req->flags & REQ_F_INFLIGHT)
 				inflight++;
@@ -1433,8 +1439,6 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 	}
 do_free:
 	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
-	if (fixed_refs)
-		percpu_ref_put_many(&ctx->file_data->refs, fixed_refs);
 	percpu_ref_put_many(&ctx->refs, rb->to_free);
 	rb->to_free = rb->need_iter = 0;
 }
@@ -5331,7 +5335,8 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 		file = io_file_from_index(ctx, fd);
 		if (!file)
 			return -EBADF;
-		percpu_ref_get(&ctx->file_data->refs);
+		req->fixed_file_refs = ctx->file_data->cur_refs;
+		percpu_ref_get(req->fixed_file_refs);
 	} else {
 		trace_io_uring_file_get(ctx, fd);
 		file = __io_file_get(state, fd);
@@ -6124,43 +6129,36 @@ static void io_file_ref_kill(struct percpu_ref *ref)
 	complete(&data->done);
 }
 
-static void io_file_ref_exit_and_free(struct work_struct *work)
-{
-	struct fixed_file_data *data;
-
-	data = container_of(work, struct fixed_file_data, ref_work);
-
-	/*
-	 * Ensure any percpu-ref atomic switch callback has run, it could have
-	 * been in progress when the files were being unregistered. Once
-	 * that's done, we can safely exit and free the ref and containing
-	 * data structure.
-	 */
-	rcu_barrier();
-	percpu_ref_exit(&data->refs);
-	kfree(data);
-}
-
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	struct fixed_file_data *data = ctx->file_data;
+	struct fixed_file_ref_node *ref_node = NULL;
 	unsigned nr_tables, i;
+	unsigned long flags;
 
 	if (!data)
 		return -ENXIO;
 
-	percpu_ref_kill_and_confirm(&data->refs, io_file_ref_kill);
-	flush_work(&data->ref_work);
+	spin_lock_irqsave(&data->lock, flags);
+	if (!list_empty(&data->ref_list))
+		ref_node = list_first_entry(&data->ref_list,
+				struct fixed_file_ref_node, node);
+	spin_unlock_irqrestore(&data->lock, flags);
+	if (ref_node)
+		percpu_ref_kill(&ref_node->refs);
+
+	percpu_ref_kill(&data->refs);
+
+	/* wait for all refs nodes to complete */
 	wait_for_completion(&data->done);
-	io_ring_file_ref_flush(data);
 
 	__io_sqe_files_unregister(ctx);
 	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
 	for (i = 0; i < nr_tables; i++)
 		kfree(data->table[i].files);
 	kfree(data->table);
-	INIT_WORK(&data->ref_work, io_file_ref_exit_and_free);
-	queue_work(system_wq, &data->ref_work);
+	percpu_ref_exit(&data->refs);
+	kfree(data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
 	return 0;
@@ -6385,46 +6383,72 @@ static void io_ring_file_put(struct io_ring_ctx *ctx, struct file *file)
 }
 
 struct io_file_put {
-	struct llist_node llist;
+	struct list_head list;
 	struct file *file;
 };
 
-static void io_ring_file_ref_flush(struct fixed_file_data *data)
+static void io_file_put_work(struct work_struct *work)
 {
+	struct fixed_file_ref_node *ref_node;
+	struct fixed_file_data *file_data;
+	struct io_ring_ctx *ctx;
 	struct io_file_put *pfile, *tmp;
-	struct llist_node *node;
+	unsigned long flags;
 
-	while ((node = llist_del_all(&data->put_llist)) != NULL) {
-		llist_for_each_entry_safe(pfile, tmp, node, llist) {
-			io_ring_file_put(data->ctx, pfile->file);
-			kfree(pfile);
-		}
+	ref_node = container_of(work, struct fixed_file_ref_node, work);
+	file_data = ref_node->file_data;
+	ctx = file_data->ctx;
+
+	list_for_each_entry_safe(pfile, tmp, &ref_node->file_list, list) {
+		list_del_init(&pfile->list);
+		io_ring_file_put(ctx, pfile->file);
+		kfree(pfile);
 	}
+
+	spin_lock_irqsave(&file_data->lock, flags);
+	list_del_init(&ref_node->node);
+	spin_unlock_irqrestore(&file_data->lock, flags);
+
+	percpu_ref_exit(&ref_node->refs);
+	kfree(ref_node);
+	percpu_ref_put(&file_data->refs);
 }
 
-static void io_ring_file_ref_switch(struct work_struct *work)
+static void io_file_data_ref_zero(struct percpu_ref *ref)
 {
-	struct fixed_file_data *data;
+	struct fixed_file_ref_node *ref_node;
+
+	ref_node = container_of(ref, struct fixed_file_ref_node, refs);
 
-	data = container_of(work, struct fixed_file_data, ref_work);
-	io_ring_file_ref_flush(data);
-	percpu_ref_switch_to_percpu(&data->refs);
+	queue_work(system_wq, &ref_node->work);
 }
 
-static void io_file_data_ref_zero(struct percpu_ref *ref)
+static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
+			struct io_ring_ctx *ctx)
 {
-	struct fixed_file_data *data;
+	struct fixed_file_ref_node *ref_node;
 
-	data = container_of(ref, struct fixed_file_data, refs);
+	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
+	if (!ref_node)
+		return ERR_PTR(-ENOMEM);
 
-	/*
-	 * We can't safely switch from inside this context, punt to wq. If
-	 * the table ref is going away, the table is being unregistered.
-	 * Don't queue up the async work for that case, the caller will
-	 * handle it.
-	 */
-	if (!percpu_ref_is_dying(&data->refs))
-		queue_work(system_wq, &data->ref_work);
+	if (percpu_ref_init(&ref_node->refs, io_file_data_ref_zero,
+			    0, GFP_KERNEL)) {
+		kfree(ref_node);
+		return ERR_PTR(-ENOMEM);
+	}
+	INIT_LIST_HEAD(&ref_node->node);
+	INIT_LIST_HEAD(&ref_node->file_list);
+	INIT_WORK(&ref_node->work, io_file_put_work);
+	ref_node->file_data = ctx->file_data;
+	return ref_node;
+
+}
+
+static void destroy_fixed_file_ref_node(struct fixed_file_ref_node *ref_node)
+{
+	percpu_ref_exit(&ref_node->refs);
+	kfree(ref_node);
 }
 
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
@@ -6435,6 +6459,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	struct file *file;
 	int fd, ret = 0;
 	unsigned i;
+	struct fixed_file_ref_node *ref_node;
+	unsigned long flags;
 
 	if (ctx->file_data)
 		return -EBUSY;
@@ -6448,6 +6474,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -ENOMEM;
 	ctx->file_data->ctx = ctx;
 	init_completion(&ctx->file_data->done);
+	INIT_LIST_HEAD(&ctx->file_data->ref_list);
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	ctx->file_data->table = kcalloc(nr_tables,
@@ -6459,15 +6486,13 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -ENOMEM;
 	}
 
-	if (percpu_ref_init(&ctx->file_data->refs, io_file_data_ref_zero,
+	if (percpu_ref_init(&ctx->file_data->refs, io_file_ref_kill,
 				PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
 		kfree(ctx->file_data->table);
 		kfree(ctx->file_data);
 		ctx->file_data = NULL;
 		return -ENOMEM;
 	}
-	ctx->file_data->put_llist.first = NULL;
-	INIT_WORK(&ctx->file_data->ref_work, io_ring_file_ref_switch);
 
 	if (io_sqe_alloc_file_tables(ctx, nr_tables, nr_args)) {
 		percpu_ref_exit(&ctx->file_data->refs);
@@ -6530,9 +6555,22 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	ret = io_sqe_files_scm(ctx);
-	if (ret)
+	if (ret) {
 		io_sqe_files_unregister(ctx);
+		return ret;
+	}
 
+	ref_node = alloc_fixed_file_ref_node(ctx);
+	if (IS_ERR(ref_node)) {
+		io_sqe_files_unregister(ctx);
+		return PTR_ERR(ref_node);
+	}
+
+	ctx->file_data->cur_refs = &ref_node->refs;
+	spin_lock_irqsave(&ctx->file_data->lock, flags);
+	list_add(&ref_node->node, &ctx->file_data->ref_list);
+	spin_unlock_irqrestore(&ctx->file_data->lock, flags);
+	percpu_ref_get(&ctx->file_data->refs);
 	return ret;
 }
 
@@ -6579,30 +6617,21 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
-static void io_atomic_switch(struct percpu_ref *ref)
-{
-	struct fixed_file_data *data;
-
-	/*
-	 * Juggle reference to ensure we hit zero, if needed, so we can
-	 * switch back to percpu mode
-	 */
-	data = container_of(ref, struct fixed_file_data, refs);
-	percpu_ref_put(&data->refs);
-	percpu_ref_get(&data->refs);
-}
-
 static int io_queue_file_removal(struct fixed_file_data *data,
-				  struct file *file)
+				 struct file *file)
 {
 	struct io_file_put *pfile;
+	struct percpu_ref *refs = data->cur_refs;
+	struct fixed_file_ref_node *ref_node;
 
 	pfile = kzalloc(sizeof(*pfile), GFP_KERNEL);
 	if (!pfile)
 		return -ENOMEM;
 
+	ref_node = container_of(refs, struct fixed_file_ref_node, refs);
 	pfile->file = file;
-	llist_add(&pfile->llist, &data->put_llist);
+	list_add(&pfile->list, &ref_node->file_list);
+
 	return 0;
 }
 
@@ -6611,17 +6640,23 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 unsigned nr_args)
 {
 	struct fixed_file_data *data = ctx->file_data;
-	bool ref_switch = false;
+	struct fixed_file_ref_node *ref_node;
 	struct file *file;
 	__s32 __user *fds;
 	int fd, i, err;
 	__u32 done;
+	unsigned long flags;
+	bool needs_switch = false;
 
 	if (check_add_overflow(up->offset, nr_args, &done))
 		return -EOVERFLOW;
 	if (done > ctx->nr_user_files)
 		return -EINVAL;
 
+	ref_node = alloc_fixed_file_ref_node(ctx);
+	if (IS_ERR(ref_node))
+		return PTR_ERR(ref_node);
+
 	done = 0;
 	fds = u64_to_user_ptr(up->fds);
 	while (nr_args) {
@@ -6642,7 +6677,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			if (err)
 				break;
 			table->files[index] = NULL;
-			ref_switch = true;
+			needs_switch = true;
 		}
 		if (fd != -1) {
 			file = fget(fd);
@@ -6673,11 +6708,19 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		up->offset++;
 	}
 
-	if (ref_switch)
-		percpu_ref_switch_to_atomic(&data->refs, io_atomic_switch);
+	if (needs_switch) {
+		percpu_ref_kill(data->cur_refs);
+		spin_lock_irqsave(&data->lock, flags);
+		list_add(&ref_node->node, &data->ref_list);
+		data->cur_refs = &ref_node->refs;
+		spin_unlock_irqrestore(&data->lock, flags);
+		percpu_ref_get(&ctx->file_data->refs);
+	} else
+		destroy_fixed_file_ref_node(ref_node);
 
 	return done ? done : err;
 }
+
 static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 			       unsigned nr_args)
 {
-- 
2.17.2

