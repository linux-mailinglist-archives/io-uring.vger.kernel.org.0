Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67AD936EE45
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 18:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhD2QkR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 12:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbhD2QkJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 12:40:09 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDB5C06138B
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 09:39:20 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 4-20020a05600c26c4b0290146e1feccd8so98740wmv.1
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 09:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZKsNUWbyFSiNzPR/UsdqZrhsaFfVEeWpe0MPIK+Cg+Y=;
        b=l3MIOTtn0/+21c+Kltt8g61De7gY13KP/Y0UIvfQ0b8/YDveQwbMHJpmbBwjozD6Cw
         EPmdU1jdDZoKq+UW5a2IaoWcz0tGfqa3KqFMA1CLxbVsP11IrrAxgPtMh/XTf2NuoxEb
         EPP/p7aL3Wgrel6T9L0k4hYoDZDirxirCnZTzxk97QGZWicxuKhgMZx7elMCRriPQHI4
         g/X4R1vwCy9FDZaD3SCiHk7RhufiyGqaGqvC5VgzzFqqeXATjaDpmvHAsU9cUbY69WJn
         l4GuVZrykNfvvQFCT0R2j+oFuvnMWcyVQEFAkC6ekYtKBXuWIzyhG/B3Is3EZNxScsnx
         WlJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZKsNUWbyFSiNzPR/UsdqZrhsaFfVEeWpe0MPIK+Cg+Y=;
        b=fp+gG79lBC4RPUOMFURH0FRq2CTmrJJV6S/vZZ9ZpOz4FwVUpJYvEi3x9lcFQiPFJR
         Zy/A5PgnsDJBTcFIveDB2EEEp8qeEwmwWF90UW6YTWOffrwFMRfAtsehw3FkpesgEzk1
         53BSLAJl5559ESnsw/d1KmOCMLTy3a6bFUcWKkm6yrHsW4qTMn9Vg4CULZncSlNjQrU4
         47iDPGFmtHr1kTG2WwmdivCa6WfWu/J0lcNP2hqoqcD59+Vmeabi60WU47aJBsE4C/8C
         3JwcJO0OnqsmlF+4GFc0yZ6mNb8PwMQ5Q59ikVHtJ0j/Fu/RpUsajwf+ER1KgB35CFJe
         wntw==
X-Gm-Message-State: AOAM531ujCnlaPZgQp9IgSkEofBewktZ60LuXYU85G/8bZQd8faCg9uz
        qXwM4qIJjtZM7BScnXjiSMFXqP82UWc=
X-Google-Smtp-Source: ABdhPJwkJRcA+bKSSmKYLLKbfaydxfXkHnEayAOcJiuOM/nTmbT2ku1ph5O1+BQ7jrqXFaNVVB6lsw==
X-Received: by 2002:a7b:cb4a:: with SMTP id v10mr1014682wmj.53.1619714359360;
        Thu, 29 Apr 2021 09:39:19 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id 6sm13578191wmg.9.2021.04.29.09.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 09:39:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: non-atomic request refs
Date:   Thu, 29 Apr 2021 17:39:05 +0100
Message-Id: <8ad20c522160ab20205dbd92f0e242bb3d1676b9.1619714335.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619714335.git.asml.silence@gmail.com>
References: <cover.1619714335.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Replace request reference counting with a non-atomic reference
synchronised by completion_lock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 73 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9c8e1e773a34..9f534febe69f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -827,7 +827,7 @@ struct io_kiocb {
 
 	struct io_ring_ctx		*ctx;
 	unsigned int			flags;
-	atomic_t			refs;
+	int				refs;
 	struct task_struct		*task;
 	u64				user_data;
 
@@ -1487,23 +1487,25 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
  * see commit f958d7b528b1 for details.
  */
 #define req_ref_zero_or_close_to_overflow(req)	\
-	((unsigned int) atomic_read(&(req->refs)) + 127u <= 127u)
+	((req)->refs == 0)
 
 static inline bool req_ref_inc_not_zero(struct io_kiocb *req)
 {
-	return atomic_inc_not_zero(&req->refs);
+	if (!req->refs)
+		return false;
+	req->refs++;
+	return true;
 }
 
 static inline bool req_ref_sub_and_test(struct io_kiocb *req, int refs)
 {
 	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
-	return atomic_sub_and_test(refs, &req->refs);
+	return req->refs -= refs;
 }
 
 static inline bool req_ref_put_and_test(struct io_kiocb *req)
 {
-	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
-	return atomic_dec_and_test(&req->refs);
+	return req_ref_sub_and_test(req, 1);
 }
 
 static inline void req_ref_put(struct io_kiocb *req)
@@ -1514,7 +1516,18 @@ static inline void req_ref_put(struct io_kiocb *req)
 static inline void req_ref_get(struct io_kiocb *req)
 {
 	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
-	atomic_inc(&req->refs);
+	req->refs++;
+}
+
+static inline bool io_req_sub_and_test_safe(struct io_kiocb *req, int nr)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&req->ctx->completion_lock, flags);
+	ret = req_ref_sub_and_test(req, nr);
+	spin_unlock_irqrestore(&req->ctx->completion_lock, flags);
+	return ret;
 }
 
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
@@ -1601,16 +1614,13 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 		list_add(&req->compl.list, &cs->locked_free_list);
 		cs->locked_free_nr++;
 	} else {
-		if (!percpu_ref_tryget(&ctx->refs))
-			req = NULL;
+		percpu_ref_get(&ctx->refs);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
-	if (req) {
-		io_cqring_ev_posted(ctx);
-		percpu_ref_put(&ctx->refs);
-	}
+	io_cqring_ev_posted(ctx);
+	percpu_ref_put(&ctx->refs);
 }
 
 static inline bool io_req_needs_clean(struct io_kiocb *req)
