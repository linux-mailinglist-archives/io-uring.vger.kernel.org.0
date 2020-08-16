Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A74024583B
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 16:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgHPOxx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Aug 2020 10:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgHPOxw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Aug 2020 10:53:52 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4586C061786
        for <io-uring@vger.kernel.org>; Sun, 16 Aug 2020 07:53:52 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id r11so6897949pfl.11
        for <io-uring@vger.kernel.org>; Sun, 16 Aug 2020 07:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zR45yj7iw0GLmybORFggoQyFfufBCDVeBOqcMxac91o=;
        b=LHhLgAh17pjXaZw+xVhc9r9t2s6kvDC5nWPr80ho7HzE1vfMyAvaMstQdgizpSAOdA
         ezRbaZz/3CwpQ3q7ylK8XalmG5V4wZJAtU7BJd6+88wNr2jmdLi8AvD51VfFODJKT6n4
         VAk964Gt63HQgl5USlEaGwowVtZYBNghBbRkt7gY1im3K/Vch31rFBeuoErr4reHMET9
         f7V7kOgdkKBHD9GBQr04AKF4813QU/O0FrirU4+judTXI6hc0lMY2K2Y6WCbLjugeY5M
         flmL/T24SI7ShULsTpad/GFCwhye9wbkf0vmYAqJKpnDPTVJtx9OqGUucUIU3k/CJ6g8
         9SZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zR45yj7iw0GLmybORFggoQyFfufBCDVeBOqcMxac91o=;
        b=C/qWt12Txx7CbRuXdGpYN7Kd9y451MAfPyZh320U3yWXSy+j8KKpSt9YiYaExJYvJk
         nPkePfcXzUfy8ZLaAljkX9zLpQ7i/bfB09LGz+Dq43Bht5ZhBJoZjkcFQ8g8dlZM5IZv
         Jy/vB1mgPfxfyQfKTFlE00OfFwzr3etdfwa93uln2UNGYwmTQPWaXxDPdO3HjBzfbmeL
         07AiC7TcRiPEPjYUhamG7oWklHG2QX+eJudqfJprIJvc5/blhT2a4HfasdAXLo7aYrLl
         2LCK20BrwG+Vy1HFQq+nuCvnLVUyKJGsg3fpRo+/zZZv1rBvyrF0+WRHLeNwAGfrBttR
         gkiQ==
X-Gm-Message-State: AOAM533cD63EuCuAoMOEgIZO/lXLAMJgB3rUyE4QEAX2VwWn2eADQpj5
        4fWK4fjmzuZbrEOojRbsQPqnQfWTecranw==
X-Google-Smtp-Source: ABdhPJx5Qi2C7I8okFjsAz4uUeC9rE0wd0yKsuzVPlVTthWoPOUdEOpfgsDD25twF2BXZQRI6oGrAQ==
X-Received: by 2002:aa7:9613:: with SMTP id q19mr8614461pfg.9.1597589632080;
        Sun, 16 Aug 2020 07:53:52 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:80d9:87c:7a0f:8256? ([2605:e000:100e:8c61:80d9:87c:7a0f:8256])
        by smtp.gmail.com with ESMTPSA id w16sm14328879pjd.50.2020.08.16.07.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2020 07:53:51 -0700 (PDT)
Subject: Re: io_uring process termination/killing is not working
From:   Jens Axboe <axboe@kernel.dk>
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
 <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk>
 <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
 <86295255-567d-e756-5ca3-138d349a5ea1@kernel.dk>
Message-ID: <d2341bc7-e7c8-110f-e60c-39fc03c62160@kernel.dk>
Date:   Sun, 16 Aug 2020 07:53:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <86295255-567d-e756-5ca3-138d349a5ea1@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/20 6:45 AM, Jens Axboe wrote:
> On 8/15/20 9:48 AM, Pavel Begunkov wrote:
>> On 15/08/2020 18:12, Jens Axboe wrote:
>>> On 8/15/20 12:45 AM, Pavel Begunkov wrote:
>>>> On 13/08/2020 02:32, Jens Axboe wrote:
>>>>> On 8/12/20 12:28 PM, Pavel Begunkov wrote:
>>>>>> On 12/08/2020 21:22, Pavel Begunkov wrote:
>>>>>>> On 12/08/2020 21:20, Pavel Begunkov wrote:
>>>>>>>> On 12/08/2020 21:05, Jens Axboe wrote:
>>>>>>>>> On 8/12/20 11:58 AM, Josef wrote:
>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>> I have a weird issue on kernel 5.8.0/5.8.1, SIGINT even SIGKILL
>>>>>>>>>> doesn't work to kill this process(always state D or D+), literally I
>>>>>>>>>> have to terminate my VM because even the kernel can't kill the process
>>>>>>>>>> and no issue on 5.7.12-201, however if IOSQE_IO_LINK is not set, it
>>>>>>>>>> works
>>>>>>>>>>
>>>>>>>>>> I've attached a file to reproduce it
>>>>>>>>>> or here
>>>>>>>>>> https://gist.github.com/1Jo1/15cb3c63439d0c08e3589cfa98418b2c
>>>>>>>>>
>>>>>>>>> Thanks, I'll take a look at this. It's stuck in uninterruptible
>>>>>>>>> state, which is why you can't kill it.
>>>>>>>>
>>>>>>>> It looks like one of the hangs I've been talking about a few days ago,
>>>>>>>> an accept is inflight but can't be found by cancel_files() because it's
>>>>>>>> in a link.
>>>>>>>
>>>>>>> BTW, I described it a month ago, there were more details.
>>>>>>
>>>>>> https://lore.kernel.org/io-uring/34eb5e5a-8d37-0cae-be6c-c6ac4d85b5d4@gmail.com
>>>>>
>>>>> Yeah I think you're right. How about something like the below? That'll
>>>>> potentially cancel more than just the one we're looking for, but seems
>>>>> kind of silly to only cancel from the file table holding request and to
>>>>> the end.
>>>>
>>>> The bug is not poll/t-out related, IIRC my test reproduces it with
>>>> read(pipe)->open(). See the previously sent link.
>>>
>>> Right, but in this context for poll, I just mean any request that has a
>>> poll handler armed. Not necessarily only a pure poll. The patch should
>>> fix your case, too.
>>
>> Ok. I was thinking about sleeping in io_read(), etc. from io-wq context.
>> That should have the same effect.
> 
> We already cancel any blocking work for the exiting task - but we do
> that _after_ trying to cancel files, so we should probably just swap
> those around in io_uring_flush(). That'll remove any need to find and
> cancel those explicitly in io_uring_cancel_files().

I guess there's still the case of the task just closing the fd, not
necessarily exiting. So I do agree with you that the io-wq case is still
unhandled. I'll take a look...

-- 
Jens Axboe

