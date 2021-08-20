Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C29C3F3616
	for <lists+io-uring@lfdr.de>; Fri, 20 Aug 2021 23:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240667AbhHTVdQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 17:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240615AbhHTVdQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 17:33:16 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A2FC061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 14:32:37 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h13so16113216wrp.1
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 14:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5ydIt7NwdtBytYRLesfNAW371UG+bNQonkO0/eEtwe0=;
        b=dK7i6TIs0UOq/nPCK9GpoVr66tgenBHBbokAhh9aJlz+b3y2eAUceg9O38LZ/9m5wy
         J8ktFDpeQL+XyG8fMMu8mut4zlI/zszeu6px9j56gFILFyMZjDPKO+j4EOm03XD8Vafc
         q4xgKurYwINhV3VBY3X9CzroH0eJz67s1qya7gJWisN/kOm5qdRqOodrQAkOEw75auiO
         T99qVMKMcz/bHGfcjz5xk8Cl+gUHZdz5kK8OB/y3e2iPJ33ml4AVN08KLjHCfDUDpEtS
         q5hvuxGZpwNRphhS9QwTIb9tbxC/fv94hxhzOuD2W0Hq5gslEX+chPm5MKZXD9Xpn7+q
         Ny6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5ydIt7NwdtBytYRLesfNAW371UG+bNQonkO0/eEtwe0=;
        b=NMi7vY7/8NLj9kjIL5DXXcI2j9CvACk6YB4oqh0iivM9YKVO5YSkrA+cz0VGqc4Odg
         6CQbi1mvEpRgmn2ceMRlpTGUtFlJjgabVHjcoSxVQ+BV5XEKJd2tCos0zP3tHBTO2Raq
         +zbi/Atuq3dz+jccALiZ94SoNJO+tFiBrfrXRyvAxH44C/qszdWHGXiV2uhS/JoVKpaC
         6/hy1o4xmyV+5arxLqKEUZqMTdrDTHwOQ17e7QcTL1EKN5wD48VJwCfrQbNJXJO56nxm
         8t5jpNW2pJ69bJzA/ZA4FLqlJFcZelM5yDHfTN08wk4yyLaTObbTl6u2yjaH1YEw2ucr
         wDzQ==
X-Gm-Message-State: AOAM531qbplpnN/JyG/RcqeK1KRa5AiKU72mTaa3wuqcI94Vvhm/9ZqL
        8aLR6KT6ByQ1VERmd4U9Se4=
X-Google-Smtp-Source: ABdhPJwGgD5YihADIjbSd6O1uSihMLWgQTTFx1Q/uQNGazl6VA4REuo1/W/Gf+ZZAF+5d/1MQnz2dQ==
X-Received: by 2002:adf:cf0e:: with SMTP id o14mr793251wrj.329.1629495156341;
        Fri, 20 Aug 2021 14:32:36 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id q13sm2000507wrv.79.2021.08.20.14.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 14:32:35 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210820184013.195812-1-haoxu@linux.alibaba.com>
 <c2e5476e-86b8-a45f-642e-6a3c2449bfa2@gmail.com>
 <4b6d903b-09ec-0fca-fa70-4c6c32a0f5cb@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH for-5.15] io_uring: fix lacking of protection for compl_nr
Message-ID: <68755d6f-8049-463f-f372-0ddc978a963e@gmail.com>
Date:   Fri, 20 Aug 2021 22:32:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <4b6d903b-09ec-0fca-fa70-4c6c32a0f5cb@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/21 9:39 PM, Hao Xu wrote:
> 在 2021/8/21 上午2:59, Pavel Begunkov 写道:
>> On 8/20/21 7:40 PM, Hao Xu wrote:
>>> coml_nr in ctx_flush_and_put() is not protected by uring_lock, this
>>> may cause problems when accessing it parallelly.
>>
>> Did you hit any problem? It sounds like it should be fine as is:
>>
>> The trick is that it's only responsible to flush requests added
>> during execution of current call to tctx_task_work(), and those
>> naturally synchronised with the current task. All other potentially
>> enqueued requests will be of someone else's responsibility.
>>
>> So, if nobody flushed requests, we're finely in-sync. If we see
>> 0 there, but actually enqueued a request, it means someone
>> actually flushed it after the request had been added.
>>
>> Probably, needs a more formal explanation with happens-before
>> and so.
> I should put more detail in the commit message, the thing is:
> say coml_nr > 0
> 
>   ctx_flush_and put                  other context
>    if (compl_nr)                      get mutex
>                                       coml_nr > 0
>                                       do flush
>                                           coml_nr = 0
>                                       release mutex
>         get mutex
>            do flush (*)
>         release mutex
> 
> in (*) place, we do a bunch of unnecessary works, moreover, we

I wouldn't care about overhead, that shouldn't be much

> call io_cqring_ev_posted() which I think we shouldn't.

IMHO, users should expect spurious io_cqring_ev_posted(),
though there were some eventfd users complaining before, so
for them we can do

if (state->nr) {
    lock();
    if (state->nr) flush();
    unlock();
}

>>> Fixes: d10299e14aae ("io_uring: inline struct io_comp_state")
>>
>> FWIW, it came much earlier than this commit, IIRC
>>
>> commit 2c32395d8111037ae2cb8cab883e80bcdbb70713
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Sun Feb 28 22:04:53 2021 +0000
>>
>>      io_uring: fix __tctx_task_work() ctx race
>>
>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   fs/io_uring.c | 7 +++----
>>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index c755efdac71f..420f8dfa5327 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -2003,11 +2003,10 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx)
>>>   {
>>>       if (!ctx)
>>>           return;
>>> -    if (ctx->submit_state.compl_nr) {
>>> -        mutex_lock(&ctx->uring_lock);
>>> +    mutex_lock(&ctx->uring_lock);
>>> +    if (ctx->submit_state.compl_nr)
>>>           io_submit_flush_completions(ctx);
>>> -        mutex_unlock(&ctx->uring_lock);
>>> -    }
>>> +    mutex_unlock(&ctx->uring_lock);
>>>       percpu_ref_put(&ctx->refs);
>>>   }
>>>  
>>
> 

-- 
Pavel Begunkov
