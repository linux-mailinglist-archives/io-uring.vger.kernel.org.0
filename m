Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7546A24A75C
	for <lists+io-uring@lfdr.de>; Wed, 19 Aug 2020 22:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgHSUAb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Aug 2020 16:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgHSUA3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Aug 2020 16:00:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8551CC061757;
        Wed, 19 Aug 2020 13:00:29 -0700 (PDT)
Date:   Wed, 19 Aug 2020 22:00:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597867227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mPBs5pdSA3FfAqeWx43GnTVjpf8tF34H+T0qVYbtE+4=;
        b=bpktalKZ2kUph9YQC0jcEp8FbhzO0INpTNF1a6OcTeqHTatA7amF8mPOd9kLwq+W8Y6kFG
        kUEDaQkFmzYR1T0TALGc4AGUu280nmQx+fu+JSSwtKvTq2xNWke+jXCNCM/A9vhnlPelSE
        wokEmMxjAIE+2mCljqNkMFaMB4DTx3jS84BzHWI8pduTaH5U/WCStqFJJ5K5aDvOm/pJ9m
        dFDnQRAHtNOW39n/pmTfbRmnCmZI/FBwpOveb4mkUTIamK7xUF7bGmsKALjyo+zOD1IxxO
        PoXHa9G3u2GqOm76ifUG+2XKcC7ea0BVSkfSu/GRAC5f+ddEp4SMLFCaEQBPuA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597867227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mPBs5pdSA3FfAqeWx43GnTVjpf8tF34H+T0qVYbtE+4=;
        b=u58pBXjH0qSlWt+/sknjW5QKrTUr/PCV1IOQijl+Y+9uxt1aWbrcaOOK30vT0B8s5ZHn7W
        81EFjQIlKhieSxBg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     peterz@infradead.org
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] sched: Cache task_struct::flags in sched_submit_work()
Message-ID: <20200819200025.lqvmyefqnbok5i4f@linutronix.de>
References: <20200819142134.GD2674@hirez.programming.kicks-ass.net>
 <20200819195505.y3fxk72sotnrkczi@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200819195505.y3fxk72sotnrkczi@linutronix.de>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

sched_submit_work() is considered to be a hot path. The preempt_disable()
instruction is a compiler barrier and forces the compiler to load
task_struct::flags for the second comparison.
By using a local variable, the compiler can load the value once and keep it in
a register for the second comparison.

Verified on x86-64 with gcc-10.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

Optimisation at molecule level, part two. Drop this in case this branch
isn't consider *that* hot and the cache hot value can be loaded again.
But then the value is around and be speculated early on :)

 kernel/sched/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8471a0f7eb322..c36dc1ae58beb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4551,9 +4551,12 @@ void __noreturn do_task_dead(void)
 
 static inline void sched_submit_work(struct task_struct *tsk)
 {
+	unsigned int task_flags;
+
 	if (!tsk->state)
 		return;
 
+	task_flags = tsk->flags;
 	/*
 	 * If a worker went to sleep, notify and ask workqueue whether
 	 * it wants to wake up a task to maintain concurrency.
@@ -4562,9 +4565,9 @@ static inline void sched_submit_work(struct task_struct *tsk)
 	 * in the possible wakeup of a kworker and because wq_worker_sleeping()
 	 * requires it.
 	 */
-	if (tsk->flags & (PF_WQ_WORKER | PF_IO_WORKER)) {
+	if (task_flags & (PF_WQ_WORKER | PF_IO_WORKER)) {
 		preempt_disable();
-		if (tsk->flags & PF_WQ_WORKER)
+		if (task_flags & PF_WQ_WORKER)
 			wq_worker_sleeping(tsk);
 		else
 			io_wq_worker_sleeping(tsk);
-- 
2.28.0

