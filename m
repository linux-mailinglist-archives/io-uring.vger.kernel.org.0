Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B7E625FE3
	for <lists+io-uring@lfdr.de>; Fri, 11 Nov 2022 17:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiKKQzq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Nov 2022 11:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbiKKQzg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Nov 2022 11:55:36 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBD463B9C
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 08:55:34 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id l11so8408653edb.4
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 08:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=li+sAU5p5WFq98AQol/lQxqBFYvbjKQmvrzaRGUYYwU=;
        b=pDPH/A0Y3bvrq4wym67tKqDPuqx2J6bdsB8cl8qAEXuMvmFHzrZvPAN4L3cI+EqJtR
         Bxll3eY7uRsNA4H6pOtu+psam4pVW7pmPTqfNSctbgKbNZ7cxFwoV8s0znD4tmD8K3TH
         Ok/KXpLmzWCtkQCKV7CE7bf2WaBAEkJ8LqlO628wNJ0MFqWzJJB1pMNrV95DvwrEgS43
         4u3BH538BPx0ZeLyIeQGpsastkBRgdQl1ILmTFDyxPJN0s7waIpI83880lZLGbawodJb
         RE1yM/z3cYsT+jfwSPwQ30xe+7B4DrJk1P+Ui+aO0FB2Ahn36t8g/zPMXIBpuL6RK6CE
         Zt5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=li+sAU5p5WFq98AQol/lQxqBFYvbjKQmvrzaRGUYYwU=;
        b=Rww99Hy5sGgGHkdwTmqOoOi7OXPmDqIOSh8PjqsozYSm9e1z7+KbqMyhN4MzAcH8XQ
         N1A7HguZMONiT08aLrjnnYPAECLuoVgkTG+aFmWxQ1UOKcjQD5TC9mUlTflFblmoP9Qw
         k/HVTLA32bV3m/it6a6t3kio2qDTYKT5ouPClRVPeLS2oN+p8gC1kYaHo1IX2fmeopXy
         dNtBAaxvF3iyqqoBEblwzw3JemtBi9VJCUM6mHsikBIdUv4Brco/AEZYQQq5UX1L8CSx
         4qHxT3jO3kJkXWAyeEY2mZfJudmMeQSgUNWp8Y8Q0N1eD4xVCSNn3zoHblSQuQBXtf7F
         8XYg==
X-Gm-Message-State: ANoB5pnhoyp2qjPcMoM19d4tgZUJYRBjOiIiUc+tbFXawCJwpRbgrGWS
        POkKKA9OOXFVyAtVtzEIBtrHsottcqE=
X-Google-Smtp-Source: AA0mqf5tr6jS3ZQGEuq46xO03kCAY8Q/A4d8QnUP8bq0lyFkvU6YBqI8EByWyQ0oZ3e4/bmpS5Kqfg==
X-Received: by 2002:a05:6402:f19:b0:461:a1c1:b667 with SMTP id i25-20020a0564020f1900b00461a1c1b667mr2310654eda.191.1668185732253;
        Fri, 11 Nov 2022 08:55:32 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:7f38])
        by smtp.gmail.com with ESMTPSA id 20-20020a170906329400b0079dbf06d558sm1022540ejw.184.2022.11.11.08.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 08:55:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/2] io_uring: split tw fallback into a function
Date:   Fri, 11 Nov 2022 16:54:09 +0000
Message-Id: <e503dab9d7af95470ca6b214c6de17715ae4e748.1668162751.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668162751.git.asml.silence@gmail.com>
References: <cover.1668162751.git.asml.silence@gmail.com>
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

When the target process is dying and so task_work_add() is not allowed
we push all task_work item to the fallback workqueue. Move the part
responsible for moving tw items out of __io_req_task_work_add() into
a separate function. Makes it a bit cleaner and gives the compiler a bit
of extra info.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f4420de6ee8b..d63f15afa5fd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1095,6 +1095,20 @@ void tctx_task_work(struct callback_head *cb)
 	trace_io_uring_task_work_run(tctx, count, loops);
 }
 
+static __cold void io_fallback_tw(struct io_uring_task *tctx)
+{
+	struct llist_node *node = llist_del_all(&tctx->task_list);
+	struct io_kiocb *req;
+
+	while (node) {
+		req = container_of(node, struct io_kiocb, io_task_work.node);
+		node = node->next;
+		if (llist_add(&req->io_task_work.node,
+			      &req->ctx->fallback_llist))
+			schedule_delayed_work(&req->ctx->fallback_work, 1);
+	}
+}
+
 static void io_req_local_work_add(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1121,7 +1135,6 @@ void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
 {
 	struct io_uring_task *tctx = req->task->io_uring;
 	struct io_ring_ctx *ctx = req->ctx;
-	struct llist_node *node;
 
 	if (allow_local && ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
 		io_req_local_work_add(req);
@@ -1138,15 +1151,7 @@ void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
 	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
 		return;
 
-	node = llist_del_all(&tctx->task_list);
-
-	while (node) {
-		req = container_of(node, struct io_kiocb, io_task_work.node);
-		node = node->next;
-		if (llist_add(&req->io_task_work.node,
-			      &req->ctx->fallback_llist))
-			schedule_delayed_work(&req->ctx->fallback_work, 1);
-	}
+	io_fallback_tw(tctx);
 }
 
 static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
-- 
2.38.1

