Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1BC50A114
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 15:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386698AbiDUNsJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 09:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386738AbiDUNsH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 09:48:07 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5F9B1C3
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:17 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id g18so6754400wrb.10
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T4urCmMZJF9kSBnPZxacH8qGs8h0X3PTlpSksUUEjkU=;
        b=iT3mSYPUGChewKta3fVmREDZR2DmFBZY2HxL7TsQf1GJmNCuA3HQPJxwI+24sCA5yS
         BrFKn14Me9y1Ux0AkY+HniDyLGxRyHDQmVSWPmU8//MP3nx6qL4p4/XK9c4CGkQDSGWt
         fSek94zycEGdMNMZTyj7IETQDoBXI1X8B3c+HDt1WEyeNRwy1Ewqs+0sFO7GupDh+Gtm
         DIeBKdeSzf3fLHGK/l5XWUhqP1gTx63UuBN16Mg7fcE5ogCJfZI/LWnc5OcsCQuGJqlO
         SDh5QhE/9IGZX1TCg2PKpwbT5zJK5pPEMUtdlbwK4OeRBsUCsuW/tiFjRFguNAefLf3b
         7yoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T4urCmMZJF9kSBnPZxacH8qGs8h0X3PTlpSksUUEjkU=;
        b=FHpRSpQD8AibaYN1mxdjnj1UtmNGKIgNK2SWM6/MsfIEzaVvL5m70mvJZL8u+VF1p6
         6GJkjvdTouzxbARsv/hySEreTbzE+IRrjsEwuWSlVDF2HMSMM8m5Rab6MJGHPrOGKDjX
         o17xrwJ+4bb/RxUUNtz0/6hR8tyqJMB6NFCB2O0k5ysqPup5d8KpPlvxQKOUyHBIlAiV
         QN7C25xCb0T51izR4M2HLc1ApWnaXDO+Rg4ERKXiy3QTYRDz8lN0pWGL2imIvl98w8xD
         P/mXz2txWsLozfeLzAUnJ83FwV/DhVdHozrXAZSxESW1j/sFxuokSUuY2ed/yZYvNI9Z
         +ivA==
X-Gm-Message-State: AOAM530cV8Iir2c+RRfTgSlQJZvcWxA04I91GgQxqzqDmliK5C04kytH
        0xnVYRWBfYa8WsPGKe1/oWqAYcXYIYM=
X-Google-Smtp-Source: ABdhPJwEl0ED6DZ2C3ToUOn9q8X4OKTzyNwMtq9u1JNjOQlF6wK4FPtosFAALSA48FyF8QF7B0aMGA==
X-Received: by 2002:a5d:5248:0:b0:207:a421:1a26 with SMTP id k8-20020a5d5248000000b00207a4211a26mr19323943wrc.271.1650548715296;
        Thu, 21 Apr 2022 06:45:15 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.218])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe0c7000000b002060e7bbe49sm2837821wri.45.2022.04.21.06.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:45:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 08/11] io_uring: wire io_uring specific task work
Date:   Thu, 21 Apr 2022 14:44:21 +0100
Message-Id: <3355bb0947b74a37c32d078f64ef7e9f16cf622b.1650548192.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1650548192.git.asml.silence@gmail.com>
References: <cover.1650548192.git.asml.silence@gmail.com>
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

Instead of relying on task_work infrastructure for io_uring, add
io_uring specific path. This removes 2 cmpxchg and a
spin_[un]lock_irq pair per batch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c            | 50 +++++++++++++++++++++-------------------
 include/linux/io_uring.h |  8 +++----
 2 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 22dcd2fb9687..ea7b0c71ca8b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -509,7 +509,6 @@ struct io_uring_task {
 	spinlock_t		task_lock;
 	struct io_wq_work_list	task_list;
 	struct io_wq_work_list	prior_task_list;
-	struct callback_head	task_work;
 	struct file		**registered_rings;
 	bool			task_running;
 };
@@ -2541,12 +2540,14 @@ static void handle_tw_list(struct io_wq_work_node *node,
 	} while (node);
 }
 
