Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71EA7416FD
	for <lists+io-uring@lfdr.de>; Wed, 28 Jun 2023 19:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjF1RKD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jun 2023 13:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbjF1RKC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jun 2023 13:10:02 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC841BE6
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 10:10:01 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-7835bbeb6a0so2191139f.0
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 10:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687972200; x=1690564200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qGeotf15uqrwCXJBzrcEcErfPDo2q6OqBuDdMyzUqqU=;
        b=OlK3Y3gL4TmaSJXJiYsfgn5Oycv8ozxCoMYapKaCsjbF2McSJ2cxGH7hs6wU6xo2ED
         B0IAc6HdtrUvTK8hI1Rp8j9vLHhGYz1vSTZJp1QJOTSyCdzThmy8Q1DtcrHAsFBDn7Xm
         4SwboPBp86V957eYLONvDp1lRY5P6KF0ajptRc6R2Tk9Bd/SOxVKvira4nWjgj5SSlJS
         HACOAjrHODoET/Y9rPFb7MMyxvSt6WjXjkIaNuVuze9QZOZ3F3oiVJMG6s3hpEE0Gada
         6LTR6y2GFdUa6DpBGa1azlnYhvYrIqMjS20e/a5CnekjjyKhD6RVGWhoyRLs1XlWOIVs
         PQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687972200; x=1690564200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qGeotf15uqrwCXJBzrcEcErfPDo2q6OqBuDdMyzUqqU=;
        b=c1476olSoDRgS0BxLIET2ycwSEB8FyVNagWksPsJDLwbDI0Wf+LtXsUbNBwuJl1uWq
         JaDRGOBEM6T2vEhQLfS/Fxp8SSi3brMKzFegIRTxXvNd/g9NDljkYE67L3NQIUApFmm6
         NL/iCknRr1bNxT0xQMKJ9ENZZXz1GmzzQiFIzMDc/Nbrw9zealtsHu9ZWXf0cp+u8Hh1
         krz5v8w8oaBBc5ZiBf/DGPmxnwxdQgSSfcE9yCuj+MNM4VVjzHtI7tVTMJ0i7ddRCgxc
         u9sc7NRVA2HYH/yzFTZH07zIumXMlRquCtuCYMvFlX5A70Xi1aGEciMG2LBSTWv7onT1
         +6iQ==
X-Gm-Message-State: AC+VfDwfLJ6OjNzqA++5lZOvNzdnl1BI3SNLfjKr3q5CV3VZvI7HQgY8
        xUz+dN6FnBfzknO2AxGmyajKtwvRtwu2093OhNI=
X-Google-Smtp-Source: ACHHUZ606jneCQVzLuuVPX/79tWADZCVUunqHlyBja/OCkyYzNFegIYJLYjSUMbcAGICC2bOyN5f2w==
X-Received: by 2002:a05:6602:1648:b0:780:c6bb:ad8d with SMTP id y8-20020a056602164800b00780c6bbad8dmr583517iow.0.1687972199982;
        Wed, 28 Jun 2023 10:09:59 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t11-20020a02c48b000000b0042aecf02051sm708342jam.51.2023.06.28.10.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 10:09:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: flush offloaded and delayed task_work on exit
Date:   Wed, 28 Jun 2023 11:09:53 -0600
Message-Id: <20230628170953.952923-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230628170953.952923-1-axboe@kernel.dk>
References: <20230628170953.952923-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring offloads task_work for cancelation purposes when the task is
exiting. This is conceptually fine, but we should be nicer and actually
wait for that work to complete before returning.

Add an argument to io_fallback_tw() telling it to flush the deferred
work when it's all queued up, and have it flush a ctx behind whenever
the ctx changes.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f84d258ea348..e8096d502a7c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1237,18 +1237,32 @@ static inline struct llist_node *io_llist_cmpxchg(struct llist_head *head,
 	return cmpxchg(&head->first, old, new);
 }
 
-static __cold void io_fallback_tw(struct io_uring_task *tctx)
+static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 {
 	struct llist_node *node = llist_del_all(&tctx->task_list);
+	struct io_ring_ctx *last_ctx = NULL;
 	struct io_kiocb *req;
 
 	while (node) {
 		req = container_of(node, struct io_kiocb, io_task_work.node);
 		node = node->next;
+		if (sync && last_ctx != req->ctx) {
+			if (last_ctx) {
+				flush_delayed_work(&last_ctx->fallback_work);
+				percpu_ref_put(&last_ctx->refs);
+			}
+			last_ctx = req->ctx;
+			percpu_ref_get(&last_ctx->refs);
+		}
 		if (llist_add(&req->io_task_work.node,
 			      &req->ctx->fallback_llist))
 			schedule_delayed_work(&req->ctx->fallback_work, 1);
 	}
+
+	if (last_ctx) {
+		flush_delayed_work(&last_ctx->fallback_work);
+		percpu_ref_put(&last_ctx->refs);
+	}
 }
 
 void tctx_task_work(struct callback_head *cb)
@@ -1263,7 +1277,7 @@ void tctx_task_work(struct callback_head *cb)
 	unsigned int count = 0;
 
 	if (unlikely(current->flags & PF_EXITING)) {
-		io_fallback_tw(tctx);
+		io_fallback_tw(tctx, true);
 		return;
 	}
 
@@ -1358,7 +1372,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
 		return;
 
-	io_fallback_tw(tctx);
+	io_fallback_tw(tctx, false);
 }
 
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
@@ -3108,6 +3122,8 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	if (ctx->rings)
 		io_kill_timeouts(ctx, NULL, true);
 
+	flush_delayed_work(&ctx->fallback_work);
+
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
 	/*
 	 * Use system_unbound_wq to avoid spawning tons of event kworkers
-- 
2.40.1

