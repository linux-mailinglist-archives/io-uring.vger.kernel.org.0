Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A32B4D4838
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 14:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242512AbiCJNia (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 08:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236870AbiCJNi3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 08:38:29 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAF714F2BC
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 05:37:07 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id m42-20020a05600c3b2a00b00382ab337e14so5446096wms.3
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 05:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=t01d7DZUeVTS0b6xXmSJgoao5+zwN5iU4o+ZQVS/n1E=;
        b=lCoP08hhVgFmhqtfdM5tvo6I29fFKQizHFdXrRW1xl9xcJZ94cq1ciyK4Z+yMA8LJl
         9rXgCGS7RQvUH/QPYPmVeLM69nmvlEsOvniga0H5jiwcDTq/WW2a8CBGzZljN1Og8HBb
         REsCY7VKzFH9CtuIWT0cKC1VRy3hKIHvHL9Ql1Sj+5j5E96Xr+bnZ01pmAyI3PE7T/lv
         ZuaJkkf9HHZv43kTd9sJTFa+eu/bNEvdm1QUG1enOrqdPyzbm9K0/aFGFOMmU3qbCAGP
         8u38E6tuykFnbbZRgSIEPkdtNDumk+AJ+xBw9fxYNmszqpLMekPHD0s5ld49t2KfNP5/
         mOIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=t01d7DZUeVTS0b6xXmSJgoao5+zwN5iU4o+ZQVS/n1E=;
        b=u34dnEBZ8GlPyeDQRWlpL7FqfA4XzqMEbI1mlgFneGoMB17pUuEwfN+VZ0Cic4AHIs
         NRsRdu1uf4WyzfftgitSsB6+5m1Nh+teZsQDZ1dFkURKeQPFmuf/6ezweaxdJN6w004Z
         0uOfAuN+APYFFPMd0dqlx/MBrRALSnqw0GDB5wY0ReKpvtSWq7VhTI2905zjcgmNyeQx
         agiTTg6rIYRSiVYM9x8OPtQUJJk11LJynLkccLYwJORslxxnMx9mlPaEYOBvirUruWAu
         b3xV6bZCt96Djz5KdRPgHFVPadYtZnWKL6BEDuvIGgzfNqE+k9txZ9L841rKCi7BQ1km
         vMKA==
X-Gm-Message-State: AOAM531v+ijaaI3vXpfXD8rYZXpg9ggKp/6020DJMrt2NtT81VYAI6hk
        8Vj+BNY2Ss4qEAGgOTiyh9g=
X-Google-Smtp-Source: ABdhPJyX7ydClqCSErivP9ld4Pe3lpvoRKOfGQftfEW1AZA3sckTKJmRdGAAYzcpbAUBH9H2xxWVxw==
X-Received: by 2002:a05:600c:1d18:b0:389:cda6:f39f with SMTP id l24-20020a05600c1d1800b00389cda6f39fmr8469686wms.69.1646919426070;
        Thu, 10 Mar 2022 05:37:06 -0800 (PST)
Received: from [192.168.8.198] ([85.255.237.75])
        by smtp.gmail.com with ESMTPSA id n2-20020a056000170200b001f1e16f3c53sm4282470wrc.51.2022.03.10.05.37.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 05:37:05 -0800 (PST)
Message-ID: <745ea281-8e34-d92a-214b-ab2fc421acb8@gmail.com>
Date:   Thu, 10 Mar 2022 13:34:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Artyom Pavlov <newpavlov@gmail.com>,
        io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
 <c4a02dbd-8dff-a311-ce4a-e7daffd6a22a@gmail.com>
 <478d1650-139b-f02b-bebf-7d54aa24eae2@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <478d1650-139b-f02b-bebf-7d54aa24eae2@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/10/22 03:00, Jens Axboe wrote:
> On 3/9/22 7:11 PM, Artyom Pavlov wrote:
>> 10.03.2022 04:36, Jens Axboe wrote:
>>> On 3/9/22 4:49 PM, Artyom Pavlov wrote:
>>>> Greetings!
>>>>
>>>> A common approach for multi-threaded servers is to have a number of
>>>> threads equal to a number of cores and launch a separate ring in each
>>>> one. AFAIK currently if we want to send an event to a different ring,
>>>> we have to write-lock this ring, create SQE, and update the index
>>>> ring. Alternatively, we could use some kind of user-space message
>>>> passing.
>>>>
>>>> Such approaches are somewhat inefficient and I think it can be solved
>>>> elegantly by updating the io_uring_sqe type to allow accepting fd of a
>>>> ring to which CQE must be sent by kernel. It can be done by
>>>> introducing an IOSQE_ flag and using one of currently unused padding
>>>> u64s.
>>>>
>>>> Such feature could be useful for load balancing and message passing
>>>> between threads which would ride on top of io-uring, i.e. you could
>>>> send NOP with user_data pointing to a message payload.
>>>
>>> So what you want is a NOP with 'fd' set to the fd of another ring, and
>>> that nop posts a CQE on that other ring? I don't think we'd need IOSQE
>>> flags for that, we just need a NOP that supports that. I see a few ways
>>> of going about that:
>>>
>>> 1) Add a new 'NOP' that takes an fd, and validates that that fd is an
>>>      io_uring instance. It can then grab the completion lock on that ring
>>>      and post an empty CQE.
>>>
>>> 2) We add a FEAT flag saying NOP supports taking an 'fd' argument, where
>>>      'fd' is another ring. Posting CQE same as above.
>>>
>>> 3) We add a specific opcode for this. Basically the same as #2, but
>>>      maybe with a more descriptive name than NOP.
>>>
>>> Might make sense to pair that with a CQE flag or something like that, as
>>> there's no specific user_data that could be used as it doesn't match an
>>> existing SQE that has been issued. IORING_CQE_F_WAKEUP for example.
>>> Would be applicable to all the above cases.
>>>
>>> I kind of like #3 the best. Add a IORING_OP_RING_WAKEUP command, require
>>> that sqe->fd point to a ring (could even be the ring itself, doesn't
>>> matter). And add IORING_CQE_F_WAKEUP as a specific flag for that.
>>>
>>
>> No, ideally I would like to be able to send any type of SQE to a
>> different ring. For example, if I see that the current ring is
>> overloaded, I can create exactly the same SQEs as during usual
>> operation, but with a changed recipient ring.
>>
>> Your approach with a new "sendable" NOP will allow to emulate it in
>> user-space, but it will involve unnecessary ring round-trip and will
>> be a bit less pleasant in user code, e.g. we would need to encode a
>> separate state "the task is being sent to a different ring" instead of
>> simply telling io-uring "read data and report CQE on this ring"
>> without any intermediate states.
> 
> OK, so what you're asking is to be able to submit an sqe to ring1, but
> have the completion show up in ring2? With the idea being that the rings
> are setup so that you're basing this on which thread should ultimately
> process the request when it completes, which is why you want it to
> target another ring?
> 
> It'd certainly be doable, but it's a bit of a strange beast. My main
> concern with that would be:
> 
> 1) It's a fast path code addition to every request, we'd need to check
>     some new field (sqe->completion_ring_fd) and then also grab a
>     reference to that file for use at completion time.
> 
> 2) Completions are protected by the completion lock, and it isn't
>     trivial to nest these. What happens if ring1 submits an sqe with
>     ring2 as the cqe target, and ring2 submits an sqe with ring1 as the
>     cqe target? We can't safely nest these, as we could easily introduce
>     deadlocks that way.
> 
> My knee jerk reaction is that it'd be both simpler and cheaper to
> implement this in userspace... Unless there's an elegant solution to it,
> which I don't immediately see.

Per request fd will be ugly and slow unfortunately. As people asked about
a similar thing before, the only thing I can suggest is to add a way
to pass another SQ. The execution will be slower, but at least can be
made zero overhead for the normal path.

-- 
Pavel Begunkov
