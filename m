Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A7F2818E0
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 19:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgJBRKp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 13:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgJBRKo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 13:10:44 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F2DC0613D0
        for <io-uring@vger.kernel.org>; Fri,  2 Oct 2020 10:10:44 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l15so1534385wmh.1
        for <io-uring@vger.kernel.org>; Fri, 02 Oct 2020 10:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nZAeF5Z44GdRlYOz7AD0tWVSZr9SU7mXTBbKWSd8wdY=;
        b=R/Gis1UnsskolYMXvqLN+gup1+e6NJ8Z+RKInwJYXMbKn9AIOYqHPkEmYtMtkaNR5c
         qEwctZu65hbMXibdvjl3fo0Ny04jFrGmE82lE7pr9QvnQYaAK+vqucoziGn/FNLae236
         VfjbgtSFNihyxzEtH3UJBOYADERdear11oNKk67DD+Vfp5lNq0D4AtFzLUoLxliGGpq6
         g/emX1ZSOJMGMvC85nNGam1QMu43bcE0y6wJb2ybDk37ktimPbXOaAjDBNxDCTmE7Uc9
         PDVnnULBwtKtjpbibb5wW7FYtFDhTm/Fi9o3a7b0XI9Y77nhAI3+IJ10gvYiODg21Pw0
         JGjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nZAeF5Z44GdRlYOz7AD0tWVSZr9SU7mXTBbKWSd8wdY=;
        b=EahuMIInDCnf/3XZRCpk6ge6Zfoa+S6MOxP3amuq0Kqycr8oGBNzYBlRew52vAUhHE
         giJFB6+/t92gPjMYPwDKn9PF1ktdTlmsYZz7L+sKuwl9kUXKZQ27TCUTbR+kFHkvxN6Z
         3hP1s48mZakoiPkh8y3mTujHjd4wTVhPERzmiZY9OuEqqUTyUiAq5a31cwjtK3NP9G/b
         azulXOdP1co1jALFi7GZDW+4l0/SuxrFfeVs/8vKpEK6YevercaNkBBTtAr24VNHi3ZT
         CKQQOyQq4LWhR5Cxoq/GzMtp6mfnoI56WppCvELD8KxxXseNppMdH0iS3TmNNUvsZtfh
         B3XQ==
X-Gm-Message-State: AOAM5317U7ZhruStJqRdo49yh/M7BG12TEZF/9+oqBZIOf3O+OuxhKpC
        nd10jenYRYLAedghqczjcBbcZaIlwCc=
X-Google-Smtp-Source: ABdhPJwCtqIIb7ZEy5XEZ7pIdq+ATlgTIk1x5fbsFk04lmv5LIfvrfVs7gcw3XH3zxZ2LY1SJ3388w==
X-Received: by 2002:a7b:c182:: with SMTP id y2mr4111340wmi.21.1601658640923;
        Fri, 02 Oct 2020 10:10:40 -0700 (PDT)
Received: from [192.168.1.151] (host109-152-100-140.range109-152.btcentralplus.com. [109.152.100.140])
        by smtp.gmail.com with ESMTPSA id t16sm2702563wmi.18.2020.10.02.10.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 10:10:39 -0700 (PDT)
Subject: Re: [PATCH 1/5] io_uring: grab any needed state during defer prep
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20200914162555.1502094-1-axboe@kernel.dk>
 <20200914162555.1502094-2-axboe@kernel.dk>
 <77283ddd-77d9-41e1-31d2-2b9734ee2388@gmail.com>
 <79e9d619-882b-8915-32df-ced1886e1eb3@gmail.com>
 <f61a349a-8348-04a3-fc4d-0a15344664fd@gmail.com>
 <6f514236-a584-e333-3ce2-8fd63c69c9c3@gmail.com>
 <f95eb757-795a-adcc-e4ea-e0a783d62a29@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <3f681c72-2e42-279e-437f-8f4a6ab78dee@gmail.com>
Date:   Fri, 2 Oct 2020 20:08:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <f95eb757-795a-adcc-e4ea-e0a783d62a29@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/10/2020 20:01, Jens Axboe wrote:
> On 10/2/20 10:34 AM, Pavel Begunkov wrote:
>> On 02/10/2020 19:14, Pavel Begunkov wrote:
>>> On 19/09/2020 19:56, Pavel Begunkov wrote:
>>>> On 19/09/2020 18:27, Pavel Begunkov wrote:
>>>>> On 14/09/2020 19:25, Jens Axboe wrote:
>>>>>> Always grab work environment for deferred links. The assumption that we
>>>>>> will be running it always from the task in question is false, as exiting
>>>>>> tasks may mean that we're deferring this one to a thread helper. And at
>>>>>> that point it's too late to grab the work environment.
>>>> Forgot that they will be cancelled there. So, how it could happen?
>>>> Is that the initial thread will run task_work but loosing
>>>> some resources like mm prior to that? e.g. in do_exit()
>>>
>>> Jens, please let me know when you get time for that. I was thinking that
>>> you were meaning do_exit(), which does task_work_run() after killing mm,
>>> etc., but you mentioned a thread helper in the description... Which one
>>> do you mean?
>>
>> Either it refers to stuff after io_ring_ctx_wait_and_kill(), which
>> delegates the rest to io_ring_exit_work() via @system_unbound_wq.
> 
> We punt the request to task_work. task_work is run, we're still in the
> right context. We fail with -EAGAIN, and then call io_queue_async_work()
> and we're not doing async prep at that point.

I'm missing something. io_queue_async_work() calls io_prep_async_link()
-> io_prep_async_work() before actually queuing.

-- 
Pavel Begunkov