-static void tctx_task_work(struct callback_head *cb)
+void io_uring_task_work_run(void)
 {
-	bool uring_locked = false;
+	struct io_uring_task *tctx = current->io_uring;
 	struct io_ring_ctx *ctx = NULL;
-	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
-						  task_work);
+	bool uring_locked = false;
+
+	if (!tctx)
+		return;
 
 	while (1) {
 		struct io_wq_work_node *node1, *node2;
@@ -2581,7 +2582,6 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 	struct io_wq_work_list *list;
 	struct task_struct *tsk = req->task;
 	struct io_uring_task *tctx = tsk->io_uring;
-	enum task_work_notify_mode notify;
 	struct io_wq_work_node *node;
 	unsigned long flags;
 	bool running;
@@ -2602,21 +2602,19 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 	spin_unlock_irqrestore(&tctx->task_lock, flags);
 
 	/* task_work already pending, we're done */
-	if (running)
-		return;
-
-	/*
-	 * SQPOLL kernel thread doesn't need notification, just a wakeup. For
-	 * all other cases, use TWA_SIGNAL unconditionally to ensure we're
-	 * processing task_work. There's no reliable way to tell if TWA_RESUME
-	 * will do the job.
-	 */
-	notify = (req->ctx->flags & IORING_SETUP_SQPOLL) ? TWA_NONE : TWA_SIGNAL;
-	if (likely(!task_work_add(tsk, &tctx->task_work, notify))) {
-		if (notify == TWA_NONE)
+	if (!running) {
+		/*
+		 * SQPOLL kernel thread doesn't need notification, just a wakeup. For
+		 * all other cases, use TWA_SIGNAL unconditionally to ensure we're
+		 * processing task_work. There's no reliable way to tell if TWA_RESUME
+		 * will do the job.
+		 */
+		if (req->ctx->flags & IORING_SETUP_SQPOLL)
 			wake_up_process(tsk);
-		return;
+		else
+			task_work_notify(tsk, TWA_SIGNAL);
 	}
+	return;
 
 	spin_lock_irqsave(&tctx->task_lock, flags);
 cancel_locked:
@@ -2795,7 +2793,9 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 
 static inline bool io_run_task_work(void)
 {
-	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || task_work_pending(current)) {
+	struct io_uring_task *tctx = current->io_uring;
+
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || (tctx && tctx->task_running)) {
 		__set_current_state(TASK_RUNNING);
 		clear_notify_signal();
 		io_uring_task_work_run();
@@ -7988,6 +7988,7 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
 
 static int io_sq_thread(void *data)
 {
+	struct io_uring_task *tctx = current->io_uring;
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
 	unsigned long timeout = 0;
@@ -8022,8 +8023,10 @@ static int io_sq_thread(void *data)
 			if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
 		}
-		if (io_run_task_work())
+		if (tctx->task_running) {
+			io_uring_task_work_run();
 			sqt_spin = true;
+		}
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
 			cond_resched();
@@ -8033,7 +8036,7 @@ static int io_sq_thread(void *data)
 		}
 
 		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
-		if (!io_sqd_events_pending(sqd) && !task_work_pending(current)) {
+		if (!io_sqd_events_pending(sqd) && !tctx->task_running) {
 			bool needs_sched = true;
 
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
@@ -8074,7 +8077,6 @@ static int io_sq_thread(void *data)
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 		io_ring_set_wakeup_flag(ctx);
-	io_run_task_work();
 	mutex_unlock(&sqd->lock);
 
 	audit_free(current);
@@ -9135,7 +9137,6 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
 	INIT_WQ_LIST(&tctx->prior_task_list);
-	init_task_work(&tctx->task_work, tctx_task_work);
 	return 0;
 }
 
@@ -10356,6 +10357,7 @@ static __cold void io_uring_cancel_generic(bool cancel_all,
 
 	do {
 		io_uring_drop_tctx_refs(current);
+		io_run_task_work();
 		/* read completions before cancelations */
 		inflight = tctx_inflight(tctx, !cancel_all);
 		if (!inflight)
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index e87ed946214f..331bea825ee6 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -5,15 +5,12 @@
 #include <linux/sched.h>
 #include <linux/xarray.h>
 
-static inline void io_uring_task_work_run(void)
-{
-}
-
 #if defined(CONFIG_IO_URING)
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
 void io_uring_unreg_ringfd(void);
+void io_uring_task_work_run(void);
 
 static inline void io_uring_files_cancel(void)
 {
@@ -46,6 +43,9 @@ static inline void io_uring_files_cancel(void)
 static inline void io_uring_free(struct task_struct *tsk)
 {
 }
+static inline void io_uring_task_work_run(void)
+{
+}
 #endif
 
 #endif
-- 
2.36.0

