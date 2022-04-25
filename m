Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1135A50D65D
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 02:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236781AbiDYAs0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Apr 2022 20:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240022AbiDYAsY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Apr 2022 20:48:24 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E01663CC
        for <io-uring@vger.kernel.org>; Sun, 24 Apr 2022 17:45:15 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id w16so6930436pfj.2
        for <io-uring@vger.kernel.org>; Sun, 24 Apr 2022 17:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=plTac+a+MZOjMaIyNjl//97G6tUJYZXF7aSDx85RTz4=;
        b=qs+tGe4kcc53+c6qdnmArN+d4An5vra34Z2KwbaoyTW65GUH3Sbxa0FOcrw55w8s6c
         tAV2keh/prGUwy8K1WXTIybAD/59/0QZYOFyFgb0LRxhYIpD6iscbT9/YDsEc4qhwF83
         VoNDUqKneDxYqFei4RDx0HPkYt1oM1q2bgUNFcWcKg8/M4fphWGpLnKRC//EIPMEHiU6
         rGq9d7w7xBcf+5JNwgT52w9pGXZyhhw4uijGUjZ7KMhmHs8hNntXtOg1R4yvH3AMIIv1
         XvXGT9L50JS7Himw/DU4IGfDH1SVt9JSSGBseq6LTH0DBEj9tCLcnnp3Td/wNobnynsi
         IelQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=plTac+a+MZOjMaIyNjl//97G6tUJYZXF7aSDx85RTz4=;
        b=gPnbZpItyaRLnKdXNz6IbbmwJjGPRmuG2hX30FLZhv4FwWLCgyF1kJsYlpZGTVFFx7
         jL1b1hOB9IyqFhEJem8cb9XOBOCjMmdlI42MJWtlZ+xTHU+xYGvcg2TT+aOXjceZlK8/
         rMrCtO3rtEr+QKJ9lO6PMW96kjP2G4AQg3f8JN9u1VdCDSZ+D7O1i0HztflB6ydwT7lR
         NWmMIoPRPE/7xLn4faxmNwOmR4S+1m7z2Ttz91ue1hGPkC6IYfjAxrdGNiOZ1AKr5/+V
         UPPxY4cOrs4aHNdVWx4Y1NWummez2vzZYarRUhbt+T72CcsUiLnDSeIdYRSZb/27g+dZ
         WdHg==
X-Gm-Message-State: AOAM530MxHRxzAQG8MHBFQTGD1+cajh+VTXaXiInu4B0iA6mjGzynyTM
        C+9gpVDcMwZg6WFPxy4TsMf0QQ==
X-Google-Smtp-Source: ABdhPJweIt115DL/iBy3UwiYQH/MK73guVdweQklk+i9UgG+WsBJ9+Kd5KXERen9Tv5R2OXZ9TgxKg==
X-Received: by 2002:a63:3f8f:0:b0:386:3116:a1f3 with SMTP id m137-20020a633f8f000000b003863116a1f3mr13179497pga.136.1650847515093;
        Sun, 24 Apr 2022 17:45:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g12-20020a056a001a0c00b004e1307b249csm9670707pfv.69.2022.04.24.17.45.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 17:45:14 -0700 (PDT)
Message-ID: <c925572e-9509-77bd-0992-3ac439fb0aac@kernel.dk>
Date:   Sun, 24 Apr 2022 18:45:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: memory access op ideas
Content-Language: en-US
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
 <c03c4041-ed0f-2f6f-ed84-c5afe5555b4f@scylladb.com>
 <1acd11b7-12e7-d31b-775a-4f62895ac2f7@kernel.dk>
 <ee3f7e59-e7a1-9638-cb9a-4b2c15a5f945@scylladb.com>
 <d4321b8e-7d6a-7279-5e89-7e688a087a36@kernel.dk>
 <14e61ff5-2985-3ca5-b227-8d36db95b7bd@scylladb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <14e61ff5-2985-3ca5-b227-8d36db95b7bd@scylladb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/24/22 8:56 AM, Avi Kivity wrote:
> 
> On 24/04/2022 16.30, Jens Axboe wrote:
>> On 4/24/22 7:04 AM, Avi Kivity wrote:
>>> On 23/04/2022 20.30, Jens Axboe wrote:
>>>> On 4/23/22 10:23 AM, Avi Kivity wrote:
>>>>> Perhaps the interface should be kept separate from io_uring. e.g. use
>>>>> a pidfd to represent the address space, and then issue
>>>>> IORING_OP_PREADV/IORING_OP_PWRITEV to initiate dma. Then one can copy
>>>>> across process boundaries.
>>>> Then you just made it a ton less efficient, particularly if you used the
>>>> vectored read/write. For this to make sense, I think it has to be a
>>>> separate op. At least that's the only implementation I'd be willing to
>>>> entertain for the immediate copy.
>>>
>>> Sorry, I caused a lot of confusion by bundling immediate copy and a
>>> DMA engine interface. For sure the immediate copy should be a direct
>>> implementation like you posted!
>>>
>>> User-to-user copies are another matter. I feel like that should be a
>>> stand-alone driver, and that io_uring should be an io_uring-y way to
>>> access it. Just like io_uring isn't an NVMe driver.
>> Not sure I understand your logic here or the io_uring vs nvme driver
>> reference, to be honest. io_uring _is_ a standalone way to access it,
>> you can use it sync or async through that.
>>
>> If you're talking about a standalone op vs being useful from a command
>> itself, I do think both have merit and I can see good use cases for
>> both.
> 
> 
> I'm saying that if dma is exposed to userspace, it should have a
> regular synchronous interface (maybe open("/dev/dma"), maybe something
> else). io_uring adds asynchrony to everything, but it's not
> everything's driver.

Sure, my point is that if/when someone wants to add that, they should be
free to do so. It's not a fair requirement to put on someone doing the
initial work on wiring this up. It may not be something they would want
to use to begin with, and it's perfectly easy to run io_uring in sync
mode should you wish to do so. The hard part is making the
issue+complete separate actions, rolling a sync API on top of that would
be trivial.

> Anyway maybe we drifted off somewhere and this should be decided by
> pragmatic concerns (like whatever the author of the driver prefers).

Indeed!

-- 
Jens Axboe

