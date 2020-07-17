Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72642223DCD
	for <lists+io-uring@lfdr.de>; Fri, 17 Jul 2020 16:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgGQOI3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jul 2020 10:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgGQOI2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jul 2020 10:08:28 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECF1C0619D2
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 07:08:28 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m9so5447675pfh.0
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 07:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tm2UqBON9THnirIATmzVCmWwQ8IEi1EF4dhUywIVepE=;
        b=SgEu3+B3y2HZ3bwFjIkNHicXpPovmXaZXIs8JRtCWvtx7T/MSTpBnMKHBAFZpmGRd7
         YMMESNqU6GYsL7Hvakl9iZGEev3kjMiTkN0S4csJZWyEXG8+ZUr/jvTqTA0YnK4pQauc
         TpU8ZZxS0dh4Km8dwspRkEtZLKuDBhTlOE4NzqQqEVCzQo1iz6bKfbT8qMjfYYYPOASV
         4/oYLqNEf7uvdtFd3wzVchf6P1COLDJcCRde/PTCjP3H6eNS0AyaNZzrNg5j75Mf6Xos
         OUCMvDw9lLnW8qseeeYhMJIPOMDV8YOzZ8L3wgJ8rjgJG2VhGQj8v5FhTCal8kurTUOb
         Rk3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tm2UqBON9THnirIATmzVCmWwQ8IEi1EF4dhUywIVepE=;
        b=V95DBdAOFwPmp63y2tvnCiim9AYQMFL02CytxrbfTaCfkiS/f/3qzfPKQPJya8hECH
         6GnTgYvqQ3JabJlGgh3bDHt2d3qTyJeISj4XYtu7mYd1PcLUCzcfcvhIBftiXwU4eaPW
         ZGbLEDd0D5R2rFr16mMyRQ8op8MtQnM+4jNNKuih+dyGVsv8EBYjG7oL8EsuKmdbW5el
         wV+tFXyGwoaMKEXNNmZjsJk8V9JXK4jaQhHzh5vwfJCtQTF7EEfO2somkOH92s7nWTqf
         /XPtLZ5OHBpNinRB9uyb81WKSFO87N+EH4iMEetGXT1gxuWMfjZ/38vBZSHRol8Nv3iA
         qPFQ==
X-Gm-Message-State: AOAM5322rhBMPYIASEAU+Y+etX5Y1VONAcE0R/RwfCs1ztV1qJquj2Z7
        ODteo72QCA3PHVecWCTg0jwUy9K7BAN+qg==
X-Google-Smtp-Source: ABdhPJwd3lQ84ejGVWoQL2SlMn4LcP4GnP0HQgNuO81wFr5nqb07lyyF8DLqpCKzpBqUzMrI4xbMXw==
X-Received: by 2002:a65:6212:: with SMTP id d18mr7957562pgv.402.1594994907838;
        Fri, 17 Jul 2020 07:08:27 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x7sm7270857pfp.96.2020.07.17.07.08.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 07:08:27 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix sq array offset calculation
From:   Jens Axboe <axboe@kernel.dk>
To:     Dmitry Vyukov <dvyukov@google.com>,
        Hristo Venev <hristo@venev.name>
Cc:     Necip Fazil Yildiran <necip@google.com>, io-uring@vger.kernel.org
References: <20200711093111.2490946-1-dvyukov@google.com>
 <7d4e4f01-17d4-add1-5643-1df6a6868cb3@kernel.dk>
 <CACT4Y+YGwr+1k=rsJhMsnyQL4C+S2s9t7Cz5Axwc9fO5Ap4HbQ@mail.gmail.com>
 <7f128319f405358aa448a869a3a634a6cbc1469f.camel@venev.name>
 <CACT4Y+Y36NYmsn1nA16YFzLDU_Gt1xWZF+ZXvbJr9y-0qqP+DQ@mail.gmail.com>
 <CACT4Y+bgTCMXi3eU7xV+W0ZZNceZFUWRTkngojdr0G_yuY8w9w@mail.gmail.com>
 <07129dd4-3ca1-63ad-8045-973532e320d9@kernel.dk>
Message-ID: <698c7ae3-b324-0c2f-d956-159c52d8270b@kernel.dk>
Date:   Fri, 17 Jul 2020 08:08:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <07129dd4-3ca1-63ad-8045-973532e320d9@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/17/20 8:05 AM, Jens Axboe wrote:
> On 7/17/20 7:48 AM, Dmitry Vyukov wrote:
>> On Sat, Jul 11, 2020 at 6:16 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>>>
>>> On Sat, Jul 11, 2020 at 5:52 PM Hristo Venev <hristo@venev.name> wrote:
>>>>
>>>> On Sat, 2020-07-11 at 17:31 +0200, Dmitry Vyukov wrote:
>>>>> Looking at the code more, I am not sure how it may not corrupt
>>>>> memory.
>>>>> There definitely should be some combinations where accessing
>>>>> sq_entries*sizeof(u32) more memory won't be OK.
>>>>> May be worth adding a test that allocates all possible sizes for
>>>>> sq/cq
>>>>> and fills both rings.
>>>>
>>>> The layout (after the fix) is roughly as follows:
>>>>
>>>> 1. struct io_rings - ~192 bytes, maybe 256
>>>> 2. cqes - (32 << n) bytes
>>>> 3. sq_array - (4 << n) bytes
>>>>
>>>> The bug was that the sq_array was offset by (4 << n) bytes. I think
>>>> issues can only occur when
>>>>
>>>>     PAGE_ALIGN(192 + (32 << n) + (4 << n) + (4 << n))
>>>>     !=
>>>>     PAGE_ALIGN(192 + (32 << n) + (4 << n))
>>>>
>>>> It looks like this never happens. We got lucky.
>>>
>>> Interesting. CQ entries are larger and we have at least that many of
>>> them as SQ entries. I guess this + power-of-2-pages can make it never
>>> overflow.
>>
>> Hi Jens,
>>
>> I see this patch is in block/for-5.9/io_uring
>> Is this tree merged into linux-next? I don't see it in linux-next yet.
>> Or is it possible to get it into 5.8?
> 
> Yes, that tree is in linux-next, and I'm surprised you don't see it there
> as it's been queued up for almost a week. Are you sure?

I see it in there:

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/fs/io_uring.c?id=a4968ff8b6314631a73fdc945a66fd8645dfe8cc

-- 
Jens Axboe

