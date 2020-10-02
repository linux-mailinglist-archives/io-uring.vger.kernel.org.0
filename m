Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D730281466
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 15:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387869AbgJBNpB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 09:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387768AbgJBNo5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 09:44:57 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82930C0613D0
        for <io-uring@vger.kernel.org>; Fri,  2 Oct 2020 06:44:55 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id q1so1272237ilt.6
        for <io-uring@vger.kernel.org>; Fri, 02 Oct 2020 06:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HuaZxNIjoxmWBPLmDlP+LOvkz0SeC33XVwnI4UoKcgE=;
        b=08Ay7ZlS8S/Op/x80hiuzkfNTS5Oj+MH/QKuVeRlMOF2r4DyLOxGukrNI+Ow4+oYPG
         rr2RDuVx8BxmHopJA7CP75K2yMZcGzSehFb8uvLT3uuZ5wtU3vWP6sMJ8Z/rycSuUtbS
         o4PUSyxqOh/0tH8aPpbjLtcdpidN4IxgH5rn3TlvZQtMulRexpF0NoZJlZC1WAwiKbMW
         uRsJeSsuGF5CXMXJAWyNJ12uSt4SqVNzZD6zTrGwoS9xofivIMtpIxVnu0R5rvqe40EU
         dLWo6dRNhTg1I3eXah4YLNPFhfWodsha8SFKJx4JZ1QhOh0md9iko1GwCtSnjrF78ems
         X3Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HuaZxNIjoxmWBPLmDlP+LOvkz0SeC33XVwnI4UoKcgE=;
        b=GgjS/5FJMqBcKRqQPnNgA6veQTZsKiFEPFhVTRoe+A2BSSe/xOtIMpBwP0/cy/H94z
         8v+Jm/yf8/u8Xe5Q599P7UOV0eVv4uXQVfubZnRzOe9rBIJzRFb+6JvVJQHMKBFM4zcR
         6YSWDmgDU0WkuWX27iEGF3RkWXKn+rDmMpVUhVTQzG8DVo44yoIYHxCstinXuJzM4l2Z
         ggjomAAOC+o7ABHX06v6fClvRdxZVSxi3efxFP8ytg2bm8uHRQVEGVRudVNXRdqCyxRp
         8Gp31kl6km8opY3jyEDPiXnvt3ePTrUrnsuBNjjjU98PejSoQ6Jv9eux7qvx+AjSY/yx
         IerQ==
X-Gm-Message-State: AOAM531/k28V/iYLQVGd5vnOtpS1JFhzTOXWAS6eE96KG/Z3cnxi5ipK
        Ca9eLSopEL2K6g9OBvRwoTRFcw==
X-Google-Smtp-Source: ABdhPJxzL2xnAh7xDB40PZMjpqbyfdQ6sXsGzL3IKo70ipbWQ2CoeaEDsE8uGCbgl4UuoX1ellY8nA==
X-Received: by 2002:a92:c212:: with SMTP id j18mr1814640ilo.244.1601646294636;
        Fri, 02 Oct 2020 06:44:54 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d1sm754041ila.67.2020.10.02.06.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 06:44:54 -0700 (PDT)
Subject: Re: [PATCH RFC v2] kernel: decouple TASK_WORK TWA_SIGNAL handling
 from signals
To:     Hillf Danton <hdanton@sina.com>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        io-uring <io-uring@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <3ce9e205-aad0-c9ce-86a7-b281f1c0237a@kernel.dk>
 <20201001162719.GD13633@redhat.com> <20201002133813.3180-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <de200581-1e95-c175-4b6a-a41636a34507@kernel.dk>
