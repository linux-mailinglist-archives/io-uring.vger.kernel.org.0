Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D1852BC1A
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 16:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbiERMtA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 08:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237107AbiERMsn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 08:48:43 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA65E2611B
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 05:48:40 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id q4so1643983plr.11
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 05:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ehXZOPVyZk1nus82q5s2HUzBV5cWyOlGby8E7ZgBsH8=;
        b=n+dYYpmEbEuDZDMWINB9qgjmrGA2e+6HehjiARKXnNU+Md+FX+jVuDzSbVQRrjoVNP
         AEX+jnGVvvSsUCVfb7fiA/IE2U2qitshHcHaQtErEw0bCWJTZ+VyP6yX0PfxOhXIFENz
         ADOuk+DKcF0fE56hbGoyLhxYs4mP81Nzh+n3C5RZ63/N7RB4C5r66D2h1A8w3cx5i/JD
         FhxBBA1ydCi53gGCt4hh+M2nvPbdqt7bsQAUtO76WQCcmXKBC53R/wyuhx4vLzLCUcrG
         vlKE9ndAo0+xVQjLbp4LTd9Q29lP45Hmp/JOtNSRyZxifcvypADsACTUGF9WnSxd1Bd8
         g1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ehXZOPVyZk1nus82q5s2HUzBV5cWyOlGby8E7ZgBsH8=;
        b=sHTe1o5EceQce4/Puac284yfx2KlGmarDgfTnkY+0X/9ZrcNKPmkIgpuhfBPMHDBf6
         7qbjt8fGxC9p7g0kRbA0L7/gKjDwcepLxd9BOulJDM1EE0bfXbnCvknSaDHo1tRMS+0a
         YDDydu7r6ATrJxaSJKZxXfRzMM+8KotHO8iZIHdR/VpfO9v02vZ4sd91dhzwX3nNLl8w
         JEN+8e+JjqOzfz32ip7Hn6AqWpHbrOoJ8tfICPcG7o69d41gMz0iUyrQ8B+quIi4Fb6n
         6Ws4/Qyh6dyGQvQtIFSJvwJa7ieysrfV/d1SUT79eKreN+TsbmuHf7x7dji1zBPM/GOp
         nO4Q==
X-Gm-Message-State: AOAM533NoeBZuevQ4I9J8XkBk3YxyRMPMIX9rvsvERF4BqSvFCXb+Apd
        y3L5xUV24k4gzBxNz5B3BEZqnoyy37XuEg==
X-Google-Smtp-Source: ABdhPJyOiyqGOK6BiMcM1SvA+eI6uXShw+E/sM7p27Gd6YZ+Cot8Kix9ZnYWf8AvBzynHuBA3pmvnA==
X-Received: by 2002:a17:903:32cc:b0:161:9539:fd49 with SMTP id i12-20020a17090332cc00b001619539fd49mr11595480plr.117.1652878120041;
        Wed, 18 May 2022 05:48:40 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d62-20020a623641000000b0050dc76281f0sm1787399pfa.202.2022.05.18.05.48.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 05:48:39 -0700 (PDT)
Message-ID: <d36ea4ca-b2bb-511d-6440-a3e43f05e24d@kernel.dk>
Date:   Wed, 18 May 2022 06:48:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 3/3] io_uring: add support for ring mapped supplied
 buffers
Content-Language: en-US
To:     Hao Xu <haoxu.linux@icloud.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Dylan Yudaken <dylany@fb.com>
References: <20220516162118.155763-1-axboe@kernel.dk>
 <20220516162118.155763-4-axboe@kernel.dk>
 <131d7543-b3bd-05e5-1a4c-e386368374ac@icloud.com>
 <8394fddb-ef44-b591-2654-2737219d2b8a@kernel.dk>
 <f1c6963f-9a53-db2c-3166-180800f14723@icloud.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f1c6963f-9a53-db2c-3166-180800f14723@icloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/18/22 4:50 AM, Hao Xu wrote:
>> This is known at compile time, so the compiler should already be doing
>> that as it's a constant.
>>
>>>> +        buf = page_address(bl->buf_pages[index]);
>>>> +        buf += off;
>>>> +    }
>>>
>>> I'm not familiar with this part, allow me to ask, is this if else
>>> statement for efficiency? why choose one page as the dividing line
>>
>> We need to index at the right page granularity.
> 
> Sorry, I didn't get it, why can't we just do buf = &br->bufs[tail];
> It seems something is beyond my knowledge..

The pages might not be contigious, we have to index from the right page.

-- 
Jens Axboe

