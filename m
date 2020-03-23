Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563A918F3F0
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2020 12:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgCWLyd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Mar 2020 07:54:33 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:49090 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728145AbgCWLyd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Mar 2020 07:54:33 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04397;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TtPCqbv_1584964242;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TtPCqbv_1584964242)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 23 Mar 2020 19:50:49 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: refacor file register/unregister/update based on sequence
Date:   Mon, 23 Mar 2020 19:50:36 +0800
Message-Id: <20200323115036.6539-1-xiaoguang.wang@linux.alibaba.com>
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

To fix this issue, we remove the percpu_ref related codes, and add two new
counter: sq_seq and cq_seq to struct io_ring_ctx:
    sq_seq: the most recent issued requset sequence number, which is
            protected uring_lock.
    cq_seq: the most recent completed request sequence number, which is
            protected completion_lock.

When we update fileset(under uring_lock), we record the current sq_seq,
and when cq_seq is greater or equal to recorded sq_seq, we know we can
put previous registered file safely.

Link: https://lore.kernel.org/io-uring/5a8dac33-4ca2-4847-b091-f7dcd3ad0ff3@linux.alibaba.com/T/#t
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 278 ++++++++++++++++++++++++++++----------------------
 1 file changed, 155 insertions(+), 123 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3affd96a98ba..d33cf957a074 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -186,13 +186,27 @@ struct fixed_file_table {
 struct fixed_file_data {
 	struct fixed_file_table		*table;
 	struct io_ring_ctx		*ctx;
-
 	struct percpu_ref		refs;
-	struct llist_head		put_llist;
+	struct list_head		drop_list;
 	struct work_struct		ref_work;
+	unsigned long			wait_seq;
+	wait_queue_head_t		wait;
 	struct completion		done;
 };
 
+struct io_file {
+	struct list_head list;
+	struct file *file;
+};
+
+struct io_file_set {
+	unsigned long			seq;
+	struct list_head		file_list;
+	struct list_head		node;
+	struct fixed_file_data		*file_data;
+	struct work_struct		work;
+};
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -306,6 +320,11 @@ struct io_ring_ctx {
 		spinlock_t		inflight_lock;
 		struct list_head	inflight_list;
 	} ____cacheline_aligned_in_smp;
+
+	struct {
+		unsigned long		sq_seq;
+		unsigned long		cq_seq;
+	} ____cacheline_aligned_in_smp;
 };
 
 /*
@@ -759,7 +778,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_files_update *ip,
 				 unsigned nr_args);
 static int io_grab_files(struct io_kiocb *req);
-static void io_ring_file_ref_flush(struct fixed_file_data *data);
+static void io_ring_file_put(struct io_ring_ctx *ctx, struct file *file);
 static void io_cleanup_req(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
@@ -1017,6 +1036,56 @@ static void io_kill_timeouts(struct io_ring_ctx *ctx)
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
+static void put_files(struct io_file_set *drop_files)
+{
+	struct io_file *pfile, *tmp;
+	struct fixed_file_data *file_data = drop_files->file_data;
+	struct io_ring_ctx *ctx = file_data->ctx;
+
+	list_for_each_entry_safe(pfile, tmp, &drop_files->file_list, list) {
+		list_del_init(&pfile->list);
+		io_ring_file_put(ctx, pfile->file);
+		kfree(pfile);
+	}
+
+}
+
+static void io_file_put_work(struct work_struct *work)
+{
+	struct io_file_set *drop_files;
+	struct fixed_file_data *data;
+
+	drop_files = container_of(work, struct io_file_set, work);
+	data = drop_files->file_data;
+	put_files(drop_files);
+	kfree(drop_files);
+	percpu_ref_put(&data->refs);
+}
+
+static void io_file_set_put(struct io_ring_ctx *ctx)
+{
+	struct fixed_file_data *data = ctx->file_data;
+	struct io_file_set *drop_files, *tmp;
+
+	if (!data)
+		return;
+
+	if (unlikely(data->wait_seq <= ctx->cq_seq &&
+	    wq_has_sleeper(&data->wait)))
+		wake_up(&data->wait);
+
+	if (list_empty(&data->drop_list))
+		return;
+
+	list_for_each_entry_safe(drop_files, tmp, &data->drop_list, node) {
+		if (drop_files->seq <= ctx->cq_seq) {
+			list_del_init(&drop_files->node);
+			queue_work(system_wq, &drop_files->work);
+		} else
+			break;
+	}
+}
+
 static void io_commit_cqring(struct io_ring_ctx *ctx)
 {
 	struct io_kiocb *req;
@@ -1026,6 +1095,8 @@ static void io_commit_cqring(struct io_ring_ctx *ctx)
 
 	__io_commit_cqring(ctx);
 
+	io_file_set_put(ctx);
+
 	while ((req = io_get_deferred_req(ctx)) != NULL)
 		io_queue_async_work(req);
 }
@@ -1162,6 +1233,7 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 		req->result = res;
 		list_add_tail(&req->list, &ctx->cq_overflow_list);
 	}
+	ctx->cq_seq++;
 }
 
 static void io_cqring_add_event(struct io_kiocb *req, long res)
@@ -1256,18 +1328,12 @@ static void __io_req_do_free(struct io_kiocb *req)
 
 static void __io_req_aux_free(struct io_kiocb *req)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		io_cleanup_req(req);
 
 	kfree(req->io);
-	if (req->file) {
-		if (req->flags & REQ_F_FIXED_FILE)
-			percpu_ref_put(&ctx->file_data->refs);
-		else
-			fput(req->file);
-	}
+	if (req->file && !(req->flags & REQ_F_FIXED_FILE))
+		fput(req->file);
 
 	io_req_work_drop_env(req);
 }
@@ -1339,8 +1405,6 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 	}
 do_free:
 	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
-	if (fixed_refs)
-		percpu_ref_put_many(&ctx->file_data->refs, fixed_refs);
 	percpu_ref_put_many(&ctx->refs, rb->to_free);
 	rb->to_free = rb->need_iter = 0;
 }
@@ -4122,7 +4186,9 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock)
 	up.fds = req->files_update.arg;
 
 	mutex_lock(&ctx->uring_lock);
+	ctx->sq_seq--;
 	ret = __io_sqe_files_update(ctx, &up, req->files_update.nr_args);
+	ctx->sq_seq++;
 	mutex_unlock(&ctx->uring_lock);
 
 	if (ret < 0)
@@ -4600,7 +4666,6 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 		if (!req->file)
 			return -EBADF;
 		req->flags |= REQ_F_FIXED_FILE;
-		percpu_ref_get(&ctx->file_data->refs);
 	} else {
 		if (req->needs_fixed_file)
 			return -EBADF;
@@ -5002,6 +5067,7 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		req->opcode = READ_ONCE((*sqe_ptr)->opcode);
 		req->user_data = READ_ONCE((*sqe_ptr)->user_data);
 		ctx->cached_sq_head++;
+		ctx->sq_seq++;
 		return true;
 	}
 
@@ -5336,51 +5402,37 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 #endif
 }
 
-static void io_file_ref_kill(struct percpu_ref *ref)
-{
-	struct fixed_file_data *data;
-
-	data = container_of(ref, struct fixed_file_data, refs);
-	complete(&data->done);
-}
-
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
 	unsigned nr_tables, i;
+	DEFINE_WAIT(wait);
+	unsigned long flags;
 
 	if (!data)
 		return -ENXIO;
 
-	percpu_ref_kill_and_confirm(&data->refs, io_file_ref_kill);
-	flush_work(&data->ref_work);
+	percpu_ref_kill(&data->refs);
 	wait_for_completion(&data->done);
-	io_ring_file_ref_flush(data);
+
+	spin_lock_irqsave(&ctx->completion_lock, flags);
+	prepare_to_wait(&data->wait, &wait, TASK_INTERRUPTIBLE);
+	if (ctx->cq_seq >= ctx->sq_seq) {
+		finish_wait(&data->wait, &wait);
+		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	} else {
+		data->wait_seq = ctx->sq_seq;
+		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+		schedule();
+		finish_wait(&data->wait, &wait);
+		data->wait_seq = 0;
+	}
 
 	__io_sqe_files_unregister(ctx);
 	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
 	for (i = 0; i < nr_tables; i++)
 		kfree(data->table[i].files);
 	kfree(data->table);
-	INIT_WORK(&data->ref_work, io_file_ref_exit_and_free);
-	queue_work(system_wq, &data->ref_work);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
 	return 0;
@@ -5604,51 +5656,12 @@ static void io_ring_file_put(struct io_ring_ctx *ctx, struct file *file)
 #endif
 }
 
-struct io_file_put {
-	struct llist_node llist;
-	struct file *file;
-	struct completion *done;
-};
-
-static void io_ring_file_ref_flush(struct fixed_file_data *data)
-{
-	struct io_file_put *pfile, *tmp;
-	struct llist_node *node;
-
-	while ((node = llist_del_all(&data->put_llist)) != NULL) {
-		llist_for_each_entry_safe(pfile, tmp, node, llist) {
-			io_ring_file_put(data->ctx, pfile->file);
-			if (pfile->done)
-				complete(pfile->done);
-			else
-				kfree(pfile);
-		}
-	}
-}
-
-static void io_ring_file_ref_switch(struct work_struct *work)
-{
-	struct fixed_file_data *data;
-
-	data = container_of(work, struct fixed_file_data, ref_work);
-	io_ring_file_ref_flush(data);
-	percpu_ref_switch_to_percpu(&data->refs);
-}
-
 static void io_file_data_ref_zero(struct percpu_ref *ref)
 {
 	struct fixed_file_data *data;
 
 	data = container_of(ref, struct fixed_file_data, refs);
-
-	/*
-	 * We can't safely switch from inside this context, punt to wq. If
-	 * the table ref is going away, the table is being unregistered.
-	 * Don't queue up the async work for that case, the caller will
-	 * handle it.
-	 */
-	if (!percpu_ref_is_dying(&data->refs))
-		queue_work(system_wq, &data->ref_work);
+	complete(&data->done);
 }
 
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
@@ -5672,6 +5685,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -ENOMEM;
 	ctx->file_data->ctx = ctx;
 	init_completion(&ctx->file_data->done);
