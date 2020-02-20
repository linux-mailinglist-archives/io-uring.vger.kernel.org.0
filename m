Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 846A5166AA2
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 00:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgBTXAY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 18:00:24 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38265 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTXAY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 18:00:24 -0500
Received: by mail-pl1-f194.google.com with SMTP id t6so16605plj.5
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 15:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YnPe7nM7qQ1nRth7gVxBoZgFVVtHlnpy38WwBM/2Xmc=;
        b=QG762lHLIoAscq1QxslsPVWLOrEL+b4u7XiQSqYaiiKotAJSsD46t4rYyp5VETvyNL
         cNLMZgaLyF2fCfwRxkDa+UTb2Y4NMvME3FsdHajG2VXSqj5vAE4eGl+wZRo+Zb0z3AcU
         qQQGmUgViju6ogC9CD9Oxed092EpvbwntWspk5wlNm0h9PZ8cxrMJyPnFmT+a/fbgMOw
         Hc5jLssIITEe+DrJGIT8Vs+Bjua2UEDpoKmCCi/O5K2/txr3OFRlP7t7nTO+qKod6Iuw
         uTFkOZy4oK62WFmzaADtiJb4tSUXKKnrwnYBFc2uKs16xvFDSZgRXgAzu5NdYobgp5X/
         Xz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YnPe7nM7qQ1nRth7gVxBoZgFVVtHlnpy38WwBM/2Xmc=;
        b=bP4CKxSPJOujqa33DI2WGSwRAeSVSdgdj3eLMfIzMcp3emxjQfa4UjwXCIJXV5rm5q
         3JxGkcIV509RutOMZAxNbXrSE7bE2xsEP4bRbfyQbi8CyAhC/gxqjs1E2GbJD1x3MhMQ
         Cbmaasj/QVyPFHTWKbQVnmLrLi96QO+MijJid79magL27t0sPtvVaFfTjWxRyi6CaEhr
         MdgyBPbpkGVPmHH/bscnM9hBapyIXVGDrU/d0CWlWoDQ9pk+z7J8RG4xIX7ulBxMvxXc
         h/lTw+aaEg+/TFufqt/CLmP/eJrrTzmpc5Z4kU03tusm2apwzaJK/NX0RPbUFwoR4KJa
         Rgww==
X-Gm-Message-State: APjAAAWDNOoFNt61b2X/2v75EVW/0BpU9CPJHNPSdamrLcgg/HAuKlxZ
        ndVYGqK6Z9f8CDB2gzSkO8hfDA==
X-Google-Smtp-Source: APXvYqx65b1oGzU7Pb/D1VQjsYBucbkYJwQeoug81W2N64F919TfFmJFM06UHyDZtLEImhztD7mtkA==
X-Received: by 2002:a17:90a:c697:: with SMTP id n23mr6021384pjt.37.1582239621813;
        Thu, 20 Feb 2020 15:00:21 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1130::1006? ([2620:10d:c090:180::17d5])
        by smtp.gmail.com with ESMTPSA id y18sm649390pfe.19.2020.02.20.15.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 15:00:21 -0800 (PST)
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
 <CAG48ez37KerMukJ6zU=VQPtHsxo29S7TxqcqvU=Bs7Lfxtfdcg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4caec29c-469d-7448-f779-af3ba9c6c6a9@kernel.dk>
Date:   Thu, 20 Feb 2020 15:00:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez37KerMukJ6zU=VQPtHsxo29S7TxqcqvU=Bs7Lfxtfdcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 3:23 PM, Jann Horn wrote:
> On Thu, Feb 20, 2020 at 11:14 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 2/20/20 3:02 PM, Jann Horn wrote:
>>> On Thu, Feb 20, 2020 at 9:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> For poll requests, it's not uncommon to link a read (or write) after
>>>> the poll to execute immediately after the file is marked as ready.
>>>> Since the poll completion is called inside the waitqueue wake up handler,
>>>> we have to punt that linked request to async context. This slows down
>>>> the processing, and actually means it's faster to not use a link for this
>>>> use case.
>>>>
>>>> We also run into problems if the completion_lock is contended, as we're
>>>> doing a different lock ordering than the issue side is. Hence we have
>>>> to do trylock for completion, and if that fails, go async. Poll removal
>>>> needs to go async as well, for the same reason.
>>>>
>>>> eventfd notification needs special case as well, to avoid stack blowing
>>>> recursion or deadlocks.
>>>>
>>>> These are all deficiencies that were inherited from the aio poll
>>>> implementation, but I think we can do better. When a poll completes,
>>>> simply queue it up in the task poll list. When the task completes the
>>>> list, we can run dependent links inline as well. This means we never
>>>> have to go async, and we can remove a bunch of code associated with
>>>> that, and optimizations to try and make that run faster. The diffstat
>>>> speaks for itself.
>>> [...]
>>>> -static void io_poll_trigger_evfd(struct io_wq_work **workptr)
>>>> +static void io_poll_task_func(struct callback_head *cb)
>>>>  {
>>>> -       struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
>>>> +       struct io_kiocb *req = container_of(cb, struct io_kiocb, sched_work);
>>>> +       struct io_kiocb *nxt = NULL;
>>>>
>>> [...]
>>>> +       io_poll_task_handler(req, &nxt);
>>>> +       if (nxt)
>>>> +               __io_queue_sqe(nxt, NULL);
>>>
>>> This can now get here from anywhere that calls schedule(), right?
>>> Which means that this might almost double the required kernel stack
>>> size, if one codepath exists that calls schedule() while near the
>>> bottom of the stack and another codepath exists that goes from here
>>> through the VFS and again uses a big amount of stack space? This is a
>>> somewhat ugly suggestion, but I wonder whether it'd make sense to
>>> check whether we've consumed over 25% of stack space, or something
>>> like that, and if so, directly punt the request.
>>
>> Right, it'll increase the stack usage. Not against adding some safe
>> guard that punts if we're too deep in, though I'd have to look how to
>> even do that... Looks like stack_not_used(), though it's not clear to me
>> how efficient that is?
> 
> No, I don't think you want to do that... at least on X86-64, I think
> something vaguely like this should do the job:
> 
> unsigned long cur_stack = (unsigned long)__builtin_frame_address(0);
> unsigned long begin = (unsigned long)task_stack_page(task);
> unsigned long end   = (unsigned long)task_stack_page(task) + THREAD_SIZE;
> if (cur_stack < begin || cur_stack >= end || cur_stack < begin +
> THREAD_SIZE*3/4)
>   [bailout]
> 
> But since stacks grow in different directions depending on the
> architecture and so on, it might have to be an arch-specific thing...
> I'm not sure.

Yeah, that's fun... Probably a good first attempt is to wire up
an x86-64 variant that works, and use the base of stack_not_used()
for archs that don't provide it. Hopefully that'll get rectified
as time progresses.

>>> Also, can we recursively hit this point? Even if __io_queue_sqe()
>>> doesn't *want* to block, the code it calls into might still block on a
>>> mutex or something like that, at which point the mutex code would call
>>> into schedule(), which would then again hit sched_out_update() and get
>>> here, right? As far as I can tell, this could cause unbounded
>>> recursion.
>>
>> The sched_work items are pruned before being run, so that can't happen.
> 
> And is it impossible for new ones to be added in the meantime if a
> second poll operation completes in the background just when we're
> entering __io_queue_sqe()?

True, that can happen.

I wonder if we just prevent the recursion whether we can ignore most
of it. Eg never process the sched_work list if we're not at the top
level, so to speak.

This should also prevent the deadlock that you mentioned with FUSE
in the next email that just rolled in.

-- 
Jens Axboe

