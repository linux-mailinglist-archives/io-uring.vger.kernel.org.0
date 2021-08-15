Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693E83EC9D7
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 17:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhHOPLa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 11:11:30 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:40736 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229603AbhHOPLa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 11:11:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uj2jC6t_1629040249;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uj2jC6t_1629040249)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 15 Aug 2021 23:10:58 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: consider cgroup setting when binding sqpoll cpu
Date:   Sun, 15 Aug 2021 23:10:49 +0800
Message-Id: <20210815151049.182340-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since sqthread is userspace like thread now, it should respect cgroup
setting, thus we should consider current allowed cpuset when doing
cpu binding for sqthread.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 41 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 51c4166f68b5..35d0e7bc283b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -79,6 +79,7 @@
 #include <linux/pagemap.h>
 #include <linux/io_uring.h>
 #include <linux/tracehook.h>
+#include <linux/cpuset.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -6903,15 +6904,35 @@ static int io_sq_thread(void *data)
 	struct io_ring_ctx *ctx;
 	unsigned long timeout = 0;
 	char buf[TASK_COMM_LEN];
+	cpumask_var_t cpus_allowed;
 	DEFINE_WAIT(wait);
 
 	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);
 
-	if (sqd->sq_cpu != -1)
-		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
-	else
-		set_cpus_allowed_ptr(current, cpu_online_mask);
+	if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL)) {
+		mutex_lock(&sqd->lock);
+		sqd->thread = NULL;
+		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+			io_ring_set_wakeup_flag(ctx);
+		io_run_task_work();
+		mutex_unlock(&sqd->lock);
+
+		complete(&sqd->exited);
+		do_exit(1);
+	}
+	cpuset_cpus_allowed(current, cpus_allowed);
+	if (sqd->sq_cpu != -1) {
+		if (!cpumask_test_cpu(sqd->sq_cpu, cpus_allowed)) {
+			sqd->sq_cpu = -1;
+			pr_warn("sqthread %d: bound cpu not allowed\n", current->pid);
+		} else {
+			set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
+		}
+	}
+	if (sqd->sq_cpu == -1)
+		set_cpus_allowed_ptr(current, cpus_allowed);
+	free_cpumask_var(cpus_allowed);
 	current->flags |= PF_NO_SETAFFINITY;
 
 	mutex_lock(&sqd->lock);
@@ -8060,11 +8081,23 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 
 		if (p->flags & IORING_SETUP_SQ_AFF) {
 			int cpu = p->sq_thread_cpu;
+			cpumask_var_t cpus_allowed;
 
 			ret = -EINVAL;
 			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
 				goto err_sqpoll;
+			if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL)) {
+				ret = -ENOMEM;
+				goto err_sqpoll;
+			}
+			cpuset_cpus_allowed(current, cpus_allowed);
+			if (!cpumask_test_cpu(cpu, cpus_allowed)) {
+				free_cpumask_var(cpus_allowed);
+				goto err_sqpoll;
+			}
+
 			sqd->sq_cpu = cpu;
+			free_cpumask_var(cpus_allowed);
 		} else {
 			sqd->sq_cpu = -1;
 		}
-- 
2.24.4

