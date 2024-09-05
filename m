Return-Path: <io-uring+bounces-3047-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6824C96D328
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 11:28:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7825B23D64
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 09:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 227281991DF;
	Thu,  5 Sep 2024 09:27:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D5CF197A7A;
	Thu,  5 Sep 2024 09:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725528458; cv=none; b=GnzO9eYNn+7lGgcKStWzvLIk6fAZU6HxeLYlLdmcDPQCsTtvo1yxDYSCD4O2M1nB4NaJKujU0uqEMcgaSAOp+eKf5pas4HFRARsRb///eM08dmFrk1I/7/RulYjknB+nn+/cl7117yu/kAxLU4pXktNNxGpUKkLjR5n2C9hwoZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725528458; c=relaxed/simple;
	bh=WoLUFlTPkqhx9dGHUiTDC3K2yeV+M3vPQWQiwZWIiQI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iShcu17YaRDW3+JnE4iKnDzW1DRe4h65tAxmGYS9bwpEOD9V5gvi7mbWeAPdeIEnNh+tqQiMayVSanpFGKoIHT1hVL4Rc5UTU7V0Hu6iAbLTKNyp6hSKyn2HNUml0kxoFvVI00gtRhoyHnKqxTIlXwxtZptcbngVeYpUIguMWqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEA461063;
	Thu,  5 Sep 2024 02:28:02 -0700 (PDT)
Received: from e127648.arm.com (unknown [10.57.75.86])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D99BE3F73F;
	Thu,  5 Sep 2024 02:27:31 -0700 (PDT)
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
Subject: [RFC PATCH 4/8] TEST: cpufreq/schedutil: iowait boost cap sysfs
Date: Thu,  5 Sep 2024 10:26:41 +0100
Message-Id: <20240905092645.2885200-5-christian.loehle@arm.com>
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

Add a knob to cap applied iowait_boost per sysfs.
This is to test for potential regressions.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
---
 kernel/sched/cpufreq_schedutil.c | 38 ++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 7810374aaa5b..5324f07fc93a 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -11,6 +11,7 @@
 struct sugov_tunables {
 	struct gov_attr_set	attr_set;
 	unsigned int		rate_limit_us;
+	unsigned int		iowait_boost_cap;
 };
 
 struct sugov_policy {
@@ -35,6 +36,8 @@ struct sugov_policy {
 
 	bool			limits_changed;
 	bool			need_freq_update;
+
+	unsigned int		iowait_boost_cap;
 };
 
 struct sugov_cpu {
@@ -316,6 +319,9 @@ static unsigned long sugov_iowait_apply(struct sugov_cpu *sg_cpu, u64 time,
 
 	sg_cpu->iowait_boost_pending = false;
 
+	if (sg_cpu->iowait_boost > sg_cpu->sg_policy->iowait_boost_cap)
+		sg_cpu->iowait_boost = sg_cpu->sg_policy->iowait_boost_cap;
+
 	/*
 	 * sg_cpu->util is already in capacity scale; convert iowait_boost
 	 * into the same scale so we can compare.
@@ -554,6 +560,14 @@ static ssize_t rate_limit_us_show(struct gov_attr_set *attr_set, char *buf)
 	return sprintf(buf, "%u\n", tunables->rate_limit_us);
 }
 
+
+static ssize_t iowait_boost_cap_show(struct gov_attr_set *attr_set, char *buf)
+{
+	struct sugov_tunables *tunables = to_sugov_tunables(attr_set);
+
+	return sprintf(buf, "%u\n", tunables->iowait_boost_cap);
+}
+
 static ssize_t
 rate_limit_us_store(struct gov_attr_set *attr_set, const char *buf, size_t count)
 {
@@ -572,10 +586,30 @@ rate_limit_us_store(struct gov_attr_set *attr_set, const char *buf, size_t count
 	return count;
 }
 
+static ssize_t
+iowait_boost_cap_store(struct gov_attr_set *attr_set, const char *buf, size_t count)
+{
+	struct sugov_tunables *tunables = to_sugov_tunables(attr_set);
+	struct sugov_policy *sg_policy;
+	unsigned int iowait_boost_cap;
+
+	if (kstrtouint(buf, 10, &iowait_boost_cap))
+		return -EINVAL;
+
+	tunables->iowait_boost_cap = iowait_boost_cap;
+
+	list_for_each_entry(sg_policy, &attr_set->policy_list, tunables_hook)
+		sg_policy->iowait_boost_cap = iowait_boost_cap;
+
+	return count;
+}
+
 static struct governor_attr rate_limit_us = __ATTR_RW(rate_limit_us);
+static struct governor_attr iowait_boost_cap = __ATTR_RW(iowait_boost_cap);
 
 static struct attribute *sugov_attrs[] = {
 	&rate_limit_us.attr,
+	&iowait_boost_cap.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(sugov);
@@ -765,6 +799,8 @@ static int sugov_init(struct cpufreq_policy *policy)
 
 	tunables->rate_limit_us = cpufreq_policy_transition_delay_us(policy);
 
+	tunables->iowait_boost_cap = SCHED_CAPACITY_SCALE;
+
 	policy->governor_data = sg_policy;
 	sg_policy->tunables = tunables;
 
@@ -834,6 +870,8 @@ static int sugov_start(struct cpufreq_policy *policy)
 	sg_policy->limits_changed		= false;
 	sg_policy->cached_raw_freq		= 0;
 
+	sg_policy->iowait_boost_cap		= SCHED_CAPACITY_SCALE;
+
 	sg_policy->need_freq_update = cpufreq_driver_test_flags(CPUFREQ_NEED_UPDATE_LIMITS);
 
 	if (policy_is_shared(policy))
-- 
2.34.1


