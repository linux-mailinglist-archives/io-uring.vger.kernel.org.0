Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4921145B39C
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 05:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhKXEuG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 23:50:06 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:37889 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229729AbhKXEuG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 23:50:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uy45oE2_1637729208;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uy45oE2_1637729208)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 12:46:55 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/9] io-wq: reduce acct->lock crossing functions lock/unlock
Date:   Wed, 24 Nov 2021 12:46:41 +0800
Message-Id: <20211124044648.142416-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211124044648.142416-1-haoxu@linux.alibaba.com>
References: <20211124044648.142416-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

reduce acct->lock lock and unlock in different functions to make the
code clearer.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 1869cf6c39f3..26ccc04797b7 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -237,10 +237,14 @@ static void io_worker_exit(struct io_worker *worker)
 
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
+	return ret;
 }
 
 /*
@@ -385,13 +389,9 @@ static void io_wqe_dec_running(struct io_worker *worker)
 	if (!atomic_dec_and_test(&acct->nr_running))
 		return;
 
-	raw_spin_lock(&acct->lock);
-	if (!io_acct_run_queue(acct)) {
-		raw_spin_unlock(&acct->lock);
+	if (!io_acct_run_queue(acct))
 		return;
-	}
 
-	raw_spin_unlock(&acct->lock);
 	atomic_inc(&acct->nr_running);
 	atomic_inc(&wqe->wq->worker_refs);
 	io_queue_worker_create(worker, acct, create_worker_cb);
@@ -540,6 +540,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
+		raw_spin_lock(&acct->lock);
 		work = io_get_next_work(acct, worker);
 		raw_spin_unlock(&acct->lock);
 		if (work) {
@@ -579,15 +580,10 @@ static void io_worker_handle_work(struct io_worker *worker)
 				clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 				if (wq_has_sleeper(&wq->hash->wait))
 					wake_up(&wq->hash->wait);
-				raw_spin_lock(&acct->lock);
-				/* skip unnecessary unlock-lock wqe->lock */
 				if (!work)
 					goto get_next;
-				raw_spin_unlock(&acct->lock);
 			}
 		} while (work);
-
-		raw_spin_lock(&acct->lock);
 	} while (1);
 }
 
@@ -610,12 +606,9 @@ static int io_wqe_worker(void *data)
 
 		set_current_state(TASK_INTERRUPTIBLE);
 loop:
-		raw_spin_lock(&acct->lock);
 		if (io_acct_run_queue(acct)) {
 			io_worker_handle_work(worker);
 			goto loop;
-		} else {
-			raw_spin_unlock(&acct->lock);
 		}
 		raw_spin_lock(&wqe->lock);
 		/* timed out, exit unless we're the last worker */
@@ -641,10 +634,8 @@ static int io_wqe_worker(void *data)
 		last_timeout = !ret;
 	}
 
-	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
-		raw_spin_lock(&acct->lock);
+	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
 		io_worker_handle_work(worker);
-	}
 
 	io_worker_exit(worker);
 	return 0;
-- 
2.24.4

