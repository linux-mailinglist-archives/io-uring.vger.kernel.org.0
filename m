Return-Path: <io-uring+bounces-1810-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E31DE8BEA20
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 19:12:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B0903B213B0
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 17:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6FC7B672;
	Tue,  7 May 2024 17:00:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092E144C6F;
	Tue,  7 May 2024 17:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715101223; cv=none; b=ibnScLM+98R8zpXKIVz+LntGeQQFff5BbqFGTOs16F/e7TQqSquG2Dix/6ZQwUlhqgWJs4n2Nz/2R+C0ZJiDghOw6xDcxIScpMqj08gMccMFm8XSWGNlDZ6896uMCgns8R7hv2VavDvxmBpYvsihntQs4Ve1Hgp+apFxVNgHTMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715101223; c=relaxed/simple;
	bh=t1RIG4lFlJ2bVFn7HFt/zInC8yyYV3aSCcHDk0NkM5E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lT1lEBJet+8Tcr3Y75snDQCqiXaJiBsUWEbWXg1BlcKDDiGEk1FVdSo3hdwDlubBs90ANp56XRToAhXpv91Krj+JrbiY40i8UqrI2MHOZM120Fduc8HD2jAZqy1a02mMJWDgAppFDDWYq1CmYH9+pfYrAXEvk+/AkzIlt3rLyJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2e3fa13f018so10802851fa.3;
        Tue, 07 May 2024 10:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715101220; x=1715706020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LItJ7IjSKA5TzTyJS4gjTEq76An66N3HomKKKz8MeuA=;
        b=YQajUb+8LrSoddlNecbdjMX/qSO0ZNfAc29Jw7n5eP4ET8HWjyyEfpQCO2mCjTPDxr
         H2yyV2Un/EjPjfHRRjvi0jCmdOEkMI4c7OzNseym4JNdBcigFGETu9U7Wv7vQbZU8DLz
         a5rle25jm4V0U8J4yuOpltJrKj0LEA5nii4bm7goV9Zq+yrTyYkOTMuO7oDpG8Wkoxe4
         /2PPnWuOCQ7T0F34BZQ1cYhPVVnOQ30WJnO3DwJ4kEW105rUuUsLAFIIYhRetklS7X7U
         W2LbP32Q9uzpKGgxjlqzgMCgkMDOOO/HS3MZGxyIWKT3o4a0TOgeJNPv/Jq2xXQ+R8yS
         m7Bg==
X-Forwarded-Encrypted: i=1; AJvYcCVU8tP2qIzSyuFK4/8VPYa69bkfagR5IGSWuQzKrBlkywQ06bUT4teMtXVd4YJ2aAw1CJGuPWSyYLL7GqlKjnop2M2cjKZBPh05KBituBQeou/Udqj5ACt/VfZx0JQFvJ/r4aIgbFE=
X-Gm-Message-State: AOJu0YzTSh+ohIuT7M4HBT9NGEPeR9ry52q8vHoA+tTH8yzaTSBatjym
	UTYuJwwuJxb4iGcmRn2vIcyNodZS/79NwudV9HW8Z5FUIRP4+UFf
X-Google-Smtp-Source: AGHT+IHnC7yjAY4z54ZWvxpVYv0mtgDIh5GTyFxC3vHHPoxRa/lBuvTBxApS3uWYctsKvE8dQmpjVw==
X-Received: by 2002:a19:ee14:0:b0:520:76d0:b054 with SMTP id 2adb3069b0e04-5217cd4b0d8mr69069e87.57.1715101219912;
        Tue, 07 May 2024 10:00:19 -0700 (PDT)
