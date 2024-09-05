Return-Path: <io-uring+bounces-3044-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD9F096D31A
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 11:27:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8B0C1C219EB
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 09:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F37C19885E;
	Thu,  5 Sep 2024 09:27:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87A60198841;
	Thu,  5 Sep 2024 09:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725528445; cv=none; b=Srl6f4em5BjPO8aS52Ql+evnRc1opg8neP/6W04c5HlG3GaHOsEpi9BVADwqCaZnHwPKVZjMIEiFUL72oCtvUlncvx4Ay8UXa6Q2PXUMqEFo9taUhPOaM3Xg09yJJ+e+BhsUJ6R0ZiSWrGRhg3cr2icKxcVdbfZjvbiqyNT2240=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725528445; c=relaxed/simple;
	bh=LotwrgBSvphX+n3nj7L5VhgYje+CjPmnpOocTn1onKo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bj78+yy0uJQlKcJusuPESdgVjPvxdsXyQCWQPz9UTcuV9urmkg/5qau88C8U/K291iqtcD4gFlDxhvf32/JKyZ9qirVagsbKYpVyYGgd6CcuPfn1A7IFx8JrP9ysaAOTED+CVauW4o/jrH4a9VGTFwAvANFTRMNFDRhxeK5QsPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B6D81570;
	Thu,  5 Sep 2024 02:27:49 -0700 (PDT)
Received: from e127648.arm.com (unknown [10.57.75.86])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 100F43F73F;
	Thu,  5 Sep 2024 02:27:17 -0700 (PDT)
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
Subject: [RFC PATCH 1/8] cpuidle: menu: Remove iowait influence
Date: Thu,  5 Sep 2024 10:26:38 +0100
Message-Id: <20240905092645.2885200-2-christian.loehle@arm.com>
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

Remove CPU iowaiters influence on idle state selection.
Remove the menu notion of performance multiplier which increased with
the number of tasks that went to iowait sleep on this CPU and haven't
woken up yet.

Relying on iowait for cpuidle is problematic for a few reasons:
1. There is no guarantee that an iowaiting task will wake up on the
same CPU.
2. The task being in iowait says nothing about the idle duration, we
could be selecting shallower states for a long time.
3. The task being in iowait doesn't always imply a performance hit
with increased latency.
4. If there is such a performance hit, the number of iowaiting tasks
doesn't directly correlate.
5. The definition of iowait altogether is vague at best, it is
sprinkled across kernel code.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
---
 drivers/cpuidle/governors/menu.c | 76 ++++----------------------------
 1 file changed, 9 insertions(+), 67 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f3c9d49f0f2a..28363bfa3e4c 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -19,7 +19,7 @@
 
 #include "gov.h"
 
-#define BUCKETS 12
+#define BUCKETS 6
 #define INTERVAL_SHIFT 3
 #define INTERVALS (1UL << INTERVAL_SHIFT)
 #define RESOLUTION 1024
