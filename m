Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9EDF7416FA
	for <lists+io-uring@lfdr.de>; Wed, 28 Jun 2023 19:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjF1RKG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jun 2023 13:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbjF1RKA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jun 2023 13:10:00 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECBC10C
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 10:09:59 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-760dff4b701so2338739f.0
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 10:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687972199; x=1690564199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Sy6Sx0KyVfu6SSofVlvPg2ozz2tXo7on0jmFzVosUo=;
        b=B0CzJS1Zi0Y/z8asn2A8oY4cI6dlgXqoYnwd3tom4UsHE9PdcYwh8LurRFwxe38eHQ
         kCNG0DWCfyP180Ah68XfSObxJyQ7PlXW/RTalhW2chedWE53Jr+znxWyKMSeEvGZYgx6
         NQEvq9/O8JSo7nFviXYUrWx5XLIEZzIZh8YWtgn4t1/qILQsnlZGAvH4dfK2GFwKs2TG
         Pd6iEOT4E7O6k9yPrZ2KA7gCONZT1HdyO2MJm8cwJiEnw1/01bmPfqbTsWfPLEyAbnfb
         L3XuD8JvSQrQ1DUp2S/HT2R8xAYTmxXLtD0WpTHvI+ikLOki26K6OOB9R2u8sHnNzf7O
         tVew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687972199; x=1690564199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Sy6Sx0KyVfu6SSofVlvPg2ozz2tXo7on0jmFzVosUo=;
        b=CzWxPm04VNRNS13khRrvb7Tz3s4UqDdE5xZEpk8SdKO2SaF018XeZRsZS/DIfUnVtd
         ubVSs0odr09sKNmV41D8almu1JfjF1xqe9TR0QyYT0wGcP48hTb4/5t+DLM0VA1lAa+2
         bAASRk/wsAxh1k4yK9/IOetwc6bq+01mTtZysVSvI/gqi80WhwixoYW11Adokymbhq1F
         1YbwNqqB5CEJH4Y5v0DVxotbvYPJ2JTg/bOh8uEuaAHTjqz+jprWKj68OdywlnUEjEFB
         D0xrmsbauWplpbfTW/bAXUiCx6XbvtCvtVFLVV2tUnhlDaxyGHaMMJiQTDXZoA6FeK/o
         YFRg==
X-Gm-Message-State: AC+VfDwTDU+vJze73zvy+865t1+QWo2myYgtnfGgllFkQu8ZPCGwTOz1
        PFJxUJh5Ze/EnU35Q1hY9ok+Pan5/PH5SKXiQRY=
X-Google-Smtp-Source: ACHHUZ7ioNSgQh3N5lNUABusq6a3/WQZVkc9VPcGTxjTpbrtLfGRwbhzaYluLUWMUZZAi5VMzDYGlA==
X-Received: by 2002:a6b:b707:0:b0:780:cb36:6f24 with SMTP id h7-20020a6bb707000000b00780cb366f24mr18999149iof.2.1687972198812;
        Wed, 28 Jun 2023 10:09:58 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t11-20020a02c48b000000b0042aecf02051sm708342jam.51.2023.06.28.10.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 10:09:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: remove io_fallback_tw() forward declaration
Date:   Wed, 28 Jun 2023 11:09:52 -0600
Message-Id: <20230628170953.952923-3-axboe@kernel.dk>
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

It's used just one function higher up, get rid of the declaration and
just move it up a bit.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1b53a2ab0a27..f84d258ea348 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -149,7 +149,6 @@ static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 static void io_queue_sqe(struct io_kiocb *req);
 static void io_move_task_work_from_local(struct io_ring_ctx *ctx);
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
-static __cold void io_fallback_tw(struct io_uring_task *tctx);
 
 struct kmem_cache *req_cachep;
 
@@ -1238,6 +1237,20 @@ static inline struct llist_node *io_llist_cmpxchg(struct llist_head *head,
 	return cmpxchg(&head->first, old, new);
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
 void tctx_task_work(struct callback_head *cb)
 {
 	struct io_tw_state ts = {};
@@ -1279,20 +1292,6 @@ void tctx_task_work(struct callback_head *cb)
 	trace_io_uring_task_work_run(tctx, count, loops);
 }
 
-static __cold void io_fallback_tw(struct io_uring_task *tctx)
-{
-	struct llist_node *node = llist_del_all(&tctx->task_list);
-	struct io_kiocb *req;
-
-	while (node) {
-		req = container_of(node, struct io_kiocb, io_task_work.node);
-		node = node->next;
-		if (llist_add(&req->io_task_work.node,
-			      &req->ctx->fallback_llist))
-			schedule_delayed_work(&req->ctx->fallback_work, 1);
-	}
-}
-
 static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-- 
2.40.1

