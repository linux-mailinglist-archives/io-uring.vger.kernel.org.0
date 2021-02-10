Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E212B315DC7
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 04:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhBJDYH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 22:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhBJDYG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 22:24:06 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDDDC061574
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 19:23:26 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id 8so428794plc.10
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 19:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=nhzfzSXnq+pTyKaxGqY1TjPbEkxOgv9+TA6074H41uk=;
        b=vj51oq33njk7Vk8VhJCLnRXaVqw9TJsxQ54ph1/3FsmmfNwXmbXx/SN4JAeKp3bEYK
         8+X0Nhe9emD9aGFadE68ITu5+yJHFUiNWSZG40C7w1dDT6/Xj2bnDxWMGCoFEmi1AtbX
         49pFK07CG7pJ6C6zEvWfJPYs9SrmclVr2V6e0X09yBLU3lK+kAfC7R74mW+KA+Zq0tAt
         40+BWh8U3rSjyXrx8grBnerHydabrPpYJgA5jWD+r8YB3ZYEGzrQhC5BN3TtIT8pHrPS
         K6XVaufty0RefCq/OXfpsnOlyCqhi6RhHZ5f1ToNZPR3N2r1YlGScL3T6zRTX1tdoq/t
         Pckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nhzfzSXnq+pTyKaxGqY1TjPbEkxOgv9+TA6074H41uk=;
        b=rgZ+iZuqfD5saPEKjFk764TfQDOiPM+UPSlaR1bpUF89xBXnJzGi+Fv5MKLb9Iakfb
         PngB7aA6Nsi0+G8d3CF7Oj/rrD75GXjvOr1LAH2VrYRzf2uLaVt7nWI6QuCk2/3CiO94
         RsHUzmHfu6wKQ6hUy6k/iy0b52RtH4BEHQ8ljDWOrYOSI5UU/pDv6cJA+M2a0l8PQfrp
         Dnxerr/0fcfg53k4epAkSn1+xY2Pg3M3AbTjuogO714lV4bFX5gN84YvkcRkjNTuN0QN
         lWjTkh0BI7ghuzwm8Lucj7GSzh7tEEA1owXck3jMTeNkQRG/Srr32FfEnBXRS9wpM2iq
         4Y4g==
X-Gm-Message-State: AOAM530IZA71RbMy2hEfIuymAchkbJNHCrdTqdzOXRECm4jsZuBIHau+
        3viFYsJrdNtrKGzOnqMahwo4RxqwbbWxkw==
X-Google-Smtp-Source: ABdhPJwjOWQKBuluAKH3PQn4nhk+71FMhdTOZVPIJt2rsS/2J8ZhVswzTxXmFoOPN9h5sDXhePCw1g==
X-Received: by 2002:a17:90a:1f41:: with SMTP id y1mr1103177pjy.90.1612927405755;
        Tue, 09 Feb 2021 19:23:25 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 74sm309945pfw.53.2021.02.09.19.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 19:23:25 -0800 (PST)
Subject: Re: [PATCH RFC 00/17] playing around req alloc
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1612915326.git.asml.silence@gmail.com>
 <ffaf0640-7747-553d-9baf-4d41777a4d4d@kernel.dk>
 <dcc61d65-d6e0-14e0-7368-352501fc21ea@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a9a0d663-f6ac-1086-8cd7-ad4583b1cb7c@kernel.dk>
Date:   Tue, 9 Feb 2021 20:23:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dcc61d65-d6e0-14e0-7368-352501fc21ea@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/9/21 8:14 PM, Pavel Begunkov wrote:
> On 10/02/2021 02:08, Jens Axboe wrote:
>> On 2/9/21 5:03 PM, Pavel Begunkov wrote:
>>> Unfolding previous ideas on persistent req caches. 4-7 including
>>> slashed ~20% of overhead for nops benchmark, haven't done benchmarking
>>> personally for this yet, but according to perf should be ~30-40% in
>>> total. That's for IOPOLL + inline completion cases, obviously w/o
>>> async/IRQ completions.
>>
>> And task_work, which is sort-of inline.
>>
>>> Jens,
>>> 1. 11/17 removes deallocations on end of submit_sqes. Looks you
>>> forgot or just didn't do that.
> 
> And without the patches I added, it wasn't even necessary, so
> nevermind

OK good, I was a bit confused about that one...

>>> 2. lists are slow and not great cache-wise, that why at I want at least
>>> a combined approach from 12/17.
>>
>> This is only true if you're browsing a full list. If you do add-to-front
>> for a cache, and remove-from-front, then cache footprint of lists are
>> good.
> 
> Ok, good point, but still don't think it's great. E.g. 7/17 did improve
> performance a bit for me, as I mentioned in the related RFC. And that
> was for inline-completed nops, and going over the list/array and
> always touching all reqs.

Agree, array is always a bit better. Just saying that it's not a huge
deal unless you're traversing the list, in which case lists are indeed
horrible. But for popping off the first entry (or adding one), it's not
bad at all.

>>> 3. Instead of lists in "use persistent request cache" I had in mind a
>>> slightly different way: to grow the req alloc cache to 32-128 (or hint
>>> from the userspace), batch-alloc by 8 as before, and recycle _all_ reqs
>>> right into it. If  overflows, do kfree().
>>> It should give probabilistically high hit rate, amortising out most of
>>> allocations. Pros: it doesn't grow ~infinitely as lists can. Cons: there
>>> are always counter examples. But as I don't have numbers to back it, I
>>> took your implementation. Maybe, we'll reconsider later.
>>
>> It shouldn't grow bigger than what was used, but the downside is that
>> it will grow as big as the biggest usage ever. We could prune, if need
>> be, of course.
> 
> Yeah, that was the point. But not a deal-breaker in either case.

Agree

>> As far as I'm concerned, the hint from user space is the submit count.
> 
> I mean hint on setup, like max QD, then we can allocate req cache
> accordingly. Not like it matters

I'd rather grow it dynamically, only the first few iterations will hit
the alloc. Which is fine, and better than pre-populating. Assuming I
understood you correctly here...

>>
>>> I'll revise tomorrow on a fresh head + do some performance testing,
>>> and is leaving it RFC until then.
>>
>> I'll look too and test this, thanks!

Tests out good for me with the suggested edits I made. nops are
massively improved, as suspected. But also realistic workloads benefit
nicely.

I'll send out a few patches I have on top tomorrow. Not fixes, but just
further improvements/features/accounting.

-- 
Jens Axboe

