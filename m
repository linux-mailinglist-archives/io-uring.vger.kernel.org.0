Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052B354E143
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 14:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbiFPM6s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 08:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbiFPM6r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 08:58:47 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DD734655
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 05:58:45 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id me5so2647202ejb.2
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 05:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2+SyeFrjODQ4tx6C8WZaOMwNU7ZFz0rTky2Fsyw8pF8=;
        b=T0QlIdOBo5gJyT2jt8N9TjUd12nmnoyK2Xh4689m0poy6Eib9y6KzD/99V9kBNd41B
         RO6AcNi/mh2QAmay0pIt6vqesJsOhBTPqH+UfzHNu100D8YPNom42pLFO8vfaA6ni0ZJ
         AanFvM6wqCb1sefSFb0ilArcrHuGPFUiLJEdekXscdky9Fo92XGiq2512gavuHtQhkTL
         dzTqTOOvkeYdCX+FARRzgl2gNsMW1u/8TAhDPo8Ye4mRjiQm7fO32sXQZ8iCPQmAgINk
         IHLOD7KQQDiYzuag1vkMLu5xoBLQvImEIHvp7DYzth1q1Si+d4ipbZega5sFkeySMO04
         8Pkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2+SyeFrjODQ4tx6C8WZaOMwNU7ZFz0rTky2Fsyw8pF8=;
        b=1Dx4FUPABEs4mqr06JXPPCpxGbeUxDvuUNdGndelOw7MtQ0yplmpYSLzt5cTha1ZVm
         bKVWdmoU52SqWsNAQEOvy+CTzrng6E+gIjHiGpCWgnZUc7+UILEZmaW8THtXOQlSVaio
         WAW2P44NV1b1SQL1XN/oHtYHZ9ZCAQ3m3ze1+4SmNu3PtW2/+n6bPdSpK3BTBgWXrnHG
         b4l8aRj8HBjtiNbWDoNa5S5F5ac8m2pkvDoB/D42zFrD0OHAX/Ew7HxCXx+ZZgfd7zpV
         nuEZbBTZIiYGkfEl9cR/Tjks8I230mKajT7m9Wo+paXjfdz4rfa9ZNozHrxuBk/x6YfD
         szZg==
X-Gm-Message-State: AJIora+1Z8a7TapuxAKyqpu+zkQ4RybiWuHGvRDCf7QMeXG/049PRDo5
        fk0CjCFtOwRySkTP6OXBrjtIoHtWR2jpFg==
X-Google-Smtp-Source: AGRyM1vdiDeJewoEdT+jKwkxF/G3Dnjs0HL7nZwqQ3iBEUbg6nwdjTBjDvRjuMyEjspphcL6ufmNnA==
X-Received: by 2002:a17:907:c24:b0:711:d4c6:9161 with SMTP id ga36-20020a1709070c2400b00711d4c69161mr4534013ejc.760.1655384323959;
        Thu, 16 Jun 2022 05:58:43 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:139d])
        by smtp.gmail.com with ESMTPSA id j17-20020a17090623f100b00711d5baae0esm746896ejg.145.2022.06.16.05.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 05:58:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/3] io_uring: clean up tracing events
