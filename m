Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACA221C4E4
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2020 17:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgGKPrJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jul 2020 11:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbgGKPrJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jul 2020 11:47:09 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC359C08C5DD
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2020 08:47:08 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id b9so3465775plx.6
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2020 08:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jxMjkqN1zCXHmIxhYd7vQaL5SxQgJ4Y1Ox07mYbjzBk=;
        b=C76noFlcqllIAvQI0LGUH0EIjE/XivNVK8ZU2oSL/+O3iO2wt75+wSb1Iez+Qpy4O6
         sxS0QMuEPXccBhWZcgYHVKLx97GpO6JTAmw6TtQdaeg7rFkj5KqYqgWdf5h0DmTQxZr3
         CObtkl4ZiyeTrV52usbOUd2XClBmMNbttJ3Q6mYomtQyZRGyBC08FmQ6F3UqaLswvPhF
         9pgihF5GmQLcz4FcRwk70in0/kA6pr0KVEW67kIjIQogvnOkj1b5UCD1bibZi1cvKwDb
         eRfVA2KIpw1uWGV5ME47LPK5LSMW3XIED2JVXuNtYNMxEWXFb4bWBKer/0X8+qACZSlz
         uu3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jxMjkqN1zCXHmIxhYd7vQaL5SxQgJ4Y1Ox07mYbjzBk=;
        b=nhs9rTQj2MaxhP2uC+woQ5JDpRSyRB03UE9vdSZqe+ipf7AyA/GB7QQZYfd2ZTxNGU
         Rez+v6stVfrT6c3JGKvb7B/fPz0wqOfAoZOz2FZghO0a4PH8MXFvZkX7xOQDfn0FXxZU
         uIbT3BHs4DWgAzwyPSJFdZDFNLooKu+V1+0HCRgaURdxxoRCxSu2WcrlqJnE9g+WpZFX
         BnYb0qVtSXTTTfx9qHjHsjZnyYco2hvjTPIVh438BSxF3dhjDO/x3NZPLsYyX7ZhsMGH
         puuo5KwMc+PGnCu/kKj8Nty8RJurQ2U55T58pGihCXxsqeD2AkMmFoIyNR0XZ5cWRQy8
         GnTA==
X-Gm-Message-State: AOAM530s4wQ7Em18L7gPgB3zknrS5A5oSXe3t2w+V/4FFTo8GathtY+w
        a445sKNJvcYpRRqUGX7/qi6Sww==
X-Google-Smtp-Source: ABdhPJwrOhdpGJ4la2rIv/FAasHVZ8ciiDiBtGgQsWkeWlY1RHjqcOPzNn1SDMsGRY8P76SH/CtToQ==
X-Received: by 2002:a17:90b:11d8:: with SMTP id gv24mr11141974pjb.131.1594482428235;
        Sat, 11 Jul 2020 08:47:08 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s194sm9065668pgs.24.2020.07.11.08.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 08:47:07 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix sq array offset calculation
From:   Jens Axboe <axboe@kernel.dk>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Necip Fazil Yildiran <necip@google.com>, io-uring@vger.kernel.org,
        Hristo Venev <hristo@venev.name>
References: <20200711093111.2490946-1-dvyukov@google.com>
 <7d4e4f01-17d4-add1-5643-1df6a6868cb3@kernel.dk>
 <CACT4Y+YGwr+1k=rsJhMsnyQL4C+S2s9t7Cz5Axwc9fO5Ap4HbQ@mail.gmail.com>
 <09c57874-9176-0e9d-4260-2072b91275a8@kernel.dk>
Message-ID: <ce790156-2faa-637b-2dbd-bddc853564e3@kernel.dk>
Date:   Sat, 11 Jul 2020 09:47:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <09c57874-9176-0e9d-4260-2072b91275a8@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/20 9:36 AM, Jens Axboe wrote:
> On 7/11/20 9:31 AM, Dmitry Vyukov wrote:
>> On Sat, Jul 11, 2020 at 5:16 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 7/11/20 3:31 AM, Dmitry Vyukov wrote:
>>>> rings_size() sets sq_offset to the total size of the rings
>>>> (the returned value which is used for memory allocation).
>>>> This is wrong: sq array should be located within the rings,
>>>> not after them. Set sq_offset to where it should be.
>>>>
>>>> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
>>>> Cc: io-uring@vger.kernel.org
>>>> Cc: Hristo Venev <hristo@venev.name>
>>>> Fixes: 75b28affdd6a ("io_uring: allocate the two rings together")
>>>>
>>>> ---
>>>> This looks so wrong and yet io_uring works.
>>>> So I am either missing something very obvious here,
>>>> or io_uring worked only due to lucky side-effects
>>>> of rounding size to power-of-2 number of pages
>>>> (which gave it enough slack at the end),
>>>> maybe reading/writing some unrelated memory
>>>> with some sizes.
>>>> If I am wrong, please poke my nose into what I am not seeing.
>>>> Otherwise, we probably need to CC stable as well.
>>>
>>> Well that's a noodle scratcher, it's definitely been working fine,
>>> and I've never seen any out-of-bounds on any of the testing I do.
>>> I regularly run anything with KASAN enabled too.
>>
>> Looking at the code more, I am not sure how it may not corrupt memory.
>> There definitely should be some combinations where accessing
>> sq_entries*sizeof(u32) more memory won't be OK.
>> May be worth adding a test that allocates all possible sizes for sq/cq
>> and fills both rings.
> 
> Yeah, actually doing that right now just to verify it.

Did that, full utilization of the sq ring and the cq ring, and not
seeing anything trigger or wrong. I'd need to look closer, but it
just might be that the power-of-2 sizes end up saving us from doom
and gloom.

-- 
Jens Axboe

