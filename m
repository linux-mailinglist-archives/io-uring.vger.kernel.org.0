Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6523FCB34
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 18:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbhHaQJC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 12:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbhHaQJB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 12:09:01 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECDFC061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 09:08:06 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id m9so4180741wrb.1
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 09:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=lHQiqchgHj21YXOsp0OboW+rLSskwTeEw16T3bL1XSU=;
        b=bCzNROTR4Tehv5RsZK8v0UlA2NETxq5EYqr569xLJ2nCeDtG7nEfg+3vpwV6QuDjX9
         ljB+5cPqSKCkvjcEHOWssBbAHgW/tUBtw1pUVQTiECvivbGz0PZTMtYDGx2YhHRa/dCF
         YPj3mvby1M06L+dSwND5pdIEYYyUpyU6MWAHAL2IGfYFoxtyKyggVo1+OOZC+jVOaJkU
         VdB5Le3TKfnnS/GQc7ftjZH2S06bYSwKYsIcRXwfulhG/tREbnfR4ixdDubIdtL8qa2O
         JaHN6I+Pro7A4r5sLa+Tk7Fn3osCbBfjw/E1J2qHH2nUTEFosz9EeB3MNxi8FbUXF2om
         V1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lHQiqchgHj21YXOsp0OboW+rLSskwTeEw16T3bL1XSU=;
        b=Nd5wmwvUnyQL80we04rWHRkfcqNK6I9c9sFbsGBu1o15TtWkM9TsgmvY1BkV8xXSr6
         W4rueQD2M0+33Lk/6wqS8qQpYjH6lEfQRR3GgQuTDg4jF8m8Yeh73m2XzpG2m6Zkl0RR
         kEY/oaaAOV466kxwQyi8fi3dkBi4JOQA+x5tWKvXNVXXZggliNUABhAPvGzXYIimbL+o
         BMWrlnuK7UF/3bDeQ/4/ItYvxcv54siNk4QkKU2vvfV7dr8ge2JA0QN3v0FupfdrF5P8
         9x6AxBz7xnE6pBRr0ozQ5oYXNGkPdpub/Kkz1HN+0CQFuvonl5wCcU7/sD4ZHfPzi+F7
         kmog==
X-Gm-Message-State: AOAM533iharXLAku3TnFRkaXeXqsyh8Rt/Tf2sWYQSOV+DTPqKhmcY4B
        08rSeZlNgZgkemm4ajxjB6VxUyPXrd0=
X-Google-Smtp-Source: ABdhPJwdz7qZIucXvd03sPpAxHFBD8eiaXsF49HbyIOzlKSiQt0Dt16GAj4RuMlTrP0W0p0t13PgEg==
X-Received: by 2002:adf:e101:: with SMTP id t1mr32381297wrz.215.1630426084421;
        Tue, 31 Aug 2021 09:08:04 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id k4sm18897580wrm.74.2021.08.31.09.08.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 09:08:04 -0700 (PDT)
Subject: Re: io_uring_prep_timeout_update on linked timeouts
To:     Jens Axboe <axboe@kernel.dk>, Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhHOt1Ni==4Qr6c+qGzQQ2R9SQR4COkG2MXn_SUzEG-cg@mail.gmail.com>
 <CAM1kxwi83=Q1Br46=_3DH46Ep2XoxbRX5hOVwFs7ze87Osx_eg@mail.gmail.com>
 <CAM1kxwiAF3tmF8PxVf6KPV+Qsg_180sFvebxos5ySmU=TqxgmA@mail.gmail.com>
 <1b3865bd-f381-04f3-6e54-779fe6b43946@kernel.dk>
 <04e3c4ab-4e78-805c-bc4f-f9c6d7e85ec1@gmail.com>
 <b53e6d69-9591-607b-c391-bf5fed23c1af@kernel.dk>
 <ebf4753c-dbe4-f6b5-e79c-39cc9a608beb@gmail.com>
 <66bf3640-a396-28cf-0b0d-8f3a9622ce2b@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <33030b85-fcec-181f-5244-198b86a8e1d4@gmail.com>
