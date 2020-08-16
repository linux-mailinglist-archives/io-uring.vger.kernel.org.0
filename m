Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E962457D1
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 15:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgHPNpO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Aug 2020 09:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgHPNpL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Aug 2020 09:45:11 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC38C061786
        for <io-uring@vger.kernel.org>; Sun, 16 Aug 2020 06:45:11 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k18so6860777pfp.7
        for <io-uring@vger.kernel.org>; Sun, 16 Aug 2020 06:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2hBMbMFLz38WYEFuqSGCM5XGmr08B3lwOZCTrq71DhU=;
        b=Wb9+fuHHSccq/VJnE5shX4u/fyxSaX1GT6Ek4auQf/r0TEhw1pDO2+64ZmXVUjAsW4
         59MnVM039FPtCJroQONIwN2KJqI7u0JdinGmeb8o8bHcbApo2ZPTrVB1gezpTDKexUXl
         iLtm+W50RKjEPJirRPLZHFIep8cyY2bAIHOGu7nKstaktzF10h5GWajAnMkOFCA9HkuU
         NWuhyRxgi+ye2NAYDNVzSHuoRREqX7/6MMa4vSEXi/Lpoc+dcquRcNkeg0kBg547CRf/
         M7S3TdV+ekOvWCdxWdY7+T8LJU2cWY+5HSduMs2HUjyUJvMthFj258Z5omSJDZpcBDPb
         hnPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2hBMbMFLz38WYEFuqSGCM5XGmr08B3lwOZCTrq71DhU=;
        b=eEMr3ANdKcS7ftFLHth8JRh2GNNyuYjL/s9/cQZVhJD4k9Fj6M+vNbreAa+LfKINWe
         hTykW9TGDkoQTnnQdiytNdB8P1gw2ZHBSx8dtLIebnEsZSWAN48ynp/rkytAOIm4JYjm
         jkPTKUxhDWr97VUG1UdCCmbjlm2DnA5hnwx2Vd+XHcBAC0InZIbhzYkkhkXDtvPmn2FC
         5uou5M0CfSsesinHdtOHPFhF6F3sFARVM4nT3svqxQ0MbrQPbIkjWSYkT+l8bei83/4y
         51XXlKzmNoHTruAMrGRFnvG98XxGnrywEezrKC+QyWLZjqyDaQg0vLG0bPNLbgvFhGcJ
         u26g==
X-Gm-Message-State: AOAM53140++XVNzFMUZcPWJ/ppXei9wF5Jwo17XLf5H9T+GE1UCE13Lj
        GDlJOZGIVi/LFSoZzp5Dch96H6YH+7ZWww==
X-Google-Smtp-Source: ABdhPJxfLVsIJUOFlGDCzLk8UHsL0X7iOZOcmWA+nT9aw2hOYtATQPvrdb0mJZPiybywuC3jehbXAw==
X-Received: by 2002:a63:4e56:: with SMTP id o22mr6883545pgl.381.1597585510805;
        Sun, 16 Aug 2020 06:45:10 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:80d9:87c:7a0f:8256? ([2605:e000:100e:8c61:80d9:87c:7a0f:8256])
        by smtp.gmail.com with ESMTPSA id s22sm15506305pfh.16.2020.08.16.06.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2020 06:45:10 -0700 (PDT)
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
 <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk>
 <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <86295255-567d-e756-5ca3-138d349a5ea1@kernel.dk>
Date:   Sun, 16 Aug 2020 06:45:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/20 9:48 AM, Pavel Begunkov wrote:
> On 15/08/2020 18:12, Jens Axboe wrote:
>> On 8/15/20 12:45 AM, Pavel Begunkov wrote:
>>> On 13/08/2020 02:32, Jens Axboe wrote:
>>>> On 8/12/20 12:28 PM, Pavel Begunkov wrote:
>>>>> On 12/08/2020 21:22, Pavel Begunkov wrote:
>>>>>> On 12/08/2020 21:20, Pavel Begunkov wrote:
>>>>>>> On 12/08/2020 21:05, Jens Axboe wrote:
>>>>>>>> On 8/12/20 11:58 AM, Josef wrote:
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> I have a weird issue on kernel 5.8.0/5.8.1, SIGINT even SIGKILL
>>>>>>>>> doesn't work to kill this process(always state D or D+), literally I
>>>>>>>>> have to terminate my VM because even the kernel can't kill the process
>>>>>>>>> and no issue on 5.7.12-201, however if IOSQE_IO_LINK is not set, it
>>>>>>>>> works
>>>>>>>>>
>>>>>>>>> I've attached a file to reproduce it
>>>>>>>>> or here
>>>>>>>>> https://gist.github.com/1Jo1/15cb3c63439d0c08e3589cfa98418b2c
>>>>>>>>
>>>>>>>> Thanks, I'll take a look at this. It's stuck in uninterruptible
>>>>>>>> state, which is why you can't kill it.
>>>>>>>
>>>>>>> It looks like one of the hangs I've been talking about a few days ago,
>>>>>>> an accept is inflight but can't be found by cancel_files() because it's
>>>>>>> in a link.
>>>>>>
>>>>>> BTW, I described it a month ago, there were more details.
>>>>>
>>>>> https://lore.kernel.org/io-uring/34eb5e5a-8d37-0cae-be6c-c6ac4d85b5d4@gmail.com
>>>>
>>>> Yeah I think you're right. How about something like the below? That'll
>>>> potentially cancel more than just the one we're looking for, but seems
>>>> kind of silly to only cancel from the file table holding request and to
>>>> the end.
>>>
>>> The bug is not poll/t-out related, IIRC my test reproduces it with
>>> read(pipe)->open(). See the previously sent link.
>>
>> Right, but in this context for poll, I just mean any request that has a
>> poll handler armed. Not necessarily only a pure poll. The patch should
>> fix your case, too.
> 
> Ok. I was thinking about sleeping in io_read(), etc. from io-wq context.
> That should have the same effect.

We already cancel any blocking work for the exiting task - but we do
that _after_ trying to cancel files, so we should probably just swap
those around in io_uring_flush(). That'll remove any need to find and
cancel those explicitly in io_uring_cancel_files().

-- 
Jens Axboe

