Return-Path: <io-uring+bounces-11009-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DCDACCB5001
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 08:40:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 76DD8300F580
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 07:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E835A32C8B;
	Thu, 11 Dec 2025 07:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fpdHl6VO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7A62BEC42
	for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 07:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765438737; cv=none; b=ZZhvFjywV3mrcrzhbAIx259p9nCMAS1Nd2oNKScil3hEaXpjiwCY8z3q8IHy8u/NmxnE3m7x35dk7QGMeTTC/KxvuBAM9o1vYx11tYQZ8sdxwz0wNAPJmlBYDBAX2BeaNRw9n/h/7yZ5ZXY6jkWXascz0187jgI/y8ezgQJzxnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765438737; c=relaxed/simple;
	bh=ira2TFwd2k4PpoL6qGvcd7fkr+sDaT5I6prUvQbe1zQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P8Oj8XuBdFLXOm7d1ZNq3AJE90q35AdgaEbSIBiW0+yBdS9SeC8e+A/aqLaY+wPqjSaLbsc+F9toqPXZOSdZaF1TlSGbR6JNUOzuDz2IYBpxC3ws65sIOoRSqK2EosDfI19yFc0Usu9SGQjtp6P2yLhtawedYHpwA/ga1Cv644w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fpdHl6VO; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso815742b3a.1
        for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 23:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765438734; x=1766043534; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cEVkhhQIloxlMzKVVz3bzC6iLUqlz4cAxeJa9vYvecQ=;
        b=fpdHl6VOH/QItCfb/6/HqnFDNMhHRprfD4tJxo6D8MYPRpZD6kLzJWGfrIdzvdWYhF
         lOHGRdMITcwD0md2+lsyw5YNGZZzyhATDnvfxGwR6bu1TUHWzy32VZy+Wq9/rjBMWkvS
         KlaNNBcl7PeW4fvWmQu/OJ/7I7ryVJQZfQbkYf0pE/JPYMQfEI0Tk418RrohKIxRXSuH
         cEb+OY66ekpbJMP6ktR5QS74uzg3lpc6pKeWtFPQkeHPV2MhAWOcFGg8p5b+s1ZUBKGB
         fgXNpRIA+QaB/fIeBPxGXMuC/Khj/ir7frDvLn2cZJVizkjQKpBV14wCa7HxEJMd217J
         OHOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765438734; x=1766043534;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cEVkhhQIloxlMzKVVz3bzC6iLUqlz4cAxeJa9vYvecQ=;
        b=JN+DiIXn179g/S5BK4H1ZZISwBV6iVH6WpXJIFTaXs8kw9WOHBas7189nhkCfObohX
         iXS5mn6Q78qhZbkUi5ysQDVTfVBVNgSY8c7DHAcC4+8X7IHD5mgeBBqP5wqdjuGmWgZi
         /0n5Yl0QAxHbfsn9DxPW4xhEgOvLr/KTXtX0/7Tq2HXzcr243ZMY9OPjSnhf30ggQc7H
         17MWps5xRQ1NvzdimsRaKzXMoH69OnwLZPlM4u5+vzn/urjXnzkUp8+WmjM5JP6ooe5P
         1yU1Zj7S7Unt5tpXqSo9Oo77qSLXwcwrbIubTx6tUiiGnpGa/QTLTAaJ07SZhw8p7GgV
         5ngA==
X-Forwarded-Encrypted: i=1; AJvYcCW6SwX6PMizx9VzFvA8cROLbsc3oGleDJiS11AYvGhF5+IOGvrRhE//eMCkZpmOZWqiqxIAA0+4kw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyDKy9gLMWoF6ANbwBEFHEYMSBzV50jgbg25P/ton3iZC58b5zJ
	Fh8j+xN4irtLL9oGiZZ9way3L6Uzup7pu4LIChQifCzcgl9kgQbkoB93
X-Gm-Gg: AY/fxX6Q7blRaXwkXGjXvoq4v+NJAUO4lm/GF4wY9BStiNPxD0x56jiHdYLoYb9C5/z
	FeTW6SfRDougz/prfj59w3Ri68UEJMNNVsFwaJxCzMXDauQKrVkiUH3d45Issyq5uVIGDiS/SPH
	F1OzjiI95BxlZ1sBXXkeXijRvZSSsIngJsVKHsOlx1iETjJwU1gg7rJz9lx2lFLDzlbD7fR4Fjf
	olX6Q6Kc4wlNVVT1mtSglDKNpoBQtMjDNcym704FSRBBYkt788Hzdm+CjOEul2ps6037dcDbwhC
	7LIbiN5sE94B/wMtsqUb9e0mosoj0U6zocdPF52MrWlz5IyT4/CsjthA3glN8T3NBgAf8W2SPVE
	vuDTsHVhx+V+SIOJkFcZNdlc2kpnZdE85keB4QUiec7Bd9oTLfkFq7vAAdbU7RlnRG39xi0V9TY
	TIPO87WlW+4EeRBJoDeK34EixVB9kp5Mc=
