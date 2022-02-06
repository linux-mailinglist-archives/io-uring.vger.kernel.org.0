Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEAAE4AAEB4
	for <lists+io-uring@lfdr.de>; Sun,  6 Feb 2022 10:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiBFJwy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Feb 2022 04:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiBFJwx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Feb 2022 04:52:53 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1868C061A73
        for <io-uring@vger.kernel.org>; Sun,  6 Feb 2022 01:52:52 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V3fxVZ3_1644141169;
Received: from localhost.localdomain(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V3fxVZ3_1644141169)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 06 Feb 2022 17:52:50 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/3] io-wq: reduce acct->lock crossing functions lock/unlock
Date:   Sun,  6 Feb 2022 17:52:40 +0800
Message-Id: <20220206095241.121485-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220206095241.121485-1-haoxu@linux.alibaba.com>
References: <20220206095241.121485-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

reduce acct->lock lock and unlock in different functions to make the
code clearer.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 9595616ccaa3..f7b7fa396faf 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -239,10 +239,15 @@ static void io_worker_exit(struct io_worker *worker)
 
 static inline bool io_acct_run_queue(struct io_wqe_acct *acct)
 {
+	bool ret = false;
+
+	raw_spin_lock(&acct->lock);
 	if (!wq_list_empty(&acct->work_list) &&
 	    !test_bit(IO_ACCT_STALLED_BIT, &acct->flags))
-		return true;
-	return false;
+		ret = true;
+	raw_spin_unlock(&acct->lock);
+
+	return ret;
 }
 
 /*
@@ -395,13 +400,9 @@ static void io_wqe_dec_running(struct io_worker *worker)
 
 	if (!atomic_dec_and_test(&acct->nr_running))
 		return;
-	raw_spin_lock(&wqe->lock);
-	if (!io_acct_run_queue(acct)) {
-		raw_spin_unlock(&wqe->lock);
+	if (!io_acct_run_queue(acct))
 		return;
-	}
 
-	raw_spin_unlock(&wqe->lock);
 	atomic_inc(&acct->nr_running);
 	atomic_inc(&wqe->wq->worker_refs);
 	io_queue_worker_create(worker, acct, create_worker_cb);
@@ -544,7 +545,6 @@ static void io_assign_current_work(struct io_worker *worker,
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 
 static void io_worker_handle_work(struct io_worker *worker)
-	__releases(acct->lock)
 {
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
@@ -561,6 +561,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
+		raw_spin_lock(&acct->lock);
 		work = io_get_next_work(acct, worker);
 		raw_spin_unlock(&acct->lock);
 		if (work) {
@@ -614,8 +615,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 					wake_up(&wq->hash->wait);
 			}
 		} while (work);
-
-		raw_spin_lock(&acct->lock);
 	} while (1);
 }
 
@@ -639,14 +638,9 @@ static int io_wqe_worker(void *data)
 		long ret;
 
 		set_current_state(TASK_INTERRUPTIBLE);
-loop:
-		raw_spin_lock(&acct->lock);
-		if (io_acct_run_queue(acct)) {
+		while (io_acct_run_queue(acct))
 			io_worker_handle_work(worker);
-			goto loop;
-		} else {
-			raw_spin_unlock(&acct->lock);
-		}
+
 		raw_spin_lock(&wqe->lock);
 		/* timed out, exit unless we're the last worker */
 		if (last_timeout && acct->nr_workers > 1) {
@@ -671,10 +665,8 @@ static int io_wqe_worker(void *data)
 		last_timeout = !ret;
 	}
 
-	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
-		raw_spin_lock(&acct->lock);
+	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
 		io_worker_handle_work(worker);
-	}
 
 	audit_free(current);
 	io_worker_exit(worker);
-- 
2.25.1

