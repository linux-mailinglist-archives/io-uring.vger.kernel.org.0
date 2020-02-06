Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B138154C71
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 20:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgBFTvH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 14:51:07 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:34078 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgBFTvG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 14:51:06 -0500
Received: by mail-il1-f195.google.com with SMTP id l4so6261182ilj.1
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2020 11:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H6h85xrCfg+hq6R4St/F+34IPqni6BUTXg8rGkhGCqQ=;
        b=Q9k3KnQN2MHUn79kvbULiVAbY+4cFTtPF/F3gh6x7uSxqpUcFm0p6E/yCHrIFXvg46
         4A5NeT5FMnwxqoumUYbKuOEah8w5ge5yuuGRGq8esjq3d9SrDBtZQA1hKzf4uK39fCed
         lM7QKQPAfUVJ91eDFB8ZTpdkKbhLaeam4VPoFrX3VJNyBZwYByq/4PHXfwRatGXtYJfj
         a3Xhxq8/YTPDw8j+aVer4RAs0Wbd0wV5Xfq+9KLMh2vrmEhlrjixv3qQ+3Pf1XOP2Bvm
         hTuLKoxmS72hl1NpKX4FRcQ78ds7PLvHrgo2IY7pcbt7A9k6B8XJUxLpuLQ+KPRhLFMk
         RO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H6h85xrCfg+hq6R4St/F+34IPqni6BUTXg8rGkhGCqQ=;
        b=lCYnDz7hq+h5nUpzJvdsqXma+OCq5a4rbgo/6Uc3gZ1nX/i000+lODaOWRkMa9mUTi
         6S4VLs03VulZtZYwEwxIg0zMXvfBc05TuXMkiJKo2DFpoR9hCANujePDp2BhPHMyJ8f0
         +NTW0S5ysvGMFifLqJZokyEfYEqOFWIyRauWrmSsEsXK0ztqFIGdrnD/Za7I/QS1GFD7
         0j8yK36f3h2ir6OvFncd+0NYnDm3+EjscVAUnljt1P03pcU3dt2Dgsid23sLC0YI31Ns
         FrFTbhhY5Fn3Rb1H+FE92TgN8j5a+ZzetxaGdxlBz2VSRjmMcAncfLiuQVRLo3IaTxl7
         RdRw==
X-Gm-Message-State: APjAAAUtloWXQq5AZZdLzrScXvZskOMbt4mQlsuDfV1bRWWV89KMPCus
        sccYQR1mYKgk8C79wUCd6LajeayQJcg=
X-Google-Smtp-Source: APXvYqzL3VTwzW/g90Gs3le564MRCDr6MRsG8dlFLL63aArFjrAyVU5B8SYzd7pdsSbwVmildnyB9A==
X-Received: by 2002:a92:990b:: with SMTP id p11mr5554087ili.254.1581018664583;
        Thu, 06 Feb 2020 11:51:04 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t2sm267414ild.34.2020.02.06.11.51.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 11:51:04 -0800 (PST)
Subject: Re: [PATCH liburing v2 0/1] test: add epoll test case
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20200131142943.120459-1-sgarzare@redhat.com>
 <ebc2efdb-4e7f-0db9-ef04-c02aac0b08b1@kernel.dk>
 <CAGxU2F6qvW28=ULNUi-UHethus2bO6VXYX127HOcH_KPToZC-w@mail.gmail.com>
 <ec04cb8f-01e8-6289-2fd4-6dec8a8e2c02@kernel.dk>
Message-ID: <548cb67b-bb43-c22a-f3c6-e707e2c07c13@kernel.dk>
Date:   Thu, 6 Feb 2020 12:51:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <ec04cb8f-01e8-6289-2fd4-6dec8a8e2c02@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/6/20 12:15 PM, Jens Axboe wrote:
> On 2/6/20 10:33 AM, Stefano Garzarella wrote:
>>
>>
>> On Fri, Jan 31, 2020 at 4:39 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 1/31/20 7:29 AM, Stefano Garzarella wrote:
>>>> Hi Jens,
>>>> this is a v2 of the epoll test.
>>>>
>>>> v1 -> v2:
>>>>     - if IORING_FEAT_NODROP is not available, avoid to overflow the CQ
>>>>     - add 2 new tests to test epoll with IORING_FEAT_NODROP
>>>>     - cleanups
>>>>
>>>> There are 4 sub-tests:
>>>>     1. test_epoll
>>>>     2. test_epoll_sqpoll
>>>>     3. test_epoll_nodrop
>>>>     4. test_epoll_sqpoll_nodrop
>>>>
>>>> In the first 2 tests, I try to avoid to queue more requests than we have room
>>>> for in the CQ ring. These work fine, I have no faults.
>>>
>>> Thanks!
>>>
>>>> In the tests 3 and 4, if IORING_FEAT_NODROP is supported, I try to submit as
>>>> much as I can until I get a -EBUSY, but they often fail in this way:
>>>> the submitter manages to submit everything, the receiver receives all the
>>>> submitted bytes, but the cleaner loses completion events (I also tried to put a
>>>> timeout to epoll_wait() in the cleaner to be sure that it is not related to the
>>>> patch that I send some weeks ago, but the situation doesn't change, it's like
>>>> there is still overflow in the CQ).
>>>>
>>>> Next week I'll try to investigate better which is the problem.
>>>
>>> Does it change if you have an io_uring_enter() with GETEVENTS set? I wonder if
>>> you just pruned the CQ ring but didn't flush the internal side.
>>
>> If I do io_uring_enter() with GETEVENTS set and wait_nr = 0 it solves
>> the issue, I think because we call io_cqring_events() that flushes the
>> overflow list.
>>
>> At this point, should we call io_cqring_events() (that flushes the
>> overflow list) in io_uring_poll()?
>> I mean something like this:
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 77f22c3da30f..2769451af89a 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -6301,7 +6301,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
>>         if (READ_ONCE(ctx->rings->sq.tail) - ctx->cached_sq_head !=
>>             ctx->rings->sq_ring_entries)
>>                 mask |= EPOLLOUT | EPOLLWRNORM;
>> -       if (READ_ONCE(ctx->rings->cq.head) != ctx->cached_cq_tail)
>> +       if (!io_cqring_events(ctx, false))
>>                 mask |= EPOLLIN | EPOLLRDNORM;
>>
>>         return mask;
> 
> That's not a bad idea, would just have to verify that it is indeed safe
> to always call the flushing variant from there.

Double checked, and it should be fine. We may be invoked with
ctx->uring_lock held, but that's fine.

-- 
Jens Axboe

