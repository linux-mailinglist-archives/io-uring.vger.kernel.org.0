Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A252D15AEB2
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2020 18:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgBLR3n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Feb 2020 12:29:43 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45446 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728721AbgBLR3n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Feb 2020 12:29:43 -0500
Received: by mail-pg1-f194.google.com with SMTP id b9so1423956pgk.12
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2020 09:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xrY7AMkHrKww8zJCzj1GdOG5UXmd0BAsVpqqjvF0JJE=;
        b=H0hDSzA0gLP0bkiP6fI5C4Uk1NwHFllDo8mfnJnA1qSh7GqMulCvq7NnOclKS+u3np
         1jqDSf8EaJaDioerkcXRFueqReYLFCKETWtOCseiKq4GtygCydwMtxBpyZHmLD7bwrOh
         f1+p0h/rilRjp9MKcE/kUHdO+b8PMzzSZLSchOtRjmCtaalc/BVIe+JU57SzT4akP9I3
         qbMrxpUwxmnldupwcLWh0n1DtDmhzEUBg72LyXbNv2fy7ehg2/ikNeiYk+/Nq6vB/anZ
         upReVPW3ZH4ZoDvwbHZ6xvTLARM2Vzcx9NNrONGGtJkMyxrN9MRoXVQdV7foSTn9wQzY
         qO7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xrY7AMkHrKww8zJCzj1GdOG5UXmd0BAsVpqqjvF0JJE=;
        b=D4YZYDdVCJuFB5r00Q+dNTy7UfM+KoRW/411Bz6xphVIsnoE47Jq7nVXyqu1gADRMV
         Med2iZDnWug8LBTalpKn7Mow7WhXYthzUY6fMBg2Vf2H4/iLkOIm9z7KreKv8i/Kfbdr
         LmaZcYz2+yyBX2VXW2gLSptD3cfehuMDTJ+8MGw9MfZVxcuSJOWjf6X6sIvSFonlJQd9
         otGO6oFnvRoJ50j76In+BWJ4J0UQjIrAJwBB9j6Wk1RTr22+gvoKs/Iww6DeiB6fKo6W
         2ycMSlEWkocRwSpDJL+oKcFEzNcXStmfe3MPMBNLQF60X4dyayRyrZFr/sg07/HgteSF
         OGVA==
X-Gm-Message-State: APjAAAXMPYNfEXefDs5sga7Iop/RHYuUPYuPnCBHQbWhHwR8mA4Dfj5H
        S2zsxtS2qYdWChAdQAfZRCy+9gCP/F4=
X-Google-Smtp-Source: APXvYqx0WIgXOOAmFG89+/eF2zkiVYJZRHANf0YXKtuliRrJ7ZHIPwToMPQkMsegTFOrvDDJCzDYyA==
X-Received: by 2002:a63:7802:: with SMTP id t2mr13057740pgc.352.1581528582675;
        Wed, 12 Feb 2020 09:29:42 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::1018? ([2620:10d:c090:180::78ef])
        by smtp.gmail.com with ESMTPSA id t23sm1679471pfq.6.2020.02.12.09.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 09:29:42 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
From:   Jens Axboe <axboe@kernel.dk>
To:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <c0bf9bf4-9932-0c74-aa74-72b9cfa488b0@kernel.dk>
Message-ID: <4f1cdfd5-4947-39d0-c21b-01e694b47e87@kernel.dk>
Date:   Wed, 12 Feb 2020 10:29:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c0bf9bf4-9932-0c74-aa74-72b9cfa488b0@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/20 10:22 AM, Jens Axboe wrote:
> On 2/12/20 10:11 AM, Jens Axboe wrote:
>> On 2/12/20 9:31 AM, Carter Li 李通洲 wrote:
>>> Hi everyone,
>>>
>>> IOSQE_IO_LINK seems to have very high cost, even greater then io_uring_enter syscall.
>>>
>>> Test code attached below. The program completes after getting 100000000 cqes.
>>>
>>> $ gcc test.c -luring -o test0 -g -O3 -DUSE_LINK=0
>>> $ time ./test0
>>> USE_LINK: 0, count: 100000000, submit_count: 1562500
>>> 0.99user 9.99system 0:11.02elapsed 99%CPU (0avgtext+0avgdata 1608maxresident)k
>>> 0inputs+0outputs (0major+72minor)pagefaults 0swaps
>>>
>>> $ gcc test.c -luring -o test1 -g -O3 -DUSE_LINK=1
>>> $ time ./test1
>>> USE_LINK: 1, count: 100000110, submit_count: 799584
>>> 0.83user 19.21system 0:20.90elapsed 95%CPU (0avgtext+0avgdata 1632maxresident)k
>>> 0inputs+0outputs (0major+72minor)pagefaults 0swaps
>>>
>>> As you can see, the `-DUSE_LINK=1` version emits only about half io_uring_submit calls
>>> of the other version, but takes twice as long. That makes IOSQE_IO_LINK almost useless,
>>> please have a check.
>>
>> The nop isn't really a good test case, as it doesn't contain any smarts
>> in terms of executing a link fast. So it doesn't say a whole lot outside
>> of "we could make nop links faster", which is also kind of pointless.
>>
>> "Normal" commands will work better. Where the link is really a win is if
>> the first request needs to go async to complete. For that case, the
>> next link can execute directly from that context. This saves an async
>> punt for the common case.
> 
> Case in point, if I just add the below patch, we're a lot closer:
> 
> [root@archlinux liburing]# time test/nop-link 0
> Using link: 0
> count: 100000000, submit_count: 1562500
> 
> 
> real	0m7.934s
> user	0m0.740s
> sys	0m7.157s
> [root@archlinux liburing]# time test/nop-link 1
> Using link: 1
> count: 100000000, submit_count: 781250
> 
> 
> real	0m9.009s
> user	0m0.710s
> sys	0m8.264s
> 
> The links are still a bit slower, which is to be expected as the
> nop basically just completes, it doesn't do anything at all and
> it never needs to go async.

Pinning the test for more reliable results and we're basically even.

[root@archlinux liburing]# time taskset -c 0 test/nop-link 1
Using link: 1
count: 100000000, submit_count: 781250


real	0m8.251s
user	0m0.680s
sys	0m7.536s

[root@archlinux liburing]# time taskset -c 0 test/nop-link 0
Using link: 0
count: 100000000, submit_count: 1562500


real	0m7.986s
user	0m0.610s
sys	0m7.340s

For the intended case (outlined above), it'll definitely be a
win.

-- 
Jens Axboe

