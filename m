Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4AB3A5B5D
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 03:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbhFNBjA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Jun 2021 21:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbhFNBi7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Jun 2021 21:38:59 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E93C061574
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:36:57 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id m18so12619942wrv.2
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tKWcscbXDB2ke6RbknYjb16Mh4jj5KYRyFdy7K7fpg4=;
        b=aaoDrSoEDzqSHYbGvsxBN21zK7QsVuT+lQAQE+23ZVAd30ZrgcAl7wMo1ffJ8UcdY5
         0mJ6ZNm8+aQlzMnSqOfZzOQGDOcRXZdh/w5mmF6rPtkk+Xh48HbGFJzHWuqInc3+sT9i
         hVlsaPOLOqnylUjVEu1z+K2jBRxFEMDnM2krWiCjzo2lHXJDeGykIPj/dIQJUU5vPI7p
         zCUZTarCMj1tenee9HaXe6Kb8X0VuEQonVkkVlEkj69i/+HYLXerT5srW4GYanvmOBFf
         bBdOABSmJaKBmU6OkMFlfq+5bB49yDqeIzbtVqL9hzFQUC6gvh3bZDTq/5C6YAPaBkgx
         flLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tKWcscbXDB2ke6RbknYjb16Mh4jj5KYRyFdy7K7fpg4=;
        b=j3zoChFRoDzZTDBam1XcgrHAGgfK0g5SOeRXtgSYqeHOjovQybYWLpMERhxcJQiAnf
         pb8fC1UYfjUtpqvnka40ORN4peHople11/8e2sySCb/VDx+i5b7yPNmVSTEj4kIpFUea
         aHx52Wd2V0Av2yUq8BQ7xCrao7Py/IoDejjl1swsoLG6kefQxcgBYSxprZKfyz85SgI3
         totuiBmws/U9Gox/4ut7yw6xXoXRBWWKz6cAVdWENHPcLVu33yahM114e4q5wvLZKfpD
         gib65r/Q/ZsaiOR1hi/nEyBEV5mR5uPDRSLXl09SenB7gSKv7wb/HdXH+rFXw8840NGM
         +J5w==
X-Gm-Message-State: AOAM533PUE7bhGYSUiF5Kv6B8bJMtNeZdY4wGpN4TOJt5IwMXtPaskWN
        pSEF+arUAZqlDfFH92xtIoM=
X-Google-Smtp-Source: ABdhPJzZsE9nSYXrKHK2j+NDQraGDd3rBG0DJLstZqGXB+EZNX3ebd86+BmrZKbsbmdywnbF+j+u7g==
X-Received: by 2002:a5d:648a:: with SMTP id o10mr15885707wri.274.1623634616217;
        Sun, 13 Jun 2021 18:36:56 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id a9sm6795291wrv.37.2021.06.13.18.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:36:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 12/13] io_uring: unify SQPOLL and user task cancellations
Date:   Mon, 14 Jun 2021 02:36:23 +0100
Message-Id: <adfe24d6dad4a3883a40eee54352b8b65ac851bb.1623634181.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623634181.git.asml.silence@gmail.com>
References: <cover.1623634181.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Merge io_uring_cancel_sqpoll() and __io_uring_cancel() as it's easier to
have a conditional ctx traverse inside than keeping them in sync.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 89 +++++++++++++++++----------------------------------
 1 file changed, 30 insertions(+), 59 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 23b15ed98815..23644179edd4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1036,7 +1036,7 @@ static void io_uring_del_tctx_node(unsigned long index);
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 bool cancel_all);
-static void io_uring_cancel_sqpoll(struct io_sq_data *sqd);
+static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 
 static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
@@ -6921,7 +6921,7 @@ static int io_sq_thread(void *data)
 		timeout = jiffies + sqd->sq_thread_idle;
 	}
 
-	io_uring_cancel_sqpoll(sqd);
+	io_uring_cancel_generic(true, sqd);
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 		io_ring_set_wakeup_flag(ctx);
@@ -9097,21 +9097,6 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 	return percpu_counter_sum(&tctx->inflight);
 }
 
