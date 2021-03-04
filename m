Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D724432D8A4
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 18:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbhCDRdI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 12:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238393AbhCDRdC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 12:33:02 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B4AC061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 09:32:22 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id g9so25597521ilc.3
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 09:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GgaskH7YDIwN8bBGT1CyGEdr1yY0XCw9wPTWOp0SFoQ=;
        b=u48Ee+yKXbyreIb1+T9BfT6PV8ji+19wFe3cSF+s5qnmEGpg6nUFUchiIc37XKyiR+
         d1C2xrtq0VX7KTmlHi7bjkcGWCO37O6QQB7XUNHIP7joVG6TWVgel34NJhl3qXCIYHGo
         qFwUvb4HeYVWjE34bqPc7RdGo7viSIKFiKN4hEbcMwkcfK2KPCC1sQBAuTMK8wozj0/o
         +AOZ0otXoazojkRnF7DKax1lULmLvXujqmIwVAj6/p/EjbDIlgZJUKt68aEdEJD43Utx
         zlOYiMmB5PaZFSvVfSwxVkqxu05GAzuX6EBn6aRRMenJ5Iib2ZJJeZisP364SSIIKd4O
         Y2gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GgaskH7YDIwN8bBGT1CyGEdr1yY0XCw9wPTWOp0SFoQ=;
        b=Li8JgXaq085JpEznzyGkZGuRjfbnn1nv5/g5S92jqDCcBGiFLL8C2G1V0MKPPP+jAp
         Rcdf72TbY1u3QLAeh6gQclp3OqiH1ZKv13ZLXctXMl1Toa7YY+aJSMMdakTVqRIXK8dI
         8Fug/FYWyE3Rc2deKySPqEv8eqcZjULK8NsisoLP5hibgZqIVCG4yqljRZDZ3bJo/E49
         huUpYMNoX0LiSlAVwi3jzOOLgkBe4RmjlKVSRrBT71xpmEw0lKRTldhOYuNt1sWbBc1J
         3B1hy+3Kkg5CE+LTMDnxChMqdSsR4JpEtmV8rY0X6m4KpX67pI7cPFLHaFWMwrtIC/r4
         44jw==
X-Gm-Message-State: AOAM531tW3cPY/Zeh70VrrrIyTPCy1h0/J7rOpzHTsxKQHBVIOKPThQ1
        6ZoDzPSE0f8LvO34ehBZ4OkuJtQA9Qrx6g==
X-Google-Smtp-Source: ABdhPJxyu+60gDiglzHJu3Ocd6pD9N1dl1w4bMoGKfbAa9UHTSi3QjFW/56oBzYmvGoJTrnrRlZ8gg==
X-Received: by 2002:a92:d352:: with SMTP id a18mr4667279ilh.33.1614879141516;
        Thu, 04 Mar 2021 09:32:21 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h13sm15201541ioe.40.2021.03.04.09.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 09:32:20 -0800 (PST)
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-10-axboe@kernel.dk>
 <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org>
 <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk>
 <a9f58269-b260-6281-4e83-43cb5e881d25@samba.org>
 <d3dfc422-8762-0078-bc80-989f1d71f006@samba.org>
 <32f1218b-49c3-eeb6-5866-3ec45acbc1c5@kernel.dk>
 <34857989-ff46-b2a7-9730-476636848acc@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <47c76a83-a449-3a65-5850-1d3dff4f3249@kernel.dk>
