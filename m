Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C85EC16EFF1
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 21:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731565AbgBYUU2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 15:20:28 -0500
Received: from mail-il1-f173.google.com ([209.85.166.173]:43669 "EHLO
        mail-il1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730794AbgBYUU1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 15:20:27 -0500
Received: by mail-il1-f173.google.com with SMTP id p78so307086ilb.10
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 12:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CjB2KWEG3cyO9PSRLGbjAvj/AeNUTAvG2N+kx0dlOBo=;
        b=xtzUDkiOhiH0vBh2MudmAhR2cYuHQzIfkjGIghuT9etJ6EF8ovAZpIO3Io84fzwLqX
         +Mo3u2hCXPSIy/IAaZyp/48hGA4tIJxE/QCIDlyl1VQWeU+n88MqhNuYIs5pqEJPPCL9
         E5URmwragQn5QFtZBvDjqf4D1nuyksCdcUjcgRvAua9W57lV/GHhWJc7EA8mifsPG6QL
         +BfBjjW6XS3k9U1wwSC94d028SZ1vGR8ufR1XLElqGoIa3OfmIR6VuV9aBGUFkWhiYFC
         ry78FooisIQcxtvofvdHjQY6CJuUiOZtNuI0T+qDkkG1nyoTvM2rPGAxn5v95YZO3OGH
         Ycow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CjB2KWEG3cyO9PSRLGbjAvj/AeNUTAvG2N+kx0dlOBo=;
        b=ohHRbj01mbJgUhgz7NE6FpwHztbRyQxRiLXBe4FUJJoThv91gD/bTBfnSuUUYdantD
         MnJafyhgB4QSqJgB+d6QfTDA9+x3aK2e3D9GCqZ3/Mr4gfHZLpS1qkIa+7wHaQuLSg66
         Nf8llIYKTJuAa/owW2DdNOvWejB+idWHM/tzXJk//JR6XliCQMrQJj5mZAyy+dtQj/pG
         Rzkx6Qz9CS6A1Pi/z7nGP1bLSu4Hhg1Vm53wV71HuRQtvbz2dfPfSa1oStEffHu00bXP
         mqhn3FWfn1IGGNwee25YV8M/U80rUOvZuzqTe8p1VfZPgRDZeygjY/Z2gGaQEnj0OLpa
         mBYA==
X-Gm-Message-State: APjAAAU2ZEQAx3W04DFJlMEkjweIBDCz+31aE9bZypKWqA4+SEpfIiVj
        UhhZNauVcfkI6R8pIs+l3UJ0fN5seU4=
X-Google-Smtp-Source: APXvYqwSoGMKS5njOzOxSzNjLvuezg9dhbnsgI9Mr5YrZc+qGiPoBMlF9W2ABq6tmg7anwzDEVmwyw==
X-Received: by 2002:a92:d185:: with SMTP id z5mr455361ilz.132.1582662025415;
        Tue, 25 Feb 2020 12:20:25 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y11sm5874641ilm.22.2020.02.25.12.20.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 12:20:24 -0800 (PST)
Subject: Re: [RFC] single cqe per link
To:     Pavel Begunkov <asml.silence@gmail.com>,
        =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <1a9a6022-7175-8ed3-4668-e4de3a2b9ff7@gmail.com>
 <9E393343-7DB8-49D1-A7A2-611F88124C11@eoitek.com>
 <9830e660-0ffa-ed48-37da-493485a5ea17@kernel.dk>
 <56a18348-2949-e9da-b036-600b5bb4dad2@kernel.dk>
 <1e733dd7-acd4-dde6-b3c5-c0ee0fbeda2a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <be37a342-9768-5d1e-8d80-6d3d28f236e8@kernel.dk>
Date:   Tue, 25 Feb 2020 13:20:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1e733dd7-acd4-dde6-b3c5-c0ee0fbeda2a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/25/20 3:12 AM, Pavel Begunkov wrote:
> On 2/25/2020 6:13 AM, Jens Axboe wrote:
>>>> I still think flags tagged on sqes could be a better choice, which
>>>> gives users an ability to deside if they want to ignore the cqes, not
>>>> only for links, but also for normal sqes.
>>>>
>>>> In addition, boxed cqes couldn’t resolve the issue of
>>>> IORING_IO_TIMEOUT.
>>>
>>> I would tend to agree, and it'd be trivial to just set the flag on
>>> whatever SQEs in the chain you don't care about. Or even an individual
>>> SQE, though that's probably a bit more of a reach in terms of use case.
>>> Maybe nop with drain + ignore?
> 
> Flexible, but not performant. The existence of drain is already makes
> io_uring to do a lot of extra stuff, and even worse when it's actually used.

Yeah I agree, that's assuming we can make the drain more efficient. Just
hand waving on possible use cases :-)

>>> In any case it's definitely more flexible.
> 
> That's a different thing. Knowing how requests behave (e.g. if
> nbytes!=res, then fail link), one would want to get cqe for the last
> executed sqe, whether it's an error or a success for the last one.
> 
> It makes a link to be handled as a single entity. I don't see a way to
> emulate similar behaviour with the unconditional masking. Probably, we
> will need them both.

But you can easily do that with IOSQE_NO_CQE, in fact that's what I did
to test this. The chain will have IOSQE_NO_CQE | IOSQE_IO_LINK set on
all but the last request.

>> In the interest of taking this to the extreme, I tried a nop benchmark
>> on my laptop (qemu/kvm). Granted, this setup is particularly sensitive
>> to spinlocks, they are a lot more expensive there than on a real host.
>>
>> Anyway, regular nops run at about 9.5M/sec with a single thread.
>> Flagging all SQEs with IOSQE_NO_CQE nets me about 14M/sec. So a handy
>> improvement. Looking at the top of profiles:
>>
>> cqe-per-sqe:
>>
>> +   28.45%  io_uring  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
>> +   14.38%  io_uring  [kernel.kallsyms]  [k] io_submit_sqes
>> +    9.38%  io_uring  [kernel.kallsyms]  [k] io_put_req
>> +    7.25%  io_uring  libc-2.31.so       [.] syscall
>> +    6.12%  io_uring  [kernel.kallsyms]  [k] kmem_cache_free
>>
>> no-cqes:
>>
>> +   19.72%  io_uring  [kernel.kallsyms]  [k] io_put_req
>> +   11.93%  io_uring  [kernel.kallsyms]  [k] io_submit_sqes
>> +   10.14%  io_uring  [kernel.kallsyms]  [k] kmem_cache_free
>> +    9.55%  io_uring  libc-2.31.so       [.] syscall
>> +    7.48%  io_uring  [kernel.kallsyms]  [k] __io_queue_sqe
>>
>> I'll try the real disk IO tomorrow, using polled IO.
> 
> Great, would love to see

My box with the optane2 is out of commission, apparently, cannot get it
going today. So I had to make do with my laptop, which does about ~600K
random read IOPS. I don't see any difference there, using polled IO,
using 4 link deep chains (so 1/4th the CQEs). Both run at around
611-613K IOPS.

-- 
Jens Axboe

