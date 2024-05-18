Return-Path: <io-uring+bounces-1935-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF848C90AB
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 13:40:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2EA6282CD0
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 11:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EEE63A1B6;
	Sat, 18 May 2024 11:40:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E17B38F86;
	Sat, 18 May 2024 11:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716032431; cv=none; b=jfLJx8Fd+nWRACekYj1UeE8w26zRoRCya9lCNGQIwQexbCW5U1Wch6/ELwZHEdyHl5dUo+JigZDTzCJOv4uXPb/WMdUTI/Dh9Thgs/260d8Jnk2CLUfXg+y/Cfx57DCRvOC3VT6JHPqsb+IZnpbjc98XyqJCsWu+Vy4jNqiWurU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716032431; c=relaxed/simple;
	bh=o099f1CC2pXOjh7HHwaDT46zv4Dd0pYwEQtktxIdbO0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eKoXH7Nvm4dqIyeHx5XGA7Jp1L/KeYck1zpt31s2JitrmbEejS61se2t8ictE8dEwnW5k06yKSSC9LJvLguxW/rzGE/SmJoHQ6XGfeaNziUrSrJlajVD17GN6J71+5GzghWFgengnCx7UU5k4sVwWhVVApN1UWfO6t1qGDI1m/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DC2015BF;
	Sat, 18 May 2024 04:40:46 -0700 (PDT)
Received: from e127648.arm.com (unknown [10.57.69.234])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5C1253F641;
	Sat, 18 May 2024 04:40:18 -0700 (PDT)
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
	bvanassche@acm.org,
	andres@anarazel.de,
	asml.silence@gmail.com,
	linux-pm@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	qyousef@layalina.io,
	Christian Loehle <christian.loehle@arm.com>
Subject: [RFC PATCH v2 1/1] sched/fair: sugov: Introduce per-task io util boost
Date: Sat, 18 May 2024 12:39:47 +0100
Message-Id: <20240518113947.2127802-2-christian.loehle@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240518113947.2127802-1-christian.loehle@arm.com>
References: <20240518113947.2127802-1-christian.loehle@arm.com>
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
implemented in schedutil which boost the CPU for iowait wakeups on the
rq.
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

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
---
 include/linux/sched.h            |  10 ++
 kernel/sched/core.c              |   8 +-
 kernel/sched/cpufreq_schedutil.c | 258 ++++++++++++++++++++-----------
 kernel/sched/fair.c              |  37 +++--
 kernel/sched/sched.h             |  10 +-
 5 files changed, 218 insertions(+), 105 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c75fd46506df..f0aa62e18c54 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1551,6 +1551,16 @@ struct task_struct {
 	struct user_event_mm		*user_event_mm;
 #endif

+#ifdef CONFIG_CPU_FREQ_GOV_SCHEDUTIL
+	/* IO boost tracking */
+	u64		io_boost_timeout;
+	u64		io_boost_interval_start;
+	/* Minimum number of iowaits per interval to maintain current boost */
+	unsigned int	io_boost_threshold_down;
+	unsigned int	io_boost_level;
+	unsigned int	io_boost_curr_ios;
+#endif
+
 	/*
 	 * New fields for task_struct should be added above here, so that
 	 * they are included in the randomized portion of task_struct.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1a914388144a..a30ada2f45f3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1561,14 +1561,18 @@ uclamp_eff_get(struct task_struct *p, enum uclamp_id clamp_id)
 unsigned long uclamp_eff_value(struct task_struct *p, enum uclamp_id clamp_id)
 {
 	struct uclamp_se uc_eff;
+	unsigned long io_boost = 0;
+
+	if (clamp_id == UCLAMP_MIN && p->io_boost_level)
+		io_boost = sugov_io_boost_util(p);

 	/* Task currently refcounted: use back-annotated (effective) value */
 	if (p->uclamp[clamp_id].active)
-		return (unsigned long)p->uclamp[clamp_id].value;
+		return max_t(unsigned long, p->uclamp[clamp_id].value, io_boost);

 	uc_eff = uclamp_eff_get(p, clamp_id);

-	return (unsigned long)uc_eff.value;
+	return max_t(unsigned long, uc_eff.value, io_boost);
 }

 /*
diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index eece6244f9d2..4a598315961c 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -6,8 +6,6 @@
  * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
  */

