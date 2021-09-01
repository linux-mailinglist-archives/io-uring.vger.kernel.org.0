Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C780F3FDC08
	for <lists+io-uring@lfdr.de>; Wed,  1 Sep 2021 15:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344388AbhIAMqb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Sep 2021 08:46:31 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:34970 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345547AbhIAMo2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Sep 2021 08:44:28 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Umw3D8n_1630500202;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Umw3D8n_1630500202)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 01 Sep 2021 20:43:29 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>,
        Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, cgroups@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/2] io_uring: consider cgroup setting when binding sqpoll cpu
Date:   Wed,  1 Sep 2021 20:43:22 +0800
Message-Id: <20210901124322.164238-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210901124322.164238-1-haoxu@linux.alibaba.com>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
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
 fs/io_uring.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7cc458e0b636..fb7890077ede 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -79,6 +79,7 @@
 #include <linux/pagemap.h>
 #include <linux/io_uring.h>
 #include <linux/tracehook.h>
+#include <linux/cpuset.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -7112,11 +7113,9 @@ static int io_sq_thread(void *data)
 
 	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);
-
-	if (sqd->sq_cpu != -1)
+	if (sqd->sq_cpu != -1 && test_cpu_in_current_cpuset(sqd->sq_cpu))
 		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
-	else
-		set_cpus_allowed_ptr(current, cpu_online_mask);
+
 	current->flags |= PF_NO_SETAFFINITY;
 
 	mutex_lock(&sqd->lock);
@@ -8310,8 +8309,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			int cpu = p->sq_thread_cpu;
 
 			ret = -EINVAL;
-			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
+			if (cpu >= nr_cpu_ids || !cpu_online(cpu) ||
+			    !test_cpu_in_current_cpuset(cpu))
 				goto err_sqpoll;
+
 			sqd->sq_cpu = cpu;
 		} else {
 			sqd->sq_cpu = -1;
-- 
2.24.4

