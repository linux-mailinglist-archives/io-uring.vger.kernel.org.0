Return-Path: <io-uring+bounces-11008-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0094FCB4AAD
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 05:10:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7C5F830014CD
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 04:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97182D1905;
	Thu, 11 Dec 2025 04:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uiSLjmsd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43E41494DB
	for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 04:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765426242; cv=none; b=sxq+3ybJRXATDZfs5UkQyl+LxSUWFFni4kJsjnBvjPt8c1iNaOJeNbEG+MsLClTLNMJeKn3vEmIMeT0riBx0YGtQ2liTJvOUTdthildmiBIGxQIttdCkmk69v/qrmHi9YD9ZqvvlM2IUi0ik8ZAuzHaP2zcD75fZMy0EWYZ83GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765426242; c=relaxed/simple;
	bh=iLWxNI1wQn/Owd6NJFy5R4W6MMduZtfvkqP/UBBvAPA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=m21gyLDjGzGuD9cgP6levWMmH42Lc4jgiZv8b1+eJ6L/pRG8kyjYq2ltloGZrs8ljAVm2TL/Z1UrD/3l+WT17kl9d7y2IIL69Pxz5fVzUssEHrB8OecJ026RCZKbhOKIADwU7GLCeK6yFiyGCSP1QLkLMUDstX1LO/8W73HzvJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uiSLjmsd; arc=none smtp.client-ip=209.85.216.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-343f52d15efso575940a91.3
        for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 20:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765426238; x=1766031038; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dnB+rk1dZcWArXw1utvDGsXpb7b/auyVKoqWkAU8KJQ=;
        b=uiSLjmsdQz4/LebkHltY8UTtuLlEIwpRQBNsRnEgpy+LaruPj/9wEUTEyhepHVvtw0
         V6V5SzBV2g/1OfajU2wZgFPvtTsEHvpl7ajnIIQ0TiRBWkyNvPlnmfhpbNTh+5Mx3AxU
         0BUt7c8QfxUO3ZjLSaHu3C1J3ahyXBeuBMZJ4/4Gi6iOugztTmZ9RcfB7B0zoL5acLih
         CaMg3BSmbUM7d9IkIHzy98KzSXCtwilzyg0oNvWbh2dswqI/o1OmUxiXmJFQ9dB2+bv5
         v8gJ3EOrro7Z7aYP8qU5K1wYjL0QK0C2rwKPs1TY/10uYJiXIritW+iOOh1zY3XdHjdY
         46WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765426238; x=1766031038;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dnB+rk1dZcWArXw1utvDGsXpb7b/auyVKoqWkAU8KJQ=;
        b=E7q/Lwuh1RwK9wWIgxVnjSeakP8uMJ85FFD5TYMQ4Bn7pokrsF1rN8gSYOBrfvf+aB
         KolY02rQnPBCJ5mDKwAyU9k/u8dz5VT3VJ9WlBYKrQ6jEm8qhCwckpnexp9iM1p48ux5
         DYXf/mkDgj6E8tmYLf2N3DwnQBQmmrpnl4C+ZYF3YnqVXZxzEX+hmq+hI5MGYGkqJq7N
         ckXro43V88gCkbRysEmsHfFjGZg2AhpD8BiyiwaXnkbzCfEvAte6W2WqATw4w738ktcN
         kYvzXsc1vsx8DQMcxTVs7k5YxdXxwPcuvyXbhXqIwoyKJUgPu47PBleukDOnAXvz/Iqv
         axaA==
X-Forwarded-Encrypted: i=1; AJvYcCUckmnekmYo50z3BCB1Ldcvt8ah/6imENog6e1r+pxZd170y/T24WDl5xtweEH1pzadjnnDWjgUrg==@vger.kernel.org
X-Gm-Message-State: AOJu0YynK+fThjXR19bxJsWFBEZJedRrL7x3lzbGO/4IwrnA6NTyCcrB
	Vf9M/OKDUSlf6CNtXjvtkscK4ZRH+lUTuOWeAQYChuMJawPT8blTGmkjNT6ACecu018=
