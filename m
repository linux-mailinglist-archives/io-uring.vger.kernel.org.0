Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E182D592FBB
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 15:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbiHONVV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 09:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbiHONVU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 09:21:20 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E860517A8C
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:21:17 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27F9Ovm0021314
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:21:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=YDnw0IMdboi07u45x9i+nGIhBCBBNVetx4FPd5PC8qU=;
 b=gyGs2iZYpQ1/6XIh6CchmLN4DZ2ixw9fZ8wJ3wDkB6dWqCEkctqiA8FtFZaUeVvEd+ud
 xPJQKV+KK7HFiYpMy5dkF8N1bhVxC3/PCU+YWQx2DD0DFrP+XE8Fe0Zr2960DJfov7A4
 YKRWvD0y7cydboUkEyXPQ8uyevUHRZowd8A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hykfy0y8j-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:21:17 -0700
Received: from twshared1866.09.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 15 Aug 2022 06:21:14 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 7E95C49B6CB5; Mon, 15 Aug 2022 06:09:15 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 5/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
Date:   Mon, 15 Aug 2022 06:09:09 -0700
Message-ID: <20220815130911.988014-6-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815130911.988014-1-dylany@fb.com>
References: <20220815130911.988014-1-dylany@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: cvnvfA0hpdc0hI7O4RqC-iBa8LsTQlUf
X-Proofpoint-ORIG-GUID: cvnvfA0hpdc0hI7O4RqC-iBa8LsTQlUf
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Allow deferring async tasks until the user calls io_uring_enter(2) with
the IORING_ENTER_GETEVENTS flag.

Being able to hand pick when tasks are run prevents the problem where
there is current work to be done, however task work runs anyway.

For example, a common workload would obtain a batch of CQEs, and process
each one. Interrupting this to additional taskwork would add latency but
not gain anything. If instead task work is deferred to just before more
CQEs are obtained then no additional latency is added.

The way this is implemented is by trying to keep task work local to a
io_ring_ctx, rather than to the submission task. This is required, as the
application will want to wake up only a single io_ring_ctx at a time to
process work, and so the lists of work have to be kept separate.

This has some other benefits like not having to check the task continually
in handle_tw_list (and potentially unlocking/locking those), and reducing
locks in the submit & process completions path.

There are networking cases where using this option can reduce request
latency by 50%. For example a contrived example using [1] where the client
sends 2k data and receives the same data back while doing some system
calls (to trigger task work) shows this reduction. The reason ends up
being that if sending responses is delayed by processing task work, then
the client side sits idle. Whereas reordering the sends first means that
the client runs it's workload in parallel with the local task work.

[1]:
Using https://github.com/DylanZA/netbench/tree/defer_run
Client:
./netbench  --client_only 1 --control_port 10000 --host <host> --tx "epoll =
--threads 16 --per_thread 1 --size 2048 --resp 2048 --workload 1000"
Server:
./netbench  --server_only 1 --control_port 10000  --rx "io_uring --defer_ta=
skrun 0 --workload 100"   --rx "io_uring  --defer_taskrun 1 --workload 100"

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/linux/io_uring_types.h |   2 +
 include/uapi/linux/io_uring.h  |   7 ++
 io_uring/cancel.c              |   2 +-
 io_uring/io_uring.c            | 125 ++++++++++++++++++++++++++++-----
 io_uring/io_uring.h            |  31 +++++++-
 io_uring/rsrc.c                |   2 +-
 6 files changed, 148 insertions(+), 21 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 677a25d44d7f..d56ff2185168 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -301,6 +301,8 @@ struct io_ring_ctx {
 		struct io_hash_table	cancel_table;
 		bool			poll_multi_queue;
=20
+		struct llist_head	work_llist;
+
 		struct list_head	io_buffers_comp;
 	} ____cacheline_aligned_in_smp;
=20
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1463cfecb56b..be8d1801bf4a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -153,6 +153,13 @@ enum {
  */
 #define IORING_SETUP_SINGLE_ISSUER	(1U << 12)
=20
+/*
+ * Defer running task work to get events.
+ * Rather than running bits of task work whenever the task transitions
+ * try to do it just before it is needed.
+ */
+#define IORING_SETUP_DEFER_TASKRUN	(1U << 13)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index e4e1dc0325f0..db6180b62e41 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -292,7 +292,7 @@ int io_sync_cancel(struct io_ring_ctx *ctx, void __user=
 *arg)
 			break;
=20
 		mutex_unlock(&ctx->uring_lock);
