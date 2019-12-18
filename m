Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 310E0124366
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 10:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfLRJiJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 04:38:09 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38391 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfLRJiJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 04:38:09 -0500
Received: by mail-lf1-f67.google.com with SMTP id r14so1195001lfm.5
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 01:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=64UQzQZMv2s2KNa0BaCfsUpdrNzajXJps5HvEbnLDIQ=;
        b=m63MYsGFoe+2CJYy9dvf88KLV7PrOnUvwlSG8kWCmUC/snFM6HszxpFp47mgD2S/+w
         aof3CJUXDPybYEBblj3EG8MribcD8VoRGcJr8st95R1O676hXVzcpWShPF2oc7Ib1UXe
         kx7kaAlH2VEywbyRrIxfcm5Scv2jhTnWyZwuqI9D8rCqMLZMhRLuvojrhbZVkcsBxuhg
         HloV3LhzmcQlUq+4TSTQgXo+ViSQJeKR2tE5r2o3R+U4+/Mmg0UqCxe7VVRefebwofhi
         DvlBLjqC5kXuK/5qZgGkXnJN/I5vsF0SDXKj5Z2WRmA2MU0kjzfpxdJo81t0vsMwTgV+
         q4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=64UQzQZMv2s2KNa0BaCfsUpdrNzajXJps5HvEbnLDIQ=;
        b=fq2Dq57r5bvrNCdFGxnT3riLcZhPcBl4FLcVrthovyAv1uQt7lxEXxUy/Gb0qIPeZf
         Tl8XimnefYicVSPYugDZltgB0yU0t5XBm7RgI+PaLfbB6t9e8O3/dolRgCli51zPdND/
         ZR9ip3oVY6DSb7ey3uoAXws+UoCadzR8L5BpC9rvSCrfGeOMPqzr5WuZly02v3HqgS7W
         cmkfqACuzltrILzdbOWgfsGtZoo4FinKFhMPKxZ2NtkScV6LhURweI90xXjv4Do5vMtM
         CyCQD1P+44i8bvcG/KAolzcLJ6rMMDdpDYpATYZCZj167KeP0H6KNny/jjHhz9+jr9pu
         jTTA==
X-Gm-Message-State: APjAAAUB0TRe8mZ/W1PcCZkeGQBftukYl/oolZejXW1H0R1lTIJaefZq
        qZvsC+m0hnkTzFBPr+Is4P7bo4785Nw=
X-Google-Smtp-Source: APXvYqwtja/GUUwCCUHX6qB08GR7p8vK2GZ+xHzMssv4zVASZ1ImUfkeyW6p19kGbSc3F3TeTE5+ug==
X-Received: by 2002:ac2:44ce:: with SMTP id d14mr1149695lfm.140.1576661886535;
        Wed, 18 Dec 2019 01:38:06 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id a15sm806402lfi.60.2019.12.18.01.38.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 01:38:06 -0800 (PST)
Subject: Re: [PATCH 3/7] io_uring: don't wait when under-submitting
To:     Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <20191217225445.10739-1-axboe@kernel.dk>
 <20191217225445.10739-4-axboe@kernel.dk>
 <CAG48ez3kndOnUmEKRiL0SJ8=Tt_+NqZAg7ESwB9Us2xX43rnHg@mail.gmail.com>
 <1facf64e-a826-5b7c-391d-e29c1d7a71b0@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <711479c4-9aee-667c-590d-480fbee64c96@gmail.com>
Date:   Wed, 18 Dec 2019 12:38:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <1facf64e-a826-5b7c-391d-e29c1d7a71b0@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/18/2019 3:06 AM, Jens Axboe wrote:
> On 12/17/19 4:55 PM, Jann Horn wrote:
>> On Tue, Dec 17, 2019 at 11:54 PM Jens Axboe <axboe@kernel.dk> wrote:
>>> There is no reliable way to submit and wait in a single syscall, as
>>> io_submit_sqes() may under-consume sqes (in case of an early error).
>>> Then it will wait for not-yet-submitted requests, deadlocking the user
>>> in most cases.
>>>
>>> In such cases adjust min_complete, so it won't wait for more than
>>> what have been submitted in the current io_uring_enter() call. It
>>> may be less than total in-flight, but that up to a user to handle.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> [...]
>>>         if (flags & IORING_ENTER_GETEVENTS) {
>>>                 unsigned nr_events = 0;
>>>
>>>                 min_complete = min(min_complete, ctx->cq_entries);
>>> +               if (submitted != to_submit)
>>> +                       min_complete = min(min_complete, (u32)submitted);
>>
>> Hm. Let's say someone submits two requests, first an ACCEPT request
>> that might stall indefinitely and then a WRITE to a file on disk that
>> is expected to complete quickly; and the caller uses min_complete=1
>> because they want to wait for the WRITE op. But now the submission of
>> the WRITE fails, io_uring_enter() computes min_complete=min(1, 1)=1,
>> and it blocks on the ACCEPT op. That would be bad, right?
>>
>> If the usecase I described is valid, I think it might make more sense
>> to do something like this:
>>
>> u32 missing_submissions = to_submit - submitted;
>> min_complete = min(min_complete, ctx->cq_entries);
>> if ((flags & IORING_ENTER_GETEVENTS) && missing_submissions < min_complete) {
>>   min_complete -= missing_submissions;
>>   [...]
>> }
>>
>> In other words: If we do a partially successful submission, only wait
>> as long as we know that userspace definitely wants us to wait for one
>> of the pending requests; and once we can't tell whether userspace
>> intended to wait longer, return to userspace and let the user decide.
>>
>> Or it might make sense to just ignore IORING_ENTER_GETEVENTS
>> completely in the partial submission case, in case userspace wants to
>> immediately react to the failed request by writing out an error
>> message to a socket or whatever. This case probably isn't
>> performance-critical, right? And it would simplify things a bit.
> 
> That's a good point, and Pavel's first patch actually did that. I
> didn't consider the different request type case, which might be
> uncommon but definitely valid.
> 
> Probably the safest bet here is just to not wait at all if we fail
> submitting all of them. This isn't a fast path, there was an error
> somehow which meant we didn't submit it all. So just return the
> submit count (including 0, not -EAGAIN) if we fail submitting,
> and ignore IORING_ENTER_GETEVENTS for that case.
> 
I see nothing wrong with -EAGAIN, it's returned only if it can't
allocate memory for the first request. If so, can you then just take the
v1? It will probably be applied cleanly.

> Pavel, care to submit a new one? I'll drop this one now.
> 

-- 
Pavel Begunkov
