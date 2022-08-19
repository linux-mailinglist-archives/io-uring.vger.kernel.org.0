Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE09599E3E
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349649AbiHSP2b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349763AbiHSP22 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:28:28 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5944110F
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:28:25 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660922903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EuuOlSXmNNGkOG1ruyJmE/aFr3PdiEC8n0WEJ/S84wY=;
        b=WrPXOhI8DWARoyhQGvspy2y2r1UaiBJsIws1Yp70x5Mar/8dgOY2/n2IYeBZDibN5+8xaj
        9uJCKWc4xzG4EYHXzLfHHLKgC7F61t8fJFQdPHEAxKpKgeGT538BNT9QTL3agEmpAlBXDW
        kWpV+mswMLwyZ0DdS/ul6TrPDQniSgA=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 04/19] io-wq: split io_wqe_worker() to io_wqe_worker_normal() and io_wqe_worker_let()
Date:   Fri, 19 Aug 2022 23:27:23 +0800
Message-Id: <20220819152738.1111255-5-hao.xu@linux.dev>
In-Reply-To: <20220819152738.1111255-1-hao.xu@linux.dev>
References: <20220819152738.1111255-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

io_wqe_worker_normal() is the normal io worker, and io_wqe_worker_let()
is the handler for uringlet mode.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c    | 82 ++++++++++++++++++++++++++++++++++++++++-----
 io_uring/io-wq.h    |  8 ++++-
 io_uring/io_uring.c |  8 +++--
 io_uring/io_uring.h |  2 +-
 4 files changed, 87 insertions(+), 13 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index aaa58cbacf60..b533db18d7c0 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -20,6 +20,7 @@
 #include "io-wq.h"
 #include "slist.h"
 #include "io_uring.h"
+#include "tctx.h"
 
 #define WORKER_IDLE_TIMEOUT	(5 * HZ)
 
@@ -617,19 +618,12 @@ static void io_worker_handle_work(struct io_worker *worker)
 	} while (1);
 }
 
-static int io_wqe_worker(void *data)
+static void io_wqe_worker_normal(struct io_worker *worker)
 {
-	struct io_worker *worker = data;
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 	bool last_timeout = false;
-	char buf[TASK_COMM_LEN];
-
-	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
-
-	snprintf(buf, sizeof(buf), "iou-wrk-%d", wq->task->pid);
-	set_task_comm(current, buf);
 
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		long ret;
@@ -664,6 +658,78 @@ static int io_wqe_worker(void *data)
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
 		io_worker_handle_work(worker);
+}
+
+#define IO_URINGLET_EMPTY_LIMIT	100000
+#define URINGLET_WORKER_IDLE_TIMEOUT	1
+
+static void io_wqe_worker_let(struct io_worker *worker)
+{
+	struct io_wqe *wqe = worker->wqe;
+	struct io_wq *wq = wqe->wq;
+
+	/* TODO this one breaks encapsulation */
+	if (unlikely(io_uring_add_tctx_node(wq->private)))
+		goto out;
+
+	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
+		unsigned int empty_count = 0;
+
+		__io_worker_busy(wqe, worker);
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		do {
+			enum io_uringlet_state submit_state;
+
+			submit_state = wq->do_work(wq->private);
+			if (submit_state == IO_URINGLET_SCHEDULED) {
+				empty_count = 0;
+				break;
+			} else if (submit_state == IO_URINGLET_EMPTY) {
+				if (++empty_count > IO_URINGLET_EMPTY_LIMIT)
+					break;
+			} else {
+				empty_count = 0;
+			}
+			cond_resched();
+		} while (1);
+
+		raw_spin_lock(&wqe->lock);
+		__io_worker_idle(wqe, worker);
+		raw_spin_unlock(&wqe->lock);
+		schedule_timeout(URINGLET_WORKER_IDLE_TIMEOUT);
+		if (signal_pending(current)) {
+			struct ksignal ksig;
+
+			if (!get_signal(&ksig))
+				continue;
+			break;
+		}
+	}
+
+	__set_current_state(TASK_RUNNING);
+out:
+	wq->free_work(NULL);
+}
+
+static int io_wqe_worker(void *data)
+{
+	struct io_worker *worker = data;
+	struct io_wqe *wqe = worker->wqe;
+	struct io_wq *wq = wqe->wq;
+	bool uringlet = io_wq_is_uringlet(wq);
+	char buf[TASK_COMM_LEN];
+
+	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
+
+	snprintf(buf, sizeof(buf), uringlet ? "iou-let-%d" : "iou-wrk-%d",
+		 wq->task->pid);
+	set_task_comm(current, buf);
+
+	if (uringlet)
+		io_wqe_worker_let(worker);
+	else
+		io_wqe_worker_normal(worker);
 
 	io_worker_exit(worker);
 	return 0;
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index b9f5ce4493e0..b862b04e49ce 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -21,8 +21,14 @@ enum io_wq_cancel {
 	IO_WQ_CANCEL_NOTFOUND,	/* work not found */
 };
 
+enum io_uringlet_state {
+	IO_URINGLET_INLINE,
+	IO_URINGLET_EMPTY,
+	IO_URINGLET_SCHEDULED,
+};
+
 typedef struct io_wq_work *(free_work_fn)(struct io_wq_work *);
-typedef void (io_wq_work_fn)(struct io_wq_work *);
+typedef int (io_wq_work_fn)(struct io_wq_work *);
 
 struct io_wq_hash {
 	refcount_t refs;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cb011a04653b..b57e9059a388 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1612,7 +1612,7 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 	return req ? &req->work : NULL;
 }
 
-void io_wq_submit_work(struct io_wq_work *work)
+int io_wq_submit_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	const struct io_op_def *def = &io_op_defs[req->opcode];
@@ -1632,7 +1632,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 	if (work->flags & IO_WQ_WORK_CANCEL) {
 fail:
 		io_req_task_queue_fail(req, err);
-		return;
+		return 0;
 	}
 	if (!io_assign_file(req, issue_flags)) {
 		err = -EBADF;
@@ -1666,7 +1666,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 		}
 
 		if (io_arm_poll_handler(req, issue_flags) == IO_APOLL_OK)
-			return;
+			return 0;
 		/* aborted or ready, in either case retry blocking */
 		needs_poll = false;
 		issue_flags &= ~IO_URING_F_NONBLOCK;
@@ -1675,6 +1675,8 @@ void io_wq_submit_work(struct io_wq_work *work)
 	/* avoid locking problems by failing it from a clean context */
 	if (ret < 0)
 		io_req_task_queue_fail(req, ret);
+
+	return 0;
 }
 
 inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2f73f83af960..b20d2506a60f 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -69,7 +69,7 @@ void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node);
 int io_req_prep_async(struct io_kiocb *req);
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work);
-void io_wq_submit_work(struct io_wq_work *work);
+int io_wq_submit_work(struct io_wq_work *work);
 
 void io_free_req(struct io_kiocb *req);
 void io_queue_next(struct io_kiocb *req);
-- 
2.25.1