Received: from localhost (fwdproxy-lla-003.fbsv.net. [2a03:2880:30ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id l20-20020aa7cad4000000b00572e91cf988sm3771430edt.93.2024.05.07.10.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 10:00:19 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: christophe.jaillet@wanadoo.fr,
	paulmck@kernel.org,
	io-uring@vger.kernel.org (open list:IO_URING),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] io_uring/io-wq: Use set_bit() and test_bit() at worker->flags
Date: Tue,  7 May 2024 10:00:01 -0700
Message-ID: <20240507170002.2269003-1-leitao@debian.org>
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
v3:
  * Use BIT() helpers when calling set_mask_bits()
v2:
  * Moved `create_index` to avoid holes in the struct.
  * Use set_mask_bits() as suggested by Christophe JAILLET.
  * https://lore.kernel.org/all/20240507150506.1748059-1-leitao@debian.org/
v1:
  * https://lore.kernel.org/all/20240503173711.2211911-1-leitao@debian.org/

---
 io_uring/io-wq.c | 47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index d7fc6f6d4477..d1c47a9d9215 100644
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
@@ -57,7 +58,6 @@ struct io_worker {
 
 	unsigned long create_state;
 	struct callback_head create_work;
-	int create_index;
 
 	union {
 		struct rcu_head rcu;
@@ -164,7 +164,7 @@ static inline struct io_wq_acct *io_work_get_acct(struct io_wq *wq,
 
 static inline struct io_wq_acct *io_wq_get_acct(struct io_worker *worker)
 {
-	return io_get_acct(worker->wq, worker->flags & IO_WORKER_F_BOUND);
+	return io_get_acct(worker->wq, test_bit(IO_WORKER_F_BOUND, &worker->flags));
 }
 
 static void io_worker_ref_put(struct io_wq *wq)
@@ -224,7 +224,7 @@ static void io_worker_exit(struct io_worker *worker)
 	wait_for_completion(&worker->ref_done);
 
 	raw_spin_lock(&wq->lock);
-	if (worker->flags & IO_WORKER_F_FREE)
+	if (test_bit(IO_WORKER_F_FREE, &worker->flags))
 		hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
 	raw_spin_unlock(&wq->lock);
@@ -409,7 +409,7 @@ static void io_wq_dec_running(struct io_worker *worker)
 	struct io_wq_acct *acct = io_wq_get_acct(worker);
 	struct io_wq *wq = worker->wq;
 
-	if (!(worker->flags & IO_WORKER_F_UP))
+	if (!test_bit(IO_WORKER_F_UP, &worker->flags))
 		return;
 
 	if (!atomic_dec_and_test(&acct->nr_running))
@@ -429,8 +429,8 @@ static void io_wq_dec_running(struct io_worker *worker)
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
@@ -443,8 +443,8 @@ static void __io_worker_busy(struct io_wq *wq, struct io_worker *worker)
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
@@ -632,7 +632,8 @@ static int io_wq_worker(void *data)
 	bool exit_mask = false, last_timeout = false;
 	char buf[TASK_COMM_LEN];
 
-	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
+	set_mask_bits(&worker->flags, 0,
+		      BIT(IO_WORKER_F_UP) | BIT(IO_WORKER_F_RUNNING));
 
 	snprintf(buf, sizeof(buf), "iou-wrk-%d", wq->task->pid);
 	set_task_comm(current, buf);
@@ -696,11 +697,11 @@ void io_wq_worker_running(struct task_struct *tsk)
 
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
 
@@ -714,12 +715,12 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 
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
 
@@ -733,7 +734,7 @@ static void io_init_new_worker(struct io_wq *wq, struct io_worker *worker,
 	raw_spin_lock(&wq->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wq->free_list);
 	list_add_tail_rcu(&worker->all_list, &wq->all_list);
-	worker->flags |= IO_WORKER_F_FREE;
+	set_bit(IO_WORKER_F_FREE, &worker->flags);
 	raw_spin_unlock(&wq->lock);
 	wake_up_new_task(tsk);
 }
@@ -839,7 +840,7 @@ static bool create_io_worker(struct io_wq *wq, int index)
 	init_completion(&worker->ref_done);
 
 	if (index == IO_WQ_ACCT_BOUND)
-		worker->flags |= IO_WORKER_F_BOUND;
+		set_bit(IO_WORKER_F_BOUND, &worker->flags);
 
 	tsk = create_io_thread(io_wq_worker, worker, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
@@ -925,8 +926,8 @@ static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
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


