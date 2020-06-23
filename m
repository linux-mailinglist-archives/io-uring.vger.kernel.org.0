Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675C320559D
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 17:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732891AbgFWPQk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 11:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732781AbgFWPQk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 11:16:40 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13818C061755
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 08:16:39 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id f23so18715912iof.6
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 08:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ivnU5dVqZ8yhNnH5J6vQ0l1cwyV7VsdcPZxfpEgO48c=;
        b=k757Je12xOnyWljIOkxEPmMv6pLLXcjDQxTRprJrFgO4TbkXaU27oFiokpHPRpi4aL
         GCYIH5zZ6I1XPvYbICoV1uzI4zkeAIfe0VknTPi9Cm8Fw78DBk7b9bPK7E8ovDrLys6Z
         jvb90mLYJ4gCOJgWUot1c8/g8UrDxt4kKBy/Dn8qDwXuGT+NZgS2v+b8zbw7GUMOWgWK
         tWFbQ3R2hC6w0uyLAXhklZGxY20qCJV7aeRjmb79Gj+OvgNLXE5DaU9hmTJR4U+JgiLN
         Qd+lH5547foZAxDyrs1Ngo3NZCrDjbGjUehkDlqmQENHdytlaxxlLVXLhxV705Slx4Xr
         wZrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ivnU5dVqZ8yhNnH5J6vQ0l1cwyV7VsdcPZxfpEgO48c=;
        b=ttW55VmTY5dWkwf6kq9tuWcoxdMBUMjBP7i/tV7uZ9z+L50xgvsNQKtwc8lJymKg7N
         4L8LU+DjjKgvxqZikZr8y9sxhOZ7LQ7H6O/ladKDDLgvNeyO82olpsQtHpoWgjJIQtFf
         erJzaF2redodv4+Xo8s87WNWtLysi1CfIEIkhv29QlJMTWV8iPu2K/zDrUus0iXtFSIh
         ptzX6bAQKss9x0rxWMSh/Bd3Gsb5OlqlLrU7K/ntCFq3uYL9Adb5/thM/i01fvmCNAuu
         v8PW3wYAvmmkD6yeRo/86/F4Lys1n9oLgOALQ7ec+WrdKP8A1tpnsqv0tus/VEbecFnB
         //gg==
X-Gm-Message-State: AOAM533ItTZPTn1/idCOOiAvBrtOudoar9UwylTZH1T3PvaGSx3NoDfz
        FPu+xvIXKoVxNcmGWDYKo9cPDkmOnqM=
X-Google-Smtp-Source: ABdhPJxKmELSKTg15enYujexLbux07EiyAHIVSTPlG4G/3EC7topsqa0wl/VdQnWfLkBFb45WoxKYg==
X-Received: by 2002:a5e:8f4b:: with SMTP id x11mr17319879iop.90.1592925397915;
        Tue, 23 Jun 2020 08:16:37 -0700 (PDT)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k1sm4275180ilr.35.2020.06.23.08.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 08:16:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     xuanzhuo@linux.alibaba.com, Dust.li@linux.alibaba.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring: pass down completion state on the issue side
Date:   Tue, 23 Jun 2020 09:16:27 -0600
Message-Id: <20200623151629.17197-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623151629.17197-1-axboe@kernel.dk>
References: <20200623151629.17197-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No functional changes in this patch, just in preparation for having the
completion state be available on the issue side. Later on, this will
allow requests that complete inline to be completed in batches.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 67 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 50 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1da5269c9ef7..d6eb608c105a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -909,7 +909,8 @@ static void io_cleanup_req(struct io_kiocb *req);
 static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 		       int fd, struct file **out_file, bool fixed);
 static void __io_queue_sqe(struct io_kiocb *req,
-			   const struct io_uring_sqe *sqe);
+			   const struct io_uring_sqe *sqe,
+			   struct io_comp_state *cs);
 
 static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 			       struct iovec **iovec, struct iov_iter *iter,
@@ -2799,7 +2800,7 @@ static void io_async_buf_retry(struct callback_head *cb)
 	__set_current_state(TASK_RUNNING);
 	if (!io_sq_thread_acquire_mm(ctx, req)) {
 		mutex_lock(&ctx->uring_lock);
-		__io_queue_sqe(req, NULL);
+		__io_queue_sqe(req, NULL, NULL);
 		mutex_unlock(&ctx->uring_lock);
 	} else {
 		__io_async_buf_error(req, -EFAULT);
@@ -4423,7 +4424,7 @@ static void io_poll_task_func(struct callback_head *cb)
 		struct io_ring_ctx *ctx = nxt->ctx;
 
 		mutex_lock(&ctx->uring_lock);
-		__io_queue_sqe(nxt, NULL);
+		__io_queue_sqe(nxt, NULL, NULL);
 		mutex_unlock(&ctx->uring_lock);
 	}
 }
