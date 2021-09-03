Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56B53FFFB9
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 14:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbhICM3U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 08:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhICM3Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 08:29:16 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC28C061575
        for <io-uring@vger.kernel.org>; Fri,  3 Sep 2021 05:28:16 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b6so7986153wrh.10
        for <io-uring@vger.kernel.org>; Fri, 03 Sep 2021 05:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RZUltNxN8swjKZJxh9uDkp4MdgFsPnFWDUBfK/eqmSs=;
        b=mg4rjNkDJUb2s4YPFsdsa6XykGehw1WE55/WYzU2wr3rXx7u2ilc/kg8Yzfaqq84oa
         eVm1uGv1X6kenucMqQIGuG+rMZKufd/+ynSNx0Zaj6QUXIc53tK+K4xeNRFn6mU/dSsX
         9QdbLaAquximThuiunX/LzBljGORvJQg/dtF8dD5fi+P6swD6bNKD2BvSfJbzpfXJp7s
         aOE94war31DrAfjkfMIFEXhv5VuQ41ModpBea7xxGbTdRU7XOLshpDFpDGAxWN9wBq97
         tjvs8TdLRwjLOaA+fVvxN+9e6QQS/zWQLKoNhI6k5g6aL5zb7YhaOJ45tbB+O/843xTQ
         ACEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RZUltNxN8swjKZJxh9uDkp4MdgFsPnFWDUBfK/eqmSs=;
        b=CH+6czQ7usJDZM0v6Zbv9v6X/5Rt9bkzUAXYwmF89YNjm23V213QlQXn5/TGWSfwxe
         DD+Yrw7DSgOL7ikdJnZGU4SpF8rNmpQDsm46ohe5ANnBiA/qAKjdrkkgFGwwRZfx2mUf
         ctD25MrAC/Gmkj8GqEtPomf7nGZi5uB4xnMPzaqVO3zK+JybhkbjU+T8aDWEO+M6dmI9
         GuIMU1M/PTNckCJ3puv7blflT1Pp4FXAVTUeqIZVmR/L2nNb00txr7y7EEGf5GkpqIix
         51ZVPfwslc+FiU1l1IrSSye5hRKlSa0HbvOIu5/301ZQZwhZK8DOQeTaSDt9zCioS7Hw
         2Bdg==
X-Gm-Message-State: AOAM532n9j1/jNAMUV4GG7tF+3Kanvwqt4rgg/t13mv4G+HEV4QtCz3z
        g9ygl6ln6vD61yEg4XoucMw=
X-Google-Smtp-Source: ABdhPJyPifUyATsp8PXeSPceVsFzV7Q1lahibnJ7pCn5gDd2oX19rthzpALLV/dHaEdPz5MonJzd6w==
X-Received: by 2002:adf:ebcd:: with SMTP id v13mr3842291wrn.400.1630672095368;
        Fri, 03 Sep 2021 05:28:15 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id q13sm4039832wmj.46.2021.09.03.05.28.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 05:28:15 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-2-haoxu@linux.alibaba.com>
 <fd529494-96d4-bc91-8e0c-0adf731b9052@gmail.com>
 <302430f6-f83e-4096-448e-9d35f8f4303e@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 1/6] io_uring: enhance flush completion logic
Message-ID: <5dd28d14-24b5-e2dc-aa55-a68cb5d9f4e8@gmail.com>
Date:   Fri, 3 Sep 2021 13:27:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <302430f6-f83e-4096-448e-9d35f8f4303e@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/21 1:08 PM, Hao Xu wrote:
> 在 2021/9/3 下午7:42, Pavel Begunkov 写道:
>> On 9/3/21 12:00 PM, Hao Xu wrote:
>>> Though currently refcount of a req is always one when we flush inline
>>
>> It can be refcounted and != 1. E.g. poll requests, or consider
> It seems poll requests don't leverage comp cache, do I miss anything?

Hmm, looks so. Not great that it doesn't, but probably it's because
of trying to submit next reqs right in io_poll_task_func().

I'll be pushing for some changes around tw, with it should be easy
to hook poll completion batching with no drawbacks. Would be great
if you will be willing to take a shot on it.

>> that tw also flushes, and you may have a read that goes to apoll
>> and then get tw resubmitted from io_async_task_func(). And other
> when it goes to apoll, (say no double wait entry) ref is 1, then read
> completes inline and then the only ref is droped by flush.

Yep, but some might have double entry. It also will have elevated
refs if there was a linked timeout. Another case is io-wq, which
takes a reference, and if iowq doesn't put it for a while (e.g. got
rescheduled) but requests goes to tw (resubmit, poll, whatever)
you have the same picture.

>> cases.
>>
>>> completions, but still a chance there will be exception in the future.
>>> Enhance the flush logic to make sure we maintain compl_nr correctly.
>>
>> See below
>>
>>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>
>>> we need to either removing the if check to claim clearly that the req's
>>> refcount is 1 or adding this patch's logic.
>>>
>>>   fs/io_uring.c | 6 ++++--
>>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 2bde732a1183..c48d43207f57 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -2291,7 +2291,7 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
>>>       __must_hold(&ctx->uring_lock)
>>>   {
>>>       struct io_submit_state *state = &ctx->submit_state;
>>> -    int i, nr = state->compl_nr;
>>> +    int i, nr = state->compl_nr, remain = 0;
>>>       struct req_batch rb;
>>>         spin_lock(&ctx->completion_lock);
>>> @@ -2311,10 +2311,12 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
>>>             if (req_ref_put_and_test(req))
>>>               io_req_free_batch(&rb, req, &ctx->submit_state);
>>> +        else
>>> +            state->compl_reqs[remain++] = state->compl_reqs[i];
>>
>> Our ref is dropped, and something else holds another reference. That
>> "something else" is responsible to free the request once it put the last
>> reference. This chunk would make the following io_submit_flush_completions()
>> to underflow refcount and double free.
> True, I see. Thanks Pavel.
>>
>>>       }
>>>         io_req_free_batch_finish(ctx, &rb);
>>> -    state->compl_nr = 0;
>>> +    state->compl_nr = remain;
>>>   }
>>>     /*
>>>
>>
> 

-- 
Pavel Begunkov
