Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4BB45B3A1
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 05:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhKXEuI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 23:50:08 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:39236 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229623AbhKXEuH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 23:50:07 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uy45oE2_1637729208;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uy45oE2_1637729208)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 12:46:57 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 6/9] io-wq: add infra data structure for fixed workers
Date:   Wed, 24 Nov 2021 12:46:45 +0800
Message-Id: <20211124044648.142416-7-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211124044648.142416-1-haoxu@linux.alibaba.com>
References: <20211124044648.142416-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add data sttructure and basic initialization for fixed worker.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 63 ++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 18 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 44c3e344c5d6..fcdfbb904cdf 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -25,6 +25,7 @@ enum {
 	IO_WORKER_F_RUNNING	= 2,	/* account as running */
 	IO_WORKER_F_FREE	= 4,	/* worker on free list */
 	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
+	IO_WORKER_F_FIXED	= 16,	/* is a fixed worker */
 };
 
 enum {
@@ -33,6 +34,35 @@ enum {
 
 enum {
 	IO_ACCT_STALLED_BIT	= 0,	/* stalled on hash */
+	IO_ACCT_IN_WORKER_BIT,
+};
+
+struct io_wqe_acct {
+	union {
+		unsigned int nr_workers;
+		unsigned int nr_works;
+	};
+	union {
+		unsigned int max_workers;
+		unsigned int max_works;
+	};
+	int index;
+	atomic_t nr_running;
+	raw_spinlock_t lock;
+	struct io_wq_work_list work_list;
+	unsigned long flags;
+
+	struct wait_queue_entry wait;
+	union {
+		struct io_wqe *wqe;
+		struct io_worker *worker;
+	};
+};
+
+enum {
+	IO_WQ_ACCT_BOUND,
+	IO_WQ_ACCT_UNBOUND,
+	IO_WQ_ACCT_NR,
 };
 
 /*
@@ -59,6 +89,9 @@ struct io_worker {
 		struct rcu_head rcu;
 		struct work_struct work;
 	};
+	bool fixed;
+	unsigned int index;
+	struct io_wqe_acct acct;
 };
 
 #if BITS_PER_LONG == 64
@@ -69,24 +102,6 @@ struct io_worker {
 
 #define IO_WQ_NR_HASH_BUCKETS	(1u << IO_WQ_HASH_ORDER)
 
-struct io_wqe_acct {
-	unsigned nr_workers;
-	unsigned max_workers;
-	int index;
-	atomic_t nr_running;
-	raw_spinlock_t lock;
-	struct io_wq_work_list work_list;
-	unsigned long flags;
-	struct wait_queue_entry wait;
-	struct io_wqe *wqe;
-};
-
-enum {
-	IO_WQ_ACCT_BOUND,
-	IO_WQ_ACCT_UNBOUND,
-	IO_WQ_ACCT_NR,
-};
-
 /*
  * Per-node worker thread pool
  */
@@ -103,6 +118,12 @@ struct io_wqe {
 	struct io_wq_work *hash_tail[IO_WQ_NR_HASH_BUCKETS];
 
 	cpumask_var_t cpu_mask;
+
+	raw_spinlock_t fixed_lock;
+	unsigned int max_fixed[IO_WQ_ACCT_NR];
+	unsigned int nr_fixed[IO_WQ_ACCT_NR];
+	unsigned int default_max_works[IO_WQ_ACCT_NR];
+	struct io_worker **fixed_workers[IO_WQ_ACCT_NR];
 };
 
 /*
@@ -1090,6 +1111,8 @@ static int io_wqe_hash_wake(struct wait_queue_entry *wait, unsigned mode,
 	return 1;
 }
 
+#define DEFAULT_MAX_FIXED_WORKERS 0
+#define DEFAULT_MAX_FIXED_WORKS 0
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 {
 	int ret, node, i;
@@ -1141,9 +1164,12 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 			INIT_LIST_HEAD(&acct->wait.entry);
 			acct->wait.func = io_wqe_hash_wake;
 			acct->wqe = wqe;
+			wqe->max_fixed[i] = DEFAULT_MAX_FIXED_WORKERS;
+			wqe->default_max_works[i] = DEFAULT_MAX_FIXED_WORKS;
 		}
 		wqe->wq = wq;
 		raw_spin_lock_init(&wqe->lock);
+		raw_spin_lock_init(&wqe->fixed_lock);
 		INIT_HLIST_NULLS_HEAD(&wqe->free_list, 0);
 		INIT_LIST_HEAD(&wqe->all_list);
 	}
@@ -1232,6 +1258,7 @@ static void io_wq_destroy(struct io_wq *wq)
 		};
 		io_wqe_cancel_pending_work(wqe, &match);
 		free_cpumask_var(wqe->cpu_mask);
+		kfree(wqe->fixed_workers);
 		kfree(wqe);
 	}
 	io_wq_put_hash(wq->hash);
-- 
2.24.4