-#define IOWAIT_BOOST_MIN	(SCHED_CAPACITY_SCALE / 8)
-
 struct sugov_tunables {
 	struct gov_attr_set	attr_set;
 	unsigned int		rate_limit_us;
@@ -42,7 +40,6 @@ struct sugov_cpu {
 	struct sugov_policy	*sg_policy;
 	unsigned int		cpu;

-	bool			iowait_boost_pending;
 	unsigned int		iowait_boost;
 	u64			last_update;

@@ -182,12 +179,18 @@ unsigned long sugov_effective_cpu_perf(int cpu, unsigned long actual,
 				 unsigned long min,
 				 unsigned long max)
 {
+	struct update_util_data *data = rcu_dereference_sched(*per_cpu_ptr(&cpufreq_update_util_data, cpu));
+	struct sugov_cpu *sg_cpu = container_of(data, struct sugov_cpu, update_util);
+
 	/* Add dvfs headroom to actual utilization */
 	actual = map_util_perf(actual);
 	/* Actually we don't need to target the max performance */
 	if (actual < max)
 		max = actual;

+	if (sg_cpu)
+		min = max(min, sg_cpu->iowait_boost);
+
 	/*
 	 * Ensure at least minimum performance while providing more compute
 	 * capacity when possible.
@@ -205,74 +208,27 @@ static void sugov_get_util(struct sugov_cpu *sg_cpu, unsigned long boost)
 	sg_cpu->util = sugov_effective_cpu_perf(sg_cpu->cpu, util, min, max);
 }

-/**
- * sugov_iowait_reset() - Reset the IO boost status of a CPU.
- * @sg_cpu: the sugov data for the CPU to boost
- * @time: the update time from the caller
- * @set_iowait_boost: true if an IO boost has been requested
- *
- * The IO wait boost of a task is disabled after a tick since the last update
- * of a CPU. If a new IO wait boost is requested after more then a tick, then
- * we enable the boost starting from IOWAIT_BOOST_MIN, which improves energy
- * efficiency by ignoring sporadic wakeups from IO.
- */
-static bool sugov_iowait_reset(struct sugov_cpu *sg_cpu, u64 time,
-			       bool set_iowait_boost)
-{
-	s64 delta_ns = time - sg_cpu->last_update;
-
-	/* Reset boost only if a tick has elapsed since last request */
-	if (delta_ns <= TICK_NSEC)
-		return false;
-
-	sg_cpu->iowait_boost = set_iowait_boost ? IOWAIT_BOOST_MIN : 0;
-	sg_cpu->iowait_boost_pending = set_iowait_boost;
-
-	return true;
-}
-
 /**
  * sugov_iowait_boost() - Updates the IO boost status of a CPU.
  * @sg_cpu: the sugov data for the CPU to boost
  * @time: the update time from the caller
  * @flags: SCHED_CPUFREQ_IOWAIT if the task is waking up after an IO wait
  *
- * Each time a task wakes up after an IO operation, the CPU utilization can be
- * boosted to a certain utilization which doubles at each "frequent and
- * successive" wakeup from IO, ranging from IOWAIT_BOOST_MIN to the utilization
- * of the maximum OPP.
- *
- * To keep doubling, an IO boost has to be requested at least once per tick,
- * otherwise we restart from the utilization of the minimum OPP.
+ * The io boost is determined by a per-task interval tracking strategy.
  */
 static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
 			       unsigned int flags)
 {
-	bool set_iowait_boost = flags & SCHED_CPUFREQ_IOWAIT;
-
-	/* Reset boost if the CPU appears to have been idle enough */
-	if (sg_cpu->iowait_boost &&
-	    sugov_iowait_reset(sg_cpu, time, set_iowait_boost))
-		return;
-
-	/* Boost only tasks waking up after IO */
-	if (!set_iowait_boost)
-		return;
+	unsigned long boost;

-	/* Ensure boost doubles only one time at each request */
-	if (sg_cpu->iowait_boost_pending)
+	if (!flags & SCHED_CPUFREQ_IOWAIT)
 		return;
-	sg_cpu->iowait_boost_pending = true;

-	/* Double the boost at each request */
-	if (sg_cpu->iowait_boost) {
-		sg_cpu->iowait_boost =
-			min_t(unsigned int, sg_cpu->iowait_boost << 1, SCHED_CAPACITY_SCALE);
+	boost = sugov_io_boost_util(current);
+	if (!boost)
 		return;
-	}
-
-	/* First wakeup after IO: start with minimum boost */
-	sg_cpu->iowait_boost = IOWAIT_BOOST_MIN;
+	sg_cpu->last_update = time;
+	sg_cpu->iowait_boost = boost;
 }

 /**
@@ -281,47 +237,22 @@ static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
  * @time: the update time from the caller
  * @max_cap: the max CPU capacity
  *
- * A CPU running a task which woken up after an IO operation can have its
- * utilization boosted to speed up the completion of those IO operations.
- * The IO boost value is increased each time a task wakes up from IO, in
- * sugov_iowait_apply(), and it's instead decreased by this function,
- * each time an increase has not been requested (!iowait_boost_pending).
- *
- * A CPU which also appears to have been idle for at least one tick has also
- * its IO boost utilization reset.
- *
- * This mechanism is designed to boost high frequently IO waiting tasks, while
- * being more conservative on tasks which does sporadic IO operations.
+ * Apply the most recent io boost, if it is still valid.
+ * It is necessary to apply any recent boost to ensure it is available
+ * for the next io cycle, because requesting at task enqueue will be too
+ * late to see the benefit.
  */
 static unsigned long sugov_iowait_apply(struct sugov_cpu *sg_cpu, u64 time,
 			       unsigned long max_cap)
 {
+	if (sg_cpu->last_update + NSEC_PER_MSEC < time)
+		sg_cpu->iowait_boost = 0;
+
 	/* No boost currently required */
 	if (!sg_cpu->iowait_boost)
 		return 0;

-	/* Reset boost if the CPU appears to have been idle enough */
-	if (sugov_iowait_reset(sg_cpu, time, false))
-		return 0;
-
-	if (!sg_cpu->iowait_boost_pending) {
-		/*
-		 * No boost pending; reduce the boost value.
-		 */
-		sg_cpu->iowait_boost >>= 1;
-		if (sg_cpu->iowait_boost < IOWAIT_BOOST_MIN) {
-			sg_cpu->iowait_boost = 0;
-			return 0;
-		}
-	}
-
-	sg_cpu->iowait_boost_pending = false;
-
-	/*
-	 * sg_cpu->util is already in capacity scale; convert iowait_boost
-	 * into the same scale so we can compare.
-	 */
-	return (sg_cpu->iowait_boost * max_cap) >> SCHED_CAPACITY_SHIFT;
+	return min(sg_cpu->iowait_boost, max_cap);
 }

 #ifdef CONFIG_NO_HZ_COMMON
@@ -538,6 +469,153 @@ static void sugov_irq_work(struct irq_work *irq_work)
 	kthread_queue_work(&sg_policy->worker, &sg_policy->work);
 }

+/************************** per-task io boost **********************/
+
+#define IO_BOOST_INTERVAL_MSEC  25
+#define IO_BOOST_LEVELS         8
+
+/* Require 1000 iowait wakeups per second to start the boosting */
+#define IO_BOOST_IOWAITS_MIN    (IO_BOOST_INTERVAL_MSEC)
+/* The util boost given to the task per io boost level, account for headroom */
+#define IO_BOOST_UTIL_STEP              ((unsigned long)((SCHED_CAPACITY_SCALE / 1.25) / IO_BOOST_LEVELS))
+/* The iowait per interval increase we expect per level, subject to scaling. */
+#define IO_BOOST_IOWAITS_STEP           5
+
+inline unsigned int sugov_io_boost_util(struct task_struct *p)
+{
+	return min(p->io_boost_level * IO_BOOST_UTIL_STEP,
+			uclamp_eff_value(p, UCLAMP_MAX));
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
+	 * => level 8 can be maintained with >1567 iowaits per second.
+	 */
+	return (io_boost_level + 1) * IO_BOOST_INTERVAL_MSEC * NSEC_PER_MSEC;
+}
+
+static inline unsigned int io_boost_threshold(unsigned long threshold_down)
+{
+	/* Allow for threshold range to scale somewhat */
+	return max(threshold_down >> 8, IO_BOOST_IOWAITS_STEP);
+}
+
+static inline void io_boost_scale_interval(struct task_struct *p, bool inc)
+{
+	unsigned int level = p->io_boost_level + (inc ? 1 : -1);
+
+	p->io_boost_level = level;
+	/* We change interval length, scale iowaits per interval accordingly. */
+	if (inc) {
+		p->io_boost_threshold_down = (p->io_boost_curr_ios *
+			(level + 1) / level);
+		p->io_boost_threshold_down +=
+			io_boost_threshold(p->io_boost_threshold_down);
+	} else {
+		p->io_boost_threshold_down = (p->io_boost_curr_ios *
+			level / (level + 1));
+		p->io_boost_threshold_down -=
+			io_boost_threshold(p->io_boost_threshold_down);
+	}
+}
+
+void sugov_enqueue_io_task(struct task_struct *p)
+{
+	u64 now = sched_clock();
+
+	/* Only what's necessary here because this is the critical path */
+	if (now < p->io_boost_timeout)
+		return;
+	/* Last iowait took too long, reset boost */
+	p->io_boost_interval_start = 0;
+	p->io_boost_level = 0;
+}
+
+static inline void io_boost_start_interval(struct task_struct *p, u64 now)
+{
+	p->io_boost_interval_start = now;
+	p->io_boost_curr_ios = 1;
+}
+
+void sugov_dequeue_io_task(struct task_struct *p)
+{
+	u64 now;
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
+	} else if (p->io_boost_curr_ios > p->io_boost_threshold_down +
+			io_boost_threshold(p->io_boost_threshold_down)) {
+		/* Increase boost */
+		if (p->io_boost_level < IO_BOOST_LEVELS)
+			io_boost_scale_interval(p, true);
+		else
+			p->io_boost_threshold_down = p->io_boost_curr_ios -
+				io_boost_threshold(p->io_boost_threshold_down);
+	} else if (p->io_boost_curr_ios < p->io_boost_threshold_down) {
+		/* Reduce boost */
+		if (p->io_boost_level > 1)
+			io_boost_scale_interval(p, false);
+		else
+			p->io_boost_level = 0;
+	} else if (p->io_boost_level == IO_BOOST_LEVELS) {
+		/* Allow for reducing boost on max when conditions changed. */
+		p->io_boost_threshold_down = max(p->io_boost_threshold_down,
+				p->io_boost_curr_ios -
+				io_boost_threshold(p->io_boost_threshold_down));
+	}
+	/* On maintaining boost we just start a new interval. */
+
+	io_boost_start_interval(p, now);
+}
+
 /************************** sysfs interface ************************/

 static struct sugov_tunables *global_tunables;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 146ecf9cc3af..e4c3fdcdd932 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4988,9 +4988,6 @@ static inline int util_fits_cpu(unsigned long util,
 	 */
 	fits = fits_capacity(util, capacity);

-	if (!uclamp_is_used())
-		return fits;
-
 	/*
 	 * We must use arch_scale_cpu_capacity() for comparing against uclamp_min and
 	 * uclamp_max. We only care about capacity pressure (by using
@@ -6751,6 +6748,9 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	struct sched_entity *se = &p->se;
 	int idle_h_nr_running = task_has_idle_policy(p);
 	int task_new = !(flags & ENQUEUE_WAKEUP);
+#ifdef CONFIG_CPU_FREQ_GOV_SCHEDUTIL
+	unsigned int io_boost_level_current, io_boost_level_task;
+#endif

 	/*
 	 * The code below (indirectly) updates schedutil which looks at
@@ -6760,13 +6760,22 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	 */
 	util_est_enqueue(&rq->cfs, p);

-	/*
-	 * If in_iowait is set, the code below may not trigger any cpufreq
-	 * utilization updates, so do it here explicitly with the IOWAIT flag
-	 * passed.
-	 */
+#ifdef CONFIG_CPU_FREQ_GOV_SCHEDUTIL
+	if (p->in_iowait)
+		sugov_enqueue_io_task(p);
+	/* XXX: Sugov assumes current task is io task on SCHED_CPUFREQ_IOWAIT */
+	io_boost_level_task = p->io_boost_level;
+	if (io_boost_level_task) {
+		io_boost_level_current = current->io_boost_level;
+		current->io_boost_level = p->io_boost_level;
+	}
+#endif
 	if (p->in_iowait)
 		cpufreq_update_util(rq, SCHED_CPUFREQ_IOWAIT);
+#ifdef CONFIG_CPU_FREQ_GOV_SCHEDUTIL
+	if (io_boost_level_task)
+		current->io_boost_level = io_boost_level_current;
+#endif

 	for_each_sched_entity(se) {
 		if (se->on_rq)
@@ -6848,6 +6857,10 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)

 	util_est_dequeue(&rq->cfs, p);

+#ifdef CONFIG_CPU_FREQ_GOV_SCHEDUTIL
+	sugov_dequeue_io_task(p);
+#endif
+
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
@@ -7905,7 +7918,7 @@ eenv_pd_max_util(struct energy_env *eenv, struct cpumask *pd_cpus,
 		eff_util = effective_cpu_util(cpu, util, &min, &max);

 		/* Task's uclamp can modify min and max value */
-		if (tsk && uclamp_is_used()) {
+		if (tsk) {
 			min = max(min, uclamp_eff_value(p, UCLAMP_MIN));

 			/*
@@ -7991,8 +8004,8 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 {
 	struct cpumask *cpus = this_cpu_cpumask_var_ptr(select_rq_mask);
 	unsigned long prev_delta = ULONG_MAX, best_delta = ULONG_MAX;
-	unsigned long p_util_min = uclamp_is_used() ? uclamp_eff_value(p, UCLAMP_MIN) : 0;
-	unsigned long p_util_max = uclamp_is_used() ? uclamp_eff_value(p, UCLAMP_MAX) : 1024;
+	unsigned long p_util_min = uclamp_eff_value(p, UCLAMP_MIN);
+	unsigned long p_util_max = uclamp_eff_value(p, UCLAMP_MAX);
 	struct root_domain *rd = this_rq()->rd;
 	int cpu, best_energy_cpu, target = -1;
 	int prev_fits = -1, best_fits = -1;
@@ -8067,7 +8080,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 			 * much capacity we can get out of the CPU; this is
 			 * aligned with sched_cpu_util().
 			 */
-			if (uclamp_is_used() && !uclamp_rq_is_idle(rq)) {
+			if (!uclamp_rq_is_idle(rq)) {
 				/*
 				 * Open code uclamp_rq_util_with() except for
 				 * the clamp() part. I.e.: apply max aggregation
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a831af102070..e72966b2e861 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3050,6 +3050,14 @@ static inline unsigned long cpu_util_rt(struct rq *rq)
 }
 #endif

+#ifdef CONFIG_CPU_FREQ_GOV_SCHEDUTIL
+void sugov_enqueue_io_task(struct task_struct *p);
+void sugov_dequeue_io_task(struct task_struct *p);
+unsigned int sugov_io_boost_util(struct task_struct *p);
+#else
+static unsigned int sugov_io_boost_util(struct task_struct *p) { return 0; }
+#endif
+
 #ifdef CONFIG_UCLAMP_TASK
 unsigned long uclamp_eff_value(struct task_struct *p, enum uclamp_id clamp_id);

@@ -3102,7 +3110,7 @@ static inline unsigned long uclamp_eff_value(struct task_struct *p,
 					     enum uclamp_id clamp_id)
 {
 	if (clamp_id == UCLAMP_MIN)
-		return 0;
+		return sugov_io_boost_util(p);

 	return SCHED_CAPACITY_SCALE;
 }
--
2.34.1


