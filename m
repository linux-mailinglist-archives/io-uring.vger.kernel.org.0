Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4794216F1
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238853AbhJDTFr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238852AbhJDTFr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:47 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1410C061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:03:57 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g8so68939041edt.7
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sux+GsObXa+f2NFJl8fsdybVNouratHOb1fNbD0bx3E=;
        b=CPI/qXVWvyLO7fBlO4S2jFLRaR7D3eGH9+CCQVP1Iey0olZYJj4xi0QkYjz+Q/f+Aq
         4icG9QnNbYtNmX86vnG7mRuDCCjYIG2W1irSJR9z6pMCPbUjmknp4dVVApcK4d5jk3aT
         4R3PVaJgnr7NvekjC8BdtG83T67L0JVhAYnAz/icNZ+IQ9SsraQZ4DLmSWhsPTMo5fEW
         +jZt0F1ofi0XtZJOPdU59u3mSNg0qI4MZt5S60V34vS07p8w7AfwGMFpi7xO3mjMFQCK
         8KS45X0AVyCAhi9MssYQiFwuXSL5+4sys5wgviZiCghpsbNUMhgTnyAEFujNs3L1pFET
         3OiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sux+GsObXa+f2NFJl8fsdybVNouratHOb1fNbD0bx3E=;
        b=lCRt+q5VHipeiMhEYrK/C7SZpwPrQv0MAM0o7UBszO1G4vWeP89Sqqtw5ykrJ4T2YG
         /6snexqg90ec/+T2lAA9cYy5Q0RBx3KOHMkTCPIZV/LUhdefFUIH+9PwEYOCSbT5kUvb
         WG3KD98TvtqxHI7k8+4MoqnS6208vzOxWm+rwWUVAi6a7H+0HCUyUZjMvTTpvXEQn5Li
         ACdRQGT/RzOuvdjBAhd8Sc7nqSCX0jY4TQCeSeZ0Cyv/+VWeOwYqg/J95TwDMuHwp7Dn
         JTYjPtJEG1jIWbubh9rDVmH42L7pjkxarDp+zSnkLKx9mtFkiYgEBRrX3GTfma368gLg
         H0tg==
X-Gm-Message-State: AOAM532XrdOa32BjHfCtw4bfLh+f7TuT23undE3NYhAWpnBVKYOqZd7a
        pZ5jwDPZy5SKjTqifw9U26QhP5NJg9k=
X-Google-Smtp-Source: ABdhPJzNMG61ImQ+FE8lGJAukEegV537J8ittlu2XkcEqWvseD7E1sbxnAufHmv0F+C6ezk4tngB/g==
X-Received: by 2002:a17:906:3148:: with SMTP id e8mr18909683eje.240.1633374236059;
        Mon, 04 Oct 2021 12:03:56 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:03:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 09/16] io_uring: mark cold functions
Date:   Mon,  4 Oct 2021 20:02:54 +0100
Message-Id: <b53d385f91dca45170b67d7f11c7abd787e821f6.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Attribute cold functions so compilers can optimise them for size. It
shrinks the binary by 2.5-3%

   text    data     bss     dec     hex filename
  90670   14002       8  104680   198e8 ./fs/io_uring.o
  88053   14002       8  102063   18eaf ./fs/io_uring.o

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 123 ++++++++++++++++++++++++++------------------------
 1 file changed, 64 insertions(+), 59 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2b7f38df6a0c..10112ea73e77 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1230,7 +1230,7 @@ static inline void req_fail_link_node(struct io_kiocb *req, int res)
 	req->result = res;
 }
 
-static void io_ring_ctx_ref_free(struct percpu_ref *ref)
+static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
 {
 	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
 
@@ -1242,7 +1242,7 @@ static inline bool io_is_timeout_noseq(struct io_kiocb *req)
 	return !req->timeout.off;
 }
 
-static void io_fallback_req_func(struct work_struct *work)
+static __cold void io_fallback_req_func(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
 						fallback_work.work);
@@ -1262,7 +1262,7 @@ static void io_fallback_req_func(struct work_struct *work)
 
 }
 
