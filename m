Return-Path: <io-uring+bounces-6289-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C54CA2B548
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2025 23:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0F3B166F75
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2025 22:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6987219CC36;
	Thu,  6 Feb 2025 22:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="YO3dbOV6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f227.google.com (mail-il1-f227.google.com [209.85.166.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109D123C380
	for <io-uring@vger.kernel.org>; Thu,  6 Feb 2025 22:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881563; cv=none; b=DAM0+PazlVxDzY5IMAbGuYtMypnsBXeSgFx6NAb9kq6asz0eBfQVdolYjh681MyUb9obVJyzQCqIArd7QyRcC/6vfqqtPqSvbuekBKPgM5MZAItjKacO9FtFbuGZPrdEwKHrGI08dG+9R0/ABDJO6iooclfEVfYgMddgf+Az/LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881563; c=relaxed/simple;
	bh=Nrg0g1NU//t049z0PlkNMbyoN3JRs+gc/YpabR/RWEE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=kZlMxgA8hT2dF5HNevXhleumdAirw1q41Uu0gmIDOnkiHOcm5hw8xATyGBxNVdiP2CPFClSZ6DxH9lDCLd4qnrhzAy9bEiPECo7J9xlIPy4B79hqNLfV8jNRHpjSGcr44yyaQnyjYMuTf22XYMdOIwr/QClNOVu7WS9eGHNfvc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=YO3dbOV6; arc=none smtp.client-ip=209.85.166.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-il1-f227.google.com with SMTP id e9e14a558f8ab-3ce886a2d5bso12513545ab.1
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2025 14:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1738881560; x=1739486360; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zhBeQh7Zdw/l4mcGmN2xzJz9jOXegs73RTrIYNhiVUE=;
        b=YO3dbOV6V1HHttrBpZqoMntKfHUnCx7lRwXWf0NyLAmWLba6TmSYPN9v4CQ5eCP5tw
         OOtReEoEsDJrMixq4OQsRqjYRqeP8UeR/0KTuSDjcaChvIpm2REgV5MCGKSAdEP0DeCs
         UAmNbgvac6TU4wQfIFsOie5sq3rizkboeXNrkNfX5bMjdOjzq6mRriQcudPxpLw+/L8e
         t9DREBcuPZsXP3gQOwC7fA4EazGcjbBqx+1NSwGj7zQm2OZ2RQZf7kt9kSdCpS65ZHxg
         0UDwUfEi2FmJfxGw7vH2HpKlGXyJxpnXBjzj/ul23/zzzlVoBp6wCQ9QGwiUKm7diFP2
         sBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738881560; x=1739486360;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zhBeQh7Zdw/l4mcGmN2xzJz9jOXegs73RTrIYNhiVUE=;
        b=rd6rHsegxIhf1juAgH77OPReF035wKG+dWc3W0SU3iPRAB6gtm2zKRA3MtbuVxeofp
         5dBToJgpyYPMRui7kQpuYqZq3BORVrE5RLq6soYC4ygsvTq31QCmV5qd6RYttT2XhnuQ
         CLncKhs+oo/6iy/Ik0GQjlagWnmr8Ad8dsSe7Xq/17URTlBZRfGWcVJ+GFHq4aumgSrp
         6py6W7LHtr1B2ZxBOog82eHnUqtjGNI18BUP6JhBHXL9HL38d66I09t+tyd8gK+qeg5P
         /Q8gokFbIa3cCHnvjqwKRG0b2JsDWDKSxtXnpjrwhhaJqgHNkM4WJGICVPt33H68hX/l
         agSQ==
X-Gm-Message-State: AOJu0YzqLHOk01BfpxJrJJM50PNfjxiK645pZlndWEpUI4yOYF3nKc0k
	ausd/tdjijkj+HII0OX5S3equ2QJWMge/3G7LNcdYRvsh5sstw2HBEJVnyqg5iM3YMv/2bXJnsN
	kZJtRWjIp9RPgSixwcZrshp69LqAY+TMk
X-Gm-Gg: ASbGncvU4oSK8llj0KgCnRxLm5nK/DnBwmoVyNZZ5PhLNDFPix3qz4/YsDUy1DP2eC7
	/abjTKL7ONleP/MNhkyT8D96xqVfUnIKQNybAAqV4wKZLeFcgy/sy9eh533qoeUBMsoKiVAKQPK
	nlvki+cjGvawjT5OPnROfN9WcE4MJCJwvvIHPYDinebwNM9ANf3OOTa5uyzjroh0I4swdoitkSc
	bLJ93M3IfV1OWujx0S2ZoDU9RqST9eWq75PP0RmKXy/S7onHLtFdmzYg2AcqNp3GF+2C4Dghk26
	s2FVTwUFvQf9SPYOY3kqSOOzNgmIbzpfPb3UfsE=