Date:   Thu, 16 Jun 2022 13:57:20 +0100
Message-Id: <40ff72f92798114e56d400f2b003beb6cde6ef53.1655384063.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655384063.git.asml.silence@gmail.com>
References: <cover.1655384063.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have lots of trace events accepting an io_uring request and wanting
to print some of its fields like user_data, opcode, flags and so on.
However, as trace points were unaware of io_uring structures, we had to
pass all the fields as arguments. Teach trace/events/io_uring.h about
struct io_kiocb and stop the misery of passing a horde of arguments to
trace helpers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/trace/events/io_uring.h | 118 ++++++++++++--------------------
 io_uring/io_uring.c             |  16 ++---
 io_uring/poll.c                 |   5 +-
 io_uring/timeout.c              |   3 +-
 4 files changed, 54 insertions(+), 88 deletions(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 66fcc5a1a5b1..5635912e1013 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -7,6 +7,7 @@
 
 #include <linux/tracepoint.h>
 #include <uapi/linux/io_uring.h>
+#include <linux/io_uring_types.h>
 #include <linux/io_uring.h>
 
 struct io_wq_work;
@@ -97,9 +98,7 @@ TRACE_EVENT(io_uring_register,
 /**
  * io_uring_file_get - called before getting references to an SQE file
  *
- * @ctx:	pointer to a ring context structure
  * @req:	pointer to a submitted request
- * @user_data:	user data associated with the request
  * @fd:		SQE file descriptor
  *
  * Allows to trace out how often an SQE file reference is obtained, which can
@@ -108,9 +107,9 @@ TRACE_EVENT(io_uring_register,
  */
 TRACE_EVENT(io_uring_file_get,
 
-	TP_PROTO(void *ctx, void *req, unsigned long long user_data, int fd),
+	TP_PROTO(struct io_kiocb *req, int fd),
 
-	TP_ARGS(ctx, req, user_data, fd),
+	TP_ARGS(req, fd),
 
 	TP_STRUCT__entry (
 		__field(  void *,	ctx		)
@@ -120,9 +119,9 @@ TRACE_EVENT(io_uring_file_get,
 	),
 
 	TP_fast_assign(
-		__entry->ctx		= ctx;
+		__entry->ctx		= req->ctx;
 		__entry->req		= req;
-		__entry->user_data	= user_data;
+		__entry->user_data	= req->cqe.user_data;
 		__entry->fd		= fd;
 	),
 
@@ -133,22 +132,16 @@ TRACE_EVENT(io_uring_file_get,
 /**
  * io_uring_queue_async_work - called before submitting a new async work
  *
- * @ctx:	pointer to a ring context structure
  * @req:	pointer to a submitted request
- * @user_data:	user data associated with the request
- * @opcode:	opcode of request
- * @flags	request flags
- * @work:	pointer to a submitted io_wq_work
  * @rw:		type of workqueue, hashed or normal
  *
  * Allows to trace asynchronous work submission.
  */
 TRACE_EVENT(io_uring_queue_async_work,
 
-	TP_PROTO(void *ctx, void * req, unsigned long long user_data, u8 opcode,
-		unsigned int flags, struct io_wq_work *work, int rw),
+	TP_PROTO(struct io_kiocb *req, int rw),
 
-	TP_ARGS(ctx, req, user_data, opcode, flags, work, rw),
+	TP_ARGS(req, rw),
 
 	TP_STRUCT__entry (
 		__field(  void *,			ctx		)
@@ -161,12 +154,12 @@ TRACE_EVENT(io_uring_queue_async_work,
 	),
 
 	TP_fast_assign(
-		__entry->ctx		= ctx;
+		__entry->ctx		= req->ctx;
 		__entry->req		= req;
-		__entry->user_data	= user_data;
-		__entry->flags		= flags;
-		__entry->opcode		= opcode;
-		__entry->work		= work;
+		__entry->user_data	= req->cqe.user_data;
+		__entry->flags		= req->flags;
+		__entry->opcode		= req->opcode;
+		__entry->work		= &req->work;
 		__entry->rw		= rw;
 	),
 
@@ -179,19 +172,16 @@ TRACE_EVENT(io_uring_queue_async_work,
 /**
  * io_uring_defer - called when an io_uring request is deferred
  *
- * @ctx:	pointer to a ring context structure
  * @req:	pointer to a deferred request
- * @user_data:	user data associated with the request
- * @opcode:	opcode of request
  *
  * Allows to track deferred requests, to get an insight about what requests are
  * not started immediately.
  */
 TRACE_EVENT(io_uring_defer,
 
-	TP_PROTO(void *ctx, void *req, unsigned long long user_data, u8 opcode),
+	TP_PROTO(struct io_kiocb *req),
 
-	TP_ARGS(ctx, req, user_data, opcode),
+	TP_ARGS(req),
 
 	TP_STRUCT__entry (
 		__field(  void *,		ctx	)
@@ -201,10 +191,10 @@ TRACE_EVENT(io_uring_defer,
 	),
 
 	TP_fast_assign(
-		__entry->ctx	= ctx;
+		__entry->ctx	= req->ctx;
 		__entry->req	= req;
-		__entry->data	= user_data;
-		__entry->opcode	= opcode;
+		__entry->data	= req->cqe.user_data;
+		__entry->opcode	= req->opcode;
 	),
 
 	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s",
@@ -216,7 +206,6 @@ TRACE_EVENT(io_uring_defer,
  * io_uring_link - called before the io_uring request added into link_list of
  * 		   another request
  *
- * @ctx:		pointer to a ring context structure
  * @req:		pointer to a linked request
  * @target_req:		pointer to a previous request, that would contain @req
  *
@@ -225,9 +214,9 @@ TRACE_EVENT(io_uring_defer,
  */
 TRACE_EVENT(io_uring_link,
 
-	TP_PROTO(void *ctx, void *req, void *target_req),
+	TP_PROTO(struct io_kiocb *req, struct io_kiocb *target_req),
 
-	TP_ARGS(ctx, req, target_req),
+	TP_ARGS(req, target_req),
 
 	TP_STRUCT__entry (
 		__field(  void *,	ctx		)
@@ -236,7 +225,7 @@ TRACE_EVENT(io_uring_link,
 	),
 
 	TP_fast_assign(
-		__entry->ctx		= ctx;
+		__entry->ctx		= req->ctx;
 		__entry->req		= req;
 		__entry->target_req	= target_req;
 	),
@@ -277,10 +266,7 @@ TRACE_EVENT(io_uring_cqring_wait,
 /**
  * io_uring_fail_link - called before failing a linked request
  *
- * @ctx:	pointer to a ring context structure
  * @req:	request, which links were cancelled
- * @user_data:	user data associated with the request
- * @opcode:	opcode of request
  * @link:	cancelled link
  *
  * Allows to track linked requests cancellation, to see not only that some work
@@ -288,9 +274,9 @@ TRACE_EVENT(io_uring_cqring_wait,
  */
 TRACE_EVENT(io_uring_fail_link,
 
-	TP_PROTO(void *ctx, void *req, unsigned long long user_data, u8 opcode, void *link),
+	TP_PROTO(struct io_kiocb *req, struct io_kiocb *link),
 
-	TP_ARGS(ctx, req, user_data, opcode, link),
+	TP_ARGS(req, link),
 
 	TP_STRUCT__entry (
 		__field(  void *,		ctx		)
@@ -301,10 +287,10 @@ TRACE_EVENT(io_uring_fail_link,
 	),
 
 	TP_fast_assign(
-		__entry->ctx		= ctx;
+		__entry->ctx		= req->ctx;
 		__entry->req		= req;
-		__entry->user_data	= user_data;
-		__entry->opcode		= opcode;
+		__entry->user_data	= req->cqe.user_data;
+		__entry->opcode		= req->opcode;
 		__entry->link		= link;
 	),
 
@@ -364,23 +350,17 @@ TRACE_EVENT(io_uring_complete,
 /**
  * io_uring_submit_sqe - called before submitting one SQE
  *
- * @ctx:		pointer to a ring context structure
  * @req:		pointer to a submitted request
- * @user_data:		user data associated with the request
- * @opcode:		opcode of request
- * @flags		request flags
  * @force_nonblock:	whether a context blocking or not
- * @sq_thread:		true if sq_thread has submitted this SQE
  *
  * Allows to track SQE submitting, to understand what was the source of it, SQ
  * thread or io_uring_enter call.
  */
 TRACE_EVENT(io_uring_submit_sqe,
 
-	TP_PROTO(void *ctx, void *req, unsigned long long user_data, u8 opcode, u32 flags,
-		 bool force_nonblock, bool sq_thread),
+	TP_PROTO(struct io_kiocb *req, bool force_nonblock),
 
-	TP_ARGS(ctx, req, user_data, opcode, flags, force_nonblock, sq_thread),
+	TP_ARGS(req, force_nonblock),
 
 	TP_STRUCT__entry (
 		__field(  void *,		ctx		)
@@ -393,13 +373,13 @@ TRACE_EVENT(io_uring_submit_sqe,
 	),
 
 	TP_fast_assign(
-		__entry->ctx		= ctx;
+		__entry->ctx		= req->ctx;
 		__entry->req		= req;
-		__entry->user_data	= user_data;
-		__entry->opcode		= opcode;
-		__entry->flags		= flags;
+		__entry->user_data	= req->cqe.user_data;
+		__entry->opcode		= req->opcode;
+		__entry->flags		= req->flags;
 		__entry->force_nonblock	= force_nonblock;
-		__entry->sq_thread	= sq_thread;
+		__entry->sq_thread	= req->ctx->flags & IORING_SETUP_SQPOLL;
 	),
 
 	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, flags 0x%x, "
@@ -411,10 +391,7 @@ TRACE_EVENT(io_uring_submit_sqe,
 /*
  * io_uring_poll_arm - called after arming a poll wait if successful
  *
- * @ctx:		pointer to a ring context structure
  * @req:		pointer to the armed request
- * @user_data:		user data associated with the request
- * @opcode:		opcode of request
  * @mask:		request poll events mask
  * @events:		registered events of interest
  *
@@ -423,10 +400,9 @@ TRACE_EVENT(io_uring_submit_sqe,
  */
 TRACE_EVENT(io_uring_poll_arm,
 
-	TP_PROTO(void *ctx, void *req, u64 user_data, u8 opcode,
-		 int mask, int events),
+	TP_PROTO(struct io_kiocb *req, int mask, int events),
 
-	TP_ARGS(ctx, req, user_data, opcode, mask, events),
+	TP_ARGS(req, mask, events),
 
 	TP_STRUCT__entry (
 		__field(  void *,		ctx		)
@@ -438,10 +414,10 @@ TRACE_EVENT(io_uring_poll_arm,
 	),
 
 	TP_fast_assign(
-		__entry->ctx		= ctx;
+		__entry->ctx		= req->ctx;
 		__entry->req		= req;
-		__entry->user_data	= user_data;
-		__entry->opcode		= opcode;
+		__entry->user_data	= req->cqe.user_data;
+		__entry->opcode		= req->opcode;
 		__entry->mask		= mask;
 		__entry->events		= events;
 	),
@@ -455,18 +431,15 @@ TRACE_EVENT(io_uring_poll_arm,
 /*
  * io_uring_task_add - called after adding a task
  *
- * @ctx:		pointer to a ring context structure
  * @req:		pointer to request
- * @user_data:		user data associated with the request
- * @opcode:		opcode of request
  * @mask:		request poll events mask
  *
  */
 TRACE_EVENT(io_uring_task_add,
 
-	TP_PROTO(void *ctx, void *req, unsigned long long user_data, u8 opcode, int mask),
+	TP_PROTO(struct io_kiocb *req, int mask),
 
-	TP_ARGS(ctx, req, user_data, opcode, mask),
+	TP_ARGS(req, mask),
 
 	TP_STRUCT__entry (
 		__field(  void *,		ctx		)
@@ -477,10 +450,10 @@ TRACE_EVENT(io_uring_task_add,
 	),
 
 	TP_fast_assign(
-		__entry->ctx		= ctx;
+		__entry->ctx		= req->ctx;
 		__entry->req		= req;
-		__entry->user_data	= user_data;
-		__entry->opcode		= opcode;
+		__entry->user_data	= req->cqe.user_data;
+		__entry->opcode		= req->opcode;
 		__entry->mask		= mask;
 	),
 
@@ -494,7 +467,6 @@ TRACE_EVENT(io_uring_task_add,
  * io_uring_req_failed - called when an sqe is errored dring submission
  *
  * @sqe:		pointer to the io_uring_sqe that failed
- * @ctx:		pointer to a ring context structure
  * @req:		pointer to request
  * @error:		error it failed with
  *
@@ -502,9 +474,9 @@ TRACE_EVENT(io_uring_task_add,
  */
 TRACE_EVENT(io_uring_req_failed,
 
-	TP_PROTO(const struct io_uring_sqe *sqe, void *ctx, void *req, int error),
+	TP_PROTO(const struct io_uring_sqe *sqe, struct io_kiocb *req, int error),
 
-	TP_ARGS(sqe, ctx, req, error),
+	TP_ARGS(sqe, req, error),
 
 	TP_STRUCT__entry (
 		__field(  void *,		ctx		)
@@ -526,7 +498,7 @@ TRACE_EVENT(io_uring_req_failed,
 	),
 
 	TP_fast_assign(
-		__entry->ctx		= ctx;
+		__entry->ctx		= req->ctx;
 		__entry->req		= req;
 		__entry->user_data	= sqe->user_data;
 		__entry->opcode		= sqe->opcode;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6ade0ec91979..80c433995347 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -447,9 +447,7 @@ void io_queue_iowq(struct io_kiocb *req, bool *dont_use)
 	if (WARN_ON_ONCE(!same_thread_group(req->task, current)))
 		req->work.flags |= IO_WQ_WORK_CANCEL;
 
-	trace_io_uring_queue_async_work(req->ctx, req, req->cqe.user_data,
-					req->opcode, req->flags, &req->work,
-					io_wq_is_hashed(&req->work));
+	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
 	io_wq_enqueue(tctx->io_wq, &req->work);
 	if (link)
 		io_queue_linked_timeout(link);
@@ -1518,7 +1516,7 @@ static __cold void io_drain_req(struct io_kiocb *req)
 		goto queue;
 	}
 
-	trace_io_uring_defer(ctx, req, req->cqe.user_data, req->opcode);
+	trace_io_uring_defer(req);
 	de->req = req;
 	de->seq = seq;
 	list_add_tail(&de->list, &ctx->defer_list);
@@ -1718,7 +1716,7 @@ struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 {
 	struct file *file = fget(fd);
 
-	trace_io_uring_file_get(req->ctx, req, req->cqe.user_data, fd);
+	trace_io_uring_file_get(req, fd);
 
 	/* we don't allow fixed io_uring files */
 	if (file && io_is_uring_fops(file))
@@ -1940,7 +1938,7 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
 	struct io_submit_link *link = &ctx->submit_state.link;
 	struct io_kiocb *head = link->head;
 
-	trace_io_uring_req_failed(sqe, ctx, req, ret);
+	trace_io_uring_req_failed(sqe, req, ret);
 
 	/*
 	 * Avoid breaking links in the middle as it renders links with SQPOLL
@@ -1982,9 +1980,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		return io_submit_fail_init(sqe, req, ret);
 
 	/* don't need @sqe from now on */
-	trace_io_uring_submit_sqe(ctx, req, req->cqe.user_data, req->opcode,
-				  req->flags, true,
-				  ctx->flags & IORING_SETUP_SQPOLL);
+	trace_io_uring_submit_sqe(req, true);
 
 	/*
 	 * If we already have a head request, queue this one for async
@@ -1998,7 +1994,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (unlikely(ret))
 			return io_submit_fail_init(sqe, req, ret);
 
-		trace_io_uring_link(ctx, req, link->head);
+		trace_io_uring_link(req, link->head);
 		link->last->link = req;
 		link->last = req;
 
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 76828bce8653..7f245f5617f6 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -296,7 +296,7 @@ static void __io_poll_execute(struct io_kiocb *req, int mask, __poll_t events)
 	else
 		req->io_task_work.func = io_apoll_task_func;
 
-	trace_io_uring_task_add(req->ctx, req, req->cqe.user_data, req->opcode, mask);
+	trace_io_uring_task_add(req, mask);
 	io_req_task_work_add(req);
 }
 
@@ -560,8 +560,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	if (ret || ipt.error)
 		return ret ? IO_APOLL_READY : IO_APOLL_ABORTED;
 
-	trace_io_uring_poll_arm(ctx, req, req->cqe.user_data, req->opcode,
-				mask, apoll->poll.events);
+	trace_io_uring_poll_arm(req, mask, apoll->poll.events);
 	return IO_APOLL_OK;
 }
 
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index f9df359813c9..557c637af158 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -115,8 +115,7 @@ static void io_fail_links(struct io_kiocb *req)
 		nxt = link->link;
 		link->link = NULL;
 
-		trace_io_uring_fail_link(req->ctx, req, req->cqe.user_data,
-					req->opcode, link);
+		trace_io_uring_fail_link(req, link);
 
 		if (ignore_cqes)
 			link->flags |= REQ_F_CQE_SKIP;
-- 
2.36.1

