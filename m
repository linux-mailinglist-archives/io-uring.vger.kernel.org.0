Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632846B5086
	for <lists+io-uring@lfdr.de>; Fri, 10 Mar 2023 20:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjCJTFl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Mar 2023 14:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjCJTFk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Mar 2023 14:05:40 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D3012FD2B;
        Fri, 10 Mar 2023 11:05:38 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id j3so4115944wms.2;
        Fri, 10 Mar 2023 11:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678475136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JIh61AeAslFvC/UqfgujvO6v8/4r94MTx+gfqjB4Zv0=;
        b=Qk1HKtJuMvfTdFkszk7Z7A4FFthMb55U7IdSXvMQLQzGdgM7/nTB6U+BKVjK4jKbBB
         /DAFsEQjq8pvgtd6aoGgKQ0SaiHpooVOaYnAbPIdMT9Y/HUy1BnK7t1m7d4siBSk+H1/
         CfIYPsxff5P8ddRmgEeAlShsm51M84eds2cWkJUn3xC8V6x5LzPQwjp43HyGqEGuvZFI
         7I2k8cwLf/9zRqOlzjxByL8zh7bnGWRrUZ+b6AWB41bpI62pi1dKzqugS2RefwlT4juk
         3ao6vTtketbTSFJ3w8FP+sPwMdp1ItYQyyGH+dQOH3xwpcQpYKTbLJC1gU+Y4gJl3VWo
         kItQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678475136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JIh61AeAslFvC/UqfgujvO6v8/4r94MTx+gfqjB4Zv0=;
        b=xvEcVlXX2I3y6RnrwY6T3YxoaAJ2fkUS0pRumTbP8IrRv8dOTj517cKvyEwkxDKxdJ
         uyfgcDo+owcYM38zpakhx0niBXCxERlyYo2Ktbt9ApVppm6kTGjajeywEQSFYyYQjTZw
         IHm36kqJYXF9FE/PsxPRBT9c/xwfQGucTWrD+1ytKrjTQpvSyYPDn7WV8Ij2kXLEkr0E
         MIF4oBF5x8gqrpycpp4AZdxP/4JFjsr4ejMtu2EM/d47i6YwEY64A4/Tw7YXIV3WvIXX
         BpzWUQu4TuH97wlCwCGhsUXOQZE1f5GsNEezIp5tAYl2tf7VFfkrsXzlCHDGBh5DdAQp
         T4cw==
X-Gm-Message-State: AO0yUKUrixzrFAGSIAylFvOlx7HyNc04CnqBDsuX1JkRiFjOFAi/zDyN
        UA0EklS1fCb3YSDyLLk3NEFm/OyOwF4=
X-Google-Smtp-Source: AK7set/aFrZFw7N4w4dVQ9r6eAubOHUCWHZgphebD8+7VqRRjXBb1bU/VfTDJhsZiySXo22yPDTPmA==
X-Received: by 2002:a05:600c:1da6:b0:3ea:e7f6:f8f9 with SMTP id p38-20020a05600c1da600b003eae7f6f8f9mr3726399wms.19.1678475136502;
        Fri, 10 Mar 2023 11:05:36 -0800 (PST)
Received: from 127.0.0.1localhost (188.30.129.33.threembb.co.uk. [188.30.129.33])
        by smtp.gmail.com with ESMTPSA id z19-20020a1c4c13000000b003e20cf0408esm647882wmf.40.2023.03.10.11.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 11:05:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [RFC 2/2] io_uring: reduce sheduling due to tw
Date:   Fri, 10 Mar 2023 19:04:16 +0000
Message-Id: <1001c8552cc79afc98ab778219e6ea3190ff37d9.1678474375.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1678474375.git.asml.silence@gmail.com>
References: <cover.1678474375.git.asml.silence@gmail.com>
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

Every task_work will try to wake the task to be executed, which causes
excessive scheduling with corresponding overhead. For some tw it's
justified, but others won't do much but post a single CQE.

When a task waits for multiple cqes, every such task_work will wake it
up. Instead, the task may give a hint about how many cqes it waits for,
io_req_local_work_add() will compare against it and skip wake ups
if #cqes + #tw items is not enough to satisfy the task. The optimisation
is used only for simple enough tws, more complex and/or urgent items
will force wake up. It's also limited to DEFER_TASKRUN.

