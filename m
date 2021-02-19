Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DE631FD9C
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhBSRKu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhBSRKt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:10:49 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7861C061793
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:28 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id u8so6314459ior.13
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9uy1WFIpKgahD2nObFVJWD6TJyJxvxIkT7tmPaSbsGo=;
        b=nugdALp5MEIIg3W9MMMYQ6OPZQLqfp3qhHMzacpTZ4a9KwGs4DLGBqb7UxmaA2JC1u
         iM5bk5aoniVGO5NnhczebJ/zdbxvMpFU0BOE69ycTGyqu53IxuQAJxLEIwEARdv8iu3e
         xhp7u3yLCuqI4h04zlApx884Am1liIYZ/DW4w+njAnaJbszafvbmo2Zx/yiGWauxOEqI
         BsygRSGrJ1qg818SpLxA6D1s0UhuBZaRwSW0VZ7xpcsshH5BghxY/kTxIPYLwYts3fW/
         5jdrHwW6lC1b25lpfzNxE3qUczmNJY+TTQleJ3yqz4U/XtrKe4p2KV14NXpTNGWXj3gw
         0tFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9uy1WFIpKgahD2nObFVJWD6TJyJxvxIkT7tmPaSbsGo=;
        b=YCUWdZakCgqoAePygh0VcTdbTi46CsFq6zoMpnC8HMYRKtH9E2Jf1U5cavrqLGDXoe
         aUzYhk2O9rUGqnnfHg7ORZOAsegEgZ9n7N+Z5/GOV0xbXJj2zsyjrncM+7g7m6CyRBTk
         r+ACmZ+j+f0pHwItYWNvh06KbSsSE5XjwlmuUTXv7SjPCKgN0MOYy2ylwLu4tEGW1ggd
         v4syiWja/kPQOk40o4F3+T5xcgiHG9rJizI+QqYGwGqi9P37AxsNlMVSEZ/6TO3piXaF
         Sudkm8nXAGEtthqN21Mu7k5EmdMmk6qvLGu1asZ/n/CpMnvetIitQW7k4WZ+ydSOlhzH
         eQ5Q==
X-Gm-Message-State: AOAM531Jr0/kTFt5r8vyTqpj5Y+P650SgN47Vnk8BaMW5GiYw9NQKMwc
        O1KJNbBFqApqgxk3Sq9biWgkNz/YjAkUu1ET
X-Google-Smtp-Source: ABdhPJxSW1zdrR+gUWMzaLIU5CUDaTkEYnZPUzZoRwIsOIsytZ9cXswbDTu/NIUdPxAt97lEHmt2vA==
X-Received: by 2002:a02:714f:: with SMTP id n15mr8938331jaf.6.1613754627535;
        Fri, 19 Feb 2021 09:10:27 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:26 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/18] io_uring: remove io_identity
Date:   Fri, 19 Feb 2021 10:10:04 -0700
Message-Id: <20210219171010.281878-13-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We are no longer grabbing state, so no need to maintain an IO identity
that we COW if there are changes.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c               |  26 ++++++++++
 fs/io-wq.h               |   2 +-
 fs/io_uring.c            | 104 ++++++++++-----------------------------
 include/linux/io_uring.h |  19 -------
 4 files changed, 52 insertions(+), 99 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 41042119bf0f..acc67ed3a52c 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -53,6 +53,9 @@ struct io_worker {
 	struct io_wq_work *cur_work;
 	spinlock_t lock;
 
+	const struct cred *cur_creds;
+	const struct cred *saved_creds;
+
 	struct rcu_head rcu;
 };
 
@@ -171,6 +174,11 @@ static void io_worker_exit(struct io_worker *worker)
 	worker->flags = 0;
 	preempt_enable();
 
+	if (worker->saved_creds) {
+		revert_creds(worker->saved_creds);
+		worker->cur_creds = worker->saved_creds = NULL;
+	}
+
 	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
@@ -312,6 +320,10 @@ static void __io_worker_idle(struct io_wqe *wqe, struct io_worker *worker)
 		worker->flags |= IO_WORKER_F_FREE;
 		hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
 	}
+	if (worker->saved_creds) {
+		revert_creds(worker->saved_creds);
+		worker->cur_creds = worker->saved_creds = NULL;
+	}
 }
 
 static inline unsigned int io_get_work_hash(struct io_wq_work *work)
@@ -359,6 +371,18 @@ static void io_flush_signals(void)
 	}
 }
 
