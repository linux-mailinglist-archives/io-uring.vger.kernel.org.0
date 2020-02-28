Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5073D17402C
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 20:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgB1TSD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 14:18:03 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:33352 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgB1TSC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 14:18:02 -0500
Received: by mail-il1-f193.google.com with SMTP id r4so2326184iln.0
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2020 11:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7MhE9X7UYFrqQkBEM8p4df2bFvhxemtvUVISEY3Agy0=;
        b=fYcfhzlZ4JQeryPDtdspaVtJA29LyPH2xXxeoO9iO9/aFUs6w6ZqYcADKESvctiWVZ
         04NVJW8X/cyOoZpqU4Vjoa81GxOVqMVI3Rw1HOevGkVbgSbb9Xm9RilMe0E/ANpaqUgy
         CLmps0qVztnMXED7RyPoX5YbCfmMqapFm5UP8zlhtnBI2XeNmZdX7kCSmXHuAZQZaVDW
         u0L5z3C+NFhVVXG1b7G18h1LZmgb5LdofoUDLWhAu7X9G8oHPiAu2XMDY5qd9734LN2C
         h7zrfWC08jYhbwDHSEz1BmpVyRWOBiS2LAOOPZE5Gp172u8ZDYzDgC79zfVTonJ3XK0h
         07Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7MhE9X7UYFrqQkBEM8p4df2bFvhxemtvUVISEY3Agy0=;
        b=jsHJVBqgwelZrNu9DJVKrHDB4OWvXc/bsdet4efgIrBkAFL2RHmnCb2vuKy0KI2d5q
         ApbEXSxkWJuPhlxhShPiAREONrw9Kc0c4854nSsmFjCM84DGNlgnYa7xh0ePaHWbKXaH
         f0A0SaSIh7jl/P/Up8KR9GXfZzDkxkS26qQJ5aj9MRLf3qxbA97wcAEHJVQVFCibPcQI
         H4kNlwOR9yoffxo+wmskYEVWKCeZsAhs+6/+S0nGIPGPS6KhPBcdYVNb2AaemHOZQs8x
         XwRpT8PLzCzb/nmCRIDaKkJHpft0ogeHRcPRLUk4XKAynxFUeVYvJM2ldxrlej5xSDL9
         E8/w==
X-Gm-Message-State: APjAAAVszHT49sv+5mxta8dcsQ1474sKT6H0das6nHqsPRd/Cdrda4sM
        pOXDcf7Zidr2gVWhQtc1qeKhJFXk3fw=
X-Google-Smtp-Source: APXvYqy/le2WGe1wZ//2TpkwS1lo8ktG2871duP8/qKqATVYLJANVlSJs6i94OVHaPkTyEP104A0Ug==
X-Received: by 2002:a92:489a:: with SMTP id j26mr5639356ilg.302.1582917480048;
        Fri, 28 Feb 2020 11:18:00 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t9sm2411853iof.88.2020.02.28.11.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 11:17:59 -0800 (PST)
Subject: Re: [PATCH] task_work_run: don't take ->pi_lock unconditionally
From:   Jens Axboe <axboe@kernel.dk>
To:     Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <20200218145645.GB3466@redhat.com>
 <20200218150756.GC14914@hirez.programming.kicks-ass.net>
 <20200218155017.GD3466@redhat.com>
 <20200220163938.GA18400@hirez.programming.kicks-ass.net>
 <20200220172201.GC27143@redhat.com>
 <20200220174932.GB18400@hirez.programming.kicks-ass.net>
 <20200221145256.GA16646@redhat.com>
 <77349a8d-ecbf-088d-3a48-321f68f1774f@kernel.dk>
