Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F667A87AA
	for <lists+io-uring@lfdr.de>; Wed, 20 Sep 2023 16:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbjITOyx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Sep 2023 10:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236662AbjITOyr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Sep 2023 10:54:47 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A0BAF
        for <io-uring@vger.kernel.org>; Wed, 20 Sep 2023 07:54:37 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-7748ca56133so55805439f.0
        for <io-uring@vger.kernel.org>; Wed, 20 Sep 2023 07:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695221676; x=1695826476; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4gSTAFCjAjz9EbkEdAVZmbLCM6zbrZ3KXGMs93zaaHA=;
        b=pHw+0sFW2VgyotjYA3YMxX2dEzmfe4ZdqEFLEx5AAeysNIYBIEqvtnNEZ4h9arBcle
         2X3axa7iMeyb2QPmUbug4pBG1ZEVBloXD07W/2kwDtD5HAxYVuwCEsDneoVY1+9YcjNA
         FIe3NHyIp5Jt2gCf1S4q3WOU4zp2pX8+SzHaz2ReeaJssJVmK3hDfCLiQ60QJknRXciQ
         7KxVqpdx3SeyPA6Mi4G0tbJeD39ve0v1YxW0eGr2usewwxSOmojw3PV57zJlAghJxYhh
         TngsrNz9UsZWpGj75D+lO7XZz2y9wEYLpQ1Rw3gBwHON7W6tdKTga2hj684o4cuCFPH5
         Pxlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695221676; x=1695826476;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4gSTAFCjAjz9EbkEdAVZmbLCM6zbrZ3KXGMs93zaaHA=;
        b=A42TJaXPRS2XnTW5vuPlnaEZQfE5XSU9nB11K6eowynVj72cQPDj8umI8i5/Z83GDU
         kBXmQmiAixDsJD13oqNtKO+Car89nv4KcyakJfKkhHZWm2nWyBlYI5s3IZHezKg1P2Wt
         +P1Uti8XKTCtQwCon0MMk9dJr9bZPlif58nGujaxwm7ZShtraNnM5bHaD/6pjaw9xUUG
         n86K/W066WC41KotMlz0JQQGO1PnILi/QgQgIthdqLaBpORTF6MK+v6QQPouFB98iYt3
         l8Jjv8dZvQQTA8nr9V1NIGb+gDpeRTkmwGnIwENp8hXzbIiU6vQrRDPRtCk76CGUVkbt
         FO3Q==
X-Gm-Message-State: AOJu0YyqT10xq6vGIs7yF2oekIGWykTopeSfJLhsEsxjlxUVdCpTxhc2
        JcdGX5Wx9aaasHjhYIrGL9lRPw==
X-Google-Smtp-Source: AGHT+IGXmrDRzeD9focLY39nrOY1tY3KU5q6K/zPWh+OttDDNs9l75IOAgr+eNaPE0pqrFWNGFsT7Q==
X-Received: by 2002:a05:6602:4996:b0:79a:c487:2711 with SMTP id eg22-20020a056602499600b0079ac4872711mr3550341iob.0.1695221676571;
        Wed, 20 Sep 2023 07:54:36 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g8-20020a02c548000000b004290f6c15bfsm4219015jaj.145.2023.09.20.07.54.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 07:54:35 -0700 (PDT)
Message-ID: <81e0ef16-c780-478b-aeb0-5564aa010b13@kernel.dk>
Date:   Wed, 20 Sep 2023 08:54:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v4 0/5] Add io_uring support for waitid
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Christian Brauner <brauner@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, asml.silence@gmail.com
References: <20230909151124.1229695-1-axboe@kernel.dk>
 <26ddc629-e685-49b9-9786-73c0f89854d8@kernel.dk>
 <20230919-beinen-fernab-dbc587acb08d@brauner>
 <c20d61f4-0e4f-49a8-804f-d827ff705dcf@kernel.dk>
In-Reply-To: <c20d61f4-0e4f-49a8-804f-d827ff705dcf@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/19/23 8:57 AM, Jens Axboe wrote:
> On 9/19/23 8:45 AM, Christian Brauner wrote:
>> On Tue, Sep 12, 2023 at 11:06:39AM -0600, Jens Axboe wrote:
>>> On 9/9/23 9:11 AM, Jens Axboe wrote:
>>>> Hi,
>>>>
>>>> This adds support for IORING_OP_WAITID, which is an async variant of
>>>> the waitid(2) syscall. Rather than have a parent need to block waiting
>>>> on a child task state change, it can now simply get an async notication
>>>> when the requested state change has occured.
>>>>
>>>> Patches 1..4 are purely prep patches, and should not have functional
>>>> changes. They split out parts of do_wait() into __do_wait(), so that
>>>> the prepare-to-wait and sleep parts are contained within do_wait().
>>>>
>>>> Patch 5 adds io_uring support.
>>>>
>>>> I wrote a few basic tests for this, which can be found in the
>>>> 'waitid' branch of liburing:
>>>>
>>>> https://git.kernel.dk/cgit/liburing/log/?h=waitid
>>>>
>>>> Also spun a custom kernel for someone to test it, and no issues reported
>>>> so far.
>>>
>>> Forget to mention that I also ran all the ltp testcases for any wait*
>>> syscall test, and everything still passes just fine.
>>
>> I think the struct that this ends up exposing to io_uring is pretty ugly
>> and it would warrant a larger cleanup. I wouldn't be surprised if you
>> get some people complain about this.
>>
>> Other than that I don't have any complaints about the series.
> 
> io_uring only really needs child_wait and wo_pid on the wait_opts side,
> for waitid_info it needs all of it. I'm assuming your worry is about the
> former rather than the latter.
> 
> I think we could only make this smaller if we had a separate entry point
> for io_uring, which would then make the code reuse a lot smaller. Right
> now we just have __do_wait() abstracted out, and if we added a third
> struct that has child_wait/wo_pid and exposed just that, we could not
> share this infrastructure.
> 
> So as far as I can tell, there's no way to make the sharing less than it
> is, at least not without adding cost of more code and less reuse.
> 
> Shrug?

Took a closer look, and I don't think it's really possible to split much
out of wait_opts. You may only need child_wait/wo_pid for setup, but on
the wakeup side you type and flags as well. We could probably add that
third struct and move wo_rusage and notask_error out, but seems very
pointless at that point just to avoid those two. And if we do wire up
rusage at some point, then we're left with just the one.

-- 
Jens Axboe

