Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405815E7D7A
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 16:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbiIWOop (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 10:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiIWOon (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 10:44:43 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10076100D
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:44:42 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id c192-20020a1c35c9000000b003b51339d350so1049003wma.3
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=1YyzqH7/RXrpn9V8IWWPoYJCc/jqyj/RbY3A/pYepx8=;
        b=Q7gTZpe5saKjD5BQhu7FLcJn5iZbKAiV8zgZxHJmMk8DpFrsbQ2vwYYCvfplwWs+Rv
         JHVC6BsXnvmiXlEdkyYOOlETZsO9S+XUgOnPQ3BFCm58CTOXnt+5OGWxx9QLArIxea7I
         2ClgvcM2aYs5CzCp5s7kjHqZS6j9FT7zJIMZTJtBPJKF9MOBZH2tysA2Svu30BRqusyg
         Vu8u14/o9n8MUxc90hEYgp8YgQ77bKJZh4jhWzeuTKewIGDNV6dneKgz9iSWt4quo+7K
         D/8J/M15ETV7+vUfJvJmPuKUAN/sMA6eedeVAAAAh4mPiJ1kIGGqyw6Z8HBuV2OljXS4
         VkSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=1YyzqH7/RXrpn9V8IWWPoYJCc/jqyj/RbY3A/pYepx8=;
        b=JVHr/FBMrhefjwfeIjj3Ocva0L01k6U9FV+jmB8wqEQObtxOAJE0f5tH08WwOcxsLD
         3xT16SWXbPxaWdmiwadC4JdYoKdgm8JgwSSUUHkpaFOM8l0m+6lSKoA/R9jPNfdpds10
         lZIVJ5McQ2jP49fNWJmmotv71eLyD/xLAVGbkHpi93Gd9yHdmVscfvFJ+CFwoynoMi4o
         D6rqxFXsqKVY15nXgZjKGZmXKQQNqyyltGXQPCicKY3rd3v6In3ZfTSfFJn0y1q9AIwK
         Aiz0Br6aDvsgyl5bgbPRZAejSv34y/nGQbX7cbd3f2MPa/GgjU3rH6WYRYRR7jidg/U5
         ZLvA==
X-Gm-Message-State: ACrzQf1Rz4EIybnCUBLm8SGrv/qBMwJR7giIKFdBopBId+HroYpCVdvk
        YD5hQun7jaSpI7W2gTteA8dIgIwsoWc=
X-Google-Smtp-Source: AMsMyM4TkZoqJTyCdBg592j70ngjKACHQ9tzxW9Aj67QBwhRaNMrk6zLMGH7NJIhVxpHSQJOGeTubA==
X-Received: by 2002:a7b:ca53:0:b0:3b4:90c4:e07 with SMTP id m19-20020a7bca53000000b003b490c40e07mr6381131wml.150.1663944280511;
        Fri, 23 Sep 2022 07:44:40 -0700 (PDT)
Received: from [192.168.8.198] (188.28.201.74.threembb.co.uk. [188.28.201.74])
        by smtp.gmail.com with ESMTPSA id k22-20020a05600c1c9600b003b340f00f10sm2918472wms.31.2022.09.23.07.44.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 07:44:40 -0700 (PDT)
Message-ID: <2789dabf-519f-6c01-c60e-f015a4312c36@gmail.com>
Date:   Fri, 23 Sep 2022 15:43:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH for-next] io_uring: fix CQE reordering
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Dylan Yudaken <dylany@fb.com>
References: <ec3bc55687b0768bbe20fb62d7d06cfced7d7e70.1663892031.git.asml.silence@gmail.com>
 <30718187-8558-4b32-b8d1-5c1f4f322d4f@kernel.dk>
 <56c084c9-8920-dfa6-74d7-9b0ff8423b67@gmail.com>
 <4bf24140-ddbf-f6ea-22c9-42d754e96cec@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4bf24140-ddbf-f6ea-22c9-42d754e96cec@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/23/22 15:35, Jens Axboe wrote:
> On 9/23/22 8:26 AM, Pavel Begunkov wrote:
>> On 9/23/22 15:19, Jens Axboe wrote:
>>> On 9/23/22 7:53 AM, Pavel Begunkov wrote:
>>>> Overflowing CQEs may result in reordeing, which is buggy in case of
>>>> links, F_MORE and so.
>>>>
>>>> Reported-by: Dylan Yudaken <dylany@fb.com>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>    io_uring/io_uring.c | 12 ++++++++++--
>>>>    io_uring/io_uring.h | 12 +++++++++---
>>>>    2 files changed, 19 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> index f359e24b46c3..62d1f55fde55 100644
>>>> --- a/io_uring/io_uring.c
>>>> +++ b/io_uring/io_uring.c
>>>> @@ -609,7 +609,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
>>>>          io_cq_lock(ctx);
>>>>        while (!list_empty(&ctx->cq_overflow_list)) {
>>>> -        struct io_uring_cqe *cqe = io_get_cqe(ctx);
>>>> +        struct io_uring_cqe *cqe = io_get_cqe_overflow(ctx, true);
>>>>            struct io_overflow_cqe *ocqe;
>>>>              if (!cqe && !force)
>>>> @@ -736,12 +736,19 @@ bool io_req_cqe_overflow(struct io_kiocb *req)
>>>>     * control dependency is enough as we're using WRITE_ONCE to
>>>>     * fill the cq entry
>>>>     */
>>>> -struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
>>>> +struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
>>>>    {
>>>>        struct io_rings *rings = ctx->rings;
>>>>        unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
>>>>        unsigned int free, queued, len;
>>>>    +    /*
>>>> +     * Posting into the CQ when there are pending overflowed CQEs may break
>>>> +     * ordering guarantees, which will affect links, F_MORE users and more.
>>>> +     * Force overflow the completion.
>>>> +     */
>>>> +    if (!overflow && (ctx->check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)))
>>>> +        return NULL;
>>>
>>> Rather than pass this bool around for the hot path, why not add a helper
>>> for the case where 'overflow' isn't known? That can leave the regular
>>> io_get_cqe() avoiding this altogether.
>>
>> Was choosing from two ugly-ish solutions, but io_get_cqe() should be
>> inline and shouldn't really matter, but that's only the case in theory
>> though. If someone cleans up the CQE32 part and puts it into a separate
>> non-inline function, it'll be actually inlined.
> 
> Yes, in theory the current one will be fine as it's known at compile
> time. In theory... Didn't check if practice agrees with that, would
> prefer if we didn't leave this to the compiler. Fiddling some other
> bits, will check in a bit if I have a better idea.

When inline constants are propagated to the moment they're needed,
no sane compiler will do otherwise, that's one of the most basic
optimisations. Don't think it's sane not relying on that.

-- 
Pavel Begunkov
