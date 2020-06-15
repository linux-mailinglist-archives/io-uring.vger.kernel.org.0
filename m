Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1661B1F8F81
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 09:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgFOH0G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 03:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728669AbgFOHZk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 03:25:40 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26EBC061A0E;
        Mon, 15 Jun 2020 00:25:39 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f185so13677519wmf.3;
        Mon, 15 Jun 2020 00:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hCmcJTHOD+I9y8zMPEKQfZ4lr4Baar/k/CqSQtJkni8=;
        b=gyzK30N5LjAUZYspjnP1rYi5vhZxhf7uwbaem5wYIxZT+/da7prQXz1LASs30qhxiH
         liFx8D82k8q6bupfg6u7laF4aoCR8VTNxIQOVHkKUVIt/mLASflxpUrAbpEgOJkqn2vq
         plJ315HAcnmREEebbs2ALEmY3mzzcE0Ugme0IvV3O/a+55h/cHwrHTUqE1j1UddrzamB
         lvGlWvcfhVdo/R0HDy3ehFNif17o7AskwMWUXv2whtAwCptewCbh2mTElVB9y5NpUDPY
         VUQGMTtKr+sZ32njVUEDx2ODBOr1VcSAC3v96LX/OrtWHWOPQIaZe8HAsRxZrs+15/uH
         gGRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hCmcJTHOD+I9y8zMPEKQfZ4lr4Baar/k/CqSQtJkni8=;
        b=cK+oam8r7riQNw/4Niw90MOxRp0KsHVW0GENNaTx7KzlK2hnxnBXLvGhEQ4pD7VsBV
         zhnOu9A8PssEVWDTLuDO22iDtq9gKIsl2aqaLtNeoiDD4xyJtOZtpowZfA5ARx+9ljQR
         j2ynyh8H5pxTEvhLhgFqD/9Uibb81LIW9Dayuhxci3cBsyILSw3934tZ7rhBY/MwRbnu
         mdLgvIIo/jJit3jaluBC/ZSW2MkdOy3/5a5Nyls0Z6if2pxMEYU7aIXPnHrp6woNLrqx
         JBuWcoyEt/c1sxluIJxFJeGI6inAFQsHaDR5x2igeP2UKUmNRMDWJIKaKzVhzCLdXmrE
         pYTQ==
X-Gm-Message-State: AOAM531Z92u3tlGU1rVbK5boL51aaT40kkJG1nFanczkec2fVX4XzL5i
        ndTRDM/xTONCskcfE1J7bqsYFhjT
X-Google-Smtp-Source: ABdhPJxQ12xchLyd+KF6I38bMdcp3Ai3PVBmxfWll1791kAy4og8dnlQ/kEUHgV62mnpn5EV2DB5iA==
X-Received: by 2002:a7b:ca47:: with SMTP id m7mr11234380wml.173.1592205938464;
        Mon, 15 Jun 2020 00:25:38 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id b187sm21897402wmd.26.2020.06.15.00.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 00:25:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] io-wq: add an option to cancel all matched reqs
Date:   Mon, 15 Jun 2020 10:24:03 +0300
Message-Id: <6943d97038cf2588a9ccfa8e92193349ebf373f7.1592205754.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592205754.git.asml.silence@gmail.com>
References: <cover.1592205754.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support for cancelling all io-wq works matching a predicate.
It isn't used yet, so no change in observable behaviour.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    | 60 +++++++++++++++++++++++++++++----------------------
 fs/io-wq.h    |  2 +-
 fs/io_uring.c |  2 +-
 3 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 9e7d277de248..3b0bd956e539 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -908,13 +908,15 @@ void io_wq_cancel_all(struct io_wq *wq)
 struct io_cb_cancel_data {
 	work_cancel_fn *fn;
 	void *data;
+	int nr_running;
+	int nr_pending;
+	bool cancel_all;
 };
 
 static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 {
 	struct io_cb_cancel_data *match = data;
 	unsigned long flags;
-	bool ret = false;
 
 	/*
 	 * Hold the lock to avoid ->cur_work going out of scope, caller
@@ -925,55 +927,55 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 	    !(worker->cur_work->flags & IO_WQ_WORK_NO_CANCEL) &&
 	    match->fn(worker->cur_work, match->data)) {
 		send_sig(SIGINT, worker->task, 1);
-		ret = true;
+		match->nr_running++;
 	}
 	spin_unlock_irqrestore(&worker->lock, flags);
 
-	return ret;
+	return match->nr_running && !match->cancel_all;
 }
 
-static bool io_wqe_cancel_pending_work(struct io_wqe *wqe,
+static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 				       struct io_cb_cancel_data *match)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work;
 	unsigned long flags;
-	bool found = false;
 
+retry:
 	spin_lock_irqsave(&wqe->lock, flags);
 	wq_list_for_each(node, prev, &wqe->work_list) {
 		work = container_of(node, struct io_wq_work, list);
+		if (!match->fn(work, match->data))
+			continue;
 
-		if (match->fn(work, match->data)) {
-			wq_list_del(&wqe->work_list, node, prev);
-			found = true;
-			break;
-		}
+		wq_list_del(&wqe->work_list, node, prev);
+		spin_unlock_irqrestore(&wqe->lock, flags);
+		io_run_cancel(work, wqe);
+		match->nr_pending++;
+		if (!match->cancel_all)
+			return;
+
+		/* not safe to continue after unlock */
+		goto retry;
 	}
 	spin_unlock_irqrestore(&wqe->lock, flags);
