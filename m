Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6950932D800
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 17:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbhCDQnc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 11:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbhCDQnG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 11:43:06 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373E3C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 08:42:26 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id o9so15505980iow.6
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 08:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YVtHkyDJqd+ZycuOV1hIiBr1sy1bTxsuzz5qJY3TVdY=;
        b=doU4D70KZMImU+DuIVez97lsFDMavYiA03bh34CjRrFhTaKE4VGWlu29VF6xJHzJRu
         pA1sLkeGTkCsgFhfykqh4biDMf0QgzQvSunnGhy9IYbOpp1FcK1PhV+d9jcUgTjrKezQ
         5TrVXTxGJXyyEAaAvdCPGd53IqF8i1+n0CYu6ZnpPA1PBDUHBpLOC4M/AHrwZY4e7nU5
         gHpVMkK0qgxNpI4Bj26Bjin7MiyoL5ki7HnV7P4WGzrTEM3z76tbOVmGR3US+v9zU8eX
         cOsLgxARBiiNFTKDxQ05cVgbRrVnhlgryTQshezCgDM3dDlTGPS03KyJexxdEKjxqnPu
         pVcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YVtHkyDJqd+ZycuOV1hIiBr1sy1bTxsuzz5qJY3TVdY=;
        b=aeey36f6ZjqnijX6ON4fvmOtOzKsut4S/rctAtH8SQIUeYdMkjhOLdl8mvqt8ocKuw
         l217DBnlNeLQ/+mfRjqR0Y6qv4uIkvEeyUOJo8NZG4mRkV5x7SOd7JX27x5KTgcdFfAN
         9I6JKbKf9IcBOQhPlcgfIpUBNZhymvvjbTdeiX+/RFt1FsnPr1Lgx6kiOD4HTah4Wx4j
         3UznkMfqncczhXXY8KwgueALgxTtVmEFthS/3XzHZVwkt6VD6BzHM4TvxcxVu4nx/mgs
         p2hF72INRj42MbWpLtCLSnR95nInIomSx7P9EbDXu34n/a8j4VkAJxjWlsgFERsKGbKs
         NGLw==
X-Gm-Message-State: AOAM532H0w/WpP/iNHb+LEADjcfa5AoQiYPy70Khkbkc3ymd1Gat0an8
        qK6EfomLiRCq+44lPPnZQowfkQ==
X-Google-Smtp-Source: ABdhPJyqudlxWjYT/gzJYtasm0qwi0XqhiSTH9cPkvZrMLkIJZXWBHrdtAaATs8N642bHaNfcBadKw==
X-Received: by 2002:a5e:9612:: with SMTP id a18mr4149373ioq.209.1614876145592;
        Thu, 04 Mar 2021 08:42:25 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r15sm6541193iot.5.2021.03.04.08.42.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 08:42:24 -0800 (PST)
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <32f1218b-49c3-eeb6-5866-3ec45acbc1c5@kernel.dk>
Date:   Thu, 4 Mar 2021 09:42:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d3dfc422-8762-0078-bc80-989f1d71f006@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/21 9:13 AM, Stefan Metzmacher wrote:
> 
> Am 04.03.21 um 14:19 schrieb Stefan Metzmacher:
>> Hi Jens,
>>
>>>> Can you please explain why CLONE_SIGHAND is used here?
>>>
>>> We can't have CLONE_THREAD without CLONE_SIGHAND... The io-wq workers
>>> don't really care about signals, we don't use them internally.
>>
>> I'm 100% sure, but I heard rumors that in some situations signals get
>> randomly delivered to any thread of a userspace process.
> 
> Ok, from task_struct:
> 
>         /* Signal handlers: */
>         struct signal_struct            *signal;
>         struct sighand_struct __rcu             *sighand;
>         sigset_t                        blocked;
>         sigset_t                        real_blocked;
>         /* Restored if set_restore_sigmask() was used: */
>         sigset_t                        saved_sigmask;
>         struct sigpending               pending;
> 
> The signal handlers are shared, but 'blocked' is per thread/task.
> 
>> My fear was that the related logic may select a kernel thread if they
>> share the same signal handlers.
> 
> I found the related logic in the interaction between
> complete_signal() and wants_signal().
> 
> static inline bool wants_signal(int sig, struct task_struct *p)
> {
>         if (sigismember(&p->blocked, sig))
>                 return false;
> 
> ...
> 
> Would it make sense to set up task->blocked to block all signals?
> 
> Something like this:
> 
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -611,15 +611,15 @@ pid_t io_wq_fork_thread(int (*fn)(void *), void *arg)
>  {
>         unsigned long flags = CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|
>                                 CLONE_IO|SIGCHLD;
> -       struct kernel_clone_args args = {
> -               .flags          = ((lower_32_bits(flags) | CLONE_VM |
> -                                   CLONE_UNTRACED) & ~CSIGNAL),
> -               .exit_signal    = (lower_32_bits(flags) & CSIGNAL),
> -               .stack          = (unsigned long)fn,
> -               .stack_size     = (unsigned long)arg,
> -       };
> +       sigset_t mask, oldmask;
> +       pid_t pid;
> 
> -       return kernel_clone(&args);
> +       sigfillset(&mask);
> +       sigprocmask(SIG_BLOCK, &mask, &oldmask);
> +       pid = kernel_thread(fn, arg, flags);
> +       sigprocmask(SIG_SETMASK, &oldmask, NULL);
> +
> +       return ret;
>  }
> 
> I think using kernel_thread() would be a good simplification anyway.

I like this approach, we're really not interested in signals for those
threads, and this makes it explicit. Ditto on just using the kernel_thread()
helper, looks fine too. I'll run this through the testing. Do you want to
send this as a "real" patch, or should I just attribute you in the commit
message?

-- 
Jens Axboe

