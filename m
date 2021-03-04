Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC1432D4D9
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 15:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236562AbhCDOFK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 09:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238935AbhCDOEy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 09:04:54 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76B7C061765
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 06:03:40 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id b18so21299147wrn.6
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 06:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hcAk4aChmOzbw+0dQefcWWuBy7CqUjDqTTf4AHckJgE=;
        b=YfkIYGJXJEFZ3wyfQ/zmKI+5kW1QmdivDXVbJI6ASy0nMZmf4y1v/yMCT0Yag0AB2x
         HU4fq6Mc3EiI4quNKJVMVCL8lL+6iK0tahkqbdgM6NNMBEX5VPHp70vn6I647HYg9I1a
         hpNtG3WJAwDd7mjCWQIow294EDFSjV1liCZIOYpsHRsN6fOBy2y08nCBelUY9Ncc2Zoo
         eFEU25XuRh7HYlfL2ffx412y6ZXIKjl5QX20jUz5M2dQ03P2A30ZAwHFbtTiT16KEQhE
         nfaOppee1Lhs+rb/q8TGdwVSgHpvkGrG2f1TslQlQm7W1YqG0HriUe3rZ0NuXFh5ch9M
         edpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hcAk4aChmOzbw+0dQefcWWuBy7CqUjDqTTf4AHckJgE=;
        b=XuBoXkHzd/oceVYqXuN8aGn0FAnv1a0bIvGveYNLt48A8EDBINc4RLhWW7PBktdj/C
         XumpXKEnj3OCmggxtjZHlRZNUKkLdMFgaeKb2sh7YQ41BOPacXlZuFbBYvhYyjqZSs4k
         T7Ns8n/Enh4af92K+zofG50wXsZ36TRaPT7iU0a6O59n9OjXF+NkI/jtJQD8LyoAKuKt
         QCRj8UXE8qAL9rODDcrmk3Upy0PIz2DkJqbQJpCzEo784V8/6u3ELoEeLWYEwRF5EfOe
         IlAg4scqWHDUAqjTVym4luybz4u4ctiE38wKQ2qNWjtATQj6hhxhD6bxEkHPhE92wsBk
         3tmQ==
X-Gm-Message-State: AOAM532STRcCa3Luv0+CqLQSGFJ4X4WxawictdSR6pmuEXPh6n+CHU+X
        +TwfCNjNAMODQgqZtnryW6M=
X-Google-Smtp-Source: ABdhPJx6ZBv6Jdd22W9gTm+BluEkpOGO5J/Fj3NO76Ng9O9MqJhU3yCHT99a4O8bLZqWA46YqZ+9cg==
X-Received: by 2002:adf:df10:: with SMTP id y16mr4211270wrl.372.1614866619565;
        Thu, 04 Mar 2021 06:03:39 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id o124sm9975488wmo.41.2021.03.04.06.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 06:03:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/8] io_uring: do ctx initiated file note removal
Date:   Thu,  4 Mar 2021 13:59:28 +0000
Message-Id: <ab5fe8960d208b3dd84e67963981192ceb60a017.1614866085.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614866085.git.asml.silence@gmail.com>
References: <cover.1614866085.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Another preparation patch. When full quiesce is done on ctx exit, use
task_work infra to remove corresponding to the ctx io_uring->xa entries.
For that we use the back tctx map. Also use ->in_idle to prevent
removing it while we traversing ->xa on cancellation, just ignore it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8d632fa61799..d88f77f4bb7e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -987,6 +987,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_UNLINKAT] = {},
 };
 
+static void io_uring_del_task_file(unsigned long index);
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 struct files_struct *files);
@@ -8521,10 +8522,33 @@ static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
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
@@ -8535,6 +8559,26 @@ static void io_ring_exit_work(struct work_struct *work)
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
2.24.0

