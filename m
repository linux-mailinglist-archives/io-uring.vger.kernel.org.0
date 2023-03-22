Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53846C3FA6
	for <lists+io-uring@lfdr.de>; Wed, 22 Mar 2023 02:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjCVBRq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Mar 2023 21:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjCVBRp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Mar 2023 21:17:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEDF580EF
        for <io-uring@vger.kernel.org>; Tue, 21 Mar 2023 18:17:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D73F820761;
        Wed, 22 Mar 2023 01:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679447797; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f78x1Gjkv6LxjJ0Cn8TfPVeCOrzW3ehHE38mMAb7ieU=;
        b=tphYB6oT+5NM+W4+aN6mng1CG18iyRj16arGnQNd6/gLiDLzR9p7NyA+XJPqvAtyNsM2Q/
        at8vL9KozP3azCBnXvHz7ERlA+JjGcuDD578rh7ajD76qf4oZlOm/GVAYsu2bDXmnvxU+A
        SO8RsVZgyG2P9sKgYJFRsFQScbh3NGQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679447797;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f78x1Gjkv6LxjJ0Cn8TfPVeCOrzW3ehHE38mMAb7ieU=;
        b=biNM35LAvYkT9WxX74AGUIONTlHKUjnUcHPPX2YkFXs5+r6P1H8KIIGqZXaZrYGs8sx99k
        aWtK88Xc56spc9BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 61C6F13451;
        Wed, 22 Mar 2023 01:16:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nEq3CvVWGmRAfQAAMHmgww
        (envelope-from <krisman@suse.de>); Wed, 22 Mar 2023 01:16:37 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 1/2] io-wq: Move wq accounting to io_wq
Date:   Tue, 21 Mar 2023 22:16:27 -0300
Message-Id: <20230322011628.23359-2-krisman@suse.de>
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

