Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0125129065D
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 15:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408111AbgJPNdV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 09:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407996AbgJPNdU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 09:33:20 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635CCC0613D3
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 06:33:19 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 144so1522040pfb.4
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 06:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XId5jF20WoJucd7UO/O4pOGAuuKjSwAQsDiyHWbeAK0=;
        b=0bNM9NwPbtFkSdLDBoUo/aM0G5yRT9dB58kuUATJYEA+QUGkwEChc5rGMnj64wNBfN
         e6ZW+CZTl+f4EA4jFl46ZxGdOQaROglNJPCMalxHq/XvwbbsniMMPPk2CcjnHRKOBbF+
         T95R6sXAf+6TchEmAak4fWzVqSVxJYCNeBocnyg25iU+Xs9hG5tTcE5Fhuxk3yTo9ISH
         Oy88F3tdBPv9XbUX9xyWTIDl/8RYO+DbXeetRLvmveStTW/E7E5a6vAnsXPZPmxaydb3
         TluEKL8e+zjdrtKGRH+X2Zt2Nfp8Aub80XUqOr4HZqQcC7r7InD6Gz8oRYsevTkzBLy8
         f1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XId5jF20WoJucd7UO/O4pOGAuuKjSwAQsDiyHWbeAK0=;
        b=iQzYSEzrSDsiLNpCNbG3NkED7NUhAcrzaxap99913lL8vF3tPj2zgiEhL+8/u+Qq/c
         ouRLjAr2DAOCinptk9gcIYI3R0YDu2+f/S12XHzLz97b6tX0ka72LfCgQ/V5AXeg1RjP
         CgCjHgNva0ALbmFzuOm9jVOTXxzhnv1vZoJqDPPIosZFsSGpWr5F6tTKr1OaF6I1aNkf
         7KfurxT/4E23+HYCXOKs0I+Wn5IKv2PKnocW7bbHRxmsqv6zcZ8l7pahcks1gGyy2oGk
         cyuLBHsbbkBSYxT2rNNCfYxljRcVRhZewwlCix+vmGY+/AdumSW+tyiLzbvlc0SOU10e
         rdAg==
X-Gm-Message-State: AOAM530v78cmvTKiIevbjd1VhGqbbypJFw4MMQJE0C2ar26u86VuKRKH
        eTgC6Q03GfEn8NINoKHMbIbbIA==
X-Google-Smtp-Source: ABdhPJyKqfI5qKnih+7nbP6TbkIQesNEOH+MdKaLZsEubZNXQk/tyXddMMNizkeyBJ6DPe9ocgaoEQ==
X-Received: by 2002:a05:6a00:16d1:b029:157:7d81:432d with SMTP id l17-20020a056a0016d1b02901577d81432dmr3759531pfc.38.1602855198763;
        Fri, 16 Oct 2020 06:33:18 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k9sm2978122pfi.188.2020.10.16.06.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 06:33:18 -0700 (PDT)
Subject: Re: [PATCH 5/5] task_work: use TIF_NOTIFY_SIGNAL if available
To:     Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, Roman Gershman <romger@amazon.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-6-axboe@kernel.dk> <20201015154953.GM24156@redhat.com>
 <e17cd91e-97b2-1eae-964b-fc90f8f9ef31@kernel.dk>
 <87a6wmv93v.fsf@nanos.tec.linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c7da5280-f283-2c89-f6f2-be7d84c3675a@kernel.dk>
Date:   Fri, 16 Oct 2020 07:33:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87a6wmv93v.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/20 3:00 AM, Thomas Gleixner wrote:
> On Thu, Oct 15 2020 at 12:39, Jens Axboe wrote:
>> On 10/15/20 9:49 AM, Oleg Nesterov wrote:
>>> You can simply nack the patch which adds TIF_NOTIFY_SIGNAL to
>>> arch/xxx/include/asm/thread_info.h.
> 
> As if that is going to change anything...
> 
>> This seems to be the biggest area of contention right now. Just to
>> summarize, we have two options:
>>
>> 1) We leave the CONFIG_GENERIC_ENTRY requirement, which means that the
>>    rest of the cleanups otherwise enabled by this series will not be
>>    able to move forward until the very last arch is converted to the
>>    generic entry code.
>>
>> 2) We go back to NOT having the CONFIG_GENERIC_ENTRY requirement, and
>>    archs can easily opt-in to TIF_NOTIFY_SIGNAL independently of
>>    switching to the generic entry code.
>>
>> I understand Thomas's reasoning in wanting to push archs towards the
>> generic entry code, and I fully support that. However, it does seem like
>> the road paved by #1 is long and potentially neverending, which would
>> leave us with never being able to kill the various bits of code that we
>> otherwise would be able to.
>>
>> Thomas, I do agree with Oleg on this one, I think we can make quicker
>> progress on cleanups with option #2. This isn't really going to hinder
>> any arch conversion to the generic entry code, as arch patches would be
>> funeled through the arch trees anyway.
> 
> I completely understand the desire to remove the jobctl mess and it
> looks like a valuable cleanup on it's own.
> 
> But I fundamentaly disagree with the wording of #2:
> 
>     'and archs can easily opt-in ....'
> 
> Just doing it on an opt-in base is not any different from making it
> dependent on CONFIG_GENERIC_ENTRY. It's just painted differently and
> makes it easy for you to bring the performance improvement to the less
> than a handful architectures which actually care about io_uring.

It's a lot easier for me to add support for archs for TIF_NOTIFY_SIGNAL,
than it is to convert them to CONFIG_GENERIC ENTRY. And in fact I
already _did_ convert all archs, in a separate series. Is it perfect
yet? No. arm needs a bit of love, powerpc should be cleaned up once the
5.10 merge happens for that arch (dropping a bit), and s390 I need
someone to verify. But apart from that, it is already done.

> So if you change #2 to:
> 
>    Drop the CONFIG_GENERIC_ENTRY dependency, make _all_ architectures
>    use TIF_NOTIFY_SIGNAL and clean up the jobctl and whatever related
>    mess.
> 
> and actually act apon it, then I'm fine with that approach.

Already did that too!

https://git.kernel.dk/cgit/linux-block/log/?h=tif-task_work.arch

It's sitting on top of this series. So the work is already done.

> Anything else is just proliferating the existing mess and yet another
> promise of great improvements which never materialize.
> 
> Just to prove my point:
> 
> e91b48162332 ("task_work: teach task_work_add() to do signal_wake_up()")
> 
> added TWA_SIGNAL in June with the following in the changelog:
> 
>     TODO: once this patch is merged we need to change all current users
>     of task_work_add(notify = true) to use TWA_RESUME.

Totally agree the ball was dropped on this one. I did actually write a
patch, just never had time to get it out.
 
> This features first and let others deal with the mess we create mindset
> has to stop. I'm dead tired of it.

I totally agree, and we're on the same page. I think you'll find that in
the past I always carry through, the task_work notification was somewhat
of a rush due to a hang related to it. For this particular case, the
cleanups and arch additions are pretty much ready to go.

-- 
Jens Axboe

