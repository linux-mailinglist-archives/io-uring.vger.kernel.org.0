Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E28C28D4AD
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 21:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgJMTjj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 15:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgJMTji (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 15:39:38 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F64C0613D2
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 12:39:37 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x13so325534pgp.7
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 12:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u5ODaBfTT5W67Km3lOC3SSe3iDF1/gqpv3kYlN3EjVE=;
        b=Yq/ei9oJTUbdXy6mESFNA7vY+sswzM+fFDcH4ntCSECKbazwi7IynQsi5sodzn6TJA
         KfeHybgteb/MO7N2lDqFd1w099ZD6cyf2h7XqKxwN5/Ruz5Kekt7y6odT2N0MnNBtTHI
         d5Nu8E4iJ45J4y3DpHnjdbTmY/3BgEVgQZruhLITJK0MajGBd9r1ljCH/E6u8zkjUH4e
         SeQdiy0tD7SK2O0TZxopHlFRjjoQllVM9WmXPdRaw648fhfAA0Skw/TaK3Xn6dF55ial
         o9EQ8ERUMvorSjDSd/brjMPw1qPLbW2k8GVEm+proXkT7mtDmGrWnW30xv+IbHwyhgHe
         UFvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u5ODaBfTT5W67Km3lOC3SSe3iDF1/gqpv3kYlN3EjVE=;
        b=M0jOEq33wVFtDaWjQNsctxSPRO56alQo+Etx3ODeDDSjQ/K0Jy2f0HAbD1blwNNTPP
         dt1o/KlaWmLJZ1pcWJ5pFPDtHNdnetOXef12ky6sINxml2hzkxZAbv8WwzFZVbMKLm7Y
         3xWk7VB61+wPtWWTb0PCgjPr7zxaNHH9De0gWI2eAnW+ANvJaLtO5cSLGcK9vkKQpI/u
         UWxrRNLFj3lSvFpL4Mz0+965GMkgMp1Q70NoWOkHhBNVODmaemeKXt5vi/UaVKccHvM+
         hrDd0Q919FLNyN+6WFXRELmZdVZ61kIzt+tDQPGN5pgxY56+1BHCDcgNg4cxB9qRZXXv
         VOIA==
X-Gm-Message-State: AOAM533MiysWDqGeixLXx0TlIWb/1Ea6f75hQSSL4iGq66r7hWaG6184
        KsoGoq6MIupgVy5CeRAsNTyLDQ==
X-Google-Smtp-Source: ABdhPJzkeYACJjYJ1KHRzZ0STHtXaYfBhNHzzrdVRpF1+3kfjPhiiCJMBk6o/z9i/mgqx6tQZ3DhsQ==
X-Received: by 2002:a63:1b02:: with SMTP id b2mr973821pgb.164.1602617976821;
        Tue, 13 Oct 2020 12:39:36 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x1sm806247pjj.25.2020.10.13.12.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 12:39:36 -0700 (PDT)
Subject: Re: [PATCHSET RFC v3 0/6] Add support for TIF_NOTIFY_SIGNAL
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        live-patching@vger.kernel.org
References: <20201005150438.6628-1-axboe@kernel.dk>
 <20201008145610.GK9995@redhat.com>
 <alpine.LSU.2.21.2010090959260.23400@pobox.suse.cz>
 <e33ec671-3143-d720-176b-a8815996fd1c@kernel.dk>
 <9a01ab10-3140-3fa6-0fcf-07d3179973f2@kernel.dk>
 <alpine.LSU.2.21.2010121921420.10435@pobox.suse.cz>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3c3616f2-8801-1d42-6d7d-3dfbf977edb2@kernel.dk>
Date:   Tue, 13 Oct 2020 13:39:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.2010121921420.10435@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/12/20 11:27 AM, Miroslav Benes wrote:
> On Sat, 10 Oct 2020, Jens Axboe wrote:
> 
>> On 10/9/20 9:21 AM, Jens Axboe wrote:
>>> On 10/9/20 2:01 AM, Miroslav Benes wrote:
>>>> On Thu, 8 Oct 2020, Oleg Nesterov wrote:
>>>>
>>>>> On 10/05, Jens Axboe wrote:
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> The goal is this patch series is to decouple TWA_SIGNAL based task_work
>>>>>> from real signals and signal delivery.
>>>>>
>>>>> I think TIF_NOTIFY_SIGNAL can have more users. Say, we can move
>>>>> try_to_freeze() from get_signal() to tracehook_notify_signal(), kill
>>>>> fake_signal_wake_up(), and remove freezing() from recalc_sigpending().
>>>>>
>>>>> Probably the same for TIF_PATCH_PENDING, klp_send_signals() can use
>>>>> set_notify_signal() rather than signal_wake_up().
>>>>
>>>> Yes, that was my impression from the patch set too, when I accidentally 
>>>> noticed it.
>>>>
>>>> Jens, could you CC our live patching ML when you submit v4, please? It 
>>>> would be a nice cleanup.
>>>
>>> Definitely, though it'd be v5 at this point. But we really need to get
>>> all archs supporting TIF_NOTIFY_SIGNAL first. Once we have that, there's
>>> a whole slew of cleanups that'll fall out naturally:
>>>
>>> - Removal of JOBCTL_TASK_WORK
>>> - Removal of special path for TWA_SIGNAL in task_work
>>> - TIF_PATCH_PENDING can be converted and then removed
>>> - try_to_freeze() cleanup that Oleg mentioned
>>>
>>> And probably more I'm not thinking of right now :-)
>>
>> Here's the current series, I took a stab at converting all archs to
>> support TIF_NOTIFY_SIGNAL so we have a base to build on top of. Most
>> of them were straight forward, but I need someone to fixup powerpc,
>> verify arm and s390.
>>
>> But it's a decent start I think, and means that we can drop various
>> bits as is done at the end of the series. I could swap things around
>> a bit and avoid having the intermediate step, but I envision that
>> getting this in all archs will take a bit longer than just signing off
>> on the generic/x86 bits. So probably best to keep the series as it is
>> for now, and work on getting the arch bits verified/fixed/tested.
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=tif-task_work
> 
> Thanks, Jens.
> 
> Crude diff for live patching on top of the series is below. Tested only on 
> x86_64, but it passes the tests without an issue.

Nice, thanks!

I'm continuing to hone the series, what's really missing so far is arch
review. Most conversions are straight forward, some I need folks to
definitely take a look at (arm, s390). powerpc is also a bit hair right
now, but I'm told that 5.10 will kill a TIF flag there, so that'll make
it trivial once I rebase on that.

Did a few more cleanups on top, series is in the same spot. I'll repost
once the merge window settles down.

-- 
Jens Axboe