Message-ID: <de55c2ac-bc94-14d8-68b1-b2a9c0cb7428@kernel.dk>
Date:   Fri, 28 Feb 2020 12:17:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <77349a8d-ecbf-088d-3a48-321f68f1774f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 11:47 AM, Jens Axboe wrote:
> On 2/21/20 7:52 AM, Oleg Nesterov wrote:
>> On 02/20, Peter Zijlstra wrote:
>>>
>>> On Thu, Feb 20, 2020 at 06:22:02PM +0100, Oleg Nesterov wrote:
>>>> @@ -68,10 +65,10 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
>>>>  	 * we raced with task_work_run(), *pprev == NULL/exited.
>>>>  	 */
>>>>  	raw_spin_lock_irqsave(&task->pi_lock, flags);
>>>> +	for (work = READ_ONCE(*pprev); work; ) {
>>>>  		if (work->func != func)
>>>>  			pprev = &work->next;
>>>
>>> But didn't you loose the READ_ONCE() of *pprev in this branch?
>>
>> Argh, yes ;)
>>
>>>> @@ -97,16 +94,16 @@ void task_work_run(void)
>>>>  		 * work->func() can do task_work_add(), do not set
>>>>  		 * work_exited unless the list is empty.
>>>>  		 */
>>>> +		work = READ_ONCE(task->task_works);
>>>>  		do {
>>>>  			head = NULL;
>>>>  			if (!work) {
>>>>  				if (task->flags & PF_EXITING)
>>>>  					head = &work_exited;
>>>>  				else
>>>>  					break;
>>>>  			}
>>>> +		} while (!try_cmpxchg(&task->task_works, &work, head));
>>>>
>>>>  		if (!work)
>>>>  			break;
>>>
>>> But given that, as you say, cancel() could have gone and stole our head,
>>> should we not try and install &work_exiting when PF_EXITING in that
>>> case?
>>
>> cancel() can't do this, as long as we use cmpxchg/try_cmpxchg, not xchg().
>> This is what the comment before lock/unlock below tries to explain.
>>
>>> That is; should we not do continue in that case, instead of break.
>>
>> This is what we should do if we use xchg() like your previous version did.
>> Or I am totally confused. Hmm, and when I re-read my words it looks as if
>> I am trying to confuse you.
>>
>> So lets "simplify" this code assuming that PF_EXITING is set:
>>
>> 		work = READ_ONCE(task->task_works);
>> 		do {
>> 			head = NULL;
>> 			if (!work)
>> 				head = &work_exited;
>> 		} while (!try_cmpxchg(&task->task_works, &work, head));
>>
>> 		if (!work)
>> 			break;
>>
>> If work == NULL after try_cmpxchg() _succeeds_, then the new "head" must
>> be work_exited and we have nothing to do.
>>
>> If it was nullified by try_cmpxchg(&work) because we raced with cancel_(),
>> then this try_cmpxchg() should have been failed.
>>
>> Right?
>>
>>> @@ -69,9 +68,12 @@ task_work_cancel(struct task_struct *tas
>>>  	 */
>>>  	raw_spin_lock_irqsave(&task->pi_lock, flags);
>>>  	while ((work = READ_ONCE(*pprev))) {
>>> -		if (work->func != func)
>>> +		if (work->func != func) {
>>>  			pprev = &work->next;
>>> -		else if (cmpxchg(pprev, work, work->next) == work)
>>> +			continue;
>>> +		}
>>> +
>>> +		if (try_cmpxchg(pprev, &work, work->next))
>>>  			break;
>>
>> perhaps I misread this code, but it looks a bit strange to me... it doesn't
>> differ from
>>
>> 	while ((work = READ_ONCE(*pprev))) {
>> 		if (work->func != func)
>> 			pprev = &work->next;
>> 		else if (try_cmpxchg(pprev, &work, work->next))
>> 			break;
>> 	}
>>
>> either way it is correct, the only problem is that we do not need (want)
>> another READ_ONCE() if try_cmpxchg() fails.
>>
>>>  void task_work_run(void)
>>>  {
>>>  	struct task_struct *task = current;
>>> -	struct callback_head *work, *head, *next;
>>> +	struct callback_head *work, *next;
>>>  
>>>  	for (;;) {
>>> -		/*
>>> -		 * work->func() can do task_work_add(), do not set
>>> -		 * work_exited unless the list is empty.
>>> -		 */
>>> -		do {
>>> -			head = NULL;
>>> -			work = READ_ONCE(task->task_works);
>>> -			if (!work) {
>>> -				if (task->flags & PF_EXITING)
>>> -					head = &work_exited;
>>> -				else
>>> -					break;
>>> -			}
>>> -		} while (cmpxchg(&task->task_works, work, head) != work);
>>> +		work = READ_ONCE(task->task_works);
>>> +		if (!work) {
>>> +			if (!(task->flags & PF_EXITING))
>>> +				return;
>>> +
>>> +			/*
>>> +			 * work->func() can do task_work_add(), do not set
>>> +			 * work_exited unless the list is empty.
>>> +			 */
>>> +			if (try_cmpxchg(&task->task_works, &work, &work_exited))
>>> +				return;
>>> +		}
>>> +
>>> +		work = xchg(&task->task_works, NULL);
>>> +		if (!work)
>>> +			continue;
>>
>> looks correct...
> 
> Peter/Oleg, as you've probably noticed, I'm still hauling Oleg's
> original patch around. Is the above going to turn into a separate patch
> on top?  If so, feel free to shove it my way as well for some extra
> testing.

Peter/Oleg, gentle ping on this query. I'd like to queue up the task poll
rework on the io_uring side, but I still have this one at the start of
the series:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-task-poll&id=3b668ecf75f94f40c1faf9688ba3f32fb5e9f5d0


-- 
Jens Axboe

