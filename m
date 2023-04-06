Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1811D6D97F1
	for <lists+io-uring@lfdr.de>; Thu,  6 Apr 2023 15:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238366AbjDFNVH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Apr 2023 09:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237895AbjDFNU7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Apr 2023 09:20:59 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF549EC8;
        Thu,  6 Apr 2023 06:20:28 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id j22so1344216ejv.1;
        Thu, 06 Apr 2023 06:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680787226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z3skbR51DToc6t5YTcydSbJg47SV5f1fSwhxlZGFm+8=;
        b=jYvDqHgImpCfYiLEYukcp6QQOe3SArOcvxlqXicYgzrJ9KPpJXqNWMSA2Yyr0CUmhY
         Fz6Cd2Lbr5JYLBIs4HCAcvW12GV6jpq3UITRZ51shZvgtDL6XClK8aDGjPXOtM7aYKDm
         V+a/YUZuN1QJkiwbJ61RfAmS30r5ECNsFnOH3U9am8pdOLBcbRaUgO/DLnVGI1V/m3xu
         m+dphyDfeZ9EnywG/lpVsVT718l9417LKEAnp4xm1qfBxoS5u7H3wMDQGqvS5FhFchhD
         B0Inb1fw9/Dyb7qEMbIJtxtwcryB1EJEikHQjEfUKHyDxjEE36abwezra3PJqzthSYzW
         H/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680787226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z3skbR51DToc6t5YTcydSbJg47SV5f1fSwhxlZGFm+8=;
        b=cGGGtNiOgH9U1wRqgWuGszgf4e+9R4Lb6hNbFUIwzGYpY9etPAcvJmMIoHMIIhpI2W
         VYKvWyNpbt8gM5mQfmXSn/TcJkWr2NsZL1p9aRHWexYzKAQOSUk+jkVr3mV/rQcqOm4V
         7jGgra7aJsdiImMeVOHXPagIhCuEyWIe/+1iOTrdqUvYBLMMUcCdZ/wl7HV3qEm4ULY9
         xtmCXWisDFHoKq8ELq5Y1MVjoxqv5ANV/3IX0L0214hIoEG8gccC6aGWBgLfqemM2SV0
         0v9MsXhxDPMPvRktOrx7b9URj6WZZlWf+yHjbXvDMmqw/YwNPcTbNctYc4Kolyz1NSsK
         LGxQ==
X-Gm-Message-State: AAQBX9dsxIX4ttJ6n5Ldidlu7MgQQ9LNqtLmrQARm2oTDghKE+i9tbbe
        l49RxYMO555d7MlnpKvXu4Vv8ucyP4k=
X-Google-Smtp-Source: AKy350arsvVxjiEy7oV6GeeQ+k9sbyUU8hkmebn+HOHLlnIOZbftF55CVEF4zDvRyGal8t0JJ0qyUQ==
X-Received: by 2002:a17:906:5a88:b0:948:6e3d:a030 with SMTP id l8-20020a1709065a8800b009486e3da030mr6456873ejq.42.1680787226589;
        Thu, 06 Apr 2023 06:20:26 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a638])
        by smtp.gmail.com with ESMTPSA id m20-20020a509994000000b0050470aa444fsm312732edb.51.2023.04.06.06.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 06:20:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/8] io_uring: reduce scheduling due to tw
Date:   Thu,  6 Apr 2023 14:20:12 +0100
Message-Id: <d2b77e99d1e86624d8a69f7037d764b739dcd225.1680782017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1680782016.git.asml.silence@gmail.com>
References: <cover.1680782016.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Every task_work will try to wake the task to be executed, which causes
excessive scheduling and additional overhead. For some tw it's
justified, but others won't do much but post a single CQE.

When a task waits for multiple cqes, every such task_work will wake it
up. Instead, the task may give a hint about how many cqes it waits for,
io_req_local_work_add() will compare against it and skip wake ups
if #cqes + #tw is not enough to satisfy the waiting condition. Task_work
that uses the optimisation should be simple enough and never post more
than one CQE. It's also ignored for non DEFER_TASKRUN rings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  3 +-
 io_uring/io_uring.c            | 68 +++++++++++++++++++++++-----------
 io_uring/io_uring.h            |  9 +++++
 io_uring/notif.c               |  2 +-
 io_uring/notif.h               |  2 +-
 io_uring/rw.c                  |  2 +-
 6 files changed, 61 insertions(+), 25 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 4a6ce03a4903..fa621a508a01 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -296,7 +296,7 @@ struct io_ring_ctx {
 		spinlock_t		completion_lock;
 
 		bool			poll_multi_queue;
-		bool			cq_waiting;
+		atomic_t		cq_wait_nr;
 
 		/*
 		 * ->iopoll_list is protected by the ctx->uring_lock for
@@ -566,6 +566,7 @@ struct io_kiocb {
 	atomic_t			refs;
 	atomic_t			poll_refs;
 	struct io_task_work		io_task_work;
+	unsigned			nr_tw;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	union {
 		struct hlist_node	hash_node;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 786ecfa01c54..8a327a81beaf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1300,35 +1300,59 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx)
 	}
 }
 
-static void io_req_local_work_add(struct io_kiocb *req)
+static void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	unsigned nr_wait, nr_tw, nr_tw_prev;
 	struct llist_node *first;
 
+	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
+		flags &= ~IOU_F_TWQ_LAZY_WAKE;
+
 	first = READ_ONCE(ctx->work_llist.first);
 	do {
+		nr_tw_prev = 0;
+		if (first) {
+			struct io_kiocb *first_req = container_of(first,
+							struct io_kiocb,
+							io_task_work.node);
+			/*
+			 * Might be executed at any moment, rely on
+			 * SLAB_TYPESAFE_BY_RCU to keep it alive.
+			 */
+			nr_tw_prev = READ_ONCE(first_req->nr_tw);
+		}
+		nr_tw = nr_tw_prev + 1;
+		/* Large enough to fail the nr_wait comparison below */
+		if (!(flags & IOU_F_TWQ_LAZY_WAKE))
+			nr_tw = -1U;
+
+		req->nr_tw = nr_tw;
 		req->io_task_work.node.next = first;
 	} while (!try_cmpxchg(&ctx->work_llist.first, &first,
 			      &req->io_task_work.node));
 
