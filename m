Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5634735B10C
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbhDKAvR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234903AbhDKAvR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:17 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE94EC06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:01 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b9so9256233wrs.1
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PvDhszO+3EXvrU/RCGSEzpxPASiNaJbQGJ5PS4GhZ7I=;
        b=m+bmbAmKt6baOwNPQmw+3k7LuvPoIU31KtlNj+Fq6G5Gms0lSD8WYaa97StTP6acc1
         Ijesp3Hrqg/eXpSHyjqaKdbtv52jKBTf+hD5154xNzO4c2+IdmhO6Nd3n23CMbOn6sTv
         afsLOjAItgC2e/R/h5re+SCa8yivSIW4dQm1uDl/XInteZzli6oCsy2MX5U+54pZ4EBH
         De/mAiQKGb45+zYCdLLL7XNBCfsoU3WD3X+OZZseh0yHLEFYYota3nZ5SJnzg4Wjxk6V
         yGZ/sT08L9mIAQpif5vUGcJL5yxT70k3EeuK15l3Tnkh5pPHaoTzzpbRaUteyBkGFRGg
         DSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PvDhszO+3EXvrU/RCGSEzpxPASiNaJbQGJ5PS4GhZ7I=;
        b=ZDMIY6zTqq1AqV/yQ/LnY3xLKN6AI+JFkiclRFW1HIU4dOnoih7067DCJDYHQsh1qx
         xw7vRlRbksY2luh4wmm1bhagcUxrB8e2bhpEs/xZ1onrzTCsin76ZLrcYi1DSSuVNpNh
         ex8GskLJhPFi4ZJ0EMFHiXd/ANpQEaCcydEBO7UZbXq8jySQqKFMTDJe6fyWVK36OmRG
         VOsWouPSK3QGOgrklGu+UVbGb4/xnfovhaob0a6JOwoKhzJ1PmqUGTcDyhsyMqWA1CuH
         64162mALlpvFeVi7PlAwXE+b5ipAi125Mmsm6UjeIOHuanA6VU1gvGOCR8vKB1G0PBRQ
         zRBQ==
X-Gm-Message-State: AOAM530vsEren65M3PNHzm6CzYAZdB3zYQgvxO4dM6kwZGHo5uVXRYTU
        wGqD5DgwkR2w0OMoC/IY6SiwP1dteRPfZA==
X-Google-Smtp-Source: ABdhPJyenYNLsUwgkW/fDMbt9umOz7NdwH1znjrQlSgQRiko3Pq/kZTiOmL4Cmh3xF3N0zbRY2e7Zg==
X-Received: by 2002:adf:f543:: with SMTP id j3mr23988715wrp.259.1618102260748;
        Sat, 10 Apr 2021 17:51:00 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:51:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/16] io_uring: always pass cflags into fill_event()
Date:   Sun, 11 Apr 2021 01:46:32 +0100
Message-Id: <704f9c85b7d9843e4ad50a9f057200c58f5adc6e.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A simple preparation patch inlining io_cqring_fill_event(), which only
role was to pass cflags=0 into an actual fill event. It helps to keep
number of related helpers sane in following patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 87c1c614411c..1a7bfb10d2b2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1030,7 +1030,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx);
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 
-static void io_cqring_fill_event(struct io_kiocb *req, long res);
+static bool io_cqring_fill_event(struct io_kiocb *req, long res, unsigned cflags);
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req, int nr);
 static void io_dismantle_req(struct io_kiocb *req);
@@ -1260,7 +1260,7 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		io_cqring_fill_event(req, status);
+		io_cqring_fill_event(req, status, 0);
 		io_put_req_deferred(req, 1);
 	}
 }
@@ -1494,8 +1494,8 @@ static inline void req_ref_get(struct io_kiocb *req)
 	atomic_inc(&req->refs);
 }
 