The trade-off is having extra atomics in io_req_local_work_add() but
saving more on rescheduling the task..

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            | 41 +++++++++++++++++++++-------------
 io_uring/io_uring.h            |  1 +
 io_uring/notif.h               |  2 +-
 io_uring/rw.c                  |  2 +-
 5 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 00689c12f6ab..fdf0ae28023d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -295,7 +295,7 @@ struct io_ring_ctx {
 		spinlock_t		completion_lock;
 
 		bool			poll_multi_queue;
-		bool			cq_waiting;
+		atomic_t		cq_wait_nr;
 
 		/*
 		 * ->iopoll_list is protected by the ctx->uring_lock for
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 42ada470845f..0fa4dee8dcf4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1279,31 +1279,38 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx)
 	}
 }
 
-static void io_req_local_work_add(struct io_kiocb *req)
+static void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	bool first;
 
 	percpu_ref_get(&ctx->refs);
 
-	if (!llist_add(&req->io_task_work.node, &ctx->work_llist))
-		goto put_ref;
-
+	first = llist_add(&req->io_task_work.node, &ctx->work_llist);
 	/* needed for the following wake up */
 	smp_mb__after_atomic();
 
-	if (unlikely(atomic_read(&req->task->io_uring->in_cancel))) {
-		io_move_task_work_from_local(ctx);
-		goto put_ref;
+	if (first) {
+		if (unlikely(atomic_read(&req->task->io_uring->in_cancel))) {
+			io_move_task_work_from_local(ctx);
+			goto put_ref;
+		}
+
+		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+		if (ctx->has_evfd)
+			io_eventfd_signal(ctx);
 	}
 
-	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
-		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
-	if (ctx->has_evfd)
-		io_eventfd_signal(ctx);
+	if (atomic_read(&ctx->cq_wait_nr) <= 0)
+		goto put_ref;
 
-	if (READ_ONCE(ctx->cq_waiting))
-		wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
+	if (!(flags & IOU_F_TWQ_FACILE))
+		atomic_set(&ctx->cq_wait_nr, 0);
+	else if (atomic_dec_return(&ctx->cq_wait_nr) > 0)
+		goto put_ref;
 
+	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
 put_ref:
 	percpu_ref_put(&ctx->refs);
 }
@@ -1315,7 +1322,7 @@ void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
 
 	if (!(flags & IOU_F_TWQ_FORCE_NORMAL) &&
 	    (ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
-		io_req_local_work_add(req);
+		io_req_local_work_add(req, flags);
 		return;
 	}
 
@@ -2601,7 +2608,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		unsigned long check_cq;
 
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
-			WRITE_ONCE(ctx->cq_waiting, 1);
+			int to_wait = (int) iowq.cq_tail - READ_ONCE(ctx->rings->cq.tail);
+
+			atomic_set(&ctx->cq_wait_nr, to_wait);
 			set_current_state(TASK_INTERRUPTIBLE);
 		} else {
 			prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
@@ -2610,7 +2619,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 		ret = io_cqring_wait_schedule(ctx, &iowq);
 		__set_current_state(TASK_RUNNING);
-		WRITE_ONCE(ctx->cq_waiting, 0);
+		atomic_set(&ctx->cq_wait_nr, 0);
 
 		if (ret < 0)
 			break;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index cd2e702f206c..98ff9b71d498 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -18,6 +18,7 @@
 enum {
 	/* don't use deferred task_work */
 	IOU_F_TWQ_FORCE_NORMAL			= 1,
+	IOU_F_TWQ_FACILE			= 2,
 };
 
 enum {
diff --git a/io_uring/notif.h b/io_uring/notif.h
index c88c800cd89d..ec9998fb0be6 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -33,7 +33,7 @@ static inline void io_notif_flush(struct io_kiocb *notif)
 
 	/* drop slot's master ref */
 	if (refcount_dec_and_test(&nd->uarg.refcnt))
-		io_req_task_work_add(notif);
+		__io_req_task_work_add(notif, IOU_F_TWQ_FACILE);
 }
 
 static inline int io_notif_account_mem(struct io_kiocb *notif, unsigned len)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4c233910e200..a4578c120973 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -304,7 +304,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 		return;
 	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
 	req->io_task_work.func = io_req_rw_complete;
-	io_req_task_work_add(req);
+	__io_req_task_work_add(req, IOU_F_TWQ_FACILE);
 }
 
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
-- 
2.39.1

