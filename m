Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3C949316E
	for <lists+io-uring@lfdr.de>; Wed, 19 Jan 2022 00:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbiARXhC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jan 2022 18:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238152AbiARXhC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jan 2022 18:37:02 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5599C061574
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 15:37:01 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id i14so621488ila.11
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 15:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6MX2/YJCEuMVsjFucdd/zVrtMd+SerdZa167kbd56Zs=;
        b=XsOd+/fW/Vgzx7i9ImeWWHWUSBEJE5uQ73zI9nSemRD0QJ2oTTK/+9FSp0qc3VVKSg
         DVQ60icxfUZ7IWCKcFFqC67X9eNrjjy4vnfQ5s6ynSghcLkgxRkgyc1z/E15tbXqbTVQ
         SEAee6DJhrPuMID4wctgFx3On6bOzZL2B7YtnfdgY11kdkRNWXXqJSYcwA9623NxYv5I
         EeZY7+blb+BCZj+NPkZ3Ysg5SNi+kRCW7u001tgpbsPq+UHsSVrQDNQzwPyKPEowGdrs
         e0083Nx02NUYy5BH82YS4U6Lzx/hYCLoSueL/IkNPSzQGWsa90a7cRlEZnehRfRTk+V6
         W7WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6MX2/YJCEuMVsjFucdd/zVrtMd+SerdZa167kbd56Zs=;
        b=5JFoBkvikBH0lUkkgsZ7E1JBQQVo2fWl+mf7nSo9Kc2OX2PNs4dkuGsLq2jl8hGcjG
         eMhcnbm6qUtfe26q8m3y9yyGVjrANsyAR2xuSELPxVV+JnbYwB/vu+7f9uwKSD0wtDt/
         LfcaOHUf28Pm8u2z69V54S7/sV9D1CtzFTCSWA56CeqllIGNp1+CHYYc5Q1ssldk66CD
         RM0xsgnOaXX/c96GeDY6n3M9cAujn81v9tJyYHeEEVZmtUeLL7DIVsNYQhJTF5GofOJe
         LkmgS880vLhpj4udGA4UPDrNMg/1LtZgjNoR41uC/h5kreM833QlLJWo6FGB8L5gxCsg
         KbGA==
X-Gm-Message-State: AOAM532aeBe/91re/2u34bJgOYKDzG7CYJnTHX3jbSHY53eEjXVZ3FAO
        4dBAJOZSnFdyt81IPdS6a6M6S7vWMgtwqQ==
X-Google-Smtp-Source: ABdhPJx1YpCXPihNfcrc/dEFZz4bt62BLl65Z8rk/o858N5h1+MCjYSs/bcn7udnbOtUScp5QzjZXQ==
X-Received: by 2002:a05:6e02:164c:: with SMTP id v12mr15178607ilu.49.1642549020911;
        Tue, 18 Jan 2022 15:37:00 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id x13sm8473334ile.49.2022.01.18.15.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 15:37:00 -0800 (PST)
Subject: Re: Canceled read requests never completed
To:     io-uring@vger.kernel.org, flow@cs.fau.de
References: <20220118151337.fac6cthvbnu7icoc@pasture>
 <81656a38-3628-e32f-1092-bacf7468a6bf@kernel.dk>
 <20220118200549.qybt7fgfqznscidx@pasture>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1ec0f92c-117e-d584-f456-036d41348332@kernel.dk>
Date:   Tue, 18 Jan 2022 16:36:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220118200549.qybt7fgfqznscidx@pasture>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/18/22 1:05 PM, Florian Fischer wrote:
>>> After reading the io_uring_enter(2) man page a IORING_OP_ASYNC_CANCEL's return value of -EALREADY apparently
>>> may not cause the request to terminate. At least that is our interpretation of "…res field will contain -EALREADY.
>>> In this case, the request may or may not terminate."
>>
>> I took a look at this, and my theory is that the request cancelation
>> ends up happening right in between when the work item is moved between
>> the work list and to the worker itself. The way the async queue works,
>> the work item is sitting in a list until it gets assigned by a worker.
>> When that assignment happens, it's removed from the general work list
>> and then assigned to the worker itself. There's a small gap there where
>> the work cannot be found in the general list, and isn't yet findable in
>> the worker itself either.
>>
>> Do you always see -ENOENT from the cancel when you get the hang
>> condition?
> 
> No we also and actually more commonly observe cancel returning
> -EALREADY and the canceled read request never gets completed.
> 
> As shown in the log snippet I included below.

I think there are a couple of different cases here. Can you try the
below patch? It's against current -git.


diff --git a/fs/io-wq.c b/fs/io-wq.c
index 5c4f582d6549..e8f8a5ee93c1 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -48,7 +48,8 @@ struct io_worker {
 	struct io_wqe *wqe;
 
 	struct io_wq_work *cur_work;
-	spinlock_t lock;
+	struct io_wq_work *next_work;
+	raw_spinlock_t lock;
 
 	struct completion ref_done;
 
@@ -529,9 +530,11 @@ static void io_assign_current_work(struct io_worker *worker,
 		cond_resched();
 	}
 
-	spin_lock(&worker->lock);
+	WARN_ON_ONCE(work != worker->next_work);
+	raw_spin_lock(&worker->lock);
 	worker->cur_work = work;
-	spin_unlock(&worker->lock);
+	worker->next_work = NULL;
+	raw_spin_unlock(&worker->lock);
 }
 
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
@@ -555,9 +558,20 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * clear the stalled flag.
 		 */
 		work = io_get_next_work(acct, worker);