-	if (first)
-		return;
-
-	/* needed for the following wake up */
-	smp_mb__after_atomic();
-
-	if (unlikely(atomic_read(&req->task->io_uring->in_cancel))) {
-		io_move_task_work_from_local(ctx);
-		return;
+	if (!first) {
+		if (unlikely(atomic_read(&req->task->io_uring->in_cancel))) {
+			io_move_task_work_from_local(ctx);
+			return;
+		}
+		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+		if (ctx->has_evfd)
+			io_eventfd_signal(ctx);
 	}
 
-	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
-		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
-	if (ctx->has_evfd)
-		io_eventfd_signal(ctx);
-
-	if (READ_ONCE(ctx->cq_waiting))
-		wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
+	nr_wait = atomic_read(&ctx->cq_wait_nr);
+	/* no one is waiting */
+	if (!nr_wait)
+		return;
+	/* either not enough or the previous add has already woken it up */
+	if (nr_wait > nr_tw || nr_tw_prev >= nr_wait)
+		return;
+	/* pairs with set_current_state() in io_cqring_wait() */
+	smp_mb__after_atomic();
+	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
 }
 
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
@@ -1339,7 +1363,7 @@ void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
 	if (!(flags & IOU_F_TWQ_FORCE_NORMAL) &&
 	    (ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
 		rcu_read_lock();
-		io_req_local_work_add(req);
+		io_req_local_work_add(req, flags);
 		rcu_read_unlock();
 		return;
 	}
@@ -2625,7 +2649,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		unsigned long check_cq;
 
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
-			WRITE_ONCE(ctx->cq_waiting, 1);
+			int nr_wait = (int) iowq.cq_tail - READ_ONCE(ctx->rings->cq.tail);
+
+			atomic_set(&ctx->cq_wait_nr, nr_wait);
 			set_current_state(TASK_INTERRUPTIBLE);
 		} else {
 			prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
@@ -2634,7 +2660,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 		ret = io_cqring_wait_schedule(ctx, &iowq);
 		__set_current_state(TASK_RUNNING);
-		WRITE_ONCE(ctx->cq_waiting, 0);
+		atomic_set(&ctx->cq_wait_nr, 0);
 
 		if (ret < 0)
 			break;
@@ -4517,7 +4543,7 @@ static int __init io_uring_init(void)
 	io_uring_optable_init();
 
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
-				SLAB_ACCOUNT);
+				SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU);
 	return 0;
 };
 __initcall(io_uring_init);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index cb4309a2acdc..ef449e43d493 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -18,6 +18,15 @@
 enum {
 	/* don't use deferred task_work */
 	IOU_F_TWQ_FORCE_NORMAL			= 1,
+
+	/*
+	 * A hint to not wake right away but delay until there are enough of
+	 * tw's queued to match the number of CQEs the task is waiting for.
+	 *
+	 * Must not be used wirh requests generating more than one CQE.
+	 * It's also ignored unless IORING_SETUP_DEFER_TASKRUN is set.
+	 */
+	IOU_F_TWQ_LAZY_WAKE			= 2,
 };
 
 enum {
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 172105eb347d..e1846a25dde1 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -31,7 +31,7 @@ static void io_tx_ubuf_callback(struct sk_buff *skb, struct ubuf_info *uarg,
 	struct io_kiocb *notif = cmd_to_io_kiocb(nd);
 
 	if (refcount_dec_and_test(&uarg->refcnt))
-		io_req_task_work_add(notif);
+		__io_req_task_work_add(notif, IOU_F_TWQ_LAZY_WAKE);
 }
 
 static void io_tx_ubuf_callback_ext(struct sk_buff *skb, struct ubuf_info *uarg,
diff --git a/io_uring/notif.h b/io_uring/notif.h
index c88c800cd89d..6dd1b30a468f 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -33,7 +33,7 @@ static inline void io_notif_flush(struct io_kiocb *notif)
 
 	/* drop slot's master ref */
 	if (refcount_dec_and_test(&nd->uarg.refcnt))
-		io_req_task_work_add(notif);
+		__io_req_task_work_add(notif, IOU_F_TWQ_LAZY_WAKE);
 }
 
 static inline int io_notif_account_mem(struct io_kiocb *notif, unsigned len)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index f14868624f41..6c7d2654770e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -304,7 +304,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 		return;
 	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
 	req->io_task_work.func = io_req_rw_complete;
-	io_req_task_work_add(req);
+	__io_req_task_work_add(req, IOU_F_TWQ_LAZY_WAKE);
 }
 
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
-- 
2.40.0

