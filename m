Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFD341ABF8
	for <lists+io-uring@lfdr.de>; Tue, 28 Sep 2021 11:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239770AbhI1Jfz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Sep 2021 05:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239724AbhI1Jfy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Sep 2021 05:35:54 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C342C061575
        for <io-uring@vger.kernel.org>; Tue, 28 Sep 2021 02:34:15 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 205-20020a1c01d6000000b0030cd17ffcf8so1630469wmb.3
        for <io-uring@vger.kernel.org>; Tue, 28 Sep 2021 02:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4zRGXEPeTth90e32UQZL6clwn3EfmRqzHeY5/3q5UBk=;
        b=Ot48LADFhYsLJIHHAIhhMebHKpljWQcqZXG65DZZefxOlqYsv5oldtWX9rsUAScixW
         Vq50JzphDLAw5Fl1z06MqdhU5SGrQjCJBCDynp8p2ZyR2HUg48apSt/M/e2KZIr+Qkom
         1OKdjwgEiHuaqIApMMtadvxowIFF4beCIQOPjC4ku1qT2TmhJSoOjxPoQ7uoFAiO4T0L
         wPlqU/0UTm4KLJsxwPZ6puCX2fRxW/z9X9KLgEsTdCnsakOB9YJSrVQ0Dnhh6SWP/IEi
         r9+V8YbkXuTosRmULt6UtQ76Qx0FC1eIl6Nft8rG0c7X+9vvxrEdd/Ud18W1qdGHxAFl
         e66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4zRGXEPeTth90e32UQZL6clwn3EfmRqzHeY5/3q5UBk=;
        b=M1wv+cHNU/T4Ji8MSzeHe2INrJABRn56/WtO4OG2wgoLKOhUB8yW9Y55/9wMZwQr5L
         //v35FEJXjyZelj5RaIK3jVddQtgVqNp6RZEbU74jwHPGKqbnZxRD+75PWU5XLg1PNnD
         a4ECP3mW5FqLUMxypzM6bt7H65XmYtBy/fAdPLHxc/IPed7kPdeZN0ExwToKmCe+4Nxp
         Y5otaZQJVsEskLDh8bZzDpwSGqy73rb0X3bhoR4SXfjLYiGADxFtj05D6Wm4tknMNTuu
         racfwlPHd0q9QfZIk/zfGWmbKAuSqsRtWBGPTwlxUdUUmNdY7ijHWJY7LRahl3Lt3wnj
         bKoQ==
X-Gm-Message-State: AOAM530PlCqBOMjRlELe2pAAioLAjC4d70Bw3pWh7qbLahX+58tBbJ/S
        +kO/WV2dnGdVBSIa3wqwXpuEicU6LxE=
X-Google-Smtp-Source: ABdhPJzz4pizq1HJGMSXlveEUEKb5ZKoCs5P3H2CSf5vNWC/jcZlDxMXmezmB4s4l2bxEc+3y2SFFg==
X-Received: by 2002:a1c:4b15:: with SMTP id y21mr3601710wma.183.1632821653996;
        Tue, 28 Sep 2021 02:34:13 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.229])
        by smtp.gmail.com with ESMTPSA id 8sm2058642wmo.47.2021.09.28.02.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 02:34:13 -0700 (PDT)
Subject: Re: [PATCH v2 10/24] io_uring: add a helper for batch free
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1632516769.git.asml.silence@gmail.com>
 <4fc8306b542c6b1dd1d08e8021ef3bdb0ad15010.1632516769.git.asml.silence@gmail.com>
 <1522b987-b614-7255-8336-7dbdf6f785fa@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <61174012-a714-2102-d69f-a6d216af74de@gmail.com>
Date:   Tue, 28 Sep 2021 10:33:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1522b987-b614-7255-8336-7dbdf6f785fa@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/21 4:36 AM, Hao Xu wrote:
> 在 2021/9/25 上午4:59, Pavel Begunkov 写道:
>> Add a helper io_free_batch_list(), which takes a single linked list and
>> puts/frees all requests from it in an efficient manner. Will be reused
>> later.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   fs/io_uring.c | 34 +++++++++++++++++++++-------------
>>   1 file changed, 21 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 205127394649..ad8af05af4bc 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2308,12 +2308,31 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
>>       wq_stack_add_head(&req->comp_list, &state->free_list);
>>   }
>>   +static void io_free_batch_list(struct io_ring_ctx *ctx,
>> +                   struct io_wq_work_list *list)
>> +    __must_hold(&ctx->uring_lock)
>> +{
>> +    struct io_wq_work_node *node;
>> +    struct req_batch rb;
>> +
>> +    io_init_req_batch(&rb);
>> +    node = list->first;
>> +    do {
>> +        struct io_kiocb *req = container_of(node, struct io_kiocb,
>> +                            comp_list);
>> +
>> +        node = req->comp_list.next;
>> +        if (req_ref_put_and_test(req))
>> +            io_req_free_batch(&rb, req, &ctx->submit_state);
>> +    } while (node);
>> +    io_req_free_batch_finish(ctx, &rb);
>> +}
> Hi Pavel, Why not we use the wq_list_for_each here as well?

Because we do wq_stack_add_head() in the middle of the loop and
there is also refcounting adding potential races. We'd need
some for_each_*_safe version of it.


-- 
Pavel Begunkov
