Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD0D3DF6D7
	for <lists+io-uring@lfdr.de>; Tue,  3 Aug 2021 23:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhHCVZh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Aug 2021 17:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbhHCVZh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Aug 2021 17:25:37 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B82C061757
        for <io-uring@vger.kernel.org>; Tue,  3 Aug 2021 14:25:25 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a8so8363668pjk.4
        for <io-uring@vger.kernel.org>; Tue, 03 Aug 2021 14:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pgAXqcVbo1jn5AnENF09t8UJUKAKlvs26pztb6oq9yw=;
        b=JdFbbLivGFbn9N0iRBjUgy/IkmSYARGZU+nrGso1wnJq5LV+jn4nNt9aXtq+FDPqEf
         0e/7rdIDb8+P0vBCG+uDAIQ+6fehOX5AZ3qpyFqdaL2wPFy15gn+G2Re4cnJkkWu596I
         sffV/IAd+t1Qw6zNnr81JKlBNMg1DoGd1FjuIqmnaRV8ixbNmazbCOaAFAnup6bsA8I6
         89pKLU+eLIhsim6Z0vOrpJU/DPpdozdAmqwillrEuKx5x4D8oXysTOA2mqJumuoTVw6r
         O6hT1pQVVYsmqB/zDviOEB5veyo9C5eadQVit1ZPILlKOxEbuDCQYNGSaWhglE1vqM9B
         /j4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pgAXqcVbo1jn5AnENF09t8UJUKAKlvs26pztb6oq9yw=;
        b=roCHYSpoL/zq9q1RlKbCvqSYysYPaCa2zfdT4qH6ZlM49Zn2JRSmCQmscMeenFhE3u
         m3siIktEUFe7psZHMACvyHsVeHZzIsCY6PzvK2KskYtPUADX7enDeXMZ/eWG97ycWe5T
         DEhloQuGkos+xa1EhtZcUqCWIi//BFjDS28eFu/Gj4qPOZV6ktWJOfEFek2Zm91mOT9y
         bxHXVSfkWRiD2c3HgyWUzODTJTZDAtEEdFlYxugkSOwqW7CmGVDlFh0LyuX+FOeaFlhy
         cS7TqBLL/HjOd0/7xpA8B278blYLEqzbENb6feEg6t09FR0XfaKD5wfDyIbdHHPxCoax
         5UPg==
X-Gm-Message-State: AOAM532yRPmlhRD6bhK2MSrruca/Uihn+Fpw6IoWBmuPxz1nEYDsrdww
        Xrh3Z5RlB+PqTNXV3ZGLITOjIw==
X-Google-Smtp-Source: ABdhPJyk9EF+yha8KJnq7ynxwWYq+izm8+JZEeOqzv4qafo6ymhkmTTOeIlYDiXjqkgBZZgyYwljqA==
X-Received: by 2002:a17:903:3091:b029:12c:d083:cfde with SMTP id u17-20020a1709033091b029012cd083cfdemr2180586plc.19.1628025925172;
        Tue, 03 Aug 2021 14:25:25 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id t8sm34437pgh.18.2021.08.03.14.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 14:25:24 -0700 (PDT)
Subject: Re: Race between io_wqe_worker() and io_wqe_wake_worker()
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     io-uring@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>
References: <BFF746C0-FEDE-4646-A253-3021C57C26C9@gmail.com>
 <5bc88410-6423-2554-340d-ef83f1ba9844@kernel.dk>
 <c6ef9d6c-3127-090f-88a2-a1ffd432bbef@kernel.dk>
 <3CEF2AD7-AD8B-478D-91ED-488E8441988F@gmail.com>
 <612d19fd-a59d-e058-b0bd-1f693bbf647d@kernel.dk>
 <B2A8D1BD-82A1-4EA3-8C7F-B38349D0D305@gmail.com>
 <5f574edb-86ca-2584-dd40-b25fa7bf0517@kernel.dk>
 <6b51481c-c45e-adf4-51ed-7f7fe927e6b9@kernel.dk>
 <A5ED2B2B-66F8-4A2D-A810-6326CD710042@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e0efdda8-4c47-5b97-11b4-f5f9e57dc8a2@kernel.dk>
Date:   Tue, 3 Aug 2021 15:25:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <A5ED2B2B-66F8-4A2D-A810-6326CD710042@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/21 3:16 PM, Nadav Amit wrote:
> 
> 
>> On Aug 3, 2021, at 12:53 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> How about this? I think this largely stems from the fact that we only
>> do a partial running decrement on exit. Left the previous checks in
>> place as well, as it will reduce the amount of times that we do need
>> to hit that case.
> 
> It did not apply cleanly on my 5.13, but after I cleaned it, it still
> got stuck (more frequently than when I used your previous solution).
> 
> I do not see the problem related to the partial running decrement.
> Thinking of it, I think that the problem might even happen if
> multiple calls to io_wqe_activate_free_worker() wake up the same worker,
> not realizing that they race (since __io_worker_busy() was still not
> called by io_worker_handle_work()).

That's actually by design for io-wq in general, we assume that the work
won't block, and in that case we only want to activate the one worker.

