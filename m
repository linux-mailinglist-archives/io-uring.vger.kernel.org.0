Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935734CC7DC
	for <lists+io-uring@lfdr.de>; Thu,  3 Mar 2022 22:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236484AbiCCVUu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 16:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236481AbiCCVUu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 16:20:50 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EB1131108
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 13:20:03 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v4so5747977pjh.2
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 13:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=7ciw4pGxyZRHaWocRiCKTRHyrEP/QHEuTzHvQESBNkU=;
        b=4AsXBQN5nKlOemLN+s9y5FrcNvdzeaeHwoPglX2PoN2iRT/kV+blkABUgl/GPl9rTK
         daZQPGJZ4FuBk/nRJSn3yYcmuuJ8inh2UBoSAEWaQ12kXTKZ+KUQgVvdnP+JpTJTWOBz
         TvrpSEQy0g3KJLuW5thFzKUdx0vvHecE3YG2zeFj5OeH5+AU01lIfASg09zmSsJXla7V
         YOYn/C+pWS9yLyARYPpukZZabHo8TzoEHaLhu+Na5K2s2Fyc+NhnSUSgEqusSxjmZFCU
         mfR3qIVZyKVvqRzo82NNUkqXgHdM+Mt/dEDX+hsvRIvbxazz86oQEqPqyoIifQBrXSdA
         yXUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=7ciw4pGxyZRHaWocRiCKTRHyrEP/QHEuTzHvQESBNkU=;
        b=WL5UecELST4nljD/Ku6H4A89iUoRg6i0TeFWqB04Q7RLNeyDDRLRZO6Z5SBp04/7S5
         +s1m4qGuKrEpKj8eXKk7pqOHpi6Zqbdb+s1srIWsvWmzwU2XL5o/sW1FV6hSlojYdIjB
         Kjfy7buuYmo3ELM40C6rswbcdOmqDjZyEXJIU73L0KwfQzQElIrSQIwHyxRM5FjpIqjN
         j69AhSsj6rB9T4KJiyr1pJsNVYyNbtal3zVMruFWpz0cvOnX2p7CCPk37qdmm8aAXAF9
         iaViPN7HmcbdKNJox9ibOoE+CYgb8VrS0OBr/4/PR51qzAzOHhJPA9Ez3Bwc6SNtngb1
         SXyw==
X-Gm-Message-State: AOAM532QkAf6kMEYk7qnZ5k+uFyxPSwdRxGORE/N5fXzGAE4NZEawBAD
        x7CGHiTq3PYcKEkyIfHBiYXcrA80T8CD8Q==
X-Google-Smtp-Source: ABdhPJzwPGsXfaQIOReJVZLaX4EBApDzf4UmIqRxx/Iq9aPwwJ14bc4HLKgZjjaaNXHx3V4FwPiJTw==
X-Received: by 2002:a17:90a:4702:b0:1bd:36ce:f7af with SMTP id h2-20020a17090a470200b001bd36cef7afmr7403862pjg.228.1646342403401;
        Thu, 03 Mar 2022 13:20:03 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u10-20020a6540ca000000b0037445e95c93sm2780028pgp.15.2022.03.03.13.20.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 13:20:02 -0800 (PST)
Message-ID: <968510d6-6101-ca0f-95a0-f8cb8807b0da@kernel.dk>
Date:   Thu, 3 Mar 2022 14:19:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
 <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
 <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
 <66bfc962-b983-e737-7c36-85784c52b7fa@kernel.dk>
 <8466f91e-416e-d53e-8c24-47a0b20412ac@kernel.dk>
In-Reply-To: <8466f91e-416e-d53e-8c24-47a0b20412ac@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/3/22 1:41 PM, Jens Axboe wrote:
> On 3/3/22 10:18 AM, Jens Axboe wrote:
>> On 3/3/22 9:31 AM, Jens Axboe wrote:
>>> On 3/3/22 7:40 AM, Jens Axboe wrote:
>>>> On 3/3/22 7:36 AM, Jens Axboe wrote:
>>>>> The only potential oddity here is that the fd passed back is not a
>>>>> legitimate fd. io_uring does support poll(2) on its file descriptor, so
>>>>> that could cause some confusion even if I don't think anyone actually
>>>>> does poll(2) on io_uring.
>>>>
>>>> Side note - the only implication here is that we then likely can't make
>>>> the optimized behavior the default, it has to be an IORING_SETUP_REG
>>>> flag which tells us that the application is aware of this limitation.
>>>> Though I guess close(2) might mess with that too... Hmm.
>>>
>>> Not sure I can find a good approach for that. Tried out your patch and
>>> made some fixes:
>>>
>>> - Missing free on final tctx free
>>> - Rename registered_files to registered_rings
>>> - Fix off-by-ones in checking max registration count
>>> - Use kcalloc
>>> - Rename ENTER_FIXED_FILE -> ENTER_REGISTERED_RING
>>> - Don't pass in tctx to io_uring_unreg_ringfd()
>>> - Get rid of forward declaration for adding tctx node
>>> - Get rid of extra file pointer in io_uring_enter()
>>> - Fix deadlock in io_ringfd_register()
>>> - Use io_uring_rsrc_update rather than add a new struct type
>>
>> - Allow multiple register/unregister instead of enforcing just 1 at the
>>   time
>> - Check for it really being a ring fd when registering
>>
>> For different batch counts, nice improvements are seen. Roughly:
>>
>> Batch==1	15% faster
>> Batch==2	13% faster
>> Batch==4	11% faster
>>
>> This is just in microbenchmarks where the fdget/fdput play a bigger
>> factor, but it will certainly help with real world situations where
>> batching is more limited than in benchmarks.
> 
> In trying this out in applications, I think the better registration API
> is to allow io_uring to pick the offset. The application doesn't care,
> it's just a magic integer there. And if we allow io_uring to pick it,
> then that makes things a lot easier to deal with.
> 
> For registration, pass in an array of io_uring_rsrc_update structs, just
> filling in the ring_fd in the data field. Return value is number of ring
> fds registered, and up->offset now contains the chosen offset for each
> of them.
> 
> Unregister is the same struct, but just with offset filled in.
> 
> For applications using io_uring, which is all of them as far as I'm
> aware, we can also easily hide this. This means we can get the optimized
> behavior by default.

Only complication here is if the ring is shared across threads or
processes. The thread one can be common, one thread doing submit and one
doing completions. That one is a bit harder to handle. Without
inheriting registered ring fds, not sure how it can be handled by
default. Should probably just introduce a new queue init helper, but
then that requires application changes to adopt...

Ideas welcome!

-- 
Jens Axboe

