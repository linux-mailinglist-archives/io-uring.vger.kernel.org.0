Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116985A63DD
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 14:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiH3Mur (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 08:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiH3Muq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 08:50:46 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BCDAE9C8
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 05:50:44 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 27TMpNVG015625
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 05:50:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=H4TVGHqw1eGMuepaH71uPv++6POI1G5nbkjTU/AOufs=;
 b=VrU+nj0ieZHr4X3Ib9vU0ssSPzZ4yYH44956fWe6WbnvuW1/zOSsJnl/u2wuFhlhS/Nj
 8tMpr1X98spppr9bzMarxMu6vdodm3wrLa8OUf0c+YN6p/wLatjokew+E2/CRqSN8bfX
 fE98gmo53CP+HQ4GX7aE3bDnOf12aQtIX7U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3j7exygh8c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 05:50:43 -0700
Received: from twshared0646.06.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 05:50:41 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id F088855BF510; Tue, 30 Aug 2022 05:50:30 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next v4 4/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
Date:   Tue, 30 Aug 2022 05:50:10 -0700
Message-ID: <20220830125013.570060-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220830125013.570060-1-dylany@fb.com>
References: <20220830125013.570060-1-dylany@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 06EyFhZoBDawiFZM-tqzTj22mzUeH9sx
X-Proofpoint-ORIG-GUID: 06EyFhZoBDawiFZM-tqzTj22mzUeH9sx
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_07,2022-08-30_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Allow deferring async tasks until the user calls io_uring_enter(2) with
the IORING_ENTER_GETEVENTS flag. Enable this mode with a flag at
io_uring_setup time. This functionality requires that the later
io_uring_enter will be called from the same submission task, and therefore
restrict this flag to work only when IORING_SETUP_SINGLE_ISSUER is also
set.

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
 io_uring/io_uring.c            | 147 +++++++++++++++++++++++++++++----
 io_uring/io_uring.h            |  29 ++++++-
 io_uring/rsrc.c                |   2 +-
 6 files changed, 168 insertions(+), 21 deletions(-)

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
index 9e0b5c8d92ce..48e5c70e0baf 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -157,6 +157,13 @@ enum {
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
index 5fc5d3e80fcb..2291a53cdabd 100644
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
index 329d5b9d448e..9f90b0633de7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -142,7 +142,7 @@ static bool io_uring_try_cancel_requests(struct io_ring=
_ctx *ctx,
 static void io_dismantle_req(struct io_kiocb *req);
 static void io_clean_op(struct io_kiocb *req);
 static void io_queue_sqe(struct io_kiocb *req);
-
+static void io_move_task_work_from_local(struct io_ring_ctx *ctx);
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
=20
 static struct kmem_cache *req_cachep;
@@ -316,6 +316,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(str=
uct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
 	init_llist_head(&ctx->rsrc_put_llist);
+	init_llist_head(&ctx->work_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	ctx->submit_state.free_list.next =3D NULL;
 	INIT_WQ_LIST(&ctx->locked_free_list);
@@ -1047,12 +1048,36 @@ void tctx_task_work(struct callback_head *cb)
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
+	if (unlikely(atomic_read(&req->task->io_uring->in_idle))) {
+		io_move_task_work_from_local(ctx);
+		return;
+	}
+
+	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+
+	io_cqring_wake(ctx);
+
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
@@ -1074,6 +1099,73 @@ void io_req_task_work_add(struct io_kiocb *req)
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
+int io_run_local_work(struct io_ring_ctx *ctx)
+{
+	bool locked;
+	struct llist_node *node;
+	struct llist_node fake;
+	struct llist_node *current_final =3D NULL;
+	int ret;
+
+	if (unlikely(ctx->submitter_task !=3D current)) {
+		/* maybe this is before any submissions */
+		if (!ctx->submitter_task)
+			return 0;
+
+		return -EEXIST;
+	}
+
+	locked =3D mutex_trylock(&ctx->uring_lock);
+
+	node =3D io_llist_xchg(&ctx->work_llist, &fake);
+	ret =3D 0;
+again:
+	while (node !=3D current_final) {
+		struct llist_node *next =3D node->next;
+		struct io_kiocb *req =3D container_of(node, struct io_kiocb,
+						    io_task_work.node);
+		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
+		req->io_task_work.func(req, &locked);
+		ret++;
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
+	return ret;
+}
+
 static void io_req_tw_post(struct io_kiocb *req, bool *locked)
 {
 	io_req_complete_post(req);
@@ -1285,8 +1377,10 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, =
long min)
 			u32 tail =3D ctx->cached_cq_tail;
=20
 			mutex_unlock(&ctx->uring_lock);
-			io_run_task_work();
+			ret =3D io_run_task_work_ctx(ctx);
 			mutex_lock(&ctx->uring_lock);
+			if (ret < 0)
+				break;
=20
 			/* some requests don't go through iopoll_list */
 			if (tail !=3D ctx->cached_cq_tail ||
@@ -2147,7 +2241,9 @@ struct io_wait_queue {
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
@@ -2179,9 +2275,9 @@ static int io_wake_function(struct wait_queue_entry *=
curr, unsigned int mode,
 	return -1;
 }
=20
-int io_run_task_work_sig(void)
+int io_run_task_work_sig(struct io_ring_ctx *ctx)
 {
-	if (io_run_task_work())
+	if (io_run_task_work_ctx(ctx) > 0)
 		return 1;
 	if (task_sigpending(current))
 		return -EINTR;
@@ -2197,7 +2293,7 @@ static inline int io_cqring_wait_schedule(struct io_r=
ing_ctx *ctx,
 	unsigned long check_cq;
=20
 	/* make sure we run task_work before checking for signals */
-	ret =3D io_run_task_work_sig();
+	ret =3D io_run_task_work_sig(ctx);
 	if (ret || io_should_wake(iowq))
 		return ret;
=20
@@ -2228,12 +2324,14 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, =
int min_events,
 	int ret;
=20
 	do {
+		/* always run at least 1 task work to process local work */
+		ret =3D io_run_task_work_ctx(ctx);
+		if (ret < 0)
+			return ret;
 		io_cqring_overflow_flush(ctx);
 		if (io_cqring_events(ctx) >=3D min_events)
 			return 0;
-		if (!io_run_task_work())
-			break;
-	} while (1);
+	} while (ret > 0);
=20
 	if (sig) {
 #ifdef CONFIG_COMPAT
@@ -2574,6 +2672,9 @@ static __cold void io_ring_exit_work(struct work_stru=
ct *work)
 	 * as nobody else will be looking for them.
 	 */
 	do {
+		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+			io_move_task_work_from_local(ctx);
+
 		while (io_uring_try_cancel_requests(ctx, NULL, true))
 			cond_resched();
=20
@@ -2769,13 +2870,15 @@ static __cold bool io_uring_try_cancel_requests(str=
uct io_ring_ctx *ctx,
 		}
 	}
=20
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+		ret |=3D io_run_local_work(ctx) > 0;
 	ret |=3D io_cancel_defer_files(ctx, task, cancel_all);
 	mutex_lock(&ctx->uring_lock);
 	ret |=3D io_poll_remove_all(ctx, task, cancel_all);
 	mutex_unlock(&ctx->uring_lock);
 	ret |=3D io_kill_timeouts(ctx, task, cancel_all);
 	if (task)
-		ret |=3D io_run_task_work();
+		ret |=3D io_run_task_work() > 0;
 	return ret;
 }
=20
@@ -3060,8 +3163,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u3=
2, to_submit,
 			goto iopoll_locked;
 		mutex_unlock(&ctx->uring_lock);
 	}
+
 	if (flags & IORING_ENTER_GETEVENTS) {
 		int ret2;
+
 		if (ctx->syscall_iopoll) {
 			/*
 			 * We disallow the app entering submit/complete with
@@ -3290,17 +3395,29 @@ static __cold int io_uring_create(unsigned entries,=
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
=20
+	/*
+	 * For DEFER_TASKRUN we require the completion task to be the same as the
+	 * submission task. This implies that there is only one submitter, so enf=
orce
+	 * that.
+	 */
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN &&
+	    !(ctx->flags & IORING_SETUP_SINGLE_ISSUER)) {
+		goto err;
+	}
+
 	/*
 	 * This is just grabbed for accounting purposes. When a process exits,
 	 * the mm is exited and dropped before the files, hence we need to hang
@@ -3401,7 +3518,7 @@ static long io_uring_setup(u32 entries, struct io_uri=
ng_params __user *params)
 			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
 			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
-			IORING_SETUP_SINGLE_ISSUER))
+			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN))
 		return -EINVAL;
=20
 	return io_uring_create(entries, &p, params);
@@ -3873,7 +3990,7 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, =
unsigned int, opcode,
=20
 	ctx =3D f.file->private_data;
=20
-	io_run_task_work();
+	io_run_task_work_ctx(ctx);
=20
 	mutex_lock(&ctx->uring_lock);
 	ret =3D __io_uring_register(ctx, opcode, arg, nr_args);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2f73f83af960..f417d75d7bc1 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -26,7 +26,8 @@ enum {
=20
 struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx);
 bool io_req_cqe_overflow(struct io_kiocb *req);
-int io_run_task_work_sig(void);
+int io_run_task_work_sig(struct io_ring_ctx *ctx);
+int io_run_local_work(struct io_ring_ctx *ctx);
 void io_req_complete_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
 void io_req_complete_post(struct io_kiocb *req);
@@ -221,17 +222,37 @@ static inline unsigned int io_sqring_entries(struct i=
o_ring_ctx *ctx)
 	return smp_load_acquire(&rings->sq.tail) - ctx->cached_sq_head;
 }
=20
-static inline bool io_run_task_work(void)
+static inline int io_run_task_work(void)
 {
 	if (test_thread_flag(TIF_NOTIFY_SIGNAL)) {
 		__set_current_state(TASK_RUNNING);
 		clear_notify_signal();
 		if (task_work_pending(current))
 			task_work_run();
-		return true;
+		return 1;
 	}
=20
-	return false;
+	return 0;
+}
+
+static inline int io_run_task_work_ctx(struct io_ring_ctx *ctx)
+{
+	int ret =3D 0;
+	int ret2;
+
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+		ret =3D io_run_local_work(ctx);
+
+	/* want to run this after in case more is added */
+	ret2 =3D io_run_task_work();
+
+	/* Try propagate error in favour of if tasks were run,
+	 * but still make sure to run them if requested
+	 */
+	if (ret >=3D 0)
+		ret +=3D ret2;
+
+	return ret;
 }
=20
 static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
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