Date:   Tue, 31 Aug 2021 17:07:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <66bf3640-a396-28cf-0b0d-8f3a9622ce2b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/29/21 3:40 AM, Jens Axboe wrote:
> On 8/28/21 3:38 PM, Pavel Begunkov wrote:
>> On 8/28/21 2:43 PM, Jens Axboe wrote:
>>> On 8/28/21 7:39 AM, Pavel Begunkov wrote:
>>>> On 8/28/21 4:22 AM, Jens Axboe wrote:
>>>>> On 8/26/21 7:40 PM, Victor Stewart wrote:
>>>>>> On Wed, Aug 25, 2021 at 2:27 AM Victor Stewart <v@nametag.social> wrote:
>>>>>>>
>>>>>>> On Tue, Aug 24, 2021 at 11:43 PM Victor Stewart <v@nametag.social> wrote:
>>>>>>>>
>>>>>>>> we're able to update timeouts with io_uring_prep_timeout_update
>>>>>>>> without having to cancel
>>>>>>>> and resubmit, has it ever been considered adding this ability to
>>>>>>>> linked timeouts?
>>>>>>>
>>>>>>> whoops turns out this does work. just tested it.
>>>>>>
>>>>>> doesn't work actually. missed that because of a bit of misdirection.
>>>>>> returns -ENOENT.
>>>>>>
>>>>>> the problem with the current way of cancelling then resubmitting
>>>>>> a new a timeout linked op (let's use poll here) is you have 3 situations:
>>>>>>
>>>>>> 1) the poll triggers and you get some positive value. all good.
>>>>>>
>>>>>> 2) the linked timeout triggers and cancels the poll, so the poll
>>>>>> operation returns -ECANCELED.
>>>>>>
>>>>>> 3) you cancel the existing poll op, and submit a new one with
>>>>>> the updated linked timeout. now the original poll op returns
>>>>>> -ECANCELED.
>>>>>>
>>>>>> so solely from looking at the return value of the poll op in 2) and 3)
>>>>>> there is no way to disambiguate them. of course the linked timeout
>>>>>> operation result will allow you to do so, but you'd have to persist state
>>>>>> across cqe processings. you can also track the cancellations and know
>>>>>> to skip the explicitly cancelled ops' cqes (which is what i chose).
>>>>>>
>>>>>> there's also the problem of efficiency. you can imagine in a QUIC
>>>>>> server where you're constantly updating that poll timeout in response
>>>>>> to idle timeout and ACK scheduling, this extra work mounts.
>>>>>>
>>>>>> so i think the ability to update linked timeouts via
>>>>>> io_uring_prep_timeout_update would be fantastic.
>>>>>
>>>>> Hmm, I'll need to dig a bit, but whether it's a linked timeout or not
>>>>> should not matter. It's a timeout, it's queued and updated the same way.
>>>>> And we even check this in some of the liburing tests.
>>>>
>>>> We don't keep linked timeouts in ->timeout_list, so it's not
>>>> supported and has never been. Should be doable, but we need
>>>> to be careful synchronising with the link's head.
>>>
>>> Yeah shoot you are right, I guess that explains the ENOENT. Would be
>>> nice to add, though. Synchronization should not be that different from
>>> dealing with regular timeouts.
>>
>> _Not tested_, but something like below should do. will get it
>> done properly later, but even better if we already have a test
>> case. Victor?
> 
> FWIW, I wrote a simple test case for it, and it seemed to work fine.
> Nothing fancy, just a piped read that would never finish with a linked
> timeout (1s), submit, then submit a ltimeout update that changes it to
> 2s instead. Test runs and update completes first with res == 0 as
> expected, and 2s later the ltimeout completes with -EALREADY (because
> the piped read went async) and the piped read gets canceled.
> 
> That seems to be as expected, and didn't trigger anything odd.

Perfect. Thanks, Jens

-- 
Pavel Begunkov
