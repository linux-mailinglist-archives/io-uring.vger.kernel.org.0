Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF4E31FDAB
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhBSRLX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhBSRLP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:11:15 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2A2C06121E
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:30 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id q9so5094082ilo.1
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lRIqKR4zz64eVXWUItnuHtA1aG+QSyDSd5v3KnCne0A=;
        b=ADfZSayBfJQHVUV4OBWnyKxg1b97Cm7QsXbBccptnPQ1kEwI5vAd375LcQX9SZin35
         QgTxQEBMJwv6EHEC29UWZF8SM8wUP/bYOV6tlgwYawrKsL6MWcSpBGFimgsDj2szV01o
         1wpDj3+lheWyJvxDcitVu0RaWHcWe4BGVOuWqN4r/+lduIlXsMui6lRYIOD5bQ1MHEQv
         uGiZ53g1cukh2j07lqM8iCAkAnJrhGVRrpxhRFaLFaCh6pRw8k29AQb1iKw3rGF3zbMp
         Llh7PBVMRExMIQ9Rho+D/lcJNrCUHG0WeIcUUR7xeJhhKcTWduugovz1MytLfPc8iUwN
         ekuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lRIqKR4zz64eVXWUItnuHtA1aG+QSyDSd5v3KnCne0A=;
        b=JU7KldziNGnEV3ExuvstW3QYoxdnrvYtfoalW7cOpIvXaygATwdbF3hiqQF7oQFvAY
         god0r6nQMxDZUokOMhrySP3v/9HWlZ0rHC3vy1Sr3M1nc8uqn6Hct45+qfAJCZTsGilB
         yK+uAuKqIgnrweOysaKGBlttAsDznJcnFhYfQZQ2IuMHXv8/wTD8GLJxTFjmMHsZkf5Z
         KspoNdemgNPLYv/MtsrgvTIVetr+BudCQywvspFW4aiR3u38BMNGqySFEIt4xS7NkvOf
         1DS63tS2PQLewvM6sEWAoxiqeu907cWS+wFkzMutPE50f8eLoZ9J73B4pdjyb5lcgh6s
         AOhg==
X-Gm-Message-State: AOAM531TEc0ta5B5Azw0iKexfXKqS3wIQxf55u26g9iq8dPH5LPggwFR
        ILCCn7T2EGWuv2bmI8zbCsgRs30gs9lVAK6U
X-Google-Smtp-Source: ABdhPJyixRhVcaihiE/Ue7p1eCfmvs+G07BrKKSeWavzEP/0sI3O85+GTIrJxaYU6bjlPu3wLFHxBA==
X-Received: by 2002:a05:6e02:180b:: with SMTP id a11mr4780357ilv.231.1613754629689;
        Fri, 19 Feb 2021 09:10:29 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:29 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 15/18] io_uring: move SQPOLL thread io-wq forked worker
Date:   Fri, 19 Feb 2021 10:10:07 -0700
Message-Id: <20210219171010.281878-16-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't use a kthread for SQPOLL, use a forked worker just like the io-wq
workers. With that done, we can drop the various context grabbing we do
for SQPOLL, it already has everything it needs.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 446 ++++++++++++++++++--------------------------------
 1 file changed, 162 insertions(+), 284 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 980c62762359..239eacec3f3a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -57,7 +57,6 @@
 #include <linux/mman.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
-#include <linux/kthread.h>
 #include <linux/blkdev.h>
 #include <linux/bvec.h>
 #include <linux/net.h>
@@ -253,6 +252,11 @@ struct io_restriction {
 	bool registered;
 };
 
