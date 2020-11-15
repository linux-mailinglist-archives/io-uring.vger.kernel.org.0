Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0D52B34FC
	for <lists+io-uring@lfdr.de>; Sun, 15 Nov 2020 13:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgKOM7r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 07:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgKOM7r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 07:59:47 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B257FC0613D1
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 04:59:46 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id a3so21151937wmb.5
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 04:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LPXo98gRuejN6BC9sLPpThN7ibOs8WoUY5SZnxJlcOw=;
        b=iMJYi7IPioYCORKZwa6gQ+LNwOFAQQN8o8rKU+50nV4QiSr1Jqgxt0jaNcjdiUd3gT
         Ti9FfWc61o7YpnvM+/EazyUZ1/EtIImbWGic3BAsQ6R3mlLBbE/vhb4GB6jcVaUNVAcE
         JsdjujoZxYd+IA+UN3t8fdtlyfNfhK5g+RiBamZnhv0prZa9qkP5V95vsXOTHQKamAWV
         290HRv3uDutm9M8duUgPgZBICZZiMUco44sF+cAmAOOoPPlBk121vjgEWQ8482R7AcVI
         DdzJTp/iUEGeSZJVtw83u6SPrObXinouy/FBhESUcbVVFPAfC1X2tbhEFGDrG5ZaaYVW
         PyYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LPXo98gRuejN6BC9sLPpThN7ibOs8WoUY5SZnxJlcOw=;
        b=TvOpKbUBSyZDVDOnAHLFbBoAYViUacJYtDT+NsdOYolEoti8pMQFx38Czkgx0zpmWy
         lk85QQaoBAWYqZdT9M77TTQHSBf0/hl4oUhUH/JOKBcbVJDnd6DCjeKFBRVqFX9I+QXb
         S864BVMupv7qLWZi7dGMyr6i2ZvzPngRIFVpnA7qqjAZ4E05fnY1e5ZwBKjJOvbvvtcL
         u9QFtFazYjhpOr6ZCXeSTdVE0a3jgfPD/lc4EGxxiQld6fpc+01/UJuVFMTBfzoFhdoi
         c5n4F8zcJN4b4kex9EOzd+Mrki3+icL3/z2brl1WRFlOIRQaIGqVX6MYOj9IQVX6y8O4
         BE+A==
X-Gm-Message-State: AOAM531yNGtFJ4OtBuiHmahOIgOTIeYHwsCTfev8j1qzVLIAflC3fz5h
        WQayfqWModQN33zHCXChl0I=
X-Google-Smtp-Source: ABdhPJzTApVkZdBhvskH0snDcKjaAABe/iqq5hhKghaHH0dklZi3cR6ScQFnHappg/kNxffYfpBP3Q==
X-Received: by 2002:a05:600c:22c5:: with SMTP id 5mr10816105wmg.25.1605445184729;
        Sun, 15 Nov 2020 04:59:44 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id b14sm18139887wrs.46.2020.11.15.04.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 04:59:44 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: replace inflight_wait with tctx->wait
Date:   Sun, 15 Nov 2020 12:56:32 +0000
Message-Id: <ce4f91e603b524b6425d68cf49c83c7d4fbd7d79.1605444955.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As tasks now cancel only theirs requests, and inflight_wait is awaited
only in io_uring_cancel_files(), which should be called with ->in_idle
set, instead of keeping a separate inflight_wait use tctx->wait.

That will add some spurious wakeups but actually is safer from point of
not hanging the task.

e.g.
task1                   | IRQ
                        | *start* io_complete_rw_common(link)
                        |        link: req1 -> req2 -> req3(with files)
*cancel_files()         |
io_wq_cancel(), etc.    |
                        | put_req(link), adds to io-wq req2
schedule()              |

So, task1 will never try to cancel req2 or req3. If req2 is
long-standing (e.g. read(empty_pipe)), this may hang.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index feb8e5bd2fb2..1a7ac86a0b92 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -286,7 +286,6 @@ struct io_ring_ctx {
 		struct list_head	timeout_list;
 		struct list_head	cq_overflow_list;
 
-		wait_queue_head_t	inflight_wait;
 		struct io_uring_sqe	*sq_sqes;
 	} ____cacheline_aligned_in_smp;
 
@@ -1300,7 +1299,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
-	init_waitqueue_head(&ctx->inflight_wait);
 	spin_lock_init(&ctx->inflight_lock);
 	INIT_LIST_HEAD(&ctx->inflight_list);
 	INIT_DELAYED_WORK(&ctx->file_put_work, io_file_put_work);
@@ -6081,12 +6079,13 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static void io_req_drop_files(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_uring_task *tctx = req->task->io_uring;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->inflight_lock, flags);
 	list_del(&req->inflight_entry);
-	if (waitqueue_active(&ctx->inflight_wait))
-		wake_up(&ctx->inflight_wait);
+	if (atomic_read(&tctx->in_idle))
+		wake_up(&tctx->wait);
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
 	put_files_struct(req->work.identity->files);
@@ -8721,8 +8720,8 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			break;
 		}
 		if (found)
-			prepare_to_wait(&ctx->inflight_wait, &wait,
-						TASK_UNINTERRUPTIBLE);
+			prepare_to_wait(&task->io_uring->wait, &wait,
+					TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(&ctx->inflight_lock);
 
 		/* We need to keep going until we don't find a matching req */
@@ -8735,7 +8734,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 		/* cancellations _may_ trigger task work */
 		io_run_task_work();
 		schedule();
-		finish_wait(&ctx->inflight_wait, &wait);
+		finish_wait(&task->io_uring->wait, &wait);
 	}
 }
 
-- 
2.24.0

