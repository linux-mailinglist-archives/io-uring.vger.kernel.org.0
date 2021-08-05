Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F963E11EE
	for <lists+io-uring@lfdr.de>; Thu,  5 Aug 2021 12:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239918AbhHEKGE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Aug 2021 06:06:04 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:41767 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239963AbhHEKGB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Aug 2021 06:06:01 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Ui1e.zi_1628157938;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Ui1e.zi_1628157938)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 05 Aug 2021 18:05:44 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/3] io-wq: clean code of task state setting
Date:   Thu,  5 Aug 2021 18:05:36 +0800
Message-Id: <20210805100538.127891-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210805100538.127891-1-haoxu@linux.alibaba.com>
References: <20210805100538.127891-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't need to set task state to TASK_INTERRUPTIBLE at the beginning
of while() in io_wqe_worker(), which causes state resetting to
TASK_RUNNING in other place. Move it to above schedule_timeout() and
remove redundant task state settings.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 50dc93ffc153..cd4fd4d6268f 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -380,7 +380,6 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 	if (list_empty(&wqe->wait.entry)) {
 		__add_wait_queue(&wq->hash->wait, &wqe->wait);
 		if (!test_bit(hash, &wq->hash->map)) {
-			__set_current_state(TASK_RUNNING);
 			list_del_init(&wqe->wait.entry);
 		}
 	}
@@ -433,7 +432,6 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 static bool io_flush_signals(void)
 {
 	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL))) {
-		__set_current_state(TASK_RUNNING);
 		tracehook_notify_signal();
 		return true;
 	}
@@ -482,7 +480,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 		if (!work)
 			break;
 		io_assign_current_work(worker, work);
-		__set_current_state(TASK_RUNNING);
 
 		/* handle a whole dependent link */
 		do {
@@ -538,7 +535,6 @@ static int io_wqe_worker(void *data)
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		long ret;
 
-		set_current_state(TASK_INTERRUPTIBLE);
 loop:
 		raw_spin_lock_irq(&wqe->lock);
 		if (io_wqe_run_queue(wqe)) {
@@ -549,6 +545,7 @@ static int io_wqe_worker(void *data)
 		raw_spin_unlock_irq(&wqe->lock);
 		if (io_flush_signals())
 			continue;
+		set_current_state(TASK_INTERRUPTIBLE);
 		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
 		if (signal_pending(current)) {
 			struct ksignal ksig;
-- 
2.24.4

