Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1BE4795BF
	for <lists+io-uring@lfdr.de>; Fri, 17 Dec 2021 21:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhLQUsd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Dec 2021 15:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhLQUsd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Dec 2021 15:48:33 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EB9C061574
        for <io-uring@vger.kernel.org>; Fri, 17 Dec 2021 12:48:33 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id p23so4720413iod.7
        for <io-uring@vger.kernel.org>; Fri, 17 Dec 2021 12:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=YJq8OffaPChe9DuJ9rxFmhVA9ONySfhHvsKMNKytUQE=;
        b=anDM1wJIDgzGNd7oeZUL7CLwqJw85uY8Fc9PZI0SXw3h4XpRbt4waI+dZe/cIVXS/c
         Fqtyygviq/Dz2adXyIQTziy13jT6lJ/t7J9Be89A9XpweQhtQ/DoOTw/iD9aiv2imsxt
         OkZAUy3z6G5OLX9yGvlPnVr7y/B0nxmad2rrDEC0Yoc09Hxi8/3bHfBEwconpxNOVJKn
         hsqhndlaoeXkui9mDczvTmUoa9qDMd+q0UEbTwNUf+yHo9mabhKMW7mc31KuKmH7fOuy
         58e7j5Yc723AYGC4e5b5IxSwDVddJ0RSQL54ajwi4IXkEI9qqkpkecrF+4TxEHT8zHpt
         BPog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=YJq8OffaPChe9DuJ9rxFmhVA9ONySfhHvsKMNKytUQE=;
        b=wrleFMqQr7Vks/HYdkFVU6rb76aQe8bORWaPHBKpJFuJfOpKNl7ovKUz+8npmyDoJm
         l/vuoqPCiZGEQTHET43Pc0XAQrKb55ioqGn5nUPPuM2Mv7YkA253yAF4eKNQ2JKOA9x1
         iGddg9jIFKfcMSOJRMFFHXCqjEtp0TBNPGlCTkG5sGLhOsX/2cF/K8DRGoqgH18eUV7D
         9TwFV4M9nU3Qnt97y0I/vLuzbg2unToCwCJjFAx/8VHPlwHFBf+c+VrY6e4AdvHBLTp8
         R3JGo6Rt/A0Tpqp/WupQAdmRTQiKG5LFarLgNU/zimzxB4Z/lzQe7C/47iA650O7fM3D
         3BaA==
X-Gm-Message-State: AOAM531OkQGMdRblY/na9uzgaaheGlG0YdxuywuhNr7iHTALHqkU4GQy
        RFnVU2tXjAg4Or2+sVA5U8WXjktFZeAFNg==
X-Google-Smtp-Source: ABdhPJwOoB2hfauihV1BJeNrQUwsWQHtZAahinEEk3S4kdw63KUqD6l8fVsmAnlv4a2eHCyHz8r0cg==
X-Received: by 2002:a05:6638:3818:: with SMTP id i24mr3217808jav.150.1639774112183;
        Fri, 17 Dec 2021 12:48:32 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g8sm6182320ilf.75.2021.12.17.12.48.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Dec 2021 12:48:31 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fix for 5.16-rc6
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <1a6bc93c-df75-d47e-e90e-e90a87e48a56@kernel.dk>
 <CAHk-=wgFYF+W7QZ1KW3u-uFU=rC0jbyUFZBzCVX1-SH9-qe16w@mail.gmail.com>
 <8ac64e80-b686-6191-33f0-11a18c0ac295@kernel.dk>
Message-ID: <fb873466-b3db-a043-9ac7-172102f70013@kernel.dk>
Date:   Fri, 17 Dec 2021 13:48:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8ac64e80-b686-6191-33f0-11a18c0ac295@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------28626FBEBFAB23EC08F45BBB"
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------28626FBEBFAB23EC08F45BBB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 12/17/21 1:11 PM, Jens Axboe wrote:
> On 12/17/21 12:45 PM, Linus Torvalds wrote:
>> On Fri, Dec 17, 2021 at 9:00 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> Just a single fix, fixing an issue with the worker creation change that
>>> was merged last week.
>>
>> Hmm. I've pulled, but looking at the result, this is a classic no-no.
>>
>> You can't just randomly drop and re-take a lock and sat it's "safe".
>>
>> Because I don't think it's necessarily safe at all.
>>
>> When you drop the wqe->lock in the middle of io_wqe_dec_running to
>> create a new worker, it means - for example - that "io_worker_exit()"
>> can now run immediately on the new worker as far as I can tell.
>>
>> So one io_worker_exit() m,ay literally race with another one, where
>> both are inside that io_wqe_dec_running() at the same time. And then
>> they both end up doing
>>
>>         worker->flags = 0;
>>         current->flags &= ~PF_IO_WORKER;
>>
>> afterwards in the caller, and not necessarily in the original order.
>> And then they'll both possible do
>>
>>         kfree_rcu(worker, rcu);
>>
>> which sounds like a disaster.
> 
> The worker itself calls io_worker_exit(), so it cannot happen from
> within io_wqe_dec_running for the existing one. And that's really all
> we care about. The new worker can come and go and we don't really
> care about it, we know we're within another worker.
> 
> That said, I totally do agree that this pattern is not a great one
> and should be avoided if at all possible. This one should be solvable by
> passing back a "do the cancel" information from
> io_queue_worker_create(), but that also gets a bit ugly in terms of
> having three return types essentially...
> 
> I'll have a think about how to do this in a saner fashion that's more
> obviously correct.

