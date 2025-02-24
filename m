Return-Path: <io-uring+bounces-6654-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1123A41C89
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 12:23:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45BA73BB696
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 11:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B9F2627EF;
	Mon, 24 Feb 2025 11:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FY7KiyEc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7B92627EA;
	Mon, 24 Feb 2025 11:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740395864; cv=none; b=sH2EZZR7dhJc0mfnvnckpShyD2qEkNlMp2S+Rr4bQ2kmZqOIDBgkdVdezvuDErHFa2R+dkjaUL+C+1RkCt7DhokL/1XIxdJ/cbQpAzNQMuiIEX8u9rMNonwPOBDQsrAmYbcrb2N9VhsCj0ox233RN0yC3UTeaRl5qeahFK8wuMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740395864; c=relaxed/simple;
	bh=+feFKXjzyb6cPuFwFoOgFVXkqXP4xv+KmHIxH9YIDQM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ib76O9FFRBXPl6IZvkHRrVQ4VxMhnp7lChPoaFAP4sqZ7iI4cB0eXXbTVTFkgyvLKX6K9S+DMQb+9exNqdxJ50RkKTrY3954cb2dyBdkYLUs1RG23wVkE90NsO3OELMT5gwPzbKeWf2p1G+Zch4bhKBOCaoZYyLVhEXDkwI4uec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FY7KiyEc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7587BC4CED6;
	Mon, 24 Feb 2025 11:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740395863;
	bh=+feFKXjzyb6cPuFwFoOgFVXkqXP4xv+KmHIxH9YIDQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FY7KiyEcFxDnrsQEgsIbzed1ECchMYx+90KsWmN6fKEBz3GbbxmWGww/5D6YK7WIO
	 ECg6nvbs345wIFuGYq9jA9kSwagdN3sDEgW1/qd05wk+1JLSaFpp33yi16q5bezzOG
	 7inEbfO3AkD/BI3C5lBcb41V1kZlWpLrcZnHRZLidMv0/tv1Lr4MdHdXkDrqhASU7M
	 yo/Y7hIr7JXWth7RjxiHRR5f6J+CKQ5XD71D9u+NRS2QkDRJC9cnM7DR8njEPEO3Jp
	 WOJBQc42yNBDK3GE8hLpE8aeOPLCRFMhhMGe2irD28d0ZsqzS+n/iRLLPO0sdQmOsV
	 eynrrNEzDOurQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Uday Shankar <ushankar@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.13 22/32] io-wq: backoff when retrying worker creation
Date: Mon, 24 Feb 2025 06:16:28 -0500
Message-Id: <20250224111638.2212832-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250224111638.2212832-1-sashal@kernel.org>
References: <20250224111638.2212832-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13.4
Content-Transfer-Encoding: 8bit

From: Uday Shankar <ushankar@purestorage.com>

[ Upstream commit 13918315c5dc5a515926c8799042ea6885c2b734 ]

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
Link: https://lore.kernel.org/r/20250208-wq_retry-v2-1-4f6f5041d303@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index a38f36b680604..a2d577b099308 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -64,7 +64,7 @@ struct io_worker {
 
 	union {
 		struct rcu_head rcu;
-		struct work_struct work;
+		struct delayed_work work;
 	};
 };
 
@@ -770,6 +770,18 @@ static inline bool io_should_retry_thread(struct io_worker *worker, long err)
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
+	schedule_delayed_work(&worker->work,
+			      msecs_to_jiffies(worker->init_retries * 5));
+}
+
 static void create_worker_cont(struct callback_head *cb)
 {
 	struct io_worker *worker;
@@ -809,12 +821,13 @@ static void create_worker_cont(struct callback_head *cb)
 
 	/* re-create attempts grab a new worker ref, drop the existing one */
 	io_worker_release(worker);
-	schedule_work(&worker->work);
+	queue_create_worker_retry(worker);
 }
 
 static void io_workqueue_create(struct work_struct *work)
 {
-	struct io_worker *worker = container_of(work, struct io_worker, work);
+	struct io_worker *worker = container_of(work, struct io_worker,
+						work.work);
 	struct io_wq_acct *acct = io_wq_get_acct(worker);
 
 	if (!io_queue_worker_create(worker, acct, create_worker_cont))
@@ -855,8 +868,8 @@ static bool create_io_worker(struct io_wq *wq, int index)
 		kfree(worker);
 		goto fail;
 	} else {
-		INIT_WORK(&worker->work, io_workqueue_create);
-		schedule_work(&worker->work);
+		INIT_DELAYED_WORK(&worker->work, io_workqueue_create);
+		queue_create_worker_retry(worker);
 	}
 
 	return true;
-- 
2.39.5


