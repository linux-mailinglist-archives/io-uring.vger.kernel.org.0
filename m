Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7213A5B60
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 03:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhFNBjO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Jun 2021 21:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbhFNBjO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Jun 2021 21:39:14 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BA0C0613A3
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:36:56 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id h22-20020a05600c3516b02901a826f84095so11789344wmq.5
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=U/CpU13PTwiUlLR29dkB8bGBkeFPP7Wf6o2s0Nv29jA=;
        b=tk7wHWgc69kwfIE0TT3bE8BwtS5XfL1IDETqrVsMPKZYtbm/w8ODZtiAVcAP1hk3fq
         TherYvzeimcvqPw8MbIVgzfQHfi9rv5LYEJqTWLCApaNdzEf7kSeoL5XEENa6r0cWetL
         BkQom7fDu19EoGpH/UfoTg2asijeKoogCDUHMN9XnSZl2lC+4kIdvYSpZb+9/FVKJEzt
         t3I3XmRKyEACkSLiXzgVtqzztBOdOgjTrV2NxSrwgSnUI15r3+W5JEN/uQ27EyDViHBb
         fq5F6/Vr78JK4sSihIymBI3MjrFd2TJ9WRi1DEoyAEFswXeu0CtNqwujnY3UsAgVfogM
         QhdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U/CpU13PTwiUlLR29dkB8bGBkeFPP7Wf6o2s0Nv29jA=;
        b=W6fkl6DizyEUrVylyHrhzIaePCpXBwwP7zi1TuPeG0HZRYayK3zj2MGPsvaMyGGKq6
         9/5q8PrW5ctmLnqySQRiFo3LVmXYO8PRkhMnO6TWuGbfqkwGJsqYwvzOt/3agT4hW7Jw
         6XSRG/ipte/Q7zKycfz4iM+lzVlLQTiYvNQ2KVbdoS43CkLH0fr4BoPMCAI2gyz4cfS+
         qYOzP6ERNisYQj6kQ9gGmE3FqKPqWFLSg9KQ+kY49Tdjxfl0FlQEwqp1Uv1Bbl8YsCCB
         VNVOD02CyLGzCh1OpcZ1PVbGxyN7MG4PP+dgjJ6VQsY1BxPOyE2OpzzdHekDWTxe2peH
         oz1g==
X-Gm-Message-State: AOAM531/zp6iGmHSb9WH+X7/+8NYnXSiXM21fk+23Ev4QDLWsN1BwLcR
        T3UuSfAD8Ch5h+cTWQ0kagqz38Fdr4gTTA==
X-Google-Smtp-Source: ABdhPJzHP4o5wG1X/Ndz/3llYm/TPb1v+ZCP1xcfxJPtcXOd5ZMU4t9d4JidqtH78wbA+NU+aoOfmg==
X-Received: by 2002:a7b:cf2e:: with SMTP id m14mr13310585wmg.111.1623634614973;
        Sun, 13 Jun 2021 18:36:54 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id a9sm6795291wrv.37.2021.06.13.18.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:36:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/13] io_uring: cache task struct refs
Date:   Mon, 14 Jun 2021 02:36:22 +0100
Message-Id: <14b327b973410a3eec1f702ecf650e100513aca9.1623634181.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623634181.git.asml.silence@gmail.com>
References: <cover.1623634181.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

tctx in submission part is always synchronised because is executed from
the task's context, so we can batch allocate tctx/task references and
store them across syscall boundaries. It avoids enough of operations,
including an atomic for getting task ref and a percpu_counter_add()
function call, which still fallback to spinlock for large batching
cases (around >=32). Should be good for SQPOLL submitting in small
portions and coming at some moment bpf submissions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 692c91d03054..23b15ed98815 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -110,6 +110,8 @@
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
 				IOSQE_BUFFER_SELECT)
 
