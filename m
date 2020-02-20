Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A49E166A38
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 23:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgBTWOl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 17:14:41 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33795 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbgBTWOl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 17:14:41 -0500
Received: by mail-pg1-f195.google.com with SMTP id j4so2629538pgi.1
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 14:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CDj4SubGp9kb33ZX/H3TLWDoThhSA8Hb5NlhhtFOx+8=;
        b=q+SXzgqQcIZN5sqePaJ4tXNWqr9rXx5VcyGywgiwaXPrZIpHjPfHy1DQQq0KpjUVeP
         zdt0TxsdOlHIdY2V0Nf4zULjQxZVstfzlT/tLSUUOD3ynGTu1KG6HiCL3euIiQDRr7aI
         mwk4iDtkNXs+8hfp+X0vaG+pXXX5Pizpenm9FLrp80thC7eXtjhDPDhALHZfslKf3nMg
         ryO+HFWthfbWee+VvC93gjqz6baAw7Lag82agTJcjASbvEq9wZsaXHc4FMCcS9q31GsO
         WZjdX5FFFkCLLPm+NFxKXF5JBLUJtxNyQCQa1ZjXATkgfTEyiX4weByRuU9wUfcisS66
         ahTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CDj4SubGp9kb33ZX/H3TLWDoThhSA8Hb5NlhhtFOx+8=;
        b=kcLccYiIghY6iofs2uEcrb2ffS/aCOXAAgROpZ+/lkpNpXlx9cE74UsMk3FwI+s7cd
         caAxvCQkSf316r1Zw7ziye6AgWGWHNacDJEQSQZN40Qc006fz2vZgMHNUTBZQ/zX0G0S
         4jIQIEoFHzBQ+eYvyXuCs9+j1sDGDRkQHESe7XeQ/o9wstOoWGjBBVKbYR1UJLxgAF/m
         cSceQ67UpCSjoTWg+hEhYXhgT37Zwi2DLfiWaVsH8nxRun5m/jCGrZ1blCAsXyk9xWcv
         TeEqYJCnvhxwBuBvz/FcNYvX08Cqg5iX+z87YZYOgjNRtDUm5NwTcVMWtU6bdJ/7tDSv
         KtLg==
X-Gm-Message-State: APjAAAVRByT4HYeoO+rfa11gojhgDzN0g5XRrGnD/PI3XRLZ3D+M2Ofq
        ezlhnCiLL0xm94+TaucZKqfH4w==
X-Google-Smtp-Source: APXvYqyxECKHlNVFoVVIwvaScin7Kv9TUf5zUgWkembmjJ92KTHLbxSU35MbjMWbozk5vn64jen1bQ==
X-Received: by 2002:a62:cd89:: with SMTP id o131mr35111110pfg.100.1582236880323;
        Thu, 20 Feb 2020 14:14:40 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1130::1006? ([2620:10d:c090:180::17d5])
        by smtp.gmail.com with ESMTPSA id e18sm585790pfm.24.2020.02.20.14.14.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 14:14:39 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b78cd45a-9e6f-04ec-d096-d6e1f6cec8bd@kernel.dk>
Date:   Thu, 20 Feb 2020 14:14:36 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 3:02 PM, Jann Horn wrote:
> On Thu, Feb 20, 2020 at 9:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> For poll requests, it's not uncommon to link a read (or write) after
>> the poll to execute immediately after the file is marked as ready.
>> Since the poll completion is called inside the waitqueue wake up handler,
>> we have to punt that linked request to async context. This slows down
>> the processing, and actually means it's faster to not use a link for this
>> use case.
>>
>> We also run into problems if the completion_lock is contended, as we're
>> doing a different lock ordering than the issue side is. Hence we have
>> to do trylock for completion, and if that fails, go async. Poll removal
>> needs to go async as well, for the same reason.
>>
>> eventfd notification needs special case as well, to avoid stack blowing
>> recursion or deadlocks.
>>
>> These are all deficiencies that were inherited from the aio poll
>> implementation, but I think we can do better. When a poll completes,
>> simply queue it up in the task poll list. When the task completes the
>> list, we can run dependent links inline as well. This means we never
>> have to go async, and we can remove a bunch of code associated with
>> that, and optimizations to try and make that run faster. The diffstat
>> speaks for itself.
> [...]
>> -static void io_poll_trigger_evfd(struct io_wq_work **workptr)
>> +static void io_poll_task_func(struct callback_head *cb)
>>  {
>> -       struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
>> +       struct io_kiocb *req = container_of(cb, struct io_kiocb, sched_work);
>> +       struct io_kiocb *nxt = NULL;
>>
> [...]
>> +       io_poll_task_handler(req, &nxt);
>> +       if (nxt)
>> +               __io_queue_sqe(nxt, NULL);
> 
> This can now get here from anywhere that calls schedule(), right?
> Which means that this might almost double the required kernel stack
> size, if one codepath exists that calls schedule() while near the
> bottom of the stack and another codepath exists that goes from here
> through the VFS and again uses a big amount of stack space? This is a
> somewhat ugly suggestion, but I wonder whether it'd make sense to
> check whether we've consumed over 25% of stack space, or something
> like that, and if so, directly punt the request.

Right, it'll increase the stack usage. Not against adding some safe
guard that punts if we're too deep in, though I'd have to look how to
even do that... Looks like stack_not_used(), though it's not clear to me
how efficient that is?

> Also, can we recursively hit this point? Even if __io_queue_sqe()
> doesn't *want* to block, the code it calls into might still block on a
> mutex or something like that, at which point the mutex code would call
> into schedule(), which would then again hit sched_out_update() and get
> here, right? As far as I can tell, this could cause unbounded
> recursion.

The sched_work items are pruned before being run, so that can't happen.

> (On modern kernels with CONFIG_VMAP_STACK=y, running out of stack
> space on a task stack is "just" a plain kernel oops instead of nasty
> memory corruption, but we still should really try to avoid it.)

Certainly!

>> @@ -3646,46 +3596,11 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>>
>>         list_del_init(&poll->wait.entry);
>>
> [...]
>> +       tsk = req->task;
>> +       req->result = mask;
>> +       init_task_work(&req->sched_work, io_poll_task_func);
>> +       sched_work_add(tsk, &req->sched_work);
> 
> Doesn't this have to check the return value?

Trying to think if we can get here with TASK_EXITING, but probably safer
to just handle it in any case. I'll add that.

>> +       wake_up_process(tsk);
>>         return 1;
>>  }
>>
>> @@ -3733,6 +3648,9 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>>
>>         events = READ_ONCE(sqe->poll_events);
>>         poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
>> +
>> +       /* task will wait for requests on exit, don't need a ref */
>> +       req->task = current;
> 
> Can we get here in SQPOLL mode?

We can, this and the async poll arm should just revert to the old
behavior for SQPOLL. I'll make that change.

Thanks for taking a look!

-- 
Jens Axboe

