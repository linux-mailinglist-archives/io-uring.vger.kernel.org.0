Return-Path: <io-uring+bounces-820-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FEA2870B53
	for <lists+io-uring@lfdr.de>; Mon,  4 Mar 2024 21:17:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DBA0B2516F
	for <lists+io-uring@lfdr.de>; Mon,  4 Mar 2024 20:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA90B7BAFB;
	Mon,  4 Mar 2024 20:17:17 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89CB843AC3;
	Mon,  4 Mar 2024 20:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709583437; cv=none; b=hJS8TUjXpk4IQwYe+dvGdKq/O+3uFlGJO6Um0YWKXeFT7X6Q/Vmn92hYYLj4QjOoJrsV+/zplBfdLNvl9qTMc2IMdmy0Sgx3zn89YDUlVPEuQ14Fo4bJoRgqA4XTUYUshgFUezTZ0/QEFiOz5+Rce34r3zPU6w5Nvu1lRRiWcjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709583437; c=relaxed/simple;
	bh=nDzguq2wc/kTCus2xPytgWUMDNinZnJBVesDHn/3zxA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HoGyBiGxlu5Df6eGl80yNtDU5HfPhl5daJixRiU/UF2939WZ9L1QWvA3FJhU7ovSt2UqD1HFsL4x6kFpwRUiq7iZo9wt9YQCWflIxL3EEaKHjWhS9xhwDTdntmHQmCx8ekUpDDGJ5lF/IqcfjO4k6eKR/YKJ/fL9oR7+5LoheaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAF03FEC;
	Mon,  4 Mar 2024 12:17:45 -0800 (PST)
Received: from e133047.arm.com (unknown [10.57.95.7])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4EB053F738;
	Mon,  4 Mar 2024 12:17:05 -0800 (PST)
From: Christian Loehle <christian.loehle@arm.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	juri.lelli@redhat.com,
	mingo@redhat.com,
	rafael@kernel.org,
	dietmar.eggemann@arm.com,
	vschneid@redhat.com,
	vincent.guittot@linaro.org,
	Johannes.Thumshirn@wdc.com,
	adrian.hunter@intel.com,
	ulf.hansson@linaro.org,
	andres@anarazel.de,
	asml.silence@gmail.com,
	linux-pm@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	Christian Loehle <christian.loehle@arm.com>
Subject: [RFC PATCH 1/2] sched/fair: Introduce per-task io util boost
Date: Mon,  4 Mar 2024 20:16:24 +0000
Message-Id: <20240304201625.100619-2-christian.loehle@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240304201625.100619-1-christian.loehle@arm.com>
References: <20240304201625.100619-1-christian.loehle@arm.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement an io boost utilization enhancement that is tracked for each
task_struct. Tasks that wake up from in_iowait frequently will have
a io_boost associated with them, which counts iowait wakeups and only
boosts when it seems to improve the per-task throughput.

The patch is intended to replace the current iowait boosting strategy,
implemented in both schedutil and intel_pstate which boost the CPU for
iowait wakeups on the rq.
The primary benefits are:
1. EAS can take the io boost into account.
2. Boosting is limited when it doesn't seem to improve throughput.
3. io boost is being carried with the task when it migrates.

This is implemented by observing the iowait wakeups for an interval.
The boost is divided into 8 levels. If the task achieves the
required number of iowait wakeups per interval it's boost level is
increased.
To reflect that we can't expect an increase of iowait wakeups linear
to the applied boost (the time the task spends in iowait isn't
decreased by boosting) we scale the intervals.
Intervals for the lower boost levels are shorter, also allowing for
a faster ramp up.

