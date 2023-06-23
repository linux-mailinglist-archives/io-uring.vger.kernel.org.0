Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2367473B610
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 13:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjFWLYn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 07:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjFWLYl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 07:24:41 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E28E213C
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-988f066f665so57183766b.2
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687519479; x=1690111479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gDXyyrGu+GtMDO6VObST1r4sSfZY+sVWPFHmiQYWm98=;
        b=I7U7AvCRmQxblQCJ4yrf2sUa694qZ6TN5jEmmsimZO9CJH8QEXb05SEhi10pPHH3LX
         cFe3woL/Rc14uO45Qz/DNTzrpRBo0akuqP4iNhWQsWTpj6Eg3ooyYjGRnMOnxoL6gob2
         +t92hDo/q7RBNhUaYVJVCN4KWHZcNqztrQS1VZaS66f6M83sPvfIiznIlixmOR62ExP0
         tzykbqkn8KEHk6C2mtAqWb5kvw/MKU1ntOB9xwfln5I8LMmldxDmwUdg+oZ6pFkvlzR1
         Bg1tixAH9Z6s8qnnWRhPI73rNvb0x5PkijudbNUoHdhg23KoAGAmMWtmLvsnqwr2gfpM
         lTmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519479; x=1690111479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gDXyyrGu+GtMDO6VObST1r4sSfZY+sVWPFHmiQYWm98=;
        b=bRV6NEt0L3lNlHuUAmjTxdSqRWi+2djKkClMJeFZjKiEf1KmDsiXTnmJQIbjuSLXWH
         ZsUpKHLh4Nrx4H388IJw+ZTvK5HAr4Uu9DUVniOYHERXgwJyAmeUBpcnz0j+adIO1EHE
         4ZVSnsHpZvuGbSQLoloFwa7IGOahAsM67OCNLVGRnkDii/HnppAShtfGKIiRZcR1tjzp
         CPs14TsWkbP9boZG4kkHi+uEusthQoAu6Ao3ItXI9BE5tADnb7IVfEJAJU/nvahY9b5m
         Nxu+ANyYYKYlwuBTnnZ9sJCzl4Xex7iCgPUgz9HdIbHdUNfG6EUOwTTDyxuD0IDrN8E3
         CRFw==
X-Gm-Message-State: AC+VfDx3tHslE00ZZLru3X+I5tBWbW9yaQf04iPfLhPZErgfVNw/OI5P
        IXcLWd8t7Obxx++0oigoF6wEdetqFE4=
X-Google-Smtp-Source: ACHHUZ4pYldR2iKfOP0VA8zqMUvvrjEJ/zQ1CE25QOjFdMYQVyVusFrQxkZG/mpc0X0BwxLNIg9BaQ==
X-Received: by 2002:a17:907:25cd:b0:989:3148:e9a with SMTP id ae13-20020a17090725cd00b0098931480e9amr8478796ejc.41.1687519478816;
        Fri, 23 Jun 2023 04:24:38 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7d95])
        by smtp.gmail.com with ESMTPSA id h10-20020a1709067cca00b00969f44bbef3sm5959769ejp.11.2023.06.23.04.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:24:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 05/11] io_uring: don't batch task put on reqs free
Date:   Fri, 23 Jun 2023 12:23:25 +0100
Message-Id: <4a7ef7dce845fe2bd35507bf389d6bd2d5c1edf0.1687518903.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1687518903.git.asml.silence@gmail.com>
References: <cover.1687518903.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We're trying to batch io_put_task() in io_free_batch_list(), but
considering that the hot path is a simple inc, it's most cerainly and
probably faster to just do io_put_task() instead of task tracking.

We don't care about io_put_task_remote() as it's only for IOPOLL
where polling/waiting is done by not the submitter task.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4d8613996644..3eec5c761d0a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -754,29 +754,29 @@ static void io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 }
 
 /* can be called by any task */
-static void io_put_task_remote(struct task_struct *task, int nr)
+static void io_put_task_remote(struct task_struct *task)
 {
 	struct io_uring_task *tctx = task->io_uring;
 
-	percpu_counter_sub(&tctx->inflight, nr);
+	percpu_counter_sub(&tctx->inflight, 1);
 	if (unlikely(atomic_read(&tctx->in_cancel)))
 		wake_up(&tctx->wait);
-	put_task_struct_many(task, nr);
+	put_task_struct(task);
 }
 
 /* used by a task to put its own references */
-static void io_put_task_local(struct task_struct *task, int nr)
+static void io_put_task_local(struct task_struct *task)
 {
-	task->io_uring->cached_refs += nr;
+	task->io_uring->cached_refs++;
 }
 
 /* must to be called somewhat shortly after putting a request */
-static inline void io_put_task(struct task_struct *task, int nr)
+static inline void io_put_task(struct task_struct *task)
 {
 	if (likely(task == current))
-		io_put_task_local(task, nr);
+		io_put_task_local(task);
 	else
-		io_put_task_remote(task, nr);
+		io_put_task_remote(task);
 }
 
 void io_task_refs_refill(struct io_uring_task *tctx)
@@ -1033,7 +1033,7 @@ static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 		 * we don't hold ->completion_lock. Clean them here to avoid
 		 * deadlocks.
 		 */
-		io_put_task_remote(req->task, 1);
+		io_put_task_remote(req->task);
 		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
 	}
@@ -1518,9 +1518,6 @@ void io_queue_next(struct io_kiocb *req)
 void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node)
 	__must_hold(&ctx->uring_lock)
 {
-	struct task_struct *task = NULL;
-	int task_refs = 0;
-
 	do {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    comp_list);
@@ -1550,19 +1547,10 @@ void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node)
 
 		io_req_put_rsrc_locked(req, ctx);
 
-		if (req->task != task) {
-			if (task)
-				io_put_task(task, task_refs);
-			task = req->task;
-			task_refs = 0;
-		}
-		task_refs++;
+		io_put_task(req->task);
 		node = req->comp_list.next;
 		io_req_add_to_cache(req, ctx);
 	} while (node);
-
-	if (task)
-		io_put_task(task, task_refs);
 }
 
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
-- 
2.40.0