X-Google-Smtp-Source: AGHT+IGqvMNYVj5tXrQGKJ5/opY/oaPe99N6Qph0k58aqNKGOApmijmp/kjhkR/+QgtWMQoYmOggjg==
X-Received: by 2002:a05:6a20:72a0:b0:366:14ac:e1ef with SMTP id adf61e73a8af0-366e299c641mr5889928637.65.1765438734339;
        Wed, 10 Dec 2025 23:38:54 -0800 (PST)
Received: from [100.82.101.13] ([203.208.167.148])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34a9264e4f6sm1067530a91.2.2025.12.10.23.38.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 23:38:53 -0800 (PST)
Message-ID: <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com>
Date: Thu, 11 Dec 2025 15:38:49 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
To: Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
 Diangang Li <lidiangang@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-3-changfengnan@bytedance.com>
 <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
 <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk>
From: Fengnan <fengnanchang@gmail.com>
In-Reply-To: <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/12/11 12:10, Jens Axboe 写道:
> On 12/10/25 7:15 PM, Jens Axboe wrote:
>> On 12/10/25 1:55 AM, Fengnan Chang wrote:
>>> In the io_do_iopoll function, when the poll loop of iopoll_list ends, it
>>> is considered that the current req is the actual completed request.
>>> This may be reasonable for multi-queue ctx, but is problematic for
>>> single-queue ctx because the current request may not be done when the
>>> poll gets to the result. In this case, the completed io needs to wait
>>> for the first io on the chain to complete before notifying the user,
>>> which may cause io accumulation in the list.
>>> Our modification plan is as follows: change io_wq_work_list to normal
>>> list so that the iopoll_list list in it can be removed and put into the
>>> comp_reqs list when the request is completed. This way each io is
>>> handled independently and all gets processed in time.
>>>
>>> After modification,  test with:
>>>
>>> ./t/io_uring -p1 -d128 -b4096 -s32 -c32 -F1 -B1 -R1 -X1 -n1 -P1
>>> /dev/nvme6n1
>>>
>>> base IOPS is 725K,  patch IOPS is 782K.
>>>
>>> ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 -P1
>>> /dev/nvme6n1
>>>
>>> Base IOPS is 880k, patch IOPS is 895K.
>> A few notes on this:
>>
>> 1) Manipulating the list in io_complete_rw_iopoll() I don't think is
>>     necessarily safe. Yes generally this is invoked from the
>>     owning/polling task, but that's not guaranteed.
>>
>> 2) The patch doesn't apply to the current tree, must be an older
>>     version?
>>
>> 3) When hand-applied, it still throws a compile warning about an unused
>>     variable. Please don't send untested stuff...
>>
>> 4) Don't just blatantly bloat the io_kiocb. When you change from a
>>     singly to a doubly linked list, you're growing the io_kiocb size. You
>>     should be able to use a union with struct io_task_work for example.
>>     That's already 16b in size - win/win as you don't need to slow down
>>     the cache management as that can keep using the linkage it currently
>>     is using, and you're not bloating the io_kiocb.
>>
>> 5) The already mentioned point about the cache free list now being
>>     doubly linked. This is generally a _bad_ idea as removing and adding
>>     entries now need to touch other entries too. That's not very cache
>>     friendly.
>>
>> #1 is kind of the big one, as it means you'll need to re-think how you
>> do this. I do agree that the current approach isn't necessarily ideal as
>> we don't process completions as quickly as we could, so I think there's
>> merrit in continuing this work.
> Proof of concept below, entirely untested, at a conference. Basically
> does what I describe above, and retains the list manipulation logic
> on the iopoll side, rather than on the completion side. Can you take
> a look at this? And if it runs, can you do some numbers on that too?

This patch works, and in my test case, the performance is identical to 
my patch.
But there is a small problem, now looking for completed requests, always 
need to
traverse the whole iopoll_list. this can be a bit inefficient in some 
cases, for
example if the previous sent 128K io , the last io is 4K, the last io 
will be returned
much earlier, this kind of scenario can not be verified in the current test.
I'm not sure if it's a meaningful scenario.

> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index e1adb0d20a0a..54fd30abf2b8 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -316,7 +316,7 @@ struct io_ring_ctx {
>   		 * manipulate the list, hence no extra locking is needed there.
>   		 */
>   		bool			poll_multi_queue;
> -		struct io_wq_work_list	iopoll_list;
> +		struct list_head	iopoll_list;
>   
>   		struct io_file_table	file_table;
>   		struct io_rsrc_data	buf_table;
> @@ -708,7 +708,16 @@ struct io_kiocb {
>   
>   	atomic_t			refs;
>   	bool				cancel_seq_set;
> -	struct io_task_work		io_task_work;
> +
> +	/*
> +	 * IOPOLL doesn't use task_work, so use the ->iopoll_node list
> +	 * entry to manage pending iopoll requests.
> +	 */
> +	union {
> +		struct io_task_work	io_task_work;
> +		struct list_head	iopoll_node;
> +	};
> +
>   	union {
>   		/*
>   		 * for polled requests, i.e. IORING_OP_POLL_ADD and async armed
> diff --git a/io_uring/cancel.c b/io_uring/cancel.c
> index ca12ac10c0ae..4136bf04464a 100644
> --- a/io_uring/cancel.c
> +++ b/io_uring/cancel.c
> @@ -534,7 +534,7 @@ __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>   	/* SQPOLL thread does its own polling */
>   	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
>   	    is_sqpoll_thread) {
> -		while (!wq_list_empty(&ctx->iopoll_list)) {
> +		while (!list_empty(&ctx->iopoll_list)) {
>   			io_iopoll_try_reap_events(ctx);
>   			ret = true;
>   			cond_resched();
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 6cb24cdf8e68..fdb0b43f6fb5 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -334,7 +334,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   	init_waitqueue_head(&ctx->poll_wq);
>   	spin_lock_init(&ctx->completion_lock);
>   	raw_spin_lock_init(&ctx->timeout_lock);
> -	INIT_WQ_LIST(&ctx->iopoll_list);
> +	INIT_LIST_HEAD(&ctx->iopoll_list);
>   	INIT_LIST_HEAD(&ctx->defer_list);
>   	INIT_LIST_HEAD(&ctx->timeout_list);
>   	INIT_LIST_HEAD(&ctx->ltimeout_list);
> @@ -1561,7 +1561,7 @@ __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
>   		return;
>   
>   	mutex_lock(&ctx->uring_lock);
> -	while (!wq_list_empty(&ctx->iopoll_list)) {
> +	while (!list_empty(&ctx->iopoll_list)) {
>   		/* let it sleep and repeat later if can't complete a request */
>   		if (io_do_iopoll(ctx, true) == 0)
>   			break;
> @@ -1626,21 +1626,18 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
>   		 * forever, while the workqueue is stuck trying to acquire the
>   		 * very same mutex.
>   		 */
> -		if (wq_list_empty(&ctx->iopoll_list) ||
> -		    io_task_work_pending(ctx)) {
> +		if (list_empty(&ctx->iopoll_list) || io_task_work_pending(ctx)) {
>   			u32 tail = ctx->cached_cq_tail;
>   
>   			(void) io_run_local_work_locked(ctx, min_events);
>   
> -			if (task_work_pending(current) ||
> -			    wq_list_empty(&ctx->iopoll_list)) {
> +			if (task_work_pending(current) || list_empty(&ctx->iopoll_list)) {
>   				mutex_unlock(&ctx->uring_lock);
>   				io_run_task_work();
>   				mutex_lock(&ctx->uring_lock);
>   			}
>   			/* some requests don't go through iopoll_list */
> -			if (tail != ctx->cached_cq_tail ||
> -			    wq_list_empty(&ctx->iopoll_list))
> +			if (tail != ctx->cached_cq_tail || list_empty(&ctx->iopoll_list))
>   				break;
>   		}
>   		ret = io_do_iopoll(ctx, !min_events);
> @@ -1683,25 +1680,17 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
>   	 * how we do polling eventually, not spinning if we're on potentially
>   	 * different devices.
>   	 */
> -	if (wq_list_empty(&ctx->iopoll_list)) {
> +	if (list_empty(&ctx->iopoll_list)) {
>   		ctx->poll_multi_queue = false;
>   	} else if (!ctx->poll_multi_queue) {
>   		struct io_kiocb *list_req;
>   
> -		list_req = container_of(ctx->iopoll_list.first, struct io_kiocb,
> -					comp_list);
> +		list_req = list_entry(ctx->iopoll_list.next, struct io_kiocb, iopoll_node);
>   		if (list_req->file != req->file)
>   			ctx->poll_multi_queue = true;
>   	}
>   
> -	/*
> -	 * For fast devices, IO may have already completed. If it has, add
> -	 * it to the front so we find it first.
> -	 */
> -	if (READ_ONCE(req->iopoll_completed))
> -		wq_list_add_head(&req->comp_list, &ctx->iopoll_list);
> -	else
> -		wq_list_add_tail(&req->comp_list, &ctx->iopoll_list);
> +	list_add_tail(&req->iopoll_node, &ctx->iopoll_list);
>   
>   	if (unlikely(needs_lock)) {
>   		/*
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 70ca88cc1f54..307f1f39d9f3 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -1315,9 +1315,9 @@ static int io_uring_hybrid_poll(struct io_kiocb *req,
>   
>   int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>   {
> -	struct io_wq_work_node *pos, *start, *prev;
>   	unsigned int poll_flags = 0;
>   	DEFINE_IO_COMP_BATCH(iob);
> +	struct io_kiocb *req, *tmp;
>   	int nr_events = 0;
>   
>   	/*
> @@ -1327,8 +1327,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>   	if (ctx->poll_multi_queue || force_nonspin)
>   		poll_flags |= BLK_POLL_ONESHOT;
>   
> -	wq_list_for_each(pos, start, &ctx->iopoll_list) {
> -		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
> +	list_for_each_entry(req, &ctx->iopoll_list, iopoll_node) {
>   		int ret;
>   
>   		/*
> @@ -1357,31 +1356,20 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>   
>   	if (!rq_list_empty(&iob.req_list))
>   		iob.complete(&iob);
> -	else if (!pos)
> -		return 0;
> -
> -	prev = start;
> -	wq_list_for_each_resume(pos, prev) {
> -		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
>   
> +	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, iopoll_node) {
>   		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
>   		if (!smp_load_acquire(&req->iopoll_completed))
> -			break;
> +			continue;
> +		list_del(&req->iopoll_node);
> +		wq_list_add_tail(&req->comp_list, &ctx->submit_state.compl_reqs);
>   		nr_events++;
>   		req->cqe.flags = io_put_kbuf(req, req->cqe.res, NULL);
>   		if (req->opcode != IORING_OP_URING_CMD)
>   			io_req_rw_cleanup(req, 0);
>   	}
> -	if (unlikely(!nr_events))
> -		return 0;
> -
> -	pos = start ? start->next : ctx->iopoll_list.first;
> -	wq_list_cut(&ctx->iopoll_list, prev, start);
> -
> -	if (WARN_ON_ONCE(!wq_list_empty(&ctx->submit_state.compl_reqs)))
> -		return 0;
> -	ctx->submit_state.compl_reqs.first = pos;
> -	__io_submit_flush_completions(ctx);
> +	if (nr_events)
> +		__io_submit_flush_completions(ctx);
>   	return nr_events;
>   }
>   
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 74c1a130cd87..becdfdd323a9 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -212,7 +212,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, struct io_sq_data *sqd,
>   	if (cap_entries && to_submit > IORING_SQPOLL_CAP_ENTRIES_VALUE)
>   		to_submit = IORING_SQPOLL_CAP_ENTRIES_VALUE;
>   
> -	if (to_submit || !wq_list_empty(&ctx->iopoll_list)) {
> +	if (to_submit || !list_empty(&ctx->iopoll_list)) {
>   		const struct cred *creds = NULL;
>   
>   		io_sq_start_worktime(ist);
> @@ -221,7 +221,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, struct io_sq_data *sqd,
>   			creds = override_creds(ctx->sq_creds);
>   
>   		mutex_lock(&ctx->uring_lock);
> -		if (!wq_list_empty(&ctx->iopoll_list))
> +		if (!list_empty(&ctx->iopoll_list))
>   			io_do_iopoll(ctx, true);
>   
>   		/*
> @@ -344,7 +344,7 @@ static int io_sq_thread(void *data)
>   		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>   			int ret = __io_sq_thread(ctx, sqd, cap_entries, &ist);
>   
> -			if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
> +			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
>   				sqt_spin = true;
>   		}
>   		if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
> @@ -379,7 +379,7 @@ static int io_sq_thread(void *data)
>   				atomic_or(IORING_SQ_NEED_WAKEUP,
>   						&ctx->rings->sq_flags);
>   				if ((ctx->flags & IORING_SETUP_IOPOLL) &&
> -				    !wq_list_empty(&ctx->iopoll_list)) {
> +				    !list_empty(&ctx->iopoll_list)) {
>   					needs_sched = false;
>   					break;
>   				}
>