@@ -4548,7 +4549,7 @@ static void io_async_task_func(struct callback_head *cb)
 			goto end_req;
 		}
 		mutex_lock(&ctx->uring_lock);
-		__io_queue_sqe(req, NULL);
+		__io_queue_sqe(req, NULL, NULL);
 		mutex_unlock(&ctx->uring_lock);
 	} else {
 		io_cqring_ev_posted(ctx);
@@ -5345,7 +5346,7 @@ static void io_cleanup_req(struct io_kiocb *req)
 }
 
 static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			bool force_nonblock)
+			bool force_nonblock, struct io_comp_state *cs)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -5630,7 +5631,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 
 	if (!ret) {
 		do {
-			ret = io_issue_sqe(req, NULL, false);
+			ret = io_issue_sqe(req, NULL, false, NULL);
 			/*
 			 * We can get EAGAIN for polled IO even though we're
 			 * forcing a sync submission from here, since we can't
@@ -5807,7 +5808,8 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 	return nxt;
 }
 
-static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			   struct io_comp_state *cs)
 {
 	struct io_kiocb *linked_timeout;
 	struct io_kiocb *nxt;
@@ -5827,7 +5829,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			old_creds = override_creds(req->work.creds);
 	}
 
-	ret = io_issue_sqe(req, sqe, true);
+	ret = io_issue_sqe(req, sqe, true, cs);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
@@ -5885,7 +5887,8 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		revert_creds(old_creds);
 }
 
-static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			 struct io_comp_state *cs)
 {
 	int ret;
 
@@ -5914,21 +5917,22 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 		io_queue_async_work(req);
 	} else {
-		__io_queue_sqe(req, sqe);
+		__io_queue_sqe(req, sqe, cs);
 	}
 }
 
-static inline void io_queue_link_head(struct io_kiocb *req)
+static inline void io_queue_link_head(struct io_kiocb *req,
+				      struct io_comp_state *cs)
 {
 	if (unlikely(req->flags & REQ_F_FAIL_LINK)) {
 		io_put_req(req);
 		io_req_complete(req, -ECANCELED);
 	} else
-		io_queue_sqe(req, NULL);
+		io_queue_sqe(req, NULL, cs);
 }
 
 static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			 struct io_kiocb **link)
+			 struct io_kiocb **link, struct io_comp_state *cs)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -5968,7 +5972,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 		/* last request of a link, enqueue the link */
 		if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
-			io_queue_link_head(head);
+			io_queue_link_head(head, cs);
 			*link = NULL;
 		}
 	} else {
@@ -5988,18 +5992,47 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 				req->flags |= REQ_F_FAIL_LINK;
 			*link = req;
 		} else {
-			io_queue_sqe(req, sqe);
+			io_queue_sqe(req, sqe, cs);
 		}
 	}
 
 	return 0;
 }
 
+static void io_submit_flush_completions(struct io_comp_state *cs)
+{
+	struct io_ring_ctx *ctx = cs->ctx;
+
+	spin_lock_irq(&ctx->completion_lock);
+	while (!list_empty(&cs->list)) {
+		struct io_kiocb *req;
+
+		req = list_first_entry(&cs->list, struct io_kiocb, list);
+		list_del(&req->list);
+		io_cqring_fill_event(req, req->result);
+		if (!(req->flags & REQ_F_LINK_HEAD)) {
+			req->flags |= REQ_F_COMP_LOCKED;
+			io_put_req(req);
+		} else {
+			spin_unlock_irq(&ctx->completion_lock);
+			io_put_req(req);
+			spin_lock_irq(&ctx->completion_lock);
+		}
+	}
+	io_commit_cqring(ctx);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
+	cs->nr = 0;
+}
+
 /*
  * Batched submission is done, ensure local IO is flushed out.
  */
 static void io_submit_state_end(struct io_submit_state *state)
 {
+	if (!list_empty(&state->comp.list))
+		io_submit_flush_completions(&state->comp);
 	blk_finish_plug(&state->plug);
 	io_state_file_put(state);
 	if (state->free_reqs)
@@ -6189,7 +6222,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, io_async_submit(ctx));
-		err = io_submit_sqe(req, sqe, &link);
+		err = io_submit_sqe(req, sqe, &link, &state.comp);
 		if (err)
 			goto fail_req;
 	}
@@ -6200,7 +6233,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		percpu_ref_put_many(&ctx->refs, nr - ref_used);
 	}
 	if (link)
-		io_queue_link_head(link);
+		io_queue_link_head(link, &state.comp);
 	io_submit_state_end(&state);
 
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
-- 
2.27.0

