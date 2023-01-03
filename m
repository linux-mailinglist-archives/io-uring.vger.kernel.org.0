Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE4565B992
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 04:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbjACDFe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 22:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236614AbjACDF3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 22:05:29 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE314B84B
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 19:05:28 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id m26-20020a05600c3b1a00b003d9811fcaafso15637412wms.5
        for <io-uring@vger.kernel.org>; Mon, 02 Jan 2023 19:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3isi2VSN68XETOdIovNlf5UDSVV24D7okjNbrEgjk1w=;
        b=DQj5EpaoYldJ2OIcu3ZY8D4w4fF3wVbSwm4ovnFW/OfnYsyESHvHY+J13I0n2cINzv
         ta8cn7ezpET6FGezls9RTN8hGonNi4ccmsAhTnG6O1S/42Jll/b3tY7zmeB4Br25MfGA
         qWwul0dllukBHqZXc1Ju1NXWGiPq6+bBGxUTUyEb6bGEYfTo9iX+rnt+oFadCugr6DQh
         kLN+rnwDku4y+ZBjXxC76h5V+ntM5F5JSJYy9LtZFPrFNc8A+tMzkj4626gLf2EQfWeH
         hxUE4oblYqUxWZZsKo0Sueoi1kxcCLjLP/sUbKQAQp01m7JhOZ0pRuFxGnNc0JBdI4D1
         P6FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3isi2VSN68XETOdIovNlf5UDSVV24D7okjNbrEgjk1w=;
        b=I4k3YuFnAyVf2zkKVThF82vD7t3JRXYaPeaC3e0JdRlyVJuhK0CAbh8wC8LWzwNyOi
         eSYblTcDG91LouAkF8obdJhFG9IQxyHYDK31qPkXyfV9CbyYxgwSbBkR93UX5lHqCAjA
         nDFdv0OBl6mpKerh0kDm99G4zrVU7auWzZN3cOukVbsfOagsYd6+xIbFUfCHWN6Fn13o
         P1m6IpG33AtvubgJIpakyf48KU+JlhfjBQcu02WTFT1RNSpoxF5omAcTOxoPuJNlCcTT
         7BbjufETX6IFK7cZ4ndDv7QpSqgNb+GCcMstyQuKGDGy/eHzGIA8NdwDwwFllqp9kiEF
         c3+w==
X-Gm-Message-State: AFqh2kq72wtdQLeN4tMwpOe934fdGcvfM0MUicrF8vdKqLb78chwCBne
        U20Cj6SqqB7FGG+wkMJpb9HgEoXS0DA=
X-Google-Smtp-Source: AMrXdXveNHlRPS2HEBsmQKG8c9uU8+zjvR77ByryE1mQpmVPjwcdqRLziLBlFgifKPiC0r+HDb2GsQ==
X-Received: by 2002:a05:600c:1f0e:b0:3cf:497c:c59e with SMTP id bd14-20020a05600c1f0e00b003cf497cc59emr30541872wmb.6.1672715127225;
        Mon, 02 Jan 2023 19:05:27 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bca41000000b003d1de805de5sm39967839wml.16.2023.01.02.19.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 19:05:27 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC v2 10/13] io_uring: add lazy poll_wq activation
Date:   Tue,  3 Jan 2023 03:04:01 +0000
Message-Id: <81e49bfc364b3b385fa405adf4065a41dcaf9141.1672713341.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672713341.git.asml.silence@gmail.com>
References: <cover.1672713341.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Even though io_poll_wq_wake()'s waitqueue_active reuses a barrier we do
for another waitqueue, it's not going to be the case in the future and
so we want to have a fast path for it when the ring has never been
polled.

Move poll_wq wake ups into __io_commit_cqring_flush() using a new flag
called ->poll_activated. The idea behind the flag is to set it when the
ring was polled for the first time. This requires additional sync to not
miss events, which is done here by using task_work for ->task_complete
rings, and by default enabling the flag for all other types of rings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  2 ++
 io_uring/io_uring.c            | 40 ++++++++++++++++++++++++++++++++++
 io_uring/io_uring.h            |  7 +++---
 3 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index cbcd3aaddd9d..1452ff745e5c 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -210,6 +210,7 @@ struct io_ring_ctx {
 		unsigned int		syscall_iopoll: 1;
 		/* all CQEs should be posted only by the submitter task */
 		unsigned int		task_complete: 1;
+		unsigned int		poll_activated: 1;
 	} ____cacheline_aligned_in_smp;
 
 	/* submission data */