-static bool __io_cqring_fill_event(struct io_kiocb *req, long res,
-				   unsigned int cflags)
+static bool io_cqring_fill_event(struct io_kiocb *req, long res,
+				 unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_cqe *cqe;
@@ -1541,11 +1541,6 @@ static bool __io_cqring_fill_event(struct io_kiocb *req, long res,
 	return false;
 }
 
-static void io_cqring_fill_event(struct io_kiocb *req, long res)
-{
-	__io_cqring_fill_event(req, res, 0);
-}
-
 static void io_req_complete_post(struct io_kiocb *req, long res,
 				 unsigned int cflags)
 {
@@ -1553,7 +1548,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	__io_cqring_fill_event(req, res, cflags);
+	io_cqring_fill_event(req, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
@@ -1769,7 +1764,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		link->timeout.head = NULL;
 		ret = hrtimer_try_to_cancel(&io->timer);
 		if (ret != -1) {
-			io_cqring_fill_event(link, -ECANCELED);
+			io_cqring_fill_event(link, -ECANCELED, 0);
 			io_put_req_deferred(link, 1);
 			return true;
 		}
@@ -1788,7 +1783,7 @@ static void io_fail_links(struct io_kiocb *req)
 		link->link = NULL;
 
 		trace_io_uring_fail_link(req, link);
-		io_cqring_fill_event(link, -ECANCELED);
+		io_cqring_fill_event(link, -ECANCELED, 0);
 		io_put_req_deferred(link, 2);
 		link = nxt;
 	}
@@ -2108,7 +2103,7 @@ static void io_submit_flush_completions(struct io_comp_state *cs,
 	spin_lock_irq(&ctx->completion_lock);
 	for (i = 0; i < nr; i++) {
 		req = cs->reqs[i];
-		__io_cqring_fill_event(req, req->result, req->compl.cflags);
+		io_cqring_fill_event(req, req->result, req->compl.cflags);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
@@ -2248,7 +2243,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		if (req->flags & REQ_F_BUFFER_SELECTED)
 			cflags = io_put_rw_kbuf(req);
 
-		__io_cqring_fill_event(req, req->result, cflags);
+		io_cqring_fill_event(req, req->result, cflags);
 		(*nr_events)++;
 
 		if (req_ref_put_and_test(req))
@@ -4887,7 +4882,7 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	}
 	if (req->poll.events & EPOLLONESHOT)
 		flags = 0;
-	if (!__io_cqring_fill_event(req, error, flags)) {
+	if (!io_cqring_fill_event(req, error, flags)) {
 		io_poll_remove_waitqs(req);
 		req->poll.done = true;
 		flags = 0;
@@ -5224,7 +5219,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 
 	do_complete = io_poll_remove_waitqs(req);
 	if (do_complete) {
-		io_cqring_fill_event(req, -ECANCELED);
+		io_cqring_fill_event(req, -ECANCELED, 0);
 		io_commit_cqring(req->ctx);
 		req_set_fail_links(req);
 		io_put_req_deferred(req, 1);
@@ -5483,7 +5478,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	atomic_set(&req->ctx->cq_timeouts,
 		atomic_read(&req->ctx->cq_timeouts) + 1);
 
-	io_cqring_fill_event(req, -ETIME);
+	io_cqring_fill_event(req, -ETIME, 0);
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
@@ -5528,7 +5523,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 		return PTR_ERR(req);
 
 	req_set_fail_links(req);
-	io_cqring_fill_event(req, -ECANCELED);
+	io_cqring_fill_event(req, -ECANCELED, 0);
 	io_put_req_deferred(req, 1);
 	return 0;
 }
@@ -5601,7 +5596,7 @@ static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_timeout_update(ctx, tr->addr, &tr->ts,
 					io_translate_timeout_mode(tr->flags));
 
-	io_cqring_fill_event(req, ret);
+	io_cqring_fill_event(req, ret, 0);
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
@@ -5753,7 +5748,7 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 done:
 	if (!ret)
 		ret = success_ret;
-	io_cqring_fill_event(req, ret);
+	io_cqring_fill_event(req, ret, 0);
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	io_cqring_ev_posted(ctx);
@@ -5810,7 +5805,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 
 	spin_lock_irq(&ctx->completion_lock);
 done:
-	io_cqring_fill_event(req, ret);
+	io_cqring_fill_event(req, ret, 0);
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
-- 
2.24.0