If multiple tasks are io-boosted their boost will be max-aggregated
per rq. The energy calculations of EAS have been adapted to reflect
this.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
---
 include/linux/sched.h            |  15 +++
 kernel/sched/cpufreq_schedutil.c |   6 ++
 kernel/sched/fair.c              | 165 +++++++++++++++++++++++++++++--
 kernel/sched/sched.h             |   4 +-
 4 files changed, 181 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ffe8f618ab86..4e0dfa6fbd65 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1547,6 +1547,21 @@ struct task_struct {
 	struct user_event_mm		*user_event_mm;
 #endif
 
+	/* IO boost tracking */
+	u64		io_boost_timeout;
+	u64		io_boost_interval_start;
+#define IO_BOOST_INTERVAL_MSEC	25
+/* Require 1000 iowait wakeups per second to start the boosting */
+#define IO_BOOST_IOWAITS_MIN	(IO_BOOST_INTERVAL_MSEC)
+#define IO_BOOST_LEVELS		8
+/* The util boost given to the task per io boost level, account for headroom */
+#define IO_BOOST_UTIL_STEP		((unsigned long)((SCHED_CAPACITY_SCALE / 1.25) / IO_BOOST_LEVELS))
+#define IO_BOOST_IOWAITS_STEP		5
+	/* Minimum number of iowaits per interval to maintain current boost */
+	unsigned int	io_boost_threshold_down;
+	unsigned int	io_boost_level;
+	unsigned int	io_boost_curr_ios;
+
 	/*
 	 * New fields for task_struct should be added above here, so that
 	 * they are included in the randomized portion of task_struct.
diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index eece6244f9d2..cd0ca3cbd212 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -198,7 +198,13 @@ unsigned long sugov_effective_cpu_perf(int cpu, unsigned long actual,
 static void sugov_get_util(struct sugov_cpu *sg_cpu, unsigned long boost)
 {
 	unsigned long min, max, util = cpu_util_cfs_boost(sg_cpu->cpu);
+	unsigned long io_boost = cpu_util_io_boost(sg_cpu->cpu);
 
+	/*
+	 * XXX: This already includes io boost now, makes little sense with
+	 * sugov iowait boost on top
+	 */
+	util = max(util, io_boost);
 	util = effective_cpu_util(sg_cpu->cpu, util, &min, &max);
 	util = max(util, boost);
 	sg_cpu->bw_min = min;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 533547e3c90a..b983e4399c53 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4959,6 +4959,11 @@ static inline void util_est_update(struct cfs_rq *cfs_rq,
 	trace_sched_util_est_se_tp(&p->se);
 }
 
+static inline unsigned int io_boost_util(struct task_struct *p)
+{
+	return p->io_boost_level * IO_BOOST_UTIL_STEP;
+}
+
 static inline int util_fits_cpu(unsigned long util,
 				unsigned long uclamp_min,
 				unsigned long uclamp_max,
@@ -6695,6 +6700,137 @@ static int sched_idle_cpu(int cpu)
 }
 #endif
 
+static unsigned long io_boost_rq(struct cfs_rq *cfs_rq)
+{
+	int i;
+
+	for (i = IO_BOOST_LEVELS; i > 0; i--)
+		if (atomic_read(&cfs_rq->io_boost_tasks[i - 1]))
+			return i * IO_BOOST_UTIL_STEP;
+	return 0;
+}
+
+static inline unsigned long io_boost_interval_nsec(unsigned int io_boost_level)
+{
+	/*
+	 * We require 5 iowaits per interval increase to consider the boost
+	 * worth having, that leads to:
+	 * level 0->1:   25ms -> 200 iowaits per second increase
+	 * level 1->2:   50ms -> 125 iowaits per second increase
+	 * level 2->3:   75ms ->  66 iowaits per second increase
+	 * level 3->4:  100ms ->  50 iowaits per second increase
+	 * level 4->5:  125ms ->  40 iowaits per second increase
+	 * level 5->6:  150ms ->  33 iowaits per second increase
+	 * level 6->7:  175ms ->  28 iowaits per second increase
+	 * level 7->8:  200ms ->  25 iowaits per second increase
+	 * => level 8 can be maintained with >=1567 iowaits per second.
+	 */
+	return (io_boost_level + 1) * IO_BOOST_INTERVAL_MSEC * NSEC_PER_MSEC;
+}
+
+static inline void io_boost_scale_interval(struct task_struct *p, bool inc)
+{
+	unsigned int level = p->io_boost_level + (inc ? 1 : -1);
+
+	p->io_boost_level = level;
+	/* We change interval length, scale iowaits per interval accordingly. */
+	if (inc)
+		p->io_boost_threshold_down = (p->io_boost_curr_ios *
+			(level + 1) / level) + IO_BOOST_IOWAITS_STEP;
+	else
+		p->io_boost_threshold_down = (p->io_boost_curr_ios *
+			level / (level + 1)) - IO_BOOST_IOWAITS_STEP;
+}
+
+static void enqueue_io_boost(struct cfs_rq *cfs_rq, struct task_struct *p)
+{
+	u64 now = sched_clock();
+
+	/* Only what's necessary here because this is the critical path */
+	if (now > p->io_boost_timeout) {
+		/* Last iowait took too long, reset boost */
+		p->io_boost_interval_start = 0;
+		p->io_boost_level = 0;
+	}
+	if (p->io_boost_level)
+		atomic_inc(&cfs_rq->io_boost_tasks[p->io_boost_level - 1]);
+}
+
+static inline void io_boost_start_interval(struct task_struct *p, u64 now)
+{
+	p->io_boost_interval_start = now;
+	p->io_boost_curr_ios = 1;
+}
+
+static void dequeue_io_boost(struct cfs_rq *cfs_rq, struct task_struct *p)
+{
+	u64 now;
+
+	if (p->io_boost_level)
+		atomic_dec(&cfs_rq->io_boost_tasks[p->io_boost_level - 1]);
+
+	/*
+	 * Doing all this at dequeue instead of at enqueue might seem wrong,
+	 * but it really doesn't matter as the task won't be enqueued anywhere
+	 * anyway. At enqueue we then only need to check if the in_iowait
+	 * wasn't too long. We can then act as if the current in_iowait has
+	 * already completed 'in time'.
+	 * Doing all this at dequeue has a performance benefit as at this time
+	 * the io is issued and we aren't in the io critical path.
+	 */
+
+	if (!p->in_iowait) {
+		/* Even if no boost is active, we reset the interval */
+		p->io_boost_interval_start = 0;
+		p->io_boost_level = 0;
+		return;
+	}
+
+	/* The maximum in_iowait time we allow to continue boosting */
+	now = sched_clock();
+	p->io_boost_timeout = now + 10 * NSEC_PER_MSEC;
+
+	if (!p->io_boost_interval_start) {
+		io_boost_start_interval(p, now);
+		return;
+	}
+	p->io_boost_curr_ios++;
+
+	if (now < p->io_boost_interval_start +
+			io_boost_interval_nsec(p->io_boost_level))
+		return;
+
+	if (!p->io_boost_level) {
+		if (likely(p->io_boost_curr_ios < IO_BOOST_IOWAITS_MIN)) {
+			io_boost_start_interval(p, now);
+			return;
+		}
+		io_boost_scale_interval(p, true);
+	} else if (p->io_boost_curr_ios < IO_BOOST_IOWAITS_MIN) {
+		p->io_boost_level = 0;
+	} else if (p->io_boost_curr_ios > p->io_boost_threshold_down + IO_BOOST_IOWAITS_STEP) {
+		/* Increase boost */
+		if (p->io_boost_level < IO_BOOST_LEVELS)
+			io_boost_scale_interval(p, true);
+		else
+			p->io_boost_threshold_down =
+				p->io_boost_curr_ios - IO_BOOST_IOWAITS_STEP;
+	} else if (p->io_boost_curr_ios < p->io_boost_threshold_down) {
+		/* Reduce boost */
+		if (p->io_boost_level > 1)
+			io_boost_scale_interval(p, true);
+		else
+			p->io_boost_level = 0;
+	} else if (p->io_boost_level == IO_BOOST_LEVELS) {
+		/* Allow for reducing boost on max when conditions changed. */
+		p->io_boost_threshold_down = max(p->io_boost_threshold_down,
+				p->io_boost_curr_ios - IO_BOOST_IOWAITS_STEP);
+	}
+	/* On maintaining boost we just start a new interval. */
+
+	io_boost_start_interval(p, now);
+}
+
 /*
  * The enqueue_task method is called before nr_running is
  * increased. Here we update the fair scheduling stats and
@@ -6716,11 +6852,9 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	 */
 	util_est_enqueue(&rq->cfs, p);
 
-	/*
-	 * If in_iowait is set, the code below may not trigger any cpufreq
-	 * utilization updates, so do it here explicitly with the IOWAIT flag
-	 * passed.
-	 */
+	if (p->in_iowait || p->io_boost_interval_start)
+		enqueue_io_boost(&rq->cfs, p);
+	/* Ensure new io boost can be applied. */
 	if (p->in_iowait)
 		cpufreq_update_util(rq, SCHED_CPUFREQ_IOWAIT);
 
@@ -6804,6 +6938,8 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 	util_est_dequeue(&rq->cfs, p);
 
+	dequeue_io_boost(&rq->cfs, p);
+
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
@@ -7429,11 +7565,13 @@ select_idle_capacity(struct task_struct *p, struct sched_domain *sd, int target)
 	int fits, best_fits = 0;
 	int cpu, best_cpu = -1;
 	struct cpumask *cpus;
+	unsigned long io_boost = io_boost_util(p);
 
 	cpus = this_cpu_cpumask_var_ptr(select_rq_mask);
 	cpumask_and(cpus, sched_domain_span(sd), p->cpus_ptr);
 
 	task_util = task_util_est(p);
+	task_util = max(task_util, io_boost);
 	util_min = uclamp_eff_value(p, UCLAMP_MIN);
 	util_max = uclamp_eff_value(p, UCLAMP_MAX);
 
@@ -7501,7 +7639,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	 */
 	if (sched_asym_cpucap_active()) {
 		sync_entity_load_avg(&p->se);
-		task_util = task_util_est(p);
+		task_util = max(task_util_est(p), io_boost_util(p));
 		util_min = uclamp_eff_value(p, UCLAMP_MIN);
 		util_max = uclamp_eff_value(p, UCLAMP_MAX);
 	}
@@ -7615,12 +7753,17 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	return target;
 }
 
