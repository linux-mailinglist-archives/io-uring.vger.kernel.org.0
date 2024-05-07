Return-Path: <io-uring+bounces-1805-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E57A8BE6EC
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 17:06:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75E4FB28DE9
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 15:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 633CC161313;
	Tue,  7 May 2024 15:05:17 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D3615F311;
	Tue,  7 May 2024 15:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715094317; cv=none; b=bxaWRNRDiv/KjNT794OChdfDalHHSLiO3LqRxPoBrXEU0TRYXlo9d7ufqf0Xwce2ZpZcuXU6nVAzLGQ2KGojQ2tbnuyLfRqfEPLxuGBY7K64RtT1T29kBxf1p1LqAfnXU8VVTeFSJ7VsHDMSWIdok6HXQOq5cRKUbohNWbfrNxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715094317; c=relaxed/simple;
	bh=F5SojC1Aso76ilUIHd7zkohFfpWYx4zKuWjVs2YIOZo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ixvo6BEF+33tz+M3cmNp/zIA9AHM0qZQEzfTpPqpwcpUJe11oyuRPsU/AV7CHIo/WDMzmS1Cyq6I/XgVwCjAbWjGA/o3quwYU1moY+0u7kO0C/B3fm6FOPREevdNRaldQiK8j0EucAbz933MvuIKRD6SvLzIzM08BCbyR0YBAYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a59a5f81af4so847447666b.3;
        Tue, 07 May 2024 08:05:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715094313; x=1715699113;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TURLiT4bRicACTKTr+r8vhSZhdlXKzpOFbrGnSfXbuo=;
        b=AIb770xBZ9YGBcybdLaJLi3yYQIwY9QAm28Wi7XAdeq3knGqO2B0PITmO8hARSH20u
         s2D22YJ3IYlqbEDuO37XPfm0yu+JnwCHxX5dV+uoKusI9iSHEp1w+BEyDAOGpc9MOuH9
         Vm2A34mNjmPSh9mQWefej0pPiKPWz0ANDUgIlv5V1pJIL3eeN0cKBThSx12CdDx9RMDs
         IqsnAYGRYKzw3Je9IVwz19pNYmnFllwFfjQPBo+3MRYLGQ81G4acsas1In8uwLqlpfAL
         jf9QXI8HxdDWx14t5FN+2tVs/Z9gdbbA5/OhIgC/JZJU5wNIdNRyH5M8GgYepG/MTcKV
         KCRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPf1AKXbuJfMmFoqD9RNr25yr3ekYS//IuIigBxZKaaEd3ylVTq9tJf9D4h9iMfqF99SoEm4g7Q2nhWlaGz1RUlwQabCar5F/ECU2kYgguCglbYoOSyCq6g5YmJvduSPIs8IADsdA=
X-Gm-Message-State: AOJu0Yz8RIeCWDn16cWouDnOryd4yHQM8kNDXsIGvs4NajEwekR7lBxL
	4fVnIchu6HSJEEIixoQZZS+eyrCuuBMG3B2nW20NMvGOHAfH3yGJ
X-Google-Smtp-Source: AGHT+IEGkucU37pVk0CxcOQhxNRKNsgWhIiOqqzcRjmrXhSP6dg1K4fMfGdPqURZqTdCTyFxxNthMQ==
X-Received: by 2002:a17:907:944d:b0:a59:cc9b:d6ea with SMTP id dl13-20020a170907944d00b00a59cc9bd6eamr5525762ejc.22.1715094313164;
        Tue, 07 May 2024 08:05:13 -0700 (PDT)
Received: from localhost (fwdproxy-lla-120.fbsv.net. [2a03:2880:30ff:78::face:b00c])
        by smtp.gmail.com with ESMTPSA id bh9-20020a170906a0c900b00a59b1914415sm3795821ejb.5.2024.05.07.08.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 08:05:12 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: christophe.jaillet@wanadoo.fr,
	io-uring@vger.kernel.org (open list:IO_URING),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] io_uring/io-wq: Use set_bit() and test_bit() at worker->flags
Date: Tue,  7 May 2024 08:05:05 -0700
Message-ID: <20240507150506.1748059-1-leitao@debian.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Utilize set_bit() and test_bit() on worker->flags within io_uring/io-wq
to address potential data races.

