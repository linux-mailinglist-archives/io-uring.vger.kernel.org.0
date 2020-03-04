Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA2D179114
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 14:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388176AbgCDNPV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 08:15:21 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36068 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387992AbgCDNPV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 08:15:21 -0500
Received: by mail-wm1-f68.google.com with SMTP id g83so1834026wme.1;
        Wed, 04 Mar 2020 05:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=k4NsppHUexOnTxLarLxr/xLsc9hIMTHgPPSr8BCSfpY=;
        b=LuHDyfm6gdQcURKD2ay9V1I3LG75N8yu3592y3geIM6VGblTAMO2OZu9eRwGk/QmH5
         hx5C/I6uhyTtRyQ8/8gj1EIUobCoK/kzRaC/DTcla7t2OUJZx2hhWG7ngT4covPHsfyA
         ITLKrp+6l0u6Mdhtx+cH4oVd2VaVp1hzxeufBXypRxwxqKfmqRLhhjSC4E0PpdyzejE7
         edu3fm9lGhCKNNki+IMnJ0Ph5kY7Vfk/iAC+LzaF9zaGmTaNzeEPS5yRAdqIi0TpBt83
         TBbArwSEozqbd/EVId3eNxbzQrcCGA/SfVM6U683oyHhxJFDHFSqcvzdNxz48Iw4V6vQ
         Pbtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k4NsppHUexOnTxLarLxr/xLsc9hIMTHgPPSr8BCSfpY=;
        b=d3HYWFgYLpwTnBZbaJq3n5zTOwIyGS/YmPlk6CPW+kDiZUtdZS5Em22Si1g4vjLKro
         5VH51HZBjKUmrpeB6fRWmPzmjHOQcVp/9WDDg/AEfI6Z52R03cZCgFzmufGme5mCCPte
         aWGeSe7oqQrrbIWEQaoUUYW8OzkIeSwdi2rIvHvVnCLDV82plL6vpxyNFKZ1Tgr99+R2
         t0QLRVC0A4ZV2ZM+1RXxV2bI+yCXmrYrqG8ZmisWEjE4UtECjZ5DEtLw+/ZWo304p5iR
         kX6tW0vDqjoARuUnWBaf4+pWZLuayeZjSYIaqxiKpSzgU3j4JSOLrnYv2vPGUOXTerJ3
         QtIw==
X-Gm-Message-State: ANhLgQ3O2KZ05cQ5Y9gZSRxoLSaU3Z+Bd1Brn2JB4rsXAZnIVqjyRgn2
        dfm4HjtB89+MRntww7H0Wec=
X-Google-Smtp-Source: ADFU+vvLU1A7vTM4OWSEdDvTaSMPbkY3wsaLz472+i0PrkulMwJCaRYolRdFHs9hCBibWwmBCJl34g==
X-Received: by 2002:a1c:e0d6:: with SMTP id x205mr3439817wmg.29.1583327718452;
        Wed, 04 Mar 2020 05:15:18 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id c14sm24746746wro.36.2020.03.04.05.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 05:15:17 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] io_uring/io-wq: forward submission ref to async
Date:   Wed,  4 Mar 2020 16:14:12 +0300
Message-Id: <8990627d9815c320e2bd5e6181e5daf876c3dc47.1583314087.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583314087.git.asml.silence@gmail.com>
References: <cover.1583314087.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

First it changes io-wq interfaces. It replaces {get,put}_work() with
free_work(), which guaranteed to be called exactly once. It also enforces
free_work() callback to be non-NULL.

