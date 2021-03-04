Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDBB32D77C
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 17:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhCDQOo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 11:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236185AbhCDQOj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 11:14:39 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F604C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 08:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:Cc:To:From;
        bh=8WPOg7aHAYMZ/WgGGwtla213M4EaWBCNHNR6ymOinCg=; b=aSrmSfjsA5gKGIyVUFULlZnLOo
        QgcS5MYLYWzgMTPqWZD5Acn65vvjqXDtYriE5mM7Uy0c3wN3nYEV56F82g8oTXnHHa13KjIGHnrRv
        sEmHQ0mJhyXIYJllCX+9K7ZRPNEsr2fDnHDWH0mhRXbHnZwKFgb9s8MzhAIK723UhZYusSQDA4cA2
        wzrIZJhPAz/bPFRtOTuqGJemR57vPaBNk6OX90KldIX0JmlAkEK0ZtX3d0/S+EVDEXV+8ZLcTAwEc
        1FzJjN+55bjXSpbTXp/DbxM5w4FSUpvYEiBvbpSNrMFODAPSqG0zIGn9ZNLXcBTb/vSyHuHHPuR0P
        Kxzxpc6g2wtIFd6VFbhqH4rg0FX/4lrECZXOjhc2c7+4POGg9cMcItQfaeC9oZLIXB0s+yuVCwpNe
        O0gcOTwmXum159ofQ58gwV1NE7hUuPZTf7AXldSsBLu7msr7MI/0UabFgME4zFHjLxY9NxUFmhR7C
        EO414/rywHmuiSgOfs0lCdOV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lHqbs-0007U2-Qk; Thu, 04 Mar 2021 16:13:56 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-10-axboe@kernel.dk>
 <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org>
 <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk>
 <a9f58269-b260-6281-4e83-43cb5e881d25@samba.org>
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
Message-ID: <d3dfc422-8762-0078-bc80-989f1d71f006@samba.org>
Date:   Thu, 4 Mar 2021 17:13:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <a9f58269-b260-6281-4e83-43cb5e881d25@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 04.03.21 um 14:19 schrieb Stefan Metzmacher:
> Hi Jens,
> 
>>> Can you please explain why CLONE_SIGHAND is used here?
>>
>> We can't have CLONE_THREAD without CLONE_SIGHAND... The io-wq workers
>> don't really care about signals, we don't use them internally.
> 
> I'm 100% sure, but I heard rumors that in some situations signals get
> randomly delivered to any thread of a userspace process.

Ok, from task_struct:

        /* Signal handlers: */
        struct signal_struct            *signal;
        struct sighand_struct __rcu             *sighand;
        sigset_t                        blocked;
        sigset_t                        real_blocked;
        /* Restored if set_restore_sigmask() was used: */
        sigset_t                        saved_sigmask;
        struct sigpending               pending;

The signal handlers are shared, but 'blocked' is per thread/task.

> My fear was that the related logic may select a kernel thread if they
> share the same signal handlers.

I found the related logic in the interaction between
complete_signal() and wants_signal().

static inline bool wants_signal(int sig, struct task_struct *p)
{
        if (sigismember(&p->blocked, sig))
                return false;

...

Would it make sense to set up task->blocked to block all signals?

Something like this:

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -611,15 +611,15 @@ pid_t io_wq_fork_thread(int (*fn)(void *), void *arg)
 {
        unsigned long flags = CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|
                                CLONE_IO|SIGCHLD;
-       struct kernel_clone_args args = {
-               .flags          = ((lower_32_bits(flags) | CLONE_VM |
-                                   CLONE_UNTRACED) & ~CSIGNAL),
-               .exit_signal    = (lower_32_bits(flags) & CSIGNAL),
-               .stack          = (unsigned long)fn,
-               .stack_size     = (unsigned long)arg,
-       };
+       sigset_t mask, oldmask;
+       pid_t pid;

-       return kernel_clone(&args);
+       sigfillset(&mask);
+       sigprocmask(SIG_BLOCK, &mask, &oldmask);
+       pid = kernel_thread(fn, arg, flags);
+       sigprocmask(SIG_SETMASK, &oldmask, NULL);
+
+       return ret;
 }

I think using kernel_thread() would be a good simplification anyway.

sig_task_ignored() has some PF_IO_WORKER logic.

Or is there any PF_IO_WORKER related logic that prevents
an io_wq thread to be excluded in complete_signal().

Or PF_IO_WORKER would teach kernel_clone to ignore CLONE_SIGHAND
and create a fresh handler and alter the copy_signal() and copy_sighand()
checks...

metze
