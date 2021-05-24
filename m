Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FF438F684
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 01:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhEXXxK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 19:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhEXXxJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 19:53:09 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D452C06138A
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:40 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso733074wmc.1
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=klUJPrKjXipoTc2jn0OCW7ocxfKxOS9Q/bwu2HA5+Y0=;
        b=bBgt19vJhS2LAQboMMkYrXrqGE7vKnqaLzV2Imi5Mj9aDilGIYWNopdu72Zihyh9vi
         +/st9D7eXy/gWfW/0BYk4C7C0UnZRzqPWsXnNrxjv38oHvoupn0VhWVGRnT7MBeyI9B6
         Sj8YyMtU+JIXMS1Q/XvfAQ1Jh7y2t20GxZCsdy03riEY3xs/Ve3Xt1xb/QCRKLLmpV1D
         SgnwcBC+1NF836F8wAhZtLdSsfbqnoiL4QYeYuhbCRgx+vYOjtFbSK3qMVsUOFrZwEV4
         o6+4IhMbtulcUAV2XRNaUMBkhTeNQIycBKsmVfsDgM4+gtXyef8m4ZFvm6v9nFd65kte
         U2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=klUJPrKjXipoTc2jn0OCW7ocxfKxOS9Q/bwu2HA5+Y0=;
        b=kFy2PJl7dloldsBkJo0nUtt/cduu6dGJPDbGMZYfPAUnwyIrbfXs+Yv3uRDSfGFBnB
         Z8vCozX4qdRpr4WoloKqkwUhYIUz5etcxqM8O0KvkrCxTg+KVzRhQIj7yGr9ydZho6eW
         GDle0eCljQmA5nUXyl+u2c442ivTq2/qSz65mx/WVz1It3CcFvYjwmY4euyzD+eIV7wa
         3VfkkjqtrfnSPT9wFC/3mrHDYeEoWnkdFwbC4bH4shnwDjOaHdR6JkXkGxe1H9oqUjMb
         5/uqohpZhIShq801+g/bgPoE+gstEhgwrYq260LG4TE/6F1PmOWOn5KMIkWptHjkF4ve
         J+dA==
X-Gm-Message-State: AOAM532V/08LkoZaLoTKoSDFMU1gmzk1cJwpDhDAMLBDvKtWjLhRc0Ze
        bOdS3PMzuuIlZPrSLaKMOwQ=
X-Google-Smtp-Source: ABdhPJyHSYGN3v+TZx+4saRUqau0RWyE0OL/JPUlLpGyG+Q63aD/Cmxd1lLoU2XPRkdUEUztqdhwhg==
X-Received: by 2002:a05:600c:4f15:: with SMTP id l21mr21188704wmq.37.1621900298784;
        Mon, 24 May 2021 16:51:38 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id f7sm8961069wmq.30.2021.05.24.16.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:51:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 12/13] io_uring: cache task struct refs
Date:   Tue, 25 May 2021 00:51:11 +0100
Message-Id: <d124d2af721af9d9d5fa7c187cdee9431b7fe831.1621899872.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621899872.git.asml.silence@gmail.com>
References: <cover.1621899872.git.asml.silence@gmail.com>
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
index 2b2d70a58a87..a95d55a0f9be 100644
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
@@ -9097,6 +9104,16 @@ static void io_uring_try_cancel(bool cancel_all)
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
@@ -9112,6 +9129,7 @@ static void io_uring_cancel_sqpoll(struct io_sq_data *sqd)
 
 	WARN_ON_ONCE(!sqd || sqd->thread != current);
 
+	io_uring_drop_tctx_refs(current);
 	atomic_inc(&tctx->in_idle);
 	do {
 		/* read completions before cancelations */
@@ -9149,6 +9167,7 @@ void __io_uring_cancel(struct files_struct *files)
 		io_wq_exit_start(tctx->io_wq);
 
 	/* make sure overflow events are dropped */
+	io_uring_drop_tctx_refs(current);
 	atomic_inc(&tctx->in_idle);
 	do {
 		/* read completions before cancelations */
-- 
2.31.1

