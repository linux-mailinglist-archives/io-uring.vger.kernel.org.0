Return-Path: <io-uring+bounces-3120-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D80E6973C97
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 17:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D6BE282C97
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 15:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 558AC1946CD;
	Tue, 10 Sep 2024 15:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b="fQIiUeoN"
X-Original-To: io-uring@vger.kernel.org
Received: from mta-64-227.siemens.flowmailer.net (mta-64-227.siemens.flowmailer.net [185.136.64.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A51818EFD4
	for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.64.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725983155; cv=none; b=Ye2E3foarFWsQNShBKe/h87T4J0shBJZGiH1toHsWc63yPMZeuMj/sLIOqybPh8UI5iMZdzejKat/nii3n3LZn5rl6xpjdELzy5nogisj+MUto2IvUi53dsC8CkFonEA0PJYYcqZRbaD6BSQGi01RGUZPAHhVd3f5oaPk8ON0yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725983155; c=relaxed/simple;
	bh=gEr1cCpObgM8xPbCaVvgWMgIX9dT3M9/NLL3bHUSkQ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RjTDEEJdke0R1lsy+Bfo7wURqO5Zo4eTqketlchF3CZ0aoF/ynQyE8WKcUBIJGTiI2ZA7pETaCDvvQPjpVaTDk5xggJf4XgBiFpSHDEEyUm5EpMVqBmv4BIGiUpL1FY1QNBM/vEdvrPB9GqycsCF+tiNMGbMJGxm2yPsf8R4VKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b=fQIiUeoN; arc=none smtp.client-ip=185.136.64.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Received: by mta-64-227.siemens.flowmailer.net with ESMTPSA id 2024091015454829028258f1a444a758
        for <io-uring@vger.kernel.org>;
        Tue, 10 Sep 2024 17:45:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=felix.moessbauer@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc:References:In-Reply-To;
 bh=V02Mv7Qi+O8u5o24OCWYd+wHeSgI3uHzoIbW8MTflmc=;
 b=fQIiUeoNAW+Q6pb2ZUhgOnWMDuLe/QcfMkc7XUkr2GxbQ55+yc93eNRLxZ9Q24aXzU2MK6
 oICVy6iT+qAKJxtxFBYIpS0saomc5V53ErKuN2C6xXr5RqqRbYwuRH21z20fAJNTiCXOUdMp
 NOv5j+ZOaxPBynHlxKPlkl9EXoqI1SFHWrI38xuU+oeaMo5QqBLJSisZKRl7tJR4/0cb2hUx
 wMxaYKgGu0ZkENGw+ec5IVZRKTdLNhNe35RQN4IJse8XSaI1/CT/JJw2eSkz3w8VUchyaa+5
 xRMl8fJh4rq4cPvS9m8udbJ0QEWYXVuq6mUJ5ekVbYnEkMUi83zr0peQ==;
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
Subject: [PATCH v2 1/2] io_uring/io-wq: do not allow pinning outside of cpuset
Date: Tue, 10 Sep 2024 17:45:34 +0200
Message-Id: <20240910154535.140587-2-felix.moessbauer@siemens.com>
In-Reply-To: <20240910154535.140587-1-felix.moessbauer@siemens.com>
References: <20240910154535.140587-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-1321639:519-21489:flowmailer

The io worker threads are userland threads that just never exit to the
userland. By that, they are also assigned to a cgroup (the group of the
creating task).

When changing the affinity of the io_wq thread via syscall, we must only
allow cpumasks within the limits defined by the cpuset controller of the
cgroup (if enabled).

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


