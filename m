Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEEA9417CB4
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348486AbhIXVCn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346564AbhIXVCf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:35 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA40FC061613
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:01 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id v18so5596687edc.11
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Dv80Tan9pDFBNRjEtpfJiy73+mquYTFqBbDEAwH88Zg=;
        b=Q5HicYyY479v8guXRUDjfxKUDsavN0+BlbcWnQJgKDzdWKsllV8pgS6ODacNhYDNIi
         jvTAGbm2GMp2Y1tfMgd+7QFbZYWkLeF19jli238BztWQLDp22i+jk8zdLnIYSK7JmP+P
         zEs4b4azoP07V90X7KPG9XWY+w//omfg5r7Peuv13t8gi5Bg9IJSwpNFqWUx2ZOIEG9j
         83h7uho0/uhPsmacOz890VU5zBY2cRhS+mQvB13nDYaH34bzIQ5VSUwo+2oXwwB/LmCt
         52bfaLv9BonoHH+iO4bJCUoW9xeSr4DQPXi2WIqNmJ4yBLRmjLby1isSK+3XX+pWmcji
         Npxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dv80Tan9pDFBNRjEtpfJiy73+mquYTFqBbDEAwH88Zg=;
        b=LypUcxqIdz0ygtMp85DSlUrxZcDE+zBQmQZx/g7mQA9Xsv4iCIebv1aDMOZEPc1AG3
         aLrF39O1c1BuI5AJmeNqSXgTZeon6OZ8V2Ft4Q+Sl3r6QaZFSNjaKH8Hvy7+XWbljown
         xzvkHNjMqNXqX9M8PsR2QcSYr3eFXVsEolCbitP2e/H5av8nfppuCfViHQOsSwBujGYF
         cTzgOdSwkYk5Bfrfhe35UDwHiyqsZdqoRgSBuha4LpD2EzbTxwSFwSB4+8zNBlT7z25M
         8i0/UmnNzFC+1PJr/KbUuf7ktErJ0rY4f0V5FAVo/yDTyx0v+xa4xxtr58ncsgvwHaTC
         mMVQ==
X-Gm-Message-State: AOAM5324wh1W7Xo3K+SJdvjeGMpOzuDo0uFPZrV3fYBU4XFAGFyd13em
        UL2OHR516mZNRqEdrxLeMva3qG8dFPo=
X-Google-Smtp-Source: ABdhPJwJo1XJzZumhHWWudlH0teSdH5ynJ4vJ3GOQeKu3Nc682N0qVE3clwfWDq7R4GECNeJsCnDKw==
X-Received: by 2002:a17:906:d798:: with SMTP id pj24mr13068653ejb.1.1632517260368;
        Fri, 24 Sep 2021 14:01:00 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:01:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 13/24] io_uring: inline completion batching helpers
Date:   Fri, 24 Sep 2021 21:59:53 +0100
Message-Id: <595a2917f80dd94288cd7203052c7934f5446580.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We now have a single function for batched put of requests, just inline
struct req_batch and all related helpers into it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 66 +++++++++++++++++----------------------------------
 1 file changed, 22 insertions(+), 44 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c9588519e04a..8d2aa0951579 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2269,63 +2269,41 @@ static void io_free_req_work(struct io_kiocb *req, bool *locked)
 	io_free_req(req);
 }
 
-struct req_batch {
-	struct task_struct	*task;
-	int			task_refs;
-	int			ctx_refs;
-};
-
-static inline void io_init_req_batch(struct req_batch *rb)
-{
-	rb->task_refs = 0;
-	rb->ctx_refs = 0;
-	rb->task = NULL;
-}
-
-static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
-				     struct req_batch *rb)
-{
-	if (rb->ctx_refs)
-		percpu_ref_put_many(&ctx->refs, rb->ctx_refs);
-	if (rb->task)
-		io_put_task(rb->task, rb->task_refs);
-}
-
-static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
-			      struct io_submit_state *state)
-{
-	io_queue_next(req);
-	io_dismantle_req(req);
-
-	if (req->task != rb->task) {
-		if (rb->task)
-			io_put_task(rb->task, rb->task_refs);
-		rb->task = req->task;
-		rb->task_refs = 0;
-	}
-	rb->task_refs++;
-	rb->ctx_refs++;
-	wq_stack_add_head(&req->comp_list, &state->free_list);
-}
-
 static void io_free_batch_list(struct io_ring_ctx *ctx,
 			       struct io_wq_work_list *list)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_wq_work_node *node;
-	struct req_batch rb;
+	struct task_struct *task = NULL;
+	int task_refs = 0, ctx_refs = 0;
 
-	io_init_req_batch(&rb);
 	node = list->first;
 	do {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    comp_list);
 
 		node = req->comp_list.next;
-		if (req_ref_put_and_test(req))
-			io_req_free_batch(&rb, req, &ctx->submit_state);
+		if (!req_ref_put_and_test(req))
+			continue;
+
+		io_queue_next(req);
+		io_dismantle_req(req);
+
+		if (req->task != task) {
+			if (task)
+				io_put_task(task, task_refs);
+			task = req->task;
+			task_refs = 0;
+		}
+		task_refs++;
+		ctx_refs++;
+		wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
 	} while (node);
-	io_req_free_batch_finish(ctx, &rb);
+
+	if (ctx_refs)
+		percpu_ref_put_many(&ctx->refs, ctx_refs);
+	if (task)
+		io_put_task(task, task_refs);
 }
 
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
-- 
2.33.0

