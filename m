Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6A945B39E
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 05:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhKXEuG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 23:50:06 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:58771 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229623AbhKXEuG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 23:50:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uy45oE2_1637729208;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uy45oE2_1637729208)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 12:46:56 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 3/9] io-wq: update check condition for lock
Date:   Wed, 24 Nov 2021 12:46:42 +0800
Message-Id: <20211124044648.142416-4-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211124044648.142416-1-haoxu@linux.alibaba.com>
References: <20211124044648.142416-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Update sparse check since we changed the lock.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 26ccc04797b7..443c34d9b326 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -378,7 +378,6 @@ static bool io_queue_worker_create(struct io_worker *worker,
 }
 
 static void io_wqe_dec_running(struct io_worker *worker)
-	__must_hold(wqe->lock)
 {
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
@@ -449,7 +448,7 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 
 static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 					   struct io_worker *worker)
-	__must_hold(wqe->lock)
+	__must_hold(acct->lock)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work, *tail;
@@ -523,7 +522,6 @@ static void io_assign_current_work(struct io_worker *worker,
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 
 static void io_worker_handle_work(struct io_worker *worker)
-	__releases(wqe->lock)
 {
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
@@ -986,7 +984,6 @@ static inline void io_wqe_remove_pending(struct io_wqe *wqe,
 static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 					struct io_wqe_acct *acct,
 					struct io_cb_cancel_data *match)
-	__releases(wqe->lock)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work;
-- 
2.24.4

