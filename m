Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DF71A16D6
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 22:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgDGUae (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 16:30:34 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38553 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGUae (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 16:30:34 -0400
Received: by mail-pf1-f196.google.com with SMTP id c21so1332660pfo.5
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 13:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/IZbIEUi86EigXkqySsPv0aIiGUxudS4aZJiZ2f4/2c=;
        b=xeArvkz6U7eGFpEjNOgelrF3QuyeTjZHkM/jHsP25pBKFIwpWLQwoIL5HCkVyhp+GZ
         a2jQnxDFdrJCNHWQc9zyWrwJmqaMxe9c6wvnvFiP057TIjd7AamHhp/PbEBmnyDdmkFR
         r187heiDlf+mX9gsBR/lwcuKqroL7VU5RfIatG9+t1CRSLXN+tNfYjq0OSktV+6faFT4
         KSQy2fJ5P05vpGu5t2UU5nxPwlJeWTF2ISgUUZ4qlgCFzVY5JGVZrbutepZPQ6hyY4TP
         qzDtGuCNf94XVY5CxMfl+xawnDKRnLL9I9v+uKzVH0O/Zc1kRQnwREceCxLbIwM7D9eO
         n8Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/IZbIEUi86EigXkqySsPv0aIiGUxudS4aZJiZ2f4/2c=;
        b=o7LFbUS8ApEPGYhWrcwRRECZPKQ7q5nzqQeDun3/lWfLoboAcG9M49M17aOYc8oSF1
         KN6ZvoE3zjNbnr9xh3xLYVt+vXxPfrejIsJ6HjaUsg1ffYrxBYe/n4bo1GkYC7WwmWir
         9092dYtlL7qbjht+jWMAhpPczClM8zYyW1//3bFIvFExoFGp0tWKEqfO4i3aAHK8CyfU
         bKros0VDlVgm+lavkq6Svq3+frozm7/rcUFzyPez1rHe42YGxxWsDGr8fDpsyz7iYcRQ
         RLiSaMr1dNsrOuQw8zXsaCRxDR2d/PTNiA55zRZyS76nBjzdTkuYV0to0opsKdorGKg3
         vfOA==
X-Gm-Message-State: AGi0PubmdT13zKORHTpb9tsyda5gaLh+SzBCkGNOP7hyeZwetOt9thzg
        b0N0xxI1oV6Wsd94y3W6CIBtNw==
X-Google-Smtp-Source: APiQypIuRKw0gHmr1qshWmUAcptyRHlZ99FNUJBXGDqJjufgWtT9g/nn/AJn6Db2nEOophuVQx04Gg==
X-Received: by 2002:a63:330c:: with SMTP id z12mr3589125pgz.415.1586291433009;
        Tue, 07 Apr 2020 13:30:33 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab? ([2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab])
        by smtp.gmail.com with ESMTPSA id ci13sm151331pjb.16.2020.04.07.13.30.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 13:30:32 -0700 (PDT)
Subject: Re: [PATCH 4/4] io_uring: flush task work before waiting for ring
 exit
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        Peter Zijlstra <peterz@infradead.org>
References: <20200407160258.933-1-axboe@kernel.dk>
 <20200407160258.933-5-axboe@kernel.dk> <20200407162405.GA9655@redhat.com>
 <20200407163816.GB9655@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4b70317a-d12a-6c29-1d7f-1394527f9676@kernel.dk>
Date:   Tue, 7 Apr 2020 13:30:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200407163816.GB9655@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/7/20 9:38 AM, Oleg Nesterov wrote:
> On 04/07, Oleg Nesterov wrote:
>>
>> On 04/07, Jens Axboe wrote:
>>>
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -7293,10 +7293,15 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
>>>  		io_wq_cancel_all(ctx->io_wq);
>>>
>>>  	io_iopoll_reap_events(ctx);
>>> +	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
>>> +
>>> +	if (current->task_works != &task_work_exited)
>>> +		task_work_run();
>>
>> this is still wrong, please see the email I sent a minute ago.
> 
> Let me try to explain in case it was not clear. Lets forget about io_uring.
> 
> 	void bad_work_func(struct callback_head *cb)
> 	{
> 		task_work_run();
> 	}
> 
> 	...
> 
> 	init_task_work(&my_work, bad_work_func);
> 
> 	task_work_add(task, &my_work);
> 
> If the "task" above is exiting the kernel will crash; because the 2nd
> task_work_run() called by bad_work_func() will install work_exited, then
> we return to task_work_run() which was called by exit_task_work(), it will
> notice ->task_works != NULL, restart the main loop, and execute
> work_exited->fn == NULL.
> 
> Again, if we want to allow task_work_run() in do_exit() paths we need
> something like below. But still do not understand why do we need this :/

The crash I sent was from the exit path, I don't think we need to run
the task_work for that case, as the ordering should imply that we either
queue the work with the task (if not exiting), and it'll get run just fine,
or we queue it with another task. For both those cases, no need to run
the local task work.

io_uring exit removes the pending poll requests, but what if (for non
exit invocation), we get poll requests completing before they are torn
down. Now we have task_work queued up that won't get run, because we
are are in the task_work handler for the __fput(). For this case, we
need to run the task work.

But I can't tell them apart easily, hence I don't know when it's safe
to run it. That's what I'm trying to solve by exposing task_work_exited
so I can check for that specifically. Not really a great solution as
it doesn't tell me which of the cases I'm in, but at least it tells me
if it's safe to run the task work?

-- 
Jens Axboe

