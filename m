Return-Path: <io-uring+bounces-6154-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DCAD5A20B65
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 14:40:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37A91165C4D
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 13:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D901ACECC;
	Tue, 28 Jan 2025 13:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="gpyXwnBB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com [209.85.221.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510CF1A83E8
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 13:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738071583; cv=none; b=QPLPccQxHh2cK4IVj2Ei4MGenC3xAQ8eYJ1ZZqlspaByHTSQnmjfgAxyMQfqZIarbjBjeFvFg21loKmdUDixPAx7nJJYbfaYrb7Jz5mQdrTmGw00aChL/Od8Qiam2PWMlmm6kuG+LzH0jq0UKgPaxkGMDA9wFzZjOLuTUHoYypE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738071583; c=relaxed/simple;
	bh=b9q0H6JlHPZhx/QToXEjyQgV/SZEBw6Z/m//xQGJlOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BB5jAKCUCqlJd1bVj5kc1NJuLEEarteMSZtYs1UOr519tXV0BpZKu6KgLKxhznLy9hniqbfXOf/WWN1TGApXpiFF1XcjogZ5iM4OPHdFahVDYrwBLPU8ZfyxOgLoJPhXcHA2Y30L6Dq3vCtoN6XgNtjnh5Ui85HdZf9xp4aoV/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=gpyXwnBB; arc=none smtp.client-ip=209.85.221.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wr1-f68.google.com with SMTP id ffacd0b85a97d-38a8b17d7a7so3036375f8f.2
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 05:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738071579; x=1738676379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=juRRYQ1dTFnhLtP+KRntaqf9hUoGq/7yGgLWvGvQH84=;
        b=gpyXwnBB6oq+IaNdNwzqbfUbclMGt1xFE0ySyT/KIk6aiv4R+rkrduCRJbYxF3EDrl
         uEZo3u/H85rtibk9fr7aQwWCWOKKGXpOx8keTUVsPENpa5kwkA5pQkwJttn25yWNW+a0
         f0XKnQKhJvcSW8hrPe9qbHctz9E5hyb3y4+DvOaRpCi2mMusKxAvgtzvXhwSXLxAsFw0
         /jxzlBz0zydUmT7dx7XKuEh2JWphhts7FV8tETk+MJEut6Nh/p5+YDrr83VOTk3IIR7f
         cvGDrcSE8eHXzT+lwnPl2gk9elHf320Yk4QfNgoEDcOqGJjAZKmR4/MIKXicIsa43EPF
         +7Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738071579; x=1738676379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=juRRYQ1dTFnhLtP+KRntaqf9hUoGq/7yGgLWvGvQH84=;
        b=mNtaQJaOV5R956N+g/+9I8nzsv9slY/xcfcq483929WQx1oOHealRpMrOZ3sdwaMqw
         IiCEO02fRdTCcMC/4T2ip+Yj7abCiaJnk1x8X6ve0kk7OP5mr13YVcPMeEJ77NfVSTGx
         L2IYjoiIZFRRroCeBLCamm/noE2yRbuei5kCs0PCzcZUGbK4AU0C62+QZO0FiOBm8BAo
         ymjYvD1QmHZN3PEBcOUwZ2JxhSww4B+Rpcj0yBqJje5gkwgiCVo6i1ScKW3qvlm4L2P6
         mJ7fbpnq4cDZp50ncxnCl03MmtRRrSvJu6P26CvdPP547xZd9a1WBTxYBe83rDHuhiSz
         3ctQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3sDv3RLDzEcY8cOZoCd/wki8juqPKfBDCDlu3tuIhAPGwy6evkfW0C7toMySPV+hlGPZfCBzUaw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzSF6XCtQtpEl97pyG4+ikoWp114XPUaZuSnxnhpdpoKztulXEt
	7YZHDyy+IFpOxyNUorvq1BaCt8pHMp+R7HsO9ntArhPx5y6IvHH38Qy6NApvpHI=
