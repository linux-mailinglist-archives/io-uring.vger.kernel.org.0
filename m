Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B75B16AF9E
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 19:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgBXSr3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 13:47:29 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:45590 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727797AbgBXSr3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 13:47:29 -0500
Received: by mail-io1-f67.google.com with SMTP id w9so40288iob.12
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 10:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eI0fvDGpOl2R0oIHdxWo9epHT28g114lPTBAwlN/kP0=;
        b=pbdwNBi0w8FbjBkyN9qb1373jxGz9i8NBLMu8nQZ9WvQZfSDEekFqBoZMl0kCJcYIe
         WNAk7RUeFdAxgNcj12shSnF2m41XSXCSxPkMIhRoq7+S+/552uCRmynFVWlx8B/Q8PHp
         j+Od5Rbwyuh4tQJ/1+iGDc19YEgH9fL6AOSKKr9m42dyiZCFAaeCLUN7fAYSTqLd5K5A
         HojzqsgXnFF/tIcvzHdqv5txA877qZTtRhmyT13A5VkwRG8lGQuhH/x/vPCTYSIhLYOv
         FfZrZETM+7r7adZnPnixltFlnQ4n9MFwPsxWPswwm4pEXKyIDVI2msW1jPUcl3eiHc/V
         GlIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eI0fvDGpOl2R0oIHdxWo9epHT28g114lPTBAwlN/kP0=;
        b=K7iEOnMlelz5KNxtL5LVMJ1ssfW345CJDw1AwREdfWG28c454564MuhAnck2HVzYbI
         hOaKq0/avC1BQxOegW5eAaw/Gdiqgt/8eGk8/tkwjIL0hdDqFOeEBfzco9ok9fg3wKP8
         LsvLIoCJ06p2Itt0rNoYSV1k54A3bHqGn1BkeZeHAMgixar5u9sYUr3DCeWDLH7OWfK1
         jVN69cRFORd4jzYNO/vI695J8vgl38ZU6xtIrVe60SlAIff7YaYCORTmsajjZv8Bao5i
         icZ4CX+yDJ8d+nb53aCdwl65qWCvodb5OFD93Dt5yzddGnqaBeQnTjRw3ramWbWdOJYt
         F0qA==
X-Gm-Message-State: APjAAAWQgsXpfrNcL3MDTiXPR4ucBSpdBSkvec2v93cjtpTwRJkBK8xa
        CunP27bNzIKMSFfICeR05YlxkhkdhGQ=
X-Google-Smtp-Source: APXvYqwZnUDcMe+xE3nolUQoO/BirkDsvELA4pxNWA9QgNkjMhwKOVS6sTsTbzcnudUUzZR4+EQHqg==
X-Received: by 2002:a5d:8856:: with SMTP id t22mr52423524ios.217.1582570047323;
        Mon, 24 Feb 2020 10:47:27 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l13sm3127334ion.3.2020.02.24.10.47.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:47:26 -0800 (PST)