io_uring follows the changes and instead of putting a submission reference
in io_put_req_async_completion(), it will be done in io_free_work(). As
removes io_get_work() with corresponding refcount_inc(), the ref balance
is maintained.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    | 29 ++++++++++++++---------------
 fs/io-wq.h    |  6 ++----
 fs/io_uring.c | 31 +++++++++++--------------------
 3 files changed, 27 insertions(+), 39 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 82e76011d409..eda36f997dea 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -107,8 +107,7 @@ struct io_wq {
 	struct io_wqe **wqes;
 	unsigned long state;
 
-	get_work_fn *get_work;
-	put_work_fn *put_work;
+	free_work_fn *free_work;
 
 	struct task_struct *manager;
 	struct user_struct *user;
@@ -509,16 +508,11 @@ static void io_worker_handle_work(struct io_worker *worker)
 			if (test_bit(IO_WQ_BIT_CANCEL, &wq->state))
 				work->flags |= IO_WQ_WORK_CANCEL;
 
-			if (wq->get_work)
-				wq->get_work(work);
-
 			old_work = work;
 			work->func(&work);
 			work = (old_work == work) ? NULL : work;
 			io_assign_current_work(worker, work);
-
-			if (wq->put_work)
-				wq->put_work(old_work);
+			wq->free_work(old_work);
 
 			if (hash != -1U) {
 				spin_lock_irq(&wqe->lock);
@@ -749,14 +743,17 @@ static bool io_wq_can_queue(struct io_wqe *wqe, struct io_wqe_acct *acct,
 	return true;
 }
 
-static void io_run_cancel(struct io_wq_work *work)
+static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 {
+	struct io_wq *wq = wqe->wq;
+
 	do {
 		struct io_wq_work *old_work = work;
 
 		work->flags |= IO_WQ_WORK_CANCEL;
 		work->func(&work);
 		work = (work == old_work) ? NULL : work;
+		wq->free_work(old_work);
 	} while (work);
 }
 
@@ -773,7 +770,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	 * It's close enough to not be an issue, fork() has the same delay.
 	 */
 	if (unlikely(!io_wq_can_queue(wqe, acct, work))) {
-		io_run_cancel(work);
+		io_run_cancel(work, wqe);
 		return;
 	}
 
@@ -912,7 +909,7 @@ static enum io_wq_cancel io_wqe_cancel_cb_work(struct io_wqe *wqe,
 	spin_unlock_irqrestore(&wqe->lock, flags);
 
 	if (found) {
-		io_run_cancel(work);
+		io_run_cancel(work, wqe);
 		return IO_WQ_CANCEL_OK;
 	}
 
@@ -987,7 +984,7 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
 	spin_unlock_irqrestore(&wqe->lock, flags);
 
 	if (found) {
-		io_run_cancel(work);
+		io_run_cancel(work, wqe);
 		return IO_WQ_CANCEL_OK;
 	}
 
@@ -1064,6 +1061,9 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	int ret = -ENOMEM, node;
 	struct io_wq *wq;
 
+	if (WARN_ON_ONCE(!data->free_work))
+		return ERR_PTR(-EINVAL);
+
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
 	if (!wq)
 		return ERR_PTR(-ENOMEM);
@@ -1074,8 +1074,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	wq->get_work = data->get_work;
-	wq->put_work = data->put_work;
+	wq->free_work = data->free_work;
 
 	/* caller must already hold a reference to this */
 	wq->user = data->user;
@@ -1132,7 +1131,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 bool io_wq_get(struct io_wq *wq, struct io_wq_data *data)
 {
-	if (data->get_work != wq->get_work || data->put_work != wq->put_work)
+	if (data->free_work != wq->free_work)
 		return false;
 
 	return refcount_inc_not_zero(&wq->use_refs);
diff --git a/fs/io-wq.h b/fs/io-wq.h
index a0978d6958f0..2117b9a4f161 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -81,14 +81,12 @@ struct io_wq_work {
 		*(work) = (struct io_wq_work){ .func = _func };	\
 	} while (0)						\
 
-typedef void (get_work_fn)(struct io_wq_work *);
-typedef void (put_work_fn)(struct io_wq_work *);
+typedef void (free_work_fn)(struct io_wq_work *);
 
 struct io_wq_data {
 	struct user_struct *user;
 
-	get_work_fn *get_work;
-	put_work_fn *put_work;
+	free_work_fn *free_work;
 };
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 40ca9e6a5ace..0d6f4b3b8f13 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1558,8 +1558,8 @@ static void io_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
-static void io_put_req_async_completion(struct io_kiocb *req,
-					struct io_wq_work **workptr)
+static void io_steal_work(struct io_kiocb *req,
+			  struct io_wq_work **workptr)
 {
 	/*
 	 * It's in an io-wq worker, so there always should be at least
@@ -1569,7 +1569,6 @@ static void io_put_req_async_completion(struct io_kiocb *req,
 	 * It also means, that if the counter dropped to 1, then there is
 	 * no asynchronous users left, so it's safe to steal the next work.
 	 */
-	refcount_dec(&req->refs);
 	if (refcount_read(&req->refs) == 1) {
 		struct io_kiocb *nxt = NULL;
 
@@ -2578,7 +2577,7 @@ static bool io_req_cancelled(struct io_kiocb *req)
 	if (req->work.flags & IO_WQ_WORK_CANCEL) {
 		req_set_fail_links(req);
 		io_cqring_add_event(req, -ECANCELED);
-		io_double_put_req(req);
+		io_put_req(req);
 		return true;
 	}
 
@@ -2606,7 +2605,7 @@ static void io_fsync_finish(struct io_wq_work **workptr)
 	if (io_req_cancelled(req))
 		return;
 	__io_fsync(req);
-	io_put_req_async_completion(req, workptr);
+	io_steal_work(req, workptr);
 }
 
 static int io_fsync(struct io_kiocb *req, bool force_nonblock)
@@ -2639,7 +2638,7 @@ static void io_fallocate_finish(struct io_wq_work **workptr)
 	if (io_req_cancelled(req))
 		return;
 	__io_fallocate(req);
-	io_put_req_async_completion(req, workptr);
+	io_steal_work(req, workptr);
 }
 
 static int io_fallocate_prep(struct io_kiocb *req,
@@ -3006,7 +3005,7 @@ static void io_close_finish(struct io_wq_work **workptr)
 
 	/* not cancellable, don't do io_req_cancelled() */
 	__io_close_finish(req);
-	io_put_req_async_completion(req, workptr);
+	io_steal_work(req, workptr);
 }
 
 static int io_close(struct io_kiocb *req, bool force_nonblock)
@@ -3452,7 +3451,7 @@ static void io_accept_finish(struct io_wq_work **workptr)
 	if (io_req_cancelled(req))
 		return;
 	__io_accept(req, false);
-	io_put_req_async_completion(req, workptr);
+	io_steal_work(req, workptr);
 }
 #endif
 
@@ -4719,7 +4718,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 		io_put_req(req);
 	}
 
-	io_put_req_async_completion(req, workptr);
+	io_steal_work(req, workptr);
 }
 
 static int io_req_needs_file(struct io_kiocb *req, int fd)
@@ -6105,21 +6104,14 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 	return __io_sqe_files_update(ctx, &up, nr_args);
 }
 
-static void io_put_work(struct io_wq_work *work)
+static void io_free_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
-	/* Consider that io_put_req_async_completion() relies on this ref */
+	/* Consider that io_steal_work() relies on this ref */
 	io_put_req(req);
 }
 
-static void io_get_work(struct io_wq_work *work)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-
-	refcount_inc(&req->refs);
-}
-
 static int io_init_wq_offload(struct io_ring_ctx *ctx,
 			      struct io_uring_params *p)
 {
@@ -6130,8 +6122,7 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
 	int ret = 0;
 
 	data.user = ctx->user;
-	data.get_work = io_get_work;
-	data.put_work = io_put_work;
+	data.free_work = io_free_work;
 
 	if (!(p->flags & IORING_SETUP_ATTACH_WQ)) {
 		/* Do QD, or 4 * CPUS, whatever is smallest */
-- 
2.24.0