X-Gm-Gg: ASbGnctGfl58jrkTjLy/+Z7QOSjJsRY5pED05scUSyQYa6rg9JpKlXFoLZDPzxfe4Rn
	QxHGtioMdjHR9/YapBxl/r3/1G+NTl/ZdovU766Z7AyOFvtLYp0U4R0EKYIP9SHjqFEXlDH1eAZ
	O0GKCJXn+Ci/Z8HInZrpIpCwzwMVPIchpSiUjY7ILTK/KrsiWd40Hp1flwPPGX+yOCNkbnAJNcp
	7fS7nogQEwapY0sh1CVsd+jTCl8UCx44+PN6i2WGJJV/luEex4ucPwtaTzGXQ7TPSfE1C2ILhGS
	hTcq1z10Dn5cUO1l3ympaBc2tynzbibh906Ocp3nfyNRER5kTW510Q/ASxqHCH8w8fNo26fO6eW
	A9T1EPxuJiAWdg9aAkIHlPF6opA==
X-Google-Smtp-Source: AGHT+IGH5LVV10FXWTscWf1MbdV29OFTGXN+TK6mO0EpZ8qDDcqBVSdd1lNBnzoUoaG3JTtQpj/JMg==
X-Received: by 2002:a5d:59a4:0:b0:38b:f3f4:57ae with SMTP id ffacd0b85a97d-38bf5655726mr41692567f8f.10.1738071578528;
        Tue, 28 Jan 2025 05:39:38 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f2b6900023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f2b:6900:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bb02dsm14160780f8f.70.2025.01.28.05.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 05:39:38 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 3/8] io_uring/io-wq: move worker lists to struct io_wq_acct
Date: Tue, 28 Jan 2025 14:39:22 +0100
Message-ID: <20250128133927.3989681-4-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250128133927.3989681-1-max.kellermann@ionos.com>
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Have separate linked lists for bounded and unbounded workers.  This
way, io_acct_activate_free_worker() sees only workers relevant to it
and doesn't need to skip irrelevant ones.  This speeds up the
linked list traversal (under acct->lock).

