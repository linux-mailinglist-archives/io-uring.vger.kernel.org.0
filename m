Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4FCC174E4B
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2020 17:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgCAQTv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 11:19:51 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50330 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgCAQTt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 11:19:49 -0500
Received: by mail-wm1-f66.google.com with SMTP id a5so8555820wmb.0;
        Sun, 01 Mar 2020 08:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gy+VQ//fVN6pH1srAhqAnUVt8Kt1VEumVBPqQb4zp78=;
        b=YoQS23a4rDp2Y8MWTRhtt23qrG7IJ/A21ly18lOYHyuLhZOO+EPdmN8W/S/t0K4icP
         OKJjuHzPyJ6K4xXJOiEGSPq61tJD5txQtE/Ld/B3R8avVi8wkl/s97pFpi62IqXbnMgA
         VUWJzZO+zpFfUBnCXPFiAdBTAdSq79JAouFYkF7XzOrk+A0db97qobv2jPgYZWSHMcny
         xBhfbyYfkHasGC4bRdLRH3iaXtr4dTwGGUKOD5bzqpcc8SAesomgYBwMGAnJqhpW912n
         tkedz2aK+XcFA94xdnMHjQPCX+zsYv/GKyn2yz01OfTNQrASHul+3xef1upNuUXlkoQK
         TeYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gy+VQ//fVN6pH1srAhqAnUVt8Kt1VEumVBPqQb4zp78=;
        b=QQNP9AqeU58yX+QfHhSgmXX9bSxWtKMj6V/NMBVUUAGtg9HnUGfWrY8106Q44eIkRW
         Rqin6dZsI99uvOJVZO+og2UFrU4DT0jvqOhNMosrSSQuGe+cc8CATxufs25wriEvAzjk
         5ltdl99Ox05zzr2BzJr46pbrLW5PtJ2uMMW5KuJOt48co49t6OvueM+6+LmSlmkGo3jR
         chBOEJBLhnLwLME6Sr5VMYIAKwMW/E9SXeicinGRESplcn7GLWmFB+dUzezuYuV+/7XQ
         J6bA1a5+aimQNXF0ikFmvPvJfVA8Lafm/AKg1YG9+vfBHmBSrCgMCC4+KfY15dIV3vJ9
         LzzQ==
X-Gm-Message-State: APjAAAWv86+xvgVTQ523ELmU3trMh9dz0+t/2D7HwYeoIL5dv47ei/PR
        IiOSyhFe00hQ5hkCu2HNQN8=
X-Google-Smtp-Source: APXvYqwmxZV88W/Dit77zfp3G+VomT0a5EIKicQezyGLICWBDYhi4tICThzqzeTaMTFJZTeZzLmPJA==
X-Received: by 2002:a05:600c:285:: with SMTP id 5mr14834424wmk.120.1583079587316;
        Sun, 01 Mar 2020 08:19:47 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id q9sm15864741wrn.8.2020.03.01.08.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 08:19:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] io_uring: pass submission ref to async
Date:   Sun,  1 Mar 2020 19:18:26 +0300
Message-Id: <29efa25e63ea86b9b038fff202a5f7423b5482c8.1583078091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583078091.git.asml.silence@gmail.com>
References: <cover.1583078091.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currenlty, every async work handler accepts a submission reference,
which it should put. Also there is a reference grabbed in io_get_work()
and dropped in io_put_work(). This patch merge them together.

- So, ownership of the submission reference passed to io-wq, and it'll
be put in io_put_work().
- io_get_put() doesn't take a ref now and so deleted.
- async handlers don't put the submission ref anymore.
- make cancellation bits of io-wq to call {get,put}_work() handlers

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    | 17 +++++++++++++----
 fs/io_uring.c | 32 +++++++++++++-------------------
 2 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index f9b18c16ebd8..686ad043c6ac 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -751,14 +751,23 @@ static bool io_wq_can_queue(struct io_wqe *wqe, struct io_wqe_acct *acct,
 	return true;
 }
 
-static void io_run_cancel(struct io_wq_work *work)
+static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 {
+	struct io_wq *wq = wqe->wq;
+
 	do {
 		struct io_wq_work *old_work = work;
+		bool is_internal = work->flags & IO_WQ_WORK_INTERNAL;
+
+		if (wq->get_work && !is_internal)
+			wq->get_work(work);
 
 		work->flags |= IO_WQ_WORK_CANCEL;
 		work->func(&work);
 		work = (work == old_work) ? NULL : work;
+
+		if (wq->put_work && !is_internal)
+			wq->put_work(old_work);
 	} while (work);
 }
 
