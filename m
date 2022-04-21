Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036F450A115
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 15:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386686AbiDUNsL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 09:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386713AbiDUNsJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 09:48:09 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA564AE6C
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:18 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id w4so6738170wrg.12
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UjsMf0ynl8TMQUrKEb47A/zKSS6svNcRYfX66VLmhAs=;
        b=Whqhiqh1z4BuuCGadKTaBQ1LYsg7rPUOvF+2kyhNOJPNUXRWirevcYPKGB1YhrGAah
         cL5ynh/JksByjBky0f1K8g9Dbt0svTzY9NGnLLp1IPXgLO8xk64ZwoDZP/qTXUQr290W
         1FPZSYA7cnDjhR8CW7PfIhUY62eDmBWjgYLTSFKSjZrfQWNRY6DkHmH1DJsMJaWpur90
         nFBy6wSdbK3eB191lS4QfsyvjAdZWrZzlXMSIm/bFRoQa6CKO8d/SioUCH+a06AbzbyT
         cfU0awaWhksRPJBlyN22+pbxptvRRXYjp3CKR0s9QZov7QwrKPChMeTvH8v19CjgaZ4K
         rD1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UjsMf0ynl8TMQUrKEb47A/zKSS6svNcRYfX66VLmhAs=;
        b=wwGJoQJbqAOTdz+cdh553z9ZJvLNzkUVu6caAcq9/vZfkiaIE3djUlLjQw4GpxnCiU
         +lpP5Z8LJwHMp5f43rcScfsjjqTwarKXo7Ew0yHQvCEUzCV86Q5jYe60fHW3niiAm5r1
         5izX1pdZYrDCs7hU8i5PFYJobnPwHCUNZZLFznnJb8P1e52uEnU4dJQHISzeb22mdhws
         hhDblm2k3Ay4swwxqF6yjxXtM2swqlT7pJIMj9Iv3ZC5tAowwv3UOiUiR8z6Qc1K0VbC
         rj+XS03+mMK3WO+H+TVKGP9vHihZGOojZx89DRmJwwRpNLtmpf68R9KhAT+0DLAnHaBm
         ekvA==
X-Gm-Message-State: AOAM531ZeVl5ZsZM8UQ3k0EY0m9y/WPhhO8tVbZQDwL6TdOMMZqFXMOz
        BLfZ80LNFXUfcop+SnBxEmQtXuqCioo=
X-Google-Smtp-Source: ABdhPJwjmfUGyyjFKaiXgyYLJ7ULpPz7fgP/Jqr2klniFgjwGLAZNt1q3T44b+Stb6djb7IBIlx6YA==
X-Received: by 2002:a5d:584c:0:b0:20a:821a:b393 with SMTP id i12-20020a5d584c000000b0020a821ab393mr20266717wrf.141.1650548717225;
        Thu, 21 Apr 2022 06:45:17 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.218])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe0c7000000b002060e7bbe49sm2837821wri.45.2022.04.21.06.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:45:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 10/11] io_uring: remove priority tw list
Date:   Thu, 21 Apr 2022 14:44:23 +0100
Message-Id: <03a8a348c2508ed710397906ce1867dc50e63f01.1650548192.git.asml.silence@gmail.com>
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

Not for upstreaming. Remove it for experimenting

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 61 +++++++--------------------------------------------
 1 file changed, 8 insertions(+), 53 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6397348748ad..51b6ee2b70f2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -508,7 +508,6 @@ struct io_uring_task {
 
 	spinlock_t		task_lock;
 	struct io_wq_work_list	task_list;
-	struct io_wq_work_list	prior_task_list;
 	struct file		**registered_rings;
 	bool			task_running;
 };
@@ -2483,42 +2482,6 @@ static inline void ctx_commit_and_unlock(struct io_ring_ctx *ctx)
 	io_cqring_ev_posted(ctx);
 }
 
