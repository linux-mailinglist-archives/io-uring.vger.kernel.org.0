Return-Path: <io-uring+bounces-6152-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D608A20B62
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 14:39:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B23A3A65D4
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 13:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F3DF1A9B4C;
	Tue, 28 Jan 2025 13:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="dmcTbvJq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E24B15CD41
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 13:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738071582; cv=none; b=TjtM3T4LyBnBo/G4CnY7F29/bmNCRWkt2f38EmIpp5HYByrXMdO2/eUBMVmLfbZ7y1YA8V+ELpb8MB3h12fNMI4YfDAuiz+hOYmFcHFO2aS4293rDfR4K2Co+JXcNjBK1QHTn/Yuhl7vE+4rtWM63cjitn1Dh8hxL8lecQJqldc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738071582; c=relaxed/simple;
	bh=mvwqkwgQ/VbBCILFRqc5Ce5W30pZPIIiXsjC5pLsUOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpmT4qjSrFOtl5n2yX7tjhkdtfO4M6N78nJf/fe02oBzfTAjDyIs2cDM599SugFJhYz+XjcWlqJO/vxbVxGPCHPJ3pl/qM9rY2qgp0wrWNQVKAY4jz5nZN4lv7o0oHtmJy+bdvH4xoMDmqhBL9t6OwTgpnHDnDh5zt/ASI1hwKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=dmcTbvJq; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-436345cc17bso40185305e9.0
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 05:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738071578; x=1738676378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Mh2jFvUal50P1kZhLOmeKi1LJ4OQZ7qeSID+lPKLRI=;
        b=dmcTbvJq5LwZgER+aOP9EMfJB3fym6t/rTAyYesr4HpBjdKqfHKVrb8FBZGdfniwpt
         o+pjOkEljT2cCZuc21djJ3qYoI7jN0qvMp7OVgs3vvSQ/3ZxGAe1xE1SLGhtMfJBVB7z
         hBmFeDAuv9MVacejRHva/7JfPnToJVPNfxEf4q76/PyFAq3v5R6QfPNR4eDjzDdhPfLx
         QUVkubAoOE3n7Aba6Va/pYusD57mRzHsPkK+ypsLUxjhrquytPtK/AfHFk0ReRiteLDG
         wc4pzbLyQoYuxVRsD3v8B3RjA7V11GZ4GzsmLx1es76o1m/XgAOMI8mLTmRjhGvDyVJQ
         zIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738071578; x=1738676378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Mh2jFvUal50P1kZhLOmeKi1LJ4OQZ7qeSID+lPKLRI=;
        b=kJ2Y0cm128PcVbircly1vFJ7kneOlzbMHLvLJkesb9eA0T3kTolWdVcfwDnXd77lgW
         P1YGCgv7qteLHRNRFbg2JJJhCSbztNg5S1gvHwieQ6GVIBolst/TyZTzv+SwktN28TZH
         0qaLJB6xH+WRTVBhHfd3vhB2FGEUgP57nGLEmNLSh2k/uH0OKMe6QkG+aA14PZubJFiI
         maVuZWidMQm7A7nl0E5997FMrs+bsP1zhx9O0FGzsLpAfnTL68Fz5NibPhzJgQQzm1ls
         6vJxqNXYM5daI2YPKJzSP46G70wYPWunYZBv8TEZhtslJOqi1QxnDJXOBB8LTXsqaw/K
         lUOw==
X-Forwarded-Encrypted: i=1; AJvYcCVAnZLjZ/yPdHJCFMwQeT+PQz7mafX5fte/eAUx5CCEg1AFw6dGS5UA/H3xsL7ySJGG6sfN4l2WDg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYPd9BezzGlQmHKlokU/84wHLEkcbyCZtIM8K0FPdTUzSeNl71
	r65e4KOSfMYSbo0a5bPQxcLR8nz363Ahz9RyXLwAGhbH22sB0DjIHFMVufIP2dE=
X-Gm-Gg: ASbGnctxi1EqvsWtrh0IJRFlFhd6EhEI94DbGtiCLfgOlvsUDOtJVLzdEm65p7Xekml
	CrxdBgTG4oZFJjxn+qbJqBF7fUJXtwMU4Q+65au5IGTxJ9P/pmLfd0UM9Tc/O+YtyzoY2/v8czO
	QCI2TAsFdozybUQy6YwK6/jLOJMQI0UXikFYIZNdMYtQcRiwbExIN3QPpx2RjXRb0AAKW1Jhr/o
	rWvpzP7pMeb4mWDdmtjSj3M1L79gW1VAA+FE6RaVHncH3T1cUdpWxKnZSXmcqi6pmJuShYkDlJJ
	/SglwQF1xA3chykZ671qikznro9FYMsgnIglvP0HPCLqGNQkcJ52+7dDwvhUzn5zXp/wLk36erL
	hRBAFm0/ewFSxGNk=
X-Google-Smtp-Source: AGHT+IHgeKju9Jzoyobd7WVJUbZyx4+buUWEWE2AbiOXa5JBGh33t4+gMIX8Byr7egoIWtLFm9Wfsg==
X-Received: by 2002:a05:600c:1d19:b0:434:f623:9ff3 with SMTP id 5b1f17b1804b1-438913e0303mr456136895e9.15.1738071577698;
        Tue, 28 Jan 2025 05:39:37 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f2b6900023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f2b:6900:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bb02dsm14160780f8f.70.2025.01.28.05.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 05:39:37 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 2/8] io_uring/io-wq: add io_worker.acct pointer
