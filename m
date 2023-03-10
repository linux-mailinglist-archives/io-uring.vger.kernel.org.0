Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AD66B517D
	for <lists+io-uring@lfdr.de>; Fri, 10 Mar 2023 21:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbjCJULa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Mar 2023 15:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjCJUL3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Mar 2023 15:11:29 -0500
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD71612BAFB;
        Fri, 10 Mar 2023 12:11:24 -0800 (PST)
Received: by mail-wm1-f46.google.com with SMTP id l7-20020a05600c1d0700b003eb5e6d906bso4212548wms.5;
        Fri, 10 Mar 2023 12:11:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678479083;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6kiTqhMXHzgKv7psNi1DKTy8UVrMqOd1ia9ZGD9Fq5w=;
        b=GmgsVlm/7F9CGzjAVc5G65Wz4umcordrdF0Xc5OrF7FrXJSlDTkV+5nbJzEy3UDr0r
         eQYLEVNaOsFKBm004Rh0vzrXM/5ahgnABvtHglP76v/iSXfVo91ZIhmM6diZz7eANaUU
         tc68SJXhxwdRcg8nUaL5OFSCMIIqJry5lkAFvta3RphQwSiFZtXziIY3Y2y5FsiJqM9G
         THVNUf7QUZQiwF2rVIusfkwcJYLOxbks3mkyFWtNVXH5BnW0xrTpN2oBBOzp2Fy+bt7W
         2OnaDUTTcY0oBSTVGXIQMvQHIsTISX3EOnRwQ2lIkuRECNl5TOZgpsIl0sQh5e0CrQZ8
         K0ng==
X-Gm-Message-State: AO0yUKW6wrCAmX7v4XAsRBHO+4YSoQ5OdG78UUN8tLTYdqx84s4SYT54
        1d3+9RbaeOZREG40ROK0mMMuTC5vc6E=
X-Google-Smtp-Source: AK7set8jCawbRgZsX6BKSjZ3yb5f4Xidu7HfR10pINf8fZvFO7PiNIWte2xTrHhw66Gs1KyD1FXGeg==
X-Received: by 2002:a05:600c:1f0f:b0:3df:ef18:b0a1 with SMTP id bd15-20020a05600c1f0f00b003dfef18b0a1mr3960024wmb.12.1678479083147;
        Fri, 10 Mar 2023 12:11:23 -0800 (PST)
Received: from localhost (fwdproxy-cln-025.fbsv.net. [2a03:2880:31ff:19::face:b00c])
        by smtp.gmail.com with ESMTPSA id r17-20020a05600c35d100b003e0015c8618sm992739wmq.6.2023.03.10.12.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 12:11:22 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org
Cc:     leit@fb.com, linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: One wqe per wq
Date:   Fri, 10 Mar 2023 12:11:07 -0800
Message-Id: <20230310201107.4020580-1-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Right now io_wq allocates one io_wqe per NUMA node.  As io_wq is now
bound to a task, the task basically uses only the NUMA local io_wqe, and
almost never changes NUMA nodes, thus, the other wqes are mostly
unused.

Allocate just one io_wqe embedded into io_wq, and uses all possible cpus
(cpu_possible_mask) in the io_wqe->cpumask.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/io-wq.c | 180 ++++++++++++++++++-----------------------------
 1 file changed, 70 insertions(+), 110 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index f81c0a7136a5..44d522c5d36f 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -15,6 +15,7 @@
 #include <linux/cpu.h>
 #include <linux/task_work.h>
 #include <linux/audit.h>
+#include <linux/mmu_context.h>
 #include <uapi/linux/io_uring.h>
 
 #include "io-wq.h"
