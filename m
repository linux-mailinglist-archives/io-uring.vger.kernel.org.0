Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90CC91347D2
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2020 17:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgAHQYc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jan 2020 11:24:32 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45351 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgAHQYc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jan 2020 11:24:32 -0500
Received: by mail-pf1-f195.google.com with SMTP id 2so1855323pfg.12
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2020 08:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NDUTlXhpLXTQ8pke/mfHfmd0L1zdlQMPzMe3jfhwk7M=;
        b=0XVQ9N/Yvwy0zjQnC+bFmVT0lK/OwZSgBGirb5FbNTCeyyMfiM5P60f2+Q6ATvZE0X
         cxWVAJh1Rz8/XFDe8eP6pjFrglPSnDsO6jDGvQQlR+4ffYYcgjOd3O6y9rKL8bzc3UjH
         6UTgPbFuBVPMi4kyjiKpA+XArNseEJZ9K2TR61jFCypBhFQ4Y7osbY44/0gTTOH16tVM
         38UAACSszRDhzKgEgEpUgXoPjf3F8CnKzd/7PP0LBj/GLTL8fmGWO2Xi0/C4s/SUL2jB
         cmf/UO/KUR8GVjFXTRcqb6LbHf7LrJ5lTi4+XzTVWytwCzZmUfjq42bGOAlxMq0SnV1I
         IaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NDUTlXhpLXTQ8pke/mfHfmd0L1zdlQMPzMe3jfhwk7M=;
        b=kxh04vv5C0QF1SdE2warsp073aNtyFchyV2eBtcH/u9NtOjDKnUXujZgcwsthSHmhj
         NuL5ge620jQc4mE3QrMnZxISRdlUkKvV5jl5azPK6jXnimk+gLHRZNDmuIs7P06Tu4oa
         G0ssNYoX0cQU6h8LMnW1Nc6LQXkFcZXrNPxNttg5YwsUI0i2MYlm7LmiGadQozTaTjbY
         vqXszI8J25P9VSTKdHKJH/N6GLL8Be7zhaIHkNVZvX2t3DwYWEYSrrYcSLiePQpK7tTN
         TKUhgvq0EQiyqqalEF5WmfqysAVvONw+kKVOADuqMaZNToq1YRU2OYf8mVgNApEeKoJh
         dL4Q==
X-Gm-Message-State: APjAAAVWku1I0Yf1K0zNh45+LWRipJr50bSL5CcuQolnxasjBMZLxp97
        E13AZksR/0Z2VyjLbSQZMrHnYmVTESg=
X-Google-Smtp-Source: APXvYqzMdnd4yKTO/PMcXUbpvwH+s6h90H9bZUooTL9SI+9gsquNOQs7Zr3I23RLEMQK6zmt7Jm4AQ==
X-Received: by 2002:a62:a206:: with SMTP id m6mr5762462pff.210.1578500671013;
        Wed, 08 Jan 2020 08:24:31 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1130::1133? ([2620:10d:c090:180::38c8])
        by smtp.gmail.com with ESMTPSA id c1sm4317256pfa.51.2020.01.08.08.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 08:24:30 -0800 (PST)
Subject: Re: io_uring and spurious wake-ups from eventfd
To:     Mark Papadakis <markuspapadakis@icloud.com>
Cc:     io-uring@vger.kernel.org
References: <2005CB9A-0883-4C35-B975-1931C3640AA1@icloud.com>
 <55243723-480f-0220-2b93-74cc033c6e1d@kernel.dk>
 <60360091-ffce-fc8b-50d5-1a20fecaf047@kernel.dk>
 <4DED8D2F-8F0B-46FB-800D-FEC3F2A5B553@icloud.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d949ea3a-bd24-e597-b230-89b7075544cc@kernel.dk>
Date:   Wed, 8 Jan 2020 09:24:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4DED8D2F-8F0B-46FB-800D-FEC3F2A5B553@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/8/20 12:36 AM, Mark Papadakis wrote:
> 
> 
>> On 7 Jan 2020, at 10:34 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 1/7/20 1:26 PM, Jens Axboe wrote:
>>> On 1/7/20 8:55 AM, Mark Papadakis wrote:
>>>> This is perhaps an odd request, but if it’s trivial to implement
>>>> support for this described feature, it could help others like it ‘d
>>>> help me (I ‘ve been experimenting with io_uring for some time now).
>>>>
>>>> Being able to register an eventfd with an io_uring context is very
>>>> handy, if you e.g have some sort of reactor thread multiplexing I/O
>>>> using epoll etc, where you want to be notified when there are pending
>>>> CQEs to drain. The problem, such as it is, is that this can result in
>>>> un-necessary/spurious wake-ups.
>>>>
>>>> If, for example, you are monitoring some sockets for EPOLLIN, and when
>>>> poll says you have pending bytes to read from their sockets, and said
>>>> sockets are non-blocking, and for each some reported event you reserve
>>>> an SQE for preadv() to read that data and then you io_uring_enter to
>>>> submit the SQEs, because the data is readily available, as soon as
>>>> io_uring_enter returns, you will have your completions available -
>>>> which you can process.  The “problem” is that poll will wake up
>>>> immediately thereafter in the next reactor loop iteration because
>>>> eventfd was tripped (which is reasonable but un-necessary).
>>>>
>>>> What if there was a flag for io_uring_setup() so that the eventfd
>>>> would only be tripped for CQEs that were processed asynchronously, or,
>>>> if that’s non-trivial, only for CQEs that reference file FDs?
>>>>
>>>> That’d help with that spurious wake-up.
>>>
>>> One easy way to do that would be for the application to signal that it
>>> doesn't want eventfd notifications for certain requests. Like using an
>>> IOSQE_ flag for that. Then you could set that on the requests you submit
>>> in response to triggering an eventfd event.
>>
> 
> 
> Thanks Jens,
> 
> This is great, but perhaps there is a somewhat slightly more optimal
> way to do this.  Ideally, io_uring should trip the eventfd if there
> are any new completions available, that haven’t been produced In the
> context of an io_uring_enter(). That is to say, if any SQEs can be
> immediately served (because data is readily available in
> Buffers/caches in the kernel), then their respective CQEs will be
> produced in the context of that io_uring_enter() that submitted said
> SQEs(and thus the CQEs can be processed immediately after
> io_uring_enter() returns).  So, if any CQEs are placed in the
> respective ring at any other time, but not during an io_uring_enter()
> call, then it means those completions were produced asynchronously,
> and thus the eventfd can be tripped, otherwise, there is no need to
> trip the eventfd at all.
> 
> e.g (pseudocode):
> void produce_completion(cfq_ctx *ctx, const bool in_io_uring_enter_ctx) {
>         cqe_ring_push(cqe_from_ctx(ctx));
>         if (false == in_io_uring_enter_ctx && eventfd_registered()) {
>                 trip_iouring_eventfd();
>         } else {
>                 // don't bother
>         }
> }

I see what you're saying, so essentially only trigger eventfd
notifications if the completions happen async. That does make a lot of
sense, and it would be cleaner than having to flag this per request as
well. I think we'd still need to make that opt-in as it changes the
behavior of it.

The best way to do that would be to add IORING_REGISTER_EVENTFD_ASYNC or
something like that. Does the exact same thing as
IORING_REGISTER_EVENTFD, but only triggers it if completions happen
async.

What do you think?

-- 
Jens Axboe

