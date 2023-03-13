Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF45F6B8469
	for <lists+io-uring@lfdr.de>; Mon, 13 Mar 2023 23:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjCMWCN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Mar 2023 18:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCMWCM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Mar 2023 18:02:12 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4E98C51F
        for <io-uring@vger.kernel.org>; Mon, 13 Mar 2023 15:01:37 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso2936053pjb.0
        for <io-uring@vger.kernel.org>; Mon, 13 Mar 2023 15:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678744897;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aoryjymo1oElOGINN9cU4eLvQOu+fBsC3uXzTaes3Mc=;
        b=MYy7GeuncwawvsYj6On0bCx0hNboUyy8iUNqupWdKOkwdx1DDgtBxc8wmA+6sUw8de
         4Sm1uRIELAl/MdVJX1yiFDi7sQ87p7BteCp7tBl296Lw/YCyHTe78shGIrj2LnHD05oQ
         n9SgLZEYXPy/DhcEBmUVWMD2cQSPCuiivL6mx8RHLUCRy2x4PoNTFEpSJWrvmJ/FFXRT
         6wLANodOiaSU2jK85nWxSs0hliKxSkjD2hgPKOFywCLRRMXi6Qx9apUPelXxLyjff2dW
         J1DZXVZGR6S/0ahoCUujE6IjbNzxAx3ctvUwnOphuccaWQwrA8TtU0dDHLEwrhz4211c
         2ECw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678744897;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aoryjymo1oElOGINN9cU4eLvQOu+fBsC3uXzTaes3Mc=;
        b=d0vQKO+f6tv+1tzZQr7nvSkTfwToEXSq9vOwQTFjVK/eVftwm053VSQvEOYP4X7i+l
         IImaoZ89PyMACY7q4eyJCYf+26Fk4ooIpbdUvTfGj3hy0gesqmeZ9HZmYpzBxsKma3QY
         2XJxyWQuuMd0AzD/nP/bV3Z5MAsmkF6t18TuMDuwIYTjZAXXa/GtTo/B83lmTqmXhUEl
         DmbZhANu0srfDItiWClkoDsSa49b/7yI9CXg6NzlsyM4BeKbeoCoXeUBbpvXAQASu2bJ
         ZlQeAawpeW3N5WXI8cFHjMhYCpnVeLCkV21kAWYdQTl3Nruk5AWC3KscpGMyq4wx3csq
         K1Xg==
X-Gm-Message-State: AO0yUKUeEciBLwOS4IPDOGQpbQJFF2gj8wCzG1XxQrBexYKGHiWlcY1G
        l0RXFnJ5TvBNGm5CZrMdWg/4Qg==
X-Google-Smtp-Source: AK7set+9QGd09G9H0H+duic/XO65p0Yg/8XFn8ktQw7uv5jx733l5yAhwJNJGpoTcxvEeHvJE6gSOA==
X-Received: by 2002:a17:903:42c7:b0:199:3f82:ef62 with SMTP id jy7-20020a17090342c700b001993f82ef62mr10886267plb.5.1678744896833;
        Mon, 13 Mar 2023 15:01:36 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id la15-20020a170902fa0f00b00186cf82717fsm318355plb.165.2023.03.13.15.01.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 15:01:36 -0700 (PDT)
Message-ID: <9e5dc1c6-ec4a-7c6d-9c3f-653ba55db0f8@kernel.dk>
Date:   Mon, 13 Mar 2023 16:01:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC 0/2] optimise local-tw task resheduling
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1678474375.git.asml.silence@gmail.com>
 <9250606d-4998-96f6-aeaf-a5904d7027e3@kernel.dk>
 <ee962f58-1074-0480-333b-67b360ea8b87@gmail.com>
 <9322c9ab-6bf5-b717-9f25-f5e55954db7b@kernel.dk>
 <4ed9ee1e-db0f-b164-4558-f3afa279dd4f@gmail.com>
 <c433f8cf-57dc-52c9-9959-f6a21297d1b0@kernel.dk>
 <ad5d6234-b11d-7ac6-0218-78058df99712@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ad5d6234-b11d-7ac6-0218-78058df99712@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/13/23 11:50?AM, Pavel Begunkov wrote:
> On 3/13/23 14:16, Jens Axboe wrote:
>> On 3/12/23 9:45?PM, Pavel Begunkov wrote:
>>>>>> Didn't take a closer look just yet, but I grok the concept. One
>>>>>> immediate thing I'd want to change is the FACILE part of it. Let's call
>>>>>> it something a bit more straightforward, perhaps LIGHT? Or LIGHTWEIGHT?
>>>>>
>>>>> I don't really care, will change, but let me also ask why?
>>>>> They're more or less synonyms, though facile is much less
>>>>> popular. Is that your reasoning?
>>>
>>>> Yep, it's not very common and the name should be self-explanatory
>>>> immediately for most people.
>>>
>>> That's exactly the problem. Someone will think that it's
>>> like normal tw but "better" and blindly apply it. Same happened
>>> before with priority tw lists.
>>
>> But the way to fix that is not through obscure naming, it's through
>> better and more frequent review. Naming is hard, but naming should be
>> basically self-explanatory in terms of why it differs from not setting
>> that flag. LIGHTWEIGHT and friends isn't great either, maybe it should
>> just be explicit in that this task_work just posts a CQE and hence it's
>> pointless to wake the task to run it unless it'll then meet the criteria
>> of having that task exit its wait loop as it now has enough CQEs
>> available. IO_UF_TWQ_CQE_POST or something like that. Then if it at some
> 
> There are 2 expectations (will add a comment)
> 1) it's posts no more that 1 CQE, 0 is fine
> 
> 2) it's not urgent, including that it doesn't lock out scarce
> [system wide] resources. DMA mappings come to mind as an example.
> 
> IIRC is a problem even now with nvme passthrough and DEFER_TASKRUN

DMA mappings aren't really scarce, only on weird/crappy setups with a
very limited IOMMU space where and IOMMU is being used. So not a huge
deal I think.

>> point gets modified to also encompass different types of task_work that
>> should not cause wakes, then it can change again. Just tossing
>> suggestions out there...
> 
> I honestly don't see how LIGHTWEIGHT is better. I think a proper
> name would be _LAZY_WAKE or maybe _DEFERRED_WAKE. It doesn't tell
> much about why you would want it, but at least sets expectations
> what it does. Only needs a comment that multishot is not supported.

Agree, and this is what I said too, LIGHTWEIGHT isn't a great word
either. DEFERRED_WAKE seems like a good candidate, and it'd be great to
also include a code comment there on what it does. That'll help future
contributors.

-- 
Jens Axboe

