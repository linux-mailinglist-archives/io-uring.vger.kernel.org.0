Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80BA11A16E4
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 22:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgDGUjv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 16:39:51 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50448 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGUjK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 16:39:10 -0400
Received: by mail-pj1-f68.google.com with SMTP id b7so113671pju.0
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 13:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OydNmXwnSsqpCoDkrNY1KyYZ6oQCq17uevYMgEc3764=;
        b=IUt1JF9zITT7ZX1fC2J0rVL1Vgi+qWcxfQOx8UfyHnDqRblQytWa8p5sxt/qtQqMvF
         e2nSqk+nqk9sEWT86GqsbecdgorKUDqFCqcMdo1ZHT6uW1+nmB1Rost3IfXSO2GBKsZi
         FJG2Q4bQ6//XaNVhLmz8dMfrKpDQbXhoVfs5Nr+ZJdmuIQPoTCprWFs63rMyT7KFFHNp
         CoqQ01AdgjqDCELTCm5091gUXGDu8XwXfGU4gxKMjWu6J/GC1/fKpzTf9pDYhDC7yYW8
         vjJwW3VCF1nqQEd0DzSP89LC5kD96EI7p0Gksz0DeiCEg9AW3k79zhVUNo0onq4gr3Kg
         HQ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OydNmXwnSsqpCoDkrNY1KyYZ6oQCq17uevYMgEc3764=;
        b=o0weM1DaEFwwLeEFjYAbFe76LWcjzHZ8unLcbmCIe+82WFDDjHMFUpOKfs8reFKer4
         TtLv7CQApwhdP9fgR39rgb/q+QAikGWBDbzHbL98rHAxOzrr7sGuYhIrmyPTOLLRO9QS
         bOLIYQKq1hg+7ua9L2c5ETk+SfWZeifLcSfegI4RFdxPZD558zVj4opx+fwumwgGsUB+
         g4jDTgecr9r6xJuqmG70OtCzQ9qxPDcxlehAKjhLGxPeF96ubTG55suxiyfV7c3RK6qP
         S1Yc6F7vmD9zmeVNhToa1HCx2o3oWNNS/pQWZiR3jCiaznskn1BPtrHKJpdP1qSfBFkq
         XLkA==
X-Gm-Message-State: AGi0PuYGYXEMAh6yVbRj67eEM7ppGLqTLJYnejAXcuxL02elt8Csl7kP
        PnFOS51bhtpw4M6vIeqjdb89qesYCRgLmQ==
X-Google-Smtp-Source: APiQypIK/BJEwqDWqQbYQT67zh70bdmJS+L58XPW8OUrYr1RxGB7RiBMbqHHqPLXJXuIhRQA1PiUhQ==
X-Received: by 2002:a17:90b:230d:: with SMTP id mt13mr1256255pjb.164.1586291947819;
        Tue, 07 Apr 2020 13:39:07 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab? ([2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab])
        by smtp.gmail.com with ESMTPSA id c9sm3433547pfj.214.2020.04.07.13.39.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 13:39:07 -0700 (PDT)
Subject: Re: [PATCH 4/4] io_uring: flush task work before waiting for ring
 exit
From:   Jens Axboe <axboe@kernel.dk>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        Peter Zijlstra <peterz@infradead.org>
References: <20200407160258.933-1-axboe@kernel.dk>
 <20200407160258.933-5-axboe@kernel.dk> <20200407162405.GA9655@redhat.com>
 <20200407163816.GB9655@redhat.com>
 <4b70317a-d12a-6c29-1d7f-1394527f9676@kernel.dk>
Message-ID: <5712029a-c8f8-3087-5a6d-d9b438dc89a4@kernel.dk>
Date:   Tue, 7 Apr 2020 13:39:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <4b70317a-d12a-6c29-1d7f-1394527f9676@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/7/20 1:30 PM, Jens Axboe wrote:
> On 4/7/20 9:38 AM, Oleg Nesterov wrote:
>> On 04/07, Oleg Nesterov wrote:
>>>
>>> On 04/07, Jens Axboe wrote:
>>>>
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -7293,10 +7293,15 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
>>>>  		io_wq_cancel_all(ctx->io_wq);
>>>>
>>>>  	io_iopoll_reap_events(ctx);
>>>> +	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
>>>> +
>>>> +	if (current->task_works != &task_work_exited)
>>>> +		task_work_run();
>>>
>>> this is still wrong, please see the email I sent a minute ago.
>>
>> Let me try to explain in case it was not clear. Lets forget about io_uring.
>>
>> 	void bad_work_func(struct callback_head *cb)
>> 	{
>> 		task_work_run();
>> 	}
>>
>> 	...
>>
>> 	init_task_work(&my_work, bad_work_func);
>>
>> 	task_work_add(task, &my_work);
>>
>> If the "task" above is exiting the kernel will crash; because the 2nd
>> task_work_run() called by bad_work_func() will install work_exited, then
>> we return to task_work_run() which was called by exit_task_work(), it will
>> notice ->task_works != NULL, restart the main loop, and execute
>> work_exited->fn == NULL.
>>
>> Again, if we want to allow task_work_run() in do_exit() paths we need
>> something like below. But still do not understand why do we need this :/
> 
> The crash I sent was from the exit path, I don't think we need to run
> the task_work for that case, as the ordering should imply that we either
> queue the work with the task (if not exiting), and it'll get run just fine,
> or we queue it with another task. For both those cases, no need to run
> the local task work.
> 
> io_uring exit removes the pending poll requests, but what if (for non
> exit invocation), we get poll requests completing before they are torn
> down. Now we have task_work queued up that won't get run, because we
> are are in the task_work handler for the __fput(). For this case, we
> need to run the task work.
> 
> But I can't tell them apart easily, hence I don't know when it's safe
> to run it. That's what I'm trying to solve by exposing task_work_exited
> so I can check for that specifically. Not really a great solution as
> it doesn't tell me which of the cases I'm in, but at least it tells me
> if it's safe to run the task work?

It's also possible I totally mis-analyzed it, and it really is back to
"just" being an ordering issue than I then work-around by re-running the
task_work within the handler.

-- 
Jens Axboe

