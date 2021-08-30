Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B7D3FB778
	for <lists+io-uring@lfdr.de>; Mon, 30 Aug 2021 16:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbhH3ODW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Aug 2021 10:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhH3ODV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Aug 2021 10:03:21 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3070C061575
        for <io-uring@vger.kernel.org>; Mon, 30 Aug 2021 07:02:27 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id b10so20012160ioq.9
        for <io-uring@vger.kernel.org>; Mon, 30 Aug 2021 07:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=PT05Y1ipPFjSdccb1XGW1xjou0VmJiQ/FeRyDEj+Q18=;
        b=fTa1AjYlcosi4mUmFs4ng/HziOnLFdZ6ZY9mt/7tRD6M2GAIirlDuWwmAXbOygZvOr
         /ON4Xx5G7hVjU43v9IgfEgzA87K7OpEnCqEiHRW7buHweTumuu221J8Fto8bLC6QWOqj
         ZyPzO2e0UuK05XBo2E6ujZRDLv137lzU4236nJB7a/T0SAY1aKKxwmQ4k+J/TGX3wg2i
         ntSuECB/Ht+EowWBcVwWKiN+pF6ZxALb5or3Wq+njTfjTkK1LKD9ZiPsUt5lgZmPOnYT
         5ucLwlOkeLapSv+tf2cfYqCIRc+cOz5ovAXxaw+RS35eEh9g3TTQqGtuKU9x8uBRu068
         TjAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=PT05Y1ipPFjSdccb1XGW1xjou0VmJiQ/FeRyDEj+Q18=;
        b=St4AGecKPTXtdbby0AioFITZBcPLEyqQ12jo3QsfBjiKLm8Ink248HPjDUkKtNBvrJ
         Pd4vG7iLGZ2ITtmCI1qlVOxocxwuvvDDPYSVIXnhuJgGzSvbvxovdbVXvI4FdkvNHYlF
         MhxqXjoJYaevb+43asu21RMgsMvCX7w4tDTm6WJ4IDGoJejQ5fK/CzfrXkKVwsGXOlIG
         4sywgbPdAhg8Q0DeT3glprZ47g0zfHrECMzI9J8bOSQ6fkFxNv20CBmP1jNWPA4sAvKZ
         BqEyQC6NpRcJyLPpi7KCySu3CzitPCOVhRmI7BIW/G4iN/rjIAqCqF8EhWqsRcbINfWE
         pTEQ==
X-Gm-Message-State: AOAM531NOpj9pv8+OTOOBlmRP9T4CJ0BmeZ1W1pF4Zc07wrZV6Jcn9l2
        Ko6c78jzVh22ooqe02iadMN+b/o6MkS4Lg==
X-Google-Smtp-Source: ABdhPJzSHhI81KuvxJSjoS3ilYI/vPtQPHvgmOfgBE7r7TdDOqg8xAqcocbCW5JNdgNOZZuVwz/aUA==
X-Received: by 2002:a6b:5c0c:: with SMTP id z12mr12205594ioh.171.1630332146837;
        Mon, 30 Aug 2021 07:02:26 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a17sm8568255ilp.75.2021.08.30.07.02.26
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 07:02:26 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: wqe and worker locks no longer need to be IRQ safe
Message-ID: <8fe17adc-62e8-d269-e4bb-a0d764b2c51c@kernel.dk>
Date:   Mon, 30 Aug 2021 08:02:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring no longer queues async work off completion handlers that run in
hard or soft interrupt context, and that use case was the only reason that
io-wq had to use IRQ safe locks for wqe and worker locks.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index da3ad45028f9..13aeb48a0964 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -178,7 +178,7 @@ static void io_worker_exit(struct io_worker *worker)
 		complete(&worker->ref_done);
 	wait_for_completion(&worker->ref_done);
 
-	raw_spin_lock_irq(&wqe->lock);
+	raw_spin_lock(&wqe->lock);
 	if (worker->flags & IO_WORKER_F_FREE)
 		hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
@@ -188,7 +188,7 @@ static void io_worker_exit(struct io_worker *worker)
 	worker->flags = 0;
 	current->flags &= ~PF_IO_WORKER;
 	preempt_enable();
