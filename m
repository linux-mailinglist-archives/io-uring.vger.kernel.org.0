Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0CE32C99B
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240128AbhCDBKH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353860AbhCDAeL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:34:11 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B08C0610CF
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:30 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id o188so10882337pfg.2
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2okANeocaKJ1gfmTgxLGOyCGOrOFLcR/DL5JU2mAQHw=;
        b=KMaMlfGO159sSVUgMTpb483yg1T14t/ke1nQBOAzlw/xBq7Ud2tx/eaZ4zyiwE8KlQ
         vVNMLryNB9YG53ZVJWGzOivrtb1Viql8iH3iiTdt82l0NOBPYrsYszxEu7h5S0TjGAOx
         8xiZga9zTp+drwtwBkNkv6v9M1ajrJe4Podj6a42WuS8+q2hk81QPPGxlJzW9jw5TtQ2
         0oik+5utc1q/gX03TFiW9OxOXwAD0I1GX2kfsgQzHiLJP09KBJ9T0cSQOD0alUQSavQ3
         x3Nj9bkpbmEvTU/KdtR7uOAOd9tP5P5aLM7oWgyBtpLetB8XUIx2YSKJxSfw9zxlq5Bt
         RSsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2okANeocaKJ1gfmTgxLGOyCGOrOFLcR/DL5JU2mAQHw=;
        b=AjiC7hoxiyck+PKvVbZNVZvKW8PfPKQuTKtAxfSCaQBYKJFY+z8IwIt4QTNPuabqVx
         X1I/NyuVp1mhxjP2HWTGRLDJdVndgJ8xNJNRtcdYBIDXfrJhljdTimBAHAy2ORd7hvwP
         LlwozKTlyhl/lA+ADH0ROwajIuYcShGMXgjHbcgKY8qb/hiQQBxc8yyICxednWNagSXT
         Gj2G4XmbdAVySvFF+O82l0/7YjlgrNDNDbbonFB6jbe2BPUTgbnzHmGCAvXmkBoKB9gj
         U7Uc/FZLkG+6WFHdIIXMujAgPlRT4HsZie3DSEdUYj8HoR6bNWSPXMayIy5aMJhrDm/n
         uy7A==
X-Gm-Message-State: AOAM533YE5gHTpbTZ/f314IxMDHjzx77Q/RRaKjGjR63eOLD8XZvx7S4
        sXPccYjxaj1uiq6enZt/aVnc/NyqozXiDl9S
X-Google-Smtp-Source: ABdhPJxleznXIsBTocUp1wS53ucgWRRrAZgR1UpnkKe8y5OVmBxPUqVrIYgw1z56vGcZY4N1tdXkvw==
X-Received: by 2002:a63:1a07:: with SMTP id a7mr1300542pga.167.1614817649307;
        Wed, 03 Mar 2021 16:27:29 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:28 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        syzbot+a157ac7c03a56397f553@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 20/33] io_uring: fix __tctx_task_work() ctx race
Date:   Wed,  3 Mar 2021 17:26:47 -0700
Message-Id: <20210304002700.374417-21-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

There is an unlikely but possible race using a freed context. That's
because req->task_work.func() can free a request, but we won't
necessarily find a completion in submit_state.comp and so all ctx refs
may be put by the time we do mutex_lock(&ctx->uring_ctx);

There are several reasons why it can miss going through
submit_state.comp: 1) req->task_work.func() didn't complete it itself,
but punted to iowq (e.g. reissue) and it got freed later, or a similar
situation with it overflowing and getting flushed by someone else, or
being submitted to IRQ completion, 2) As we don't hold the uring_lock,
someone else can do io_submit_flush_completions() and put our ref.
3) Bugs and code obscurities, e.g. failing to propagate issue_flags
properly.

One example is as follows

  CPU1                                  |  CPU2
=======================================================================
@req->task_work.func()                  |
  -> @req overflwed,                    |
     so submit_state.comp,nr==0         |
                                        | flush overflows, and free @req
                                        | ctx refs == 0, free it
ctx is dead, but we do                  |
	lock + flush + unlock           |

So take a ctx reference for each new ctx we see in __tctx_task_work(),
and do release it until we do all our flushing.

Fixes: 65453d1efbd2 ("io_uring: enable req cache for task_work items")
Reported-by: syzbot+a157ac7c03a56397f553@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
[axboe: fold in my one-liner and fix ref mismatch]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f6bc0254cd01..befa0f4dd575 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1800,6 +1800,18 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	return __io_req_find_next(req);
 }
 
+static void ctx_flush_and_put(struct io_ring_ctx *ctx)
+{
+	if (!ctx)
+		return;
+	if (ctx->submit_state.comp.nr) {
+		mutex_lock(&ctx->uring_lock);
+		io_submit_flush_completions(&ctx->submit_state.comp, ctx);
+		mutex_unlock(&ctx->uring_lock);
+	}
+	percpu_ref_put(&ctx->refs);
+}
+
 static bool __tctx_task_work(struct io_uring_task *tctx)
 {
 	struct io_ring_ctx *ctx = NULL;
@@ -1817,30 +1829,20 @@ static bool __tctx_task_work(struct io_uring_task *tctx)
 	node = list.first;
 	while (node) {
 		struct io_wq_work_node *next = node->next;
-		struct io_ring_ctx *this_ctx;
 		struct io_kiocb *req;
 
 		req = container_of(node, struct io_kiocb, io_task_work.node);
-		this_ctx = req->ctx;
-		req->task_work.func(&req->task_work);
-		node = next;
-
-		if (!ctx) {
-			ctx = this_ctx;
-		} else if (ctx != this_ctx) {
-			mutex_lock(&ctx->uring_lock);
-			io_submit_flush_completions(&ctx->submit_state.comp, ctx);
-			mutex_unlock(&ctx->uring_lock);
-			ctx = this_ctx;
+		if (req->ctx != ctx) {
+			ctx_flush_and_put(ctx);
+			ctx = req->ctx;
+			percpu_ref_get(&ctx->refs);
 		}
-	}
 
-	if (ctx && ctx->submit_state.comp.nr) {
-		mutex_lock(&ctx->uring_lock);
-		io_submit_flush_completions(&ctx->submit_state.comp, ctx);
-		mutex_unlock(&ctx->uring_lock);
+		req->task_work.func(&req->task_work);
+		node = next;
 	}
 
+	ctx_flush_and_put(ctx);
 	return list.first != NULL;
 }
 
-- 
2.30.1

