Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFC035B106
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhDKAvM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbhDKAvM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:12 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A700DC06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:50:56 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id j20-20020a05600c1914b029010f31e15a7fso6649196wmq.1
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/DhZUIVbXIGv74WNO+H61ukYppXgzZsQf5D8ADyfpSI=;
        b=arQQ1O1op74T2Yq3Cw7JGBtRNyUoK8VQ1cvSk+ZswaHOQljchnpIaDpTV96XdAUp6o
         xhC+YigZPqhTgV91KebBlUBNLN5d2DhXnZ32W0mYHITQfx1MSkxuxLD0dhGWXH3NwZk5
         N2D9CcKKp2HGiy9MkMD6t6iIoJ6Dkljw4//Fq/7Gs0Ulo5ZYE26zOElsKlQW7yJcQ/jl
         i1TU9NvyZP/oQFqB/pZCYMq+7cYjOtGhH3pgv5ZATzW8YAaRsH+yOW0RghwPw9pfLOyz
         3jWqGQdMS2DR/6iizR+M0Y7U9VjjQjj24TXs5lqhR5Q/Et2it0CuvD+ubn9rW5dof2Cq
         Qmwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/DhZUIVbXIGv74WNO+H61ukYppXgzZsQf5D8ADyfpSI=;
        b=pVqnjvWVPRA6YuprG0k0RCZADWPGg6TpG+dj4rSr5pBjMyoCrj4kZQwSY1hxUo8acC
         0f6lL+0Dp3PV7Kzss6blPGSvjNaJGXe5e+YK+tmTyjxqXsdgncCTJGvObgn6beK/YszD
         LQvvE9mbg58bmIjYRLb+PrgIS9RZuWyYrQ3VAIEm0l0OHasaTbq+ErrHe6wvg+rAE9Dk
         uG6561eVNTh4nmjZ6F/p8wHdBe9n3POev1QrI/Uh/YO/ibZ3xqvVq6oosmYfxM+1YGWj
         22MoXlmLS3JXb/uPYuzLhzd6J7bbNagYDj2rcy5i/UvdpvFtSjT+7r25VR8ch3aoDMQG
         /Mzg==
X-Gm-Message-State: AOAM533O+odW0d+ZgbbirqzltItzaEjRcmRiCa8I5/mjjYheEO4Z3Xd9
        KXGXfIPs3rfSgUqpIMxyhPhwAANI0H7fOw==
X-Google-Smtp-Source: ABdhPJyyVXLs2kwqcbzR5un6gCTdXvOffJEUZOORDwPYuhUDwh35UGMM98D+QcdVJmtR5wslxCNoUA==
X-Received: by 2002:a05:600c:b4b:: with SMTP id k11mr3233006wmr.180.1618102255499;
        Sat, 10 Apr 2021 17:50:55 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:50:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/16] io_uring: track inflight requests through counter
Date:   Sun, 11 Apr 2021 01:46:26 +0100
Message-Id: <3c2ee0863cd7eeefa605f3eaff4c1c461a6f1157.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of keeping requests in a inflight_list, just track them with a
per tctx atomic counter. Apart from it being much easier and more
consistent with task cancel, it frees ->inflight_entry from being shared
between iopoll and cancel-track, so less headache for us.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 56 +++++++++------------------------------------------
 1 file changed, 10 insertions(+), 46 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5c2364ceb6e1..3353a0b1032a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -444,9 +444,6 @@ struct io_ring_ctx {
 		struct hlist_head	*cancel_hash;
 		unsigned		cancel_hash_bits;
 		bool			poll_multi_file;
-
-		spinlock_t		inflight_lock;
-		struct list_head	inflight_list;
 	} ____cacheline_aligned_in_smp;
 
 	struct delayed_work		rsrc_put_work;
