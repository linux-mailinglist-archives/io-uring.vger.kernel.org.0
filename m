Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875CD514682
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 12:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357390AbiD2KWh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 06:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357391AbiD2KWb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 06:22:31 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A25C6ED8;
        Fri, 29 Apr 2022 03:19:11 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id fv2so6727941pjb.4;
        Fri, 29 Apr 2022 03:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NpPFG4XRH1a1LgmEG5Xpjkc4A8sSdHnFyJLNANxCbg0=;
        b=dK9IAaPlt9ujn+B5tqW/USQCvnaupj4k+JHAVPywrFLWuoQHXoWHTIESjY0H5EtVwF
         3vTzukISs4GltKcLJcEUAJ/vIOR9cUM3sb6ZyLoZn0xruh2qUzogdm5m193ixKaPqtiN
         8FMyRHYrb0k9+63KtyaOG80uRDRTBbOP1jVw53N70PcXHuwELhHw+pt8NvIAyHkixR/M
         BLQVloHkY0mcsh5JrF6Kplg3r/6Nyh9Bi9Jbfv71wJ+Y5i1L6YQ0+FHaEfJiWZITX9uf
         jbFOKduS6laY0pVKfJQSa1S/WlYY750VS55iwZGBtJrdGhpTXLPEwTmEYfo/se51yCSc
         10+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NpPFG4XRH1a1LgmEG5Xpjkc4A8sSdHnFyJLNANxCbg0=;
        b=tLhSglLoPYXCe9sCsuIG0ou3ku3iWS+31PWonMEzvHM2DY2bG7MfRq54ZFrQb6hY6r
         9E6Jj2l/hGxn4PFFJCcRwplRLnHjkDgN1pT8Mi/Pb6ie3eTRRlw/jEq3edvjXlD+Dvz3
         QpkWb94sBVctR8jRs3MvMTqH17HWkG8FUA4VvEXOL91UKWGG3FbLIM/2WpjWX7BgQSOt
         UwOUCu9XJQtAmzoPk+wMjyvdzO0WSipzv8JoBVVte4VTge32qx8/GwCUQ0ZYCEliGOxZ
         aRF4T9NaykHXA+g3zBJvB4PjIY/gnMwDJDGjsJDai0APiUj+ayQpd+ldi/7+mpBe61VA
         u7pw==
X-Gm-Message-State: AOAM532KiKGDm5dbB3dWYGaDDwbeyn3krjsRfjqOd7tdCALafblYP25p
        N1ULYwsXch0zq9hL1YXXZkZK9yoVvKU=
X-Google-Smtp-Source: ABdhPJw7hWIEZ+pKMbdG9T9TYW1aAji3AdnP9yc3HWJuQ65rYBUyZXNdr9ob8qrGrVlrHWVoSQ/VaQ==
X-Received: by 2002:a17:902:e5c2:b0:15e:8061:87 with SMTP id u2-20020a170902e5c200b0015e80610087mr1096130plf.123.1651227550942;
        Fri, 29 Apr 2022 03:19:10 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id k17-20020a628e11000000b0050d8d373331sm2600016pfe.214.2022.04.29.03.19.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Apr 2022 03:19:10 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] io-wq: implement fixed worker logic
Date:   Fri, 29 Apr 2022 18:18:56 +0800
Message-Id: <20220429101858.90282-8-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429101858.90282-1-haoxu.linux@gmail.com>
References: <20220429101858.90282-1-haoxu.linux@gmail.com>
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
index 2feff19970ca..aaa9cea7d39a 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -70,6 +70,7 @@ struct io_wqe_acct {
 	unsigned max_workers;
 	unsigned nr_fixed;
 	unsigned max_works;
+	unsigned work_seq;
 	union {
 		struct io_wq_work_list work_list;
 		struct io_worker **fixed_workers;
@@ -624,9 +625,9 @@ static void io_assign_current_work(struct io_worker *worker,
 
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 
-static void io_worker_handle_work(struct io_worker *worker)
+static void io_worker_handle_work(struct io_worker *worker,
+				  struct io_wqe_acct *acct)
 {
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 	bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
@@ -698,19 +699,31 @@ static void io_worker_handle_work(struct io_worker *worker)
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
@@ -722,13 +735,24 @@ static int io_wqe_worker(void *data)
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
@@ -754,10 +778,18 @@ static int io_wqe_worker(void *data)
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
@@ -1001,9 +1033,9 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 	} while (work);
 }
 
-static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
+static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work,
+			       struct io_wqe_acct *acct)
 {
-	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
 	unsigned int hash;
 	struct io_wq_work *tail;
 
@@ -1022,6 +1054,45 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
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
@@ -1030,6 +1101,7 @@ static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
+	struct io_wqe_acct *fixed_acct;
 	struct io_cb_cancel_data match;
 	unsigned work_flags = work->flags;
 	bool do_create;
@@ -1044,8 +1116,14 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
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
 
@@ -1131,9 +1209,9 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 
 static inline void io_wqe_remove_pending(struct io_wqe *wqe,
 					 struct io_wq_work *work,
-					 struct io_wq_work_node *prev)
+					 struct io_wq_work_node *prev,
+					 struct io_wqe_acct *acct)
 {
-	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
 	unsigned int hash = io_get_work_hash(work);
 	struct io_wq_work *prev_work = NULL;
 
@@ -1160,7 +1238,7 @@ static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 		work = container_of(node, struct io_wq_work, list);
 		if (!match->fn(work, match->data))
 			continue;
-		io_wqe_remove_pending(wqe, work, prev);
+		io_wqe_remove_pending(wqe, work, prev, acct);
 		raw_spin_unlock(&acct->lock);
 		io_run_cancel(work, wqe);
 		match->nr_pending++;
@@ -1175,17 +1253,35 @@ static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
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
2.36.0

