Return-Path: <io-uring+bounces-3108-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2545D9739EF
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 16:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB90C28AA97
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 14:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B8AB196C7C;
	Tue, 10 Sep 2024 14:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b="Dc/KxDbE"
X-Original-To: io-uring@vger.kernel.org
Received: from mta-65-227.siemens.flowmailer.net (mta-65-227.siemens.flowmailer.net [185.136.65.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0901922E1
	for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 14:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.65.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725978816; cv=none; b=P9NcXEQKgpGkFkNgbGVc2VN2XdrNrNxIMv97L3iRWgzIqaM85747vMGrsIkDk1cby6uDyzxhiHBqct3EpaiLRQE/xmdslzAbzzcIZJOIGafV3HplNisYDMnbaTka2q69C9QKWTOb05XnBTX1BO14505T3oOi0rln1t8sBnMK+bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725978816; c=relaxed/simple;
	bh=JJ+DdDXeUJ6flbA+QfumePVA4yIjXcT651pOhkeHREY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WIJj9XR9jfYTiw4BWz/L7snK3nXquy1mpq0LA9O9gMGZg19mTewT1916Xwh9g3KhxmdvRUv+wDWNFjsmWN2lh0DD8IPKvLNp1Ch9DFj4nLQa0iTADNzJ5MI9Y961/mXV1eUAEkPsaXfSbBzjV9EyqSdFXyF1pMIWkCSUTxxDpwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b=Dc/KxDbE; arc=none smtp.client-ip=185.136.65.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Received: by mta-65-227.siemens.flowmailer.net with ESMTPSA id 20240910143330358dababac3717bee5
        for <io-uring@vger.kernel.org>;
        Tue, 10 Sep 2024 16:33:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=felix.moessbauer@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc:References:In-Reply-To;
 bh=o/hbiqvNhfjZcBz7cNxNDB+PJkwANn7n0tH6iRSE4no=;
 b=Dc/KxDbEOSo2DKI8ACmHiQSlwWT61RF1uGFT9sYhRRNOdwVHf/bbGPezZV9ecoeaXbuIbN
 NdR2oyU9IHiA9dy6xbqMJBURHnN2LiCF7fFXzs/f6/YJuqYE88ZvpTSQ8jwlw8dZi0lwmhNy
 zoIxocgBUtKDpbkdutsE8ZgVyVtlqxTFwO/dm0NHhCpxbB6nM8/tTA/Qjzte3TPrneNu3+Bl
 JgUGoq9TKbNajrdUQg1vIhR4lh3pjeiwYTijej8AGl2Pnl0vHCTCKkTO9HH5REPUBs4ZHR/g
 DKIvMq6ZkqWLZB8LMrGou34+0PVj14Jxe82qFexknKiH7K3Fe7dydW/Q==;
From: Felix Moessbauer <felix.moessbauer@siemens.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	cgroups@vger.kernel.org,
	dqminh@cloudflare.com,
	longman@redhat.com,
	adriaan.schmidt@siemens.com,
	florian.bezdeka@siemens.com,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH 1/2] io_uring/io-wq: do not allow pinning outside of cpuset
Date: Tue, 10 Sep 2024 16:33:19 +0200
Message-Id: <20240910143320.123234-2-felix.moessbauer@siemens.com>
In-Reply-To: <20240910143320.123234-1-felix.moessbauer@siemens.com>
References: <20240910143320.123234-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-1321639:519-21489:flowmailer

The io work queue polling threads are userland threads that just never
exit to the userland. By that, they are also assigned to a cgroup (the
group of the creating task).

When changing the affinity of the io_wq thread via syscall, we must only
allow cpumasks within the ambient limits. These are defined by the cpuset
controller of the cgroup (if enabled).

Fixes: da64d6db3bd3 ("io_uring: One wqe per wq")
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
---
 io_uring/io-wq.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index f1e7c670add8..c7055a8895d7 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/rculist_nulls.h>
 #include <linux/cpu.h>
+#include <linux/cpuset.h>
 #include <linux/task_work.h>
 #include <linux/audit.h>
 #include <linux/mmu_context.h>
@@ -1322,17 +1323,29 @@ static int io_wq_cpu_offline(unsigned int cpu, struct hlist_node *node)
 
 int io_wq_cpu_affinity(struct io_uring_task *tctx, cpumask_var_t mask)
 {
+	cpumask_var_t allowed_mask;
+	int ret = 0;
+
 	if (!tctx || !tctx->io_wq)
 		return -EINVAL;
 
+	if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL))
+		return -ENOMEM;
+
 	rcu_read_lock();
-	if (mask)
-		cpumask_copy(tctx->io_wq->cpu_mask, mask);
-	else
-		cpumask_copy(tctx->io_wq->cpu_mask, cpu_possible_mask);
+	cpuset_cpus_allowed(tctx->io_wq->task, allowed_mask);
+	if (mask) {
+		if (cpumask_subset(mask, allowed_mask))
+			cpumask_copy(tctx->io_wq->cpu_mask, mask);
+		else
+			ret = -EINVAL;
+	} else {
+		cpumask_copy(tctx->io_wq->cpu_mask, allowed_mask);
+	}
 	rcu_read_unlock();
 
-	return 0;
+	free_cpumask_var(allowed_mask);
+	return ret;
 }
 
 /*
-- 
2.39.2