-
-	if (found)
-		io_run_cancel(work, wqe);
-	return found;
 }
 
-static bool io_wqe_cancel_running_work(struct io_wqe *wqe,
+static void io_wqe_cancel_running_work(struct io_wqe *wqe,
 				       struct io_cb_cancel_data *match)
 {
-	bool found;
-
 	rcu_read_lock();
-	found = io_wq_for_each_worker(wqe, io_wq_worker_cancel, match);
+	io_wq_for_each_worker(wqe, io_wq_worker_cancel, match);
 	rcu_read_unlock();
-	return found;
 }
 
 enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
-				  void *data)
+				  void *data, bool cancel_all)
 {
 	struct io_cb_cancel_data match = {
-		.fn	= cancel,
-		.data	= data,
+		.fn		= cancel,
+		.data		= data,
+		.cancel_all	= cancel_all,
 	};
 	int node;
 
@@ -985,7 +987,8 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
-		if (io_wqe_cancel_pending_work(wqe, &match))
+		io_wqe_cancel_pending_work(wqe, &match);
+		if (match.nr_pending && !match.cancel_all)
 			return IO_WQ_CANCEL_OK;
 	}
 
@@ -998,10 +1001,15 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
-		if (io_wqe_cancel_running_work(wqe, &match))
+		io_wqe_cancel_running_work(wqe, &match);
+		if (match.nr_running && !match.cancel_all)
 			return IO_WQ_CANCEL_RUNNING;
 	}
 
+	if (match.nr_running)
+		return IO_WQ_CANCEL_RUNNING;
+	if (match.nr_pending)
+		return IO_WQ_CANCEL_OK;
 	return IO_WQ_CANCEL_NOTFOUND;
 }
 
@@ -1012,7 +1020,7 @@ static bool io_wq_io_cb_cancel_data(struct io_wq_work *work, void *data)
 
 enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
 {
-	return io_wq_cancel_cb(wq, io_wq_io_cb_cancel_data, (void *)cwork);
+	return io_wq_cancel_cb(wq, io_wq_io_cb_cancel_data, (void *)cwork, false);
 }
 
 static bool io_wq_pid_match(struct io_wq_work *work, void *data)
@@ -1026,7 +1034,7 @@ enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid)
 {
 	void *data = (void *) (unsigned long) pid;
 
-	return io_wq_cancel_cb(wq, io_wq_pid_match, data);
+	return io_wq_cancel_cb(wq, io_wq_pid_match, data, false);
 }
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 8e138fa88b9f..7d5bd431c5e3 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -130,7 +130,7 @@ enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid);
 typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
 
 enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
-					void *data);
+					void *data, bool cancel_all);
 
 struct task_struct *io_wq_get_task(struct io_wq *wq);
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5b0249140ff5..7f18c29388d6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4773,7 +4773,7 @@ static int io_async_cancel_one(struct io_ring_ctx *ctx, void *sqe_addr)
 	enum io_wq_cancel cancel_ret;
 	int ret = 0;
 
-	cancel_ret = io_wq_cancel_cb(ctx->io_wq, io_cancel_cb, sqe_addr);
+	cancel_ret = io_wq_cancel_cb(ctx->io_wq, io_cancel_cb, sqe_addr, false);
 	switch (cancel_ret) {
 	case IO_WQ_CANCEL_OK:
 		ret = 0;
-- 
2.24.0