+unsigned long cpu_util_io_boost(int cpu)
+{
+	return io_boost_rq(&cpu_rq(cpu)->cfs);
+}
+
 /**
  * cpu_util() - Estimates the amount of CPU capacity used by CFS tasks.
  * @cpu: the CPU to get the utilization for
  * @p: task for which the CPU utilization should be predicted or NULL
  * @dst_cpu: CPU @p migrates to, -1 if @p moves from @cpu or @p == NULL
- * @boost: 1 to enable boosting, otherwise 0
+ * @boost: 1 to enable runnable boosting, otherwise 0
  *
  * The unit of the return value must be the same as the one of CPU capacity
  * so that CPU utilization can be compared with CPU capacity.
@@ -7843,8 +7986,10 @@ eenv_pd_max_util(struct energy_env *eenv, struct cpumask *pd_cpus,
 	for_each_cpu(cpu, pd_cpus) {
 		struct task_struct *tsk = (cpu == dst_cpu) ? p : NULL;
 		unsigned long util = cpu_util(cpu, p, dst_cpu, 1);
+		unsigned long io_boost = max(io_boost_util(p), cpu_util_io_boost(cpu));
 		unsigned long eff_util, min, max;
 
+		util = max(util, io_boost);
 		/*
 		 * Performance domain frequency: utilization clamping
 		 * must be considered since it affects the selection
@@ -7970,7 +8115,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 	target = prev_cpu;
 
 	sync_entity_load_avg(&p->se);
-	if (!task_util_est(p) && p_util_min == 0)
+	if (!task_util_est(p) && p_util_min == 0 && io_boost_util(p) == 0)
 		goto unlock;
 
 	eenv_task_busy_time(&eenv, p, prev_cpu);
@@ -7983,6 +8128,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		unsigned long cur_delta, base_energy;
 		int max_spare_cap_cpu = -1;
 		int fits, max_fits = -1;
+		unsigned long p_io_boost = io_boost_util(p);
 
 		cpumask_and(cpus, perf_domain_span(pd), cpu_online_mask);
 
@@ -7999,6 +8145,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 
 		for_each_cpu(cpu, cpus) {
 			struct rq *rq = cpu_rq(cpu);
+			unsigned long io_boost;
 
 			eenv.pd_cap += cpu_thermal_cap;
 
@@ -8009,6 +8156,8 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 				continue;
 
 			util = cpu_util(cpu, p, cpu, 0);
+			io_boost = max(p_io_boost, cpu_util_io_boost(cpu));
+			util = max(util, io_boost);
 			cpu_cap = capacity_of(cpu);
 
 			/*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 001fe047bd5d..5f42b72b3cde 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -598,6 +598,8 @@ struct cfs_rq {
 	struct sched_entity	*curr;
 	struct sched_entity	*next;
 
+	atomic_t		io_boost_tasks[IO_BOOST_LEVELS];
+
 #ifdef	CONFIG_SCHED_DEBUG
 	unsigned int		nr_spread_over;
 #endif
@@ -3039,7 +3041,7 @@ static inline unsigned long cpu_util_dl(struct rq *rq)
 	return READ_ONCE(rq->avg_dl.util_avg);
 }
 
-
+extern unsigned long cpu_util_io_boost(int cpu);
 extern unsigned long cpu_util_cfs(int cpu);
 extern unsigned long cpu_util_cfs_boost(int cpu);
 
-- 
2.34.1


