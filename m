Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A42CE168F61
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2020 15:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbgBVOl3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Feb 2020 09:41:29 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36594 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbgBVOl3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Feb 2020 09:41:29 -0500
Received: by mail-pg1-f196.google.com with SMTP id d9so2566180pgu.3
        for <io-uring@vger.kernel.org>; Sat, 22 Feb 2020 06:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=defhfpL9wtyWCiB1Xr45L7eZpLIgSOEZiNKRIgbcPSE=;
        b=moyZqqm1967PCLaQTbIM+IXMpWMB6lWD/X52sELVl3WXRMM8ffMNE7PJrqiDDVDmwS
         h26MAbfMnU3VigwpxFgkJAD8pb4GHvqVcJZmehymmW/kKq1wXsBe7ppdzC05wwKu3Sf2
         Cw5Mmv4+IUrrddtzug3iLkXWrDMfptVwVcmcRFZfBiCP8VLpgM0k0y4cHl3F/ForsHuQ
         hhVyS/U3N2lVKh67CHAPHIZAscFzIDlEXv0KBA/cCLhCs/zbsyd9o1GJQ5zuTF+afg6L
         p/Fus3hmErIhJQMu2WcWFKQ4919ZHsnnCI0IT4OTYSGiYI6zlhTdU0fbkVnbPFKyfLNd
         WHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=defhfpL9wtyWCiB1Xr45L7eZpLIgSOEZiNKRIgbcPSE=;
        b=OfZQVJQHnMGyl1NaxZ0eth2lw82C5tXgVI1G0kRa7bsSOV3iHXm7eE8Nc3dcHRCK2x
         oGwqoun46yCX5/ltWPvFT0Kl2Mpc1pxJd2fVc9ZloKNI4bojIUpcU+oSA1gJvP0Zwdx9
         bcee0ElEwrnz/+b3OtCNZNqe7J4SipN9YqXLBAog8WeWyDDQBMZXWgvGgRcXZF6z3NrG
         lJCMF4X2Lyf0kjaTkmTb9SIxMWUp/tL10KWlmVJR4oUvFDBu7I3kgykfFZ/MdI6XwImw
         yVbgs7Ycnl5f5fY+5CZs7vcuOFACO1zfSb5tVWXdYhEIETEnVkr1qq6NKHCEpO7YctGi
         pj9A==
X-Gm-Message-State: APjAAAVgEvbN1MW0R8EYXXIxAOeTawymP+HOMcZbJTjYfmkq1vxytcP4
        XPEIYulpNZMxFzjObL0t58W+PA==
X-Google-Smtp-Source: APXvYqxGDuEZACgHFjVKi8yuSRO4mZUDfrasNTWVDxQhlKrAFCahVwLz4uVw3PnoTGLUu2mIfOb9Tw==
X-Received: by 2002:a62:2ad1:: with SMTP id q200mr44285774pfq.123.1582382487337;
        Sat, 22 Feb 2020 06:41:27 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:d487:5bdf:4186:2ae1? ([2605:e000:100e:8c61:d487:5bdf:4186:2ae1])
        by smtp.gmail.com with ESMTPSA id 5sm6575282pfx.163.2020.02.22.06.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2020 06:41:26 -0800 (PST)
Subject: Re: [PATCH 5/7] io_uring: add per-task callback handler
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20200221214606.12533-1-axboe@kernel.dk>
 <20200221214606.12533-6-axboe@kernel.dk>
 <CAG48ez2ErAJgEiPdkK+PeNBoHchVEkkw5674Wt2eSaNjqyZ98g@mail.gmail.com>
 <CAG48ez3rsk6TzF82Q0PvDDCRp6wfWWUn8bsSZ2+OB9FgSOGgsw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f9fe1046-543a-1541-ad87-2a70da906ac5@kernel.dk>
