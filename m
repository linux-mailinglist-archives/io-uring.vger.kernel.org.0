Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBA150D1D4
	for <lists+io-uring@lfdr.de>; Sun, 24 Apr 2022 15:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbiDXNHH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Apr 2022 09:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiDXNHG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Apr 2022 09:07:06 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B5517CE92
        for <io-uring@vger.kernel.org>; Sun, 24 Apr 2022 06:04:05 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id el3so10721407edb.11
        for <io-uring@vger.kernel.org>; Sun, 24 Apr 2022 06:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:organization:in-reply-to:content-transfer-encoding;
        bh=lPIcVNuugcheRiY2SLqWGyjLAsIL5Smjii9R91GW3dg=;
        b=23FOwSibC8vmzkOrhaICl6exEVaTBwwkF7zhhPlaTYz+YTSMVSo4KCjDaEuquxJOgJ
         9cLrwsU90BdhOaD1xQF5tvMp60i7Z/7v1t9CPWn66alKR3wKx+9jXkVSmwFj18WZ7ulU
         gKqJZbKA4bZ2QN9h2fCEFQdh6sXuOmKEfUYXRPA8ltkOjRq8iRpDjMXaSl59Hbsedc/S
         WawDLf0SE+k/vfIuChJL2tioOEU1rRPHFT3XEdFfnCrfRWWjbvmcl6j6Tkm9m4Hic4E8
         YQ9pEb9WFkJpbOo8RfkTnOWCkI/y7WnhIxj+EHD93y5MgwRVmYqifWGyMD2b3nG0kySd
         UDSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=lPIcVNuugcheRiY2SLqWGyjLAsIL5Smjii9R91GW3dg=;
        b=7Npb+9E9Z4EoSMS+jMSrWaBtduHTF5MKL2tvRcifPhjJXrnh9954cddVRAk1jy3g6V
         CmZlOabRF4OtO6c+TFL+p8l//Mzw9vuR/pxuBPU/xdSgfpMjZsgXvYfa/umbmOPAY9z9
         OdLFGt1ipAu3MlmaDVKrCYG1KyotQXSHVZbieThi2OcY80Yc9D7PNQIoytbp3c9go2+/
         0jBbX4SowsehQAytUK+ieaxUmyvUEWUdv5X0B3EtXUYZUeb1ItNs9gWc8dbXt1gUzBBf
         8isuZmjNVELz0pvHj5BIHdr1d5ard1YDvujl09oDlZ1HZQBZAqp0jJgIvkqxFJOJ3s1R
         1Fkg==
X-Gm-Message-State: AOAM533L/ePhdOlNwBUTBbGKJjletAIFO5I7fC25Ju7hIxn3QXeWE7vP
        CIcgLX9fis3DVVNqO3g4M968sg==
X-Google-Smtp-Source: ABdhPJzVTezrO9hMGVm2mqwdrw8GwFd7/nxuwQqWgXU919vOYjnOnawRi6B7JyJQpe1CkdfQDE171Q==
X-Received: by 2002:aa7:d311:0:b0:423:e539:8581 with SMTP id p17-20020aa7d311000000b00423e5398581mr13962723edq.111.1650805443875;
        Sun, 24 Apr 2022 06:04:03 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id iy6-20020a170907818600b006f38fa4889fsm409610ejc.172.2022.04.24.06.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 06:04:03 -0700 (PDT)
Message-ID: <ee3f7e59-e7a1-9638-cb9a-4b2c15a5f945@scylladb.com>
Date:   Sun, 24 Apr 2022 16:04:01 +0300
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
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <1acd11b7-12e7-d31b-775a-4f62895ac2f7@kernel.dk>
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


On 23/04/2022 20.30, Jens Axboe wrote:
> On 4/23/22 10:23 AM, Avi Kivity wrote:
>> Perhaps the interface should be kept separate from io_uring. e.g. use
>> a pidfd to represent the address space, and then issue
>> IORING_OP_PREADV/IORING_OP_PWRITEV to initiate dma. Then one can copy
>> across process boundaries.
> Then you just made it a ton less efficient, particularly if you used the
> vectored read/write. For this to make sense, I think it has to be a
> separate op. At least that's the only implementation I'd be willing to
> entertain for the immediate copy.


Sorry, I caused a lot of confusion by bundling immediate copy and a DMA 
engine interface. For sure the immediate copy should be a direct 
implementation like you posted!


User-to-user copies are another matter. I feel like that should be a 
stand-alone driver, and that io_uring should be an io_uring-y way to 
access it. Just like io_uring isn't an NVMe driver.


>> A different angle is to use expose the dma device as a separate fd.
>> This can be useful as dma engine can often do other operations, like
>> xor or crc or encryption or compression. In any case I'd argue for the
>> interface to be useful outside io_uring, although that considerably
>> increases the scope. I also don't have a direct use case for it,
>> though I'm sure others will.
> I'd say that whoever does it get to at least dictate the initial
> implementation.


Of course, but bikeshedding from the sidelines never hurt anyone.


>   For outside of io_uring, you're looking at a sync
> interface, which I think already exists for this (ioctls?).


Yes, it would be a asynchronous interface. I don't know if one exists, 
but I can't claim to have kept track.


>
>> The kernel itself should find the DMA engine useful for things like
>> memory compaction.
> That's a very different use case though and just deals with wiring it up
> internally.
>
> Let's try and keep the scope here reasonable, imho nothing good comes
> out of attempting to do all the things at once.
>

For sure, I'm just noting that the DMA engine has many different uses 
and so deserves an interface that is untied to io_uring.


