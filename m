Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4396E17434F
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 00:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgB1Xij (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 18:38:39 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33797 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgB1Xii (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 18:38:38 -0500
Received: by mail-wm1-f66.google.com with SMTP id i10so9297793wmd.1;
        Fri, 28 Feb 2020 15:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Ssw6UNJlKT+KneadMWBdq0id//CH16BE3vLYYGo0tJw=;
        b=ETuMVD3uSw4cPuzOEG6cejQ7mAAbXHJiom6+SfeQ/q6nTtdHdS/1x7giawsIaAe43h
         C00xowVojLpzdEytNAmHl1L0G7qd4ASn3p31SPMgjxoYBx0nRzFrHY+kPdT6Hb32Sh8y
         A9A+8lYxTP6D4nhlbJo1iJNYaFIPuwih20nmtyGhZJz+o455j3Hv8powzef1WXfFwoQL
         N0KdpjzHhCpNFPXNBAtMBo80fQrloi+NhLJB1Wn5cpVhwFzmWYl/N+5+P6N+J8WGxO9p
         Y6zIHvgAHhFJDo+/JcHSzuuY/yaLz1GrsJc2vERtY3SVKwdomMhuia9RI7ZEklT1q8QA
         FVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ssw6UNJlKT+KneadMWBdq0id//CH16BE3vLYYGo0tJw=;
        b=LO5GYmP1XJhC6PxfkQK247KQU1fGMqidYqFqvjpEMh6F6zpjH321slePpMAriw31+w
         L3Le/3y/z//niAakwWe01MBWrOJC0D0MbIjcWLSxFoGS2cqWZInjUuorfv86jbyO41vE
         FygnaEvNHwfo8eVU76BaHTgjQFH/JwX0v2wzPj4reRWlnwLnwz+wvVji/8endaLobT+V
         fJ7r1rlurjWkDafgx2bM9poAoZFRRaw1Qe7o4a+7ecnFTjbwQnMtPgBPD8MPgWJM6g7U
         8pvZFvomhMw3kAwmtLbChtnEITPwsTsACAhoAKd2iA6SYXi7d5yLyJvgkZtDbauNRMUt
         ovyQ==
X-Gm-Message-State: APjAAAWao60hQ0saXSPDJEtYuWq/TzRerh2XSmAnUhHVGRhHsFOEVZTB
        hUEncZHXkG181J6q0IjRXQ8=
X-Google-Smtp-Source: APXvYqzX9CYi9wStGzGyLkpz3zZpP7nYFuT4SRr7OE/SgbEMFBEj2EE7uPky38yTQ6E8wCYdqiodQg==
X-Received: by 2002:a1c:38c7:: with SMTP id f190mr6708279wma.94.1582933115216;
        Fri, 28 Feb 2020 15:38:35 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id q1sm13762512wrw.5.2020.02.28.15.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 15:38:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] io_uring/io-wq: allow put_work return next work
Date:   Sat, 29 Feb 2020 02:37:27 +0300
Message-Id: <6280f7ebf6bec855f8667ecc7bc97bb07fb39b83.1582932860.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582932860.git.asml.silence@gmail.com>
References: <cover.1582932860.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Formerly work->func() was returning next work to exeucute. Make put_work
do the same. As put_work() is the last thing happening with work during
issuing, it have all info needed to deduce the next job.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    | 17 +++++------------
 fs/io-wq.h    |  2 +-
 fs/io_uring.c | 29 ++++++++++++++++++++++++++---
 3 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index a830eddaffbe..8bdda5e23dcd 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -443,7 +443,7 @@ static void io_wq_switch_creds(struct io_worker *worker,
 static void io_worker_handle_work(struct io_worker *worker)
 	__releases(wqe->lock)
 {
-	struct io_wq_work *work, *old_work = NULL, *put_work = NULL;
+	struct io_wq_work *work, *old_work = NULL;
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 
@@ -464,8 +464,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 			wqe->flags |= IO_WQE_FLAG_STALLED;
 
 		spin_unlock_irq(&wqe->lock);
-		if (put_work && wq->put_work)
-			wq->put_work(old_work);
 		if (!work)
 			break;
 next:
@@ -497,10 +495,8 @@ static void io_worker_handle_work(struct io_worker *worker)
 		if (test_bit(IO_WQ_BIT_CANCEL, &wq->state))
 			work->flags |= IO_WQ_WORK_CANCEL;
 
-		if (wq->get_work && !(work->flags & IO_WQ_WORK_INTERNAL)) {
-			put_work = work;
+		if (wq->get_work && !(work->flags & IO_WQ_WORK_INTERNAL))
 			wq->get_work(work);
-		}
 
 		old_work = work;
 		work->func(work);
@@ -509,6 +505,9 @@ static void io_worker_handle_work(struct io_worker *worker)
 		worker->cur_work = NULL;
 		spin_unlock_irq(&worker->lock);
 
+		if (wq->put_work && !(work->flags & IO_WQ_WORK_INTERNAL))
+			wq->put_work(&work);
+
 		spin_lock_irq(&wqe->lock);
 
 		if (hash != -1U) {
@@ -517,12 +516,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 		}
 		if (work && work != old_work) {
 			spin_unlock_irq(&wqe->lock);
-
-			if (put_work && wq->put_work) {
-				wq->put_work(put_work);
-				put_work = NULL;
-			}
-
 			/* dependent work not hashed */
 			hash = -1U;
 			goto next;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 508615af4552..f1d717e9acc1 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -83,7 +83,7 @@ struct io_wq_work {
 	} while (0)						\
 
 typedef void (get_work_fn)(struct io_wq_work *);
-typedef void (put_work_fn)(struct io_wq_work *);
+typedef void (put_work_fn)(struct io_wq_work **);
 
 struct io_wq_data {
 	struct user_struct *user;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 54dfa9b71864..5a579f686f9e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6064,11 +6064,34 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 	return __io_sqe_files_update(ctx, &up, nr_args);
 }
 
-static void io_put_work(struct io_wq_work *work)
+static void io_link_work_cb(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_kiocb *link = work->data;
 
-	io_put_req(req);
+	io_queue_linked_timeout(link);
+	io_wq_submit_work(work);
+}
+
+static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *req)
+{
+	struct io_kiocb *link;
+
+	io_prep_next_work(req, &link);
+	*workptr = &req->work;
+	if (link) {
+		req->work.func = io_link_work_cb;
+		req->work.data = link;
+	}
+}
+
+static void io_put_work(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *nxt = NULL;
+
+	io_put_req_find_next(req, &nxt);
+	if (nxt)
+		io_wq_assign_next(workptr, nxt);
 }
 
 static void io_get_work(struct io_wq_work *work)
-- 
2.24.0