@@ -29,12 +29,11 @@
 /*
  * Concepts and ideas behind the menu governor
  *
- * For the menu governor, there are 3 decision factors for picking a C
+ * For the menu governor, there are 2 decision factors for picking a C
  * state:
  * 1) Energy break even point
- * 2) Performance impact
- * 3) Latency tolerance (from pmqos infrastructure)
- * These three factors are treated independently.
+ * 2) Latency tolerance (from pmqos infrastructure)
+ * These two factors are treated independently.
  *
  * Energy break even point
  * -----------------------
@@ -75,30 +74,6 @@
  * intervals and if the stand deviation of these 8 intervals is below a
  * threshold value, we use the average of these intervals as prediction.
  *
- * Limiting Performance Impact
- * ---------------------------
- * C states, especially those with large exit latencies, can have a real
- * noticeable impact on workloads, which is not acceptable for most sysadmins,
- * and in addition, less performance has a power price of its own.
- *
- * As a general rule of thumb, menu assumes that the following heuristic
- * holds:
- *     The busier the system, the less impact of C states is acceptable
- *
- * This rule-of-thumb is implemented using a performance-multiplier:
- * If the exit latency times the performance multiplier is longer than
- * the predicted duration, the C state is not considered a candidate
- * for selection due to a too high performance impact. So the higher
- * this multiplier is, the longer we need to be idle to pick a deep C
- * state, and thus the less likely a busy CPU will hit such a deep
- * C state.
- *
- * Currently there is only one value determining the factor:
- * 10 points are added for each process that is waiting for IO on this CPU.
- * (This value was experimentally determined.)
- * Utilization is no longer a factor as it was shown that it never contributed
- * significantly to the performance multiplier in the first place.
- *
  */
 
 struct menu_device {
@@ -112,19 +87,10 @@ struct menu_device {
 	int		interval_ptr;
 };
 
-static inline int which_bucket(u64 duration_ns, unsigned int nr_iowaiters)
+static inline int which_bucket(u64 duration_ns)
 {
 	int bucket = 0;
 
-	/*
-	 * We keep two groups of stats; one with no
-	 * IO pending, one without.
-	 * This allows us to calculate
-	 * E(duration)|iowait
-	 */
-	if (nr_iowaiters)
-		bucket = BUCKETS/2;
-
 	if (duration_ns < 10ULL * NSEC_PER_USEC)
 		return bucket;
 	if (duration_ns < 100ULL * NSEC_PER_USEC)
@@ -138,19 +104,6 @@ static inline int which_bucket(u64 duration_ns, unsigned int nr_iowaiters)
 	return bucket + 5;
 }
 
-/*
- * Return a multiplier for the exit latency that is intended
- * to take performance requirements into account.
- * The more performance critical we estimate the system
- * to be, the higher this multiplier, and thus the higher
- * the barrier to go to an expensive C state.
- */
-static inline int performance_multiplier(unsigned int nr_iowaiters)
-{
-	/* for IO wait tasks (per cpu!) we add 10x each */
-	return 1 + 10 * nr_iowaiters;
-}
-
 static DEFINE_PER_CPU(struct menu_device, menu_devices);
 
 static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev);
@@ -258,8 +211,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	s64 latency_req = cpuidle_governor_latency_req(dev->cpu);
 	u64 predicted_ns;
-	u64 interactivity_req;
-	unsigned int nr_iowaiters;
 	ktime_t delta, delta_tick;
 	int i, idx;
 
@@ -268,8 +219,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		data->needs_update = 0;
 	}
 
-	nr_iowaiters = nr_iowait_cpu(dev->cpu);
-
 	/* Find the shortest expected idle interval. */
 	predicted_ns = get_typical_interval(data) * NSEC_PER_USEC;
 	if (predicted_ns > RESIDENCY_THRESHOLD_NS) {
@@ -283,7 +232,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		}
 
 		data->next_timer_ns = delta;
-		data->bucket = which_bucket(data->next_timer_ns, nr_iowaiters);
+		data->bucket = which_bucket(data->next_timer_ns);
 
 		/* Round up the result for half microseconds. */
 		timer_us = div_u64((RESOLUTION * DECAY * NSEC_PER_USEC) / 2 +
@@ -301,7 +250,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		 */
 		data->next_timer_ns = KTIME_MAX;
 		delta_tick = TICK_NSEC / 2;
-		data->bucket = which_bucket(KTIME_MAX, nr_iowaiters);
+		data->bucket = which_bucket(KTIME_MAX);
 	}
 
 	if (unlikely(drv->state_count <= 1 || latency_req == 0) ||
@@ -328,15 +277,8 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		 */
 		if (predicted_ns < TICK_NSEC)
 			predicted_ns = data->next_timer_ns;
-	} else {
-		/*
-		 * Use the performance multiplier and the user-configurable
-		 * latency_req to determine the maximum exit latency.
-		 */
-		interactivity_req = div64_u64(predicted_ns,
-					      performance_multiplier(nr_iowaiters));
-		if (latency_req > interactivity_req)
-			latency_req = interactivity_req;
+	} else if (latency_req > predicted_ns) {
+		latency_req = predicted_ns;
 	}
 
 	/*
-- 
2.34.1


