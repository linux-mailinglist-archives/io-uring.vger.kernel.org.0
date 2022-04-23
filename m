Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADAF950C92A
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 12:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiDWKYL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 06:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbiDWKYK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 06:24:10 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10181B9FA8
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 03:21:10 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id k23so20785489ejd.3
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 03:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ced37WKrUwuLucyXb5Gn9XvPRdvdFeQhOCPZCvKk6oY=;
        b=hZiesldX2LdlE2ikcZaoDGal2L7aWEelFo2Nrkajr8HWBmpga0GYn6ubVUJYA38BCo
         DlwFiWqzfl5rjIJBoWb6cTsHE2kKvrBI5h7/RPkGydCfwmovfAuLoIefqFmOrGN9Lzx+
         dtynb4cKCPd3iRsINPRPtnALu2OSzcZ/BAD1iLO7P8BX9QDuzHV1cIOUj569yr3lLLpE
         f6gZCp4+pinlTxkmUPrdtyNtNN8H4xQ3pqG2xJN8xKoxK3ZTgPoWXWndNAF9LodbzJvm
         dqAPbz+wsjU5rTQSXTUHgy6O/RoODxDkTSNnNJfgR0z59eYy6llRuyoI1tDjAG/Lfc15
         I5hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ced37WKrUwuLucyXb5Gn9XvPRdvdFeQhOCPZCvKk6oY=;
        b=XvMQkpcv/El3FVjqmbhH9V6POPIgZiXHN5uc9qRraaA+BYqPKfGpc/ddmHHejE3OiY
         DQTd6NCHjpKWdCVQiy3W5Fhf0oMx0E95lB99cU1CxpBssoAq+BnGGrtBzOhNG4Y0M5BT
         Y2dKHZ1cnAAQ9Hobrf6Sb07AHEwJ3Oc0rPk+j8p6UYwts/oE9UTNXkTD5ovotQVkbTaD
         l7SPkLyQQ3ij1CA7G2rz1NogF0+N4nGwPMElSTBQ7aZybXBI22/K/sRMMgeLpffsYeyf
         v6l72DlaGcdL3r9ANvBtPLYvMcY9sTjmdfcczE6wUwGgK3C5aqAKXTJFI650SSwIKDEJ
         h0aQ==
X-Gm-Message-State: AOAM531EQIAtx86pwj5/bzDgwvyA9QaznJ/2PSrOMETi1GDhpWISeNh6
        HD1Rrqe8funNTuMQLamj9FQ=
X-Google-Smtp-Source: ABdhPJxbZ5h/kyK9e6h73exbLov1RSntPDabctZLtxQPhhsWtd/ANDTk3uapzEVFLnwWV7fBhXusJg==
X-Received: by 2002:a17:906:6144:b0:6cf:bb2e:a2e1 with SMTP id p4-20020a170906614400b006cfbb2ea2e1mr7967708ejl.299.1650709269422;
        Sat, 23 Apr 2022 03:21:09 -0700 (PDT)
Received: from [192.168.8.198] ([185.69.144.28])
        by smtp.gmail.com with ESMTPSA id v20-20020a056402349400b00425a5ea1bb7sm2094845edc.57.2022.04.23.03.21.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 03:21:09 -0700 (PDT)
Message-ID: <4960fad0-1f32-8e6b-8bff-128af848baad@gmail.com>
Date:   Sat, 23 Apr 2022 11:19:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: memory access op ideas
Content-Language: en-US
To:     "Walker, Benjamin" <benjamin.walker@intel.com>,
        Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>,
        io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
 <d48eaf9a-1e7e-0355-2a23-456f9cd5b0bf@intel.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d48eaf9a-1e7e-0355-2a23-456f9cd5b0bf@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/22/22 21:03, Walker, Benjamin wrote:
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
> I'm about to send a set of patches to associate an io_uring with a dmaengine channel to this list. I'm not necessarily thinking of using it to directly drive the DMA engine itself (although we could, and there's some nice advantages to that), but rather as a way to offload data copies/transforms on existing io_uring operations. My primary focus has been the copy between kernel and user space when receiving from a socket.
> 
> Upcoming DMA engines also support SVA, allowing them to copy from kernel to user without page pinning. We've got patches for full SVA enabling in dmaengine prepared, such that each io_uring can allocate a PASID describing the user+kernel address space for the current context, allocate a channel via dmaengine and assign it the PASID, and then do DMA between kernel/user with new dmaengine APIs without any page pinning.
> 
> As preparation, I have submitted a series to dmaengine that allows for polling and out-of-order completions. See https://lore.kernel.org/dmaengine/20220201203813.3951461-1-benjamin.walker@intel.com/T/#u. This is a necessary first step.
> 
> I'll get the patches out ASAP as an RFC. I'm sure my approach was entirely wrong, but you'll get the idea.

Please do. Sounds interesting and it will likely be nicely
aligned with our work/plans on p2p.

-- 
Pavel Begunkov