-static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
+static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
 	struct io_ring_ctx *ctx;
 	int hash_bits;
@@ -1361,7 +1361,7 @@ static inline bool io_req_ffs_set(struct io_kiocb *req)
 	return IS_ENABLED(CONFIG_64BIT) && (req->flags & REQ_F_FIXED_FILE);
 }
 
-static void io_req_track_inflight(struct io_kiocb *req)
+static inline void io_req_track_inflight(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_INFLIGHT)) {
 		req->flags |= REQ_F_INFLIGHT;
@@ -1500,7 +1500,7 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 	}
 }
 
-static void io_queue_deferred(struct io_ring_ctx *ctx)
+static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
 {
 	while (!list_empty(&ctx->defer_list)) {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
@@ -1514,7 +1514,7 @@ static void io_queue_deferred(struct io_ring_ctx *ctx)
 	}
 }
 
-static void io_flush_timeouts(struct io_ring_ctx *ctx)
+static __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->completion_lock)
 {
 	u32 seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
@@ -1547,7 +1547,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 	spin_unlock_irq(&ctx->timeout_lock);
 }
 
-static void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
+static __cold void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
 	if (ctx->off_timeout_used)
 		io_flush_timeouts(ctx);
@@ -1903,7 +1903,7 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
  * Because of that, io_alloc_req() should be called only under ->uring_lock
  * and with extra caution to not get a request that is still worked on.
  */
-static bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
+static __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state = &ctx->submit_state;
@@ -1975,7 +1975,7 @@ static inline void io_dismantle_req(struct io_kiocb *req)
 	}
 }
 
-static void __io_free_req(struct io_kiocb *req)
+static __cold void __io_free_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -2462,7 +2462,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
  * We can't just wait for polled events to come to us, we have to actively
  * find and complete them.
  */
-static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
+static __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 {
 	if (!(ctx->flags & IORING_SETUP_IOPOLL))
 		return;
@@ -5635,8 +5635,8 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 /*
  * Returns true if we found and killed one or more poll requests
  */
-static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
-			       bool cancel_all)
+static __cold bool io_poll_remove_all(struct io_ring_ctx *ctx,
+				      struct task_struct *tsk, bool cancel_all)
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
@@ -6428,7 +6428,7 @@ static u32 io_get_sequence(struct io_kiocb *req)
 	return seq;
 }
 
-static void io_drain_req(struct io_kiocb *req)
+static __cold void io_drain_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_defer_entry *de;
@@ -7308,7 +7308,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 	return ret;
 }
 
-static void io_sqd_update_thread_idle(struct io_sq_data *sqd)
+static __cold void io_sqd_update_thread_idle(struct io_sq_data *sqd)
 {
 	struct io_ring_ctx *ctx;
 	unsigned sq_thread_idle = 0;
@@ -7562,7 +7562,7 @@ static void io_free_page_table(void **table, size_t size)
 	kfree(table);
 }
 
-static void **io_alloc_page_table(size_t size)
+static __cold void **io_alloc_page_table(size_t size)
 {
 	unsigned i, nr_tables = DIV_ROUND_UP(size, PAGE_SIZE);
 	size_t init_size = size;
@@ -7591,7 +7591,7 @@ static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
 	kfree(ref_node);
 }
 
-static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
+static __cold void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 {
 	struct io_rsrc_node *node = container_of(ref, struct io_rsrc_node, refs);
 	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
@@ -7668,7 +7668,8 @@ static int io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
 	return ctx->rsrc_backup_node ? 0 : -ENOMEM;
 }
 
-static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ctx)
+static __cold int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
+				      struct io_ring_ctx *ctx)
 {
 	int ret;
 
@@ -7724,9 +7725,9 @@ static void io_rsrc_data_free(struct io_rsrc_data *data)
 	kfree(data);
 }
 
-static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
-			      u64 __user *utags, unsigned nr,
-			      struct io_rsrc_data **pdata)
+static __cold int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
+				     u64 __user *utags, unsigned nr,
+				     struct io_rsrc_data **pdata)
 {
 	struct io_rsrc_data *data;
 	int ret = -ENOMEM;
@@ -8496,8 +8497,8 @@ static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 	return io_wq_create(concurrency, &data);
 }
 
