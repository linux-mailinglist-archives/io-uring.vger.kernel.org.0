Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1BE3E039A
	for <lists+io-uring@lfdr.de>; Wed,  4 Aug 2021 16:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbhHDOoA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Aug 2021 10:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238397AbhHDOoA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Aug 2021 10:44:00 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF1BC061798
        for <io-uring@vger.kernel.org>; Wed,  4 Aug 2021 07:43:46 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id i10so3253282pla.3
        for <io-uring@vger.kernel.org>; Wed, 04 Aug 2021 07:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Ssek2gBdwyibbtURI+xATKZuZg52BHGlKje0OtabAs0=;
        b=h7VKzZe4o/L9PE1NTEeOz+gX+OI8S+0iVj+BIvfuPH96E+Uq9tD4KtuiaP3BxpqVMF
         h24wZN18njHEA/v2QrhvN4v+TvKzidPUCu70kgXubr0I3ny8IuWoAIdhUbspfg1v0sDH
         ITMawuKWwYSGbk2Lo0wxpsvPoVT4qZ9OQH9Yo5NxK1JFzSxexLGW+C4kwH7Vs3HPEqws
         BJbxEeXdNhTxpfL+wHF9iQTiiAIgB8DeVVeE7fu+T0nDmfHvBjiT7Ugob4dyR50pKXaw
         95z1uNAmqu8+dVgtjBXav1k85dFplY6yKKJNDaz9jkQt/9Vw0p+CuHxqAigOz/aKRULu
         Rbow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Ssek2gBdwyibbtURI+xATKZuZg52BHGlKje0OtabAs0=;
        b=CeJ1X38/3EDonkCq30XkVAVIHeGcm8pXXDFRNIs3r/COkOtK0zf1y/9hWaBuEIqDf4
         tb+M5DoHGoJxYaaWY2grazDzbum5hh3vpTKdZKrztnhhyPFaJ1IyCI52vmgq2US2ScY4
         TxAtjK2YLTeT7lsO9Z4e43/037ydXNZz02G5llrL36AxWfTy4i0S1TGkTiHlKaAaTWra
         X8G8D06jr5QaaKcpGOUrj4jusYgGcEBx+7YvEolxlCkokCzIQ5vMJq6peXuxqwhlbqef
         skcU03N5tHDT27Fkc+jHtJZj0RZ7cshhI5DrdeBNMfAzdM5LOD/NbT+JL6aykEtgtUEz
         3AGw==
X-Gm-Message-State: AOAM533vFu1tVLYQBuHmSO5EPYVkDmMu3lYyXIfvTRWZdRBuh8ZPcoQz
        PC1/VAixSHid8iqfjX6pES6DlyutpQ7PJ25w
X-Google-Smtp-Source: ABdhPJwL5ywRYtwZGNqKKeAQLRuOPUqwsDqScLiVgGvUGmKKEoly68alFaEd9jp/7w2tRDEZawbVTg==
X-Received: by 2002:a63:5641:: with SMTP id g1mr1098698pgm.33.1628088226021;
        Wed, 04 Aug 2021 07:43:46 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id x4sm3398147pfb.27.2021.08.04.07.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 07:43:45 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Daniel Wagner <dwagner@suse.de>,
        Peter Zijlstra <peterz@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: remove GFP_ATOMIC allocation off schedule out path
Message-ID: <a673a130-e0e4-5aa8-4165-f35d1262fc6a@kernel.dk>
Date:   Wed, 4 Aug 2021 08:43:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Daniel reports that the v5.14-rc4-rt4 kernel throws a BUG when running
stress-ng:

| [   90.202543] BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:35
| [   90.202549] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 2047, name: iou-wrk-2041
| [   90.202555] CPU: 5 PID: 2047 Comm: iou-wrk-2041 Tainted: G        W         5.14.0-rc4-rt4+ #89
| [   90.202559] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
| [   90.202561] Call Trace:
| [   90.202577]  dump_stack_lvl+0x34/0x44
| [   90.202584]  ___might_sleep.cold+0x87/0x94
| [   90.202588]  rt_spin_lock+0x19/0x70
| [   90.202593]  ___slab_alloc+0xcb/0x7d0
| [   90.202598]  ? newidle_balance.constprop.0+0xf5/0x3b0
| [   90.202603]  ? dequeue_entity+0xc3/0x290
| [   90.202605]  ? io_wqe_dec_running.isra.0+0x98/0xe0
| [   90.202610]  ? pick_next_task_fair+0xb9/0x330
| [   90.202612]  ? __schedule+0x670/0x1410
| [   90.202615]  ? io_wqe_dec_running.isra.0+0x98/0xe0
| [   90.202618]  kmem_cache_alloc_trace+0x79/0x1f0
| [   90.202621]  io_wqe_dec_running.isra.0+0x98/0xe0
| [   90.202625]  io_wq_worker_sleeping+0x37/0x50
| [   90.202628]  schedule+0x30/0xd0
| [   90.202630]  schedule_timeout+0x8f/0x1a0
| [   90.202634]  ? __bpf_trace_tick_stop+0x10/0x10
| [   90.202637]  io_wqe_worker+0xfd/0x320
| [   90.202641]  ? finish_task_switch.isra.0+0xd3/0x290
| [   90.202644]  ? io_worker_handle_work+0x670/0x670
| [   90.202646]  ? io_worker_handle_work+0x670/0x670
| [   90.202649]  ret_from_fork+0x22/0x30

