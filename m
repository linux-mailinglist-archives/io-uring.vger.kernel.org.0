Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A57240F60
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 21:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730347AbgHJTVy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 15:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730343AbgHJTVv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 15:21:51 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE889C061756
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 12:21:50 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f10so5555501plj.8
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 12:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zhBrPzLrgwSOK6IoThnZRHLRdVzRJupy+N07FBv6wjw=;
        b=cC/bCU5qRxyU4ouap8na9urRs4istEWMjsiXWRBpwhLf0EpBtb/nIAxsIGnS8xuKmm
         JwBL9wpRUONGi+ptiIoa8A46xMK/4fIwNQWOC+LfTYXobMvqQHv98/KI8vTz3frNCTjN
         T1rg4Cax+ODFEyZ8fBcKPwZZ9Hi5t8HTlteA2hcin//8Bgnj6tDd/PQlF+vH1hxGtX2z
         xckeYobZ+wVh045t/97BKjwaW9v8HJTdappc7/XCqKIXTo4bKo1+1+Uji77kdnAoc7Dd
         CPILIlloIuLMDIGP/01fnfQT/LuXKjYnBydQens18Fb0c6Z8xXDGDV3vuDgEsrbIKSSf
         MsJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zhBrPzLrgwSOK6IoThnZRHLRdVzRJupy+N07FBv6wjw=;
        b=c5ZQZCoKsw4uX/ycvPq7qLsXhNw9adNRtW9lcOlj7uFN+B/wC/A5eXWMw04GNOlNbN
         1h6pC4Do6KaipEcGK0nVRXtswEE3qb5ZB41SNhPmvZCl2gzN8mz2l4aDo6Ke6bqeR3qI
         b1IToUhVqmFnbdFxJFMBAYOGbSolB8rVZBC2mhCAvqrrMwTLLdwh0R2PkeKhLhTrZZWu
         acpqYRm08ZjMx02yiQsNadLWiJ95KFf8agAO/aL1w/4r+gCgnCJFGg3xGRA18BMQNgQO
         0wLEPJy8wukX8RLPTyEA+85iVjW5LyxHt7dhaY39n29VqvUU4U0oovA7znC+eCiKPZ5p
         SeOA==
X-Gm-Message-State: AOAM53350rk1itnbdjvI1FlE8BhfYwq8GvFh2fLLYV8qZZoDm9b1omuv
        OW2UhcuBN6Qlvn7LCTHvkKo8GQ==
X-Google-Smtp-Source: ABdhPJwz9ir8ZqL6iUQ2SoOy3rN46uQ4ZKDt39g1cc4HeRcEIV6GR02w8sXqEyssN6JQdXT0bzZ6MQ==
X-Received: by 2002:a17:90a:148:: with SMTP id z8mr806295pje.197.1597087310205;
        Mon, 10 Aug 2020 12:21:50 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l17sm24959777pff.126.2020.08.10.12.21.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 12:21:49 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
From:   Jens Axboe <axboe@kernel.dk>
To:     peterz@infradead.org
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org,
        Josef <josef.grieb@gmail.com>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net>
 <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