+enum {
+	IO_SQ_THREAD_SHOULD_STOP = 0,
+	IO_SQ_THREAD_SHOULD_PARK,
+};
+
 struct io_sq_data {
 	refcount_t		refs;
 	struct mutex		lock;
@@ -266,6 +270,12 @@ struct io_sq_data {
 	struct wait_queue_head	wait;
 
 	unsigned		sq_thread_idle;
+	int			sq_cpu;
+	pid_t			task_pid;
+
+	unsigned long		state;
+	struct completion	completion;
+	struct completion	exited;
 };
 
 #define IO_IOPOLL_BATCH			8
@@ -366,18 +376,13 @@ struct io_ring_ctx {
 	struct io_rings	*rings;
 
 	/*
-	 * For SQPOLL usage - we hold a reference to the parent task, so we
-	 * have access to the ->files
+	 * For SQPOLL usage
 	 */
 	struct task_struct	*sqo_task;
 
 	/* Only used for accounting purposes */
 	struct mm_struct	*mm_account;
 
-#ifdef CONFIG_BLK_CGROUP
-	struct cgroup_subsys_state	*sqo_blkcg_css;
-#endif
-
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
 	struct wait_queue_head	sqo_sq_wait;
@@ -397,13 +402,6 @@ struct io_ring_ctx {
 
 	struct user_struct	*user;
 
-	const struct cred	*creds;
-
-#ifdef CONFIG_AUDIT
-	kuid_t			loginuid;
-	unsigned int		sessionid;
-#endif
-
 	struct completion	ref_comp;
 	struct completion	sq_thread_comp;
 
@@ -995,6 +993,7 @@ static const struct io_op_def io_op_defs[] = {
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 struct files_struct *files);
+static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx);
 static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node);
 static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 			struct io_ring_ctx *ctx);
@@ -1092,118 +1091,6 @@ static bool io_match_task(struct io_kiocb *head,
 	return false;
 }
 
-static void io_sq_thread_drop_mm_files(void)
-{
-	struct files_struct *files = current->files;
-	struct mm_struct *mm = current->mm;
-
-	if (mm) {
-		kthread_unuse_mm(mm);
-		mmput(mm);
-		current->mm = NULL;
-	}
-	if (files) {
-		struct nsproxy *nsproxy = current->nsproxy;
-
-		task_lock(current);
-		current->files = NULL;
-		current->nsproxy = NULL;
-		task_unlock(current);
-		put_files_struct(files);
-		put_nsproxy(nsproxy);
-	}
-}
-
-static int __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
-{
-	if (!current->files) {
-		struct files_struct *files;
-		struct nsproxy *nsproxy;
-
-		task_lock(ctx->sqo_task);
-		files = ctx->sqo_task->files;
-		if (!files) {
-			task_unlock(ctx->sqo_task);
-			return -EOWNERDEAD;
-		}
-		atomic_inc(&files->count);
-		get_nsproxy(ctx->sqo_task->nsproxy);
-		nsproxy = ctx->sqo_task->nsproxy;
-		task_unlock(ctx->sqo_task);
-
-		task_lock(current);
-		current->files = files;
-		current->nsproxy = nsproxy;
-		task_unlock(current);
-	}
-	return 0;
-}
-
-static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
-{
-	struct mm_struct *mm;
-
-	if (current->mm)
-		return 0;
-
-	task_lock(ctx->sqo_task);
-	mm = ctx->sqo_task->mm;
-	if (unlikely(!mm || !mmget_not_zero(mm)))
-		mm = NULL;
-	task_unlock(ctx->sqo_task);
-
-	if (mm) {
-		kthread_use_mm(mm);
-		return 0;
-	}
-
-	return -EFAULT;
-}
-
-static int __io_sq_thread_acquire_mm_files(struct io_ring_ctx *ctx,
-					   struct io_kiocb *req)
-{
-	int ret;
-
-	ret = __io_sq_thread_acquire_mm(ctx);
-	if (unlikely(ret))
-		return ret;
-
-	ret = __io_sq_thread_acquire_files(ctx);
-	if (unlikely(ret))
-		return ret;
-
-	return 0;
-}
-
-static inline int io_sq_thread_acquire_mm_files(struct io_ring_ctx *ctx,
-						struct io_kiocb *req)
-{
-	if (!(ctx->flags & IORING_SETUP_SQPOLL))
-		return 0;
-	return __io_sq_thread_acquire_mm_files(ctx, req);
-}
-
-static void io_sq_thread_associate_blkcg(struct io_ring_ctx *ctx,
-					 struct cgroup_subsys_state **cur_css)
-
-{
-#ifdef CONFIG_BLK_CGROUP
-	/* puts the old one when swapping */
-	if (*cur_css != ctx->sqo_blkcg_css) {
-		kthread_associate_blkcg(ctx->sqo_blkcg_css);
-		*cur_css = ctx->sqo_blkcg_css;
-	}
-#endif
-}
-
-static void io_sq_thread_unassociate_blkcg(void)
-{
-#ifdef CONFIG_BLK_CGROUP
-	kthread_associate_blkcg(NULL);
-#endif
-}
-
 static inline void req_set_fail_links(struct io_kiocb *req)
 {
 	if ((req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) == REQ_F_LINK)
@@ -2124,15 +2011,11 @@ static void __io_req_task_submit(struct io_kiocb *req)
 
 	/* ctx stays valid until unlock, even if we drop all ours ctx->refs */
 	mutex_lock(&ctx->uring_lock);
-	if (!ctx->sqo_dead && !(current->flags & PF_EXITING) &&
-	    !io_sq_thread_acquire_mm_files(ctx, req))
+	if (!ctx->sqo_dead && !(current->flags & PF_EXITING))
 		__io_queue_sqe(req);
 	else
 		__io_req_task_cancel(req, -EFAULT);
 	mutex_unlock(&ctx->uring_lock);
-
-	if (ctx->flags & IORING_SETUP_SQPOLL)
-		io_sq_thread_drop_mm_files();
 }
 
 static void io_req_task_submit(struct callback_head *cb)
