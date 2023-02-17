Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115A569AFF0
	for <lists+io-uring@lfdr.de>; Fri, 17 Feb 2023 16:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjBQP4k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Feb 2023 10:56:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjBQP4j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Feb 2023 10:56:39 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C14711BB
        for <io-uring@vger.kernel.org>; Fri, 17 Feb 2023 07:56:09 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id n13so581006ioz.11
        for <io-uring@vger.kernel.org>; Fri, 17 Feb 2023 07:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=decFKkAFL8wXX2ojuQ7Ywldi5Z7b4l79OF1al9tr1EQ=;
        b=jk0TA2tb+c3GXBeucrT6eBWINvHa2E9SHfd+BCuVI4cchKmphbxw9UrViT9931Lhql
         a0XwIVCnZSDHNT/8kdVVvVxyxJ8hcniQy/46rxuE9KwsyQypivplsiks3+zGYs8MPz11
         AEiuLWTX00G30NhjPHJ56mjtNWEfRwihYqAtKu1vxfy6L9fFa4TQEGqtlmd9X/HSQ9sb
         xPzVqIns7ThxXEtYZWxz9Tu36c4MyE9v8F18WozZDRLpO/ZsqSwisSSTWe16hZTUNH1B
         gvgWos4QBx9uKzJopYVpu0YMxuEywrBNXl56cMVaySQln+IOZYFdGueK28yBtw32QF3N
         3vzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=decFKkAFL8wXX2ojuQ7Ywldi5Z7b4l79OF1al9tr1EQ=;
        b=ApfD47d9N2LDxNSvv2D8Mr8r50WCaoB4sH54gbGA6vgrIEUZTsrFI6lhO6d5mrG2Nr
         jaOpzgA4+ErO4r2PYWVaNeTza98VryM+is10S+urR8JkDt7H54XqageLP9oe9MU8GA22
         YCRKCIgj9s/60aZUoBO6UivKXIeTqavrA1XevbYdCou+XcX0Im9wsjmtdfvarjqkz8aG
         dyq8EFcxFwHzENvK+/v8/o05g0XmST1KED7s0Su1bLKpX3D0swbec+/H+b7W41ZMHOn0
         PLLQ0MCFQTtEzclQDl3agOyWD0B//8yvsQ3fjmJeQu/oB1KPNgQ5cr7xBatPNT5G4hyU
         rvXQ==
X-Gm-Message-State: AO0yUKU98fkbghwSwG6RCOzxXASn/hEcWw7G0pQAy9eJ09LUTDVrQxC2
        03oVpM5mJ644dfkqg7iyM08sH6eFQK+g96Wy
X-Google-Smtp-Source: AK7set8PFfiezxWGCt1yswSWregiukuNBFdHmMoOALur53cEciPqn0HN6eNOmLTYzNzOEhzgR1H5nA==
X-Received: by 2002:a6b:da07:0:b0:740:7d21:d96f with SMTP id x7-20020a6bda07000000b007407d21d96fmr1305665iob.1.1676649367731;
        Fri, 17 Feb 2023 07:56:07 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d22-20020a0566022d5600b007046e9e138esm1551156iow.22.2023.02.17.07.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 07:56:06 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: rename 'in_idle' to 'in_cancel'
Date:   Fri, 17 Feb 2023 08:55:58 -0700
Message-Id: <20230217155600.157041-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230217155600.157041-1-axboe@kernel.dk>
References: <20230217155600.157041-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This better describes what it does - it's incremented when the task is
currently undergoing a cancelation operation, due to exiting or exec'ing.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            | 18 +++++++++---------
 io_uring/tctx.c                |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 0efe4d784358..00689c12f6ab 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -58,7 +58,7 @@ struct io_uring_task {
 
 	struct xarray			xa;
 	struct wait_queue_head		wait;
-	atomic_t			in_idle;
+	atomic_t			in_cancel;
 	atomic_t			inflight_tracked;
 	struct percpu_counter		inflight;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cbe06deb84ff..64e07df034d1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -719,7 +719,7 @@ static void io_put_task_remote(struct task_struct *task, int nr)
 	struct io_uring_task *tctx = task->io_uring;
 
 	percpu_counter_sub(&tctx->inflight, nr);
-	if (unlikely(atomic_read(&tctx->in_idle)))
+	if (unlikely(atomic_read(&tctx->in_cancel)))
 		wake_up(&tctx->wait);
 	put_task_struct_many(task, nr);
 }
@@ -1258,8 +1258,8 @@ void tctx_task_work(struct callback_head *cb)
 
 	ctx_flush_and_put(ctx, &uring_locked);
 
-	/* relaxed read is enough as only the task itself sets ->in_idle */
-	if (unlikely(atomic_read(&tctx->in_idle)))
+	/* relaxed read is enough as only the task itself sets ->in_cancel */
+	if (unlikely(atomic_read(&tctx->in_cancel)))
 		io_uring_drop_tctx_refs(current);
 
 	trace_io_uring_task_work_run(tctx, count, loops);
@@ -1291,7 +1291,7 @@ static void io_req_local_work_add(struct io_kiocb *req)
 	/* needed for the following wake up */
 	smp_mb__after_atomic();
 
-	if (unlikely(atomic_read(&req->task->io_uring->in_idle))) {
+	if (unlikely(atomic_read(&req->task->io_uring->in_cancel))) {
 		io_move_task_work_from_local(ctx);
 		goto put_ref;
 	}
@@ -2937,12 +2937,12 @@ static __cold void io_tctx_exit_cb(struct callback_head *cb)
 
 	work = container_of(cb, struct io_tctx_exit, task_work);
 	/*
-	 * When @in_idle, we're in cancellation and it's racy to remove the
+	 * When @in_cancel, we're in cancellation and it's racy to remove the
 	 * node. It'll be removed by the end of cancellation, just ignore it.
 	 * tctx can be NULL if the queueing of this task_work raced with
 	 * work cancelation off the exec path.
 	 */
-	if (tctx && !atomic_read(&tctx->in_idle))
+	if (tctx && !atomic_read(&tctx->in_cancel))
 		io_uring_del_tctx_node((unsigned long)work->ctx);
 	complete(&work->completion);
 }
@@ -3210,7 +3210,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 	if (tctx->io_wq)
 		io_wq_exit_start(tctx->io_wq);
 
-	atomic_inc(&tctx->in_idle);
+	atomic_inc(&tctx->in_cancel);
 	do {
 		bool loop = false;
 
@@ -3261,9 +3261,9 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 	if (cancel_all) {
 		/*
 		 * We shouldn't run task_works after cancel, so just leave
-		 * ->in_idle set for normal exit.
+		 * ->in_cancel set for normal exit.
 		 */
-		atomic_dec(&tctx->in_idle);
+		atomic_dec(&tctx->in_cancel);
 		/* for exec all current's requests should be gone, kill tctx */
 		__io_uring_free(current);
 	}
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 4324b1cf1f6a..3a8d1dd97e1b 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -83,7 +83,7 @@ __cold int io_uring_alloc_task_context(struct task_struct *task,
 
 	xa_init(&tctx->xa);
 	init_waitqueue_head(&tctx->wait);
-	atomic_set(&tctx->in_idle, 0);
+	atomic_set(&tctx->in_cancel, 0);
 	atomic_set(&tctx->inflight_tracked, 0);
 	task->io_uring = tctx;
 	init_llist_head(&tctx->task_list);
-- 
2.39.1

