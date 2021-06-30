Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DB13B89EB
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 22:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhF3U47 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 16:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhF3U46 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 16:56:58 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494C2C0617A8
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:54:29 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id q18-20020a1ce9120000b02901f259f3a250so2573696wmc.2
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0p0meUSwF/Oxw6Zt+qddmm/HxkjzzLrP0pkugqwTm+E=;
        b=PeN7rNSKBUePrs79fCL5mBk9swWKsf7W7r7EobIk3KUH1nv66TvdfkAQo3jy3s3jpI
         bmzkLaHM+cqVr6CK++Ft4JCl9GaUNhz+i+jtmEMFNVhHnjkJpwAFNwCqU6LXtot/n0LI
         q9UuK+b2xUshmTREQbwmxR/45N8uvfU1OuMSlurC6YORqkMb5vcLIkSuVGv/1Wq11vqe
         iWunU5Zs/O853CTXD+MaNl7XP0ZKonRpjbvrCDzxcSlz33ZV7zPtVxVCOqQgx7Dr9RY2
         PRWL0N6JG8Y1R9nvbNn2fdO+dPYek2wCNSX6VlpixaQ0f1jsO5tr7Cg9j5maCWcBLTX5
         CvMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0p0meUSwF/Oxw6Zt+qddmm/HxkjzzLrP0pkugqwTm+E=;
        b=OqY7neGJ+gaYsmUzLC2LLHyF++NnPtmJ5mLUScgUmKSrG+A8SutI4KpFNc108Jr2HX
         wHvfuA7GKUTLkngHZiSfdGhRC/xtGn+1rLPsq+92hM8rd+9YqUcukxm4qs+Fou9u7rZX
         BLl5YUPPzxlVYCNQgP30xdinVos+tGdR7eWkJxd5hhH+kaTXHcuFdE5OF8SElLRRnafv
         ar8psMX19h+aVxw2NKPzx/FMnrWPJLrOoH2bpwxKVzaw+ltWD6LJAkL+bq937t0R4Bz7
         U/uyml2SJO0m1YQdTMUzhUSgIup6AeZuazXKvb+9P+TV0dseQqdiYBMtOmwCC9C54m89
         f2TA==
X-Gm-Message-State: AOAM531YQcLryLJb3lJWYaicYYKg4IbsXf2gcKwhRYgkQAl/hxD5PhHl
        n30zmSvcCvlr3PhJopRYHHM=
X-Google-Smtp-Source: ABdhPJzDHwj4vXCDhOV5p+ixCGHRQAQNNU19bhNMGNEUmYizce4blimlR1824q5SCDiDwuQ7ROyXhQ==
X-Received: by 2002:a05:600c:40ca:: with SMTP id m10mr38997093wmh.105.1625086467945;
        Wed, 30 Jun 2021 13:54:27 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.26])
        by smtp.gmail.com with ESMTPSA id p2sm22099087wro.16.2021.06.30.13.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 13:54:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: fix stuck fallback reqs
Date:   Wed, 30 Jun 2021 21:54:03 +0100
Message-Id: <52213538759af2d500ca2060160620c406bb83d1.1625086418.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1625086418.git.asml.silence@gmail.com>
References: <cover.1625086418.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When task_work_add() fails, we use ->exit_task_work to queue the work.
That will be run only in the cancellation path, which happens either
when the ctx is dying or one of tasks with inflight requests is exiting
or executing. There is a good chance that such a request would just get
stuck in the list potentially hodling a file, all io_uring rsrc
recycling or some other resources. Nothing terrible, it'll go away at
some point, but we don't want to lock them up for longer than needed.

Replace that hand made ->exit_task_work with delayed_work + llist
inspired by fput_many().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 61 +++++++++++++++++----------------------------------
 1 file changed, 20 insertions(+), 41 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 92f85d4385a2..08ca835629ce 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -465,7 +465,8 @@ struct io_ring_ctx {
 		struct mm_struct		*mm_account;
 
 		/* ctx exit and cancelation */
-		struct callback_head		*exit_task_work;
+		struct llist_head		fallback_llist;
+		struct delayed_work		fallback_work;
 		struct work_struct		exit_work;
 		struct list_head		tctx_list;
 		struct completion		ref_comp;
@@ -885,6 +886,8 @@ struct io_kiocb {
 	struct io_wq_work		work;
 	const struct cred		*creds;
 
+	struct llist_node		fallback_node;
+
 	/* store used ubuf, so we can prevent reloading */
 	struct io_mapped_ubuf		*imu;
 };
@@ -1100,6 +1103,8 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx);
 static bool io_poll_remove_waitqs(struct io_kiocb *req);
 static int io_req_prep_async(struct io_kiocb *req);
 
+static void io_fallback_req_func(struct work_struct *unused);
+
 static struct kmem_cache *req_cachep;
 
 static const struct file_operations io_uring_fops;
@@ -1231,6 +1236,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	INIT_LIST_HEAD(&ctx->submit_state.comp.free_list);
 	INIT_LIST_HEAD(&ctx->locked_free_list);
+	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
@@ -2028,44 +2034,12 @@ static int io_req_task_work_add(struct io_kiocb *req)
 	return ret;
 }
 
-static bool io_run_task_work_head(struct callback_head **work_head)
-{
-	struct callback_head *work, *next;
-	bool executed = false;
-
-	do {
-		work = xchg(work_head, NULL);
-		if (!work)
-			break;
-
-		do {
-			next = work->next;
-			work->func(work);
-			work = next;
-			cond_resched();
-		} while (work);
-		executed = true;
-	} while (1);
-
-	return executed;
-}
-
-static void io_task_work_add_head(struct callback_head **work_head,
-				  struct callback_head *task_work)
-{
-	struct callback_head *head;
-
-	do {
-		head = READ_ONCE(*work_head);
-		task_work->next = head;
-	} while (cmpxchg(work_head, head, task_work) != head);
-}
-
 static void io_req_task_work_add_fallback(struct io_kiocb *req,
 					  task_work_func_t cb)
 {
 	init_task_work(&req->task_work, cb);
-	io_task_work_add_head(&req->ctx->exit_task_work, &req->task_work);
+	if (llist_add(&req->fallback_node, &req->ctx->fallback_llist))
+		schedule_delayed_work(&req->ctx->fallback_work, 1);
 }
 
 static void io_req_task_cancel(struct callback_head *cb)
@@ -2514,6 +2488,17 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 }
 #endif
 
+static void io_fallback_req_func(struct work_struct *work)
+{
+	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
+						fallback_work.work);
+	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
+	struct io_kiocb *req, *tmp;
+
+	llist_for_each_entry_safe(req, tmp, node, fallback_node)
+		req->task_work.func(&req->task_work);
+}
+
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 			     unsigned int issue_flags)
 {
@@ -8956,11 +8941,6 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 	return -EINVAL;
 }
 
-static inline bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
-{
-	return io_run_task_work_head(&ctx->exit_task_work);
-}
-
 struct io_tctx_exit {
 	struct callback_head		task_work;
 	struct completion		completion;
@@ -9225,7 +9205,6 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		ret |= io_kill_timeouts(ctx, task, cancel_all);
 		if (task)
 			ret |= io_run_task_work();
-		ret |= io_run_ctx_fallback(ctx);
 		if (!ret)
 			break;
 		cond_resched();
-- 
2.32.0

