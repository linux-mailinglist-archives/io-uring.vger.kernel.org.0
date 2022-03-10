Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183234D3F72
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 04:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbiCJDBk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 22:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiCJDBk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 22:01:40 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D6A124C25
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 19:00:40 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id s42so3991758pfg.0
        for <io-uring@vger.kernel.org>; Wed, 09 Mar 2022 19:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=E/dSH0Kfhl1s12OdbtenOvD9QnZIr6FLI2hQXGAw3XQ=;
        b=2AJp0JDIKVuazoN6pj7sowRJwm2AWHcA4rxlggW0BR9JMr3Zo/DRkMbLYh/qfWXTgN
         k5YqSOfIPCwq5go+jcOw31rHNeibCJzs38hD/qBjTRJWwSbgESbp7wXdUTeVIxMrKjUa
         JSLsW3mP5FmVHlAV2e0EIiyDG0BpQJQsIVhyPLziSBNjlfk4zEfHavbSDH25KrhwqESv
         JYyNHXvHzXkkpHHHk4L88CpmkXudNCGEJJb+fjCjedWNkWsHaJqHxbvClrh5dG8OdtBW
         U+kbT64+cmMvRC+I/diqrtXun5qOGfs/f5zMiGB30HhHwY+pJm19vguaA39Z148XlQnu
         DLwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=E/dSH0Kfhl1s12OdbtenOvD9QnZIr6FLI2hQXGAw3XQ=;
        b=O4fEaM1QolZWKNptkNZxBudPz8ipu/cwLN7VSj4LTsJ7ODVhnykG3HxnpdNxV9yXEu
         D4EJ5ESoqszbIow9nJN/OO4Quczu5YqAzTDmLvFL1W9V5qN5cTJSQhuAA42Sqpb0ADo5
         cYC3m4TvDA9B8qD0RW4cjHIeX4VG3yqBeSOVaodqitGW5QPrXPrSwQmIiJr/YcsRNeke
         e3d4QPe16Xt4ew/Wuhne/PqVd2lirXrGpa1n8RNFspUmIfelz7wEsZHMWc6UT356JMso
         97oGr4ZYM4ggk5Yf6rjUTvpDYoGYZpFUbHoirBiBpyPhzL6zm6Sqhxq6erpnM4q1WUaf
         6XMg==
X-Gm-Message-State: AOAM533CNY0po8y082lWV7mUqcQ4sgCy3K5PkZS3SA60Q8i3ksiC75GI
        wFXyxPSqquR+qavCkDgOrIJZdEL8i1C0U0F7
X-Google-Smtp-Source: ABdhPJxRaT3pFlOfcHBa5qPMAdF6BSo8tZsfWeCPFWlZnt8aGWtRT/N1RrQF1dsW6cEckeBI0Cg4/w==
X-Received: by 2002:a63:950a:0:b0:375:64a3:f98c with SMTP id p10-20020a63950a000000b0037564a3f98cmr2348700pgd.22.1646881239388;
        Wed, 09 Mar 2022 19:00:39 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v14-20020a056a00148e00b004e1cee6f6b4sm4785713pfu.47.2022.03.09.19.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 19:00:38 -0800 (PST)
Message-ID: <478d1650-139b-f02b-bebf-7d54aa24eae2@kernel.dk>
Date:   Wed, 9 Mar 2022 20:00:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
To:     Artyom Pavlov <newpavlov@gmail.com>, io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
 <c4a02dbd-8dff-a311-ce4a-e7daffd6a22a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c4a02dbd-8dff-a311-ce4a-e7daffd6a22a@gmail.com>
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

On 3/9/22 7:11 PM, Artyom Pavlov wrote:
> 10.03.2022 04:36, Jens Axboe wrote:
>> On 3/9/22 4:49 PM, Artyom Pavlov wrote:
>>> Greetings!
>>>
>>> A common approach for multi-threaded servers is to have a number of
>>> threads equal to a number of cores and launch a separate ring in each
>>> one. AFAIK currently if we want to send an event to a different ring,
>>> we have to write-lock this ring, create SQE, and update the index
>>> ring. Alternatively, we could use some kind of user-space message
>>> passing.
>>>
>>> Such approaches are somewhat inefficient and I think it can be solved
>>> elegantly by updating the io_uring_sqe type to allow accepting fd of a
>>> ring to which CQE must be sent by kernel. It can be done by
>>> introducing an IOSQE_ flag and using one of currently unused padding
>>> u64s.
>>>
>>> Such feature could be useful for load balancing and message passing
>>> between threads which would ride on top of io-uring, i.e. you could
>>> send NOP with user_data pointing to a message payload.
>>
>> So what you want is a NOP with 'fd' set to the fd of another ring, and
>> that nop posts a CQE on that other ring? I don't think we'd need IOSQE
>> flags for that, we just need a NOP that supports that. I see a few ways
>> of going about that:
>>
>> 1) Add a new 'NOP' that takes an fd, and validates that that fd is an
>>     io_uring instance. It can then grab the completion lock on that ring
>>     and post an empty CQE.
>>
>> 2) We add a FEAT flag saying NOP supports taking an 'fd' argument, where
>>     'fd' is another ring. Posting CQE same as above.
>>
>> 3) We add a specific opcode for this. Basically the same as #2, but
>>     maybe with a more descriptive name than NOP.
>>
>> Might make sense to pair that with a CQE flag or something like that, as
>> there's no specific user_data that could be used as it doesn't match an
>> existing SQE that has been issued. IORING_CQE_F_WAKEUP for example.
>> Would be applicable to all the above cases.
>>
>> I kind of like #3 the best. Add a IORING_OP_RING_WAKEUP command, require
>> that sqe->fd point to a ring (could even be the ring itself, doesn't
>> matter). And add IORING_CQE_F_WAKEUP as a specific flag for that.
>>
> 
> No, ideally I would like to be able to send any type of SQE to a
> different ring. For example, if I see that the current ring is
> overloaded, I can create exactly the same SQEs as during usual
> operation, but with a changed recipient ring.
> 
> Your approach with a new "sendable" NOP will allow to emulate it in
> user-space, but it will involve unnecessary ring round-trip and will
> be a bit less pleasant in user code, e.g. we would need to encode a
> separate state "the task is being sent to a different ring" instead of
> simply telling io-uring "read data and report CQE on this ring"
> without any intermediate states.

OK, so what you're asking is to be able to submit an sqe to ring1, but
have the completion show up in ring2? With the idea being that the rings
are setup so that you're basing this on which thread should ultimately
process the request when it completes, which is why you want it to
target another ring?

It'd certainly be doable, but it's a bit of a strange beast. My main
concern with that would be:

1) It's a fast path code addition to every request, we'd need to check
   some new field (sqe->completion_ring_fd) and then also grab a
   reference to that file for use at completion time.

2) Completions are protected by the completion lock, and it isn't
   trivial to nest these. What happens if ring1 submits an sqe with
   ring2 as the cqe target, and ring2 submits an sqe with ring1 as the
   cqe target? We can't safely nest these, as we could easily introduce
   deadlocks that way.

My knee jerk reaction is that it'd be both simpler and cheaper to
implement this in userspace... Unless there's an elegant solution to it,
which I don't immediately see.

-- 
Jens Axboe

