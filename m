Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40A47D5F18
	for <lists+io-uring@lfdr.de>; Wed, 25 Oct 2023 02:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjJYAeN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Oct 2023 20:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjJYAeM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Oct 2023 20:34:12 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B17410CC
        for <io-uring@vger.kernel.org>; Tue, 24 Oct 2023 17:34:09 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6bcbfecf314so1085089b3a.1
        for <io-uring@vger.kernel.org>; Tue, 24 Oct 2023 17:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698194049; x=1698798849; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a8AeR5cX4ECeRAMqM9bk6xqQoLMHM5hoApBMejuGgnI=;
        b=KYtqphirFdawzCn/Dq5xn85ab1MyhJjXJ7/NiVHXNAadcY5yrdEjowK7XWoWJSIjUP
         D0V4lqxwGcgtd9SBz1yxaZVZSSa09GlKK6Ip9t/21DxCGnDCF3MZyFVx6ezJ5tn30Ig3
         TjAtJsKwY8UiXPTcHmBG9+r/w1SCzDe2i/7NBN5zr5/R8ollqxHoxv81vhkz42xiH06l
         wPYkUBzyaTDopl8aY0IlXkjprWy1Wj/Z/TUPGKugTDoDhR3FlUTXFDYiwroN2e5veA03
         +Tf+eIF9G/XaqvNYkq4USxzRTbbieB8AMUwSO0wC7ysJSDkskg9qSa2CQh7htFPm/hVS
         Jt5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698194049; x=1698798849;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a8AeR5cX4ECeRAMqM9bk6xqQoLMHM5hoApBMejuGgnI=;
        b=F4NNCfpOpER0elR5F22BEK6vo2YTVnSFWfS75su8X+AEONzIpuZl3RKlls1smIJxNK
         lnb6tdpC929/qOW2a+NqJfoaHaikUzN3b/xidWyNkMGJiEp0Mwpy9DNOrowgHBA3HUdo
         mWqjQL2KDkIiS3mj4he0NEfqAtQXNQUZaBCJMFDk5osq0i7oBDGm0HLuTT3/SpcuywZL
         vrS8cYMrhxFU7LCIFdrWuF8SMBUuUaLRTssKJsayVhviobU3ozbSaCaqjw5l3eKU1owm
         83KBItT4Vm26miPC0p5Ml4aUQuX4FVj43xjIDObvIM9LPevehNq+RVGJJ7YWKCAJHvI7
         hq5Q==
X-Gm-Message-State: AOJu0YyC0Ne+UuCcVEXXgcxYbxe9wEDkrIGZaL3XjDDZvscZNyiVvjKZ
        VcPYEAZ/FsttUa3uIzy3YDDjAQ==
X-Google-Smtp-Source: AGHT+IGpxAnEvrI6l7SDpL7iESVoor6ZCUMq1w/wBpUXkzIX2xbD4rgxQX9ZLlZIuL82wxU6qAWDSg==
X-Received: by 2002:a05:6a20:c188:b0:15a:2c0b:6c81 with SMTP id bg8-20020a056a20c18800b0015a2c0b6c81mr17059900pzb.3.1698194048863;
        Tue, 24 Oct 2023 17:34:08 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id a6-20020aa79706000000b006b22218cb92sm8124187pfg.43.2023.10.24.17.34.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 17:34:07 -0700 (PDT)
Message-ID: <4ace2109-3d05-4ca0-b582-f7b8db88a0ca@kernel.dk>
Date:   Tue, 24 Oct 2023 18:34:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: task hung in ext4_fallocate #2
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     Andres Freund <andres@anarazel.de>, Theodore Ts'o <tytso@mit.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        linux-ext4@vger.kernel.org,
        =?UTF-8?Q?Ricardo_Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        gustavo.padovan@collabora.com, zsm@google.com, garrick@google.com,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        io-uring@vger.kernel.org
References: <20231017033725.r6pfo5a4ayqisct7@awork3.anarazel.de>
 <20231018004335.GA593012@mit.edu>
 <20231018025009.ulkykpefwdgpfvzf@awork3.anarazel.de>
 <ZTcZ9+n+jX6UDrgd@dread.disaster.area>
 <74921cba-6237-4303-bb4c-baa22aaf497b@kernel.dk>
 <ab4f311b-9700-4d3d-8f2e-09ccbcfb3df5@kernel.dk>
 <ZThcATP9zOoxb4Ec@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZThcATP9zOoxb4Ec@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/24/23 6:06 PM, Dave Chinner wrote:
> On Tue, Oct 24, 2023 at 12:35:26PM -0600, Jens Axboe wrote:
>> On 10/24/23 8:30 AM, Jens Axboe wrote:
>>> I don't think this is related to the io-wq workers doing non-blocking
>>> IO.
> 
> The io-wq worker that has deadlocked _must_ be doing blocking IO. If
> it was doing non-blocking IO (i.e. IOCB_NOWAIT) then it would have
> done a trylock and returned -EAGAIN to the worker for it to try
> again later. I'm not sure that would avoid the issue, however - it
> seems to me like it might just turn it into a livelock rather than a
> deadlock....

Sorry typo, yes they are doing blocking IO, that's all they ever do. My
point is that it's not related to the issue.

>>> The callback is eventually executed by the task that originally
>>> submitted the IO, which is the owner and not the async workers. But...
>>> If that original task is blocked in eg fallocate, then I can see how
>>> that would potentially be an issue.
>>>
>>> I'll take a closer look.
>>
>> I think the best way to fix this is likely to have inode_dio_wait() be
>> interruptible, and return -ERESTARTSYS if it should be restarted. Now
>> the below is obviously not a full patch, but I suspect it'll make ext4
>> and xfs tick, because they should both be affected.
> 
> How does that solve the problem? Nothing will issue a signal to the
> process that is waiting in inode_dio_wait() except userspace, so I
> can't see how this does anything to solve the problem at hand...

Except task_work, which when it completes, will increment the i_dio
count again. This is the whole point of the half assed patch I sent out.

> I'm also very leary of adding new error handling complexity to paths
> like truncate, extent cloning, fallocate, etc which expect to block
> on locks until they can perform the operation safely.

I actually looked at all of them, ext4 and xfs specifically. It really
doesn't seem to bad.

> On further thinking, this could be a self deadlock with
> just async direct IO submission - submit an async DIO with
> IOCB_CALLER_COMP, then run an unaligned async DIO that attempts to
> drain in-flight DIO before continuing. Then the thread waits in
> inode_dio_wait() because it can't run the completion that will drop
> the i_dio_count to zero.

No, because those will be non-blocking. Any blocking IO will go via
io-wq, and that won't then hit the deadlock. If you're doing
inode_dio_wait() from the task itself for a non-blocking issue, then
that would surely be an issue. But we should not be doing that, and we
are checking for it.

> Hence it appears to me that we've missed some critical constraints
> around nesting IO submission and completion when using
> IOCB_CALLER_COMP. Further, it really isn't clear to me how deep the
> scope of this problem is yet, let alone what the solution might be.

I think you're missing exactly what the deadlock is.

> With all this in mind, and how late this is in the 6.6 cycle, can we
> just revert the IOCB_CALLER_COMP changes for now?

Yeah I'm going to do a revert of the io_uring side, which effectively
disables it. Then a revised series can be done, and when done, we could
bring it back.

-- 
Jens Axboe