+	init_waitqueue_head(&ctx->file_data->wait);
+	INIT_LIST_HEAD(&ctx->file_data->drop_list);
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	ctx->file_data->table = kcalloc(nr_tables,
@@ -5684,17 +5699,15 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	if (percpu_ref_init(&ctx->file_data->refs, io_file_data_ref_zero,
-				PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
+			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
+		percpu_ref_exit(&ctx->file_data->refs);
 		kfree(ctx->file_data->table);
 		kfree(ctx->file_data);
 		ctx->file_data = NULL;
 		return -ENOMEM;
 	}
-	ctx->file_data->put_llist.first = NULL;
-	INIT_WORK(&ctx->file_data->ref_work, io_ring_file_ref_switch);
 
 	if (io_sqe_alloc_file_tables(ctx, nr_tables, nr_args)) {
-		percpu_ref_exit(&ctx->file_data->refs);
 		kfree(ctx->file_data->table);
 		kfree(ctx->file_data);
 		ctx->file_data = NULL;
@@ -5803,46 +5816,40 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
-static void io_atomic_switch(struct percpu_ref *ref)
+static void io_queue_file_removal(struct fixed_file_data *data,
+			struct io_file_set *drop_files, struct file *file)
 {
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
-static bool io_queue_file_removal(struct fixed_file_data *data,
-				  struct file *file)
-{
-	struct io_file_put *pfile, pfile_stack;
-	DECLARE_COMPLETION_ONSTACK(done);
+	struct io_file *pfile;
+	struct io_ring_ctx *ctx = data->ctx;
+	unsigned long flags;
+	DEFINE_WAIT(wait);
 
 	/*
 	 * If we fail allocating the struct we need for doing async reomval
 	 * of this file, just punt to sync and wait for it.
 	 */
 	pfile = kzalloc(sizeof(*pfile), GFP_KERNEL);
-	if (!pfile) {
-		pfile = &pfile_stack;
-		pfile->done = &done;
+	if (pfile) {
+		pfile->file = file;
+		INIT_LIST_HEAD(&pfile->list);
+		list_add(&pfile->list, &drop_files->file_list);
+		return;
 	}
 
-	pfile->file = file;
-	llist_add(&pfile->llist, &data->put_llist);
-
-	if (pfile == &pfile_stack) {
-		percpu_ref_switch_to_atomic(&data->refs, io_atomic_switch);
-		wait_for_completion(&done);
-		flush_work(&data->ref_work);
-		return false;
+	spin_lock_irqsave(&ctx->completion_lock, flags);
+	prepare_to_wait(&data->wait, &wait, TASK_INTERRUPTIBLE);
+	if (ctx->cq_seq >= ctx->sq_seq) {
+		finish_wait(&data->wait, &wait);
+		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+		io_ring_file_put(ctx, file);
+		return;
 	}
-
-	return true;
+	data->wait_seq = ctx->sq_seq;
+	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	schedule();
+	finish_wait(&data->wait, &wait);
+	data->wait_seq = 0;
+	return;
 }
 
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
@@ -5850,17 +5857,26 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 unsigned nr_args)
 {
 	struct fixed_file_data *data = ctx->file_data;
-	bool ref_switch = false;
 	struct file *file;
 	__s32 __user *fds;
 	int fd, i, err;
 	__u32 done;
+	struct io_file_set *drop_files;
 
 	if (check_add_overflow(up->offset, nr_args, &done))
 		return -EOVERFLOW;
 	if (done > ctx->nr_user_files)
 		return -EINVAL;
 
+	drop_files = kzalloc(sizeof(*drop_files), GFP_KERNEL);
+	if (!drop_files)
+		return -ENOMEM;
+
+	drop_files->file_data = data;
+	drop_files->seq = ctx->sq_seq;
+	INIT_LIST_HEAD(&drop_files->file_list);
+	INIT_LIST_HEAD(&drop_files->node);
+	INIT_WORK(&drop_files->work, io_file_put_work);
 	done = 0;
 	fds = u64_to_user_ptr(up->fds);
 	while (nr_args) {
@@ -5878,8 +5894,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		if (table->files[index]) {
 			file = io_file_from_index(ctx, index);
 			table->files[index] = NULL;
-			if (io_queue_file_removal(data, file))
-				ref_switch = true;
+			io_queue_file_removal(data, drop_files, file);
 		}
 		if (fd != -1) {
 			file = fget(fd);
@@ -5910,8 +5925,25 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		up->offset++;
 	}
 
-	if (ref_switch)
-		percpu_ref_switch_to_atomic(&data->refs, io_atomic_switch);
+	if (!list_empty(&drop_files->file_list)) {
+		unsigned long flags;
+		bool drop = false;
+
+		spin_lock_irqsave(&ctx->completion_lock, flags);
+		if (ctx->cq_seq >= ctx->sq_seq)
+			drop = true;
+		else {
+			drop_files->seq = ctx->sq_seq;
+			list_add_tail(&drop_files->node, &data->drop_list);
+		}
+		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+
+		if (drop) {
+			put_files(drop_files);
+			kfree(drop_files);
+		} else
+			percpu_ref_get(&ctx->file_data->refs);
+	}
 
 	return done ? done : err;
 }
-- 
2.17.2