The `io_wq.lock` field is moved to `io_wq_acct.workers_lock`.  It did
not actually protect "access to elements below", that is, not all of
them; it only protected access to the worker lists.  By having two
locks instead of one, contention on this lock is reduced.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 io_uring/io-wq.c | 162 ++++++++++++++++++++++++++++-------------------
 1 file changed, 96 insertions(+), 66 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 197352ef78c7..dfdd45ebe4bb 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -76,9 +76,27 @@ struct io_worker {
 #define IO_WQ_NR_HASH_BUCKETS	(1u << IO_WQ_HASH_ORDER)
 
 struct io_wq_acct {
+	/**
+	 * Protects access to the worker lists.
+	 */
+	raw_spinlock_t workers_lock;
+
 	unsigned nr_workers;
 	unsigned max_workers;
 	atomic_t nr_running;
+
+	/**
+	 * The list of free workers.  Protected by #workers_lock
+	 * (write) and RCU (read).
+	 */
+	struct hlist_nulls_head free_list;
+
+	/**
+	 * The list of all workers.  Protected by #workers_lock
+	 * (write) and RCU (read).
+	 */
+	struct list_head all_list;
+
 	raw_spinlock_t lock;
 	struct io_wq_work_list work_list;
 	unsigned long flags;
@@ -110,12 +128,6 @@ struct io_wq {
 
 	struct io_wq_acct acct[IO_WQ_ACCT_NR];
 
-	/* lock protects access to elements below */
-	raw_spinlock_t lock;
-
-	struct hlist_nulls_head free_list;
-	struct list_head all_list;
-
 	struct wait_queue_entry wait;
 
 	struct io_wq_work *hash_tail[IO_WQ_NR_HASH_BUCKETS];
@@ -190,9 +202,9 @@ static void io_worker_cancel_cb(struct io_worker *worker)
 	struct io_wq *wq = worker->wq;
 
 	atomic_dec(&acct->nr_running);
-	raw_spin_lock(&wq->lock);
+	raw_spin_lock(&acct->workers_lock);
 	acct->nr_workers--;
-	raw_spin_unlock(&wq->lock);
+	raw_spin_unlock(&acct->workers_lock);
 	io_worker_ref_put(wq);
 	clear_bit_unlock(0, &worker->create_state);
 	io_worker_release(worker);
@@ -211,6 +223,7 @@ static bool io_task_worker_match(struct callback_head *cb, void *data)
 static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wq *wq = worker->wq;
+	struct io_wq_acct *acct = io_wq_get_acct(worker);
 
 	while (1) {
 		struct callback_head *cb = task_work_cancel_match(wq->task,
@@ -224,11 +237,11 @@ static void io_worker_exit(struct io_worker *worker)
 	io_worker_release(worker);
 	wait_for_completion(&worker->ref_done);
 
-	raw_spin_lock(&wq->lock);
+	raw_spin_lock(&acct->workers_lock);
 	if (test_bit(IO_WORKER_F_FREE, &worker->flags))
 		hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
-	raw_spin_unlock(&wq->lock);
+	raw_spin_unlock(&acct->workers_lock);
 	io_wq_dec_running(worker);
 	/*
 	 * this worker is a goner, clear ->worker_private to avoid any
@@ -267,8 +280,7 @@ static inline bool io_acct_run_queue(struct io_wq_acct *acct)
  * Check head of free list for an available worker. If one isn't available,
  * caller must create one.
  */
-static bool io_wq_activate_free_worker(struct io_wq *wq,
-					struct io_wq_acct *acct)
+static bool io_acct_activate_free_worker(struct io_wq_acct *acct)
 	__must_hold(RCU)
 {
 	struct hlist_nulls_node *n;
@@ -279,13 +291,9 @@ static bool io_wq_activate_free_worker(struct io_wq *wq,
 	 * activate. If a given worker is on the free_list but in the process
 	 * of exiting, keep trying.
 	 */
-	hlist_nulls_for_each_entry_rcu(worker, n, &wq->free_list, nulls_node) {
+	hlist_nulls_for_each_entry_rcu(worker, n, &acct->free_list, nulls_node) {
 		if (!io_worker_get(worker))
 			continue;
-		if (io_wq_get_acct(worker) != acct) {
-			io_worker_release(worker);
-			continue;
-		}
 		/*
 		 * If the worker is already running, it's either already
 		 * starting work or finishing work. In either case, if it does
@@ -312,13 +320,13 @@ static bool io_wq_create_worker(struct io_wq *wq, struct io_wq_acct *acct)
 	if (unlikely(!acct->max_workers))
 		pr_warn_once("io-wq is not configured for unbound workers");
 
-	raw_spin_lock(&wq->lock);
+	raw_spin_lock(&acct->workers_lock);
 	if (acct->nr_workers >= acct->max_workers) {
-		raw_spin_unlock(&wq->lock);
+		raw_spin_unlock(&acct->workers_lock);
 		return true;
 	}
 	acct->nr_workers++;
-	raw_spin_unlock(&wq->lock);
+	raw_spin_unlock(&acct->workers_lock);
 	atomic_inc(&acct->nr_running);
 	atomic_inc(&wq->worker_refs);
 	return create_io_worker(wq, acct);
@@ -342,13 +350,13 @@ static void create_worker_cb(struct callback_head *cb)
 	worker = container_of(cb, struct io_worker, create_work);
 	wq = worker->wq;
 	acct = worker->acct;
-	raw_spin_lock(&wq->lock);
+	raw_spin_lock(&acct->workers_lock);
 
 	if (acct->nr_workers < acct->max_workers) {
 		acct->nr_workers++;
 		do_create = true;
 	}
-	raw_spin_unlock(&wq->lock);
+	raw_spin_unlock(&acct->workers_lock);
 	if (do_create) {
 		create_io_worker(wq, acct);
 	} else {
@@ -427,25 +435,25 @@ static void io_wq_dec_running(struct io_worker *worker)
  * Worker will start processing some work. Move it to the busy list, if
  * it's currently on the freelist
  */
-static void __io_worker_busy(struct io_wq *wq, struct io_worker *worker)
+static void __io_worker_busy(struct io_wq_acct *acct, struct io_worker *worker)
 {
 	if (test_bit(IO_WORKER_F_FREE, &worker->flags)) {
 		clear_bit(IO_WORKER_F_FREE, &worker->flags);
-		raw_spin_lock(&wq->lock);
+		raw_spin_lock(&acct->workers_lock);
 		hlist_nulls_del_init_rcu(&worker->nulls_node);
-		raw_spin_unlock(&wq->lock);
+		raw_spin_unlock(&acct->workers_lock);
 	}
 }
 
 /*
  * No work, worker going to sleep. Move to freelist.
  */
-static void __io_worker_idle(struct io_wq *wq, struct io_worker *worker)
-	__must_hold(wq->lock)
+static void __io_worker_idle(struct io_wq_acct *acct, struct io_worker *worker)
+	__must_hold(acct->workers_lock)
 {
 	if (!test_bit(IO_WORKER_F_FREE, &worker->flags)) {
 		set_bit(IO_WORKER_F_FREE, &worker->flags);
-		hlist_nulls_add_head_rcu(&worker->nulls_node, &wq->free_list);
+		hlist_nulls_add_head_rcu(&worker->nulls_node, &acct->free_list);
 	}
 }
 
@@ -580,7 +588,7 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 		if (!work)
 			break;
 
-		__io_worker_busy(wq, worker);
+		__io_worker_busy(acct, worker);
 
 		io_assign_current_work(worker, work);
 		__set_current_state(TASK_RUNNING);
@@ -651,20 +659,20 @@ static int io_wq_worker(void *data)
 		while (io_acct_run_queue(acct))
 			io_worker_handle_work(acct, worker);
 
-		raw_spin_lock(&wq->lock);
+		raw_spin_lock(&acct->workers_lock);
 		/*
 		 * Last sleep timed out. Exit if we're not the last worker,
 		 * or if someone modified our affinity.
 		 */
 		if (last_timeout && (exit_mask || acct->nr_workers > 1)) {
 			acct->nr_workers--;
-			raw_spin_unlock(&wq->lock);
+			raw_spin_unlock(&acct->workers_lock);
 			__set_current_state(TASK_RUNNING);
 			break;
 		}
 		last_timeout = false;
-		__io_worker_idle(wq, worker);
-		raw_spin_unlock(&wq->lock);
+		__io_worker_idle(acct, worker);
+		raw_spin_unlock(&acct->workers_lock);
 		if (io_run_task_work())
 			continue;
 		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
@@ -725,18 +733,18 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 	io_wq_dec_running(worker);
 }
 
-static void io_init_new_worker(struct io_wq *wq, struct io_worker *worker,
+static void io_init_new_worker(struct io_wq *wq, struct io_wq_acct *acct, struct io_worker *worker,
 			       struct task_struct *tsk)
 {
 	tsk->worker_private = worker;
 	worker->task = tsk;
 	set_cpus_allowed_ptr(tsk, wq->cpu_mask);
 
-	raw_spin_lock(&wq->lock);
-	hlist_nulls_add_head_rcu(&worker->nulls_node, &wq->free_list);
-	list_add_tail_rcu(&worker->all_list, &wq->all_list);
+	raw_spin_lock(&acct->workers_lock);
+	hlist_nulls_add_head_rcu(&worker->nulls_node, &acct->free_list);
+	list_add_tail_rcu(&worker->all_list, &acct->all_list);
 	set_bit(IO_WORKER_F_FREE, &worker->flags);
-	raw_spin_unlock(&wq->lock);
+	raw_spin_unlock(&acct->workers_lock);
 	wake_up_new_task(tsk);
 }
 
@@ -772,20 +780,20 @@ static void create_worker_cont(struct callback_head *cb)
 	struct io_worker *worker;
 	struct task_struct *tsk;
 	struct io_wq *wq;
+	struct io_wq_acct *acct;
 
 	worker = container_of(cb, struct io_worker, create_work);
 	clear_bit_unlock(0, &worker->create_state);
 	wq = worker->wq;
+	acct = io_wq_get_acct(worker);
 	tsk = create_io_thread(io_wq_worker, worker, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
-		io_init_new_worker(wq, worker, tsk);
+		io_init_new_worker(wq, acct, worker, tsk);
 		io_worker_release(worker);
 		return;
 	} else if (!io_should_retry_thread(worker, PTR_ERR(tsk))) {
-		struct io_wq_acct *acct = io_wq_get_acct(worker);
-
 		atomic_dec(&acct->nr_running);
-		raw_spin_lock(&wq->lock);
+		raw_spin_lock(&acct->workers_lock);
 		acct->nr_workers--;
 		if (!acct->nr_workers) {
 			struct io_cb_cancel_data match = {
@@ -793,11 +801,11 @@ static void create_worker_cont(struct callback_head *cb)
 				.cancel_all	= true,
 			};
 
-			raw_spin_unlock(&wq->lock);
+			raw_spin_unlock(&acct->workers_lock);
 			while (io_acct_cancel_pending_work(wq, acct, &match))
 				;
 		} else {
-			raw_spin_unlock(&wq->lock);
+			raw_spin_unlock(&acct->workers_lock);
 		}
 		io_worker_ref_put(wq);
 		kfree(worker);
@@ -829,9 +837,9 @@ static bool create_io_worker(struct io_wq *wq, struct io_wq_acct *acct)
 	if (!worker) {
 fail:
 		atomic_dec(&acct->nr_running);
-		raw_spin_lock(&wq->lock);
+		raw_spin_lock(&acct->workers_lock);
 		acct->nr_workers--;
-		raw_spin_unlock(&wq->lock);
+		raw_spin_unlock(&acct->workers_lock);
 		io_worker_ref_put(wq);
 		return false;
 	}
@@ -844,7 +852,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wq_acct *acct)
 
 	tsk = create_io_thread(io_wq_worker, worker, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
-		io_init_new_worker(wq, worker, tsk);
+		io_init_new_worker(wq, acct, worker, tsk);
 	} else if (!io_should_retry_thread(worker, PTR_ERR(tsk))) {
 		kfree(worker);
 		goto fail;
@@ -860,14 +868,14 @@ static bool create_io_worker(struct io_wq *wq, struct io_wq_acct *acct)
  * Iterate the passed in list and call the specific function for each
  * worker that isn't exiting
  */
-static bool io_wq_for_each_worker(struct io_wq *wq,
-				  bool (*func)(struct io_worker *, void *),
-				  void *data)
+static bool io_acct_for_each_worker(struct io_wq_acct *acct,
+				    bool (*func)(struct io_worker *, void *),
+				    void *data)
 {
 	struct io_worker *worker;
 	bool ret = false;
 
-	list_for_each_entry_rcu(worker, &wq->all_list, all_list) {
+	list_for_each_entry_rcu(worker, &acct->all_list, all_list) {
 		if (io_worker_get(worker)) {
 			/* no task if node is/was offline */
 			if (worker->task)
@@ -881,6 +889,18 @@ static bool io_wq_for_each_worker(struct io_wq *wq,
 	return ret;
 }
 
+static bool io_wq_for_each_worker(struct io_wq *wq,
+				  bool (*func)(struct io_worker *, void *),
+				  void *data)
+{
+	for (int i = 0; i < IO_WQ_ACCT_NR; i++) {
+		if (!io_acct_for_each_worker(&wq->acct[i], func, data))
+			return false;
+	}
+
+	return true;
+}
+
 static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 {
 	__set_notify_signal(worker->task);
@@ -949,7 +969,7 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 	raw_spin_unlock(&acct->lock);
 
 	rcu_read_lock();
-	do_create = !io_wq_activate_free_worker(wq, acct);
+	do_create = !io_acct_activate_free_worker(acct);
 	rcu_read_unlock();
 
 	if (do_create && ((work_flags & IO_WQ_WORK_CONCURRENT) ||
@@ -960,12 +980,12 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 		if (likely(did_create))
 			return;
 
-		raw_spin_lock(&wq->lock);
+		raw_spin_lock(&acct->workers_lock);
 		if (acct->nr_workers) {
-			raw_spin_unlock(&wq->lock);
+			raw_spin_unlock(&acct->workers_lock);
 			return;
 		}
-		raw_spin_unlock(&wq->lock);
+		raw_spin_unlock(&acct->workers_lock);
 
 		/* fatal condition, failed to create the first worker */
 		io_acct_cancel_pending_work(wq, acct, &match);
@@ -1072,11 +1092,22 @@ static void io_wq_cancel_pending_work(struct io_wq *wq,
 	}
 }
 
+static void io_acct_cancel_running_work(struct io_wq_acct *acct,
+					struct io_cb_cancel_data *match)
+{
+	raw_spin_lock(&acct->workers_lock);
+	io_acct_for_each_worker(acct, io_wq_worker_cancel, match);
+	raw_spin_unlock(&acct->workers_lock);
+}
+
 static void io_wq_cancel_running_work(struct io_wq *wq,
 				       struct io_cb_cancel_data *match)
 {
 	rcu_read_lock();
-	io_wq_for_each_worker(wq, io_wq_worker_cancel, match);
+
+	for (int i = 0; i < IO_WQ_ACCT_NR; i++)
+		io_acct_cancel_running_work(&wq->acct[i], match);
+
 	rcu_read_unlock();
 }
 
@@ -1099,16 +1130,14 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	 * as an indication that we attempt to signal cancellation. The
 	 * completion will run normally in this case.
 	 *
-	 * Do both of these while holding the wq->lock, to ensure that
+	 * Do both of these while holding the acct->workers_lock, to ensure that
 	 * we'll find a work item regardless of state.
 	 */
 	io_wq_cancel_pending_work(wq, &match);
 	if (match.nr_pending && !match.cancel_all)
 		return IO_WQ_CANCEL_OK;
 
-	raw_spin_lock(&wq->lock);
 	io_wq_cancel_running_work(wq, &match);
-	raw_spin_unlock(&wq->lock);
 	if (match.nr_running && !match.cancel_all)
 		return IO_WQ_CANCEL_RUNNING;
 
@@ -1132,7 +1161,7 @@ static int io_wq_hash_wake(struct wait_queue_entry *wait, unsigned mode,
 		struct io_wq_acct *acct = &wq->acct[i];
 
 		if (test_and_clear_bit(IO_ACCT_STALLED_BIT, &acct->flags))
-			io_wq_activate_free_worker(wq, acct);
+			io_acct_activate_free_worker(acct);
 	}
 	rcu_read_unlock();
 	return 1;
@@ -1171,14 +1200,15 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		struct io_wq_acct *acct = &wq->acct[i];
 
 		atomic_set(&acct->nr_running, 0);
+
+		raw_spin_lock_init(&acct->workers_lock);
+		INIT_HLIST_NULLS_HEAD(&acct->free_list, 0);
+		INIT_LIST_HEAD(&acct->all_list);
+
 		INIT_WQ_LIST(&acct->work_list);
 		raw_spin_lock_init(&acct->lock);
 	}
 
-	raw_spin_lock_init(&wq->lock);
-	INIT_HLIST_NULLS_HEAD(&wq->free_list, 0);
-	INIT_LIST_HEAD(&wq->all_list);
-
 	wq->task = get_task_struct(data->task);
 	atomic_set(&wq->worker_refs, 1);
 	init_completion(&wq->worker_done);
@@ -1364,14 +1394,14 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
 
 	rcu_read_lock();
 
-	raw_spin_lock(&wq->lock);
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		acct = &wq->acct[i];
+		raw_spin_lock(&acct->workers_lock);
 		prev[i] = max_t(int, acct->max_workers, prev[i]);
 		if (new_count[i])
 			acct->max_workers = new_count[i];
+		raw_spin_unlock(&acct->workers_lock);
 	}
-	raw_spin_unlock(&wq->lock);
 	rcu_read_unlock();
 
 	for (i = 0; i < IO_WQ_ACCT_NR; i++)
-- 
2.45.2


