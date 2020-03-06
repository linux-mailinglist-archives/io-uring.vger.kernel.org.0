Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2731D17C836
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2020 23:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCFWQi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Mar 2020 17:16:38 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34164 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgCFWQi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Mar 2020 17:16:38 -0500
Received: by mail-wr1-f68.google.com with SMTP id z15so4133020wrl.1;
        Fri, 06 Mar 2020 14:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uOvy7qFzP2o/QfsQqd9FQH6elo20IssQkb6btx1/LZI=;
        b=PgmOLgpHd//uqECmKFYAD9ljB1lvLgSnihAI1gmHND6MHOXT7BhkZl3b2bqnUcGHEt
         hxJKcB/i/EcKTUw7w6HORLnI828m0NNqvxKu77lUCLn1f+nRqtISqrLBP9leDXJbOzW/
         pxGA9xYX6GOF5WS3kpSOnT8NNVT7FBZg4Yt0IhxDc9aSyNiy17S9TiZ0SXD/vcDyLJe0
         xJmvd1cAp2mFWEklxC/RtWmTTa6XaIXPEsXVFs8FqClUn77xI874i7XiQhdfh0JX9PdZ
         hh60OB3PfCXp1WwVtNqS6oT0OdMrylNNMdrbDHtho7v6+lemH0z0hk3DiFbuerepKX0x
         C7yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uOvy7qFzP2o/QfsQqd9FQH6elo20IssQkb6btx1/LZI=;
        b=t6EYHTZMYpr3bnxKAb02Gkhllc00E65Ja+emvAHn2kydY3OQZERSZLF09nmyScnx/W
         3yUpfaftg6wkqf5tY+rtirYBDba69cipQ+KxOrwhLMrJolCa9dE0JZ1T242uf6+iOuy6
         6rriKxjHFPNLDubYpiviwjz/acHcAgBjwm2A1cQVZW7DX4l5LVUCH/AKQIz6sWJvVNG8
         YTNNIfZSn9uiHAXgbXWWEU/ylNrOIubGIWMXSUNFtJcndL1C1RbvuZZdnSGG5D90Iv+F
         iwrZ6BXPDrIg8EJ1O/AXH/I2GaKqj6yTT1tGJX5ZLZtEyZ/tCPCZcqmpthgTyMMObYlS
         XYMA==
X-Gm-Message-State: ANhLgQ14KNSg/KSB/TPEYL2SDIAuiRHz67+UuOoXJoi3kqRMDwuIloM+
        qkCKrWmqoTfYoEGI5hB0Afyv3/PX
X-Google-Smtp-Source: ADFU+vvZ6lCgwvbC8a0wJ/X1+n+BpidLMBSrXPAuIEv5HBF+/Ap/wTMk8+Lz39t/49KT8fDNOckslQ==
X-Received: by 2002:adf:ec52:: with SMTP id w18mr5860600wrn.26.1583532995771;
        Fri, 06 Mar 2020 14:16:35 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id r19sm14592901wmh.26.2020.03.06.14.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 14:16:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] io-wq: remove duplicated cancel code
Date:   Sat,  7 Mar 2020 01:15:39 +0300
Message-Id: <883f200570ee22c8081469bd571bec5fb27da4c5.1583531319.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Deduplicate cancellation parts, as many of them looks the same, as do
e.g.
- io_wqe_cancel_cb_work() and io_wqe_cancel_work()
- io_wq_worker_cancel() and io_work_cancel()

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 136 ++++++++++-------------------------------------------
 1 file changed, 24 insertions(+), 112 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index eda36f997dea..0e7c6277afcb 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -855,14 +855,13 @@ void io_wq_cancel_all(struct io_wq *wq)
 }
 
 struct io_cb_cancel_data {
-	struct io_wqe *wqe;
-	work_cancel_fn *cancel;
-	void *caller_data;
+	work_cancel_fn *fn;
+	void *data;
 };
 