-		ret =3D io_run_task_work_sig();
+		ret =3D io_run_task_work_sig(ctx);
 		if (ret < 0) {
 			mutex_lock(&ctx->uring_lock);
 			break;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3b08369c3c60..35edeed1bcc1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -316,6 +316,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(str=
uct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
 	init_llist_head(&ctx->rsrc_put_llist);
+	init_llist_head(&ctx->work_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	ctx->submit_state.free_list.next =3D NULL;
 	INIT_WQ_LIST(&ctx->locked_free_list);
@@ -1047,12 +1048,30 @@ void tctx_task_work(struct callback_head *cb)
 	trace_io_uring_task_work_run(tctx, count, loops);
 }
=20
-void io_req_task_work_add(struct io_kiocb *req)
+static void io_req_local_work_add(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx =3D req->ctx;
+
+	if (!llist_add(&req->io_task_work.node, &ctx->work_llist))
+		return;
+
+	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+
+	io_cqring_wake(ctx);
+}
+
+static inline void __io_req_task_work_add(struct io_kiocb *req, bool allow=
_local)
 {
 	struct io_uring_task *tctx =3D req->task->io_uring;
 	struct io_ring_ctx *ctx =3D req->ctx;
 	struct llist_node *node;
=20
+	if (allow_local && ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+		io_req_local_work_add(req);
+		return;
+	}
+
 	/* task_work already pending, we're done */
 	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
 		return;
@@ -1074,6 +1093,69 @@ void io_req_task_work_add(struct io_kiocb *req)
 	}
 }
=20
+void io_req_task_work_add(struct io_kiocb *req)
+{
+	__io_req_task_work_add(req, true);
+}
+
+static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
+{
+	struct llist_node *node;
+
+	node =3D llist_del_all(&ctx->work_llist);
+	while (node) {
+		struct io_kiocb *req =3D container_of(node, struct io_kiocb,
+						    io_task_work.node);
+
+		node =3D node->next;
+		__io_req_task_work_add(req, false);
+	}
+}
+
+bool io_run_local_work(struct io_ring_ctx *ctx, bool locked)
+{
+	struct llist_node *node;
+	struct llist_node fake;
+	struct llist_node *current_final =3D NULL;
+	unsigned int count;
+
+	if (!locked)
+		locked =3D mutex_trylock(&ctx->uring_lock);
+
+	node =3D io_llist_xchg(&ctx->work_llist, &fake);
+	count =3D 0;
+again:
+	while (node !=3D current_final) {
+		struct llist_node *next =3D node->next;
+		struct io_kiocb *req =3D container_of(node, struct io_kiocb,
+						    io_task_work.node);
+		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
+		if (unlikely(!same_thread_group(req->task, current))) {
+			__io_req_task_work_add(req, false);
+		} else {
+			req->io_task_work.func(req, &locked);
+			count++;
+		}
+		node =3D next;
+	}
+
+	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+
+	node =3D io_llist_cmpxchg(&ctx->work_llist, &fake, NULL);
+	if (node !=3D &fake) {
+		current_final =3D &fake;
+		node =3D io_llist_xchg(&ctx->work_llist, &fake);
+		goto again;
+	}
+
+	if (locked) {
+		io_submit_flush_completions(ctx);
+		mutex_unlock(&ctx->uring_lock);
+	}
+	return count > 0;
+}
+
 static void io_req_tw_post(struct io_kiocb *req, bool *locked)
 {
 	io_req_complete_post(req);
@@ -1284,8 +1366,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, l=
ong min)
 		if (wq_list_empty(&ctx->iopoll_list)) {
 			u32 tail =3D ctx->cached_cq_tail;
=20
-			mutex_unlock(&ctx->uring_lock);
-			io_run_task_work();
+			io_run_task_work_unlock_ctx(ctx);
 			mutex_lock(&ctx->uring_lock);
=20
 			/* some requests don't go through iopoll_list */
@@ -2146,7 +2227,9 @@ struct io_wait_queue {
=20
 static inline bool io_has_work(struct io_ring_ctx *ctx)
 {
-	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
+	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
+	       ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
+		!llist_empty(&ctx->work_llist));
 }
=20
 static inline bool io_should_wake(struct io_wait_queue *iowq)
@@ -2178,9 +2261,9 @@ static int io_wake_function(struct wait_queue_entry *=
curr, unsigned int mode,
 	return -1;
 }
=20
-int io_run_task_work_sig(void)
+int io_run_task_work_sig(struct io_ring_ctx *ctx)
 {
-	if (io_run_task_work())
+	if (io_run_task_work_ctx(ctx, true))
 		return 1;
 	if (task_sigpending(current))
 		return -EINTR;
@@ -2196,7 +2279,7 @@ static inline int io_cqring_wait_schedule(struct io_r=
ing_ctx *ctx,
 	unsigned long check_cq;
=20
 	/* make sure we run task_work before checking for signals */
-	ret =3D io_run_task_work_sig();
+	ret =3D io_run_task_work_sig(ctx);
 	if (ret || io_should_wake(iowq))
 		return ret;
=20
@@ -2230,7 +2313,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, in=
t min_events,
 		io_cqring_overflow_flush(ctx);
 		if (io_cqring_events(ctx) >=3D min_events)
 			return 0;
-		if (!io_run_task_work())
+		if (!io_run_task_work_ctx(ctx, false))
 			break;
 	} while (1);
=20
@@ -2768,13 +2851,14 @@ static __cold bool io_uring_try_cancel_requests(str=
uct io_ring_ctx *ctx,
 		}
 	}
=20
+	io_move_task_work_from_local(ctx);
 	ret |=3D io_cancel_defer_files(ctx, task, cancel_all);
 	mutex_lock(&ctx->uring_lock);
 	ret |=3D io_poll_remove_all(ctx, task, cancel_all);
 	mutex_unlock(&ctx->uring_lock);
 	ret |=3D io_kill_timeouts(ctx, task, cancel_all);
 	if (task)
-		ret |=3D io_run_task_work();
+		ret |=3D io_run_task_work_ctx(ctx, true);
 	return ret;
 }
=20
@@ -2837,7 +2921,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, =
struct io_sq_data *sqd)
 		}