-static int io_uring_alloc_task_context(struct task_struct *task,
-				       struct io_ring_ctx *ctx)
+static __cold int io_uring_alloc_task_context(struct task_struct *task,
+					      struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx;
 	int ret;
@@ -8544,8 +8545,8 @@ void __io_uring_free(struct task_struct *tsk)
 	tsk->io_uring = NULL;
 }
 
-static int io_sq_offload_create(struct io_ring_ctx *ctx,
-				struct io_uring_params *p)
+static __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
+				       struct io_uring_params *p)
 {
 	int ret;
 
@@ -9184,7 +9185,7 @@ static void io_wait_rsrc_data(struct io_rsrc_data *data)
 		wait_for_completion(&data->done);
 }
 
-static void io_ring_ctx_free(struct io_ring_ctx *ctx)
+static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
 
@@ -9293,7 +9294,7 @@ struct io_tctx_exit {
 	struct io_ring_ctx		*ctx;
 };
 
-static void io_tctx_exit_cb(struct callback_head *cb)
+static __cold void io_tctx_exit_cb(struct callback_head *cb)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_exit *work;
@@ -9308,14 +9309,14 @@ static void io_tctx_exit_cb(struct callback_head *cb)
 	complete(&work->completion);
 }
 
-static bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
+static __cold bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
 	return req->ctx == data;
 }
 
-static void io_ring_exit_work(struct work_struct *work)
+static __cold void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
 	unsigned long timeout = jiffies + HZ * 60 * 5;
@@ -9386,8 +9387,8 @@ static void io_ring_exit_work(struct work_struct *work)
 }
 
 /* Returns true if we found and killed one or more timeouts */
-static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
-			     bool cancel_all)
+static __cold bool io_kill_timeouts(struct io_ring_ctx *ctx,
+				    struct task_struct *tsk, bool cancel_all)
 {
 	struct io_kiocb *req, *tmp;
 	int canceled = 0;
@@ -9409,7 +9410,7 @@ static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	return canceled != 0;
 }
 
-static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
+static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	unsigned long index;
 	struct creds *creds;
@@ -9471,8 +9472,9 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 	return ret;
 }
 
-static bool io_cancel_defer_files(struct io_ring_ctx *ctx,
-				  struct task_struct *task, bool cancel_all)
+static __cold bool io_cancel_defer_files(struct io_ring_ctx *ctx,
+					 struct task_struct *task,
+					 bool cancel_all)
 {
 	struct io_defer_entry *de;
 	LIST_HEAD(list);
@@ -9497,7 +9499,7 @@ static bool io_cancel_defer_files(struct io_ring_ctx *ctx,
 	return true;
 }
 
-static bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
+static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 {
 	struct io_tctx_node *node;
 	enum io_wq_cancel cret;
@@ -9521,9 +9523,9 @@ static bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
-					 struct task_struct *task,
-					 bool cancel_all)
+static __cold void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
+						struct task_struct *task,
+						bool cancel_all)
 {
 	struct io_task_cancel cancel = { .task = task, .all = cancel_all, };
 	struct io_uring_task *tctx = task ? task->io_uring : NULL;
@@ -9613,7 +9615,7 @@ static inline int io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 /*
  * Remove this io_uring_file -> task mapping.
  */
-static void io_uring_del_tctx_node(unsigned long index)
+static __cold void io_uring_del_tctx_node(unsigned long index)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
@@ -9636,7 +9638,7 @@ static void io_uring_del_tctx_node(unsigned long index)
 	kfree(node);
 }
 
-static void io_uring_clean_tctx(struct io_uring_task *tctx)
+static __cold void io_uring_clean_tctx(struct io_uring_task *tctx)
 {
 	struct io_wq *wq = tctx->io_wq;
 	struct io_tctx_node *node;
@@ -9663,7 +9665,7 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 	return percpu_counter_sum(&tctx->inflight);
 }
 
