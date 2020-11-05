Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FEB2A88B8
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 22:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732375AbgKEVMh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 16:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732250AbgKEVMh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 16:12:37 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40605C0613CF
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 13:12:37 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id p2so2688462ilg.1
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 13:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RYEUOPRfxZU6JrgyltuAn/pRQdQEw0ygZOlXy+sOPkg=;
        b=2FVKtkSADKLjDYQx6Dw3oLep66eLC1ZKsXLtRuBjgt2Coneqbn0zZkZSbW2WnhVafh
         Av3U63NH4fGDO5G4v/TkwNjRrj3xYo1GBY9B8q64EziSXRB+0h8MurfaQWnyu8kQwjvQ
         FEQC1OsbbGm+v+sGMoJ14e1uQQTdprN/7smlAgo/rInH+Yne/j7J0cnU6BAMrE2nk9hP
         VrEraWS36LU4ZnHtoGwwNcMyZJ28FhLL2VroxVqoa97q6gtSgxVn6NijuVHHKfzU71Pc
         /M0HKghCX4xGJJ4sGmihaPpJzO86uJIvkwlPXqDbstr6Ahzgc/9ORbyalSuYBvDnEbdN
         smBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RYEUOPRfxZU6JrgyltuAn/pRQdQEw0ygZOlXy+sOPkg=;
        b=S9M4nBtWgyTHKQQv4sa5C/A/pA9f7MyfRalVSVRLegvycCuT/CK1L6w44cN0aqNUyE
         +KQbvJacSEF4yjgphdacUh/rY6aNLD1kOjUjuw1qZN2285+bLCOJ+eayJL1oDAhJNC3y
         9XsfV0UbMAofTat6sIuYNCmL/vJlj0JTq/fZqqRZV1t4p7qojmuGKmevm7IN2YG31Q73
         1WFmi+Kir/VJKtdBOU1Qc9j5Khm6X9FIX39M+mjOdQHV9VJtv4yu09AxJTwYiUE4OVO7
         OjUmgjPSB443nwtemjL3ffUP78hwIUf+mZFGVq6J5+exnIN7YzVy1FjISWrGpsIhafnG
         MDVA==
X-Gm-Message-State: AOAM530FILk8dK6MRWIteX9QSrhWDdLvoozehOOiZWYxyuujvO1B0m6C
        UNCjQLAcpErPYPALBBEXTVuyw0x6wPaktQ==
X-Google-Smtp-Source: ABdhPJxUJ8CJYVZM7Pbjae5cJ23+RtfxFT/FOp3rB9nov2/z8wEM2XyOvMi6gbz5g6TF34gu5dhDUw==
X-Received: by 2002:a92:7c04:: with SMTP id x4mr3433637ilc.36.1604610756295;
        Thu, 05 Nov 2020 13:12:36 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d142sm1592048iof.43.2020.11.05.13.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 13:12:35 -0800 (PST)
Subject: Re: Use of disowned struct filename after 3c5499fa56f5?
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>, io-uring@vger.kernel.org
References: <CAOKbgA5ojRs0xuor9TEtBEHUfhEj5sJewDoNgsbAYruhrFmPQw@mail.gmail.com>
 <1c1cd326-d99a-b15b-ab73-d5ee437db0fa@gmail.com>
 <7db39583-8839-ac9e-6045-5f6e2f4f9f4b@gmail.com>
 <97810ccb-2f85-9547-e7c1-ce1af562924d@kernel.dk>
 <38141659-e902-73c6-a320-33b8bf2af0a5@gmail.com>
 <361ab9fb-a67b-5579-3e7b-2a09db6df924@kernel.dk>
 <9b52b4b1-a243-4dc0-99ce-d6596ca38a58@gmail.com>
 <266e0d85-42ed-e0f8-3f0b-84bcda0af912@kernel.dk>
 <ae71b04d-b490-7055-900b-ebdbe389c744@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d0ff2282-2aba-d500-0552-e6ee179e3794@kernel.dk>
Date:   Thu, 5 Nov 2020 14:12:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ae71b04d-b490-7055-900b-ebdbe389c744@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/5/20 1:57 PM, Pavel Begunkov wrote:
> On 05/11/2020 20:49, Jens Axboe wrote:
>> On 11/5/20 1:35 PM, Pavel Begunkov wrote:
>>> On 05/11/2020 20:26, Jens Axboe wrote:
>>>> On 11/5/20 1:04 PM, Pavel Begunkov wrote:
>>>>> On 05/11/2020 19:37, Jens Axboe wrote:
>>>>>> On 11/5/20 7:55 AM, Pavel Begunkov wrote:
>>>>>>> On 05/11/2020 14:22, Pavel Begunkov wrote:
>>>>>>>> On 05/11/2020 12:36, Dmitry Kadashev wrote:
>>>>>>> Hah, basically filename_parentat() returns back the passed in filename if not
>>>>>>> an error, so @oldname and @from are aliased, then in the end for retry path
>>>>>>> it does.
>>>>>>>
>>>>>>> ```
>>>>>>> put(from);
>>>>>>> goto retry;
>>>>>>> ```
>>>>>>>
>>>>>>> And continues to use oldname. The same for to/newname.
>>>>>>> Looks buggy to me, good catch!
>>>>>>
>>>>>> How about we just cleanup the return path? We should only put these names
>>>>>> when we're done, not for the retry path. Something ala the below - untested,
>>>>>> I'll double check, test, and see if it's sane.
>>>>>
>>>>> Retry should work with a comment below because it uses @oldname
>>>>> knowing that it aliases to @from, which still have a refcount, but I
>>>>> don't like this implicit ref passing. If someone would change
>>>>> filename_parentat() to return a new filename, that would be a nasty
>>>>> bug.
>>>>
>>>> Not a huge fan of how that works either, but I'm not in this to rewrite
>>>> namei.c...
>>>
>>> There are 6 call sites including do_renameat2(), a separate patch would
>>> change just ~15-30 lines, doesn't seem like a big rewrite.
>>
>> It just seems like an utterly pointless exercise to me, something you'd
>> go through IFF you're changing filename_parentat() to return a _new_
>> entry instead of just the same one. And given that this isn't the only
>> callsite, there's precedence there for it working like that. I'd
>> essentially just be writing useless code.
>>
>> I can add a comment about it, but again, there are 6 other call sites.
> 
> Ok, but that's how things get broken.

I'm not arguing it's great code, just saying that's how it already works...

> There is one more idea then,
> instead of keeping both oldname and from, just have from. May make
> the whole thing easier.
> 
> int do_renameat2(struct filename *from)
> {
> ...
> retry:
>     from = filename_parentat(from, ...);
> ...
> exit:
>     if (!IS_ERR(from))
>         putname(from);
> }

That's not a bad idea, and eliminates the extra variables. I'll add that.
Need to get this sent out for review soonish anyway.

-- 
Jens Axboe