> Anyhow, I think there are a few problems in the patch you sent. Once I
> addressed a couple of problems, my test passes, but I am not sure you
> actually want to final result, and I am not sure it is robust/correct.
> 
> See my comments below for the changes I added and other questions I
> have (you can answer only if you have time).
> 
>>
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index cf086b01c6c6..f072995d382b 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -35,12 +35,17 @@ enum {
>> 	IO_WQE_FLAG_STALLED	= 1,	/* stalled on hash */
>> };
>>
>> +enum {
>> +	IO_WORKER_EXITING	= 0,	/* worker is exiting */
>> +};
>> +
>> /*
>>  * One for each thread in a wqe pool
>>  */
>> struct io_worker {
>> 	refcount_t ref;
>> 	unsigned flags;
>> +	unsigned long state;
>> 	struct hlist_nulls_node nulls_node;
>> 	struct list_head all_list;
>> 	struct task_struct *task;
>> @@ -130,6 +135,7 @@ struct io_cb_cancel_data {
>> };
>>
>> static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
>> +static void io_wqe_dec_running(struct io_worker *worker);
>>
>> static bool io_worker_get(struct io_worker *worker)
>> {
>> @@ -168,26 +174,21 @@ static void io_worker_exit(struct io_worker *worker)
>> {
>> 	struct io_wqe *wqe = worker->wqe;
>> 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
>> -	unsigned flags;
>>
>> 	if (refcount_dec_and_test(&worker->ref))
>> 		complete(&worker->ref_done);
>> 	wait_for_completion(&worker->ref_done);
>>
>> -	preempt_disable();
>> -	current->flags &= ~PF_IO_WORKER;
>> -	flags = worker->flags;
>> -	worker->flags = 0;
>> -	if (flags & IO_WORKER_F_RUNNING)
>> -		atomic_dec(&acct->nr_running);
>> -	worker->flags = 0;
>> -	preempt_enable();
>> -
>> 	raw_spin_lock_irq(&wqe->lock);
>> -	if (flags & IO_WORKER_F_FREE)
>> +	if (worker->flags & IO_WORKER_F_FREE)
>> 		hlist_nulls_del_rcu(&worker->nulls_node);
>> 	list_del_rcu(&worker->all_list);
>> 	acct->nr_workers--;
>> +	preempt_disable();
>> +	io_wqe_dec_running(worker);
> 
> IIUC, in the scenario I encountered, acct->nr_running might be non-zero,
> but still a new worker would be needed. So the check in io_wqe_dec_running()
> is insufficient to spawn a new worker at this point, no?

If nr_running != 0, then we have active workers. They will either
complete the work they have without blocking, or if they block, then
we'll create a new one. So it really should be enough, I'm a bit
puzzled...

>> +	worker->flags = 0;
>> +	current->flags &= ~PF_IO_WORKER;
>> +	preempt_enable();
>> 	raw_spin_unlock_irq(&wqe->lock);
>>
>> 	kfree_rcu(worker, rcu);
>> @@ -214,15 +215,20 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe)
>> 	struct hlist_nulls_node *n;
>> 	struct io_worker *worker;
>>
>> -	n = rcu_dereference(hlist_nulls_first_rcu(&wqe->free_list));
>> -	if (is_a_nulls(n))
>> -		return false;
>> -
>> -	worker = hlist_nulls_entry(n, struct io_worker, nulls_node);
>> -	if (io_worker_get(worker)) {
>> -		wake_up_process(worker->task);
>> +	/*
>> +	 * Iterate free_list and see if we can find an idle worker to
>> +	 * activate. If a given worker is on the free_list but in the process
>> +	 * of exiting, keep trying.
>> +	 */
>> +	hlist_nulls_for_each_entry_rcu(worker, n, &wqe->free_list, nulls_node) {
>> +		if (!io_worker_get(worker))
>> +			continue;
> 
> Presumably you want to rely on the order between io_worker_get(), i.e.
> the refcount_inc_not_zero() and the test_bit(). I guess no memory-barrier
> is needed here (since refcount_inc_not_zero() returns a value) but
> documentation would help. Anyhow, I do not see how it helps.

Right, no extra barriers needed.

>> +		if (!test_bit(IO_WORKER_EXITING, &worker->state)) {
>> +			wake_up_process(worker->task);
> 
> So this might be the main problem. The worker might be in between waking
> and setting IO_WORKER_EXITING. One option (that I tried and works, at
> least in limited testing), is to look whether the process was actually
> woken according to the return value of wake_up_process() and not to
> use workers that were not actually woken.
> 
> So I changed it to:
>                         if (wake_up_process(worker->task)) {
>                                 io_worker_release(worker);
>                                 return true;
>                         }
> 
> 
>> +			io_worker_release(worker);
> 
> The refcount is decreased, so the refcount_read in io_wqe_worker()
> would not see the elevated refcount. No?

That's probably not a bad idea, though not quite sure that'd always be
safe. I'm going to need to look deeper, because we really should not
have a lot of concurrent activity here in terms of multiple issuers
looking up free workers and activating them.

Can you share a bit about what the workload looks like? That might help
create a reproducer, which would be handy going forward as well.

>> +			return true;
>> +		}
>> 		io_worker_release(worker);
>> -		return true;
>> 	}
>>
>> 	return false;
>> @@ -560,8 +566,17 @@ static int io_wqe_worker(void *data)
>> 		if (ret)
>> 			continue;
>> 		/* timed out, exit unless we're the fixed worker */
>> -		if (!(worker->flags & IO_WORKER_F_FIXED))
>> +		if (!(worker->flags & IO_WORKER_F_FIXED)) {
>> +			/*
>> +			 * Someone elevated our refs, which could be trying
>> +			 * to re-activate for work. Loop one more time for
>> +			 * that case.
>> +			 */
>> +			if (refcount_read(&worker->ref) != 1)
>> +				continue;
> 
> I am not sure what it serves, as the refcount is decreased in
> io_wqe_activate_free_worker() right after wake_up_process().

It should just go away I think, it'd be better to cut the patch down to
the functional part.

> Anyhow, presumably you need smp_mb__before_atomic() here, no? I added
> one. Yet, without the check in the wake_up_process() this still seems
> borken.

Yes, it would need that.

-- 
Jens Axboe

