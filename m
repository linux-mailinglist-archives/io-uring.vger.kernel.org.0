Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7852A2FC8AA
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 04:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbhATDVv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 22:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731781AbhATCg6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 21:36:58 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D16C0613C1
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 18:36:11 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id l12so16384681wry.2
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 18:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1jFhctExuLWMGWfEU2Fg+esgl7ADG6JNXsRJ+YCJcpo=;
        b=N0PzeE7XAQ6GI7Dy0KsBCVXdCUYX0H/tEAOabkqvvhPCpC/IxKg6oRviAPJuWru0IP
         OHLLIBeWrcfH6mJ6Lh+tIAFbca+9/i/h0+j/uuFrkJVj0L0SOjhe3EoN9d5ueNm68wAJ
         JEiaLIaAu1eegMyicyTgFRPKtxEoEx9GO8bjbD1DjpwCfcLneyFQO5saCGHSzCWDk4Pu
         BIVdt9Mu514UY39ngxJU81MKIjPA4xBNmayPg5xo+tP2P03K9GpPjxWX3xnPq2yxp/g2
         ni8axRqTwHDHIplGIl5SVFKNCY8+LZikjUvSsmCHYC1jzQWCFLFHoa1awN2vHULAiBIp
         kgxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1jFhctExuLWMGWfEU2Fg+esgl7ADG6JNXsRJ+YCJcpo=;
        b=AFTBiCeJlpDR7kodCA/fMXNI4hgV6A5SKDo+vxDMNpPeS7/2uXoTj+jen9RSmJHfrH
         IYdezRHizBuVM8urclRhz33FRiST9g4pMeuqk884gxz8rI5QBtwAroFpj0GFBgP41jn9
         y8wvQi3D1+sAR3xTfbr86SA8I7TJikkyUm0gBnhbFX3vD2tLpy9I7y13YNELJAAN1I+h
         AHNZT/QuNByU9aOZsF5HBTtnFKWcbsSNi6E3jJviglrtkQX4aqREG/+30TwumQJ80YdS
         SLfdFR569vMApN+T81XrXhFRVdZ6bJhy6QeJoaud56oH8NpcP9Z89NCLG/DwNPTU0QTY
         BZLw==
X-Gm-Message-State: AOAM533wng+/WrjjqOCUUBQmaFlNqmyWBgRk1GKSFVQLGEKe1CD7pxGs
        zrX+z15H/jIcFSFNJ4faurQ0IQAST5+JXg==
X-Google-Smtp-Source: ABdhPJwgqnfQImqqNVZQEbLjfevUpN6EU/hO5VHEyILZCdg5gBB5KpdmXCrZmfs+gE+U8S2XjN0b1Q==
X-Received: by 2002:adf:fa86:: with SMTP id h6mr6815697wrr.103.1611110169848;
        Tue, 19 Jan 2021 18:36:09 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id v20sm1082767wra.19.2021.01.19.18.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 18:36:09 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: remove cancel_files and inflight tracking
Date:   Wed, 20 Jan 2021 02:32:23 +0000
Message-Id: <f8d1b90ce2a31b3ce72319ab48f47a8c4f1fa918.1611109718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611109718.git.asml.silence@gmail.com>
References: <cover.1611109718.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't do files-specific cancellations anymore, so we can kill
io_uring_cancel_files() and old tracking scheme where we keep all such
requests in ->inflight_list and synchronise it by ->inflight_lock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 63 ++-------------------------------------------------
 1 file changed, 2 insertions(+), 61 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5bfcb72c916e..0c886ef49920 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -389,9 +389,6 @@ struct io_ring_ctx {
 		struct hlist_head	*cancel_hash;
 		unsigned		cancel_hash_bits;
 		bool			poll_multi_file;
-
-		spinlock_t		inflight_lock;
-		struct list_head	inflight_list;
 	} ____cacheline_aligned_in_smp;
 
 	struct delayed_work		rsrc_put_work;
