Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F161F0C6E
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2020 17:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgFGPeL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 11:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgFGPeK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 11:34:10 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD62C08C5C4;
        Sun,  7 Jun 2020 08:34:09 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id q25so13980962wmj.0;
        Sun, 07 Jun 2020 08:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=x4J7gn7StAXEHk+li9NqtaNo161m+6dZxHH0kWNnq0U=;
        b=vPpmQggfUGbR7aptEHIa+XvURIhO2+pQB5p/AMlipwTImn+a3V9evB1+cIl/HcmJXY
         eWA//izTGIX5UgeRn0wDexNhFMuU9r6UDa9O/mKx5qFfNAQUXI2HfUiI6lt+6Re33R+R
         Y/5cgrgsCSZzz9W7AsfHUu9qFLUt0JLCBlEnOLqI1BoES/xZqJSWShbrkChukdRkvEA1
         UbpIyn2kDjyh/XXYw4cs86oSkehbbrxvQGCK46d37fVZ/v4h9738cfeWd6T8tCjp0Sbn
         y1sgVmNO52zrBUowszN0+Xv3o4F0EnYUG9ZNdHAgNnsEwMtjSEw0QpYB8jUX1G+qzxxH
         w0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x4J7gn7StAXEHk+li9NqtaNo161m+6dZxHH0kWNnq0U=;
        b=jxCxSfd9ysa0RIfHiIwnqD12eRSrk+QJmO6Ax2OBWbXGovB0uHfNdO5Va7MY4T01bm
         AYNQrZQ8SB7VMU5zDcEePehsD7gh+WwajE2Hhf5BVUZ+nnY2cYQiXx4A4Wic7iEjOM4S
         cxW80V8BlM/Ye5Upp71q0vaVmhn0xURqXwIb93pJ2FM3R/VZG+pCpr1+EJKKRd55FVzM
         XWk4NVdwAYkQCdbo0i3DbiOjnarMC0V/Mq5klowBDntoZsFxPXLTeNi7gVg0S99PhGNV
         BhVFJnnG3V8z5DehUc837qxo3rsH99o3bP5KHqQfF2r7Jg3FCy14J6Wd0e94IKaKx9eq
         KBWQ==
X-Gm-Message-State: AOAM531xQy0eQxQaGIV7+lqzROi0wFmbk9bX8pC14YMozxUozVyaCi5T
        8F/LMGcKj6w1jXsAc2YD0ww=
X-Google-Smtp-Source: ABdhPJzwXz4ZuXk3gjUmYFg2IPBEhRRahFSyOg9itQglaqRNJkb2fpElR3+jjhuAbrUjSt9Ucn5LtA==
X-Received: by 2002:a7b:cd06:: with SMTP id f6mr12145293wmj.8.1591544048114;
        Sun, 07 Jun 2020 08:34:08 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id 1sm19589015wmz.13.2020.06.07.08.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 08:34:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] io-wq: add an option to cancel all matched reqs
Date:   Sun,  7 Jun 2020 18:32:23 +0300
Message-Id: <b281bbd4c2e728d6c43b2bcbdfd9ecfd6248c654.1591541128.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591541128.git.asml.silence@gmail.com>
References: <cover.1591541128.git.asml.silence@gmail.com>
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
index 3283f8c5b5a1..6d2e8ccc229e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -907,13 +907,15 @@ void io_wq_cancel_all(struct io_wq *wq)
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
@@ -924,55 +926,55 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
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
 
@@ -984,7 +986,8 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
-		if (io_wqe_cancel_pending_work(wqe, &match))
+		io_wqe_cancel_pending_work(wqe, &match);
+		if (match.nr_pending && !match.cancel_all)
 			return IO_WQ_CANCEL_OK;
 	}
 
@@ -997,10 +1000,15 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
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
 
@@ -1011,7 +1019,7 @@ static bool io_wq_io_cb_cancel_data(struct io_wq_work *work, void *data)
 
 enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
 {
-	return io_wq_cancel_cb(wq, io_wq_io_cb_cancel_data, (void *)cwork);
+	return io_wq_cancel_cb(wq, io_wq_io_cb_cancel_data, (void *)cwork, false);
 }
 
 static bool io_wq_pid_match(struct io_wq_work *work, void *data)
@@ -1025,7 +1033,7 @@ enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid)
 {
 	void *data = (void *) (unsigned long) pid;
 
-	return io_wq_cancel_cb(wq, io_wq_pid_match, data);
+	return io_wq_cancel_cb(wq, io_wq_pid_match, data, false);
 }
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 5ba12de7572f..8902903831f2 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -134,7 +134,7 @@ enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid);
 typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
 
 enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
-					void *data);
+					void *data, bool cancel_all);
 
 struct task_struct *io_wq_get_task(struct io_wq *wq);
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6391a00ff8b7..8b0c9a5bcec1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4884,7 +4884,7 @@ static int io_async_cancel_one(struct io_ring_ctx *ctx, void *sqe_addr)
 	enum io_wq_cancel cancel_ret;
 	int ret = 0;
 
-	cancel_ret = io_wq_cancel_cb(ctx->io_wq, io_cancel_cb, sqe_addr);
+	cancel_ret = io_wq_cancel_cb(ctx->io_wq, io_cancel_cb, sqe_addr, false);
 	switch (cancel_ret) {
 	case IO_WQ_CANCEL_OK:
 		ret = 0;
-- 
2.24.0