X-Gm-Gg: AY/fxX6EJwgBWqV32ghv1PKs+jBKrprC8y7SiY9eqtUtgsb3FKv2pNjnOjDOuG3iEKt
	FOOR40RjJiDPN99x9Qc71fw/ZdsFGaSLTWq9CvoMN8g/QZ84hiAHGjoQKBCAtQXcu3XxI6SGlRz
	AhNrBzwm7HuQssE29gcOfVzvVHsG5OSjNwv9EkrYSK+jnIDFt8C2it+TggRHmBEVI2sIWLOmE/V
	fMUrcsGejeINwbAq0Z5Uxez62AzDHuh9XlVqm/lk6pVEvZSygrITwPyOSZH+bR1iTVfzvGar75V
	qEYq9VOn0JqPmtC5Ns0OPUCW+jHE+4wQOgfkVwUhYgfr8F+1/aBUJe7b9LSoPskevBVe2DOT3uE
	N/DkxzsptaDD66w989mOSQeEXt7L/2DVnGASWk9ohEhfUbiaKBKygGakL9Cj1BHb0aN+3vmYtJM
	APnDvydLPFymTASaguEoQ+LAUMMTiufaKUiKYcAW53pWNnMc4mQQ==
X-Google-Smtp-Source: AGHT+IGWQPQpIrsvdXSJfAvJ+0t+0pkMYGOXS3GTEf5zU8qoT9VLYajwNfgYCjueMheau11tIi5VIw==
X-Received: by 2002:a17:90b:1d82:b0:343:edb0:1012 with SMTP id 98e67ed59e1d1-34a7287480bmr4526975a91.21.1765426237958;
        Wed, 10 Dec 2025 20:10:37 -0800 (PST)
Received: from [172.20.4.188] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2b9d8a2bsm857095a12.27.2025.12.10.20.10.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 20:10:37 -0800 (PST)
Message-ID: <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk>
Date: Wed, 10 Dec 2025 21:10:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
From: Jens Axboe <axboe@kernel.dk>
To: Fengnan Chang <fengnanchang@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
 Diangang Li <lidiangang@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-3-changfengnan@bytedance.com>
 <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
Content-Language: en-US
In-Reply-To: <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/10/25 7:15 PM, Jens Axboe wrote:
> On 12/10/25 1:55 AM, Fengnan Chang wrote:
>> In the io_do_iopoll function, when the poll loop of iopoll_list ends, it
>> is considered that the current req is the actual completed request.
>> This may be reasonable for multi-queue ctx, but is problematic for
>> single-queue ctx because the current request may not be done when the
>> poll gets to the result. In this case, the completed io needs to wait
>> for the first io on the chain to complete before notifying the user,
>> which may cause io accumulation in the list.
>> Our modification plan is as follows: change io_wq_work_list to normal
>> list so that the iopoll_list list in it can be removed and put into the
>> comp_reqs list when the request is completed. This way each io is
>> handled independently and all gets processed in time.
>>
>> After modification,  test with:
>>
>> ./t/io_uring -p1 -d128 -b4096 -s32 -c32 -F1 -B1 -R1 -X1 -n1 -P1
>> /dev/nvme6n1
>>
>> base IOPS is 725K,  patch IOPS is 782K.
>>
>> ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 -P1
>> /dev/nvme6n1
>>
>> Base IOPS is 880k, patch IOPS is 895K.
> 
> A few notes on this:
> 
> 1) Manipulating the list in io_complete_rw_iopoll() I don't think is
>    necessarily safe. Yes generally this is invoked from the
>    owning/polling task, but that's not guaranteed.
> 
> 2) The patch doesn't apply to the current tree, must be an older
>    version?
> 
> 3) When hand-applied, it still throws a compile warning about an unused
>    variable. Please don't send untested stuff...
> 
> 4) Don't just blatantly bloat the io_kiocb. When you change from a
>    singly to a doubly linked list, you're growing the io_kiocb size. You
>    should be able to use a union with struct io_task_work for example.
>    That's already 16b in size - win/win as you don't need to slow down
>    the cache management as that can keep using the linkage it currently
>    is using, and you're not bloating the io_kiocb.
> 
> 5) The already mentioned point about the cache free list now being
>    doubly linked. This is generally a _bad_ idea as removing and adding
>    entries now need to touch other entries too. That's not very cache
>    friendly.
> 
> #1 is kind of the big one, as it means you'll need to re-think how you
> do this. I do agree that the current approach isn't necessarily ideal as
> we don't process completions as quickly as we could, so I think there's
> merrit in continuing this work.

