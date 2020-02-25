Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C67C16BE5B
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 11:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgBYKMX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 05:12:23 -0500
Received: from mail-lf1-f48.google.com ([209.85.167.48]:39244 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729417AbgBYKMX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 05:12:23 -0500
Received: by mail-lf1-f48.google.com with SMTP id n30so8521820lfh.6
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 02:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X6MVgfs+WtEWgAJ8YVhVB0Y0njLkPNUy0N0MMV6ZAdg=;
        b=lCQuwO1ik1iQ+CPnl5bViFu7rQxxMFCGdqg3nan6CEBfGFXGkNdScxX1j8caU0E0kC
         um8AY5WEAbPZcl2DvzXR9p9UTccs3pElsKhqNKVrrlj1RKcY/+gkfSIhet/uXreL4ZCQ
         d271tU090uBFw2YMeozZty4gVDlm4y4ApwZiwKPdI1dCsFRZN4gKjeKHWFiWsAuETBgS
         nwQyDmqPWHj+cJ0x/5pRCyDbCiJAkfL1q13ApaVV3+UueLvmsVQ1aRhcGw2ej5t197bb
         xNkiTYudmV9gF+61xLvVpMD0GhxsopHRdDL0VwwRUxn/s4F5wlBJENDj7i7yKxGiKmIb
         OQng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X6MVgfs+WtEWgAJ8YVhVB0Y0njLkPNUy0N0MMV6ZAdg=;
        b=krB/ihaefwN9dcsEzYiajoPers94mz+V15kgPllyrtOJcH9NhD7WzhJS2xSX+g64vG
         qr7jhf9UPPbHueGN5KuHEyCJI5/Pt07/qVQ3YBfnJ0DXcZScWp77TlBxS1MHKUW5zWAN
         d6EsRBGtkcXXM/YnlbR7kbQVLVMmMnt7jv9uP+8Kx4zfSTDGqVewcB0HwU7ZfT2Irbh3
         6IFNUzNLTCSY+CjGoolWMCH5PwvtcMmevJc28f66JSnqnmzeb+77fdv0Eq7P+gub91rJ
         yshuC6kyaw42jsFQNW81IoaVV2QVUkTzyQxpoJt2MYTGv7hwuSz7axkF7yVAQTJO5W/5
         uiGg==
X-Gm-Message-State: APjAAAVserHgOqo2pEIov/pdj7ZLafFNdlHfACqExOkttju8U0Hz4Qd8
        49tmXYsyVdrF+WGcXgvnv17LrUmNzbU=
X-Google-Smtp-Source: APXvYqzd40vxttnJ7tusUvcUvE2AXu4OApvaZoOYAajaY+qSQEigFg4je0dQY4z6x/FcGtioLJLD+A==
X-Received: by 2002:ac2:44a5:: with SMTP id c5mr9117996lfm.4.1582625541115;
        Tue, 25 Feb 2020 02:12:21 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id o20sm5676473lfg.45.2020.02.25.02.12.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 02:12:20 -0800 (PST)
Subject: Re: [RFC] single cqe per link
To:     Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <1a9a6022-7175-8ed3-4668-e4de3a2b9ff7@gmail.com>
 <9E393343-7DB8-49D1-A7A2-611F88124C11@eoitek.com>
 <9830e660-0ffa-ed48-37da-493485a5ea17@kernel.dk>
 <56a18348-2949-e9da-b036-600b5bb4dad2@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <1e733dd7-acd4-dde6-b3c5-c0ee0fbeda2a@gmail.com>
Date:   Tue, 25 Feb 2020 13:12:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <56a18348-2949-e9da-b036-600b5bb4dad2@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/25/2020 6:13 AM, Jens Axboe wrote:
>>> I still think flags tagged on sqes could be a better choice, which
>>> gives users an ability to deside if they want to ignore the cqes, not
>>> only for links, but also for normal sqes.
>>>
>>> In addition, boxed cqes couldn’t resolve the issue of
>>> IORING_IO_TIMEOUT.
>>
>> I would tend to agree, and it'd be trivial to just set the flag on
>> whatever SQEs in the chain you don't care about. Or even an individual
>> SQE, though that's probably a bit more of a reach in terms of use case.
>> Maybe nop with drain + ignore?

Flexible, but not performant. The existence of drain is already makes
io_uring to do a lot of extra stuff, and even worse when it's actually used.

>>
>> In any case it's definitely more flexible.

That's a different thing. Knowing how requests behave (e.g. if
nbytes!=res, then fail link), one would want to get cqe for the last
executed sqe, whether it's an error or a success for the last one.

It makes a link to be handled as a single entity. I don't see a way to
emulate similar behaviour with the unconditional masking. Probably, we
will need them both.

> In the interest of taking this to the extreme, I tried a nop benchmark
> on my laptop (qemu/kvm). Granted, this setup is particularly sensitive
> to spinlocks, they are a lot more expensive there than on a real host.
> 
> Anyway, regular nops run at about 9.5M/sec with a single thread.
> Flagging all SQEs with IOSQE_NO_CQE nets me about 14M/sec. So a handy
> improvement. Looking at the top of profiles:
> 
> cqe-per-sqe:
> 
> +   28.45%  io_uring  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
> +   14.38%  io_uring  [kernel.kallsyms]  [k] io_submit_sqes
> +    9.38%  io_uring  [kernel.kallsyms]  [k] io_put_req
> +    7.25%  io_uring  libc-2.31.so       [.] syscall
> +    6.12%  io_uring  [kernel.kallsyms]  [k] kmem_cache_free
> 
> no-cqes:
> 
> +   19.72%  io_uring  [kernel.kallsyms]  [k] io_put_req
> +   11.93%  io_uring  [kernel.kallsyms]  [k] io_submit_sqes
> +   10.14%  io_uring  [kernel.kallsyms]  [k] kmem_cache_free
> +    9.55%  io_uring  libc-2.31.so       [.] syscall
> +    7.48%  io_uring  [kernel.kallsyms]  [k] __io_queue_sqe
> 
> I'll try the real disk IO tomorrow, using polled IO.

Great, would love to see


-- 
Pavel Begunkov
