Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC12251E61F
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 11:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446231AbiEGJej (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 05:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446230AbiEGJef (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 05:34:35 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2719737AA3;
        Sat,  7 May 2022 02:30:39 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id w4so12995322wrg.12;
        Sat, 07 May 2022 02:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ES1pXES2giJ8KOF2aZPm/MgYCN7hJ8uCPToioT3vSKs=;
        b=jSC17tjp6qzS/TpMVbtEd3Tg3zARblNvdAY1Ol5n6O16uGUYiFhyaQ5IPZeNPENces
         Dzpc8yaGxYch+5sLvI2aX0jDyBAZMYZubczfUwqd7MT2/BIy2e1nZOkoz5sM/4cD5VYw
         HwkM/tPKHOeJJuESNfYtyy4lpnjQjg4gN43ePwUGyq+984io82+Jx1iLIKzkAma0lsBS
         hun80wMgtVHxvYb98TxN5bUCBrkO9u7EIm7AY5GGycimRBsic6j05Y+1ny/ebiF1rel5
         jZ+PZ3gr4Mj6i4bLEdpiImP5BcolBKzATl1ywC2leaTQCqjhBYg/++ezVOXtM/qFLzdk
         oqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ES1pXES2giJ8KOF2aZPm/MgYCN7hJ8uCPToioT3vSKs=;
        b=oGNDtnz255rYZLvimwhD2XWAczug3j0tfGYeQqbSpInynEB4ByXFnOydnruTAAe+vg
         qfWKGZuhh05y1ENwaB0/zlLnkuXi8/mhW17ZWuQn3LkFcmDI/SO57VCXjPgqIqeC/hyY
         nNvG4n7IHpJJSwqpE683O0Q8arAhpkgYO59nsNFeKZpNa3hxo92H83ediiGy1dkYeKO/
         tAwfseB0rvMOR+Dpscx65t0tAZ9vPwP7PYnebJhu3iZ8NBigNuLPSviQDd329KOpU8gk
         iN0r3zkJLjFm0u0yDCwOvD7HvQs9DX+S33FBDD3RLXNYew/eLN46go4vc7qgqVJo9tbb
         yeMQ==
X-Gm-Message-State: AOAM531+F0h8FUA0P3AsCRXUcuA9TnnulOg7Q7s68KtHUd9LBeY7t6Ub
        cSGAAOZdrLcWDHsdE3z8Av0=
X-Google-Smtp-Source: ABdhPJyrVpIY+vTyGlo87mvnoS+sNlIByrIXT7/AAwWQ2aOO5XIqXpXxisQ9QoeGQYGl/fUPDqqmtg==
X-Received: by 2002:a5d:61c2:0:b0:20a:d92f:9056 with SMTP id q2-20020a5d61c2000000b0020ad92f9056mr5903610wrv.652.1651915838375;
        Sat, 07 May 2022 02:30:38 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.237.69])
        by smtp.gmail.com with ESMTPSA id n11-20020a056000170b00b0020c5253d8c7sm5396924wrc.19.2022.05.07.02.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 02:30:37 -0700 (PDT)
Message-ID: <f0af8012-7550-022a-d3f3-0882d4dee1de@gmail.com>
Date:   Sat, 7 May 2022 10:29:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 4/5] io_uring: add a helper for poll clean
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-5-haoxu.linux@gmail.com>
 <28b1901e-3eb2-2a50-525c-62e1aa39eaac@gmail.com>
 <6f59afd3-a591-90fd-0428-3572d910b689@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6f59afd3-a591-90fd-0428-3572d910b689@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/22 07:43, Hao Xu wrote:
> 在 2022/5/7 上午12:22, Pavel Begunkov 写道:
>> On 5/6/22 08:01, Hao Xu wrote:
>>> From: Hao Xu <howeyxu@tencent.com>
>>>
>>> Add a helper for poll clean, it will be used in the multishot accept in
>>> the later patches.
>>>
>>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>>> ---
>>>   fs/io_uring.c | 23 ++++++++++++++++++-----
>>>   1 file changed, 18 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index d33777575faf..0a83ecc457d1 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -5711,6 +5711,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>       return 0;
>>>   }
>>> +static inline void __io_poll_clean(struct io_kiocb *req)
>>> +{
>>> +    struct io_ring_ctx *ctx = req->ctx;
>>> +
>>> +    io_poll_remove_entries(req);
>>> +    spin_lock(&ctx->completion_lock);
>>> +    hash_del(&req->hash_node);
>>> +    spin_unlock(&ctx->completion_lock);
>>> +}
>>> +
>>> +#define REQ_F_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
>>> +static inline void io_poll_clean(struct io_kiocb *req)
>>> +{
>>> +    if ((req->flags & REQ_F_APOLL_MULTI_POLLED) == REQ_F_APOLL_MULTI_POLLED)
>>
>> So it triggers for apoll multishot only when REQ_F_POLLED is _not_ set,
>> but if it's not set it did never go through arm_poll / etc. and there is
>> nothing to clean up. What is the catch?
> 
> No, it is triggered for apoll multishot only when REQ_F_POLLED is set..

Ok, see it now, probably confused REQ_F_APOLL_MULTI_POLLED on the right
hand side with something else


>> btw, don't see the function used in this patch, better to add it later
>> or at least mark with attribute unused, or some may get build failures.
> Gotcha.
>>
>>
>>> +        __io_poll_clean(req);
>>> +}
>>> +
>>>   static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>>>   {
>>>       struct io_accept *accept = &req->accept;
>>> @@ -6041,17 +6058,13 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
>>>   static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
>>>   {
>>> -    struct io_ring_ctx *ctx = req->ctx;
>>>       int ret;
>>>       ret = io_poll_check_events(req, locked);
>>>       if (ret > 0)
>>>           return;
>>> -    io_poll_remove_entries(req);
>>> -    spin_lock(&ctx->completion_lock);
>>> -    hash_del(&req->hash_node);
>>> -    spin_unlock(&ctx->completion_lock);
>>> +    __io_poll_clean(req);
>>>       if (!ret)
>>>           io_req_task_submit(req, locked);
>>
> 

-- 
Pavel Begunkov
