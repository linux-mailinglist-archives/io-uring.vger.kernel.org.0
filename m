Return-Path: <io-uring+bounces-2490-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F8092D7DD
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 19:58:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7390E1F22161
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 17:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AD4D195F28;
	Wed, 10 Jul 2024 17:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VI0KlQgp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865F619580B;
	Wed, 10 Jul 2024 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720634305; cv=none; b=jo5pCjzjL4RRrGNdZ48pvI0ot9SqiYPzENb5b7n9cPga2z9djukk39C9r/q6RJYgHV6Dfw0piTMit7RudY0ID5pACYxrC1nGRnNSwfK33QHgJ1NCID1BN7/pFw/VxdhPUXYSEguYUUaUHsIXB6WeWe7/4r7bQsBdrPCxSf5aPb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720634305; c=relaxed/simple;
	bh=56yxF9GpN3+SBqvxWIHDoRuiZiSSCgbsjJKnBgn+SdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3pcWGIFQ0+ZabN+T582L77pgplBtdX4yqpxdSoESYlRLYksXIJuT+zz9y640AAqCDruAZ0slZcw8GYiD/5/hFalNBz4WjAOWAfKQbtnssr7YK35i/LAF8AxHx6eTWWfYhYmw2roWgr7MmdcebdNe4F9OENwMoiWCVHQmiqN5Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VI0KlQgp; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-595856e2332so16692a12.1;
        Wed, 10 Jul 2024 10:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720634302; x=1721239102; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P+VgPEMLmae+/qxOpZtakJuw1R/jzNgCMh5Dl8wOtdE=;
        b=VI0KlQgpIC1DhkmyJse6tzvbbvcTkJmLSJyZ5PtPP/5YeWuOarYOGoEGU0AHR/UOc2
         /njpMDUhzttUt+oTJoyB1g3wZVsuJKQ0Mf0uniOUqvs0wa6JbrkVf6i5aSYYHRgRdwuB
         vndTRFo+SlPlFLuw1ujie16H4nwf0FnZdALltfiUOwRjovyxNQ8BJF1cGFi9gUuEZXqh
         HUdXKoCXVEgtoSa4FcUTwBKLBwK0Uq1OYUyRyTYbeh/FUJ7U9xQSns5HVsIZR/mwUfZT
         uNo8u8fiWBpdPi0xOVa5ucDmh8+B1fC622oi30lX5FiSiZNRrtTDQPt+ExBPmtmiOct6
         LBZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720634302; x=1721239102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P+VgPEMLmae+/qxOpZtakJuw1R/jzNgCMh5Dl8wOtdE=;
        b=OBMrbdrgfYEZC7ivf7bxVrAFqMVPa1ENs6MeFjkE8IU2CLpotUJ1H0B8p8BJqK4wIg
         6nNd0XeelO9m4YBdTGXfZTtJxBAcXAcK5I+FzW0E2Sn7tF1lZjuLDH0FTX6avzIzidRx
         xIbPZuiVYy485gSyBz/AWi18OPncrIs1ldJcIn6v62tYtO23XK1f4zgyE+7FbA632JyE
         rxLY9tTm4j4BoS/wgN8f+h3MMTz2ZBne6nYe3iVcu+d3CqtJbm4ntDQxEB5sx3nXyu7A
         iBtKnwKlqcW13vpKbTpW1ZMQgPxFdrwzwLswVuc08t1N314utttjVdFoyYoiUDpF4Vyz
         Qg2w==
X-Forwarded-Encrypted: i=1; AJvYcCWqGRY1lFmTBc//Q6V3LutJMx2pxTxaz0K1jBYtHLK00huZu1L9MuFri/2kgnLuWE7KMakQz8bEnX5gTAJW5CgYkX6A418DZu+rq/LL
X-Gm-Message-State: AOJu0YxJcrFXJiIVm9pzcOUqpNukv+yMphIRqZaFsNIRTssXvsLOU6Wx
	ZUayNx1e7phdQujL6I4ORhEoWYw5I4KHOPbeKnI84bgs5/Y1A0z227ik/A==
X-Google-Smtp-Source: AGHT+IG1Ah/owR/vxbAcLhRPAwlG+SRJjcy9ABTH2RYIo9D9vHFpGpHCuWvC9bFMyKUYkjtzwlX2Dg==
X-Received: by 2002:a05:6402:11cb:b0:58e:4088:ed2 with SMTP id 4fb4d7f45d1cf-594baf8d6e7mr4700754a12.16.1720634301471;
        Wed, 10 Jul 2024 10:58:21 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-594bbe2ce4bsm2459679a12.25.2024.07.10.10.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 10:58:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH v3 1/2] io_uring/io-wq: limit retrying worker initialisation
Date: Wed, 10 Jul 2024 18:58:17 +0100
Message-ID: <8280436925db88448c7c85c6656edee1a43029ea.1720634146.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1720634146.git.asml.silence@gmail.com>
References: <cover.1720634146.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If io-wq worker creation fails, we retry it by queueing up a task_work.
tasK_work is needed because it should be done from the user process
context. The problem is that retries are not limited, and if queueing a
task_work is the reason for the failure, we might get into an infinite
loop.

It doesn't seem to happen now but it would with the following patch
executing task_work in the freezer's loop. For now, arbitrarily limit the
number of attempts to create a worker.

Cc: stable@vger.kernel.org
Fixes: 3146cba99aa28 ("io-wq: make worker creation resilient against signals")
Reported-by: Julian Orth <ju.orth@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io-wq.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 913c92249522..f1e7c670add8 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -23,6 +23,7 @@
 #include "io_uring.h"
 
 #define WORKER_IDLE_TIMEOUT	(5 * HZ)
+#define WORKER_INIT_LIMIT	3
 
 enum {
 	IO_WORKER_F_UP		= 0,	/* up and active */
@@ -58,6 +59,7 @@ struct io_worker {
 
 	unsigned long create_state;
 	struct callback_head create_work;
+	int init_retries;
 
 	union {
 		struct rcu_head rcu;
@@ -745,7 +747,7 @@ static bool io_wq_work_match_all(struct io_wq_work *work, void *data)
 	return true;
 }
 
-static inline bool io_should_retry_thread(long err)
+static inline bool io_should_retry_thread(struct io_worker *worker, long err)
 {
 	/*
 	 * Prevent perpetual task_work retry, if the task (or its group) is
@@ -753,6 +755,8 @@ static inline bool io_should_retry_thread(long err)
 	 */
 	if (fatal_signal_pending(current))
 		return false;
+	if (worker->init_retries++ >= WORKER_INIT_LIMIT)
+		return false;
 
 	switch (err) {
 	case -EAGAIN:
@@ -779,7 +783,7 @@ static void create_worker_cont(struct callback_head *cb)
 		io_init_new_worker(wq, worker, tsk);
 		io_worker_release(worker);
 		return;
-	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+	} else if (!io_should_retry_thread(worker, PTR_ERR(tsk))) {
 		struct io_wq_acct *acct = io_wq_get_acct(worker);
 
 		atomic_dec(&acct->nr_running);
@@ -846,7 +850,7 @@ static bool create_io_worker(struct io_wq *wq, int index)
 	tsk = create_io_thread(io_wq_worker, worker, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
 		io_init_new_worker(wq, worker, tsk);
-	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+	} else if (!io_should_retry_thread(worker, PTR_ERR(tsk))) {
 		kfree(worker);
 		goto fail;
 	} else {
-- 
2.44.0


