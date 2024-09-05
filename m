Return-Path: <io-uring+bounces-3046-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 63C3A96D323
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 11:28:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AC3E1F2545E
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 09:28:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD9B51990CD;
	Thu,  5 Sep 2024 09:27:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FF61197A7A;
	Thu,  5 Sep 2024 09:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725528454; cv=none; b=LJf83AtHipmkKpwcBNsbeBxyyydIEuKom9NQDjq/Y4g57TG4l9vqHedCe7VSWS79IPyCr5Aak3LGB+PPctXlmEmM2RvSppKPbbgLM8/z6RaZP0bWKLIY0qk9D+JnXJWzPFDnCyKwe+ICuHp684yfHnL5SvREe5gDolnwLP5K3mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725528454; c=relaxed/simple;
	bh=edp627popAZTkRr7v+xqmAOIkA2ak/45oKZuSXAezOk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f48KbMCzxa11yg/0QBBjX/sjZtUvhWVVSGs82WN+h7Lxv3bZ3T8MMIhNWOEdne5eFZqU3/Sg297LaoBlkg8dud1RbKHYRwxBjQKOSUZSREzjZ+lJUn1EYIE3wgEXrnEHVs2eI8PGdO+lIW2DNmNhns1qSkW4Od9r31i7YoPXrKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0EE271063;
	Thu,  5 Sep 2024 02:27:58 -0700 (PDT)
Received: from e127648.arm.com (unknown [10.57.75.86])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 130043F73F;
	Thu,  5 Sep 2024 02:27:26 -0700 (PDT)
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
Subject: [RFC PATCH 3/8] TEST: cpufreq/schedutil: Linear iowait boost step
Date: Thu,  5 Sep 2024 10:26:40 +0100
Message-Id: <20240905092645.2885200-4-christian.loehle@arm.com>
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

In preparation for capping iowait boost make the steps linear as
opposed to doubling.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
---
 kernel/sched/cpufreq_schedutil.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index eece6244f9d2..7810374aaa5b 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -267,7 +267,8 @@ static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
 	/* Double the boost at each request */
 	if (sg_cpu->iowait_boost) {
 		sg_cpu->iowait_boost =
-			min_t(unsigned int, sg_cpu->iowait_boost << 1, SCHED_CAPACITY_SCALE);
+			min_t(unsigned int,
+			      sg_cpu->iowait_boost + IOWAIT_BOOST_MIN, SCHED_CAPACITY_SCALE);
 		return;
 	}
 
@@ -308,11 +309,9 @@ static unsigned long sugov_iowait_apply(struct sugov_cpu *sg_cpu, u64 time,
 		/*
 		 * No boost pending; reduce the boost value.
 		 */
-		sg_cpu->iowait_boost >>= 1;
-		if (sg_cpu->iowait_boost < IOWAIT_BOOST_MIN) {
-			sg_cpu->iowait_boost = 0;
+		sg_cpu->iowait_boost -= IOWAIT_BOOST_MIN;
+		if (!sg_cpu->iowait_boost)
 			return 0;
-		}
 	}
 
 	sg_cpu->iowait_boost_pending = false;
-- 
2.34.1