-	raw_spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock(&wqe->lock);
 
 	kfree_rcu(worker, rcu);
 	io_worker_ref_put(wqe->wq);
@@ -254,14 +254,14 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	if (!ret) {
 		bool do_create = false, first = false;
 
-		raw_spin_lock_irq(&wqe->lock);
+		raw_spin_lock(&wqe->lock);
 		if (acct->nr_workers < acct->max_workers) {
 			if (!acct->nr_workers)
 				first = true;
 			acct->nr_workers++;
 			do_create = true;
 		}
-		raw_spin_unlock_irq(&wqe->lock);
+		raw_spin_unlock(&wqe->lock);
 		if (do_create) {
 			atomic_inc(&acct->nr_running);
 			atomic_inc(&wqe->wq->worker_refs);
@@ -289,14 +289,14 @@ static void create_worker_cb(struct callback_head *cb)
 	wqe = worker->wqe;
 	wq = wqe->wq;
 	acct = &wqe->acct[worker->create_index];
-	raw_spin_lock_irq(&wqe->lock);
+	raw_spin_lock(&wqe->lock);
 	if (acct->nr_workers < acct->max_workers) {
 		if (!acct->nr_workers)
 			first = true;
 		acct->nr_workers++;
 		do_create = true;
 	}
-	raw_spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock(&wqe->lock);
 	if (do_create) {
 		create_io_worker(wq, wqe, worker->create_index, first);
 	} else {
@@ -510,9 +510,9 @@ static void io_assign_current_work(struct io_worker *worker,
 		cond_resched();
 	}
 
-	spin_lock_irq(&worker->lock);
+	spin_lock(&worker->lock);
 	worker->cur_work = work;
-	spin_unlock_irq(&worker->lock);
+	spin_unlock(&worker->lock);
 }
 
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
@@ -542,7 +542,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		else if (stalled)
 			wqe->flags |= IO_WQE_FLAG_STALLED;
 
-		raw_spin_unlock_irq(&wqe->lock);
+		raw_spin_unlock(&wqe->lock);
 		if (!work)
 			break;
 		io_assign_current_work(worker, work);
@@ -574,16 +574,16 @@ static void io_worker_handle_work(struct io_worker *worker)
 				clear_bit(hash, &wq->hash->map);
 				if (wq_has_sleeper(&wq->hash->wait))
 					wake_up(&wq->hash->wait);
-				raw_spin_lock_irq(&wqe->lock);
+				raw_spin_lock(&wqe->lock);
 				wqe->flags &= ~IO_WQE_FLAG_STALLED;
 				/* skip unnecessary unlock-lock wqe->lock */
 				if (!work)
 					goto get_next;
-				raw_spin_unlock_irq(&wqe->lock);
+				raw_spin_unlock(&wqe->lock);
 			}
 		} while (work);
 
-		raw_spin_lock_irq(&wqe->lock);
+		raw_spin_lock(&wqe->lock);
 	} while (1);
 }
 
@@ -604,13 +604,13 @@ static int io_wqe_worker(void *data)
 
 		set_current_state(TASK_INTERRUPTIBLE);
 loop:
-		raw_spin_lock_irq(&wqe->lock);
+		raw_spin_lock(&wqe->lock);
 		if (io_wqe_run_queue(wqe)) {
 			io_worker_handle_work(worker);
 			goto loop;
 		}
 		__io_worker_idle(wqe, worker);
-		raw_spin_unlock_irq(&wqe->lock);
+		raw_spin_unlock(&wqe->lock);
 		if (io_flush_signals())
 			continue;
 		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
@@ -629,7 +629,7 @@ static int io_wqe_worker(void *data)
 	}
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
-		raw_spin_lock_irq(&wqe->lock);
+		raw_spin_lock(&wqe->lock);
 		io_worker_handle_work(worker);
 	}
 
@@ -671,9 +671,9 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 
 	worker->flags &= ~IO_WORKER_F_RUNNING;
 