@@ -734,10 +731,7 @@ struct io_kiocb {
 	struct io_kiocb			*link;
 	struct percpu_ref		*fixed_rsrc_refs;
 
-	/*
-	 * 1. used with ctx->iopoll_list with reads/writes
-	 * 2. to track reqs with ->files (see io_op_def::file_table)
-	 */
+	/* tracks iopoll requests, see ctx->iopoll_list */
 	struct list_head		inflight_entry;
 	struct callback_head		task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
@@ -1331,8 +1325,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
-	spin_lock_init(&ctx->inflight_lock);
-	INIT_LIST_HEAD(&ctx->inflight_list);
 	spin_lock_init(&ctx->rsrc_ref_lock);
 	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
@@ -1451,7 +1443,6 @@ static bool io_grab_identity(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	struct io_identity *id = req->work.identity;
-	struct io_ring_ctx *ctx = req->ctx;
 
 	if (def->work_flags & IO_WQ_WORK_FSIZE) {
 		if (id->fsize != rlimit(RLIMIT_FSIZE))
@@ -1508,10 +1499,6 @@ static bool io_grab_identity(struct io_kiocb *req)
 		atomic_inc(&id->files->count);
 		get_nsproxy(id->nsproxy);
 		req->flags |= REQ_F_INFLIGHT;
-
-		spin_lock_irq(&ctx->inflight_lock);
-		list_add(&req->inflight_entry, &ctx->inflight_list);
-		spin_unlock_irq(&ctx->inflight_lock);
 		req->work.flags |= IO_WQ_WORK_FILES;
 	}
 	if (!(req->work.flags & IO_WQ_WORK_MM) &&
@@ -6155,15 +6142,10 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 static void io_req_drop_files(struct io_kiocb *req)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_task *tctx = req->task->io_uring;
-	unsigned long flags;
 
 	put_files_struct(req->work.identity->files);
 	put_nsproxy(req->work.identity->nsproxy);
-	spin_lock_irqsave(&ctx->inflight_lock, flags);
-	list_del(&req->inflight_entry);
-	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
 	req->work.flags &= ~IO_WQ_WORK_FILES;
 	if (atomic_read(&tctx->in_idle))
@@ -8919,43 +8901,6 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 	}
 }
 
-static void io_uring_cancel_files(struct io_ring_ctx *ctx,
-				  struct task_struct *task,
-				  struct files_struct *files)
-{
-	while (!list_empty_careful(&ctx->inflight_list)) {
-		struct io_task_cancel cancel = { .task = task, .files = files };
-		struct io_kiocb *req;
-		DEFINE_WAIT(wait);
-		bool found = false;
-
-		spin_lock_irq(&ctx->inflight_lock);
-		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (req->task != task ||
-			    req->work.identity->files != files)
-				continue;
-			found = true;
-			break;
-		}
-		if (found)
-			prepare_to_wait(&task->io_uring->wait, &wait,
-					TASK_UNINTERRUPTIBLE);
-		spin_unlock_irq(&ctx->inflight_lock);
-
-		/* We need to keep going until we don't find a matching req */
-		if (!found)
-			break;
-
-		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
-		io_poll_remove_all(ctx, task, files);
-		io_kill_timeouts(ctx, task, files);
-		/* cancellations _may_ trigger task work */
-		io_run_task_work();
-		schedule();
-		finish_wait(&task->io_uring->wait, &wait);
-	}
-}
-
 static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 					    struct task_struct *task)
 {
@@ -9019,11 +8964,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 
 	io_cancel_defer_files(ctx, task, files);
 	io_cqring_overflow_flush(ctx, true, task, files);
-
-	if (!files)
-		__io_uring_cancel_task_requests(ctx, task);
-	else
-		io_uring_cancel_files(ctx, task, files);
+	__io_uring_cancel_task_requests(ctx, task);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);
-- 
2.24.0

