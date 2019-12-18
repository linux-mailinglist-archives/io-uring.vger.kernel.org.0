Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9581B1247AF
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 14:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfLRNJq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 08:09:46 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45683 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbfLRNJq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 08:09:46 -0500
Received: by mail-lj1-f193.google.com with SMTP id j26so2045240ljc.12
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 05:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CnTWSUiz1cx5gE0hG20kRIYKRW+P5HJzlve4fCJIJuw=;
        b=WEFbCRGD2Cv6G9N3tNunqOm70Ie3XMrMfZvpw4mPNLEm2h3EZXeGb3gHCbIKqnD4xs
         gW8MLgS0bAFcM3wpE4Njnn8C8Y/NnR0TouUHnrESi6QSlU1hE94ksYzYrjnHiKB5O5zP
         AIEBpSnZLjHhIQe6xpPbGH9aBmrUV+oKIZkJPStmx7onkePBaoUquwW4XNuicl+C3Q6Z
         0eJUPz4rltKIrngb0xES8iK11YBfXGnRJSP14ff5reBDaIQhQoE6I2nWKgmHOMb+k+U5
         3qbTJWVZ0B9J6MO1JF1oazofkEZKD3Hkipu4iZvChdQA+akBIyqqXfUqI3aCj5OhU3zT
         Z2kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CnTWSUiz1cx5gE0hG20kRIYKRW+P5HJzlve4fCJIJuw=;
        b=rAohJJNxop5MG+AzJICoz7Ug4R6/XqVfyyZ0IAR88rlg0rGSkfCOnpParAHPmcPbXb
         khMOzKYuV7AN9tWcjNchHcpEx8Jd2M7iG/3nBzF61Cy8Dd+gtOO/eSjFIsfRlpLXJYzn
         LxnfOTcJf/0iQf3y8/h+2O8Ex78NeXafvDR06ZdyMASHAouFP46r3JYOkfxcd4NOejRr
         cAuL5vBYNjUxkRXGtKEhViSLvX4/V/q1WQlSrg/oAKF8joIhG4BTVOtTaLyS3a7tJLpR
         zVFSu7hUv5fZ7l6nAkxGX+5j7bk2q+QHgskU8dF67Xr5/hDNtq0op5VZ2Y4U2k/fz67k
         nRbw==
X-Gm-Message-State: APjAAAXj9Rw5WhNK+NIr+LLorunVjnTuhK1u+pbvgJLDucLMEbcHZgAj
        +juNVbxCqckFkEPQ6qRHaBnfQbskHV8=
X-Google-Smtp-Source: APXvYqy1U6QSM6NDFgqXMvrW+BT0oio3qTZl5OqQDCSmujXNGqfS0V9lm1bNd6OSjB1JT10kNMtnxw==
X-Received: by 2002:a2e:b5ac:: with SMTP id f12mr1802493ljn.0.1576674583776;
        Wed, 18 Dec 2019 05:09:43 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id i4sm1486768lji.0.2019.12.18.05.09.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 05:09:43 -0800 (PST)
Subject: Re: [PATCH 3/7] io_uring: don't wait when under-submitting
To:     Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <20191217225445.10739-1-axboe@kernel.dk>
 <20191217225445.10739-4-axboe@kernel.dk>
 <CAG48ez3kndOnUmEKRiL0SJ8=Tt_+NqZAg7ESwB9Us2xX43rnHg@mail.gmail.com>
 <1facf64e-a826-5b7c-391d-e29c1d7a71b0@kernel.dk>
 <711479c4-9aee-667c-590d-480fbee64c96@gmail.com>
 <78c65b96-d5ad-c2f4-862b-5fb839895fc1@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <4fce5f02-6263-24b5-adbc-c496a13b0aa0@gmail.com>
Date:   Wed, 18 Dec 2019 16:09:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <78c65b96-d5ad-c2f4-862b-5fb839895fc1@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/18/2019 4:02 PM, Jens Axboe wrote:
> On 12/18/19 2:38 AM, Pavel Begunkov wrote:
>> On 12/18/2019 3:06 AM, Jens Axboe wrote:
>>> On 12/17/19 4:55 PM, Jann Horn wrote:
>>>> On Tue, Dec 17, 2019 at 11:54 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>> There is no reliable way to submit and wait in a single syscall, as
>>>>> io_submit_sqes() may under-consume sqes (in case of an early error).
>>>>> Then it will wait for not-yet-submitted requests, deadlocking the user
>>>>> in most cases.
>>>>>
>>>>> In such cases adjust min_complete, so it won't wait for more than
>>>>> what have been submitted in the current io_uring_enter() call. It
>>>>> may be less than total in-flight, but that up to a user to handle.
>>>>>
>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> [...]
>>>>>         if (flags & IORING_ENTER_GETEVENTS) {
>>>>>                 unsigned nr_events = 0;
>>>>>
>>>>>                 min_complete = min(min_complete, ctx->cq_entries);
>>>>> +               if (submitted != to_submit)
>>>>> +                       min_complete = min(min_complete, (u32)submitted);
>>>>
>>>> Hm. Let's say someone submits two requests, first an ACCEPT request
>>>> that might stall indefinitely and then a WRITE to a file on disk that
>>>> is expected to complete quickly; and the caller uses min_complete=1
>>>> because they want to wait for the WRITE op. But now the submission of
>>>> the WRITE fails, io_uring_enter() computes min_complete=min(1, 1)=1,
>>>> and it blocks on the ACCEPT op. That would be bad, right?
>>>>
>>>> If the usecase I described is valid, I think it might make more sense
>>>> to do something like this:
>>>>
>>>> u32 missing_submissions = to_submit - submitted;
>>>> min_complete = min(min_complete, ctx->cq_entries);
>>>> if ((flags & IORING_ENTER_GETEVENTS) && missing_submissions < min_complete) {
>>>>   min_complete -= missing_submissions;
>>>>   [...]
>>>> }
>>>>
>>>> In other words: If we do a partially successful submission, only wait
>>>> as long as we know that userspace definitely wants us to wait for one
>>>> of the pending requests; and once we can't tell whether userspace
>>>> intended to wait longer, return to userspace and let the user decide.
>>>>
>>>> Or it might make sense to just ignore IORING_ENTER_GETEVENTS
>>>> completely in the partial submission case, in case userspace wants to
>>>> immediately react to the failed request by writing out an error
>>>> message to a socket or whatever. This case probably isn't
>>>> performance-critical, right? And it would simplify things a bit.
>>>
>>> That's a good point, and Pavel's first patch actually did that. I
>>> didn't consider the different request type case, which might be
>>> uncommon but definitely valid.
>>>
>>> Probably the safest bet here is just to not wait at all if we fail
>>> submitting all of them. This isn't a fast path, there was an error
>>> somehow which meant we didn't submit it all. So just return the
>>> submit count (including 0, not -EAGAIN) if we fail submitting,
>>> and ignore IORING_ENTER_GETEVENTS for that case.
>>>
>> I see nothing wrong with -EAGAIN, it's returned only if it can't
>> allocate memory for the first request. If so, can you then just take the
>> v1? It will probably be applied cleanly.
> 
> -EAGAIN for request alloc is fine, but your v1 also returned -EAGAIN if
> someone asked to submit 0, which is a bug. We must return zero for that
> case.
> 
Now I see which -EAGAIN you meant. You're right, I'll resend

> So your v1 without that would work, something ala:
> 
> if (submitted != to_submit)
> 	goto out;
> 
> without the turning 0 into -EAGAIN unconditionally, io_submit_sqes() does
> the right thing there as it is.
> 

-- 
Pavel Begunkov
