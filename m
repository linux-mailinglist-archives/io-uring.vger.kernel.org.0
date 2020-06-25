Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9429D20A4F8
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 20:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404398AbgFYS1i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 14:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404116AbgFYS1h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 14:27:37 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82799C08C5C1
        for <io-uring@vger.kernel.org>; Thu, 25 Jun 2020 11:27:37 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id s14so3147204plq.6
        for <io-uring@vger.kernel.org>; Thu, 25 Jun 2020 11:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=K5tvedByjgBGkRuu48DZn/MrJTh8+Qv5JK0BMe2eDH0=;
        b=LhIrpsyoXGscTo1TV0SYO5MjhOV1SYA6qUS5uN4BJlsF7XtQQljSc+HD4ASwajltOg
         nbDWDAsCOYcOVpVzFaqtBwxd927yWCldWCz/CvVi5psaDQFqLKRZnLuD3TAm9nLf9ti+
         ++KfuD/q8D+JX6IDPbzXlb1shN+QVvzufnaHkayBnNQ15aiUFuwbv8poYsAkucu31Gst
         1QJOhDQWcOguUH//ZO5eHuYUPInitSLsokHP915hx2IzSyFjN4XEbr5WqkyvyJKIL4a9
         Duo8qzPM5suwlq+Ftbd8p6AudL3noMzA0kdAabv2JZmXqbVjC/TS0RAA4upPIhicWVBs
         c06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=K5tvedByjgBGkRuu48DZn/MrJTh8+Qv5JK0BMe2eDH0=;
        b=clWmDRhO1y0nYkiNOGQQgtePkD8cZEf/+nM6RWSnraVgnsj+sb7k4bfqE6phdchkne
         0uXXRHoThHyrNzTF1zO8HDg6ZdRU6deT4be2z8U2DxNAVkaow5lYJTHntSr0CyHfJ9ps
         uXhWwZ2W1V7o/ovUw6dV8BnRXCV8bqH0bCladbROyE5g2hRNbn2O0nF4aatu3I85EFLd
         re7XvYwzddzM98mLg8zy7GifAuxoBXS2gbkMI4Qx74w53yCYtUH4u7oGkNJAoaUcwxec
         JNALnBOhE7mcQgKcDk4mDs286bR7dgvOwXJU8mJO14naFhjBpvDwxyRQFF0eObzSMQEp
         axAg==
X-Gm-Message-State: AOAM533/Au6TUkM40dWExk+Psn0NkM6L1/9/A6ybQFtrxiQp01iXc8Qf
        fFuoc42azboOiQtdl+C+/IQZ4X4jbo5ONg==
X-Google-Smtp-Source: ABdhPJz1ZE4JlWVBZmjLyYVRX8ZiT/50uIx5v4a/s/MvPcdbPWlhCYeDOv8dsLETHMfur1X1F1OlOQ==
X-Received: by 2002:a17:90a:acf:: with SMTP id r15mr4880338pje.171.1593109656506;
        Thu, 25 Jun 2020 11:27:36 -0700 (PDT)
Received: from [192.168.1.56] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u20sm25383790pfk.91.2020.06.25.11.27.35
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 11:27:35 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: use task_work for links if possible
Message-ID: <421c3b22-2619-a9a2-a76e-ed8251c7264c@kernel.dk>
Date:   Thu, 25 Jun 2020 12:27:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently links are always done in an async fashion, unless we
catch them inline after we successfully complete a request without
having to resort to blocking. This isn't necessarily the most efficient
approach, it'd be more ideal if we could just use the task_work handling
for this.

Outside of saving an async jump, we can also do less prep work for
these kinds of requests.

Running dependent links from the task_work handler yields some nice
performance benefits. As an example, examples/link-cp from the liburing
repository uses read+write links to implement a copy operation. Without
this patch, the a cache fold 4G file read from a VM runs in about
3 seconds:

$ time examples/link-cp /data/file /dev/null

real	0m2.986s
user	0m0.051s
sys	0m2.843s

and a subsequent cache hot run looks like this:

$ time examples/link-cp /data/file /dev/null

real	0m0.898s
user	0m0.069s
sys	0m0.797s

With this patch in place, the cold case takes about 2.4 seconds:

$ time examples/link-cp /data/file /dev/null

real	0m2.400s
user	0m0.020s
sys	0m2.366s

and the cache hot case looks like this:

$ time examples/link-cp /data/file /dev/null

real	0m0.676s
user	0m0.010s
sys	0m0.665s

