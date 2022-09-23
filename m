Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816265E7D95
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 16:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiIWOwA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 10:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiIWOv7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 10:51:59 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA1C12A4B1
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:51:58 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id e205so122609iof.1
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=sk4wnUXyuSEdfNY9fydggTwdg8ckWgargPIa5P24MuE=;
        b=41zSWk1XadXmuOc6jVOVbOht54ch/7f/zpL9foPux+DSUA4vlMeosi2msbw2ye8wi4
         Ix3t4QkPB6Gq25XN7f9oQY42+3zzCRxCK6+rKlWES9CDt9+udZUjoJWKZQtpAFnwvms6
         VOJKNE8tb+rJ6v377wRDtBvmiLxyccNPs8CvBkoykwYy44P1yhGe0/HV9Pe/Pmji5Y8U
         hyvr7ksxX4jwDPEY7uxL5YWh5+tgoQzQ1IOTynt6Sc/Uj4M8eErfdgHp4tr/Gvj9Sp6o
         0aCLKvzGp+09y9aeHEYwhO3AAdrZxTHAC1H3ltZXluTHhGccZeX36LaaCqEYUhLd3Sp/
         J6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=sk4wnUXyuSEdfNY9fydggTwdg8ckWgargPIa5P24MuE=;
        b=7ldxk1Je93Jw2nu+F3DYeneke91fdtqzSVZ3vpUCg759XcXM7p9QFG3G6X8RsMdT0u
         CvqWw8Bzaro4uX4v1ZAT5vUa4GZE4OoOA2q4n9Z8+LlyZ33yrw7xXk5qdSGZJ7NUMm9i
         1tgOU4yc2OoIHwou25H8Hr+rw0aJ79S4q0jzqHDhgnNutKTphhanN/XQzSASt4rzHPmR
         J/5aFDQzCID8Z77GhTtTesuQEi3KCTzxyprCYJ53zWAm62avt5O94LcRJiiqyy5AEFvE
         zDBV/4bDPRgZEUkBF0QoIqe2Dut5dK4++aVeSMMcl8WWOFNOf3djPpgtkIk2ucdAzFqv
         hdgw==
X-Gm-Message-State: ACrzQf3gVbocGNEAQlUBNo/5EW0eiQb1E7TLiayAQoK4bijxFd6JAREz
        p7GoA0jme64FTPTEL1bF5Xjtqg==
X-Google-Smtp-Source: AMsMyM5I1mWOits2w2KZR6MLkNYIYqZgQ42f8qupSz3sOqbmdqiK+/6XxjmDOEPQlVREMzbMxjMFjg==
X-Received: by 2002:a05:6602:2d89:b0:6a3:8489:fef4 with SMTP id k9-20020a0566022d8900b006a38489fef4mr4209081iow.105.1663944717640;
        Fri, 23 Sep 2022 07:51:57 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b13-20020a056638388d00b0034c10bd52f5sm3478970jav.125.2022.09.23.07.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 07:51:57 -0700 (PDT)
Message-ID: <6cfacb7b-a4c8-5573-20cc-be5842a9d127@kernel.dk>
Date:   Fri, 23 Sep 2022 08:51:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH for-next] io_uring: fix CQE reordering
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Dylan Yudaken <dylany@fb.com>
References: <ec3bc55687b0768bbe20fb62d7d06cfced7d7e70.1663892031.git.asml.silence@gmail.com>
 <30718187-8558-4b32-b8d1-5c1f4f322d4f@kernel.dk>
 <56c084c9-8920-dfa6-74d7-9b0ff8423b67@gmail.com>
 <4bf24140-ddbf-f6ea-22c9-42d754e96cec@kernel.dk>
 <2789dabf-519f-6c01-c60e-f015a4312c36@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2789dabf-519f-6c01-c60e-f015a4312c36@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/23/22 8:43 AM, Pavel Begunkov wrote:
> On 9/23/22 15:35, Jens Axboe wrote:
>> On 9/23/22 8:26 AM, Pavel Begunkov wrote:
>>> On 9/23/22 15:19, Jens Axboe wrote:
>>>> On 9/23/22 7:53 AM, Pavel Begunkov wrote:
>>>>> Overflowing CQEs may result in reordeing, which is buggy in case of
>>>>> links, F_MORE and so.
>>>>>
>>>>> Reported-by: Dylan Yudaken <dylany@fb.com>
>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>> ---
>>>>>    io_uring/io_uring.c | 12 ++++++++++--
>>>>>    io_uring/io_uring.h | 12 +++++++++---
>>>>>    2 files changed, 19 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>> index f359e24b46c3..62d1f55fde55 100644
>>>>> --- a/io_uring/io_uring.c
>>>>> +++ b/io_uring/io_uring.c
>>>>> @@ -609,7 +609,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
>>>>>          io_cq_lock(ctx);
>>>>>        while (!list_empty(&ctx->cq_overflow_list)) {
>>>>> -        struct io_uring_cqe *cqe = io_get_cqe(ctx);
>>>>> +        struct io_uring_cqe *cqe = io_get_cqe_overflow(ctx, true);
>>>>>            struct io_overflow_cqe *ocqe;
>>>>>              if (!cqe && !force)
>>>>> @@ -736,12 +736,19 @@ bool io_req_cqe_overflow(struct io_kiocb *req)
>>>>>     * control dependency is enough as we're using WRITE_ONCE to
>>>>>     * fill the cq entry
>>>>>     */
>>>>> -struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
>>>>> +struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
>>>>>    {
>>>>>        struct io_rings *rings = ctx->rings;
>>>>>        unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
>>>>>        unsigned int free, queued, len;
>>>>>    +    /*
>>>>> +     * Posting into the CQ when there are pending overflowed CQEs may break
>>>>> +     * ordering guarantees, which will affect links, F_MORE users and more.
>>>>> +     * Force overflow the completion.
>>>>> +     */
>>>>> +    if (!overflow && (ctx->check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)))
>>>>> +        return NULL;
>>>>
>>>> Rather than pass this bool around for the hot path, why not add a helper
>>>> for the case where 'overflow' isn't known? That can leave the regular
>>>> io_get_cqe() avoiding this altogether.
>>>
>>> Was choosing from two ugly-ish solutions, but io_get_cqe() should be
>>> inline and shouldn't really matter, but that's only the case in theory
>>> though. If someone cleans up the CQE32 part and puts it into a separate
>>> non-inline function, it'll be actually inlined.
>>
>> Yes, in theory the current one will be fine as it's known at compile
>> time. In theory... Didn't check if practice agrees with that, would
>> prefer if we didn't leave this to the compiler. Fiddling some other
>> bits, will check in a bit if I have a better idea.
> 
> When inline constants are propagated to the moment they're needed,
> no sane compiler will do otherwise, that's one of the most basic
> optimisations. Don't think it's sane not relying on that.

Yeah it's probably fine as-is, I'd expect it to as well for sure.-- 
Jens Axboe