-	raw_spin_lock_irq(&worker->wqe->lock);
+	raw_spin_lock(&worker->wqe->lock);
 	io_wqe_dec_running(worker);
-	raw_spin_unlock_irq(&worker->wqe->lock);
+	raw_spin_unlock(&worker->wqe->lock);
 }
 
 static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index, bool first)
@@ -699,9 +699,9 @@ static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index, bo
 		kfree(worker);
 fail:
 		atomic_dec(&acct->nr_running);
-		raw_spin_lock_irq(&wqe->lock);
+		raw_spin_lock(&wqe->lock);
 		acct->nr_workers--;
-		raw_spin_unlock_irq(&wqe->lock);
+		raw_spin_unlock(&wqe->lock);
 		io_worker_ref_put(wq);
 		return;
 	}
@@ -711,7 +711,7 @@ static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index, bo
 	set_cpus_allowed_ptr(tsk, wqe->cpu_mask);
 	tsk->flags |= PF_NO_SETAFFINITY;
 
-	raw_spin_lock_irq(&wqe->lock);
+	raw_spin_lock(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
 	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
 	worker->flags |= IO_WORKER_F_FREE;
@@ -719,7 +719,7 @@ static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index, bo
 		worker->flags |= IO_WORKER_F_BOUND;
 	if (first && (worker->flags & IO_WORKER_F_BOUND))
 		worker->flags |= IO_WORKER_F_FIXED;
-	raw_spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock(&wqe->lock);
 	wake_up_new_task(tsk);
 }
 
@@ -795,7 +795,6 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
 	int work_flags;
-	unsigned long flags;
 
 	/*
 	 * If io-wq is exiting for this task, or if the request has explicitly
@@ -808,10 +807,10 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	}
 
 	work_flags = work->flags;
-	raw_spin_lock_irqsave(&wqe->lock, flags);
+	raw_spin_lock(&wqe->lock);
 	io_wqe_insert_work(wqe, work);
 	wqe->flags &= ~IO_WQE_FLAG_STALLED;
-	raw_spin_unlock_irqrestore(&wqe->lock, flags);
+	raw_spin_unlock(&wqe->lock);
 
 	if ((work_flags & IO_WQ_WORK_CONCURRENT) ||
 	    !atomic_read(&acct->nr_running))
@@ -840,19 +839,18 @@ void io_wq_hash_work(struct io_wq_work *work, void *val)
 static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 {
 	struct io_cb_cancel_data *match = data;
-	unsigned long flags;
 
 	/*
 	 * Hold the lock to avoid ->cur_work going out of scope, caller
 	 * may dereference the passed in work.
 	 */
-	spin_lock_irqsave(&worker->lock, flags);
+	spin_lock(&worker->lock);
 	if (worker->cur_work &&
 	    match->fn(worker->cur_work, match->data)) {
 		set_notify_signal(worker->task);
 		match->nr_running++;
 	}
-	spin_unlock_irqrestore(&worker->lock, flags);
+	spin_unlock(&worker->lock);
 
 	return match->nr_running && !match->cancel_all;
 }
@@ -880,16 +878,15 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work;
-	unsigned long flags;
 
 retry:
-	raw_spin_lock_irqsave(&wqe->lock, flags);
+	raw_spin_lock(&wqe->lock);
 	wq_list_for_each(node, prev, &wqe->work_list) {
 		work = container_of(node, struct io_wq_work, list);
 		if (!match->fn(work, match->data))
 			continue;
 		io_wqe_remove_pending(wqe, work, prev);
-		raw_spin_unlock_irqrestore(&wqe->lock, flags);
+		raw_spin_unlock(&wqe->lock);
 		io_run_cancel(work, wqe);
 		match->nr_pending++;
 		if (!match->cancel_all)
@@ -898,7 +895,7 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 		/* not safe to continue after unlock */
 		goto retry;
 	}
-	raw_spin_unlock_irqrestore(&wqe->lock, flags);
+	raw_spin_unlock(&wqe->lock);
 }
 
 static void io_wqe_cancel_running_work(struct io_wqe *wqe,

-- 
Jens Axboe