-static void io_uring_drop_tctx_refs(struct task_struct *task)
+static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 {
 	struct io_uring_task *tctx = task->io_uring;
 	unsigned int refs = tctx->cached_refs;
@@ -9679,7 +9681,8 @@ static void io_uring_drop_tctx_refs(struct task_struct *task)
  * Find any io_uring ctx that this task has registered or done IO on, and cancel
  * requests. @sqd should be not-null IIF it's an SQPOLL thread cancellation.
  */
-static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
+static __cold void io_uring_cancel_generic(bool cancel_all,
+					   struct io_sq_data *sqd)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_ring_ctx *ctx;
@@ -9772,7 +9775,7 @@ static void *io_uring_validate_mmap_request(struct file *file,
 
 #ifdef CONFIG_MMU
 
-static int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
+static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	size_t sz = vma->vm_end - vma->vm_start;
 	unsigned long pfn;
@@ -9957,7 +9960,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 }
 
 #ifdef CONFIG_PROC_FS
-static int io_uring_show_cred(struct seq_file *m, unsigned int id,
+static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
 		const struct cred *cred)
 {
 	struct user_namespace *uns = seq_user_ns(m);
@@ -9989,7 +9992,8 @@ static int io_uring_show_cred(struct seq_file *m, unsigned int id,
 	return 0;
 }
 
-static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
+static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
+					  struct seq_file *m)
 {
 	struct io_sq_data *sq = NULL;
 	struct io_overflow_cqe *ocqe;
@@ -10101,7 +10105,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	spin_unlock(&ctx->completion_lock);
 }
 
-static void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
+static __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 {
 	struct io_ring_ctx *ctx = f->private_data;
 
@@ -10125,8 +10129,8 @@ static const struct file_operations io_uring_fops = {
 #endif
 };
 
-static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
-				  struct io_uring_params *p)
+static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
+					 struct io_uring_params *p)
 {
 	struct io_rings *rings;
 	size_t size, sq_array_offset;
@@ -10215,8 +10219,8 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 	return file;
 }
 
-static int io_uring_create(unsigned entries, struct io_uring_params *p,
-			   struct io_uring_params __user *params)
+static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
+				  struct io_uring_params __user *params)
 {
 	struct io_ring_ctx *ctx;
 	struct file *file;
@@ -10374,7 +10378,8 @@ SYSCALL_DEFINE2(io_uring_setup, u32, entries,
 	return io_uring_setup(entries, params);
 }
 
-static int io_probe(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
+static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
+			   unsigned nr_args)
 {
 	struct io_uring_probe *p;
 	size_t size;
@@ -10430,8 +10435,8 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 	return id;
 }
 
-static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
-				    unsigned int nr_args)
+static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
+					   void __user *arg, unsigned int nr_args)
 {
 	struct io_uring_restriction *res;
 	size_t size;
@@ -10565,7 +10570,7 @@ static int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 	return __io_register_rsrc_update(ctx, type, &up, up.nr);
 }
 
-static int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
+static __cold int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned int size, unsigned int type)
 {
 	struct io_uring_rsrc_register rr;
@@ -10591,8 +10596,8 @@ static int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 	return -EINVAL;
 }
 
-static int io_register_iowq_aff(struct io_ring_ctx *ctx, void __user *arg,
-				unsigned len)
+static __cold int io_register_iowq_aff(struct io_ring_ctx *ctx,
+				       void __user *arg, unsigned len)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	cpumask_var_t new_mask;
@@ -10618,7 +10623,7 @@ static int io_register_iowq_aff(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
-static int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
+static __cold int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx = current->io_uring;
 
@@ -10628,8 +10633,8 @@ static int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
 	return io_wq_cpu_affinity(tctx->io_wq, NULL);
 }
 
-static int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
-					void __user *arg)
+static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
+					       void __user *arg)
 {
 	struct io_uring_task *tctx = NULL;
 	struct io_sq_data *sqd = NULL;
@@ -10710,7 +10715,7 @@ static bool io_register_op_must_quiesce(int op)
 	}
 }
 
-static int io_ctx_quiesce(struct io_ring_ctx *ctx)
+static __cold int io_ctx_quiesce(struct io_ring_ctx *ctx)
 {
 	long ret;
 
-- 
2.33.0