+#define IO_TCTX_REFS_CACHE_NR	(1U << 10)
+
 struct io_uring {
 	u32 head ____cacheline_aligned_in_smp;
 	u32 tail ____cacheline_aligned_in_smp;
@@ -472,6 +474,7 @@ struct io_ring_ctx {
 
 struct io_uring_task {
 	/* submission side */
+	int			cached_refs;
 	struct xarray		xa;
 	struct wait_queue_head	wait;
 	const struct io_ring_ctx *last;
@@ -6702,16 +6705,23 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 {
+	struct io_uring_task *tctx;
 	int submitted = 0;
 
 	/* make sure SQ entry isn't read before tail */
 	nr = min3(nr, ctx->sq_entries, io_sqring_entries(ctx));
-
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
 
-	percpu_counter_add(&current->io_uring->inflight, nr);
-	refcount_add(nr, &current->usage);
+	tctx = current->io_uring;
+	tctx->cached_refs -= nr;
+	if (unlikely(tctx->cached_refs < 0)) {
+		unsigned int refill = -tctx->cached_refs + IO_TCTX_REFS_CACHE_NR;
+
+		percpu_counter_add(&tctx->inflight, refill);
+		refcount_add(refill, &current->usage);
+		tctx->cached_refs += refill;
+	}
 	io_submit_state_start(&ctx->submit_state, nr);
 
 	while (submitted < nr) {
@@ -6737,12 +6747,10 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 	if (unlikely(submitted != nr)) {
 		int ref_used = (submitted == -EAGAIN) ? 0 : submitted;
-		struct io_uring_task *tctx = current->io_uring;
 		int unused = nr - ref_used;
 
+		current->io_uring->cached_refs += unused;
 		percpu_ref_put_many(&ctx->refs, unused);
-		percpu_counter_sub(&tctx->inflight, unused);
-		put_task_struct_many(current, unused);
 	}
 
 	io_submit_state_end(&ctx->submit_state, ctx);
@@ -7924,7 +7932,7 @@ static int io_uring_alloc_task_context(struct task_struct *task,
 	struct io_uring_task *tctx;
 	int ret;
 
-	tctx = kmalloc(sizeof(*tctx), GFP_KERNEL);
+	tctx = kzalloc(sizeof(*tctx), GFP_KERNEL);
 	if (unlikely(!tctx))
 		return -ENOMEM;
 
@@ -7944,13 +7952,11 @@ static int io_uring_alloc_task_context(struct task_struct *task,
 
 	xa_init(&tctx->xa);
 	init_waitqueue_head(&tctx->wait);
-	tctx->last = NULL;
 	atomic_set(&tctx->in_idle, 0);
 	atomic_set(&tctx->inflight_tracked, 0);
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
-	tctx->task_state = 0;
 	init_task_work(&tctx->task_work, tctx_task_work);
 	return 0;
 }
@@ -7961,6 +7967,7 @@ void __io_uring_free(struct task_struct *tsk)
 
 	WARN_ON_ONCE(!xa_empty(&tctx->xa));
 	WARN_ON_ONCE(tctx->io_wq);
+	WARN_ON_ONCE(tctx->cached_refs);
 
 	percpu_counter_destroy(&tctx->inflight);
 	kfree(tctx);
@@ -9105,6 +9112,16 @@ static void io_uring_try_cancel(bool cancel_all)
 	}
 }
 
+static void io_uring_drop_tctx_refs(struct task_struct *task)
+{
+	struct io_uring_task *tctx = task->io_uring;
+	unsigned int refs = tctx->cached_refs;
+
+	tctx->cached_refs = 0;
+	percpu_counter_sub(&tctx->inflight, refs);
+	put_task_struct_many(task, refs);
+}
+
 /* should only be called by SQPOLL task */
 static void io_uring_cancel_sqpoll(struct io_sq_data *sqd)
 {
@@ -9120,6 +9137,7 @@ static void io_uring_cancel_sqpoll(struct io_sq_data *sqd)
 
 	WARN_ON_ONCE(!sqd || sqd->thread != current);
 
+	io_uring_drop_tctx_refs(current);
 	atomic_inc(&tctx->in_idle);
 	do {
 		/* read completions before cancelations */
@@ -9157,6 +9175,7 @@ void __io_uring_cancel(struct files_struct *files)
 		io_wq_exit_start(tctx->io_wq);
 
 	/* make sure overflow events are dropped */
+	io_uring_drop_tctx_refs(current);
 	atomic_inc(&tctx->in_idle);
 	do {
 		/* read completions before cancelations */
-- 
2.31.1

