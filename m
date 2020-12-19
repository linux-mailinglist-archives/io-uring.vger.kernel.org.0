Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA742DF0B6
	for <lists+io-uring@lfdr.de>; Sat, 19 Dec 2020 18:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgLSRiw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 12:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbgLSRiv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 12:38:51 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6CDC0613CF
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 09:38:10 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id t6so3172599plq.1
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 09:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iblu9KqseMLVYUHve7G5EeGEoolPxu16GoY7bneEg+8=;
        b=oiDqo9t4P8GFfYPx4IYCaxdkYnBD20zJKwplxQs8UcsN2MJMtEfI6w60/oQcwxs2i5
         7A5atuT2h0N7bFZtJ1QRPeiTBBkEPpkZijYTsvy2ZBeC/CxkaEoWZ1tyBZx3RWGS7/Va
         XxtFvz/fIe5Ft8cYeLuOh3iWZAXmg1uylS6R+11qEnDSSOTIp+/yGqirVTcVs2VakdGn
         b1FMZyYnuiZ6KPgdHOGMI09jYCqBtGtZeFwDXpr//HEMbvcalXG2QhqK5kSYkMhSO1Bj
         wOg01cLs6dMJELYd61RmDIdjFPi0uQjrWU9TC/XL/6iOIeXF//a+VWFa997VS3XYyq9i
         Ou1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iblu9KqseMLVYUHve7G5EeGEoolPxu16GoY7bneEg+8=;
        b=r8EFdPFNpAZNxEL/FCejfqZ7VnGtBC5soRUk3HssKHFKCTzMomK9RY9RFkl+2yNzvG
         FxVm7K3H9LE8whm/c6QPOff5QjVqIhiw9uLzAWcQ7bU0MqoIDRGf+tZyueyLIvwZj+gc
         ZPaTEjmUnP1yEZGysIkfE+mYVLa4dGng7bBAoFCtkZNoBZCMRLwhandMk0YJeEhUI9jT
         JPYfX0JnJrS6wNR1ieijTrIoewHQmB8DppA4Aeo1nWLWcOSF77kMtPPAEAcD17UqOKPI
         TIGOi/ohi8e91adFDF/l4r8PMzqxAc0CwYVLsfgmmPrGUobyf6ztUkJJezUyhog/aEn/
         waug==
X-Gm-Message-State: AOAM53324aJEGP3XmZhavbk0Sqiyc0uFiSCOiPz2g99MgXU52V+Xz4xR
        F+9lKh+SgZCl1sEKADsg3EW+NjsN0QxgWg==
X-Google-Smtp-Source: ABdhPJxgI+N1wN/VmbkK2Enn5f7GOveXUHyLzt7p+7Y83j8APQutzD0IE2IVHK+MtyvZJwAJJQycnA==
X-Received: by 2002:a17:902:c244:b029:da:e63c:cede with SMTP id 4-20020a170902c244b02900dae63ccedemr9719715plg.0.1608399489695;
        Sat, 19 Dec 2020 09:38:09 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b189sm12064825pfb.194.2020.12.19.09.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 09:38:09 -0800 (PST)
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Norman Maurer <norman.maurer@googlemail.com>
Cc:     Josef <josef.grieb@gmail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
Date:   Sat, 19 Dec 2020 10:38:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/19/20 10:34 AM, Norman Maurer wrote:
>> Am 19.12.2020 um 18:11 schrieb Jens Axboe <axboe@kernel.dk>:
>>
>> ﻿On 12/19/20 9:29 AM, Jens Axboe wrote:
>>>> On 12/19/20 9:13 AM, Jens Axboe wrote:
>>>> On 12/18/20 7:49 PM, Josef wrote:
>>>>>> I'm happy to run _any_ reproducer, so please do let us know if you
>>>>>> manage to find something that I can run with netty. As long as it
>>>>>> includes instructions for exactly how to run it :-)
>>>>>
>>>>> cool :)  I just created a repo for that:
>>>>> https://github.com/1Jo1/netty-io_uring-kernel-debugging.git
>>>>>
>>>>> - install jdk 1.8
>>>>> - to run netty: ./mvnw compile exec:java
>>>>> -Dexec.mainClass="uring.netty.example.EchoUringServer"
>>>>> - to run the echo test: cargo run --release -- --address
>>>>> "127.0.0.1:2022" --number 200 --duration 20 --length 300
>>>>> (https://github.com/haraldh/rust_echo_bench.git)
>>>>> - process kill -9
>>>>>
>>>>> async flag is enabled and these operation are used: OP_READ,
>>>>> OP_WRITE, OP_POLL_ADD, OP_CLOSE, OP_ACCEPT
>>>>>
>>>>> (btw you can change the port in EchoUringServer.java)
>>>>
>>>> This is great! Not sure this is the same issue, but what I see here is
>>>> that we have leftover workers when the test is killed. This means the
>>>> rings aren't gone, and the memory isn't freed (and unaccounted), which
>>>> would ultimately lead to problems of course, similar to just an
>>>> accounting bug or race.
>>>>
>>>> The above _seems_ to be related to IOSQE_ASYNC. Trying to narrow it
>>>> down...
>>>
>>> Further narrowed down, it seems to be related to IOSQE_ASYNC on the
>>> read requests. I'm guessing there are cases where we end up not
>>> canceling them on ring close, hence the ring stays active, etc.
>>>
>>> If I just add a hack to clear IOSQE_ASYNC on IORING_OP_READ, then
>>> the test terminates fine on the kill -9.
>>
>> And even more so, it's IOSQE_ASYNC on the IORING_OP_READ on an eventfd
>> file descriptor. You probably don't want/mean to do that as it's
>> pollable, I guess it's done because you just set it on all reads for the
>> test?
>>
>> In any case, it should of course work. This is the leftover trace when
>> we should be exiting, but an io-wq worker is still trying to get data
>> from the eventfd:
>>
>> $ sudo cat /proc/2148/stack
>> [<0>] eventfd_read+0x160/0x260
>> [<0>] io_iter_do_read+0x1b/0x40
>> [<0>] io_read+0xa5/0x320
>> [<0>] io_issue_sqe+0x23c/0xe80
>> [<0>] io_wq_submit_work+0x6e/0x1a0
>> [<0>] io_worker_handle_work+0x13d/0x4e0
>> [<0>] io_wqe_worker+0x2aa/0x360
>> [<0>] kthread+0x130/0x160
>> [<0>] ret_from_fork+0x1f/0x30
>>
>> which will never finish at this point, it should have been canceled.
>
> Thanks a lot ... we can just workaround this than in netty .

That probably should be done in any case, since I don't think
IOSQE_ASYNC is useful on the eventfd read for you. But I'm trying to
narrow down _why_ it fails, it could be a general issue in how
cancelations are processed for sudden exit. Which would explain why it
only shows up for the kill -9 case.

Anyway, digging into it :-)

-- 
Jens Axboe