As expected, the (mostly) cache hot case yields the biggest improvement,
running about 25% faster with this change, while the cache cold case
yields about a 20% increase in performance. Outside of the performance
increase, we're using less CPU as well, as we're not using the async
offload threads at all for this anymore.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0bba12e4e559..389274a078c8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -898,6 +898,7 @@ enum io_mem_account {
 static void io_wq_submit_work(struct io_wq_work **workptr);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
+static void io_double_put_req(struct io_kiocb *req);
 static void __io_double_put_req(struct io_kiocb *req);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
@@ -951,6 +952,34 @@ static void __io_put_req_task(struct io_kiocb *req)
 		put_task_struct(req->task);
 }
 
+static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
+{
+	struct mm_struct *mm = current->mm;
+
+	if (mm) {
+		kthread_unuse_mm(mm);
+		mmput(mm);
+	}
+}
+
+static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
+				   struct io_kiocb *req)
+{
+	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
+		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
+			return -EFAULT;
+		kthread_use_mm(ctx->sqo_mm);
+	}
+
+	return 0;
+}
+
+static inline void req_set_fail_links(struct io_kiocb *req)
+{
+	if ((req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) == REQ_F_LINK)
+		req->flags |= REQ_F_FAIL_LINK;
+}
+
 static void io_file_put_work(struct work_struct *work);
 
 /*
@@ -1664,6 +1693,64 @@ static void io_req_find_next(struct io_kiocb *req, struct io_kiocb **nxt)
 	}
 }
 
+static void __io_req_task_cancel(struct io_kiocb *req, int error)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	spin_lock_irq(&ctx->completion_lock);
+	io_cqring_fill_event(req, error);
+	io_commit_cqring(ctx);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
+	req_set_fail_links(req);
+	io_double_put_req(req);
+}
+
+static void io_req_task_cancel(struct callback_head *cb)
+{
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+
+	__io_req_task_cancel(req, -ECANCELED);
+}
+
+static void __io_req_task_submit(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	__set_current_state(TASK_RUNNING);
+	if (!io_sq_thread_acquire_mm(ctx, req)) {
+		mutex_lock(&ctx->uring_lock);
+		__io_queue_sqe(req, NULL, NULL);
+		mutex_unlock(&ctx->uring_lock);
+	} else {
+		__io_req_task_cancel(req, -EFAULT);
+	}
+}
+
+static void io_req_task_submit(struct callback_head *cb)
+{
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+
+	__io_req_task_submit(req);
+}
+
+static void io_req_task_queue(struct io_kiocb *req)
+{
+	struct task_struct *tsk = req->task;
+	int ret;
+
+	init_task_work(&req->task_work, io_req_task_submit);
+
+	ret = task_work_add(tsk, &req->task_work, true);
+	if (unlikely(ret)) {
+		init_task_work(&req->task_work, io_req_task_cancel);
+		tsk = io_wq_get_task(req->ctx->io_wq);
+		task_work_add(tsk, &req->task_work, true);
+	}
+	wake_up_process(tsk);
+}
+
 static void io_free_req(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = NULL;
@@ -1671,8 +1758,12 @@ static void io_free_req(struct io_kiocb *req)
 	io_req_find_next(req, &nxt);
 	__io_free_req(req);
 
-	if (nxt)
-		io_queue_async_work(nxt);
+	if (nxt) {
+		if (nxt->flags & REQ_F_WORK_INITIALIZED)
+			io_queue_async_work(nxt);
+		else
+			io_req_task_queue(nxt);
+	}
 }
 
 static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
@@ -2013,12 +2104,6 @@ static void kiocb_end_write(struct io_kiocb *req)
 	file_end_write(req->file);
 }
 
-static inline void req_set_fail_links(struct io_kiocb *req)
-{
-	if ((req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) == REQ_F_LINK)
-		req->flags |= REQ_F_FAIL_LINK;
-}
-
 static void io_complete_rw_common(struct kiocb *kiocb, long res,
 				  struct io_comp_state *cs)
 {
@@ -2035,35 +2120,6 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res,
 	__io_req_complete(req, res, cflags, cs);
 }
 
-static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
-{
-	struct mm_struct *mm = current->mm;
-
-	if (mm) {
-		kthread_unuse_mm(mm);
-		mmput(mm);
-	}
-}
-
-static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
-{
-	if (!current->mm) {
-		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
-			return -EFAULT;
-		kthread_use_mm(ctx->sqo_mm);
-	}
-
-	return 0;
-}
-
-static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
-				   struct io_kiocb *req)
-{
-	if (!io_op_defs[req->opcode].needs_mm)
-		return 0;
-	return __io_sq_thread_acquire_mm(ctx);
-}
-
 #ifdef CONFIG_BLOCK
 static bool io_resubmit_prep(struct io_kiocb *req, int error)
 {
@@ -2811,20 +2867,6 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static void __io_async_buf_error(struct io_kiocb *req, int error)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	spin_lock_irq(&ctx->completion_lock);
-	io_cqring_fill_event(req, error);
-	io_commit_cqring(ctx);
-	spin_unlock_irq(&ctx->completion_lock);
-
-	io_cqring_ev_posted(ctx);
-	req_set_fail_links(req);
-	io_double_put_req(req);
-}
-
 static void io_async_buf_cancel(struct callback_head *cb)
 {
 	struct io_async_rw *rw;
@@ -2832,27 +2874,18 @@ static void io_async_buf_cancel(struct callback_head *cb)
 
 	rw = container_of(cb, struct io_async_rw, task_work);
 	req = rw->wpq.wait.private;
-	__io_async_buf_error(req, -ECANCELED);
+	__io_req_task_cancel(req, -ECANCELED);
 }
 
 static void io_async_buf_retry(struct callback_head *cb)
 {
 	struct io_async_rw *rw;
-	struct io_ring_ctx *ctx;
 	struct io_kiocb *req;
 
 	rw = container_of(cb, struct io_async_rw, task_work);
 	req = rw->wpq.wait.private;
-	ctx = req->ctx;
 
-	__set_current_state(TASK_RUNNING);
-	if (!__io_sq_thread_acquire_mm(ctx)) {
-		mutex_lock(&ctx->uring_lock);
-		__io_queue_sqe(req, NULL, NULL);
-		mutex_unlock(&ctx->uring_lock);
-	} else {
-		__io_async_buf_error(req, -EFAULT);
-	}
+	__io_req_task_submit(req);
 }
 
 static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
@@ -5218,22 +5251,24 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 }
 
 static int io_req_defer_prep(struct io_kiocb *req,
-			     const struct io_uring_sqe *sqe)
+			     const struct io_uring_sqe *sqe, bool for_async)
 {
 	ssize_t ret = 0;
 
 	if (!sqe)
 		return 0;
 
-	io_req_init_async(req);
+	if (for_async) {
+		io_req_init_async(req);
 
-	if (io_op_defs[req->opcode].file_table) {
-		ret = io_grab_files(req);
-		if (unlikely(ret))
-			return ret;
-	}
+		if (io_op_defs[req->opcode].file_table) {
+			ret = io_grab_files(req);
+			if (unlikely(ret))
+				return ret;
+		}
 
-	io_req_work_grab_env(req, &io_op_defs[req->opcode]);
+		io_req_work_grab_env(req, &io_op_defs[req->opcode]);
+	}
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
@@ -5347,7 +5382,7 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!req->io) {
 		if (io_alloc_async_ctx(req))
 			return -EAGAIN;
-		ret = io_req_defer_prep(req, sqe);
+		ret = io_req_defer_prep(req, sqe, true);
 		if (ret < 0)
 			return ret;
 	}
@@ -5966,7 +6001,7 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			ret = -EAGAIN;
 			if (io_alloc_async_ctx(req))
 				goto fail_req;
-			ret = io_req_defer_prep(req, sqe);
+			ret = io_req_defer_prep(req, sqe, true);
 			if (unlikely(ret < 0))
 				goto fail_req;
 		}
@@ -6022,13 +6057,14 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		if (io_alloc_async_ctx(req))
 			return -EAGAIN;
 
-		ret = io_req_defer_prep(req, sqe);
+		ret = io_req_defer_prep(req, sqe, false);
 		if (ret) {
 			/* fail even hard links since we don't submit */
 			head->flags |= REQ_F_FAIL_LINK;
 			return ret;
 		}
 		trace_io_uring_link(ctx, req, head);
+		io_get_req_task(req);
 		list_add_tail(&req->link_list, &head->link_list);
 
 		/* last request of a link, enqueue the link */
@@ -6048,7 +6084,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (io_alloc_async_ctx(req))
 				return -EAGAIN;
 
-			ret = io_req_defer_prep(req, sqe);
+			ret = io_req_defer_prep(req, sqe, true);
 			if (ret)
 				req->flags |= REQ_F_FAIL_LINK;
 			*link = req;

-- 
Jens Axboe

