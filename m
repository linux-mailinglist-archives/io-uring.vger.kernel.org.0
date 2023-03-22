Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F036C3FA4
	for <lists+io-uring@lfdr.de>; Wed, 22 Mar 2023 02:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjCVBRf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Mar 2023 21:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjCVBR2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Mar 2023 21:17:28 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F1F59809
        for <io-uring@vger.kernel.org>; Tue, 21 Mar 2023 18:17:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4B86022B92;
        Wed, 22 Mar 2023 01:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679447801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6m1aMrNL9kmvX1UKECIT8vdC32qe4kH2FwkhPLAi90E=;
        b=GpYwJopyvcVgDSFgYVpsQ8tr+xXwqR2HGYLHkQ4IvOt5K98QwVl0iaPDypda+lRwa/71I/
        iSWxUYKiIRapm0s8u6doxQG0uxYKgwEAsgUCB2ALNWcHorhZBoWztrqChMKiJ8T+DlEAhd
        0Jtd96tpSmA5cXo7sugnidfjdWU+KU4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679447801;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6m1aMrNL9kmvX1UKECIT8vdC32qe4kH2FwkhPLAi90E=;
        b=dyOsn0Xpkywi3OmIpd7/MLB7LFeYQHH0xNQEpyXQSTdOlKMyN/8Z4JETB0HhD4ixKKtuI0
        ftNtNqZNlCxeIfCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8DE1D13451;
        Wed, 22 Mar 2023 01:16:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fhFjFfhWGmRKfQAAMHmgww
        (envelope-from <krisman@suse.de>); Wed, 22 Mar 2023 01:16:40 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 2/2] io-wq: Drop struct io_wqe
Date:   Tue, 21 Mar 2023 22:16:28 -0300
Message-Id: <20230322011628.23359-3-krisman@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230322011628.23359-1-krisman@suse.de>
References: <20230322011628.23359-1-krisman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since commit 0654b05e7e65 ("io_uring: One wqe per wq"), we have just a
single io_wqe instance embedded per io_wq.  Drop the extra structure in
favor of accessing struct io_wq directly, cleaning up quite a bit of
dereferences and backpointers.