-static void io_uring_try_cancel(bool cancel_all)
-{
-	struct io_uring_task *tctx = current->io_uring;
-	struct io_tctx_node *node;
-	unsigned long index;
-
-	xa_for_each(&tctx->xa, index, node) {
-		struct io_ring_ctx *ctx = node->ctx;
-
-		/* sqpoll task will cancel all its requests */
-		if (!ctx->sq_data)
-			io_uring_try_cancel_requests(ctx, current, cancel_all);
-	}
-}
-
 static void io_uring_drop_tctx_refs(struct task_struct *task)
 {
 	struct io_uring_task *tctx = task->io_uring;
@@ -9122,69 +9107,50 @@ static void io_uring_drop_tctx_refs(struct task_struct *task)
 	put_task_struct_many(task, refs);
 }
 
-/* should only be called by SQPOLL task */
-static void io_uring_cancel_sqpoll(struct io_sq_data *sqd)
+/*
+ * Find any io_uring ctx that this task has registered or done IO on, and cancel
+ * requests. @sqd should be not-null IIF it's an SQPOLL thread cancellation.
+ */
+static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_ring_ctx *ctx;
 	s64 inflight;
 	DEFINE_WAIT(wait);
 
+	WARN_ON_ONCE(sqd && sqd->thread != current);
+
 	if (!current->io_uring)
 		return;
 	if (tctx->io_wq)
 		io_wq_exit_start(tctx->io_wq);
 
-	WARN_ON_ONCE(!sqd || sqd->thread != current);
-
 	io_uring_drop_tctx_refs(current);
 	atomic_inc(&tctx->in_idle);
 	do {
 		/* read completions before cancelations */
-		inflight = tctx_inflight(tctx, false);
+		inflight = tctx_inflight(tctx, !cancel_all);
 		if (!inflight)
 			break;
-		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-			io_uring_try_cancel_requests(ctx, current, true);
 
-		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
-		/*
-		 * If we've seen completions, retry without waiting. This
-		 * avoids a race where a completion comes in before we did
-		 * prepare_to_wait().
-		 */
-		if (inflight == tctx_inflight(tctx, false))
-			schedule();
-		finish_wait(&tctx->wait, &wait);
-	} while (1);
-	atomic_dec(&tctx->in_idle);
-}
+		if (!sqd) {
+			struct io_tctx_node *node;
+			unsigned long index;
 
-/*
- * Find any io_uring fd that this task has registered or done IO on, and cancel
- * requests.
- */
-void __io_uring_cancel(struct files_struct *files)
-{
-	struct io_uring_task *tctx = current->io_uring;
-	DEFINE_WAIT(wait);
-	s64 inflight;
-	bool cancel_all = !files;
-
-	if (tctx->io_wq)
-		io_wq_exit_start(tctx->io_wq);
+			xa_for_each(&tctx->xa, index, node) {
+				/* sqpoll task will cancel all its requests */
+				if (node->ctx->sq_data)
+					continue;
+				io_uring_try_cancel_requests(node->ctx, current,
+							     cancel_all);
+			}
+		} else {
+			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+				io_uring_try_cancel_requests(ctx, current,
+							     cancel_all);
+		}
 
-	/* make sure overflow events are dropped */
-	io_uring_drop_tctx_refs(current);
-	atomic_inc(&tctx->in_idle);
-	do {
-		/* read completions before cancelations */
-		inflight = tctx_inflight(tctx, !cancel_all);
-		if (!inflight)
-			break;
-		io_uring_try_cancel(cancel_all);
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
-
 		/*
 		 * If we've seen completions, retry without waiting. This
 		 * avoids a race where a completion comes in before we did
@@ -9203,6 +9169,11 @@ void __io_uring_cancel(struct files_struct *files)
 	}
 }
 
+void __io_uring_cancel(struct files_struct *files)
+{
+	io_uring_cancel_generic(!files, NULL);
+}
+
 static void *io_uring_validate_mmap_request(struct file *file,
 					    loff_t pgoff, size_t sz)
 {
-- 
2.31.1

