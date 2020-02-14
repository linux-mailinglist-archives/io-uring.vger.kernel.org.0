Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D740515DB6D
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 16:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgBNPsA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 10:48:00 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:41378 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729090AbgBNPr7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 10:47:59 -0500
Received: by mail-io1-f67.google.com with SMTP id m25so10999740ioo.8
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 07:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9cm9nMe+tq4lmZTcYutNgobi54J7NwX7ziEbQU5p76Y=;
        b=1xsYCij8TWXrLs6rL6xUzjdj3XD/ejSu4AMs5RVjDGaYucjnopJSMn1iYVETHocfOM
         uwRhmxMmE5Il6jOQmzDWybDjaEWXMagNiiT9VDZEtGd72RwFZaR1NewuuPOZVYdHgIqn
         r0InRYNz8ys9irI5V2P0MVOteWd1xNqNo+dWngC2Ys4lnmK5CPjJsWPl9OTErhUS2QSf
         oQVecGIjckwfiU4XHTRB68WM+S9fzvK0BzAfhSN9pcLHUh+NJkc2N5Hw0X51m5wEj4Pb
         Hi1il0MF5+O1KeHJU3VSaxFbQnYl2JWwERx/9I9OPndfce35F38MyF5u3VWQClTkAXgw
         3sNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9cm9nMe+tq4lmZTcYutNgobi54J7NwX7ziEbQU5p76Y=;
        b=jpuPjtmtsVZ5vZYKahp99xGTWND/0Ue3n9iC3zjleiwdDiYk2vIApfeC3+njDHSUHl
         I+dplbHoywIZkMM70cczSe9zarNQ3PYRf3gIoPv9lOkHEV+9VLoMYZGQ3FyWEc4V+OGi
         Yrj0Nvhr+zl926/MekJKqJm5QUK7wxC8B0w1S5TCWDP4v6wT4LpkPrrpA3ryO8PDeoew
         sPwzyAQRDQECocBgWATYvtwkkQwX58yv3/Z+7x4j7YIdfQk7/LOQK0hnm0XSytW68gro
         TtoTUlaekUqYgdJ8wWNYNNywps5/QIVMC6J6XAxMlyyqg+Iv5IKO3sc9sNm5URK9igZT
         bEnA==
X-Gm-Message-State: APjAAAVdh7e5sxbD0OCcnyoflq/yTKujrcMhzABIeQCkIQVBb3ETHsgt
        W8PLKfLuloLt0/FL/6JTrlojQnMSkzo=
X-Google-Smtp-Source: APXvYqy32gBfgM64NhDo4QJelVzLiDS9QFrmFHJOnwchkP/Ml5RHmYuK50WMNiQatQCSfPKPTw/bLw==
X-Received: by 2002:a5d:9708:: with SMTP id h8mr2800933iol.141.1581695277515;
        Fri, 14 Feb 2020 07:47:57 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v18sm2088283ilm.85.2020.02.14.07.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 07:47:57 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
Date:   Fri, 14 Feb 2020 08:47:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214153218.GM14914@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/20 8:32 AM, Peter Zijlstra wrote:
> On Thu, Feb 13, 2020 at 10:03:54PM -0700, Jens Axboe wrote:
> 
>> CC'ing peterz for some cluebat knowledge. Peter, is there a nice way to
>> currently do something like this? Only thing I'm currently aware of is
>> the preempt in/out notifiers, but they don't quite provide what I need,
>> since I need to pass some data (a request) as well.
> 
> Whee, nothing quite like this around I think.

Probably not ;-)

