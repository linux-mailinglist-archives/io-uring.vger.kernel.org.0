Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133F921C4DA
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2020 17:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgGKPgd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jul 2020 11:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbgGKPgd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jul 2020 11:36:33 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E201C08C5DD
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2020 08:36:33 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p3so3887018pgh.3
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2020 08:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dejdbKm01I5Ix2yckboLsRVAyUy7hDHwkCNLEMyb1jk=;
        b=j3m/+i7zNRW9OusAVG8NTbdnnoFG6OYLMJjREOuBe5Od6m5XOyZfj8HV0ItyJq8xXT
         ry3LkxAca2bchz0eBOathP2at8jZ2De9iLGzViMDXaK8EykFjbdGNJ8oixqDRcg2SgfP
         GeW02sOhpb/Yp0geJ6yITVL9wuRYnOJsCCZfxYFALBAAr7HK9qxAxcZz7sjFJiuHqlXq
         7FLCBhnBH0kgZTCwIVDu0aULotrQ9w7SjZEvFkymJWNCuOohiIraRvwhuS9zWbV4d2z/
         oQ+K0hMmmvJQkx3lB+vpNC95AQk/yOAakVD/qUyVzclLsclSKEOkz9dAjGf+IX7CLDml
         lv8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dejdbKm01I5Ix2yckboLsRVAyUy7hDHwkCNLEMyb1jk=;
        b=HsfKSiilA2p2++j4in0CTiUd9DE63Ava55hVQ6DrH/VQZTBkOIdCD0ydJZFqzDgK0t
         jo6keeaS77ljmlibq1AHqBzoYhzpk4ccANBsZjtJKYbXR/1zBk/9kgZtbteeZU15B2O+
         VGCva/X0Z3KNYVS3MoHXFNeGJynr7e8CLoUrjNBMuP2Fx3qhvKUi8OTffD0IUohpdKlW
         tBuLKawlbs3NiVmUHJZi9oseSnzvASskdTgAFc2NN6wyffDXQbjvgS2NDGgDjtPU633n
         vu/1yjhi+PAHIgVaYEY9cpAv7ef+sH6bM0f7EvquO6VuFVr9AJcmzQDKWuTWcMiaChls
         RdsQ==
X-Gm-Message-State: AOAM53097x3ok09hV+7tGoE9VDfaRB8dqRhw64kK9dDavD6NcFaCWXPv
        8GmFmH5Q28SXgtZJcE4yotaeXA==
X-Google-Smtp-Source: ABdhPJzg8fugGGkRLaCetnAzFuRUlv/Q7LBWYHoous3D2JoCgognS/DQ/4zv9kSNUgRypF3mqm5Mpw==
X-Received: by 2002:a63:d944:: with SMTP id e4mr62316152pgj.376.1594481792478;
        Sat, 11 Jul 2020 08:36:32 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c1sm9733837pje.9.2020.07.11.08.36.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 08:36:31 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix sq array offset calculation
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Necip Fazil Yildiran <necip@google.com>, io-uring@vger.kernel.org,
        Hristo Venev <hristo@venev.name>
References: <20200711093111.2490946-1-dvyukov@google.com>
 <7d4e4f01-17d4-add1-5643-1df6a6868cb3@kernel.dk>
 <CACT4Y+YGwr+1k=rsJhMsnyQL4C+S2s9t7Cz5Axwc9fO5Ap4HbQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <09c57874-9176-0e9d-4260-2072b91275a8@kernel.dk>
Date:   Sat, 11 Jul 2020 09:36:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACT4Y+YGwr+1k=rsJhMsnyQL4C+S2s9t7Cz5Axwc9fO5Ap4HbQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/20 9:31 AM, Dmitry Vyukov wrote:
> On Sat, Jul 11, 2020 at 5:16 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 7/11/20 3:31 AM, Dmitry Vyukov wrote:
>>> rings_size() sets sq_offset to the total size of the rings
>>> (the returned value which is used for memory allocation).
>>> This is wrong: sq array should be located within the rings,
>>> not after them. Set sq_offset to where it should be.
>>>
>>> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
>>> Cc: io-uring@vger.kernel.org
>>> Cc: Hristo Venev <hristo@venev.name>
>>> Fixes: 75b28affdd6a ("io_uring: allocate the two rings together")
>>>
>>> ---
>>> This looks so wrong and yet io_uring works.
>>> So I am either missing something very obvious here,
>>> or io_uring worked only due to lucky side-effects
>>> of rounding size to power-of-2 number of pages
>>> (which gave it enough slack at the end),
>>> maybe reading/writing some unrelated memory
>>> with some sizes.
>>> If I am wrong, please poke my nose into what I am not seeing.
>>> Otherwise, we probably need to CC stable as well.
>>
>> Well that's a noodle scratcher, it's definitely been working fine,
>> and I've never seen any out-of-bounds on any of the testing I do.
>> I regularly run anything with KASAN enabled too.
> 
> Looking at the code more, I am not sure how it may not corrupt memory.
> There definitely should be some combinations where accessing
> sq_entries*sizeof(u32) more memory won't be OK.
> May be worth adding a test that allocates all possible sizes for sq/cq
> and fills both rings.

Yeah, actually doing that right now just to verify it.

-- 
Jens Axboe

