Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4EC50CC48
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 18:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbiDWQ1j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 12:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235823AbiDWQ1i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 12:27:38 -0400
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457111CDEEC
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 09:24:41 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id u15so21749450ejf.11
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 09:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:organization:in-reply-to:content-transfer-encoding;
        bh=4r0LDrp3TMa34Dp5MHait0uKn4kM+N0fy8d00j9VfMk=;
        b=5sQCr45kg8DLJhuz6pyZb0LNd4x9SxycGhYUIKmEw5dTmxJyZ1UTSPjVSx6lCRNXZR
         ZXK5/4ngAFxg/9Xd8AUbiZrOImLI7ko10Fr/tei5X/VzBh/uzfn2lcqcinYzfcQt6liR
         pHmYkq1faCZ0xzzOGc9WXhrDBES3xRll3kI/VF1tk9TfiIqbzfLJVaTt6YOWAzsLSu3p
         Gra0gkoYMwdqqnzGsOpBLGVH95zAjEr94z0oiaUq4JAsKeClI4yFSpdjAil0J+lD30dg
         WkhiU14z5ZWTeEsBl0E44Zi65XFz0eNHfE0pOlnYwnDNPXHRbEeinm0NhCBPp1JDKzof
         ul9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=4r0LDrp3TMa34Dp5MHait0uKn4kM+N0fy8d00j9VfMk=;
        b=3rp1HRjrGzsH+2Yd+v6ZolnsxiEE1SAQZ0B6JYY0ms9laTFjlH0N7T2h4o9GSm7pHb
         aWFgVph2hRh+Op1zuqdHBVWO5TC9835yGj4PI5fym8GJecK26mr+41Q04gSGw596Uc0v
         z+mJNLr8mxOeodjXEpr1g74EE4R6FxyK72IDvDe4VpdnpgFsqjD/0UW40ZR8oEmo06XQ
         +ryPBIHdDFarAIen5S5LCCjUGiugGMbFKe0QqaOMnI9z5MMb7eMszqJ97l95us+80USs
         HPvio/cQNbDMXMnXTowM2MBmAO/EXAVC6BomBhfq9UqiB7WoWLPZkICN9cUcgO5BlEAg
         34HQ==
X-Gm-Message-State: AOAM533aNeYWiUFF+6Tqvtk2xR51yO18yI4LxzQ6TXGMhFxnZ+GTShp/
        Qmtgf0kEN85DYkbvfoRAAkUDXQ==
X-Google-Smtp-Source: ABdhPJwaoZ+SqcWZ/7iSKfkjAFglT4ZeK5keH5gbvGEcegUMXt3rsi9OwtNiEviinQzKay7qMifcbQ==
X-Received: by 2002:a17:907:7b84:b0:6e8:b8c2:6fe2 with SMTP id ne4-20020a1709077b8400b006e8b8c26fe2mr9190952ejc.401.1650730987748;
        Sat, 23 Apr 2022 09:23:07 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id q17-20020a170906771100b006ef7d5b7a83sm1804206ejm.2.2022.04.23.09.23.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 09:23:07 -0700 (PDT)
Message-ID: <c03c4041-ed0f-2f6f-ed84-c5afe5555b4f@scylladb.com>
Date:   Sat, 23 Apr 2022 19:23:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: memory access op ideas
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 22/04/2022 17.50, Jens Axboe wrote:
> On 4/13/22 4:33 AM, Avi Kivity wrote:
>> Unfortunately, only ideas, no patches. But at least the first seems very easy.
>>
>>
>> - IORING_OP_MEMCPY_IMMEDIATE - copy some payload included in the op
>> itself (1-8 bytes) to a user memory location specified by the op.
>>
>>
>> Linked to another op, this can generate an in-memory notification
>> useful for busy-waiters or the UMWAIT instruction
>>
>> This would be useful for Seastar, which looks at a timer-managed
>> memory location to check when to break computation loops.
> This one would indeed be trivial to do. If we limit the max size
> supported to eg 8 bytes like suggested, then it could be in the sqe
> itself and just copied to the user address specified.
>
> Eg have sqe->len be the length (1..8 bytes), sqe->addr the destination
> address, and sqe->off the data to copy.
>
> If you'll commit to testing this, I can hack it up pretty quickly...


I can certainly commit to test it in a VM (my workstation has a 
hate-hate relationship with custom kernels).


>> - IORING_OP_MEMCPY - asynchronously copy memory
>>
>>
>> Some CPUs include a DMA engine, and io_uring is a perfect interface to
>> exercise it. It may be difficult to find space for two iovecs though.
> I've considered this one in the past too, and it is indeed an ideal fit
> in terms of API. Outside of the DMA engines, it can also be used to
> offload memcpy to a GPU, for example.
>
> The io_uring side would not be hard to wire up, basically just have the
> sqe specfy source, destination, length. Add some well defined flags
> depending on what the copy engine offers, for example.
>
> But probably some work required here in exposing an API and testing
> etc...


Perhaps the interface should be kept separate from io_uring. e.g. use a 
pidfd to represent the address space, and then issue 
IORING_OP_PREADV/IORING_OP_PWRITEV to initiate dma. Then one can copy 
across process boundaries.


A different angle is to use expose the dma device as a separate fd. This 
can be useful as dma engine can often do other operations, like xor or 
crc or encryption or compression. In any case I'd argue for the 
interface to be useful outside io_uring, although that considerably 
increases the scope. I also don't have a direct use case for it, though 
I'm sure others will.


The kernel itself should find the DMA engine useful for things like 
memory compaction.