@@ -357,6 +358,7 @@ struct io_ring_ctx {
 	u32				iowq_limits[2];
 	bool				iowq_limits_set;
 
+	struct callback_head		poll_wq_task_work;
 	struct list_head		defer_list;
 	unsigned			sq_thread_idle;
 	/* protected by ->completion_lock */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 42f512c42099..d2a3d9928ba3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -573,6 +573,8 @@ static void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
 
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
+	if (ctx->poll_activated)
+		io_poll_wq_wake(ctx);
 	if (ctx->off_timeout_used)
 		io_flush_timeouts(ctx);
 	if (ctx->drain_active) {
@@ -2764,11 +2766,42 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	kfree(ctx);
 }
 
+static __cold void io_lazy_activate_poll(struct callback_head *cb)
+{
+	struct io_ring_ctx *ctx = container_of(cb, struct io_ring_ctx,
+					       poll_wq_task_work);
+
+	mutex_lock(&ctx->uring_lock);
+	ctx->poll_activated = true;
+	mutex_unlock(&ctx->uring_lock);
+
+	/*
+	 * Wake ups for some events between start of polling and activation
+	 * might've been lost due to loose synchronisation.
+	 */
+	io_poll_wq_wake(ctx);
+	percpu_ref_put(&ctx->refs);
+}
+
 static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 {
 	struct io_ring_ctx *ctx = file->private_data;
 	__poll_t mask = 0;
 
+	if (unlikely(!ctx->poll_activated)) {
+		spin_lock(&ctx->completion_lock);
+		if (!ctx->poll_activated && !ctx->poll_wq_task_work.func &&
+		    ctx->submitter_task) {
+			init_task_work(&ctx->poll_wq_task_work, io_lazy_activate_poll);
+			percpu_ref_get(&ctx->refs);
+
+			if (task_work_add(ctx->submitter_task,
+					  &ctx->poll_wq_task_work, TWA_SIGNAL))
+				percpu_ref_put(&ctx->refs);
+		}
+		spin_unlock(&ctx->completion_lock);
+	}
+
 	poll_wait(file, &ctx->poll_wq, wait);
 	/*
 	 * synchronizes with barrier from wq_has_sleeper call in
@@ -3575,6 +3608,13 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	    !(ctx->flags & IORING_SETUP_SQPOLL))
 		ctx->task_complete = true;
 
+	/*
+	 * Lazy poll_wq activation requires sync with all potential completors,
+	 * ->task_complete guarantees a single completor
+	 */
+	if (!ctx->task_complete)
+		ctx->poll_activated = true;
+
 	/*
 	 * When SETUP_IOPOLL and SETUP_SQPOLL are both enabled, user
 	 * space applications don't need to do io completion events
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 645ace377d7e..e9819872c186 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -209,7 +209,7 @@ static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 
 static inline void io_poll_wq_wake(struct io_ring_ctx *ctx)
 {
-	if (waitqueue_active(&ctx->poll_wq))
+	if (wq_has_sleeper(&ctx->poll_wq))
 		__wake_up(&ctx->poll_wq, TASK_NORMAL, 0,
 				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
 }
@@ -217,8 +217,6 @@ static inline void io_poll_wq_wake(struct io_ring_ctx *ctx)
 /* requires smb_mb() prior, see wq_has_sleeper() */
 static inline void __io_cqring_wake(struct io_ring_ctx *ctx)
 {
-	io_poll_wq_wake(ctx);
-
 	/*
 	 * Trigger waitqueue handler on all waiters on our waitqueue. This
 	 * won't necessarily wake up all the tasks, io_should_wake() will make
@@ -319,7 +317,8 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 
 static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
-	if (unlikely(ctx->off_timeout_used || ctx->drain_active || ctx->has_evfd))
+	if (unlikely(ctx->off_timeout_used || ctx->drain_active ||
+		     ctx->has_evfd || ctx->poll_activated))
 		__io_commit_cqring_flush(ctx);
 }
 
-- 
2.38.1

