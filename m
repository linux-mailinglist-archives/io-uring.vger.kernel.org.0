Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96AE45277BF
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 15:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiEONNK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 09:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236858AbiEONNK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 09:13:10 -0400
Received: from pv50p00im-ztdg10022001.me.com (pv50p00im-ztdg10022001.me.com [17.58.6.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE66D13F4D
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 06:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652620388;
        bh=y6vkx1JrYS6Yj1jtrm0AnFQTMC0tyUNU8zGu3cGL3CY=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=vD3mgn3gnA1yErRobWJVBIOgi3kSaHZ/RmYMmPCSGV4SEO7Ix3QhCPaExVAQiEa35
         NeHCsqzqNW3FeKz7lyX1rIhpYFbkb5mZB69Z2KxLbgZwseviIhP45MhqXqBga2u2Z9
         h++K6SjNSiW6DY63w7h6kVmW8qxGETyjjVv30n1wHxf3Mds1SMrba5Jl8t9wl2rEER
         lz1z3Zk31shEwV+3Y7Naj9hKmpeXlWXqAYgPzRqpKI124f6kGyvbw/VyC/jFp95ig9
         Xz5ft1Ac+zOGsH/94T896aS4r3G93f61KVY9Yztjp/1PCm6rQaXA9FmZp31GvkGTCx
         dMnnYHxDQoj6g==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10022001.me.com (Postfix) with ESMTPSA id DC7B43E1D60;
        Sun, 15 May 2022 13:13:02 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 07/11] io-wq: implement fixed worker logic
Date:   Sun, 15 May 2022 21:12:26 +0800
Message-Id: <20220515131230.155267-8-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220515131230.155267-1-haoxu.linux@icloud.com>
References: <20220515131230.155267-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-15_07:2022-05-13,2022-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205150069
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <haoxu.linux@gmail.com>

From: Hao Xu <howeyxu@tencent.com>

The current implementation of io-wq has big spinlock contension. The
main reason is the single work list model. All producers(who insert
works) and consumers(io-workers) have to grap wqe->lock to move ahead.
Set max_worker to 3 or 4, do a fio read test, we can see 40%~50% lock
contension.
Introduce fixed io-workers which sticks there to handle works and have
their own work list.

previous:

  producer0 ---insert---> work_list ---get---> io-worker0,1,2

now:

                     ---> private work_list0 --get--> fixed-worker0
                    /
  producer0 --insert----> private work_list1 --get--> fixed-worker1
      |             \
      |              ---> private work_list2 --get--> fixed-worker2
      |
      |---insert---> public work_list --get--> (normal)io-worker

Since each fixed-worker has a private work list, the contension will be
limited to a smaller range(the private work list).
Logic of fixed-worker: first handle private works then public ones.
Logic of normal io-worker: only handle public works.
Logic of producer: 1) randomly pick a private work list and check if it
                      is full, insert the work if it's not
                   2) insert the work to the public work list if 1)
                      fails.
The get logic of a private list: fixed-worker grab all the works in
its private work list(like what tctx_task_work() does) rather than one
by one.(this code is in the next patches as a optimization)

To achieve this, we need to add an io_wqe_acct for each fixed-worker
struct, and though this we can leverage the old code as much as
possible, which makes the new design clean and compatible.

Good things of this feature:
  1) bound and unbound work lists now have different spinlocks.
  2) much smaller contension between work producers and consumers.
  3) fixed workers are friendly for users to control: binding cpus,
     reset priority etc.

Wrote a nop test program to test it, 3 fixed-workers VS 3 normal workers.
normal workers:
./run_nop_wqe.sh nop_wqe_normal 200000 100 3 1-3
        time spent: 10464397 usecs      IOPS: 1911242
        time spent: 9610976 usecs       IOPS: 2080954
        time spent: 9807361 usecs       IOPS: 2039284

fixed workers:
./run_nop_wqe.sh nop_wqe_fixed 200000 100 3 1-3
        time spent: 17314274 usecs      IOPS: 1155116
        time spent: 17016942 usecs      IOPS: 1175299
        time spent: 17908684 usecs      IOPS: 1116776