@@ -473,6 +470,7 @@ struct io_uring_task {
 	const struct io_ring_ctx *last;
 	struct io_wq		*io_wq;
 	struct percpu_counter	inflight;
+	atomic_t		inflight_tracked;
 	atomic_t		in_idle;
 
 	spinlock_t		task_lock;
@@ -833,10 +831,7 @@ struct io_kiocb {
 	struct io_kiocb			*link;
 	struct percpu_ref		*fixed_rsrc_refs;
 
-	/*
-	 * 1. used with ctx->iopoll_list with reads/writes
-	 * 2. to track reqs with ->files (see io_op_def::file_table)
-	 */
+	/* used with ctx->iopoll_list with reads/writes */
 	struct list_head		inflight_entry;
 	union {
 		struct io_task_work	io_task_work;
@@ -1164,8 +1159,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
-	spin_lock_init(&ctx->inflight_lock);
-	INIT_LIST_HEAD(&ctx->inflight_list);
 	spin_lock_init(&ctx->rsrc_ref_lock);
 	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
@@ -1194,14 +1187,9 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 
 static void io_req_track_inflight(struct io_kiocb *req)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
 	if (!(req->flags & REQ_F_INFLIGHT)) {
 		req->flags |= REQ_F_INFLIGHT;
-
-		spin_lock_irq(&ctx->inflight_lock);
-		list_add(&req->inflight_entry, &ctx->inflight_list);
-		spin_unlock_irq(&ctx->inflight_lock);
+		atomic_inc(&current->io_uring->inflight_tracked);
 	}
 }
 
@@ -1719,12 +1707,9 @@ static void io_dismantle_req(struct io_kiocb *req)
 		io_clean_op(req);
 
 		if (req->flags & REQ_F_INFLIGHT) {
-			struct io_ring_ctx *ctx = req->ctx;
-			unsigned long flags;
+			struct io_uring_task *tctx = req->task->io_uring;
 
-			spin_lock_irqsave(&ctx->inflight_lock, flags);
-			list_del(&req->inflight_entry);
-			spin_unlock_irqrestore(&ctx->inflight_lock, flags);
+			atomic_dec(&tctx->inflight_tracked);
 			req->flags &= ~REQ_F_INFLIGHT;
 		}
 	}
@@ -7917,6 +7902,7 @@ static int io_uring_alloc_task_context(struct task_struct *task,
 	init_waitqueue_head(&tctx->wait);
 	tctx->last = NULL;
 	atomic_set(&tctx->in_idle, 0);
+	atomic_set(&tctx->inflight_tracked, 0);
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
@@ -8855,20 +8841,6 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	}
 }
 
-static int io_uring_count_inflight(struct io_ring_ctx *ctx,
-				   struct task_struct *task,
-				   struct files_struct *files)
-{
-	struct io_kiocb *req;
-	int cnt = 0;
-
-	spin_lock_irq(&ctx->inflight_lock);
-	list_for_each_entry(req, &ctx->inflight_list, inflight_entry)
-		cnt += io_match_task(req, task, files);
-	spin_unlock_irq(&ctx->inflight_lock);
-	return cnt;
-}
-
 static int __io_uring_add_task_file(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx = current->io_uring;
@@ -8954,17 +8926,9 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	}
 }
 
-static s64 tctx_inflight_tracked(struct task_struct *task,
-				 struct files_struct *files)
+static s64 tctx_inflight_tracked(struct io_uring_task *tctx)
 {
-	struct io_uring_task *tctx = task->io_uring;
-	struct io_tctx_node *node;
-	unsigned long index;
-	s64 cnt = 0;
-
-	xa_for_each(&tctx->xa, index, node)
-		cnt += io_uring_count_inflight(node->ctx, task, files);
-	return cnt;
+	return atomic_read(&tctx->inflight_tracked);
 }
 
 static s64 tctx_inflight(struct io_uring_task *tctx)
@@ -9063,13 +9027,13 @@ void __io_uring_files_cancel(struct files_struct *files)
 	atomic_inc(&tctx->in_idle);
 	do {
 		/* read completions before cancelations */
-		inflight = tctx_inflight_tracked(current, files);
+		inflight = tctx_inflight_tracked(tctx);
 		if (!inflight)
 			break;
 		io_uring_try_cancel(files);
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
-		if (inflight == tctx_inflight_tracked(current, files))
+		if (inflight == tctx_inflight_tracked(tctx))
 			schedule();
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
-- 
2.24.0

