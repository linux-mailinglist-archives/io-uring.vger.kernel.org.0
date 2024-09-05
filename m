Return-Path: <io-uring+bounces-3048-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D530996D32B
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 11:29:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 605101F26DE9
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 09:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 601DD199395;
	Thu,  5 Sep 2024 09:27:43 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C33E19882C;
	Thu,  5 Sep 2024 09:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725528463; cv=none; b=EpMTAxUXSGARd7SeoUE0tV2KkC0Y/YmFrSyBLLWCCSJHu624J8hYNQBTnGIOnF+PanOPQgH4UkoD3lX13R8KHE0RsPe7QOWm3bSTmjVY0t2Rzy3tdE3zxXAIZ5emdyDYtBRUFELpRzU5xkSWhfl/6WzDiYlViFmuVfrQSrhRsQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725528463; c=relaxed/simple;
	bh=8bhuxxX8Yz7TBt2gYDLk5O6y8xl5n79SC7WD1NXf4Qc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EZ6VMZtNF3aHqSFczE0Ful4q1wVm4voku7+M1whIYsRsn8sW8WV9s5Dn2JsAdELFgpyvEh/Rmk4aiaatWEdbwcie0CKzUCc6GycsO7+9m/UGuDeuszfXXSnMkM9yN9rAQj8/aTDUjMfI1PKzY5UlWpfH7D8XlKRGQCAeBOMerC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 489021570;
	Thu,  5 Sep 2024 02:28:07 -0700 (PDT)
Received: from e127648.arm.com (unknown [10.57.75.86])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 79E3D3F73F;
	Thu,  5 Sep 2024 02:27:36 -0700 (PDT)
From: Christian Loehle <christian.loehle@arm.com>
To: linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rafael@kernel.org,
	peterz@infradead.org
Cc: juri.lelli@redhat.com,
	mingo@redhat.com,
	dietmar.eggemann@arm.com,
	vschneid@redhat.com,
	vincent.guittot@linaro.org,
	Johannes.Thumshirn@wdc.com,
	adrian.hunter@intel.com,
	ulf.hansson@linaro.org,
	bvanassche@acm.org,
	andres@anarazel.de,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	qyousef@layalina.io,
	dsmythies@telus.net,
	axboe@kernel.dk,
	Christian Loehle <christian.loehle@arm.com>
Subject: [RFC PATCH 5/8] cpufreq/schedutil: Remove iowait boost
Date: Thu,  5 Sep 2024 10:26:42 +0100
Message-Id: <20240905092645.2885200-6-christian.loehle@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240905092645.2885200-1-christian.loehle@arm.com>
References: <20240905092645.2885200-1-christian.loehle@arm.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iowait boost in schedutil was introduced by
commit ("21ca6d2c52f8 cpufreq: schedutil: Add iowait boosting").
with it more or less following intel_pstate's approach to increase
frequency after an iowait wakeup.
Behaviour that is piggy-backed onto iowait boost is problematic
due to a lot of reasons, so remove it.

For schedutil specifically these are some of the reasons:
1. Boosting is applied even in scenarios where it doesn't improve
throughput.
2. The boost is not accounted for in EAS: a) feec() will only consider
 the actual task utilization for task placement, but another CPU might
 be more energy-efficient at that capacity than the boosted one.)
 b) When placing a non-IO task while a CPU is boosted compute_energy()
 assumes a lower OPP than what is actually applied. This leads to
 wrong EAS decisions.
3. Actual IO heavy workloads are hardly distinguished from infrequent
in_iowait wakeups.
4. The boost isn't accounted for in task placement.
5. The boost isn't associated with a task, it therefore lingers on the
rq even after the responsible task has migrated / stopped.
6. The boost isn't associated with a task, it therefore needs to ramp
up again when migrated.
7. Since schedutil doesn't know which task is getting woken up,
multiple unrelated in_iowait tasks lead to boosting.
8. Boosting is hard to control with UCLAMP_MAX (which is only active
when the task is on the rq, which for boosted tasks is usually not
the case for most of the time).

