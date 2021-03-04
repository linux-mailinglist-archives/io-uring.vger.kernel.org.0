Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34BC32D85F
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 18:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236627AbhCDRKM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 12:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238037AbhCDRKL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 12:10:11 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCB2C061756
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 09:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=Wz5gZQ8jreq+Ih0H6gD7QsYuJejRVi7sFEsNYjeLWlA=; b=x1kNX6mQqPH929n1CPRoNXD7YQ
        osHCMHwXHtjFUHqDkhZiPRy5dopH+gakQZEsV7q0o02wTjGxNCnZ7drg+senNJlxu4G3Dt1rbCR5s
        UD3JPf/++VRs01WMoWfRi3pfAgjWjkBRTNo3CFBSL7Ouhg750+dwHxYF3GXXWC5YvW00+gsS6ebAN
        BnQ0s5QIzqIx2wgHK969qQWOh+8kNfc9pj1yAIMA4PmP+IGIvNAww1M9HcqruoCnd5/QCgOxESYfo
        kT++crqvLEzESYiL0fUiAEa3TedISQ11HsJ5EMzqjDo+YmSCMxGQevUACkQYlsnONqJFAgaQweOJp
        ZYPzZsfSgi53GYjWv/3XIVZuc7Cdild2IYrkaBav3qzzM0kt4qGCEH3ILzfoSwZcUpjkOniDOAM0z
        KzLRoN+/mCjCxoUEM1ge6hAM0BMJEg39Yb4YxooCDBNij/d4uylKeMwNVrGIkAQAQURj3kef9/svr
        D9U/ch94YkVM+okbRhsuIJGu;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lHrTc-0007up-RR; Thu, 04 Mar 2021 17:09:28 +0000
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-10-axboe@kernel.dk>
 <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org>
 <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk>
 <a9f58269-b260-6281-4e83-43cb5e881d25@samba.org>
 <d3dfc422-8762-0078-bc80-989f1d71f006@samba.org>
 <32f1218b-49c3-eeb6-5866-3ec45acbc1c5@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
Message-ID: <34857989-ff46-b2a7-9730-476636848acc@samba.org>
Date:   Thu, 4 Mar 2021 18:09:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <32f1218b-49c3-eeb6-5866-3ec45acbc1c5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 04.03.21 um 17:42 schrieb Jens Axboe:
> On 3/4/21 9:13 AM, Stefan Metzmacher wrote:
>>
>> Am 04.03.21 um 14:19 schrieb Stefan Metzmacher:
>>> Hi Jens,
>>>
>>>>> Can you please explain why CLONE_SIGHAND is used here?
>>>>
>>>> We can't have CLONE_THREAD without CLONE_SIGHAND... The io-wq workers
>>>> don't really care about signals, we don't use them internally.
>>>
>>> I'm 100% sure, but I heard rumors that in some situations signals get
>>> randomly delivered to any thread of a userspace process.
>>
>> Ok, from task_struct:
>>
>>         /* Signal handlers: */
>>         struct signal_struct            *signal;
>>         struct sighand_struct __rcu             *sighand;
>>         sigset_t                        blocked;
>>         sigset_t                        real_blocked;
>>         /* Restored if set_restore_sigmask() was used: */
>>         sigset_t                        saved_sigmask;
>>         struct sigpending               pending;
>>
>> The signal handlers are shared, but 'blocked' is per thread/task.
>>
>>> My fear was that the related logic may select a kernel thread if they
>>> share the same signal handlers.
>>
>> I found the related logic in the interaction between
>> complete_signal() and wants_signal().
>>
>> static inline bool wants_signal(int sig, struct task_struct *p)
>> {
>>         if (sigismember(&p->blocked, sig))
>>                 return false;
>>
>> ...
>>
>> Would it make sense to set up task->blocked to block all signals?
>>
>> Something like this:
>>
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -611,15 +611,15 @@ pid_t io_wq_fork_thread(int (*fn)(void *), void *arg)
>>  {
>>         unsigned long flags = CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|
>>                                 CLONE_IO|SIGCHLD;
>> -       struct kernel_clone_args args = {
>> -               .flags          = ((lower_32_bits(flags) | CLONE_VM |
>> -                                   CLONE_UNTRACED) & ~CSIGNAL),
>> -               .exit_signal    = (lower_32_bits(flags) & CSIGNAL),
>> -               .stack          = (unsigned long)fn,
>> -               .stack_size     = (unsigned long)arg,
>> -       };
>> +       sigset_t mask, oldmask;
>> +       pid_t pid;
>>
>> -       return kernel_clone(&args);
>> +       sigfillset(&mask);
>> +       sigprocmask(SIG_BLOCK, &mask, &oldmask);
>> +       pid = kernel_thread(fn, arg, flags);
>> +       sigprocmask(SIG_SETMASK, &oldmask, NULL);
>> +
>> +       return ret;
>>  }
>>
>> I think using kernel_thread() would be a good simplification anyway.
> 
> I like this approach, we're really not interested in signals for those
> threads, and this makes it explicit. Ditto on just using the kernel_thread()
> helper, looks fine too. I'll run this through the testing. Do you want to
> send this as a "real" patch, or should I just attribute you in the commit
> message?

You can do the patch, it was mostly an example.
I'm not sure if sigprocmask() is the correct function here.

Or if we better use something like this:

        set_restore_sigmask();
        current->saved_sigmask = current->blocked;
        set_current_blocked(&kmask);
        pid = kernel_thread(fn, arg, flags);
        restore_saved_sigmask();

I think current->flags |= PF_IO_WORKER;
should also move into io_wq_fork_thread()
and maybe passed differently to kernel_clone() that
abusing current->flags (where current is not an IO_WORKER),
so in general I think it would be better to handle all this within kernel_clone()
natively, rather than temporary modifying current->flags or current->blocked.

What there be problems with handling everything in copy_process() and related helpers
and avoid the CLONE_SIGHAND behavior for PF_IO_WORKER tasks.

kernel_clone_args could get an unsigned int task_flags to fill p->flags in copy_process().
Then kernel_thread() could also get a task_flags argument and in all other places will use
fill that with current->flags.

metze