X-Google-Smtp-Source: AGHT+IF6mtXYoU8DcSicBlQPvfysMyAzXQooMtAXlC4iKsFOHbacr4uMJSDjzn5dyhKUiGO+TZmDEYKs5nlr
X-Received: by 2002:a05:6e02:1d8d:b0:3d0:4e0c:2c96 with SMTP id e9e14a558f8ab-3d13de77ae3mr6812215ab.2.1738881560004;
        Thu, 06 Feb 2025 14:39:20 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3d05e8d9272sm1422705ab.1.2025.02.06.14.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 14:39:19 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-ushankar.dev.purestorage.com (dev-ushankar.dev.purestorage.com [IPv6:2620:125:9007:640:7:70:36:0])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 59E8C34014E;
	Thu,  6 Feb 2025 15:39:18 -0700 (MST)
Received: by dev-ushankar.dev.purestorage.com (Postfix, from userid 1557716368)
	id 4EFFEE55F7E; Thu,  6 Feb 2025 15:39:18 -0700 (MST)
From: Uday Shankar <ushankar@purestorage.com>
Date: Thu, 06 Feb 2025 15:38:53 -0700
Subject: [PATCH] io-wq: backoff when retrying worker creation
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250206-wq_retry-v1-1-6d79bde1e69f@purestorage.com>
X-B4-Tracking: v=1; b=H4sIAPw5pWcC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDIwMz3fLC+KLUkqJKXcPkJPM002RDS2PTFCWg8oKi1LTMCrBR0bG1tQC
 5rjn7WgAAAA==
X-Change-ID: 20250206-wq_retry-1cb7f5c1935d
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>
X-Mailer: b4 0.14.2

When io_uring submission goes async for the first time on a given task,
we'll try to create a worker thread to handle the submission. Creating
this worker thread can fail due to various transient conditions, such as
an outstanding signal in the forking thread, so we have retry logic with
a limit of 3 retries. However, this retry logic appears to be too
aggressive/fast - we've observed a thread blowing through the retry
limit while having the same outstanding signal the whole time. Here's an
excerpt of some tracing that demonstrates the issue:

First, signal 26 is generated for the process. It ends up getting routed
to thread 92942.

 0)   cbd-92284    /* signal_generate: sig=26 errno=0 code=-2 comm=psblkdASD pid=92934 grp=1 res=0 */

This causes create_io_thread in the signalled thread to fail with
ERESTARTNOINTR, and thus a retry is queued.

13) task_th-92942  /* io_uring_queue_async_work: ring 000000007325c9ae, request 0000000080c96d8e, user_data 0x0, opcode URING_CMD, flags 0x8240001, normal queue, work 000000006e96dd3f */
13) task_th-92942  io_wq_enqueue() {
13) task_th-92942    _raw_spin_lock();
13) task_th-92942    io_wq_activate_free_worker();
13) task_th-92942    _raw_spin_lock();
13) task_th-92942    create_io_worker() {
13) task_th-92942      __kmalloc_cache_noprof();
13) task_th-92942      __init_swait_queue_head();
13) task_th-92942      kprobe_ftrace_handler() {
13) task_th-92942        get_kprobe();
13) task_th-92942        aggr_pre_handler() {
13) task_th-92942          pre_handler_kretprobe();
13) task_th-92942          /* create_enter: (create_io_thread+0x0/0x50) fn=0xffffffff8172c0e0 arg=0xffff888996bb69c0 node=-1 */
13) task_th-92942        } /* aggr_pre_handler */
...
13) task_th-92942        } /* copy_process */
13) task_th-92942      } /* create_io_thread */
13) task_th-92942      kretprobe_rethook_handler() {
13) task_th-92942        /* create_exit: (create_io_worker+0x8a/0x1a0 <- create_io_thread) arg1=0xfffffffffffffdff */
13) task_th-92942      } /* kretprobe_rethook_handler */
13) task_th-92942    queue_work_on() {
...

The CPU is then handed to a kworker to process the queued retry:

------------------------------------------
 13) task_th-92942  => kworker-54154
------------------------------------------
13) kworker-54154  io_workqueue_create() {
13) kworker-54154    io_queue_worker_create() {
13) kworker-54154      task_work_add() {
13) kworker-54154        wake_up_state() {
13) kworker-54154          try_to_wake_up() {
13) kworker-54154            _raw_spin_lock_irqsave();
13) kworker-54154            _raw_spin_unlock_irqrestore();
13) kworker-54154          } /* try_to_wake_up */
13) kworker-54154        } /* wake_up_state */
13) kworker-54154        kick_process();
13) kworker-54154      } /* task_work_add */
13) kworker-54154    } /* io_queue_worker_create */
13) kworker-54154  } /* io_workqueue_create */

And then we immediately switch back to the original task to try creating
a worker again. This fails, because the original task still hasn't
handled its signal.

-----------------------------------------
 13) kworker-54154  => task_th-92942