which is due to the RT kernel not liking a GFP_ATOMIC allocation inside
a raw spinlock. Besides that not working on RT, doing any kind of
allocation from inside schedule() is kind of nasty and should be avoided
if at all possible.

This particular path happens when an io-wq worker goes to sleep, and we
need a new worker to handle pending work. We currently allocate a small
data item to hold the information we need to create a new worker, but we
can instead include this data in the io_worker struct itself and just
protect it with a single bit lock. We only really need one per worker
anyway, as we will have run pending work between to sleep cycles.

https://lore.kernel.org/lkml/20210804082418.fbibprcwtzyt5qax@beryllium.lan/
Reported-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 50dc93ffc153..d5f56d41d59b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -51,6 +51,10 @@ struct io_worker {
 
 	struct completion ref_done;
 
+	unsigned long create_state;
+	struct callback_head create_work;
+	int create_index;
+
 	struct rcu_head rcu;
 };
 
@@ -261,42 +265,46 @@ static void io_wqe_inc_running(struct io_worker *worker)
 	atomic_inc(&acct->nr_running);
 }
 
-struct create_worker_data {
-	struct callback_head work;
-	struct io_wqe *wqe;
-	int index;
-};
-
 static void create_worker_cb(struct callback_head *cb)
 {
-	struct create_worker_data *cwd;
+	struct io_worker *worker;
 	struct io_wq *wq;
 
-	cwd = container_of(cb, struct create_worker_data, work);
-	wq = cwd->wqe->wq;
-	create_io_worker(wq, cwd->wqe, cwd->index);
-	kfree(cwd);
+	worker = container_of(cb, struct io_worker, create_work);
+	wq = worker->wqe->wq;
+	create_io_worker(wq, worker->wqe, worker->create_index);
+	clear_bit_unlock(0, &worker->create_state);
+	io_worker_release(worker);
 }
 
-static void io_queue_worker_create(struct io_wqe *wqe, struct io_wqe_acct *acct)
+static void io_queue_worker_create(struct io_wqe *wqe, struct io_worker *worker,
+				   struct io_wqe_acct *acct)
 {
-	struct create_worker_data *cwd;
 	struct io_wq *wq = wqe->wq;
 
 	/* raced with exit, just ignore create call */
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
 		goto fail;
+	if (!io_worker_get(worker))
+		goto fail;
+	/*
+	 * create_state manages ownership of create_work/index. We should
+	 * only need one entry per worker, as the worker going to sleep
+	 * will trigger the condition, and waking will clear it once it
+	 * runs the task_work.
+	 */
+	if (test_bit(0, &worker->create_state) ||
+	    test_and_set_bit_lock(0, &worker->create_state))
+		goto fail_release;
 
-	cwd = kmalloc(sizeof(*cwd), GFP_ATOMIC);
-	if (cwd) {
-		init_task_work(&cwd->work, create_worker_cb);
-		cwd->wqe = wqe;
-		cwd->index = acct->index;
-		if (!task_work_add(wq->task, &cwd->work, TWA_SIGNAL))
-			return;
+	init_task_work(&worker->create_work, create_worker_cb);
+	worker->create_index = acct->index;
+	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL))
+		return;
 
-		kfree(cwd);
-	}
+	clear_bit_unlock(0, &worker->create_state);
+fail_release:
+	io_worker_release(worker);
 fail:
 	atomic_dec(&acct->nr_running);
 	io_worker_ref_put(wq);
@@ -314,7 +322,7 @@ static void io_wqe_dec_running(struct io_worker *worker)
 	if (atomic_dec_and_test(&acct->nr_running) && io_wqe_run_queue(wqe)) {
 		atomic_inc(&acct->nr_running);
 		atomic_inc(&wqe->wq->worker_refs);
-		io_queue_worker_create(wqe, acct);
+		io_queue_worker_create(wqe, worker, acct);
 	}
 }
 
@@ -973,12 +981,12 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 static bool io_task_work_match(struct callback_head *cb, void *data)
 {
-	struct create_worker_data *cwd;
+	struct io_worker *worker;
 
 	if (cb->func != create_worker_cb)
 		return false;
-	cwd = container_of(cb, struct create_worker_data, work);
-	return cwd->wqe->wq == data;
+	worker = container_of(cb, struct io_worker, create_work);
+	return worker->wqe->wq == data;
 }
 
 void io_wq_exit_start(struct io_wq *wq)
@@ -995,12 +1003,13 @@ static void io_wq_exit_workers(struct io_wq *wq)
 		return;
 
 	while ((cb = task_work_cancel_match(wq->task, io_task_work_match, wq)) != NULL) {
-		struct create_worker_data *cwd;
+		struct io_worker *worker;
 
-		cwd = container_of(cb, struct create_worker_data, work);
-		atomic_dec(&cwd->wqe->acct[cwd->index].nr_running);
+		worker = container_of(cb, struct io_worker, create_work);
+		atomic_dec(&worker->wqe->acct[worker->create_index].nr_running);
 		io_worker_ref_put(wq);
-		kfree(cwd);
+		clear_bit_unlock(0, &worker->create_state);
+		io_worker_release(worker);
 	}
 
 	rcu_read_lock();

-- 
Jens Axboe

