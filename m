Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF890223D9F
	for <lists+io-uring@lfdr.de>; Fri, 17 Jul 2020 16:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgGQOF1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jul 2020 10:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgGQOF0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jul 2020 10:05:26 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A57C0619D2
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 07:05:26 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s189so6702782pgc.13
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 07:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HOmnp9kcYdnOayC8Z9yTyfDeqDY6sv9n+Ilu/0sRG6o=;
        b=ridHEwiRp/76SJ9N4qcNSSrTb6LwTny6lcgA2evLj9bIQtjYNvR8NNO/OYQAKkgzjR
         S03464PLoC3ggM65ADHR94Z7B4bveESVZmgug3C/ByLrF61ZQ3/sqYH6/KLRftn8Bk9J
         bB5kurWIfYBJJWh8IzUROKCWGULQ7IAj634zqGRhKW+yz++WsfdQRsTCxQjnpjyDDDX7
         TOhzNcNMuXoRqCcz3lXLDbCphZRbM7Qph/1mZwV7+W8WpYo+KB14si9cNzKT0PJBeCC0
         Dbh7trCNd7Ceu8p13SiRPxi+/27oqEf4gMfLYgERD9d95PRIpAFiSlk4p1k6hMm58W62
         A5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HOmnp9kcYdnOayC8Z9yTyfDeqDY6sv9n+Ilu/0sRG6o=;
        b=bZBGoErBloHg+4+UNfuM/FHZnShcRTcUFfbgp8IIHdDVuYAtlRsYBZyDm1EJAhbS14
         dqxf8IP2hrlqWNI6OUSYQR9EBYAEiOGIyaQZlsLtF4hoWIYNQUohh4McQlH6QuBN4k+S
         2C/bW4WOVRZuO+8i9Z37FKaTUtPpGa/8FXQYgmzdP7ZjL2PRwPBWh92ti6lOuOWul8ua
         XSMK088eRFDi/IiLWdduIXGkCFoD0qxlNW4fQ+tsWM4zicKK18SDmbzLQz9SWRUZuG1m
         PXPALWUnn3pClitVYmRlTInhyeGuI36aJ+x80U197LZum0/i21z5hhR4UyqUoKSA8DGq
         +YdA==
X-Gm-Message-State: AOAM531AR2ARGK4BAOhSDJubXuez5MsTwzDwfFsVwqkPxsgTtbgARWRn
        lIadJKyZtZQKKrf45aXgCwQO5wVqMPmM5Q==
X-Google-Smtp-Source: ABdhPJziC/CAufD41d/z5VNqolMpp1amKK75CsTb7dlEYuifRFu7uAS6yQxrYc466Snqg8ya9VXd+g==
X-Received: by 2002:a65:63d4:: with SMTP id n20mr9133964pgv.213.1594994725104;
        Fri, 17 Jul 2020 07:05:25 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q1sm8388786pfk.132.2020.07.17.07.05.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 07:05:24 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix sq array offset calculation
To:     Dmitry Vyukov <dvyukov@google.com>,
        Hristo Venev <hristo@venev.name>
Cc:     Necip Fazil Yildiran <necip@google.com>, io-uring@vger.kernel.org
References: <20200711093111.2490946-1-dvyukov@google.com>
 <7d4e4f01-17d4-add1-5643-1df6a6868cb3@kernel.dk>
 <CACT4Y+YGwr+1k=rsJhMsnyQL4C+S2s9t7Cz5Axwc9fO5Ap4HbQ@mail.gmail.com>
 <7f128319f405358aa448a869a3a634a6cbc1469f.camel@venev.name>
 <CACT4Y+Y36NYmsn1nA16YFzLDU_Gt1xWZF+ZXvbJr9y-0qqP+DQ@mail.gmail.com>
 <CACT4Y+bgTCMXi3eU7xV+W0ZZNceZFUWRTkngojdr0G_yuY8w9w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <07129dd4-3ca1-63ad-8045-973532e320d9@kernel.dk>
Date:   Fri, 17 Jul 2020 08:05:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACT4Y+bgTCMXi3eU7xV+W0ZZNceZFUWRTkngojdr0G_yuY8w9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/17/20 7:48 AM, Dmitry Vyukov wrote:
> On Sat, Jul 11, 2020 at 6:16 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>>
>> On Sat, Jul 11, 2020 at 5:52 PM Hristo Venev <hristo@venev.name> wrote:
>>>
>>> On Sat, 2020-07-11 at 17:31 +0200, Dmitry Vyukov wrote:
>>>> Looking at the code more, I am not sure how it may not corrupt
>>>> memory.
>>>> There definitely should be some combinations where accessing
>>>> sq_entries*sizeof(u32) more memory won't be OK.
>>>> May be worth adding a test that allocates all possible sizes for
>>>> sq/cq
>>>> and fills both rings.
>>>
>>> The layout (after the fix) is roughly as follows:
>>>
>>> 1. struct io_rings - ~192 bytes, maybe 256
>>> 2. cqes - (32 << n) bytes
>>> 3. sq_array - (4 << n) bytes
>>>
>>> The bug was that the sq_array was offset by (4 << n) bytes. I think
>>> issues can only occur when
>>>
>>>     PAGE_ALIGN(192 + (32 << n) + (4 << n) + (4 << n))
>>>     !=
>>>     PAGE_ALIGN(192 + (32 << n) + (4 << n))
>>>
>>> It looks like this never happens. We got lucky.
>>
>> Interesting. CQ entries are larger and we have at least that many of
>> them as SQ entries. I guess this + power-of-2-pages can make it never
>> overflow.
> 
> Hi Jens,
> 
> I see this patch is in block/for-5.9/io_uring
> Is this tree merged into linux-next? I don't see it in linux-next yet.
> Or is it possible to get it into 5.8?

Yes, that tree is in linux-next, and I'm surprised you don't see it there
as it's been queued up for almost a week. Are you sure?

I'm not going to apply it to both 5.9 and 5.8 trees. The bug has
been there for a while, but doesn't really impact functionality.
Hence I just queued it up for 5.9. If this had been a 5.8 commit
that introduced it, I would have queued it up for 5.8.

> The reason I am asking is that we have an intern (Necip in CC) working
> on significantly extending io_uring coverage in syzkaller:
> https://github.com/google/syzkaller/pull/1926
> Unfortunately we had to hardcode offset computation logic b/c the
> intended way of using io_uring for normal programs represents an
> additional obstacle for the fuzzer and the relations between syscalls
> and writes to shared memory are even hard to express for the fuzzer.
> We want to hardcode this new updated way of computing offsets, but
> this means we probably won't get good coverage until the intern term
> ends (+ may be good to discover some io_uring bugs before the
> release).

Sounds good

> If it won't get into linux-next/mainline until 5.9, it's not a big
> deal, but I wanted to ask.

That's the plan, it'll go in as part of the 5.9 merge window.

-- 
Jens Axboe

