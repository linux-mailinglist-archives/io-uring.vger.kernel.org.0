Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05B84166A99
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 23:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgBTW4Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 17:56:25 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38085 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729130AbgBTW4Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 17:56:24 -0500
Received: by mail-pl1-f193.google.com with SMTP id t6so11300plj.5
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 14:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LbWvJZV4FhAUamQ768QCcrHQD2xJfqWNqNxA9Z/LMdY=;
        b=bOIMfYOaNjlCLSlZ5psl4lXoxRMAJPBfNO4/oOJTU1lEtR0aM18OPKgkPiC7zqzpmF
         zguunFYJ8yK8b3DntxrGA7Zwi+WjIGIabmfCacMs5GgjgbJ31Brwrb/pQfSjk0q/iNrZ
         Rzu1ndC3cn9lpMzy7axhJIG+ytjnfYK3S+uQgjAL0IoXa1ph+GKX/3EEoRtNVZjx/lFF
         Kb7YMvHrL4/1/nIsouYzEycxwdxxXZZiKjgt47CMWt8Nc9EqFqw0duIj+MJ4zeeiJucF
         cmuxvl8AlA5onIVtqSXVW5/QY2niaHTlg2oV4lyz2qLFnwPzwf+LH3cLEiImyxoxXfRY
         DOKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LbWvJZV4FhAUamQ768QCcrHQD2xJfqWNqNxA9Z/LMdY=;
        b=LB4zi0VZoPGFfNFCTHZLHiId/lzu41GmWDlYTwe8Zwvf3tNHp43UBukdBfrB51rhuK
         d+4ebWJnpUxTjloXc8o4L0VLGa/o5Q4H6qmtGF0f9aikRSmhsshgD2RamLI059ItEIRN
         LhQCydrfw+WpYPZ0ryiCTg8Kk7KUpkJKvDJM8vGFhJ70X31KYWoJdBszft0RN5zmb1iv
         UXGjfrwVqGJnQlc2NNkwEiuJG+mCM6yXynOKSq+weOPBiRg/rJvrXsRudy5cLk7r+Amx
         1iF4DvGMxOuqG+3T8NCdAkpmnfzNGlvGrJxXFiMKm7T3kQgV+weo2s3hLR6n3UZLXafv
         7X7Q==
X-Gm-Message-State: APjAAAUK3SNFtYDdwje7mf4nSURCKhP5M7fOTQeMSfCz5eU5X0OqYqJX
        y/bGkmSVSQV7xoNeAKY4DFjOhg==
X-Google-Smtp-Source: APXvYqyqrcIAKAdAaL1RWXh79CN6H/mOkUR14oBciuG6Ldzh1mQXVquxjQPiPEvRThY06QceavqLNA==
X-Received: by 2002:a17:90a:71c1:: with SMTP id m1mr6170122pjs.34.1582239384122;
        Thu, 20 Feb 2020 14:56:24 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1130::1006? ([2620:10d:c090:180::17d5])
        by smtp.gmail.com with ESMTPSA id o11sm459551pjs.6.2020.02.20.14.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 14:56:23 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
 <b78cd45a-9e6f-04ec-d096-d6e1f6cec8bd@kernel.dk>
 <67a62039-0cb0-b5b2-d7f8-fade901c59f4@kernel.dk>
 <CAG48ez3R3DWLry_aRAt47BQ05Y4Mr9yVXq49yuiRGNoyRMr3Lg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1658b860-6419-fac9-8ec3-b2d91d74b293@kernel.dk>
Date:   Thu, 20 Feb 2020 14:56:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez3R3DWLry_aRAt47BQ05Y4Mr9yVXq49yuiRGNoyRMr3Lg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 3:38 PM, Jann Horn wrote:
> On Thu, Feb 20, 2020 at 11:23 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 2/20/20 3:14 PM, Jens Axboe wrote:
>>>>> @@ -3646,46 +3596,11 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>>>>>
>>>>>         list_del_init(&poll->wait.entry);
>>>>>
>>>> [...]
>>>>> +       tsk = req->task;
>>>>> +       req->result = mask;
>>>>> +       init_task_work(&req->sched_work, io_poll_task_func);
>>>>> +       sched_work_add(tsk, &req->sched_work);
>>>>
>>>> Doesn't this have to check the return value?
>>>
>>> Trying to think if we can get here with TASK_EXITING, but probably safer
>>> to just handle it in any case. I'll add that.
>>
>> Double checked this one, and I think it's good as-is, but needs a
>> comment. If the sched_work_add() fails, then the work item is still in
>> the poll hash on the ctx. That work is canceled on exit.
> 
> You mean via io_poll_remove_all()? That doesn't happen when a thread
> dies, right?

Off of io_uring_flush, we do:

if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
	io_uring_cancel_task_poll(current);
	io_uring_cancel_task_async(current);
	io_wq_cancel_pid(ctx->io_wq, task_pid_vnr(current));
}

to cancel _anything_ that the task has pending.

> As far as I can tell, the following might happen:
> 
> 1. process with threads A and B set up uring
> 2. thread B submits chained requests poll->read
> 3. thread A waits for request completion
> 4. thread B dies
> 5. poll waitqueue is notified, data is ready

Unless I'm mistaken, when B dies, the requests from #2 will be canceled.

> Even if there isn't a memory leak, you'd still want the read request
> to execute at some point so that thread A can see the result, right?

It just needs to complete, if the task is going away, then a cancelation
is fine too.

> And actually, in this scenario, wouldn't the req->task be a dangling
> pointer, since you're not holding a reference? Or is there some magic
> callback from do_exit() to io_uring that I missed? There is a comment
> "/* task will wait for requests on exit, don't need a ref */", but I
> don't see how that works...

That'd only be the case if we didn't cancel requests when it dies. I'll
double check if that's 100% the case.

-- 
Jens Axboe