=20
 		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
-		io_run_task_work();
+		io_run_task_work_ctx(ctx, true);
 		io_uring_drop_tctx_refs(current);
=20
 		/*
@@ -3055,12 +3139,15 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u=
32, to_submit,
 			mutex_unlock(&ctx->uring_lock);
 			goto out;
 		}
-		if ((flags & IORING_ENTER_GETEVENTS) && ctx->syscall_iopoll)
+
+		if (!(flags & IORING_ENTER_GETEVENTS))
+			mutex_unlock(&ctx->uring_lock);
+		else if (ctx->syscall_iopoll)
 			goto iopoll_locked;
-		mutex_unlock(&ctx->uring_lock);
-		io_run_task_work();
+		else
+			io_run_task_work_unlock_ctx(ctx);
 	} else {
-		io_run_task_work();
+		io_run_task_work_ctx(ctx, false);
 	}
=20
 	if (flags & IORING_ENTER_GETEVENTS) {
@@ -3293,13 +3380,15 @@ static __cold int io_uring_create(unsigned entries,=
 struct io_uring_params *p,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		/* IPI related flags don't make sense with SQPOLL */
 		if (ctx->flags & (IORING_SETUP_COOP_TASKRUN |
-				  IORING_SETUP_TASKRUN_FLAG))
+				  IORING_SETUP_TASKRUN_FLAG |
+				  IORING_SETUP_DEFER_TASKRUN))
 			goto err;
 		ctx->notify_method =3D TWA_SIGNAL_NO_IPI;
 	} else if (ctx->flags & IORING_SETUP_COOP_TASKRUN) {
 		ctx->notify_method =3D TWA_SIGNAL_NO_IPI;
 	} else {
-		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG &&
+		    !(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
 			goto err;
 		ctx->notify_method =3D TWA_SIGNAL;
 	}
@@ -3404,7 +3493,7 @@ static long io_uring_setup(u32 entries, struct io_uri=
ng_params __user *params)
 			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
 			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
-			IORING_SETUP_SINGLE_ISSUER))
+			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN))
 		return -EINVAL;
=20
 	return io_uring_create(entries, &p, params);
@@ -3876,7 +3965,7 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, =
unsigned int, opcode,
=20
 	ctx =3D f.file->private_data;
=20
-	io_run_task_work();
+	io_run_task_work_ctx(ctx, true);
=20
 	mutex_lock(&ctx->uring_lock);
 	ret =3D __io_uring_register(ctx, opcode, arg, nr_args);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2f73f83af960..2a317a0a1eea 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -26,7 +26,8 @@ enum {
=20
 struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx);
 bool io_req_cqe_overflow(struct io_kiocb *req);
-int io_run_task_work_sig(void);
+int io_run_task_work_sig(struct io_ring_ctx *ctx);
+bool io_run_local_work(struct io_ring_ctx *ctx, bool locked);
 void io_req_complete_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
 void io_req_complete_post(struct io_kiocb *req);
@@ -234,6 +235,34 @@ static inline bool io_run_task_work(void)
 	return false;
 }
=20
+static inline bool io_run_task_work_ctx(struct io_ring_ctx *ctx, bool all)
+{
+	bool ret =3D false;
+
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+		ret =3D io_run_local_work(ctx, false);
+		if (!all)
+			return ret;
+	}
+	ret  |=3D io_run_task_work();
+	return ret;
+}
+
+static inline bool io_run_task_work_unlock_ctx(struct io_ring_ctx *ctx)
+{
+	bool ret;
+
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+		ret =3D io_run_local_work(ctx, true);
+		mutex_unlock(&ctx->uring_lock);
+	} else {
+		mutex_unlock(&ctx->uring_lock);
+		ret =3D io_run_task_work();
+	}
+
+	return ret;
+}
+
 static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
 {
 	if (!*locked) {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 71359a4d0bd4..80cda6e2067f 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -343,7 +343,7 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_da=
ta *data,
 		flush_delayed_work(&ctx->rsrc_put_work);
 		reinit_completion(&data->done);
=20
-		ret =3D io_run_task_work_sig();
+		ret =3D io_run_task_work_sig(ctx);
 		mutex_lock(&ctx->uring_lock);
 	} while (ret >=3D 0);
 	data->quiesce =3D false;
--=20
2.30.2

