Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5CEE50CA8D
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 15:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbiDWNX4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 09:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235734AbiDWNXz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 09:23:55 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3BB21F8D3
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 06:20:58 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d15so16798403pll.10
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 06:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=nYmvChsIZLp+p0+Nd71TF7KCFNDhKWFcw3pyKAwTNcI=;
        b=53vPnRnMAkBec0kwh07ZWHxCJUoXkktW7p4Ey+d+wFG5jhke1+eK550ac+UHrTC/Jo
         /9jlZFz5vuaj3ARR30aekPdOY/mRY0NNVYKufgoKVgLDhISh1HT29Xw730yQvVe7+yg5
         mDjHEM7YVzQ0h+GWPBQmUt1fivYN1DRuG/OnyuviTN5FIYGIk4KgBM5NyEBAGxlIF6Y3
         tKFKEfGcgoAtiZQ/0/jTrDJCdYeDw8YkAJZKtbun9djt+qnAQADceHDmaEjUu8T6Ztud
         HmaLeOoE9UexydGH49uogiAPF4QsFEOhZ99N3K50NmrrX72RwcmrKvzUnSefosNHMPuK
         5XPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nYmvChsIZLp+p0+Nd71TF7KCFNDhKWFcw3pyKAwTNcI=;
        b=qdOX5dFnFdE8Gvg5kjXP2gA4kjKn8ujOH0mz8BEOnoJGitHMqVgV/uaqG6NdjD3A0B
         NTpW+K9wDgTyDSVgmW6zNpNOozO5T1g9Ds3fYEP1Q6Usrv0xnz+Zp4vBbjTZ5YuOpVA0
         dHjlJcMBndSZd4j+XIndQcdB9MtLJuoBLn9JPtbXPuS+y7eBxxCemYzSfuDub4Ysyx3o
         GS2PMmlbRoNnP25jKrBcObeGI/sNq54SuCIml6hgrEtySZ9YsxnA4LEdW7xYbk8klGBg
         aYtOJNAPUR6GZBVIXj3+K1gIUo6nHjfDez7E657qe3WcNP3XWPw1xAp9pHf1AYEAJI4Q
         YSgA==
X-Gm-Message-State: AOAM531SeDD4zkeKILBUZEyV7SSrxuED3I50zqJIL9A4S3RFUtG6HcC5
        gWOfTeUSjHE4AffInqROgd5V/yuv6XjuRFw3
X-Google-Smtp-Source: ABdhPJxxoQLHazS4dTgD3GbXBc+y/k33pUpqXoCOvvZLoToApuQUygJvCDYBJI/oRi0w7UWIeGA52Q==
X-Received: by 2002:a17:90b:90b:b0:1d5:c3b1:55 with SMTP id bo11-20020a17090b090b00b001d5c3b10055mr15466813pjb.162.1650720058325;
        Sat, 23 Apr 2022 06:20:58 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p42-20020a056a0026ea00b0050ab776f6a2sm5926073pfw.103.2022.04.23.06.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 06:20:57 -0700 (PDT)
Message-ID: <b8e50dc0-4b1f-603d-c850-9456cc49987f@kernel.dk>
Date:   Sat, 23 Apr 2022 07:20:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: memory access op ideas
Content-Language: en-US
To:     "Walker, Benjamin" <benjamin.walker@intel.com>,
        Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
 <d48eaf9a-1e7e-0355-2a23-456f9cd5b0bf@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d48eaf9a-1e7e-0355-2a23-456f9cd5b0bf@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/22/22 2:03 PM, Walker, Benjamin wrote:
> On 4/22/2022 7:50 AM, Jens Axboe wrote:
>> On 4/13/22 4:33 AM, Avi Kivity wrote:
>>> Unfortunately, only ideas, no patches. But at least the first seems very easy.
>>>
>>>
>>> - IORING_OP_MEMCPY_IMMEDIATE - copy some payload included in the op
>>> itself (1-8 bytes) to a user memory location specified by the op.
>>>
>>>
>>> Linked to another op, this can generate an in-memory notification
>>> useful for busy-waiters or the UMWAIT instruction
>>>
>>> This would be useful for Seastar, which looks at a timer-managed
>>> memory location to check when to break computation loops.
>>
>> This one would indeed be trivial to do. If we limit the max size
>> supported to eg 8 bytes like suggested, then it could be in the sqe
>> itself and just copied to the user address specified.
>>
>> Eg have sqe->len be the length (1..8 bytes), sqe->addr the destination
>> address, and sqe->off the data to copy.
>>
>> If you'll commit to testing this, I can hack it up pretty quickly...
>>
>>> - IORING_OP_MEMCPY - asynchronously copy memory
>>>
>>>
>>> Some CPUs include a DMA engine, and io_uring is a perfect interface to
>>> exercise it. It may be difficult to find space for two iovecs though.
>>
>> I've considered this one in the past too, and it is indeed an ideal fit
>> in terms of API. Outside of the DMA engines, it can also be used to
>> offload memcpy to a GPU, for example.
>>
>> The io_uring side would not be hard to wire up, basically just have the
>> sqe specfy source, destination, length. Add some well defined flags
>> depending on what the copy engine offers, for example.
>>
>> But probably some work required here in exposing an API and testing
>> etc...
>>
> 
> I'm about to send a set of patches to associate an io_uring with a
> dmaengine channel to this list. I'm not necessarily thinking of using
> it to directly drive the DMA engine itself (although we could, and
> there's some nice advantages to that), but rather as a way to offload
> data copies/transforms on existing io_uring operations. My primary
> focus has been the copy between kernel and user space when receiving
> from a socket.

Interesting - I think both uses cases are actually valid, offloading a
memcpy or using the engine to copy the data of an existing operation.

> Upcoming DMA engines also support SVA, allowing them to copy from
> kernel to user without page pinning. We've got patches for full SVA
> enabling in dmaengine prepared, such that each io_uring can allocate a
> PASID describing the user+kernel address space for the current
> context, allocate a channel via dmaengine and assign it the PASID, and
> then do DMA between kernel/user with new dmaengine APIs without any
> page pinning.
> 
> As preparation, I have submitted a series to dmaengine that allows for
> polling and out-of-order completions. See
> https://lore.kernel.org/dmaengine/20220201203813.3951461-1-benjamin.walker@intel.com/T/#u.
> This is a necessary first step.
> 
> I'll get the patches out ASAP as an RFC. I'm sure my approach was
> entirely wrong, but you'll get the idea.

Please do, this sounds exciting! The whole point of an RFC is to get
some feedback on initial design before it potentially goes too far down
the wrong path.

-- 
Jens Axboe

