Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFCF323673
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 05:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhBXEeW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 23:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbhBXEeV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 23:34:21 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5023CC06174A
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 20:33:41 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id s16so431066plr.9
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 20:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lRItJ18w8D6fDXbtJfgkIc5az0f5zbFgwI9IOwjcWdg=;
        b=VluGEBfO8w8z13Kipg/YkcyFnEXzutcSQsFn98mW2rP6xQ3khA3XVclKoxM0kK9fq+
         S9GOT7HSi1jL/lkULoLnVBN8JLzyXLvhX9oRSfduXmeQLgokCo2X57i4zWc4qKwxQLH4
         lBATxWQB2HppFGW1a3HdDWGRhg+vlAU9bEvX65FsanxpTWovUGJYIqshcdyu8pVaUefW
         gyIS29hK+2AsHz2qEvi9Z2nuxZlk8q5oXqcg2bikwJOwVRsVDrzp5tWau9WL0OvTGxQ0
         DopXHx7Q8I0PaYBpbfVHJCf8ehkezloPaB0MJFOWTWx+Oh54y2H5DCJSSU5Yz4ZSx57j
         k9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lRItJ18w8D6fDXbtJfgkIc5az0f5zbFgwI9IOwjcWdg=;
        b=DKYViwJl2yBvR+4yQPJIg9whKTRRQHsfQbvl+tiR1jpQRQqiLpqpcnQX4XaiY4q1xB
         VxhxK3PmrYkX8sLTGySP0xSYeKdxAiWRFDewc0UjlcnFomcf6oUAYfyWXCDa3uf0cW6W
         J0CP+LfYJPePglfruceTNpNVVyX3unYg38JqyKT/+N+3xIUbogP1NT+NtndHE8Bdccf2
         KXqdTHu5FNsqrUllCjjLo82y8E5yM47FFiMzTD8ZcLSZb98Qt2d4h/q3i4hHXt2nfEQF
         SN51QE7pBhXWdhShYDoDeen4gvVhHVYLNBDYU+VgRtmTKvi1jRr/aj663WsYrMIPLfev
         T7lQ==
X-Gm-Message-State: AOAM532wWmrHZZVyzy5Xy+wbSihLVBEx6BHGcSwP6xOdCU47Q25wvRqX
        MfTHL/ib/vBGNqpuRWX1dE97oD+OnS0NLg==
X-Google-Smtp-Source: ABdhPJwZK51H2LVpnzM3w9606kb7qR/KTKeNUkbrwpwtFTIVWsTugQzOwvA1Fgu/lxKpRMcBVCB8aw==
X-Received: by 2002:a17:90a:2ec6:: with SMTP id h6mr2389987pjs.103.1614141220445;
        Tue, 23 Feb 2021 20:33:40 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d73sm837752pfd.0.2021.02.23.20.33.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 20:33:40 -0800 (PST)
Subject: Re: io_uring_enter() returns EAGAIN after child exit in 5.12
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20210224032514.emataeyir7d2kxkx@alap3.anarazel.de>
 <db110327-99b5-f008-2729-d1c68483bff1@kernel.dk>
 <20210224043149.6tj6whjfjd6ihamz@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d630c75f-51d4-abb4-46b3-c860a6105e4b@kernel.dk>
Date:   Tue, 23 Feb 2021 21:33:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210224043149.6tj6whjfjd6ihamz@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/21 9:31 PM, Andres Freund wrote:
> Hi,
> 
> On 2021-02-23 20:35:09 -0700, Jens Axboe wrote:
>> On 2/23/21 8:25 PM, Andres Freund wrote:
>>> Hi,
>>>
>>> commit 41be53e94fb04cc69fdf2f524c2a05d8069e047b (HEAD, refs/bisect/bad)
>>> Author: Jens Axboe <axboe@kernel.dk>
>>> Date:   2021-02-13 09:11:04 -0700
>>>
>>>     io_uring: kill cached requests from exiting task closing the ring
>>>
>>>     Be nice and prune these upfront, in case the ring is being shared and
>>>     one of the tasks is going away. This is a bit more important now that
>>>     we account the allocations.
>>>
>>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>>
>>> causes EAGAIN to be returned by io_uring_enter() after a child
>>> exits. The existing liburing test across-fork.c repros the issue after
>>> applying the patch below.
>>>
>>> Retrying the submission twice seems to make it succeed most of the
>>> time...
>>
>> Oh that's funky, I'll take a look.
>  
> It was fixed in
> 
> commit 8e5c66c485a8af3f39a8b0358e9e09f002016d92
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   2021-02-22 11:45:55 +0000
> 
>     io_uring: clear request count when freeing caches

Yep, thanks for confirming. Didn't immediate connect them, but I guess
any sort of oddity is possible before that fix with the caches.

> Jens, seems like it'd make sense to apply the test case upthread into
> the liburing repo. Do you want me to open a PR?

I think so, it's a good addition. Either a PR or just an emailed patch,
whatever you prefer. Well, the previous email had whitespace damage,
so maybe a PR is safer :-)

-- 
Jens Axboe

