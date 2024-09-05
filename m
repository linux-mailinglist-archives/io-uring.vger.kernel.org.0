Return-Path: <io-uring+bounces-3049-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BA9096D32E
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 11:29:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E2441C256EC
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 09:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE078199954;
	Thu,  5 Sep 2024 09:27:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C002198A01;
	Thu,  5 Sep 2024 09:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725528466; cv=none; b=eK4mo0JyIQMWs/iPfVbje9nYg05sMXecCh/4S7W5bkCWPIkzDrHx8u5uJYXc7WtSV/us3xdnVyjduE+/M+y9YOzDLbRyT8DbWYWjBTiST3rC/waQJgWxwQQRqRGbg6FfFzZqssZUZ8Vczb26e75WlypjBf7uEuUxe1nkOchELpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725528466; c=relaxed/simple;
	bh=apO3ieJCTPZmZT/g1YOS/QvNSR5JN4FNa0CjdLj5DUQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PlhMCNmsYqtdhS8VzevygKx5tpaU2mHlux20ZsocHTWtlovoQGeY+kXPQ+L4wpiz0WzX0bPzypfw6bJEmNuxlXjcIUzCwQnnHxjiYKhJ4sWZq3iCCU+sIwe/cvWF/gWjpbOrlyn4UtXFzJx9/6EYIYGIFBWmiAT0YZHhuKPUBRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 697021063;
	Thu,  5 Sep 2024 02:28:11 -0700 (PDT)
Received: from e127648.arm.com (unknown [10.57.75.86])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 020CE3F73F;
	Thu,  5 Sep 2024 02:27:40 -0700 (PDT)
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
Subject: [RFC PATCH 6/8] cpufreq: intel_pstate: Remove iowait boost
Date: Thu,  5 Sep 2024 10:26:43 +0100
Message-Id: <20240905092645.2885200-7-christian.loehle@arm.com>
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

Analogous to schedutil, remove iowait boost for the same reasons.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
---
 drivers/cpufreq/intel_pstate.c | 50 ++--------------------------------
 1 file changed, 3 insertions(+), 47 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index c0278d023cfc..7f30b2569bb3 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -191,7 +191,6 @@ struct global_params {
  * @policy:		CPUFreq policy value
  * @update_util:	CPUFreq utility callback information
  * @update_util_set:	CPUFreq utility callback is set
- * @iowait_boost:	iowait-related boost fraction
  * @last_update:	Time of the last update.
  * @pstate:		Stores P state limits for this CPU
  * @vid:		Stores VID limits for this CPU
@@ -245,7 +244,6 @@ struct cpudata {
 	struct acpi_processor_performance acpi_perf_data;
 	bool valid_pss_table;
 #endif
-	unsigned int iowait_boost;
 	s16 epp_powersave;
 	s16 epp_policy;
 	s16 epp_default;
@@ -2136,28 +2134,7 @@ static inline void intel_pstate_update_util_hwp_local(struct cpudata *cpu,
 {
 	cpu->sample.time = time;
 
-	if (cpu->sched_flags & SCHED_CPUFREQ_IOWAIT) {
-		bool do_io = false;
-
-		cpu->sched_flags = 0;
-		/*
-		 * Set iowait_boost flag and update time. Since IO WAIT flag
-		 * is set all the time, we can't just conclude that there is
-		 * some IO bound activity is scheduled on this CPU with just
-		 * one occurrence. If we receive at least two in two
-		 * consecutive ticks, then we treat as boost candidate.
-		 */
-		if (time_before64(time, cpu->last_io_update + 2 * TICK_NSEC))
-			do_io = true;
-
-		cpu->last_io_update = time;
-
-		if (do_io)
-			intel_pstate_hwp_boost_up(cpu);
-
-	} else {
-		intel_pstate_hwp_boost_down(cpu);
-	}
+	intel_pstate_hwp_boost_down(cpu);
 }
 
 static inline void intel_pstate_update_util_hwp(struct update_util_data *data,
@@ -2240,9 +2217,6 @@ static inline int32_t get_target_pstate(struct cpudata *cpu)
 	busy_frac = div_fp(sample->mperf << cpu->aperf_mperf_shift,
 			   sample->tsc);
 
-	if (busy_frac < cpu->iowait_boost)
-		busy_frac = cpu->iowait_boost;
-
 	sample->busy_scaled = busy_frac * 100;
 
 	target = READ_ONCE(global.no_turbo) ?
@@ -2303,7 +2277,7 @@ static void intel_pstate_adjust_pstate(struct cpudata *cpu)
 		sample->aperf,
 		sample->tsc,
 		get_avg_frequency(cpu),
-		fp_toint(cpu->iowait_boost * 100));
+		0);
 }
 
 static void intel_pstate_update_util(struct update_util_data *data, u64 time,
@@ -2317,24 +2291,6 @@ static void intel_pstate_update_util(struct update_util_data *data, u64 time,
 		return;
 
 	delta_ns = time - cpu->last_update;
-	if (flags & SCHED_CPUFREQ_IOWAIT) {
-		/* Start over if the CPU may have been idle. */
-		if (delta_ns > TICK_NSEC) {
-			cpu->iowait_boost = ONE_EIGHTH_FP;
-		} else if (cpu->iowait_boost >= ONE_EIGHTH_FP) {
-			cpu->iowait_boost <<= 1;
-			if (cpu->iowait_boost > int_tofp(1))
-				cpu->iowait_boost = int_tofp(1);
-		} else {
-			cpu->iowait_boost = ONE_EIGHTH_FP;
-		}
-	} else if (cpu->iowait_boost) {
-		/* Clear iowait_boost if the CPU may have been idle. */
-		if (delta_ns > TICK_NSEC)
-			cpu->iowait_boost = 0;
-		else
-			cpu->iowait_boost >>= 1;
-	}
 	cpu->last_update = time;
 	delta_ns = time - cpu->sample.time;
 	if ((s64)delta_ns < INTEL_PSTATE_SAMPLING_INTERVAL)
@@ -2832,7 +2788,7 @@ static void intel_cpufreq_trace(struct cpudata *cpu, unsigned int trace_type, in
 		sample->aperf,
 		sample->tsc,
 		get_avg_frequency(cpu),
-		fp_toint(cpu->iowait_boost * 100));
+		0);
 }
 
 static void intel_cpufreq_hwp_update(struct cpudata *cpu, u32 min, u32 max,
-- 
2.34.1