+static void io_wq_switch_creds(struct io_worker *worker,
+			       struct io_wq_work *work)
+{
+	const struct cred *old_creds = override_creds(work->creds);
+
+	worker->cur_creds = work->creds;
+	if (worker->saved_creds)
+		put_cred(old_creds); /* creds set by previous switch */
+	else
+		worker->saved_creds = old_creds;
+}
+
 static void io_assign_current_work(struct io_worker *worker,
 				   struct io_wq_work *work)
 {
@@ -407,6 +431,8 @@ static void io_worker_handle_work(struct io_worker *worker)
 			unsigned int hash = io_get_work_hash(work);
 
 			next_hashed = wq_next_work(work);
+			if (work->creds && worker->cur_creds != work->creds)
+				io_wq_switch_creds(worker, work);
 			wq->do_work(work);
 			io_assign_current_work(worker, NULL);
 
diff --git a/fs/io-wq.h b/fs/io-wq.h
index ab8029bf77b8..c187d54dc5cd 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -78,7 +78,7 @@ static inline void wq_list_del(struct io_wq_work_list *list,
 
 struct io_wq_work {
 	struct io_wq_work_node list;
-	struct io_identity *identity;
+	const struct cred *creds;
 	unsigned flags;
 };
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 872d2f1c6ea5..980c62762359 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1086,7 +1086,7 @@ static bool io_match_task(struct io_kiocb *head,
 			continue;
 		if (req->file && req->file->f_op == &io_uring_fops)
 			return true;
-		if (req->work.identity->files == files)
+		if (req->task->files == files)
 			return true;
 	}
 	return false;
@@ -1210,31 +1210,6 @@ static inline void req_set_fail_links(struct io_kiocb *req)
 		req->flags |= REQ_F_FAIL_LINK;
 }
 
-/*
- * None of these are dereferenced, they are simply used to check if any of
- * them have changed. If we're under current and check they are still the
- * same, we're fine to grab references to them for actual out-of-line use.
- */
-static void io_init_identity(struct io_identity *id)
-{
-	id->files = current->files;
-	id->mm = current->mm;
-#ifdef CONFIG_BLK_CGROUP
-	rcu_read_lock();
-	id->blkcg_css = blkcg_css();
-	rcu_read_unlock();
-#endif
-	id->creds = current_cred();
-	id->nsproxy = current->nsproxy;
-	id->fs = current->fs;
-	id->fsize = rlimit(RLIMIT_FSIZE);
-#ifdef CONFIG_AUDIT
-	id->loginuid = current->loginuid;
-	id->sessionid = current->sessionid;
-#endif
-	refcount_set(&id->count, 1);
-}
-
 static inline void __io_req_init_async(struct io_kiocb *req)
 {
 	memset(&req->work, 0, sizeof(req->work));
@@ -1247,17 +1222,10 @@ static inline void __io_req_init_async(struct io_kiocb *req)
  */
 static inline void io_req_init_async(struct io_kiocb *req)
 {
-	struct io_uring_task *tctx = current->io_uring;
-
 	if (req->flags & REQ_F_WORK_INITIALIZED)
 		return;
 
 	__io_req_init_async(req);
-
-	/* Grab a ref if this isn't our static identity */
-	req->work.identity = tctx->identity;
-	if (tctx->identity != &tctx->__identity)
-		refcount_inc(&req->work.identity->count);
 }
 
 static void io_ring_ctx_ref_free(struct percpu_ref *ref)
@@ -1342,19 +1310,15 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 	return false;
 }
 
-static void io_put_identity(struct io_uring_task *tctx, struct io_kiocb *req)
-{
-	if (req->work.identity == &tctx->__identity)
-		return;
-	if (refcount_dec_and_test(&req->work.identity->count))
-		kfree(req->work.identity);
-}
-
 static void io_req_clean_work(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_WORK_INITIALIZED))
 		return;
 
+	if (req->work.creds) {
+		put_cred(req->work.creds);
+		req->work.creds = NULL;
+	}
 	if (req->flags & REQ_F_INFLIGHT) {
 		struct io_ring_ctx *ctx = req->ctx;
 		struct io_uring_task *tctx = req->task->io_uring;
@@ -1369,7 +1333,6 @@ static void io_req_clean_work(struct io_kiocb *req)
 	}
 
 	req->flags &= ~REQ_F_WORK_INITIALIZED;
-	io_put_identity(req->task->io_uring, req);
 }
 
 static void io_req_track_inflight(struct io_kiocb *req)
@@ -1403,6 +1366,8 @@ static void io_prep_async_work(struct io_kiocb *req)
 		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
+	if (!req->work.creds)
+		req->work.creds = get_current_cred();
 }
 
 static void io_prep_async_link(struct io_kiocb *req)
@@ -6392,9 +6357,9 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	const struct cred *old_creds = NULL;
 	int ret;
 
