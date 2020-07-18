Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0353224DD0
	for <lists+io-uring@lfdr.de>; Sat, 18 Jul 2020 22:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgGRUXU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jul 2020 16:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbgGRUXU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jul 2020 16:23:20 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E425FC0619D2
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 13:23:19 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m16so6878383pls.5
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 13:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k3dloabMVGCQAcZZ1gvaHUx/GfB5CrXoSXjBMbYmBuA=;
        b=tKsjIzyT9UoSVf3MEiVYumTnoltFMQhFodbNcyx6tySRKN/qfgUNqz8b9+AZZKMV14
         6EkZCAyh9i77U4TFMThmvlbALUWW628qpOn2RlPBjuKTO1VMdCxBadwYKHNNqlYHpmXg
         8NmkiW6ZXygWMqps7IGs0LAc/jN2Cu0gKApYEwTI3caf9/HRUZ354Jy3zcxNuy5u82Ae
         /ZpiafQeZic/QfKoGDAMoi47BIO77OJv51PqoNeT5B73DlyVKlTHC1/zjBgSLRlC6kYD
         jbe6F0eTnbEK1OCfV52Q0VXTU9iMwPAMaSmcgzGr4dv+LlAcFrLpe5T9xdV9kIaQ7VmS
         A7nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k3dloabMVGCQAcZZ1gvaHUx/GfB5CrXoSXjBMbYmBuA=;
        b=MhKw6gigZMhTW40u6mbkX6X7075HS9CmtraeYorOGnmQM0Ru2xolHNBQyEajAeCy60
         N6jJZJIQC5R3z17Tu17GBRuK1egapwlfFm671PNaKWvR44/r2YpZWsdMCP73awnKG+uB
         6x7NghYHjHDn22Dzv0S0B7DobBDjpxAWBOjU4Ua9MdqQuljS47o7lrpj3PjMdeEvLpr7
         qz7mwyms8QGgfLnB1yj/055NjmKDyHNV/BbF11hcguj25X9X40prscDU5CZ0NbvWwnme
         SQ8GvBt3oBoYYQX0WBWF8x6tQ792/NMXy2INF9JFzNP1eFai6RidOq13NHNMCz1qsMvZ
         0Agg==
X-Gm-Message-State: AOAM533rbc7ytWIOLHjNDTCxPU2j6sUldnAO7kaeV5HVHyQ9pWE5kTt4
        RPHcx/o98Y7W2LaOBuK2Ao6guJzfIfifmg==
X-Google-Smtp-Source: ABdhPJyxeSDLTuSgPdyhdgKN8sR8fFzhie9wEqevScgzkekW2joutx7ZMcNIn1laYD9+Q3YsXIj0Gw==
X-Received: by 2002:a17:902:b496:: with SMTP id y22mr12644333plr.44.1595103799206;
        Sat, 18 Jul 2020 13:23:19 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o8sm5384235pjf.37.2020.07.18.13.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 13:23:18 -0700 (PDT)
Subject: Re: [PATCH] io_files_update_prep shouldn't consider all the flags
 invalid
To:     Daniele Salvatore Albano <d.albano@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAKq9yRh2Q2fJuEM1X6GV+G7dAyGv2=wdGbPQ4X0y_CP=wJcKwg@mail.gmail.com>
 <CAKq9yRiSyHJu7voNUiXbwm36cRjU+VdcSXYkGPDGWai0w8BG=w@mail.gmail.com>
 <bf3df7ce-7127-2481-602c-ee18733b02bd@kernel.dk>
 <CAKq9yRhrqMv44sHK-P_A7=OUvLXf=3dZxPysVrPP=sL43ZGiDQ@mail.gmail.com>
 <4f0f5fba-797b-5505-b4fa-6e46b2b036e6@kernel.dk>
 <CAKq9yRjwp6_hYbG3j11ekAg_1iJ8h_aLM+Kq7uCmgYvOHESFaA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9a7105c2-261b-3c0c-ed03-fa0abec48861@kernel.dk>
Date:   Sat, 18 Jul 2020 14:23:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAKq9yRjwp6_hYbG3j11ekAg_1iJ8h_aLM+Kq7uCmgYvOHESFaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/18/20 11:29 AM, Daniele Salvatore Albano wrote:
> On Fri, 17 Jul 2020 at 23:48, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 7/17/20 4:39 PM, Daniele Salvatore Albano wrote:
>>> Sure thing, tomorrow I will put it together, review all the other ops
>>> as well, just in case (although I believe you may already have done
>>> it), and test it.
>>
>> I did take a quick look and these were the three I found. There
>> shouldn't be others, so I think we're good there.
>>
>>> For the test cases, should I submit a separate patch for liburing or
>>> do you prefer to use pull requests on gh?
>>
>> Either one is fine, I can work with either.
>>
>> --
>> Jens Axboe
>>
> 
> I changed the patch name considering that is now affecting multiple
> functions, I will also create the PR for the test cases but it may
> take a few days, I wasn't using the other 2 functions and need to do
> some testing.

Thanks, I applied this one with a modified commit message. Also note
that your mailer is mangling patches, the whitespace is all damaged.
I fixed it up. Here's the end result:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.8&id=61710e437f2807e26a3402543bdbb7217a9c8620

-- 
Jens Axboe