Message-ID: <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk>
Date:   Mon, 10 Aug 2020 13:21:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/20 9:02 AM, Jens Axboe wrote:
> On 8/10/20 5:42 AM, peterz@infradead.org wrote:
>> On Sat, Aug 08, 2020 at 12:34:39PM -0600, Jens Axboe wrote:
>>> An earlier commit:
>>>
>>> b7db41c9e03b ("io_uring: fix regression with always ignoring signals in io_cqring_wait()")
>>>
>>> ensured that we didn't get stuck waiting for eventfd reads when it's
>>> registered with the io_uring ring for event notification, but we still
>>> have a gap where the task can be waiting on other events in the kernel
>>> and need a bigger nudge to make forward progress.
>>>
>>> Ensure that we use signaled notifications for a task that isn't currently
>>> running, to be certain the work is seen and processed immediately.
>>>
>>> Cc: stable@vger.kernel.org # v5.7+
>>> Reported-by: Josef <josef.grieb@gmail.com>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>  fs/io_uring.c | 22 ++++++++++++++--------
>>>  1 file changed, 14 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index e9b27cdaa735..443eecdfeda9 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -1712,21 +1712,27 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
>>>  	struct io_ring_ctx *ctx = req->ctx;
>>>  	int ret, notify = TWA_RESUME;
>>>  
>>> +	ret = __task_work_add(tsk, cb);
>>> +	if (unlikely(ret))
>>> +		return ret;
>>> +
>>>  	/*
>>>  	 * SQPOLL kernel thread doesn't need notification, just a wakeup.
>>> -	 * If we're not using an eventfd, then TWA_RESUME is always fine,
>>> -	 * as we won't have dependencies between request completions for
>>> -	 * other kernel wait conditions.
>>> +	 * For any other work, use signaled wakeups if the task isn't
>>> +	 * running to avoid dependencies between tasks or threads. If
>>> +	 * the issuing task is currently waiting in the kernel on a thread,
>>> +	 * and same thread is waiting for a completion event, then we need
>>> +	 * to ensure that the issuing task processes task_work. TWA_SIGNAL
>>> +	 * is needed for that.
>>>  	 */
>>>  	if (ctx->flags & IORING_SETUP_SQPOLL)
>>>  		notify = 0;
>>> -	else if (ctx->cq_ev_fd)
>>> +	else if (READ_ONCE(tsk->state) != TASK_RUNNING)
>>>  		notify = TWA_SIGNAL;
>>>  
>>> -	ret = task_work_add(tsk, cb, notify);
>>> -	if (!ret)
>>> -		wake_up_process(tsk);
>>> -	return ret;
>>> +	__task_work_notify(tsk, notify);
>>> +	wake_up_process(tsk);
>>> +	return 0;
>>>  }
>>
>> Wait.. so the only change here is that you look at tsk->state, _after_
>> doing __task_work_add(), but nothing, not the Changelog nor the comment
>> explains this.
>>
>> So you're relying on __task_work_add() being an smp_mb() vs the add, and
>> you order this against the smp_mb() in set_current_state() ?
>>
>> This really needs spelling out.
> 
> I'll update the changelog, it suffers a bit from having been reused from
> the earlier versions. Thanks for checking!

I failed to convince myself that the existing construct was safe, so
here's an incremental on top of that. Basically we re-check the task
state _after_ the initial notification, to protect ourselves from the
case where we initially find the task running, but between that check
and when we do the notification, it's now gone to sleep. Should be
pretty slim, but I think it's there.

Hence do a loop around it, if we're using TWA_RESUME.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 44ac103483b6..a4ecb6c7e2b0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1780,12 +1780,27 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
 	 * to ensure that the issuing task processes task_work. TWA_SIGNAL
 	 * is needed for that.
 	 */
-	if (ctx->flags & IORING_SETUP_SQPOLL)
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		notify = 0;
-	else if (READ_ONCE(tsk->state) != TASK_RUNNING)
-		notify = TWA_SIGNAL;
+	} else {
+		bool notified = false;
 
-	__task_work_notify(tsk, notify);
+		/*
+		 * If the task is running, TWA_RESUME notify is enough. Make
+		 * sure to re-check after we've sent the notification, as not
+		 * to have a race between the check and the notification. This
+		 * only applies for TWA_RESUME, as TWA_SIGNAL is safe with a
+		 * sleeping task
+		 */
+		do {
+			if (READ_ONCE(tsk->state) != TASK_RUNNING)
+				notify = TWA_SIGNAL;
+			else if (notified)
+				break;
+			__task_work_notify(tsk, notify);
+			notified = true;
+		} while (notify != TWA_SIGNAL);
+	}
 	wake_up_process(tsk);
 	return 0;
 }

and I've folded it in here:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=8d685b56f80b16516be9ce2eb1aee5adcfba13ff

-- 
Jens Axboe

