Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE9F174351
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 00:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgB1Xig (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 18:38:36 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]:37059 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgB1Xif (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 18:38:35 -0500
Received: by mail-wm1-f47.google.com with SMTP id a141so5159910wme.2;
        Fri, 28 Feb 2020 15:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=CJQOQfTviWsGvoVWHdG9gbIZtuVbYKj722HiymhEARA=;
        b=oTsZfOpHGC9gUdGOP9b1Egebbwq4QLIUd4Rml9XrEB1PDzSY4RyjrEWGhQlhRlh03K
         8W7c6VKJrIVMdjnL/L8siU2WvcvoRnZ4YJypvs3W/s7wlhuQddFH5OdPKwwYiUk/+UNt
         QslkXY0DahPINNIyrR1i0o/xEBpbZOshoDcsN56TpGAcJZ/Z11bTqmRzYwTF0OazpCKm
         9PRFGTmDyd4MFPjERb6Z95QqEmyjjcIswGZrYYICQq+kjFmmx4OqCwpGvYk4LSJP2FJv
         kpC8NrxzBUF6JtxYsDynYB+8DyoUbBKKcZrmk7GXaCSlTpuTpe4M1LLZOaWXqb5HvBB2
         ++oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CJQOQfTviWsGvoVWHdG9gbIZtuVbYKj722HiymhEARA=;
        b=tKSpSxIL6fh0BpEipGYGP/M9gTvmQt5AtmBLAQcgswGvCzeuE5KbIfbTwZmHAAMSBd
         BwxDJqpKzR1SxwBMlKWqySSBaOVZYrgouYXxoYf5w83C333dOMijwAqnesyjeFe/2Qbz
         XFZGseEFf2d4ecnO2m2R3RkY5ciq6c9T2q/nDIko6SaK/c3Xb5mfhbOP60pNOhbgBDon
         4EhmksDQbXG07MRZDK/iAALSi9Zl9gSVBUVO8cFgaJQhg9f6FMbciFUXsnujcbLZcjix
         mMWQHk5+81RoT7sb8j6VT2+WUeYVKgrnRD7tDdH5s9oiK3wy5FolTSanANsYcEutoLU6
         qezQ==
X-Gm-Message-State: APjAAAVOO1FfQPjX+HOuyf+60Ki1XHkOxAcuG4tYuRMCHnXpqnxLYh34
        /Tk+y+aNeUPD6iLrmNvFPbw=
X-Google-Smtp-Source: APXvYqxs1JOIrZS+B1D1uxN9/NKBCJm9FhFVClJ0HxVSnD7EoTe9yCjGxORXiqR02XyzYLRlh8Q/DQ==
X-Received: by 2002:a1c:9802:: with SMTP id a2mr6950453wme.117.1582933113342;
        Fri, 28 Feb 2020 15:38:33 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id q1sm13762512wrw.5.2020.02.28.15.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 15:38:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] io_uring/io-wq: pass *work instead of **workptr
Date:   Sat, 29 Feb 2020 02:37:26 +0300
Message-Id: <3db3cb928e4bc7670a0e7e105b2b417897c4b96e.1582932860.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582932860.git.asml.silence@gmail.com>
References: <cover.1582932860.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now work->func() never modifies passed workptr.
Remove extra indirection by passing struct work*
instead of a pointer to that.

Also, it leaves (work != old_work) dancing in io_worker_handle_work(),
as it'll be reused shortly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    | 11 +++++------
 fs/io-wq.h    |  2 +-
 fs/io_uring.c | 25 ++++++++++++-------------
 3 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index a05c32df2046..a830eddaffbe 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -503,7 +503,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		}
 
 		old_work = work;
-		work->func(&work);
+		work->func(work);
 
 		spin_lock_irq(&worker->lock);
 		worker->cur_work = NULL;
@@ -756,7 +756,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	 */
 	if (unlikely(!io_wq_can_queue(wqe, acct, work))) {
 		work->flags |= IO_WQ_WORK_CANCEL;
-		work->func(&work);
+		work->func(work);
 		return;
 	}
 
@@ -896,7 +896,7 @@ static enum io_wq_cancel io_wqe_cancel_cb_work(struct io_wqe *wqe,
 
 	if (found) {
 		work->flags |= IO_WQ_WORK_CANCEL;
-		work->func(&work);
+		work->func(work);
 		return IO_WQ_CANCEL_OK;
 	}
 
@@ -972,7 +972,7 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
 
 	if (found) {
 		work->flags |= IO_WQ_WORK_CANCEL;
-		work->func(&work);
+		work->func(work);
 		return IO_WQ_CANCEL_OK;
 	}
 
@@ -1049,9 +1049,8 @@ struct io_wq_flush_data {
 	struct completion done;
 };
 
-static void io_wq_flush_func(struct io_wq_work **workptr)
+static void io_wq_flush_func(struct io_wq_work *work)
 {
-	struct io_wq_work *work = *workptr;
 	struct io_wq_flush_data *data;
 
 	data = container_of(work, struct io_wq_flush_data, work);
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 001194aef6ae..508615af4552 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -68,7 +68,7 @@ struct io_wq_work {
 		struct io_wq_work_node list;
 		void *data;
 	};
-	void (*func)(struct io_wq_work **);
+	void (*func)(struct io_wq_work *);
 	struct files_struct *files;
 	struct mm_struct *mm;
 	const struct cred *creds;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index ee75e503964d..54dfa9b71864 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -793,7 +793,7 @@ static const struct io_op_def io_op_defs[] = {
 	}
 };
 
-static void io_wq_submit_work(struct io_wq_work **workptr);
+static void io_wq_submit_work(struct io_wq_work *work);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
 static void __io_double_put_req(struct io_kiocb *req);
@@ -2568,9 +2568,9 @@ static void __io_fsync(struct io_kiocb *req)
 	io_put_req(req);
 }
 
-static void io_fsync_finish(struct io_wq_work **workptr)
+static void io_fsync_finish(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
 	if (io_req_cancelled(req))
 		return;
@@ -2604,9 +2604,9 @@ static void __io_fallocate(struct io_kiocb *req)
 	io_put_req(req);
 }
 
-static void io_fallocate_finish(struct io_wq_work **workptr)
+static void io_fallocate_finish(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
 	__io_fallocate(req);
 }
@@ -2970,9 +2970,9 @@ static void __io_close_finish(struct io_kiocb *req)
 	io_put_req(req);
 }
 
-static void io_close_finish(struct io_wq_work **workptr)
+static void io_close_finish(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
 	/* not cancellable, don't do io_req_cancelled() */
 	__io_close_finish(req);
@@ -3039,9 +3039,9 @@ static void __io_sync_file_range(struct io_kiocb *req)
 }
 
 
-static void io_sync_file_range_finish(struct io_wq_work **workptr)
+static void io_sync_file_range_finish(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
 	if (io_req_cancelled(req))
 		return;
@@ -3409,9 +3409,9 @@ static int __io_accept(struct io_kiocb *req, bool force_nonblock)
 	return 0;
 }
 
-static void io_accept_finish(struct io_wq_work **workptr)
+static void io_accept_finish(struct io_wq_work *work)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
 	io_put_req(req);
 
@@ -4646,9 +4646,8 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static void io_wq_submit_work(struct io_wq_work **workptr)
+static void io_wq_submit_work(struct io_wq_work *work)
 {
-	struct io_wq_work *work = *workptr;
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	int ret = 0;
 
-- 
2.24.0