One benefit of schedutil specifically is the reliance on the
scheduler's utilization signals, which have evolved a lot since it's
original introduction. Some cases that benefitted from iowait boosting
in the past can now be covered by e.g. util_est.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
---
 kernel/sched/cpufreq_schedutil.c | 181 +------------------------------
 1 file changed, 3 insertions(+), 178 deletions(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 5324f07fc93a..55b8b8ba7238 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -6,12 +6,9 @@
  * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
  */
 
-#define IOWAIT_BOOST_MIN	(SCHED_CAPACITY_SCALE / 8)
-
 struct sugov_tunables {
 	struct gov_attr_set	attr_set;
 	unsigned int		rate_limit_us;
-	unsigned int		iowait_boost_cap;
 };
 
 struct sugov_policy {
@@ -36,8 +33,6 @@ struct sugov_policy {
 
 	bool			limits_changed;
 	bool			need_freq_update;
-
-	unsigned int		iowait_boost_cap;
 };
 
 struct sugov_cpu {
@@ -45,10 +40,6 @@ struct sugov_cpu {
 	struct sugov_policy	*sg_policy;
 	unsigned int		cpu;
 
-	bool			iowait_boost_pending;
-	unsigned int		iowait_boost;
-	u64			last_update;
-
 	unsigned long		util;
 	unsigned long		bw_min;
 
@@ -198,137 +189,15 @@ unsigned long sugov_effective_cpu_perf(int cpu, unsigned long actual,
 	return max(min, max);
 }
 
-static void sugov_get_util(struct sugov_cpu *sg_cpu, unsigned long boost)
+static void sugov_get_util(struct sugov_cpu *sg_cpu)
 {
 	unsigned long min, max, util = cpu_util_cfs_boost(sg_cpu->cpu);
 
 	util = effective_cpu_util(sg_cpu->cpu, util, &min, &max);
-	util = max(util, boost);
 	sg_cpu->bw_min = min;
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
-/**
- * sugov_iowait_boost() - Updates the IO boost status of a CPU.
- * @sg_cpu: the sugov data for the CPU to boost
- * @time: the update time from the caller
- * @flags: SCHED_CPUFREQ_IOWAIT if the task is waking up after an IO wait
- *
- * Each time a task wakes up after an IO operation, the CPU utilization can be
- * boosted to a certain utilization which doubles at each "frequent and
- * successive" wakeup from IO, ranging from IOWAIT_BOOST_MIN to the utilization
- * of the maximum OPP.
- *
- * To keep doubling, an IO boost has to be requested at least once per tick,
- * otherwise we restart from the utilization of the minimum OPP.
- */
-static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
-			       unsigned int flags)
-{
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
-
-	/* Ensure boost doubles only one time at each request */
-	if (sg_cpu->iowait_boost_pending)
-		return;
-	sg_cpu->iowait_boost_pending = true;
-
-	/* Double the boost at each request */
-	if (sg_cpu->iowait_boost) {
-		sg_cpu->iowait_boost =
-			min_t(unsigned int,
-			      sg_cpu->iowait_boost + IOWAIT_BOOST_MIN, SCHED_CAPACITY_SCALE);
-		return;
-	}
-
-	/* First wakeup after IO: start with minimum boost */
-	sg_cpu->iowait_boost = IOWAIT_BOOST_MIN;
-}
-
-/**
- * sugov_iowait_apply() - Apply the IO boost to a CPU.
- * @sg_cpu: the sugov data for the cpu to boost
- * @time: the update time from the caller
- * @max_cap: the max CPU capacity
- *
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
- */
-static unsigned long sugov_iowait_apply(struct sugov_cpu *sg_cpu, u64 time,
-			       unsigned long max_cap)
-{
-	/* No boost currently required */
-	if (!sg_cpu->iowait_boost)
-		return 0;
-
-	/* Reset boost if the CPU appears to have been idle enough */
-	if (sugov_iowait_reset(sg_cpu, time, false))
-		return 0;
-
-	if (!sg_cpu->iowait_boost_pending) {
-		/*
-		 * No boost pending; reduce the boost value.
-		 */
-		sg_cpu->iowait_boost -= IOWAIT_BOOST_MIN;
-		if (!sg_cpu->iowait_boost)
-			return 0;
-	}
-
-	sg_cpu->iowait_boost_pending = false;
-
-	if (sg_cpu->iowait_boost > sg_cpu->sg_policy->iowait_boost_cap)
-		sg_cpu->iowait_boost = sg_cpu->sg_policy->iowait_boost_cap;
-
-	/*
-	 * sg_cpu->util is already in capacity scale; convert iowait_boost
-	 * into the same scale so we can compare.
-	 */
-	return (sg_cpu->iowait_boost * max_cap) >> SCHED_CAPACITY_SHIFT;
-}
-
 #ifdef CONFIG_NO_HZ_COMMON
 static bool sugov_cpu_is_busy(struct sugov_cpu *sg_cpu)
 {
@@ -356,18 +225,12 @@ static inline bool sugov_update_single_common(struct sugov_cpu *sg_cpu,
 					      u64 time, unsigned long max_cap,
 					      unsigned int flags)
 {
-	unsigned long boost;
-
-	sugov_iowait_boost(sg_cpu, time, flags);
-	sg_cpu->last_update = time;
-
 	ignore_dl_rate_limit(sg_cpu);
 
 	if (!sugov_should_update_freq(sg_cpu->sg_policy, time))
 		return false;
 
-	boost = sugov_iowait_apply(sg_cpu, time, max_cap);
-	sugov_get_util(sg_cpu, boost);
+	sugov_get_util(sg_cpu);
 
 	return true;
 }
@@ -468,11 +331,8 @@ static unsigned int sugov_next_freq_shared(struct sugov_cpu *sg_cpu, u64 time)
 
 	for_each_cpu(j, policy->cpus) {
 		struct sugov_cpu *j_sg_cpu = &per_cpu(sugov_cpu, j);
-		unsigned long boost;
-
-		boost = sugov_iowait_apply(j_sg_cpu, time, max_cap);
-		sugov_get_util(j_sg_cpu, boost);
 
+		sugov_get_util(j_sg_cpu);
 		util = max(j_sg_cpu->util, util);
 	}
 
@@ -488,9 +348,6 @@ sugov_update_shared(struct update_util_data *hook, u64 time, unsigned int flags)
 
 	raw_spin_lock(&sg_policy->update_lock);
 
-	sugov_iowait_boost(sg_cpu, time, flags);
-	sg_cpu->last_update = time;
-
 	ignore_dl_rate_limit(sg_cpu);
 
 	if (sugov_should_update_freq(sg_policy, time)) {
@@ -560,14 +417,6 @@ static ssize_t rate_limit_us_show(struct gov_attr_set *attr_set, char *buf)
 	return sprintf(buf, "%u\n", tunables->rate_limit_us);
 }
 
-
-static ssize_t iowait_boost_cap_show(struct gov_attr_set *attr_set, char *buf)
-{
-	struct sugov_tunables *tunables = to_sugov_tunables(attr_set);
-
-	return sprintf(buf, "%u\n", tunables->iowait_boost_cap);
-}
-
 static ssize_t
 rate_limit_us_store(struct gov_attr_set *attr_set, const char *buf, size_t count)
 {
@@ -586,30 +435,10 @@ rate_limit_us_store(struct gov_attr_set *attr_set, const char *buf, size_t count
 	return count;
 }
 
-static ssize_t
-iowait_boost_cap_store(struct gov_attr_set *attr_set, const char *buf, size_t count)
-{
-	struct sugov_tunables *tunables = to_sugov_tunables(attr_set);
-	struct sugov_policy *sg_policy;
-	unsigned int iowait_boost_cap;
-
-	if (kstrtouint(buf, 10, &iowait_boost_cap))
-		return -EINVAL;
-
-	tunables->iowait_boost_cap = iowait_boost_cap;
-
-	list_for_each_entry(sg_policy, &attr_set->policy_list, tunables_hook)
-		sg_policy->iowait_boost_cap = iowait_boost_cap;
-
-	return count;
-}
-
 static struct governor_attr rate_limit_us = __ATTR_RW(rate_limit_us);
-static struct governor_attr iowait_boost_cap = __ATTR_RW(iowait_boost_cap);
 
 static struct attribute *sugov_attrs[] = {
 	&rate_limit_us.attr,
-	&iowait_boost_cap.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(sugov);
@@ -799,8 +628,6 @@ static int sugov_init(struct cpufreq_policy *policy)
 
 	tunables->rate_limit_us = cpufreq_policy_transition_delay_us(policy);
 
-	tunables->iowait_boost_cap = SCHED_CAPACITY_SCALE;
-
 	policy->governor_data = sg_policy;
 	sg_policy->tunables = tunables;
 
@@ -870,8 +697,6 @@ static int sugov_start(struct cpufreq_policy *policy)
 	sg_policy->limits_changed		= false;
 	sg_policy->cached_raw_freq		= 0;
 
-	sg_policy->iowait_boost_cap		= SCHED_CAPACITY_SCALE;
-
 	sg_policy->need_freq_update = cpufreq_driver_test_flags(CPUFREQ_NEED_UPDATE_LIMITS);
 
 	if (policy_is_shared(policy))
-- 
2.34.1


