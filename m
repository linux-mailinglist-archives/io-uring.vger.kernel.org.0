Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D455E3FD785
	for <lists+io-uring@lfdr.de>; Wed,  1 Sep 2021 12:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbhIAKTr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Sep 2021 06:19:47 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:2830 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231739AbhIAKTq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Sep 2021 06:19:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UmvU9H3_1630491513;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UmvU9H3_1630491513)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 01 Sep 2021 18:18:40 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>,
        Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, cgroups@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/2] cpuset: add a helper to check if cpu in cpuset of current task
Date:   Wed,  1 Sep 2021 18:18:32 +0800
Message-Id: <20210901101833.69535-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210901101833.69535-1-haoxu@linux.alibaba.com>
References: <20210901101833.69535-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Check if a cpu is in the cpuset of current task, not guaranteed that
cpu is online.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 include/linux/cpuset.h |  7 +++++++
 kernel/cgroup/cpuset.c | 11 +++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 04c20de66afc..fad77c91bc1f 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -116,6 +116,8 @@ static inline int cpuset_do_slab_mem_spread(void)
 
 extern bool current_cpuset_is_being_rebound(void);
 
+extern bool test_cpu_in_current_cpuset(int cpu);
+
 extern void rebuild_sched_domains(void);
 
 extern void cpuset_print_current_mems_allowed(void);
@@ -257,6 +259,11 @@ static inline bool current_cpuset_is_being_rebound(void)
 	return false;
 }
 
+static inline bool test_cpu_in_current_cpuset(int cpu)
+{
+	return false;
+}
+
 static inline void rebuild_sched_domains(void)
 {
 	partition_sched_domains(1, NULL, NULL);
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index adb5190c4429..a63c27e9430e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1849,6 +1849,17 @@ bool current_cpuset_is_being_rebound(void)
 	return ret;
 }
 
+bool test_cpu_in_current_cpuset(int cpu)
+{
+	bool ret;
+
+	rcu_read_lock();
+	ret = cpumask_test_cpu(cpu, task_cs(current)->effective_cpus);
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
 #ifdef CONFIG_SMP
-- 
2.24.4