@@ -96,8 +97,6 @@ struct io_wqe {
 	raw_spinlock_t lock;
 	struct io_wqe_acct acct[IO_WQ_ACCT_NR];
 
-	int node;
-
 	struct hlist_nulls_head free_list;
 	struct list_head all_list;
 
@@ -127,7 +126,7 @@ struct io_wq {
 
 	struct task_struct *task;
 
-	struct io_wqe *wqes[];
+	struct io_wqe wqe;
 };
 
 static enum cpuhp_state io_wq_online;
@@ -754,7 +753,7 @@ static void create_worker_cont(struct callback_head *cb)
 	worker = container_of(cb, struct io_worker, create_work);
 	clear_bit_unlock(0, &worker->create_state);
 	wqe = worker->wqe;
-	tsk = create_io_thread(io_wqe_worker, worker, wqe->node);
+	tsk = create_io_thread(io_wqe_worker, worker, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
 		io_init_new_worker(wqe, worker, tsk);
 		io_worker_release(worker);
@@ -804,7 +803,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 
 	__set_current_state(TASK_RUNNING);
 
-	worker = kzalloc_node(sizeof(*worker), GFP_KERNEL, wqe->node);
+	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
 	if (!worker) {
 fail:
 		atomic_dec(&acct->nr_running);
@@ -823,7 +822,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	if (index == IO_WQ_ACCT_BOUND)
 		worker->flags |= IO_WORKER_F_BOUND;
 
-	tsk = create_io_thread(io_wqe_worker, worker, wqe->node);
+	tsk = create_io_thread(io_wqe_worker, worker, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
 		io_init_new_worker(wqe, worker, tsk);
 	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
@@ -961,7 +960,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 {
-	struct io_wqe *wqe = wq->wqes[numa_node_id()];
+	struct io_wqe *wqe = &wq->wqe;
 
 	io_wqe_enqueue(wqe, work);
 }
@@ -1083,7 +1082,7 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 		.data		= data,
 		.cancel_all	= cancel_all,
 	};
-	int node;
+	struct io_wqe *wqe = &wq->wqe;
 
 	/*
 	 * First check pending list, if we're lucky we can just remove it
@@ -1098,19 +1097,15 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	 * Do both of these while holding the wqe->lock, to ensure that
 	 * we'll find a work item regardless of state.
 	 */
-	for_each_node(node) {
-		struct io_wqe *wqe = wq->wqes[node];
-
-		io_wqe_cancel_pending_work(wqe, &match);
-		if (match.nr_pending && !match.cancel_all)
-			return IO_WQ_CANCEL_OK;
+	io_wqe_cancel_pending_work(wqe, &match);
+	if (match.nr_pending && !match.cancel_all)
+		return IO_WQ_CANCEL_OK;
 
-		raw_spin_lock(&wqe->lock);
-		io_wqe_cancel_running_work(wqe, &match);
-		raw_spin_unlock(&wqe->lock);
-		if (match.nr_running && !match.cancel_all)
-			return IO_WQ_CANCEL_RUNNING;
-	}
+	raw_spin_lock(&wqe->lock);
+	io_wqe_cancel_running_work(wqe, &match);
+	raw_spin_unlock(&wqe->lock);
+	if (match.nr_running && !match.cancel_all)
+		return IO_WQ_CANCEL_RUNNING;
 
 	if (match.nr_running)
 		return IO_WQ_CANCEL_RUNNING;
@@ -1140,15 +1135,16 @@ static int io_wqe_hash_wake(struct wait_queue_entry *wait, unsigned mode,
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 {
-	int ret, node, i;
+	int ret, i;
 	struct io_wq *wq;
+	struct io_wqe *wqe;
 
 	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
 		return ERR_PTR(-EINVAL);
 	if (WARN_ON_ONCE(!bounded))
 		return ERR_PTR(-EINVAL);
 
-	wq = kzalloc(struct_size(wq, wqes, nr_node_ids), GFP_KERNEL);
+	wq = kzalloc(sizeof(struct io_wq), GFP_KERNEL);
 	if (!wq)
 		return ERR_PTR(-ENOMEM);
 	ret = cpuhp_state_add_instance_nocalls(io_wq_online, &wq->cpuhp_node);
@@ -1159,40 +1155,30 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	wq->hash = data->hash;
 	wq->free_work = data->free_work;
 	wq->do_work = data->do_work;
+	wqe = &wq->wqe;
 
 	ret = -ENOMEM;
-	for_each_node(node) {
-		struct io_wqe *wqe;
-		int alloc_node = node;
-
-		if (!node_online(alloc_node))
-			alloc_node = NUMA_NO_NODE;
-		wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, alloc_node);
-		if (!wqe)
-			goto err;
-		wq->wqes[node] = wqe;
-		if (!alloc_cpumask_var(&wqe->cpu_mask, GFP_KERNEL))
-			goto err;
-		cpumask_copy(wqe->cpu_mask, cpumask_of_node(node));
-		wqe->node = alloc_node;
-		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
-		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
-					task_rlimit(current, RLIMIT_NPROC);
-		INIT_LIST_HEAD(&wqe->wait.entry);
-		wqe->wait.func = io_wqe_hash_wake;
-		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-			struct io_wqe_acct *acct = &wqe->acct[i];
-
-			acct->index = i;
-			atomic_set(&acct->nr_running, 0);
-			INIT_WQ_LIST(&acct->work_list);
-			raw_spin_lock_init(&acct->lock);
-		}
-		wqe->wq = wq;
-		raw_spin_lock_init(&wqe->lock);
-		INIT_HLIST_NULLS_HEAD(&wqe->free_list, 0);
-		INIT_LIST_HEAD(&wqe->all_list);
+
+	if (!alloc_cpumask_var(&wqe->cpu_mask, GFP_KERNEL))
+		goto err;
+	cpumask_copy(wqe->cpu_mask, cpu_possible_mask);
+	wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
+	wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
+				task_rlimit(current, RLIMIT_NPROC);
+	INIT_LIST_HEAD(&wqe->wait.entry);
+	wqe->wait.func = io_wqe_hash_wake;
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		struct io_wqe_acct *acct = &wqe->acct[i];
+
+		acct->index = i;
+		atomic_set(&acct->nr_running, 0);
+		INIT_WQ_LIST(&acct->work_list);
+		raw_spin_lock_init(&acct->lock);
 	}
+	wqe->wq = wq;
+	raw_spin_lock_init(&wqe->lock);
+	INIT_HLIST_NULLS_HEAD(&wqe->free_list, 0);
+	INIT_LIST_HEAD(&wqe->all_list);
 
 	wq->task = get_task_struct(data->task);
 	atomic_set(&wq->worker_refs, 1);
@@ -1201,12 +1187,8 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 err:
 	io_wq_put_hash(data->hash);
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-	for_each_node(node) {
-		if (!wq->wqes[node])
-			continue;
-		free_cpumask_var(wq->wqes[node]->cpu_mask);
-		kfree(wq->wqes[node]);
-	}
+
+	free_cpumask_var(wq->wqe.cpu_mask);
 err_wq:
 	kfree(wq);
 	return ERR_PTR(ret);
@@ -1247,48 +1229,36 @@ static void io_wq_cancel_tw_create(struct io_wq *wq)
 
 static void io_wq_exit_workers(struct io_wq *wq)
 {
-	int node;
-
 	if (!wq->task)
 		return;
 
 	io_wq_cancel_tw_create(wq);
 
 	rcu_read_lock();
-	for_each_node(node) {
-		struct io_wqe *wqe = wq->wqes[node];
-
-		io_wq_for_each_worker(wqe, io_wq_worker_wake, NULL);
-	}
+	io_wq_for_each_worker(&wq->wqe, io_wq_worker_wake, NULL);
 	rcu_read_unlock();
 	io_worker_ref_put(wq);
 	wait_for_completion(&wq->worker_done);
 
-	for_each_node(node) {
-		spin_lock_irq(&wq->hash->wait.lock);
-		list_del_init(&wq->wqes[node]->wait.entry);
-		spin_unlock_irq(&wq->hash->wait.lock);
-	}
+	spin_lock_irq(&wq->hash->wait.lock);
+	list_del_init(&wq->wqe.wait.entry);
+	spin_unlock_irq(&wq->hash->wait.lock);
+
 	put_task_struct(wq->task);
 	wq->task = NULL;
 }
 
 static void io_wq_destroy(struct io_wq *wq)
 {
-	int node;
+	struct io_cb_cancel_data match = {
+		.fn		= io_wq_work_match_all,
+		.cancel_all	= true,
+	};
+	struct io_wqe *wqe = &wq->wqe;
 
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-
-	for_each_node(node) {
-		struct io_wqe *wqe = wq->wqes[node];
-		struct io_cb_cancel_data match = {
-			.fn		= io_wq_work_match_all,
-			.cancel_all	= true,
-		};
-		io_wqe_cancel_pending_work(wqe, &match);
-		free_cpumask_var(wqe->cpu_mask);
-		kfree(wqe);
-	}
+	io_wqe_cancel_pending_work(wqe, &match);
+	free_cpumask_var(wqe->cpu_mask);
 	io_wq_put_hash(wq->hash);
 	kfree(wq);
 }
@@ -1323,11 +1293,9 @@ static int __io_wq_cpu_online(struct io_wq *wq, unsigned int cpu, bool online)
 		.cpu = cpu,
 		.online = online
 	};
-	int i;
 
 	rcu_read_lock();
-	for_each_node(i)
-		io_wq_for_each_worker(wq->wqes[i], io_wq_worker_affinity, &od);
+	io_wq_for_each_worker(&wq->wqe, io_wq_worker_affinity, &od);
 	rcu_read_unlock();
 	return 0;
 }
@@ -1348,18 +1316,15 @@ static int io_wq_cpu_offline(unsigned int cpu, struct hlist_node *node)
 
 int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask)
 {
-	int i;
+	struct io_wqe *wqe = &wq->wqe;
 
 	rcu_read_lock();
-	for_each_node(i) {
-		struct io_wqe *wqe = wq->wqes[i];
-
-		if (mask)
-			cpumask_copy(wqe->cpu_mask, mask);
-		else
-			cpumask_copy(wqe->cpu_mask, cpumask_of_node(i));
-	}
+	if (mask)
+		cpumask_copy(wqe->cpu_mask, mask);
+	else
+		cpumask_copy(wqe->cpu_mask, cpu_possible_mask);
 	rcu_read_unlock();
+
 	return 0;
 }
 
