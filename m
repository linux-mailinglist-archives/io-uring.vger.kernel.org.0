Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5002A249E31
	for <lists+io-uring@lfdr.de>; Wed, 19 Aug 2020 14:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgHSMiG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Aug 2020 08:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728249AbgHSMiB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Aug 2020 08:38:01 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D3CC061757;
        Wed, 19 Aug 2020 05:38:01 -0700 (PDT)
Date:   Wed, 19 Aug 2020 14:37:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597840679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=lwW59TWfLQL9/3bZCi/CgmH2rjvRhAnceBj2jd3SReo=;
        b=imGxWJhrhkFrnQ6z3tR+Tn958XvlBhli27vWGVVlvnb5U7529LWEvoBmnFzBrt9h+KvJzb
        J/Mi16BTNBaP0RDORRxDLgpxddkXb5gD+rmjgvE2WIrTdPdl4cfYYEZ/9QzGi7IQZ1FYMM
        XLzWdkNdAHqgU7t/6dZaHSTT3veW0NELHlDBrdVD++uBEW6+Puo6LPhvtFwOMLcWk2oAuC
        Zf1OB9ZrA8yFytDcs/+GHiWmniFMZMMIJkANU4Pd7D4JA05/OjLdNtd+KB6TLGHQRkx9bY
        L7Gbmdxj1Dh5CM+oK32cn0Ak6bA9oEQ1grOtb+lgIgQwe0aI8OORV+NWMyrV7w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597840679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=lwW59TWfLQL9/3bZCi/CgmH2rjvRhAnceBj2jd3SReo=;
        b=L96aS3EG2/dopYg65zffBoCQs2OJ3KlrwOAI5sFEBi2GymemUk0tDk5n9DAPYbj0sZWHE1
        U8+k+5QFGSljGJCg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH] sched: Invoke io_wq_worker_sleeping() with enabled
 preemption
Message-ID: <20200819123758.6v45rj2gvojddsnn@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

During a context switch the scheduler invokes wq_worker_sleeping() with
disabled preemption. Disabling preemption is needed because it protects
access to `worker->sleeping'. As an optimisation it avoids invoking
schedule() within the schedule path as part of possible wake up (thus
preempt_enable_no_resched() afterwards).

The io-wq has been added to the mix in the same section with disabled
preemption. This breaks on PREEMPT_RT because io_wq_worker_sleeping()
acquires a spinlock_t. Also within the schedule() the spinlock_t must be
acquired after tsk_is_pi_blocked() otherwise it will block on the sleeping lock
again while scheduling out.

While playing with `io_uring-bench' I didn't notice a significant
latency spike after converting io_wqe::lock to a raw_spinlock_t. The
latency was more or less the same.

I don't see a significant reason why this lock should become a
raw_spinlock_t therefore I suggest to move it after the
tsk_is_pi_blocked() check.
The io_worker::flags are usually modified under the lock except in the
scheduler path. Ideally the lock is always acquired since the
IO_WORKER_F_UP flag is set early in the startup and IO_WORKER_F_RUNNING
should be set unless the task loops within schedule(). I *think* ::flags
requires the same protection like workqueue's ::sleeping and therefore I
move the check within the locked section.

Any feedback on this vs raw_spinlock_t?

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 fs/io-wq.c          |  8 ++++----
 kernel/sched/core.c | 10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index e92c4724480ca..a7e07b3ac5b95 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -623,15 +623,15 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 	struct io_worker *worker = kthread_data(tsk);
 	struct io_wqe *wqe = worker->wqe;
 
+	spin_lock_irq(&wqe->lock);
 	if (!(worker->flags & IO_WORKER_F_UP))
-		return;
+		goto out;
 	if (!(worker->flags & IO_WORKER_F_RUNNING))
-		return;
+		goto out;
 
 	worker->flags &= ~IO_WORKER_F_RUNNING;
-
-	spin_lock_irq(&wqe->lock);
 	io_wqe_dec_running(wqe, worker);
+out:
 	spin_unlock_irq(&wqe->lock);
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3bbb60b97c73c..b76c0f27bd95e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4694,18 +4694,18 @@ static inline void sched_submit_work(struct task_struct *tsk)
 	 * in the possible wakeup of a kworker and because wq_worker_sleeping()
 	 * requires it.
 	 */
-	if (tsk->flags & (PF_WQ_WORKER | PF_IO_WORKER)) {
+	if (tsk->flags & PF_WQ_WORKER) {
 		preempt_disable();
-		if (tsk->flags & PF_WQ_WORKER)
-			wq_worker_sleeping(tsk);
-		else
-			io_wq_worker_sleeping(tsk);
+		wq_worker_sleeping(tsk);
 		preempt_enable_no_resched();
 	}
 
 	if (tsk_is_pi_blocked(tsk))
 		return;
 
+	if (tsk->flags & PF_IO_WORKER)
+		io_wq_worker_sleeping(tsk);
+
 	/*
 	 * If we are going to sleep and we have plugged IO queued,
 	 * make sure to submit it to avoid deadlocks.
-- 
2.28.0

