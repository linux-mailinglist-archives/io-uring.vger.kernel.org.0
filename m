Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339743E453D
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbhHIMFh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbhHIMFg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:36 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773ADC0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:16 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id u1so421577wmm.0
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=CnYM3OvFkyR8siTD79qVF6fXzdQh3X28WKQWmqdKfTo=;
        b=tuIoWfBoPKKicDOaI11mOd9eC1jFNaxvnjsKU7cR07xhong9H2QMIX9B7ikk+Civob
         ElqhUL9AZnCfOXjJ8yHZrWlt7RK0Cg9J7zCT5hL8z90rrnGvksKDO6qjaDEzbP2pgobg
         KjXp1IY0jYD4piQWWgKCD0qAagBEd9o6NrDYkTvw0ijXqWgPaTEgFdCkjEtG25TKi9a1
         /cqfPDLexeRvabrNOwyQKN8T+FSzBLCCuSgR68gdo1XGlUOCgU3T+gNntupEovjmBI60
         Oq2Nugo8Ksaa8e8KQnQG7yBIaFfwpmzKT0/cZNB/bRd7gNCzhqf4u9exOnyb6hRevPlR
         2TuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CnYM3OvFkyR8siTD79qVF6fXzdQh3X28WKQWmqdKfTo=;
        b=oRGq6zgC5Koj3wALxl5tB2WSZKnL63kOzEmNJXr66yeuCBvFQCX6B2roosgQFQil9/
         qFPZ/FDJpWZCb2qIM4I+PfclettE/XEZiW6woJWzVQNzTWkzKIGIzCa0gcaaXEGffNlz
         7gfu2YYDhl2egxg2NPZzuGQSoMrmUwLEd1lQdvFpySPNUlp0M7sBOU3TjpMyCBjJG9hT
         m5WCFFsjyVLwgPuJgro2uksngKBPPsq0bik+wrT2DROcbq48hB9C/fgEUDcLIDhG+Lhb
         4o577p/uIQJvce00Xl8+XPCi9FV09Z2ASQRdDkA6jJjGhaInah8/ZF6teH/01Agg3UDV
         6KRg==
X-Gm-Message-State: AOAM53390zhte0+2sQHFFLiYYmLclzXVhHelUOrez60ccO92AnwQK67W
        o3UrB97X/T0vsX8EGSFZ0L4=
X-Google-Smtp-Source: ABdhPJxHbPeIS+KQMKmQjkszz+jQnVy4t9DBXuvjEeM7SQh7qJG8C1ZyYxpGdieKVGPnUY8t3JgsJw==
X-Received: by 2002:a7b:c932:: with SMTP id h18mr16244143wml.152.1628510715177;
        Mon, 09 Aug 2021 05:05:15 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 13/28] io_uring: move io_put_task() definition
Date:   Mon,  9 Aug 2021 13:04:13 +0100
Message-Id: <33d917d69e4206557c75a5b98fe22bcdf77ce47d.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move the function in the source file as it is to get rid of forward
declarations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 292dbf10e316..fc778724acd5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1051,7 +1051,6 @@ static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req, int nr);
 static void io_dismantle_req(struct io_kiocb *req);
-static void io_put_task(struct task_struct *task, int nr);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
@@ -1570,6 +1569,17 @@ static inline void req_ref_get(struct io_kiocb *req)
 	atomic_inc(&req->refs);
 }
 
+/* must to be called somewhat shortly after putting a request */
+static inline void io_put_task(struct task_struct *task, int nr)
+{
+	struct io_uring_task *tctx = task->io_uring;
+
+	percpu_counter_sub(&tctx->inflight, nr);
+	if (unlikely(atomic_read(&tctx->in_idle)))
+		wake_up(&tctx->wait);
+	put_task_struct_many(task, nr);
+}
+
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 				     long res, unsigned int cflags)
 {
@@ -1806,17 +1816,6 @@ static void io_dismantle_req(struct io_kiocb *req)
 	}
 }
 
-/* must to be called somewhat shortly after putting a request */
-static inline void io_put_task(struct task_struct *task, int nr)
-{
-	struct io_uring_task *tctx = task->io_uring;
-
-	percpu_counter_sub(&tctx->inflight, nr);
-	if (unlikely(atomic_read(&tctx->in_idle)))
-		wake_up(&tctx->wait);
-	put_task_struct_many(task, nr);
-}
-
 static void __io_free_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-- 
2.32.0

