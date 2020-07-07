Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677DE216E21
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 15:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgGGN4f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 09:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgGGN4f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 09:56:35 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196E5C061755
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 06:56:35 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id a6so19313157ilq.13
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 06:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CVzc3mlM7yVgAoPHG9szyLaVedvwSqHUI397oh9woAA=;
        b=e414SfdeHAvt9RzQXAVY5e3drYBtvGn96vWCF9IWmZD9zns2dFesKwhzwGBkLOE6Kb
         ducE735EmCE1DUEQdPzyn5qauNHR22JuAs7GK4DQ+wEHAWRddJGL0F/nR/X6IM/UI4A2
         1Uxjj3dt10+0xhhxD4EvDg2JtGhwIv4+Y+nOHu2WZjXk3qHJLM6BlUd8oWsR97/mhrav
         Je+uSCereRKowZxUxLUHyoqgolj9bCUNMSJ+3G4iAehtfMQjYqtlkHEK0Fcw+V5xASiY
         xyfiLP/SxDKm4qQXaOeeGevlcY3GV33B/pxcoaPx7i1S4Cmu5pcdNye10Y4owZqE8Cf6
         gBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CVzc3mlM7yVgAoPHG9szyLaVedvwSqHUI397oh9woAA=;
        b=TjAPCjCjKVhoRA9D01MYTfMuGNEADxS8vNl0FjnfnsNjuvR0IpXSHKJK8vcG2Crpo4
         a+E3CeG+0n+y/i+LCDhvrcXe/45en9+KmnrHgzIFJ4AeXtACTVs5SOhVV/6dOe+U5y6G
         IjUTHUhakKK8wxhTza4w728oN54pRO/8FRdE0Vn7sqFu1UpIsuLa0AJfYMeMhzNDziaG
         EfbQIMVCpbfoKh6OJCcYwntZOYnNH+9uUMvbSJT1E/bLJChaCAJNzZC1tlVsU0LOnemo
         vPmj53VC/PVk2sW+/StJEfd1WGWWk1fatgb40+FI55+xK78M4UWs9F5hTnFIyQZKn1MP
         4uEw==
X-Gm-Message-State: AOAM531Tu7JWwscukemoQWN7EnCilKORGoaSD+3nQiiCRzMoEi3yb4Ei
        jdIxbK+oMaMwj0xcKHOakWPNKgtL5rZHMg==
X-Google-Smtp-Source: ABdhPJxlLF+THNwLSZYDzmnRL+Bxbylgs44tMnv9sL3H22hdiZX+he6/RM5n3FjI4UxDDtW9IIErmA==
X-Received: by 2002:a92:d812:: with SMTP id y18mr26048570ilm.286.1594130194158;
        Tue, 07 Jul 2020 06:56:34 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i9sm13204340ile.48.2020.07.07.06.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 06:56:33 -0700 (PDT)
Subject: Re: [PATCH 5/5] io_uring: fix use after free
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>
References: <cover.1593424923.git.asml.silence@gmail.com>
 <1221be71ac8977607748d381f90439af4781c1e5.1593424923.git.asml.silence@gmail.com>
 <CAG48ez2yJdH3W_PHzvEuwpORB6MoTf9M5nOm1JL3H-wAnkJBBA@mail.gmail.com>
 <f7f4724d-a869-c867-ad8e-b2a59e89c727@gmail.com>
 <CAG48ez3fR1QyVXapvwbYzbtv4AEb0BY2ebKsV7vNFLE-6NaUQA@mail.gmail.com>
 <4f5ecae5-8272-04aa-775e-293dfef82383@gmail.com>
 <463baa76-18ef-b98a-070f-416cdf00250d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <92724ba5-956c-8308-a3a6-c6ec058e3cfd@kernel.dk>
Date:   Tue, 7 Jul 2020 07:56:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <463baa76-18ef-b98a-070f-416cdf00250d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/7/20 6:46 AM, Pavel Begunkov wrote:
> On 04/07/2020 09:49, Pavel Begunkov wrote:
>> On 04/07/2020 00:32, Jann Horn wrote:
>>> On Fri, Jul 3, 2020 at 9:50 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>> On 03/07/2020 05:39, Jann Horn wrote:
>>>>> On Mon, Jun 29, 2020 at 10:44 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>>> After __io_free_req() put a ctx ref, it should assumed that the ctx may
>>>>>> already be gone. However, it can be accessed to put back fallback req.
>>>>>> Free req first and then put a req.
>>>>>
>>>>> Please stick "Fixes" tags on bug fixes to make it easy to see when the
>>>>> fixed bug was introduced (especially for ones that fix severe issues
>>>>> like UAFs). From a cursory glance, it kinda seems like this one
>>>>> _might_ have been introduced in 2b85edfc0c90ef, which would mean that
>>>>> it landed in 5.6? But I can't really tell for sure without investing
>>>>> more time; you probably know that better.
>>>>
>>>> It was there from the beginning,
>>>> 0ddf92e848ab7 ("io_uring: provide fallback request for OOM situations")
>>>>
>>>>>
>>>>> And if this actually does affect existing releases, please also stick
>>>>> a "Cc: stable@vger.kernel.org" tag on it so that the fix can be
>>>>> shipped to users of those releases.
>>>>
>>>> As mentioned in the cover letter, it's pretty unlikely to ever happen.
>>>> No one seems to have seen it since its introduction in November 2019.
>>>> And as the patch can't be backported automatically, not sure it's worth
>>>> the effort. Am I misjudging here?
>>>
>>> Use-after-free bugs are often security bugs; in particular when, as in
>>> this case, data is written through the freed pointer. That means that
>>> even if this is extremely unlikely to occur in practice under normal
>>> circumstances, you should assume that someone may invest a significant
>>> amount of time into engineering some way to make this bug happen. If
> 
> Jens, how would you prefer to handle this for 5.8? I can send a patch, but
> 1. it's fixed in for-5.9
> 2. it would be a merge conflict regardless of 1.

Given the type of bug and conditions required to trigger it, I think we
should just send it in for stable once it lands in 5.9. We need GFP_KERNEL
allocations to fail, the fallback req the last to be released, the ctx
freed (and reused) in an extremely short window.

If it was more severe or easier to trigger, then we could deal with the
pain of the conflict. But I don't think it's worth it for this one.

-- 
Jens Axboe

