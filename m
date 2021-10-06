Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94DE42498F
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 00:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239554AbhJFWZx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 18:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239223AbhJFWZx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 18:25:53 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D39FC061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 15:24:00 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id b78so4587572iof.2
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 15:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3QOQqklJ+a0sYymOSo0v2z1/py177nqGK35Jk5vy2vE=;
        b=R3dnSHdgh8/5+UQNZYFGaU3YQ2NzaIibFQNAJ1+HHCMZdRaLGXhcdxST8CtCVZ+K7w
         CEVnn7rFji9Xftfr1vyyKFORTyCyR0590qwgtLGvxKZeHMsQjehE9b2qwKpIAkkz+o7t
         jMAdWp9H2PQO4r52PAuvogsVmhl+YLMwGboFaos/gnJnrqwrBbXuNdnNhYk4OBKoRqzc
         tOy/Tz+DHR1n0Dxi8lNtOtczoTaRdn9uV/V91U3Q2abRTwI8E8QJgaFE1IfR1vs5s9mr
         JXcECg60/4hV1S4g91XoSKVKNd5ZxIZsIy94sp/bmumj+BarPFk2jGB2btvp1W29XucJ
         7YYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3QOQqklJ+a0sYymOSo0v2z1/py177nqGK35Jk5vy2vE=;
        b=p5Y1eCVeqfY4v+k+qevVvogTdf7aaCoE251uAmnZ/fa0K11bwzGYagLLK8jBnEt5WH
         EyBnX80OKlP7OFlo31H/TgtvX8IfPSiLqS64SFKdVV2FMTT8asTE2pS/j2WQ4A0r9Kjh
         nj/w1WiguPjB/PDtw2Ux1QBNsRuxb/631ZOd4cPIUAPK7RsWejNov7OZ4/rg1hcdrzIY
         fgmLWGijsXbAMt/8lqqmC+0jO+Fl85omV6M0P8IDT+GC8sPeiYjACak8w6Ddv/nmF2R3
         jCfBUaG/KjXIgOWkgvofX1pJRcSEYqj68ruFaT/hySth6MlqYw0IuibEH28dqCoSJZhw
         YYPA==
X-Gm-Message-State: AOAM5310JGtnXa6ZSuB0a580jUbQNLnAZw+y+/BUQmpaqf3EBG+rLoI7
        F3tv0XoLV5N+JcAexWuj0bbL8idY1n6Jjw==
X-Google-Smtp-Source: ABdhPJzmdQ4Ds4sp1ZYX4kxgDUDSeE4p8Uqtn25G6ZgTvv+4rN96jFZv0cX4vLK5vBQweMGva+pVcw==
X-Received: by 2002:a6b:6302:: with SMTP id p2mr637665iog.105.1633559039873;
        Wed, 06 Oct 2021 15:23:59 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m1sm12904290ilc.75.2021.10.06.15.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 15:23:59 -0700 (PDT)
Subject: Re: [PATCHSET v1 RFC liburing 0/6] Add no libc support for x86-64
 arch
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
References: <20211006222030.1208080-1-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a8a96675-91c2-5566-4ac1-4b60bbafd94e@kernel.dk>
Date:   Wed, 6 Oct 2021 16:23:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211006222030.1208080-1-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/6/21 4:20 PM, Ammar Faizi wrote:
> On Thu, Oct 7, 2021 at 1:48 AM Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/6/21 8:49 AM, Ammar Faizi wrote:
>>> Hi everyone,
>>>
>>> This is the v1 of RFC to support build liburing without libc.
>>>
>>> In this RFC, I introduce no libc support for x86-64 arch. Hopefully,
>>> one day we can get support for other architectures as well.
>>>
>>> Motivation:
>>> Currently liburing depends on libc. We want to make liburing can be
>>> built without libc.
>>>
>>> This idea firstly posted as an issue on the liburing GitHub
>>> repository here: https://github.com/axboe/liburing/issues/443
>>>
>>> The subject of the issue is: "An option to use liburing without libc?".
>>
>> This series seems to be somewhat upside down. You should fix up tests
>> first, then add support for x86-64 nolibc, then enable it. You seem to
>> be doing the opposite?
>>
>> -- 
>> Jens Axboe
> 
> Yes, that's what I am doing.
> 
> I agree with add support for x86-64 nolibc, then enable it. However,
> the tests fixes happened very naturally.
> 
> I would not be able to caught those broken tests if I didn't add the
> nolibc support.

Right, but that's exactly why they should get fixed up front! If not,
you've got this weird point in the git tree that doesn't make any sense.
Each patch, when applied, should leave you with a fully functional repo.

> There are two main problems with the tests, all of them are caught
> after adding no libc support.
> 
>   1) The test uses `errno` to check error from liburing functions,
>      this is only problematic with no libc build. I wouldn't be able
>      to caught this without adding no libc support. I caught several
>      tests failed after added no libc support, then investigated the
>      failure causes and found the culprit (it's errno from the libc).
> 
>   2) The test uses `free()` to free the return value of
>      `io_uring_get_probe{,_ring}` functions
>      from liburing. This causes invalid free only for nolibc build.
>      So it does really make sense to add no libc support first, then
>      fix up the tests. Because there is no way I can know this broken
>      situation earlier.

2 is just a plain bug, and was introduced when that probe freeing
function was added. So that's definitely just a separate upfront patch
to fix that.

1 can be fixed too upfront, as it should not cause any changes in
behavior.

> Since now I know everything about the situation, I can do so. So I
> will send the RFC v2 and rebase everything based on your order.

Thanks!

-- 
Jens Axboe