Since we now have a single io_wqe per io_wq instead of per-node, and in
preparation to its removal, move the accounting into the parent
structure.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io-wq.c | 78 +++++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 38 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 44d522c5d36f..da7c6e00b690 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -74,7 +74,7 @@ struct io_worker {
 
 #define IO_WQ_NR_HASH_BUCKETS	(1u << IO_WQ_HASH_ORDER)
 
-struct io_wqe_acct {
+struct io_wq_acct {
 	unsigned nr_workers;
 	unsigned max_workers;
 	int index;
@@ -95,7 +95,6 @@ enum {
  */
 struct io_wqe {
 	raw_spinlock_t lock;
-	struct io_wqe_acct acct[IO_WQ_ACCT_NR];
 
 	struct hlist_nulls_head free_list;
 	struct list_head all_list;
@@ -126,6 +125,8 @@ struct io_wq {
 
 	struct task_struct *task;
 
+	struct io_wq_acct acct[IO_WQ_ACCT_NR];
+
 	struct io_wqe wqe;
 };
 
@@ -142,7 +143,7 @@ struct io_cb_cancel_data {
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
 static void io_wqe_dec_running(struct io_worker *worker);
 static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
-					struct io_wqe_acct *acct,
+					struct io_wq_acct *acct,
 					struct io_cb_cancel_data *match);
 static void create_worker_cb(struct callback_head *cb);
 static void io_wq_cancel_tw_create(struct io_wq *wq);
@@ -158,20 +159,20 @@ static void io_worker_release(struct io_worker *worker)
 		complete(&worker->ref_done);
 }
 
-static inline struct io_wqe_acct *io_get_acct(struct io_wqe *wqe, bool bound)
+static inline struct io_wq_acct *io_get_acct(struct io_wq *wq, bool bound)
 {
-	return &wqe->acct[bound ? IO_WQ_ACCT_BOUND : IO_WQ_ACCT_UNBOUND];
+	return &wq->acct[bound ? IO_WQ_ACCT_BOUND : IO_WQ_ACCT_UNBOUND];
 }
 
-static inline struct io_wqe_acct *io_work_get_acct(struct io_wqe *wqe,
-						   struct io_wq_work *work)
+static inline struct io_wq_acct *io_work_get_acct(struct io_wq *wq,
+						  struct io_wq_work *work)
 {
-	return io_get_acct(wqe, !(work->flags & IO_WQ_WORK_UNBOUND));
+	return io_get_acct(wq, !(work->flags & IO_WQ_WORK_UNBOUND));
 }
 
-static inline struct io_wqe_acct *io_wqe_get_acct(struct io_worker *worker)
+static inline struct io_wq_acct *io_wq_get_acct(struct io_worker *worker)
 {
-	return io_get_acct(worker->wqe, worker->flags & IO_WORKER_F_BOUND);
+	return io_get_acct(worker->wqe->wq, worker->flags & IO_WORKER_F_BOUND);
 }
 
 static void io_worker_ref_put(struct io_wq *wq)
@@ -182,7 +183,7 @@ static void io_worker_ref_put(struct io_wq *wq)
 
 static void io_worker_cancel_cb(struct io_worker *worker)
 {
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wq_acct *acct = io_wq_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 
@@ -238,7 +239,7 @@ static void io_worker_exit(struct io_worker *worker)
 	do_exit(0);
 }
 
-static inline bool io_acct_run_queue(struct io_wqe_acct *acct)
+static inline bool io_acct_run_queue(struct io_wq_acct *acct)
 {
 	bool ret = false;
 
@@ -256,7 +257,7 @@ static inline bool io_acct_run_queue(struct io_wqe_acct *acct)
  * caller must create one.
  */
 static bool io_wqe_activate_free_worker(struct io_wqe *wqe,
-					struct io_wqe_acct *acct)
+					struct io_wq_acct *acct)
 	__must_hold(RCU)
 {
 	struct hlist_nulls_node *n;
@@ -270,7 +271,7 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe,
 	hlist_nulls_for_each_entry_rcu(worker, n, &wqe->free_list, nulls_node) {
 		if (!io_worker_get(worker))
 			continue;
-		if (io_wqe_get_acct(worker) != acct) {
+		if (io_wq_get_acct(worker) != acct) {
 			io_worker_release(worker);
 			continue;
 		}
@@ -288,7 +289,7 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe,
  * We need a worker. If we find a free one, we're good. If not, and we're
  * below the max number of workers, create one.
  */
-static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
+static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wq_acct *acct)
 {
 	/*
 	 * Most likely an attempt to queue unbounded work on an io_wq that
@@ -311,7 +312,7 @@ static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 
 static void io_wqe_inc_running(struct io_worker *worker)
 {
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wq_acct *acct = io_wq_get_acct(worker);
 
 	atomic_inc(&acct->nr_running);
 }
@@ -321,13 +322,13 @@ static void create_worker_cb(struct callback_head *cb)
 	struct io_worker *worker;
 	struct io_wq *wq;
 	struct io_wqe *wqe;
-	struct io_wqe_acct *acct;
+	struct io_wq_acct *acct;
 	bool do_create = false;
 
 	worker = container_of(cb, struct io_worker, create_work);
 	wqe = worker->wqe;
 	wq = wqe->wq;
-	acct = &wqe->acct[worker->create_index];
+	acct = &wq->acct[worker->create_index];
 	raw_spin_lock(&wqe->lock);
 	if (acct->nr_workers < acct->max_workers) {
 		acct->nr_workers++;
@@ -345,7 +346,7 @@ static void create_worker_cb(struct callback_head *cb)
 }
 
 static bool io_queue_worker_create(struct io_worker *worker,
-				   struct io_wqe_acct *acct,
+				   struct io_wq_acct *acct,
 				   task_work_func_t func)
 {
 	struct io_wqe *wqe = worker->wqe;
@@ -393,7 +394,7 @@ static bool io_queue_worker_create(struct io_worker *worker,
 
 static void io_wqe_dec_running(struct io_worker *worker)
 {
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wq_acct *acct = io_wq_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 
 	if (!(worker->flags & IO_WORKER_F_UP))
@@ -462,7 +463,7 @@ static bool io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 	return ret;
 }
 
-static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
+static struct io_wq_work *io_get_next_work(struct io_wq_acct *acct,
 					   struct io_worker *worker)
 	__must_hold(acct->lock)
 {
@@ -537,7 +538,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 
 static void io_worker_handle_work(struct io_worker *worker)
 {
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wq_acct *acct = io_wq_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 	bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
@@ -612,7 +613,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 static int io_wqe_worker(void *data)
 {
 	struct io_worker *worker = data;
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wq_acct *acct = io_wq_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 	bool exit_mask = false, last_timeout = false;
@@ -759,7 +760,7 @@ static void create_worker_cont(struct callback_head *cb)
 		io_worker_release(worker);
 		return;
 	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
-		struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+		struct io_wq_acct *acct = io_wq_get_acct(worker);
 
 		atomic_dec(&acct->nr_running);
 		raw_spin_lock(&wqe->lock);
@@ -789,7 +790,7 @@ static void create_worker_cont(struct callback_head *cb)
 static void io_workqueue_create(struct work_struct *work)
 {
 	struct io_worker *worker = container_of(work, struct io_worker, work);
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wq_acct *acct = io_wq_get_acct(worker);
 
 	if (!io_queue_worker_create(worker, acct, create_worker_cont))
 		kfree(worker);
@@ -797,7 +798,7 @@ static void io_workqueue_create(struct work_struct *work)
 
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 {
-	struct io_wqe_acct *acct = &wqe->acct[index];
+	struct io_wq_acct *acct = &wq->acct[index];
 	struct io_worker *worker;
 	struct task_struct *tsk;
 
@@ -881,7 +882,7 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 
 static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 {
-	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
+	struct io_wq_acct *acct = io_work_get_acct(wqe->wq, work);
 	unsigned int hash;
 	struct io_wq_work *tail;
 
@@ -907,7 +908,7 @@ static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
 
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
-	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
+	struct io_wq_acct *acct = io_work_get_acct(wqe->wq, work);
 	struct io_cb_cancel_data match;
 	unsigned work_flags = work->flags;
 	bool do_create;
@@ -1011,7 +1012,7 @@ static inline void io_wqe_remove_pending(struct io_wqe *wqe,
 					 struct io_wq_work *work,
 					 struct io_wq_work_node *prev)
 {
-	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
+	struct io_wq_acct *acct = io_work_get_acct(wqe->wq, work);
 	unsigned int hash = io_get_work_hash(work);
 	struct io_wq_work *prev_work = NULL;
 
@@ -1027,7 +1028,7 @@ static inline void io_wqe_remove_pending(struct io_wqe *wqe,
 }
 
 static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
-					struct io_wqe_acct *acct,
+					struct io_wq_acct *acct,
 					struct io_cb_cancel_data *match)
 {
 	struct io_wq_work_node *node, *prev;
@@ -1051,12 +1052,12 @@ static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 }
 
 static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
-				       struct io_cb_cancel_data *match)
+				      struct io_cb_cancel_data *match)
 {
 	int i;
 retry:
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
+		struct io_wq_acct *acct = io_get_acct(wqe->wq, i == 0);
 
 		if (io_acct_cancel_pending_work(wqe, acct, match)) {
 			if (match->cancel_all)
@@ -1118,13 +1119,14 @@ static int io_wqe_hash_wake(struct wait_queue_entry *wait, unsigned mode,
 			    int sync, void *key)
 {
 	struct io_wqe *wqe = container_of(wait, struct io_wqe, wait);
+	struct io_wq *wq = wqe->wq;
 	int i;
 
 	list_del_init(&wait->entry);
 
 	rcu_read_lock();
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-		struct io_wqe_acct *acct = &wqe->acct[i];
+		struct io_wq_acct *acct = &wq->acct[i];
 
 		if (test_and_clear_bit(IO_ACCT_STALLED_BIT, &acct->flags))
 			io_wqe_activate_free_worker(wqe, acct);
@@ -1162,13 +1164,13 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	if (!alloc_cpumask_var(&wqe->cpu_mask, GFP_KERNEL))
 		goto err;
 	cpumask_copy(wqe->cpu_mask, cpu_possible_mask);
-	wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
-	wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
+	wq->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
+	wq->acct[IO_WQ_ACCT_UNBOUND].max_workers =
 				task_rlimit(current, RLIMIT_NPROC);
 	INIT_LIST_HEAD(&wqe->wait.entry);
 	wqe->wait.func = io_wqe_hash_wake;
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-		struct io_wqe_acct *acct = &wqe->acct[i];
+		struct io_wq_acct *acct = &wq->acct[i];
 
 		acct->index = i;
 		atomic_set(&acct->nr_running, 0);
@@ -1335,7 +1337,7 @@ int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask)
 int io_wq_max_workers(struct io_wq *wq, int *new_count)
 {
 	struct io_wqe *wqe = &wq->wqe;
-	struct io_wqe_acct *acct;
+	struct io_wq_acct *acct;
 	int prev[IO_WQ_ACCT_NR];
 	int i;
 
@@ -1355,7 +1357,7 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
 
 	raw_spin_lock(&wqe->lock);
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-		acct = &wqe->acct[i];
+		acct = &wq->acct[i];
 		prev[i] = max_t(int, acct->max_workers, prev[i]);
 		if (new_count[i])
 			acct->max_workers = new_count[i];
-- 
2.35.3

