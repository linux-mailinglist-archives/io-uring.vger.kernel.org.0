Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794D23E4544
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbhHIMFo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbhHIMFn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:43 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B08FC0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:23 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id l11-20020a7bcf0b0000b0290253545c2997so11369006wmg.4
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZSm24jvFKWXmy7uaTVxMb4Y61uiOZuc8uig93JJ3WeY=;
        b=DBz8BlIEpJTY8iajLMBJ1MFHUuZVAkXnjJxWlJsrcCYQ5HE+JRg62CEKwET1ZiTJ26
         XikGO9MBwAc3ZC8ixN4ZWiODbpfKJVM1t6f6kIRTzPrYiWEtxHHXwigN7FgtRQttz9Zi
         4aNXDC72MT1jK4IGf0MBaRzbB9gd4CJpUwsvI3T6Oz3QRFz6edC7qe6KAQiGJbTyl21C
         60hWc/WcIR//+99/d3wQGWg6MqLVnT2uOcz1WFgoPcu2v1op/j0IEv6I+SYICZgUW1LK
         c8Gl4ZoR+uv5rwWFnKPGqKjjO3V+k0Rwop9H7KCYwmQRkDCWqzqol/6ehxU+gxLojnTF
         SJvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZSm24jvFKWXmy7uaTVxMb4Y61uiOZuc8uig93JJ3WeY=;
        b=F0OL338bDJw5IIU09rGasUQlLmTWuCuJDM3JUkjdFnBWVWitn3/P1EcjmWTJs9a5/B
         9a9oSoJ35sCbYQeniKG0swhHflK6O9hQrnHz8mbNL/R+hXjfYh9pkH4FCEmSBjTjEw0i
         7vYaGqPdniUpZMt70GNe6T9uUU/khROx9jvNUAL1gzyLezhSqpJ8lhKFQn+CxZCFpSm1
         SLJp/huF5FLSv7dSHSdKrRxEi1ScE2HrXvZMyaNIvleppTVRsKiWbBFYA6qDBuvr1eEp
         RikXcrXRD1+aoS/beCPFEzZ6eYvJNTLlLgifRu57N4eYim5ffTQ60KURDFJZ18LdBx9m
         NXCg==
X-Gm-Message-State: AOAM530HsAYJwejHLRqkrD0j/yaSgT303DPPIcWz4JZySF2SbK7KCqtC
        7rT7DSa/PTsAmrBwJ28g+rg=
X-Google-Smtp-Source: ABdhPJzoFVdLizkH9j/WlWGMv9oh/Rvd6XK0LpPbqVoIwF+uuefDGsA4VHVZMG/M4HpAgLl4kbHJdA==
X-Received: by 2002:a7b:c8d9:: with SMTP id f25mr16043938wml.40.1628510721826;
        Mon, 09 Aug 2021 05:05:21 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 20/28] io_uring: optimise putting task struct
Date:   Mon,  9 Aug 2021 13:04:20 +0100
Message-Id: <6fe9646b3cb70e46aca1f58426776e368c8926b3.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We cache all the reference to task + tctx, so if io_put_task() is
called by the corresponding task itself, we can save on atomics and
return the refs right back into the cache.

It's beneficial for all inline completions, and also iopolling, when
polling and submissions are done by the same task, including
SQPOLL|IOPOLL.

Note: io_uring_cancel_generic() can return refs to the cache as well,
so those should be flushed in the loop for tctx_inflight() to work
right.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3c5c4cf73d1c..0982b0dba6b0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2099,10 +2099,12 @@ static inline void io_init_req_batch(struct req_batch *rb)
 static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 				     struct req_batch *rb)
 {
-	if (rb->task)
-		io_put_task(rb->task, rb->task_refs);
 	if (rb->ctx_refs)
 		percpu_ref_put_many(&ctx->refs, rb->ctx_refs);
+	if (rb->task == current)
+		current->io_uring->cached_refs += rb->task_refs;
+	else if (rb->task)
+		io_put_task(rb->task, rb->task_refs);
 }
 
 static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
@@ -9143,9 +9145,11 @@ static void io_uring_drop_tctx_refs(struct task_struct *task)
 	struct io_uring_task *tctx = task->io_uring;
 	unsigned int refs = tctx->cached_refs;
 
-	tctx->cached_refs = 0;
-	percpu_counter_sub(&tctx->inflight, refs);
-	put_task_struct_many(task, refs);
+	if (refs) {
+		tctx->cached_refs = 0;
+		percpu_counter_sub(&tctx->inflight, refs);
+		put_task_struct_many(task, refs);
+	}
 }
 
 /*
@@ -9166,9 +9170,9 @@ static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 	if (tctx->io_wq)
 		io_wq_exit_start(tctx->io_wq);
 
-	io_uring_drop_tctx_refs(current);
 	atomic_inc(&tctx->in_idle);
 	do {
+		io_uring_drop_tctx_refs(current);
 		/* read completions before cancelations */
 		inflight = tctx_inflight(tctx, !cancel_all);
 		if (!inflight)
@@ -9192,6 +9196,7 @@ static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		}
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
+		io_uring_drop_tctx_refs(current);
 		/*
 		 * If we've seen completions, retry without waiting. This
 		 * avoids a race where a completion comes in before we did
-- 
2.32.0