@@ -1369,9 +1334,10 @@ int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask)
  */
 int io_wq_max_workers(struct io_wq *wq, int *new_count)
 {
+	struct io_wqe *wqe = &wq->wqe;
+	struct io_wqe_acct *acct;
 	int prev[IO_WQ_ACCT_NR];
-	bool first_node = true;
-	int i, node;
+	int i;
 
 	BUILD_BUG_ON((int) IO_WQ_ACCT_BOUND   != (int) IO_WQ_BOUND);
 	BUILD_BUG_ON((int) IO_WQ_ACCT_UNBOUND != (int) IO_WQ_UNBOUND);
@@ -1386,21 +1352,15 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
 		prev[i] = 0;
 
 	rcu_read_lock();
-	for_each_node(node) {
-		struct io_wqe *wqe = wq->wqes[node];
-		struct io_wqe_acct *acct;
 
-		raw_spin_lock(&wqe->lock);
-		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-			acct = &wqe->acct[i];
-			if (first_node)
-				prev[i] = max_t(int, acct->max_workers, prev[i]);
-			if (new_count[i])
-				acct->max_workers = new_count[i];
-		}
-		raw_spin_unlock(&wqe->lock);
-		first_node = false;
+	raw_spin_lock(&wqe->lock);
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		acct = &wqe->acct[i];
+		prev[i] = max_t(int, acct->max_workers, prev[i]);
+		if (new_count[i])
+			acct->max_workers = new_count[i];
 	}
+	raw_spin_unlock(&wqe->lock);
 	rcu_read_unlock();
 
 	for (i = 0; i < IO_WQ_ACCT_NR; i++)
-- 
2.34.1

