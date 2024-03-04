Return-Path: <io-uring+bounces-821-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07730870B5D
	for <lists+io-uring@lfdr.de>; Mon,  4 Mar 2024 21:18:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BBB11C222E5
	for <lists+io-uring@lfdr.de>; Mon,  4 Mar 2024 20:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB84B7C6C9;
	Mon,  4 Mar 2024 20:17:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 007EA2C840;
	Mon,  4 Mar 2024 20:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709583449; cv=none; b=H9skxixbhDi04ii4VhbAu21gxaTSGd4GrzUYU51ioU8m7BT9oSOi1zOzU2w7w06ImbErxuZ5ocrAQSs0c13AEulkB8RBkwwzKJwdRSb2odpq670sY42c8FO7jYcZf/SfZ4tum02XUG8RahEtv4INSV8GVm3PaClPy7GYoFOEbVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709583449; c=relaxed/simple;
	bh=clDidIhiTcDaNyPWQCdL6Rs1LruWiA738NpcAJs2/80=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fgNLZu8K7xoGjYp/tflv6lZkmF24UHRtcmOXv7yglnIcT2xzOW8yBU23blOtOqvVqfZzzAdsa4zjj+KfQGu+YqHAmgK7Y9iujimwd3o2MPv+yJEi0bco1OeABPPMVIFkBSD4lsQn0DTQ+RZP7UJWShe9/X4ZUdLcXlidjWgLnok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 41B2C1576;
	Mon,  4 Mar 2024 12:17:54 -0800 (PST)
Received: from e133047.arm.com (unknown [10.57.95.7])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C84B13F738;
	Mon,  4 Mar 2024 12:17:13 -0800 (PST)
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
Subject: [RFC PATCH 2/2] cpufreq/schedutil: Remove iowait boost
Date: Mon,  4 Mar 2024 20:16:25 +0000
Message-Id: <20240304201625.100619-3-christian.loehle@arm.com>
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

The previous commit provides a new cpu_util_cfs_boost_io interface for
schedutil which uses the io boosted utilization of the per-task
tracking strategy. Schedutil iowait boosting is therefore no longer
necessary so remove it.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
---
 kernel/sched/cpufreq_schedutil.c | 152 +------------------------------
 1 file changed, 5 insertions(+), 147 deletions(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index cd0ca3cbd212..ed9fc88a74fc 100644
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
@@ -42,10 +40,6 @@ struct sugov_cpu {
 	struct sugov_policy	*sg_policy;
 	unsigned int		cpu;
 
-	bool			iowait_boost_pending;
-	unsigned int		iowait_boost;
-	u64			last_update;
-
 	unsigned long		util;
 	unsigned long		bw_min;
 
@@ -195,141 +189,17 @@ unsigned long sugov_effective_cpu_perf(int cpu, unsigned long actual,
 	return max(min, max);
 }
 
-static void sugov_get_util(struct sugov_cpu *sg_cpu, unsigned long boost)
+static void sugov_get_util(struct sugov_cpu *sg_cpu)
 {
 	unsigned long min, max, util = cpu_util_cfs_boost(sg_cpu->cpu);
 	unsigned long io_boost = cpu_util_io_boost(sg_cpu->cpu);
 
-	/*
-	 * XXX: This already includes io boost now, makes little sense with
-	 * sugov iowait boost on top
-	 */
 	util = max(util, io_boost);
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
-			min_t(unsigned int, sg_cpu->iowait_boost << 1, SCHED_CAPACITY_SCALE);
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
-}
-
 #ifdef CONFIG_NO_HZ_COMMON
 static bool sugov_cpu_is_busy(struct sugov_cpu *sg_cpu)
 {
@@ -357,18 +227,12 @@ static inline bool sugov_update_single_common(struct sugov_cpu *sg_cpu,
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
@@ -458,7 +322,7 @@ static void sugov_update_single_perf(struct update_util_data *hook, u64 time,
 	sg_cpu->sg_policy->last_freq_update_time = time;
 }
 
-static unsigned int sugov_next_freq_shared(struct sugov_cpu *sg_cpu, u64 time)
+static unsigned int sugov_next_freq_shared(struct sugov_cpu *sg_cpu)
 {
 	struct sugov_policy *sg_policy = sg_cpu->sg_policy;
 	struct cpufreq_policy *policy = sg_policy->policy;
@@ -469,11 +333,8 @@ static unsigned int sugov_next_freq_shared(struct sugov_cpu *sg_cpu, u64 time)
 
 	for_each_cpu(j, policy->cpus) {
 		struct sugov_cpu *j_sg_cpu = &per_cpu(sugov_cpu, j);
-		unsigned long boost;
-
-		boost = sugov_iowait_apply(j_sg_cpu, time, max_cap);
-		sugov_get_util(j_sg_cpu, boost);
 
+		sugov_get_util(j_sg_cpu);
 		util = max(j_sg_cpu->util, util);
 	}
 
@@ -489,13 +350,10 @@ sugov_update_shared(struct update_util_data *hook, u64 time, unsigned int flags)
 
 	raw_spin_lock(&sg_policy->update_lock);
 
-	sugov_iowait_boost(sg_cpu, time, flags);
-	sg_cpu->last_update = time;
-
 	ignore_dl_rate_limit(sg_cpu);
 
 	if (sugov_should_update_freq(sg_policy, time)) {
-		next_f = sugov_next_freq_shared(sg_cpu, time);
+		next_f = sugov_next_freq_shared(sg_cpu);
 
 		if (!sugov_update_next_freq(sg_policy, time, next_f))
 			goto unlock;
-- 
2.34.1


