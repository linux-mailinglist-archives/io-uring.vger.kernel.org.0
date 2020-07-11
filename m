Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D818F21C4EA
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2020 17:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgGKPzX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jul 2020 11:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbgGKPzW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jul 2020 11:55:22 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97C4C08C5DD
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2020 08:55:22 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mn17so3870282pjb.4
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2020 08:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=alzNp7BjevbmMSm3BIk6CSZIU655udTC00mRpVOaJcU=;
        b=Cj5TBxVGGGkbMkLv00wFrJhDk5HLoGHElAjWUbRmB9ieWRVvfkhc2C//86OSNjr83/
         Tblr4szDl8gImfG3DEBjvy4LGzp3J2xoHQHmv/yyVbd088YADJLIe9zuhdQYcrQ+9QcV
         maolRJjwuNbGbhC9mjw2Gjm6/cvs/Iy/SSNGl4UJkoq3vwR3XmqNbIEpIy05Jz3OH+1J
         +cVt5GEQV69cloV7CUVxmMepPtBWGmTC3j6ZrSlVYLevnKqiZphO7j+/wzTfUNmZaTqF
         meMB/BR/aOcYPb4z33zKcdJp0800XllNnQziEbvjEtifKMEAUEm1JhvPwR1wlSTqyxOo
         oFTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=alzNp7BjevbmMSm3BIk6CSZIU655udTC00mRpVOaJcU=;
        b=cK+N+/uAH3uwy/CIDN43WsQRScNEhOZpm1ABceK3XRq0gbe/gPYs05crOUgp8UlILJ
         QkVtekMgoEew6lsA8lTpfbBrCyWBKtZFhn8Hgo5n8FtFOOlntjACXNpw6curLtd6dak6
         4gdQJVyJRV43uNh0MgfQujTx7TbgJN598B2d0FbijjMlM8x3nZXmFxBNd9fFzjUxSpHv
         IcL1VWUsPktBqJkLlZ/A17hEoNT2OcprIhpE0oJERF1JYQGmnGm8UbwOJlZLjemoC8Zi
         37bLEkAz2ZS9tvACAsMrV3n5N1wC4K+edWmzXUymHU7wWhwiOvMzifDaEstCM9vtXVMB
         GUtg==
X-Gm-Message-State: AOAM530Ncd86gJYlaadhgJGow3ijEp59YBI0Jqq03q5gwxy/uJaJzF6K
        4181/WGzl4Qkr5kcLnbO+s5aM/FzO6KwZQ==
X-Google-Smtp-Source: ABdhPJxs5PyBkf6wVlPLaKhuYSAmrbheVrXPSGtNxPyM+sRRBwSTO9Cix2Z/vzyfr0IkaEuhfVR60w==
X-Received: by 2002:a17:902:9305:: with SMTP id bc5mr21717734plb.21.1594482921729;
        Sat, 11 Jul 2020 08:55:21 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p11sm8709631pjb.3.2020.07.11.08.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 08:55:21 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix sq array offset calculation
To:     Hristo Venev <hristo@venev.name>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     Necip Fazil Yildiran <necip@google.com>, io-uring@vger.kernel.org
References: <20200711093111.2490946-1-dvyukov@google.com>
 <7d4e4f01-17d4-add1-5643-1df6a6868cb3@kernel.dk>
 <CACT4Y+YGwr+1k=rsJhMsnyQL4C+S2s9t7Cz5Axwc9fO5Ap4HbQ@mail.gmail.com>
 <7f128319f405358aa448a869a3a634a6cbc1469f.camel@venev.name>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4620d87d-1862-ed28-9f42-7b98bd49179b@kernel.dk>
Date:   Sat, 11 Jul 2020 09:55:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7f128319f405358aa448a869a3a634a6cbc1469f.camel@venev.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/20 9:52 AM, Hristo Venev wrote:
> On Sat, 2020-07-11 at 17:31 +0200, Dmitry Vyukov wrote:
>> Looking at the code more, I am not sure how it may not corrupt
>> memory.
>> There definitely should be some combinations where accessing
>> sq_entries*sizeof(u32) more memory won't be OK.
>> May be worth adding a test that allocates all possible sizes for
>> sq/cq
>> and fills both rings.
> 
> The layout (after the fix) is roughly as follows:
> 
> 1. struct io_rings - ~192 bytes, maybe 256
> 2. cqes - (32 << n) bytes
> 3. sq_array - (4 << n) bytes
> 
> The bug was that the sq_array was offset by (4 << n) bytes. I think
> issues can only occur when
> 
>     PAGE_ALIGN(192 + (32 << n) + (4 << n) + (4 << n))
>     !=
>     PAGE_ALIGN(192 + (32 << n) + (4 << n))
> 
> It looks like this never happens. We got lucky.

A bit of luck, but if that wasn't the case, then I'm sure we would
have found it when the original patch was tested. But thanks for
double checking!

-- 
Jens Axboe