No functional changes intended.  Tested with liburing's testsuite
and mmtests performance microbenchmarks.  I didn't observe any
performance regressions.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io-wq.c | 344 +++++++++++++++++++++--------------------------
 1 file changed, 156 insertions(+), 188 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index da7c6e00b690..2b0b2e33cd71 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -40,7 +40,7 @@ enum {
 };
 
 /*
- * One for each thread in a wqe pool
+ * One for each thread in a wq pool
  */
 struct io_worker {
 	refcount_t ref;
@@ -48,7 +48,7 @@ struct io_worker {
 	struct hlist_nulls_node nulls_node;
 	struct list_head all_list;
 	struct task_struct *task;
-	struct io_wqe *wqe;
+	struct io_wq *wq;
 
 	struct io_wq_work *cur_work;
 	struct io_wq_work *next_work;
@@ -90,23 +90,6 @@ enum {
 	IO_WQ_ACCT_NR,
 };
 
-/*
- * Per-node worker thread pool
- */
-struct io_wqe {
-	raw_spinlock_t lock;
-
-	struct hlist_nulls_head free_list;
-	struct list_head all_list;
-
-	struct wait_queue_entry wait;
-
-	struct io_wq *wq;
-	struct io_wq_work *hash_tail[IO_WQ_NR_HASH_BUCKETS];
-
-	cpumask_var_t cpu_mask;
-};
-
 /*
  * Per io_wq state
   */
@@ -127,7 +110,17 @@ struct io_wq {
 
 	struct io_wq_acct acct[IO_WQ_ACCT_NR];
 
-	struct io_wqe wqe;
+	/* lock protects access to elements below */
+	raw_spinlock_t lock;
+
+	struct hlist_nulls_head free_list;
+	struct list_head all_list;
+
+	struct wait_queue_entry wait;
+
+	struct io_wq_work *hash_tail[IO_WQ_NR_HASH_BUCKETS];
+
+	cpumask_var_t cpu_mask;
 };
 
 static enum cpuhp_state io_wq_online;
@@ -140,9 +133,9 @@ struct io_cb_cancel_data {
 	bool cancel_all;
 };
 
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
-static void io_wqe_dec_running(struct io_worker *worker);
-static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
+static bool create_io_worker(struct io_wq *wq, int index);
+static void io_wq_dec_running(struct io_worker *worker);
+static bool io_acct_cancel_pending_work(struct io_wq *wq,
 					struct io_wq_acct *acct,
 					struct io_cb_cancel_data *match);
 static void create_worker_cb(struct callback_head *cb);
@@ -172,7 +165,7 @@ static inline struct io_wq_acct *io_work_get_acct(struct io_wq *wq,
 
 static inline struct io_wq_acct *io_wq_get_acct(struct io_worker *worker)
 {
-	return io_get_acct(worker->wqe->wq, worker->flags & IO_WORKER_F_BOUND);
+	return io_get_acct(worker->wq, worker->flags & IO_WORKER_F_BOUND);
 }
 
 static void io_worker_ref_put(struct io_wq *wq)
@@ -184,13 +177,12 @@ static void io_worker_ref_put(struct io_wq *wq)
 static void io_worker_cancel_cb(struct io_worker *worker)
 {
 	struct io_wq_acct *acct = io_wq_get_acct(worker);
-	struct io_wqe *wqe = worker->wqe;
-	struct io_wq *wq = wqe->wq;
+	struct io_wq *wq = worker->wq;
 
 	atomic_dec(&acct->nr_running);
-	raw_spin_lock(&worker->wqe->lock);
+	raw_spin_lock(&wq->lock);
 	acct->nr_workers--;
-	raw_spin_unlock(&worker->wqe->lock);
+	raw_spin_unlock(&wq->lock);
 	io_worker_ref_put(wq);
 	clear_bit_unlock(0, &worker->create_state);
 	io_worker_release(worker);
@@ -208,8 +200,7 @@ static bool io_task_worker_match(struct callback_head *cb, void *data)
 
 static void io_worker_exit(struct io_worker *worker)
 {
-	struct io_wqe *wqe = worker->wqe;
-	struct io_wq *wq = wqe->wq;
+	struct io_wq *wq = worker->wq;
 
 	while (1) {
 		struct callback_head *cb = task_work_cancel_match(wq->task,
@@ -223,19 +214,19 @@ static void io_worker_exit(struct io_worker *worker)
 	io_worker_release(worker);
 	wait_for_completion(&worker->ref_done);
 
-	raw_spin_lock(&wqe->lock);
+	raw_spin_lock(&wq->lock);
 	if (worker->flags & IO_WORKER_F_FREE)
 		hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
-	raw_spin_unlock(&wqe->lock);
-	io_wqe_dec_running(worker);
+	raw_spin_unlock(&wq->lock);
+	io_wq_dec_running(worker);
 	worker->flags = 0;
 	preempt_disable();
 	current->flags &= ~PF_IO_WORKER;
 	preempt_enable();
 
 	kfree_rcu(worker, rcu);
-	io_worker_ref_put(wqe->wq);
+	io_worker_ref_put(wq);
 	do_exit(0);
 }
 
@@ -256,7 +247,7 @@ static inline bool io_acct_run_queue(struct io_wq_acct *acct)
  * Check head of free list for an available worker. If one isn't available,
  * caller must create one.
  */
-static bool io_wqe_activate_free_worker(struct io_wqe *wqe,
+static bool io_wq_activate_free_worker(struct io_wq *wq,
 					struct io_wq_acct *acct)
 	__must_hold(RCU)
 {
@@ -268,7 +259,7 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe,
 	 * activate. If a given worker is on the free_list but in the process
 	 * of exiting, keep trying.
 	 */
-	hlist_nulls_for_each_entry_rcu(worker, n, &wqe->free_list, nulls_node) {
+	hlist_nulls_for_each_entry_rcu(worker, n, &wq->free_list, nulls_node) {
 		if (!io_worker_get(worker))
 			continue;
 		if (io_wq_get_acct(worker) != acct) {
@@ -289,7 +280,7 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe,
  * We need a worker. If we find a free one, we're good. If not, and we're
  * below the max number of workers, create one.
  */
-static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wq_acct *acct)
+static bool io_wq_create_worker(struct io_wq *wq, struct io_wq_acct *acct)
 {
 	/*
 	 * Most likely an attempt to queue unbounded work on an io_wq that
@@ -298,19 +289,19 @@ static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wq_acct *acct)
 	if (unlikely(!acct->max_workers))
 		pr_warn_once("io-wq is not configured for unbound workers");
 
-	raw_spin_lock(&wqe->lock);
+	raw_spin_lock(&wq->lock);
 	if (acct->nr_workers >= acct->max_workers) {
-		raw_spin_unlock(&wqe->lock);
+		raw_spin_unlock(&wq->lock);
 		return true;
 	}
 	acct->nr_workers++;
-	raw_spin_unlock(&wqe->lock);
+	raw_spin_unlock(&wq->lock);
 	atomic_inc(&acct->nr_running);
-	atomic_inc(&wqe->wq->worker_refs);
-	return create_io_worker(wqe->wq, wqe, acct->index);
+	atomic_inc(&wq->worker_refs);
+	return create_io_worker(wq, acct->index);
 }
 
-static void io_wqe_inc_running(struct io_worker *worker)
+static void io_wq_inc_running(struct io_worker *worker)
 {
 	struct io_wq_acct *acct = io_wq_get_acct(worker);
 
@@ -321,22 +312,22 @@ static void create_worker_cb(struct callback_head *cb)
 {
 	struct io_worker *worker;
 	struct io_wq *wq;
-	struct io_wqe *wqe;
+
 	struct io_wq_acct *acct;
 	bool do_create = false;
 
 	worker = container_of(cb, struct io_worker, create_work);
-	wqe = worker->wqe;
-	wq = wqe->wq;
+	wq = worker->wq;
 	acct = &wq->acct[worker->create_index];
-	raw_spin_lock(&wqe->lock);
+	raw_spin_lock(&wq->lock);
+
 	if (acct->nr_workers < acct->max_workers) {
 		acct->nr_workers++;
 		do_create = true;
 	}
-	raw_spin_unlock(&wqe->lock);
+	raw_spin_unlock(&wq->lock);
 	if (do_create) {
-		create_io_worker(wq, wqe, worker->create_index);
+		create_io_worker(wq, worker->create_index);
 	} else {
 		atomic_dec(&acct->nr_running);
 		io_worker_ref_put(wq);
@@ -349,8 +340,7 @@ static bool io_queue_worker_create(struct io_worker *worker,
 				   struct io_wq_acct *acct,
 				   task_work_func_t func)
 {
-	struct io_wqe *wqe = worker->wqe;
-	struct io_wq *wq = wqe->wq;
+	struct io_wq *wq = worker->wq;
 
 	/* raced with exit, just ignore create call */
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
@@ -392,10 +382,10 @@ static bool io_queue_worker_create(struct io_worker *worker,
 	return false;
 }
 
-static void io_wqe_dec_running(struct io_worker *worker)
+static void io_wq_dec_running(struct io_worker *worker)
 {
 	struct io_wq_acct *acct = io_wq_get_acct(worker);
-	struct io_wqe *wqe = worker->wqe;
+	struct io_wq *wq = worker->wq;
 
 	if (!(worker->flags & IO_WORKER_F_UP))
 		return;
@@ -406,7 +396,7 @@ static void io_wqe_dec_running(struct io_worker *worker)
 		return;
 
 	atomic_inc(&acct->nr_running);
-	atomic_inc(&wqe->wq->worker_refs);
+	atomic_inc(&wq->worker_refs);
 	io_queue_worker_create(worker, acct, create_worker_cb);
 }
 
@@ -414,13 +404,13 @@ static void io_wqe_dec_running(struct io_worker *worker)
  * Worker will start processing some work. Move it to the busy list, if
  * it's currently on the freelist
  */
-static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker)
+static void __io_worker_busy(struct io_wq *wq, struct io_worker *worker)
 {
 	if (worker->flags & IO_WORKER_F_FREE) {
 		worker->flags &= ~IO_WORKER_F_FREE;
-		raw_spin_lock(&wqe->lock);
+		raw_spin_lock(&wq->lock);
 		hlist_nulls_del_init_rcu(&worker->nulls_node);
-		raw_spin_unlock(&wqe->lock);
+		raw_spin_unlock(&wq->lock);
 	}
 }
 
@@ -431,12 +421,12 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker)
  * retry the loop in that case (we changed task state), we don't regrab
  * the lock if we return success.
  */
-static void __io_worker_idle(struct io_wqe *wqe, struct io_worker *worker)
-	__must_hold(wqe->lock)
+static void __io_worker_idle(struct io_wq *wq, struct io_worker *worker)
+	__must_hold(wq->lock)
 {
 	if (!(worker->flags & IO_WORKER_F_FREE)) {
 		worker->flags |= IO_WORKER_F_FREE;
-		hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
+		hlist_nulls_add_head_rcu(&worker->nulls_node, &wq->free_list);
 	}
 }
 
@@ -445,17 +435,16 @@ static inline unsigned int io_get_work_hash(struct io_wq_work *work)
 	return work->flags >> IO_WQ_HASH_SHIFT;
 }
 
-static bool io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
+static bool io_wait_on_hash(struct io_wq *wq, unsigned int hash)
 {
-	struct io_wq *wq = wqe->wq;
 	bool ret = false;
 
 	spin_lock_irq(&wq->hash->wait.lock);
-	if (list_empty(&wqe->wait.entry)) {
-		__add_wait_queue(&wq->hash->wait, &wqe->wait);
+	if (list_empty(&wq->wait.entry)) {
+		__add_wait_queue(&wq->hash->wait, &wq->wait);
 		if (!test_bit(hash, &wq->hash->map)) {
 			__set_current_state(TASK_RUNNING);
-			list_del_init(&wqe->wait.entry);
+			list_del_init(&wq->wait.entry);
 			ret = true;
 		}
 	}
@@ -470,7 +459,7 @@ static struct io_wq_work *io_get_next_work(struct io_wq_acct *acct,
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work, *tail;
 	unsigned int stall_hash = -1U;
-	struct io_wqe *wqe = worker->wqe;
+	struct io_wq *wq = worker->wq;
 
 	wq_list_for_each(node, prev, &acct->work_list) {
 		unsigned int hash;
@@ -485,11 +474,11 @@ static struct io_wq_work *io_get_next_work(struct io_wq_acct *acct,
 
 		hash = io_get_work_hash(work);
 		/* all items with this hash lie in [work, tail] */
-		tail = wqe->hash_tail[hash];
+		tail = wq->hash_tail[hash];
 
 		/* hashed, can run if not already running */
-		if (!test_and_set_bit(hash, &wqe->wq->hash->map)) {
-			wqe->hash_tail[hash] = NULL;
+		if (!test_and_set_bit(hash, &wq->hash->map)) {
+			wq->hash_tail[hash] = NULL;
 			wq_list_cut(&acct->work_list, &tail->list, prev);
 			return work;
 		}
@@ -508,12 +497,12 @@ static struct io_wq_work *io_get_next_work(struct io_wq_acct *acct,
 		 */
 		set_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 		raw_spin_unlock(&acct->lock);
-		unstalled = io_wait_on_hash(wqe, stall_hash);
+		unstalled = io_wait_on_hash(wq, stall_hash);
 		raw_spin_lock(&acct->lock);
 		if (unstalled) {
 			clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
-			if (wq_has_sleeper(&wqe->wq->hash->wait))
-				wake_up(&wqe->wq->hash->wait);
+			if (wq_has_sleeper(&wq->hash->wait))
+				wake_up(&wq->hash->wait);
 		}
 	}
 
@@ -534,13 +523,10 @@ static void io_assign_current_work(struct io_worker *worker,
 	raw_spin_unlock(&worker->lock);
 }
 
-static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
-
 static void io_worker_handle_work(struct io_worker *worker)
 {
 	struct io_wq_acct *acct = io_wq_get_acct(worker);
-	struct io_wqe *wqe = worker->wqe;
-	struct io_wq *wq = wqe->wq;
+	struct io_wq *wq = worker->wq;
 	bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 
 	do {
@@ -557,7 +543,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		work = io_get_next_work(acct, worker);
 		raw_spin_unlock(&acct->lock);
 		if (work) {
-			__io_worker_busy(wqe, worker);
+			__io_worker_busy(wq, worker);
 
 			/*
 			 * Make sure cancelation can find this, even before
@@ -595,7 +581,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 			}
 			io_assign_current_work(worker, work);
 			if (linked)
-				io_wqe_enqueue(wqe, linked);
+				io_wq_enqueue(wq, linked);
 
 			if (hash != -1U && !next_hashed) {
 				/* serialize hash clear with wake_up() */
@@ -610,12 +596,11 @@ static void io_worker_handle_work(struct io_worker *worker)
 	} while (1);
 }
 
-static int io_wqe_worker(void *data)
+static int io_wq_worker(void *data)
 {
 	struct io_worker *worker = data;
 	struct io_wq_acct *acct = io_wq_get_acct(worker);
-	struct io_wqe *wqe = worker->wqe;
-	struct io_wq *wq = wqe->wq;
+	struct io_wq *wq = worker->wq;
 	bool exit_mask = false, last_timeout = false;
 	char buf[TASK_COMM_LEN];
 
@@ -631,20 +616,20 @@ static int io_wqe_worker(void *data)
 		while (io_acct_run_queue(acct))
 			io_worker_handle_work(worker);
 
-		raw_spin_lock(&wqe->lock);
+		raw_spin_lock(&wq->lock);
 		/*
 		 * Last sleep timed out. Exit if we're not the last worker,
 		 * or if someone modified our affinity.
 		 */
 		if (last_timeout && (exit_mask || acct->nr_workers > 1)) {
 			acct->nr_workers--;
-			raw_spin_unlock(&wqe->lock);
+			raw_spin_unlock(&wq->lock);
 			__set_current_state(TASK_RUNNING);
 			break;
 		}
 		last_timeout = false;
-		__io_worker_idle(wqe, worker);
-		raw_spin_unlock(&wqe->lock);
+		__io_worker_idle(wq, worker);
+		raw_spin_unlock(&wq->lock);
 		if (io_run_task_work())
 			continue;
 		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
@@ -658,7 +643,7 @@ static int io_wqe_worker(void *data)
 		if (!ret) {
 			last_timeout = true;
 			exit_mask = !cpumask_test_cpu(raw_smp_processor_id(),
-							wqe->cpu_mask);
+							wq->cpu_mask);
 		}
 	}
 
@@ -683,7 +668,7 @@ void io_wq_worker_running(struct task_struct *tsk)
 	if (worker->flags & IO_WORKER_F_RUNNING)
 		return;
 	worker->flags |= IO_WORKER_F_RUNNING;
-	io_wqe_inc_running(worker);
+	io_wq_inc_running(worker);
 }
 
 /*
@@ -702,21 +687,21 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 		return;
 
 	worker->flags &= ~IO_WORKER_F_RUNNING;
-	io_wqe_dec_running(worker);
+	io_wq_dec_running(worker);
 }
 
-static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
+static void io_init_new_worker(struct io_wq *wq, struct io_worker *worker,
 			       struct task_struct *tsk)
 {
 	tsk->worker_private = worker;
 	worker->task = tsk;
-	set_cpus_allowed_ptr(tsk, wqe->cpu_mask);
+	set_cpus_allowed_ptr(tsk, wq->cpu_mask);
 
-	raw_spin_lock(&wqe->lock);
-	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
-	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
+	raw_spin_lock(&wq->lock);
+	hlist_nulls_add_head_rcu(&worker->nulls_node, &wq->free_list);
+	list_add_tail_rcu(&worker->all_list, &wq->all_list);
 	worker->flags |= IO_WORKER_F_FREE;
-	raw_spin_unlock(&wqe->lock);
+	raw_spin_unlock(&wq->lock);
 	wake_up_new_task(tsk);
 }
 
@@ -749,21 +734,21 @@ static void create_worker_cont(struct callback_head *cb)
 {
 	struct io_worker *worker;
 	struct task_struct *tsk;
-	struct io_wqe *wqe;
+	struct io_wq *wq;
 
 	worker = container_of(cb, struct io_worker, create_work);
 	clear_bit_unlock(0, &worker->create_state);
-	wqe = worker->wqe;
-	tsk = create_io_thread(io_wqe_worker, worker, NUMA_NO_NODE);
+	wq = worker->wq;
+	tsk = create_io_thread(io_wq_worker, worker, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
-		io_init_new_worker(wqe, worker, tsk);
+		io_init_new_worker(wq, worker, tsk);
 		io_worker_release(worker);
 		return;
 	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
 		struct io_wq_acct *acct = io_wq_get_acct(worker);
 
 		atomic_dec(&acct->nr_running);
-		raw_spin_lock(&wqe->lock);
+		raw_spin_lock(&wq->lock);
 		acct->nr_workers--;
 		if (!acct->nr_workers) {
 			struct io_cb_cancel_data match = {
@@ -771,13 +756,13 @@ static void create_worker_cont(struct callback_head *cb)
 				.cancel_all	= true,
 			};
 
-			raw_spin_unlock(&wqe->lock);
-			while (io_acct_cancel_pending_work(wqe, acct, &match))
+			raw_spin_unlock(&wq->lock);
+			while (io_acct_cancel_pending_work(wq, acct, &match))
 				;
 		} else {
-			raw_spin_unlock(&wqe->lock);
+			raw_spin_unlock(&wq->lock);
 		}
-		io_worker_ref_put(wqe->wq);
+		io_worker_ref_put(wq);
 		kfree(worker);
 		return;
 	}
@@ -796,7 +781,7 @@ static void io_workqueue_create(struct work_struct *work)
 		kfree(worker);
 }
 
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
+static bool create_io_worker(struct io_wq *wq, int index)
 {
 	struct io_wq_acct *acct = &wq->acct[index];
 	struct io_worker *worker;
@@ -808,24 +793,24 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	if (!worker) {
 fail:
 		atomic_dec(&acct->nr_running);
-		raw_spin_lock(&wqe->lock);
+		raw_spin_lock(&wq->lock);
 		acct->nr_workers--;
-		raw_spin_unlock(&wqe->lock);
+		raw_spin_unlock(&wq->lock);
 		io_worker_ref_put(wq);
 		return false;
 	}
 
 	refcount_set(&worker->ref, 1);
-	worker->wqe = wqe;
+	worker->wq = wq;
 	raw_spin_lock_init(&worker->lock);
 	init_completion(&worker->ref_done);
 
 	if (index == IO_WQ_ACCT_BOUND)
 		worker->flags |= IO_WORKER_F_BOUND;
 
-	tsk = create_io_thread(io_wqe_worker, worker, NUMA_NO_NODE);
+	tsk = create_io_thread(io_wq_worker, worker, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
-		io_init_new_worker(wqe, worker, tsk);
+		io_init_new_worker(wq, worker, tsk);
 	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
 		kfree(worker);
 		goto fail;
@@ -841,14 +826,14 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
  * Iterate the passed in list and call the specific function for each
  * worker that isn't exiting
  */
-static bool io_wq_for_each_worker(struct io_wqe *wqe,
+static bool io_wq_for_each_worker(struct io_wq *wq,
 				  bool (*func)(struct io_worker *, void *),
 				  void *data)
 {
 	struct io_worker *worker;
 	bool ret = false;
 
-	list_for_each_entry_rcu(worker, &wqe->all_list, all_list) {
+	list_for_each_entry_rcu(worker, &wq->all_list, all_list) {
 		if (io_worker_get(worker)) {
 			/* no task if node is/was offline */
 			if (worker->task)
@@ -869,10 +854,8 @@ static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 	return false;
 }
 
-static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
+static void io_run_cancel(struct io_wq_work *work, struct io_wq *wq)
 {
-	struct io_wq *wq = wqe->wq;
-
 	do {
 		work->flags |= IO_WQ_WORK_CANCEL;
 		wq->do_work(work);
@@ -880,9 +863,9 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 	} while (work);
 }
 
-static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
+static void io_wq_insert_work(struct io_wq *wq, struct io_wq_work *work)
 {
-	struct io_wq_acct *acct = io_work_get_acct(wqe->wq, work);
+	struct io_wq_acct *acct = io_work_get_acct(wq, work);
 	unsigned int hash;
 	struct io_wq_work *tail;
 
@@ -893,8 +876,8 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 	}
 
 	hash = io_get_work_hash(work);
-	tail = wqe->hash_tail[hash];
-	wqe->hash_tail[hash] = work;
+	tail = wq->hash_tail[hash];
+	wq->hash_tail[hash] = work;
 	if (!tail)
 		goto append;
 
@@ -906,9 +889,9 @@ static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
 	return work == data;
 }
 
-static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
+void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 {
-	struct io_wq_acct *acct = io_work_get_acct(wqe->wq, work);
+	struct io_wq_acct *acct = io_work_get_acct(wq, work);
 	struct io_cb_cancel_data match;
 	unsigned work_flags = work->flags;
 	bool do_create;
@@ -917,55 +900,48 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	 * If io-wq is exiting for this task, or if the request has explicitly
 	 * been marked as one that should not get executed, cancel it here.
 	 */
-	if (test_bit(IO_WQ_BIT_EXIT, &wqe->wq->state) ||
+	if (test_bit(IO_WQ_BIT_EXIT, &wq->state) ||
 	    (work->flags & IO_WQ_WORK_CANCEL)) {
-		io_run_cancel(work, wqe);
+		io_run_cancel(work, wq);
 		return;
 	}
 
 	raw_spin_lock(&acct->lock);
-	io_wqe_insert_work(wqe, work);
+	io_wq_insert_work(wq, work);
 	clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 	raw_spin_unlock(&acct->lock);
 
-	raw_spin_lock(&wqe->lock);
+	raw_spin_lock(&wq->lock);
 	rcu_read_lock();
-	do_create = !io_wqe_activate_free_worker(wqe, acct);
+	do_create = !io_wq_activate_free_worker(wq, acct);
 	rcu_read_unlock();
 
-	raw_spin_unlock(&wqe->lock);
+	raw_spin_unlock(&wq->lock);
 
 	if (do_create && ((work_flags & IO_WQ_WORK_CONCURRENT) ||
 	    !atomic_read(&acct->nr_running))) {
 		bool did_create;
 
-		did_create = io_wqe_create_worker(wqe, acct);
+		did_create = io_wq_create_worker(wq, acct);
 		if (likely(did_create))
 			return;
 
-		raw_spin_lock(&wqe->lock);
+		raw_spin_lock(&wq->lock);
 		if (acct->nr_workers) {
-			raw_spin_unlock(&wqe->lock);
+			raw_spin_unlock(&wq->lock);
 			return;
 		}
-		raw_spin_unlock(&wqe->lock);
+		raw_spin_unlock(&wq->lock);
 
 		/* fatal condition, failed to create the first worker */
 		match.fn		= io_wq_work_match_item,
 		match.data		= work,
 		match.cancel_all	= false,
 
-		io_acct_cancel_pending_work(wqe, acct, &match);
+		io_acct_cancel_pending_work(wq, acct, &match);
 	}
 }
 
-void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
-{
-	struct io_wqe *wqe = &wq->wqe;
-
-	io_wqe_enqueue(wqe, work);
-}
-
 /*
  * Work items that hash to the same value will not be done in parallel.
  * Used to limit concurrent writes, generally hashed by inode.
@@ -1008,26 +984,26 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 	return match->nr_running && !match->cancel_all;
 }
 
-static inline void io_wqe_remove_pending(struct io_wqe *wqe,
+static inline void io_wq_remove_pending(struct io_wq *wq,
 					 struct io_wq_work *work,
 					 struct io_wq_work_node *prev)
 {
-	struct io_wq_acct *acct = io_work_get_acct(wqe->wq, work);
+	struct io_wq_acct *acct = io_work_get_acct(wq, work);
 	unsigned int hash = io_get_work_hash(work);
 	struct io_wq_work *prev_work = NULL;
 
-	if (io_wq_is_hashed(work) && work == wqe->hash_tail[hash]) {
+	if (io_wq_is_hashed(work) && work == wq->hash_tail[hash]) {
 		if (prev)
 			prev_work = container_of(prev, struct io_wq_work, list);
 		if (prev_work && io_get_work_hash(prev_work) == hash)
-			wqe->hash_tail[hash] = prev_work;
+			wq->hash_tail[hash] = prev_work;
 		else
-			wqe->hash_tail[hash] = NULL;
+			wq->hash_tail[hash] = NULL;
 	}
 	wq_list_del(&acct->work_list, &work->list, prev);
 }
 
-static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
+static bool io_acct_cancel_pending_work(struct io_wq *wq,
 					struct io_wq_acct *acct,
 					struct io_cb_cancel_data *match)
 {
@@ -1039,9 +1015,9 @@ static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 		work = container_of(node, struct io_wq_work, list);
 		if (!match->fn(work, match->data))
 			continue;
-		io_wqe_remove_pending(wqe, work, prev);
+		io_wq_remove_pending(wq, work, prev);
 		raw_spin_unlock(&acct->lock);
-		io_run_cancel(work, wqe);
+		io_run_cancel(work, wq);
 		match->nr_pending++;
 		/* not safe to continue after unlock */
 		return true;
@@ -1051,15 +1027,15 @@ static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 	return false;
 }
 
-static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
+static void io_wq_cancel_pending_work(struct io_wq *wq,
 				      struct io_cb_cancel_data *match)
 {
 	int i;
 retry:
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-		struct io_wq_acct *acct = io_get_acct(wqe->wq, i == 0);
+		struct io_wq_acct *acct = io_get_acct(wq, i == 0);
 
-		if (io_acct_cancel_pending_work(wqe, acct, match)) {
+		if (io_acct_cancel_pending_work(wq, acct, match)) {
 			if (match->cancel_all)
 				goto retry;
 			break;
@@ -1067,11 +1043,11 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 	}
 }
 
-static void io_wqe_cancel_running_work(struct io_wqe *wqe,
+static void io_wq_cancel_running_work(struct io_wq *wq,
 				       struct io_cb_cancel_data *match)
 {
 	rcu_read_lock();
-	io_wq_for_each_worker(wqe, io_wq_worker_cancel, match);
+	io_wq_for_each_worker(wq, io_wq_worker_cancel, match);
 	rcu_read_unlock();
 }
 
@@ -1083,7 +1059,6 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 		.data		= data,
 		.cancel_all	= cancel_all,
 	};
-	struct io_wqe *wqe = &wq->wqe;
 
 	/*
 	 * First check pending list, if we're lucky we can just remove it
@@ -1095,16 +1070,16 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	 * as an indication that we attempt to signal cancellation. The
 	 * completion will run normally in this case.
 	 *
-	 * Do both of these while holding the wqe->lock, to ensure that
+	 * Do both of these while holding the wq->lock, to ensure that
 	 * we'll find a work item regardless of state.
 	 */
-	io_wqe_cancel_pending_work(wqe, &match);
+	io_wq_cancel_pending_work(wq, &match);
 	if (match.nr_pending && !match.cancel_all)
 		return IO_WQ_CANCEL_OK;
 
-	raw_spin_lock(&wqe->lock);
-	io_wqe_cancel_running_work(wqe, &match);
-	raw_spin_unlock(&wqe->lock);
+	raw_spin_lock(&wq->lock);
+	io_wq_cancel_running_work(wq, &match);
+	raw_spin_unlock(&wq->lock);
 	if (match.nr_running && !match.cancel_all)
 		return IO_WQ_CANCEL_RUNNING;
 
@@ -1115,11 +1090,10 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	return IO_WQ_CANCEL_NOTFOUND;
 }
 
-static int io_wqe_hash_wake(struct wait_queue_entry *wait, unsigned mode,
+static int io_wq_hash_wake(struct wait_queue_entry *wait, unsigned mode,
 			    int sync, void *key)
 {
-	struct io_wqe *wqe = container_of(wait, struct io_wqe, wait);
-	struct io_wq *wq = wqe->wq;
+	struct io_wq *wq = container_of(wait, struct io_wq, wait);
 	int i;
 
 	list_del_init(&wait->entry);
@@ -1129,7 +1103,7 @@ static int io_wqe_hash_wake(struct wait_queue_entry *wait, unsigned mode,
 		struct io_wq_acct *acct = &wq->acct[i];
 
 		if (test_and_clear_bit(IO_ACCT_STALLED_BIT, &acct->flags))
-			io_wqe_activate_free_worker(wqe, acct);
+			io_wq_activate_free_worker(wq, acct);
 	}
 	rcu_read_unlock();
 	return 1;
@@ -1139,7 +1113,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 {
 	int ret, i;
 	struct io_wq *wq;
-	struct io_wqe *wqe;
 
 	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
 		return ERR_PTR(-EINVAL);
@@ -1157,18 +1130,17 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	wq->hash = data->hash;
 	wq->free_work = data->free_work;
 	wq->do_work = data->do_work;
-	wqe = &wq->wqe;
 
 	ret = -ENOMEM;
 
-	if (!alloc_cpumask_var(&wqe->cpu_mask, GFP_KERNEL))
+	if (!alloc_cpumask_var(&wq->cpu_mask, GFP_KERNEL))
 		goto err;
-	cpumask_copy(wqe->cpu_mask, cpu_possible_mask);
+	cpumask_copy(wq->cpu_mask, cpu_possible_mask);
 	wq->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 	wq->acct[IO_WQ_ACCT_UNBOUND].max_workers =
 				task_rlimit(current, RLIMIT_NPROC);
-	INIT_LIST_HEAD(&wqe->wait.entry);
-	wqe->wait.func = io_wqe_hash_wake;
+	INIT_LIST_HEAD(&wq->wait.entry);
+	wq->wait.func = io_wq_hash_wake;
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		struct io_wq_acct *acct = &wq->acct[i];
 
@@ -1177,10 +1149,10 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		INIT_WQ_LIST(&acct->work_list);
 		raw_spin_lock_init(&acct->lock);
 	}
-	wqe->wq = wq;
-	raw_spin_lock_init(&wqe->lock);
-	INIT_HLIST_NULLS_HEAD(&wqe->free_list, 0);
-	INIT_LIST_HEAD(&wqe->all_list);
+
+	raw_spin_lock_init(&wq->lock);
+	INIT_HLIST_NULLS_HEAD(&wq->free_list, 0);
+	INIT_LIST_HEAD(&wq->all_list);
 
 	wq->task = get_task_struct(data->task);
 	atomic_set(&wq->worker_refs, 1);
@@ -1190,7 +1162,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	io_wq_put_hash(data->hash);
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 
-	free_cpumask_var(wq->wqe.cpu_mask);
+	free_cpumask_var(wq->cpu_mask);
 err_wq:
 	kfree(wq);
 	return ERR_PTR(ret);
@@ -1203,7 +1175,7 @@ static bool io_task_work_match(struct callback_head *cb, void *data)
 	if (cb->func != create_worker_cb && cb->func != create_worker_cont)
 		return false;
 	worker = container_of(cb, struct io_worker, create_work);
-	return worker->wqe->wq == data;
+	return worker->wq == data;
 }
 
 void io_wq_exit_start(struct io_wq *wq)
@@ -1237,13 +1209,13 @@ static void io_wq_exit_workers(struct io_wq *wq)
 	io_wq_cancel_tw_create(wq);
 
 	rcu_read_lock();
-	io_wq_for_each_worker(&wq->wqe, io_wq_worker_wake, NULL);
+	io_wq_for_each_worker(wq, io_wq_worker_wake, NULL);
 	rcu_read_unlock();
 	io_worker_ref_put(wq);
 	wait_for_completion(&wq->worker_done);
 
 	spin_lock_irq(&wq->hash->wait.lock);
-	list_del_init(&wq->wqe.wait.entry);
+	list_del_init(&wq->wait.entry);
 	spin_unlock_irq(&wq->hash->wait.lock);
 
 	put_task_struct(wq->task);
@@ -1256,11 +1228,10 @@ static void io_wq_destroy(struct io_wq *wq)
 		.fn		= io_wq_work_match_all,
 		.cancel_all	= true,
 	};
-	struct io_wqe *wqe = &wq->wqe;
 
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-	io_wqe_cancel_pending_work(wqe, &match);
-	free_cpumask_var(wqe->cpu_mask);
+	io_wq_cancel_pending_work(wq, &match);
+	free_cpumask_var(wq->cpu_mask);
 	io_wq_put_hash(wq->hash);
 	kfree(wq);
 }
@@ -1283,9 +1254,9 @@ static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
 	struct online_data *od = data;
 
 	if (od->online)
-		cpumask_set_cpu(od->cpu, worker->wqe->cpu_mask);
+		cpumask_set_cpu(od->cpu, worker->wq->cpu_mask);
 	else
-		cpumask_clear_cpu(od->cpu, worker->wqe->cpu_mask);
+		cpumask_clear_cpu(od->cpu, worker->wq->cpu_mask);
 	return false;
 }
 
@@ -1297,7 +1268,7 @@ static int __io_wq_cpu_online(struct io_wq *wq, unsigned int cpu, bool online)
 	};
 
 	rcu_read_lock();
-	io_wq_for_each_worker(&wq->wqe, io_wq_worker_affinity, &od);
+	io_wq_for_each_worker(wq, io_wq_worker_affinity, &od);
 	rcu_read_unlock();
 	return 0;
 }
@@ -1318,13 +1289,11 @@ static int io_wq_cpu_offline(unsigned int cpu, struct hlist_node *node)
 
 int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask)
 {
-	struct io_wqe *wqe = &wq->wqe;
-
 	rcu_read_lock();
 	if (mask)
-		cpumask_copy(wqe->cpu_mask, mask);
+		cpumask_copy(wq->cpu_mask, mask);
 	else
-		cpumask_copy(wqe->cpu_mask, cpu_possible_mask);
+		cpumask_copy(wq->cpu_mask, cpu_possible_mask);
 	rcu_read_unlock();
 
 	return 0;
@@ -1336,7 +1305,6 @@ int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask)
  */
 int io_wq_max_workers(struct io_wq *wq, int *new_count)
 {
-	struct io_wqe *wqe = &wq->wqe;
 	struct io_wq_acct *acct;
 	int prev[IO_WQ_ACCT_NR];
 	int i;
@@ -1355,14 +1323,14 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
 
 	rcu_read_lock();
 
-	raw_spin_lock(&wqe->lock);
+	raw_spin_lock(&wq->lock);
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		acct = &wq->acct[i];
 		prev[i] = max_t(int, acct->max_workers, prev[i]);
 		if (new_count[i])
 			acct->max_workers = new_count[i];
 	}
-	raw_spin_unlock(&wqe->lock);
+	raw_spin_unlock(&wq->lock);
 	rcu_read_unlock();
 
 	for (i = 0; i < IO_WQ_ACCT_NR; i++)
-- 
2.35.3

