Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A53343034
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 23:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhCTWxK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Mar 2021 18:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhCTWxJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Mar 2021 18:53:09 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E263AC061574
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 15:53:08 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id l1so6127188pgb.5
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 15:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=loJtadz11k9s/k92JAPlZ0uUPDBkIe52qTJzUu616NU=;
        b=n06jRY9UMbT/u4rKxl6i122jNhUHyan6aXjvVaugHUiJocJeu6I9n8Dile+eGY4zkJ
         ETXf2302ueG59950/GQ6J2RaAclnVbE2xTKoZIQBs1cTmn+0gsyCZcJZkjApg8XRwHyl
         TCEavpkSMjEiUMTub4LAZBs518LzzzV+YpTtiL9ZbSox5yh2Wq0r2aZlXg8Z3plHRxGK
         nWWW18XKW2qyQ9IEsyj3SvdwhrqYd1SQxJYRmPf6zb30h1jSy9DMCLalNu42Ws1NiPQe
         mitiJmz0vpDk5sRLgGD57yF6ZhFs3xs40ZrNKgRuoyb7f0HjebcN6Lz9mMKQyPsUJMfK
         dMxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=loJtadz11k9s/k92JAPlZ0uUPDBkIe52qTJzUu616NU=;
        b=ZN6FfgcUCTZDn/SCV05bv5u0GUxsXmfD/F1Ja0Tq6JKKfkWNOSqS28H7QpUKCYZ2H9
         aRiedVJ/iN3QZCpoywLTcRNZFfF22rfGglIUrcoLkm0XUjRhpaJe1salJU6exlO02v8+
         vqR/rmn7TmxB3ezKak8JCCKF3/TRQpXUL04WkR+DrZS7gzpkT1UU50JD/F4+PuRSfU20
         3oHnY9LrgDMMIIQTRrHbqtM0KTMvJApwp2OlBU5U8a6k6J8TKa1s3hN/i/Ah3lTcWBks
         OIO4M6VZxgJe/RUgGo3Tcoe7+NX6m2RezS3hc1cxBz6/kfTKGtriogT00qQgCJNvMTvZ
         KZAQ==
X-Gm-Message-State: AOAM532Gi9dp8pcD/F2Y3w6FhFT5L4ey1dODUeXf8hW/7i7X2KWL0WxC
        Ufp2+4V487kOyQF5340njj83Lw==
X-Google-Smtp-Source: ABdhPJzDqXRafmaH7Jo+tjWnSiLzYWX6L7b3GS9juDTDlP5hsT/Ae9XvHHxxF01YNrmYs9nAGMBcKw==
X-Received: by 2002:a63:d40b:: with SMTP id a11mr16710498pgh.192.1616280788204;
        Sat, 20 Mar 2021 15:53:08 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l4sm9077825pgn.77.2021.03.20.15.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 15:53:07 -0700 (PDT)
Subject: Re: [PATCHSET 0/2] PF_IO_WORKER signal tweaks
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, criu@openvz.org
References: <20210320153832.1033687-1-axboe@kernel.dk>
 <m14kh5aj0n.fsf@fess.ebiederm.org>
 <CAHk-=whyL6prwWR0GdgxLZm_w-QWwo7jPw_DkEGYFbMeCdo8YQ@mail.gmail.com>
 <CAHk-=wh3DCgezr5RKQ4Mqffoj-F4i47rp85Q4MSFRNhrr8tg3w@mail.gmail.com>
 <m1im5l5vi5.fsf@fess.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <907b36b6-a022-019a-34ea-58ce46dc2d12@kernel.dk>
Date:   Sat, 20 Mar 2021 16:53:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <m1im5l5vi5.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/20/21 4:08 PM, Eric W. Biederman wrote:
> 
> Added criu because I just realized that io_uring (which can open files
> from an io worker thread) looks to require some special handling for
> stopping and freezing processes.  If not in the SIGSTOP case in the
> related cgroup freezer case.
> 
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
>> On Sat, Mar 20, 2021 at 10:51 AM Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>>
>>> Alternatively, make it not use
>>> CLONE_SIGHAND|CLONE_THREAD at all, but that would make it
>>> unnecessarily allocate its own signal state, so that's "cleaner" but
>>> not great either.
>>
>> Thinking some more about that, it would be problematic for things like
>> the resource counters too. They'd be much better shared.
>>
>> Not adding it to the thread list etc might be clever, but feels a bit too scary.
>>
>> So on the whole I think Jens' minor patches to just not have IO helper
>> threads accept signals are probably the right thing to do.
> 
> The way I see it we have two options:
> 
> 1) Don't ask PF_IO_WORKERs to stop do_signal_stop and in
>    task_join_group_stop.
> 
>    The easiest comprehensive implementation looks like just
>    updating task_set_jobctl_pending to treat PF_IO_WORKER
>    as it treats PF_EXITING.
> 
> 2) Have the main loop of the kernel thread test for JOBCTL_STOP_PENDING
>    and call into do_signal_stop.
> 
> It is a wee bit trickier to modify the io_workers to stop, but it does
> not look prohibitively difficult.
> 
> All of the work performed by the io worker is work scheduled via
> io_uring by the process being stopped.
> 
> - Is the amount of work performed by the io worker thread sufficiently
>   negligible that we don't care?
> 
> - Or is the amount of work performed by the io worker so great that it
>   becomes a way for an errant process to escape SIGSTOP?
> 
> As the code is all intermingled with the cgroup_freezer.  I am also
> wondering creating checkpoints needs additional stopping guarantees.

The work done is the same a syscall, basically. So it could be long
running and essentially not doing anything (eg read from a socket, no
data is there), or it's pretty short lived (eg read from a file, just
waiting on DMA).

This is outside of my domain of expertise, which is exactly why I added
you and Linus to make some calls on what the best approach here would
be. My two patches obviously go route #1 in terms of STOP. And fwiw,
I tested this:

> To solve the issue that SIGSTOP is simply broken right now I am totally
> fine with something like:
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index ba4d1ef39a9e..cb9acdfb32fa 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -288,7 +288,8 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask)
>  			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
>  	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
>  
> -	if (unlikely(fatal_signal_pending(task) || (task->flags & PF_EXITING)))
> +	if (unlikely(fatal_signal_pending(task) ||
> +		     (task->flags & (PF_EXITING | PF_IO_WORKER))))
>  		return false;
>  
>  	if (mask & JOBCTL_STOP_SIGMASK)

and can confirm it works fine for me with 2/2 reverted and this applied
instead.

> Which just keeps from creating unstoppable processes today.  I am just
> not convinced that is what we want as a long term solution.

How about we go with either my 2/2 or yours above to at least ensure we
don't leave workers looping as schedule() is a nop with sigpending? If
there's a longer timeline concern that "evading" SIGSTOP is a concern, I
have absolutely no qualms with making the IO threads participate. But
since it seems conceptually simple but with potentially lurking minor
issues, probably not the ideal approach for right now.

-- 
Jens Axboe