@@ -775,7 +784,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	 * It's close enough to not be an issue, fork() has the same delay.
 	 */
 	if (unlikely(!io_wq_can_queue(wqe, acct, work))) {
-		io_run_cancel(work);
+		io_run_cancel(work, wqe);
 		return;
 	}
 
@@ -914,7 +923,7 @@ static enum io_wq_cancel io_wqe_cancel_cb_work(struct io_wqe *wqe,
 	spin_unlock_irqrestore(&wqe->lock, flags);
 
 	if (found) {
-		io_run_cancel(work);
+		io_run_cancel(work, wqe);
 		return IO_WQ_CANCEL_OK;
 	}
 
@@ -989,7 +998,7 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
 	spin_unlock_irqrestore(&wqe->lock, flags);
 
 	if (found) {
-		io_run_cancel(work);
+		io_run_cancel(work, wqe);
 		return IO_WQ_CANCEL_OK;
 	}
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index d456b0ff6835..c6845a1e5aaa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1556,12 +1556,13 @@ static struct io_kiocb *io_put_req_submission(struct io_kiocb *req)
 	return nxt;
 }
 
-static void io_put_req_async_submission(struct io_kiocb *req,
-					struct io_wq_work **workptr)
+static void io_steal_work(struct io_kiocb *req,
+			  struct io_wq_work **workptr)
 {
-	static struct io_kiocb *nxt;
+	struct io_kiocb *nxt = NULL;
 
-	nxt = io_put_req_submission(req);
+	if (!(req->flags & REQ_F_DONT_STEAL_NEXT))
+		io_req_find_next(req, &nxt);
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -2575,7 +2576,7 @@ static bool io_req_cancelled(struct io_kiocb *req)
 	if (req->work.flags & IO_WQ_WORK_CANCEL) {
 		req_set_fail_links(req);
 		io_cqring_add_event(req, -ECANCELED);
-		io_double_put_req(req);
+		io_put_req(req);
 		return true;
 	}
 
@@ -2603,7 +2604,7 @@ static void io_fsync_finish(struct io_wq_work **workptr)
 	if (io_req_cancelled(req))
 		return;
 	__io_fsync(req);
-	io_put_req_async_submission(req, workptr);
+	io_steal_work(req, workptr);
 }
 
 static int io_fsync(struct io_kiocb *req, bool force_nonblock)
@@ -2636,7 +2637,7 @@ static void io_fallocate_finish(struct io_wq_work **workptr)
 	if (io_req_cancelled(req))
 		return;
 	__io_fallocate(req);
-	io_put_req_async_submission(req, workptr);
+	io_steal_work(req, workptr);
 }
 
 static int io_fallocate_prep(struct io_kiocb *req,
@@ -3003,7 +3004,7 @@ static void io_close_finish(struct io_wq_work **workptr)
 
 	/* not cancellable, don't do io_req_cancelled() */
 	__io_close_finish(req);
-	io_put_req_async_submission(req, workptr);
+	io_steal_work(req, workptr);
 }
 
 static int io_close(struct io_kiocb *req, bool force_nonblock)
@@ -3076,7 +3077,7 @@ static void io_sync_file_range_finish(struct io_wq_work **workptr)
 	if (io_req_cancelled(req))
 		return;
 	__io_sync_file_range(req);
-	io_put_req_async_submission(req, workptr);
+	io_steal_work(req, workptr);
 }
 
 static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
@@ -3446,7 +3447,7 @@ static void io_accept_finish(struct io_wq_work **workptr)
 	if (io_req_cancelled(req))
 		return;
 	__io_accept(req, false);
-	io_put_req_async_submission(req, workptr);
+	io_steal_work(req, workptr);
 }
 #endif
 
@@ -4716,7 +4717,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 		io_put_req(req);
 	}
 
-	io_put_req_async_submission(req, workptr);
+	io_steal_work(req, workptr);
 }
 
 static int io_req_needs_file(struct io_kiocb *req, int fd)
@@ -6107,13 +6108,6 @@ static void io_put_work(struct io_wq_work *work)
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
@@ -6124,7 +6118,7 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
 	int ret = 0;
 
 	data.user = ctx->user;
-	data.get_work = io_get_work;
+	data.get_work = NULL;
 	data.put_work = io_put_work;
 
 	if (!(p->flags & IORING_SETUP_ATTACH_WQ)) {
-- 
2.24.0

