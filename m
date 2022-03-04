Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD7C4CCA82
	for <lists+io-uring@lfdr.de>; Fri,  4 Mar 2022 01:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiCDAIL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 19:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiCDAIK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 19:08:10 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6A0ED943
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 16:07:24 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b8so5997354pjb.4
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 16:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=omp/Ehf5co0rXi410Dnz8uYWp0IA37EPZcmaAAC19BA=;
        b=5hMjvLNHJX9LecQUvRXY71Kq/bAOfjv6rj4DCkCC2kXvb/OO6cXcyvhIiMKEJl7NYM
         0Xj2B8KYFABBLtNKxBan8c8IKRjb4pScu40g/rLYga6IEopAjDE2c3eF9S2/16LISdx2
         tkuOKnYubOHJ/zQbi+1j7mcg50xOpI7n5kgC3e1BkL8emXqGytxCu5DevuNYdmWPafdx
         I8T4fPKpFdP7FqqekRDVv5CZi7Lof9AbKhU4NRCCNlkakGpCAomS0PWUDNrzUeGzyhHo
         I9yaf4a5XRHkHbIlW1HndJ39wlqfAiT4KXMg8NKKYwtT/dpZbuoGoIdQCg3ueJfv5yQg
         zY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=omp/Ehf5co0rXi410Dnz8uYWp0IA37EPZcmaAAC19BA=;
        b=OBwcQ73TBpf2I++H1H3osvgbDZjq+bDPr8wYeC1+9M+4wHtIser2IwOSiZlRvajQFH
         nE1LG5l58gbvEooTzvHXoYB15kb3k1NFTjNb3I6HJwZ4E/CZautcA8DKQ9dyq6XgmPiz
         a0G1pbWoB2Eu0RgCr+BgrOFuxXO3LUR3NO4speA05J8QNPCsVUSdPDEVusiYQLXq6lKm
         Qy9gml0iWaVKZBNHDAIc8QruU3JPvQq9XRqZ9gGZWhCBfuk5I4P3FO3QkOXQ+YcHp8Gk
         80jzCPgBS/IEJ0MNnmhuXI0SYqllfffv6qxM6Op2KQoX1SFh7ldUa3kWckw1DIwgW6U/
         jkbg==
X-Gm-Message-State: AOAM530W6euiOGCSjWyyMsVZ/5wAiub8VSF5sgaoEjdbVkZVNERo9/mp
        KDtNUefVjTcw/kW3E/im5wJeGg==
X-Google-Smtp-Source: ABdhPJx6hEuPDnISXZaHB5528NIs6RMcHir9Axew9dSV+vb2wE+UHatr2fBaxnibFpg7TS9OP+zaTQ==
X-Received: by 2002:a17:903:1248:b0:151:9708:d586 with SMTP id u8-20020a170903124800b001519708d586mr10653886plh.15.1646352443464;
        Thu, 03 Mar 2022 16:07:23 -0800 (PST)
Received: from ?IPV6:2600:380:775f:d591:2b28:c186:9b52:b4ae? ([2600:380:775f:d591:2b28:c186:9b52:b4ae])
        by smtp.gmail.com with ESMTPSA id cv15-20020a17090afd0f00b001bedcbca1a9sm8888363pjb.57.2022.03.03.16.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 16:07:22 -0800 (PST)
Message-ID: <6b1a48d5-7991-b686-06fa-22ac23650992@kernel.dk>
Date:   Thu, 3 Mar 2022 17:07:21 -0700
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
 <968510d6-6101-ca0f-95a0-f8cb8807b0da@kernel.dk>
In-Reply-To: <968510d6-6101-ca0f-95a0-f8cb8807b0da@kernel.dk>
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

On 3/3/22 2:19 PM, Jens Axboe wrote:
> On 3/3/22 1:41 PM, Jens Axboe wrote:
>> On 3/3/22 10:18 AM, Jens Axboe wrote:
>>> On 3/3/22 9:31 AM, Jens Axboe wrote:
>>>> On 3/3/22 7:40 AM, Jens Axboe wrote:
>>>>> On 3/3/22 7:36 AM, Jens Axboe wrote:
>>>>>> The only potential oddity here is that the fd passed back is not a
>>>>>> legitimate fd. io_uring does support poll(2) on its file descriptor, so
>>>>>> that could cause some confusion even if I don't think anyone actually
>>>>>> does poll(2) on io_uring.
>>>>>
>>>>> Side note - the only implication here is that we then likely can't make
>>>>> the optimized behavior the default, it has to be an IORING_SETUP_REG
>>>>> flag which tells us that the application is aware of this limitation.
>>>>> Though I guess close(2) might mess with that too... Hmm.
>>>>
>>>> Not sure I can find a good approach for that. Tried out your patch and
>>>> made some fixes:
>>>>
>>>> - Missing free on final tctx free
>>>> - Rename registered_files to registered_rings
>>>> - Fix off-by-ones in checking max registration count
>>>> - Use kcalloc
>>>> - Rename ENTER_FIXED_FILE -> ENTER_REGISTERED_RING
>>>> - Don't pass in tctx to io_uring_unreg_ringfd()
>>>> - Get rid of forward declaration for adding tctx node
>>>> - Get rid of extra file pointer in io_uring_enter()
>>>> - Fix deadlock in io_ringfd_register()
>>>> - Use io_uring_rsrc_update rather than add a new struct type
>>>
>>> - Allow multiple register/unregister instead of enforcing just 1 at the
>>>   time
>>> - Check for it really being a ring fd when registering
>>>
>>> For different batch counts, nice improvements are seen. Roughly:
>>>
>>> Batch==1	15% faster
>>> Batch==2	13% faster
>>> Batch==4	11% faster
>>>
>>> This is just in microbenchmarks where the fdget/fdput play a bigger
>>> factor, but it will certainly help with real world situations where
>>> batching is more limited than in benchmarks.
>>
>> In trying this out in applications, I think the better registration API
>> is to allow io_uring to pick the offset. The application doesn't care,
>> it's just a magic integer there. And if we allow io_uring to pick it,
>> then that makes things a lot easier to deal with.
>>
>> For registration, pass in an array of io_uring_rsrc_update structs, just
>> filling in the ring_fd in the data field. Return value is number of ring
>> fds registered, and up->offset now contains the chosen offset for each
>> of them.
>>
>> Unregister is the same struct, but just with offset filled in.
>>
>> For applications using io_uring, which is all of them as far as I'm
>> aware, we can also easily hide this. This means we can get the optimized
>> behavior by default.
> 
> Only complication here is if the ring is shared across threads or
> processes. The thread one can be common, one thread doing submit and one
> doing completions. That one is a bit harder to handle. Without
> inheriting registered ring fds, not sure how it can be handled by
> default. Should probably just introduce a new queue init helper, but
> then that requires application changes to adopt...
> 
> Ideas welcome!

Don't see a way to do it by default, so I think it'll have to be opt-in.
We could make it the default if you never shared a ring, which most
people don't do, but we can't easily do so if it's ever shared between
tasks or processes.

With liburing, if you share, you share the io_uring struct as well. So
it's hard to maintain a new ->enter_ring_fd in there. It'd be doable if
we could reserve real fd == registered fd. Which is of course possible
using xarray or similar, but that'll add extra overhead.

Anyway, current version below. Only real change here is allowing either
specific offset or generated offset, depending on what the
io_uring_rsrc_update->offset is set to. If set to -1U, then io_uring
will find a free offset. If set to anything else, io_uring will use that
index (as long as it's >=0 && < MAX).

-- 
Jens Axboe

