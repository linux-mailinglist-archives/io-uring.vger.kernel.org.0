Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8EC33FBCC
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 00:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhCQX1K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 19:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhCQX05 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 19:26:57 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E798C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 16:26:57 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id n11so218425pgm.12
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 16:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3D/LAYlmQ15bXmYQVLsutCFW4mR0bFPUOpRy2QOLTZI=;
        b=DLQMM8x2cXzjrNwznCRr7z8rBROxx8J2kiYliJRwr1iUa5SvtkF9FpXpCzuyXfOPXw
         Bif0Y4BmNESGIfgt/XSHlCQfpknuOOnv8aEcyq9WHdp5gRoYlOQj5PHjUwS1gQCNQkDD
         2HL29FlOT++R+8bV7LJfuoRnfWV8jUwZpRA3BXXWJo+fyl0jTxpBYcDIYikCr7q8H4tM
         UISw7ytauVLBAmzNPvbS9PSi6Yr27Sf4cHD0Hf5fnHlS/8uE1ejhkPGjwgwGlp6qg0TF
         QeVZK31jh8UgIZzmlfqIIAVy3fYJb/zXVNm/Nge6YfL+cOb4RxKZoB+OZJZlg7Ihl1g6
         bugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3D/LAYlmQ15bXmYQVLsutCFW4mR0bFPUOpRy2QOLTZI=;
        b=UG6rbkx/ok50/14EwAEeSp2X4Ya2Ha/P84c8YEI8TR4/gYF/8buER9+mnlcCC9uv8Z
         9eLaog55qT0iT1R6O385dkEoYZrA6CelkFaTsm7LytC9ZeyjTt1LFWhlgrkYqM6ryDnS
         hg6eDLF1wnRL82SCLNx1lJjaM8jewst3prcWC56ZnYOHZTQaANJdxrjJqsHh+U/S0yqM
         DHHE1Ev1rQ7FDg/046pC2iFB0CcdgjNV6JE/n1U9Czq4eDay1Rz0AJF3EP/LCi82SpPR
         4vdFlJRGuEfRNdYOaNGcuHHmhd/bFPyRCbw1q+cJ3c5Hs0d/kjOgvS70hdjwDNjhHHaL
         Saiw==
X-Gm-Message-State: AOAM531nfyqyAIIr2xE7eQ7kWahWAHeBo65Oqv4R4aDtNBFn4ayrFs6V
        Xl1NqhI+JII7jR/QQ0d/4+DEYJbXAkHLp/+u
X-Google-Smtp-Source: ABdhPJwjXxn+p96pM018B04RbhJ5STE8y1zjQugfKtMe95SklDlw9fNJu5iLL/6k6X4JOauq1j8XFA==
X-Received: by 2002:a63:fd0a:: with SMTP id d10mr4360782pgh.405.1616023616329;
        Wed, 17 Mar 2021 16:26:56 -0700 (PDT)
Received: from ?IPv6:2600:380:4a51:337f:2eaa:706:9b3d:17d9? ([2600:380:4a51:337f:2eaa:706:9b3d:17d9])
        by smtp.gmail.com with ESMTPSA id a19sm153350pfn.181.2021.03.17.16.26.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 16:26:55 -0700 (PDT)
Subject: Re: [RFC PATCH 00/10] Complete setup before calling
 wake_up_new_task() and improve task->comm
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <cover.1615826736.git.metze@samba.org>
 <60a6919e-259b-fcc8-86fd-d85105545675@kernel.dk>
 <0784fd4d-cf3a-f638-0fd3-f631be1e490a@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8dca99dd-a82e-1c88-31b6-621ea7b4db63@kernel.dk>
Date:   Wed, 17 Mar 2021 17:26:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0784fd4d-cf3a-f638-0fd3-f631be1e490a@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/17/21 5:06 PM, Stefan Metzmacher wrote:
> 
> Hi Jens,
> 
>>> now that we have an explicit wake_up_new_task() in order to start the
>>> result from create_io_thread(), we should things up before calling
>>> wake_up_new_task().
>>>
>>> There're also some improvements around task->comm:
>>> - We return 0 bytes for /proc/<pid>/cmdline
>>> - We no longer allow a userspace process to change
>>>   /proc/<pid>/[task/<tid>]/comm
>>> - We dynamically generate comm names (up to 63 chars)
>>>   via io_wq_worker_comm(), similar to wq_worker_comm()
>>>
>>> While doing this I noticed a few places we check for
>>> PF_KTHREAD, but not PF_IO_WORKER, maybe we should
>>> have something like a PS_IS_KERNEL_THREAD_MASK() macro
>>> that should be used in generic places and only
>>> explicitly use PF_IO_WORKER or PF_KTHREAD checks where the
>>> difference matters.
>>>
>>> There are also quite a number of cases where we use
>>> same_thread_group(), I guess these need to be checked.
>>> Should that return true if userspace threads and their iothreds
>>> are compared?
> 
> Can you comment more deeply here and recheck this in the code
> I just noticed possible problems by reading the code and playing
> with git grep. I don't have time right now to build my own 5.12 kernel
> and play with it. (I'm planing to do some livepath tricks to inject
> backported io_uring into an older kernel...).
> 
> For a lot of things regarding PF_KTHREAD v. PF_IO_WORKER and
> same_thread_group() I'm just unsure what the correct behavior would be.

FWIW, I do agree that we should probably have an umbrella that covers
PF_KTHREAD and PF_IO_WORKER, though not in all cases would that be
useful. But we have had a few, so definitely useful.

> It would help if you could post dumps of things like:
> ps axf -o user,pid,tid,comm,cmd
> ls -laR /proc/$pid/
> 
> Currently I can only guess how things will look like.

I'm not too worried about the comm side, and in fact, I'd prefer
deferring that to 5.13 and we can just stable backport it instead.
Trying to keep the amount of churn down to bare necessities at this
point.

>>> I've compiled but didn't test, I hope there's something useful...
>>
>> Looks pretty good to me. Can I talk you into splitting this into
>> a series for 5.12, and then a 5.13 on top? It looks a bit mixed
>> right now. For 5.12, basically just things we absolutely need for
>> release. Any cleanups or improvements on top should go to 5.13.
> 
> I'll rebase tomorrow. Actually I'd like to see all of them in 5.12
> because it would means that do the admin visible change only once.
> 
> The WARN_ON() fixes are not strictly needed, but for me it would be
> strange to defer them.
> io_wq_worker_comm() patches are not strictly required,
> but they would make the new design more consistent and
> avoid changing things again in 5.13.

Right, hence I'd prefer to push comm changes, and anything that isn't
strictly a bug.

-- 
Jens Axboe