>> The full detail on what I'm trying here is:
>>
>> io_uring can have linked requests. One obvious use case for that is to
>> queue a POLLIN on a socket, and then link a read/recv to that. When the
>> poll completes, we want to run the read/recv. io_uring hooks into the
>> waitqueue wakeup handler to finish the poll request, and since we're
>> deep in waitqueue wakeup code, it queues the linked read/recv for
>> execution via an async thread. This is not optimal, obviously, as it
>> relies on a switch to a new thread to perform this read. This hack
>> queues a backlog to the task itself, and runs it when it's scheduled in.
>> Probably want to do the same for sched out as well, currently I just
>> hack that in the io_uring wait part...
> 
> I'll definitely need to think more about this, but a few comments on the
> below.
> 
>> +static void __io_uring_task_handler(struct list_head *list)
>> +{
>> +	struct io_kiocb *req;
>> +
>> +	while (!list_empty(list)) {
>> +		req = list_first_entry(list, struct io_kiocb, list);
>> +		list_del(&req->list);
>> +
>> +		__io_queue_sqe(req, NULL);
>> +	}
>> +}
>> +
>> +void io_uring_task_handler(struct task_struct *tsk)
>> +{
>> +	LIST_HEAD(list);
>> +
>> +	raw_spin_lock_irq(&tsk->uring_lock);
>> +	if (!list_empty(&tsk->uring_work))
>> +		list_splice_init(&tsk->uring_work, &list);
>> +	raw_spin_unlock_irq(&tsk->uring_lock);
>> +
>> +	__io_uring_task_handler(&list);
>> +}
> 
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index fc1dfc007604..b60f081cac17 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -2717,6 +2717,11 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
>>  	INIT_HLIST_HEAD(&p->preempt_notifiers);
>>  #endif
>>  
>> +#ifdef CONFIG_IO_URING
>> +	INIT_LIST_HEAD(&p->uring_work);
>> +	raw_spin_lock_init(&p->uring_lock);
>> +#endif
>> +
>>  #ifdef CONFIG_COMPACTION
>>  	p->capture_control = NULL;
>>  #endif
>> @@ -3069,6 +3074,20 @@ fire_sched_out_preempt_notifiers(struct task_struct *curr,
>>  
>>  #endif /* CONFIG_PREEMPT_NOTIFIERS */
>>  
>> +#ifdef CONFIG_IO_URING
>> +extern void io_uring_task_handler(struct task_struct *tsk);
>> +
>> +static inline void io_uring_handler(struct task_struct *tsk)
>> +{
>> +	if (!list_empty(&tsk->uring_work))
>> +		io_uring_task_handler(tsk);
>> +}
>> +#else /* !CONFIG_IO_URING */
>> +static inline void io_uring_handler(struct task_struct *tsk)
>> +{
>> +}
>> +#endif
>> +
>>  static inline void prepare_task(struct task_struct *next)
>>  {
>>  #ifdef CONFIG_SMP
>> @@ -3322,6 +3341,8 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
>>  	balance_callback(rq);
>>  	preempt_enable();
>>  
>> +	io_uring_handler(current);
>> +
>>  	if (current->set_child_tid)
>>  		put_user(task_pid_vnr(current), current->set_child_tid);
>>  
> 
> I suspect you meant to put that in finish_task_switch() which is the
> tail end of every schedule(), schedule_tail() is the tail end of
> clone().
> 
> Or maybe you meant to put it in (and rename) sched_update_worker() which
> is after every schedule() but in a preemptible context -- much saner
> since you don't want to go add an unbounded amount of work in a
> non-preemptible context.
> 
> At which point you already have your callback: io_wq_worker_running(),
> or is this for any random task?

Let me try and clarify - this isn't for the worker tasks, this is for
any task that is using io_uring. In fact, it's particularly not for the
worker threads, just the task itself.

I basically want the handler to be called when:

1) The task is scheduled in. The poll will complete and stuff some items
   on that task list, and I want to task to process them as it wakes up.

2) The task is going to sleep, don't want to leave entries around while
   the task is sleeping.

3) I need it to be called from "normal" context, with ints enabled,
   preempt enabled, etc.

sched_update_worker() (with a rename) looks ideal for #1, and the
context is sane for me. Just need a good spot to put the hook call for
schedule out. I think this:

	if (tsk->flags & (PF_WQ_WORKER | PF_IO_WORKER)) {
		preempt_disable();
		if (tsk->flags & PF_WQ_WORKER)
			wq_worker_sleeping(tsk);
		else
			io_wq_worker_sleeping(tsk);
		preempt_enable_no_resched();
	}

just needs to go into another helper, and then I can call it there
outside of the preempt.

I'm sure there are daemons lurking here, but I'll test and see how it
goes...

-- 
Jens Axboe