@@ -2132,21 +2142,22 @@ static void io_submit_flush_completions(struct io_comp_state *cs,
 	spin_lock_irq(&ctx->completion_lock);
 	for (i = 0; i < nr; i++) {
 		req = cs->reqs[i];
+		refs = 1 + !!(req->flags & REQ_F_COMPLETE_INLINE);
+
 		if (req->flags & REQ_F_COMPLETE_INLINE)
 			__io_cqring_fill_event(ctx, req->user_data, req->result,
 						req->compl.cflags);
+		if (!req_ref_sub_and_test(req, refs))
+			cs->reqs[i] = NULL;
 	}
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
 
 	io_cqring_ev_posted(ctx);
 	for (i = 0; i < nr; i++) {
-		req = cs->reqs[i];
-		refs = 1 + !!(req->flags & REQ_F_COMPLETE_INLINE);
-
 		/* submission and completion refs */
-		if (req_ref_sub_and_test(req, refs))
-			io_req_free_batch(&rb, req, &ctx->submit_state);
+		if (cs->reqs[i])
+			io_req_free_batch(&rb, cs->reqs[i], &ctx->submit_state);
 	}
 
 	io_req_free_batch_finish(ctx, &rb);
@@ -2161,7 +2172,7 @@ static inline struct io_kiocb *io_put_req_find_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = NULL;
 
-	if (req_ref_put_and_test(req)) {
+	if (io_req_sub_and_test_safe(req, 1)) {
 		nxt = io_req_find_next(req);
 		__io_free_req(req);
 	}
@@ -2170,7 +2181,7 @@ static inline struct io_kiocb *io_put_req_find_next(struct io_kiocb *req)
 
 static inline void io_put_req(struct io_kiocb *req)
 {
-	if (req_ref_put_and_test(req))
+	if (io_req_sub_and_test_safe(req, 1))
 		io_free_req(req);
 }
 
@@ -2188,6 +2199,12 @@ static void io_free_req_deferred(struct io_kiocb *req)
 		io_req_task_work_add_fallback(req, io_put_req_deferred_cb);
 }
 
+static inline void __io_put_req_deferred(struct io_kiocb *req, int refs)
+{
+	if (io_req_sub_and_test_safe(req, refs))
+		io_free_req_deferred(req);
+}
+
 static inline void io_put_req_deferred(struct io_kiocb *req, int refs)
 {
 	if (req_ref_sub_and_test(req, refs))
@@ -2757,7 +2774,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 	if (check_reissue && req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
 		if (io_resubmit_prep(req)) {
-			req_ref_get(req);
+			io_req_sub_and_test_safe(req, -1);
 			io_queue_async_work(req);
 		} else {
 			int cflags = 0;
@@ -3185,7 +3202,7 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 	list_del_init(&wait->entry);
 
 	/* submit ref gets dropped, acquire a new one */
-	req_ref_get(req);
+	io_req_sub_and_test_safe(req, -1);
 	io_req_task_queue(req);
 	return 1;
 }
@@ -4979,7 +4996,7 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 			poll->wait.func(&poll->wait, mode, sync, key);
 		}
 	}
-	req_ref_put(req);
+	__io_put_req_deferred(req, 1);
 	return 1;
 }
 
@@ -5030,7 +5047,7 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			return;
 		}
 		io_init_poll_iocb(poll, poll_one->events, io_poll_double_wake);
-		req_ref_get(req);
+		io_req_sub_and_test_safe(req, -1);
 		poll->wait.private = req;
 		*poll_ptr = poll;
 	}
@@ -6266,7 +6283,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	/* avoid locking problems by failing it from a clean context */
 	if (ret) {
 		/* io-wq is going to take one down */
-		req_ref_get(req);
+		io_req_sub_and_test_safe(req, -1);
 		io_req_task_queue_fail(req, ret);
 	}
 }
@@ -6364,11 +6381,11 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 
 	if (prev) {
 		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
-		io_put_req_deferred(prev, 1);
+		__io_put_req_deferred(prev, 1);
 	} else {
 		io_req_complete_post(req, -ETIME, 0);
 	}
-	io_put_req_deferred(req, 1);
+	__io_put_req_deferred(req, 1);
 	return HRTIMER_NORESTART;
 }
 
@@ -6503,7 +6520,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->link = NULL;
 	req->fixed_rsrc_refs = NULL;
 	/* one is dropped after submission, the other at completion */
-	atomic_set(&req->refs, 2);
+	req->refs = 2;
 	req->task = current;
 	req->result = 0;
 	req->work.creds = NULL;
-- 
2.31.1

