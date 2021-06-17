Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982CF3AB9BA
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 18:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhFQQcH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 12:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbhFQQb4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 12:31:56 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3147C0617A6
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 09:29:47 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id k11so2655070ioa.5
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 09:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HrscUnbEROm+H7rU/R4OkgUpJxpOnSkiFdY8zO6hxl0=;
        b=aBKXhnqip3KVe5STxdK2Ze10ShEvQhK7D5x5gswW66NccrN3VTH89yT7G6jJhoicLe
         goRyVeWoJ3Ee18M5Z2WV8F9M7nTmonjNW3YArJ4wtxE8sqWV9Dz9ScOZOJffdmh9aq7R
         XYvxyjjDmv+8pJFUeRqq0czj7UD0LITqzB+77VMLiR2Chpfud9HhRzB756TzC+2PRrEP
         TBo5xWqGgJhovcplUOI1XqVtgg7Lv70Ey9vN/HQo3WS+P4JkfkdcgGbv8D4Bm/MrDhzg
         tluxZHEDwxjg8eVuo/ysth+/asokcB4lvPlUlZvgebXKJdYe17QNpz7BpR7LtZds8eSZ
         v0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HrscUnbEROm+H7rU/R4OkgUpJxpOnSkiFdY8zO6hxl0=;
        b=iLTHnG5/dzH7v4c1j0dYlIQ+y/CS656Hl/z/6SQqkf1+UUmmqaOllTDuvsx1KdG6Ws
         kDpkJTz6qfxlftr+TyjEjj1GQsk1StslsL/WKEnFwsUDtZnCsSmteCLouScYCy0J3Ack
         XMP5vnRbhwYSd4t13VGYTE0gL1/Rf6Y3hT0OJaTtDNdKAVaLX1pA/spvbKi8zXY6v3W9
         fdeUCdELM5k5TvYqGuHTysl/VQWjBensAtI30X9lp41ZVGW+2Yk4Z9nm9esyuLB3sVzR
         gsY7E51hP5ziWdosyWo6kaZHVOg2TV2+gB2zj8NsNFBle/bATJMoQkAsZ4G+DK4vlwWM
         RpDA==
X-Gm-Message-State: AOAM532kVJ8EwczG5MObDwm8e/V+7uoRJOGx3RZzCL7trOVDy9Uo9S7j
        LJnW/dg0BiIs03M8EVrNYxV/HAPIvpfRmUCw
X-Google-Smtp-Source: ABdhPJxr/bqbyRzdkgvF8IswqSK+4fNquc/Oy5xAIZpZY9fZ/iWLUZ5D+R6+n0N2Ztmhe04ll16cvA==
X-Received: by 2002:a05:6602:3306:: with SMTP id b6mr4663918ioz.10.1623947387178;
        Thu, 17 Jun 2021 09:29:47 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b9sm2856359ilj.33.2021.06.17.09.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 09:29:46 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io-wq: use private CPU mask
Date:   Thu, 17 Jun 2021 10:29:43 -0600
Message-Id: <20210617162944.524917-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617162944.524917-1-axboe@kernel.dk>
References: <20210617162944.524917-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for allowing user specific CPU masks for IO thread
creation, switch to using a mask embedded in the per-node wqe
structure.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 897b94530b57..2af8e1df4646 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -94,6 +94,8 @@ struct io_wqe {
 
 	struct io_wq *wq;
 	struct io_wq_work *hash_tail[IO_WQ_NR_HASH_BUCKETS];
+
+	cpumask_var_t cpu_mask;
 };
 
 /*
@@ -638,7 +640,7 @@ static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 
 	tsk->pf_io_worker = worker;
 	worker->task = tsk;
-	set_cpus_allowed_ptr(tsk, cpumask_of_node(wqe->node));
+	set_cpus_allowed_ptr(tsk, wqe->cpu_mask);
 	tsk->flags |= PF_NO_SETAFFINITY;
 
 	raw_spin_lock_irq(&wqe->lock);
@@ -922,6 +924,9 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, alloc_node);
 		if (!wqe)
 			goto err;
+		if (!alloc_cpumask_var(&wqe->cpu_mask, GFP_KERNEL))
+			goto err;
+		cpumask_copy(wqe->cpu_mask, cpumask_of_node(node));
 		wq->wqes[node] = wqe;
 		wqe->node = alloc_node;
 		wqe->acct[IO_WQ_ACCT_BOUND].index = IO_WQ_ACCT_BOUND;
@@ -947,8 +952,12 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 err:
 	io_wq_put_hash(data->hash);
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-	for_each_node(node)
+	for_each_node(node) {
+		if (!wq->wqes[node])
+			continue;
+		free_cpumask_var(wq->wqes[node]->cpu_mask);
 		kfree(wq->wqes[node]);
+	}
 err_wq:
 	kfree(wq);
 	return ERR_PTR(ret);
@@ -1018,6 +1027,7 @@ static void io_wq_destroy(struct io_wq *wq)
 			.cancel_all	= true,
 		};
 		io_wqe_cancel_pending_work(wqe, &match);
+		free_cpumask_var(wqe->cpu_mask);
 		kfree(wqe);
 	}
 	io_wq_put_hash(wq->hash);
@@ -1032,31 +1042,57 @@ void io_wq_put_and_exit(struct io_wq *wq)
 	io_wq_destroy(wq);
 }
 
+struct online_data {
+	unsigned int cpu;
+	bool online;
+};
+
 static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
 {
-	set_cpus_allowed_ptr(worker->task, cpumask_of_node(worker->wqe->node));
+	struct online_data *od = data;
 
+	if (od->online)
+		cpumask_set_cpu(od->cpu, worker->wqe->cpu_mask);
+	else
+		cpumask_clear_cpu(od->cpu, worker->wqe->cpu_mask);
 	return false;
 }
 
-static int io_wq_cpu_online(unsigned int cpu, struct hlist_node *node)
+static int __io_wq_cpu_online(struct io_wq *wq, unsigned int cpu, bool online)
 {
-	struct io_wq *wq = hlist_entry_safe(node, struct io_wq, cpuhp_node);
+	struct online_data od = {
+		.cpu = cpu,
+		.online = online
+	};
 	int i;
 
 	rcu_read_lock();
 	for_each_node(i)
-		io_wq_for_each_worker(wq->wqes[i], io_wq_worker_affinity, NULL);
+		io_wq_for_each_worker(wq->wqes[i], io_wq_worker_affinity, &od);
 	rcu_read_unlock();
 	return 0;
 }
 
+static int io_wq_cpu_online(unsigned int cpu, struct hlist_node *node)
+{
+	struct io_wq *wq = hlist_entry_safe(node, struct io_wq, cpuhp_node);
+
+	return __io_wq_cpu_online(wq, cpu, true);
+}
+
+static int io_wq_cpu_offline(unsigned int cpu, struct hlist_node *node)
+{
+	struct io_wq *wq = hlist_entry_safe(node, struct io_wq, cpuhp_node);
+
+	return __io_wq_cpu_online(wq, cpu, false);
+}
+
 static __init int io_wq_init(void)
 {
 	int ret;
 
 	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "io-wq/online",
-					io_wq_cpu_online, NULL);
+					io_wq_cpu_online, io_wq_cpu_offline);
 	if (ret < 0)
 		return ret;
 	io_wq_online = ret;
-- 
2.32.0