Subject: Re: [PATCH] task_work_run: don't take ->pi_lock unconditionally
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <77349a8d-ecbf-088d-3a48-321f68f1774f@kernel.dk>
Date:   Mon, 24 Feb 2020 11:47:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221145256.GA16646@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/20 7:52 AM, Oleg Nesterov wrote:
> On 02/20, Peter Zijlstra wrote:
>>
>> On Thu, Feb 20, 2020 at 06:22:02PM +0100, Oleg Nesterov wrote:
>>> @@ -68,10 +65,10 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
>>>  	 * we raced with task_work_run(), *pprev == NULL/exited.
>>>  	 */
>>>  	raw_spin_lock_irqsave(&task->pi_lock, flags);
>>> +	for (work = READ_ONCE(*pprev); work; ) {
>>>  		if (work->func != func)
>>>  			pprev = &work->next;
>>
>> But didn't you loose the READ_ONCE() of *pprev in this branch?
> 
> Argh, yes ;)
> 
>>> @@ -97,16 +94,16 @@ void task_work_run(void)
>>>  		 * work->func() can do task_work_add(), do not set
>>>  		 * work_exited unless the list is empty.
>>>  		 */
>>> +		work = READ_ONCE(task->task_works);
>>>  		do {
>>>  			head = NULL;
>>>  			if (!work) {
>>>  				if (task->flags & PF_EXITING)
>>>  					head = &work_exited;
>>>  				else
>>>  					break;
>>>  			}
>>> +		} while (!try_cmpxchg(&task->task_works, &work, head));
>>>
>>>  		if (!work)
>>>  			break;
>>
>> But given that, as you say, cancel() could have gone and stole our head,
>> should we not try and install &work_exiting when PF_EXITING in that
>> case?
> 
> cancel() can't do this, as long as we use cmpxchg/try_cmpxchg, not xchg().
> This is what the comment before lock/unlock below tries to explain.
> 
>> That is; should we not do continue in that case, instead of break.
> 
> This is what we should do if we use xchg() like your previous version did.
> Or I am totally confused. Hmm, and when I re-read my words it looks as if
> I am trying to confuse you.
> 
> So lets "simplify" this code assuming that PF_EXITING is set:
> 
> 		work = READ_ONCE(task->task_works);
> 		do {
> 			head = NULL;
> 			if (!work)
> 				head = &work_exited;
> 		} while (!try_cmpxchg(&task->task_works, &work, head));
> 
> 		if (!work)
> 			break;
> 
> If work == NULL after try_cmpxchg() _succeeds_, then the new "head" must
> be work_exited and we have nothing to do.
> 
> If it was nullified by try_cmpxchg(&work) because we raced with cancel_(),
> then this try_cmpxchg() should have been failed.
> 
> Right?
> 
>> @@ -69,9 +68,12 @@ task_work_cancel(struct task_struct *tas
>>  	 */
>>  	raw_spin_lock_irqsave(&task->pi_lock, flags);
>>  	while ((work = READ_ONCE(*pprev))) {
>> -		if (work->func != func)
>> +		if (work->func != func) {
>>  			pprev = &work->next;
>> -		else if (cmpxchg(pprev, work, work->next) == work)
>> +			continue;
>> +		}
>> +
>> +		if (try_cmpxchg(pprev, &work, work->next))
>>  			break;
> 
> perhaps I misread this code, but it looks a bit strange to me... it doesn't
> differ from
> 
> 	while ((work = READ_ONCE(*pprev))) {
> 		if (work->func != func)
> 			pprev = &work->next;
> 		else if (try_cmpxchg(pprev, &work, work->next))
> 			break;
> 	}
> 
> either way it is correct, the only problem is that we do not need (want)
> another READ_ONCE() if try_cmpxchg() fails.
> 
>>  void task_work_run(void)
>>  {
>>  	struct task_struct *task = current;
>> -	struct callback_head *work, *head, *next;
>> +	struct callback_head *work, *next;
>>  
>>  	for (;;) {
>> -		/*
>> -		 * work->func() can do task_work_add(), do not set
>> -		 * work_exited unless the list is empty.
>> -		 */
>> -		do {
>> -			head = NULL;
>> -			work = READ_ONCE(task->task_works);
>> -			if (!work) {
>> -				if (task->flags & PF_EXITING)
>> -					head = &work_exited;
>> -				else
>> -					break;
>> -			}
>> -		} while (cmpxchg(&task->task_works, work, head) != work);
>> +		work = READ_ONCE(task->task_works);
>> +		if (!work) {
>> +			if (!(task->flags & PF_EXITING))
>> +				return;
>> +
>> +			/*
>> +			 * work->func() can do task_work_add(), do not set
>> +			 * work_exited unless the list is empty.
>> +			 */
>> +			if (try_cmpxchg(&task->task_works, &work, &work_exited))
>> +				return;
>> +		}
>> +
>> +		work = xchg(&task->task_works, NULL);
>> +		if (!work)
>> +			continue;
> 
> looks correct...

Peter/Oleg, as you've probably noticed, I'm still hauling Oleg's
original patch around. Is the above going to turn into a separate patch
on top?  If so, feel free to shove it my way as well for some extra
testing.

-- 
Jens Axboe

