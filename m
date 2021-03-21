Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417A9343341
	for <lists+io-uring@lfdr.de>; Sun, 21 Mar 2021 16:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhCUPnF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 11:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbhCUPmj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 11:42:39 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F638C061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 08:42:39 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso9089885pji.3
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 08:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lfjjDnUJu9opPPSvQVQubITocISsFGgS1UWLUqrIkKA=;
        b=2Q4EYjPPArir5nkhENmAqet6f7qHsv+Fd0FeFVmw9hhZRfkEXbnUUQjDkz2ovHu3Fv
         CLgenqXPoHqF/MtNiJ/GCf1NUNW/yMsohywIk0spdMmjpgcq4FG28nDcOQCPqkc6nuOA
         44YxEIUkOavNg+lt0Jn7q5R0u5yyW0pZPo/z9dy50yllOMZcImxM0xgWn0eqSTWoWPiT
         ot5sn5G07FOsMrUgli1JPU2WEdPpQa231UTywAfBwcg2rl8Hd7YxR3E0kedGBhcq0mFp
         whHxeDJacp/3JHCR3tGVWe7WuQhTixcw6HSYq055Qdi6XS7kHRhKnKNq8FNEUiHdoVdg
         ZaEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lfjjDnUJu9opPPSvQVQubITocISsFGgS1UWLUqrIkKA=;
        b=dmx6G2nzI+An8WKcB8Q/oUbVtxGCX3kwwyltQUvTx00ZxDifoF3pZh/zlyKcPaO+9l
         rxoR+M+8r5yTk/Get/xKUpvALFjjkYRhOXiFb9j1lbTgAf8v2YL5VaK8GSVZsTJ7Hnnd
         8NcgxB+5c5Mr5lDDrNAIbYS4Dn/mzU2P0uis3/YRrKJ4AOelRPuWQzzVJCPPlge2h7gn
         4MgwH5Lgsn5K6///8nJ6ezICBXJYYvZN2Y1HV1vmmJcB/XjlNhBcW5W/2TUUs41yoJgH
         mTiEPUQR82U1RdeA24FxbAMa0Ru97PVCMpgKRVVW86AgvZitC9igdqXeK6xYo8o7oxge
         NvNw==
X-Gm-Message-State: AOAM531ehUYYWlwKBAtE9KwsVeOwxiVGhpkzoiDUAjnYrFBEAGS/Hf/v
        XopB4mtKqgZk+yk8HNzqeiUGv5fAfh8JlA==
X-Google-Smtp-Source: ABdhPJzmQLX2cg+/nJ82cLk9xUY3UiFH3iaFNYt6lVtZkHB0fyjrGJ0Qn8wtyIc26JtTTa9teUqtbQ==
X-Received: by 2002:a17:90a:b392:: with SMTP id e18mr8771052pjr.66.1616341358593;
        Sun, 21 Mar 2021 08:42:38 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w2sm10522754pgh.54.2021.03.21.08.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 08:42:38 -0700 (PDT)
Subject: Re: [PATCHSET 0/2] PF_IO_WORKER signal tweaks
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, criu@openvz.org
References: <20210320153832.1033687-1-axboe@kernel.dk>
 <m14kh5aj0n.fsf@fess.ebiederm.org>
 <CAHk-=whyL6prwWR0GdgxLZm_w-QWwo7jPw_DkEGYFbMeCdo8YQ@mail.gmail.com>
 <CAHk-=wh3DCgezr5RKQ4Mqffoj-F4i47rp85Q4MSFRNhrr8tg3w@mail.gmail.com>
 <m1im5l5vi5.fsf@fess.ebiederm.org>
 <907b36b6-a022-019a-34ea-58ce46dc2d12@kernel.dk>
 <m135wo5yd3.fsf@fess.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <718e91db-5f0b-9aed-7b65-9d41c9f9f8f4@kernel.dk>