Date:   Sat, 22 Feb 2020 06:41:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez3rsk6TzF82Q0PvDDCRp6wfWWUn8bsSZ2+OB9FgSOGgsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/20 4:00 PM, Jann Horn wrote:
> On Fri, Feb 21, 2020 at 11:56 PM Jann Horn <jannh@google.com> wrote:
>> On Fri, Feb 21, 2020 at 10:46 PM Jens Axboe <axboe@kernel.dk> wrote:
>>> For poll requests, it's not uncommon to link a read (or write) after
>>> the poll to execute immediately after the file is marked as ready.
>>> Since the poll completion is called inside the waitqueue wake up handler,
>>> we have to punt that linked request to async context. This slows down
>>> the processing, and actually means it's faster to not use a link for this
>>> use case.
>>>
>>> We also run into problems if the completion_lock is contended, as we're
>>> doing a different lock ordering than the issue side is. Hence we have
>>> to do trylock for completion, and if that fails, go async. Poll removal
>>> needs to go async as well, for the same reason.
>>>
>>> eventfd notification needs special case as well, to avoid stack blowing
>>> recursion or deadlocks.
>>>
>>> These are all deficiencies that were inherited from the aio poll
>>> implementation, but I think we can do better. When a poll completes,
>>> simply queue it up in the task poll list. When the task completes the
>>> list, we can run dependent links inline as well. This means we never
>>> have to go async, and we can remove a bunch of code associated with
>>> that, and optimizations to try and make that run faster. The diffstat
>>> speaks for itself.
>> [...]
>>> @@ -3637,8 +3587,8 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>>>  {
>>>         struct io_kiocb *req = wait->private;
>>>         struct io_poll_iocb *poll = &req->poll;
>>> -       struct io_ring_ctx *ctx = req->ctx;
>>>         __poll_t mask = key_to_poll(key);
>>> +       struct task_struct *tsk;
>>>
>>>         /* for instances that support it check for an event match first: */
>>>         if (mask && !(mask & poll->events))
>>> @@ -3646,46 +3596,11 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>>>
>>>         list_del_init(&poll->wait.entry);
>>>
>> [...]
>>> +       tsk = req->task;
>>> +       req->result = mask;
>>> +       init_task_work(&req->task_work, io_poll_task_func);
>>> +       task_work_add(tsk, &req->task_work, true);
>>> +       wake_up_process(tsk);
>>>         return 1;
>>>  }
>>
>> Let's say userspace has some code like this:
>>
>> [prepare two uring requests: one POLL and a RECVMSG linked behind it]
>> // submit requests
>> io_uring_enter(uring_fd, 2, 0, 0, NULL, 0);
>> // wait for something to happen, either a completion event from uring
>> or input from stdin
>> struct pollfd fds[] = {
>>   { .fd = 0, .events = POLLIN },
>>   { .fd = uring_fd, .events = POLLIN }
>> };
>> while (1) {
>>   poll(fds, 2, -1);
>>   if (fds[0].revents) {
>>     [read stuff from stdin]
>>   }
>>   if (fds[1].revents) {
>>     [fetch completions from shared memory]
>>   }
>> }
>>
>> If userspace has reached the poll() by the time the uring POLL op
>> completes, I think you'll wake up the do_poll() loop while it is in
>> poll_schedule_timeout(); then it will do another iteration, see that
>> no signals are pending and none of the polled files have become ready,
>> and go to sleep again. So things are stuck until the io_uring fd
>> signals that it is ready.
>>
>> The options I see are:
>>
>>  - Tell the kernel to go through signal delivery code, which I think
>> will cause the pending syscall to actually abort and return to
>> userspace (which I think is kinda gross). You could maybe add a
>> special case where that doesn't happen if the task is already in
>> io_uring_enter() and waiting for CQ events.
>>  - Forbid eventfd notifications, ensure that the ring's ->poll handler
>> reports POLLIN when work items are pending for userspace, and then
>> rely on the fact that those work items will be picked up when
>> returning from the poll syscall. Unfortunately, this gets a bit messy
>> when you're dealing with multiple threads that access the same ring,
>> since then you'd have to ensure that *any* thread can pick up this
>> work, and that that doesn't mismatch how the uring instance is shared
>> between threads; but you could probably engineer your way around this.
>> For userspace, this whole thing just means "POLLIN may be spurious".
>>  - Like the previous item, except you tell userspace that if it gets
>> POLLIN (or some special poll status like POLLRDBAND) and sees nothing
>> in the completion queue, it should call io_uring_enter() to process
>> the work. This addresses the submitter-is-not-completion-reaper
>> scenario without having to add some weird version of task_work that
>> will be processed by the first thread, but you'd get some extra
>> syscalls.
> 
> ... or I suppose you could punt to worker context if anyone uses the
> ring's ->poll handler or has an eventfd registered, if you don't
> expect high-performance users to do those things.

Good points, thanks Jann. We have some precedence in the area of
requiring the application to enter the kernel, that's how the CQ ring
overflow is handled as well. For liburing users, that'd be trivial to
hide, for the raw interface that's not necessarily the case. I'd hate to
make the feature opt-in rather than just generally available.

I'll try and play with some ideas in this area and see how it falls out.

-- 
Jens Axboe