Something like this gets rid of it, but I'm not a huge fan of patch 1.
We could also make it an enum return, but that also gets a bit weird
imho.

-- 
Jens Axboe


--------------28626FBEBFAB23EC08F45BBB
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io-wq-enable-io_queue_worker_create-worker-freeing-o.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io-wq-enable-io_queue_worker_create-worker-freeing-o.pa";
 filename*1="tch"

From 259d17e8752041ee0311e098d9e64718cccd2f67 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 17 Dec 2021 13:42:40 -0700
Subject: [PATCH 1/2] io-wq: enable io_queue_worker_create() worker freeing on
 error

Rather than pass back this information, pass in whether or not we should
be kfree'ing the worker on error.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 5c4f582d6549..f261fb700cfc 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -336,9 +336,10 @@ static void create_worker_cb(struct callback_head *cb)
 	io_worker_release(worker);
 }
 
-static bool io_queue_worker_create(struct io_worker *worker,
+static void io_queue_worker_create(struct io_worker *worker,
 				   struct io_wqe_acct *acct,
-				   task_work_func_t func)
+				   task_work_func_t func,
+				   bool free_worker_on_error)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
@@ -370,8 +371,7 @@ static bool io_queue_worker_create(struct io_worker *worker,
 		 */
 		if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
 			io_wq_cancel_tw_create(wq);
-		io_worker_ref_put(wq);
-		return true;
+		goto fail_wq_put;
 	}
 	io_worker_ref_put(wq);
 	clear_bit_unlock(0, &worker->create_state);
@@ -379,8 +379,10 @@ static bool io_queue_worker_create(struct io_worker *worker,
 	io_worker_release(worker);
 fail:
 	atomic_dec(&acct->nr_running);
+fail_wq_put:
 	io_worker_ref_put(wq);
-	return false;
+	if (free_worker_on_error)
+		kfree(worker);
 }
 
 static void io_wqe_dec_running(struct io_worker *worker)
@@ -396,7 +398,7 @@ static void io_wqe_dec_running(struct io_worker *worker)
 		atomic_inc(&acct->nr_running);
 		atomic_inc(&wqe->wq->worker_refs);
 		raw_spin_unlock(&wqe->lock);
-		io_queue_worker_create(worker, acct, create_worker_cb);
+		io_queue_worker_create(worker, acct, create_worker_cb, false);
 		raw_spin_lock(&wqe->lock);
 	}
 }
@@ -790,8 +792,7 @@ static void io_workqueue_create(struct work_struct *work)
 	struct io_worker *worker = container_of(work, struct io_worker, work);
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 
-	if (!io_queue_worker_create(worker, acct, create_worker_cont))
-		kfree(worker);
+	io_queue_worker_create(worker, acct, create_worker_cont, true);
 }
 
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
-- 
2.34.1


--------------28626FBEBFAB23EC08F45BBB
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io-wq-pass-back-cancel-information-from-worker-creat.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-io-wq-pass-back-cancel-information-from-worker-creat.pa";
 filename*1="tch"

From 39caf24bc3645a5c608c070652e3a5e9385232c7 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 17 Dec 2021 13:44:22 -0700
Subject: [PATCH 2/2] io-wq: pass back cancel information from worker creation
 path

Don't call cancel directly deep inside the worker creation, pass back
whether to cancel to the caller which can then do so from a saner
context. We have two paths that currently do this, and one does so while
holding a lock we may need on cancelation.