Date:   Sun, 21 Mar 2021 09:42:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <m135wo5yd3.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/21/21 9:18 AM, Eric W. Biederman wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 3/20/21 4:08 PM, Eric W. Biederman wrote:
>>>
>>> Added criu because I just realized that io_uring (which can open files
>>> from an io worker thread) looks to require some special handling for
>>> stopping and freezing processes.  If not in the SIGSTOP case in the
>>> related cgroup freezer case.
>>>
>>> Linus Torvalds <torvalds@linux-foundation.org> writes:
>>>
>>>> On Sat, Mar 20, 2021 at 10:51 AM Linus Torvalds
>>>> <torvalds@linux-foundation.org> wrote:
>>>>>
>>>>> Alternatively, make it not use
>>>>> CLONE_SIGHAND|CLONE_THREAD at all, but that would make it
>>>>> unnecessarily allocate its own signal state, so that's "cleaner" but
>>>>> not great either.
>>>>
>>>> Thinking some more about that, it would be problematic for things like
>>>> the resource counters too. They'd be much better shared.
>>>>
>>>> Not adding it to the thread list etc might be clever, but feels a bit too scary.
>>>>
>>>> So on the whole I think Jens' minor patches to just not have IO helper
>>>> threads accept signals are probably the right thing to do.
>>>
>>> The way I see it we have two options:
>>>
>>> 1) Don't ask PF_IO_WORKERs to stop do_signal_stop and in
>>>    task_join_group_stop.
>>>
>>>    The easiest comprehensive implementation looks like just
>>>    updating task_set_jobctl_pending to treat PF_IO_WORKER
>>>    as it treats PF_EXITING.
>>>
>>> 2) Have the main loop of the kernel thread test for JOBCTL_STOP_PENDING
>>>    and call into do_signal_stop.
>>>
>>> It is a wee bit trickier to modify the io_workers to stop, but it does
>>> not look prohibitively difficult.
>>>
>>> All of the work performed by the io worker is work scheduled via
>>> io_uring by the process being stopped.
>>>
>>> - Is the amount of work performed by the io worker thread sufficiently
>>>   negligible that we don't care?
>>>
>>> - Or is the amount of work performed by the io worker so great that it
>>>   becomes a way for an errant process to escape SIGSTOP?
>>>
>>> As the code is all intermingled with the cgroup_freezer.  I am also
>>> wondering creating checkpoints needs additional stopping guarantees.
>>
>> The work done is the same a syscall, basically. So it could be long
>> running and essentially not doing anything (eg read from a socket, no
>> data is there), or it's pretty short lived (eg read from a file, just
>> waiting on DMA).
>>
>> This is outside of my domain of expertise, which is exactly why I added
>> you and Linus to make some calls on what the best approach here would
>> be. My two patches obviously go route #1 in terms of STOP. And fwiw,
>> I tested this:
>>
>>> To solve the issue that SIGSTOP is simply broken right now I am totally
>>> fine with something like:
>>>
>>> diff --git a/kernel/signal.c b/kernel/signal.c
>>> index ba4d1ef39a9e..cb9acdfb32fa 100644
>>> --- a/kernel/signal.c
>>> +++ b/kernel/signal.c
>>> @@ -288,7 +288,8 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask)
>>>  			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
>>>  	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
>>>  
>>> -	if (unlikely(fatal_signal_pending(task) || (task->flags & PF_EXITING)))
>>> +	if (unlikely(fatal_signal_pending(task) ||
>>> +		     (task->flags & (PF_EXITING | PF_IO_WORKER))))
>>>  		return false;
>>>  
>>>  	if (mask & JOBCTL_STOP_SIGMASK)
>>
>> and can confirm it works fine for me with 2/2 reverted and this applied
>> instead.
>>
>>> Which just keeps from creating unstoppable processes today.  I am just
>>> not convinced that is what we want as a long term solution.
>>
>> How about we go with either my 2/2 or yours above to at least ensure we
>> don't leave workers looping as schedule() is a nop with sigpending? If
>> there's a longer timeline concern that "evading" SIGSTOP is a concern, I
>> have absolutely no qualms with making the IO threads participate. But
>> since it seems conceptually simple but with potentially lurking minor
>> issues, probably not the ideal approach for right now.
> 
> 
> Here is the signoff for mine.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Yours misses the joining of group stop during fork.  So we better use
> mine.

I've updated it and attributed it to you, here is is:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.12&id=4db4b1a0d1779dc159f7b87feb97030ec0b12597

> As far as I can see that fixes the outstanding bugs.

Great!

> Jens can you make a proper patch out of it and send it to Linus for
> -rc4?  I unfortunately have other commitments and this is all I can do
> for today.

Will do - I'm going to sanity run the current branch and do a followup
pull request for Linus once I've verified everything is still sane.

-- 
Jens Axboe

