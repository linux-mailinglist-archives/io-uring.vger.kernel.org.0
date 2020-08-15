Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BF12452EA
	for <lists+io-uring@lfdr.de>; Sat, 15 Aug 2020 23:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbgHOVwN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 17:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbgHOVwI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 17:52:08 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61905C09B042
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 08:12:18 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i92so6518421pje.0
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 08:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=axupiLoVzvsjPFb5imUaqcJ2MpbZV9xAGepnN4tXK2Q=;
        b=Mf/a2wpUSMB+HK5kR4QFE/R0txdQ3Ig9Pp+xzr5M0tn+mi+9H348447ff7bXugmnX3
         DZprioxdKmczoY5uUwYOL1ff4BbGkeRuar1qWa274a4uUQ2e9n7sxFDkCA/s/JLwGPKr
         UED90xc51vuUlAR0YSGyMZG48lNxNYPEHcKU1vSDlxVF+I145ZpcwfBrKMsHVhN+4BWy
         4Zaon5QbRq7xsmDgU7aOG2B8mR/161djMf+OJ8zrk5TL1DulV/QZvYPcCk1jt0NePtQ1
         2qTwV/Z5cpKfS12f1/hzRS6S/De2VONJmJJA8yItaYq8ReTI4dysAtSGVwfkMfF/CaLE
         zs4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=axupiLoVzvsjPFb5imUaqcJ2MpbZV9xAGepnN4tXK2Q=;
        b=hac3VBSzms90Z+iy4JxrvBmHTb4ceIOLVSHOBR1o2N5jSN1GjVZZcrbiUTBB4l+6ot
         BdnFitbyQz4ubjaxeQgMr4cUp3h6/dmaX9RTPcgeMKk36fXqLIrLOqUp8Ldih0m19WJO
         F35rAkyq6fYa5R8MtEz6HVT0das8YVp7++QCkMLd94edauGYNwyN3g8A+6DxefiRmvwl
         6X2wPOAjmSpze6oKkDkLs/QhpjNWZfUbBMpDQ8ut4wDZaqFkcVv+HsZZBixqrUR+mST6
         VifMll1CX9SP4LXqvGWdOnQqEjWsqCvUcwY+X+HluG34RPW8Cs+Ha+2T2VALwrjEVspg
         wliQ==
X-Gm-Message-State: AOAM532HdpTZ5uvjzjATJomE+aG9siWLQ/teml7Ts3T5ig2yUqKZ160K
        0JDfje7SMqwKZWuzwumLwVpG9w==
X-Google-Smtp-Source: ABdhPJwOrD99UiW/rZbnQFjqMcBpDHsuY1xHB6/Ysn0qhidykBW4uBgIZORytN0uw3HRZPXOtc45LA==
X-Received: by 2002:a17:902:744c:: with SMTP id e12mr5759365plt.38.1597504337679;
        Sat, 15 Aug 2020 08:12:17 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:6299:2df1:e468:6351? ([2605:e000:100e:8c61:6299:2df1:e468:6351])
        by smtp.gmail.com with ESMTPSA id i14sm1305141pfu.50.2020.08.15.08.12.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 08:12:17 -0700 (PDT)
Subject: Re: io_uring process termination/killing is not working
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk>
 <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com>
 <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
 <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk>
Date:   Sat, 15 Aug 2020 08:12:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/20 12:45 AM, Pavel Begunkov wrote:
> On 13/08/2020 02:32, Jens Axboe wrote:
>> On 8/12/20 12:28 PM, Pavel Begunkov wrote:
>>> On 12/08/2020 21:22, Pavel Begunkov wrote:
>>>> On 12/08/2020 21:20, Pavel Begunkov wrote:
>>>>> On 12/08/2020 21:05, Jens Axboe wrote:
>>>>>> On 8/12/20 11:58 AM, Josef wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I have a weird issue on kernel 5.8.0/5.8.1, SIGINT even SIGKILL
>>>>>>> doesn't work to kill this process(always state D or D+), literally I
>>>>>>> have to terminate my VM because even the kernel can't kill the process
>>>>>>> and no issue on 5.7.12-201, however if IOSQE_IO_LINK is not set, it
>>>>>>> works
>>>>>>>
>>>>>>> I've attached a file to reproduce it
>>>>>>> or here
>>>>>>> https://gist.github.com/1Jo1/15cb3c63439d0c08e3589cfa98418b2c
>>>>>>
>>>>>> Thanks, I'll take a look at this. It's stuck in uninterruptible
>>>>>> state, which is why you can't kill it.
>>>>>
>>>>> It looks like one of the hangs I've been talking about a few days ago,
>>>>> an accept is inflight but can't be found by cancel_files() because it's
>>>>> in a link.
>>>>
>>>> BTW, I described it a month ago, there were more details.
>>>
>>> https://lore.kernel.org/io-uring/34eb5e5a-8d37-0cae-be6c-c6ac4d85b5d4@gmail.com
>>
>> Yeah I think you're right. How about something like the below? That'll
>> potentially cancel more than just the one we're looking for, but seems
>> kind of silly to only cancel from the file table holding request and to
>> the end.
> 
> The bug is not poll/t-out related, IIRC my test reproduces it with
> read(pipe)->open(). See the previously sent link.

Right, but in this context for poll, I just mean any request that has a
poll handler armed. Not necessarily only a pure poll. The patch should
fix your case, too.

> As mentioned, I'm going to patch that up, if you won't beat me on that.

Please test and send a fix if you find something! I'm going to ship what
I have this weekend, but we can always add a fix on top if we need
anything.

-- 
Jens Axboe

