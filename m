Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD19599E3A
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348966AbiHSP3z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349079AbiHSP3w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:29:52 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98DAE68C2
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:29:49 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660922987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dn1SuKfvdTW1N/o/HS4A6lbLDjo5jUVIvfIV9+6/E5U=;
        b=oisBl32dUVt/PQBLOx/C9wsskJ8NNn6BtP3FpmDOfi9CJB3cPkmDkdntiYu8ZhMOcDqGwm
        nsvogO1w43ZbKpt9bIK37kSjW47eo/1BMScqLkSNsXpkU8ti2Tysm/PRnW2kZINc56Z1Bu
        kMlDZ5QGjrthC2rWYQqQ/LTSqAiYIK0=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 09/19] io-wq: add IO_WORKER_F_SCHEDULED and its friends
Date:   Fri, 19 Aug 2022 23:27:28 +0800
Message-Id: <20220819152738.1111255-10-hao.xu@linux.dev>
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

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 29 ++---------------------------
 io_uring/io-wq.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 27 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 7e58bb5857ee..fe4faff79cf8 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -32,33 +32,6 @@ enum {
 	IO_ACCT_STALLED_BIT	= 0,	/* stalled on hash */
 };
 
-/*
- * One for each thread in a wqe pool
- */
-struct io_worker {
-	refcount_t ref;
-	unsigned flags;
-	struct hlist_nulls_node nulls_node;
-	struct list_head all_list;
-	struct task_struct *task;
-	struct io_wqe *wqe;
-
-	struct io_wq_work *cur_work;
-	struct io_wq_work *next_work;
-	raw_spinlock_t lock;
-
-	struct completion ref_done;
-
-	unsigned long create_state;
-	struct callback_head create_work;
-	int create_index;
-
-	union {
-		struct rcu_head rcu;
-		struct work_struct work;
-	};
-};
-
 #if BITS_PER_LONG == 64
 #define IO_WQ_HASH_ORDER	6
 #else
@@ -426,6 +399,7 @@ static void io_wqe_dec_running(struct io_worker *worker)
 		if (!io_worker_test_submit(worker))
 			return;
 
+		io_worker_set_scheduled(worker);
 		raw_spin_lock(&wqe->lock);
 		rcu_read_lock();
 		activated = io_wqe_activate_free_worker(wqe, acct);
@@ -706,6 +680,7 @@ static void io_wqe_worker_let(struct io_worker *worker)
 		do {
 			enum io_uringlet_state submit_state;
 
+			io_worker_clean_scheduled(worker);
 			io_worker_set_submit(worker);
 			submit_state = wq->do_work(wq->private);
 			io_worker_clean_submit(worker);
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 1485e9009784..81146dba2ae6 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -3,9 +3,37 @@
 
 #include <linux/refcount.h>
 #include <linux/io_uring_types.h>
+#include <linux/list_nulls.h>
 
 struct io_wq;
 
+/*
+ * One for each thread in a wqe pool
+ */
+struct io_worker {
+	refcount_t ref;
+	unsigned flags;
+	struct hlist_nulls_node nulls_node;
+	struct list_head all_list;
+	struct task_struct *task;
+	struct io_wqe *wqe;
+
+	struct io_wq_work *cur_work;
+	struct io_wq_work *next_work;
+	raw_spinlock_t lock;
+
+	struct completion ref_done;
+
+	unsigned long create_state;
+	struct callback_head create_work;
+	int create_index;
+
+	union {
+		struct rcu_head rcu;
+		struct work_struct work;
+	};
+};
+
 enum {
 	IO_WQ_WORK_CANCEL	= 1,
 	IO_WQ_WORK_HASHED	= 2,
@@ -97,6 +125,21 @@ static inline bool io_wq_current_is_worker(void)
 		current->worker_private;
 }
 
+static inline void io_worker_set_scheduled(struct io_worker *worker)
+{
+	worker->flags |= IO_WORKER_F_SCHEDULED;
+}
+
+static inline void io_worker_clean_scheduled(struct io_worker *worker)
+{
+	worker->flags &= ~IO_WORKER_F_SCHEDULED;
+}
+
+static inline bool io_worker_test_scheduled(struct io_worker *worker)
+{
+	return worker->flags & IO_WORKER_F_SCHEDULED;
+}
+
 extern struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 					struct task_struct *task);
 extern int io_uringlet_offload(struct io_wq *wq);
-- 
2.25.1

