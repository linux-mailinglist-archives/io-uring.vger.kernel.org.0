Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1160E39BACA
	for <lists+io-uring@lfdr.de>; Fri,  4 Jun 2021 16:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhFDOTK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Jun 2021 10:19:10 -0400
Received: from mail-ej1-f41.google.com ([209.85.218.41]:42889 "EHLO
        mail-ej1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhFDOTJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Jun 2021 10:19:09 -0400
Received: by mail-ej1-f41.google.com with SMTP id k25so9258945eja.9;
        Fri, 04 Jun 2021 07:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BxgumMgzhDjL0lr/zHcx8CCLu0Hsz3srHrbkQdXC+6I=;
        b=NAv/5WhdpFGP4ZJKd43WO/ifv2dibJLXgz5PRhZYn2UUQqAlDCwtFLNrXpgtLjorHv
         EH3cQrvWWte34yAdoroXGbxoHWv0737cY90bA9Lu8HZB9+WQ8Tw9ezElSc8kOd6XPCbV
         irA7V1kESizVdiZn2lONPgXgOa3lXcBFiDVl2OddaMt2ZuonFu2hF9zKqqo8cckI8KDG
         6HZjHr3EuNaqGBzulYV87xq0gdKr1Vd9Fm1j4AbQ1WtXlLPMS2e+O/44SaZ3YnIuu2oL
         LIZdWxPLOJLQw2PO/jmNDxRbHnKhibhzBnqQ2/RrizwbOOOQ0XAd3iQtE95AXktpw69b
         vBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BxgumMgzhDjL0lr/zHcx8CCLu0Hsz3srHrbkQdXC+6I=;
        b=ZjlmPhBh2GzFakV5ADqOs155EdP+E0Q9Vk3LoELwLRvPP64ahJWmvdUQDN4pGd7qLR
         pP3QaIjARUVgxthaL+FunBaF1jpql2zmMRDueYuBckKdQatNJXFnYWAjpkCNa4MsoLUl
         4xDXMmlk2yZVJUSFaAnPF/tkhqvQlKC8p95gy+yqg6fVI3uQhooGJrI8p+rSOadgQCH7
         2VrJLYLLKWN0As/qOKeRtgmnkJI0VdeInl66IymgzOy5mTa9/QNtFxAVZ0XZDvQuGRdn
         am26b+kUHcC4tDL/ytO+edlY6shZxtCTcmy4mT4agTbki8o2lidLcNdBJhWMyvWJS/zK
         ZijQ==
X-Gm-Message-State: AOAM533FSxIST0yy54pfXcUOxgWrOBhMQOyMry3YytaPuqlSgVvrB1Wx
        j5B3xNdJb/D/pfyGgRsqoJmEmXPmDS42SwD/
X-Google-Smtp-Source: ABdhPJzzXXd13cbkvg/19J8P9IENnt57vEjvQSmDx8Wp+JUBknE+hONtbS65kbKgwgLjP9GTy0j4/Q==
X-Received: by 2002:a17:906:4089:: with SMTP id u9mr4373948ejj.478.1622816182529;
        Fri, 04 Jun 2021 07:16:22 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:b808])
        by smtp.gmail.com with ESMTPSA id e22sm3354036edv.57.2021.06.04.07.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 07:16:22 -0700 (PDT)
Subject: Re: Memory uninitialized after "io_uring: keep table of pointers to
 ubufs"
To:     Andres Freund <andres@anarazel.de>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210529003350.m3bqhb3rnug7yby7@alap3.anarazel.de>
 <d2c5b250-5a0f-5de5-061f-38257216389d@gmail.com>
 <20210603180612.uchkn5qqa3j7rpgd@alap3.anarazel.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <9fa5c0f2-ff28-3775-9f4e-6a1cec06f151@gmail.com>
Date:   Fri, 4 Jun 2021 15:16:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210603180612.uchkn5qqa3j7rpgd@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/3/21 7:06 PM, Andres Freund wrote:
> Hi,
> 
> On 2021-05-29 12:03:12 +0100, Pavel Begunkov wrote:
>> On 5/29/21 1:33 AM, Andres Freund wrote:
>>> Hi,
>>>
>>> I started to see buffer registration randomly failing with ENOMEM on
>>> 5.13. Registering buffer or two often succeeds, but more than that
>>> rarely. Running the same program as root succeeds - but the user has a high
>>> rlimit.
>>>
>>> The issue is that io_sqe_buffer_register() doesn't initialize
>>> imu. io_buffer_account_pin() does imu->acct_pages++, before calling
>>> io_account_mem(ctx, imu->acct_pages);
>>>
>>> Which means that a random amount of memory is being accounted for. On the first
>>> few allocations this sometimes fails to fail because the memory is zero, but
>>> after a bit of reuse...
>>
>> Makes sense, thanks for digging in. I've just sent a patch, would
>> be great if you can test it or send your own.
> 
> Sorry for the slow response, I'm off this week. I did just get around to
> test and unsurprisingly: The patch does fix the issue.

Yep, since you already narrowed it down. Thanks for testing

-- 
Pavel Begunkov