@@ -2596,7 +2479,6 @@ static bool io_rw_reissue(struct io_kiocb *req)
 {
 #ifdef CONFIG_BLOCK
 	umode_t mode = file_inode(req->file)->i_mode;
-	int ret;
 
 	if (!S_ISBLK(mode) && !S_ISREG(mode))
 		return false;
@@ -2605,9 +2487,7 @@ static bool io_rw_reissue(struct io_kiocb *req)
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	ret = io_sq_thread_acquire_mm_files(req->ctx, req);
-
-	if (!ret && io_resubmit_prep(req)) {
+	if (io_resubmit_prep(req)) {
 		refcount_inc(&req->refs);
 		io_queue_async_work(req);
 		return true;
@@ -6475,9 +6355,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
 
-	if (unlikely(io_sq_thread_acquire_mm_files(ctx, req)))
-		return -EFAULT;
-
 	if (unlikely(!io_check_restriction(ctx, req, sqe_flags)))
 		return -EACCES;
 
@@ -6793,41 +6670,81 @@ static void io_sqd_init_new(struct io_sq_data *sqd)
 	io_sqd_update_thread_idle(sqd);
 }
 
+static bool io_sq_thread_should_stop(struct io_sq_data *sqd)
+{
+	return test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+}
+
+static bool io_sq_thread_should_park(struct io_sq_data *sqd)
+{
+	return test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
+}
+
+static void io_sq_thread_parkme(struct io_sq_data *sqd)
+{
+	for (;;) {
+		/*
+		 * TASK_PARKED is a special state; we must serialize against
+		 * possible pending wakeups to avoid store-store collisions on
+		 * task->state.
+		 *
+		 * Such a collision might possibly result in the task state
+		 * changin from TASK_PARKED and us failing the
+		 * wait_task_inactive() in kthread_park().
+		 */
+		set_special_state(TASK_PARKED);
+		if (!test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state))
+			break;
+
+		/*
+		 * Thread is going to call schedule(), do not preempt it,
+		 * or the caller of kthread_park() may spend more time in
+		 * wait_task_inactive().
+		 */
+		preempt_disable();
+		complete(&sqd->completion);
+		schedule_preempt_disabled();
+		preempt_enable();
+	}
+	__set_current_state(TASK_RUNNING);
+}
+
 static int io_sq_thread(void *data)
 {
-	struct cgroup_subsys_state *cur_css = NULL;
-	struct files_struct *old_files = current->files;
-	struct nsproxy *old_nsproxy = current->nsproxy;
-	const struct cred *old_cred = NULL;
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
 	unsigned long timeout = 0;
+	char buf[TASK_COMM_LEN];
 	DEFINE_WAIT(wait);
 
-	task_lock(current);
-	current->files = NULL;
-	current->nsproxy = NULL;
-	task_unlock(current);
+	sprintf(buf, "iou-sqp-%d", sqd->task_pid);
+	set_task_comm(current, buf);
+	sqd->thread = current;
+	current->pf_io_worker = NULL;
+
+	if (sqd->sq_cpu != -1)
+		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
+	else
+		set_cpus_allowed_ptr(current, cpu_online_mask);
+	current->flags |= PF_NO_SETAFFINITY;
+
+	complete(&sqd->completion);
 
-	while (!kthread_should_stop()) {
+	while (!io_sq_thread_should_stop(sqd)) {
 		int ret;
 		bool cap_entries, sqt_spin, needs_sched;
 
 		/*
 		 * Any changes to the sqd lists are synchronized through the
-		 * kthread parking. This synchronizes the thread vs users,
+		 * thread parking. This synchronizes the thread vs users,
 		 * the users are synchronized on the sqd->ctx_lock.
 		 */
-		if (kthread_should_park()) {
-			kthread_parkme();
-			/*
-			 * When sq thread is unparked, in case the previous park operation
-			 * comes from io_put_sq_data(), which means that sq thread is going
-			 * to be stopped, so here needs to have a check.
-			 */
-			if (kthread_should_stop())
-				break;
+		if (io_sq_thread_should_park(sqd)) {
+			io_sq_thread_parkme(sqd);
+			continue;
 		}
+		if (fatal_signal_pending(current))
+			break;
 
 		if (unlikely(!list_empty(&sqd->ctx_new_list))) {
 			io_sqd_init_new(sqd);
@@ -6837,27 +6754,13 @@ static int io_sq_thread(void *data)
 		sqt_spin = false;
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
-			if (current->cred != ctx->creds) {
-				if (old_cred)
-					revert_creds(old_cred);
-				old_cred = override_creds(ctx->creds);
-			}
-			io_sq_thread_associate_blkcg(ctx, &cur_css);
-#ifdef CONFIG_AUDIT
-			current->loginuid = ctx->loginuid;
-			current->sessionid = ctx->sessionid;
-#endif
-
 			ret = __io_sq_thread(ctx, cap_entries);
 			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
-
-			io_sq_thread_drop_mm_files();
 		}
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
 			io_run_task_work();
-			io_sq_thread_drop_mm_files();
 			cond_resched();
 			if (sqt_spin)
 				timeout = jiffies + sqd->sq_thread_idle;
@@ -6878,7 +6781,7 @@ static int io_sq_thread(void *data)
 			}
 		}
 
-		if (needs_sched && !kthread_should_park()) {
+		if (needs_sched && !io_sq_thread_should_park(sqd)) {
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_set_wakeup_flag(ctx);
 
@@ -6891,22 +6794,14 @@ static int io_sq_thread(void *data)
 		timeout = jiffies + sqd->sq_thread_idle;
 	}
 
-	io_run_task_work();
-	io_sq_thread_drop_mm_files();
+	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+		io_uring_cancel_sqpoll(ctx);
 
-	if (cur_css)
-		io_sq_thread_unassociate_blkcg();
-	if (old_cred)
-		revert_creds(old_cred);
-
-	task_lock(current);
-	current->files = old_files;
-	current->nsproxy = old_nsproxy;
-	task_unlock(current);
-
-	kthread_parkme();
+	io_run_task_work();
 
-	return 0;
+	complete_all(&sqd->completion);
+	complete(&sqd->exited);
+	do_exit(0);
 }
 
 struct io_wait_queue {
@@ -7214,20 +7109,78 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	return 0;
 }
 
+static void io_sq_thread_unpark(struct io_sq_data *sqd)
+	__releases(&sqd->lock)
+{
+	if (!sqd->thread)
+		return;
+	if (sqd->thread == current)
+		return;
+	clear_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
+	wake_up_state(sqd->thread, TASK_PARKED);
+	mutex_unlock(&sqd->lock);
+}
+
+static void io_sq_thread_park(struct io_sq_data *sqd)
+	__acquires(&sqd->lock)
+{
+	if (!sqd->thread)
+		return;
+	if (sqd->thread == current)
+		return;
+	mutex_lock(&sqd->lock);
+	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
+	wake_up_process(sqd->thread);
+	wait_for_completion(&sqd->completion);
+}
+
+static void io_sq_thread_stop(struct io_sq_data *sqd)
+{
+	if (!sqd->thread)
+		return;
+
+	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+	WARN_ON_ONCE(test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state));
+	wake_up_process(sqd->thread);
+	wait_for_completion(&sqd->exited);
+}
+
 static void io_put_sq_data(struct io_sq_data *sqd)
 {
 	if (refcount_dec_and_test(&sqd->refs)) {
-		/*
-		 * The park is a bit of a work-around, without it we get
-		 * warning spews on shutdown with SQPOLL set and affinity
-		 * set to a single CPU.
-		 */
+		io_sq_thread_stop(sqd);
+		kfree(sqd);
+	}
+}
+
+static void io_sq_thread_finish(struct io_ring_ctx *ctx)
+{
+	struct io_sq_data *sqd = ctx->sq_data;
+
+	if (sqd) {
 		if (sqd->thread) {
-			kthread_park(sqd->thread);
-			kthread_stop(sqd->thread);
+			/*
+			 * We may arrive here from the error branch in
+			 * io_sq_offload_create() where the kthread is created
+			 * without being waked up, thus wake it up now to make
+			 * sure the wait will complete.
+			 */
+			wake_up_process(sqd->thread);
+			wait_for_completion(&ctx->sq_thread_comp);
+
+			io_sq_thread_park(sqd);
 		}
 
-		kfree(sqd);
+		mutex_lock(&sqd->ctx_lock);
+		list_del(&ctx->sqd_list);
+		io_sqd_update_thread_idle(sqd);
+		mutex_unlock(&sqd->ctx_lock);
+
+		if (sqd->thread)
+			io_sq_thread_unpark(sqd);
+
+		io_put_sq_data(sqd);
+		ctx->sq_data = NULL;
 	}
 }
 
@@ -7274,58 +7227,11 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
 	mutex_init(&sqd->ctx_lock);
 	mutex_init(&sqd->lock);
 	init_waitqueue_head(&sqd->wait);
+	init_completion(&sqd->completion);
+	init_completion(&sqd->exited);
 	return sqd;
 }
 
-static void io_sq_thread_unpark(struct io_sq_data *sqd)
-	__releases(&sqd->lock)
-{
-	if (!sqd->thread)
-		return;
-	kthread_unpark(sqd->thread);
-	mutex_unlock(&sqd->lock);
-}
-
-static void io_sq_thread_park(struct io_sq_data *sqd)
-	__acquires(&sqd->lock)
-{
-	if (!sqd->thread)
-		return;
-	mutex_lock(&sqd->lock);
-	kthread_park(sqd->thread);
-}
-
-static void io_sq_thread_stop(struct io_ring_ctx *ctx)
-{
-	struct io_sq_data *sqd = ctx->sq_data;
-
-	if (sqd) {
-		if (sqd->thread) {
-			/*
-			 * We may arrive here from the error branch in
-			 * io_sq_offload_create() where the kthread is created
-			 * without being waked up, thus wake it up now to make
-			 * sure the wait will complete.
-			 */
-			wake_up_process(sqd->thread);
-			wait_for_completion(&ctx->sq_thread_comp);
-
-			io_sq_thread_park(sqd);
-		}
-
-		mutex_lock(&sqd->ctx_lock);
-		list_del(&ctx->sqd_list);
-		io_sqd_update_thread_idle(sqd);
-		mutex_unlock(&sqd->ctx_lock);
-
-		if (sqd->thread)
-			io_sq_thread_unpark(sqd);
-
-		io_put_sq_data(sqd);
-		ctx->sq_data = NULL;
-	}
-}
-
 #if defined(CONFIG_UNIX)
 /*
  * Ensure the UNIX gc is aware of our file set, so we are certain that
@@ -8001,17 +7907,20 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			if (!cpu_online(cpu))
 				goto err;
 
-			sqd->thread = kthread_create_on_cpu(io_sq_thread, sqd,
-							cpu, "io_uring-sq");
+			sqd->sq_cpu = cpu;
 		} else {
-			sqd->thread = kthread_create(io_sq_thread, sqd,
-							"io_uring-sq");
+			sqd->sq_cpu = -1;
 		}
-		if (IS_ERR(sqd->thread)) {
-			ret = PTR_ERR(sqd->thread);
+
+		sqd->task_pid = current->pid;
+		current->flags |= PF_IO_WORKER;
+		ret = io_wq_fork_thread(io_sq_thread, sqd);
+		current->flags &= ~PF_IO_WORKER;
+		if (ret < 0) {
 			sqd->thread = NULL;
 			goto err;
 		}
+		wait_for_completion(&sqd->completion);
 		ret = io_uring_alloc_task_context(sqd->thread, ctx);
 		if (ret)
 			goto err;
@@ -8023,7 +7932,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 
 	return 0;
 err:
-	io_sq_thread_stop(ctx);
+	io_sq_thread_finish(ctx);
 	return ret;
 }
 
@@ -8498,21 +8407,14 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	mutex_lock(&ctx->uring_lock);
 	mutex_unlock(&ctx->uring_lock);
 
-	io_sq_thread_stop(ctx);
+	io_sq_thread_finish(ctx);
 	io_sqe_buffers_unregister(ctx);
 
-	if (ctx->sqo_task) {
-		put_task_struct(ctx->sqo_task);
-		ctx->sqo_task = NULL;
+	if (ctx->mm_account) {
 		mmdrop(ctx->mm_account);
 		ctx->mm_account = NULL;
 	}
 
-#ifdef CONFIG_BLK_CGROUP
-	if (ctx->sqo_blkcg_css)
-		css_put(ctx->sqo_blkcg_css);
-#endif
-
 	mutex_lock(&ctx->uring_lock);
 	io_sqe_files_unregister(ctx);
 	mutex_unlock(&ctx->uring_lock);
@@ -8532,7 +8434,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
-	put_cred(ctx->creds);
 	io_req_caches_free(ctx, NULL);
 	kfree(ctx->cancel_hash);
 	kfree(ctx);
@@ -9544,12 +9445,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ctx->compat = in_compat_syscall();
 	ctx->limit_mem = !capable(CAP_IPC_LOCK);
 	ctx->user = user;
-	ctx->creds = get_current_cred();
-#ifdef CONFIG_AUDIT
-	ctx->loginuid = current->loginuid;
-	ctx->sessionid = current->sessionid;
-#endif
-	ctx->sqo_task = get_task_struct(current);
+	ctx->sqo_task = current;
 
 	/*
 	 * This is just grabbed for accounting purposes. When a process exits,
@@ -9560,24 +9456,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	mmgrab(current->mm);
 	ctx->mm_account = current->mm;
 
-#ifdef CONFIG_BLK_CGROUP
-	/*
-	 * The sq thread will belong to the original cgroup it was inited in.
-	 * If the cgroup goes offline (e.g. disabling the io controller), then
-	 * issued bios will be associated with the closest cgroup later in the
-	 * block layer.
-	 */
-	rcu_read_lock();
-	ctx->sqo_blkcg_css = blkcg_css();
-	ret = css_tryget_online(ctx->sqo_blkcg_css);
-	rcu_read_unlock();
-	if (!ret) {
-		/* don't init against a dying cgroup, have the user try again */
-		ctx->sqo_blkcg_css = NULL;
-		ret = -ENODEV;
-		goto err;
-	}
-#endif
 	ret = io_allocate_scq_urings(ctx, p);
 	if (ret)
 		goto err;
-- 
2.30.0