Date: Tue, 28 Jan 2025 14:39:21 +0100
Message-ID: <20250128133927.3989681-3-max.kellermann@ionos.com>
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

This replaces the `IO_WORKER_F_BOUND` flag.  All code that checks this
flag is not interested in knowing whether this is a "bound" worker;
all it does with this flag is determine the `io_wq_acct` pointer.  At
the cost of an extra pointer field, we can eliminate some fragile
pointer arithmetic.  In turn, the `create_index` and `index` fields
are not needed anymore.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 io_uring/io-wq.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 6d26f6f068af..197352ef78c7 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -30,7 +30,6 @@ enum {
 	IO_WORKER_F_UP		= 0,	/* up and active */
 	IO_WORKER_F_RUNNING	= 1,	/* account as running */
 	IO_WORKER_F_FREE	= 2,	/* worker on free list */
-	IO_WORKER_F_BOUND	= 3,	/* is doing bounded work */
 };
 
 enum {
@@ -46,12 +45,12 @@ enum {
  */
 struct io_worker {
 	refcount_t ref;
-	int create_index;
 	unsigned long flags;
 	struct hlist_nulls_node nulls_node;
 	struct list_head all_list;
 	struct task_struct *task;
 	struct io_wq *wq;
+	struct io_wq_acct *acct;
 
 	struct io_wq_work *cur_work;
 	raw_spinlock_t lock;
@@ -79,7 +78,6 @@ struct io_worker {
 struct io_wq_acct {
 	unsigned nr_workers;
 	unsigned max_workers;
-	int index;
 	atomic_t nr_running;
 	raw_spinlock_t lock;
 	struct io_wq_work_list work_list;
@@ -135,7 +133,7 @@ struct io_cb_cancel_data {
 	bool cancel_all;
 };
 
-static bool create_io_worker(struct io_wq *wq, int index);
+static bool create_io_worker(struct io_wq *wq, struct io_wq_acct *acct);
 static void io_wq_dec_running(struct io_worker *worker);
 static bool io_acct_cancel_pending_work(struct io_wq *wq,
 					struct io_wq_acct *acct,
@@ -167,7 +165,7 @@ static inline struct io_wq_acct *io_work_get_acct(struct io_wq *wq,
 
 static inline struct io_wq_acct *io_wq_get_acct(struct io_worker *worker)
 {
-	return io_get_acct(worker->wq, test_bit(IO_WORKER_F_BOUND, &worker->flags));
+	return worker->acct;
 }
 
 static void io_worker_ref_put(struct io_wq *wq)
@@ -323,7 +321,7 @@ static bool io_wq_create_worker(struct io_wq *wq, struct io_wq_acct *acct)
 	raw_spin_unlock(&wq->lock);
 	atomic_inc(&acct->nr_running);
 	atomic_inc(&wq->worker_refs);
-	return create_io_worker(wq, acct->index);
+	return create_io_worker(wq, acct);
 }
 
 static void io_wq_inc_running(struct io_worker *worker)
@@ -343,7 +341,7 @@ static void create_worker_cb(struct callback_head *cb)
 
 	worker = container_of(cb, struct io_worker, create_work);
 	wq = worker->wq;
-	acct = &wq->acct[worker->create_index];
+	acct = worker->acct;
 	raw_spin_lock(&wq->lock);
 
 	if (acct->nr_workers < acct->max_workers) {
@@ -352,7 +350,7 @@ static void create_worker_cb(struct callback_head *cb)
 	}
 	raw_spin_unlock(&wq->lock);
 	if (do_create) {
-		create_io_worker(wq, worker->create_index);
+		create_io_worker(wq, acct);
 	} else {
 		atomic_dec(&acct->nr_running);
 		io_worker_ref_put(wq);
@@ -384,7 +382,6 @@ static bool io_queue_worker_create(struct io_worker *worker,
 
 	atomic_inc(&wq->worker_refs);
 	init_task_work(&worker->create_work, func);
-	worker->create_index = acct->index;
 	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL)) {
 		/*
 		 * EXIT may have been set after checking it above, check after
@@ -821,9 +818,8 @@ static void io_workqueue_create(struct work_struct *work)
 		kfree(worker);
 }
 
-static bool create_io_worker(struct io_wq *wq, int index)
+static bool create_io_worker(struct io_wq *wq, struct io_wq_acct *acct)
 {
-	struct io_wq_acct *acct = &wq->acct[index];
 	struct io_worker *worker;
 	struct task_struct *tsk;
 
@@ -842,12 +838,10 @@ static bool create_io_worker(struct io_wq *wq, int index)
 
 	refcount_set(&worker->ref, 1);
 	worker->wq = wq;
+	worker->acct = acct;
 	raw_spin_lock_init(&worker->lock);
 	init_completion(&worker->ref_done);
 
-	if (index == IO_WQ_ACCT_BOUND)
-		set_bit(IO_WORKER_F_BOUND, &worker->flags);
-
 	tsk = create_io_thread(io_wq_worker, worker, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
 		io_init_new_worker(wq, worker, tsk);
@@ -1176,7 +1170,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		struct io_wq_acct *acct = &wq->acct[i];
 
-		acct->index = i;
 		atomic_set(&acct->nr_running, 0);
 		INIT_WQ_LIST(&acct->work_list);
 		raw_spin_lock_init(&acct->lock);
-- 
2.45.2


