Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB76931FDA5
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBSRLJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhBSRLD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:11:03 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523F7C061797
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:23 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id y15so5051002ilj.11
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4PjVZNSi3YexjijgewJtnbSJnMA1mIMeY/9mx+zhauw=;
        b=ht/1xlDHtxtPaQOj9wK31QgmcVMH0BKGd9y7Tx6TVyaMaXSFdH4/VcLwc7F29gP63n
         a1BVx+ZPYrqtICd7kl//O9w0+RhdyLxhFYh3sOkOIAO7oeSMUDhIlhfcNJhSd0EFDbMJ
         GvnAxteX32O1jzqiZyYDr9xGPCiO4TrD79JfoMnycvGKkFsR6Xiwcz3YL6eJwFiUfvFL
         ZJj9lH7tXoHsIhJgLNMUlWJA92mwqqPbDxDHbzfzDCgEGSHcWnwmVLu77+sfENvmWkXR
         aYJCJnJI/HCPJVIlwak/zNcV/NXr8L3QbBVCvWwPnyCQ0i9sF5jHAQR3b2XRyggqWiyp
         Jviw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4PjVZNSi3YexjijgewJtnbSJnMA1mIMeY/9mx+zhauw=;
        b=LQWVWmqahAI84FtQ6XKrYGNS6GO4xb/JHQCodYfJ5ZjLHNj2vPLQ/kyy7Cs6FmS3w3
         ZaK0BeaISsamR/oPcbR+fYRQp8LESYxGoZsYc0hQtZ042ge/TogH1bBMV5BdlhZIZgeJ
         CKi5qmBjPdOeGF8uF3b2SwMEko6fnXeWmhhLk+E2SbGZGrTx35owsJeVombddn4d2Zm9
         mHnDy8tQiD0f5dJbSisuNynRq+X0uaRpDz1tJxmZpMc6/z0T4PZVKblh/B4h8uiADk1G
         X0tzQAd0speUbrNNLDcAKYd+GUMVa+G4HCwci20sdhWWFXxVt+aPdYNiFZ18YXssjz2Q
         OQKw==
X-Gm-Message-State: AOAM531ELQY2lD2xjAf2gjZ3L0IwRaw86pxiTMO5OCuXIAolRK86YNcx
        o1mVqHOYQ9FrGt62v87AekXLe0VIM73PtakV
X-Google-Smtp-Source: ABdhPJxkULlW05j2p2064QLC+ElWz2S8dFZQz8fG3WkmKlrQZUa8Y4WTO0bCDpDE6ZQhxg9Ls3T2EQ==
X-Received: by 2002:a05:6e02:1bee:: with SMTP id y14mr4794052ilv.256.1613754622485;
        Fri, 19 Feb 2021 09:10:22 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:22 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/18] io-wq: don't pass 'wqe' needlessly around
Date:   Fri, 19 Feb 2021 10:09:58 -0700
Message-Id: <20210219171010.281878-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just grab it from the worker itself, which we're already passing in.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 0c47febfed9b..ec7f1106b659 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -201,9 +201,10 @@ static inline struct io_wqe_acct *io_work_get_acct(struct io_wqe *wqe,
 	return &wqe->acct[IO_WQ_ACCT_BOUND];
 }
 
-static inline struct io_wqe_acct *io_wqe_get_acct(struct io_wqe *wqe,
-						  struct io_worker *worker)
+static inline struct io_wqe_acct *io_wqe_get_acct(struct io_worker *worker)
 {
+	struct io_wqe *wqe = worker->wqe;
+
 	if (worker->flags & IO_WORKER_F_BOUND)
 		return &wqe->acct[IO_WQ_ACCT_BOUND];
 
@@ -213,7 +214,7 @@ static inline struct io_wqe_acct *io_wqe_get_acct(struct io_wqe *wqe,
 static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
-	struct io_wqe_acct *acct = io_wqe_get_acct(wqe, worker);
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 
 	/*
 	 * If we're not at zero, someone else is holding a brief reference
@@ -303,23 +304,24 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 		wake_up_process(wqe->wq->manager);
 }
 
-static void io_wqe_inc_running(struct io_wqe *wqe, struct io_worker *worker)
+static void io_wqe_inc_running(struct io_worker *worker)
 {
-	struct io_wqe_acct *acct = io_wqe_get_acct(wqe, worker);
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 
 	atomic_inc(&acct->nr_running);
 }
 
-static void io_wqe_dec_running(struct io_wqe *wqe, struct io_worker *worker)
+static void io_wqe_dec_running(struct io_worker *worker)
 	__must_hold(wqe->lock)
 {
-	struct io_wqe_acct *acct = io_wqe_get_acct(wqe, worker);
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wqe *wqe = worker->wqe;
 
 	if (atomic_dec_and_test(&acct->nr_running) && io_wqe_run_queue(wqe))
 		io_wqe_wake_worker(wqe, acct);
 }
 
-static void io_worker_start(struct io_wqe *wqe, struct io_worker *worker)
+static void io_worker_start(struct io_worker *worker)
 {
 	allow_kernel_signal(SIGINT);
 
@@ -329,7 +331,7 @@ static void io_worker_start(struct io_wqe *wqe, struct io_worker *worker)
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
 	worker->restore_nsproxy = current->nsproxy;
-	io_wqe_inc_running(wqe, worker);
+	io_wqe_inc_running(worker);
 }
 
 /*
@@ -354,7 +356,7 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
 	worker_bound = (worker->flags & IO_WORKER_F_BOUND) != 0;
 	work_bound = (work->flags & IO_WQ_WORK_UNBOUND) == 0;
 	if (worker_bound != work_bound) {
-		io_wqe_dec_running(wqe, worker);
+		io_wqe_dec_running(worker);
 		if (work_bound) {
 			worker->flags |= IO_WORKER_F_BOUND;
 			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers--;
@@ -366,7 +368,7 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
 			wqe->acct[IO_WQ_ACCT_BOUND].nr_workers--;
 			atomic_inc(&wqe->wq->user->processes);
 		}
-		io_wqe_inc_running(wqe, worker);
+		io_wqe_inc_running(worker);
 	 }
 }
 
@@ -589,7 +591,7 @@ static int io_wqe_worker(void *data)
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 
-	io_worker_start(wqe, worker);
+	io_worker_start(worker);
 
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -634,14 +636,13 @@ static int io_wqe_worker(void *data)
 void io_wq_worker_running(struct task_struct *tsk)
 {
 	struct io_worker *worker = kthread_data(tsk);
-	struct io_wqe *wqe = worker->wqe;
 
 	if (!(worker->flags & IO_WORKER_F_UP))
 		return;
 	if (worker->flags & IO_WORKER_F_RUNNING)
 		return;
 	worker->flags |= IO_WORKER_F_RUNNING;
-	io_wqe_inc_running(wqe, worker);
+	io_wqe_inc_running(worker);
 }
 
 /*
@@ -662,7 +663,7 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 	worker->flags &= ~IO_WORKER_F_RUNNING;
 
 	raw_spin_lock_irq(&wqe->lock);
-	io_wqe_dec_running(wqe, worker);
+	io_wqe_dec_running(worker);
 	raw_spin_unlock_irq(&wqe->lock);
 }
 
-- 
2.30.0