-	if ((req->flags & REQ_F_WORK_INITIALIZED) &&
-	    req->work.identity->creds != current_cred())
-		old_creds = override_creds(req->work.identity->creds);
+	if ((req->flags & REQ_F_WORK_INITIALIZED) && req->work.creds &&
+	    req->work.creds != current_cred())
+		old_creds = override_creds(req->work.creds);
 
 	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
 
@@ -6522,16 +6487,11 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	id = READ_ONCE(sqe->personality);
 	if (id) {
-		struct io_identity *iod;
-
-		iod = idr_find(&ctx->personality_idr, id);
-		if (unlikely(!iod))
-			return -EINVAL;
-		refcount_inc(&iod->count);
-
 		__io_req_init_async(req);
-		get_cred(iod->creds);
-		req->work.identity = iod;
+		req->work.creds = idr_find(&ctx->personality_idr, id);
+		if (unlikely(!req->work.creds))
+			return -EINVAL;
+		get_cred(req->work.creds);
 	}
 
 	state = &ctx->submit_state;
@@ -7968,8 +7928,6 @@ static int io_uring_alloc_task_context(struct task_struct *task,
 	tctx->last = NULL;
 	atomic_set(&tctx->in_idle, 0);
 	tctx->sqpoll = false;
-	io_init_identity(&tctx->__identity);
-	tctx->identity = &tctx->__identity;
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
@@ -7983,9 +7941,6 @@ void __io_uring_free(struct task_struct *tsk)
 	struct io_uring_task *tctx = tsk->io_uring;
 
 	WARN_ON_ONCE(!xa_empty(&tctx->xa));
-	WARN_ON_ONCE(refcount_read(&tctx->identity->count) != 1);
-	if (tctx->identity != &tctx->__identity)
-		kfree(tctx->identity);
 	percpu_counter_destroy(&tctx->inflight);
 	kfree(tctx);
 	tsk->io_uring = NULL;
@@ -8625,13 +8580,11 @@ static int io_uring_fasync(int fd, struct file *file, int on)
 
 static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 {
-	struct io_identity *iod;
+	const struct cred *creds;
 
-	iod = idr_remove(&ctx->personality_idr, id);
-	if (iod) {
-		put_cred(iod->creds);
-		if (refcount_dec_and_test(&iod->count))
-			kfree(iod);
+	creds = idr_remove(&ctx->personality_idr, id);
+	if (creds) {
+		put_cred(creds);
 		return 0;
 	}
 
@@ -9333,8 +9286,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 #ifdef CONFIG_PROC_FS
 static int io_uring_show_cred(int id, void *p, void *data)
 {
-	struct io_identity *iod = p;
-	const struct cred *cred = iod->creds;
+	const struct cred *cred = p;
 	struct seq_file *m = data;
 	struct user_namespace *uns = seq_user_ns(m);
 	struct group_info *gi;
@@ -9765,21 +9717,15 @@ static int io_probe(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 
 static int io_register_personality(struct io_ring_ctx *ctx)
 {
-	struct io_identity *id;
+	const struct cred *creds;
 	int ret;
 
-	id = kmalloc(sizeof(*id), GFP_KERNEL);
-	if (unlikely(!id))
-		return -ENOMEM;
-
-	io_init_identity(id);
-	id->creds = get_current_cred();
+	creds = get_current_cred();
 
-	ret = idr_alloc_cyclic(&ctx->personality_idr, id, 1, USHRT_MAX, GFP_KERNEL);
-	if (ret < 0) {
-		put_cred(id->creds);
-		kfree(id);
-	}
+	ret = idr_alloc_cyclic(&ctx->personality_idr, (void *) creds, 1,
+				USHRT_MAX, GFP_KERNEL);
+	if (ret < 0)
+		put_cred(creds);
 	return ret;
 }
 
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 0e95398998b6..c48fcbdc2ea8 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -5,23 +5,6 @@
 #include <linux/sched.h>
 #include <linux/xarray.h>
 
-struct io_identity {
-	struct files_struct		*files;
-	struct mm_struct		*mm;
-#ifdef CONFIG_BLK_CGROUP
-	struct cgroup_subsys_state	*blkcg_css;
-#endif
-	const struct cred		*creds;
-	struct nsproxy			*nsproxy;
-	struct fs_struct		*fs;
-	unsigned long			fsize;
-#ifdef CONFIG_AUDIT
-	kuid_t				loginuid;
-	unsigned int			sessionid;
-#endif
-	refcount_t			count;
-};
-
 struct io_wq_work_node {
 	struct io_wq_work_node *next;
 };
@@ -38,8 +21,6 @@ struct io_uring_task {
 	struct file		*last;
 	void			*io_wq;
 	struct percpu_counter	inflight;
-	struct io_identity	__identity;
-	struct io_identity	*identity;
 	atomic_t		in_idle;
 	bool			sqpoll;
 
-- 
2.30.0