------------------------------------------
13) task_th-92942  create_worker_cont() {
13) task_th-92942    kprobe_ftrace_handler() {
13) task_th-92942      get_kprobe();
13) task_th-92942      aggr_pre_handler() {
13) task_th-92942        pre_handler_kretprobe();
13) task_th-92942        /* create_enter: (create_io_thread+0x0/0x50) fn=0xffffffff8172c0e0 arg=0xffff888996bb69c0 node=-1 */
13) task_th-92942      } /* aggr_pre_handler */
13) task_th-92942    } /* kprobe_ftrace_handler */
13) task_th-92942    create_io_thread() {
13) task_th-92942      copy_process() {
13) task_th-92942        task_active_pid_ns();
13) task_th-92942        _raw_spin_lock_irq();
13) task_th-92942        recalc_sigpending();
13) task_th-92942        _raw_spin_lock_irq();
13) task_th-92942      } /* copy_process */
13) task_th-92942    } /* create_io_thread */
13) task_th-92942    kretprobe_rethook_handler() {
13) task_th-92942      /* create_exit: (create_worker_cont+0x35/0x1b0 <- create_io_thread) arg1=0xfffffffffffffdff */
13) task_th-92942    } /* kretprobe_rethook_handler */
13) task_th-92942    io_worker_release();
13) task_th-92942    queue_work_on() {
13) task_th-92942      clear_pending_if_disabled();
13) task_th-92942      __queue_work() {
13) task_th-92942      } /* __queue_work */
13) task_th-92942    } /* queue_work_on */
13) task_th-92942  } /* create_worker_cont */

The pattern repeats another couple times until we blow through the retry
counter, at which point we give up. All outstanding work is canceled,
and the io_uring command which triggered all this is failed with
ECANCELED:

13) task_th-92942  io_acct_cancel_pending_work() {
...
13) task_th-92942  /* io_uring_complete: ring 000000007325c9ae, req 0000000080c96d8e, user_data 0x0, result -125, cflags 0x0 extra1 0 extra2 0  */

Finally, the task gets around to processing its outstanding signal 26,
but it's too late.

13) task_th-92942  /* signal_deliver: sig=26 errno=0 code=-2 sa_handler=59566a0 sa_flags=14000000 */

Try to address this issue by adding a small scaling delay when retrying
worker creation. This should give the forking thread time to handle its
signal in the above case. This isn't a particularly satisfying solution,
as sufficiently paradoxical scheduling would still have us hitting the
same issue, and I'm open to suggestions for something better. But this
is likely to prevent this (already rare) issue from hitting in practice.

Signed-off-by: Uday Shankar <ushankar@purestorage.com>
---
 io_uring/io-wq.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index f7d328feb7225d809601707e423c86a85ebb1c3c..173c77b70060bbbb2cd6009614c079095fab3e3c 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -63,7 +63,7 @@ struct io_worker {
 
 	union {
 		struct rcu_head rcu;
-		struct work_struct work;
+		struct delayed_work work;
 	};
 };
 
@@ -784,6 +784,18 @@ static inline bool io_should_retry_thread(struct io_worker *worker, long err)
 	}
 }
 
+static void queue_create_worker_retry(struct io_worker *worker)
+{
+	/*
+	 * We only bother retrying because there's a chance that the
+	 * failure to create a worker is due to some temporary condition
+	 * in the forking task (e.g. outstanding signal); give the task
+	 * some time to clear that condition.
+	 */
+	schedule_delayed_work(
+		&worker->work, msecs_to_jiffies(worker->init_retries * 5));
+}
+
 static void create_worker_cont(struct callback_head *cb)
 {
 	struct io_worker *worker;
@@ -823,12 +835,13 @@ static void create_worker_cont(struct callback_head *cb)
 
 	/* re-create attempts grab a new worker ref, drop the existing one */
 	io_worker_release(worker);
-	schedule_work(&worker->work);
+	queue_create_worker_retry(worker);
 }
 
 static void io_workqueue_create(struct work_struct *work)
 {
-	struct io_worker *worker = container_of(work, struct io_worker, work);
+	struct io_worker *worker = container_of(
+		work, struct io_worker, work.work);
 	struct io_wq_acct *acct = io_wq_get_acct(worker);
 
 	if (!io_queue_worker_create(worker, acct, create_worker_cont))
@@ -866,8 +879,8 @@ static bool create_io_worker(struct io_wq *wq, struct io_wq_acct *acct)
 		kfree(worker);
 		goto fail;
 	} else {
-		INIT_WORK(&worker->work, io_workqueue_create);
-		schedule_work(&worker->work);
+		INIT_DELAYED_WORK(&worker->work, io_workqueue_create);
+		queue_create_worker_retry(worker);
 	}
 
 	return true;

---
base-commit: ec4ef55172d4539abff470568a4369a6e1c317b8
change-id: 20250206-wq_retry-1cb7f5c1935d

Best regards,
-- 
Uday Shankar <ushankar@purestorage.com>


