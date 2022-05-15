Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974795277BB
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 15:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiEONMz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 09:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236841AbiEONMz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 09:12:55 -0400
Received: from pv50p00im-ztdg10022001.me.com (pv50p00im-ztdg10022001.me.com [17.58.6.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D2CDF67
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 06:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652620372;
        bh=C1bI0TWHN23Y0viwQoofcVG0b8qJVUVJWBIOvXCIB4c=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=ODVxDXfaYp7clxkLSZXOjw7tVh6GOCrC303b2bPGzfFqpL5jzSY2Gs/g7ZOjdinSV
         Rt/OPGhbeHiLDX5WpWQ0kf3e1xTF1SGPmokpd4sX0njkA3Rh/AuhC7CLMmmitkB1q3
         BsIQpx/om8dt9VaF6zjpzjkCamDmXeXvTO/BVUWj+4+BKEqgm8bHTktyxRNzp7rGfS
         BlsUrUoUARY7s1wiqKRKKssa45mpLcKpXvxQAiulKWmuVS1JYNwWPifuYfhbxH4XPR
         xvNvwtb86u+Ae804ccI8UtAYzj3ZjHhwc/ifX/PGhfjyM/71kN3JPBGQ5bLPuIWat7
         d7kDo1V2cx09A==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10022001.me.com (Postfix) with ESMTPSA id 1FF553E1F11;
        Sun, 15 May 2022 13:12:48 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 03/11] io-wq: add infra data structure for fixed workers
Date:   Sun, 15 May 2022 21:12:22 +0800
Message-Id: <20220515131230.155267-4-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220515131230.155267-1-haoxu.linux@icloud.com>
References: <20220515131230.155267-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-15_07:2022-05-13,2022-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=807 adultscore=0 classifier=spam adjust=0 reason=mlx
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

Add data sttructure and basic initialization for fixed worker.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 94 insertions(+), 11 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 35ce622f77ba..73fbe62617b7 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -26,6 +26,7 @@ enum {
 	IO_WORKER_F_RUNNING	= 2,	/* account as running */
 	IO_WORKER_F_FREE	= 4,	/* worker on free list */
 	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
+	IO_WORKER_F_FIXED	= 16,	/* is a fixed worker */
 	IO_WORKER_F_EXIT	= 32,	/* worker is exiting */
 };
 
@@ -37,6 +38,68 @@ enum {
 	IO_ACCT_STALLED_BIT	= 0,	/* stalled on hash */
 };
 
+struct io_wqe_acct {
+/*
+ *	union {
+ *		// (1) for wqe->acct (normal worker)
+ *		struct {
+ *			unsigned nr_workers;
+ *			unsigned max_workers;
+ *			struct io_wq_work_list work_list;
+ *		};
+ *		// (2) for wqe->fixed_acct (fixed worker)
+ *		struct {
+ *			unsigned nr_workers;
+ *			unsigned max_workers;
+ *			unsigned nr_fixed;
+ *			unsigned max_works;
+ *			struct io_worker **fixed_workers;
+ *		};
+ *		// (3) for fixed worker's private acct
+ *		struct {
+ *			unsigned nr_works;
+ *			unsigned max_works;
+ *			struct io_wq_work_list work_list;
+ *		};
+ *	};
+ */
+	union {
+		struct {
+			unsigned nr_workers;
+			unsigned max_workers;
+		};
+		struct {
+			unsigned nr_works;
+		};
+	};
+	unsigned max_works;
+	union {
+		struct io_wq_work_list work_list;
+		struct {
+			unsigned nr_fixed;
+			struct io_worker **fixed_workers;
+		};
+	};
+
+	/*
+	 * nr_running is not meaningful for fixed worker
+	 * but still keep the same logic for it for the
+	 * convinence for now. So do nr_workers and
+	 * max_workers.
+	 */
+	atomic_t nr_running;
+	/*
+	 * For 1), it protects the work_list, the other two member nr_workers
+	 * and max_workers are protected by wqe->lock.
+	 * For 2), it protects nr_fixed, max_works, fixed_workers
+	 * For 3), it protects nr_works, max_works and work_list.
+	 */
+	raw_spinlock_t lock;
+	int index;
+	unsigned long flags;
+	bool fixed_worker_registered;
+};
+
 /*
  * One for each thread in a wqe pool
  */
@@ -62,6 +125,8 @@ struct io_worker {
 		struct rcu_head rcu;
 		struct work_struct work;
 	};
+	int index;
+	struct io_wqe_acct acct;
 };
 
 #if BITS_PER_LONG == 64
@@ -72,16 +137,6 @@ struct io_worker {
 
 #define IO_WQ_NR_HASH_BUCKETS	(1u << IO_WQ_HASH_ORDER)
 
-struct io_wqe_acct {
-	unsigned nr_workers;
-	unsigned max_workers;
-	int index;
-	atomic_t nr_running;
-	raw_spinlock_t lock;
-	struct io_wq_work_list work_list;
-	unsigned long flags;
-};
-
 enum {
 	IO_WQ_ACCT_BOUND,
 	IO_WQ_ACCT_UNBOUND,
@@ -94,6 +149,7 @@ enum {
 struct io_wqe {
 	raw_spinlock_t lock;
 	struct io_wqe_acct acct[IO_WQ_ACCT_NR];
+	struct io_wqe_acct fixed_acct[IO_WQ_ACCT_NR];
 
 	int node;
 
@@ -1205,6 +1261,31 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 			atomic_set(&acct->nr_running, 0);
 			INIT_WQ_LIST(&acct->work_list);
 			raw_spin_lock_init(&acct->lock);
+
+			acct = &wqe->fixed_acct[i];
+			acct->index = i;
+			INIT_WQ_LIST(&acct->work_list);
+			raw_spin_lock_init(&acct->lock);
+			/*
+			 * nr_running for a fixed worker is meaningless
+			 * for now, init it to 1 to wround around the
+			 * io_wqe_dec_running logic
+			 */
+			atomic_set(&acct->nr_running, 1);
+			/*
+			 * max_workers for a fixed worker is meaningless
+			 * for now, init it so since number of fixed workers
+			 * should be controlled by users.
+			 */
+			acct->max_workers = task_rlimit(current, RLIMIT_NPROC);
+			raw_spin_lock_init(&acct->lock);
+			/*
+			 * For fixed worker, not necessary
+			 * but do it explicitly for clearity
+			 */
+			acct->nr_fixed = 0;
+			acct->max_works = 0;
+			acct->fixed_workers = NULL;
 		}
 		wqe->wq = wq;
 		raw_spin_lock_init(&wqe->lock);
@@ -1287,7 +1368,7 @@ static void io_wq_exit_workers(struct io_wq *wq)
 
 static void io_wq_destroy(struct io_wq *wq)
 {
-	int node;
+	int i, node;
 
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 
@@ -1299,6 +1380,8 @@ static void io_wq_destroy(struct io_wq *wq)
 		};
 		io_wqe_cancel_pending_work(wqe, &match);
 		free_cpumask_var(wqe->cpu_mask);
+		for (i = 0; i < IO_WQ_ACCT_NR; i++)
+			kfree(wqe->fixed_acct[i].fixed_workers);
 		kfree(wqe);
 	}
 	io_wq_put_hash(wq->hash);
-- 
2.25.1

