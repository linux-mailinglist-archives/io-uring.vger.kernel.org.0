Return-Path: <io-uring+bounces-1710-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D198C8BB1DC
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 19:37:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D4C4EB20B5A
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 17:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7938E157E87;
	Fri,  3 May 2024 17:37:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA061EA87;
	Fri,  3 May 2024 17:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714757838; cv=none; b=MtAMXTtr9VoICg+go8fnHlqeWobnv9eH1AFBC9E/+5a1iL058VCzPUTdtJseaSLv2uxHzWlyxJWJl4ajdav+PruvhPKQxtqo7LT0L69UY9uXmTVsDnnNge7P3bVHPJHSphvsPKmopP0dbDC+SBf1nFRagFpAEeZZ5BNBz9XXPGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714757838; c=relaxed/simple;
	bh=ffYdlFU2N5khAncz7FuZgYdmuPobYWJIuub4Tfx5sHo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ozhDSE7UvFzpk/N+51j4BZYCgqlvfG+EFS6dWuhiXIL0lJoGk8XSH8kDpPAjU7GW5txj8+eVn/E2CN+1cxNA3M6iKqiFo02zjm/qQ1A1+Ma9h0BD4zFaYoQZe4s3wbkXaYci087FcKab2nHxrA2Uaz/aWIzZKiLP5DDnlVAlGxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a597de5a715so375339466b.2;
        Fri, 03 May 2024 10:37:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714757835; x=1715362635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oNeVP55/tYBUCC+buHTeImb1VCQfKz88JDpcLuFeZ/o=;
        b=GgamD9GHYH+/7G27RE62qZr6Ap3baVNTX7KuH9FOzXW9tEOOC6q70S4Zo6ovtdBUkE
         dWbIUacqk4cbHGAWY99qzXXIO0X1jLV/R6e8sJSKl4xZgPZqTdxwc4cW4qmGWdDrDlQc
         3XV9jnG2NzdMKZvB+rbAng7d6xWhRE6fH5vikCusHdMdFelVSxxouW3CifrImVk18tpA
         pvG/3jgRnU8qYtpu54fT4gZRIbouLEHCnoy9Wu29sqNg9SMdf1mfw3lhoqBS75Zy4rg7
         1HTDwH57+oWjx5jZKvG3ocH2DX/H11J7oQ4+eX1Tw3Qkw6IbaO6lhxsGplsF7WxOJpuA
         NwLw==
X-Forwarded-Encrypted: i=1; AJvYcCUcxCIkpD8bvy3BrV3b0I3BnazsgYiLRqm3QDVu+rcKk1DbEoGSe0GSJHQTprUd0C81AfW70vtFo89NiHERDzobKRnTnBdQIqG+/y3VR73bDAWhrZR+UkbYR4fF7q+9Ptx/vGVWCOA=
X-Gm-Message-State: AOJu0YwSFkbL1MtMet/cOJlecRQqQ/NHARmcyZ+IUeyp392Xt+HoCAte
	/HsOzP+TE+EBAg+uqYD59J2dz8fFU72JF/j26gKGlp76A5ZXYohQ
X-Google-Smtp-Source: AGHT+IGxbYhbo2Veue9D5d8wb+mVQIddhXM7E8yN0+5L7O2LS65Hy3dC8giBiuBD49/EIHMSDMVpTQ==
X-Received: by 2002:a50:9b55:0:b0:572:a123:5ed0 with SMTP id a21-20020a509b55000000b00572a1235ed0mr2039453edj.21.1714757834740;
        Fri, 03 May 2024 10:37:14 -0700 (PDT)
Received: from localhost (fwdproxy-lla-117.fbsv.net. [2a03:2880:30ff:75::face:b00c])
        by smtp.gmail.com with ESMTPSA id ec43-20020a0564020d6b00b00572dea90dabsm242515edb.63.2024.05.03.10.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 10:37:14 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: leit@meta.com,
	io-uring@vger.kernel.org (open list:IO_URING),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] io_uring/io-wq: Use set_bit() and test_bit() at worker->flags
Date: Fri,  3 May 2024 10:37:11 -0700
Message-ID: <20240503173711.2211911-1-leitao@debian.org>
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

The structure io_worker->flags may be accessed through parallel data
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

Line numbers against commit 18daea77cca6 ("Merge tag 'for-linus' of
git://git.kernel.org/pub/scm/virt/kvm/kvm").

These races involve writes and reads to the same memory location by
different tasks running on different CPUs. To mitigate this, refactor
the code to use atomic operations such as set_bit(), test_bit(), and
clear_bit() instead of basic "and" and "or" operations. This ensures
thread-safe manipulation of worker flags.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/io-wq.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 522196dfb0ff..6712d70d1f18 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -44,7 +44,7 @@ enum {
  */
 struct io_worker {
 	refcount_t ref;
-	unsigned flags;
+	unsigned long flags;
 	struct hlist_nulls_node nulls_node;
 	struct list_head all_list;
 	struct task_struct *task;
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
@@ -631,7 +631,8 @@ static int io_wq_worker(void *data)
 	bool exit_mask = false, last_timeout = false;
 	char buf[TASK_COMM_LEN];
 
-	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
+	set_bit(IO_WORKER_F_UP, &worker->flags);
+	set_bit(IO_WORKER_F_RUNNING, &worker->flags);
 
 	snprintf(buf, sizeof(buf), "iou-wrk-%d", wq->task->pid);
 	set_task_comm(current, buf);
@@ -695,11 +696,11 @@ void io_wq_worker_running(struct task_struct *tsk)
 
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
 
@@ -713,12 +714,12 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 
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
 
@@ -732,7 +733,7 @@ static void io_init_new_worker(struct io_wq *wq, struct io_worker *worker,
 	raw_spin_lock(&wq->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wq->free_list);
 	list_add_tail_rcu(&worker->all_list, &wq->all_list);
-	worker->flags |= IO_WORKER_F_FREE;
+	set_bit(IO_WORKER_F_FREE, &worker->flags);
 	raw_spin_unlock(&wq->lock);
 	wake_up_new_task(tsk);
 }
@@ -838,7 +839,7 @@ static bool create_io_worker(struct io_wq *wq, int index)
 	init_completion(&worker->ref_done);
 
 	if (index == IO_WQ_ACCT_BOUND)
-		worker->flags |= IO_WORKER_F_BOUND;
+		set_bit(IO_WORKER_F_BOUND, &worker->flags);
 
 	tsk = create_io_thread(io_wq_worker, worker, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
@@ -924,8 +925,8 @@ static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
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