-static bool io_work_cancel(struct io_worker *worker, void *cancel_data)
+static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 {
-	struct io_cb_cancel_data *data = cancel_data;
+	struct io_cb_cancel_data *match = data;
 	unsigned long flags;
 	bool ret = false;
 
@@ -873,83 +872,7 @@ static bool io_work_cancel(struct io_worker *worker, void *cancel_data)
 	spin_lock_irqsave(&worker->lock, flags);
 	if (worker->cur_work &&
 	    !(worker->cur_work->flags & IO_WQ_WORK_NO_CANCEL) &&
-	    data->cancel(worker->cur_work, data->caller_data)) {
-		send_sig(SIGINT, worker->task, 1);
-		ret = true;
-	}
-	spin_unlock_irqrestore(&worker->lock, flags);
-
-	return ret;
-}
-
-static enum io_wq_cancel io_wqe_cancel_cb_work(struct io_wqe *wqe,
-					       work_cancel_fn *cancel,
-					       void *cancel_data)
-{
-	struct io_cb_cancel_data data = {
-		.wqe = wqe,
-		.cancel = cancel,
-		.caller_data = cancel_data,
-	};
-	struct io_wq_work_node *node, *prev;
-	struct io_wq_work *work;
-	unsigned long flags;
-	bool found = false;
-
-	spin_lock_irqsave(&wqe->lock, flags);
-	wq_list_for_each(node, prev, &wqe->work_list) {
-		work = container_of(node, struct io_wq_work, list);
-
-		if (cancel(work, cancel_data)) {
-			wq_node_del(&wqe->work_list, node, prev);
-			found = true;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&wqe->lock, flags);
-
-	if (found) {
-		io_run_cancel(work, wqe);
-		return IO_WQ_CANCEL_OK;
-	}
-
-	rcu_read_lock();
-	found = io_wq_for_each_worker(wqe, io_work_cancel, &data);
-	rcu_read_unlock();
-	return found ? IO_WQ_CANCEL_RUNNING : IO_WQ_CANCEL_NOTFOUND;
-}
-
-enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
-				  void *data)
-{
-	enum io_wq_cancel ret = IO_WQ_CANCEL_NOTFOUND;
-	int node;
-
-	for_each_node(node) {
-		struct io_wqe *wqe = wq->wqes[node];
-
-		ret = io_wqe_cancel_cb_work(wqe, cancel, data);
-		if (ret != IO_WQ_CANCEL_NOTFOUND)
-			break;
-	}
-
-	return ret;
-}
-
-struct work_match {
-	bool (*fn)(struct io_wq_work *, void *data);
-	void *data;
-};
-
-static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
-{
-	struct work_match *match = data;
-	unsigned long flags;
-	bool ret = false;
-
-	spin_lock_irqsave(&worker->lock, flags);
-	if (match->fn(worker->cur_work, match->data) &&
-	    !(worker->cur_work->flags & IO_WQ_WORK_NO_CANCEL)) {
+	    match->fn(worker->cur_work, match->data)) {
 		send_sig(SIGINT, worker->task, 1);
 		ret = true;
 	}
@@ -959,7 +882,7 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 }
 
 static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
-					    struct work_match *match)
+					    struct io_cb_cancel_data *match)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work;
@@ -1000,22 +923,16 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
 	return found ? IO_WQ_CANCEL_RUNNING : IO_WQ_CANCEL_NOTFOUND;
 }
 
-static bool io_wq_work_match(struct io_wq_work *work, void *data)
-{
-	return work == data;
-}
-
-enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
+enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
+				  void *data)
 {
-	struct work_match match = {
-		.fn	= io_wq_work_match,
-		.data	= cwork
+	struct io_cb_cancel_data match = {
+		.fn	= cancel,
+		.data	= data,
 	};
 	enum io_wq_cancel ret = IO_WQ_CANCEL_NOTFOUND;
 	int node;
 
-	cwork->flags |= IO_WQ_WORK_CANCEL;
-
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
@@ -1027,33 +944,28 @@ enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
 	return ret;
 }
 
+static bool io_wq_io_cb_cancel_data(struct io_wq_work *work, void *data)
+{
+	return work == data;
+}
+
+enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
+{
+	return io_wq_cancel_cb(wq, io_wq_io_cb_cancel_data, (void *)cwork);
+}
+
 static bool io_wq_pid_match(struct io_wq_work *work, void *data)
 {
 	pid_t pid = (pid_t) (unsigned long) data;
 
-	if (work)
-		return work->task_pid == pid;
-	return false;
+	return work->task_pid == pid;
 }
 
 enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid)
 {
-	struct work_match match = {
-		.fn	= io_wq_pid_match,
-		.data	= (void *) (unsigned long) pid
-	};
-	enum io_wq_cancel ret = IO_WQ_CANCEL_NOTFOUND;
-	int node;
-
-	for_each_node(node) {
-		struct io_wqe *wqe = wq->wqes[node];
+	void *data = (void *) (unsigned long) pid;
 
-		ret = io_wqe_cancel_work(wqe, &match);
-		if (ret != IO_WQ_CANCEL_NOTFOUND)
-			break;
-	}
-
-	return ret;
+	return io_wq_cancel_cb(wq, io_wq_pid_match, data);
 }
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
-- 
2.24.0

