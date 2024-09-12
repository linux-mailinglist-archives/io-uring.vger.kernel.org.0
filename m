Return-Path: <io-uring+bounces-3171-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BBABF9767D3
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 13:27:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 704C41F294FB
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 11:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B23C1A2631;
	Thu, 12 Sep 2024 11:22:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033EE19F43A;
	Thu, 12 Sep 2024 11:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726140149; cv=none; b=aVGhSO4VUKTNLQCqiHxa3mCExiEvPmH9RYwOMCJlQ8ns7l8oXTbYMmpBGtgtw0xFKrCd6MleBjWsf3wMIDMmATbRvYMQeFookszctFD3wREqUhwMNywOUMmgCbT9jCx9y6C1ujtF04zii56m7dOk8vK/ASOwpMSmfDSdv/TIFqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726140149; c=relaxed/simple;
	bh=WkMmrR2PMxTc+mNjIBBn0lHsWo61UePSvPPcS/l2WUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SmQ1C3U490qc/gvri33hNVapn+5qUkxM5YvMgL8Npq2m5L8Q2Y/Vgh34mCXpP8J0iG/JxQ4/+WqBNo1yUrmFjULL9uLP1m6VdKLNLpeebJqySFqaJNMVtBS5XxNuxO05knXFcsl3VhwULbcMhLbIB/17VM+IasdPNcyBCH0Rx9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53CC8DA7;
	Thu, 12 Sep 2024 04:22:55 -0700 (PDT)
Received: from [10.1.32.61] (e127648.arm.com [10.1.32.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 798AA3F64C;
	Thu, 12 Sep 2024 04:22:23 -0700 (PDT)
Message-ID: <7d755a55-31ab-4538-aee4-f88e04dfb6cb@arm.com>
Date: Thu, 12 Sep 2024 12:22:21 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [RFC PATCH] TEST: cpufreq: intel_pstate: sysfs iowait_boost_cap
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
 rafael@kernel.org, peterz@infradead.org
Cc: juri.lelli@redhat.com, mingo@redhat.com, dietmar.eggemann@arm.com,
 vschneid@redhat.com, vincent.guittot@linaro.org, Johannes.Thumshirn@wdc.com,
 adrian.hunter@intel.com, ulf.hansson@linaro.org, bvanassche@acm.org,
 andres@anarazel.de, asml.silence@gmail.com, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, qyousef@layalina.io, dsmythies@telus.net,
 axboe@kernel.dk
References: <20240905092645.2885200-1-christian.loehle@arm.com>
 <20240905092645.2885200-7-christian.loehle@arm.com>
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <20240905092645.2885200-7-christian.loehle@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For non-HWP systems, rework iowait boost to be linear and add
the sysfs knob iowait_boost_cap to limit the maximum boost in
8 steps.

I don't see a good way to translate this to HWP, as the
boost applied isn't as static as it is for non-HWP, but there
is already the dynamic_hwp_boost sysfs to enable/disable
completely.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
---
 drivers/cpufreq/intel_pstate.c | 39 ++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index c0278d023cfc..6882d8c74e61 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -183,6 +183,7 @@ struct global_params {
 	bool turbo_disabled;
 	int max_perf_pct;
 	int min_perf_pct;
+	unsigned int iowait_boost_cap;
 };
 
 /**
@@ -1444,6 +1445,30 @@ static ssize_t store_min_perf_pct(struct kobject *a, struct kobj_attribute *b,
 	return count;
 }
 
+static ssize_t store_iowait_boost_cap(struct kobject *a, struct kobj_attribute *b,
+				  const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
+
+	ret = sscanf(buf, "%u", &input);
+	if (ret != 1)
+		return -EINVAL;
+
+	mutex_lock(&intel_pstate_driver_lock);
+
+	if (!intel_pstate_driver) {
+		mutex_unlock(&intel_pstate_driver_lock);
+		return -EAGAIN;
+	}
+
+	global.iowait_boost_cap = clamp_t(int, input, 0, 8);
+
+	mutex_unlock(&intel_pstate_driver_lock);
+
+	return count;
+}
+
 static ssize_t show_hwp_dynamic_boost(struct kobject *kobj,
 				struct kobj_attribute *attr, char *buf)
 {
@@ -1497,6 +1522,7 @@ static ssize_t store_energy_efficiency(struct kobject *a, struct kobj_attribute
 
 show_one(max_perf_pct, max_perf_pct);
 show_one(min_perf_pct, min_perf_pct);
+show_one(iowait_boost_cap, iowait_boost_cap);
 
 define_one_global_rw(status);
 define_one_global_rw(no_turbo);
@@ -1506,6 +1532,7 @@ define_one_global_ro(turbo_pct);
 define_one_global_ro(num_pstates);
 define_one_global_rw(hwp_dynamic_boost);
 define_one_global_rw(energy_efficiency);
+define_one_global_rw(iowait_boost_cap);
 
 static struct attribute *intel_pstate_attributes[] = {
 	&status.attr,
@@ -1562,6 +1589,9 @@ static void __init intel_pstate_sysfs_expose_params(void)
 		rc = sysfs_create_file(intel_pstate_kobject, &energy_efficiency.attr);
 		WARN_ON(rc);
 	}
+
+	rc = sysfs_create_file(intel_pstate_kobject, &iowait_boost_cap.attr);
+	WARN_ON(rc);
 }
 
 static void __init intel_pstate_sysfs_remove(void)
@@ -2322,18 +2352,23 @@ static void intel_pstate_update_util(struct update_util_data *data, u64 time,
 		if (delta_ns > TICK_NSEC) {
 			cpu->iowait_boost = ONE_EIGHTH_FP;
 		} else if (cpu->iowait_boost >= ONE_EIGHTH_FP) {
-			cpu->iowait_boost <<= 1;
+			cpu->iowait_boost += ONE_EIGHTH_FP;
 			if (cpu->iowait_boost > int_tofp(1))
 				cpu->iowait_boost = int_tofp(1);
 		} else {
 			cpu->iowait_boost = ONE_EIGHTH_FP;
 		}
+		if (cpu->iowait_boost > global.iowait_boost_cap * ONE_EIGHTH_FP)
+			cpu->iowait_boost = global.iowait_boost_cap * ONE_EIGHTH_FP;
 	} else if (cpu->iowait_boost) {
 		/* Clear iowait_boost if the CPU may have been idle. */
 		if (delta_ns > TICK_NSEC)
 			cpu->iowait_boost = 0;
-		else
+		else {
 			cpu->iowait_boost >>= 1;
+			if (cpu->iowait_boost < ONE_EIGHTH_FP)
+				cpu->iowait_boost = 0;
+		}
 	}
 	cpu->last_update = time;
 	delta_ns = time - cpu->sample.time;
-- 
2.25.1

