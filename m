Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7196C326B8B
	for <lists+io-uring@lfdr.de>; Sat, 27 Feb 2021 05:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhB0E2M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 23:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbhB0E2K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Feb 2021 23:28:10 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC123C06174A
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 20:27:30 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id g20so6373869plo.2
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 20:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fjRtjVluXS4VlwMJZHNw73GL+tZG/aO5/gqvLU8XqSs=;
        b=RiqtfDqEFEwMcVEH9ueZ8hTcNc8TwAtvWiFk6e4xttbN6IcBXlR8IbCNqw2FPci8Wy
         LilxSKeLeygecpCso5HACa76DMzEnaMMBtwoYVTSgim0wjAZZ8OQn8eH/jXiXH2ipoF0
         MpoWqQahq/ltaT8MY3wrwKGvWC9VTMav2i7Gyc8aXAZGIaXADtpj900r2zXvNoszdbzo
         FD7Olvy2ayfj3ND2vNJoBnAtFfga/n2hABTms3sg5ovkpNWk9ervujEfb4sN25iOPrTB
         +Cw+pSN6BzVmDs5+dqeEhgeouduvmiNAul4f5u7z6KgWdVYTj4/eU7KW+wgIV8s4CvqK
         IaNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fjRtjVluXS4VlwMJZHNw73GL+tZG/aO5/gqvLU8XqSs=;
        b=pp1lNIh8mDeOZqwNLDQyZ+pMUIIV/VcMbLQJgi+ISxIBo/ryZof9DN2dou0Gudgf/p
         ctrK6PY3YvPSQz/cNFdQVxVInTtD02vJSBt3jTJSD1yJg9BKCYrwsAe+8mGuXR16OFJC
         6+ud3qMem2bnSeg8Zt+AObCD6zeHkL6G+oV//3QYTpfcuuY7g6H7F1pYERXVrMI6PDDc
         JxZ2fKhUsDoAv5jxC1el5lVPJAyEVFilHrDRY/mU3Piw+20kwfueJW2PcscAd2m+dhKt
         JYX5gSmy3bFXn14XYSDcGGBRPpW/RrqI/RCMeipWWfeaKCkK/TwrJCoaKJYpWhiYJsUl
         pGVA==
X-Gm-Message-State: AOAM532PA+HX8hPi8iPfxdbGlBDboYlGnbt1X3TwRub0W9xN7Tf/d6US
        ZeXUAdTrf15vdpOhuZ4kjSHtqLpoABRKPA==
X-Google-Smtp-Source: ABdhPJy/778jm4ZRbB+gvg4YwrhynxHrRxuMEk+AsT2fFliP2kxDNlYePo4lE5BQstXuNfRNNCAK+g==
X-Received: by 2002:a17:90a:da02:: with SMTP id e2mr6552021pjv.173.1614400049983;
        Fri, 26 Feb 2021 20:27:29 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q7sm10332085pjr.13.2021.02.26.20.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 20:27:29 -0800 (PST)
Subject: Re: [GIT PULL] io_uring thread worker change
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <0c142458-9473-9df3-535f-34c06957d464@kernel.dk>
 <CAHk-=wjWB3+NnWwuwyQofNv=d1kT0j7T6QH-G_yF_fBO52yvag@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f0bf6cae-b3bd-472d-54b6-5d7367ab28e1@kernel.dk>
Date:   Fri, 26 Feb 2021 21:27:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjWB3+NnWwuwyQofNv=d1kT0j7T6QH-G_yF_fBO52yvag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/26/21 7:48 PM, Linus Torvalds wrote:
> Reading through this once..
> 
> I'll read through it another time tomorrow before merging it, but on
> the whole it looks good. The concept certainly is the right now, but I
> have a few questions about some of the details..

Thanks, I do think it's the right path. As mentioned there's a few minor
rough edges and cases that we've fixed since, and those are soaking as
we speak to verify that they are good. But nothing really major.

> On Fri, Feb 26, 2021 at 2:04 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>>       io-wq: fix races around manager/worker creation and task exit
> 
> Where did that
> 
> +        __set_current_state(TASK_RUNNING);
> 
> in the patch come from? That looks odd.
> 
> Is it because io_wq_manager() does a
> 
>         set_current_state(TASK_INTERRUPTIBLE);
> 
> at one point? Regardless, that code looks very very strange.

Right, it's for both out of necessity for worker creation (since it
blocks), but also so that we'll run the loop again when we return.
Basically:

- Set non-runnable state
- Check condition
- schedule

and the schedule will be a no-op, so we'll do that loop again and
finally then schedule if nothing woke us up. If we don't end up needing
to fork a worker, then the stateremains TASK_INTERRUPTIBLE and we go to
sleep as originally planned.

>>       io_uring: remove the need for relying on an io-wq fallback worker
> 
> This is coded really oddly.
> 
> + do {
> +     head = NULL;
> +     work = READ_ONCE(ctx->exit_task_work);
> + } while (cmpxchg(&ctx->exit_task_work, work, head) != work);
> 
> Whaa?
> 
> If you want to write
> 
>     work = xchg(&ctx->exit_task_work, NULL);
> 
> then just do that. Instead of an insane cmpxchg loop that isn't even
> well-written.
> 
> I say that it isn't even well-written, because when you really do want
> a cmpxchg loop, then realize that cmpxchg() returns the old value, so
> the proper way to write it is
> 
>     new = whatever;
>     expect = READ_ONCE(ctx->exit_task_work);
>     for (;;) {
>           new->next = expect;  // Mumble mumble - this is why you want
> the cmpxchg
>           was = cmpxchg(&ctx->exit_task_work, expect, new);
>           if (was == expect)
>                   break;
>           expect = was;
>     }
> 
> IOW, that READ_ONCE() of the old value should happen only once - and
> isn't worth a READ_ONCE() in the first place. There's nothing "read
> once" about it.
> 
> But as mentioned, if all you want is an atomic "get and replace with
> NULL", then just a plain "xchg()" is what you should do.
> 
> Yes, that cmpxchg loop _works_, but it is really confusing to read
> that way, when clearly you don't actually need or really want a
> cmpxchg.
> 
> (The other cmpxchg loop in the same patch is needed, but does that
> unnecessary "re-read the value that cmpxchg just returned").
> 
> Please explain.

You are totally right, and Eric and Pavel actually commented on that
too. I decided to just leave it for a cleanup patch, because it should
just be an xchg(). I didn't deem it important enough to go back and fix
the original patch, since it isn't broken, it's just not as well written
or as optimal as it could be. It'll get changed to xchg().

-- 
Jens Axboe