Date:   Thu, 4 Mar 2021 10:32:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <34857989-ff46-b2a7-9730-476636848acc@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/21 10:09 AM, Stefan Metzmacher wrote:
> 
> Am 04.03.21 um 17:42 schrieb Jens Axboe:
>> On 3/4/21 9:13 AM, Stefan Metzmacher wrote:
>>>
>>> Am 04.03.21 um 14:19 schrieb Stefan Metzmacher:
>>>> Hi Jens,
>>>>
>>>>>> Can you please explain why CLONE_SIGHAND is used here?
>>>>>
>>>>> We can't have CLONE_THREAD without CLONE_SIGHAND... The io-wq workers
>>>>> don't really care about signals, we don't use them internally.
>>>>
>>>> I'm 100% sure, but I heard rumors that in some situations signals get
>>>> randomly delivered to any thread of a userspace process.
>>>
>>> Ok, from task_struct:
>>>
>>>         /* Signal handlers: */
>>>         struct signal_struct            *signal;
>>>         struct sighand_struct __rcu             *sighand;
>>>         sigset_t                        blocked;
>>>         sigset_t                        real_blocked;
>>>         /* Restored if set_restore_sigmask() was used: */
>>>         sigset_t                        saved_sigmask;
>>>         struct sigpending               pending;
>>>
>>> The signal handlers are shared, but 'blocked' is per thread/task.
>>>
>>>> My fear was that the related logic may select a kernel thread if they
>>>> share the same signal handlers.
>>>
>>> I found the related logic in the interaction between
>>> complete_signal() and wants_signal().
>>>
>>> static inline bool wants_signal(int sig, struct task_struct *p)
>>> {
>>>         if (sigismember(&p->blocked, sig))
>>>                 return false;
>>>
>>> ...
>>>
>>> Would it make sense to set up task->blocked to block all signals?
>>>
>>> Something like this:
>>>
>>> --- a/fs/io-wq.c
>>> +++ b/fs/io-wq.c
>>> @@ -611,15 +611,15 @@ pid_t io_wq_fork_thread(int (*fn)(void *), void *arg)
>>>  {
>>>         unsigned long flags = CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|
>>>                                 CLONE_IO|SIGCHLD;
>>> -       struct kernel_clone_args args = {
>>> -               .flags          = ((lower_32_bits(flags) | CLONE_VM |
>>> -                                   CLONE_UNTRACED) & ~CSIGNAL),
>>> -               .exit_signal    = (lower_32_bits(flags) & CSIGNAL),
>>> -               .stack          = (unsigned long)fn,
>>> -               .stack_size     = (unsigned long)arg,
>>> -       };
>>> +       sigset_t mask, oldmask;
>>> +       pid_t pid;
>>>
>>> -       return kernel_clone(&args);
>>> +       sigfillset(&mask);
>>> +       sigprocmask(SIG_BLOCK, &mask, &oldmask);
>>> +       pid = kernel_thread(fn, arg, flags);
>>> +       sigprocmask(SIG_SETMASK, &oldmask, NULL);
>>> +
>>> +       return ret;
>>>  }
>>>
>>> I think using kernel_thread() would be a good simplification anyway.
>>
>> I like this approach, we're really not interested in signals for those
>> threads, and this makes it explicit. Ditto on just using the kernel_thread()
>> helper, looks fine too. I'll run this through the testing. Do you want to
>> send this as a "real" patch, or should I just attribute you in the commit
>> message?
> 
> You can do the patch, it was mostly an example.
> I'm not sure if sigprocmask() is the correct function here.
> 
> Or if we better use something like this:
> 
>         set_restore_sigmask();
>         current->saved_sigmask = current->blocked;
>         set_current_blocked(&kmask);
>         pid = kernel_thread(fn, arg, flags);
>         restore_saved_sigmask();

Might be cleaner, and allows fatal signals.

> I think current->flags |= PF_IO_WORKER;
> should also move into io_wq_fork_thread()
> and maybe passed differently to kernel_clone() that
> abusing current->flags (where current is not an IO_WORKER),
> so in general I think it would be better to handle all this within kernel_clone()
> natively, rather than temporary modifying current->flags or current->blocked.
> 
> What there be problems with handling everything in copy_process() and related helpers
> and avoid the CLONE_SIGHAND behavior for PF_IO_WORKER tasks.
> 
> kernel_clone_args could get an unsigned int task_flags to fill p->flags in copy_process().
> Then kernel_thread() could also get a task_flags argument and in all other places will use
> fill that with current->flags.

I agree there are cleanups possible there, but I'd rather defer those until all
the dust has settled.

-- 
Jens Axboe