-		if (work)
+		if (work) {
 			__io_worker_busy(wqe, worker, work);
 
+			/*
+			 * Make sure cancelation can find this, even before
+			 * it becomes the active work. That avoids a window
+			 * where the work has been removed from our general
+			 * work list, but isn't yet discoverable as the
+			 * current work item for this worker.
+			 */
+			raw_spin_lock(&worker->lock);
+			worker->next_work = work;
+			raw_spin_unlock(&worker->lock);
+		}
 		raw_spin_unlock(&wqe->lock);
 		if (!work)
 			break;
@@ -815,7 +829,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 
 	refcount_set(&worker->ref, 1);
 	worker->wqe = wqe;
-	spin_lock_init(&worker->lock);
+	raw_spin_lock_init(&worker->lock);
 	init_completion(&worker->ref_done);
 
 	if (index == IO_WQ_ACCT_BOUND)
@@ -973,6 +987,19 @@ void io_wq_hash_work(struct io_wq_work *work, void *val)
 	work->flags |= (IO_WQ_WORK_HASHED | (bit << IO_WQ_HASH_SHIFT));
 }
 
+static bool __io_wq_worker_cancel(struct io_worker *worker,
+				  struct io_cb_cancel_data *match,
+				  struct io_wq_work *work)
+{
+	if (work && match->fn(work, match->data)) {
+		work->flags |= IO_WQ_WORK_CANCEL;
+		set_notify_signal(worker->task);
+		return true;
+	}
+
+	return false;
+}
+
 static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 {
 	struct io_cb_cancel_data *match = data;
@@ -981,13 +1008,11 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 	 * Hold the lock to avoid ->cur_work going out of scope, caller
 	 * may dereference the passed in work.
 	 */
-	spin_lock(&worker->lock);
-	if (worker->cur_work &&
-	    match->fn(worker->cur_work, match->data)) {
-		set_notify_signal(worker->task);
+	raw_spin_lock(&worker->lock);
+	if (__io_wq_worker_cancel(worker, match, worker->cur_work) ||
+	    __io_wq_worker_cancel(worker, match, worker->next_work))
 		match->nr_running++;
-	}
-	spin_unlock(&worker->lock);
+	raw_spin_unlock(&worker->lock);
 
 	return match->nr_running && !match->cancel_all;
 }
@@ -1039,17 +1064,16 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 {
 	int i;
 retry:
-	raw_spin_lock(&wqe->lock);
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
 
 		if (io_acct_cancel_pending_work(wqe, acct, match)) {
+			raw_spin_lock(&wqe->lock);
 			if (match->cancel_all)
 				goto retry;
-			return;
+			break;
 		}
 	}
-	raw_spin_unlock(&wqe->lock);
 }
 
 static void io_wqe_cancel_running_work(struct io_wqe *wqe,
@@ -1078,7 +1102,9 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
+		raw_spin_lock(&wqe->lock);
 		io_wqe_cancel_pending_work(wqe, &match);
+		raw_spin_unlock(&wqe->lock);
 		if (match.nr_pending && !match.cancel_all)
 			return IO_WQ_CANCEL_OK;
 	}
@@ -1092,7 +1118,15 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
+		raw_spin_lock(&wqe->lock);
+		io_wqe_cancel_pending_work(wqe, &match);
+		if (match.nr_pending && !match.cancel_all) {
+			raw_spin_unlock(&wqe->lock);
+			return IO_WQ_CANCEL_OK;
+		}
+
 		io_wqe_cancel_running_work(wqe, &match);
+		raw_spin_unlock(&wqe->lock);
 		if (match.nr_running && !match.cancel_all)
 			return IO_WQ_CANCEL_RUNNING;
 	}
@@ -1263,7 +1297,9 @@ static void io_wq_destroy(struct io_wq *wq)
 			.fn		= io_wq_work_match_all,
 			.cancel_all	= true,
 		};
+		raw_spin_lock(&wqe->lock);
 		io_wqe_cancel_pending_work(wqe, &match);
+		raw_spin_unlock(&wqe->lock);
 		free_cpumask_var(wqe->cpu_mask);
 		kfree(wqe);
 	}
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 422d6de48688..49f115a2dec4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6386,7 +6386,8 @@ static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
 	WARN_ON_ONCE(!io_wq_current_is_worker() && req->task != current);
 
 	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
-	if (ret != -ENOENT)
+	//if (ret != -ENOENT)
+	if (ret == 0)
 		return ret;
 
 	spin_lock(&ctx->completion_lock);
@@ -6892,7 +6893,8 @@ static void io_wq_submit_work(struct io_wq_work *work)
 		io_queue_linked_timeout(timeout);
 
 	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
-	if (work->flags & IO_WQ_WORK_CANCEL) {
+	if (work->flags & IO_WQ_WORK_CANCEL ||
+	    test_tsk_thread_flag(current, TIF_NOTIFY_SIGNAL)) {
 		io_req_task_queue_fail(req, -ECANCELED);
 		return;
 	}


-- 
Jens Axboe