The structure io_worker->flags may be accessed through various data
paths, leading to concurrency issues. When KCSAN is enabled, it reveals
data races occurring in io_worker_handle_work and
io_wq_activate_free_worker functions.

	 BUG: KCSAN: data-race in io_worker_handle_work / io_wq_activate_free_worker
	 write to 0xffff8885c4246404 of 4 bytes by task 49071 on cpu 28:
	 io_worker_handle_work (io_uring/io-wq.c:434 io_uring/io-wq.c:569)
	 io_wq_worker (io_uring/io-wq.c:?)
<snip>

	 read to 0xffff8885c4246404 of 4 bytes by task 49024 on cpu 5:
	 io_wq_activate_free_worker (io_uring/io-wq.c:? io_uring/io-wq.c:285)
	 io_wq_enqueue (io_uring/io-wq.c:947)
	 io_queue_iowq (io_uring/io_uring.c:524)
	 io_req_task_submit (io_uring/io_uring.c:1511)
	 io_handle_tw_list (io_uring/io_uring.c:1198)
<snip>

Line numbers against commit 18daea77cca6 ("Merge tag 'for-linus' of
git://git.kernel.org/pub/scm/virt/kvm/kvm").

These races involve writes and reads to the same memory location by
different tasks running on different CPUs. To mitigate this, refactor
the code to use atomic operations such as set_bit(), test_bit(), and
clear_bit() instead of basic "and" and "or" operations. This ensures
thread-safe manipulation of worker flags.

Also, move `create_index` to avoid holes in the structure.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changelog:

v2:
  * Moved `create_index` to avoid holes in the struct.
  * Use set_mask_bits() as suggested by Christophe JAILLET.
v1:
  * https://lore.kernel.org/all/20240503173711.2211911-1-leitao@debian.org/

---
 io_uring/io-wq.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 522196dfb0ff..296b8301813a 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -25,10 +25,10 @@
 #define WORKER_IDLE_TIMEOUT	(5 * HZ)
 
 enum {
-	IO_WORKER_F_UP		= 1,	/* up and active */
-	IO_WORKER_F_RUNNING	= 2,	/* account as running */
-	IO_WORKER_F_FREE	= 4,	/* worker on free list */
-	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
+	IO_WORKER_F_UP		= 0,	/* up and active */
+	IO_WORKER_F_RUNNING	= 1,	/* account as running */
+	IO_WORKER_F_FREE	= 2,	/* worker on free list */
+	IO_WORKER_F_BOUND	= 3,	/* is doing bounded work */
 };
 
 enum {
@@ -44,7 +44,8 @@ enum {
  */
 struct io_worker {
 	refcount_t ref;
-	unsigned flags;
+	int create_index;
+	unsigned long flags;
 	struct hlist_nulls_node nulls_node;
 	struct list_head all_list;
 	struct task_struct *task;
@@ -58,7 +59,6 @@ struct io_worker {
 
 	unsigned long create_state;
 	struct callback_head create_work;
-	int create_index;
 
 	union {
 		struct rcu_head rcu;
@@ -165,7 +165,7 @@ static inline struct io_wq_acct *io_work_get_acct(struct io_wq *wq,
 
 static inline struct io_wq_acct *io_wq_get_acct(struct io_worker *worker)
 {
-	return io_get_acct(worker->wq, worker->flags & IO_WORKER_F_BOUND);
+	return io_get_acct(worker->wq, test_bit(IO_WORKER_F_BOUND, &worker->flags));
 }
 
 static void io_worker_ref_put(struct io_wq *wq)
@@ -225,7 +225,7 @@ static void io_worker_exit(struct io_worker *worker)
 	wait_for_completion(&worker->ref_done);
 
 	raw_spin_lock(&wq->lock);
-	if (worker->flags & IO_WORKER_F_FREE)
+	if (test_bit(IO_WORKER_F_FREE, &worker->flags))
 		hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
 	raw_spin_unlock(&wq->lock);
@@ -410,7 +410,7 @@ static void io_wq_dec_running(struct io_worker *worker)
 	struct io_wq_acct *acct = io_wq_get_acct(worker);
 	struct io_wq *wq = worker->wq;
 
-	if (!(worker->flags & IO_WORKER_F_UP))
+	if (!test_bit(IO_WORKER_F_UP, &worker->flags))
 		return;
 
 	if (!atomic_dec_and_test(&acct->nr_running))
@@ -430,8 +430,8 @@ static void io_wq_dec_running(struct io_worker *worker)
  */
 static void __io_worker_busy(struct io_wq *wq, struct io_worker *worker)
 {
-	if (worker->flags & IO_WORKER_F_FREE) {
-		worker->flags &= ~IO_WORKER_F_FREE;
+	if (test_bit(IO_WORKER_F_FREE, &worker->flags)) {
+		clear_bit(IO_WORKER_F_FREE, &worker->flags);
 		raw_spin_lock(&wq->lock);
 		hlist_nulls_del_init_rcu(&worker->nulls_node);
 		raw_spin_unlock(&wq->lock);
@@ -444,8 +444,8 @@ static void __io_worker_busy(struct io_wq *wq, struct io_worker *worker)
 static void __io_worker_idle(struct io_wq *wq, struct io_worker *worker)
 	__must_hold(wq->lock)
 {
-	if (!(worker->flags & IO_WORKER_F_FREE)) {
-		worker->flags |= IO_WORKER_F_FREE;
+	if (!test_bit(IO_WORKER_F_FREE, &worker->flags)) {
+		set_bit(IO_WORKER_F_FREE, &worker->flags);
 		hlist_nulls_add_head_rcu(&worker->nulls_node, &wq->free_list);
 	}
 }
@@ -631,7 +631,7 @@ static int io_wq_worker(void *data)
 	bool exit_mask = false, last_timeout = false;
 	char buf[TASK_COMM_LEN];
 
-	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
+	set_mask_bits(&worker->flags, 0, IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
 
 	snprintf(buf, sizeof(buf), "iou-wrk-%d", wq->task->pid);
 	set_task_comm(current, buf);
@@ -695,11 +695,11 @@ void io_wq_worker_running(struct task_struct *tsk)
 
 	if (!worker)
 		return;
-	if (!(worker->flags & IO_WORKER_F_UP))
+	if (!test_bit(IO_WORKER_F_UP, &worker->flags))
 		return;
-	if (worker->flags & IO_WORKER_F_RUNNING)
+	if (test_bit(IO_WORKER_F_RUNNING, &worker->flags))
 		return;
-	worker->flags |= IO_WORKER_F_RUNNING;
+	set_bit(IO_WORKER_F_RUNNING, &worker->flags);
 	io_wq_inc_running(worker);
 }
 
@@ -713,12 +713,12 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 
 	if (!worker)
 		return;
-	if (!(worker->flags & IO_WORKER_F_UP))
+	if (!test_bit(IO_WORKER_F_UP, &worker->flags))
 		return;
-	if (!(worker->flags & IO_WORKER_F_RUNNING))
+	if (!test_bit(IO_WORKER_F_RUNNING, &worker->flags))
 		return;
 
-	worker->flags &= ~IO_WORKER_F_RUNNING;
+	clear_bit(IO_WORKER_F_RUNNING, &worker->flags);
 	io_wq_dec_running(worker);
 }
 
@@ -732,7 +732,7 @@ static void io_init_new_worker(struct io_wq *wq, struct io_worker *worker,
 	raw_spin_lock(&wq->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wq->free_list);
 	list_add_tail_rcu(&worker->all_list, &wq->all_list);
-	worker->flags |= IO_WORKER_F_FREE;
+	set_bit(IO_WORKER_F_FREE, &worker->flags);
 	raw_spin_unlock(&wq->lock);
 	wake_up_new_task(tsk);
 }
@@ -838,7 +838,7 @@ static bool create_io_worker(struct io_wq *wq, int index)
 	init_completion(&worker->ref_done);
 
 	if (index == IO_WQ_ACCT_BOUND)
-		worker->flags |= IO_WORKER_F_BOUND;
+		set_bit(IO_WORKER_F_BOUND, &worker->flags);
 
 	tsk = create_io_thread(io_wq_worker, worker, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
@@ -924,8 +924,8 @@ static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 {
 	struct io_wq_acct *acct = io_work_get_acct(wq, work);
+	unsigned long work_flags = work->flags;
 	struct io_cb_cancel_data match;
-	unsigned work_flags = work->flags;
 	bool do_create;
 
 	/*
-- 
2.43.0