Date:   Fri, 2 Oct 2020 07:44:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201002133813.3180-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/2/20 7:38 AM, Hillf Danton wrote:
> 
> On Thu, 1 Oct 2020 11:27:04 -0600 Jens Axboe wrote:
>> On 10/1/20 10:27 AM, Oleg Nesterov wrote:
>>> Jens,
>>>
>>> I'll read this version tomorrow, but:
>>>
>>> On 10/01, Jens Axboe wrote:
>>>>
>>>>  static inline int signal_pending(struct task_struct *p)
>>>>  {
>>>> -	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
>>>> +#ifdef TIF_TASKWORK
>>>> +	/*
>>>> +	 * TIF_TASKWORK isn't really a signal, but it requires the same
>>>> +	 * behavior of restarting the system call to force a kernel/user
>>>> +	 * transition.
>>>> +	 */
>>>> +	return unlikely(test_tsk_thread_flag(p, TIF_SIGPENDING) ||
>>>> +			test_tsk_thread_flag(p, TIF_TASKWORK));
>>>> +#else
>>>> +	return unlikely(test_tsk_thread_flag(p, TIF_SIGPENDING));
>>>> +#endif
>>>
>>> This change alone is already very wrong.
>>>
>>> signal_pending(task) == T means that this task will do get_signal() as
>>> soon as it can, and this basically means you can't "divorce" SIGPENDING
>>> and TASKWORK.
>>>
>>> Simple example. Suppose we have a single-threaded task T.
>>>
>>> Someone does task_work_add(T, TWA_SIGNAL). This makes signal_pending()==T
>>> and this is what we need.
>>>
>>> Now suppose that another task sends a signal to T before T calls
>>> task_work_run() and clears TIF_TASKWORK. In this case SIGPENDING won't
>>> be set because signal_pending() is already set (see wants_signal), and
>>> this means that T won't notice this signal.
>>
>> That's a good point, and I have been thinking along those lines. The
>> "problem" is the two different use cases:
>>
>> 1) The "should I return from schedule() or break out of schedule() loops
>>    kind of use cases".
>>
>> 2) Internal signal delivery use cases.
>>
>> The former wants one that factors in TIF_TASKWORK, while the latter
>> should of course only look at TIF_SIGPENDING.
>>
>> Now, my gut reaction would be to have __signal_pending() that purely
>> checks for TIF_SIGPENDING, and make sure we use that on the signal
>> delivery side of things. Or something with a better name than that, but
>> functionally the same. Ala:
>>
>> static inline int __signal_pending(struct task_struct *p)
>> {
>> 	return unlikely(test_tsk_thread_flag(p, TIF_SIGPENDING));
>> }
>>
>> static inline int signal_pending(struct task_struct *p)
>> {
>> #ifdef TIF_TASKWORK
>> 	return unlikely(test_tsk_thread_flag(p, TIF_TASKWORK)||
>> 			__signal_pending(p));
>> #else
>> 	return __signal_pending(p));
>> #endif
>> }
>>
>> and then use __signal_pending() on the signal delivery side.
>>
>> It's still not great in the sense that renaming signal_pending() would
>> be a better choice, but that's a whole lot of churn...
> 
> To avoid that churn, IIUC replace TWA_SIGNAL with TWA_RESUME on
> adding task work, which is compensated by adding a counter of
> event source in IO ctx and waiting for event to arrive instead
> of signal.

That doesn't work. If the task is waiting in cqring_wait(), then
there's no issue already. The problem is if it's waiting somewhere
else.

Imagine three threads, call them T1-3. T1 creates a pipe, and creates
a ring. T1 queues a poll request for the read end of the pipe, and now
does a wait for T2. T2 is a completer thread, so it ends up waiting
for events on the ring. T2 is now in cqring_wait(). T3 is created,
and it writes to the pipe. This write triggers the original poll
request from T1, and task_work is now queued for T1. This task work
needs to be processed for T2 to wakeup and complete, but it can't
since T1 is in pthread_join() for T2.

This is why TWA_SIGNAL is needed, we need it to break the T1 wait
loop and process this work. No amount of changes in io_uring can
fix this dependency, and if you look at the last series posted,
it does in fact not even have any io_uring changes.

Hence the goal is to have TWA_SIGNAL have the same kind of semantics
it does now, but decoupled from ->sighand since that is problematic
on particularly threaded setups.

-- 
Jens Axboe

