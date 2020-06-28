Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA07F20C83D
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 15:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgF1NfX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 09:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgF1NfW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 09:35:22 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD483C061794
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 06:35:22 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y18so6071654plr.4
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 06:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Aergpb/cU3gx4e9rmGRckKA9xNOu6AknoMCbXdWR/Fs=;
        b=1UeE5FptmBto+XqZoNWSylzrAuyayT71lMoc4tRXfK10PjycuL5d6y1vw4LyVnjc62
         38LrbZOzBO4AmIGiB5Ld2snwdcL/MP6saVQ+mkuuXCLIGUbLXxIucTjv4FKcwyWtsF4a
         giqgYHzFTt8kpWb6UwZ5ctUwhUcuFAeu59v4uqv+71vb3Dd/DtuiaSwMl0MSWX2Ezeo8
         TCWZtTRqwE0ZUh1cv7oLWfByF3Yx/N/GazM6KlvWGgEMDJj5e27Els4bFWRGAx8kwQkv
         RDQyWXRKnov5g7FnYtn791O+30sRdbT1eNv7+EgsvdlA/4q4UKt85mz/C8UEbeM44lCx
         zUgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Aergpb/cU3gx4e9rmGRckKA9xNOu6AknoMCbXdWR/Fs=;
        b=haU2TAFWU3Q6n5Ro4mDyBiaAbVdJNT3nbLv08BNVIoF2IY9jnlm6s37Bsss+E32y8V
         qGSqLRLAlNBfvoegcnEldRyGHyEZ4p7pLgaeR5+JkCRE7m4gtOnhHabbEbWQ3GHQQgcK
         NplkT2xoakyUpTvM7AHHQCYQwmTeppxzNWwTsCvdXCVEHh+sY7ah6NCrCSJvQtcB6Au4
         JSVQ3bU0R52Uf7nxC/wXkSitqrgheWlNhbVVN7fhURT/5FdwHWyFQrfynVKqS2aih6vf
         bMZRoEPE8wWRIb9eRg0OUHZhTtMKJiBjwryZvFfwAldtMnAkGq6SepOy4lwquOcN9d/Z
         PDdw==
X-Gm-Message-State: AOAM532HgBS+q7IyB4a+8zU4pUQbmKuxjI0SInQvXhOHO6tJMGk9n5OS
        9SX4MzewBfGKnSrdzEe2sJglY75qnwXu+A==
X-Google-Smtp-Source: ABdhPJxVprXcM5+y4IPoD9dO/zYvUmNXJdsaBb+a7Y1quhhjEr1D+ig5A2hQf4xBFbkNxW+Q0l+GkA==
X-Received: by 2002:a17:90a:db87:: with SMTP id h7mr13883192pjv.159.1593351321158;
        Sun, 28 Jun 2020 06:35:21 -0700 (PDT)
Received: from [192.168.86.197] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id 202sm7291032pfw.84.2020.06.28.06.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 06:35:20 -0700 (PDT)
Subject: Re: [RFC PATCH] Fix usage of stdatomic.h for C++ compilers
To:     Bart Van Assche <bvanassche@acm.org>,
        Hrvoje Zeba <zeba.hrvoje@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <20200627055515.764165-1-zeba.hrvoje@gmail.com>
 <b83a2cc5-31ea-9782-1eeb-70b8537f92c3@acm.org>
 <CAEsUgYj6NDoHPHN+i7tsR5P0tj1Dj47ixJFhFf8UVpm7kagfhg@mail.gmail.com>
 <c9603711-18c6-217b-ced0-cc1fefec0c6e@acm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2b8e0c20-5da5-ee59-5159-b12bad88e244@kernel.dk>
Date:   Sun, 28 Jun 2020 07:35:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <c9603711-18c6-217b-ced0-cc1fefec0c6e@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/27/20 10:23 AM, Bart Van Assche wrote:
> On 2020-06-27 08:39, Hrvoje Zeba wrote:
>> Any suggestions?
> 
> How about the two attached (untested) patches?

Bart, this looks good to me. I've pushed out a change to detect if we
have C++ on the system, as I don't want to make it a hard requirement.
When you send these out "officially", can you make the addition of the
sq-full-cpp dependent on CONFIG_HAVE_CXX in test/Makefile?

-- 
Jens Axboe