-static void handle_prev_tw_list(struct io_wq_work_node *node,
-				struct io_ring_ctx **ctx, bool *uring_locked)
-{
-	if (*ctx && !*uring_locked)
-		spin_lock(&(*ctx)->completion_lock);
-
-	do {
-		struct io_wq_work_node *next = node->next;
-		struct io_kiocb *req = container_of(node, struct io_kiocb,
-						    io_task_work.node);
-
-		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
-
-		if (req->ctx != *ctx) {
-			if (unlikely(!*uring_locked && *ctx))
-				ctx_commit_and_unlock(*ctx);
-
-			ctx_flush_and_put(*ctx, uring_locked);
-			*ctx = req->ctx;
-			/* if not contended, grab and improve batching */
-			*uring_locked = mutex_trylock(&(*ctx)->uring_lock);
-			if (unlikely(!*uring_locked))
-				spin_lock(&(*ctx)->completion_lock);
-		}
-		if (likely(*uring_locked))
-			req->io_task_work.func(req, uring_locked);
-		else
-			__io_req_complete_post(req, req->cqe.res,
-						io_put_kbuf_comp(req));
-		node = next;
-	} while (node);
-
-	if (unlikely(!*uring_locked))
-		ctx_commit_and_unlock(*ctx);
-}
-
 static void handle_tw_list(struct io_wq_work_node *node,
 			   struct io_ring_ctx **ctx, bool *locked)
 {
@@ -2550,27 +2513,21 @@ void io_uring_task_work_run(void)
 		return;
 
 	while (1) {
-		struct io_wq_work_node *node1, *node2;
+		struct io_wq_work_node *node2;
 
 		spin_lock_irq(&tctx->task_lock);
-		node1 = tctx->prior_task_list.first;
 		node2 = tctx->task_list.first;
 		INIT_WQ_LIST(&tctx->task_list);
-		INIT_WQ_LIST(&tctx->prior_task_list);
-		if (!node2 && !node1)
+		if (!node2)
 			tctx->task_running = false;
 		spin_unlock_irq(&tctx->task_lock);
-		if (!node2 && !node1)
+		if (!node2)
 			break;
 
-		if (node1)
-			handle_prev_tw_list(node1, &ctx, &uring_locked);
-		if (node2)
-			handle_tw_list(node2, &ctx, &uring_locked);
+		handle_tw_list(node2, &ctx, &uring_locked);
 		cond_resched();
 
-		if (data_race(!tctx->task_list.first) &&
-		    data_race(!tctx->prior_task_list.first) && uring_locked)
+		if (data_race(!tctx->task_list.first) && uring_locked)
 			io_submit_flush_completions(ctx);
 	}
 
@@ -2579,7 +2536,6 @@ void io_uring_task_work_run(void)
 
 static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 {
-	struct io_wq_work_list *list;
 	struct task_struct *tsk = req->task;
 	struct io_uring_task *tctx = tsk->io_uring;
 	struct io_wq_work_node *node;
@@ -2591,8 +2547,7 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 	io_drop_inflight_file(req);
 
 	spin_lock_irqsave(&tctx->task_lock, flags);
-	list = priority ? &tctx->prior_task_list : &tctx->task_list;
-	wq_list_add_tail(&req->io_task_work.node, list);
+	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
 	if (unlikely(atomic_read(&tctx->in_idle)))
 		goto cancel_locked;
 
@@ -2618,7 +2573,8 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 
 	spin_lock_irqsave(&tctx->task_lock, flags);
 cancel_locked:
-	node = wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
+	node = tctx->task_list.first;
+	INIT_WQ_LIST(&tctx->task_list);
 	spin_unlock_irqrestore(&tctx->task_lock, flags);
 
 	while (node) {
@@ -9134,7 +9090,6 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
-	INIT_WQ_LIST(&tctx->prior_task_list);
 	return 0;
 }
 
-- 
2.36.0

