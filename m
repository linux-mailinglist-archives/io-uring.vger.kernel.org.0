Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20E7E124783
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 14:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfLRNCb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 08:02:31 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39216 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbfLRNCb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 08:02:31 -0500
Received: by mail-pg1-f194.google.com with SMTP id b137so1256413pga.6
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 05:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4eASb4jB6lE0Xa0Dk7V5enVS+D7cPlcC1iinV3tnbPE=;
        b=sh3zIraCG1E0e/8AVASYMSMOvl0ethBJIIeecFejJ/wwNJRBMp/10HPJPoNqpqzjSA
         zj3LPo9TT9dwkZLz2Hy7yapMsTy+rQx9ntRzzgJmwv5yt4Kg6t2rmyOEP6N20XiKozJW
         h9LJ+uur7wEcwUusJSBy05Y4iG9Xxfm/t8vVIXXY10dMDj7EToteZpFGb8eL4oeFNT4a
         QDlJe8udjlONwttkiUKZpIoKVFt7w/vjuJo4Yo5ZCXp4HUZeRy4vnAzXySKW8cUFFYVz
         dhCF/x3pxEtlrL8aDhz6Eq+/bW3l2Mn1AVihXGuuRIh15LUeFjBus3qqSrLkPQt/ZCVV
         qrlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4eASb4jB6lE0Xa0Dk7V5enVS+D7cPlcC1iinV3tnbPE=;
        b=GESaU1wEgDxl5kn43IT+M4+xtIVAUqi653bljEQx0Pk2UgYSTmIlGz6Q+z55x4Qinu
         7JLd4Kudaffr6VtMzewbEKlzgCs1IPoEyBWSx+yo4DWFxO0PTUToawEJNqw/PUPvFo+i
         I1nDzT4kjheaXa7m0GL/mg40diOWRku5IXelL22IZVBEPXvnqmqbnLP7sjc7WERzVdL9
         Ywa+e5NTggRV2gpd9ARLgAzlo5LTotoesLxW7ph1TK46t9dKwNSWXR+LKVYxpcRFGuoj
         z2eeMW6n65ciIN2DC31yUssnSv9VXFpKRWp9jxXEfKB4U5RXV8yy7Om+5wn5l4iSTipZ
         akog==
X-Gm-Message-State: APjAAAW+KQ4InK/1wXD7+P82od+/mjH0AaQty54AqueshhVvLxDscewH
        8RTGG4lwV5JV7qo2QdHUoDPUqZVruWgkVQ==
X-Google-Smtp-Source: APXvYqwitOYVtaDWqwiAHMyYT5Q0SHsZP1bOkIfoPSFT740Hy6DqC/kHhLFnVYpiWah0J9Sug33x6Q==
X-Received: by 2002:a63:7503:: with SMTP id q3mr2771007pgc.300.1576674149568;
        Wed, 18 Dec 2019 05:02:29 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 133sm3232988pfy.14.2019.12.18.05.02.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 05:02:28 -0800 (PST)
Subject: Re: [PATCH 3/7] io_uring: don't wait when under-submitting
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <20191217225445.10739-1-axboe@kernel.dk>
 <20191217225445.10739-4-axboe@kernel.dk>
 <CAG48ez3kndOnUmEKRiL0SJ8=Tt_+NqZAg7ESwB9Us2xX43rnHg@mail.gmail.com>
 <1facf64e-a826-5b7c-391d-e29c1d7a71b0@kernel.dk>
 <711479c4-9aee-667c-590d-480fbee64c96@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <78c65b96-d5ad-c2f4-862b-5fb839895fc1@kernel.dk>
Date:   Wed, 18 Dec 2019 06:02:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <711479c4-9aee-667c-590d-480fbee64c96@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/18/19 2:38 AM, Pavel Begunkov wrote:
> On 12/18/2019 3:06 AM, Jens Axboe wrote:
>> On 12/17/19 4:55 PM, Jann Horn wrote:
>>> On Tue, Dec 17, 2019 at 11:54 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> There is no reliable way to submit and wait in a single syscall, as
>>>> io_submit_sqes() may under-consume sqes (in case of an early error).
>>>> Then it will wait for not-yet-submitted requests, deadlocking the user
>>>> in most cases.
>>>>
>>>> In such cases adjust min_complete, so it won't wait for more than
>>>> what have been submitted in the current io_uring_enter() call. It
>>>> may be less than total in-flight, but that up to a user to handle.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> [...]
>>>>         if (flags & IORING_ENTER_GETEVENTS) {
>>>>                 unsigned nr_events = 0;
>>>>
>>>>                 min_complete = min(min_complete, ctx->cq_entries);
>>>> +               if (submitted != to_submit)
>>>> +                       min_complete = min(min_complete, (u32)submitted);
>>>
>>> Hm. Let's say someone submits two requests, first an ACCEPT request
>>> that might stall indefinitely and then a WRITE to a file on disk that
>>> is expected to complete quickly; and the caller uses min_complete=1
>>> because they want to wait for the WRITE op. But now the submission of
>>> the WRITE fails, io_uring_enter() computes min_complete=min(1, 1)=1,
>>> and it blocks on the ACCEPT op. That would be bad, right?
>>>
>>> If the usecase I described is valid, I think it might make more sense
>>> to do something like this:
>>>
>>> u32 missing_submissions = to_submit - submitted;
>>> min_complete = min(min_complete, ctx->cq_entries);
>>> if ((flags & IORING_ENTER_GETEVENTS) && missing_submissions < min_complete) {
>>>   min_complete -= missing_submissions;
>>>   [...]
>>> }
>>>
>>> In other words: If we do a partially successful submission, only wait
>>> as long as we know that userspace definitely wants us to wait for one
>>> of the pending requests; and once we can't tell whether userspace
>>> intended to wait longer, return to userspace and let the user decide.
>>>
>>> Or it might make sense to just ignore IORING_ENTER_GETEVENTS
>>> completely in the partial submission case, in case userspace wants to
>>> immediately react to the failed request by writing out an error
>>> message to a socket or whatever. This case probably isn't
>>> performance-critical, right? And it would simplify things a bit.
>>
>> That's a good point, and Pavel's first patch actually did that. I
>> didn't consider the different request type case, which might be
>> uncommon but definitely valid.
>>
>> Probably the safest bet here is just to not wait at all if we fail
>> submitting all of them. This isn't a fast path, there was an error
>> somehow which meant we didn't submit it all. So just return the
>> submit count (including 0, not -EAGAIN) if we fail submitting,
>> and ignore IORING_ENTER_GETEVENTS for that case.
>>
> I see nothing wrong with -EAGAIN, it's returned only if it can't
> allocate memory for the first request. If so, can you then just take the
> v1? It will probably be applied cleanly.

-EAGAIN for request alloc is fine, but your v1 also returned -EAGAIN if
someone asked to submit 0, which is a bug. We must return zero for that
case.

So your v1 without that would work, something ala:

if (submitted != to_submit)
	goto out;

without the turning 0 into -EAGAIN unconditionally, io_submit_sqes() does
the right thing there as it is.

-- 
Jens Axboe

