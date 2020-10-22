Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFDB296717
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 00:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372765AbgJVWYz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 18:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372761AbgJVWYz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 18:24:55 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435D2C0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 15:24:53 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 10so2167159pfp.5
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 15:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PinDMonzaC9Fo1dIXndOoyioe1Vf0FgHAWoXMyqb5sI=;
        b=w92yuiWgdLDYwhZIfAX73cWtY5Z0M1TJafr71DAUqwRwvM5ZS3LaI4OSTRhUjarPgS
         VC/j0BvmrkYsh6ECZUTJBSPaR+Wz6Cff2/uKeF/KK/Lfvl/er7V8HaMPdKUZE39TV0da
         6DclO1EGjNIAc6u0fE7taCB3Siw9Hw3l0wEcMOqzRghsbfcaiQThE9H2ezj5zAjMQ0sW
         KMQYn2fipJ0ZP+d2kDm6+KCy4IKZXl/dgmDFJwODWOU9CncxX5jWGYpIPX8dVD8EPhYQ
         sCuEpjl+kkdQbRjWw9css880fJD3RXrlgN0JHE5fBvOHEGlZ/BPimCE8ZIRf1aB0DRNf
         xcQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PinDMonzaC9Fo1dIXndOoyioe1Vf0FgHAWoXMyqb5sI=;
        b=HgeNk9T4j5vrAjrQc55+EAwaVJq0/SRZj5OlpZCHrQMvy2AuQ19vpzl/9ym14RSX4k
         bLvZ6ikUoHLhJCiRRFJ836EyAxRvICxZjJ2KMB4AxmjOoKme257ZKRLXPhIkSGW9p4Iw
         jS1cmyA1Hk0T0DoYJgNEPw0DFgMc4hoCRNucGuonLyE8EYeS39b7vIk4o9LhFir/SD1I
         QtMLGOoHnudeOBF5TfLrKzSwtUCpdK0n01vFgBIsyjISrN9A4mm/FgHNy3YR62PUgj9g
         Bt2f/F8oeZPCVXbET3abUMtE7IbGBQVAZk4ffs8Y+0idxmKrSF5476ODu1px9wNsF+mA
         cDkA==
X-Gm-Message-State: AOAM530LzJM+rvpv2uOr/KeGxYiDHt/EHClh1yDkHFQ35QRfbRjziJhT
        Z7zAnak02OoIxq5tLOySsdJ/FHlVaAkZdw==
X-Google-Smtp-Source: ABdhPJzUFIw2QqAM1pEtVda16wfRJCbggQcJjzuvQxDdw3Jd3Gz9vgJMZlJxZf26zgvX8thG5QGa4w==
X-Received: by 2002:a63:fd08:: with SMTP id d8mr4141029pgh.406.1603405492565;
        Thu, 22 Oct 2020 15:24:52 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e5sm3516437pfl.216.2020.10.22.15.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 15:24:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Zhang Qiang <qiang.zhang@windriver.com>
Subject: [PATCH 2/4] io-wq: re-set NUMA node affinities if CPUs come online
Date:   Thu, 22 Oct 2020 16:24:45 -0600
Message-Id: <20201022222447.62020-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201022222447.62020-1-axboe@kernel.dk>
References: <20201022222447.62020-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We correctly set io-wq NUMA node affinities when the io-wq context is
setup, but if an entire node CPU set is offlined and then brought back
online, the per node affinities are broken. Ensure that we set them
again whenever a CPU comes online. This ensures that we always track
the right node affinity. The usual cpuhp notifiers are used to drive it.

Reported-by: Zhang Qiang <qiang.zhang@windriver.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 54 insertions(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 4012ff541b7b..d3165ce339c2 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -19,6 +19,7 @@
 #include <linux/task_work.h>
 #include <linux/blk-cgroup.h>
 #include <linux/audit.h>
+#include <linux/cpu.h>
 
 #include "io-wq.h"
 
@@ -123,9 +124,13 @@ struct io_wq {
 	refcount_t refs;
 	struct completion done;
 
+	struct hlist_node cpuhp_node;
+
 	refcount_t use_refs;
 };
 
+static enum cpuhp_state io_wq_online;
+
 static bool io_worker_get(struct io_worker *worker)
 {
 	return refcount_inc_not_zero(&worker->ref);
@@ -1091,10 +1096,12 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		return ERR_PTR(-ENOMEM);
 
 	wq->wqes = kcalloc(nr_node_ids, sizeof(struct io_wqe *), GFP_KERNEL);
-	if (!wq->wqes) {
-		kfree(wq);
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!wq->wqes)
+		goto err_wq;
+
+	ret = cpuhp_state_add_instance_nocalls(io_wq_online, &wq->cpuhp_node);
+	if (ret)
+		goto err_wqes;
 
 	wq->free_work = data->free_work;
 	wq->do_work = data->do_work;
@@ -1102,6 +1109,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	/* caller must already hold a reference to this */
 	wq->user = data->user;
 
+	ret = -ENOMEM;
 	for_each_node(node) {
 		struct io_wqe *wqe;
 		int alloc_node = node;
@@ -1145,9 +1153,12 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	ret = PTR_ERR(wq->manager);
 	complete(&wq->done);
 err:
+	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 	for_each_node(node)
 		kfree(wq->wqes[node]);
+err_wqes:
 	kfree(wq->wqes);
+err_wq:
 	kfree(wq);
 	return ERR_PTR(ret);
 }
@@ -1164,6 +1175,8 @@ static void __io_wq_destroy(struct io_wq *wq)
 {
 	int node;
 
+	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
+
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
 	if (wq->manager)
 		kthread_stop(wq->manager);
@@ -1191,3 +1204,40 @@ struct task_struct *io_wq_get_task(struct io_wq *wq)
 {
 	return wq->manager;
 }
+
+static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
+{
+	struct task_struct *task = worker->task;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	do_set_cpus_allowed(task, cpumask_of_node(worker->wqe->node));
+	task->flags |= PF_NO_SETAFFINITY;
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	return false;
+}
+
+static int io_wq_cpu_online(unsigned int cpu, struct hlist_node *node)
+{
+	struct io_wq *wq = hlist_entry_safe(node, struct io_wq, cpuhp_node);
+	int i;
+
+	rcu_read_lock();
+	for_each_node(i)
+		io_wq_for_each_worker(wq->wqes[i], io_wq_worker_affinity, NULL);
+	rcu_read_unlock();
+	return 0;
+}
+
+static __init int io_wq_init(void)
+{
+	int ret;
+
+	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "io-wq/online",
+					io_wq_cpu_online, NULL);
+	if (ret < 0)
+		return ret;
+	io_wq_online = ret;
+	return 0;
+}
+subsys_initcall(io_wq_init);
-- 
2.29.0

