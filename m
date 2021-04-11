Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B1135B105
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbhDKAvL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbhDKAvL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:11 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC017C06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:50:55 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id b9so9256062wrs.1
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1LZ+sZHjwi7T828W4RjuVBQKzA7IM7FnjWE+tkT6CTA=;
        b=thfrcYloXYfnZwbAyWBTbsKExWsw2+Y7+1MzPYcROOJ7GSnGqbv8ig8/EH92xLkNLV
         n1hJD3WYBADwsn0WrzhK0Y2B/CY8GXZzbGm4lJczwkLEA40hqL6uX5+H9rHyZwAUjGW0
         a05HQ0WlEQgzlTou07OcIbvYC8qrKy0TNx//2ARqzN00qv83ttIZRoVdbnOpPabTFWsz
         kqLuKIGuFxV6qZF+qDMXQj8qJYuh93SGU1ct0J7a878fG+ZCrTrzSx7Y0H1wBGI9U+AY
         0cVxUX+I9Uig3rEs48jX/+/fPp8Q7ZMicNS4dCi4t45prdhtrgH51FSx5zKoIFpKV1wu
         UJdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1LZ+sZHjwi7T828W4RjuVBQKzA7IM7FnjWE+tkT6CTA=;
        b=LM9TFBFkJ3A4k8BBD4yotMjjpNR3341MLDOspoJRNulTD8ESM1S3cpipQzbsCgEqIJ
         426AJJMapk3vjRELRBjUKeu9Y54q8snCeI+lTT9s4AoGg6UqvmvR/lDtR05lWATuNwLi
         qps8dQ5i3G34RfRwZF/3hz5meb1TiadhGlhUkXm6CXxzX2dLinePHPNQC8j2vtCdAmEi
         HB9Ow/VRMuBAFLNSppJlCV6/Fxm7A553vQMZa/tVEH8v1zzelFLwKH7D3h8YfThLowIk
         puZ2gio0Ae/9sk7aR1+GeiUbdAjw9kxbW3T0H+1lYJFor2H0LlvXmhV2a1u3j1dE4Q+I
         go1A==
X-Gm-Message-State: AOAM5323NLXRht5jkMO9Vlx5FhtZUU1FxwzuRT3K9pEwxHUmD8Dkw/jL
        HEqKlVzrvpq4vpNY1vthfgd7mvIy9DyRDw==
X-Google-Smtp-Source: ABdhPJzs99W32duBMYBeZ+rMT/8qoshAejCCg+jqshlvICS59g+WKOA16NADMmnjo7Mc3Zrxzqse1g==
X-Received: by 2002:adf:cd0a:: with SMTP id w10mr1231151wrm.195.1618102254473;
        Sat, 10 Apr 2021 17:50:54 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:50:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/16] io_uring: unify task and files cancel loops
Date:   Sun, 11 Apr 2021 01:46:25 +0100
Message-Id: <dca5a395efebd1e3e0f3bbc6b9640c5e8aa7e468.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move tracked inflight number check up the stack into
__io_uring_files_cancel() so it's similar to task cancel. Will be used
for further cleaning.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 74 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 33 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f1fcb32f8e0b..5c2364ceb6e1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8869,28 +8869,6 @@ static int io_uring_count_inflight(struct io_ring_ctx *ctx,
 	return cnt;
 }
 
-static void io_uring_cancel_files(struct io_ring_ctx *ctx,
-				  struct task_struct *task,
-				  struct files_struct *files)
-{
-	while (!list_empty_careful(&ctx->inflight_list)) {
-		DEFINE_WAIT(wait);
-		int inflight;
-
-		inflight = io_uring_count_inflight(ctx, task, files);
-		if (!inflight)
-			break;
-
-		io_uring_try_cancel_requests(ctx, task, files);
-
-		prepare_to_wait(&task->io_uring->wait, &wait,
-				TASK_UNINTERRUPTIBLE);
-		if (inflight == io_uring_count_inflight(ctx, task, files))
-			schedule();
-		finish_wait(&task->io_uring->wait, &wait);
-	}
-}
-
 static int __io_uring_add_task_file(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx = current->io_uring;
@@ -8976,6 +8954,19 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	}
 }
 
+static s64 tctx_inflight_tracked(struct task_struct *task,
+				 struct files_struct *files)
+{
+	struct io_uring_task *tctx = task->io_uring;
+	struct io_tctx_node *node;
+	unsigned long index;
+	s64 cnt = 0;
+
+	xa_for_each(&tctx->xa, index, node)
+		cnt += io_uring_count_inflight(node->ctx, task, files);
+	return cnt;
+}
+
 static s64 tctx_inflight(struct io_uring_task *tctx)
 {
 	return percpu_counter_sum(&tctx->inflight);
@@ -9014,14 +9005,12 @@ static void io_sqpoll_cancel_sync(struct io_ring_ctx *ctx)
 		wait_for_completion(&work.completion);
 }
 
-void __io_uring_files_cancel(struct files_struct *files)
+static void io_uring_try_cancel(struct files_struct *files)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
 	unsigned long index;
 
-	/* make sure overflow events are dropped */
-	atomic_inc(&tctx->in_idle);
 	xa_for_each(&tctx->xa, index, node) {
 		struct io_ring_ctx *ctx = node->ctx;
 
@@ -9029,14 +9018,8 @@ void __io_uring_files_cancel(struct files_struct *files)
 			io_sqpoll_cancel_sync(ctx);
 			continue;
 		}
-		io_uring_cancel_files(ctx, current, files);
-		if (!files)
-			io_uring_try_cancel_requests(ctx, current, NULL);
+		io_uring_try_cancel_requests(ctx, current, files);
 	}
-	atomic_dec(&tctx->in_idle);
-
-	if (files)
-		io_uring_clean_tctx(tctx);
 }
 
 /* should only be called by SQPOLL task */
@@ -9070,6 +9053,31 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
 	atomic_dec(&tctx->in_idle);
 }
 
+void __io_uring_files_cancel(struct files_struct *files)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	DEFINE_WAIT(wait);
+	s64 inflight;
+
+	/* make sure overflow events are dropped */
+	atomic_inc(&tctx->in_idle);
+	do {
+		/* read completions before cancelations */
+		inflight = tctx_inflight_tracked(current, files);
+		if (!inflight)
+			break;
+		io_uring_try_cancel(files);
+
+		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
+		if (inflight == tctx_inflight_tracked(current, files))
+			schedule();
+		finish_wait(&tctx->wait, &wait);
+	} while (1);
+	atomic_dec(&tctx->in_idle);
+
+	io_uring_clean_tctx(tctx);
+}
+
 /*
  * Find any io_uring fd that this task has registered or done IO on, and cancel
  * requests.
@@ -9089,7 +9097,7 @@ void __io_uring_task_cancel(void)
 		inflight = tctx_inflight(tctx);
 		if (!inflight)
 			break;
-		__io_uring_files_cancel(NULL);
+		io_uring_try_cancel(NULL);
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
 
-- 
2.24.0

