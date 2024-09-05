Return-Path: <io-uring+bounces-3050-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F68696D333
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 11:30:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22F83288EA3
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 09:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B12F198A21;
	Thu,  5 Sep 2024 09:27:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21D0199E95;
	Thu,  5 Sep 2024 09:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725528471; cv=none; b=NLHiB+dDX4IgxWhy5H1cj+Gw4Y/pRZjR9b2t7NzdzgINTVBwd2hMe+6Bpc966k/ZhXZHYfc9bcbse98Kl7KzZnIvQYN2pDclLPCXjBC1wRaCxPOGlkSOREiN+bevimy2F1SMtVZgX90gOVeOKielSqll4KHYAYBK8pHFitPxX+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725528471; c=relaxed/simple;
	bh=+fnvzFx4Txp9JgJLEHAERhSidAo3Uf9bmtiEPtHLch8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ta+kFhwFU5fuGPm1/YGUbg4SKjaZNhuHl7I9Ud/etBxRUHOoQOQAFPjIu7f+ps0vy3up+MEYxYM2PiZqRezGo6z1j7APUUyqqJ6/fUZWfBrqH5rD6O2/Xb0LKeJAnR/e/Blqr82qJmCiglDsRjEkClBZ2/LkuA2V6JtBTiROMVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A45CE1063;
	Thu,  5 Sep 2024 02:28:15 -0700 (PDT)
Received: from e127648.arm.com (unknown [10.57.75.86])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 265603F73F;
	Thu,  5 Sep 2024 02:27:45 -0700 (PDT)
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
Subject: [RFC PATCH 7/8] cpufreq: Remove SCHED_CPUFREQ_IOWAIT update
Date: Thu,  5 Sep 2024 10:26:44 +0100
Message-Id: <20240905092645.2885200-8-christian.loehle@arm.com>
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

Neither intel_pstate nor schedutil care for the flag anymore, so
remove the update and flag definition.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
---
 include/linux/sched/cpufreq.h | 2 --
 kernel/sched/fair.c           | 8 --------
 2 files changed, 10 deletions(-)

diff --git a/include/linux/sched/cpufreq.h b/include/linux/sched/cpufreq.h
index bdd31ab93bc5..d4af813d3126 100644
--- a/include/linux/sched/cpufreq.h
+++ b/include/linux/sched/cpufreq.h
@@ -8,8 +8,6 @@
  * Interface between cpufreq drivers and the scheduler:
  */
 
-#define SCHED_CPUFREQ_IOWAIT	(1U << 0)
-
 #ifdef CONFIG_CPU_FREQ
 struct cpufreq_policy;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9057584ec06d..5cae0e5619aa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6759,14 +6759,6 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	 */
 	util_est_enqueue(&rq->cfs, p);
 
-	/*
-	 * If in_iowait is set, the code below may not trigger any cpufreq
-	 * utilization updates, so do it here explicitly with the IOWAIT flag
-	 * passed.
-	 */
-	if (p->in_iowait)
-		cpufreq_update_util(rq, SCHED_CPUFREQ_IOWAIT);
-
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
-- 
2.34.1