Proof of concept below, entirely untested, at a conference. Basically
does what I describe above, and retains the list manipulation logic
on the iopoll side, rather than on the completion side. Can you take
a look at this? And if it runs, can you do some numbers on that too?

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e1adb0d20a0a..54fd30abf2b8 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -316,7 +316,7 @@ struct io_ring_ctx {
 		 * manipulate the list, hence no extra locking is needed there.
 		 */
 		bool			poll_multi_queue;
-		struct io_wq_work_list	iopoll_list;
+		struct list_head	iopoll_list;
 
 		struct io_file_table	file_table;
 		struct io_rsrc_data	buf_table;
@@ -708,7 +708,16 @@ struct io_kiocb {
 
 	atomic_t			refs;
 	bool				cancel_seq_set;
-	struct io_task_work		io_task_work;
+
+	/*
+	 * IOPOLL doesn't use task_work, so use the ->iopoll_node list
+	 * entry to manage pending iopoll requests.
+	 */
+	union {
+		struct io_task_work	io_task_work;
+		struct list_head	iopoll_node;
+	};
+
 	union {
 		/*
 		 * for polled requests, i.e. IORING_OP_POLL_ADD and async armed
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index ca12ac10c0ae..4136bf04464a 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -534,7 +534,7 @@ __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	/* SQPOLL thread does its own polling */
 	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
 	    is_sqpoll_thread) {
-		while (!wq_list_empty(&ctx->iopoll_list)) {
+		while (!list_empty(&ctx->iopoll_list)) {
 			io_iopoll_try_reap_events(ctx);
 			ret = true;
 			cond_resched();
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6cb24cdf8e68..fdb0b43f6fb5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -334,7 +334,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_waitqueue_head(&ctx->poll_wq);
 	spin_lock_init(&ctx->completion_lock);
 	raw_spin_lock_init(&ctx->timeout_lock);
-	INIT_WQ_LIST(&ctx->iopoll_list);
+	INIT_LIST_HEAD(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	INIT_LIST_HEAD(&ctx->ltimeout_list);
@@ -1561,7 +1561,7 @@ __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 		return;
 
 	mutex_lock(&ctx->uring_lock);
-	while (!wq_list_empty(&ctx->iopoll_list)) {
+	while (!list_empty(&ctx->iopoll_list)) {
 		/* let it sleep and repeat later if can't complete a request */
 		if (io_do_iopoll(ctx, true) == 0)
 			break;
@@ -1626,21 +1626,18 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
 		 * forever, while the workqueue is stuck trying to acquire the
 		 * very same mutex.
 		 */
-		if (wq_list_empty(&ctx->iopoll_list) ||
-		    io_task_work_pending(ctx)) {
+		if (list_empty(&ctx->iopoll_list) || io_task_work_pending(ctx)) {
 			u32 tail = ctx->cached_cq_tail;
 
 			(void) io_run_local_work_locked(ctx, min_events);
 
-			if (task_work_pending(current) ||
-			    wq_list_empty(&ctx->iopoll_list)) {
+			if (task_work_pending(current) || list_empty(&ctx->iopoll_list)) {
 				mutex_unlock(&ctx->uring_lock);
 				io_run_task_work();
 				mutex_lock(&ctx->uring_lock);
 			}
 			/* some requests don't go through iopoll_list */
-			if (tail != ctx->cached_cq_tail ||
-			    wq_list_empty(&ctx->iopoll_list))
+			if (tail != ctx->cached_cq_tail || list_empty(&ctx->iopoll_list))
 				break;
 		}
 		ret = io_do_iopoll(ctx, !min_events);
@@ -1683,25 +1680,17 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 	 * how we do polling eventually, not spinning if we're on potentially
 	 * different devices.
 	 */
-	if (wq_list_empty(&ctx->iopoll_list)) {
+	if (list_empty(&ctx->iopoll_list)) {
 		ctx->poll_multi_queue = false;
 	} else if (!ctx->poll_multi_queue) {
 		struct io_kiocb *list_req;
 
-		list_req = container_of(ctx->iopoll_list.first, struct io_kiocb,
-					comp_list);
+		list_req = list_entry(ctx->iopoll_list.next, struct io_kiocb, iopoll_node);
 		if (list_req->file != req->file)
 			ctx->poll_multi_queue = true;
 	}
 
-	/*
-	 * For fast devices, IO may have already completed. If it has, add
-	 * it to the front so we find it first.
-	 */
-	if (READ_ONCE(req->iopoll_completed))
-		wq_list_add_head(&req->comp_list, &ctx->iopoll_list);
-	else
-		wq_list_add_tail(&req->comp_list, &ctx->iopoll_list);
+	list_add_tail(&req->iopoll_node, &ctx->iopoll_list);
 
 	if (unlikely(needs_lock)) {
 		/*
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 70ca88cc1f54..307f1f39d9f3 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1315,9 +1315,9 @@ static int io_uring_hybrid_poll(struct io_kiocb *req,
 
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
-	struct io_wq_work_node *pos, *start, *prev;
 	unsigned int poll_flags = 0;
 	DEFINE_IO_COMP_BATCH(iob);
+	struct io_kiocb *req, *tmp;
 	int nr_events = 0;
 
 	/*
@@ -1327,8 +1327,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	if (ctx->poll_multi_queue || force_nonspin)
 		poll_flags |= BLK_POLL_ONESHOT;
 
-	wq_list_for_each(pos, start, &ctx->iopoll_list) {
-		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
+	list_for_each_entry(req, &ctx->iopoll_list, iopoll_node) {
 		int ret;
 
 		/*
@@ -1357,31 +1356,20 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 
 	if (!rq_list_empty(&iob.req_list))
 		iob.complete(&iob);
-	else if (!pos)
-		return 0;
-
-	prev = start;
-	wq_list_for_each_resume(pos, prev) {
-		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
 
+	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, iopoll_node) {
 		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
 		if (!smp_load_acquire(&req->iopoll_completed))
-			break;
+			continue;
+		list_del(&req->iopoll_node);
+		wq_list_add_tail(&req->comp_list, &ctx->submit_state.compl_reqs);
 		nr_events++;
 		req->cqe.flags = io_put_kbuf(req, req->cqe.res, NULL);
 		if (req->opcode != IORING_OP_URING_CMD)
 			io_req_rw_cleanup(req, 0);
 	}
-	if (unlikely(!nr_events))
-		return 0;
-
-	pos = start ? start->next : ctx->iopoll_list.first;
-	wq_list_cut(&ctx->iopoll_list, prev, start);
-
-	if (WARN_ON_ONCE(!wq_list_empty(&ctx->submit_state.compl_reqs)))
-		return 0;
-	ctx->submit_state.compl_reqs.first = pos;
-	__io_submit_flush_completions(ctx);
+	if (nr_events)
+		__io_submit_flush_completions(ctx);
 	return nr_events;
 }
 
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 74c1a130cd87..becdfdd323a9 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -212,7 +212,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, struct io_sq_data *sqd,
 	if (cap_entries && to_submit > IORING_SQPOLL_CAP_ENTRIES_VALUE)
 		to_submit = IORING_SQPOLL_CAP_ENTRIES_VALUE;
 
-	if (to_submit || !wq_list_empty(&ctx->iopoll_list)) {
+	if (to_submit || !list_empty(&ctx->iopoll_list)) {
 		const struct cred *creds = NULL;
 
 		io_sq_start_worktime(ist);
@@ -221,7 +221,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, struct io_sq_data *sqd,
 			creds = override_creds(ctx->sq_creds);
 
 		mutex_lock(&ctx->uring_lock);
-		if (!wq_list_empty(&ctx->iopoll_list))
+		if (!list_empty(&ctx->iopoll_list))
 			io_do_iopoll(ctx, true);
 
 		/*
@@ -344,7 +344,7 @@ static int io_sq_thread(void *data)
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, sqd, cap_entries, &ist);
 
-			if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
+			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
 		}
 		if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
@@ -379,7 +379,7 @@ static int io_sq_thread(void *data)
 				atomic_or(IORING_SQ_NEED_WAKEUP,
 						&ctx->rings->sq_flags);
 				if ((ctx->flags & IORING_SETUP_IOPOLL) &&
-				    !wq_list_empty(&ctx->iopoll_list)) {
+				    !list_empty(&ctx->iopoll_list)) {
 					needs_sched = false;
 					break;
 				}

-- 
Jens Axboe