Fixes: d800c65c2d4e ("io-wq: drop wqe lock before creating new worker")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 46 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index f261fb700cfc..139eecd89e72 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -137,7 +137,7 @@ struct io_cb_cancel_data {
 };
 
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
-static void io_wqe_dec_running(struct io_worker *worker);
+static bool io_wqe_dec_running(struct io_worker *worker);
 static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 					struct io_wqe_acct *acct,
 					struct io_cb_cancel_data *match);
@@ -206,6 +206,7 @@ static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
+	bool cancel;
 
 	while (1) {
 		struct callback_head *cb = task_work_cancel_match(wq->task,
@@ -224,12 +225,15 @@ static void io_worker_exit(struct io_worker *worker)
 		hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
 	preempt_disable();
-	io_wqe_dec_running(worker);
+	cancel = io_wqe_dec_running(worker);
 	worker->flags = 0;
 	current->flags &= ~PF_IO_WORKER;
 	preempt_enable();
 	raw_spin_unlock(&wqe->lock);
 
+	if (cancel)
+		io_wq_cancel_tw_create(wq);
+
 	kfree_rcu(worker, rcu);
 	io_worker_ref_put(wqe->wq);
 	do_exit(0);
@@ -336,13 +340,17 @@ static void create_worker_cb(struct callback_head *cb)
 	io_worker_release(worker);
 }
 
-static void io_queue_worker_create(struct io_worker *worker,
+/*
+ * Returns true if the caller should call io_wq_cancel_tw_create
+ */
+static bool io_queue_worker_create(struct io_worker *worker,
 				   struct io_wqe_acct *acct,
 				   task_work_func_t func,
 				   bool free_worker_on_error)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
+	bool ret = false;
 
 	/* raced with exit, just ignore create call */
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
@@ -370,7 +378,7 @@ static void io_queue_worker_create(struct io_worker *worker,
 		 * work item after we canceled in io_wq_exit_workers().
 		 */
 		if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
-			io_wq_cancel_tw_create(wq);
+			ret = true;
 		goto fail_wq_put;
 	}
 	io_worker_ref_put(wq);
@@ -383,24 +391,28 @@ static void io_queue_worker_create(struct io_worker *worker,
 	io_worker_ref_put(wq);
 	if (free_worker_on_error)
 		kfree(worker);
+	return ret;
 }
 
-static void io_wqe_dec_running(struct io_worker *worker)
+/*
+ * Returns true if the caller should call io_wq_cancel_tw_create
+ */
+static bool io_wqe_dec_running(struct io_worker *worker)
 	__must_hold(wqe->lock)
 {
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 
 	if (!(worker->flags & IO_WORKER_F_UP))
-		return;
+		return false;
 
 	if (atomic_dec_and_test(&acct->nr_running) && io_acct_run_queue(acct)) {
 		atomic_inc(&acct->nr_running);
 		atomic_inc(&wqe->wq->worker_refs);
-		raw_spin_unlock(&wqe->lock);
-		io_queue_worker_create(worker, acct, create_worker_cb, false);
-		raw_spin_lock(&wqe->lock);
+		return io_queue_worker_create(worker, acct, create_worker_cb, false);
 	}
+
+	return false;
 }
 
 /*
@@ -691,6 +703,8 @@ void io_wq_worker_running(struct task_struct *tsk)
 void io_wq_worker_sleeping(struct task_struct *tsk)
 {
 	struct io_worker *worker = tsk->pf_io_worker;
+	struct io_wqe *wqe = worker->wqe;
+	bool cancel;
 
 	if (!worker)
 		return;
@@ -701,9 +715,11 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 
 	worker->flags &= ~IO_WORKER_F_RUNNING;
 
-	raw_spin_lock(&worker->wqe->lock);
-	io_wqe_dec_running(worker);
-	raw_spin_unlock(&worker->wqe->lock);
+	raw_spin_lock(&wqe->lock);
+	cancel = io_wqe_dec_running(worker);
+	raw_spin_unlock(&wqe->lock);
+	if (cancel)
+		io_wq_cancel_tw_create(wqe->wq);
 }
 
 static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
@@ -791,8 +807,12 @@ static void io_workqueue_create(struct work_struct *work)
 {
 	struct io_worker *worker = container_of(work, struct io_worker, work);
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wq *wq = worker->wqe->wq;
+	bool cancel;
 
-	io_queue_worker_create(worker, acct, create_worker_cont, true);
+	cancel = io_queue_worker_create(worker, acct, create_worker_cont, true);
+	if (cancel)
+		io_wq_cancel_tw_create(wq);
 }
 
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
-- 
2.34.1


--------------28626FBEBFAB23EC08F45BBB--