About 2x improvement. From perf result, almost no acct->lock contension.
Test program: https://github.com/HowHsu/liburing/tree/fixed_worker

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 148 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 122 insertions(+), 26 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index c57920ad90a0..8e152c076dd5 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -73,6 +73,7 @@ struct io_wqe_acct {
 		};
 	};
 	unsigned max_works;
+	unsigned work_seq;
 	union {
 		struct io_wq_work_list work_list;
 		struct {
@@ -631,9 +632,9 @@ static void io_assign_current_work(struct io_worker *worker,
 
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 
-static void io_worker_handle_work(struct io_worker *worker)
+static void io_worker_handle_work(struct io_worker *worker,
+				  struct io_wqe_acct *acct)
 {
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 	bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
@@ -705,19 +706,31 @@ static void io_worker_handle_work(struct io_worker *worker)
 	} while (1);
 }
 
+static inline void io_worker_handle_private_work(struct io_worker *worker)
+{
+	io_worker_handle_work(worker, &worker->acct);
+}
+
+static inline void io_worker_handle_public_work(struct io_worker *worker)
+{
+	io_worker_handle_work(worker, io_wqe_get_acct(worker));
+}
+
 static int io_wqe_worker(void *data)
 {
 	struct io_worker *worker = data;
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
-	bool last_timeout = false;
+	struct io_wqe_acct *acct =
+		io_get_acct(wqe, worker->flags & IO_WORKER_F_BOUND, false);
 	bool fixed = worker->flags & IO_WORKER_F_FIXED;
+	bool last_timeout = false;
 	char buf[TASK_COMM_LEN];
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
 
-	snprintf(buf, sizeof(buf), "iou-wrk-%d", wq->task->pid);
+	snprintf(buf, sizeof(buf), fixed ? "iou-fix-%d" : "iou-wrk-%d",
+		 wq->task->pid);
 	set_task_comm(current, buf);
 
 	audit_alloc_kernel(current);
@@ -729,13 +742,24 @@ static int io_wqe_worker(void *data)
 			break;
 
 		set_current_state(TASK_INTERRUPTIBLE);
-		while (!(worker->flags & IO_WORKER_F_EXIT) &&
-		       io_acct_run_queue(acct))
-			io_worker_handle_work(worker);
-
+		if (fixed) {
+			while (io_acct_run_queue(&worker->acct))
+				io_worker_handle_private_work(worker);
+			if (io_acct_run_queue(acct))
+				io_worker_handle_public_work(worker);
+		} else {
+			while (io_acct_run_queue(acct))
+				io_worker_handle_public_work(worker);
+		}
 		raw_spin_lock(&wqe->lock);
-		/* timed out, exit unless we're the last worker */
-		if (last_timeout && acct->nr_workers > 1) {
+		/* timed out, a worker will exit only if:
+		 * - not a fixed worker
+		 * - not the last non-fixed worker
+		 *
+		 * the second condition is due to we need at least one worker to
+		 * handle the public work list.
+		 */
+		if (last_timeout && !fixed && acct->nr_workers > 1) {
 			acct->nr_workers--;
 			raw_spin_unlock(&wqe->lock);
 			__set_current_state(TASK_RUNNING);
@@ -761,10 +785,18 @@ static int io_wqe_worker(void *data)
 		last_timeout = !ret;
 	}
 
-	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
-		io_worker_handle_work(worker);
-	if (fixed)
+	if (test_bit(IO_WQ_BIT_EXIT, &wq->state) && !fixed)
+		io_worker_handle_public_work(worker);
+	if (fixed) {
 		io_fixed_worker_exit(worker);
+		/*
+		 * Check and handle private work list again
+		 * to avoid race with private work insertion
+		 * TODO: an alternative way is to deliver
+		 * works to the public work list
+		 */
+		io_worker_handle_private_work(worker);
+	}
 
 	audit_free(current);
 	io_worker_exit(worker);
@@ -1008,9 +1040,9 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 	} while (work);
 }
 
-static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
+static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work,
+			       struct io_wqe_acct *acct)
 {
-	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
 	unsigned int hash;
 	struct io_wq_work *tail;
 
@@ -1029,6 +1061,45 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 	wq_list_add_after(&work->list, &tail->list, &acct->work_list);
 }
 
+static bool io_wqe_insert_private_work(struct io_wqe *wqe,
+				       struct io_wq_work *work,
+				       struct io_wqe_acct *acct)
+{
+	unsigned int nr_fixed;
+	struct io_worker *fixed_worker;
+	struct io_wqe_acct *iw_acct;
+	unsigned int fixed_worker_index;
+
+	raw_spin_lock(&acct->lock);
+	nr_fixed = acct->nr_fixed;
+	if (!nr_fixed) {
+		raw_spin_unlock(&acct->lock);
+		return false;
+	}
+
+	fixed_worker_index = (acct->work_seq++) % nr_fixed;
+	fixed_worker = acct->fixed_workers[fixed_worker_index];
+	if (!fixed_worker || fixed_worker->flags & IO_WORKER_F_EXIT) {
+		raw_spin_unlock(&acct->lock);
+		return false;
+	}
+	iw_acct = &fixed_worker->acct;
+
+	raw_spin_lock(&iw_acct->lock);
+	if (iw_acct->nr_works < iw_acct->max_works) {
+		io_wqe_insert_work(wqe, work, iw_acct);
+		iw_acct->nr_works++;
+		raw_spin_unlock(&iw_acct->lock);
+		wake_up_process(fixed_worker->task);
+		raw_spin_unlock(&acct->lock);
+		return true;
+	}
+	raw_spin_unlock(&iw_acct->lock);
+	raw_spin_unlock(&acct->lock);
+
+	return false;
+}
+
 static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
 {
 	return work == data;
@@ -1037,6 +1108,7 @@ static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
+	struct io_wqe_acct *fixed_acct;
 	struct io_cb_cancel_data match;
 	unsigned work_flags = work->flags;
 	bool do_create;
@@ -1051,8 +1123,14 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 		return;
 	}
 
+	fixed_acct = io_get_acct(wqe, !acct->index, true);
+	if (fixed_acct->fixed_worker_registered && !io_wq_is_hashed(work)) {
+		if (io_wqe_insert_private_work(wqe, work, fixed_acct))
+			return;
+	}
+
 	raw_spin_lock(&acct->lock);
-	io_wqe_insert_work(wqe, work);
+	io_wqe_insert_work(wqe, work, acct);
 	clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 	raw_spin_unlock(&acct->lock);
 
@@ -1138,9 +1216,9 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 
 static inline void io_wqe_remove_pending(struct io_wqe *wqe,
 					 struct io_wq_work *work,
-					 struct io_wq_work_node *prev)
+					 struct io_wq_work_node *prev,
+					 struct io_wqe_acct *acct)
 {
-	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
 	unsigned int hash = io_get_work_hash(work);
 	struct io_wq_work *prev_work = NULL;
 
@@ -1167,7 +1245,7 @@ static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 		work = container_of(node, struct io_wq_work, list);
 		if (!match->fn(work, match->data))
 			continue;
-		io_wqe_remove_pending(wqe, work, prev);
+		io_wqe_remove_pending(wqe, work, prev, acct);
 		raw_spin_unlock(&acct->lock);
 		io_run_cancel(work, wqe);
 		match->nr_pending++;
@@ -1182,17 +1260,35 @@ static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 				       struct io_cb_cancel_data *match)
 {
-	int i;
-retry:
-	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0, false);
+	int i, j;
+	struct io_wqe_acct *acct, *iw_acct;
 
+retry_public:
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		acct = io_get_acct(wqe, i == 0, false);
 		if (io_acct_cancel_pending_work(wqe, acct, match)) {
 			if (match->cancel_all)
-				goto retry;
-			break;
+				goto retry_public;
+			return;
 		}
 	}
+
+retry_private:
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		acct = io_get_acct(wqe, i == 0, true);
+		raw_spin_lock(&acct->lock);
+		for (j = 0; j < acct->nr_fixed; j++) {
+			iw_acct = &acct->fixed_workers[j]->acct;
+			if (io_acct_cancel_pending_work(wqe, iw_acct, match)) {
+				if (match->cancel_all) {
+					raw_spin_unlock(&acct->lock);
+					goto retry_private;
+				}
+				break;
+			}
+		}
+		raw_spin_unlock(&acct->lock);
+	}
 }
 
 static void io_wqe_cancel_running_work(struct io_wqe *wqe,
-- 
2.25.1

