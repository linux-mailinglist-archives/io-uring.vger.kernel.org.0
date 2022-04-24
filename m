Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F1750D283
	for <lists+io-uring@lfdr.de>; Sun, 24 Apr 2022 16:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239492AbiDXO7g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Apr 2022 10:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239478AbiDXO7E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Apr 2022 10:59:04 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C523403DD
        for <io-uring@vger.kernel.org>; Sun, 24 Apr 2022 07:56:04 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id r13so25097545ejd.5
        for <io-uring@vger.kernel.org>; Sun, 24 Apr 2022 07:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:organization:in-reply-to:content-transfer-encoding;
        bh=CQsNa6ZFk0wNQPmUZm2TH5ZP4ghtI00ywkpA4vx3SmY=;
        b=WDVwWbnFNr0d6a1Nd5yx16qqHuTtjETyB8vFQqEw3NyQ43Uhp4ctXsL3ZtWWr0CDDm
         yKa3SKx1K+bHvFRUdiZCwe4Oq9MsOr/HKEcRVjiqAjGZnveRJ7H3LZ3qwFdKSnYh+0bH
         OePh/bAjXtlWUYqvADy4WCKfxAlj2pLgukNiyF/WsIg1IcdaD0eb0oa8BuHu4Vwg2CLT
         wH7K3mTuOz6rUJlQx4rnrPjqkUTxAGjWPTMvGJv00qkbHnrcZRljjDUWFbZ5Huoq+qEG
         s/nzZG7DsGm8z0tduOFmvDrcuxJYAUvG5mqmALJnQWigoO49ZRgrN3iT/7V4AoB83+ww
         oodA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=CQsNa6ZFk0wNQPmUZm2TH5ZP4ghtI00ywkpA4vx3SmY=;
        b=gLDE5LlyznuvBky0qEhqkEl+2vIrfT6v7riJ7UTjtrKhgWpYUwammPeqArTLlCBNAz
         gxDEwrlcNo5xpU3pO8YY+7+lCBXpSSac5biiseRouQMzr+7pIhKVJ2wlgCcHHrcS1zxV
         SU0sbRZ9KJMAvdxoKJ2iTouFZwtxfJzBHZ8TffHshIN83Gm16DxF7+eaJftXmpiEMFWY
         NSbTlAHgJZsA+yjPUfwg/CiRANNjMeb7NHIj9mTJKIzhfq9K9/Mgj5YcFIK3Dz+6jhw7
         OSxQJcNyaJOhocdRyKPN0BOULp+tF+Sa2fiiiOowQus+4GkOmepBiga91j3IdMmWnkK2
         Ikug==
X-Gm-Message-State: AOAM530ZdqR7vbpUKx4T4Y6xxg6Afg4uHPyH4KYhhVZocowN80ucCMFS
        QVM6K9j6EM/d2pWaa8pKhKG4o3KBKIoktA==
X-Google-Smtp-Source: ABdhPJzkgQfxnPYjV14LHUGaJ7OneGHFo92sFq7TvOE0gJMUGvLeQqhZpq1CRVVrXAaA+M8xq5mQiw==
X-Received: by 2002:a17:907:6ea4:b0:6f3:87c8:21cc with SMTP id sh36-20020a1709076ea400b006f387c821ccmr3506639ejc.490.1650812162659;
        Sun, 24 Apr 2022 07:56:02 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id b89-20020a509f62000000b00425e21479fdsm634255edf.19.2022.04.24.07.56.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 07:56:01 -0700 (PDT)
Message-ID: <14e61ff5-2985-3ca5-b227-8d36db95b7bd@scylladb.com>
Date:   Sun, 24 Apr 2022 17:56:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: memory access op ideas
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
 <c03c4041-ed0f-2f6f-ed84-c5afe5555b4f@scylladb.com>
 <1acd11b7-12e7-d31b-775a-4f62895ac2f7@kernel.dk>
 <ee3f7e59-e7a1-9638-cb9a-4b2c15a5f945@scylladb.com>
 <d4321b8e-7d6a-7279-5e89-7e688a087a36@kernel.dk>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <d4321b8e-7d6a-7279-5e89-7e688a087a36@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 24/04/2022 16.30, Jens Axboe wrote:
> On 4/24/22 7:04 AM, Avi Kivity wrote:
>> On 23/04/2022 20.30, Jens Axboe wrote:
>>> On 4/23/22 10:23 AM, Avi Kivity wrote:
>>>> Perhaps the interface should be kept separate from io_uring. e.g. use
>>>> a pidfd to represent the address space, and then issue
>>>> IORING_OP_PREADV/IORING_OP_PWRITEV to initiate dma. Then one can copy
>>>> across process boundaries.
>>> Then you just made it a ton less efficient, particularly if you used the
>>> vectored read/write. For this to make sense, I think it has to be a
>>> separate op. At least that's the only implementation I'd be willing to
>>> entertain for the immediate copy.
>>
>> Sorry, I caused a lot of confusion by bundling immediate copy and a
>> DMA engine interface. For sure the immediate copy should be a direct
>> implementation like you posted!
>>
>> User-to-user copies are another matter. I feel like that should be a
>> stand-alone driver, and that io_uring should be an io_uring-y way to
>> access it. Just like io_uring isn't an NVMe driver.
> Not sure I understand your logic here or the io_uring vs nvme driver
> reference, to be honest. io_uring _is_ a standalone way to access it,
> you can use it sync or async through that.
>
> If you're talking about a standalone op vs being useful from a command
> itself, I do think both have merit and I can see good use cases for
> both.


I'm saying that if dma is exposed to userspace, it should have a regular 
synchronous interface (maybe open("/dev/dma"), maybe something else). 
io_uring adds asynchrony to everything, but it's not everything's driver.


Anyway maybe we drifted off somewhere and this should be decided by 
pragmatic concerns (like whatever the author of the driver prefers).


>
>>>    For outside of io_uring, you're looking at a sync
>>> interface, which I think already exists for this (ioctls?).
>>
>> Yes, it would be a asynchronous interface. I don't know if one exists,
>> but I can't claim to have kept track.
> Again not following. So you're saying there should be a 2nd async
> interface for it?


No. And I misspelled "synchronous" as "asynchronous" (I was agreeing 
with you that it would be a sync interface).


>
>>>> The kernel itself should find the DMA engine useful for things like
>>>> memory compaction.
>>> That's a very different use case though and just deals with wiring it up
>>> internally.
>>>
>>> Let's try and keep the scope here reasonable, imho nothing good comes
>>> out of attempting to do all the things at once.
>>>
>> For sure, I'm just noting that the DMA engine has many different uses
>> and so deserves an interface that is untied to io_uring.
> And again, not following, what's the point of having 2 interfaces for
> the same thing? I can sort of agree if one is just the basic ioctl kind
> of interface, a basic sync one. But outside of that I'm a bit puzzled as
> to why that would be useful at all.
>

Yes I meant the basic sync one. Sorry I caused quite a lot of confusion 
here!


