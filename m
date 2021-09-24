Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C904178E6
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344621AbhIXQiS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347452AbhIXQh4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:56 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C5CC06135F
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:00 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id v18so2957630edc.11
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wLCnCVYv4tRj0mwzleSWAeRGrIdDM+WbN76RMrzfLRM=;
        b=q7uP92cyjUDv7qvv+MQLdI4SKeuquZAGJyG1MDkTxOMDDyq6WFX3wZEuyUPYN2OmN4
         lsPFlAEHB1SmPD6KaG9vfBtRn2eoF6Uux7IW71x/otdXEAgeMfmnM4mcx68YZw5QHXcX
         nxGA/ShuSXk9jL8UjCTnCvPEaEjahw8W3TdCXTlDjaZx8K/kIJMJK6huV1UqxljXi7Zf
         m49ZBhTuyqAryPdcVH9KuRGPMuh6hfQIBHEgb77EAAMgnJwYxOip42b1KoGj3632ALVo
         ZRxZhtHSuz2vrAjWcuFVUGEplSLm9pVYn7w7auAlzuj9ulFCcqveTGNHEt/GD5ChesEa
         vnEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wLCnCVYv4tRj0mwzleSWAeRGrIdDM+WbN76RMrzfLRM=;
        b=k9VH4BIh9SpCZ3ylyeHa7HT5YA36WQ4y9HKwseX3AREAMAltopjZ00dU8fgiYB2L2a
         huXPd5woVdptjrKp2O6T6PEHleoVw3uSNM7KgqWuPa+e/tDAwl4bDc426ASUqZCHRKH1
         2XpYBrFbsbHDpWCF3R486xa9sti6kCGl8N7D09ld1A9XEQd7h5UMu/84HUnOsYnnQ5LM
         S4/RWHyMfI+w4S1xyElnIOfNctdUTyVN6g9l7GK7q+nSdkfcGPlxpkEgU57sOjJLVLh3
         apwspJUes5dQcdbjLKKDiLlJnl7zVUdtN9A7a3XPEx8xVaix+UOU1ASszheUANbbQLzu
         FNkw==
X-Gm-Message-State: AOAM530JJo/QqvyYgy7EgKuHnuEtVkJUAp8wRIEBbWvkt4w6X6b3aZ5J
        33qMpI51OgMnk34ci9yA+949EH/kpxU=
X-Google-Smtp-Source: ABdhPJy7qlFoZWO/jsNzDQ92qOdDMUCLG2IkvXzFFSM6etxnJJaaMi4EXXZMTAEErJS+KmP0vvpbOg==
X-Received: by 2002:a17:906:e85:: with SMTP id p5mr11974621ejf.159.1632501178880;
        Fri, 24 Sep 2021 09:32:58 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:32:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 13/23] io_uring: inline completion batching helpers
Date:   Fri, 24 Sep 2021 17:31:51 +0100
Message-Id: <4f0cb5ae875fba0de3593027031a91500f1d6b1d.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
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
index 70cd32fb4c70..e1637ea4db4c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2266,63 +2266,41 @@ static void io_free_req_work(struct io_kiocb *req, bool *locked)
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

