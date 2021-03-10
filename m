Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C29334BCB
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhCJWol (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbhCJWoK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:10 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C06C061761
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:10 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id c16so9254563ply.0
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gryrtdw8jEh/2EavrCJXH234vjkk0Y8kIf6y2/rxT5Y=;
        b=pztR4+PuZqEhK4prTlpUddaAIfmaBQm4qsAeEq1qbe7KmcwRZ5jhKDUvZ4QtVpAly2
         +X7xaldg46G9CeMOCipFkOxk8e2VH2SLgnPlTPwqg4mr5tRzG71HpN84fr5Rmc43oE05
         f3wvdiRX+afvlAkJYJE0FB+25L3kOcoLWSPm4QE9etVkPEYioC3T5NFvjfYjg4tb3BFL
         zIUxyNqKWa1JJu+1Aq//uUOYV1wT79rTOao6QJszdhz0tSyoBVTP+0x8o+JasL2oK2BG
         in/awKwKqK1p1mB+MOMGTMOwUWW0suA0OOoutlKUMa5MsN+nt6FtuY12iOJGP7WjvyS+
         kubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gryrtdw8jEh/2EavrCJXH234vjkk0Y8kIf6y2/rxT5Y=;
        b=cwQQ9i6i+3JVcLmZ0WkzF9d+j/vpfMyvikwOqrwN07O/PRysV3bgNxbupCAbeqSXY1
         6+gNnEDLILaft68DPbsbrIkAhJimT1wXs1RwR6HgUAej2ce84obAhmhE4TEY368KHvlS
         t1cTNCSAOHl9dSR6rKpIzO5zpuPN8jt3bx1+PNS4J99iG9nQzprF+QVie2LVnzktqbAo
         VALT2nh0s9KvWnYqf7rvqegongYxWuX0vS3E8mk6/5L4JOpLhYy3pL6xVia2Uko6FUnu
         uJ6RBMvDAX037WMA3fehirbbN36mmZnNxxpPS5YEgCAAAMnDI9b9U4u1xtUQKbjGBh+H
         hE5w==
X-Gm-Message-State: AOAM5322O5T6beP8Rxv44BfLJ547NNIkamkdag4hAdiCCyi+p73PbuOj
        G/ywfc3DdAsUsBkm4H9WOA9aeltsQEfEcA==
X-Google-Smtp-Source: ABdhPJxj7gjhTF86yKhr6g/imOrUfefuI15nCJlu5shZttAppeYcTGtWhFu7mslyZI26sqN0fvob5A==
X-Received: by 2002:a17:902:59d0:b029:e6:5cd0:dbdb with SMTP id d16-20020a17090259d0b02900e65cd0dbdbmr5136954plj.38.1615416249837;
        Wed, 10 Mar 2021 14:44:09 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:09 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/27] io_uring: do ctx initiated file note removal
Date:   Wed, 10 Mar 2021 15:43:36 -0700
Message-Id: <20210310224358.1494503-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Another preparation patch. When full quiesce is done on ctx exit, use
task_work infra to remove corresponding to the ctx io_uring->xa entries.
For that we use the back tctx map. Also use ->in_idle to prevent
removing it while we traversing ->xa on cancellation, just ignore it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9a2cff0662e0..8a4ab86ae64f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -987,6 +987,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_UNLINKAT] = {},
 };
 
+static void io_uring_del_task_file(unsigned long index);
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 struct files_struct *files);
@@ -8536,10 +8537,33 @@ static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
 	return executed;
 }
 
+struct io_tctx_exit {
+	struct callback_head		task_work;
+	struct completion		completion;
+	unsigned long			index;
+};
+
+static void io_tctx_exit_cb(struct callback_head *cb)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	struct io_tctx_exit *work;
+
+	work = container_of(cb, struct io_tctx_exit, task_work);
+	/*
+	 * When @in_idle, we're in cancellation and it's racy to remove the
+	 * node. It'll be removed by the end of cancellation, just ignore it.
+	 */
+	if (!atomic_read(&tctx->in_idle))
+		io_uring_del_task_file(work->index);
+	complete(&work->completion);
+}
+
 static void io_ring_exit_work(struct work_struct *work)
 {
-	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
-					       exit_work);
+	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
+	struct io_tctx_exit exit;
+	struct io_tctx_node *node;
+	int ret;
 
 	/*
 	 * If we're doing polled IO and end up having requests being
@@ -8550,6 +8574,26 @@ static void io_ring_exit_work(struct work_struct *work)
 	do {
 		io_uring_try_cancel_requests(ctx, NULL, NULL);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
+
+	mutex_lock(&ctx->uring_lock);
+	while (!list_empty(&ctx->tctx_list)) {
+		node = list_first_entry(&ctx->tctx_list, struct io_tctx_node,
+					ctx_node);
+		exit.index = (unsigned long)node->file;
+		init_completion(&exit.completion);
+		init_task_work(&exit.task_work, io_tctx_exit_cb);
+		ret = task_work_add(node->task, &exit.task_work, TWA_SIGNAL);
+		if (WARN_ON_ONCE(ret))
+			continue;
+		wake_up_process(node->task);
+
+		mutex_unlock(&ctx->uring_lock);
+		wait_for_completion(&exit.completion);
+		cond_resched();
+		mutex_lock(&ctx->uring_lock);
+	}
+	mutex_unlock(&ctx->uring_lock);
+
 	io_ring_ctx_free(ctx);
 }
 
-- 
2.30.2

